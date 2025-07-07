cls
<#
    univerzalni konvertor pro vsechny tri tipy souradnic na jednou
    automaticky rozpozna jeden ze tri typu ktery mu byl zadan a podle toho urci metodu prevodu
    pro "Google Maps" a "MAPS.ME" se pouziva stejna metoda, souradnice se lisi pouze delkou,
    tedy poctem desetinych mist a pro "mapy.cz" ktera jako jedina v sobe krome cislic obahuje 
    i pismena a jeste neobsahuje nikdy zaporna cisla tak pro tu pouziva jinou metodu prevodu
    vstup neni ostren proti chybe zadani ve smyslu regular expressions
        
    tato veze ma oproti predchozi navic jeste to ze vysledek prevodu ulozi do schranky
    (Ctrl + c) takze lze si vybrat ze dvou moznosti
#>

Remove-Variable * -ErrorAction SilentlyContinue

# v zahlavi spusteneho okna zobrazi informoce ( neco jako echo $0 v bash )
$ExistingVariables = Get-Variable | Select-Object -ExpandProperty Name
[string] $scriptName = pwd
$scriptName += $MyInvocation.MyCommand.Name
$host.UI.RawUI.WindowTitle = $scriptName

echo 'tento program prevadi souradnice nekolika typu do formatu souradnic "Garmin"'
echo ""

#$c = "yellow"
#$c = "gray"
$c = "red"
Write-Host -ForegroundColor $c 'toto je nekolik ukazek souradnic ktere pouzivaji www stranky "Google Maps"'
Write-Host -ForegroundColor $c "50.0755535254892, 14.429683968740438"
Write-Host -ForegroundColor $c "64.13767053395023, -21.89129586682449"
Write-Host -ForegroundColor $c "-33.90667755606154, 18.42039883044853"
Write-Host -ForegroundColor $c "54.53380303960464, 18.547973426086507"

$c = "cyan"
Write-Host -ForegroundColor $c 'pro Android alikaci "MAPS.ME" vypadaji souradnice nejakeho obektu treba takto'
Write-Host -ForegroundColor $c "50.07433, 14.43031"
Write-Host -ForegroundColor $c "40.774126, -73.972655"
Write-Host -ForegroundColor $c "-33.928997, 18.417401"
Write-Host -ForegroundColor $c "64.14599, -21.942253"

$c = "yellow"
#$c = "magenta" 
Write-Host -ForegroundColor $c 'www stranky "mapy.cz" pouzivaji takovyto format souradnic'
Write-Host -ForegroundColor $c "50.0753708N, 14.4299775E"
Write-Host -ForegroundColor $c "33.9214156S, 18.4149131E"
Write-Host -ForegroundColor $c "64.1484644N, 21.9489853W"
Write-Host -ForegroundColor $c "54.5218975N, 18.5419822E"

$input = Read-Host -Prompt "zadej jakoukoliv libovolnou souradnici z techto tri ukazkovych tipu "
echo $input

# hleda jesli $input neni tip souradnice kterou pouzivaji mapy.cz (jako jedina v sobe obsahuje i pismena)
$nalezeno_MapyCz = 0
$pole_seznam_cz = @("N", "S", "E", "W")
#echo $pole_seznam_cz

$d_pole_seznam_cz = $pole_seznam_cz.Length -1
#echo $d_pole_seznam_cz

for ( $aa = 0; $aa -le $d_pole_seznam_cz; $aa++ ){
$hledej_znak = $pole_seznam_cz[$aa]
#echo $hledej_znak
#echo $pole_seznam_cz[$aa]

$nalezeno_1 = $input.IndexOf($hledej_znak) # kdyz nenajde tak je vysledek -1
#echo $nalezeno_1"<"

if ( $nalezeno_1 -ne -1 ) {
$nalezeno_MapyCz = 1 # $input je typ souradnice mapy.cz
break # po prvnim nalezu jakehokoliv pismena z pole $pole_seznam_cz
}

}

