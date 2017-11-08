#!/bin/bash

ansible-playbook /etc/ansible/site.yml -t 'network_setup'
chmod +x ansible-build.sh
exit
