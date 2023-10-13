function Chart-Data
{
PARAM (	
# Alapértelmezett adatok
	[System.Collections.ArrayList] $Data = @(@{Name="London";Value=7556900},
						 @{Name="Berlin";Value=3429900},
						 @{Name="Madrid";Value=3213271},
						 @{Name="Rome";Value=2726539},
						 @{Name="Paris";Value=2188500}),
	[System.String] $ChartTitle = "Top 5 European Cities by Population",
	[System.String] $AxisXTitle = "European Cities",
	[System.String] $AxisYTitle = "Population",
	[switch] $pie
       )
# Osztálykönyvtárak betöltése
	Add-Type -Assembly System.Windows.Forms
	Add-Type -Assembly System.Windows.Forms.DataVisualization
# Diagram objektum létrehozása
	$Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart 
	$Chart.Width = 500 
	$Chart.Height = 450 
	$Chart.Left = 40 
	$Chart.Top = 30
# ChartArea létrehozása és hozzáadása
	$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea 
	$Chart.ChartAreas.Add($ChartArea)
# Adatok hozzáadása
	[void]$Chart.Series.Add("Data") 
	$Chart.Series["Data"].Points.DataBindXY($($Data | %{$_.Name}),$($data | %{$_.Value}))
# Ha nem Pie
if (!$pie)
	{
# Adatok rendezése
	$Chart.Series["Data"].Sort([System.Windows.Forms.DataVisualization.Charting.PointSortOrder]::Descending, "Y")
# Tengelycimkék hozzáadása
	[void]$Chart.Titles.Add($ChartTitle) 
	$ChartArea.AxisX.Title = $AxisXTitle 
	$ChartArea.AxisY.Title = $AxisYTitle 
# Maximum/minimum értékekhez saját színek beállítása
	$maxValuePoint = $Chart.Series["Data"].Points.FindMaxByValue() 
	$maxValuePoint.Color = [System.Drawing.Color]::Red
	$minValuePoint = $Chart.Series["Data"].Points.FindMinByValue() 
	$minValuePoint.Color = [System.Drawing.Color]::Green
# Oszlopok legyenek 3D-s hengerek
	$Chart.Series["Data"]["DrawingStyle"] = "Cylinder"
	}
else
	{
# Diagram típusának beállítása
	$Chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Pie
# Diagram tulajdonságainak beállítasa
	$Chart.Series["Data"]["PieLabelStyle"] = "Outside" 
	$Chart.Series["Data"]["PieLineColor"] = "Black" 
	$Chart.Series["Data"]["PieDrawingStyle"] = "Concave" 
	($Chart.Series["Data"].Points.FindMaxByValue())["Exploded"] = $true
	}
# Diagramterület színének beállítása 
	$Chart.BackColor = [System.Drawing.Color]::Transparent
# Save gomb hozzáadása
	$SaveButton = New-Object Windows.Forms.Button 
	$SaveButton.Text = "Save" 
	$SaveButton.Top = 500 
	$SaveButton.Left = 450 
	$SaveButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
	$SaveButton.add_click({$Chart.SaveImage($Env:USERPROFILE + "\Desktop\Chart.png", "PNG")})
# Diagram megjelenítése az űrlapon
	$Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor 
        	        [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left 
	$Form = New-Object Windows.Forms.Form 
	$Form.Text = "PowerShell Chart" 
	$Form.Width = 600 
	$Form.Height = 600 
	$Form.controls.add($Chart) 
	$Form.controls.add($SaveButton)
	$Form.Add_Shown({$Form.Activate()}) 
	$Form.ShowDialog()
}

function Get-ChartData
{
PARAM  ([Parameter(Mandatory = $true,Position = 0,valueFromPipeline=$true)][System.Object[]] $InputObject,
	[Parameter(Mandatory = $true,Position = 1)][System.String] $key,
	[Parameter(Mandatory = $true,Position = 2)][System.String] $value)
BEGIN	{$result = New-Object system.collections.arraylist}
PROCESS	{
	foreach ($item in $InputObject)
		{$result.Add(@{Name=$item.$key;Value=$item.$value}) > $null}
	}
END	{ return $result }
}

Function Get-DiskInfo
{
$dirs=Get-ChildItem "C:\Program Files" -ErrorAction SilentlyContinue
$Target= @()
foreach ($dir in $dirs)
	{
	$size=(Get-ChildItem $dir.fullname -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum/1Mb 
	$TargetProperties = @{Name=$dir.Name;Size=$Size}    
	$TargetObject = New-Object PSObject –Property $TargetProperties
	$Target +=  $TargetObject
	}
return $Target
}