
$brokerlist = Get-ADComputer -Filter {Name -Like '*BR0*'} | Select-Object -ExpandProperty DNSHostName
$Report = @()
Write-Verbose -Message "It may take upwards of 6 minutes or more to query an active RDS broker.  Please be patient while the data is collected." -Verbose
$Step = $Rate = 0; $TotalSteps = $($brokerlist | Measure-Object).Count
foreach ($ServerFQDN in $brokerlist ) {
    $Step++  
    $Rate = [math]::truncate($Step / $TotalSteps * 100)
    Write-Progress -Activity "RDS Broker Retrieval in Progress: $ServerFQDN" -Status "$Rate% Complete:" -PercentComplete $Rate
    try {
        $RDSCollections = Get-RDSessionCollection -ConnectionBroker $ServerFQDN -ErrorAction Stop | Select-Object Broker,CollectionName,CollectionAlias,Size,ResourceType,CollectionType,CollectionDescription 
    }
    catch {

    }
    if ($RDSCollections.CollectionName -match '\w+' ) {
        foreach ($collection in $RDSCollections ) {
            $collection.Broker = $ServerFQDN
            $Report += $collection | Select-Object Broker,CollectionName,CollectionAlias,Size,ResourceType,CollectionType,CollectionDescription 
        }
    } else {
        $NoCollections = New-Object PSObject -Property @{
            Broker = $ServerFQDN
            CollectionName = 'No data.'
            CollectionAlias = ''
            Size = ''
            ResourceType =''
            CollectionType = ''
            CollectionDescription = ''
        }
        $Report += $NoCollections | Select-Object Broker,CollectionName,CollectionAlias,Size,ResourceType,CollectionType,CollectionDescription 
    }
}
$Out = $Report | Select-Object Broker,CollectionName,CollectionAlias,Size,ResourceType,CollectionType,CollectionDescription 
$Out | Export-Csv -Path ([Environment]::GetFolderPath("Desktop")+'\RDSBrokers.csv') -NoTypeInformation
Write-Verbose -Message "Output file: $([Environment]::GetFolderPath("Desktop")+'\RDSBrokers.csv')" -Verbose
