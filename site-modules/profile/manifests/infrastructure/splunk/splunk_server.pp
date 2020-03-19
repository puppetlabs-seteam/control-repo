# Class: profile::infrastructure::splunk::splunk_server
# @summary Installs and configure Splunk Enterprise Server
#
#
# @example
#   include profile::infrastructure::splunk::splunk_server
#   
# @param splunk_server
#   Specifies a Splunk server if not specified used Fact[fqdn]
#   setup to be referenced from another profile as `$profile::infrastructure::splunk::splunk_server::splunk_server_fqdn`
#
class profile::infrastructure::splunk::splunk_server (
Optional[String]  $splunk_server  = undef,
String            $hec_puppetsummary_token  = 'bba862fd-c09c-43e1-90f7-87221f362296', # needs to be a valid GUID, must match with the GUID you use on PE
String            $hec_puppetdetailed_token = '7dc49a8f-8f56-4095-9522-e5566f937cfc', # needs to be a valid GUID, must match with the GUID you use on PE
){
  case $splunk_server {
    undef: {
      $splunk_server_fqdn = $facts['fqdn']
    }
    default: {
      $splunk_server_fqdn = $splunk_server
    }
  }

  class { 'splunk::params':
    version  => '8.0.2.1',
    build    => 'f002026bad55',
    src_root => 'https://download.splunk.com',
    server   => $splunk_server_fqdn,
  }

  #Install Splunk on standard web port 8000
  class { 'splunk::enterprise':
    seed_password  => true,
    package_ensure => 'latest'
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
    value => 1024
  }

  splunk::addon { 'TA-puppet-report-viewer':
    splunkbase_source => 'puppet:///modules/profile/puppet/splunk/puppet-report-viewer_200.tgz',
    notify            =>  Class['splunk::enterprise::service'],
    inputs            => {
      'http://puppet:summary'  => {
        'sourcetype' => 'puppet:summary',
        'token'      => $hec_puppetsummary_token,
        'disabled'   => 0,
      },
      'http://puppet:detailed' => {
        'sourcetype' => 'puppet:detailed',
        'token'      => $hec_puppetdetailed_token,
        'disabled'   => 0,
      },
    },
  }

  splunk::addon {
    default:
      notify            =>  Class['splunk::enterprise::service'],
    ;
    'slack_alerts':
      splunkbase_source => 'puppet:///modules/profile/puppet/splunk/slack-notification-alert_203.tgz',
  }

  file { '/opt/splunk/etc/apps/splunk_httpinput/local':
    ensure  => directory,
    require => Class['splunk']
  }

  splunk_input {
    default:
      context => 'apps/splunk_httpinput/local',
      require => File['/opt/splunk/etc/apps/splunk_httpinput/local']
    ;
    'http/disabled':
    value   => 0,
    ;
    'http/enableSSL':
    value   => 1,
  }

  file {
    default:
      ensure  => present,
      require => Splunk::Addon['TA-puppet-report-viewer'],
      notify  => Class['splunk::enterprise::service']
    ;
    '/opt/splunk/etc/apps/TA-puppet-report-viewer/local/savedsearches.conf':
      replace => false,
      source  => 'puppet:///modules/profile/puppet/splunk/localsavedsearches.conf',
    ;
    '/opt/splunk/etc/apps/TA-puppet-report-viewer/default/savedsearches.conf':
      source  => 'puppet:///modules/profile/puppet/splunk/defaultsavedsearches.conf',
  }

}
