********
PS C:\Utilities\ServerScripts\RDS> Invoke-Command -ComputerName host-rdsh01.example.com -scriptBlock {query session}  -credential $Credential
     SESSIONNAME       USERNAME                 ID  STATE   TYPE        DEVICE
    >services                                    0  Disc
                       **********                1  Disc
                       ********                 31  Disc
     rdp-tcp#50        *****                    32  Active
     rdp-tcp#51        *****                    33  Active
     rdp-tcp#53        *****                    35  Active
                       ******                   36  Disc
                       *****                    37  Disc
                       *****                    38  Disc
     rdp-tcp#57        *****                    39  Active
                       *****                    40  Disc
                       *******                  41  Disc
     rdp-tcp#61        ********                 42  Active
     rdp-tcp#65        ********                 43  Active
     rdp-tcp#76        *****                    44  Active
                       *****                    45  Disc
     rdp-tcp#72        **********               46  Active
     rdp-tcp#75        ******                   47  Active
     console                                    48  Conn
     rdp-tcp                                 65536  Listen
    PS C:\Utilities\ServerScripts\RDS>
********
PS C:\Utilities\ServerScripts\RDS> Invoke-Command -ComputerName host-rdsh01.example.com -scriptBlock {Get-Process -IncludeUserName | Where-Object {$_.UserName -eq 'example\user'}}  -credential $Credential
   
   Handles      WS(K)   CPU(s)     Id UserName               ProcessName                    PSComputerName
   -------      -----   ------     -- --------               -----------                    --------------
       232       7460     0.19  20264 example\user           rdpclip                        inf-rdsh01.amtrustservices.com
       396      65940     0.66  14956 example\user           wsmprovhost                    inf-rdsh01.amtrustservices.com
********
PS C:\Utilities\ServerScripts\RDS> Invoke-Command -ComputerName host-rdsh01.example.com -scriptBlock {stop-process 20264}  -credential $Credential
********
PS C:\Utilities\ServerScripts\RDS> Invoke-Command -ComputerName host-rdsh01.example.com -scriptBlock {logoff $args[0]} -ArgumentList 31 -credential $Credential
********
PS C:\Utilities\ServerScripts\RDS> $Report = Invoke-Command -ComputerName host-rdsh01.example.com -scriptBlock {Get-Process csrss -IncludeUserName }  -credential $Credential
********
PS C:\Utilities\ServerScripts\RDS> $Report | Sort-Object SessionId |format-table SessionId,ProcessName,Id,StartTime

SessionId ProcessName    Id StartTime
--------- -----------    -- ---------
        0 csrss         412 2/5/2019 11:31:18 PM
        1 csrss         472 2/5/2019 11:31:19 PM
       31 csrss       17224 2/7/2019 6:35:54 AM
       32 csrss       19964 2/7/2019 7:10:50 AM
       33 csrss       14724 2/7/2019 8:08:04 AM
       35 csrss       14044 2/7/2019 8:17:47 AM
       36 csrss       11660 2/7/2019 8:20:26 AM
       37 csrss       10812 2/7/2019 8:30:09 AM
       38 csrss        8924 2/7/2019 8:45:18 AM
       39 csrss       12332 2/7/2019 8:50:31 AM
       40 csrss       19948 2/7/2019 9:05:13 AM
       41 csrss       17552 2/7/2019 9:08:26 AM
       42 csrss       14224 2/7/2019 9:35:20 AM
       43 csrss       11236 2/7/2019 9:50:49 AM
       44 csrss       11600 2/7/2019 10:06:42 AM
       45 csrss        9008 2/7/2019 10:13:38 AM
       46 csrss       17972 2/7/2019 10:19:47 AM
       47 csrss        8728 2/7/2019 10:40:02 AM
       48 csrss        7752 2/7/2019 10:40:14 AM
********
PS C:\Utilities\ServerScripts\RDS> $Report2 = Invoke-Command -ComputerName host-rdsh01.example.com -scriptBlock {Get-Process ssms -IncludeUserName }  -credential $Credential
********
PS C:\Utilities\ServerScripts\RDS> $Report2 | Sort-Object SessionId |format-table SessionId,ProcessName,Id,StartTime

SessionId ProcessName    Id StartTime
--------- -----------    -- ---------
       33 Ssms        19472 2/7/2019 8:08:21 AM
       33 Ssms        16364 2/7/2019 8:17:03 AM
       42 Ssms          304 2/7/2019 9:35:40 AM
********