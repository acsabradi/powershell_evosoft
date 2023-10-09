$tomb = 0..25
#=============================================
#---- Continue ----
#=============================================
Write-Host "=========="
Write-Host "Continue: "
Write-Host "=========="
foreach ($var in $tomb)
        {
        if ((65+$var) % 10 -eq 0)
           {
            continue
           }
        "{0}: {1}" -f (65+$var), [char](65+$var)
        }
#=============================================
#---- Break ----
#=============================================
Write-Host "======="
Write-Host "Break: "
Write-Host "======="
foreach ($var in $tomb)
        {
        if ((65+$var) % 10 -eq 0)
           {
            break
           }
        "{0}: {1}" -f (65+$var), [char](65+$var)
        }
