###

$pswindow = $host.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 300
$newsize.width = 200
$pswindow.Set_BufferSize($newsize)

###

Function Get-RegValue {
    [CmdletBinding()]
    Param
    (
        # Registry Path
        [Parameter(Mandatory = $true,
            Position = 0)]
        [string]
        $RegPath,

        # Registry Name
        [Parameter(Mandatory = $true,
            Position = 1)]
        [string]
        $RegName
    )
    $regItem = Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction Ignore
    $output = "" | select Path, Name, Value
    $output.Path = $RegPath
    $output.Name = $RegName

    If ($regItem -eq $null) {
        $output.Value = "-1" #Not Found
    }
    Else {
        $output.Value = $regItem.$RegName
    }
    $output
}

$regSettings = @()
$regKey = 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319'
$regSettings += Get-RegValue $regKey 'SystemDefaultTlsVersions'
$regSettings += Get-RegValue $regKey 'SchUseStrongCrypto'

$regKey = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319'
$regSettings += Get-RegValue $regKey 'SystemDefaultTlsVersions'
$regSettings += Get-RegValue $regKey 'SchUseStrongCrypto'

$regKey = 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727'
$regSettings += Get-RegValue $regKey 'SystemDefaultTlsVersions'
$regSettings += Get-RegValue $regKey 'SchUseStrongCrypto'

$regKey = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727'
$regSettings += Get-RegValue $regKey 'SystemDefaultTlsVersions'
$regSettings += Get-RegValue $regKey 'SchUseStrongCrypto'


$osVersion = (get-ciminstance Win32_OperatingSystem).caption


# Default for all Servers
############################## TLS 1.2 SERVER ##############################
$regKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server'
$regSettings += Get-RegValue $regKey 'Enabled'
$regSettings += Get-RegValue $regKey 'DisabledByDefault'
if ((Get-RegValue $regKey 'Enabled').Value -eq "-1" -and
    (Get-RegValue $regKey 'DisabledByDefault').Value -eq "-1") { 
        # Windows 11 = Default ON
        $tls12s = 1
 } elseif ((Get-RegValue $regKey 'Enabled').Value -ge "1" -and
           (Get-RegValue $regKey 'DisabledByDefault').Value -ne "1") { 
        # Manually turned on
        $tls12s = 1
 } elseif ((Get-RegValue $regKey 'Enabled').Value  -eq "0" -and 
           (Get-RegValue $regKey 'DisabledByDefault').Value  -eq "1") { 
        # Off
        $tls12s = 0
 } else {
    # Unknown
    $tls12s = 3
 }

$regKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client'
$regSettings += Get-RegValue $regKey 'Enabled'
$regSettings += Get-RegValue $regKey 'DisabledByDefault'
if ((Get-RegValue $regKey 'Enabled').Value -eq "-1" -and
    (Get-RegValue $regKey 'DisabledByDefault').Value -eq "-1") { 
        # Windows 11 = Default ON
        $tls12c = 1
 } elseif ((Get-RegValue $regKey 'Enabled').Value -ge "1" -and
           (Get-RegValue $regKey 'DisabledByDefault').Value -ne "1") { 
        # Manually turned on
        $tls12c = 1
 } elseif ((Get-RegValue $regKey 'Enabled').Value  -eq "0" -and 
           (Get-RegValue $regKey 'DisabledByDefault').Value  -eq "1") { 
        # Off
        $tls12c = 0
 } else {
    # Unknown
    $tls12c = 3
 }

############################## TLS 1.1 SERVER ##############################
$regKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server'
$regSettings += Get-RegValue $regKey 'Enabled'
$regSettings += Get-RegValue $regKey 'DisabledByDefault'
if ((Get-RegValue $regKey 'Enabled').Value -eq "-1" -and
    (Get-RegValue $regKey 'DisabledByDefault').Value -eq "-1") { 
        # Windows 11 = Default ON
        $tls11s = 1
 } elseif ((Get-RegValue $regKey 'Enabled').Value -ge "1" -and
           (Get-RegValue $regKey 'DisabledByDefault').Value -ne "1") { 
        # Manually turned on
        $tls11s = 1
 } elseif ((Get-RegValue $regKey 'Enabled').Value  -eq "0" -and 
           (Get-RegValue $regKey 'DisabledByDefault').Value  -eq "1") { 
        # Off
        $tls11s = 0
 } else {
    # Unknown
    $tls11s = 3
 }

$regKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client'
$regSettings += Get-RegValue $regKey 'Enabled'
$regSettings += Get-RegValue $regKey 'DisabledByDefault'
if ((Get-RegValue $regKey 'Enabled').Value -eq "-1" -and
    (Get-RegValue $regKey 'DisabledByDefault').Value -eq "-1") { 
        # Windows 11 = Default ON
        $tls11c = 1
 } elseif ((Get-RegValue $regKey 'Enabled').Value -ge "1" -and
           (Get-RegValue $regKey 'DisabledByDefault').Value -ne "1") { 
        # Manually turned on
        $tls11c = 1
 } elseif ((Get-RegValue $regKey 'Enabled').Value  -eq "0" -and 
           (Get-RegValue $regKey 'DisabledByDefault').Value  -eq "1") { 
        # Off
        $tls11c = 0
 } else {
    # Unknown
    $tls11c = 3
 }
############################## TLS 1.0 SERVER ##############################
$regKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server'
$regSettings += Get-RegValue $regKey 'Enabled'
$regSettings += Get-RegValue $regKey 'DisabledByDefault'
if ((Get-RegValue $regKey 'Enabled').Value -eq "-1" -and
    (Get-RegValue $regKey 'DisabledByDefault').Value -eq "-1") { 
        # Windows 11 = Default ON
        $tls10s = 1
 } elseif ((Get-RegValue $regKey 'Enabled').Value -ge "1" -and
           (Get-RegValue $regKey 'DisabledByDefault').Value -ne "1") { 
        # Manually turned on
        $tls10s = 1
 } elseif ((Get-RegValue $regKey 'Enabled').Value  -eq "0" -and 
           (Get-RegValue $regKey 'DisabledByDefault').Value  -eq "1") { 
        # Off
        $tls10s = 0
 } else {
    # Unknown
    $tls10s = 3
 }

$regKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client'
$regSettings += Get-RegValue $regKey 'Enabled'
$regSettings += Get-RegValue $regKey 'DisabledByDefault'
if ((Get-RegValue $regKey 'Enabled').Value -eq "-1" -and
    (Get-RegValue $regKey 'DisabledByDefault').Value -eq "-1") { 
        # Windows 11 = Default ON
        $tls10c = 1
 } elseif ((Get-RegValue $regKey 'Enabled').Value -ge "1" -and
           (Get-RegValue $regKey 'DisabledByDefault').Value -ne "1") { 
        # Manually turned on
        $tls10c = 1
 } elseif ((Get-RegValue $regKey 'Enabled').Value  -eq "0" -and 
           (Get-RegValue $regKey 'DisabledByDefault').Value  -eq "1") { 
        # Off
        $tls10c = 0
 } else {
    # Unknown
    $tls10c = 3
 }


