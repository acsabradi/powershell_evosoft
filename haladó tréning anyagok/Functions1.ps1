# Paraméter nélkül
function Get-Dirsize1
{
	$files = Get-ChildItem -File 
	$size = ($files | Measure-Object -Property Length -Sum).Sum/1kb
	$string = "{0,-20} - {1,20 }{2}" -f $files[0].DirectoryName, $size, " kbyte"
	Write-Host $string
}
# Paraméterrel
function Get-Dirsize2($dir)
{
	$files = Get-ChildItem $dir -File 
	$size = ($files | Measure-Object -Property Length -Sum).Sum/1kb
	$string = "{0,-20} - {1,20 }{2}" -f $dir, $size, " kbyte"
	Write-Host $string
}
# Paraméter inicializálás
function Get-Dirsize3($dir = "C:\Windows")
{
	$files = Get-ChildItem $dir -File 
	$size = ($files | Measure-Object -Property Length -Sum).Sum/1kb
	$string = "{0,-20} - {1,20 }{2}" -f $dir, $size, " kbyte"
	Write-Host $string
}
# Paraméter ellenőrzés
function Get-Dirsize4($dir = "C:\Windows")
{
if (Test-Path $dir)
	{
	$files = Get-ChildItem $dir -File 
	$size = ($files | Measure-Object -Property Length -Sum).Sum/1kb
	$string = "{0,-20} - {1,20 }{2}" -f $dir , $size, " kbyte"
	Write-Host $string
	}
else
	{
	Write-Error "Nincs ilyen könyvtár!"
	}
}
# Érték szerinti paraméterátadás
function Get-Dirsize5($dir = "C:\Windows", $result)
{
if (Test-Path $dir)
	{
	$files = Get-ChildItem $dir -File 
	$size = ($files | Measure-Object -Property Length -Sum).Sum/1kb
	$result = $size
	$string = "{0,-20} - {1,20 }{2}" -f $dir, $size, " kbyte"
	Write-Host $string
	}
else
	{
	Write-Error "Nincs ilyen könyvtár!"
	}
}
# Cím szerinti paraméterátadás
function Get-Dirsize6($dir = "C:\Windows", [ref]$result)
{
if (Test-Path $dir)
	{
	$files = Get-ChildItem $dir -File 
	$size = ($files | Measure-Object -Property Length -Sum).Sum/1kb
	$result.Value = $size
	$string = "{0,-20} - {1,20 }{2}" -f $dir, $size, " kbyte"
	Write-Host $string
	}
else
	{
	Write-Error "Nincs ilyen könyvtár!"
	}
}
# Visszatérési érték
function Get-Dirsize7($dir = "C:\Windows")
{
if (Test-Path $dir)
	{
	$files = Get-ChildItem $dir -File 
	$size = ($files | Measure-Object -Property Length -Sum).Sum/1kb
	$string = "{0,-20} - {1,20 }{2}" -f $dir, $size, " kbyte"
	Write-Host $string
	return $size
	}
else
	{
	Write-Error "Nincs ilyen könyvtár!"
	return 0
	}
}
# Tömbparaméter
function Get-Dirsize8([System.IO.FileSystemInfo[]] $files)
{
	$size = ($files | Measure-Object -Property Length -Sum).Sum/1kb
	$string = "{0,-20} - {1,20 }{2}" -f $files[0].DirectoryName, $size, " kbyte"
	Write-Host $string
	return $size
}
# Típusos paraméter
function Get-Dirsize9([System.IO.FileSystemInfo[]] $files, $num)
{
	$size = ($files | Measure-Object -Property Length -Sum).Sum/1kb
	$string = "{0,-20} - {1,20 }{2}" -f $files[0].DirectoryName, $size, " kbyte"
	Write-Host $string
	return $num+$size
}
function Get-Dirsize10([System.IO.FileSystemInfo[]] $files, [int]$num)
{
	$size = ($files | Measure-Object -Property Length -Sum).Sum/1kb
	$string = "{0,-20} - {1,20 }{2}" -f $files[0].DirectoryName, $size, " kbyte"
	Write-Host $string
	return $num+$size
}
