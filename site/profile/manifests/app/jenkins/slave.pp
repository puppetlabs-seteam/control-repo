class profile::app::jenkins::slave (
  $master_url = 'http://localhost:8080',
){

  include ::profile::platform::baseline

  case $::kernel {

    'Linux': {
      class { '::jenkins::slave':
        masterurl    => $master_url,
        ui_user      => 'admin',
        ui_pass      => 'password',
        labels       => ['tse-slave-linux','tse-control-repo'],
        slave_groups => 'wheel',
      }

      include ::profile::app::puppetdev
    }

    'windows': {
      class { '::profile::app::jenkins::win_slave':
        masterurl => $master_url,
        ui_user   => 'admin',
        ui_pass   => 'password',
        labels    => 'tse-slave-windows',
      }

      include ::profile::app::puppetdev
    }

    default:{
      fail('Unsupported OS')
    }

  }


}
