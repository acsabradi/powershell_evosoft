############################
#       Description        #
#==========================#
# Paraméterek átvétele a   #
# parancssorból...         #
############################
param ($a=1, $b=0)
if ($args.Length -eq 0)
	{
	Write-Error "Hiányzó paraméter(ek)!"
	return $a;
	}
else	
	{
	foreach($arg in $args) 
		{ 
		Write-Host $arg 
		Write-Host $arg.GetType() 
		}
	return $b;
	}