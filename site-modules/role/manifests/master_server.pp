# Class for Puppet Primary server role
class role::master_server {
  role::require_kernel('Linux')
}
