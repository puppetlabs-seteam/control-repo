#
forge 'http://forge.puppetlabs.com'

def default_branch(default)
  begin
    match = /(.+)_(cdpe|cdpe_ia)_\d+$/.match(@librarian.environment.name)
    match ? match[1]:default
  rescue
    default
  end
end

# Modules from the Puppet Forge
# Versions should be updated to be the latest at the time you start
mod 'puppetlabs-acl', '2.1.0'
mod 'puppetlabs-apache', '4.0.0'
mod 'puppetlabs-apt', '6.3.0'
mod 'puppetlabs-aws', '2.1.0'
mod 'puppetlabs-azure', '1.3.1'
mod 'puppetlabs-bolt_shim', '0.3.0'
mod 'puppetlabs-cd4pe', '1.3.0'
mod 'puppetlabs-chocolatey', '3.3.0'
mod 'puppetlabs-cisco_ios', '1.0.0'
mod 'puppetlabs-ciscopuppet', '2.0.1'
mod 'puppetlabs-concat', '5.3.0'
mod 'puppetlabs-device_manager', '3.0.0'
mod 'puppetlabs-dism', '1.3.1'
mod 'puppetlabs-docker', '3.5.0'
mod 'puppetlabs-dsc', '1.8.0'
mod 'puppetlabs-exec', '0.3.0'
mod 'puppetlabs-facter_task', '0.4.0'
mod 'puppetlabs-firewall', '2.1.0'
mod 'puppetlabs-gcc', '0.3.0'
mod 'puppetlabs-git', '0.5.0'
mod 'puppetlabs-haproxy', '3.0.1'
mod 'puppetlabs-hocon', '1.0.1'
mod 'puppetlabs-iis', '4.5.0'
mod 'puppetlabs-inifile', '2.5.0'
mod 'puppetlabs-java', '3.3.0'
mod 'puppetlabs-limits', '0.1.0'
mod 'puppetlabs-motd', '2.1.2'
mod 'puppetlabs-mount_iso', '2.0.0'
mod 'puppetlabs-mysql', '8.0.1'
mod 'puppetlabs-netdev_stdlib', '0.18.0'
mod 'puppetlabs-ntp', '7.4.0'
mod 'puppetlabs-panos', '1.2.1'
mod 'puppetlabs-pipelines', '1.0.0'
mod 'puppetlabs-powershell', '2.2.0'
mod 'puppetlabs-puppet_authorization', '0.5.0'
mod 'puppetlabs-puppetserver_gem', '1.1.1'
mod 'puppetlabs-reboot', '2.1.2'
mod 'puppetlabs-registry', '2.1.0'
mod 'puppetlabs-resource', '0.1.0'
mod 'puppetlabs-resource_api', '1.1.0'
mod 'puppetlabs-service', '0.5.0'
mod 'puppetlabs-splunk_hec', '0.6.0'
mod 'puppetlabs-sqlserver', '2.4.0'
mod 'puppetlabs-stdlib', '5.2.0'
mod 'puppetlabs-tomcat', '2.5.0'
mod 'puppetlabs-transition', '0.1.1'
mod 'puppetlabs-translate', '1.2.0'
mod 'puppetlabs-vcsrepo', '2.4.0'

# Forge Community Modules
mod 'WhatsARanjit-node_manager', '0.7.1'
mod 'WhatsARanjit-diskspace', '0.2.0'
mod 'ajjahn-samba', '0.5.0'
mod 'andulla-vsphere_conf', '0.0.9'
mod 'puppet-redis', '4.0.0'
mod 'aristanetworks-eos', '1.5.0'
mod 'aristanetworks-netdev_stdlib_eos', '1.2.0'
mod 'ayohrling-local_security_policy', '0.6.3'
mod 'biemond-wildfly', '2.3.2'
mod 'bodgit-rngd', '2.0.2'
mod 'camptocamp-systemd', '2.2.0'
mod 'computology-packagecloud', '0.3.2'
mod 'crayfishx-purge', '1.2.1'
mod 'cyberious-pget', '1.1.0'
mod 'cyberious-windows_java', '1.0.2'
mod 'ghoneycutt-ssh', '3.59.0'
mod 'herculesteam-augeasproviders_core', '2.4.0'
mod 'herculesteam-augeasproviders_ssh', '3.2.1'
mod 'herculesteam-augeasproviders_sysctl', '2.3.1'
mod 'hunner-wordpress', '1.0.0'
mod 'ipcrm-echo', '0.1.6'
mod 'puppet-selinux', '1.6.1'
mod 'jonono-auditpol', '0.1.2'
mod 'jpadams-puppet_vim_env', '2.3.0' # There is a bug in 2.4.1
mod 'jriviere-windows_ad', '0.3.2'
mod 'kogitoapp-gitea', '1.0.4'
mod 'lwf-remote_file', '1.1.3'
mod 'puppet-wget', '2.0.1'
mod 'puppet-php', '6.0.2'
mod 'nexcess-auditd', '2.0.0'
mod 'puppet-archive', '3.2.1'
mod 'puppet-gitlab', '3.0.2'
mod 'puppet-hiera', '3.3.4'
mod 'puppet-nginx', '0.16.0'
mod 'puppet-rabbitmq', '9.0.0'
# mod 'puppet-splunk', '7.3.0'    # Can't use as 7.3.0 is broken
mod 'puppet-staging', '3.2.0'
mod 'puppet-windows_env', '3.2.0'
mod 'puppet-windows_firewall', '2.0.2'
mod 'puppet-windowsfeature', '3.2.2'
mod 'reidmv-unzip', '0.1.2'
mod 'sensu-sensu', '2.63.0'
mod 'stahnma-epel', '1.3.1'
mod 'puppet-python', '2.2.2'
mod 'thias-sysctl', '1.0.6'
mod 'trlinkin-domain_membership', '1.1.2'
mod 'tse-time', '1.0.1'
mod 'tse-winntp', '1.0.1'
mod 'yelp-uchiwa', '2.1.0'
mod 'abuxton-pdk', '0.2.0'
mod 'jdowning-rbenv', '2.4.0'
mod 'tkishel-system_gem', '1.1.1'
mod 'puppetlabs-yumrepo_core', '1.0.3'
mod 'puppetlabs-sshkeys_core', '1.0.2'
mod 'puppetlabs-selinux_core', '1.0.2'
mod 'puppetlabs-augeas_core', '1.0.4'
mod 'puppetlabs-host_core', '1.0.2'

# replaces mod 'puppet-splunk', '7.3.0' until there is a newer release
mod 'splunk',
    git: 'https://github.com/voxpupuli/puppet-splunk.git',
    ref: 'master'

mod 'tse-tse_facts',
    git: 'https://github.com/puppetlabs/tse-module-tse_facts.git',
    ref: '638abef'

mod 'demo_cis',
    git: 'https://github.com/ipcrm/ipcrm-demo_cis.git',
    ref: '4e6b63b'

mod 'rgbank',
    git:            'https://github.com/puppetlabs-seteam/puppetlabs-rgbank.git',
    branch:         :control_branch,
    default_branch: default_branch('master')

mod 'jenkins',
    git: 'https://github.com/jenkinsci/puppet-jenkins.git',
    ref: '6886819'

mod 'netstat',
    git: 'https://github.com/ipcrm/ipcrm-netstat.git',
    ref: '64bcee0'
