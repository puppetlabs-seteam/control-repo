class profile::app::webserver::apache (
  $default_vhost = true,
){

  if $::kernel == 'windows' {
    fail('Unsupported OS')
  }

  case $::osfamily {
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
