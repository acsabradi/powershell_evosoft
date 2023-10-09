Workflow ParallelTest 
{
 Parallel 
	{
	Sequence
		{
		$i= 1
		while ($i -le 10)
			{
				$i
				Start-Sleep -Seconds 1
				$i++
			}
		Get-Process powershell
		}
	$j= 101
	while ($j -le 110)
		{
			$j
			Start-Sleep -Seconds 1
			$j++
		}
	Get-Service netlogon
	}
}

ParallelTest