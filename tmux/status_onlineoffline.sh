#!/bin/bash
# colourize tmux status bar red when there is no connection to "the internet"

# dummy echo to prevent flashing status bar while waiting for the first ping
echo

# switch for mac
uname | grep -q Darwin && w=1000 || w=1

# tmux colouring
function tmux_ok {
    tmux set status-style fg=black,bg=colour46
    echo 'OK' >&2
    exit 0
}

function tmux_warn {
    tmux set status-style fg=black,bg=yellow
    exit 0
}

function tmux_err {
    tmux set status-style fg=black,bg=red
    exit 0
}

# checks
function check_ping {
    ping -W $w -qc1 www.admin.ch > /dev/null || { echo 'ERROR ping' >&2; return 1; }
}

function check_ns {
    grep -q '^nameserver' /etc/resolv.conf || { echo 'ERROR nameserver' >&2; return 1; }
}

function check_dns {
    timeout 3 host -t A -R5 -W3 www.admin.ch >&2 || { echo 'ERROR dns (timeout/refused/other)' >&2; return 1; }
}

# check dns
check_ns || tmux_warn
check_dns || tmux_err

# check ping (implies dns)
check_ping && tmux_ok || tmux_err
