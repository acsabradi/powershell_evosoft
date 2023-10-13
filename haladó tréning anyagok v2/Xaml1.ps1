#---------------------------------------------- 
# ---- XAML beolvasása ---
#---------------------------------------------- 
$inputXML = Get-Content "C:\Powershell\Democode\xaml1.xml"
[xml]$XAML = $inputXML
#---------------------------------------------- 
# ---- Osztálykönyvtárak hozzáadása ----
#---------------------------------------------- 
Add-Type –assemblyName PresentationFramework
#---------------------------------------------- 
# ---- XAML felolvasása/Ablak létrehozása ---- 
#---------------------------------------------- 
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
#---------------------------------------------- 
# ---- Komponensek változókhoz rendelése ----
#---------------------------------------------- 
$validateButton = $window.FindName("ValidateButton")
$pathTextBox = $window.FindName("PathTextBox")
#---------------------------------------------- 
# ---- ValidateButton Click esemény ----
#---------------------------------------------- 
$ValidateButton.Add_Click({
    if(!(Test-Path $pathTextBox.Text))
      {
        $pathTextBox.Text = "Nem létezik az elérési útvonal!"
      }
    else
      {
        $pathTextBox.Text = "Az elérési útvonal rendben!"
      }
  
})
#---------------------------------------------- 
# ---- Ablak megjelenítése ----
#---------------------------------------------- 
$window.ShowDialog()
#---------------------------------------------- 