import readprocline from require 'mon.util'

->
	output = {}

	for x in *({'a', 'r', 'v', 'o', 's', 'm'})
		output[x] =
			value: -> readprocline "uname -#{x}"

	output.a.name = "System - Kernel"
	output.r.name = "System - Kernel - Release"
	output.v.name = "System - Kernel - Version"
	output.o.name = "System - Kernel - OS"
	output.s.name = "System - Kernel - Name"
	output.m.name = "System - Kernel - Platform"

	output
