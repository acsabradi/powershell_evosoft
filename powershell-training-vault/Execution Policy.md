[**execution policy dokumentáció**](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.2)

```powershell

Get-ExecutionPolicy -List

```

Visszaadja az egyes scope-okhoz rendelt policy-t. A scope-ok precedencia sorrendben vannak kiírva. Egy nagyobb precedenciával bíró scope policy-ja akkor is érvényre jut, ha egy kisebb precedenciájú scope szigorúbb policy-t ír elő.

```powershell

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted # Unrestricted policy beállítása a CurrentUser scope-hoz

```