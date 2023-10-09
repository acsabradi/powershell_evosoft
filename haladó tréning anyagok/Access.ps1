#=============================================
#---- Globális változók ----
#=============================================
$curDir        = "C:\Powershell" # -- Get-Location
$accessFile    = "$curDir\test.accdb"
$provider      = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=$accessFile"
$adoConnection = new-object -comObject ADODB.connection
$adoConnection.connectionString = $provider
#=============================================
#---- Adatbázis létrehozása ----
#=============================================
function Create-Database
{
$adoxCat = New-Object -comObject ADOX.catalog
Remove-Item $accessFile -ErrorAction ignore
$catalog = $adoxCat.create($provider)
$table = $catalog.execute('CREATE TABLE tabla(id integer primary key, data varchar(20) NOT NULL)')
$adoxCat.activeConnection.close()
}
#=============================================
#---- Adatok beszúrása ----
#=============================================
function Insert-Data
{
$adoConnection.open()

$insertStmt = New-Object -comObject ADODB.command
$insertStmt.activeConnection = $adoConnection
$insertStmt.commandText      ='INSERT INTO tabla values (:num, :txt)'
$insertStmt.commandType      = 1 # adCmdText

$paramNum = $insertStmt.createParameter('num',   3, 1,  4) #   3 = adInteger, 1 = adParamInput,  4 the size
$paramTxt = $insertStmt.createParameter('txt', 200, 1, 20) # 200 = adVarchar, 1 = adParamInput, 20 the size

$insertStmt.parameters.append($paramNum)
$insertStmt.parameters.append($paramTxt)

$paramNum.value = 1; $paramTxt.value ='egy'  ; $insertStmt.execute() | out-null
$paramNum.value = 2; $paramTxt.value ='ketto'; $insertStmt.execute() | out-null
$paramNum.value = 3; $paramTxt.value ='harom'; $insertStmt.execute() | out-null

$adoConnection.close()
}
#=============================================
#---- Adatok lekérdezése ----
#=============================================
Function Select-Data
{
$adoConnection.open()

$recordSet = $adoConnection.execute('SELECT id,data FROM tabla')

while (! $recordSet.eof) 
   {
      write-output "$($recordSet.fields('id').value) | $($recordSet.fields('data').value)"
      $recordSet.moveNext()
   }
$adoConnection.close()
}