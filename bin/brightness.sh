#!/bin/bash

usage="Usage: $(basename "$0") OPTION [VALUE]
Simple script to get/set brightness

Options:
    -a: display actual brightness
    -h: display this help message
    -m: display max brightness
    -s VALUE: set brightness to the given VALUE. The value must not be greater than the max brightness

This script must be executed as root.
"

backlight_home=/sys/class/backlight/acpi_video0

case "$1" in
    "-a")
        cat $backlight_home/actual_brightness
        exit 0
        ;;
    "-h")
        echo "$usage"
        exit 0
        ;;
    "-m")
        cat $backlight_home/max_brightness
        exit 0
        ;;
    "-s")
        echo $2 > $backlight_home/brightness
        exit $?
        ;;
    *)
        echo "$usage"
        exit 1
        ;;
esac
