<#
.SYNOPSIS
This is brief description

.DESCRIPTION
This is a full description

.PARAMETER Log
The name of the log

.PARAMETER First
The number of events to get

.PARAMETER EventId
The EventID to get

.EXAMPLE
Get-MyEvent -Log Security -First 2 -EventId 4624
Gets the first 2 events of event ID 4624 from the security log.

#>

Function Get-MyEvent {

[CmdletBinding()]
Param (
    [parameter(Mandatory=$true)]
    
    [ValidateSet ("Application", "HardwareEvents", "Internet Explorer",
                  "Key Management Service", "OAlerts", "Security",
                  "System", "Windows PowerShell")]
    [string]
    $Log,

    [int]
    $First = 2,

    [int]
    $EventId = 4624,
        
    [string[]]
    $CompName = ".",  # . mean localhost

    [string]
    $LogPath = "C:\Test\Logs\ErrorLog.txt",

    [Switch]
    $LogErrors
)
    If ($LogErrors) {$Null | Out-File -FilePath $LogPath}

     ForEach ($C in $CompName) {    
        Try { invoke-command `
               -ComputerName $C `
               -ErrorAction Stop `
               -ScriptBlock {
                  Get-EventLog `
                     -LogName $Using:Log `
                     -Newest $Using:First `
                     -InstanceId $Using:EventId
                } <# END of Scriptblock #>             
                 
            } # END: Try

        Catch [System.Management.Automation.Remoting.PSRemotingTransportException] {              
                 Write-Warning "$C is off line"
                 If ($LogErrors) {$C | Out-File -FilePath $LogPath -Append} 
              } # END of Catch [System.Management.Automation.Remoting.PSRemotingTransportException]

        Catch [System.ArgumentException] {
                 Write-Warning "$EventId is not the right event"
              } # END of Catch [System.ArgumentException]
           
        Catch { 
                Write-Warning "Error: $($_.Exception.GetType().FullName)"
              } # END: Catch

    } # End: foreach ($C in $CompName) 
       
} # END: Function Get-MyEvent

# ==========================================Test Lines ============================================

# Get-MyEvent -Log Security -First 2 -EventId 4624
# Get-help Get-MyEvent -full
# Get-MyEvent -Log security -First 1 -EventId 4624 -CompName LON-DC1, Bad1, Bad2, LOn-Svr1 -LogErrors
Get-MyEvent -Log Security -CompName (Get-Content C:\Test\Logs\ErrorLog.txt) -LogErrors