## site.pp ##

# Disable filebucket by default for all File resources:
File { backup => false }

# Applications managed by App Orchestrator are defined in the site block.
site {

}

node default {
  # Check if we've set the role for this node via trusted fact, pp_role.  If yes; include that role directly here.
<<<<<<< HEAD
  if !empty( $trusted['extensions']['pp_role'] ) {
    $role = $trusted['extensions']['pp_role']
    #include "${trusted['extensions']['pp_role']}"
  }
=======
  #if !empty( $trusted['extensions']['pp_role'] ) {
  #  $role = $trusted['extensions']['pp_role']
  #  include "role::${trusted['extensions']['pp_role']}"
  #}
>>>>>>> 90093945ec37b03c799e0b2fa1900316364ec9f2
}
