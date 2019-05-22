# install and configure gitea
class profile::puppet::master::gitea {
  include git

  $secret_key = 'mysecretkey'
  class { 'gitea':
      package_ensure         => 'present',
      dependencies_ensure    => 'present',
      dependencies           => ['curl', 'tar'],
      manage_user            => true,
      manage_group           => true,
      manage_home            => true,
      owner                  => 'git',
      group                  => 'git',
      home                   => '/home/git',
      version                => '1.4.2',
      checksum               => 'c843d462b5edb0d64572b148a0e814e41d069d196c3b3ee491449225e1c39d7d',
      checksum_type          => 'sha256',
      installation_directory => '/opt/gitea',
      repository_root        => '/var/git',
      log_directory          => '/var/log/gitea',
      attachment_directory   => '/opt/gitea/data/attachments',
      manage_service         => true,
      service_template       => 'gitea/systemd.erb',
      service_path           => '/lib/systemd/system/gitea.service',
      service_provider       => 'systemd',
      service_mode           => '0644',
      configuration_sections => {
        'server'     => {
          'DOMAIN'           => $::fqdn,
          'HTTP_PORT'        => 3000,
          'ROOT_URL'         => "https://${::fqdn}/",
          'HTTP_ADDR'        => '0.0.0.0',
          'DISABLE_SSH'      => false,
          'SSH_PORT'         => '22',
          'START_SSH_SERVER' => false,
          'OFFLINE_MODE'     => false,
        },
        'database'   => {
          'DB_TYPE'  => 'sqlite3',
          'HOST'     => '127.0.0.1:3306',
          'NAME'     => 'gitea',
          'USER'     => 'root',
          'PASSWD'   => '',
          'SSL_MODE' => 'disable',
          'PATH'     => '/opt/gitea/data/gitea.db',
        },
        'security'   => {
          'SECRET_KEY'   => 'thesecretkey',
          'INSTALL_LOCK' => true,
        },
        'service'    => {
          'REGISTER_EMAIL_CONFIRM' => false,
          'ENABLE_NOTIFY_MAIL'     => false,
          'DISABLE_REGISTRATION'   => false,
          'ENABLE_CAPTCHA'         => true,
          'REQUIRE_SIGNIN_VIEW'    => false,
        },
        'repository' => {
          'ROOT'     => '/var/git',
        },
        'mailer'     => {
          'ENABLED' => false,
        },
        'picture'    => {
          'DISABLE_GRAVATAR'        => false,
          'ENABLE_FEDERATED_AVATAR' => true,
        },
        'session'    => {
          'PROVIDER' => 'file',
        },
        'indexer'    => {
          'REPO_INDEXER_ENABLED' => true,
        },
        'log'        => {
          'MODE'      => 'file',
          'LEVEL'     => 'info',
          'ROOT_PATH' => '/opt/gitea/log',
        },
        'webhook'    => {
          'SKIP_TLS_VERIFY' => true,
        },
      }
  }

  firewall{ '100 allow web connections':
    proto  => 'tcp',
    dport  => 3000,
    action => accept,
  }
}
