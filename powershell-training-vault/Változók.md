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

  

1+2.0+"3" # "Csak működjön valahogy" elv. Az értékek balról jobbra implicit módon konvertálódnak úgy, hogy az operátoroknak működhessenek az adott operandusokkal. A balszélső érték típusához fog igazodni a többi érték. Természetesen a PowerShell hibát fog dobni, ha olyan értéket adunk meg, amit nem lehet implicit módon konvertálni vagy parse-olni. Jelen esetben balszélen 1 integer érték van, így 2.0 double is integer lesz, valamint "3" string is integerré lesz parse-olva. Így az eredmény 6.

  

"1"+2 # Itt balszélen string van, így a másik operandusból is string lesz, ezért a + operátor most összefűzi a stringeket -> eredmény: "12"

  

$x ="123"

$y = [int]$x # konvertálás értékátadás során

  

($x -as [long]).GetType() # konvertálás másik szintaktikával

```