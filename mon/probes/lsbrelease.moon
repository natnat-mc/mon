import readproc from require 'mon.util'

->
	data = readproc 'lsb_release -a'

	{
		distributor:
			value: string.match data, 'ID:%s+([^\n]+)'
			name: "OS - Distributor"
		desc:
			value: string.match data, 'Description:%s+([^\n]+)'
			name: "OS - Distribution"
		release:
			value: string.match data, 'Release:%s+([^\n]+)'
			name: "OS - Distribution - Release"
		codename:
			value: string.match data, 'Codename:%s+([^\n]+)'
			name: "OS - Distribution - Codename"
	}
