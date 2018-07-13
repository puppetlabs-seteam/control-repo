# @summary This profile installs a sample website
class profile::app::sample_website {

  case $::kernel {
    'windows': { include profile::app::sample_website::windows }
    'Linux':   { include profile::app::sample_website::linux }
    default:   {
      fail('Unsupported kernel detected')
    }
  }

}
