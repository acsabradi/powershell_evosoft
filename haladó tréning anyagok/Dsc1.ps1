configuration RegConfiguration {
    Node localhost {
        Registry RegConfig {
            Key = "HKLM:\SOFTWARE\PSDSC"
            ValueName = "DSCKey"
            Ensure = 'Present'
            ValueData = "Create by DSC"
            ValueType = "String"
        }
    }
}