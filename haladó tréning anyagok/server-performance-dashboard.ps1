
<#PSScriptInfo

.VERSION 1.0

.GUID 43bc8bcd-f861-4b13-b81e-a043a30912bb

.AUTHOR Ironman Software, LLC

.COMPANYNAME Ironman Software, LLC

.COPYRIGHT Ironman Software, LLC 2017

.TAGS UniversalDashboard

.LICENSEURI 

.PROJECTURI https://raw.githubusercontent.com/adamdriscoll/poshprotools/master/examples/universal-dashboard/server-performance-dashboard.ps1

.ICONURI 

.EXTERNALMODULEDEPENDENCIES UniversalDashboard

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

<# 

.DESCRIPTION 
 Basic server information built on Universal Dashboard. 

#> 
Function Get-PerformanceCounterID
{
    param
    (
        [Parameter(Mandatory=$true,valueFromPipeline=$true)][string]$Name
    )
    begin
    {
        $key = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Perflib\009'
        $counters = (Get-ItemProperty -Path $key -Name Counter).Counter
        $perfHash = @{}
        $all = $counters.Count

        for($i = 0; $i -lt $all; $i+=2)
        {
           $perfHash.$($counters[$i+1]) = $counters[$i]
        }
    }

    process
    {
       return $perfHash.$Name
    }
}

Function Get-PerformanceCounterLocalName
{
   param
   (
     [Parameter(Mandatory=$true,valueFromPipeline=$true)][Int32]$ID,
     [string]$ComputerName = $env:COMPUTERNAME
   )

   begin
   {
       $code = '[DllImport("pdh.dll", SetLastError=true, CharSet=CharSet.Unicode)] public static extern UInt32 PdhLookupPerfNameByIndex(string szMachineName, uint dwNameIndex, System.Text.StringBuilder szNameBuffer, ref uint pcchNameBufferSize);'
       $pc = Add-Type -MemberDefinition $code -PassThru -Name PerfCounter -Namespace Utility
   }

   process
   {
       $Buffer = New-Object System.Text.StringBuilder(1024)
       [Int32]$BufferSize = $Buffer.Capacity

       $pcn = $pc::PdhLookupPerfNameByIndex($ComputerName, $id, $Buffer, [Ref]$BufferSize)

       if ($pcn -eq 0)
       {
          $Buffer.ToString().Substring(0, $BufferSize-1)
       }
       else
       {
          Throw 'Get-PerformanceCounterLocalName : Unable to retrieve localized name. Check computer name and performance counter ID.'
       }
    }
}


$processor = Get-PerformanceCounterLocalName 238
$percentProcessorTime = Get-PerformanceCounterLocalName 6
$memory = Get-PerformanceCounterLocalName 4
$committedbytes = Get-PerformanceCounterLocalName 1406
$physicaldisk = Get-PerformanceCounterLocalName 234
$disktime = Get-PerformanceCounterLocalName 200
$process = Get-PerformanceCounterLocalName 230
$ioread = Get-PerformanceCounterLocalName 1420


