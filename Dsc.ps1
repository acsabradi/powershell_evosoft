configuration RegConfiguration {
param([string] $ensure = 'Present')
    Import-DscResource –ModuleName ’PSDesiredStateConfiguration’
    Node localhost {
	LocalConfigurationManager{
	    ConfigurationModeFrequencyMins = 15
	    ConfigurationMode = "ApplyAndAutocorrect"
	    RefreshMode = "Push"
	}
        Registry RegConfig {
            Key = "HKLM:\SOFTWARE\PSDSC"
            ValueName = "DSCKey"
            Ensure = $ensure
            ValueData = "Create by DSC"
            ValueType = "String"
        }
    }
}