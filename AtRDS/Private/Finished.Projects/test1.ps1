Write-Host '******************************'
Write-Host '* Log Off User Remotely *'
Write-Host '******************************'
Write-Host

$global:adminCreds = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "")
$global:ComputerName = Read-Host 'Computer Name?'

Function enableWinRM {
	#Remotely Enable WinRM (uses PSExec)
	.\remotely_enable_winrm.ps1 -computerName $global:ComputerName
	if ($LastExitCode -ne 0) {
		enableWinRM
	}
}

Function getSessions {
	Write-host
	Write-host "Getting user sessions..."
	Write-Host
	Write-Host '***************************************************************************'
	Invoke-Command -ComputerName $global:ComputerName -scriptBlock {query session}  -credential $global:adminCreds
}

Function logUserOff {
	Write-Host
	$SessionNum = Read-Host 'Session number to log off?'
	$title = "Log Off"
	$message = "Are you sure you want to log them off?"
	$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
		"Logs selected user off."
	$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
		"Exits."
	$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
	$result = $host.ui.PromptForChoice($title, $message, $options, 1) 

	switch ($result){
		0 {
			Write-Host
			Write-Host 'OK. Logging them off...'
			Invoke-Command -ComputerName $global:ComputerName -scriptBlock {logoff $args[0]} -ArgumentList $SessionNum -credential $global:adminCreds
			Write-Host
			Write-Host 'Success!' -ForegroundColor green
			break
		}
		1 {break}
	}
}

enableWinRM
getSessions
logUserOff

Write-Host
Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")