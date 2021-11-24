import readproc from require 'mon.util'

() ->
	output = {}
	v4, v6 = 0, 0
	for address in string.gmatch (readproc 'hostname -I'), '%S+'
		if string.match address, '%.'
			output["ipv4:addr#{v4}"] =
				value: address
				name: "Network - IPv4 - Address #{v4}"
			v4 += 1
		else
			output["ipv6:addr#{v6}"] =
				value: address
				name: "Network - IPv6 - Address #{v6}"
			v6 += 1
	output
