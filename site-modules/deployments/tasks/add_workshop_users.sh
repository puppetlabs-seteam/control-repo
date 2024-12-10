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
SSLDIR=`puppet config print ssldir`

/opt/puppetlabs/bin/puppet-access login deploy --lifetime=1y << TEXT
${PT_password}
TEXT

function get_role_id {
    local role_name="comply-operator"

    # Get all roles
    response=$( /opt/puppetlabs/puppet/bin/curl -k -X GET -H 'Content-Type: application/json' \
            https://${FQDN}:4433/rbac-api/v1/roles \
            --cert ${SSLDIR}/certs/${FQDN}.pem \
            --key ${SSLDIR}/private_keys/${FQDN}.pem \
            --cacert ${SSLDIR}/certs/ca.pem
        )

    # Parse response using jq to find role ID by name
    role_id=$(echo "$response" | jq -r ".[] | select(.display_name==\"${role_name}\") | .id")

    if [ -n "$role_id" ]; then
        echo "Comply Operator role id is --> $role_id"
        return 0
    else
        echo "Role not found" >&2
        return 1
    fi
}

function add_pe_users {

  # Create workshop accounts
  for s in {0..35}
  do
    /opt/puppetlabs/puppet/bin/curl -k -X POST -H 'Content-Type: application/json' \
            https://${FQDN}:4433/rbac-api/v1/users \
            -d "{\"login\": \"workshop${s}\", \"password\": \"${USER_PASSWORD}\", \"email\": \"\", \"display_name\": \"Workshop${s}\", \"role_ids\": [2,${role_id}]}" \
            --cert ${SSLDIR}/certs/${FQDN}.pem \
            --key ${SSLDIR}/private_keys/${FQDN}.pem \
            --cacert ${SSLDIR}/certs/ca.pem
  done
}


#########################################################
# SKP: 12-03-2024
# Script execution begins here.
# The script is executed as a series of functions
#########################################################
get_role_id
add_pe_users

echo "Users have been created for the workshop"