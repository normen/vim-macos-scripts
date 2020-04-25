-- opens VIM with temp file created from input, returns changed file contents
-- Released under MIT license by Normen Hansen

on run {input, parameters}
	-- create temp file with contents
	-- "/tmp/" should be: (POSIX path of (path to temporary items folder from user domain))
	-- but that doesn't work, vim has no access
	-- maybe Terminal.app has no access to that folder
	set posixtmpfile to "/tmp/" & "vim_" & text 3 thru -1 of ((random number) as string)
	try
		set fhandle to open for access posixtmpfile with write permission
		write input to fhandle as «class utf8»
		close access fhandle
	on error
		try
			close access posixtmpfile
		end try
	end try
	
	set command to {"vim "}
	set end of command to (posixtmpfile as string)
	set end of command to ";exit"
	-- compile command
	set command to command as string
	set myTab to null
	tell application "Terminal"
		-- check if Terminal is already running
		if it is not running then
			set myTab to (do script command in window 1)
		else
			set myTab to (do script command)
		end if
		-- get our own window
		set myWindow to first window of (every window whose tabs contains myTab)
		-- set Terminal.app window settings and window size and get to foreground
		set current settings of myWindow to settings set "vim"
		set size of myWindow to {910, 800}
		activate
		-- wait for command to finish
		try
			repeat while (exists myWindow) and (myTab is busy)
				delay 0.1
			end repeat
		end try
	end tell
	-- read file contents and return
	set myString to (read posixtmpfile)
	-- delete file posixtmpfile
	do shell script "/bin/rm " & quoted form of posixtmpfile
	return myString
end run
