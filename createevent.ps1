# Create the eventlog (in a subfolder structure)
# Params()
$PrimaryEventKey = 'SuperCharger'
$LogName = 'LogName'
$Folder='c:\temp\'
$FilePath= $Folder + $PrimaryEventKey + '\' + $Logname + '.evtx'
mkdir (Split-Path $FilePath)
$Guid=New-Guid
# Vars()
$primarylocation = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\WINEVT\Channels'
$LogName = $PrimaryEventKey + '-' + $LogName
$EventRoot = (Join-Path $primarylocation $LogName)

if (!(Test-Path $EventRoot)) {
    New-Item -Path $FilePath
    New-Item -Path $EventRoot
    New-ItemProperty -Path $EventRoot -Name providerGuid -PropertyType String -Value "{$($GUID)}"
    New-ItemProperty -Path $EventRoot -Name Enabled -PropertyType DWord -Value 1
    New-ItemProperty -Path $EventRoot -Name Type -PropertyType DWord -Value 1
    New-ItemProperty -Path $EventRoot -Name Isolation -PropertyType DWord -Value 0
    New-ItemProperty -Path $EventRoot -Name RestrictGuestAccess -PropertyType String -Value 1
    New-ItemProperty -Path $EventRoot -Name OwningPublisher -PropertyType String -Value "{$($GUID)}"

    # See https://docs.microsoft.com/en-us/windows/desktop/eventlog/eventlog-key for documentation on the ChannelAccess or or RestrictGuestAccess (see: RestrictGuestAccess / Isolation)
}
else {
    Write-Warning 'Event Log (Key) Already exists in registry'
}

# Write into the event log (Example)
$eventType = ([System.Diagnostics.EventLogEntryType]::Information)
$evt = New-Object System.Diagnostics.EventLog($LogName)
$evt.Source = "SomeSource"
$evt.WriteEntry("random message", $eventType, 60001)