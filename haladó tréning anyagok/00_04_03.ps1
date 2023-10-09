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
	Write-Host "2 - Változók listázása"; 
        Write-Host "3 = Aliasok listázása";
	Write-Host "9 - Kilépés" 
	Write-Host "=========================================================" 
	$v = Read-Host 
	switch ($v) 
		{ 
		"0" {Get-Process | Format-Table} 
		"1" {Get-Service | Format-Table} 
		"2" {Get-Variable| Format-Table} 
		"3" {Get-Alias| Format-Table} 
		"9" {break} 
		default {Write-Host "Érvénytelen billentyű!"} 
		} 
	} while ($v -ne "9")