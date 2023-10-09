#---------------------------------------------- 
# ---- XAML beolvasása ---
#---------------------------------------------- 
$inputXML = Get-Content -Path ".\Xaml2.xml"
# ---- Ismert problémák javítása ---
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[xml]$XAML = $inputXML
#---------------------------------------------- 
# ---- Osztálykönyvtárak hozzáadása ----
#---------------------------------------------- 
Add-Type –assemblyName PresentationFramework
Add-Type –assemblyName PresentationCore
Add-Type –assemblyName WindowsBase
#---------------------------------------------- 
# ---- XAML felolvasása/Hibaüzenet ---- 
#---------------------------------------------- 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
try{
    $Form=[Windows.Markup.XamlReader]::Load( $reader )
}
catch{
    Write-Warning "Nem lehet feldolgozni az XML-t, a következő hibával: $($Error[0])`n Ellenőrizd hogy a szövegmezőknek NINCS SelectionChanged vagy TextChanged tagjellemzője ( a PowerShell nem tudja feldolgozni)."
    throw
}
#---------------------------------------------- 
# ---- Komponensek változókhoz rendelése ----
#---------------------------------------------- 
$xaml.SelectNodes("//*[@Name]") | %{
    try {Set-Variable -Name "$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}
    catch{throw}
    }
#---------------------------------------------- 
# ---- Komponensek tulajdonságbeállítása ----
#---------------------------------------------- 
$bSubmit.Content = "Ellenőrzés"
$lLabel.Content = "Hello User!"
$tbUsername.Text = "User"
#---------------------------------------------- 
# ---- BSubmit gomb Click esemény ----
#---------------------------------------------- 
$bSubmit.Add_Click({
    if ($tbUsername.Text -ne "" -and $tbUsername.Text -ne "User")
        {
	if ($pbPassword.Password -ne "") 
	   {
             $lLabel.Content = "Hello " + $tbUsername.Text + "! A jelszavad: " + $pbPassword.Password 
           }
        else
           {
             $lLabel.Content = "Hello " + $tbUsername.Text + "! A jelszavad üres."
           }
        }
    })
#---------------------------------------------- 
# ---- Ablak megjelenítése ----
#---------------------------------------------- 
$form.ShowDialog() | Out-Null
#---------------------------------------------- 