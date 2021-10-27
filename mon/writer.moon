class Writer
	new: =>
		@n = 1
	__call: (...) =>
		for i=1, select '#', ...
			data = select i, ...
			@[@n] = tostring data
			@n += 1
	__tostring: =>
		table.concat @, '', 1, @n-1
