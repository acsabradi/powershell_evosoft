```powershell
"Power"+"Shell" # -> PowerShell
(1,2,3)+("egy","kettő","három") # -> 1,2,3,"egy","kettő","három"
"Ba"*3 # -> BaBaBa
3*"Ba" # -> konverziós hiba!
123 -eq "0123" # -> true			
"0123"  -eq 123 # -> false 			
1,2,3,1,2,3 -ne 1 # -> 2,3,2,3 (1-eseket kiszűrte)
1,2,3,1,2,3 -contains 1 # -> true		
1,2,3,1,2,3 -notcontains 1 # -> false	
```

Case sensitiveness:

```powershell
"powershell" -eq "PowerShell" # -> true
"powershell" -ceq "PowerShell" # -> false
```