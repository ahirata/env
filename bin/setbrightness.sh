#!/bin/bash

function usage() {
cat << EOF
Usage: $(basename "$0") OPTION [VALUE]
Simple script to increase/decrease brightness by VALUE.

    -h: display this help message
    -u: increase brightness by the given VALUE
    -d: decrease brightness by the given VALUE

    VALUE: the value by which brightness should be increased/decreased. Must be
           between 0 and 100.
           Mandatory if either -u or -d is used.

This script uses sudo to execute brightess.sh. You need to put brightness.sh in
sudoers in order to execute without password.
EOF
}

case "$1" in
    "-u"|"-d")
        max=$(brightness.sh -m)
        current=$(brightness.sh -a)

        # scale the value according to max brightness
        step=$(($2 * max / 100))

        if [ $1 == "-u" ]; then
            new_val=$((current + step))
        else
            new_val=$((current - step))
        fi
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

if (( new_val > max )); then
    new_val=$max
elif ((new_val <= 0 )); then # do not allow to go totally blank
    new_val=1
fi

sudo brightness.sh -s $new_val

value=$((new_val*100/max))

notify.sh brightness notification-display-brightness $value

