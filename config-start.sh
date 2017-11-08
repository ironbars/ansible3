#!/bin/bash

host=$1

if [ -z $host ]; then
	echo "Provide hostname (i.e $0 <hostname>)"
	exit 1

# Set hostname
echo $host > /etc/hostname

# Install bootloader
bootctl install

# Create bootloader configuration files
cat << EOF > /boot/loader/loader.conf
default    arch
timeout    5
editor     0
EOF

cat << EOF > /boot/loader/entries/arch.conf
title        Arch Linux
linux        /vmlinuz-linux
initrd       /initramfs-linux.img
options      root=PARTUUID=$(lsblk -o MOUNTPOINT,UUID | awk '$1 ~ /^\/$/ {print $2}') rw
EOF

# Prepare post-reboot config script
chmod +x /etc/ansible/config.sh

# Perform network setup via Ansible
ansible-playbook /etc/ansible/site.yml -t 'network_setup'
