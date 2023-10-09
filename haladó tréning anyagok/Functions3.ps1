# CmdletBinding
function CmdletBindingDemo1
{
	[CmdletBinding()]
	PARAM ( 	
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "verb")]
		[string] $verb,
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "dir")]
		[string] $dir
	      )
	switch ($PsCmdlet.ParameterSetName) 
    		{ 
    		"verb"  { Get-Command -Verb $verb; break } 
    		"dir"   { Get-ChildItem -Path $dir; break } 
    		} 
}
# DefaultParameterSetName
function CmdletBindingDemo2
{
	[CmdletBinding(DefaultParameterSetName="dir")]
	PARAM ( 	
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "verb")]
		[string] $verb,
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "dir")]
		[string] $dir
	      )
	switch ($PsCmdlet.ParameterSetName) 
    		{ 
    		"verb"  { Get-Command -Verb $verb; break } 
    		"dir"   { Get-ChildItem -Path $dir; break }  
    		} 
}
# SupportsShouldProcess
function CmdletBindingDemo3
{
	[CmdletBinding(DefaultParameterSetName="dir",
			SupportsShouldProcess)]
	PARAM ( 	
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "verb")]
		[string] $verb,
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "dir")]
		[string] $dir
	      )
	switch ($PsCmdlet.ParameterSetName) 
    		{ 
    		"verb"  { if ($PSCmdlet.ShouldProcess($verb, 'Igei parancslista'))
				{ Get-Command -Verb $verb; break } 
			} 
    		"dir"  { if ($PSCmdlet.ShouldProcess($dir, 'Könyvtárlistázás'))
				{ Get-ChildItem -Path $dir; break } 
			}
    		} 
	
}