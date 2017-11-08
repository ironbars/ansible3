#!/bin/bash

ansible-playbook /etc/ansible/site.yml -t 'network_setup'
cp /etc/ansible/ansible-build.service /etc/systemd/system/
chmod +x ansible-build.sh
systemctl enable ansible-build.service
exit
