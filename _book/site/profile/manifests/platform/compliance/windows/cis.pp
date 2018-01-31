class profile::compliance::windows::cis {

  # CIS Microsoft Windows Server 2012 R2 v2.2.0 04-28-2016
  # https://benchmarks.cisecurity.org/tools2/windows/CIS_Microsoft_Windows_Server_2012_R2_Benchmark_v2.2.0.pdf

  # 1.1.2 (L1) Ensure 'Maximum password age' is set to '60 or fewer days, but not 0' (Scored)
  local_security_policy { 'Maximum password age':
    ensure => present,
    policy_value => '40',
  }

  # 1.1.1 (L1) Ensure 'Enforce password history' is set to '24 or more password(s)' (Scored)
  local_security_policy { 'Enforce password history':
    ensure => present,
    policy_value => '60',
  }

  # 9.1.1 (L1) Ensure 'Windows Firewall: Domain: Firewall state' is set to 'On (recommended)' (Scored)
  # 9.2.1 (L1) Ensure 'Windows Firewall: Private: Firewall state' is set to 'On (recommended)' (Scored)
  # 9.3.1 (L1) Ensure 'Windows Firewall: Public: Firewall state' is set to 'On (recommended)' (Scored)
  service {'MpsSvc':
    ensure   => 'running',
    enable   => 'true',
  }

  registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\EnableFirewall':
    type   => dword,
    data   => '1',
    notify => Service['MpsSvc'],
  }

  registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\EnableFirewall':
    type   => dword,
    data   => '1',
    notify => Service['MpsSvc'],
  }

  registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile\EnableFirewall':
    type   => dword,
    data   => '1',
    notify => Service['MpsSvc'],
  }

  # 18.9.48.3.3.1 (L2) Ensure 'Do not allow COM port redirection' is set to 'Enabled' (Scored)
  registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\fDisableCcm':
    type   => dword,
    data   => '1',
  }

  # 18.9.48.3.3.2 (L1) Ensure 'Do not allow drive redirection' is set to 'Enabled' (Scored)
  registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\fDisableCdm':
    type   => dword,
    data   => '1',
  }

  # 19.6.5.1.1 (L2) Ensure 'Turn off Help Experience Improvement Program' is set to 'Enabled' (Scored)
  registry_value { 'HKEY_LOCAL_MACHINE\Software\Microsoft\SQMClient\Windows\CEIPEnable':
    type   => dword,
    data   => '0',
  }
}
