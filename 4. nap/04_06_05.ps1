############################
#       Description        #
#==========================#
# Hatókör teszt            #
############################
$var = "init"
function Change-Var 
	{
	 "A `$var változó értéke: $var"
	  $var = "function"
	 "A `$var változó értéke a függvényen belül: $var"
	  $script:var = "script"
         "A `$var változó értéke: $var"
	 "A `$var változó értéke a szkript szintjén: $script:var"
	}
Change-Var
"A `$var változó értéke: $var"
