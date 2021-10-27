import readprocline from require 'mon.util'

->
	output = {}

	for x in *({'a', 'r', 'v', 'o', 's', 'm'})
		output["uname:#{x}"] =
			value: -> readprocline "uname -#{x}"

	output['uname:a'].name = "System - Kernel"
	output['uname:r'].name = "System - Kernel - Release"
	output['uname:v'].name = "System - Kernel - Version"
	output['uname:o'].name = "System - Kernel - OS"
	output['uname:s'].name = "System - Kernel - Name"
	output['uname:m'].name = "System - Kernel - Platform"

	output
