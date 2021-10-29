readfile = (file, part='*a') ->
	file = assert io.open file, 'r' if (type file) == 'string'
	data = file\read part
	file\close!
	data

readline = (file) -> readfile file, '*l'
readnumber = (file) -> tonumber readline file

readproc = (proc, part='*a') ->
	readfile (io.popen "#{proc} 2>/dev/null", 'r'), part

readprocline = (proc) -> readproc proc, '*l'
readprocnumber = (proc) -> tonumber readprocline proc

exists = (file) ->
	if fd = io.open file, 'rb'
		fd\close!
		true
	else
		false

sleep = (duration) ->
	assert os.execute "sleep #{duration}"

{
	:readfile, :readline, :readnumber
	:readproc, :readprocline, :readprocnumber
	:exists
	:sleep
}
