class profile::app::entropy {

  if $facts['kernel'] == 'windows' {
    fail('Unsupported OS')
  }

  class { '::rngd':
    hwrng_device => '/dev/urandom',
  }

}
