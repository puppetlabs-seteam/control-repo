class profile::app::puppetdev::linux {

  $dev_packages = $::osfamily ? {
    'RedHat' => ['gcc','gcc-c++','openssl-devel','readline-devel','zlib-devel','cmake'],
    'Debian' => ['build-essential','cmake','libssl-dev','zlib1g-dev','libreadline6-dev'],
  }

  ensure_packages($dev_packages,{ensure => present})

  include ::rbenv
  rbenv::plugin { 'rbenv/ruby-build': }
  rbenv::build { '2.3.1': global    => true }

}
