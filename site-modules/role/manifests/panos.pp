class role::panos {
  include profile::infrastructure::network::panos::interfaces
  include profile::infrastructure::network::panos::zones
  include profile::infrastructure::network::panos::nat
  include profile::infrastructure::network::panos::security_policies
  include profile::infrastructure::network::panos::commit

  Class['profile::infrastructure::network::panos::interfaces'] -> Class['profile::infrastructure::network::panos::zones'] -> Class['profile::infrastructure::network::panos::nat'] -> Class['profile::infrastructure::network::panos::security_policies']
}