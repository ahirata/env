#!/bin/bash

source ./functions.sh

read_config

precheck_skype || read -p "Open another terminal and configure /etc/pacman.conf"

configure_wifi

update_mirrorlist
read -p "Open another terminal and configure mirrorlist"

install_packages "$PACKAGES"

configure_fstab

cp -R /root/env "$MOUNT_POINT"/root/

echo "Entering chroot..."
arch-chroot "$MOUNT_POINT" /bin/bash << EOF
  cd /root/env/arch-install/
  source ./functions.sh
  read_config
  configure_locale "$HOSTNAME"
  configure_bootloader "$GRUB_INSTALL"
  configure_systemd
  create_user
  install_skype
EOF

echo "Set password for $MAIN_USER"
set_passwd "$MAIN_USER"

echo "Set password for skype"
set_passwd skype

echo "Set password for root"
set_passwd root

cat << EOF
Configure sudo for wheel group:
  %wheel ALL=(ALL) ALL

Configure sudo to skip password for skype:
  %wheel ALL=(skype) NOPASSWD: /usr/bin/skype

Execute env/setenv.sh for main user inside arch-chroot
EOF

