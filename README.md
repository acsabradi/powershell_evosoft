- [1. Alapelemek](#1-alapelemek)
  - [1.1. `Get-Command`](#11-get-command)
  - [1.2. `Get-Help`](#12-get-help)
  - [1.3. Navigáció a fájlrendszerben](#13-navigáció-a-fájlrendszerben)
  - [1.4. `Get-History`](#14-get-history)
  - [1.5. Execution Policy](#15-execution-policy)
  - [1.6. Alias-ok](#16-alias-ok)
  - [1.7. PSDrive](#17-psdrive)
  - [1.8. Metódusok használata](#18-metódusok-használata)
  - [1.9. Pipeline használata](#19-pipeline-használata)
- [2. Változók](#2-változók)
- [3. Kiíratás, output](#3-kiíratás-output)
- [4. Tömbök](#4-tömbök)

# 1. Alapelemek

## 1.1. `Get-Command`

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

## 1.2. `Get-Help`

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

## 1.3. Navigáció a fájlrendszerben

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

## 1.4. `Get-History`

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

## 1.5. Execution Policy

[**execution policy dokumentáció**](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.2)

```ps
Get-ExecutionPolicy -List
```

Visszaadja az egyes scope-okhoz rendelt policy-t. A scope-ok precedencia sorrendben vannak kiírva. Egy nagyobb precedenciával bíró scope policy-ja akkor is érvényre jut, ha egy kisebb precedenciájú scope szigorúbb policy-t ír elő.

```ps
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted # Unrestricted policy beállítása a CurrentUser scope-hoz
```

## 1.6. Alias-ok

Az *alias*-ok PowerShell parancsok és cmdlet-ek alternatív, rövidebb nevei.

```ps
Get-Alias # az összes alias lekérése
Set-Location -Path Alias: # átmegyünk az Alias drive-ra, ott Get-ChildItem-el ugyanazt kapjuk, mint az előző paranccsal
Get-Alias -Name C* # C-vel kezdődő alias-ok
Get-Alias -Definition Clear-Host # Clear-Host cmdlet-hez rendelt alias
New-Alias # új alias definiálása, enter leütése után adjuk meg az adatokat
```

## 1.7. PSDrive

```ps
Get-PSDrive # Fizikai és logikai meghajtók lekérése

Get-PSProvider # drive erőforrások (pl. FileSystem, Registry) lekérése

Get-ChildItem -Path HKCU: # HKCU (HKEY_CURRENT_USER) registry drive elemeinek lekérése

New-PSDrive # új PSDrive felvétele

Set-Location -Path Powershell: # ugrás a Powershell drive-ra

Resolve-Path -Path Powershell:\chdir.txt | Format-List # drive path feloldása; a ProviderPath attribútum tartalmazza az abszolút path-t
```

## 1.8. Metódusok használata

Ha cmdlet-el lekért objektum property-jét vagy függvényét akarjuk használni, akkor a kifejezést zárójelbe kell tenni.

```ps
Get-Item -Path C:\PowerShell\chdir.txt | Get-Member # Lekérjük az objektum elemeit

(Get-Item -Path C:\PowerShell\chdir.txt).GetType() # Egy metódus hívása

(Get-Item -Path C:\PowerShell\chdir.txt).Length # Egy property lekérése

# Integer esetében is kell zárójel:
(5).Equals(5)
```

## 1.9. Pipeline használata

A cmdlet dokumentáció alapján lehet eldönteni, hogy az adott parancsnak mit lehet átadni a pipeline-ban.

```ps
Get-Process notepad | Stop-Process
```

Ez a pipeline működik, mert:
- a `Stop-Process`-nek van egy `InputObject` bemeneti paramétere, ami
  - `Process` típust fogad
  - *Accept pipeline input: True*, tehát pipeline-on keresztül is képes fogadni ezt a paramétert
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

Létrehozunk egy objektumot, amiben van egy `Name` property `notepad` értékkel. Ezt adjuk át a pipeline-nak. Ha a pipeline bemeneten nem `Process` vagy string van, akkor a cmdlet megnézi, hogy a bemeneti objektumnak van-e `Name` property-je. Ha van, akkor annak értékét fogja venni. Ezt a működést jelzi a `Name` dokumentáció `Accept pipeline input? True (ByPropertyName)` sora.

> A property értéke később is módosítható: `$object.Name = "notepad1"`.

```ps
"BITS","WinRM" | Get-Service
```

A cmdlet string-tömböt is tud fogadni.

# 2. Változók

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

$var= "hello" # ez hibát dob, mert explicit típusnál nem adhatunk meg más típusú értéket

$var = "123" # De ez működik, mert az "123" stringet implicit módon konvertálja integerré

1+2.0+"3" # "Csak működjön valahogy" elv. Az értékek balról jobbra implicit módon konvertálódnak úgy, hogy az operátoroknak legyen valahogy értelme. A balszélső érték típusához fog igazodni a többi érték. Természetesen a PowerShell hibát fog dobni, ha olyan értéket adunk meg, amit nem lehet implicit módon konvertálni vagy parse-olni. Jelen esetben balszélen 1 integer érték van, így 2.0 double is integer lesz, valamint "3" string is integerré lesz parse-olva.

"1"+2 # Itt balszélen string van, így a másik operandusból is string lesz, ezért a + operátor most összefűzi a stringeket -> eredmény: "12"

$x ="123"
$y = [int]$x # konvertálás értékátadás során

($x -as [long]).GetType() # konvertálás másik szintaktikával
```

# 3. Kiíratás, output

```ps
$string = "Powershell"

"Ez itt a $string" # Változó értéke így beszúrható a stringbe

'Ez itt a $string' # Viszont a beszúrás ennél az idézőjel típusnál nem működik

"Ez itt a `$string" # Szükség szerint escape karakter is használható

Write-Host (1+2) # Az aritmetikai műveleteket zárójelbe kell tenni, ha azt akarjuk, hogy kiértékelődjenek

"összeadás $(1+3)" # Stringben a $ jel is szükséges

&"Get-Date" # Stringben kapott cmdlet név lefut, ha & jelet teszünk a string elé
```

# 4. Tömbök

```ps
$array = @(1,2,3,4,5) # tömb deklarálás és inicializálás

$tomb = 6..10 # integer tömb 6-tól 10-ig

$tomb.GetType() # -> Object[]

[int32[]]$intarray = 100,200,300,400,500 # explicit típusú tömb (@-al is lehetne inicializálni)

$intarray.GetType() # -> Int32[]

$tomb = $array # A tömböket referencia alapú értékátadás jellemzi. Tehát most mindkettő változó ugyanarra a memóriaszegmensre mutató pointer-t tartalmaz.

$array[0] = 50 # Ez a változás a 'tomb'-ben is mutatkozni fog

$tomb = New-Object -TypeName "int[]" -ArgumentList 10 # Új integer tömb létrehozása 10 elemmel. Az összes elem 0. Így már ez a változó másik memóriaszegmensre mutat.

$tomb[0] = "szoveg" # nem adható meg string elemnek, mert integer tömböt definiáltunk (integerré parse-olható string-et megadhatunk)

$array[2..4] # 2-től 4-es indexig tárolt elemek

$array[1,3] # 1-es és 3-as indexű elemek

$array[-1] # az utolsó elem

$array[-5] # a negatív tartományban is indexelhetünk

$urestomb = @()
$urestomb = $urestomb + 1 # |
$urestomb = $urestomb + 2 # | új elemek felvétele a '+' operátorral
$urestomb = $urestomb + 3 # |

$urestomb.Count # elemek száma -> 3

$urestomb.Rank # tömb dimenziói -> 1

$urestomb | Get-Member # Ilyenkor a cmdlet a tömbben lévő elemek információit adja vissza -> TypeName: System.Int32

Get-Member -InputObject $urestomb # Így viszont már tényleg a tömb információit kapjuk -> TypeName: System.Object[]

$urestomb.Contains(4) # Tartalmazza-e a tömb az adott elemet? -> False

$urestomb.Add(6) # Elem hozzáadása a tömbhöz

$urestomb.Sort() # Elemek sorbarendezése

$tabla = (1,2,3,4,5),("A","B","C","D","E") # Jagged 2-dimenziós tömb. Jagged = tömbökből álló tömb, így nem biztos, hogy minden al-tömb ugyanolyan hosszú

$tabla[0][0] # |
$tabla[0][3] # |
$tabla[1][0] # | Jagged tömb indexelése
$tabla[1][3] # |

$tabla.Rank # A jagged tömb dimenziója 1

$tomb = New-Object -TypeName "int[,]" -ArgumentList 2,2 # 2x2-es valódi többdimenziós tömb

$tomb[0,0] = 1 # |
$tomb[0,1] = 2 # |
$tomb[1,0] = 3 # | valódi többdimenziós tömb indexelése
$tomb[1,1] = 4 # |

$tomb.Rank # -> 2

$hash = @{Név = "Gipsz Jakab"; Cím = "Budapest"; "E-mail"="jgipsz@domain.local"} # Hash (directory) típusú tömb

$hash["Cím"] # Key alapján tudunk elemet lekérni -> Budapest

$hash.Cím # Lekérés másik módja

$hash | Get-Member # -> TypeName: System.Collections.Hashtable

$hash.Add("Név","Kőműves Kelemen") # Hibát dob, mert már van egy 'Név' key a hash-ben

$hash.Név = "Kőműves Kelemen" # key-hez tartozó érték frissítése

$contacts = New-Object system.collections.arraylist
$contacts.Add([ordered]@{Név="Gipsz Jakab"; "E-mail"="jgipsz@domain.local"; Cím="Budapest"})     # |
$contacts.Add([ordered]@{Név="Kőműves Kelemen"; "E-mail"="kkelemen@domain.local"; Cím="Szeged"}) # | Tömb feltöltése hashtable-ekkel (Az [ordered] kulcsszóra azért van szükség, hogy a kulcsok abban a sorrendben legyenek lekérhetők, ahogy megadtuk őket)
```