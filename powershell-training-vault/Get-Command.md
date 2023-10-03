```powershell

Get-Command # minden parancs lekérése

Get-Command Get* # Get-el kezdődő parancsok lekérése

Get-Command *-Service # -Service-el végződő parancsok lekérése

Get-Command -Verb Get # Get igével rendelkező parancsok lekérése

Get-Command -Noun Service # Service tárggyal rendelkező parancsok lekérése

Get-Command -Verb Get -Noun Service # Get igével és Service tárggyal rendelkező parancsok lekérése -> Get-Service

Get-Command -Name Get-Service # Get-Service parancs lekérése

Get-Command Get-Service # ugyanaz, csak a paramétert elhagytuk

Get-Command -Module Microsoft.PowerShell.Management # egy adott modulban szereplő parancsok lekérése

Get-Command Microsoft.PowerShell.Management # ugyanaz, csak a paramétert elhagytuk

Get-Command Get-Service -ShowCommandInfo # részletes infók a parancsról

```

