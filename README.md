# vim-macos-scripts
Applescript files to create Automator actions invoking VIM in Terminal.app

## What is this?
These Applescript files can be used with the Automator application on MacOSX. They allow you to create Quick Actions to edit text files or text snippets in the VIM command-line editor.

![edit-in-vim-example](/doc/edit-in-vim.gif?raw=true "Edit in VIM")

## How to use
#### Prepare Terminal.app
- Open Terminal.app
- Press `Command-,` to open its settings
- Under "Profile" add a new profile called `vim` using the `+`button.
  - This profile will be used when a new VIM window is opened, adapt it to your liking
- Under "Profile"->"Shell" set "When the shell exits" to "Close window"

#### edit-text-in-vim
- Open Automator
- Create a new "Quick Action"
- Allow the action to receive Plain Text
- Add an Applescript action to the flow
- Copy-Paste the text of `edit-text-in-vim.applescript` to the Applescript Object
- Save the Automator action as "Edit in VIM"

Now the action will automatically appear when you right-click selected text. Edit the text in VIM, save it, quit VIM and the text will be pasted automatically back to the original application.

#### open-file-in-vim
- Open Automator
- Create a new "Quick Action"
- Allow the action to receive files and folders
- Add an Applescript action to the flow
- Copy-Paste the text of `edit-text-in-vim.applescript` to the Applescript Object
- Save the Automator action as "Open in VIM"

Now the action will automatically appear in Finder when you select or right-click a file. Execute it to edit the file directly in VIM. The parent folder of the file will be set as working directory. If multiple files are selected they will open in VIM tabs.

You can also use `open-file-in-vim.applescript` to create an Automator "Application" instead of a "Quick Action". The resulting Application can open files directly in VIM when double-clicking them in Finder.
