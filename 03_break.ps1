$tomb = Get-ChildItem -Path C:\Windows
# Continue
Write-Host "=========="
Write-Host "Continue: "
Write-Host "=========="
foreach ($elem in $tomb) 
{
	if ($elem -is [System.IO.DirectoryInfo])
	   {
	 	Write-Host "Könyvtárat találtam - folytatom..."
		continue
	   } 
	Write-Output $elem.Name
}

# Break
Write-Host "======="
Write-Host "Break: "
Write-Host "======="
foreach ($elem in $tomb) 
{
	if ($elem -is [System.IO.FileInfo]) 
	   {
                Write-Host "File-t találtam - kiugrok..."
		break
           } 
	Write-Output $elem.Name
}