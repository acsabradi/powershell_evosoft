#--------------------------------------------------------- 
# ---- Segédfüggvény a szolgáltatásadatok kezeléséhez ----
#----------------------------------------------------------

function Get-ServiceInfo 
{ 
    $array = New-Object System.Collections.ArrayList 
    $Script:svcInfo = Get-Service | ? Status -eq "Running" | Select-Object Status,Name,DisplayName | Sort-Object -Property Name 
    $array.AddRange($svcInfo) 
    $dataGrid.DataSource = $array 
    $form.refresh() 
} 

#------------------------------------------------- 
# ---- A függvény, ami megjeleníti az ablakot ----
#-------------------------------------------------  

function GenerateForm 
{ 

#---------------------------------------------- 
# ---- Osztálykönyvtárak hozzáadása ----
#---------------------------------------------- 

Add-Type -Assembly System.Windows.Forms
Add-Type -Assembly System.Drawing 

#----------------------------------------------
# ---- Ablakkomponensek létrehozása ----
#---------------------------------------------- 

$form = New-Object System.Windows.Forms.Form 
$label = New-Object System.Windows.Forms.Label 
$button1 = New-Object System.Windows.Forms.Button 
$button2 = New-Object System.Windows.Forms.Button 
$button3 = New-Object System.Windows.Forms.Button 
$dataGrid = New-Object System.Windows.Forms.DataGrid 
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Size = New-Object System.Drawing.Size

#----------------------------------------------
# ---- Eseménykezelők ----
#---------------------------------------------- 

$button1_OnClick=  
{ 
    Get-ServiceInfo
} 
 
$button2_OnClick=  
{ 
    $selectedRow = $dataGrid.CurrentRowIndex 

    if (($svcid=$Script:svcInfo[$selectedRow].Name)) 
	{ 
            Stop-Service -Name $svcid
        } 
} 

$button3_OnClick=  
{ 
    $Form.Close() 
} 
 
$OnLoadForm_UpdateGrid= 
{ 
    Get-ServiceInfo
} 

#------------------------------------------
# ---- Ablak tulajdonságainak megadása ----
#------------------------------------------

$form.Text = "Szolgáltatáskezelő" 
$form.Name = "form" 
$form.DataBindings.DefaultDataSourceUpdateMode = 0 
$System_Drawing_Size.Width = 640
$System_Drawing_Size.Height = 480 
$form.ClientSize = $System_Drawing_Size 

#--------------------------------------------------
# ---- Ablakkomponensek elhelyezése az ablakon ----
#--------------------------------------------------

$label.TabIndex = 4 
$System_Drawing_Size.Width = 155 
$System_Drawing_Size.Height = 23 
$label.Size = $System_Drawing_Size 
$label.Text = "Futó szolgáltatások" 
$label.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9.75,2,3,0) 
$label.ForeColor = [System.Drawing.Color]::FromArgb(255,0,102,204) 
 
$System_Drawing_Point.X = 13 
$System_Drawing_Point.Y = 13 
$label.Location = $System_Drawing_Point 
$label.DataBindings.DefaultDataSourceUpdateMode = 0 
$label.Name = "label" 
 
$form.Controls.Add($label) 

#----------------------------------------------  

$button1.TabIndex = 1 
$button1.Name = "button1" 
$System_Drawing_Size.Width = 75 
$System_Drawing_Size.Height = 23 
$button1.Size = $System_Drawing_Size 
$button1.UseVisualStyleBackColor = $True 
 
$button1.Text = "Frissítés" 
 
$System_Drawing_Point.X = 13 
$System_Drawing_Point.Y = 379 
$button1.Location = $System_Drawing_Point 
$button1.DataBindings.DefaultDataSourceUpdateMode = 0 
$button1.add_Click($button1_OnClick) 
 
$form.Controls.Add($button1)

#----------------------------------------------  

$button2.TabIndex = 2 
$button2.Name = "button2" 
$System_Drawing_Size.Width = 125 
$System_Drawing_Size.Height = 23 
$button2.Size = $System_Drawing_Size 
$button2.UseVisualStyleBackColor = $True 
 
$button2.Text = "Szolgáltatás leállítása" 
 
$System_Drawing_Point.X = 230 
$System_Drawing_Point.Y = 378 
$button2.Location = $System_Drawing_Point 
$button2.DataBindings.DefaultDataSourceUpdateMode = 0 
$button2.add_Click($button2_OnClick) 
 
$form.Controls.Add($button2) 

#----------------------------------------------  

$button3.TabIndex = 3 
$button3.Name = "button3" 
$System_Drawing_Size.Width = 85 
$System_Drawing_Size.Height = 23 
$button3.Size = $System_Drawing_Size 
$button3.UseVisualStyleBackColor = $True 
 
$button3.Text = "Bezárás" 
 
$System_Drawing_Point.X = 429 
$System_Drawing_Point.Y = 378 
$button3.Location = $System_Drawing_Point 
$button3.DataBindings.DefaultDataSourceUpdateMode = 0 
$button3.add_Click($button3_OnClick) 
 
$form.Controls.Add($button3) 

#----------------------------------------------  

$System_Drawing_Size.Width = 620 
$System_Drawing_Size.Height = 310 
$dataGrid.Size = $System_Drawing_Size 
$dataGrid.DataBindings.DefaultDataSourceUpdateMode = 0 
$dataGrid.HeaderForeColor = [System.Drawing.Color]::FromArgb(255,0,0,0) 
$dataGrid.Name = "dataGrid" 
$dataGrid.DataMember = "" 
$dataGrid.TabIndex = 0 
$System_Drawing_Point.X = 13 
$System_Drawing_Point.Y = 48 
$dataGrid.Location = $System_Drawing_Point 
 
$form.Controls.Add($dataGrid) 

#-----------------------------------------------------
# ---- Ablak feltöltése adatokkal és megjelenítés ----
#-----------------------------------------------------
 
$form.add_Load($OnLoadForm_UpdateGrid) 

$form.ShowDialog()| Out-Null 
 
} 
 
#--------------------------------------------------
# ---- Függvény hívása ----
#--------------------------------------------------

GenerateForm

#--------------------------------------------------