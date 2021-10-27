import readproc from require 'mon.util'

->
	data = readproc 'free -hw'
	result = {}

	add = (name, tab) ->
		for k, v in pairs tab
			result["#{name}:#{k}"] =
				value: tonumber string.match v, '[0-9.]+'
				unit: string.gsub (string.match v, '[a-zA-Z]+'), 'i', ''

	total, used, free, shared, buffers, cache, available = string.match data, 'Mem:%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)'
	add 'mem', :total, :used, :free, :shared, :buffers, :cache, :available
	total, used, free = string.match data, 'Swap:%s+(%S+)%s+(%S+)%s+(%S+)'
	add 'swap', :total, :used, :free

	result['mem:total'].name = "RAM - Total"
	result['mem:free'].name = "RAM - Free"
	result['mem:available'].name = "RAM - Available"
	result['mem:used'].name = "RAM - Used (user)"
	result['mem:buffers'].name = "RAM - Used (buffers)"
	result['mem:cache'].name = "RAM - Used (cache)"
	result['mem:shared'].name = "RAM - Used (shared)"

	result['swap:total'].name = "Swap - Total"
	result['swap:free'].name = "Swap - Free"
	result['swap:used'].name = "Swap - Used"

	result
