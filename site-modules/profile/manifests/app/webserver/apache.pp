class profile::app::webserver::apache (
  $default_vhost = true,
){

  if $facts['kernel'] == 'windows' {
    fail('Unsupported OS')
  }

  case $facts['os']['family'] {
    'Debian':{
      $mpm = 'itk'
    }
    'RedHat':{
      $mpm = 'prefork'
    }
    default:{
      fail('Unsupported OS')
    }
  }

  class { '::apache':
    default_vhost => $default_vhost,
    mpm_module    => $mpm,
  }

  contain ::profile::app::webserver::apache::php

}
