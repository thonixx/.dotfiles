#!/bin/bash
# colourize tmux status bar red when there is no connection to "the internet"

# dummy echo to prevent flashing status bar while waiting for the first ping
echo

# switch for mac
uname | grep -q Darwin && w=1000 || w=1

# ping it
ping -W $w -qc1 8.8.8.8 > /dev/null && tmux set status-style fg=black,bg=colour46 || tmux set status-style fg=white,bg=red
