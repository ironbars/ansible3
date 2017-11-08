#!/bin/bash

sed -ie 's/^#en_US/en_US/g' /etc/locale.gen && rm /etc/locale.gene
locale-gen
localectl set-locale LANG=en_US.UTF-8
hwclock --systohc --utc
timedatectl set-timezone "America/Detroit"
sed -ie 's/^#NTP=/NTP=pool\.ntp\.org/g' /etc/systemd/timesyncd.conf && rm /etc/systemd/timesyncd.confe
timedatectl set-ntp true

ansible-playbook /etc/ansible/site.yml
