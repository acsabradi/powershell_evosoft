```powershell
"PowerShell" -is [string] # -> true
"PowerShell" -is [object] # -> true
1 -is [object] # -> true
"0123" -as [int] # -> 123
1.234 -as [int] # -> 1
4.567 -as [int] # -> 5
[int] "00011"
```