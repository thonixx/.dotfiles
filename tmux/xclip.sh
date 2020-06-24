#!/bin/bash

# has to be in a script as otherwise tmux freezes as long as xclip is running
exec > /dev/null # without that xclip will block tmux
tmux show-buffer | xclip -i
