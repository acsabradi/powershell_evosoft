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
```

### `Get-History`

```ps
Get-History # az aktuálisan session-ban használt parancsok
Get-History | Export-Clixml -Path C:\PowerShell\Commands.xml # az előbbi lementése CLI XML formátumba
Clear-History # session history törlése
Add-History -InputObject (Import-Clixml -Path C:\PowerShell\Commands.xml) # history beimportálása
(Get-PSReadlineOption).HistorySavePath
```

> - A `Get-PSReadlineOption` a módosítható konfigurációkat adja vissza.
> - A `HistorySavePath` visszaadja annak a textfájlnak a path-ját ahová az összes használt parancs lementődik.

```ps
Get-Content -Path (Get-PSReadlineOption).HistorySavePath # a history textfájl kiiratása
```

### Execution Policy

[**execution policy dokumentáció**](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.2)

```ps
Get-ExecutionPolicy -List
```

> Visszaadja az egyes scope-okhoz rendelt policy-t. A scope-ok precedencia sorrendben vannak kiírva. Egy nagyobb precedenciával bíró scope policy-ja akkor is érvényre jut, ha egy kisebb precedenciájú scope szigorúbb policy-t ír elő.

```ps
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted # Unrestricted policy beállítása a CurrentUser scope-hoz
```

## Alias-ok

Az *alias*-ok PowerShell parancsok és cmdlet-ek alternatív, rövidebb nevei.

```ps
Get-Alias # az összes alias lekérése
Set-Location -Path Alias: # átmegyünk az Alias drive-ra, ott Get-ChildItem-el ugyanazt kapjuk, mint az előző paranccsal
Get-Alias -Name C* # C-vel kezdődő alias-ok
Get-Alias -Definition Clear-Host # Clear-Host cmdlet alias-a
New-Alias # új alias definiálása, enter leütése után adjuk meg az adatokat
```

## PSDrive

```ps
Get-PSDrive
Get-PSProvider
Get-ChildItem -Path HKCU:
dir HKCU:\System -r
# Adjuk meg a következő paramétereket:
# Name: PowerShell
# PSProvider: FileSystem
# Root: C:\Powershell
New-PSDrive
Get-PSDrive
Set-Location -Path Powershell:
Get-ChildItem
Jegyzet .\chdir.txt
Jegyzet Powershell:\chdir.txt
Get-Content -Path Powershell:\chdir.txt
Resolve-Path -Path Powershell:\chdir.txt
Resolve-Path -Path Powershell:\chdir.txt | Format-List -Property *
Jegyzet (Resolve-Path -Path Powershell:\chdir.txt).ProviderPath
Set-Location C:
Remove-PSDrive -Name Powershell
Get-PSDrive
#=============================================
#---- Metódusok és tulajdonságok ----
#=============================================
Get-ChildItem -Path C:\PowerShell
Get-Item -Path C:\PowerShell\chdir.txt
Get-Item -Path C:\PowerShell\chdir.txt | Get-Member
Get-Item -Path C:\PowerShell\chdir.txt | Get-Member -View Base
Get-Item -Path C:\PowerShell\chdir.txt | Get-Member -View Adapted
Get-Item -Path C:\PowerShell\chdir.txt | Get-Member -View Extended
Get-Item -Path C:\PowerShell\chdir.txt | Get-Member -View All
(Get-Item -Path C:\PowerShell\chdir.txt).GetType()
(Get-Item -Path C:\PowerShell\chdir.txt).Length
Get-Process | Get-Member
Get-Process | Get-Member -View Base
Get-Process | Get-Member -View Adapted
Get-Process | Get-Member -View Extended
Get-Process | Get-Member -View All
#=============================================
#---- Metódushasználat ----
#=============================================
5
5 | Get-Member
(5).Equals(5)
(5).Equals(3)
((5) | Get-Member -Name Equals).Definition
5 | Get-Member | Format-List -Property Definition
Get-Item -Path C:\Powershell | Get-Member
(Get-Item -Path C:\Powershell).GetAccessControl()
Start-Process -FilePath notepad
Get-Process -Name notepad
Get-Process -Name notepad | Get-Member
(Get-Process -Name notepad).Kill()
#=============================================
#---- PipeLine ----
#=============================================
Start-Process -FilePath notepad
Get-Process -Name notepad
$np = Get-Process -Name notepad
$np
Stop-Process -InputObject $np
Start-Process notepad
Stop-Process notepad
Get-Process notepad | Stop-Process
Get-Help Stop-Process
Get-Help Stop-Process -Parameter InputObject
Get-Help Stop-Process -Parameter Name
Start-Process -FilePath notepad
"notepad" | Stop-Process
$object = New-Object -TypeName PSObject
Add-Member -InputObject $object -MemberType NoteProperty -Name Name -Value "notepad"
$object
$object | Stop-Process
"BITS","WinRM" | Get-Service
Get-Help Get-Service
Get-Help Get-Service -Parameter Name
Get-Help Start-Service -Parameter Name
Get-Help Stop-Service -Parameter Name
$object.Name = "WSearch"
$object | Get-Service
#=============================================
#---- Modulok használata ----
#=============================================
Get-PSSnapin
Get-PSSnapin -Registered
Get-Module
Get-Module -ListAvailable
$env:PSModulePath
Get-Command -Module NetTCPIP
Import-Module -Name NetTCPIP
Get-Module
Get-NetIpAddress
NetTCPIP\Get-NetIpAddress
Import-Module -Name NetTCPIP -Force -Prefix x -PassThru
Get-xNetIpAddress
Remove-Module -Name NetTCPIP
Get-Module
```