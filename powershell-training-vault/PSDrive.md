[**dokumentáció**](https://learn.microsoft.com/en-us/powershell/scripting/samples/managing-windows-powershell-drives?view=powershell-7.3)

```powershell

Get-PSDrive # Fizikai és logikai meghajtók lekérése

  

Get-PSProvider # drive erőforrások (pl. FileSystem, Registry) lekérése

  

Get-ChildItem -Path HKCU: # HKCU (HKEY_CURRENT_USER) registry drive elemeinek lekérése

  

New-PSDrive # új PSDrive felvétele

  

Set-Location -Path Powershell: # ugrás a Powershell drive-ra

  

Resolve-Path -Path Powershell:\chdir.txt | Format-List # drive path feloldása; a ProviderPath attribútum tartalmazza az abszolút path-t

```