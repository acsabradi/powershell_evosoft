# Splatting 
function Get-Area1 ($a, $b)
	{	
		Write-Host "`$a értéke = $a"
		Write-Host "`$b értéke = $b"
		write-host "Kerület: $(($a+$b)*2)"
		write-host "Terület: $($a*$b)"
	}
# Switching 
function Get-Area2  
	{ 	
	PARAM (	[int] $a, 
		[int] $b, 
		[switch] $terulet)
		Write-Host "`$a értéke = $a"
		Write-Host "`$b értéke = $b"
		if (!$terulet)
			{write-host "Kerület: $(($a+$b)*2)"}
		else		
			{write-host "Terület: $($a*$b)"}
	}
# Ellenőrzés THROW használatával
function Get-Area3 
	{	
	PARAM (	[int] $a,
		[int] $b,
		[switch] $terulet)
		Write-Host "`$a értéke = $a"
		Write-Host "`$b értéke = $b"
		if (($a -le 0) -or ($b -le 0))
			{ Throw "Pozitív számot kérek!" }
		if (!$terulet)
			{write-host "Kerület: $(($a+$b)*2)"}
		else
			{write-host "Terület: $($a*$b)"}
	}
# Ellenőrzés validateRange használatával
function Get-Area4 
	{	
	PARAM (	[int][validateRange(1,100)] $a = 1,
		[int][validateRange(1,100)] $b = 1,
		[switch] $terulet)
		Write-Host "`$a értéke = $a"
		Write-Host "`$b értéke = $b"
		if (!$terulet)
			{write-host "Kerület: $(($a+$b)*2)"}
		else
			{write-host "Terület: $($a*$b)"}
	}
# Fejlett paraméterezés
function Get-Area5
	{
	PARAM (	
		[Parameter(Mandatory = $true, 
                 Position = 0, 
                 HelpMessage = "A oldal hosszúsága centiméterben")]
		 [int][validateRange(1,100)] $a = 1,
		[Parameter(Mandatory = $false, 
                 Position = 1, 
                 HelpMessage = "B oldal hosszúsága centiméterben")]
		[int][validateRange(1,100)] $b = 1,
		[switch] $terulet
              )
		Write-Host "`$a értéke = $a"
		Write-Host "`$b értéke = $b"
		if (!$terulet)
			{
			write-host "Kerület: $(($a+$b)*2)"
			}
		else
			{
			write-host "Terület: $($a*$b)"
			}
	}
# Paraméterkészletek
function Get-Area6
	{
	PARAM (	
		[Parameter(Mandatory = $true, 
                 Position = 0, 
                 HelpMessage = "A oldal hosszúsága centiméterben")]
		 [int][validateRange(1,100)] $a = 1,
		[Parameter(Mandatory = $false, 
                 Position = 1, 
                 ParameterSetName = "rectangle",
                 HelpMessage = "B oldal hosszúsága centiméterben")]
		[int][validateRange(1,100)] $b = 1,
		[switch] $terulet
              )
		Write-Host "`$a értéke = $a"
		Write-Host "`$b értéke = $b"
		if (!$terulet)
			{
			if($pscmdlet.ParameterSetName -ne "rectangle")
				{write-host "Kerület: $(($a+$a)*2)"}		
			else
				{write-host "Kerület: $(($a+$b)*2)"}
			}
		else
			{
			if($pscmdlet.ParameterSetName -ne "rectangle")
				{write-host "Terület: $($a*$a)"}		
			else
				{write-host "Terület: $($a*$b)"}
			}
	}
# Adatok fogadása a csőből	
function Get-Area7
	{
	PARAM ( 	
		[Parameter(Mandatory = $true,
		 Position = 0,
		 HelpMessage = "A oldal hosszúsága centiméterben",
		 ValueFromPipeline = $true)]
		[int][validateRange(1,100)] $a = 1,
		[Parameter(Mandatory = $false,
		 Position = 1,
		 ParameterSetName = "rectangle",
		 HelpMessage = "B oldal hosszúsága centiméterben")]
		[int][validateRange(1,100)] $b = 1
	      )  
	BEGIN {	
		Write-Host "`$a értéke = $a"
		Write-Host "`$b értéke = $b"
	      }
	PROCESS
	      {	
		if($pscmdlet.ParameterSetName -ne "rectangle")
			{$k=($a+$a)*2
			$t=$a*$a}		
		else
			{$k=($a+$b)*2
			$t=$a*$b}
	      }
	END   
	      {
			Write-Host("Kerület: $k")
			Write-Host("Terület: $t")
	      }
	}
# Azonos pozíciójú paraméterek	
function Get-Area8
	{
	PARAM ( 	
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "square",
		 HelpMessage = "A oldal hosszúsága centiméterben")]
		[int][validateRange(1,100)] $a = 1,
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "circle",
		 HelpMessage = "Sugár hosszúsága centiméterben")]
		[int][validateRange(1,100)] $r = 1
	      )  
		if($pscmdlet.ParameterSetName -ne "square")
			{$k=($r*3.14)*2
			$t=$r*$r*3.14}		
		else
			{$k=($a+$a)*2
			$t=$a*$a}
		Write-Host("Kerület: $k")
		Write-Host("Terület: $t")
	}
# Alapértelmezett paraméterkészlet	
function Get-Area9
	{
	[CmdletBinding(DefaultParameterSetName="square")]
	PARAM ( 	
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "square",
		 HelpMessage = "A oldal hosszúsága centiméterben")]
		[int][validateRange(1,100)] $a = 1,
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "circle",
		 HelpMessage = "Sugár hosszúsága centiméterben")]
		[int][validateRange(1,100)] $r = 1
	      )  
		if($pscmdlet.ParameterSetName -ne "square")
			{$k=($r*3.14)*2
			$t=$r*$r*3.14}		
		else
			{$k=($a+$a)*2
			$t=$a*$a}

		Write-Host("Kerület: $k")
		Write-Host("Terület: $t")
	}
# ValidateSet
function Get-Area10
	{
	[CmdletBinding()]
	PARAM ( 	
		[Parameter(Mandatory = $false,
		 Position = 0,
		 HelpMessage = "A oldal hosszúsága centiméterben",
		 ValueFromPipeline = $true)]
		[int][validateRange(1,100)] $a = 1,
		[Parameter(Mandatory = $false,
		 Position = 1,
		 HelpMessage = "B oldal hosszúsága centiméterben")]
		[int][validateRange(1,100)] $b = 1,
		[Parameter(Mandatory = $false,
		 Position = 2,
		 HelpMessage = "Sugár hosszúsága centiméterben")]
		[int][validateRange(1,100)] $r = 1,
		[Parameter(Mandatory = $true)]
	     	[ValidateSet("Square","Rectangle","Circle")]
     		$mode
	      ) 
	switch ($mode) 
		{
		   "Square" 	{$k=($a+$a)*2;$t=$a*$a}
		   "Rectangle"  {$k=($a+$b)*2;$t=$a*$b}
		   "Circle" 	{$k=($r*3.14)*2;$t=$r*$r*3.14}	
		} 
		
		Write-Host("Kerület: $k")
		Write-Host("Terület: $t")
	}



