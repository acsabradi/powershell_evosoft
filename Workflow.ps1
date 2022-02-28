Workflow HelloWorld 
{
  "Hello World"
}

Workflow ParallelTest 
{
 Parallel 
	{
	Sequence
		{
		   Get-CimInstance –ClassName Win32_OperatingSystem
		   Get-Process –Name PowerShell*
		}
	   Get-CimInstance –ClassName Win32_ComputerSystem
	   Get-Service –Name s*
	}
}

Write-Host "==================================="
Write-Host "Munkafolyamat futtatása: HelloWorld"
Write-Host "==================================="
HelloWorld 
Write-Host "==========================="
Write-Host "Munkafolyamat tulajdonságai"
Write-Host "==========================="
Get-Command HelloWorld | Format-List *
Write-Host "========================="
Write-Host "Munkafolyamat paraméterei"
Write-Host "========================="
(Get-Command HelloWorld).Parameters.Keys
Write-Host "====================================="
Write-Host "Munkafolyamat futtatása: ParallelTest"
Write-Host "====================================="
ParallelTest