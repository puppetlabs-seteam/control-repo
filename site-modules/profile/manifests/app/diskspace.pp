# Class: profile::app::diskspace
# Notifies when diskspace usage is over the given threshold
#
class profile::app::diskspace (
  $threshold = 80
){
  # resources
  $disks_to_check = [
    'diskspace_c',
    'diskspace_root',
  ]
  $disks_to_check.each |$disk| {
    unless $facts[$disk] == undef {
      if $facts[$disk] > $threshold {
        $drive = regsubst($disk, '^diskspace_([a-z]+)$', '\1')
        notify { "Disk usage exceeded threshold: ${drive} usage at ${facts[$disk]}% (threshold was ${threshold}%)": }
      }
    }
  }
}
