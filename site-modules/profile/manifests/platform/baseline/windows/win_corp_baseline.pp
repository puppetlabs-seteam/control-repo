class profile::platform::baseline::windows::win_corp_baseline {


      registry::value { 'Security item #14 - LegalNoticeText':
        key   => 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System',
        value => 'LegalNoticeText',
        data  => 'This system may only be accessed by authorized users. By using this system you agree that COMPANY and its authorized agents may monitor, intercept, read, copy, capture and record any data and communications that occur on COMPANY IT Resources (including email and other electronic traffic to and from the Internet).',
      }
    
      registry::value { 'Security item #15 - LegalNoticeCaption':
        key   => 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System',
        value => 'LegalNoticeCaption',
        data  => 'Warning',
      }
    
    
     registry::value { 'Security item #2 - AuditBaseObjects':
        key   => 'HKLM\SYSTEM\CurrentControlSet\Control\Lsa',
        value => 'AuditBaseObjects',
        data  => '0',
        type  => dword,
      }
    
      registry::value { 'Security item #3 - fullprivilegeauditing':
        key   => 'HKLM\SYSTEM\CurrentControlSet\Control\Lsa',
        value => 'fullprivilegeauditing',
        data  => '1',
        type  => binary,
      }
    
      registry_value { 'Security item #4 - scenoapplylegacyauditpolicy':
        path   => 'HKLM\SYSTEM\CurrentControlSet\Control\Lsa\scenoapplylegacyauditpolicy',
        ensure => absent,
      }
    
      registry::value { 'Security item #5 - crashonauditfail':
        key   => 'HKLM\SYSTEM\CurrentControlSet\Control\Lsa',
        value => 'crashonauditfail',
        data  => '0',
        type  => dword,
      }
    
      registry_value { 'Security item #6 - MachineAccessRestriction':
        path   => 'HKLM\SOFTWARE\policies\Microsoft\windows NT\DCOM\MachineAccessRestriction',
        ensure => absent,
      }
    
      registry::value { 'Security item #7 - MachineLaunchRestriction':
        key   => 'HKLM\SOFTWARE\policies\Microsoft\windows NT\DCOM',
        value => 'MachineLaunchRestriction'
      }
}