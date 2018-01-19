#!/bin/bash

# get the load for mac differently
uname -s | grep -sq Darwin \
    && {
        sysctl -n vm.loadavg | cut -d ' ' -f 2-4 | tr ',' '.'
    } \
    || cut -d ' ' -f 1-3 /proc/loadavg
