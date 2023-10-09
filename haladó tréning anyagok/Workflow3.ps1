Workflow ForeachParallelTest1 
{
   $cities="Budapest", "Szeged", "Pécs", "Debrecen", "Békéscsaba", "Veszprém", "Győr", "Szombathely", "Miskolc", "Szolnok"
   $numbers = 0,1,2,3,4,5,6,7,8,9
   foreach ($number in $numbers)
	{
		Start-Sleep -Seconds $number
	 	$cities[$number]
	}
}

Workflow ForeachParallelTest2
{
   $cities="Budapest", "Szeged", "Pécs", "Debrecen", "Békéscsaba", "Veszprém", "Győr", "Szombathely", "Miskolc", "Szolnok"
   $numbers = 0,1,2,3,4,5,6,7,8,9
   foreach -parallel ($number in $numbers)
	{
		Start-Sleep -Seconds $number
	 	$cities[$number]
	}
}

ForeachParallelTest1
ForeachParallelTest2

