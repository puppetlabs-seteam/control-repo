# configure puppet device
class profile::infrastructure::network::device_manager(
  Hash $devices = {},
) {

  include cisco_ios

  $defaults = {
    'port' => 22,
  }

  $devices.each | $device, $parameters | {
    # merge defaults and parameters hashes,
    # parameters having precedence
    $creds = $defaults + $parameters

    device_manager { $device:
      type        => 'cisco_ios',
      credentials => $creds,
    }
  }
}
