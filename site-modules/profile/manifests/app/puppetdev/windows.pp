class profile::app::puppetdev::windows {

  ensure_packages(['git', 'pdk'], { ensure => present, provider => 'chocolatey' })

  windows_env { 'PATH=C:\Program Files\Puppet Labs\DevelopmentKit\private\ruby\2.1.9\bin': require => Package['pdk'] }

}
