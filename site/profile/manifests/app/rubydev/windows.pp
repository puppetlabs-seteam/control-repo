class profile::app::rubydev::windows {

  Package {
    provider => 'chocolatey',
  }

  $dev_packages = ['git','cmake']
  ensure_packages($dev_packages, { ensure => present })

  reboot {'pre_ruby_install':
    apply     => 'immediately',
    subscribe => Package[$dev_packages],
  }

  package {'ruby':
    ensure   => '2.3.1',
  }

  package {'ruby2.devkit':
    ensure  => present,
    require => [
      Package[$dev_packages],
      Package['ruby'],
    ],
  }

  windows_env { 'PATH=C:/tools/ruby23/bin': require => Package['ruby'] }

  file_line {'ruby-devkit-setup':
    path    => 'C:/tools/DevKit2/config.yml',
    line    => '- C:/tools/ruby23',
    require => Package['ruby2.devkit'],
  }

  exec {'ruby-devkit-bind':
    cwd     => 'C:/tools/DevKit2',
    command => 'C:/tools/ruby23/bin/ruby.exe dk.rb install -f',
    creates => 'C:/tools/ruby23/lib/ruby/site_ruby/devkit.rb',
    require => [
      Package['ruby2.devkit'],
      File_line['ruby-devkit-setup'],
    ],
  }

  archive {'C:/tools/rubygems-update-2.6.12.gem':
    ensure  => present,
    extract => false,
    source  => 'https://rubygems.org/gems/rubygems-update-2.6.12.gem',
    creates => 'C:/tools/rubygems-update-2.6.12.gem',
    notify  => Exec['install_ruby_gems'],
    cleanup => false,
    require => Package['ruby'],
  }

  exec { 'install_ruby_gems':
    cwd         => 'C:/tools',
    command     => 'gem install --local rubygems-update-2.6.12.gem',
    refreshonly => true,
    path        => "${::path};C:\\tools\\ruby23\\bin",
    provider    => powershell,
    notify      => Exec['update_ruby_gems'],
  }

  exec { 'update_ruby_gems':
    command     => 'update_rubygems',
    path        => "${::path};C:\\tools\\ruby23\\bin",
    provider    => powershell,
    refreshonly => true,
  }

  exec { 'install_bundler':
    command  => 'gem install bundler',
    unless   => 'gem list | findstr bundler',
    provider => powershell,
    path     => "${::path};C:\\tools\\ruby23\\bin",
    require  => Package['ruby'],
  }

}
