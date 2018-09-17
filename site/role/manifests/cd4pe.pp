# Class cd4pe
#
#
class role::cd4pe {
  include profile::platform::baseline::linux
  include profile::app::cd4pe
}
