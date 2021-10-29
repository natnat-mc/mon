import readproc from require 'mon.util'

->
	data = readproc 'free -hw'
	result = {}

	add = (name, tab) ->
		for k, v in pairs tab
			result["#{name}:#{k}"] =
				value: tonumber string.match v, '[0-9.]+'
				unit: string.gsub (string.match v, '[a-zA-Z]+'), 'i', ''
				min: 0

	total, used, free, shared, buffers, cache, available = string.match data, 'Mem:%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)'
	add 'ram', :total, :used, :free, :shared, :buffers, :cache, :available
	total, used, free = string.match data, 'Swap:%s+(%S+)%s+(%S+)%s+(%S+)'
	add 'swap', :total, :used, :free

	result['ram:total'].name = "RAM - Total"
	result['ram:free'].name = "RAM - Free"
	result['ram:available'].name = "RAM - Available"
	result['ram:used'].name = "RAM - Used (user)"
	result['ram:buffers'].name = "RAM - Used (buffers)"
	result['ram:cache'].name = "RAM - Used (cache)"
	result['ram:shared'].name = "RAM - Used (shared)"

	result['swap:total'].name = "Swap - Total"
	result['swap:free'].name = "Swap - Free"
	result['swap:used'].name = "Swap - Used"

	result
