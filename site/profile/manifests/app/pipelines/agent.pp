class profile::app::pipelines::agent (
  String $access_token,
  String $secret_key,
  String $download_url,
){

#  if ($access_token == 'ENTER_VALUE') or ($access_token == 'fake'){
#    fail('You must enter access_token, secret_key, and download_url if you want to install the Pipelines agent.')
#  }

  class { '::pipelines::agent':
    access_token => Sensitive($access_token),
    secret_key   => Sensitive($secret_key),
    download_url => $download_url,
    start_agent  => true,
  }

  case $::kernel {
    'Linux':   {  $distell_agent_location = '/usr/local/bin/distelli-download' }
    'windows': {  $distell_agent_location = 'C:/Program Files/Distelli/distelli-download.ps1' }
    default:   { fail('Unsupported OS') }
  }

  File <| title == $distell_agent_location |> {
    replace => false,
  }

}
