Import-Module RemoteDesktop
$samid = (Get-Content -Path ([Environment]::GetFolderPath("Desktop")+'\user.txt')).trimend()
$ServerFQDN = 'BR01.example.com'
$hostcollection = @() ; Write-Host ('Retrieving RDS User login information for ' + $samid + ' from broker ' + $ServerFQDN + ' ....')
$hostcollection = Get-RDUserSession -ConnectionBroker $ServerFQDN  | Where-Object UserName -match $samid | Select-Object HostServer,UnifiedSessionId ; Write-Host ('Retrieved!') ; if ($null -eq $hostcollection.HostServer) {Write-Host ('Nothing to do!')} else {foreach ($h in $hostcollection) {Write-Host ('Session host: ' + $h.HostServer + ' ID: ' + $h.UnifiedSessionId + ' samid: ' + $samid)} }
$scriptBlockGetUserProcess = {param ([string]$strSamid) Get-Process -IncludeUserName | Where-Object UserName -match $strSamid | Select-Object ProcessName,Id,SessionId,UserName }
$scriptBlockGetNTAuthorityProcess = {param ([string]$strSessionId,[string]$strProcessName) Get-Process -Name $strProcessName -IncludeUserName | Where-Object {$_.SessionId -eq $strSessionId} | Select-Object ProcessName,Id,SessionId }
$scriptBlockStopProcess = {param ([int32]$Id) try {Stop-Process -Id $Id -Force -PassThru -ErrorAction Stop } catch {} }
ForEach ($h in $hostcollection) {
    $remotehost = $h.HostServer ; $rdssessionid = $h.UnifiedSessionId
    $Session2 = New-PSSession -ComputerName $remotehost -Credential $Credential -ConfigurationName Microsoft.PowerShell -Authentication Kerberos ; Write-Host ('Start terminating processes on: ' + $remotehost + ' Session: ' + $rdssessionid +' for: ' + $samid)
    for ($i=0; $i -lt 2; $i++) {
        $UserProcessCollection = Invoke-Command -Session $Session2 -ScriptBlock $scriptBlockGetUserProcess -ArgumentList $samid | Select-Object ProcessName,Id,SessionId,UserName
        $CsrssProcess = Invoke-Command -Session $Session2 -ScriptBlock $scriptBlockGetNTAuthorityProcess -ArgumentList $rdssessionid,'Csrss' | Select-Object ProcessName,Id,SessionId
        $WinlogonProcess = Invoke-Command -Session $Session2 -ScriptBlock $scriptBlockGetNTAuthorityProcess -ArgumentList $rdssessionid,'Winlogon' | Select-Object ProcessName,Id,SessionId
        $UserProcessCollection | Format-Table
        $CsrssProcess | Format-Table
        $WinlogonProcess | Format-Table
        ForEach ($p in $UserProcessCollection) {if ($p.ProcessName -ne 'wsmprovhost' ) {Invoke-Command -Session $Session2 -ScriptBlock $scriptBlockStopProcess -ArgumentList $p.Id } }
        ForEach ($p in $WinlogonProcess) {Invoke-Command -Session $Session2 -ScriptBlock $scriptBlockStopProcess -ArgumentList $p.Id}
        ForEach ($p in $CsrssProcess) {Invoke-Command -Session $Session2 -ScriptBlock $scriptBlockStopProcess -ArgumentList $p.Id}
    }
    Remove-PSSession $Session2 ; Write-Host ('Done terminating processes on: ' + $remotehost + ' Session: ' + $rdssessionid + ' for: ' + $samid)
}