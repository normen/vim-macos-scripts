# vim-macos-scripts
Applescript files to create Automator actions invoking VIM in Terminal.app

## What is this?
These Applescript files can be used with the Shortcuts or Automator application on MacOSX. They allow you to create Quick Actions to edit text files or text snippets in the VIM command-line editor.

![edit-in-vim-example](/doc/edit-in-vim.gif?raw=true "Edit in VIM")

## How to use (Shortcuts)
Installation should work similar to below. Add a script action.

#### edit-text-in-vim
- Create a new Shortcut
- Add an AppleScript Action
- Copy-Paste the text of `edit-text-in-vim.applescript` to the Applescript action
- Add a "Stop and Return script result" Action

#### open-file-in-vim
- Create a new Shortcut
- Add an AppleScript Action
- Copy-Paste the text of `open-file-in-vim.applescript` to the Applescript action

## How to use (Automator)
#### Prepare Terminal.app
- Open Terminal.app
- Press `Command-,` to open its settings
- Under "Profile" add a new profile called `vim` using the `+`button.
  - This profile will be used when a new VIM window is opened, adapt it to your liking
- Under "Profile"->"Shell" set "When the shell exits" to "Close window"

#### edit-text-in-vim
- Open Automator
- Create a new "Contextual Workflow" (Quick Action)
- In the top bar
  - Allow the action to receive Plain Text
  - Set an fitting icon
  - Set the "replaces selected text" checkbox
- Add an Applescript action to the flow (search "Applescript" in the search bar)
- Copy-Paste the text of `edit-text-in-vim.applescript` to the Applescript action
- Save the Automator action as "Edit in VIM"

Now the action will automatically appear when you right-click selected text. Edit the text in VIM, save it, quit VIM and the text will automatically be pasted back to the original application.

_Hint: In the MacOS settings under "Keyboard" you can assign a keyboard shortcut to this action._

#### open-file-in-vim
- Open Automator
- Create a new "Contextual Workflow" (Quick Action)
- In the top bar
  - Allow the action to receive Files and Folders
  - Set an fitting icon
- Add an Applescript action to the flow (search "Applescript" in the search bar)
- Copy-Paste the text of `open-file-in-vim.applescript` to the Applescript action
- Save the Automator action as "Open in VIM"

Now the action will automatically appear in Finder when you select or right-click a file. Execute it to edit the file directly in VIM. The parent folder of the file will be set as working directory. If multiple files are selected they will open in VIM tabs. If a single `.vim` file is opened VIM will be started with the `-S` parameter to open the file as a session file.

#### open-file-in-vim as Application
You can also use `open-file-in-vim.applescript` to create an Automator "Application" instead of a "Quick Action".

- Open Automator
- Create a new "Application"
- Add an Applescript action to the flow (search "Applescript" in the search bar)
- Copy-Paste the text of `open-file-in-vim.applescript` to the Applescript action
- Save the Application as "VIM" in either /Applications or /User/name/Applications

You can set the application to always open files of a specific type through their Finder information panel. You can also use it to open a new instance of VIM without opening a file.

#### Bonus: current file in Terminal top bar
As a bonus, you can see the currently edited file in the top bar of Terminal if you add this to your `.vimrc`:

```
set t_ts=^[]6;
set t_fs=^G
set title
set titlestring=%{\"file://\".hostname().expand(\"%:p\")}
```

- To get the `^[` character press `Ctrl-v` then `Esc` when in insert mode.
- To get the `^G` character, press `Ctrl-v` then `Ctrl-G` when in insert mode.

The rest are "normal" characters.

_Hint: If the above doesn't work for you try changing the last line to_

`auto BufEnter * let &titlestring = "file://" . substitute(hostname().expand("%:p"), " ", "+", "")`

## Alternative for tmux
If you are using tmux and its running anyway you might be interested in these shell scripts to use instead of the AppleScripts:

#### edit-text-in-vim
- Add a Script action
- Set the script:
```
TMPFILE=$(mktemp)
cat>$TMPFILE
osascript -e 'tell application "Terminal" to activate'
tmux new-window "vim '$TMPFILE';tmux wait-for -S edit_return"
tmux wait edit_return
cat $TMPFILE
```
- Set "Input as stdin"
- Add a "Stop and return script value"

#### open-file-in-vim
- Add a Script action
- Set the script:
```
osascript -e 'tell application "Terminal" to activate'
FOLDER=$(dirname $1)
tmux new-window "cd $FOLDER; vim '$1'"
```
- Set "Input as arguments"
