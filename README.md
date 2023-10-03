
# 2. Változók

```powershell
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

1+2.0+"3" # "Csak működjön valahogy" elv. Az értékek balról jobbra implicit módon konvertálódnak úgy, hogy az operátoroknak legyen valahogy értelme. A balszélső érték típusához fog igazodni a többi érték. Természetesen a PowerShell hibát fog dobni, ha olyan értéket adunk meg, amit nem lehet implicit módon konvertálni vagy parse-olni. Jelen esetben balszélen 1 integer érték van, így 2.0 double is integer lesz, valamint "3" string is integerré lesz parse-olva. Így az eredmény 6.

"1"+2 # Itt balszélen string van, így a másik operandusból is string lesz, ezért a + operátor most összefűzi a stringeket -> eredmény: "12"

$x ="123"
$y = [int]$x # konvertálás értékátadás során

($x -as [long]).GetType() # konvertálás másik szintaktikával
```

# 3. Kiíratás, output

```powershell
$string = "Powershell"

"Ez itt a $string" # Változó értéke így beszúrható a stringbe

'Ez itt a $string' # Viszont a beszúrás ennél az idézőjel típusnál nem működik

"Ez itt a `$string" # Szükség szerint escape karakter is használható

Write-Host (1+2) # Az aritmetikai műveleteket zárójelbe kell tenni, ha azt akarjuk, hogy kiértékelődjenek

"összeadás $(1+3)" # Stringben a $ jel is szükséges

&"Get-Date" # Stringben kapott cmdlet név lefut, ha & jelet teszünk a string elé
```

# 4. Tömbök

```powershell
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