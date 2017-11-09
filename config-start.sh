#!/bin/bash

host=$1

if [ -z $host ]; then
	echo "Provide hostname (i.e $0 <hostname>)"
	exit 1
fi

# Set hostname
echo $host > /etc/hostname

# Get root device for later
root_dev=$(mount | awk '$3 ~ /^\/$/ {print $1}')

# Install bootloader
bootctl install

# Create bootloader configuration files
cat << EOF > /boot/loader/loader.conf
default    arch
timeout    5
editor     0
EOF
echo "Bootloader config file created"

cat << EOF > /boot/loader/entries/arch.conf
title        Arch Linux
linux        /vmlinuz-linux
initrd       /initramfs-linux.img
options      root=PARTUUID=$(blkid -s PARTUUID -o value $root_dev) rw
EOF
echo "Bootlaoder entry created"

# Prepare post-reboot config script
chmod +x /etc/ansible/config.sh

# Perform network setup via Ansible
ansible-playbook /etc/ansible/site.yml -t 'network_setup'

exit
