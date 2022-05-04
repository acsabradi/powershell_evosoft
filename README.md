# Alapelemek

## `Get-Command`

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

## `Get-Help`

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

## Navigáció a fájlrendszerben

```ps
Push-Location # az aktuális path lementése
Set-Location -Path C:\Windows # a megadott path-ra ugrás
Pop-Location # ugrás a lementett path-ra
Get-ChildItem # az aktuális path-ban lévő fájlok és mappák
Get-ChildItem | Get-Member # típusnevek (mappa és/vagy fájl), valamint azok elemei (függvény, property...)
```

A `Get-ChildItem` egy objektumtömböt ad, viszont a `Get-Member` nem a tömbről ad infót, hanem a tömbben szereplő objektumokról.

```ps
Get-Member -InputObject (Get-ChildItem)
```

Így már tényleg a tömbről kapunk infót.

```ps
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse
```

- `-Path`: Innen listázza az elemeket.
- `-Include *.log`: Csak erre a mintára illeszkedő elemeket adja vissza.
- `-Recurse`: Az almappákban is keres.

```ps
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-List # listába írja ki az elemeket -> minden property-nek új sor
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-List -Property FullName, CreationTime, LastWriteTime, LastAccessTime # megadható, hogy mely property-ket akarjuk a listában látni
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-Table -Property FullName, CreationTime, LastWriteTime, LastAccessTime # ugyanaz, csak itt táblázat a kimenet
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-List -Property * # minden property kilistázása
Show-Command -Name Get-ChildItem -PassThru # a Get-ChildItem paraméterei egy felugró ablakban megadhatók
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Out-GridView # az eredmény egy külön ablakban jelenik meg
```

## `Get-History`

```ps
Get-History # az aktuálisan session-ban használt parancsok
Get-History | Export-Clixml -Path C:\PowerShell\Commands.xml # az előbbi lementése CLI XML formátumba
Clear-History # session history törlése
Add-History -InputObject (Import-Clixml -Path C:\PowerShell\Commands.xml) # history beimportálása
(Get-PSReadlineOption).HistorySavePath
```

- A `Get-PSReadlineOption` a módosítható konfigurációkat adja vissza.
- A `HistorySavePath` visszaadja annak a textfájlnak a path-ját ahová az összes használt parancs lementődik.

```ps
Get-Content -Path (Get-PSReadlineOption).HistorySavePath # a history textfájl kiiratása
```

## Execution Policy

[**execution policy dokumentáció**](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.2)

```ps
Get-ExecutionPolicy -List
```

Visszaadja az egyes scope-okhoz rendelt policy-t. A scope-ok precedencia sorrendben vannak kiírva. Egy nagyobb precedenciával bíró scope policy-ja akkor is érvényre jut, ha egy kisebb precedenciájú scope szigorúbb policy-t ír elő.

```ps
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted # Unrestricted policy beállítása a CurrentUser scope-hoz
```

## Alias-ok

Az *alias*-ok PowerShell parancsok és cmdlet-ek alternatív, rövidebb nevei.

```ps
Get-Alias # az összes alias lekérése
Set-Location -Path Alias: # átmegyünk az Alias drive-ra, ott Get-ChildItem-el ugyanazt kapjuk, mint az előző paranccsal
Get-Alias -Name C* # C-vel kezdődő alias-ok
Get-Alias -Definition Clear-Host # Clear-Host cmdlet-hez rendelt alias
New-Alias # új alias definiálása, enter leütése után adjuk meg az adatokat
```

## PSDrive

```ps
Get-PSDrive # Fizikai és logikai meghajtók lekérése

Get-PSProvider # drive erőforrások (pl. FileSystem, Registry) lekérése

Get-ChildItem -Path HKCU: # HKCU (HKEY_CURRENT_USER) registry drive elemeinek lekérése

New-PSDrive # új PSDrive felvétele

Set-Location -Path Powershell: # ugrás a Powershell drive-ra

Resolve-Path -Path Powershell:\chdir.txt | Format-List # drive path feloldása; a ProviderPath attribútum tartalmazza az abszolút path-t
```

## Metódusok használata

Ha cmdlet-el lekért objektum property-jét vagy függvényét akarjuk használni, akkor a kifejezést zárójelbe kell tenni.

```ps
Get-Item -Path C:\PowerShell\chdir.txt | Get-Member # Lekérjük az objektum elemeit

(Get-Item -Path C:\PowerShell\chdir.txt).GetType() # Egy metódus hívása

(Get-Item -Path C:\PowerShell\chdir.txt).Length # Egy property lekérése

# Integer esetében is kell zárójel:
(5).Equals(5)
```

## Pipeline használata

A cmdlet dokumentáció alapján lehet eldönteni, hogy az adott parancsnak mit lehet átadni a pipeline-ban.

```ps
Get-Process notepad | Stop-Process
```

Ez a pipeline működik, mert:
- a `Stop-Process`-nek van egy `InputObject` bemeneti paramétere, ami
  - `Process` típust fogad
  - *Accept pipeline input: True*, tehát pipeline-ként képes fogadni
- a `Get-Process` egy `Process` objektumot ad
  
```ps
"notepad" | Stop-Process
```

Ez is működik, mert van egy `Name` nevű bemeneti paraméter, ami string-et tud fogadni pipeline-on keresztül.

```ps
$object = New-Object -TypeName PSObject
Add-Member -InputObject $object -MemberType NoteProperty -Name Name -Value "notepad"
$object | Stop-Process
```

Létrehozunk egy objektumot, amiben van egy `Name` property `notepad` értékkel. Ezt adjuk át a pipeline-nak. Ha a pipeline bemeneten nem `Process` vagy string van, akkor a cmdlet megnézi, hogy az objektumnak van-e `Name` property-je. Ha van, akkor annak értékét fogja venni. Ezt a működést jelzi a `Name` dokumentáció `Accept pipeline input? True (ByPropertyName)` sora.

> A property értéke később is módosítható: `$object.Name = "notepad1"`.

```ps
"BITS","WinRM" | Get-Service
```

A cmdlet string-tömböt is tud fogadni.

# Változók

```ps
$valtozo = "hello" # string változó deklarálás

$valtozo.GetType().Name # -> String

$valtozo = 5
$valtozo.GetType() # -> Int32

Set-StrictMode -Version Latest # Strict mode-ban hibát dob a script, ha egy best practice-t megsértünk

$variable # nem létező változóra hivatkozás -> hiba

$valtozo.tulajdonsag # nem létező property-re hivatkozás -> hiba

Set-StrictMode -Off # Strict mode kikapcsolása

$var = 1 # implicit típus megadás

[System.Int32]$var = 1 # explicit típus megadás

$var= "hello" # explicit típusnál nem adhatunk meg más típusú értéket

$var = "123" # De ez működik, mert az "123" stringet implicit módon konvertálja integerré

1+2.0+"3" # "Csak működjön valahogy" elv. Az értékek balról jobbra implicit módon konvertálódnak úgy, hogy a kifejezésnek legyen értelme. Itt a string operandusból double lesz -> eredmény: 6

"1"+2 # Itt viszont balszélen string van, így a másik operandusból is string lesz, ezért a + operátor most összefűzi a stringeket -> eredmény: "12"

$x ="123"
$y = [int]$x # konvertálás értékátadás során

($x -as [long]).GetType() # konvertálás másik szintaktikával
```