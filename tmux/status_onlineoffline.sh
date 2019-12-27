#!/bin/bash
# colourize tmux status bar red when there is no connection to "the internet"

# dummy echo to prevent flashing status bar while waiting for the first ping
echo

# switch for mac
uname | grep -q Darwin && w=1000 || w=1

# tmux colouring
function tmux_ok {
    tmux set status-style fg=black,bg=colour46
    # echo 'online' > /tmp/tmux_onlineoffline
    exit 0
}

function tmux_warn {
    tmux set status-style fg=black,bg=yellow
    # echo 'onoff_warn' > /tmp/tmux_onlineoffline
    exit 0
}

function tmux_err {
    tmux set status-style fg=black,bg=red
    # echo 'offline' > /tmp/tmux_onlineoffline
    exit 0
}

# checks
function check_ping {
    ping -W $w -qc1 www.example.org > /dev/null || return 1
}

function check_ns {
    grep -q '^inameserver' /etc/resolv.conf || return 1
}

function check_dns {
    timeout 1 host -t A -R1 -W1 www.example.org > /dev/null || return 1
}

# check dns
check_ns || tmux_warn
check_dns || tmux_err

# check ping (implies dns)
check_ping && tmux_ok || tmux_err
