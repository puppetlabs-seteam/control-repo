# class: profile::platform::baseline::linux::vim
#
class profile::platform::baseline::linux::vim {

  case $facts['os']['family'] {
    'Debian': {
      $package = 'vim-nox'
    }
    default: {
      $package = 'vim-enhanced'
    }
  }

  package { $package:
    ensure => installed,
  }
}
