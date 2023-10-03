Az *alias*-ok PowerShell parancsok és cmdlet-ek alternatív, rövidebb nevei.

```powershell

Get-Alias # az összes alias lekérése

Set-Location -Path Alias: # átmegyünk az Alias drive-ra, ott Get-ChildItem-el ugyanazt kapjuk, mint az előző paranccsal

Get-Alias -Name C* # C-vel kezdődő alias-ok

Get-Alias -Definition Clear-Host # Clear-Host cmdlet-hez rendelt alias

New-Alias # új alias definiálása, enter leütése után adjuk meg az adatokat

```