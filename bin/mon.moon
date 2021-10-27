#!/usr/bin/env moon

import encode from require 'mon.json'
import readfile, exists, merge, sleep from require 'mon.util'
Writer = require 'mon.writer'

-- parse args
args =
	loop: true
	json: false
	color: true
	delay: 1
	reload: false

do -- handle environment
	args.color = false if os.getenv 'NOCOLOR'

do -- default config file
	config_dir = os.getenv "XDG_CONFIG_HOME"
	config_dir = "#{os.getenv "HOME"}/.config" unless config_dir
	args.config = "#{config_dir}/mon.lua"

do -- parse CLI args
	i, len = 1, #arg
	while i <= len
		a = arg[i]
		switch a
			when '-h', '--help'
				io.write "#{arg[0]} [-1] [-j] [-c|-C] [-f FILE] [-r] [-d DELAY]\n"
				io.write "\t-1 Disable loop\n"
				io.write "\t-j JSON output\n"
				io.write "\t-c Color output (default unless $NO_COLOR is set)\n"
				io.write "\t-C Disable color output\n"
				io.write "\t-f Set config file (defaults to $XDG_CONFIG_HOME/mon.lua or $HOME/.config/mon.lua)\n"
				io.write "\t-r Reload config file each display\n"
				io.write "\t-d Set delay between two displays (defaults to 1; must be understood by the `sleep` command)\n"
				return 0
			when '-1'
				args.loop = false
			when '-j'
				args.json = true
				args.loop = false
			when '-c'
				args.color = true
			when '-C'
				args.color = false
			when '-f'
				args.config = assert arg[i+1], "Missing argument to -f"
				assert (exists args.config), "Config file not found: #{args.file}"
				i += 1
			when '-r'
				args.reload = true
			when '-d'
				args.delay = assert arg[i+1], "Missing argument to -d"
				i += 1
			else
				error "Unrecognized argument #{a}"
		i += 1

-- load config
local config
loadconfig = ->
	code = if exists args.config
		readfile args.config
	else
		"return {}"
	fn = assert (loadstring or load) code
	config = fn! or {}

	config.namemap or= {}
	config.display or= (x) -> [v for k, v in pairs x]
	config.probes or= {
		-- {name: 'mon.probes.backlight'} -- can't determine `name` automatically yet
		-- {name: 'mon.probes.battery'} -- can't determine `bat` and `adp` automatically yet
		{name: 'mon.probes.datetime'}
		{name: 'mon.probes.hostname'}
		{name: 'mon.probes.lsbrelease'}
		{name: 'mon.probes.memory'}
		{name: 'mon.probes.memorypct'}
		{name: 'mon.probes.sensors'}
		{name: 'mon.probes.uname'}
		{name: 'mon.probes.uptime'}
	}

-- probe function
probe = ->
	data = {}
	for probe in *config.probes
		fn = require probe.name
		table.insert data, fn probe.args
	data = merge data

	for rawname, data in pairs data
		data.name = rawname unless data.name
		data.rawname = rawname

	data

-- process function
process = (data) ->
	-- expand functions
	for k, v in pairs data
		continue if (type v) != 'table'
		v.value = v\value k if (type v.value) == 'function'

	-- expand levels
	for k, data in pairs data
		continue if (type data) != 'table'
		import value, low, high, levels from data

		level = nil
		for i=1, 3
			level = i if low and low[i] and value <= low[i]
			level = i if high and high[i] and value >= high[i]
		level = levels[value] if levels and levels[value]
		level = 0 if ((levels and next levels) or (high and next high) or (low and next low)) and not level
		data.level = level

	data

-- json export function
tojson = (data) ->
	-- rename data
	for k, data in pairs data
		continue if (type data) != 'table'
		name = config.namemap[data.rawname]
		data.name = name if name

	-- process data
	data = process data

	-- encode
	encode data

-- display function
display = (data) ->
	writer = Writer!

	-- formatting utils
	fmt = (val) ->
		return val if (type val) == 'string'
		return string.format '%d', val if (math.type val) == 'integer'
		string.format '%.2f', val

	clr = (fmt) ->
		if args.color
			writer (string.char 0x1b), '[', fmt

	-- display order
	data = config.display data

	-- rename data
	for data in *data
		continue if (type data) != 'table'
		name = config.namemap[data.rawname]
		data.name = name if name

	-- process data
	data = process data

	-- compute line lengths
	namelen, vallen = 0, 0
	for data in *data
		continue if (type data) != 'table'
		import name, value from data
		fmtvalue = fmt value
		namelen = #name if #name > namelen
		vallen = #fmtvalue if (type value) == 'number' and #fmtvalue > vallen

	for data in *data
		if (type data) != 'table'
			writer data
		else
			import name, value, level from data
			fmtvalue = fmt value

			clr '1m'
			writer name
			clr '0m'
			writer string.rep ' ', namelen - #name + 2
			writer string.rep ' ', vallen - #fmtvalue if (type value) == 'number'
			switch level
				when 0
					clr '32m'
				when 1
					clr '33m'
				when 2
					clr '31m'
				when 3
					clr '31m'
					clr '1m'
					clr '7m'
			writer fmtvalue
			clr '0m'

			if data.unit
				writer ' '
				clr '1m'
				writer data.unit
				clr '0m'

		writer '\n'

	tostring writer

-- do the stuff
loadconfig!
if args.loop
	while true
		writer = Writer!
		writer (string.char 0x1b), '[2J', (string.char '0x1b'), '[0;0H', display probe!
		print writer
		sleep args.delay
		loadconfig! if args.reload
else
	data = probe!
	if args.json
		print tojson data
	else
		print display data
