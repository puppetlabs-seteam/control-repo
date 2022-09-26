class example::info {
  file { '/etc/puppetlabs/puppet/info.txt':
    ensure  => 'present',
    content => "production",
    mode    => '0644',
  }
}
