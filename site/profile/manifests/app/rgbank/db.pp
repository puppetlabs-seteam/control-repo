# rgbank database profile
class profile::app::rgbank::db {

  rgbank::db {'default':
    user     => 'rgbank',
    password => 'rgbank',
  }

}
