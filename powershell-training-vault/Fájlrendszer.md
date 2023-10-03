```powershell

Push-Location # az aktuális path lementése

Set-Location -Path C:\Windows # a megadott path-ra ugrás

Pop-Location # ugrás a lementett path-ra

Get-ChildItem # az aktuális path-ban lévő fájlok és mappák

Get-ChildItem | Get-Member # típusnevek (mappa és/vagy fájl), valamint azok elemei (függvény, property...)

```

A `Get-ChildItem` egy objektumtömböt ad, viszont a `Get-Member` nem a tömbről ad infót, hanem a tömbben szereplő objektumokról.
  
```powershell

Get-Member -InputObject (Get-ChildItem)

```
  
Így már tényleg a tömbről kapunk infót.

```powershell

Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse

```

- `-Path`: Innen listázza az elemeket.

- `-Include *.log`: Csak erre a mintára illeszkedő elemeket adja vissza.

- `-Recurse`: Az almappákban is keres.

```powershell

Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-List # listába írja ki az elemeket -> minden property-nek új sor

Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-List -Property FullName, CreationTime, LastWriteTime, LastAccessTime # megadható, hogy mely property-ket akarjuk a listában látni

Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-Table -Property FullName, CreationTime, LastWriteTime, LastAccessTime # ugyanaz, csak itt táblázat a kimenet

Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Format-List -Property * # minden property kilistázása

Show-Command -Name Get-ChildItem -PassThru # a Get-ChildItem paraméterei egy felugró ablakban megadhatók

Get-ChildItem -Path C:\Windows\System32 -Include *.log -Recurse | Out-GridView # az eredmény egy külön ablakban jelenik meg

```