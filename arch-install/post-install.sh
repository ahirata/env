#!/bin/bash

source ./functions.sh

read_config

cd ~
mkdir tmp
cd tmp

install_yaourt
install_aur_packages "$AUR_PACKAGES"

./dev-install.sh

cat << EOF
Configure plymouth:
- Move etc/plymouth/plymouth.conf
- Modify /etc/default/grub:
  GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=0 splash"

- Modify /etc/mkinitcpio.conf:
  MODULES="i915"
  HOOKS="base udev plymouth autodetect modconf block filesystems keyboard"

- Rebuild:
  mkinitcpio -p linux
  grub-mkconfig -o /boot/grub/grub.cfg

EOF

