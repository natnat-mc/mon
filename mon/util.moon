lfs = do
	ok, val = pcall -> require 'lfs'
	if ok
		val
	else
		nil

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

ls = if lfs
	(dir) ->
		[f for f in lfs.dir dir when f != '.' and f != '..']
else
	(dir) ->
		str = readproc "find '#{dir}' -maxdepth 1 -mindepth 1 -print0"
		prefix = #dir + 2
		[string.sub f, prefix, -2 for f in string.gmatch str, '.-\0']

sleep = (duration) ->
	assert os.execute "sleep #{duration}"

{
	:readfile, :readline, :readnumber
	:readproc, :readprocline, :readprocnumber
	:exists
	:ls
	:sleep
}
