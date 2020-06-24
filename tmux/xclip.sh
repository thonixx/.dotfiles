#!/bin/bash

# has to be in a script as otherwise tmux freezes as long as xclip is running
exec > /dev/null # without that xclip will block tmux
tmux show-buffer | xclip -i

# tell me about the status
test $? -eq 0 && tmux display-message 'Copied to xclipboard!' || tmux display-message "Error ($?) while copying tmux buffer to xclip!"
