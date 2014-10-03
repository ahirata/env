#!/bin/bash

sudo mount /dev/sdb5 /mnt/bkp
sudo mount /dev/sdb6 /mnt/bkp/home

sudo rsync -aAXHSv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/home/*/.thumbnails/*","/home/*/.cache/mozilla/*","/home/*/.cache/chromium/*","/home/*/.local/share/Trash/*"} /* /mnt/bkp
