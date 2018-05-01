class profile::app::pipelines::agent (
  String $access_token = 'fake',
  String $secret_key = 'fake',
){

  if $::kernel == 'windows' {
    fail('Unsupported OS')
  }

  class { '::distelli::agent':
    access_token => Sensitive($access_token),
    secret_key   => Sensitive($secret_key),
  }

}
