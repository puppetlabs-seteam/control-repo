# rgbank database profile
class profile::app::rgbank::db (
  $split = false,
) {

  include ::profile::platform::baseline
  include ::profile::app::db::mysql::server

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
