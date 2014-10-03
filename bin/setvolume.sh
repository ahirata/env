#!/bin/bash

default_value="2%"

function usage() {
cat << EOF
Usage: $(basename "$0") OPTION [VALUE]
Simple script to increase/decrease the volume by VALUE

    -h: display this help message
    -u: increase volume by the given VALUE. Where VALUE defaults to $default_value, if not present.
    -d: decrease volume by the given VALUE. Where VALUE defaults to $default_value, if not present.
    -t: toggles the mute state

    VALUE: the value by which volume should be increased/decreased. Must be between 0 and 100.
           Mandatory if either -u or -d is used.
EOF
}

if [[ $# == 2 ]]; then
    value="$2%"
else
    value=$default_value
fi

amixer="/usr/bin/amixer -Mq set Master,0"

case "$1" in
    "-u")
        $amixer $value+
        ;;
    "-d")
        $amixer $value-
        ;;
    "-t")
        $amixer toggle
        ;;
    "-h")
        usage
        exit 0
        ;;
    *)
        usage
        exit 1
        ;;
esac

# volume=$(amixer -M get Master | grep 'Mono:' | cut -d ' ' -f 6 | sed -e 's/[^0-9]//g')
# is_muted=$(amixer -M get Master | grep 'Mono:' | grep -q "\[off\]" && echo "-m")

volume=$(amixer -M get Master | grep 'Front Left:' | head -1 | cut -d ' ' -f 7 | sed -e 's/[^0-9]//g')
is_muted=$(amixer -M get Master | grep -q "\[off\]" && echo "-m")

notify.sh $is_muted volume notification-audio-volume $volume

exit 0

