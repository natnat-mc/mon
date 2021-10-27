import readproc from require 'mon.util'

->
	data = readproc 'lsb_release -a'

	{
		'lsbrelease:distributor':
			value: string.match data, 'ID:%s+([^\n]+)'
			name: "OS - Distributor"
		'lsbrelease:desc':
			value: string.match data, 'Description:%s+([^\n]+)'
			name: "OS - Distribution"
		'lsbrelease:release':
			value: string.match data, 'Release:%s+([^\n]+)'
			name: "OS - Distribution - Release"
		'lsbrelease:codename':
			value: string.match data, 'Codename:%s+([^\n]+)'
			name: "OS - Distribution - Codename"
	}
