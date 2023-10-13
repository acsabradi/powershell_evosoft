# Adjuk hozzá a Windows.Forms .NET osztályhierarchiát és importáljuk be az Active Directory modult
Add-Type -assembly System.Windows.Forms
# Import-Module ActiveDirectory - amennyiben AD-t használnánk

# Hozzuk létre az ablakot
$main_form = New-Object System.Windows.Forms.Form

# Állítsuk be az ablak tulajdonságait
$main_form.Text ='Felhasználók lekérdezése'
$main_form.Width = 600
$main_form.Height = 200
$main_form.StartPosition = "CenterScreen"

# Ha nem férnének el az elemek, automatikusan növelje meg az ablak méretét a rendszer
$main_form.AutoSize = $true

# Cimke hozzáadása
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Felhasználók"
$Label.Location  = New-Object System.Drawing.Point(0,10)
$Label.AutoSize = $true
$main_form.Controls.Add($Label)

# Lenyíló lista létrehozása
$ComboBox = New-Object System.Windows.Forms.ComboBox
$ComboBox.Width = 300

# Lenyíló lista feltöltése
# $Users = Get-Aduser -filter * -Properties SamAccountName
$Users = (Get-LocalUser).Name    
Foreach ($User in $Users)
  {
     $ComboBox.Items.Add($User) | Out-Null
  }

# Lenyíló lista hozzáadása az ablakhoz
$ComboBox.Location  = New-Object System.Drawing.Point(100,10)
$main_form.Controls.Add($ComboBox)

# Még egy címke...
$Label2 = New-Object System.Windows.Forms.Label
$Label2.Text = "Biztonsági azonosító:"
$Label2.Location  = New-Object System.Drawing.Point(0,40)
$Label2.AutoSize = $true
$main_form.Controls.Add($Label2)

# És az utolsó...
$Label3 = New-Object System.Windows.Forms.Label
$Label3.Text = ""
$Label3.Location  = New-Object System.Drawing.Point(110,40)
$Label3.AutoSize = $true
$main_form.Controls.Add($Label3)

# Gomb hozzáadása
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Point(420,10)
$Button.Size = New-Object System.Drawing.Size(120,23)
$Button.Text = "Ellenőrzés"
$main_form.Controls.Add($Button)

# Eseménykezelő hozzáadása
$Button.Add_Click({
	If ($ComboBox.selectedItem)
          {
            $Label3.ForeColor = "Black"
	   #$Label3.Text =  ((Get-ADUser -Identity $ComboBox.selectedItem).SID).Value
            $Label3.Text =  ((Get-LocalUser -Name $ComboBox.selectedItem).SID).Value 
          }
        Else
          {
           $Label3.ForeColor = "Red"
           $Label3.Text =  "Válassz egy felhasználót!"
          }
  })

# Bezáró gomb hozzáadása
$CloseButton = New-Object System.Windows.Forms.Button
$Left = $main_form.Width/2-60
$CloseButton.Location = New-Object System.Drawing.Point($Left,100)
$CloseButton.Size = New-Object System.Drawing.Size(120,30)
$CloseButton.Text = "Bezárás"
$main_form.Controls.Add($CloseButton)

# Eseménykezelő hozzáadása
$CloseButton.Add_Click({$main_form.Close()})

# Az ablak megjelenítése
$main_form.ShowDialog() | Out-Null