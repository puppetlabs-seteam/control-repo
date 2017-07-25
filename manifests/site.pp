## site.pp ##

# Disable filebucket by default for all File resources:
File { backup => false }

# APP ORCHESTRATOR
# Applications managed by App Orchestrator are defined in the site block.
site {

}

node default {
  if !empty( $trusted['extensions']['pp_role'] ) {
    $role = $trusted['extensions']['pp_role']
    include "role::${trusted['extensions']['pp_role']}"
  }
}
