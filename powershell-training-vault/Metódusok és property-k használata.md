Ha cmdlet-el lekért objektum property-jét vagy függvényét akarjuk használni, akkor a kifejezést zárójelbe kell tenni.

```powershell

Get-Item -Path C:\PowerShell\chdir.txt | Get-Member # Lekérjük az objektum elemeit

  

(Get-Item -Path C:\PowerShell\chdir.txt).GetType() # Egy metódus hívása

  

(Get-Item -Path C:\PowerShell\chdir.txt).Length # Egy property lekérése

  

# Integer esetében is kell zárójel:

(5).Equals(5)

```