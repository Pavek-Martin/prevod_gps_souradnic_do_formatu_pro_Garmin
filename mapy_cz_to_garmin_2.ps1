cls

<#
   prevede GPS souradnice z mapy.cz do formatu pro Garmin ( program MapSource a navigace Garmin Dakota )
   pozor. netestovano na zaporni cisla " - 14.3941644 E" apod.
#>

Remove-Variable * -ErrorAction SilentlyContinue

echo "50.0980625 N, 14.3941644 E"
echo " ^- toto je priklad souradnice bodu z mapy.cz"
echo ""

Set-Clipboard "50.0980625 N, 14.3941644 E"
Write-Host -ForegroundColor red "toto je nyni v clipboardu Ctrl+v : 50.0980625 N, 14.3941644 E"
$mapy_cz = Read-Host -Prompt "zadej souradnice "
echo $mapy_cz
#echo $mapy_cz.GetType() #string

# $mapy_cz = "50.0980625 N, 14.3941644 E"

# rozsekani vstupniho stringu na jednotlivosti ( pro mapy.cz )
# N
$N1 = $mapy_cz.Substring(0,10)
#echo $N1
$N2 = [Double] $N1
#echo $N2

# E
$E1 = $mapy_cz.Substring(14,10)
#echo $E1
$E2 = [Double] $E1
#echo $E2

#$N2= 50.09806 # testovaci radky
#$N2 = 5.0980625
#echo $N2.GetTypeCode()

# funkce mapy.cz -> Garmin
function mapy_cz_to_garmin ([double] $Coordinate) {
$absCoord = [math]::Abs($Coordinate)
$degrees = [math]::Floor($absCoord)
$minutes = (($absCoord - $degrees) * 60)
#$r =  "N{0:00}° {1:00.000}'" -f $degrees, $minutes
$r =  "{0:00}° {1:00.000}'" -f $degrees, $minutes
echo $r
}


# tisk vysledne sourednice formatu Garmin pro vstup z mapy.cz
$garmin_1 = "N" + $(mapy_cz_to_garmin $N2) + " E" + $(mapy_cz_to_garmin $E2)
echo $garmin_1
#echo "N50° 05.884' E14° 23.650'"
#echo " ^- puvodni z gps-ky Garmin"

sleep 20
