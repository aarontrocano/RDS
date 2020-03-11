[string]$Appcollections = (Get-ADObject -Filter { ObjectClass -eq 'organizationalunit' } -SearchBase 'OU=Host,OU=North America,OU=RDS,OU=PROD,OU=Servers,OU=IT,DC=example,DC=com' | 
    Sort-Object distinguishedname |
    select-object @{N = "OUName"; E = {$_.distinguishedname.split(',')[0] -replace 'OU='}}).ouname
$array = $Appcollections.Split(' ') -join ','


[string[]]$arrStrAppcollections = Get-ADObject -Filter { ObjectClass -eq 'organizationalunit' } -SearchBase 'OU=Host,OU=North America,OU=RDS,OU=PROD,OU=Servers,OU=IT,DC=example,DC=com' | 
    Sort-Object name |
    select-object -expandproperty name


[string]$Appcollections = (Get-ADObject -Filter { ObjectClass -eq 'organizationalunit' } -SearchBase 'OU=Host,OU=North America,OU=RDS,OU=PROD,OU=Servers,OU=IT,DC=example,DC=com' | 
    Sort-Object distinguishedname |
    select-object @{N = "OUName"; E = {$_.distinguishedname.split(',')[0] -replace 'OU='}}).ouname
$array = $Appcollections.Split(' ') 
$array = $array | foreach-object {"'" + $_ + "'"}
$array -join ','


