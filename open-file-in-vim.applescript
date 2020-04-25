-- opens VIM with file, file list, .vim session file or standalone
-- sets current folder to parent folder of first file
-- Released under MIT license by Normen Hansen

on run {input, parameters}
	set command to {}
	-- check if theres input files at all
	if input is null or input is {} or ((item 1 in input) as string) is "" then
		-- no files, open vim without parameters
		set end of command to "vim;exit"
	else
		set firstFile to (item 1 in input) as string
		-- get parent folder thru finder, TODO: if folder is given use that
		tell application "Finder" to set pathFolderParent to quoted form of (POSIX path of ((folder of item firstFile) as string))
		set end of command to "cd "
		set end of command to (pathFolderParent as string)
		set end of command to ";vim"
		-- support .vim session files
		if firstFile ends with ".vim" then
			set end of command to " -S "
		else
			-- use tabs
			set end of command to " -p "
			--set end of command to " "
		end if
		-- compile all file paths
		set fileList to {}
		repeat with i from 1 to count input
			set end of fileList to quoted form of (POSIX path of (item i of input as string)) & space
		end repeat
		set end of command to (fileList as string)
		set end of command to ";exit"
	end if
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
	end tell
	return input
end run
