#!/bin/bash
############# GS notes ######################
#
# Creates a minimal PE master environment for the new demo environment.
# The goal is to require only a vanilla PE install at the specified version,
# and a single module to do minor agent configuration prior to class.

# Input variables
# If you want to override the defaults, you can pass these along the command line
set -x
export PATH=$PATH:/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin
FQDN="puppet.se.automationdemos.com"
HOSTNAME="puppet"
USER_PASSWORD="Puppetworkshop-1"

function add_pe_users {
		SSLDIR=`puppet config print ssldir`


  /opt/puppetlabs/bin/puppet-access login deploy --lifetime=1y << TEXT
${PT_password}
TEXT

  # Create workshop accounts
  for s in {0..35}
  do
    /opt/puppetlabs/puppet/bin/curl -k -X POST -H 'Content-Type: application/json' \
            https://${FQDN}:4433/rbac-api/v1/users \
            -d "{\"login\": \"workshop${s}\", \"password\": \"${USER_PASSWORD}\", \"email\": \"\", \"display_name\": \"Workshop${s}\", \"role_ids\": [2,1864982764]}" \
            --cert ${SSLDIR}/certs/${FQDN}.pem \
            --key ${SSLDIR}/private_keys/${FQDN}.pem \
            --cacert ${SSLDIR}/certs/ca.pem
  done
}

# Kick off Puppet agent run
#function run_puppet {
#    echo "Kick off a Puppet Run - Shouldn't be necessary for adding users but can't hurt"
#  cd /
#  /opt/puppetlabs/bin/puppet agent -t
#}

#########################################################
# SKP: 12-03-2024
# Script execution begins here.
# The script is executed as a series of functions
#########################################################

add_pe_users

echo "Users have been created for the workshop"