import readprocline from require 'mon.util'

->
	-- TODO: this can be done with native lua functions...
	{
		'24h':
			value: -> readprocline 'date +%H:%M:%S'
			name: "System - Time - 24h"
		'12h':
			value: -> readprocline 'date +"%I:%M:%S %p"'
			name: "System - Time - 12h"
		'europe':
			value: -> readprocline 'date +%d/%m/%Y'
			name: "System - Date - Europe"
		'america':
			value: -> readprocline 'date +%m/%d/%Y'
			name: "System - Date - America"
		'iso':
			value: -> readprocline 'date +%Y-%m-%d'
			name: "System - Date - ISO"
	}
