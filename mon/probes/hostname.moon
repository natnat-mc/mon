import readprocline from require 'mon.util'

->
	hostname:
		value: -> readprocline 'hostname'
		name: "System - Hostname"
