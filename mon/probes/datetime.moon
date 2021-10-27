import readprocline from require 'mon.util'

->
	-- TODO: this can be done with native lua functions...
	{
		'datetime:24h':
			value: -> readprocline 'date +%H:%M:%S'
			name: "System - Time - 24h"
		'datetime:12h':
			value: -> readprocline 'date +"%I:%M:%S %p"'
			name: "System - Time - 12h"
		'datetime:europe':
			value: -> readprocline 'date +%d/%m/%Y'
			name: "System - Date - Europe"
		'datetime:america':
			value: -> readprocline 'date +%m/%d/%Y'
			name: "System - Date - America"
		'datetime:iso':
			value: -> readprocline 'date +%Y-%m-%d'
			name: "System - Date - ISO"
	}
