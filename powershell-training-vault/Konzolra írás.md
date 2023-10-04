```powershell

$string = "Powershell"

  

"Ez itt a $string" # Változó értéke így beszúrható a stringbe

  

'Ez itt a $string' # Viszont a beszúrás ennél az idézőjel típusnál nem működik

  

"Ez itt a `$string" # Szükség szerint escape karakter is használható

  

Write-Host (1+2) # Az aritmetikai műveleteket zárójelbe kell tenni, ha azt akarjuk, hogy kiértékelődjenek

Write-Output "teszt" | Get-Service # A Write-Output alternatíva az előbbi parancsnak. Annyi a különbség hogy ez pipeline-ban tovább tudja adni a kiírt értéket, míg az előbbi tudja formázni a szöveget (pl. háttér színe)

"összeadás $(1+3)" # Stringben a $ jel is szükséges

  

&"Get-Date" # Stringben kapott cmdlet név lefut, ha & jelet teszünk a string elé

```