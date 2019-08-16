# configure puppet device
class profile::infrastructure::network::device_manager {
  include panos
  include device_manager::devices
}
