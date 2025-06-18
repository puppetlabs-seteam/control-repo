# Modules from the Puppet Forge
# Versions should be updated to be the latest at the time you start

## Puppet Core Modules
mod 'puppetlabs-augeas_core', '1.5.0'
mod 'puppetlabs-host_core', '1.3.0'
mod 'puppetlabs-selinux_core', '1.4.0'
mod 'puppetlabs-sshkeys_core', '2.5.0'
mod 'puppetlabs-yumrepo_core', '2.1.0'
mod 'puppet-augeasproviders_core', '4.1.0'

# Base Library Modules
mod 'puppetlabs-concat', '9.1.0'
mod 'puppetlabs-inifile', '6.2.0'
mod 'puppetlabs-hocon', '2.0.0'
mod 'puppetlabs-exec', '3.1.0'
mod 'puppetlabs-ruby_task_helper', '1.0.0'
mod 'puppetlabs-ruby_plugin_helper', '0.3.0'
mod 'puppetlabs-stdlib', '9.7.0'
mod 'puppetlabs-transition', '2.0.0'
mod 'ipcrm-echo', '0.1.8'
mod 'puppet-hiera', '6.0.0'
#mod 'crayfishx-purge', '1.2.1' # Very likely unused. `purge` is now a default Puppet meta-parameter. Uncomment if needed, remove in a future revision.

## Package & Archive Management
mod 'puppetlabs-apt', '10.0.0'
mod 'puppetlabs-puppet_agent', '4.23.0'
mod 'puppet-yum', '7.3.0' # Required for CD4PE workshop
mod 'puppet-archive', '7.1.0'
mod 'puppet-zypprepo', '5.0.0'

## Puppet Application Specific Modules
mod 'puppetlabs-cd4pe_jobs', '1.7.1'
mod 'puppetlabs-comply', '3.4.0'
mod 'puppetlabs-puppet_authorization', '1.0.0'
mod 'puppetlabs-puppetserver_gem', '1.1.1'     # gem package provider for puppetserver specific gems

## Linux OS & Featrue Management Modules
mod 'puppetlabs-firewall', '8.1.3'
mod 'puppetlabs-ntp', '11.0.0'
mod 'puppet-chrony', '3.0.0'
mod 'bodgit-rngd', '3.0.1'  # potentially unused, review in a future revision
mod 'kogitoapp-ufw', '1.0.3'
mod 'saz-limits', '5.0.0'
mod 'ghoneycutt-ssh', '5.1.1'
mod 'puppet-epel', '5.0.0'
mod 'puppet-firewalld', '5.0.0'
mod 'puppet-logrotate', '8.0.0'
mod 'puppet-selinux', '4.1.0' # 5.0.0+ is available, however sce_linux requires '< 5.0.0', *might* work regardless, should be tested and updated, if so.
mod 'puppet-systemd', '8.1.0' # 8.1.0+ is available, however sce_linux requires '< 7.0.0', *might* work regardless, should be tested and updated, if so.
# mod 'nexcess-auditd', '4.2.0' # Part of `profile::compliance::hippa`. Likely unused. Uncomment if needed and run code deploy.

## Windows OS & Feature Management Modules
mod 'puppetlabs-acl', '5.0.2'
mod 'puppetlabs-dism', '1.3.1'
mod 'puppetlabs-iis', '10.0.1'
mod 'puppetlabs-powershell', '6.0.2'
mod 'puppetlabs-registry', '5.0.2'
mod 'dsc-networkingdsc', '9.0.0-0-8'
mod 'dsc-auditpolicydsc', '1.4.0-0-9'
mod 'dsc-securitypolicydsc', '2.10.0-0-9'
mod 'ayohrling-local_security_policy', '1.1.1'
mod 'webalex-windows_firewall', '1.7.0'
mod 'puppet-windowsfeature', '5.0.0'
#mod 'reidmv-unzip', '0.1.2' # likely unused. `puppet-archive` should support unzip for windows. Uncomment if needed.
#mod 'trlinkin-domain_membership', '1.1.2' # likley unused. DSC methods should be used currently. Uncomment if needed.

## Common OS & Feature Modules
mod 'puppetlabs-motd', '7.2.0'
mod 'puppetlabs-pwshlib', '1.2.2'

## Utility modules
mod 'puppetlabs-facter_task', '2.1.0'
mod 'puppetlabs-node_manager', '1.1.0'
mod 'puppetlabs-reboot', '5.0.0'
mod 'puppetlabs-vcsrepo', '6.1.0'
mod 'puppetlabs-node_encrypt', '3.1.0'
mod 'puppetlabs-nessus_transformer', '1.0.2'
mod 'artsir-ansible_config', '1.1.3'   # likely unused. Should be reviewed at a future revision. 
#mod 'puppetlabs-resource', '1.1.0'    # deprecated: likely unused. Uncomment if needed. Remove in future revision.
#mod 'puppetlabs-service', '3.1.0'     # likely ununsed, there is a service task already packaged with PE. Uncomment if needed.
#mod 'WhatsARanjit-diskspace', '0.2.0' # likely ununsed, there are core facts now available for this. Uncomment if needed.
#mod 'lwf-remote_file', '1.1.3'        # likely unused, Puppet's `file` resource type now allows HTTP sources. Uncomment if needed.
#mod 'puppet-staging', '3.2.0'         # Deprecated: Likely ununsed. Uncomment and run code deploy if needed.
#mod 'tse-time', '1.0.1'               # Likely ununsed. Uncomment and run code deploy if needed.
#mod 'tse-winntp', '1.0.1'             # Likely ununsed. Uncomment and run code deploy if needed.

## Application & Middleware Modules
mod 'puppetlabs-apache', '12.3.1'
mod 'puppetlabs-chocolatey', '8.0.2'
mod 'puppetlabs-docker', '10.3.0'
mod 'puppetlabs-haproxy', '8.2.0'
mod 'puppetlabs-java', '11.1.0'
mod 'puppetlabs-terraform', '0.7.1'
mod 'puppetlabs-tomcat', '7.4.0'
mod 'puppet-grafana', '14.1.0'
mod 'puppet-gitlab', '10.3.0'
mod 'puppet-nginx', '6.0.1'
mod 'puppet-php', '11.0.0'
mod 'puppet-prometheus', '16.3.1'
mod 'puppet-python', '7.4.0'

## ServiceNOW Integrations 
## NOTE: These are disabled by default, uncomment and run code deploy if needed for a specific demo
# mod 'puppetlabs-servicenow_reporting_integration', '1.0.0'
# mod 'puppetlabs-servicenow_change_requests', '0.4.1'
# mod 'puppetlabs-servicenow_cmdb_integration', '0.2.0'

## Splunk Integrations
## NOTE: These are disabled by default, uncomment and run code deploy if needed for a specific demo
# mod 'puppet-splunk', '10.0.0'
# mod 'puppetlabs-splunk_hec', '2.0.1'

