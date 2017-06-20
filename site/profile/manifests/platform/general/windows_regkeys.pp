class profile::platform::general::windows_regkeys {

  # CUSTOM APP REG KEYS
  registry_key { 'HKEY_LOCAL_MACHINE\Software\Demonstration':
    ensure       => present,
    purge_values => true,
  }

  registry_value { 'HKEY_LOCAL_MACHINE\Software\Demonstration\value1':
    type => string,
    data => 'this is a value new from puppet intro',
  }

  registry_value { 'HKEY_LOCAL_MACHINE\Software\Demonstration\value2':
    type => dword,
    data => '0xFFFFFFFF',
  }

}
