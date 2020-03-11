<#
.SYNOPSIS
This script finds a users UPD (User Profile Disk) and renames or deletes it based on the parameters
.DESCRIPTION
This script is meant for a select few members of the service desk.  Sometimes a UPD needs to be
renamed or deleted - essentially resetting their RDS profile - and that is what this script will do. 
It looks for the UPD in the locations specifed and tries to find the UPD based on the user SID.  That
is the format the name is in.
.PARAMETER UserName
This is the sAMAccountName of the users
.PARAMETER RDSCollection
This is the RDS collection that is connected to the UPD -each collection has its own UPD path
.EXAMPLE
.\Update-RDSUPDs.ps1 -UserName 21560 -RDSCollection ClaimsApps

.NOTES
The first parameter (UserName) is required.  The second parameter (RDSCollection) is required. 
#>

[cmdletBinding()]
Param(
    [Parameter(Mandatory=$True)]
    [string]$UserName,
    [Parameter(Mandatory=$True)]
    [string]$RDSCollection
)

$TimeStamp = Get-Date -UFormat "%Y-%m-%d"
$LogFilePath = "\\example.com\logs$\RDS\UPDs"
$LogFileName = "$LogFilePath\$ENV:USERNAME-$UserName-$Timestamp.csv"
$UPDRootPath = "\\dfsn.amtrustapps.com\rdsprofiles\EXAM"
$UPDPaths = "$UPDRootPath\$RDSCollection\"
$UPDFolderExists = 0

if(!([System.IO.File]::Exists($LogfileName))){
    Add-Content -Path "$LogFileName" -Value "Date,Status,Message"
}

Write-Output "INFO - Looking for RDS Collection Path $RDSCollection"
Add-Content -Path "$LogFileName" -Value "$(Get-Date),INFO,Looking for RDS Collection Path $RDSCollection"

Try {
    $CollectionFolders = Get-ChildItem -Path $UPDRootPath
}
Catch {
    Write-Output "ERROR - There was a problem looking for RDS Collection Path $RDSCollection"
    Add-Content -Path "$LogFileName" -Value "$(Get-Date),ERROR,There was a problem looking for RDS Collection Path $RDSCollection"
    Exit
}
 
ForEach($UPDFolder in $CollectionFolders) {
    If($UPDFolder.Name -eq $RDSCollection) {
        $UPDFolderExists = 1
        Break
    }
    Else {
        $UPDFolderExists = 0
    }
}

If($UPDFolderExists -eq 0) {
    Add-Content -Path "$LogFileName" -Value "$(Get-Date),ERROR,Could not find UPD folder for RDS Collection - $RDSCollection"
    Write-Output "ERROR - Could not find UPD folder for RDS Collection - $RDSCollection"
    Write-Output "ERROR - The folders that exist are:"
    Write-Output "$($CollectionFolders.Name)"
    Exit
}
Else {
    Add-Content -Path "$LogFileName" -Value "$(Get-Date),INFO,Found UPD folder for RDS Collection - $RDSCollection"
    Write-Output "INFO - Found UPD folder for RDS Collection - $RDSCollection"
}
 
If($UserName) {
   $UserObject = Get-ADUser -filter 'sAMAccountName -eq $UserName' -Properties SID,DisplayName |Select-Object SID,DisplayName
   $ConfirmAnswer = Read-Host -Prompt "Are you sure you want to rename the UPD for $($UserObject.DisplayName) in RDS Collection $RDSCollection [Y/N]"
   If($UserObject -and $ConfirmAnswer -match "[Yy]") {
       Add-Content -Path "$LogFileName" -Value "$(Get-Date),INFO,Found account info for $UserName"
       Write-Output "INFO - Found account for $UserName"
       $UserSID = $UserObject.SID.Value
       Add-Content -Path "$LogFileName" -Value "$(Get-Date),INFO,The SID for $UserName is $UserSID"
       Write-Output "INFO - The SID for $UserName is $UserSID"
   }
   Else {
       Add-Content -Path "$LogFileName" -Value "$(Get-Date),ERROR,Could not find an account for $UserName or Process has been cancelled"
       Write-Output "ERROR - Could not find an account for $UserName or Process has been cancelled"
       Exit
   }
}
Else {
    Add-Content -Path "$LogFileName" -Value "$(Get-Date),ERROR,Invalid name provided - $UserName"
    Write-Output "ERROR - Invalid name provided - $UserName"
    Exit
}

Add-Content -Path "$LogFileName" -Value "$(Get-Date),INFO,Looking for User Profile Disk for $UserName in RDS Collection $RDSCollection"
Write-Output "INFO - Looking for User Profile Disk for $UserName in RDS Collection $RDSCollection"

Try {
    $UserUPD = Get-ChildItem -Path "$UPDPaths\*$UserSID*" -Recurse -File -Include "*.vhdx"
}
Catch {
    Add-Content -Path "$LogFileName" -Value "$(Get-Date),ERROR,A problem occurred looking for a UPD for $UserName"
    Write-Output "ERROR - A problem occurred looking for a UPD for $UserName"
    Exit
}

If($UserUPD) {
    Add-Content -Path "$LogFileName" -Value "$(Get-Date),INFO,UPD found for $UserName here - $UserUPD"
    Write-Output "INFO - UPD Found for $UserName here - $UserUPD"
    
    Rename-Item -Path $UserUPD -NewName "$UserUPD.$TimeStamp" -Force -ErrorVariable RenameErrors -ErrorAction SilentlyContinue
    $VerifyUserUPDRename = Get-ChildItem -Path "$UPDPaths\*$UserSID*" -Recurse -File -Include "*.vhdx"
    
    If($VerifyUserUPDRename) {
        Add-Content -Path "$LogFileName" -Value "$(Get-Date),ERROR,Something went wrong renaming $UserUPD for $UserName - $RenameErrors"
        Write-Output "ERROR - Something went wrong renaming $UserUPD for $UserName - $RenameErrors"
    }
    Else {
        Add-Content -Path "$LogFileName" -Value "$(Get-Date),INFO,UPD $UserUPD successfully renamed to $UserUPD.$TimeStamp"
        Write-Output "INFO - UPD $UserUPD successfully renamed"
    }
}
Else {
    Add-Content -Path "$LogFileName" -Value "$(Get-Date),ERROR,No UPD found for $UserName"
    Write-Output "ERROR - No UPD Found for $UserName"
}