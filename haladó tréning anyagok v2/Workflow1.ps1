Workflow HelloWorld 
{
  Write-Output "Hello World!"
}
Write-Host "=================================="
Write-Host "HelloWorld munkafolyamat futtatása"
Write-Host "=================================="
HelloWorld 
Write-Host "======================================"
Write-Host "Get-Command HelloWorld | Format-List *"
Write-Host "======================================"
Get-Command HelloWorld | Format-List *
Write-Host "========================================"
Write-Host "(Get-Command HelloWorld).Parameters.Keys"
Write-Host "========================================"
(Get-Command HelloWorld).Parameters.Keys
