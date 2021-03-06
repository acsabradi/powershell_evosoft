# Start-Example is a
# function like start-demo which uses the Examples from cmdlet help
# (1) Get the examples
# (2) Split out the separate examples
# (3) Select a specific example
# (4) Run it (remarks = comments) (code = commands)

#
# The body of Start-DemoCore comes from Jeffrey Snover's classic Start-Demo.
#
$global:ProgressPreference = "SilentlyContinue"

function global:Start-DemoCore
{
  param( $file, $_lines, $command )

  $_starttime = [DateTime]::now
  # Write-Host -for Yellow "<Demo [$file] Started>"


  # We use a FOR and an INDEX ($_i) instead of a FOREACH because
  # it is possible to start at a different location and/or jump 
  # around in the order.
  for ($_i = $Command; $_i -lt $_lines.count; $_i++)
  {  
    $_SimulatedLine = $("`n[$_i]PS> " + $($_Lines[$_i]) + "  ")
    Write-Host -NoNewLine $_SimulatedLine

    # Put the current command in the Window Title along with the demo duration
    $_Duration = [DateTime]::Now - $_StartTime
    # $Host.UI.RawUI.WindowTitle = "[{0}m, {1}s]    {2}" -f [int]$_Duration.TotalMinutes, [int]$_Duration.Seconds, $($_Lines[$_i])
    if ($_lines[$_i].StartsWith("#"))
    {
      continue
    }
    $_OldColor = $host.UI.RawUI.ForeGroundColor
    $host.UI.RawUI.ForeGroundColor = "Red"
    $_input=[System.Console]::ReadLine()
    $host.UI.RawUI.ForeGroundColor = $_OldColor
    switch ($_input)
    {
      "?"  
          {
            Write-Host -ForeGroundColor Yellow "Running demo: $file`n(q) Quit (!) Suspend (#x) Goto Command #x (fx) Find cmds using X`n(B) backup (t) Timecheck (s) Skip (d) Dump demo"
            $_i -= 1
          }
      "b" { 
             $_i -= 1
             while ($_lines[$($_i)].StartsWith("#"))
             {   $_i -= 1
             }
             $_i -= 1
          }
      "q"  
          {
            Write-Host -ForeGroundColor Yellow "<Quit demo>"
            return          
          }
      "s"
          {
            Write-Host -ForeGroundColor Yellow "<Skipping Cmd>"
          }
      "d"
          {
            for ($_ni = 0; $_ni -lt $_lines.Count; $_ni++)
            {
               if ($_i -eq $_ni)
               {   Write-Host -ForeGroundColor Red ("*" * 80)
               } 
               Write-Host -ForeGroundColor Yellow ("[{0,2}] {1}" -f $_ni, $_lines[$_ni])
            }
            $_i -= 1
          }
      "t"  
          {
             $_Duration = [DateTime]::Now - $_StartTime
             Write-Host -ForeGroundColor Yellow $("Demo has run {0} Minutes and {1} Seconds" -f [int]$_Duration.TotalMinutes, [int]$_Duration.Seconds)
             $_i -= 1
          }
      {$_.StartsWith("f")}
          {
            for ($_ni = 0; $_ni -lt $_lines.Count; $_ni++)
            {
               if ($_lines[$_ni] -match $_.SubString(1))
               {
                  Write-Host -ForeGroundColor Yellow ("[{0,2}] {1}" -f $_ni, $_lines[$_ni])
               }
            }
            $_i -= 1
          }
      {$_.StartsWith("!")}
          {
             if ($_.Length -eq 1)
             {
                 Write-Host -ForeGroundColor Yellow "<Suspended demo - type 'Exit' to resume>"
                 $host.EnterNestedPrompt()
             }else
             {
                 trap [System.Exception] {Write-Error $_;continue;}
                 Invoke-Expression $($_.SubString(1) + "| out-host")
             }
             $_i -= 1
          }
      {$_.StartsWith("#")}  
          {
             $_i = [int]($_.SubString(1)) - 1
             continue
          }
      default
          {
             trap [System.Exception] {Write-Error $_;continue;}
             if( $_lines[$_i].Contains( "=" ) -or $_lines[$_i].Contains( "function" ) -or $_lines[$_i].Contains( "filter" ) ){
                Invoke-Expression $($_lines[$_i])
             }
             else{
                Invoke-Expression $($_lines[$_i] + "| out-host")
             }
             $_Duration = [DateTime]::Now - $_StartTime
             # $Host.UI.RawUI.WindowTitle = "[{0}m, {1}s]    {2}" -f [int]$_Duration.TotalMinutes, [int]$_Duration.Seconds, $($_Lines[$_i])
             [System.Console]::ReadLine()
          }
    }
  }
  $_Duration = [DateTime]::Now - $_StartTime
  Write-Host -ForeGroundColor Yellow $("<Demo Complete {0} Minutes and {1} Seconds>" -f [int]$_Duration.TotalMinutes, [int]$_Duration.Seconds)
  # Write-Host -ForeGroundColor Yellow $([DateTime]::now)
}

