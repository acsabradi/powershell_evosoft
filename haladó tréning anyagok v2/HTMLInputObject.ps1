$HTMLInputObject =  @{
                   Object = Get-ChildItem "Env:" | Select -First 5
                },
                @{
                   Title  = "Directory listing for C:\";
                   Description = 'The following table contains file system information with a selection of item properties.'
                   Object = Get-Childitem "C:\" | Select -Property FullName,CreationTime,LastWriteTime,Attributes
                },
                @{
                   Title  = "Directory listing for C:\ as a list table (first 3 items only)";
                   Object = Get-Childitem "C:\" | Select -Property FullName,CreationTime,LastWriteTime,Attributes | Select -First 3
                   As     = 'List'
                }
