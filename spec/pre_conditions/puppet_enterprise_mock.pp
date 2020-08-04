# This is used for mocking the existence of puppetlabs-puppet_enterprise module
# resources for tests

function pe_compiling_server_version() {
  '2019.2.2'
}

function pe_build_version() {
  '2019.2.2'
}

class puppet_enterprise::packages { }

service { 'pe-puppetserver':
  ensure => 'running'
}

define puppet_enterprise::pg::cert_whitelist_entry (
  $user,
  $database,
  $allowed_client_certname,
  $pg_ident_conf_path,
  $ip_mask_allow_all_users_ssl,
  $ipv6_mask_allow_all_users_ssl,
) { }
