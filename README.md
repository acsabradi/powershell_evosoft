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
Get-Help -Name about_* # about doksik (hosszabb tutorial-ok) listázása
Get-Help -Name about_Aliases # alias-okról szóló about doksi megnyitása
```

### Navigáció a fájlrendszerben

```ps
Push-Location # az aktuális path lementése
Set-Location -Path C:\Windows # a megadott path-ra ugrás
Pop-Location # ugrás a lementett path-ra
Get-ChildItem # az aktuális path-ban lévő fájlok és mappák
Get-ChildItem | Get-Member # típusnevek (mappa és/vagy fájl), valamint azok elemei (függvény, property...)
```

> A `Get-ChildItem` egy objektumtömböt ad, viszont a `Get-Member` nem a tömbről ad infót, hanem a tömbben szereplő objektumokról.

```ps
Get-Member -InputObject (Get-ChildItem)
```

> Így már tényleg a tömbről kapunk infót.

```ps
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse
```

> - `-Path`: Innen listázza az elemeket.
> - `-Include *.log`: Csak erre a mintára illeszkedő elemeket adja vissza.
> - `-Recurse`: Az almappákban is keres.

```ps
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-List # listába írja ki az elemeket -> minden property-nek új sor
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-List -Property FullName, CreationTime, LastWriteTime, LastAccessTime # megadható, hogy mely property-ket akarjuk a listában látni
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-Table -Property FullName, CreationTime, LastWriteTime, LastAccessTime # ugyanaz, csak itt táblázat a kimenet
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-List -Property * # minden property kilistázása
Show-Command -Name Get-ChildItem -PassThru # a Get-ChildItem paraméterei egy felugró ablakban megadhatók
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Out-GridView # az eredmény egy külön ablakban jelenik meg
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