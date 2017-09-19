## site.pp ##

# Disable filebucket by default for all File resources:
File { backup => false }

# Applications managed by App Orchestrator are defined in the site block.
site {

}

node default {
  # For windows nodes, ensure some basics are in place so we can properly manage them; namely WMF and Chocolatey
  if $::kernel == 'windows' {
    include ::profile::platform::baseline::windows::bootstrap
    include ::profile::platform::baseline::windows::firewall
  }

  # Check if we've set the role for this node via trusted fact, pp_role.  If yes; include that role directly here.
  if !empty( $trusted['extensions']['pp_role'] ) {
    $role = $trusted['extensions']['pp_role']
    include "role::${trusted['extensions']['pp_role']}"
  }
}
