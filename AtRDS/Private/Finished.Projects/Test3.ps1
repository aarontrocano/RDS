Get-Process -Name cmd -IncludeUserName | Where-Object UserName -match user

Get-Process -Name mstsc -IncludeUserName | Where-Object UserName -match user


Import-Module RemoteDesktop
Get-RDUserSession -CollectionName * | Select-Object servername,sessionid,username,domainname,serveripaddress,applicationtype,application name, createtime,sessionstate,collectionname,hostserver
Get-RDUserSession -ConnectionBroker $ServerFQDN -CollectionName * | Sort-Object -Property CollectionName 
Get-RDUserSession -ConnectionBroker $ServerFQDN -CollectionName * | Sort-Object -Property CollectionName | Select-Object -expandproperty CollectionName 
Get-RDRemoteApp -ConnectionBroker $ServerFQDN -CollectionName * 
<#--90 seconds run--#>
Get-RDSessionCollection -ConnectionBroker $ServerFQDN 
<#--336 seconds run--#>


$ServerFQDN = 'br01.example.com'
$Collection = 'Example01Apps'
$Collection = 'Example02Apps'
Get-RDUserSession -ConnectionBroker $ServerFQDN -CollectionName $Collection | Sort-Object -Property UserName
Get-RDUserSession -ConnectionBroker $ServerFQDN  | Where-Object UserName -match atrocano
Get-RDUserSession -ConnectionBroker $ServerFQDN  | Where-Object UserName -match radcox
Get-RDUserSession -ConnectionBroker $ServerFQDN  | Where-Object UserName -match cvijanovic
Get-RDUserSession -ConnectionBroker $ServerFQDN  | Where-Object UserName -match Tester77



Get-ADComputer -Filter {Name -Like '*BR0*'} | Select-Object -ExpandProperty DNSHostName
$ServerFQDN = 'BR01.example.com' <#jackpot#>
Get-RDRemoteApp -ConnectionBroker $ServerFQDN | Sort-Object -Property DisplayName | Select-Object -ExpandProperty DisplayName | Get-Unique | FT
$WarningPreference = 'SilentlyContinue'
Get-RDRemoteApp -ConnectionBroker $ServerFQDN | Sort-Object -Property DisplayName | Select-Object -ExpandProperty DisplayName | Get-Unique | Where-Object {($_ -like "S*")}
$samid = 

$hostcollection = @()
$hostcollection = Get-RDUserSession -ConnectionBroker $ServerFQDN  | Where-Object UserName -match user | Select-Object HostServer,UnifiedSessionId <#host-rdsh01.example.com#>
ForEach ($h in $hostcollection) {$h.HostServer} <#host-rdsh01.example.com#>


Invoke-Command -ComputerName $h.HostServer -ScriptBlock {Get-Process}
Invoke-Command -ComputerName $h.HostServer -ScriptBlock {Get-Process -Name mstsc -IncludeUserName | Where-Object UserName -match radcox}
ForEach ($h in $hostcollection) {Invoke-Command -ComputerName $h.HostServer -ScriptBlock {Get-Process -Name mstsc -IncludeUserName | Where-Object UserName -match radcox}}
ForEach ($h in $hostcollection) {Invoke-Command -ComputerName $h.HostServer -ScriptBlock {Get-Process -IncludeUserName | Where-Object UserName -match radcox}}
ForEach ($h in $hostcollection) {Invoke-Command -ComputerName $h.HostServer -ScriptBlock {Get-Process -IncludeUserName | Where-Object UserName -match radcox | Select-Object Id,ProcessName,UserName | Format-Table }}




$process = 'calc.exe'
Get-WmiObject -Class Win32_Process -Filter "Name= '$process'" -ComputerName $hostcollection.HostServer | Where-Object { $_.GetOwner().User -eq $samid } | ForEach-Object { $_.Terminate() }
ForEach ($p in $process) {Write-Host ('Killing: ' + $p) ; Get-WmiObject -Class Win32_Process -Filter "Name= '$p'" -ComputerName $hostcollection.HostServer | Where-Object { $_.GetOwner().User -eq $samid } | ForEach-Object { $_.Terminate() }}
Get-WmiObject -Class Win32_Process -Filter "Name= 'csrss.exe'" -ComputerName $hostcollection.HostServer | Where-Object { $_.SessionId -eq '7' }
Get-WmiObject -Class Win32_Process -Filter "Name= 'winlogon.exe'" -ComputerName $hostcollection.HostServer | Where-Object { $_.SessionId -eq '7' }



