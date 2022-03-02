# Powershell alap tréning @ evosoft

[**jegyzet**](./MFMSPS1_22022_3059_0_Csabradi_Attila_1645699201_PowerShell_alapok_tananyag_mfmsps1_v1.pdf)

## Alapelemek

### `Get-Command`

```ps
Get-Command	# minden parancs lekérése
Get-Command Get* # Get-el kezdődő parancsok lekérése
Get-Command *-Service # -Service-el végződő parancsok lekérése
Get-Command -Verb Get # Get igével rendelkező parancsok lekérése
Get-Command -Noun Service # Service tárggyal rendelkező parancsok lekérése
Get-Command -Verb Get -Noun Service # Get igével és Service tárggyal rendelkező parancsok lekérése -> Get-Service
Get-Command -Name Get-Service # Get-Service parancs lekérése
Get-Command Get-Service # ugyanaz, csak a paramétert elhagytuk
Get-Command -Module Microsoft.PowerShell.Management # egy adott modulban szereplő parancsok lekérése
Get-Command Microsoft.PowerShell.Management # ugyanaz, csak a paramétert elhagytuk
Get-Command Get-Service -ShowCommandInfo # részletes infók a parancsról
```

### `Get-Help`

```ps
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
Get-Help -Name about_* # about doksik (hosszabb programelem leírás) listázása
Get-Help -Name about_Aliases # alias-okról szóló about doksi megnyitása
```

### Navigáció a fájlrendszerben

```ps
Push-Location # az aktuális path lementése
Set-Location -Path C:\Windows # a megadott path-ra ugrás
Pop-Location # ugrás a lementett path-ra
Get-Help -Name about_*
Get-Help -Name about_Aliases
Get-ChildItem
(Get-ChildItem).GetType()
Get-ChildItem | Get-Member
Get-Member -InputObject (Get-ChildItem)
dir C:\Windows\System32\*.log /s
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Get-Member
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-List
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-List -Property FullName, CreationTime, LastWriteTime, LastAccessTime
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-Table -Property FullName, CreationTime, LastWriteTime, LastAccessTime
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-List -Property *
Show-Command -Name Get-ChildItem -PassThru
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Out-GridView
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Out-GridView -PassThru
"Hello world!"; 1+2
Get-History
Get-History | Export-Clixml -Path C:\PowerShell\Commands.xml
Clear-History
Get-History
Add-History -InputObject (Import-Clixml -Path C:\PowerShell\Commands.xml)
Get-History
(Get-PSReadlineOption).HistorySavePath
Get-Content -Path (Get-PSReadlineOption).HistorySavePath
Get-ExecutionPolicy -List
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
Get-ExecutionPolicy -List
```