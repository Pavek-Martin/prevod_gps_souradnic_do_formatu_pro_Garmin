cls

# prevede GPS souradnice z Android aplikace MapsMy do formatu pro Garmin, program MapSource a GPS navigaci Garmin Dakota

Remove-Variable * -ErrorAction SilentlyContinue

echo "50.07433, 14.43031"
echo "40.774126, -73.972655" # v aplikaci MapsMy ma nektera souradnice 5 desetinejch mist a nektera 6 ( nemaj to sjednoceny )
echo "-33.928997, 18.417401"
echo "64.14599, -21.942253"

Write-Host -ForegroundColor red " ^- toto jsou priklady souradnice bodu z aplikace MAPS.MY pro Android"

$maps_me = Read-Host -Prompt "zadej souradnice z programu MapsMy "
#echo $maps_me.GetType() # string

echo $maps_me

# novy zpusob s funci StringFind
$d_maps_me = $maps_me.Length
#echo $d_maps_me
$znak_carka = ","
$nalezeno_carka = $maps_me.IndexOf($znak_carka) # StringFind
#echo $nalezeno_carka

$s1 = $maps_me.Substring(0,$nalezeno_carka) # pokud je prvni souradnice zaporny cislo tak je retezec o jeden znak delsi (-cilso)
#echo $s1
$s2 = [Double] $s1
echo $s2
#echo $s2.GetType()

# 
$s3 = $maps_me.Substring($nalezeno_carka + 2, $d_maps_me - $nalezeno_carka - 2 )
#echo $s3
$s4 = [Double] $s3
echo $s4
#echo $s4.GetType()

# funkce prevod maps_me -> Garmin
function maps_me_to_garmin ([double] $Coordinate) {
$absCoord = [math]::Abs($Coordinate)
#write-host $absCoord"<--a" "write-host" se na rozdil od prikazu "echo" nebude plect do vytupu z funkce
$degrees = [math]::Floor($absCoord)
#write-host $degrees"<--d"
$minutes = (($absCoord - $degrees) * 60)
#write-host $minutes"<--m"
$r =  "{0:00}° {1:00.000}'" -f $degrees, $minutes
#$r =  "{00}° {1:00.000}'" -f $degrees, $minutes # neco jako printf()
$r = $r -replace "," , "." # nahrazuje vschny vyskyta znaku "," za znak "."
echo $r # return $r
}


# tisk vysledne sourednice formatu Garmin pro vstup z aplikace MapsMy (Android)
$maps_me_1 = ""

# N nebo S
if ( $s2 -lt 0 ) { $maps_me_1 += "S" } else { $maps_me_1 += "N" }
$maps_me_1 += maps_me_to_garmin $s2

# E nebo W
if ( $s4 -lt 0 ) { $maps_me_1 += " W" } else { $maps_me_1 += " E" }
$maps_me_1 += maps_me_to_garmin $s4

#echo $maps_me_1
echo "prevedeno do formatu Garmin"
Write-Host -ForegroundColor Yellow $maps_me_1

sleep 30
