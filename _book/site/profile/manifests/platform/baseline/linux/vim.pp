class profile::platform::baseline::linux::vim {

  require ::git

  $users = {
    'root'  => '/root',
  }

  case $::osfamily {
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

  $users.each |$user, $homedir| {
    puppet_vim_env::install { "default vim for ${user}":
      homedir     => $homedir,
      owner       => $user,
      colorscheme => 'elflord',
    }
  }
}
