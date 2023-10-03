```powershell

Get-Help # Help megjelenítése

Get-Help -Name chdir # rövid help

Get-Help -Name chdir -Detailed # részletesebb help

Get-Help -Name chdir -Example # példakódok

Get-Help -Name chdir -Full # teljes help

Get-Help -Name chdir -Online # online dokumentáció

Get-Help -Name chdir -ShowWindow # a help egy külön ablakban jelenik meg

Get-Help -Name chdir -Full | Out-File C:\PowerShell\chdir.txt # a teljes help lementése egy fájlba

Get-Help -Name chdir -Parameter Path # a path paraméter help-je

Get-Help -Name Update-Help # lokális help dokumentáció frissítése

Get-Help -Name about_* # about doksik (hosszabb tutorial-ok) listázása

Get-Help -Name about_Aliases # alias-okról szóló about doksi megnyitása

```