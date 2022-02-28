Write-Verbose -Message "A ciklus kezdete"
for ($a=0; $a -ne 26; $a++) 
{
	"{0}: {1}" -f (65+$a), [char](65+$a)
	Write-Verbose -Message "A ciklustörzsben: $a"
}
Write-Verbose -Message "A ciklus vége"