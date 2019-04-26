# Class: profile::infrastructure::splunk::splunk_server
# Installs and configure Splunk Enterprise Server
#
class profile::infrastructure::splunk::splunk_server {
  package { 'net-tools':
    ensure => 'present',
    before => Class['splunk']
  }

  class { 'splunk::params':
    version     => '7.2.5.1',
    build       => '962d9a8e1586',
    src_root    => 'https://download.splunk.com',
    server      => $facts['fqdn'],     #or replace with your servername
    splunk_user => 'root'
  }

  #Install Splunk on standard web port 8000
  class { 'splunk::enterprise':
    manage_password => true,
    package_ensure  => 'latest'
  }

  class { 'firewall': }

  firewall { '100 allow splunk ports access':
    dport   => [8000, 8088, 8089, 9997],
    proto   => tcp,
    action  => accept,
    require => Class['firewall']
  }

  $default_indexes = [
    '_audit/maxTotalDataSizeMB',
    '_internal/maxTotalDataSizeMB',
    '_introspection/maxTotalDataSizeMB',
    '_telemetry/maxTotalDataSizeMB',
    '_thefishbucket/maxTotalDataSizeMB',
    'history/maxTotalDataSizeMB',
    'main/maxTotalDataSizeMB',
    'splunklogger/maxTotalDataSizeMB',
    'summary/maxTotalDataSizeMB',
  ]

  splunk_indexes { $default_indexes:
    value   => 1024
  }

  archive { '/tmp/puppet-report-viewer_135.tgz':
    source       => 'puppet:///modules/profile/puppet/splunk/puppet-report-viewer_135.tgz',
    extract      => true,
    extract_path => '/opt/splunk/etc/apps',
    creates      => '/opt/splunk/etc/apps/TA-puppet-report-viewer',
    user         => 'splunk',
    group        => 'splunk',
    require      => Class['splunk'],
    notify       => Service['Splunkd']
  }

  splunk_input { 'http/disabled':
    context => 'apps/splunk_httpinput/local',
    value   => 0
  }
  splunk_input { 'http/enableSSL':
    context => 'apps/splunk_httpinput/local',
    value   => 1
  }

  splunk_input { 'hec_puppetsummary_enable':
    context => 'apps/TA-puppet-report-viewer/local',
    section => 'http://puppet:summary',
    setting => 'disabled',
    value   => 0
  }
  splunk_input { 'hec_puppetsummary_sourcetype':
    context => 'apps/TA-puppet-report-viewer/local',
    section => 'http://puppet:summary',
    setting => 'sourcetype',
    value   => 'puppet:summary'
  }
  splunk_input { 'hec_puppetsummary_token':
    context => 'apps/TA-puppet-report-viewer/local',
    section => 'http://puppet:summary',
    setting => 'token',
    value   => 'bba862fd-c09c-43e1-90f7-87221f362296'    # needs to be a valid GUID, must match with the GUID you use on PE
  }

  splunk_input { 'hec_puppetdetailed_enable':
    context => 'apps/TA-puppet-report-viewer/local',
    section => 'http://puppet:detailed',
    setting => 'disabled',
    value   => 0
  }
  splunk_input { 'hec_puppetdetailed_sourcetype':
    context => 'apps/TA-puppet-report-viewer/local',
    section => 'http://puppet:detailed',
    setting => 'sourcetype',
    value   => 'puppet:detailed'
  }
  splunk_input { 'hec_puppetdetailed_token':
    context => 'apps/TA-puppet-report-viewer/local',
    section => 'http://puppet:detailed',
    setting => 'token',
    value   => '7dc49a8f-8f56-4095-9522-e5566f937cfc'    # needs to be a valid GUID, must match with the GUID you use on PE
  }

}
