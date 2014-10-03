read_config() {
  source config
  if [[ -z "$GRUB_INSTALL" ]]; then
    echo "GRUB install device is not configured"
    exit 1
  fi

  if [[ -z "$MOUNT_POINT" ]]; then
    echo "Mount point is not configured"
    exit 1
  fi

  if [[ -z "$HOSTNAME" ]]; then
    echo "Hostname variable is not configured"
    exit 1
  fi
}

configure_wifi() {
  echo "Configuring wifi..."
  wifi-menu
}

update_mirrorlist() {
  echo "Updating mirrorlist..."
  curl 'https://www.archlinux.org/mirrorlist/?country=BR&country=SE&protocol=http&ip_version=4' | sed -e 's/#//' > /etc/pacman.d/mirrorlist
}

install_packages() {
  echo "Installing packages..."
  pacstrap -i "$MOUNT_POINT" $1
}

configure_fstab() {
  echo "Copying fstab to new system..."
  genfstab -U -p "$MOUNT_POINT" >> "$MOUNT_POINT"/etc/fstab
}

configure_locale() {
  echo "Configuring locale..."
  sed -i -e 's/^#\(en_US.UTF-8 UTF-8\)/\1/' -e 's/^#\(pt_BR.UTF-8 UTF-8\)/\1/' /etc/locale.gen
  locale-gen
  echo LANG=en_US.UTF-8 > /etc/locale.conf
  export LANG=en_US.UTF-8
  echo KEYMAP=us-acentos >> /etc/vconsole.conf
  ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
  hwclock --systohc --utc
}

configure_hostname() {
  read -e -p "Enter the hostname: " this_hostname
  echo $1 > /etc/hostname
  sed -i -e "s/^\(127.*\)$/\1\t$this_hostname/" /etc/hosts
}

configure_bootloader() {
  echo "Configuring boot loader..."
  grub-install --target=i386-pc --recheck $1
  grub-mkconfig -o /boot/grub/grub.cfg
}

set_passwd() {
  arch-chroot "$MOUNT_POINT" passwd "$1"
}

copy_scripts() {
  cp -R /root/env /home/"$MAIN_USER" && chown -R "$MAIN_USER"."$MAIN_USER" /home/"$MAIN_USER"/env
}

configure_systemd() {
  systemctl enable NetworkManager.service
  systemctl enable lightdm.service
}

create_user() {
  echo " Creating main user"
  useradd -m -G wheel -s /bin/bash "$MAIN_USER"
  copy_scripts
}

install_pkg() {
  tar -xvzf $1.tar.gz
  cd $1
  makepkg -s
  sudo pacman -U $(ls -1 *.tar.xz)
  cd ../
}

install_yaourt() {
  echo "Installing yaourt..."
  wget https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
  install_pkg package-query

  wget https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
  install_pkg yaourt
}

install_aur_packages() {
  echo "Installing aur packages..."
  yaourt -S $1
}

precheck_skype() {
  grep "^\[multilib\]$" /etc/pacman.conf
  if [ $? -eq 1 ]; then
    echo "Uncomment multilib for skype"
    return 1
  fi
  return 0
}

install_skype() {
  echo "Creating skype user: "
  useradd -m -G audio,video -s /bin/bash skype

  echo 'export DISPLAY=":0.0"' | sudo -u skype tee /home/skype/.bashrc
  cp ~/env/dotfiles/.XCompose.symlink /home/skype/.XCompose
  chown skype.skype /home/skype/.XCompose

  sudo -u skype mkdir /home/skype/.pulse
  echo "default-server = 127.0.0.1" | sudo -u skype tee /home/skype/.pulse/client.conf
}