# funkce prevod souradnic a mapy.cz -> do Garmin
function mapy_cz ([double] $Coordinate) {
# $absCoord = [math]::Abs($Coordinate) # prevod na absolutni hodnotu ( mapy.cz nepouziva zaporna cisla jako maps.me)
# $degrees = [math]::Floor($absCoord) # proto zde tyto dva radky odpadaji a pribyli nove promenne $p2 a $p4
$degrees = [math]::Floor($Coordinate)
$minutes = (($Coordinate - $degrees) * 60)
#$r2 =  "N{0:00}° {1:00.000}'" -f $degrees, $minutes
$r2 =  "{0:00}° {1:00.000}'" -f $degrees, $minutes # ok.
$r2 = $r2 -replace "," , "." # viz. screenshoty v adresari - "jpg/funkce_string_raplace/"
echo $r2
}


# funkce prevod souradnic Google Maps & MAPS.ME -> do Garmin
function neni_mapy_cz ([double] $Coordinate) {
$absCoord = [math]::Abs($Coordinate)
#write-host $absCoord"<--a" "write-host" se na rozdil od prikazu "echo" nebude plect do vytupu z funkce
$degrees = [math]::Floor($absCoord)
#write-host $degrees"<--d"
$minutes = (($absCoord - $degrees) * 60)
#write-host $minutes"<--m"
$r =  "{0:00}° {1:00.000}'" -f $degrees, $minutes # tohle je dobre, dela napr. 09 stupnu a 09 minut apod.
#$r =  "{00}° {1:00.000}'" -f $degrees, $minutes # nedelalo nuly pri <10 stupnu
$r = $r -replace "," , "." # nahrazuje vschny vyskyta znaku "," za znak "."
echo $r # return $r
}

#echo $nalezeno_MapyCz" - Mapy.cz"
$znak_carka = ","
#$c = "magenta"
#$c = "blue"
$c = "green"

# pro prevod souradnic z mapy.cz (mapy.cz, jako jediny obsahuji pismena jiz v souradnici samotne)
if ( $nalezeno_MapyCz -eq 1 ){
$d_input = $input.Length
$nalezeno_carka = $input.IndexOf($znak_carka)
$s1 = $input.Substring(0,$nalezeno_carka - 1)
$s2 = [Double] $s1
echo $s2
$p2 = $input.Substring($nalezeno_carka -1, 1)
$s3 = $input.Substring($nalezeno_carka + 2, $d_input - $nalezeno_carka - 3 )
$s4 = [Double] $s3
echo $s4
$p4 = $input.Substring($d_input -1, 1)

# zobrazeni vysledku pro mapy.cz
$out_1 = $p2 + $(mapy_cz $s2) + " " + $p4 + $(mapy_cz $s4)
#echo "prevedeno do formatu Garmin"
echo "prevedeno do formatu Garmin a vlozeno do schranky ( Ctrl+c )"
Write-Host -ForegroundColor $c $out_1
Set-Clipboard -Value $out_1

# pro prevod souradnic vse co neni "mapy.cz" (neobsahuje pismena)
}else{
$d_input = $input.Length
$nalezeno_carka = $input.IndexOf($znak_carka)
#$s1 = $input.Substring(0,$nalezeno_carka -1) # chyba ubralo desetinu na konci
$s1 = $input.Substring(0,$nalezeno_carka)
$s2 = [Double] $s1
echo $s2 # zkracuje pocet desetin
$p2 = $input.Substring($nalezeno_carka -1, 1)
#$s3 = $input.Substring($nalezeno_carka + 2, $d_input - $nalezeno_carka - 3 ) # taky byla chyba
$s3 = $input.Substring($nalezeno_carka + 2, $d_input - $nalezeno_carka -2)
$s4 = [Double] $s3
echo $s4
$p4 = $input.Substring($d_input -1, 1)


# zobrazeni vysledku pro pro ve ostatni co neni "mapy.cz"
$out_2 = ""

# N nebo S
if ( $s2 -lt 0 ) { $out_2 += "S" } else { $out_2 += "N" }
$out_2 += neni_mapy_cz $s2

# E nebo W
if ( $s4 -lt 0 ) { $out_2 += " W" } else { $out_2 += " E" }
$out_2 += neni_mapy_cz $s4

echo "prevedeno do formatu Garmin a vlozeno do schranky ( Ctrl+c )"
Write-Host -ForegroundColor $c $out_2 # jinou barvou pro odliseni
Set-Clipboard -Value $out_2
}

sleep 30
