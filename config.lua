local function display(data)
	local display = {}
	local function add(name)
		table.insert(display, data[name])
		data[name] = nil
	end
	local function addall(pattern)
		local names = {}
		for k, v in pairs(data) do
			if k:match(pattern) then
				table.insert(names, k)
			end
		end
		table.sort(names)
		for _, v in ipairs(names) do
			add(v)
		end
	end
	local function ignore(name)
		data[name] = nil
	end
	local function ignoreall(pattern)
		local names = {}
		for k, v in pairs(data) do
			if k:match(pattern) then
				ignore(k)
			end
		end
	end
	local function write(text)
		table.insert(display, text)
	end

	add 'hostname:hostname'
	add 'uname:v'
	add 'lsbrelease:desc'
	add 'mon:value'
	ignoreall '^lsbrelease:'
	ignoreall '^uname:'
	write ''

	add 'datetime:iso'
	add 'datetime:24h'
	ignoreall '^datetime:'
	write ''

	add 'battery:level'
	add 'battery:status'
	add 'battery:charger'
	add 'backlight:level'
	addall '^sensors:BAT1%-acpi%-0:'
	write ''

	add 'memory:ram:used'
	add 'memory:ram:free'
	add 'memory:ram:available'
	add 'memorypct:ram:used'
	add 'memorypct:ram:free'
	add 'memorypct:ram:available'
	ignoreall '^mem:'
	ignoreall '^swap:'
	write ''

	addall '^uptime:'
	write ''

	addall '^hostname:ipv4:'
	addall '^hostname:ipv6:'
	write ''

	ignoreall '^sensors:coretemp%-isa%-0000:Core'
	ignore 'sensors:nvme-pci-0200:Sensor 1'
	addall ''

	return display
end

local namemap = setmetatable({
	['battery:level'] = "Battery - Level",
	['battery:status'] = "Battery - Status",
	['battery:charger'] = "Charger - Status",
	['backlight:level'] = "Backlight - Level",
	['sensors:BAT1-acpi-0:curr1'] = "Sensors - Battery - Current",
	['sensors:BAT1-acpi-0:in0'] = "Sensors - Battery - Voltage",
	['sensors:acpitz-acpi-0:temp1'] = "Sensors - Motherboard - Temp",
	['sensors:coretemp-isa-0000:Package id 0'] = "Sensors - CPU - Package - Temp",
	['sensors:iwlwifi_1-virtual-0:temp1'] = "Sensors - WiFi chip - Temp",
	['sensors:nvme-pci-0200:Composite'] = "Sensors - NVMe - Temp",
	['sensors:pch_cometlake-virtual-0:temp1'] = "Sensors - CPU - PCH - Temp",
}, {
	__index = function(_, name)

	end
})

local probes = {
	{name='mon.probes.backlight', args={name='intel_backlight'}},
	{name='mon.probes.battery', args={bat='BAT1', adp='ADP1'}},
	{name='mon.probes.datetime'},
	{name='mon.probes.hostname'},
	{name='mon.probes.lsbrelease'},
	{name='mon.probes.memory'},
	{name='mon.probes.memorypct'},
	{name='mon.probes.sensors'},
	{name='mon.probes.uname'},
	{name='mon.probes.uptime'},
	{
		name='mon.probes.adhoc',
		args={
			name="System monitor - Name",
			value=function() return 'mon' end
		},
		prefix='mon'
	}
}

return {
	display=display,
	namemap=namemap,
	probes=probes,
}
