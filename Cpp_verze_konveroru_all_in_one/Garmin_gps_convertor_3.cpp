#include <iostream> // cout, pause()
#include <cmath> // fabs()
//#include <string> // bezny veci ji navyzadujou
#include <windows.h> // pro funkci delay(), a funkci nastav_barvu()

using namespace std;
//-std=gnu++11
// toto na karte Nastoje->Nastaveni prekladace, viz screenshoty v adresari "/jpg"

/*
    univerzalni konvertor pro vsechny tri tipy souradnic na jednou
    automaticky rozpozna jeden ze tri typu ktery mu byl zadan a podle toho urci metodu prevodu
    pro "Google Maps" a "MAPS.ME" se pouziva stejna metoda, souradnice se lisi pouze delkou,
    tedy poctem desetinych mist a pro "mapy.cz" ktera jako jedina v sobe krome cislic obahuje 
    i pismena a jeste neobsahuje nikdy zaporna cisla tak pro tu pouziva jinou metodu prevodu
    vstup neni ostren proti chybe zadani ve smyslu regular expressions
 */

char pole[] = {'N', 'S', 'E', 'W'}; // pro mapy.cz
string znak, a1, a2, z1, z2;

double a11, a12, a21, a22;
int s1, s2;
double m1, m2;
   
int nalezeno_seznam;
int je_to_mapy_cz;

int nalezeno_carka;
string vstup;
int d_vstup;

// funkce pro nastaveni barvy ( Microsoft Copilot, poradil :)
void nastav_barvu(WORD attr) {
SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), attr);
}

// funkce ktera zobrazi prompt a vrati cely radek zadant uzivatelem
string inputString( const string& prompt ) {
cout<<prompt;
cout.flush(); // ujisti se ze se prompt skuteznz zobrazil
string line;
getline(cin, line); // prevte cely radek (vcetne mezer)
return line;
}


