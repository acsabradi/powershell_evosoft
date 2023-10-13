function DynamicParamFunction
{
    [CmdletBinding(DefaultParameterSetName='DefaultConfiguration')]
    Param
    (
        [Parameter(Mandatory=$true)][int]$Number
    )

    DynamicParam
    {
        $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        $attributes = New-Object System.Management.Automation.ParameterAttribute
        $attributes.ParameterSetName = "__AllParameterSets"
        $attributes.Mandatory = $true
        $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)
        # ---- Ha Number nagyobb mint 5 legyen egy második dinamikus-kötelező paramétere ----
        if($Number -gt 5)
        {
            # ---- SecondParam - kötelező string típusú paraméter ----
            $dynParam = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("SecondParam", [String], $attributeCollection)   
            # ---- Új paraméter hozáadása a paraméterkönyvtárhoz ----
            $paramDictionary.Add("SecondParam", $dynParam)
        }
        return $paramDictionary
    }

    process
    {
        Write-Host "Number = $Number"
        # ---- A dinamikus paraméterek a PSBoundParameters tömbön keresztül érhetőek el ----
        Write-Host ("SecondParam = {0}" -f $PSBoundParameters.SecondParam)
    }
}