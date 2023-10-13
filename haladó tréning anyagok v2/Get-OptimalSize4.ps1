function Get-OptimalSize1
{
[CmdletBinding()]
param
(
      [Parameter(Mandatory = $true,Position = 0,valueFromPipeline=$true)]
      [int64]$sizeInBytes
)
PROCESS 
 {
 Switch ($sizeInBytes) 
  {
   {$sizeInBytes -ge 1TB} {"{0:n2}" -f  ($sizeInBytes/1TB) + " TeraBytes";break}
   {$sizeInBytes -ge 1GB} {"{0:n2}" -f  ($sizeInBytes/1GB) + " GigaBytes";break}
   {$sizeInBytes -ge 1MB} {"{0:n2}" -f  ($sizeInBytes/1MB) + " MegaBytes";break}
   {$sizeInBytes -ge 1KB} {"{0:n2}" -f  ($sizeInBytes/1KB) + " KiloBytes";break}
   Default { "{0:n2}" -f $sizeInBytes + " Bytes" }
  }
 }  
}

function Get-OptimalSize2
{
<#
   .Synopsis
    A bájtban megadott értéket a megfelelő mértékegységre konvertálja.
   .Description
    A Get-OptimalSize2 függvény a  bájtban megadott értéket a megfelelő 
    mértékegységre konvertálja. Viszatérési értékként a számot karakterláncként adja meg.
   .Example
    Get-OptimalSize2 1024
    Átkonvertál 1024 byte-ot 1.00 KiloByte-ra.
    .Example
    Get-OptimalSize2 -sizeInBytes 1048576
    Átkonvertál 1048576 byte-ot 1.00 MegaByte-ra.
    .Example
    1048576,1024 |Get-OptimalSize2
    Átkonvertál 1048576 byte-ot 1.00 MegaByte-ra és 1024 byte-ot 1.00 KiloByte-ra.
   .Parameter SizeInBytes
    A byte érték amit konvertálni kell.
   .Inputs
    [int64]
   .OutPuts
    [string]
   .Notes
    Requires -Version 2.0
   .Link
    http://powershell.org
#>
[CmdletBinding(SupportsShouldProcess)]
param
(
      [Parameter(Mandatory = $true,Position = 0,valueFromPipeline=$true)]
      [int64]$sizeInBytes
) # param blokk vége
PROCESS 
 {
 If ($PSCmdlet.ShouldProcess($sizeInBytes, "A bájtban megadott értéket a megfelelő mértékegységre konvertálja."))
  {
  Switch ($sizeInBytes) 
   {
    {$sizeInBytes -ge 1TB} {"{0:n2}" -f  ($sizeInBytes/1TB) + " TeraBytes";break}
    {$sizeInBytes -ge 1GB} {"{0:n2}" -f  ($sizeInBytes/1GB) + " GigaBytes";break}
    {$sizeInBytes -ge 1MB} {"{0:n2}" -f  ($sizeInBytes/1MB) + " MegaBytes";break}
    {$sizeInBytes -ge 1KB} {"{0:n2}" -f  ($sizeInBytes/1KB) + " KiloBytes";break}
    Default { "{0:n2}" -f $sizeInBytes + " Bytes" }
   } # switch blokk vége
  } # if blokk vége
 } # process blokk vége
} # függvény vége 