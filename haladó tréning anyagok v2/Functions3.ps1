# CmdletBinding
function CmdletBindingDemo1
{
	[CmdletBinding()]
	PARAM ( 	
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "wmi")]
		[string] $namespace,
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "dir")]
		[string] $dir
	      )
	switch ($PsCmdlet.ParameterSetName) 
    		{ 
    		"wmi"  { Get-WmiObject -Namespace $namespace -List -Recurse; break} 
    		"dir"  { Get-ChildItem $dir; break} 
    		} 
}
# DefaultParameterSetName
function CmdletBindingDemo2
{
	[CmdletBinding(DefaultParameterSetName="dir")]
	PARAM ( 	
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "wmi")]
		[string] $namespace,
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "dir")]
		[string] $dir
	      )
	switch ($PsCmdlet.ParameterSetName) 
    		{ 
    		"wmi"  { Get-WmiObject -Namespace $namespace -List -Recurse; break} 
    		"dir"  { Get-ChildItem $dir; break} 
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
		 ParameterSetName = "wmi")]
		[string] $namespace,
		[Parameter(Mandatory = $true,
		 Position = 0,
		 ParameterSetName = "dir")]
		[string] $dir
	      )
	switch ($PsCmdlet.ParameterSetName) 
    		{ 
    		"wmi"  { if ($PSCmdlet.ShouldProcess($namespace, 'Névtérlistázás'))
				{Get-WmiObject -Namespace $namespace -List -Recurse; break}
			} 
    		"dir"  { if ($PSCmdlet.ShouldProcess($dir, 'Könyvtárlistázás'))
				{Get-ChildItem $dir; break} 
			}
    		} 
	
}