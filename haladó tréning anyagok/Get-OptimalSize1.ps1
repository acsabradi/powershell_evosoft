param
(
      [int64]$sizeInBytes
)
BEGIN
{
 if ($sizeInBytes)
  {
    switch ($sizeInBytes) 
     {
      {$sizeInBytes -ge 1TB} {"{0:n2}" -f  ($sizeInBytes/1TB) + " TeraBytes";break}
      {$sizeInBytes -ge 1GB} {"{0:n2}" -f  ($sizeInBytes/1GB) + " GigaBytes";break}
      {$sizeInBytes -ge 1MB} {"{0:n2}" -f  ($sizeInBytes/1MB) + " MegaBytes";break}
      {$sizeInBytes -ge 1KB} {"{0:n2}" -f  ($sizeInBytes/1KB) + " KiloBytes";break}
      default { "{0:n2}" -f $sizeInBytes + " Bytes" }
     }
  }
}
PROCESS
{
 if ($_)
  {
   switch ($_) 
    {
     {$_ -ge 1TB} {"{0:n2}" -f  ($_/1TB) + " TeraBytes";break}
     {$_ -ge 1GB} {"{0:n2}" -f  ($_/1GB) + " GigaBytes";break}
     {$_ -ge 1MB} {"{0:n2}" -f  ($_/1MB) + " MegaBytes";break}
     {$_ -ge 1KB} {"{0:n2}" -f  ($_/1KB) + " KiloBytes";break}
     default { "{0:n2}" -f $_ + " Bytes" }
    }
  }
}  