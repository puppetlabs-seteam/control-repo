# Add cd4pe and gitlab IP addresses using puppetdb query
class profile::app::cd4pe_buildserver::hosts {

  $master_server = $::settings::server

  $cd4pe_query = "facts[value]{ name in ['ipaddress_enp0s8',  'ipaddress_eth0']
    and certname in resources[certname] { trusted.extensions.pp_role = "puppetmaster" } }"

  $cd4pe_ip = puppetdb_query($cd4pe_query)[0]['value']

  host { 'cd4pe.pdx.puppet.vm':
    ensure       => 'present',
    ip           => $cd4pe_ip,
    host_aliases => ['cd4pe', 'gitlab.pdx.puppet.vm', 'gitlab'],
  }

}
