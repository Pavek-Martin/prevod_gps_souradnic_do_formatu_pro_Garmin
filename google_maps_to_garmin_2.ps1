cls

# prevede GPS souradnice z Google maps do formatu pro Garmin, program MapSource a GPS navigaci Garmin Dakota

Remove-Variable * -ErrorAction SilentlyContinue

echo "50.0755535254892, 14.429683968740438" # opet podobna situace jako u maps.my, ruzny pocet desetinych mist tady 13, 15
echo "64.13767053395023, -21.89129586682449" # delka desetinych mist 14 a 14 
echo "-33.90667755606154, 18.42039883044853" # 14, 14
echo "54.53380303960464, 18.547973426086507" # 14, 15

Write-Host -ForegroundColor red " ^- toto jsou priklady souradnice bodu z www stranek Google maps"

$google_maps = Read-Host -Prompt "zadej souradnice z Google Maps "
#echo $google_maps.GetType() # string

echo $google_maps

# novy zpusob s funci StringFind
$d_google_maps = $google_maps.Length
#echo $d_google_maps
$znak_carka = ","
$nalezeno_carka = $google_maps.IndexOf($znak_carka) # StringFind
#echo $nalezeno_carka

$s1 = $google_maps.Substring(0,$nalezeno_carka) # pokud je prvni souradnice zaporny cislo tak je retezec o jeden znak delsi (-cilso)
#echo $s1
$s2 = [Double] $s1
echo $s2
#echo $s2.GetType()

#
$s3 = $google_maps.Substring($nalezeno_carka + 2, $d_google_maps - $nalezeno_carka - 2 )
#echo $s3
$s4 = [Double] $s3
echo $s4
#echo $s4.GetType()


# funkce prevod google_maps -> Garmin
function google_maps_to_garmin ([double] $Coordinate) {
$absCoord = [math]::Abs($Coordinate)
#write-host $absCoord"<--a" "write-host" se na rozdil od prikazu "echo" nebude plect do vytupu z funkce
$degrees = [math]::Floor($absCoord)
#write-host $degrees"<--d"
$minutes = (($absCoord - $degrees) * 60)
#write-host $minutes"<--m"
#$r =  "{0:00}° {1:00.000}'" -f $degrees, $minutes
$r =  "{00}° {1:00.000}'" -f $degrees, $minutes # neco jako printf()
echo $r # return $r
}


# tisk vysledne sourednice formatu Garmin pro vstup z aplikace MapsMy (Android)
$google_maps_1 = ""

# N nebo S
if ( $s2 -lt 0 ) { $google_maps_1 += "S" } else { $google_maps_1 += "N" }
$google_maps_1 += google_maps_to_garmin $s2

# E nebo W
if ( $s4 -lt 0 ) { $google_maps_1 += " W" } else { $google_maps_1 += " E" }
$google_maps_1 += google_maps_to_garmin $s4

#echo $google_maps_1
echo "prevedeno do formatu Garmin"
Write-Host -ForegroundColor Yellow $google_maps_1

sleep 30
