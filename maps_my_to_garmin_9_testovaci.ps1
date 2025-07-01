cls

# prevede GPS souradnice z Android aplikace MapsMy do formatu pro Garmin, program MapSource a GPS navigaci Garmin Dakota 10
# tato verze je pouze testovaci ( na pouzivani je verze 10 )

Remove-Variable * -ErrorAction SilentlyContinue

#echo "50.07433, 14.43031"
#echo "40.774126, -73.972655" # v aplikaci MapsMy ma nektera souradnice 5 desetinejch mist a nektera 6 ( nemaj to sjednoceny )
#echo " ^- toto je priklad souradnice bodu z aplikace MAPS.MY pro Android"
# pozor na polohy 

#Set-Clipboard "50.07433, 14.43031"
#Write-Host -ForegroundColor red "toto je nyni v clipboardu Ctrl+v : 50.07433, 14.43031"
#$maps_my = Read-Host -Prompt "zadej souradnice z programu MapsMy "
#echo $maps_my.GetType() #string

$maps_my = "50.07433, 14.43031" # metro I.P. Pavlova v aplikaci MapsMy ( sedi presne )
#                                 N50° 04.460' E14° 25.818' skutecnost (BaseCamp)
#                                 N50° 04.460' E14° 25.819' vypocet sedi 

#$maps_my = "64.14599, -21.942253" # Reykjavik  N64° 08.759' W21° 56.535' skutecnst (BaseCamp)
#                                               N64° 08.759' W21° 56.535' vypocet sedi        

#$maps_my = "-33.928997, 18.417401" # kapske mesto  S33° 55.740' E18° 25.044' skutecnost
#                                                   S33° 55.740' E18° 25.044' vypocet

#$maps_my = "-4.321699, 15.312604" # Kinshasa     S4° 19.302' E15° 18.756' skutecnost
#                                                 S4° 19.302' E15° 18.756' vypocet sedi !

#$maps_my = "-54.806935, -68.30731" # Ushuaia  S54° 48.416' W68° 18.439' skutecnost
#                                              S54° 48.416' W68° 18.439' vypocet tady (sedi)       

#$maps_my = "40.774126, -73.972655" # Central Park  N40° 46.448' W73° 58.359' skutecnost (BaseCamp)
#                                                  N40° 46.448' W73° 58.359' vypocet
# posledni definici si ponecha ( prepise hodnotu premenne $maps_my z radku 18 )

#$maps_my = "3.741895, 8.774065" # Malabo   N3° 44.514' E8° 46.444' skutecnost
#                                           N3° 44.514' E8° 46.444' vypocet

#$maps_my = "0.408658, 9.44187" # Libreville  N0° 24.519' E9° 26.512' skutecnost
#                                             N0° 24.519' E9° 26.512' vypocet

echo $maps_my

# novy zpusob s funci StringFind
$d_maps_my = $maps_my.Length
#echo $d_maps_my
$znak_carka = ","
$nalezeno_carka = $maps_my.IndexOf($znak_carka) # StringFind
#echo $nalezeno_carka

$s1 = $maps_my.Substring(0,$nalezeno_carka) # pokud je prvni souradnice zaporny cislo tak je retezec o jeden znak delsi (-cilso)
#echo $s1
$s2 = [Double] $s1
echo $s2
#echo $s2.GetType()

# 
$s3 = $maps_my.Substring($nalezeno_carka + 2, $d_maps_my - $nalezeno_carka - 2 )
#echo $s3
$s4 = [Double] $s3
echo $s4
#echo $s4.GetType()


# funkce prevod maps_my -> Garmin
function maps_my_to_garmin ([double] $Coordinate) {
$absCoord = [math]::Abs($Coordinate)
write-host $absCoord"<--a" # "write-host" se na rozdil od prikazu "echo" nebude plect do vytupu z funkce
$degrees = [math]::Floor($absCoord)
write-host $degrees"<--d"
$minutes = (($absCoord - $degrees) * 60)
write-host $minutes"<--mm"
#$r =  "{0:00}° {1:00.000}'" -f $degrees, $minutes
$r =  "{00}° {1:00.000}'" -f $degrees, $minutes
echo $r # return $r
}


# tisk vysledne sourednice formatu Garmin pro vstup z aplikace MapsMy (Android)
$maps_my_1 = ""

# N nebo S
if ( $s2 -lt 0 ) { $maps_my_1 += "S" } else { $maps_my_1 += "N" }
$maps_my_1 += maps_my_to_garmin $s2

# E nebo W
if ( $s4 -lt 0 ) { $maps_my_1 += " W" } else { $maps_my_1 += " E" }
$maps_my_1 += maps_my_to_garmin $s4

echo "prevedeno do formatu Garmin"
Write-Host -ForegroundColor Yellow $maps_my_1
#echo $maps_my_1
sleep 30
