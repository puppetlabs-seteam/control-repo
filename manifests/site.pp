## site.pp ##

# Disable filebucket by default for all File resources:
File { backup => false }

# Applications managed by App Orchestrator are defined in the site block.
site {

}

node default {
  # Check if we've set the role for this node via trusted fact, pp_role.  If yes; include that role directly here.
  if !empty( $trusted['extensions']['pp_role'] ) {
    $role = $trusted['extensions']['pp_role']
    if defined("role::${role}") {
      include "role::${role}"
    }
  }
}

# Enable the "package inventory" function by default
node 'puppet.classroom.puppet.com' {
  pe_node_group { 'PE Agent':
    classes => {
      'puppet_enterprise::profile::agent' => {
        'pcp_broker_host' => 'puppet.classroom.puppet.com',
        'package_inventory_enabled' => true,
      }
    }
  }
}