int main() {
		
	// definovani pole barev (uzijte si barvy :)
	struct paleta { const char* name; WORD attr; };
	    paleta barva[] = {
        { "[0] Bright Green", FOREGROUND_INTENSITY | FOREGROUND_GREEN },
        { "[1] Bright Cyan", FOREGROUND_INTENSITY | FOREGROUND_GREEN  | FOREGROUND_BLUE },
        { "[2] Bright Red", FOREGROUND_INTENSITY | FOREGROUND_RED },
        { "[3] Bright Yellow", FOREGROUND_INTENSITY | FOREGROUND_RED | FOREGROUND_GREEN },
        { "[4] Default barva konzole", FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE },
    };
	
	nastav_barvu(barva[0].attr); // nastavena zelena barva
	cout<<"tento program prevadi souradnice nekolika typu do formatu souradnic ";
	cout<<'"'<<"Garmin"<<'"'<<endl<<endl;
	//
	nastav_barvu(barva[2].attr); // cervena
	cout<<"toto je nekolik ukazek souradnic ktere pouzivaji www stranky ";
	cout<<'"'<<"Google Maps"<<'"'<<endl;
	cout<<"50.0755535254892, 14.429683968740438"<<endl;
    cout<<"64.13767053395023, -21.89129586682449"<<endl;
    cout<<"-33.90667755606154, 18.42039883044853"<<endl;
    cout<<"54.53380303960464, 18.547973426086507"<<endl;
    //
    nastav_barvu(barva[1].attr); // cyan
	cout<<"pro Android alikaci ";
	cout<<'"'<<"MAPS.ME"<<'"';
	cout<<" vypadaji souradnice nejakeho obektu treba takto"<<endl;
	cout<<"50.07433, 14.43031"<<endl;
    cout<<"40.774126, -73.972655"<<endl;
    cout<<"-33.928997, 18.417401"<<endl;
    cout<<"64.14599, -21.942253"<<endl;
    //
    nastav_barvu(barva[3].attr); // zluta
	cout<<"www stranky ";
	cout<<'"'<<"mapy.cz"<<'"';
	cout<<" pouzivaji takovyto format souradnic"<<endl;
	cout<<"50.0753708N, 14.4299775E"<<endl;
    cout<<"33.9214156S, 18.4149131E"<<endl;
    cout<<"64.1484644N, 21.9489853W"<<endl;
    cout<<"54.5218975N, 18.5419822E"<<endl;
    //

	// zadani souradnic uzivatelem
	nastav_barvu(barva[4].attr); // default barva
	vstup = inputString("zadej jakoukoliv libovolnou souradnici z techto tri ukazkovych tipu : ");
    cout<<vstup<<endl;
    
    // testovaci radky
    //vstup = "50.0753708N, 14.4299775E"; // mapy.cz ( NE,SW )
    //vstup = "50.0753708S, 14.4299775W"; // mapy.cz ( NE,SW )
    //vstup = "40.774126, 73.9726551"; // maps.me
    //vstup = "-64.13767053395023, -21.89129586682449"; // Google Maps
    //vstup = "iefieje, dfdfd"; // testy chyby vstupu
    //vstup = "iwuriencvkdfd"; // test chyby 2
    
    //nema regular expressions, na osetreni vstupu
	nalezeno_carka = vstup.find(',');
    //cout<<nalezeno_carka<<endl;
    if (nalezeno_carka == string::npos ){ // kdyz ve vstupnim retezci nenajde znak ","
    cout<<"chyba zadani"<<endl; // kdyz nenajde carku
    Sleep(5000);
	exit (1); // chyba zadani uzivatele
	}
    
	d_vstup = vstup.length(); // spolecny pro vsechno
    //cout<<d_vstup<<"--delka vstup"<<endl;
    
	int d_pole = sizeof(pole) / sizeof(pole[0]);
	//cout<<"pole delka = "<<d_pole<<endl;
	
	for (int aa = 0; aa<= d_pole -1; aa++) {
	znak = pole[aa];
	//cout<<znak<<endl;
	nalezeno_seznam = vstup.find(znak);
	if (nalezeno_seznam != string::npos) { je_to_mapy_cz = 1; }
}

	//cout<<je_to_mapy_cz<<" -- je to mapy.cz"<<endl;
	// souradnice ze seznamu se rozdeleni 4 casti a1,a2,z1,z2
	if ( je_to_mapy_cz == 1 ){ // ==
	//cout<<"mapy.cz"<<endl;
	// prevede string na datovy typ double pro argument [1]
    a1 = vstup.substr(0, nalezeno_carka -1);
    //cout<<a1<<endl;
    z1 = vstup.substr(nalezeno_carka -1,1);
    //cout<<z1<<endl;
	a2 = vstup.substr(nalezeno_carka +2, ((d_vstup - nalezeno_carka) -3 ));
	//cout<<a2<<endl;
    z2 = vstup.substr(d_vstup -1, 1);
    //cout<<z2<<endl;	
	
	} else { // tady konci kdyz je to mapy.cz a pokracuje kdyz je to ostatni (google maps, maps.me)
	//cout<<"ostatni ( co neni mapy.cz )"<<endl;
	a1 = vstup.substr(0, nalezeno_carka);
    //cout<<a1<<"--a1"<<endl;
    a2 = vstup.substr(nalezeno_carka +2, (d_vstup - nalezeno_carka));
	//cout<<a2<<"--a2"<<endl;
    }
    
    // odsud, spolecne pro vsechny tri tipy souradnic
    //cout<<"spolecne pro vsechno"<<endl;
    cout<<a1<<endl; // kdyz je promenna typu strings jeste pred prevodem pomoci "stod()"
    cout<<a2<<endl; // tak samozdejme jeste, tiskne plny pocet desetinnych mist
    
	a11 = stod(a1); // prevede promennou typu string na typ double - stod()
    //cout<<a11<<endl; // tisk cout - zkracene ale jinak promenna obsahuje plni pocet desetinych mist
    
    a21 = stod(a2);
	//cout<<a21<<endl; // pri pouziti printf() - vytiskne plny pocet desetinych mist
	
	// funkce abs (absolutni hodnota), ze vseho zaporneho udela kladne cislo
	a12 = fabs(a11); // #include <cmath>
	//cout<<a12<<endl;
	
	a22 = fabs(a21);
	//cout<<a22<<endl;
	
	// N nebo S ( Google Maps, Mapy.cz )
    if ( je_to_mapy_cz == 0 &&  a11 > 0 ) {
	z1 = "N";
	}else if ( je_to_mapy_cz == 0  &&  a11 < 0) {
	z1 = "S";
	}
	
	//  W nebo E
	if ( je_to_mapy_cz == 0  &&  a21 > 0 ) {
	z2 = "E";
	}else if ( je_to_mapy_cz == 0  &&  a21 < 0) {
	z2 = "W";
	}
    
	// vypocet pro vsechno spolecne ( vsechy tri typi souradnic )
	// prevede typ double na typ int a ziska tim cele cislo cele cislo, coz bude pocet stupnu "s1"
	s1 = a12; // bude stupne, jako cele cislo (int), ukroji desetiny
	m1 = (( a12 - s1 ) * 60 ); // "m1" - jiz pouze minuty a vteriny ( desetine cislo )

	s2 = a22; // s2 bude cele cislo (stupne s2)
	m2 = (( a22 - s2 ) * 60 ); // stupne 2, minuty 2 ( druha cast vstupniho coordinatu )

	// tist vysledku, prevodu
	nastav_barvu(barva[0].attr); // nastavena zelena barva
	cout<<"prevedeno do formatu pro Garmin\n";
	    
	/*  
	    tyhly radky printf(), kdyz se to udelalo jako funkce ( stejne jako v verzi PS ) tak se to chovalo divne
	    neprisel jsem na to proc, v tomhle miste se moc nezadarilo
	    po dlouhy serii pokusu nakonec vyreseno takhle, bez funkce ( tzn. 2x totez )
	    samozdrejme ze to ovlivnilo celej script
	    problem byl ze printf() uvnitr funkce se nechoval jak se mu bylo rikalo
	    viz. dole mala napoveda, nefungovalo jak by melo ("%06.3f", mN)
	*/
	cout<<z1;
	printf("%02d %06.3f ",s1, m1); // pokud je napr. 9 stupnu (%02d), nebo 9 minut da pred to jeste nulu
	cout<<z2;
	printf("%02d %06.3f\n",s2, m2); // %06.3f - 2 znaky stupne + tecka + 3naky desetiny = 6 znaku celkem
    // znak "°" neumel spravne zobrazit - BaseCamp si to doplni sam a GPS-ka to nepotrebuje pri rucnim zadavani
    
    
	/* mala napoveda k funkci, printf()
	       %d - cele cislo
	       %f - desetine cislo ( vychozich, 6 mist )
	       %.2f - desetine cislo se dvema desetinnymi misty
	       %06.3f - celkem 6 znaku - 2 cela cisla + tecka + 3 destinny ( minut < 9 = 09, pridava pred minuty nulu )
	       %s - C-retezec
	       \n - newline
	       kde je mezera mezi uvozovkamy tak ji zobrazuje taky
	*/
	
	nastav_barvu(barva[4].attr); // default barva
	system("pause");
	return 0;
}


