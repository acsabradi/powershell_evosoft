A cmdlet dokumentáció alapján lehet eldönteni, hogy az adott parancsnak mit lehet átadni a pipeline-ban.

```powershell

Get-Process notepad | Stop-Process

```

Ez a pipeline működik, mert:

- a `Stop-Process`-nek van egy `InputObject` [bemeneti paramétere](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/stop-process?view=powershell-7.3#-inputobject), ami
	- `Process` típust fogad
	- *Accept pipeline input: True*, tehát pipeline-on keresztül is képes fogadni ezt a paramétert
- a `Get-Process` egy `Process` objektumot ad

```powershell

"notepad" | Stop-Process

```

Ez is működik, mert van egy `Name` nevű [bemeneti paraméter](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/stop-process?view=powershell-7.3#-name), ami string tömböt (így egy string-et is) tud fogadni pipeline-on keresztül.

```powershell

$object = New-Object -TypeName PSObject

Add-Member -InputObject $object -MemberType NoteProperty -Name Name -Value "notepad"

$object | Stop-Process

```

Létrehozunk egy objektumot, amiben van egy `Name` property `notepad` értékkel. Ezt adjuk át a pipeline-nak. Ha a pipeline bemeneten nem `Process` vagy string van, akkor a cmdlet megnézi, hogy a bemeneti objektumnak van-e `Name` property-je. Ha van, akkor annak értékét fogja venni. Ezt a működést jelzi a `Name` dokumentáció `Accept pipeline input? True (ByPropertyName)` sora.

Ezt a működést csak a `Get-Help`-el lokálisan lekérhető dokumentáció írja le.

```powershell

"BITS","WinRM" | Get-Service

```

A cmdlet string-tömböt is tud fogadni.