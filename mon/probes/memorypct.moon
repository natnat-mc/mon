import readproc from require 'mon.util'

->
	data = readproc 'free -bw'

	memtotal, memused, memfree, _, _, _, memavailable = string.match data, 'Mem:%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)'
	memtotal, memused, memfree, memavailable = (tonumber memtotal), (tonumber memused), (tonumber memfree), (tonumber memavailable)

	swaptotal, swapused, swapfree = string.match data, 'Swap:%s+(%S+)%s+(%S+)%s+(%S+)'
	swaptotal, swapused, swapfree = (tonumber swaptotal), (tonumber swapused), (tonumber swapfree)

	result =
		'ram:used':
			value: memused/memtotal
			name: "RAM - % Used"
			high: {50, 75, 90}
		'ram:free':
			value: memfree/memtotal
			name: "RAM - % Free"
			low: {25, 10, 5}
		'ram:available':
			value: memavailable/memtotal
			name: "RAM - % Available"
			low: {50, 25, 10}
		'swap:used':
			value: swapused/swaptotal
			name: "Swap - % Used"
			high: {50, 75, 90}
		'swap:free':
			value: swapfree/swaptotal
			name: "Swap - % Free"
			low: {50, 25, 10}

	if swaptotal == 0
		result['swap:used'] = nil
		result['swap:free'] = nil

	for k, v in pairs result
		v.value *= 100
		v.min = 0
		v.max = 100
		v.unit = '%'

	result
