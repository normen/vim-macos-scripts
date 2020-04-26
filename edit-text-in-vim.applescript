-- opens VIM with temp file created from input, returns changed file contents
-- Released under MIT license by Normen Hansen

on run {input, parameters}
	-- Save calling application name to bring it back to front
	-- (disabled for now as bringing back to front doesn't work)
	--tell application "System Events"
	--	set originalAppName to name of first process whose frontmost is true
	--end tell
	
	-- Create temp file with text content for VIM to open.
	-- We're using "/tmp/" but it should be:
	-- (POSIX path of (path to temporary items folder from user domain))
	-- That doesn't work though, vim has no access to files there.
	-- Maybe Terminal.app has no access to that folder.
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
	set myString to (read posixtmpfile as «class utf8»)
	-- delete file posixtmpfile
	do shell script "/bin/rm " & quoted form of posixtmpfile
	-- TODO: bring original app to front again 
	-- Can't do it directly as the app is blocked by calling this applescript.
	-- Doing "tell application originalAppName to activate" causes a deadlock.
	-- Calling osascript as a background process doesn't work either.
	-- I guess it would be in order if Apple added that behavior
	-- automatically when selecting "replace text".
	return myString
end run
