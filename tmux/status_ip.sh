#!/bin/bash
# get the default outgoing IP and display it for tmux status bar

# no matter which locale, display it with C
export LC_ALL=C

# get the ip of the default gateway
uname | grep -q Darwin \
    && outgoing_ip="$(netstat -rn | grep -e default | awk '{print $NF}' | xargs -n1 ifconfig | grep inet | head -n1 | sed 's/addr://' | awk '{print $2}')" \
    || outgoing_ip="$(netstat -rn | grep "^0.0.0.0" | awk '{print $NF}' | xargs -n1 ifconfig | grep inet | head -n1 | grep -Eo "inet ([0-9]{1,3}.){3}[0-9]{1,3}" | awk '{print $NF}')"

# print it centered and nicely
printf '%6s%-7s\n' $(echo $outgoing_ip | cut -c 1-$((${#outgoing_ip}/2))) $(echo $outgoing_ip | cut -c $((${#outgoing_ip}/2+1))-${#outgoing_ip})