############################## SERVER 2008 / 2012 SPECIALS ##############################
if ($osVersion -match "Server 2012" -or $osVersion -match "Server 2008" -or $osVersion -match "Server 2016" -or $osVersion -match "Server 2019") {
   ############################## TLS 1.3 SERVER ##############################
   $regKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Server'
   $regSettings += Get-RegValue $regKey 'Enabled'
   $regSettings += Get-RegValue $regKey 'DisabledByDefault' 
   if ((Get-RegValue $regKey 'Enabled').Value -eq "-1" -and
      (Get-RegValue $regKey 'DisabledByDefault').Value -eq "-1") { 
         # Not found # Windows 2008 = Default OFF
         # Windows 11 = Default ON
         $tls13s = 0
   } elseif ((Get-RegValue $regKey 'Enabled').Value -ge "1" -and
            (Get-RegValue $regKey 'DisabledByDefault').Value -ne "1") { 
         # Manually turned on
         $tls13s = 1
   } elseif ((Get-RegValue $regKey 'Enabled').Value  -eq "0" -and 
      (Get-RegValue $regKey 'DisabledByDefault').Value  -eq "1") { 
   # Off
   $tls13s = 0
   } else {
      # Unknown
      $tls13s = 3
   }
   ############################## TLS 1.3 CLIENT ##############################
   $regKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client'
   $regSettings += Get-RegValue $regKey 'Enabled'
   $regSettings += Get-RegValue $regKey 'DisabledByDefault'
   if ((Get-RegValue $regKey 'Enabled').Value -eq "-1" -and
   (Get-RegValue $regKey 'DisabledByDefault').Value -eq "-1") { 
      # Not found # Windows 2008 = Default OFF
      # Windows 11 = Default ON
      $tls13c = 0
   } elseif ((Get-RegValue $regKey 'Enabled').Value -ge "1" -and
            (Get-RegValue $regKey 'DisabledByDefault').Value -ne "1") { 
         # Manually turned on
         $tls13c = 1
   } elseif ((Get-RegValue $regKey 'Enabled').Value  -eq "0" -and 
      (Get-RegValue $regKey 'DisabledByDefault').Value  -eq "1") { 
   # Off
   $tls13c = 0
   } else {
      # Unknown
      $tls13c = 3
   }
}

############################## SERVER 2022 / WIN 11 SPECIALS ##############################
if ($osVersion -match "Windows 11" -or $osVersion -match "Server 2022") {
   ############################## TLS 1.3 SERVER ##############################
   $regKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Server'
   $regSettings += Get-RegValue $regKey 'Enabled'
   $regSettings += Get-RegValue $regKey 'DisabledByDefault' 
   if ((Get-RegValue $regKey 'Enabled').Value -eq "-1" -and
       (Get-RegValue $regKey 'DisabledByDefault').Value -eq "-1") { 
           # Windows 11 = Default ON
           $tls13s = 1
    } elseif ((Get-RegValue $regKey 'Enabled').Value -ge "1" -and
              (Get-RegValue $regKey 'DisabledByDefault').Value -ne "1") { 
           # Manually turned on
           $tls13s = 1
    } elseif ((Get-RegValue $regKey 'Enabled').Value  -eq "0" -and 
              (Get-RegValue $regKey 'DisabledByDefault').Value  -eq "1") { 
           # Off
           $tls13s = 0
    } else {
       # Unknown
       $tls13s = 3
    }
   ############################## TLS 1.3 CLIENT ##############################
   $regKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client'
   $regSettings += Get-RegValue $regKey 'Enabled'
   $regSettings += Get-RegValue $regKey 'DisabledByDefault'
   if ((Get-RegValue $regKey 'Enabled').Value -eq "-1" -and
       (Get-RegValue $regKey 'DisabledByDefault').Value -eq "-1") { 
           # Windows 11 = Default ON
           $tls13c = 1
    } elseif ((Get-RegValue $regKey 'Enabled').Value -ge "1" -and
              (Get-RegValue $regKey 'DisabledByDefault').Value -ne "1") { 
           # Manually turned on
           $tls13c = 1
    } elseif ((Get-RegValue $regKey 'Enabled').Value  -eq "0" -and 
              (Get-RegValue $regKey 'DisabledByDefault').Value  -eq "1") { 
           # Off
           $tls13c = 0
    } else {
       # Unknown
       $tls13c = 3
    }
}

Write-Host("<<<win_tls_status:sep(124)>>>")
Write-Host("Protocol|Server|Client")
Write-Host "TLS1_3|$tls13s|$tls13c";
Write-Host "TLS1_2|$tls12s|$tls12c";
Write-Host "TLS1_1|$tls11s|$tls11c";
Write-Host "TLS1_0|$tls10s|$tls10c";