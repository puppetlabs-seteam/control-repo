# This is used for mocking the existence of puppetlabs-pe_postgresql module
# resources for tests

class pe_postgresql::globals (
  $user,
  $group,
  $client_package_name,
  $contrib_package_name,
  $server_package_name,
  $service_name,
  $default_database,
  $version,
  $bindir,
  $datadir,
  $confdir,
  $psql_path,
  $needs_initdb,
  $pg_hba_conf_defaults,
) { }

class pe_postgresql::server (
  $listen_addresses,
  $ip_mask_allow_all_users,
  $package_ensure,
) {
  include pe_postgresql::server::install
  include pe_postgresql::server::initdb
  include pe_postgresql::server::reload

  package { 'postgresql-server': }
}

class pe_postgresql::server::install { }
class pe_postgresql::server::initdb { }
class pe_postgresql::server::reload { }

class pe_postgresql::server::contrib (
  $package_ensure,
) { }

class pe_postgresql::client (
  $package_ensure,
) { }

define pe_postgresql::server::database (
  $owner,
) { }

define pe_postgresql::server::tablespace (
  $location,
) { }

define pe_postgresql::server::db (
  $user,
  $password,
  $tablespace,
) { }

define pe_postgresql::server::pg_hba_rule (
  $database,
  $user,
  $type,
  $auth_method,
  $order,
) { }

define pe_postgresql::server::config_entry (
  $value,
) { }
