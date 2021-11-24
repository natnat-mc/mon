->
	{
		'24h':
			value: os.date '%H:%M:%S'
			name: "System - Time - 24h"
		'12h':
			value: os.date '%I:%M:%S %p'
			name: "System - Time - 12h"
		'europe':
			value: os.date '%d/%m/%Y'
			name: "System - Date - Europe"
		'america':
			value: os.date '%m/%d/%Y'
			name: "System - Date - America"
		'iso':
			value: os.date '%Y-%m-%d'
			name: "System - Date - ISO"
	}
