# rgbank database profile
class profile::app::rgbank::db {

  include ::profile::app::db::mysql::server

  rgbank::db {'default':
    user     => 'rgbank',
    password => 'rgbank',
  }

}
