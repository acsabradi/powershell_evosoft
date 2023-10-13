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
    A param�terk�nt megadott sz�m�t�g�p megoszt�sainak list�z�sa 
   .Description
    A Get-Shares f�ggv�ny visszaadja a param�terk�nt megadott sz�m�t�g�p megoszt�sait egy objektumt�mbben
   .Example
    Get-Shares localhost
    A helyi g�p megoszt�sainak list�z�sa
    .Example
    "Server","localhost" | Get-Shares
    A felsorolt g�pek megoszt�sainak list�z�sa
    .Example
    Get-Content C:\servers.txt | Get-Shares
    A servers.txt �llom�nyban felsorolt g�pek megoszt�sainak list�z�sa
   .Parameter Computer
    A sz�m�t�g�p neve, aminek a megoszt�sait list�zni szeretn�nk
   .Inputs
    [String]
   .OutPuts
    [Object[]]
   .Notes
    2.0-s Powershell verzi�t�l
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
        	Write-Output "Nem lehet kapcsol�dni a $Computer nev� sz�m�t�g�phez"
    	}
    	catch 
	{
		Write-Output "Ismeretlen hiba t�rt�nt"
	}
 }
}

Function Get-ShareSizes
{
<#
   .Synopsis
    A param�terk�nt megadott sz�m�t�g�p megoszt�sainak list�z�sa n�v �s m�ret visszaad�s�val 
   .Description
    A Get-ShareSizes f�ggv�ny visszaadja a param�terk�nt megadott sz�m�t�g�p megoszt�sainak nev�t 
    �s m�ret�t egy objektumt�mbben
   .Example
    Get-ShareSizes localhost
    A helyi g�p megoszt�sainak neve �s m�rete
    .Example
    "Server","localhost" | Get-Shares
    A felsorolt g�pek megoszt�sainak neve �s m�rete
    .Example
    Get-Content C:\servers.txt | Get-Shares
    A servers.txt �llom�nyban felsorolt g�pek megoszt�sainak neve �s m�rete
   .Parameter Computer
    A sz�m�t�g�p neve, aminek a megoszt�sait vizsg�lni szeretn�nk
   .Inputs
    [String]
   .OutPuts
    [Object[]]
   .Notes
    2.0-s Powershell verzi�t�l
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
		$valid = Get-WmiObject -ComputerName $Computer �Class Win32_OperatingSystem -ErrorAction Stop
		$shares =  Get-Shares $Computer
		$Target= @()
		foreach ($dir in $shares)
		{
			$size=$dir.Name | % {[math]::Round(((Get-ShareSize ('\\'+$Computer+'\'+$_))/1Mb),2)}
			$TargetProperties = @{Name=$dir.Name;Size=$Size}    
			$TargetObject = New-Object PSObject �Property $TargetProperties
			$Target +=  $TargetObject
		}
		return $Target
	}
	catch [System.Runtime.InteropServices.COMException]
	{
        	Write-Output "Nem lehet kapcsol�dni a $Computer nev� sz�m�t�g�phez"
    	}
    	catch 
	{
		Write-Output "Ismeretlen hiba t�rt�nt"
	}
 }
}

New-Alias -Name gs -Value Get-Shares
New-Alias -Name gss -Value Get-ShareSizes
Export-ModuleMember -Function Get-Shares, Get-ShareSizes -Alias gs, gss