#
# Start-Demo is a revision of the Jeffrey Snover classic. It reads all lines from a text file.
#
function global:Start-Demo
{
  param($file=".\demo.txt", [int]$command=0)
  Clear-Host

  $_lines = Get-Content $file

  Start-DemoCore $file $_lines $command
}

#
# Start-Example generates a sequence of lines from Get-Help with the -Examples parameter
#
function global:Start-Example
{
  param($mycmd="Get-Command", [int]$command=0)
  Clear-Host

  $file = "Get-Help $mycmd -Examples" # fake out the file name for Start-Demo compatability.
  
#  $_lines = Get-Content $file
# Read the data from the Get-Help examples into $_lines
  $_rawexamples = Get-Help $mycmd -Examples
  $many = $_rawexamples.examples.example.count
  $_prompt = "PS>"
  Write-Host -for Yellow "<$file has $many examples>"
  $_lines = 0..100
  $_cc = 0
  foreach( $i in $_rawexamples.examples.example ){
        $_lines[$_cc++] = "# " + $i.title
	for( $j=0; $j -lt $i.introduction.count; ++$j ){
	  $_lines[$_cc++] = "# prompt: " + $i.introduction[$j].text
	  $_prompt = $i.introduction[$j].text
	}
	for( $j=0; $j -lt $i.remarks.count; ++$j){ 
		if( $i.remarks[$j].text.length -gt 0 ){
			$_lines[$_cc++] = "# " + $i.remarks[$j].text
		}
	}; 
	$z = $i.code.split( "`n" )
	for( $j=0; $j -lt $z.count; ++$j ){
		if( $z[$j].startswith( $_prompt ) ){ $_lines[$_cc++] = $z[$j].substring( $_prompt.length, $z[$j].length-$_prompt.length ) }
		else{ $_lines[$_cc++] = $z[$j] }
	}
  }
  Write-Host -for Yellow "<$file has $_cc lines>"
  $_lines = $_lines[0..$_cc]
  $_lines[$_cc] = "# end"

  Start-DemoCore $file $_lines $command
}

# HistoryInfo includes values such as:
# Id                 : 1127
# CommandLine        : notepad bigprocess8.ps1
# ExecutionStatus    : Completed
# StartExecutionTime : 1/21/2008 12:18:46
# EndExecutionTime   : 1/21/2008 12:18:47
#
# Get-History takes -Count and -Id parameters
# For now we use just the -Count parameter and not -Id. Yet.
#
function global:Start-Replay
{
  param([int]$histcount=32, [int]$command=0)
  Clear-Host

  $file = "Get-History -Count $histcount" # fake out the file name for Start-Demo compatability.
  
#  $_lines = Get-Content $file
# Read the data from the Get-Help examples into $_lines
  $_rawhistory = Get-History -Count $histcount
  $_lines = 0..$histcount # could be 1..$histcount, but starts at 0 for historical reasons.
  $_cc = 0
  foreach( $i in $_rawhistory ){
        $_lines[$_cc++] = $i.CommandLine + "  # id=" + $i.Id # should include option of whether to include Id, etc.
  }
  $_lines = $_lines[0..$_cc]
  $_lines[$_cc] = "# end"

  Start-DemoCore $file $_lines $command
}

