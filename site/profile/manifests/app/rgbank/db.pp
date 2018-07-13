# rgbank database profile
class profile::app::rgbank::db (
  $split = false,
) {

  include ::profile::platform::baseline

  $override_options = $split ? {
    true  =>  { 'mysqld' => { 'bind_address' => '0.0.0.0', }, },
    false => undef,
  }

  notify { "override options: ${override_options}": }

  class { '::profile::app::db::mysql::server':
    override_options => $override_options,
  }

  rgbank::db {'default':
    user     => 'rgbank',
    password => 'rgbank',
  }

  if $split {
    firewall { '3306 allow mysql access':
        dport  => [3306],
        proto  => tcp,
        action => accept,
    }
  }
}
