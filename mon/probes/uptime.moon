import readproc from require 'mon.util'

->
	uptime, load1, load5, load15 = string.match (readproc 'uptime'), 'up%s*([^,]+),.+:%s*([0-9.]+),%s*([0-9.]+),%s([0-9.]+)'
	load1, load5, load15 = (tonumber load1), (tonumber load5), (tonumber load15)

	{
		uptime:
			value: uptime
			name: "System - Uptime"
		load1:
			value: load1
			name: "System - Load - 1 min"
		load5:
			value: load5
			name: "System - Load - 5 min"
		load15:
			value: load15
			name: "System - Load - 15 min"
	}
