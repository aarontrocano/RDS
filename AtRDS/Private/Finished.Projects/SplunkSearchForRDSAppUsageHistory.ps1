
<#--Splunk  Search String--#>
<#index=rds_processes Name = "Msaccess.exe" (Username != "Window Manager*" AND Username != "") (host = "HOST-RDSHMISC*")
| dedup Username,Name
| eval sAMAccountName = lower(substr(Username,9))
| join type=inner sAMAccountName [|inputlookup "AD.Users.LDAP.list.csv" |eval sAMAccountName = lower(sAMAccountName)]
| search userAccountControl != 514
| table _time,Name,sAMAccountName,host,displayName,department,physicalDeliveryOfficeName,l,st #>


<#index=rds_processes Name = "iexplore.exe" (Username != "Window Manager*" AND Username != "") (host = "HOST-RDSHMISC*")
| dedup Username,Name
| eval sAMAccountName = lower(substr(Username,9))
| join type=inner sAMAccountName [|inputlookup "AD.Users.LDAP.list.csv" |eval sAMAccountName = lower(sAMAccountName)]
| search userAccountControl != 514
| table _time,Name,sAMAccountName,host,displayName,department,physicalDeliveryOfficeName,l,st #>
