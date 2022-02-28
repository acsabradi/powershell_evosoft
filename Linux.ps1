systemctl list-units --type=service --no-legend --all --no-pager

$services = systemctl list-units --type=service --no-legend --all --no-pager
$services = $services -split "`n"
$services | ForEach-Object { $_ -split '\s+'}

$services = systemctl list-units --type=service --no-legend --all --no-pager
$services | ForEach-Object {
   $service = $_ -split '\s+'
      [PSCustomObject]@{
         "Name"        = $service[0]
         "Load"        = $service[1]
         "Active"      = $service[2]
         "Status"      = $service[3]
         "Description" = ($service[4..($service.count - 2)] -Join " ")
 }}

$services = systemctl list-units --type=service --no-legend --all --no-pager
$services = $services | ForEach-Object {
$service = $_ -split '\s+'
 [PSCustomObject]@{
 "Name"        = $service[0]
 "Load"        = $service[1]
 "Active"      = $service[2]
 "Status"      = $service[3]
 "Description" = ($service[4..($service.count - 2)] -Join " ")
 }}


Function Get-Service {
  [CmdletBinding()]
 
  Param(
      [Parameter( Position = 0, ValueFromPipeline = $True )][String]$Name
  )
 
  Begin {
    # Stop Function if Not Linux
    If ( -Not $IsLinux ) {
      Write-Error "This function should only be run on Linux systems"
      Break
    }
  }
 
  Process {
 If ( $Name ) {
      $services = & systemctl list-units $Name --type=service --no-legend --all --no-pager
    } Else {
      $services = & systemctl list-units --type=service --no-legend --all --no-pager
    }
 
    $services = $services -Split "`n"
 
    $services = $services | ForEach-Object {
      $service = $_ -Split '\s+'
 
      [PSCustomObject]@{
        "Name"        = ($service[0] -Split "\\.service")[0]
        "Unit"        = $service[0]
        "State"       = $service[1]
        "Active"      = (($service[2] -EQ 'active') ? $true : $false)
        "Status"      = $service[3]
        "Description" = ($service[4..($service.count - 2)] -Join " ")
      }
    }
 
    $services
  }
}

Get-Service 
Get-Service mssql-server.service