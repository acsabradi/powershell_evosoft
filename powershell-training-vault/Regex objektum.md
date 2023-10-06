```powershell
$pattern = [regex] "\([\w|-]*\)"
$szoveg = $pattern.matches("PowerShell is (a) great (command-shell)!")
$szoveg.value # -> (a); (command-shell)
```