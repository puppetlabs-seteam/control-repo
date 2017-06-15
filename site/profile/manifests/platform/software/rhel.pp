class profile::platform::software::rhel {

  require git

  $users = {
    'root'  => '/root'
  }

  package { 'vim-enhanced':
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
