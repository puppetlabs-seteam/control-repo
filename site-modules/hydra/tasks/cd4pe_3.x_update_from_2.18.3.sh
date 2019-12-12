#!/bin/sh
## Hydra to cd4pe 3 task
# Stop current running docker container
systemctl stop docker-cd4pe
#update init.pp for cd4pe module
sed -i 's/cd4pe_version.*\x27latest\x27/cd4pe_version = \x273.x\x27/g' /etc/puppetlabs/code/environments/production/modules/cd4pe/manifests/init.pp
#update /usr/local/bin/docker-run-cd4pe-start.sh
sed -i 's/continuous-delivery-for-puppet-enterprise:2.18.3/continuous-delivery-for-puppet-enterprise:3.x/g' /usr/local/bin/docker-run-cd4pe-start.sh
systemctl start docker-cd4pe
