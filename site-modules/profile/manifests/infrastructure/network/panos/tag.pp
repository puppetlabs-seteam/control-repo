class profile::infrastructure::network::panos::tag (
  String $color = 'blue',
  String $comments = 'Default from manifest',
  String $ensure = 'present',
) {
  panos_tag { 'demo':
    ensure   => $ensure,
    color    => $color,
    comments => $comments,
  }
}