```powershell

Get-History # az aktuálisan session-ban használt parancsok

Get-History | Export-Clixml -Path C:\PowerShell\Commands.xml # az előbbi lementése CLI XML formátumba

Clear-History # session history törlése

Add-History -InputObject (Import-Clixml -Path C:\PowerShell\Commands.xml) # history beimportálása

(Get-PSReadlineOption).HistorySavePath

```

- A `Get-PSReadlineOption` a módosítható konfigurációkat adja vissza.

- A `HistorySavePath` visszaadja annak a textfájlnak a path-ját ahová az összes használt parancs lementődik.

```powershell

Get-Content -Path (Get-PSReadlineOption).HistorySavePath # a history textfájl kiiratása

```