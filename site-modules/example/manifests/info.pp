class example::info {

  # OS Specific
  case $::kernel {
    'Linux': {
       file { '/etc/puppetlabs/puppet/info.txt':
         ensure  => 'present',
         content => "production",
         mode    => '0644',
       }
    }
    'windows':   {
       file { 'C:\ProgramData\PuppetLabs\puppet\info.txt':
         ensure  => 'present',
         content => "production",
         mode    => '0644',
       }
    }
    default: {
      fail('Unsupported operating system!')
    }
  }
  
}
