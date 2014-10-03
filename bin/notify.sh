#!/bin/bash
usage="$(basename $0) [-m] volume|brightness ICON VALUE
Uses notify-send to display a notification with ICON and bar set to VALUE.

Where:
    -m: flags the notification to use the \"muted\" icon.

Icons should be available at /usr/share/icons/{theme_name}/status/scalable.

The bar hint is specific to notify-osd.
"

case "$1" in
    "-m")
        control="$2"
        icon="$3-muted"
        value=$4
        ;;
    *)
        control=$1
        icon=$2
        value=$3
        if ((0 == "$value" || "" == "$value")); then
            icon="$icon-off"
            value=0
        elif ((0 < "$value" && "$value" <= 33)); then
            icon="$icon-low"
        elif ((33 < "$value" && "$value" <= 66)); then
            icon="$icon-medium"
        elif ((66 < "$value" && "$value" <= 100)); then
            icon="$icon-high"
        fi
        ;;
esac

notify-send " " -i $icon -h int:value:$value -h string:synchronous:$control
