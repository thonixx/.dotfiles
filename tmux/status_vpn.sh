#!/bin/bash
# check if vpn is running or not

# no matter which locale, display it with C
export LC_ALL=C

# get status of vpn
test -f "$(which openfortivpn)" || exit 0

pgrep -qa openfortivpn && ifconfig ppp0 | grep -Eo "inet [^ ]*" | awk '{print $NF}' | xargs ping -c1 -W1 > /dev/null \
    && {
        colour="#[fg=black]#[bg=green]"
        fvpn="VPN up"
    } \
    || {
        colour="#[fg=white]#[bg=red]"
        fvpn="VPN down"
    }

# print it centered and nicely
printf "$colour%5s%-5s#[default]\n" "$(echo "$fvpn" | cut -c 1-$((${#fvpn}/2)))" "$(echo "$fvpn" | cut -c $((${#fvpn}/2+1))-${#fvpn})"
