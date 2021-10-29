import readline, readnumber from require 'mon.util'

(args) ->
	import bat, adp from args
	-- TODO: fill in name if nil
	{
		level:
			value: -> readnumber "/sys/class/power_supply/#{bat}/capacity"
			name: "Battery - #{bat} - Level"
			low: {30, 15, 5}
			min: 0
			max: 100
			unit: '%'
		status:
			value: -> string.lower readline "/sys/class/power_supply/#{bat}/status"
			name: "Battery - #{bat} - Status"
			levels:
				discharging: 2
				unknown: 1
		charger:
			value: ->
				status = readnumber "/sys/class/power_supply/#{adp}/online"
				if status == 1
					'plugged'
				else
					'unplugged'
			name: "Charger - #{adp} - Status"
			levels:
				unplugged: 2
	}
