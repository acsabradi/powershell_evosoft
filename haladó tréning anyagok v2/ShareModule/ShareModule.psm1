#-----------------------------------------
# Private Functions
#-----------------------------------------
Function Get-ShareSize
{
PARAM (	[Parameter(Mandatory = $true,Position = 0,valueFromPipeline=$true)]
	[string] $share )
PROCESS
 {
	$files = Get-ChildItem $share -File -Recurse
	$size = ($files | Measure-Object -Property Length -Sum).Sum
	return $size
 }	
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
PARAM (	[Parameter(Mandatory = $true,Position = 0,valueFromPipeline=$true)]
	[string] $Computer )
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
        	Write-Output "Nem lehet kapcsolódni a $Computer nevû számítógéphez"
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
    A számítógép neve, aminek a megosztásait vizsgálni szeretnénk
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
PARAM (	[Parameter(Mandatory = $true,Position = 0,valueFromPipeline=$true)]
	[string] $Computer )
PROCESS
 {
	try 
	{
		$valid = Get-WmiObject -ComputerName $Computer –Class Win32_OperatingSystem -ErrorAction Stop
		$shares =  Get-Shares $Computer
		$Target= @()
		foreach ($dir in $shares)
		{
			$size=$dir.Name | % {[math]::Round(((Get-ShareSize ('\\'+$Computer+'\'+$_))/1Mb),2)}
			$TargetProperties = @{Name=$dir.Name;Size=$Size}    
			$TargetObject = New-Object PSObject –Property $TargetProperties
			$Target +=  $TargetObject
		}
		return $Target
	}
	catch [System.Runtime.InteropServices.COMException]
	{
        	Write-Output "Nem lehet kapcsolódni a $Computer nevû számítógéphez"
    	}
    	catch 
	{
		Write-Output "Ismeretlen hiba történt"
	}
 }
}

New-Alias -Name gs -Value Get-Shares
New-Alias -Name gss -Value Get-ShareSizes
Export-ModuleMember -Function Get-Shares, Get-ShareSizes -Alias gs, gss
