[**Dokumentáció**](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_redirection?view=powershell-7.3)

```powershell
# cmdlet eredményének mentése fájlba
Get-Process | Format-Table -Property Id > C:\PowerShell\szamok.txt

# szöveg hozzáfűzése a fájlhoz
Write-Output "PowerShell" >> C:\PowerShell\szamok.txt

# cmdlet eredményének mentése fájlba; hibaüzenet a konzolra megy
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse > C:\PowerShell\log.txt

# cmdlet eredménye a konzolra, a hibák fájlba kerülnek
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse 2> C:\PowerShell\hiba.txt

# minden a fájlba kerül, konzolra nem íródik ki semmi
Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse 2>&1 > C:\PowerShell\loghiba.txt

# naplózás fájlba
Write-Error -Message "Hiba" 2>> C:\PowerShell\hiba.txt
Write-Warning -Message "Figyelmeztetés" 3>> C:\PowerShell\hiba.txt
Write-Verbose -Message "Kiegészító információk" -Verbose 4>> C:\PowerShell\hiba.txt
Write-Information -Msg "Információ" -InformationAction Continue 6>> C:\PowerShell\hiba.txt

# szkript futtatást megállítja, leokézás után fut tovább
Write-Debug -Message "Hibakeresés" -Debug 5>> C:\PowerShell\hiba.txt

# hibaüzenet lementése változóba
$nincs = Remove-Item -Path C:\PowerShell\nincs.txt 2>&1
```