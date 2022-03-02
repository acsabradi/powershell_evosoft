$a = [int](Read-Host "Kérek egy számot")
if ($a -gt 10)
	{"Nagyobb, mint 10."} 
elseif ($a -lt 10) 
	{"Kisebb, mint 10."} 
else 
	{"Éppen 10."}

