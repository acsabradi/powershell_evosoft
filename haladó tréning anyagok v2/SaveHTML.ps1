$Style = "
<style>
    BODY{background-color:#b0c4de;}
    TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
    TH{border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color:#778899}
    TD{border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
    tr:nth-child(odd) { background-color:#d3d3d3;} 
    tr:nth-child(even) { background-color:white;}    
</style>
"
# --- Cella színbeállítás ----
$StatusColor = @{Stopped = ' bgcolor="Red">Stopped<';Running = ' bgcolor="Green">Running<';}

# ---- Windows szolgáltatások státusza
$GService =  Get-Service | ? DisplayName -like 'Windows*' | Select Name, Status | ConvertTo-HTML -AS Table -Fragment -PreContent '<h2>Windows Services</h2>' | Out-String 

# ---- Színcsere státusz alapján
$StatusColor.Keys | foreach { $GService = $GService -replace ">$_<",($StatusColor.$_) }

# ---- Az utolsó 5 újraindítás esemény ----
$Reboots = Get-WinEvent -FilterHashtable @{logname='system';id=6005} -MaxEvents 5 | Select Message, TimeCreated  | ConvertTo-HTML -AS Table -Fragment -PreContent '<h2>Last 5 Reboots</h2>' | Out-String

# ---- A HTML mentése ----
ConvertTo-HTML -head $Style -PostContent $GService, $Reboots -PreContent '<h1>Web Page Title</h1>' | Out-File C:\PowerShell\TableHTML.html 

# ---- A HTML megnyitása ---- 
Invoke-Item c:\PowerShell\TableHTML.html