############################
#       Description        #
#==========================#
# Felhasználói input       #
# átvétele                 #
############################
do 
	{ 
	Write-Host "=========================================================" 
	Write-Host "0 - Folyamatok listázása" 
	Write-Host "1 - Szolgáltatások listázása" 
	Write-Host "2 - Folyamat indítása" 
	Write-Host "3 - Folyamat leállítása" 
	Write-Host "9 - Kilépés" 
	Write-Host "=========================================================" 
	$v = Read-Host 
	switch ($v) 
		{ 
		"0" {Get-Process} 
		"1" {Get-Service} 
		"2" {&(Read-Host "Folyamat neve")} 
		"3" {Stop-Process -name (Read-Host "Folyamat neve")} 
		"9" {break} 
		default {Write-Host "Érvénytelen billentyű!"; break } 
		} 
	} while ($v -ne "9")