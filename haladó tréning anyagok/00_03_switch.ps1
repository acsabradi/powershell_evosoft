$a = [int](Read-Host "Kérek egy számot")

Write-Host "============================" 
Write-Host "Értékvizsgálat Break nélkül"
Write-Host "============================"
switch($a) 
{ 
	{$a -gt 10} {"Nagyobb mint 10."} 
	{$a -gt 5}  {"Kisebb/Egyenlő 10, Nagyobb mint 5."} 
	default     {"Kisebb/Egyenlő 5."} 
}

Write-Host "=================================="
Write-Host "Értékvizsgálat Break használatával"
Write-Host "=================================="
switch($a) 
{ 
	{$a -gt 10} {"Nagyobb mint 10."; break} 
	{$a -gt 5}  {"Kisebb/Egyenlő 10., Nagyobb mint 5"; break} 
	default     {"Kisebb/Egyenlő 5."} 
}

$fruit = "orange"
Write-Host "===================================="
Write-Host "Gyümölcsösszehasonlítás Break nélkül"
Write-Host "===================================="
switch ($fruit) 
{
   "apple"  {"Alma"}
   "pear"   {"Korte"}
   "orange" {"Narancs"}
   "peach"  {"Barack"}
   "banana" {"Banan"}
    default {"Valami baj van..."}
}

Write-Host "==========================================="
Write-Host "Gyümölcsösszehasonlítás Break használatával"
Write-Host "==========================================="
switch ($fruit) 
{
   "apple"  {"Alma"; break}
   "pear"   {"Korte"; break}
   "orange" {"Narancs"; break}
   "peach"  {"Barack"; break}
   "banana" {"Banan"; break}
    default {"Valami baj van..."}
}

Write-Host "================"
Write-Host "RegEx feldogozás"
Write-Host "================"
$target = "https://www.bing.com"
switch -Regex ($target)
{
    "^ftp\://.*$"        {"$_ egy FTP cím."; break}
    "^\w+@\w+\.\w{2,4}$" { "$_ egy e-mail cím."; break }
    "^(http[s]?)\://.*$" { "$_ egy webcím ami $($matches[1])-t használ."; break }
     default             {"Valami baj van..."}
}

Write-Host "==============="
Write-Host "Tömbfeldolgozás"
Write-Host "==============="
$tomb = -2,-1,0,1,2,3,4,5,6,7,"Hello",8,9
switch ($tomb)
{
    {$_ -le 0} {continue}
    {$_ -isnot [Int32]} {break}
    {$_ % 2 -ne 0} {"$_ páratlan."}
    {$_ % 2 -eq 0}{"$_ páros."}
}
