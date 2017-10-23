# @summary This profile installs a sample website
class profile::app::sample_website {

  case $::kernel {
    'windows': {
      if $::iis_version == "8.5" { include profile::app::sample_website::windows }
      else { fail('Unsupported kernel detected') }
    }
    'Linux':   { include profile::app::sample_website::linux   }
    default:   {
      fail('Unsupported kernel detected')
    }
  }

}
