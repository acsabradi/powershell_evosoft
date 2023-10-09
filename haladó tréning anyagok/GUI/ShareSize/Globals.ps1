#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------

#Sample function that provides the location of the script
function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($hostinvocation -ne $null)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}

#Sample variable that provides the location of the script
[string]$ScriptDirectory = Get-ScriptDirectory

#-----------------------------------------
# Private Functions
#-----------------------------------------
Function Get-ShareSize
{
	PARAM ([Parameter(Mandatory = $true, Position = 0, valueFromPipeline = $true)]
		[string]$Share)
	PROCESS
	{
		$entries = Get-ChildItem -recurse $Share
		$dirs = ($entries | Where-Object { $_ -is [System.IO.DirectoryInfo] })
		$files = ($entries | Where-Object { $_ -is [System.IO.FileInfo] })
		$sum = 0
		for ($i = 0; $i -lt $files.count; $i++)
		{
			$sum += $files[$i].Length
		}
		return $sum
	}
}

function Chart-Data
{
	PARAM (
		[System.Collections.ArrayList]$Data = @(@{ Name = "London"; Value = 7556900 },
		@{ Name = "Berlin"; Value = 3429900 },
		@{ Name = "Madrid"; Value = 3213271 },
		@{ Name = "Rome"; Value = 2726539 },
		@{ Name = "Paris"; Value = 2188500 }),
		[System.String]$ChartTitle = "Top 5 European Cities by Population",
		[System.String]$AxisXTitle = "European Cities",
		[System.String]$AxisYTitle = "Population",
		[switch]$pie
	)
	# load the appropriate assemblies 
	[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
	[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")
	# create chart object 
	$Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
	$Chart.Width = 500
	$Chart.Height = 450
	$Chart.Left = 40
	$Chart.Top = 30
	# create a chartarea to draw on and add to chart 
	$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
	$Chart.ChartAreas.Add($ChartArea)
	# add data to chart 
	[void]$Chart.Series.Add("Data")
	$Chart.Series["Data"].Points.DataBindXY($($Data | %{ $_.Name }), $($data | %{ $_.Value }))
	if (!$pie)
	{
		#$Chart.Series["Data"].Sort([System.Windows.Forms.DataVisualization.Charting.PointSortOrder]::Descending, "Y")
		# add title and axes labels 
		[void]$Chart.Titles.Add($ChartTitle)
		$ChartArea.AxisX.Title = $AxisXTitle
		$ChartArea.AxisY.Title = $AxisYTitle
		# Find point with max/min values and change their colour 
		$maxValuePoint = $Chart.Series["Data"].Points.FindMaxByValue()
		$maxValuePoint.Color = [System.Drawing.Color]::Red
		$minValuePoint = $Chart.Series["Data"].Points.FindMinByValue()
		$minValuePoint.Color = [System.Drawing.Color]::Green
		# make bars into 3d cylinders 
		$Chart.Series["Data"]["DrawingStyle"] = "Cylinder"
	}
	else
	{
		# set chart type 
		$Chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Pie
		# set chart options 
		$Chart.Series["Data"]["PieLabelStyle"] = "Outside"
		$Chart.Series["Data"]["PieLineColor"] = "Black"
		$Chart.Series["Data"]["PieDrawingStyle"] = "Concave"
		($Chart.Series["Data"].Points.FindMaxByValue())["Exploded"] = $true
	}
	# change chart area colour 
	$Chart.BackColor = [System.Drawing.Color]::Transparent
	# add a save button 
	$SaveButton = New-Object Windows.Forms.Button
	$SaveButton.Text = "Save"
	$SaveButton.Top = 500
	$SaveButton.Left = 450
	$SaveButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
	$SaveButton.add_click({ $Chart.SaveImage($Env:USERPROFILE + "\Desktop\Chart.png", "PNG") })
	# display the chart on a form 
	$Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor
	[System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
	$Form = New-Object Windows.Forms.Form
	$Form.Text = "PowerShell Chart"
	$Form.Width = 600
	$Form.Height = 600
	$Form.controls.add($Chart)
	$Form.controls.add($SaveButton)
	$Form.Add_Shown({ $Form.Activate() })
	$Form.ShowDialog()
}

function Get-ChartData
{
	PARAM ([Parameter(Mandatory = $true, Position = 0, valueFromPipeline = $true)]
		[System.Object[]]$InputObject,
		[Parameter(Mandatory = $true, Position = 1)]
		[System.String]$key,
		[Parameter(Mandatory = $true, Position = 2)]
		[System.String]$value)
	BEGIN { $result = New-Object system.collections.arraylist }
	PROCESS
	{
		foreach ($item in $InputObject)
		{ $result.Add(@{ Name = $item.$key; Value = $item.$value }) > $null }
	}
	END { return $result }
}

#-----------------------------------------
# Module Functions
#-----------------------------------------
Function Get-Shares
{
<#
   .Synopsis
    A paraméterként megadott számítógép megosztásainak listázása 
   .Description
    A Get-Shares függvény visszaadja a paraméterként megadott számítógép megosztásait egy objektumtömbben
   .Example
    Get-Shares localhost
    A helyi gép megosztásainak listázása
    .Example
    "Server","localhost" | Get-Shares
    A felsorolt gépek megosztásainak listázása
    .Example
    Get-Content C:\servers.txt | Get-Shares
    A servers.txt állományban felsorolt gépek megosztásainak listázása
   .Parameter Computer
    A számítógép neve, aminek a megosztásait listázni szeretnénk
   .Inputs
    [String]
   .OutPuts
    [Object[]]
   .Notes
    2.0-s Powershell verziótól
   .Link
    http://powershell.org
#>
	[CmdletBinding(SupportsShouldProcess)]
	PARAM ([Parameter(Mandatory = $true, Position = 0, valueFromPipeline = $true)]
		[string]$Computer)
	PROCESS
	{
		try
		{
			$shares = @()
			$shares = (Get-WmiObject -ComputerName $Computer -Class Win32_Share -ErrorAction Stop) -notmatch "[a-z0-9]*\$"
			return $shares
		}
		catch [System.Runtime.InteropServices.COMException]
		{
			Write-Output "Nem lehet kapcsolódni a $Computer nevű számítógéphez"
		}
		catch
		{
			Write-Output "Ismeretlen hiba történt"
		}
	}
}

Function Get-ShareSizes
{
<#
   .Synopsis
    A paraméterként megadott számítógép megosztásainak listázása név és méret visszaadásával 
   .Description
    A Get-ShareSizes függvény visszaadja a paraméterként megadott számítógép megosztásainak nevét 
    és méretét egy objektumtömbben
   .Example
    Get-ShareSizes localhost
    A helyi gép megosztásainak neve és mérete
    .Example
    "Server","localhost" | Get-Shares
    A felsorolt gépek megosztásainak neve és mérete
    .Example
    Get-Content C:\servers.txt | Get-Shares
    A servers.txt állományban felsorolt gépek megosztásainak neve és mérete
   .Parameter Computer
    A számítógép neve, aminek a megosztásait listázni szeretnénk
   .Inputs
    [String]
   .OutPuts
    [Object[]]
   .Notes
    2.0-s Powershell verziótól
   .Link
    http://powershell.org
#>
	[CmdletBinding(SupportsShouldProcess)]
	PARAM ([Parameter(Mandatory = $true, Position = 0, valueFromPipeline = $true)]
		[string]$Computer)
	PROCESS
	{
		try
		{
			$valid = Get-WmiObject -ComputerName $Computer –Class Win32_OperatingSystem -ErrorAction Stop
			$shares = Get-Shares $Computer
			$Target = @()
			foreach ($dir in $shares)
			{
				$size = $dir.Name | % { [math]::Round(((Get-ShareSize ('\\' + $Computer + '\' + $_))/1Mb), 2) }
				$TargetProperties = @{ Name = $dir.Name; Size = $Size }
				$TargetObject = New-Object PSObject –Property $TargetProperties
				$Target += $TargetObject
			}
			return $Target
		}
		catch [System.Runtime.InteropServices.COMException]
		{
			Write-Output "Nem lehet kapcsolódni a $Computer nevű számítógéphez"
		}
		catch
		{
			Write-Output "Ismeretlen hiba történt"
		}
	}
}

function Get-ShareSizesChart
{
<#
   .Synopsis
    A paraméterként megadott számítógép megosztásainak listázása diagram formátumban 
   .Description
    A Get-ShareSizesChart függvény diagramként kirajzolja a paraméterként megadott számítógép megosztásainak nevét 
    és méretét
   .Example
    Get-ShareSizesChart localhost
    A helyi gép megosztásainak neve és mérete oszlopdiagram formátumban
   .Example
    Get-ShareSizesChart localhost -Pie
    A helyi gép megosztásainak neve és mérete tortadiagram formátumban
   .Parameter Computer
    A számítógép neve, aminek a megosztásait listázni szeretnénk
   .Parameter Pie
    Az alapértelmezett oszlopdiagramformátumot állítja át tortadiagram formátumra 	
   .Inputs
    [String]
    [Switch] 
   .OutPuts
    [System.Windows.Forms.DataVisualization.Charting.Chart]
   .Notes
    2.0-s Powershell verziótól
   .Link
    http://powershell.org
#>
	[CmdletBinding(SupportsShouldProcess)]
	PARAM ([Parameter(Mandatory = $true, Position = 0)]
		[string]$Computer,
		[switch]$pie)
	
	try
	{
		$valid = Get-WmiObject -ComputerName $Computer –Class Win32_OperatingSystem -ErrorAction Stop
		$Chartdata = Get-ShareSizes $Computer | Get-ChartData -key Name -value Size
		if (!$pie)
		{ Chart-Data -Data $Chartdata -ChartTitle "Processes" -AxisXTitle "Shares" -AxisYTitle "Size" }
		else
		{ Chart-Data -Data $Chartdata -ChartTitle "Processes" -AxisXTitle "Shares" -AxisYTitle "Size" -Pie }
	}
	catch [System.Runtime.InteropServices.COMException]
	{
		Write-Output "Nem lehet kapcsolódnia a $Computer nevű számítógéphez"
	}
	catch
	{
		Write-Output "Ismeretlen hiba történt"
	}
}




