cls

<#
   prevede GPS souradnice z mapy.cz do formatu pro Garmin ( program MapSource a navigace Garmin Dakota )
#>

Remove-Variable * -ErrorAction SilentlyContinue

echo "50.0753708N, 14.4299775E" # mapy.cz nepuzivaji -neco +neco jako Google maps a apolikace maps.mt
echo "33.9214156S, 18.4149131E" # ale v rovnou obsahuji N,S ; E,W
echo "64.1484644N, 21.9489853W" # takze odpada radek z funkci "Abs" tedy prevod zapodneho cisla na kladne napr. [math]::Abs(-10) 
echo "54.5218975N, 18.5419822E" # pocet desetinych mist je pro mapy.cz vzdy stejny a je 7 mist

Write-Host -ForegroundColor Red " ^- toto jsou priklady souradnice bodu z www stranek mapy.cz"

$mapy_cz = Read-Host -Prompt "zadej souradnice z mapy.cz "
echo $mapy_cz
#echo $mapy_cz.GetType() #string

#Set-Clipboard "64.1484644N, 21.9489853W" # testovaci radek
#Set-Clipboard "50.0753708N, 14.4299775E"

# novy zpusob s funci StringFind
$d_mapy_cz = $mapy_cz.Length
#echo $d_maps_my
$znak_carka = ","
$nalezeno_carka = $mapy_cz.IndexOf($znak_carka) # StringFind
#echo $nalezeno_carka


$s1 = $mapy_cz.Substring(0,$nalezeno_carka - 1) # pokud je prvni souradnice zaporny cislo tak je retezec o jeden znak delsi (-cilso)
#echo $s1
$s2 = [Double] $s1
echo $s2
#echo $s2.GetType()

$p2 = $mapy_cz.Substring($nalezeno_carka -1, 1) # N nebo S
#echo $p2

# 
$s3 = $mapy_cz.Substring($nalezeno_carka + 2, $d_mapy_cz - $nalezeno_carka - 3 )
#echo $s3
$s4 = [Double] $s3
echo $s4
#echo $s4.GetType()

$p4 = $mapy_cz.Substring($d_mapy_cz -1, 1) # E nebo W
#echo $p4

# funkce mapy.cz -> Garmin
function mapy_cz_to_garmin ([double] $Coordinate) {
# $absCoord = [math]::Abs($Coordinate) # prevod na absolutni hodnotu ( mapy.cz nepouziva zaporna cisla jako maps.my)
# $degrees = [math]::Floor($absCoord) # proto zde tyto dva radky odpadaji a pribyli nove promenne $p2 a $p4
$degrees = [math]::Floor($Coordinate)
$minutes = (($Coordinate - $degrees) * 60)
#$r2 =  "{0:000}° {1:000.0000}'" -f $degrees, $minutes # stupne 054, minuty 031, vteriny 3139
$r2 =  "{0:00}° {1:00.000}'" -f $degrees, $minutes # ok.
$r2 = $r2 -replace "," , "." # nahrazuje vschny vyskyta znaku "," za znak "."
echo $r2
}

#mapy_cz_to_garmin $s2
#mapy_cz_to_garmin $s4
#exit

# tisk vysledne sourednice formatu Garmin pro vstup z mapy.cz
$mapy_cz_1 = $p2 + $(mapy_cz_to_garmin $s2) + " " + $p4 + $(mapy_cz_to_garmin $s4)
echo "prevedeno do formatu Garmin"
#echo $mapy_cz_1
Write-Host -ForegroundColor Yellow $mapy_cz_1
sleep 30

