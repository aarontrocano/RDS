Remove-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters -Name 'AllowEncryptionOracle'
start-sleep  -m 500
Remove-Item -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP -Name Parameters
start-sleep  -m 500
Remove-Item -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name CredSSP 
write-host "You're good to go..."
Pause