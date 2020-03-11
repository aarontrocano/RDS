<#
    (Get-Command C:\Windows\System32\TSpkg.dll).Version.toString()
#>
Write-Host ('See the following article for details.  https://support.microsoft.com/en-us/help/4295591/credssp-encryption-oracle-remediation-error-when-to-rdp-to-azure-vm' )
#$hostname = 'host01.example.com'
$collection = 'host17.example.com','host15.example.com','host16.amtrustservices.com','host17.amtrustservices.com','host18.amtrustservices.com'
foreach ($hostname in $collection) {
    $Name = ('\\' + $hostname + '\admin$\system32\TSpkg.dll')
    if ( Test-Path $Name -PathType Leaf ) { 
        $Version = (Get-Command $Name).Version.toString() 
        [pscustomobject]@{
            Name = $Name
            Version = $Version
        }
    }
}