TRY
{
	Write-Host "Begin"
	Write-Verbose "A ciklus kezdete"
	for ($a=0; $a -ne 26; $a++) 
		{
			"{0}: {1}" -f (65+$a), [char](65+$a)
			Write-Verbose "A ciklustörzsben: $a"
		}
	# Write-Verboss "A ciklus vége"
	# 10/0
	Write-Host "End"
}

CATCH [System.Management.Automation.CommandNotFoundException]
{
	"Parancshiba elkapva: $_"
	# THROW
}

CATCH
{
	"Hiba elkapva: $_"
	Break
}

FINALLY
{
	"Mindig végrehajtódik!"
}

"A szkript vége"

