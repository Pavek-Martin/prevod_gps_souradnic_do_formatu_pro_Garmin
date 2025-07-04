cls

#$out = "N54° 31,314' E18° 32,519'"
$out = "N54° 31.314' E18° 32.519'"

echo "pred"
echo $out



<#
   toto zalezi na nastaveni desetineho oddelovace v systemu Windows
   pokud mate nastaven na znak "," bude vysledek skriptu napr. N54° 31,314' E18° 32,519'
   ze znakem carka si ale zase bohuzel nerozumy pri vkladani souradnice pri editace trasoveho bodu
   program "BaseCamp" takze prikaz -repace zajisti ze pokud se ve vystupu vyskytuji nejake znaky
   carka tak je vsechny nahradio za znak tecka, pokud mate ve Windows v ovladacich panelech
   nastaven jako desetiny oddelovac znak "." tak bude vysledek napr. N54° 31.314' E18° 32.519'
   a v takovem pripade si ho prikaz -replace nebude vsimat
#>

echo "po"
echo $out

sleep 10
