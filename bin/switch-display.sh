#!/bin/bash

CONFIG_FILE=~/env/conf/20-display.conf
XORG_CONF_DIR=/etc/X11/xorg.conf.d

echo $(readlink $(basename "$0"))
if [[ -s $XORG_CONF_DIR/$CONFIG_FILE ]]; then
    echo "Switching to single head"
    sudo rm -f $XORG_CONF_DIR/$CONFIG_FILE
else
    echo "Switching to dual head"
    sudo ln -sf $(dirname "$0")/$CONFIG_FILE $XORG_CONF_DIR
fi

if [[ $? == 0 ]]; then
    read -p "All done."
fi
