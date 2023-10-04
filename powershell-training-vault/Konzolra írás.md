```powershell

$string = "Powershell"

  

"Ez itt a $string" # Változó értéke így beszúrható a stringbe

  

'Ez itt a $string' # Viszont a beszúrás ennél az idézőjel típusnál nem működik

  

"Ez itt a `$string" # Szükség szerint escape karakter is használható

  

Write-Host (1+2) # Az aritmetikai műveleteket zárójelbe kell tenni, ha azt akarjuk, hogy kiértékelődjenek

  

"összeadás $(1+3)" # Stringben a $ jel is szükséges

  

&"Get-Date" # Stringben kapott cmdlet név lefut, ha & jelet teszünk a string elé

```