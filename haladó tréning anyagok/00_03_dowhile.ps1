$a = 0
do 
      {"{0}: {1}" -f (65+$a), [char](65+$a++)} 
while ($a -ne 26)
$a