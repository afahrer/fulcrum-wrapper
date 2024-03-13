#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 15000)); then
    exit 60
else
    if ! curl --silent --fail http://fulcrum.embassy:8080 &>/dev/null; then
        echo "Web interface is unreachable" >&2
        exit 1
    fi
fi