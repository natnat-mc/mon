public var AMALG: 'amalg.lua'
public var RM: 'rm', '-rf', '--'
public var LUA: 'lua5.3'

var LIB_SRC: _.wildcard 'mon/**.moon'
var BIN_SRC: _.wildcard 'bin/*.moon'

var LIB_LUA: _.patsubst LIB_SRC, '%.moon', '%.lua'
var BIN_LUA: _.patsubst BIN_SRC, '%.moon', '%.lua'
var BIN: _.patsubst BIN_LUA, 'bin/%.lua', 'out/%'

var MODULES: _.foreach (_.patsubst LIB_LUA, '%.lua', '%'), => @gsub '/', '.'

with public default target 'all'
	\after 'amalg'

with public target 'install'
	\after 'install-bin'

with public target 'install-bin'
	\depends BIN
	\produces _.patsubst BIN, 'out/%', '/usr/local/bin/%'
	\fn => _.cmd 'sudo', 'cp', @infile, @out
	\sync!

with public target 'userinstall'
	\after 'userinstall-bin'

with public target 'userinstall-bin'
	\depends BIN
	\produces _.patsubst BIN, 'out/%', "#{os.getenv 'HOME'}/.local/bin/%"
	\fn => _.cmd 'cp', @infile, @out
	\sync!

with public target 'clean'
	\fn => _.cmd RM, LIB_LUA
	\fn => _.cmd RM, BIN_LUA

with public target 'mrproper'
	\after 'clean'
	\fn => _.cmd RM, 'out'

with public target LIB_LUA, pattern: '%.lua'
	\depends '%.moon'
	\produces '%.lua'
	\fn => _.moonc @infile, @outfile

with public target 'compile-lib'
	\depends LIB_LUA

with public target BIN_LUA, pattern: '%.lua'
	\depends '%.moon'
	\produces '%.lua'
	\fn => _.moonc @infile, @outfile

with public target 'compile-bin'
	\depends BIN_LUA

with public target BIN, pattern: 'out/%'
	\depends 'bin/%.lua'
	\depends LIB_LUA
	\produces 'out/%'
	\mkdirs!
	\fn => _.cmd AMALG, '-o', @outfile, '-s', @infile, MODULES
	\fn => _.writefile @outfile, "#!/usr/bin/env #{LUA}\n#{_.readfile @outfile}"
	\fn => _.cmd 'chmod', '+x', @outfile

with public target 'amalg'
	\depends BIN
