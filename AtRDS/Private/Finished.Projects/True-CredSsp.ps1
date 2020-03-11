New-Item -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name CredSSP 
start-sleep  -m 500
New-Item -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP -Name Parameters 
start-sleep  -m 500
New-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters -PropertyType DWORD -Name 'AllowEncryptionOracle' -Value 2 
write-host "You're good to go..."
Pause
