Workflow TestCheckPoint
{
  New-Item -Path C:\Powershell -Name BeforeCheckPoint.txt -Value (Get-Date).Minute -Force
  CheckPoint-WorkFlow
  Suspend-Workflow
  New-Item -Path C:\Powershell -Name AfterCheckPoint.txt -Value (Get-Date).Minute -Force
}

TestCheckPoint