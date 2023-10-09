#
# WmiExplorer.ps1
#
# A GUI WMI explorer and WMI Method Help generator
#
# /\/\o\/\/ 2006 
# www.ThePowerShellGuy.com
#

# load Forms NameSpace

[void][System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")
[void][reflection.assembly]::LoadWithPartialName("System.Drawing")
 
#region BuildTheForm build in C# then translated to powershell

#region Make the form

$frmMain = new-object Windows.Forms.form   
$frmMain.Size = new-object System.Drawing.Size @(800,600)   
$frmMain.text = "/\/\o\/\/'s PowerShell WMI Explorer"  

#endregion Make the form

#region Define Used Controls

$MainMenu = new-object System.Windows.Forms.MenuStrip 
$statusStrip = new-object System.Windows.Forms.StatusStrip
$FileMenu = new-object System.Windows.Forms.ToolStripMenuItem
$ToolMenu = new-object System.Windows.Forms.ToolStripMenuItem('&tools')

$miQuery = new-object System.Windows.Forms.ToolStripMenuItem('&Query (run)')

$miSelectQuery = new-object System.Windows.Forms.ToolStripMenuItem('&SelectQuery')
$miSelectQuery.add_Click({$sq | out-propertyGrid;$wmiSearcher.Query = $sq})
[void]$ToolMenu.DropDownItems.Add($miSelectQuery)

$miRelatedObjectQuery = new-object System.Windows.Forms.ToolStripMenuItem('&RelatedObjectQuery')
$miRelatedObjectQuery.add_Click({$roq | out-propertyGrid;$wmiSearcher.Query = $roq})
[void]$ToolMenu.DropDownItems.Add($miRelatedObjectQuery)

$miRelationshipQuery = new-object System.Windows.Forms.ToolStripMenuItem('&RelationshipQuery')
$miRelationshipQuery.add_Click({$rq | out-propertyGrid ;$wmiSearcher.Query = $rq})
[void]$ToolMenu.DropDownItems.Add($miRelationshipQuery)

$oq = new-object System.Management.ObjectQuery
$eq = new-object System.Management.EventQuery
$sq = new-object System.Management.SelectQuery
$roq = new-object System.Management.RelatedObjectQuery
$rq = new-object System.Management.RelationshipQuery
$wmiSearcher = [wmisearcher]''
[void]$ToolMenu.DropDownItems.Add($miQuery)

$miQuery.add_Click({

    $wmiSearcher | out-propertyGrid
    $moc = $wmiSearcher.get()
    $DT =  new-object  System.Data.DataTable 
    $DT.TableName = $lblClass.text
    $Col =  new-object System.Data.DataColumn
    $Col.ColumnName = "WmiPath"
    $DT.Columns.Add($Col)

    $i = 0
    $j = 0 ;$lblInstances.Text = $j; $lblInstances.Update()

    $MOC | 
    ForEach-Object {
        $j++ ;$lblInstances.Text = $j; $lblInstances.Update()
        $MO = $_ 
        
        # Make a DataRow 

        $DR = $DT.NewRow() 
        $Col =  new-object System.Data.DataColumn
        $DR.Item("WmiPath") = $mo.__PATH

        $MO.psbase.properties | 
        ForEach-Object { 
        
            $prop = $_ 
            
            If ($i -eq 0)  { 
    
                # Only On First Row make The Headers 
                
                $Col =  new-object System.Data.DataColumn 
                $Col.ColumnName = $prop.Name.ToString()
 
                $prop.psbase.Qualifiers | 
                ForEach-Object { 
                    If ($_.Name.ToLower() -eq "key") { 
                        $Col.ColumnName = $Col.ColumnName + "*" 
                    } 
                } 
                $DT.Columns.Add($Col)  
            } 
            
            # fill dataRow  
            
            if ($prop.value -eq $null) { 
                $DR.Item($prop.Name) = "[empty]" 
            } ElseIf ($prop.IsArray) { 
                $DR.Item($prop.Name) =[string]::Join($prop.value ,";") 
            } Else { 
                $DR.Item($prop.Name) = $prop.value 
                #Item is Key try again with * 
                trap{$DR.Item("$($prop.Name)*") = $prop.Value.tostring();continue} 
            } 

        } #end ForEach

        # Add the row to the DataTable 
        
        $DT.Rows.Add($DR) 
        $i += 1 

    }

    $DGInstances.DataSource = $DT.psObject.baseobject   
    $status.Text = "Retrieved $j Instances"
    $status.BackColor = 'YellowGreen'
    $statusstrip.Update()

})#$miQuery.add_Click


$miQuit = new-object System.Windows.Forms.ToolStripMenuItem('&quit')

$miQuit.add_Click({$frmMain.close()})  

$SplitContainer1 = new-object System.Windows.Forms.SplitContainer
$splitContainer2 = new-object System.Windows.Forms.SplitContainer
$splitContainer3 = new-object System.Windows.Forms.SplitContainer

$grpComputer = new-object System.Windows.Forms.GroupBox
$grpNameSpaces = new-object System.Windows.Forms.GroupBox
$grpClasses = new-object System.Windows.Forms.GroupBox
$grpClass = new-object System.Windows.Forms.GroupBox
$grpInstances = new-object System.Windows.Forms.GroupBox
$grpStatus = new-object System.Windows.Forms.GroupBox

$txtComputer = new-object System.Windows.Forms.TextBox
$btnConnect = new-object System.Windows.Forms.Button
$btnInstances = new-object System.Windows.Forms.Button

$tvNameSpaces = new-object System.Windows.Forms.TreeView
$lvClasses = new-object System.Windows.Forms.ListView

$clbProperties = new-object System.Windows.Forms.CheckedListBox
$clbProperties.CheckOnClick = $true
$lbMethods = new-object System.Windows.Forms.ListBox

$label1 = new-object System.Windows.Forms.Label
$label2 = new-object System.Windows.Forms.Label
$lblServer = new-object System.Windows.Forms.Label
$lblPath = new-object System.Windows.Forms.Label
$lblNameSpace = new-object System.Windows.Forms.Label
$label6 = new-object System.Windows.Forms.Label
$lblClass = new-object System.Windows.Forms.Label
$label10 = new-object System.Windows.Forms.Label
$lblClasses = new-object System.Windows.Forms.Label
$label12 = new-object System.Windows.Forms.Label
$lblProperties = new-object System.Windows.Forms.Label
$label8 = new-object System.Windows.Forms.Label
$lblMethods = new-object System.Windows.Forms.Label
$label14 = new-object System.Windows.Forms.Label
$lblInstances = new-object System.Windows.Forms.Label
$label16 = new-object System.Windows.Forms.Label

$dgInstances = new-object System.Windows.Forms.DataGridView
$TabControl = new-object System.Windows.Forms.TabControl
$tabPage1 = new-object System.Windows.Forms.TabPage
$tabInstances = new-object System.Windows.Forms.TabPage
$rtbHelp = new-object System.Windows.Forms.RichTextBox
$tabMethods = new-object System.Windows.Forms.TabPage
$rtbMethods = new-object System.Windows.Forms.RichTextBox
#endregion Define Used Controls        

#region Suspend the Layout

$splitContainer1.Panel1.SuspendLayout()
$splitContainer1.Panel2.SuspendLayout()
$splitContainer1.SuspendLayout()
$splitContainer2.Panel1.SuspendLayout()
$splitContainer2.Panel2.SuspendLayout()
$splitContainer2.SuspendLayout()
$grpComputer.SuspendLayout()
$grpNameSpaces.SuspendLayout()
$grpClasses.SuspendLayout()
$splitContainer3.Panel1.SuspendLayout()
$splitContainer3.Panel2.SuspendLayout()
$splitContainer3.SuspendLayout()
$grpClass.SuspendLayout()
$grpStatus.SuspendLayout()
$grpInstances.SuspendLayout()
$TabControl.SuspendLayout()
$tabPage1.SuspendLayout()
$tabInstances.SuspendLayout()
$FrmMain.SuspendLayout()

#endregion Suspend the Layout

#region Configure Controls

[void]$MainMenu.Items.Add($FileMenu) 
[void]$MainMenu.Items.Add($ToolMenu) 
$MainMenu.Location = new-object System.Drawing.Point(0, 0)
$MainMenu.Name = "MainMenu"
$MainMenu.Size = new-object System.Drawing.Size(1151, 24)
$MainMenu.TabIndex = 0
$MainMenu.Text = "Main Menu"

# 
# statusStrip1
# 
$statusStrip.Location = new-object System.Drawing.Point(0, 569)
$statusStrip.Name = "statusStrip"
$statusStrip.Size = new-object System.Drawing.Size(1151, 22);
$statusStrip.TabIndex = 1
$statusStrip.Text = "statusStrip"

$splitContainer1.Dock = [System.Windows.Forms.DockStyle]::Fill
$splitContainer1.Location = new-object System.Drawing.Point(0, 24)
$splitContainer1.Name = "splitContainer1"
$splitContainer1.Panel1.Controls.Add($splitContainer2)

$splitContainer1.Panel2.Controls.Add($splitContainer3)
$splitContainer1.Size = new-object System.Drawing.Size(1151, 545)
$splitContainer1.SplitterDistance = 372
$splitContainer1.TabIndex = 2

$splitContainer2.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$splitContainer2.Dock = [System.Windows.Forms.DockStyle]::Fill
$splitContainer2.Location = new-object System.Drawing.Point(0, 0)
$splitContainer2.Name = "splitContainer2"
$splitContainer2.Orientation = [System.Windows.Forms.Orientation]::Horizontal

$splitContainer2.Panel1.BackColor = [System.Drawing.SystemColors]::Control
$splitContainer2.Panel1.Controls.Add($grpNameSpaces)
$splitContainer2.Panel1.Controls.Add($btnConnect)
$splitContainer2.Panel1.Controls.Add($grpComputer)

$splitContainer2.Panel2.Controls.Add($grpClasses)
$splitContainer2.Size = new-object System.Drawing.Size(372, 545)
$splitContainer2.SplitterDistance = 302
$splitContainer2.TabIndex = 0

# 
# fileMenu
# 
[void]$fileMenu.DropDownItems.Add($miQuit)
$fileMenu.Name = "fileMenu"
$fileMenu.Size = new-object System.Drawing.Size(35, 20)
$fileMenu.Text = "&File"

$grpComputer.Anchor = "top, left, right"
$grpComputer.Controls.Add($txtComputer)
$grpComputer.Location = new-object System.Drawing.Point(12, 3)
$grpComputer.Name = "grpComputer"
$grpComputer.Size = new-object System.Drawing.Size(340, 57)
$grpComputer.TabIndex = 0
$grpComputer.TabStop = $false
$grpComputer.Text = "Computer"

$txtComputer.Anchor = "top, left, right"
$txtComputer.Location = new-object System.Drawing.Point(7, 20)
$txtComputer.Name = "txtComputer"
$txtComputer.Size = new-object System.Drawing.Size(244, 20)
$txtComputer.TabIndex = 0
$txtComputer.Text = "."


$btnConnect.Anchor = "top, right"
$btnConnect.Location = new-object System.Drawing.Point(269, 23);
$btnConnect.Name = "btnConnect"
$btnConnect.Size = new-object System.Drawing.Size(75, 23)
$btnConnect.TabIndex = 1
$btnConnect.Text = "Connect"
$btnConnect.UseVisualStyleBackColor = $true

# 
# grpNameSpaces
# 
$grpNameSpaces.Anchor = "Bottom, top, left, right"
$grpNameSpaces.Controls.Add($tvNameSpaces)
$grpNameSpaces.Location = new-object System.Drawing.Point(12, 67)
$grpNameSpaces.Name = "grpNameSpaces"
$grpNameSpaces.Size = new-object System.Drawing.Size(340, 217)
$grpNameSpaces.TabIndex = 2
$grpNameSpaces.TabStop = $false
$grpNameSpaces.Text = "NameSpaces"
# 
# grpClasses
# 
$grpClasses.Anchor = "Bottom, top, left, right"

$grpClasses.Controls.Add($lvClasses)
$grpClasses.Location = new-object System.Drawing.Point(12, 14)
$grpClasses.Name = "grpClasses"
$grpClasses.Size = new-object System.Drawing.Size(340, 206)
$grpClasses.TabIndex = 0
$grpClasses.TabStop = $False
$grpClasses.Text = "Classes"
# 
# tvNameSpaces
# 
$tvNameSpaces.Anchor = "Bottom, top, left, right"

$tvNameSpaces.Location = new-object System.Drawing.Point(7, 19)
$tvNameSpaces.Name = "tvNameSpaces"
$tvNameSpaces.Size = new-object System.Drawing.Size(325, 184)
$tvNameSpaces.TabIndex = 0
# 
# tvClasses
# 
$lvClasses.Anchor = "Bottom, top, left, right"

$lvClasses.Location = new-object System.Drawing.Point(7, 19)
$lvClasses.Name = "tvClasses"
$lvClasses.Size = new-object System.Drawing.Size(325, 172)
$lvClasses.TabIndex = 0
$lvClasses.UseCompatibleStateImageBehavior = $False
$lvClasses.ShowItemToolTips = $true
$lvClasses.View = 'Details'
$colName = $lvClasses.Columns.add('Name')
$colname.Width = 160
$colPath = $lvClasses.Columns.add('Description')
$colname.Width = 260
$colPath = $lvClasses.Columns.add('Path')
$colname.Width = 260
# 
# splitContainer3
# 
$splitContainer3.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$splitContainer3.Dock = [System.Windows.Forms.DockStyle]::Fill
$splitContainer3.Location = new-object System.Drawing.Point(0, 0)
$splitContainer3.Name = "splitContainer3"
$splitContainer3.Orientation = [System.Windows.Forms.Orientation]::Horizontal
# 
# splitContainer3.Panel1
# 
$splitContainer3.Panel1.Controls.Add($grpStatus)
$splitContainer3.Panel1.Controls.Add($grpClass)
# 
# splitContainer3.Panel2
# 
$splitContainer3.Panel2.Controls.Add($TabControl)
$splitContainer3.Size = new-object System.Drawing.Size(775, 545)
$splitContainer3.SplitterDistance = 303
$splitContainer3.TabIndex = 0
# 
# grpClass
# 
$grpClass.Anchor = "Bottom, top, left, right"
$grpClass.Controls.Add($lblInstances)
$grpClass.Controls.Add($label16)
$grpClass.Controls.Add($lblMethods)
$grpClass.Controls.Add($label14)
$grpClass.Controls.Add($lblProperties)
$grpClass.Controls.Add($label8)
$grpClass.Controls.Add($lblClass)
$grpClass.Controls.Add($label10)
$grpClass.Controls.Add($lbMethods)
$grpClass.Controls.Add($clbProperties)
$grpClass.Controls.Add($btnInstances)
$grpClass.Location = new-object System.Drawing.Point(17, 86)
$grpClass.Name = "grpClass"
$grpClass.Size = new-object System.Drawing.Size(744, 198)
$grpClass.TabIndex = 0
$grpClass.TabStop = $False
$grpClass.Text = "Class"

# 
# btnInstances
# 
$btnInstances.Anchor = "Bottom, Left"
$btnInstances.Location = new-object System.Drawing.Point(6, 169);
$btnInstances.Name = "btnInstances";
$btnInstances.Size = new-object System.Drawing.Size(96, 23);
$btnInstances.TabIndex = 0;
$btnInstances.Text = "Get Instances";
$btnInstances.UseVisualStyleBackColor = $true
# 
# grpStatus
# 
$grpStatus.Anchor = "Top,Left,Right"
$grpStatus.Controls.Add($lblClasses)
$grpStatus.Controls.Add($label12)
$grpStatus.Controls.Add($lblNameSpace)
$grpStatus.Controls.Add($label6)
$grpStatus.Controls.Add($lblPath)
$grpStatus.Controls.Add($lblServer)
$grpStatus.Controls.Add($label2)
$grpStatus.Controls.Add($label1)
$grpStatus.Location = new-object System.Drawing.Point(17, 3)
$grpStatus.Name = "grpStatus"
$grpStatus.Size = new-object System.Drawing.Size(744, 77)
$grpStatus.TabIndex = 1
$grpStatus.TabStop = $False
$grpStatus.Text = "Status"
# 
# label1
# 
$label1.AutoSize = $true
$label1.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$label1.Location = new-object System.Drawing.Point(7, 20)
$label1.Name = "label1"
$label1.Size = new-object System.Drawing.Size(62, 16)
$label1.TabIndex = 0
$label1.Text = "Server :"
# 
# label2
# 
$label2.AutoSize = $true
$label2.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$label2.Location = new-object System.Drawing.Point(7, 41)
$label2.Name = "label2"
$label2.Size = new-object System.Drawing.Size(51, 16)
$label2.TabIndex = 1
$label2.Text = "Path  :"
# 
# lblServer
# 
$lblServer.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$lblServer.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$lblServer.Location = new-object System.Drawing.Point(75, 20)
$lblServer.Name = "lblServer"
$lblServer.Size = new-object System.Drawing.Size(144, 20)
$lblServer.TabIndex = 2
# 
# lblPath
# 
$lblPath.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$lblPath.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$lblPath.Location = new-object System.Drawing.Point(75, 40)
$lblPath.Name = "lblPath"
$lblPath.Size = new-object System.Drawing.Size(567, 20)
$lblPath.TabIndex = 3
# 
# lblNameSpace
# 
$lblNameSpace.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$lblNameSpace.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$lblNameSpace.Location = new-object System.Drawing.Point(337, 20)
$lblNameSpace.Name = "lblNameSpace"
$lblNameSpace.Size = new-object System.Drawing.Size(144, 20)
$lblNameSpace.TabIndex = 5
# 
# label6
# 
$label6.AutoSize = $true
$label6.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$label6.Location = new-object System.Drawing.Point(229, 20)
$label6.Name = "label6"
$label6.Size = new-object System.Drawing.Size(102, 16)
$label6.TabIndex = 4
$label6.Text = "NameSpace :"
# 
# lblClass
# 
$lblClass.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$lblClass.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$lblClass.Location = new-object System.Drawing.Point(110, 26)
$lblClass.Name = "lblClass"
$lblClass.Size = new-object System.Drawing.Size(159, 20)
$lblClass.TabIndex = 11
# 
# label10
# 
$label10.AutoSize = $true
$label10.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$label10.Location = new-object System.Drawing.Point(6, 26)
$label10.Name = "label10"
$label10.Size = new-object System.Drawing.Size(55, 16)
$label10.TabIndex = 10
$label10.Text = "Class :"
# 
# lblClasses
# 
$lblClasses.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$lblClasses.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$lblClasses.Location = new-object System.Drawing.Point(595, 21)
$lblClasses.Name = "lblClasses"
$lblClasses.Size = new-object System.Drawing.Size(47, 20)
$lblClasses.TabIndex = 9
# 
# label12
# 
$label12.AutoSize = $true
$label12.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$label12.Location = new-object System.Drawing.Point(487, 21)
$label12.Name = "label12"
$label12.Size = new-object System.Drawing.Size(76, 16)
$label12.TabIndex = 8
$label12.Text = "Classes  :"
# 
# clbProperties
# 
$clbProperties.Anchor = "Bottom, top,left"
$clbProperties.FormattingEnabled = $true
$clbProperties.Location = new-object System.Drawing.Point(510, 27)
$clbProperties.Name = "clbProperties"
$clbProperties.Size = new-object System.Drawing.Size(220, 160)
$clbProperties.TabIndex = 1
# 
# lbMethods
# 
$lbMethods.Anchor = "Bottom, top, Left"
$lbMethods.FormattingEnabled = $true
$lbMethods.Location = new-object System.Drawing.Point(280, 27)
$lbMethods.Name = "lbMethods"
$lbMethods.Size = new-object System.Drawing.Size(220, 160)
$lbMethods.TabIndex = 2
# 
# lblProperties
# 
$lblProperties.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$lblProperties.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$lblProperties.Location = new-object System.Drawing.Point(110, 46)
$lblProperties.Name = "lblProperties"
$lblProperties.Size = new-object System.Drawing.Size(119, 20)
$lblProperties.TabIndex = 13
#
# label8
# 
$label8.AutoSize = $true
$label8.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$label8.Location = new-object System.Drawing.Point(6, 46)
$label8.Name = "label8"
$label8.Size = new-object System.Drawing.Size(88, 16)
$label8.TabIndex = 12
$label8.Text = "Properties :"
# 
# lblMethods
# 
$lblMethods.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$lblMethods.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$lblMethods.Location = new-object System.Drawing.Point(110, 66)
$lblMethods.Name = "lblMethods"
$lblMethods.Size = new-object System.Drawing.Size(119, 20)
$lblMethods.TabIndex = 15
# 
# label14
# 
$label14.AutoSize = $true
$label14.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$label14.Location = new-object System.Drawing.Point(6, 66)
$label14.Name = "label14"
$label14.Size = new-object System.Drawing.Size(79, 16)
$label14.TabIndex = 14
$label14.Text = "Methods  :"
# 
# lblInstances
# 
$lblInstances.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$lblInstances.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$lblInstances.Location = new-object System.Drawing.Point(110, 86)
$lblInstances.Name = "lblInstances"
$lblInstances.Size = new-object System.Drawing.Size(119, 20)
$lblInstances.TabIndex = 17
# 
# label16
# 
$label16.AutoSize = $true
$label16.Font = new-object System.Drawing.Font("Microsoft Sans Serif",9.75 ,[System.Drawing.FontStyle]::Bold)
$label16.Location = new-object System.Drawing.Point(6, 86)
$label16.Name = "label16"
$label16.Size = new-object System.Drawing.Size(82, 16)
$label16.TabIndex = 16
$label16.Text = "Instances :"
# 
# grpInstances
# 
$grpInstances.Anchor = "Bottom, top, left, right"
$grpInstances.Controls.Add($dgInstances)
$grpInstances.Location = new-object System.Drawing.Point(17, 17)
$grpInstances.Name = "grpInstances"
$grpInstances.Size = new-object System.Drawing.Size(744, 202)
$grpInstances.TabIndex = 0
$grpInstances.TabStop = $False
$grpInstances.Text = "Instances"
# 
# dgInstances
# 
$dgInstances.Anchor = "Bottom, top, left, right"

$dgInstances.ColumnHeadersHeightSizeMode = [System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode]::AutoSize
$dgInstances.Location = new-object System.Drawing.Point(10, 19)
$dgInstances.Name = "dgInstances"
$dgInstances.Size = new-object System.Drawing.Size(728, 167)
$dgInstances.TabIndex = 0
$dginstances.ReadOnly = $true

# TabControl
# 
$TabControl.Controls.Add($tabPage1)
$TabControl.Controls.Add($tabInstances)
$TabControl.Controls.Add($tabMethods)
$TabControl.Dock = [System.Windows.Forms.DockStyle]::Fill
$TabControl.Location = new-object System.Drawing.Point(0, 0)
$TabControl.Name = "TabControl"
$TabControl.SelectedIndex = 0
$TabControl.Size = new-object System.Drawing.Size(771, 234)
$TabControl.TabIndex = 0
# 
# tabPage1
# 
$tabPage1.Controls.Add($rtbHelp)
$tabPage1.Location = new-object System.Drawing.Point(4, 22)
$tabPage1.Name = "tabPage1"
$tabPage1.Padding = new-object System.Windows.Forms.Padding(3)
$tabPage1.Size = new-object System.Drawing.Size(763, 208)
$tabPage1.TabIndex = 0
$tabPage1.Text = "Help"
$tabPage1.UseVisualStyleBackColor = $true
# 
# tabInstances
# 
$tabInstances.Controls.Add($grpInstances)
$tabInstances.Location = new-object System.Drawing.Point(4, 22)
$tabInstances.Name = "tabInstances"
$tabInstances.Padding = new-object System.Windows.Forms.Padding(3)
$tabInstances.Size = new-object System.Drawing.Size(763, 208)
$tabInstances.TabIndex = 1
$tabInstances.Text = "Instances"
$tabInstances.UseVisualStyleBackColor = $true
# 
# richTextBox1
# 
$rtbHelp.Dock = [System.Windows.Forms.DockStyle]::Fill
$rtbHelp.Location = new-object System.Drawing.Point(3, 3)
$rtbHelp.Name = "richTextBox1"
$rtbHelp.Size = new-object System.Drawing.Size(757, 202)
$rtbHelp.TabIndex = 0
$rtbHelp.Text = ""
# 
# tabMethods
# 
$tabMethods.Location = new-object System.Drawing.Point(4, 22)
$tabMethods.Name = "tabMethods"
$tabMethods.Padding = new-object System.Windows.Forms.Padding(3)
$tabMethods.Size = new-object System.Drawing.Size(763, 208)
$tabMethods.TabIndex = 2
$tabMethods.Text = "Methods"
$tabMethods.UseVisualStyleBackColor = $true


        $rtbMethods.Dock = [System.Windows.Forms.DockStyle]::Fill
        $rtbMethods.Font = new-object System.Drawing.Font("Lucida Console",8 )
        $rtbMethods.DetectUrls = $false
        $tabMethods.controls.add($rtbMethods)
        
#endregion Configure Controls

# Configure  Main Form 

#region frmMain


# 
$frmMain.AutoScaleDimensions = new-object System.Drawing.SizeF(6, 13)
$frmMain.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
$frmMain.ClientSize = new-object System.Drawing.Size(1151, 591)
$frmMain.Controls.Add($splitContainer1)
$frmMain.Controls.Add($statusStrip)
$frmMain.Controls.Add($MainMenu)
$frmMain.MainMenuStrip = $mainMenu
$FrmMain.Name = "frmMain"
$FrmMain.Text = "/\/\o\/\/ PowerShell WMI Browser"
$mainMenu.ResumeLayout($false)
$mainMenu.PerformLayout()
$MainMenu.ResumeLayout($false)
$MainMenu.PerformLayout()
$splitContainer1.Panel1.ResumeLayout($false)
$splitContainer1.Panel2.ResumeLayout($false)
$splitContainer1.ResumeLayout($false)
$splitContainer2.Panel1.ResumeLayout($false)
$splitContainer2.Panel2.ResumeLayout($false)
$splitContainer2.ResumeLayout($false)
$grpComputer.ResumeLayout($false)
$grpComputer.PerformLayout()
$grpNameSpaces.ResumeLayout($false)
$grpClasses.ResumeLayout($false)
$splitContainer3.Panel1.ResumeLayout($false)
$splitContainer3.Panel2.ResumeLayout($false)
$splitContainer3.ResumeLayout($false)
$grpClass.ResumeLayout($false)
$grpClass.PerformLayout()
$grpStatus.ResumeLayout($false)
$grpStatus.PerformLayout()
$grpInstances.ResumeLayout($false)
$TabControl.ResumeLayout($false)
$tabPage1.ResumeLayout($false)
$tabInstances.ResumeLayout($false)
$frmMain.ResumeLayout($false)
$FrmMain.PerformLayout()

$status = new-object System.Windows.Forms.ToolStripStatusLabel
$status.BorderStyle = 'SunkenInner'
$status.BorderSides = 'All'
$status.Text = "Not Connected"
[void]$statusStrip.Items.add($status)
$slMessage = new-object System.Windows.Forms.ToolStripStatusLabel
$slMessage.BorderStyle = 'SunkenInner'
$slMessage.BorderSides = 'All'
$slMessage.Text = ""
[void]$statusStrip.Items.add($slMessage)
#endregion frmMain
#endregion

#region Helper Functions

Function out-PropertyGrid { 
  Param ($Object,[switch]$noBase,[Switch]$array) 

  $PsObject = $null 
  if ($object) { 
      $PsObject = $object 
  }Else{ 
     if ($Array.IsPresent) { 
         $PsObject = @() 
         $input |ForEach-Object {$PsObject += $_} 
     }Else{ 
         $input |ForEach-Object {$PsObject = $_} 
     } 
  } 

  if ($PsObject){ 
      $form = new-object Windows.Forms.Form  
      $form.Size = new-object Drawing.Size @(600,600)  
      $PG = new-object Windows.Forms.PropertyGrid  
      $PG.Dock = 'Fill'  
      $form.text = "$psObject"  

      if ($noBase.IsPresent) {"no"; 
          $PG.selectedobject = $psObject  
      }Else{ 
          $PG.selectedobject = $psObject.PsObject.baseobject  
      }  
      $form.Controls.Add($PG)  
      $Form.Add_Shown({$form.Activate()})   
      $form.showdialog() 
  } 

} #Function out-PropertyGrid

Function Update-Status {
  $script:computer = $Script:NameSpaces.__SERVER
  $txtComputer.Text = $script:computer
  $lblPath.Text = $Script:NameSpaces.__PATH                                
  $lblProperties.Text = $Script:NameSpaces.__PROPERTY_COUNT                                
  $lblClass.Text = $Script:NameSpaces.__RELPATH                                    
  $lblServer.Text = $script:Computer
  $lblnamespace.Text = $Script:NameSpaces.__NAMESPACE
} # Function Update-Status

Function Set-StatusBar ($Color,$Text) {
  $status.BackColor = $color
  $status.Text = $text
  $statusstrip.Update()   
}

#endregion Helper Functions

#################### Main ###############################

#region Global Variables

$FontBold = new-object System.Drawing.Font("Microsoft Sans Serif",8,[Drawing.FontStyle]'Bold' )
$fontNormal = new-object System.Drawing.Font("Microsoft Sans Serif",8,[Drawing.FontStyle]'Regular')
$fontCode = new-object System.Drawing.Font("Lucida Console",8 )

# Create Script Variables for WMI Connection

$Script:ConnectionOptions = new-object System.Management.ConnectionOptions
$script:WmiConnection = new-object system.management.ManagementScope
$script:WmiClass = [wmiClass]''

# NamespaceCaching , Make HashTable to store Treeview Items

$script:nsc = @{}

# Make DataSet for secondary Cache

$Script:dsCache = new-object data.dataset

if (-not ${Global:WmiExplorer.dtClasses}){
    ${Global:WmiExplorer.dtClasses} = new-object data.datatable
    [VOID](${Global:WmiExplorer.dtClasses}.Columns.add('Path',[string]))
    [VOID](${Global:WmiExplorer.dtClasses}.Columns.add('Namespace',[string]))
    [VOID](${Global:WmiExplorer.dtClasses}.Columns.add('name',[string]))
    [VOID](${Global:WmiExplorer.dtClasses}.Columns.add('Description',[string]))
    ${Global:WmiExplorer.dtClasses}.tablename = 'Classes'
}

#endregion

#region Control Handlers

# Add Delegate Scripts to finetune the WMI Connection objects to the events of the controls 

$slMessage.DoubleClickEnabled = $true
$slMessage.add_DoubleClick({$error[0] | out-PropertyGrid})
$lblNameSpace.add_DoubleClick({$script:WmiConnection | out-PropertyGrid})
$lblserver.add_DoubleClick({$Script:ConnectionOptions | out-PropertyGrid})
$lblClass.add_DoubleClick({$script:WmiClass | out-PropertyGrid})


$btnConnect.add_click({ConnectToComputer})
$TVNameSpaces.add_DoubleClick({GetClassesFromNameSpace})
$lvClasses.Add_DoubleClick({GetWmiClass})
$btnInstances.add_Click({GetWmiInstances})
$dgInstances.add_DoubleClick({OutputWmiInstance})
$lbMethods.Add_DoubleClick({GetWmiMethod})

$clbProperties.add_Click({
  trap{Continue}
  $DGInstances.Columns.Item(($this.SelectedItem)).visible = -not $clbProperties.GetItemChecked($this.SelectedIndex)

})

$TVNameSpaces.add_AfterSelect({

    if ($this.SelectedNode.name -ne $Computer){
        $lblPath.Text = "$($script:WmiConnection.path.path.replace('\root',''))\$($this.SelectedNode.Text)"  
    }
 
    $lblProperties.Text = $Script:NameSpaces.__PROPERTY_COUNT                                
    $lblServer.Text = $Script:NameSpaces.__SERVER
    $lblnamespace.Text = $this.SelectedNode.Text

    if ($this.SelectedNode.tag -eq "NotEnumerated") {

        (new-object system.management.managementClass(
                "$($script:WmiConnection.path.path.replace('\root',''))\$($this.SelectedNode.Text):__NAMESPACE")
        ).PSbase.getInstances() | Sort-Object $_.name | 
        ForEach-Object {
          $TN = new-object System.Windows.Forms.TreeNode
          $TN.Name = $_.name
          $TN.Text = ("{0}\{1}" -f $_.__NameSpace,$_.name)
          $TN.tag = "NotEnumerated"
          $this.SelectedNode.Nodes.Add($TN)
        }
        
        # Set tag to show this node is already enumerated
        $this.SelectedNode.tag = "Enumerated"
    }

    $mp = ("{0}\{1}" -f $script:WmiConnection.path.path.replace('\root','') , $this.SelectedNode.text)
    $lvClasses.Items.Clear()

    if($Script:nsc.Item("$mp")){ # in Namespace cache
        $lvClasses.BeginUpdate()
        $lvClasses.Items.AddRange(($nsc.Item( "$mp")))
        $status.Text = "$mp : $($lvClasses.Items.count) Classes"
        $lvClasses.EndUpdate()
        $lblClasses.Text = $lvClasses.Items.count
    } else {
        if(${Global:WmiExplorer.dtClasses}.Select("Namespace='$mp'")){ # In DataTable Cache
            $status.BackColor = 'beige'
            $status.Text = "$mp : Classes in Cache, DoubleClick NameSpace to retrieve Classes"
        } else {
            $status.BackColor = 'LightSalmon'
            $status.Text = "$mp : Classes not recieved yet, DoubleClick NameSpace to retrieve Classes"
        }
    }

}) # $TVNameSpaces.add_AfterSelect

#endregion

#region Processing Functions

#region ConnectToComputer
# Connect to Computer
Function ConnectToComputer {
    
    $computer = $txtComputer.Text 
    Set-StatusBar 'beige' "Connecting to : $computer"
    
    # Try to Connect to Computer

    &{
        trap {
            Set-StatusBar 'Red' "Connecting to : $computer Failed"
            $slMessage.Text = "$_.message"
            Continue
        }

        &{
            # Connect to WMI root
            
            $script:WmiConnection.path = "\\$computer\root"
            $script:WmiConnection.options = $Script:ConnectionOptions
            $script:WmiConnection.Connect()
            
            # Get Avaiable NameSpaces
    
            $opt = new-object system.management.ObjectGetOptions
            $opt.UseAmendedQualifiers = $true

            $Script:NameSpaces = new-object System.Management.ManagementClass(
                $script:WmiConnection,[Management.ManagementPath]'__Namespace',$opt
            )

            Update-Status

            # Create a TreeNode for the WMI Root found

            $computer = $txtComputer.Text 
            $TNRoot = new-object System.Windows.Forms.TreeNode("Root")
            $TNRoot.Name = $Computer
            $TNRoot.Text = $lblPath.Text
            $TNRoot.tag = "Enumerated"
            
            # Create NameSpaces List
            
            $Script:NameSpaces.PSbase.getInstances() | Sort-Object $_.name | 
            ForEach-Object {
                $TN = new-object System.Windows.Forms.TreeNode
                $TN.Name = $_.name
                $TN.Text = ("{0}\{1}" -f $_.__NameSpace,$_.name)
                $TN.tag = "NotEnumerated"
                [void]$TNRoot.Nodes.Add($TN)
            }

            # Add to Treeview
            $tvNameSpaces.Nodes.clear()
            [void]$TVNamespaces.Nodes.Add($TNRoot)
            
            # update StatusBar

            Set-StatusBar 'YellowGreen' "Connected to : $computer"

        }
    }

} # ConnectToComputer

#endregion

#region GetClasseFromNameSpace

# Get Classes on DoubleClick on Namespace in TreeView

Function GetClassesFromNameSpace {

  if ($this.SelectedNode.name -ne $script:computer){
    # Connect to WMI Namespace 
        
    $mp = ("{0}\{1}" -f $script:WmiConnection.path.path.replace('\root','') , $this.SelectedNode.text)

      # Update Status
        
      $lvClasses.BeginUpdate()
      $lvClasses.Items.Clear()
      $i = 0 ;$lblClasses.Text = $i; $lblclasses.Update()

    if($Script:nsc.Item("$mp")){ #in Namespace Cache, so just attach to ListView again
        
        $lvClasses.Items.AddRange(($nsc.Item( "$mp")))
        # $lvClasses.Items.AddRange(([System.Windows.Forms.ListViewItem[]]($nsc.Item( "$mp") | 
            # where {$_.name -like 'win32_*'})))
        $status.Text = "$mp : $($lvClasses.Items.count) Classes"
        $i = $lvClasses.Items.count
    } else { #Not In NameSpace Cache

      if(${Global:WmiExplorer.dtClasses}.Select("Namespace = '$mp'")){ # In DataTable cache, so get from there

        $status.Text = "loading cache from $($this.SelectedNode.name)"
        $statusStrip.Update()

        ${Global:WmiExplorer.dtClasses}.Select("Namespace = '$mp'") | 
        foreach {
            $i++
            $LI = New-Object system.Windows.Forms.ListViewItem 
            $li.Name = $_.name
            $li.Text = $_.name
            $li.SubItems.add($_.description)
            $li.SubItems.add($_.path)
            $li.ToolTipText = ($_.description)
            $lvClasses.Items.add($li)
            $status.Text = "$mp : $($lvClasses.Items.count) Classes"
            $lblClasses.Text = $lvClasses.Items.count
        } 

      } else { # Not in any Cache , Load WMI Classes

        Set-StatusBar 'Khaki' "Getting Classes from $($this.SelectedNode.name)"

        $mc = new-object System.Management.ManagementClass($mp,$opt)
        $eo = New-Object system.management.EnumerationOptions 
        $eo.EnumerateDeep = $true 
        $eo.UseAmendedQualifiers = $true

        $Mc.psbase.GetSubclasses($eo) | 
        ForEach-Object  {
            $i++ ; if ($i%10 -eq 0){$lblClasses.Text = $i;$lblclasses.Update() }
            Trap{$script:Description = "[Empty]";continue}
            $script:description = $_.psbase.Qualifiers.item("description").value
            ${Global:WmiExplorer.dtClasses}.Rows.Add($_.__path,$mp,$_.name,$description)
            $LI = New-Object system.Windows.Forms.ListViewItem 
            $li.Name = $_.name
            $li.Text = $_.name
            $li.SubItems.add($description)
            $li.SubItems.add($_.__path)
            $li.ToolTipText = $description
            $lvClasses.Items.add($li)
        } 

        $status.Text = "Ready, Retrieved $i Classes from $mp"

      } #if(${Global:WmiExplorer.dtClasses}.Select("Namespace = '$mp'"))

      $lvClasses.Sorting = 'Ascending'
      $lvClasses.Sort()
      $script:nsc.Add($mp,(([System.Windows.Forms.ListViewItem[]]($lvClasses.Items)).clone()))
      
    }

    $lvClasses.EndUpdate()
    $this.selectedNode.BackColor = 'AliceBlue'
    $lblClasses.Text = $i;$lblclasses.Update()
    $status.BackColor = 'YellowGreen'
    $statusStrip.Update()

  } #if($Script:nsc.Item("$mp"))
    
} # GetClassesFromNameSpace
#endregion

#region GetWmiClass
Function GetWmiClass {

    # Update Status 
    
    $status.Text = "Retrieving Class"
    $status.BackColor = 'Khaki'
    $statusstrip.Update()
    $lblClass.Text =  $this.SelectedItems |ForEach-Object {$_.name}
    $lblPath.text = $this.SelectedItems |ForEach-Object {"$($_.SubItems[2].text)"}
    
    # Add HelpText
    
    $rtbHelp.Text = ""
    $rtbHelp.selectionFont  = $fontBold
    $rtbHelp.appendtext("$($lblClass.Text)`n`n")
    $rtbHelp.selectionFont  = $fontNormal
    $rtbHelp.appendtext(($this.SelectedItems |ForEach-Object {"$($_.SubItems[1].text)"}))
    $rtbHelp.appendtext("`n")
    $path = $lblPath.text
    
    $opt = new-object system.management.ObjectGetOptions 
    $opt.UseAmendedQualifiers = $true 
    
    $script:WmiClass = new-object system.management.ManagementClass($path,$opt) 

    # Add Property Help
    
    $rtbHelp.selectionFont  = $fontBold
    $rtbHelp.appendtext("`n$($lblClass.Text) Properties :`n`n")
    $rtbHelp.selectionFont  = $fontNormal
    
    $i = 0 ;$lblProperties.Text = $i; $lblProperties.Update()
    $clbproperties.Items.Clear()
    $clbProperties.Items.add('WmiPath',$False)
            
    $script:WmiClass.psbase.properties | 
    ForEach-Object { 
        $i++ ;$lblProperties.Text = $i; $lblProperties.Update()
        $clbProperties.Items.add($_.name,$true)
        $rtbHelp.selectionFont  = $fontBold
        $rtbHelp.appendtext("$($_.Name) :`n" )
        &{
            Trap {$rtbHelp.appendtext("[Empty]");Continue}
            $rtbHelp.appendtext($_.psbase.Qualifiers["description"].value)
        }
        $rtbHelp.appendtext("`n`n")
    } # ForEach-Object
    

    # Create Method Help 

    $rtbHelp.selectionFont  = $fontBold
    $rtbHelp.appendtext( "$($lblClass.Text) Methods :`n`n" )

    $i = 0 ;$lblMethods.Text = $i; $lblMethods.Update()
    $lbmethods.Items.Clear()
    
    $script:WmiClass.psbase.Methods | 
    ForEach-Object { 
        $i++ ;$lblMethods.Text = $i; $lblMethods.Update()
        $lbMethods.Items.add($_.name)
        $rtbHelp.selectionFont  = $fontBold
        $rtbHelp.appendtext("$($_.Name) :`n")
        &{
            Trap {$rtbHelp.Text += "[Empty]"}
            $rtbHelp.appendtext($_.Qualifiers["description"].value)
        }
        $rtbHelp.appendtext("`n`n" )
    } #ForEach-Object
     
    $tabControl.SelectedTab = $tabpage1
    $status.Text = "Retrieved Class"
    $status.BackColor = 'YellowGreen'
    $statusstrip.Update()

} # GetWmiClass

#endregion

#region GetWmiInstances

Function GetWmiInstances {

    $status.Text = "Getting Instances for $($lblClass.text)"
    $status.BackColor = 'Red'
    $statusstrip.Update()

    $tabControl.SelectedTab = $tabInstances

    $MC = new-object system.management.ManagementClass $lblPath.text
    $MOC = $MC.PSbase.getInstances() 
    
    #trap{"Class Not found";break} 
    
    $DT =  new-object  System.Data.DataTable 
    $DT.TableName = $lblClass.text
    $Col =  new-object System.Data.DataColumn
    $Col.ColumnName = "WmiPath"
    $DT.Columns.Add($Col)

    $i = 0
    $j = 0 ;$lblInstances.Text = $j; $lblInstances.Update()
    $MOC | ForEach-Object {
        $j++ ;$lblInstances.Text = $j; $lblInstances.Update()
        $MO = $_ 
        
        # Make a DataRow 
        $DR = $DT.NewRow() 
        $Col =  new-object System.Data.DataColumn
        
        $DR.Item("WmiPath") = $mo.__PATH

        $MO.psbase.properties | 
        ForEach-Object { 
            $prop = $_ 
            If ($i -eq 0)  { 
    
                # Only On First Row make The Headers 
                
                $Col =  new-object System.Data.DataColumn 
                $Col.ColumnName = $prop.Name.ToString() 
                $prop.psbase.Qualifiers | ForEach-Object { 
                    If ($_.Name.ToLower() -eq "key") { 
                        $Col.ColumnName = $Col.ColumnName + "*" 
                    } 
                } 
                $DT.Columns.Add($Col)  
            } 
            
            # fill dataRow  
            
            if ($prop.value -eq $null) { 
                $DR.Item($prop.Name) = "[empty]" 
            } 
            ElseIf ($prop.IsArray) { 
                                $ofs = ";"
                $DR.Item($prop.Name) ="$($prop.value)" 
                                $ofs = $null
            } 
            Else { 
                $DR.Item($prop.Name) = $prop.value 
                #Item is Key try again with * 
                trap{$DR.Item("$($prop.Name)*") = $prop.Value.tostring();continue} 
            } 

        } 

        # Add the row to the DataTable 

        $DT.Rows.Add($DR) 
        $i += 1 

    }

    $DGInstances.DataSource = $DT.psObject.baseobject 
        $DGInstances.Columns.Item('WmiPath').visible =  $clbProperties.GetItemChecked(0)  
    $status.Text = "Retrieved $j Instances"
    $status.BackColor = 'YellowGreen'
    $statusstrip.Update()

} # GetWmiInstances

#endregion

#region OutputWmiInstance
Function OutputWmiInstance {
    if ( $this.SelectedRows.count -eq 1 ) {
        if (-not $Script:InstanceTab) {$Script:InstanceTab = new-object System.Windows.Forms.TabPage
            $Script:InstanceTab.Name = 'Instance'
            $Script:rtbInstance = new-object System.Windows.Forms.RichTextBox
            $Script:rtbInstance.Dock = [System.Windows.Forms.DockStyle]::Fill
            $Script:rtbInstance.Font = $fontCode
            $Script:rtbInstance.DetectUrls = $false
            $Script:InstanceTab.controls.add($Script:rtbInstance)
            $TabControl.TabPages.add($Script:InstanceTab)
        }

        $Script:InstanceTab.Text = "Instance = $($this.SelectedRows | ForEach-Object {$_.DataboundItem.wmiPath.split(':')[1]})"
        $Script:rtbInstance.Text = $this.SelectedRows |ForEach-Object {$_.DataboundItem |Format-List  * | out-String -width 1000 }
        $tabControl.SelectedTab = $Script:InstanceTab
    }

}  # OutputWmiInstance

#endregion 

#region GetWmiMethod

Function GetWmiMethod {

    $WMIMethod = $this.SelectedItem
    $WmiClassName = $script:WmiClass.__Class

    $tabControl.SelectedTab = $tabMethods
    #$rtbmethods.ForeColor = 'Green'
    $rtbMethods.Font  = new-object System.Drawing.Font("Microsoft Sans Serif",8)
    $rtbMethods.text = ""

    $rtbMethods.selectionFont  = $fontBold
    
    $rtbMethods.AppendText(("{1} Method : {0} `n" -f $this.SelectedItem , $script:WmiClass.__Class))
    $rtbMethods.AppendText("`n")

    $rtbMethods.selectionFont  = $fontBold
    $rtbMethods.AppendText("OverloadDefinitions:`n")
    $rtbMethods.AppendText("$($script:WmiClass.$WMIMethod.OverloadDefinitions)`n`n")

    $Qualifiers=@() 
    $script:WmiClass.psbase.Methods[($this.SelectedItem)].Qualifiers | ForEach-Object {$qualifiers += $_.name} 
    #$rtbMethods.AppendText( "$qualifiers`n" )
    $static = $Qualifiers -Contains "Static"  

    $rtbMethods.selectionFont  = $fontBold
    $rtbMethods.AppendText( "Static : $static`n" )

    If ($static) {  

         $rtbMethods.AppendText( "A Static Method does not an Instance to act upon`n`n" )
         $rtbMethods.AppendText("`n")
    
         $rtbMethods.SelectionColor = 'Green'
         $rtbMethods.SelectionFont = $fontCode
         $rtbMethods.AppendText("# Sample Of Connecting to a WMI Class`n`n")
         $rtbMethods.SelectionColor = 'Black'
         $rtbMethods.SelectionFont = $fontCode

         $SB = new-Object text.stringbuilder
         $SB = $SB.Append('$Computer = "') ; $SB = $SB.AppendLine(".`"") 
         $SB = $SB.Append('$Class = "') ; $SB = $SB.AppendLine("$WmiClassName`"")   
         $SB = $SB.Append('$Method = "') ; $SB = $SB.AppendLine("$WmiMethod`"`n")
         $SB = $SB.AppendLine('$MC = [WmiClass]"\\$Computer\' + "$($script:WmiClass.__NAMESPACE)" + ':$Class"')   
         #$SB = $SB.Append('$MP.Server = "') ; $SB = $SB.AppendLine("$($MP.Server)`"")   
         #$SB = $SB.Append('$MP.NamespacePath = "') ; $SB = $SB.AppendLine("$($script:WmiClass.__NAMESPACE)`"")   
         #$SB = $SB.AppendLine('$MP.ClassName = $Class')
         $SB = $SB.AppendLine("`n")    
         #$SB = $SB.AppendLine('$MC = new-object system.management.ManagementClass($MP)')   
         $rtbMethods.AppendText(($sb.tostring()))
         $rtbMethods.SelectionColor = 'Green'
         $rtbMethods.SelectionFont = $fontCode
         $rtbMethods.AppendText("# Getting information about the methods`n`n")
         $rtbMethods.SelectionColor = 'Black'
         $rtbMethods.SelectionFont = $fontCode
         $rtbMethods.AppendText(
             '$mc' + "`n" +
             '$mc | Get-Member -membertype Method' + "`n" +
             "`$mc.$WmiMethod"
         )

    } Else {

         $rtbMethods.AppendText( "This is a non Static Method and needs an Instance to act upon`n`n" )
         $rtbMethods.AppendText( "The Example given will use the Key Properties to Connect to a WMI Instance : `n`n" )
         $rtbMethods.SelectionColor = 'Green'
         $rtbMethods.SelectionFont = $fontCode
         $rtbMethods.AppendText("# Example Of Connecting to an Instance`n`n")
    
         $rtbMethods.SelectionColor = 'Black'
         $rtbMethods.SelectionFont = $fontCode
         $SB = new-Object text.stringbuilder
         $SB = $SB.AppendLine('$Computer = "."') 
         $SB = $SB.Append('$Class = "') ; $SB = $SB.AppendLine("$WmiClassName.`"")   
         $SB = $SB.Append('$Method = "') ; $SB = $SB.AppendLine("$WMIMethod`"")
         $SB = $SB.AppendLine("`n# $WmiClassName. Key Properties :")   

         $Filter = ""   
         $script:WmiClass.psbase.Properties | ForEach-Object {   
           $Q = @() 
           $_.psbase.Qualifiers | ForEach-Object {$Q += $_.name}  

           $key = $Q -Contains "key"  
           If ($key) {   
             $CIMType = $_.psbase.Qualifiers["Cimtype"].Value   
             $SB = $SB.AppendLine("`$$($_.Name) = [$CIMType]")   
             $Filter += "$($_.name) = `'`$$($_.name)`'"    
           }   
         }   

         $SB = $SB.Append("`n" + '$filter=');$SB = $SB.AppendLine("`"$filter`"")   
         $SB = $SB.AppendLine('$MC = get-WMIObject $class -computer $Computer -Namespace "' + 
             "$($script:WmiClass.__NAMESPACE)" + '" -filter $filter' + "`n")
         $SB = $SB.AppendLine('# $MC = [Wmi]"\\$Computer\Root\CimV2:$Class.$filter"')  
         $rtbMethods.AppendText(($sb.tostring()))

    }  

    $SB = $SB.AppendLine('$InParams = $mc.psbase.GetMethodParameters($Method)') 
    $SB = $SB.AppendLine("`n") 

    # output Method Parameter Help

    $rtbMethods.selectionFont  = $fontBold
    $rtbMethods.AppendText("`n`n$WmiClassName. $WMIMethod Method :`n`n")  

    $q = $script:WmiClass.PSBase.Methods[$WMIMethod].Qualifiers | foreach {$_.name} 

    if ($q -contains "Description") {
         $rtbMethods.AppendText(($script:WmiClass.psbase.Methods[$WMIMethod].psbase.Qualifiers["Description"].Value))
    }  
  
    $rtbMethods.selectionFont  = $fontBold
    $rtbMethods.AppendText("`n`n$WMIMethod Parameters :`n")  

  # get the Parameters  
   
  $inParam = $script:WmiClass.psbase.GetMethodParameters($WmiMethod) 

  $HasParams = $False  
  if ($true) {  
    trap{$rtbMethods.AppendText('[None]') ;continue}   

    $inParam.PSBase.Properties | foreach {  
      $Q = $_.Qualifiers | foreach {$_.name} 

      # if Optional Qualifier is not present then Parameter is Mandatory  
      $Optional = $q -contains "Optional" 

      $CIMType = $_.Qualifiers["Cimtype"].Value  
      $rtbMethods.AppendText("`nName = $($_.Name) `nType = $CIMType `nOptional = $Optional") 

      # write Parameters to Example script  

      if ($Optional -eq $TRUE) {$SB = $SB.Append('# ')}  
      $SB = $SB.Append('$InParams.');$SB = $SB.Append("$($_.Name) = ");$SB = $SB.AppendLine("[$CIMType]")  
      if ($q -contains "Description") {$rtbMethods.AppendText($_.Qualifiers["Description"].Value)}
      $HasParams = $true   
    }  
  }

  # Create the Rest of the Script 

  $rtbMethods.selectionFont  = $fontBold
  $rtbMethods.AppendText("`n`nTemplate Script :`n")  

  # Call diferent Overload as Method has No Parameters  

  If ($HasParams -eq $True) {  
      $SB = $SB.AppendLine("`n`"Calling $WmiClassName. : $WMIMethod with Parameters :`"")  
      $SB = $SB.AppendLine('$inparams.PSBase.properties | select name,Value | format-Table')  
      $SB = $SB.AppendLine("`n" + '$R = $mc.PSBase.InvokeMethod($Method, $inParams, $Null)')  
  }Else{  
      $SB = $SB.AppendLine("`n`"Calling $WmiClassName. : $WMIMethod `"")  
      $SB = $SB.AppendLine("`n" + '$R = $mc.PSBase.InvokeMethod($Method,$Null)')  
  }  

  $SB = $SB.AppendLine('"Result :"')  
  $SB = $SB.AppendLine('$R | Format-list' + "`n`n") 

  # Write Header of the Sample Script :  
  
  $rtbMethods.SelectionColor = 'Green'
  $rtbMethods.SelectionFont = $fontCode

  $rtbMethods.AppendText(@"

# $WmiClassName. $WMIMethod-Method Template Script"  
# Created by PowerShell WmiExplorer 
# /\/\o\/\/ 2006 
# www.ThePowerShellGuy.com
#
# Fill InParams values before Executing  
# InParams that are Remarked (#) are Optional
"@

  )

  $rtbMethods.SelectionColor = 'Black'
  #$rtbMethods.SelectionFont = $fontCode
  $rtbMethods.AppendText("`n`n" + $SB)

  $rtbMethods.SelectionFont = new-object System.Drawing.Font("Lucida Console",6 )
  $rtbMethods.AppendText("`n`n Generated by the PowerShell WMI Explorer  /\/\o\/\/ 2006" )
        
} # GetWmiMethod

#endregion

#endregion

# Show the Form

$FrmMain.Add_Shown({$FrmMain.Activate()}) 
  
trap {Write-Host $_ ;$status.Text = "unexpected error";$slMessage.Text = "$_.message";continue}

& {
    [void]$FrmMain.showdialog() 
}

# Resolve-Error $Error[0] | out-string


# SIG # Begin signature block
# MIIkCgYJKoZIhvcNAQcCoIIj+zCCI/cCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU4EVFlvue2ZYpzEq8hORLPy3V
# vhqggh7hMIIEEjCCAvqgAwIBAgIPAMEAizw8iBHRPvZj7N9AMA0GCSqGSIb3DQEB
# BAUAMHAxKzApBgNVBAsTIkNvcHlyaWdodCAoYykgMTk5NyBNaWNyb3NvZnQgQ29y
# cC4xHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEhMB8GA1UEAxMYTWlj
# cm9zb2Z0IFJvb3QgQXV0aG9yaXR5MB4XDTk3MDExMDA3MDAwMFoXDTIwMTIzMTA3
# MDAwMFowcDErMCkGA1UECxMiQ29weXJpZ2h0IChjKSAxOTk3IE1pY3Jvc29mdCBD
# b3JwLjEeMBwGA1UECxMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEwHwYDVQQDExhN
# aWNyb3NvZnQgUm9vdCBBdXRob3JpdHkwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
# ggEKAoIBAQCpAr3BcOY78k4bKJ+XeF4w6qKpjSVf+P6VTKO3/p2iID58UaKboo9g
# MmvRQmR57qx2yVTa8uuchhyPn4Rms8VremIj1h083g8BkuiWxL8tZpqaaCaZ0Dos
# vwy1WCbBRucKPjiWLKkoOajsSYNC44QPu5psVWGsgnyhYC13TOmZtGQ7mlAcMQgk
# FJ+p55ErGOY9mGMUYFgFZZ8dN1KH96fvlALGG9O/VUWziYC/OuxUlE6u/ad6bXRO
# rxjMlgkoIQBXkGBpN7tLEgc8Vv9b+6RmCgim0oFWV++2O14WgXcE2va+roCV/rDN
# f9anGnJcPMq88AijIjCzBoXJsyB3E4XfAgMBAAGjgagwgaUwgaIGA1UdAQSBmjCB
# l4AQW9Bw72lyniNRfhSyTY7/y6FyMHAxKzApBgNVBAsTIkNvcHlyaWdodCAoYykg
# MTk5NyBNaWNyb3NvZnQgQ29ycC4xHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEhMB8GA1UEAxMYTWljcm9zb2Z0IFJvb3QgQXV0aG9yaXR5gg8AwQCLPDyI
# EdE+9mPs30AwDQYJKoZIhvcNAQEEBQADggEBAJXoC8CN85cYNe24ASTYdxHzXGAy
# n54Lyz4FkYiPyTrmIfLwV5MstaBHyGLv/NfMOztaqTZUaf4kbT/JzKreBXzdMY09
# nxBwarv+Ek8YacD80EPjEVogT+pie6+qGcgrNyUtvmWhEoolD2Oj91Qc+SHJ1hXz
# UqxuQzIH/YIX+OVnbA1R9r3xUse958Qw/CAxCYgdlSkaTdUdAqXxgOADtFv0sd3I
# V+5lScdSVLa0AygS/5DW8AiPfriXxas3LOR65Kh343agANBqP8HSNorgQRKoNWob
# ats14dQcBOSoRQTIWjM4bk0cDWK3CqKM09VUP0bNHFWmcNsSOoeTdZ+n0qAwggQS
# MIIC+qADAgECAg8AwQCLPDyIEdE+9mPs30AwDQYJKoZIhvcNAQEEBQAwcDErMCkG
# A1UECxMiQ29weXJpZ2h0IChjKSAxOTk3IE1pY3Jvc29mdCBDb3JwLjEeMBwGA1UE
# CxMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEwHwYDVQQDExhNaWNyb3NvZnQgUm9v
# dCBBdXRob3JpdHkwHhcNOTcwMTEwMDcwMDAwWhcNMjAxMjMxMDcwMDAwWjBwMSsw
# KQYDVQQLEyJDb3B5cmlnaHQgKGMpIDE5OTcgTWljcm9zb2Z0IENvcnAuMR4wHAYD
# VQQLExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xITAfBgNVBAMTGE1pY3Jvc29mdCBS
# b290IEF1dGhvcml0eTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKkC
# vcFw5jvyThson5d4XjDqoqmNJV/4/pVMo7f+naIgPnxRopuij2Aya9FCZHnurHbJ
# VNry65yGHI+fhGazxWt6YiPWHTzeDwGS6JbEvy1mmppoJpnQOiy/DLVYJsFG5wo+
# OJYsqSg5qOxJg0LjhA+7mmxVYayCfKFgLXdM6Zm0ZDuaUBwxCCQUn6nnkSsY5j2Y
# YxRgWAVlnx03Uof3p++UAsYb079VRbOJgL867FSUTq79p3ptdE6vGMyWCSghAFeQ
# YGk3u0sSBzxW/1v7pGYKCKbSgVZX77Y7XhaBdwTa9r6ugJX+sM1/1qcaclw8yrzw
# CKMiMLMGhcmzIHcThd8CAwEAAaOBqDCBpTCBogYDVR0BBIGaMIGXgBBb0HDvaXKe
# I1F+FLJNjv/LoXIwcDErMCkGA1UECxMiQ29weXJpZ2h0IChjKSAxOTk3IE1pY3Jv
# c29mdCBDb3JwLjEeMBwGA1UECxMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEwHwYD
# VQQDExhNaWNyb3NvZnQgUm9vdCBBdXRob3JpdHmCDwDBAIs8PIgR0T72Y+zfQDAN
# BgkqhkiG9w0BAQQFAAOCAQEAlegLwI3zlxg17bgBJNh3EfNcYDKfngvLPgWRiI/J
# OuYh8vBXkyy1oEfIYu/818w7O1qpNlRp/iRtP8nMqt4FfN0xjT2fEHBqu/4STxhp
# wPzQQ+MRWiBP6mJ7r6oZyCs3JS2+ZaESiiUPY6P3VBz5IcnWFfNSrG5DMgf9ghf4
# 5WdsDVH2vfFSx73nxDD8IDEJiB2VKRpN1R0CpfGA4AO0W/Sx3chX7mVJx1JUtrQD
# KBL/kNbwCI9+uJfFqzcs5HrkqHfjdqAA0Go/wdI2iuBBEqg1ahtq2zXh1BwE5KhF
# BMhaMzhuTRwNYrcKoozT1VQ/Rs0cVaZw2xI6h5N1n6fSoDCCBGAwggNMoAMCAQIC
# Ci6rEdxQ/1ydy8AwCQYFKw4DAh0FADBwMSswKQYDVQQLEyJDb3B5cmlnaHQgKGMp
# IDE5OTcgTWljcm9zb2Z0IENvcnAuMR4wHAYDVQQLExVNaWNyb3NvZnQgQ29ycG9y
# YXRpb24xITAfBgNVBAMTGE1pY3Jvc29mdCBSb290IEF1dGhvcml0eTAeFw0wNzA4
# MjIyMjMxMDJaFw0xMjA4MjUwNzAwMDBaMHkxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xIzAhBgNVBAMTGk1pY3Jvc29mdCBDb2RlIFNpZ25pbmcg
# UENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAt3l91l2zRTmoNKwx
# 2vklNUl3wPsfnsdFce/RRujUjMNrTFJi9JkCw03YSWwvJD5lv84jtwtIt3913UW9
# qo8OUMUlK/Kg5w0jH9FBJPpimc8ZRaWTSh+ZzbMvIsNKLXxv2RUeO4w5EDndvSn0
# ZjstATL//idIprVsAYec+7qyY3+C+VyggYSFjrDyuJSjzzimUIUXJ4dO3TD2AD30
# xvk9gb6G7Ww5py409rQurwp9YpF4ZpyYcw2Gr/LE8yC5TxKNY8ss2TJFGe67SpY7
# UFMYzmZReaqth8hWPp+CUIhuBbE1wXskvVJmPZlOzCt+M26ERwbRntBKhgJuhgCk
# wIffUwIDAQABo4H6MIH3MBMGA1UdJQQMMAoGCCsGAQUFBwMDMIGiBgNVHQEEgZow
# gZeAEFvQcO9pcp4jUX4Usk2O/8uhcjBwMSswKQYDVQQLEyJDb3B5cmlnaHQgKGMp
# IDE5OTcgTWljcm9zb2Z0IENvcnAuMR4wHAYDVQQLExVNaWNyb3NvZnQgQ29ycG9y
# YXRpb24xITAfBgNVBAMTGE1pY3Jvc29mdCBSb290IEF1dGhvcml0eYIPAMEAizw8
# iBHRPvZj7N9AMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFMwdznYAcFuv8drE
# TppRRC6jRGPwMAsGA1UdDwQEAwIBhjAJBgUrDgMCHQUAA4IBAQB7q65+SibyzrxO
# dKJYJ3QqdbOG/atMlHgATenK6xjcacUOonzzAkPGyofM+FPMwp+9Vm/wY0SpRADu
# lsia1Ry4C58ZDZTX2h6tKX3v7aZzrI/eOY49mGq8OG3SiK8j/d/p1mkJkYi9/uEA
# uzTz93z5EBIuBesplpNCayhxtziP4AcNyV1ozb2AQWtmqLu3u440yvIDEHx69dLg
# Qt97/uHhrP7239UNs3DWkuNPtjiifC3UPds0C2I3Ap+BaiOJ9lxjj7BauznXYIxV
# hBoz9TuYoIIMol+Lsyy3oaXLq9ogtr8wGYUgFA0qvFL0QeBeMOOSKGmHwXDi86er
# zoBCcnYOMIIEajCCA1KgAwIBAgIKYQ94TQAAAAAAAzANBgkqhkiG9w0BAQUFADB5
# MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
# bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSMwIQYDVQQDExpN
# aWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQTAeFw0wNzA4MjMwMDIzMTNaFw0wOTAy
# MjMwMDMzMTNaMHQxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# HjAcBgNVBAMTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBAKLbCo3PwsFJm82qOjStI1lr22y+ISK3lMjqrr/G1SbC
# MhGLvNpdLPs2Vh4VK66PDd0Uo24oTH8WP0GsjUCxRogN2YGUrZcG0FdEdlzq8fwO
# 4n90ozPLdOXv42GhfgO3Rf/VPhLVsMpeDdB78rcTDfxgaiiFdYy3rbyF6Be0kL71
# FrZiXe0R3zruIVuLr4Bzw0XjlYl3YJvnrXfBN40zFC8T22LJrhqpT5hnrdQgOTBx
# 4I1nRuLGHPQNUHRBL+gFJGoha0mwksSyOcdCpW1cGEqrj9eOgz54CkfYpLKEI8Pi
# 8ntmsUp0vSZBS5xhFGBOMMiC89ALcHzuVU130ghVdoECAwEAAaOB+DCB9TAOBgNV
# HQ8BAf8EBAMCBsAwHQYDVR0OBBYEFPMhQI58UfhUS5jlF9dqgzQFLiboMBMGA1Ud
# JQQMMAoGCCsGAQUFBwMDMB8GA1UdIwQYMBaAFMwdznYAcFuv8drETppRRC6jRGPw
# MEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kv
# Y3JsL3Byb2R1Y3RzL0NTUENBLmNybDBIBggrBgEFBQcBAQQ8MDowOAYIKwYBBQUH
# MAKGLGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvQ1NQQ0EuY3J0
# MA0GCSqGSIb3DQEBBQUAA4IBAQBAV29TZ54ggzQBDuYXSzyt69iBf+4NeXR3T5dH
# GPMAFWl+22KQov1noZzkKCn6VdeZ/lC/XgmzuabtgvOYHm9Z+vXx4QzTiwg+Fhcg
# 0cC1RUcIJmBXCUuU8AjMuk1u8OJIEig1iyFy31+2r2kSJJTu6TQJ235ub5IKUsoq
# TEmqMiyG6KHMXSa8vDzgW7KDC7o1HE+ERUf/u5ShWQeplt14vVd/padOzPKtnJpB
# 4stcJD7cfzRHTvbPyHud67bJnGMUU6+tmu/Xv8+goauVynorhyzAx9n8bAPavzit
# 8dFcGRcPwPfKgKYQCBrdkCPnsKFMPuqwESZ4DsEsuaRrx488MIIEnTCCA4WgAwIB
# AgIKYUdSugAAAAAABDANBgkqhkiG9w0BAQUFADB5MQswCQYDVQQGEwJVUzETMBEG
# A1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMSMwIQYDVQQDExpNaWNyb3NvZnQgVGltZXN0YW1w
# aW5nIFBDQTAeFw0wNjA5MTYwMTUzMDBaFw0xMTA5MTYwMjAzMDBaMIGmMQswCQYD
# VQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEe
# MBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMScwJQYDVQQLEx5uQ2lwaGVy
# IERTRSBFU046RDhBOS1DRkNDLTU3OUMxJzAlBgNVBAMTHk1pY3Jvc29mdCBUaW1l
# c3RhbXBpbmcgU2VydmljZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
# AJtt3IZR6DI7NzqWJbLPb+5htUHSGDtanXhnuvgf2QhVkoh+40FT+uwoVP612v5w
# O5UnSH5DoDIvJoFK8gJ2d8jJqfiiIVh+Db0B2iTG/kQRBTU6AajqVAozLIfSfkGz
# 6AnZsL7jmSWmvCXt19OO2/S3bRtJC+bTw4du7kbJf/Nt6+eDHqhTRj/KJH7mfMks
# +3kUKEXATzZrUxqnhrPn/OHBn1EJ27ylu/7Khwn2tzIZvuFKUby8fKwslWqXc+py
# V6Gci4bYm71L/CczwW0yrOBoGNhuOi4iQ9H5j+3xAAENZMDJo90P8cjpVMoR/9x4
# KT4drFjA29+q3K5lG9OdvGcCAwEAAaOB+DCB9TAdBgNVHQ4EFgQUTxiJitLKAHjG
# 7FkND/18xMEigN4wHwYDVR0jBBgwFoAUb+hOP5e5NKtLho+8nOqsO0FDxtAwRAYD
# VR0fBD0wOzA5oDegNYYzaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwv
# cHJvZHVjdHMvdHNwY2EuY3JsMEgGCCsGAQUFBwEBBDwwOjA4BggrBgEFBQcwAoYs
# aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy90c3BjYS5jcnQwEwYD
# VR0lBAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQDAgbAMA0GCSqGSIb3DQEBBQUA
# A4IBAQA3Jx71jEDg9mUmPmTEkLw+41eF3UMNQIRnvoeoKtrctDYgmI4zfC5f4FB7
# YTHzGhPehL3qaRxYfLMbk+EIJ4FFttRwyhS3X7pX6dRe0DtDqrc/ttphi3HP1H3V
# e26/tMpaMJHf2goOozWfJWFOwDJ0K3oGlHIArBidS+WeK8U6VKykYNin95t/2alt
# 7URrutzgEvrwrYcMlWMKMh6JTszMfqc3pf5f2Gf6RkvRbR2nfdK+Av/zboLzh3TE
# aeW5cMxLZaMHNalEnoR9OW7+FAW9GlAhtT6f83ccj8KanVfhaX1p6IPPAm8qIrs3
# Mzpy+tYwHZGt9lAa6xPeOsW3XM2zMIIEnTCCA4WgAwIBAgIKYUl87QAAAAAABTAN
# BgkqhkiG9w0BAQUFADB5MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSMwIQYDVQQDExpNaWNyb3NvZnQgVGltZXN0YW1waW5nIFBDQTAeFw0wNjA5
# MTYwMTU1MjJaFw0xMTA5MTYwMjA1MjJaMIGmMQswCQYDVQQGEwJVUzETMBEGA1UE
# CBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
# b2Z0IENvcnBvcmF0aW9uMScwJQYDVQQLEx5uQ2lwaGVyIERTRSBFU046MTBEOC01
# ODQ3LUNCRjgxJzAlBgNVBAMTHk1pY3Jvc29mdCBUaW1lc3RhbXBpbmcgU2Vydmlj
# ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOq6BWPI2XmuhEQ+pbPE
# 7UyeJN85dh4J1jJKWHjSK9mlB5Dv5z37vSZ8o/vlfX4yz9k9izk38vjYOzQW1JKC
# +zTsaIVyGo/guEzguIXzMwoCwaJ2czVMXfG34Up9HbiUeNv/HoUVQkZxzn8nVxLR
# g087z/re9ovtPwDj1d5h+ReNS6SBPPVpQOrhib8HT7p0e+kM5Ufqq2zx1WeBCPgW
# yn0Tu3PiCUz6YvvtoDmaOv7rEchhHmJY2ApUg9U7S0viVb0vYBqOkgVD2l3rggoj
# lwmgBTFli5NOHkEhopKQ/UVERW81sUU3rWmpZfk0Q7EXwjs54RCM8hqH41RQHzud
# Ma0CAwEAAaOB+DCB9TAdBgNVHQ4EFgQUfnLwLj9WKeAl92i4AfxL4X7P4z4wHwYD
# VR0jBBgwFoAUb+hOP5e5NKtLho+8nOqsO0FDxtAwRAYDVR0fBD0wOzA5oDegNYYz
# aHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvdHNwY2Eu
# Y3JsMEgGCCsGAQUFBwEBBDwwOjA4BggrBgEFBQcwAoYsaHR0cDovL3d3dy5taWNy
# b3NvZnQuY29tL3BraS9jZXJ0cy90c3BjYS5jcnQwEwYDVR0lBAwwCgYIKwYBBQUH
# AwgwDgYDVR0PAQH/BAQDAgbAMA0GCSqGSIb3DQEBBQUAA4IBAQBpeoIJDBbR3s9G
# iS6/0TR6gX8nKEEq89Mhkg6XrV9TXin57cFUSqh99xPQCxT5TfKGFQBu44MdKEWn
# LDky3W+aN1ruI1KPVAONP6ecZDj2NsgUQ7Y6PpjJDcNxgSjzZqcx4lxdj/lSUuFc
# 65OQnWkJTInR0XZMNA1q4XxEpytbg1R/RSQZJcSKRsUl4xmAaSkU9hfG8CIsgUZe
# K/T5psZ3PiNv+aZkhY6iYg2pLR6o5ZA+f/+wjvyX7PH9BK/NSc5adKz68xMfGznO
# o7TWvPS07sit8lYe+zzxyNYqRLy/nD99ZhjNsiBjCspAPWUyGXyyuD3BJkhOIhmZ
# bowwwfGRMIIEnTCCA4WgAwIBAgIQaguZT8AAJasR20UfWHpnojANBgkqhkiG9w0B
# AQUFADBwMSswKQYDVQQLEyJDb3B5cmlnaHQgKGMpIDE5OTcgTWljcm9zb2Z0IENv
# cnAuMR4wHAYDVQQLExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xITAfBgNVBAMTGE1p
# Y3Jvc29mdCBSb290IEF1dGhvcml0eTAeFw0wNjA5MTYwMTA0NDdaFw0xOTA5MTUw
# NzAwMDBaMHkxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
# VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xIzAh
# BgNVBAMTGk1pY3Jvc29mdCBUaW1lc3RhbXBpbmcgUENBMIIBIjANBgkqhkiG9w0B
# AQEFAAOCAQ8AMIIBCgKCAQEA3Ddu+6/IQkpxGMjOSD5TwPqrFLosMrsST1LIg+0+
# M9lJMZIotpFk4B9QhLrCS9F/Bfjvdb6Lx6jVrmlwZngnZui2t++Fuc3uqv0SpAtZ
# Iikvz0DZVgQbdrVtZG1KVNvd8d6/n4PHgN9/TAI3lPXAnghWHmhHzdnAdlwvfbYl
# BLRWW2ocY/+AfDzu1QQlTTl3dAddwlzYhjcsdckO6h45CXx2/p1sbnrg7D6Pl55x
# Dl8qTxhiYDKe0oNOKyJcaEWL3i+EEFCy+bUajWzuJZsT+MsQ14UO9IJ2czbGlXqi
# zGAG7AWwhjO3+JRbhEGEWIWUbrAfLEjMb5xD4GrofyaOawIDAQABo4IBKDCCASQw
# EwYDVR0lBAwwCgYIKwYBBQUHAwgwgaIGA1UdAQSBmjCBl4AQW9Bw72lyniNRfhSy
# TY7/y6FyMHAxKzApBgNVBAsTIkNvcHlyaWdodCAoYykgMTk5NyBNaWNyb3NvZnQg
# Q29ycC4xHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEhMB8GA1UEAxMY
# TWljcm9zb2Z0IFJvb3QgQXV0aG9yaXR5gg8AwQCLPDyIEdE+9mPs30AwEAYJKwYB
# BAGCNxUBBAMCAQAwHQYDVR0OBBYEFG/oTj+XuTSrS4aPvJzqrDtBQ8bQMBkGCSsG
# AQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTAD
# AQH/MA0GCSqGSIb3DQEBBQUAA4IBAQCUTRExwnxQuxGOoWEHAQ6McEWN73NUvT8J
# BS3/uFFThRztOZG3o1YL3oy2OxvR+6ynybexUSEbbwhpfmsDoiJG7Wy0bXwiuEbT
# hPOND74HijbB637pcF1Fn5LSzM7djsDhvyrNfOzJrjLVh7nLY8Q20Rghv3beO5qz
# G3OeIYjYtLQSVIz0nMJlSpooJpxgig87xxNleEi7z62DOk+wYljeMOnpOR3jifLa
# OYH5EyGMZIBjBgSW8poCQy97Roi6/wLZZflK3toDdJOzBW4MzJ3cKGF8SPEXnBEh
# OAIch6wGxZYyuOVAxlM9vamJ3uhmN430IpaczLB3VFE61nJEsiP2MYIEkzCCBI8C
# AQEwgYcweTELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
# BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEjMCEG
# A1UEAxMaTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0ECCmEPeE0AAAAAAAMwCQYF
# Kw4DAhoFAKCBvjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3
# AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUC4dcGr1fu0gdRILe
# ff0Gq0WuPO0wXgYKKwYBBAGCNwIBDDFQME6gJoAkAE0AaQBjAHIAbwBzAG8AZgB0
# ACAATABlAGEAcgBuAGkAbgBnoSSAImh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9s
# ZWFybmluZyAwDQYJKoZIhvcNAQEBBQAEggEAAEOS5XKTwHxT4rFAMnMk+JrlHU4+
# lvyk89xGVXDIurOWmYLmxSseRQUGV1MDaPnHjdNxgsxKCdk9wwbjiLPROxieLqgy
# n/G2S8CCp2MHFkRFec2hxevENkAwn9hnf7HuT+Mk2an/VlXUnV7mR5QBNa+0q0EX
# eNFbvTEV3W57d2vm4zQHx2ueFRBnn158svHQO7jsE/z76UfPFrcrCRCfq15lXc9j
# 0AwAR27YKSaECWeBnIcFutRhVAuukwmcy/UT0DTSNG39fTeo0y/4x70WDNCqz/yp
# 6Knsh+C86IdH0gA1nXPZhU1R4dRCUVxfDxx+bWLUvrymsAP2m2N2AiO+r6GCAh8w
# ggIbBgkqhkiG9w0BCQYxggIMMIICCAIBATCBhzB5MQswCQYDVQQGEwJVUzETMBEG
# A1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMSMwIQYDVQQDExpNaWNyb3NvZnQgVGltZXN0YW1w
# aW5nIFBDQQIKYUl87QAAAAAABTAHBgUrDgMCGqBdMBgGCSqGSIb3DQEJAzELBgkq
# hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA4MDYxMjE3NDkyMFowIwYJKoZIhvcN
# AQkEMRYEFLgG/GTKUh+3IIRRrNU0o41CMgFkMA0GCSqGSIb3DQEBBQUABIIBAJEp
# Y+x8khX0e49+nb/3+QRSAGfHQMGXO2pVHCeKzwVm4hzO5Rjtn3c5yRyraNazSTG4
# gRDFgXgO2hbtzb82bLSkAtEXNzpyVQHcgZPMcmD5qGZt7xnkB6lUFReNG1zzoHwG
# Z9eg6r80eq7Bpnf/S3BgP0qKsu8KMo7jk+tKm3+FdT8dZcZcGHO62oMg9D0eiHVl
# OdOiVD+6WZWy7TYzpD2ZyqtNn33arQksjyjpvOIjU1ovm7YGFnFllJt8Mejfw7uU
# KGAU2n1YqzFp+VF0uwNoNaHejuzRdG6WQHk/uS308DeWijjxMGaFJin2VkeIkDtd
# Jyx/OdiobB3Tkdv4rmE=
# SIG # End signature block