$objSession = New-PSSession -ComputerName $h.HostServer -Credential $Credential -ConfigurationName Microsoft.PowerShell -Authentication Kerberos -RunAsAdministrator
$objSession = New-PSSession -ComputerName $hostcollection.HostServer -Credential $Credential -ConfigurationName Microsoft.PowerShell -Authentication Kerberos -RunAsAdministrator
$scriptBlockGetProcess = {
    param (
        [string]$strSamid
    )
    <# 
    Get-Process -IncludeUserName | Where-Object UserName -match $strSamid | Select-Object Id,ProcessName,UserName
    #>
    Get-Process -IncludeUserName | Where-Object UserName -match $strSamid | Select-Object ProcessName,Id,SessionId,UserName
    <#Get-Process -Name csrss -IncludeUserName | Where-Object UserName -match $strSamid | Stop-Process -Force 
    Get-Process -Name winlogon -IncludeUserName | Where-Object UserName -match $strSamid | Stop-Process -Force 
    #>
}
$scriptBlockGetProcessCsrss = {param ([string]$strSessionId) Get-Process -Name csrss -IncludeUserName | Where-Object {$_.SessionId -eq $strSessionId} | Select-Object ProcessName,Id,SessionId }
$scriptBlockGetProcessWinlogon = {param ([string]$strSessionId) Get-Process -Name Winlogon -IncludeUserName | Where-Object {$_.SessionId -eq $strSessionId} | Select-Object ProcessName,Id,SessionId }
$scriptBlockStopProcess = {
    param (
        [int32]$Id
    )
    Stop-Process -Id $Id -Force -PassThru 
}


Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

WARNING: The names of some imported commands from the module 'tmp_klpszliz.onn' include unapproved verbs that might
make them less discoverable. To find the commands with unapproved verbs, run the Import-Module command again with the
Verbose parameter. For a list of approved verbs, type Get-Verb.

ModuleType Version    Name                                ExportedCommands
---------- -------    ----                                ----------------
Script     1.0        tmp_klpszliz.onn                    {Add-ADPermission, Add-AvailabilityAddressSpace, Add-Distr...


Loading personal and system profiles took 4899ms.
PS C:\WINDOWS\system32> $ServerFQDN = 'svnprdsbr01.amtrustservices.com'
PS C:\WINDOWS\system32> Get-RDUserSession -ConnectionBroker $ServerFQDN  | Where-Object UserName -match ncarter
PS C:\WINDOWS\system32> GEt-RDSessionCollection -ConnectionBroker $ServerFQDN

CollectionName                 Size  ResourceType       CollectionType    CollectionDescription
--------------                 ----  ------------       --------------    ---------------------
ExampleApps                    32    RemoteApp programs PooledUnmanaged
DevApps                        2     RemoteApp programs PooledUnmanaged
DemoApps                       1     RemoteApp programs PooledUnmanaged
LegalAppsTest                  1     RemoteApp programs PooledUnmanaged   Legal Apps New Servers Test


PS C:\WINDOWS\system32>






































Import-Module RemoteDesktop
$samid = (Get-Content -Path ([Environment]::GetFolderPath("Desktop")+'\user.txt')).trimend()
$ServerFQDN = 'br01.amtrustservices.com'
$hostcollection = @()
Write-Host ('Retrieving RDS User login information for ' + $samid + ' from broker ' + $ServerFQDN + ' ....')
$hostcollection = Get-RDUserSession -ConnectionBroker $ServerFQDN  | Where-Object UserName -match $samid | Select-Object HostServer,UnifiedSessionId
Write-Host ('Retrieved!')
if ($null -eq $hostcollection.HostServer) {
    Write-Host ('Nothing to do!')
} else {
    foreach ($h in $hostcollection) {
        Write-Host ('Session host: ' + $h.HostServer + ' ID: ' + $h.UnifiedSessionId + ' samid: ' + $samid)
    } 
}
$scriptBlockGetUserProcess = {
    param (
        [string]$strSamid
    ) 
    Get-Process -IncludeUserName | Where-Object UserName -match $strSamid | Select-Object ProcessName,Id,SessionId,UserName 
}
$scriptBlockGetNTAuthorityProcess = {
    param (
        [string]$strSessionId,
        [string]$strProcessName
    ) 
    Get-Process -Name $strProcessName -IncludeUserName | Where-Object {$_.SessionId -eq $strSessionId} | Select-Object ProcessName,Id,SessionId 
}
$scriptBlockStopProcess = {
    param (
        [int32]$Id
    ) 
    Stop-Process -Id $Id -Force -PassThru 
}
ForEach ($h in $hostcollection) {
    $remotehost = $h.HostServer 
    $rdssessionid = $h.UnifiedSessionId
    $Session2 = New-PSSession -ComputerName $remotehost -Credential $Credential -ConfigurationName Microsoft.PowerShell -Authentication Kerberos
    Write-Host ('Start terminating processes on: ' + $remotehost + ' Session: ' + $rdssessionid +' for: ' + $samid)
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
    Remove-PSSession $Session2
    Write-Host ('Done terminating processes on: ' + $remotehost + ' Session: ' + $rdssessionid + ' for: ' + $samid)
}