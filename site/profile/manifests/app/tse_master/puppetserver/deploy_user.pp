class profile::app::tse_master::puppetserver::deploy_user (
  String $deploy_username = 'code_mgr_deploy_user',
  String $deploy_password = 'puppetlabs',
  String $deploy_key_dir = '/etc/puppetlabs/puppetserver/ssh',
  String $deploy_key_file = "${deploy_key_dir}/id-control_repo.rsa",
  String $deploy_token_dir = '/etc/puppetlabs/puppetserver/.puppetlabs',
  String $deploy_token_file = "${deploy_token_dir}/token",
) {
  # This include dependency is because of
  # File["${deploy_key_dir}/demo_id.rsa.pub"]. When that resource is cleaned up
  # we should be able to remove the include.
  include profile::app::tse_master::puppetserver::demo_user

  # deploy user's ssh keys
  file { $deploy_key_dir:
    ensure => directory,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0700',
  }

  # In 2017.2 Puppet takes over this file before we run, hence we have to override the existing empty file
  exec { "create ${deploy_username} ssh key":
    command => "/bin/yes | /usr/bin/ssh-keygen -t rsa -b 2048 -C '${deploy_username}' -f ${deploy_key_file} -q -N ''",
    unless  => "/bin/test -s ${deploy_key_file} > /dev/null 2>&1",
    require => File[$deploy_key_dir],
  }

  # The puppet_enterprise module delcares a file resource that ensures the
  # permissions and owner of $deploy_key_file are correct so we won't manage it
  # here.

  # public key
  # (the puppet_enterprise module doesn't manage the public key)
  file { "${deploy_key_file}.pub":
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0644',
    require => Exec["create ${deploy_username} ssh key"],
  }

  # copy of public key where profile::gitlab can grab it with file function
  # whaaaaaaaaat..... this probably needs refactoring. Why is the pubkey a copy
  # of some user's key???
  file { "${deploy_key_dir}/demo_id.rsa.pub":
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0644',
    source  => "${profile::app::tse_master::puppetserver::demo_user::demo_key_file}.pub",
    require => File["${profile::app::tse_master::puppetserver::demo_user::demo_key_file}.pub"],
  }

  $ruby_mk_deploy_user = epp('profile/create_user_role.rb.epp', {
    'username'    => $deploy_username,
    'password'    => $deploy_password,
    'rolename'    => 'Deploy Environments',
    'touchfile'   => '/opt/puppetlabs/puppet/cache/tse_deploy_user_created',
    'permissions' => [
      { 'action'      => 'deploy_code',
        'instance'    => '*',
        'object_type' => 'environment',
      },
    ],
  })

  exec { 'create deploy user and role':
    command => "/opt/puppetlabs/puppet/bin/ruby -e shellquote(${ruby_mk_deploy_user})",
    creates => '/opt/puppetlabs/puppet/cache/tse_deploy_user_created',
  }

  exec { "create ${deploy_username} rbac token":
    command => "/bin/echo shellquote(${deploy_password}) | \
                 /opt/puppetlabs/bin/puppet-access login \
                 --username ${deploy_username} \
                 --service-url https://${clientcert}:4433/rbac-api \
                 --lifetime 1y \
                 --token-file ${deploy_token_file}",
    creates => $deploy_token_file,
    require => Exec['create deploy user and role'],
  }

  file { $deploy_token_dir:
    ensure  => directory,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0700',
    require => Exec["create ${deploy_username} rbac token"],
  }

  file { $deploy_token_file:
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0600',
    require => Exec["create ${deploy_username} rbac token"],
  }
}
