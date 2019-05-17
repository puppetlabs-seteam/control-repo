class profile::app::puppetdev::linux {
  include git

  $dev_packages = $::osfamily ? {
    'RedHat' => [
      'binutils',
      'bzip2',
      'cmake',
      'gcc',
      'gcc-c++',
      'gdbm-devel',
      'libffi-devel',
      'libyaml-devel',
      'make',
      'ncurses-devel',
      'openssl-devel',
      'patch',
      'readline-devel',
      'zlib-devel',
    ],
    'Debian' => [
      'build-essential',
      'cmake',
      'libffi-dev',
      'libgdbm-dev',
      'libgdbm3',
      'libncurses5-dev',
      'libreadline-dev',
      'libreadline6-dev',
      'libssl-dev',
      'libyaml-dev',
      'patch',
      'zlib1g-dev',
    ],
  }

  ensure_packages($dev_packages,{ensure => present})

  class { 'rbenv':
    manage_deps => false,
  }

  rbenv::plugin { 'rbenv/ruby-build': }
  rbenv::build { '2.3.1': global    => true }

}
