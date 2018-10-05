class role::cd4pe_server {
  role::require_kernel('Linux')

  include profile::platform::baseline
  include profile::puppet::cd4pe
}
