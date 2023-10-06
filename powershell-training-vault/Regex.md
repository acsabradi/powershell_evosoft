[**Regex tesztelő**](https://regexr.com/)

```powershell
"almás pite" -match ".l" # -> True (mert talált a kifejezésre illeszkedő mintát)

# a talált minta egy rendszerváltozóba tárolódik
$matches # -> Name = 0; Value = "al"

"almás pite" -match ".l.*"
"almás pite" -match ".l.+[aeou]+.*"
"almás pite" -match ".t"
"almás pite" -match "^.l"
"almás pite" -match "^.t"
"almás pite" -match "[aeou]$"
"almás pite" -match "^.l.*\..*"
"almás pite" -match "^.l.*\s.*"

# A like és regex más karaktereket használ!
"PowerShell" -like "Power?hell" # -> True
"PowerShell" -match "Power?hell" # -> False (regexben nem értelmezett a ? operátor)
"PowerShell" -match "Power.?hell" # -> True

# Listát szűrni is használható
$varos = "Budapest","Debrecen","Szeged","Miskolc","Pécs","Győr","Nyíregyháza","Kecskemét","Székesfehérvár","Szombathely"
$varos -match "^[bs].*"
$varos -match "^[^bs].*"
$varos -match "^[^bs].*$"
$varos -match "^[^bs].+$"
$varos -match "^[^bs].?$"
$varos -match "^\w.{3}$"
$varos -match "^[b-k].*$"
$varos -match "^[b-k-[g]].*$"

"www.domain.com" -match "[a-z]{3}\.[a-z]+\.[a-z]{3}"

# betű és nem betű (szóköz, felkiáltójel) által körbezárt elemek
"hello world!" -match "\b[a-z]+\b" # -> True
$matches # -> hello (csak az első találat van benne a változóban)

"Hello World!" -match "\b[a-z]+\b\s\b[a-z]+\b"
$matches
"Hello World!" -match "\b\w+\b"
$matches
"Hello World!" -match "\b\w+\b\s\b\w+\b"
$matches

# számok ellenőrzése
"123-456" -match "\d{3}-\d{3}"
$matches

# A zárójelben lévő kifejezések külön bekerülnek a kiértékelésbe
"123-456" -match "(\d{3})-(\d{3})"
$matches # -> 123-456; 123; 456

# A zárójeles csoportokat el lehet nevezni
"123-456" -match "(?<a>\d{3})-(?<b>\d{3})"
$matches.a # -> 123
$matches.b # -> 456
$matches.0 # -> 123-456

# Szóköz vagy kötőjel elválasztó
"Power-shell" -match "Power[\s|-]shell" # -> True

# Nem szóköz vagy kötőjel elválasztó
"Power shell" -match "Power[\S|-]shell" # -> False

"Powershell" -match "Power[\S|-]shell"
"Power-shell" -match "Power[\S|-]shell"
"Power+shell" -match "Power[\S|-]shell"

"jgipsz@domain.local" -match "\b\w+@\w+\.[a-z]{2,4}\b"
"jgipsz@domain.loc" -match "\b\w+@\w+\.[a-z]{2,4}\b"
"www.domain.local" -match "(?<fqdn>(?<local>(?<host>[a-z0-9]+)\.(?<domain>[a-z0-9]+))\.(?<tld>[a-z]{2,}))"
$matches
$matches.fqdn
$matches.local
$matches.host
$matches.domain
$matches.tld
"PowerShell is (a) great (command-shell)!" -match "\([\w|-]*\)"
```