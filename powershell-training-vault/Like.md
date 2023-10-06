A `like` helyettesítő karaktereket használ string-ek tesztelésére.

```powershell
"alma" -like "?l*a" # -> True
"alma" -notlike "?l*a" # -> False
"alma" -like "?l*[aeou]" # -> True
"alma" -notlike "?l*[aeou]" # -> False
"almás pite" -like "?l*[aeou]" # -> True
"almás pite" -like "?l*[0-9]" # -> False

# cmdlet output-ot is lehet szűrni
Get-Service -Name "[ab]*svc"

"Gőgös", "Gúnár", "Gedeon" -like "g*n*" # -> Gúnár, Gedeon  
"Mosó", "Masa", "mosodája" -clike "[m-n]o?*" # -> mosodája
```