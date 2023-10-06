[**Dokumentáció**](https://ss64.com/ps/syntax-f-operator.html)

```powershell
# A beszúrandó változó helyétől kezdve egy 15 karakteres tartomány kihagyása a konzolon és ezen tartományban a változó értékét BALRA printeljük
"A {0,-15}. hónap neve: {1,-15}" -f (Get-Date).Month, (Get-Culture).DateTimeFormat.GetMonthName((Get-Date).Month)

# A beszúrandó változó heylétől kezdve egy 15 karakteres tartomány kihagyása a konzolon és ezen tartományban a változó értékét JOBBRA printeljük
"A {0,15}. hónap neve: {1,15}" -f (Get-Date).Month, (Get-Culture).DateTimeFormat.GetMonthName((Get-Date).Month)

# Ezres elválasztó
"Szám: {0:n}" -f 1234568.9 # -> Szám: 1 234 568,90

"Óra: {0:hh}" -f (Get-Date) # -> Óra: 08
"Százalék: {0:p}" -f 0.8 # -> Százalék: 80,00%
"Hexadecimális szám: {0:x}" -f 4096 # -> Hexadecimális szám: 1000
"8 számjegyű hexadecimális szám: {0:x8}" -f 4096 # -> 8 számjegyű hexadecimális szám: 00001000
"Pénznem: {0:c}" -f 123.456
"Pénznem, egész: {0:c0}" -f 123.456
"Pénznem, egy tizedesjegy: {0,15:c1}" -f 123.456
"Rövid dátum: {0:yyyy. M. d}" -f (Get-Date)
"Hosszú dátum: {0:f}" -f (Get-Date)
"Telefonszám: {0:(##) ###-####}" -f 301234567
"Érték: {0:## 000.00##}" -f 99.9
```