Start-UdDashboard -Content {
    New-UdDashboard -Title "Server Performance Dashboard" -Color '#FF050F7F' -Content {
        New-UdRow {
            New-UdColumn -Size 6 -Content {
                New-UdRow {
                    New-UdColumn -Size 12 -Content {
                        New-UdTable -Title "Server Information" -Headers @(" ", " ") -Endpoint {
                            @{
                                'Computer Name' = $env:COMPUTERNAME
                                'Operating System' = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
                                'Total Disk Space (C:)' = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'").Size / 1GB | ForEach-Object { "$([Math]::Round($_, 2)) GBs " }
                                'Free Disk Space (C:)' = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'").FreeSpace / 1GB | ForEach-Object { "$([Math]::Round($_, 2)) GBs " }
                            }.GetEnumerator() | Out-UDTableData -Property @("Name", "Value")
                        }
                    }
                }
                New-UdRow {
                    New-UdColumn -Size 3 -Content {
                        New-UdChart -Title "Memory by Process" -Type Doughnut -RefreshInterval 5 -Endpoint {
                            Get-Process | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; WorkingSet = [Math]::Round($_.WorkingSet / 1MB, 2) }} |  Out-UDChartData -DataProperty "WorkingSet" -LabelProperty Name
                        } -Options @{
                            legend = @{
                                display = $false
                            }
                        }
                    }
                    New-UdColumn -Size 3 -Content {
                        New-UdChart -Title "CPU by Process" -Type Doughnut -RefreshInterval 5 -Endpoint {
                            Get-Process | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; CPU = $_.CPU } } |  Out-UDChartData -DataProperty "CPU" -LabelProperty Name
                        } -Options @{
                            legend = @{
                                display = $false
                            }
                        }
                    }
                    New-UdColumn -Size 3 -Content {
                        New-UdChart -Title "Handle Count by Process" -Type Doughnut -RefreshInterval 5 -Endpoint {
                            Get-Process | Out-UDChartData -DataProperty "HandleCount" -LabelProperty Name
                        } -Options @{
                            legend = @{
                                display = $false
                            }
                        }
                    }
                    New-UdColumn -Size 3 -Content {
                        New-UdChart -Title "Threads by Process" -Type Doughnut -RefreshInterval 5 -Endpoint {
                            Get-Process | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } |  Out-UDChartData -DataProperty "Threads" -LabelProperty Name
                        } -Options @{
                            legend = @{
                                display = $false
                            }
                        }
                    }
                }
                New-UdRow {
                    New-UdColumn -Size 12 -Content {
                        New-UdChart -Title "Disk Space by Drive" -Type Bar -AutoRefresh -Endpoint {
                            Get-CimInstance -ClassName Win32_LogicalDisk | ForEach-Object {
                                    [PSCustomObject]@{ DeviceId = $_.DeviceID;
                                                       Size = [Math]::Round($_.Size / 1GB, 2);
                                                       FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
                                New-UdChartDataset -DataProperty "Size" -Label "Size" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23"
                                New-UdChartDataset -DataProperty "FreeSpace" -Label "Free Space" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
                            )
                        }
                    }
                }
            }
            New-UdColumn -Size 6 -Content {
                New-UdRow {
                    New-UdColumn -Size 6 -Content {
                        New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
						    try {
								Get-Counter "\$processor(_total)\$percentProcessorTime"  -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
							}
                            catch {
								0 | Out-UDMonitorData
							}
                        }
                    }
                    New-UdColumn -Size 6 -Content {
                        New-UdMonitor -Title "Memory (% in use)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#8028E842' -ChartBorderColor '#FF28E842'  -Endpoint {
							try {
								Get-Counter "\$memory\$committedbytes" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
							}
                            catch {
								0 | Out-UDMonitorData
							}
                        }
                    }
                }
                New-UdRow {
                    New-UdColumn -Size 6 -Content {
                        New-UdMonitor -Title "Network (IO Read Bytes/sec)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80E8611D' -ChartBorderColor '#FFE8611D'  -Endpoint {
							try {
								Get-Counter "\$process(_Total)\$ioread" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
							}
                            catch {
								0 | Out-UDMonitorData
							}
                        }
                    }
                    New-UdColumn -Size 6 -Content {
                        New-UdMonitor -Title "Disk (% disk time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80E8611D' -ChartBorderColor '#FFE8611D'  -Endpoint {
							try {
								Get-Counter "\$physicaldisk(_total)\$disktime" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
							}
							catch {
								0 | Out-UDMonitorData
							}
                        }
                    }
                }
                New-UdRow {
                    New-UdColumn -Size 12 {
                        New-UdGrid -Title "Processes" -Headers @("Name", "ID", "Working Set", "CPU") -Properties @("Name", "Id", "WorkingSet", "CPU") -AutoRefresh -RefreshInterval 60 -Endpoint {
                            Get-Process | Out-UDGridData
                        }
                    }
                }
            }
        }
    }
} -Port 10000