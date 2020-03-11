Clear-Host
$Server = 'host01'
Invoke-Command -ComputerName $server -ScriptBlock {
    $Store = Get-Item 'Cert:\LocalMachine\My'
    $Store.Open('readwrite')
    $Certs = Get-ChildItem -Path 'Cert:\LocalMachine\My' | Where-Object {$_.Subject -like "*$env:COMPUTERNAME*"}
    $Certs | foreach-object {$Store.Remove($_)}
    Start-Sleep -Seconds '10'
    Start-Process -FilePath 'gpupdate.exe' -ArgumentList '/force'
}