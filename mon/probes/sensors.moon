import readproc from require 'mon.util'
import decode from require 'mon.json'
import match from string

->
	data = decode readproc 'sensors -j'
	result = {}

	for category, data in pairs data
		for sensor, data in pairs data
			continue if (type data) == 'string'

			current =
				value: nil
				name: "Sensors - #{category} - #{sensor}"
				min: nil
				max: nil
				unit: nil
				low: {}
				high: {}

			for k, v in pairs data
				if match k, '^temp'
					current.unit = '°C'
				elseif match k, '^curr'
					current.unit = 'A'
				elseif match k, '^in'
					current.unit = 'V'
				elseif match k, '^fan'
					current.unit = 'RPM'

				if match k, '_max$'
					current.high[1] = v
				elseif match k, '_crit$'
					current.high[2] = v
				elseif match k, '_emergency$'
					current.high[3] = v
				elseif match k, '_min$'
					current.low[1] = v
				elseif match k, '_input$'
					current.value = v
					result["#{category}:#{sensor}"] = current

			current.low = nil unless next current.low
			current.high = nil unless next current.high

	result
