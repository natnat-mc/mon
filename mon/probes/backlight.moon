import readnumber from require 'mon.util'

(args={}) ->
	import name from args
	-- TODO: fill in name if nil
	{
		"backlight:#{name}:level":
			value: ->
				curr = readnumber "/sys/class/backlight/#{name}/brightness"
				max = readnumber "/sys/class/backlight/#{name}/max_brightness"
				math.floor curr/max*100 + .5
			name: "Backlight - #{name} - Level"
			min: 0
			max: 100
			unit: '%'
	}
