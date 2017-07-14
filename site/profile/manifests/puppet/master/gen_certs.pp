class profile::puppet::master::gen_certs (
  $dns_alt_names = ['puppet','puppetpoc'],
  $cert_hostname = $::fqdn,
){


  Exec {
    timeout => 0
  }

  pe_ini_setting { 'clientcert':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'certname',
    value   => $cert_hostname,
  }

  # Which certs to generate
  $new_certs = {
    $cert_hostname                                         => $dns_alt_names,
    'pe-internal-classifier'                        => [],
    'pe-internal-dashboard'                         => [],
    'pe-internal-mcollective-servers'               => [],
    'pe-internal-peadmin-mcollective-client'        => [],
    'pe-internal-puppet-console-mcollective-client' => [],
    'pe-internal-orchestrator'                      => [],
  }

  $new_certs.each |$k,$v| {

    if empty($v) {
      $command = "puppet cert generate ${k}"
    } else {
      $dns_names = join($v,',')
      $command = "puppet cert generate ${k} --dns_alt_names=${dns_names}"
    }

    exec{"cert-${k}":
      path    => $::path,
      command => $command,
      unless  => "test -f /etc/puppetlabs/puppet/ssl/ca/signed/${k}.pem",
      returns => [0,24]
    }

    if !empty($v) {

      $sign_cmd = "puppet cert --allow-dns-alt-names sign ${k}"

      exec{"cert-sign-${k}":
        path    => $::path,
        command => $sign_cmd,
        unless  => "test -f /etc/puppetlabs/puppet/ssl/ca/signed/${k}.pem",
      }
    }

  }

  file{'/etc/puppetlabs/puppet/ssl/crl.pem':
    source => '/etc/puppetlabs/puppet/ssl/ca/ca_crl.pem',
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0644',
  }



  $copy_files = {
    "/etc/puppetlabs/puppet/ssl/certs/${cert_hostname}.pem" =>
      "/etc/puppetlabs/puppet/ssl/ca/signed/${cert_hostname}.pem",
    "/opt/puppetlabs/server/data/postgresql/9.4/data/certs/${cert_hostname}.cert.pem" =>
      "/etc/puppetlabs/puppet/ssl/certs/${cert_hostname}.pem",
    "/opt/puppetlabs/server/data/postgresql/9.4/data/certs/${cert_hostname}.public_key.pem" =>
      "/etc/puppetlabs/puppet/ssl/public_keys/${cert_hostname}.pem",
    "/opt/puppetlabs/server/data/postgresql/9.4/data/certs/${cert_hostname}.private_key.pem" =>
      "/etc/puppetlabs/puppet/ssl/private_keys/${cert_hostname}.pem",
    '/etc/puppetlabs/orchestration-services/ssl/pe-internal-orchestrator.cert.pem' =>
      '/etc/puppetlabs/puppet/ssl/certs/pe-internal-orchestrator.pem',
    '/etc/puppetlabs/orchestration-services/ssl/pe-internal-orchestrator.public_key.pem' =>
      '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-orchestrator.pem',
    '/etc/puppetlabs/orchestration-services/ssl/pe-internal-orchestrator.private_key.pem' =>
      '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-orchestrator.pem',
    "/etc/puppetlabs/orchestration-services/ssl/${cert_hostname}.cert.pem" =>
      "/etc/puppetlabs/puppet/ssl/certs/${cert_hostname}.pem",
    "/etc/puppetlabs/orchestration-services/ssl/${cert_hostname}.public_key.pem" =>
      "/etc/puppetlabs/puppet/ssl/public_keys/${cert_hostname}.pem",
    "/etc/puppetlabs/orchestration-services/ssl/${cert_hostname}.private_key.pem" =>
      "/etc/puppetlabs/puppet/ssl/private_keys/${cert_hostname}.pem",
    '/opt/puppetlabs/server/data/console-services/certs/pe-internal-classifier.cert.pem' =>
      '/etc/puppetlabs/puppet/ssl/certs/pe-internal-classifier.pem',
    '/opt/puppetlabs/server/data/console-services/certs/pe-internal-classifier.public_key.pem' =>
      '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-classifier.pem',
    '/opt/puppetlabs/server/data/console-services/certs/pe-internal-classifier.private_key.pem' =>
      '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-classifier.pem',
    "/opt/puppetlabs/server/data/console-services/certs/${cert_hostname}.cert.pem" =>
      "/etc/puppetlabs/puppet/ssl/certs/${cert_hostname}.pem",
    "/opt/puppetlabs/server/data/console-services/certs/${cert_hostname}.public_key.pem" =>
      "/etc/puppetlabs/puppet/ssl/public_keys/${cert_hostname}.pem",
    "/opt/puppetlabs/server/data/console-services/certs/${cert_hostname}.private_key.pem" =>
      "/etc/puppetlabs/puppet/ssl/private_keys/${cert_hostname}.pem",
    '/opt/puppetlabs/server/data/console-services/certs/pe-internal-dashboard.cert.pem' =>
      '/etc/puppetlabs/puppet/ssl/certs/pe-internal-dashboard.pem',
    '/opt/puppetlabs/server/data/console-services/certs/pe-internal-dashboard.public_key.pem' =>
      '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-dashboard.pem',
    '/opt/puppetlabs/server/data/console-services/certs/pe-internal-dashboard.private_key.pem' =>
      '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-dashboard.pem',
    "/etc/puppetlabs/puppetdb/ssl/${cert_hostname}.cert.pem" =>
      "/etc/puppetlabs/puppet/ssl/certs/${cert_hostname}.pem",
    "/etc/puppetlabs/puppetdb/ssl/${cert_hostname}.public_key.pem" =>
      "/etc/puppetlabs/puppet/ssl/public_keys/${cert_hostname}.pem",
    "/etc/puppetlabs/puppetdb/ssl/${cert_hostname}.private_key.pem" =>
      "/etc/puppetlabs/puppet/ssl/private_keys/${cert_hostname}.pem",
  }

  $copy_files.each |$t,$s| {
    file { $t:
      ensure => present,
      source => $s,
    }
  }

  $pk8_create = {
    "/etc/puppetlabs/puppetdb/ssl/${cert_hostname}.private_key.pk8"               =>
      ['/etc/puppetlabs/puppetdb/ssl', "/etc/puppetlabs/puppetdb/ssl/${cert_hostname}.private_key.pem"],
    "/etc/puppetlabs/orchestration-services/ssl/${cert_hostname}.private_key.pk8" =>
      ['/etc/puppetlabs/orchestration-services/ssl',"/etc/puppetlabs/puppetdb/ssl/${cert_hostname}.private_key.pem"],
  }

  $pk8_create.each |$in,$o| {

    $workdir = $o[0]
    $outfile = $o[1]

    exec {"pk8_${in}":
      path    => $::path,
      cwd     => $workdir,
      command => "openssl pkcs8 -topk8 -inform PEM -outform DER -in ${in} -out ${outfile} -nocrypt",
      unless  => "test -f ${outfile}",
    }

  }

  file {'/opt/puppetlabs/server/data/postgresql/9.4/data/certs/':
    ensure  => directory,
    owner   => 'pe-postgres',
    group   => 'pe-postgres',
    recurse => true,
    notify  => Exec['chmod_postgresql_certs'],
  }


  file {'/etc/puppetlabs/puppetdb/ssl':
    ensure  => directory,
    owner   => 'pe-puppetdb',
    group   => 'pe-puppetdb',
    recurse => true,
  }

  file {'/opt/puppetlabs/server/data/console-services/certs/':
    ensure  => directory,
    owner   => 'pe-console-services',
    group   => 'pe-console-services',
    recurse => true,
  }

  file {'/etc/puppetlabs/orchestration-services/ssl/':
    ensure  => directory,
    owner   => 'pe-orchestration-services',
    group   => 'pe-orchestration-services',
    recurse => true,
  }

  File<||>
    -> exec {'chmod_postgresql_certs':
      path        => $::path,
      command     => 'chmod 400 /opt/puppetlabs/server/data/postgresql/9.4/data/certs/*',
      refreshonly => true,
    }


  $base_ver  = split($::pe_server_version,'[.]')[0] + 0
  $minor_ver = split($::pe_server_version,'[.]')[1] + 0

  if $base_ver < 2017 and $minor_ver < 5 {
    $puppet_face = 'enterprise'
  } else {
    $puppet_face = 'infrastructure'
  }

  File<||>
    -> exec {"puppet_${puppet_face}_configure":
      path    => $::path,
      command => "puppet ${puppet_face} configure",
    }
    -> exec {'run agent':
      path    => $::path,
      command => 'puppet agent -t',
      returns => [2],
    }
    -> exec {'run agent console setup':
      path    => $::path,
      command => 'puppet agent -t',
      returns => [2],
    }

}
