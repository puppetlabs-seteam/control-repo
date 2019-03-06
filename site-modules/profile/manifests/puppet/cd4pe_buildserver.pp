class profile::puppet::cd4pe_buildserver {
  case $facts['kernel'] {
    'Linux':   {  include ::profile::puppet::cd4pe_buildserver::linux }
    'windows': {  include ::profile::puppet::cd4pe_buildserver::windows }
    default:   { fail('Unsupported OS') }
  }
}
