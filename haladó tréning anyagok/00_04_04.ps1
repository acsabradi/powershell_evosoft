############################
#       Description        #
#==========================#
# Felhasználói input       #
# átvétele - Out-GridView  #
############################
do 
   { 
      $Menu = [ordered]@{
      0 = "Folyamatok listázása";
      1 = "Szolgáltatások listázása";
      2 = "Változók listázása"; 
      3 = "Aliasok listázása"; 
      9 = "Kilépés";}

      $Result = $Menu | Out-GridView -PassThru  -Title "Válasszon egy lehetőséget!"
      switch ($Result)  
      {
        {$Result.Name -eq 0} {Get-Process | ft}
        {$Result.Name -eq 1} {Get-Service | ft}
        {$Result.Name -eq 2} {Get-Variable | ft}   
        {$Result.Name -eq 3} {Get-Alias | ft}   
        {$Result.Name -eq 9} {Break}   
      }
} while ($Result.Name -ne "9") 