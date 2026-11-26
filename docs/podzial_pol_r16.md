# Podział pól na trzy poziomy – przyjęty w rundzie 16 (propozycja z rundy 15)

**Od kompilacji 16 źródłem przydziału jest cecha `poziom:` każdego pola w `rdzen/parametry_*.rb`** (dom 18, typ 48, standard
131 – razem 197; lista z poziomami: `docs/parametry.md`). Tabele poniżej to stan propozycji z kompilacji 15 (194 pola) –
zostają jako zapis tego, co użytkownik zaakceptował 2026-11-25 („Możemy spróbować, wygląda dobrze”).

## 1. Zasada

| Poziom | Co to jest | Kiedy zmieniasz | Gdzie w oknie | Pól |
|---|---|---|---|---|
| **Ten dom** | wymiary i położenie tego jednego domu | przy każdym domu | okno główne, kroki w kolejności budowy | 16 |
| **Typ domu** | z czego i jak zbudowany jest dom danego rodzaju (dach, taras, zadaszenie, podłoga, poszycie, przekroje wybierane ręcznie) | gdy ustawiasz typ „w wolnych chwilach” | okno typu („Zapisz jako typ”, „Zapisz zmiany w typie”); w oknie głównym – zwinięte, z przyciskiem „zmień tylko w tym domu” | 49 |
| **Standard warsztatu** | jak budujesz zawsze: bal i zamek, łączenia, zasady węgłów, luzy, zamki płatwi, obciążenia, wymiary detali, listy drewna, zestawienie | rzadko | osobne okno „Standard warsztatu”; pojedyncze pole można nadpisać dla jednego domu | 129 |

Poza listą parametrów, zawsze na poziomie „Ten dom”: rysunek obrysu, tabela okien i drzwi, węgły ręczne i ustawienia ścian z widoku ściany.
Typ zapamiętuje pola „Typ domu” i wartości startowe pól „Ten dom” (np. Typ 200: 20 wieńców, taras 2000); standard jest jeden dla wszystkich typów.

## 2. Pola „Ten dom” (16)

| Sekcja dziś | Pole |
|---|---|
| Ściany | Liczba wieńców (ściany okapowe) (`liczba_wiencow`) |
| Ściany | Kalenica (półbal na ścianach wzdłuż kalenicy) (`kalenica`) |
| Ściany | Działowa pod stropem / antresolą – góra (`dzialowa_nizsza_wysokosc`) |
| Szczyty i dach | Jednospadowy – spadek w stronę (`dach_spadek`) |
| Szczyty i dach | Jednospadowy – okap za ścianą wysoką (`dach_okap_wysoki`) |
| Szczyty i dach | Kąt dachu (`dach_kat`) |
| Szczyty i dach | Okap – wysunięcie krokwi za ścianę (`dach_okap`) |
| Szczyty i dach | Wysunięcie płatwi za szczyt (`dach_okap_szczyt`) |
| Taras | Taras – po stronie (`taras_strona`) |
| Taras | Taras – głębokość (`taras_glebokosc`) |
| Taras | Wejście na taras od frontu (`taras_wejscie`) |
| Taras | Wejście – szerokość w świetle słupów (`taras_wejscie_szerokosc`) |
| Zadaszenie – rodzaj i wymiary | Zadaszenie – przy ścianie okapowej (`zadaszenie_strona`) |
| Zadaszenie – rodzaj i wymiary | Zadaszenie – szerokość (`zadaszenie_szerokosc`) |
| Zadaszenie – rodzaj i wymiary | Zadaszenie – kąt (mniejszy niż kąt dachu) (`zadaszenie_kat`) |
| Podłoga i fundamenty | Legary wzdłuż (`legary_kierunek`) |

## 3. Pola „Typ domu” (49)

| Sekcja dziś | Pole |
|---|---|
| Przekrój bala i zamek | Przekrój bala (`preset`) |
| Ściany | Ostatek za licem (`ostatek`) |
| Ściany | Strop nad parterem (zamknięta góra) (`strop`) |
| Węgły (kontrfory) 244 – wzmocnienia ścian | Węgieł na środku ściany – automatycznie (`wegly_srodek`) |
| Węgły (kontrfory) 244 – wzmocnienia ścian | Słupki z kontrfor (węgły) pod płatwiami (`wegly_pod_platwiami`) |
| Węgły (kontrfory) 244 – wzmocnienia ścian | Słupki pod płatwiami – pod którymi (`wegly_pod_platwiami_ktore`) |
| Szczyty i dach | Szczyty z bali (`szczyty`) |
| Szczyty i dach | Szczyty także na działowych szczytowych (`szczyty_na_dzialowych`) |
| Szczyty i dach | Działowe wzdłuż kalenicy – do dachu (`dzialowa_wzdluz_do_dachu`) |
| Szczyty i dach | Dach (`dach_rodzaj`) |
| Szczyty i dach | Układ dachu (`dach_uklad`) |
| Szczyty i dach | Krokwie i poszycie – kto je buduje (`dach_wiezba`) |
| Szczyty i dach | Krokwie przy ścianie szczytowej (`krokwie_przy_szczycie`) |
| Szczyty i dach | Krokiew (szer. × wys.) (`krokiew_przekroj`) |
| Szczyty i dach | Jeden przekrój wszystkich płatwi (`platwie_jeden_przekroj`) |
| Szczyty i dach | Płatew (pośrednia) (`platwa_przekroj`) |
| Szczyty i dach | Płatew kalenicowa (`platwa_kalenicowa_przekroj`) |
| Szczyty i dach | Oparcie dachu przy ścianie okapowej (`platwa_na_scianie`) |
| Szczyty i dach | Płatew ścienna (`platwa_scienna_przekroj`) |
| Poszycie dachu (aplikacja do dachów) | Podbitka – boazeria widoczna od spodu (`podbitka`) |
| Poszycie dachu (aplikacja do dachów) | Nadbitka – pierwsza warstwa poszycia (aplikacja do dachów) (`poszycie_nadbitka`) |
| Poszycie dachu (aplikacja do dachów) | Deskowanie pełne (`poszycie_deski`) |
| Poszycie dachu (aplikacja do dachów) | Płyty OSB (`poszycie_osb`) |
| Taras | Taras przed ścianą szczytową (`taras`) |
| Taras | Podciąg – górne wieńce ścian nad tarasem (`taras_wience_gorne`) |
| Taras | Słup tarasu (wzdłuż ściany × w poprzek) (`taras_slup_przekroj`) |
| Taras | Szczyt nad tarasem (`taras_szczyt`) |
| Taras | Szczyt pusty – bale spinające (`taras_szczyt_bale`) |
| Taras | Szczyt pusty – wiązar (trójkąt) z przekroju (`taras_wieniec`) |
| Taras | Wiązar – przekrój (grub. × wys.) (`taras_wieniec_przekroj`) |
| Taras | Wiązar – rodzaj (`taras_wiazar`) |
| Taras | Wiązar – na czym stoi (`taras_wiazar_podparcie`) |
| Taras | Wiązar – słupek i zastrzały z przekroju (`taras_wiazar_przekroje`) |
| Taras | Balustrada – z czego (`taras_balustrada_rodzaj`) |
| Taras | Balustrada z wieńców – wysokość (najwyżej) (`taras_balustrada_wysokosc`) |
| Taras | Balustrada – liczba bali (`taras_balustrada_bale`) |
| Zadaszenie – rodzaj i wymiary | Zadaszenie przy ścianie okapowej (boczne / tylne) (`zadaszenie`) |
| Zadaszenie – rodzaj i wymiary | Przybudówka – podłoga (`zadaszenie_podloga`) |
| Zadaszenie – przekroje (dobór) | Płatew zadaszenia (szer. × wys.) (`zadaszenie_platwa_przekroj`) |
| Zadaszenie – przekroje (dobór) | Słup zadaszenia (wzdłuż ściany × w poprzek) (`zadaszenie_slup_przekroj`) |
| Zadaszenie – przekroje (dobór) | Belka poprzeczna na słupie (szer. × wys.) (`zadaszenie_belka_przekroj`) |
| Podłoga i fundamenty | Podłoga (podwaliny, legary, podciągi) (`podloga`) |
| Podłoga i fundamenty | Podwalina pod ścianami (szer. × wys.) (`podwalina_przekroj`) |
| Podłoga i fundamenty | Podwaliny także pod działowymi (`podwaliny_pod_dzialowymi`) |
| Podłoga i fundamenty | Izolacja między legarami (`izolacja_podlogi`) |
| Podłoga i fundamenty | Legar – przekrój do sprawdzenia (`legar_przekroj`) |
| Podłoga i fundamenty | Podciągi pod legarami (`podciagi`) |
| Podłoga i fundamenty | Podciąg pod legarami (podpora pośrednia) (`podpora_przekroj`) |
| Podłoga i fundamenty | Fundamenty punktowe (`fundamenty`) |

## 4. Pola „Standard warsztatu” (129)

| Sekcja dziś | Pól | Pola |
|---|---|---|
| Przekrój bala i zamek | 6 | Kierunek podcięć zamka (`zamek_odbicie`); Profil bala w modelu (`profil_bala`); Pióra – liczba (`pioro_liczba`); Pióro – szerokość (`pioro_szerokosc`); Pióra – rozstaw osi (dwa pióra) (`pioro_rozstaw`); Wpust – luz (szerszy i głębszy od pióra) (`wpust_luz`) |
| Ściany | 1 | Dopełnienie zamka nad niższą działową – do wnętrza (`dopelnienie_wewn`) |
| Długości bali i łączenia | 8 | Maksymalna długość bala (`max_dlugosc`); Najkrótszy kawałek bala (`min_odcinek`); Łączenie przy działowej (`styk_na_dzialowej`); Łączenie bali na długości (`styk_uklad`); Łączenie wieńców szczytu (`szczyt_styk`); Mijanka styków w sąsiednich wieńcach (`mijanka`); Szczelina na styku (`szczelina_styku`); Styk od krawędzi otworu – najmniej (`styk_odstep_od_otworu`) |
| Węgły (kontrfory) 244 – wzmocnienia ścian | 13 | Najdłuższe światło ściany bez węgła (`wegly_max_swiatlo`); To samo dla ścian wysokich (`wegly_max_swiatlo_wysokie`); Ściana wysoka od wysokości (`wegly_prog_wysokosci`); Rozmieszczenie nowych węgłów (`wegly_rozmieszczenie`); Odstęp węgła od narożnika (`wegly_odstep_od_naroznika`); Węgieł na środku – od długości ściany (`wegly_srodek_min`); Węgieł – wypust wewnątrz domu (`wegiel_wypust_wewn`); Węgieł – wypust na zewnątrz (`wegiel_wypust_zewn`); Węgieł na wolnym końcu niepełnej ściany (`wegly_wolny_koniec`); Węgieł na wolnym końcu – od długości wolnego odcinka (`wegly_wolny_koniec_min`); Węgły także na ścianach działowych (`wegly_na_dzialowych`); Odstęp węgła od innego skrzyżowania (`min_odstep_skrzyzowan`); Odstęp węgła od krawędzi otworu (`odstep_od_otworu`) |
| Szczyty i dach | 28 | Jednospadowy – najcieńszy górny bal ściany wysokiej (`jednospad_min_pasek`); Wierzch płatwi nad ścianą okapową (przy licu wewn.) (`dach_podniesienie`); Przekrój krokwi – dobór (`krokwie_dobor`); Dostępne przekroje krokwi (`krokwie_katalog`); Rozstaw krokwi – największy (`krokwie_rozstaw`); Przekrój płatwi – dobór (`platwie_dobor`); Dostępne przekroje płatwi (`platwie_katalog`); Śnieg – obciążenie gruntu (`dach_snieg`); Ciężar pokrycia z poszyciem (`dach_ciezar`); Ugięcie płatwi dopuszczalne L / (`dach_ugiecie`); Największy rozstaw płatwi (w poziomie) (`platwie_rozstaw_max`); Płatew ścienna – położenie (`platwa_scienna_polozenie`); Płatwie oparte na pełnym balu (`platwie_na_wiencach`); Dopasowanie płatwi – największe obniżenie dachu (`dach_obnizenie_max`); Dopasowanie płatwi – największe przesunięcie pośredniej (`platwie_przesuniecie_max`); Zamki w płatwiach (wręby w ścianach) (`platwie_zamki`); Zamek płatwi – wrąb z każdego boku (`platwa_zamek_bok`); Zamek płatwi – wrąb od spodu (`platwa_zamek_dol`); Zamek płatwi – luz wzdłuż (z każdej strony ściany) (`platwa_zamek_luz`); Luz w gnieździe płatwi (każda strona) (`gniazdo_luz`); Wierzch płatwi ścięty do płaszczyzny dachu (`platwie_sciecie`); Najniższy kawałek bala przy skosie (`szczyt_min_wysokosc`); Drewno w zamku przy skosie dachu – najmniej (`zamek_min_drewno`); Najkrótszy kawałek bala przy skosie i gnieździe (`szczyt_min_kawalek`); Belki dachu w modelu (płatwie, krokwie) (`dach_elementy`); Górne wieńce ścian okapowych wypuszczone za szczyt (`okap_wience_wypust`); Węgły pod okapem – górne bale do nawisu okapu (`wegly_wypust_okap`); Węgły pod okapem – liczba górnych bali (`wegly_okap_wience`) |
| Poszycie dachu (aplikacja do dachów) | 14 | Podbitka – grubość (`podbitka_grubosc`); Podbitka – szerokość deski (krycie) (`podbitka_krycie`); Podbitka – długość handlowa (`podbitka_dlugosc`); Nadbitka – grubość (`nadbitka_grubosc`); Nadbitka – szerokość krycia (`nadbitka_krycie`); Nadbitka – długość handlowa (`nadbitka_dlugosc`); Deskowanie – grubość deski (`deski_grubosc`); Deskowanie – szerokość deski (`deski_szerokosc`); Deskowanie – szczelina między deskami (`deski_szczelina`); Deskowanie – długość handlowa (`deski_dlugosc`); OSB – grubość (`osb_grubosc`); OSB – długość płyty (wzdłuż okapu) (`osb_dlugosc`); OSB – szerokość płyty (`osb_szerokosc`); OSB – szczelina przy każdej krawędzi (`osb_szczelina`) |
| Taras | 19 | Ostatek dolnych bali ścian bocznych przy tarasie (`taras_ostatek`); Słupy – największy rozstaw (osiowo) (`taras_slupy_rozstaw_max`); Słup frontu w osi kalenicy (`taras_slup_w_osi`); Słup w osi – słup wejścia bliżej osi niż tyle staje w osi (`taras_slup_os_dociag`); Słup – zamek górny (wysokość obok bala) (`taras_slup_zamek_gora`); Słup – zamek dolny (obok podwaliny) (`taras_slup_zamek_dol`); Słupy krótsze o osiadanie ścian (`slup_osiadanie`); Słup – regulacja w głowicy (`slup_regulacja`); Śruba regulacyjna – wysokość po skręceniu (`slup_regulacja_wysokosc`); Wiązar – gniazdo płatwi, najmniejsza głębokość (`taras_wiazar_gniazdo`); Wiązar – szerokość słupka (`taras_wiazar_slupek`); Wiązar – szerokość zastrzału (`taras_wiazar_zastrzal`); Wiązar – kąt zastrzałów od poziomu (`taras_wiazar_zastrzal_kat`); Łączenie bali frontu i szczytu nad tarasem (`taras_styk`); Zamek płatwi w szczycie nad tarasem (`taras_platwa_zamek`); Balustrada z wieńców – zakładka w narożnikach frontu (`taras_zakladka`); Zakładka – wysunięcie belki (`taras_zakladka_wypust`); Balustrada – długość przekładki (`taras_przekladka`); Balustrada – największy prześwit między przekładkami (`taras_przekladka_odstep`) |
| Zadaszenie – rodzaj i wymiary | 2 | Zadaszenie – okap za podporą (najmniej) (`zadaszenie_okap`); Słupy zadaszenia – największy rozstaw (osiowo) (`zadaszenie_slupy_rozstaw`) |
| Zadaszenie – przekroje (dobór) | 3 | Przekroje zadaszenia – dobór (`zadaszenie_dobor`); Dostępne przekroje belek zadaszenia (`zadaszenie_katalog`); Dostępne przekroje słupów zadaszenia (`zadaszenie_slupy_katalog`) |
| Podłoga i fundamenty | 16 | Podwaliny w narożnikach (`podwalina_laczenie`); Rozstaw legarów (osiowo) (`legary_rozstaw`); Dobór przekroju legara (`legary_dobor`); Rozstaw podciągów pod legarami – największy (`podpory_rozstaw_max`); Podciąg – poziom (`podciag_poziom`); Fundament punktowy – kształt w rzucie (`fundament_ksztalt`); Fundament punktowy – wymiary w rzucie (`fundament_przekroj`); Fundament punktowy – średnica (`fundament_srednica`); Fundament punktowy – wysokość (`fundament_wysokosc`); Rozstaw fundamentów – największy (osiowo) (`fundamenty_rozstaw_max`); Obciążenie użytkowe (`obciazenie_uzytkowe`); Obciążenie stałe (deski, izolacja) (`obciazenie_stale`); Klasa drewna konstrukcyjnego (`drewno_klasa`); Ugięcie zalecane L / (`ugiecie_zalecane`); Ugięcie dopuszczalne L / (`ugiecie_minimalne`); Dostępne przekroje legarów i podciągów (`przekroje_katalog`) |
| Okna i drzwi – stolarka i luzy | 11 | Kawałek bala przy otworze – najkrótszy (`min_kawalek_przy_otworze`); Luz boczny stolarki (z każdej strony) (`luz_boczny`); Osiadanie ścian – podpowiedź luzu górnego (`osiadanie_scian`); Luz górny – najmniejszy w podpowiedzi (`luz_gorny_min`); Najcieńszy pasek bala nad / pod otworem (`min_pasek_przy_otworze`); Nowe okno – szerokość stolarki (`okno_szerokosc`); Nowe okno – wysokość stolarki (`okno_wysokosc`); Nowe okno – spód okna (od podwaliny) (`okno_parapet`); Nowe drzwi – szerokość stolarki (`drzwi_szerokosc`); Nowe drzwi – wysokość stolarki (`drzwi_wysokosc`); Nowy otwór – odległość od narożnika (`nowy_otwor_od`) |
| Rozpoznanie rysunku i waga | 3 | Linia węgła – najdłuższa (`kontrfor_max_linia`); Tolerancja rysunku obrysu (`tolerancja_rysunku`); Gęstość drewna (waga) (`gestosc`) |
| Zestawienie materiałów | 5 | Zapas na docinki desek i płyt (`material_zapas`); Taśma między wieńcami – pasy na styk (`tasma_pasy`); Kotwy podwalin – rozstaw (`kotwy_podwalin_rozstaw`); Impregnat – wydajność (`impregnat_wydajnosc`); Impregnat – liczba warstw (`impregnat_warstwy`) |

## 5. Pełna tabela – wszystkie pola w kolejności okna

| # | Sekcja dziś | Pole | Klucz | Poziom |
|---|---|---|---|---|
| 1 | Przekrój bala i zamek | Przekrój bala | `preset` | Typ domu |
| 2 | Przekrój bala i zamek | Kierunek podcięć zamka | `zamek_odbicie` | Standard warsztatu |
| 3 | Przekrój bala i zamek | Profil bala w modelu | `profil_bala` | Standard warsztatu |
| 4 | Przekrój bala i zamek | Pióra – liczba | `pioro_liczba` | Standard warsztatu |
| 5 | Przekrój bala i zamek | Pióro – szerokość | `pioro_szerokosc` | Standard warsztatu |
| 6 | Przekrój bala i zamek | Pióra – rozstaw osi (dwa pióra) | `pioro_rozstaw` | Standard warsztatu |
| 7 | Przekrój bala i zamek | Wpust – luz (szerszy i głębszy od pióra) | `wpust_luz` | Standard warsztatu |
| 8 | Ściany | Liczba wieńców (ściany okapowe) | `liczba_wiencow` | Ten dom |
| 9 | Ściany | Ostatek za licem | `ostatek` | Typ domu |
| 10 | Ściany | Kalenica (półbal na ścianach wzdłuż kalenicy) | `kalenica` | Ten dom |
| 11 | Ściany | Strop nad parterem (zamknięta góra) | `strop` | Typ domu |
| 12 | Ściany | Działowa pod stropem / antresolą – góra | `dzialowa_nizsza_wysokosc` | Ten dom |
| 13 | Ściany | Dopełnienie zamka nad niższą działową – do wnętrza | `dopelnienie_wewn` | Standard warsztatu |
| 14 | Długości bali i łączenia | Maksymalna długość bala | `max_dlugosc` | Standard warsztatu |
| 15 | Długości bali i łączenia | Najkrótszy kawałek bala | `min_odcinek` | Standard warsztatu |
| 16 | Długości bali i łączenia | Łączenie przy działowej | `styk_na_dzialowej` | Standard warsztatu |
| 17 | Długości bali i łączenia | Łączenie bali na długości | `styk_uklad` | Standard warsztatu |
| 18 | Długości bali i łączenia | Łączenie wieńców szczytu | `szczyt_styk` | Standard warsztatu |
| 19 | Długości bali i łączenia | Mijanka styków w sąsiednich wieńcach | `mijanka` | Standard warsztatu |
| 20 | Długości bali i łączenia | Szczelina na styku | `szczelina_styku` | Standard warsztatu |
| 21 | Długości bali i łączenia | Styk od krawędzi otworu – najmniej | `styk_odstep_od_otworu` | Standard warsztatu |
| 22 | Węgły (kontrfory) 244 – wzmocnienia ścian | Najdłuższe światło ściany bez węgła | `wegly_max_swiatlo` | Standard warsztatu |
| 23 | Węgły (kontrfory) 244 – wzmocnienia ścian | To samo dla ścian wysokich | `wegly_max_swiatlo_wysokie` | Standard warsztatu |
| 24 | Węgły (kontrfory) 244 – wzmocnienia ścian | Ściana wysoka od wysokości | `wegly_prog_wysokosci` | Standard warsztatu |
| 25 | Węgły (kontrfory) 244 – wzmocnienia ścian | Rozmieszczenie nowych węgłów | `wegly_rozmieszczenie` | Standard warsztatu |
| 26 | Węgły (kontrfory) 244 – wzmocnienia ścian | Odstęp węgła od narożnika | `wegly_odstep_od_naroznika` | Standard warsztatu |
| 27 | Węgły (kontrfory) 244 – wzmocnienia ścian | Węgieł na środku ściany – automatycznie | `wegly_srodek` | Typ domu |
| 28 | Węgły (kontrfory) 244 – wzmocnienia ścian | Węgieł na środku – od długości ściany | `wegly_srodek_min` | Standard warsztatu |
| 29 | Węgły (kontrfory) 244 – wzmocnienia ścian | Węgieł – wypust wewnątrz domu | `wegiel_wypust_wewn` | Standard warsztatu |
| 30 | Węgły (kontrfory) 244 – wzmocnienia ścian | Węgieł – wypust na zewnątrz | `wegiel_wypust_zewn` | Standard warsztatu |
| 31 | Węgły (kontrfory) 244 – wzmocnienia ścian | Słupki z kontrfor (węgły) pod płatwiami | `wegly_pod_platwiami` | Typ domu |
| 32 | Węgły (kontrfory) 244 – wzmocnienia ścian | Słupki pod płatwiami – pod którymi | `wegly_pod_platwiami_ktore` | Typ domu |
| 33 | Węgły (kontrfory) 244 – wzmocnienia ścian | Węgieł na wolnym końcu niepełnej ściany | `wegly_wolny_koniec` | Standard warsztatu |
| 34 | Węgły (kontrfory) 244 – wzmocnienia ścian | Węgieł na wolnym końcu – od długości wolnego odcinka | `wegly_wolny_koniec_min` | Standard warsztatu |
| 35 | Węgły (kontrfory) 244 – wzmocnienia ścian | Węgły także na ścianach działowych | `wegly_na_dzialowych` | Standard warsztatu |
| 36 | Węgły (kontrfory) 244 – wzmocnienia ścian | Odstęp węgła od innego skrzyżowania | `min_odstep_skrzyzowan` | Standard warsztatu |
| 37 | Węgły (kontrfory) 244 – wzmocnienia ścian | Odstęp węgła od krawędzi otworu | `odstep_od_otworu` | Standard warsztatu |
| 38 | Szczyty i dach | Szczyty z bali | `szczyty` | Typ domu |
| 39 | Szczyty i dach | Szczyty także na działowych szczytowych | `szczyty_na_dzialowych` | Typ domu |
| 40 | Szczyty i dach | Działowe wzdłuż kalenicy – do dachu | `dzialowa_wzdluz_do_dachu` | Typ domu |
| 41 | Szczyty i dach | Dach | `dach_rodzaj` | Typ domu |
| 42 | Szczyty i dach | Jednospadowy – spadek w stronę | `dach_spadek` | Ten dom |
| 43 | Szczyty i dach | Jednospadowy – okap za ścianą wysoką | `dach_okap_wysoki` | Ten dom |
| 44 | Szczyty i dach | Jednospadowy – najcieńszy górny bal ściany wysokiej | `jednospad_min_pasek` | Standard warsztatu |
| 45 | Szczyty i dach | Kąt dachu | `dach_kat` | Ten dom |
| 46 | Szczyty i dach | Układ dachu | `dach_uklad` | Typ domu |
| 47 | Szczyty i dach | Krokwie i poszycie – kto je buduje | `dach_wiezba` | Typ domu |
| 48 | Szczyty i dach | Wierzch płatwi nad ścianą okapową (przy licu wewn.) | `dach_podniesienie` | Standard warsztatu |
| 49 | Szczyty i dach | Krokwie przy ścianie szczytowej | `krokwie_przy_szczycie` | Typ domu |
| 50 | Szczyty i dach | Przekrój krokwi – dobór | `krokwie_dobor` | Standard warsztatu |
| 51 | Szczyty i dach | Krokiew (szer. × wys.) | `krokiew_przekroj` | Typ domu |
| 52 | Szczyty i dach | Dostępne przekroje krokwi | `krokwie_katalog` | Standard warsztatu |
| 53 | Szczyty i dach | Rozstaw krokwi – największy | `krokwie_rozstaw` | Standard warsztatu |
| 54 | Szczyty i dach | Przekrój płatwi – dobór | `platwie_dobor` | Standard warsztatu |
| 55 | Szczyty i dach | Dostępne przekroje płatwi | `platwie_katalog` | Standard warsztatu |
| 56 | Szczyty i dach | Śnieg – obciążenie gruntu | `dach_snieg` | Standard warsztatu |
| 57 | Szczyty i dach | Ciężar pokrycia z poszyciem | `dach_ciezar` | Standard warsztatu |
| 58 | Szczyty i dach | Ugięcie płatwi dopuszczalne L / | `dach_ugiecie` | Standard warsztatu |
| 59 | Szczyty i dach | Jeden przekrój wszystkich płatwi | `platwie_jeden_przekroj` | Typ domu |
| 60 | Szczyty i dach | Płatew (pośrednia) | `platwa_przekroj` | Typ domu |
| 61 | Szczyty i dach | Płatew kalenicowa | `platwa_kalenicowa_przekroj` | Typ domu |
| 62 | Szczyty i dach | Największy rozstaw płatwi (w poziomie) | `platwie_rozstaw_max` | Standard warsztatu |
| 63 | Szczyty i dach | Oparcie dachu przy ścianie okapowej | `platwa_na_scianie` | Typ domu |
| 64 | Szczyty i dach | Płatew ścienna – położenie | `platwa_scienna_polozenie` | Standard warsztatu |
| 65 | Szczyty i dach | Płatew ścienna | `platwa_scienna_przekroj` | Typ domu |
| 66 | Szczyty i dach | Płatwie oparte na pełnym balu | `platwie_na_wiencach` | Standard warsztatu |
| 67 | Szczyty i dach | Dopasowanie płatwi – największe obniżenie dachu | `dach_obnizenie_max` | Standard warsztatu |
| 68 | Szczyty i dach | Dopasowanie płatwi – największe przesunięcie pośredniej | `platwie_przesuniecie_max` | Standard warsztatu |
| 69 | Szczyty i dach | Zamki w płatwiach (wręby w ścianach) | `platwie_zamki` | Standard warsztatu |
| 70 | Szczyty i dach | Zamek płatwi – wrąb z każdego boku | `platwa_zamek_bok` | Standard warsztatu |
| 71 | Szczyty i dach | Zamek płatwi – wrąb od spodu | `platwa_zamek_dol` | Standard warsztatu |
| 72 | Szczyty i dach | Zamek płatwi – luz wzdłuż (z każdej strony ściany) | `platwa_zamek_luz` | Standard warsztatu |
| 73 | Szczyty i dach | Luz w gnieździe płatwi (każda strona) | `gniazdo_luz` | Standard warsztatu |
| 74 | Szczyty i dach | Wierzch płatwi ścięty do płaszczyzny dachu | `platwie_sciecie` | Standard warsztatu |
| 75 | Szczyty i dach | Najniższy kawałek bala przy skosie | `szczyt_min_wysokosc` | Standard warsztatu |
| 76 | Szczyty i dach | Drewno w zamku przy skosie dachu – najmniej | `zamek_min_drewno` | Standard warsztatu |
| 77 | Szczyty i dach | Najkrótszy kawałek bala przy skosie i gnieździe | `szczyt_min_kawalek` | Standard warsztatu |
| 78 | Szczyty i dach | Belki dachu w modelu (płatwie, krokwie) | `dach_elementy` | Standard warsztatu |
| 79 | Szczyty i dach | Okap – wysunięcie krokwi za ścianę | `dach_okap` | Ten dom |
| 80 | Szczyty i dach | Wysunięcie płatwi za szczyt | `dach_okap_szczyt` | Ten dom |
| 81 | Szczyty i dach | Górne wieńce ścian okapowych wypuszczone za szczyt | `okap_wience_wypust` | Standard warsztatu |
| 82 | Szczyty i dach | Węgły pod okapem – górne bale do nawisu okapu | `wegly_wypust_okap` | Standard warsztatu |
| 83 | Szczyty i dach | Węgły pod okapem – liczba górnych bali | `wegly_okap_wience` | Standard warsztatu |
| 84 | Poszycie dachu (aplikacja do dachów) | Podbitka – boazeria widoczna od spodu | `podbitka` | Typ domu |
| 85 | Poszycie dachu (aplikacja do dachów) | Podbitka – grubość | `podbitka_grubosc` | Standard warsztatu |
| 86 | Poszycie dachu (aplikacja do dachów) | Podbitka – szerokość deski (krycie) | `podbitka_krycie` | Standard warsztatu |
| 87 | Poszycie dachu (aplikacja do dachów) | Podbitka – długość handlowa | `podbitka_dlugosc` | Standard warsztatu |
| 88 | Poszycie dachu (aplikacja do dachów) | Nadbitka – pierwsza warstwa poszycia (aplikacja do dachów) | `poszycie_nadbitka` | Typ domu |
| 89 | Poszycie dachu (aplikacja do dachów) | Nadbitka – grubość | `nadbitka_grubosc` | Standard warsztatu |
| 90 | Poszycie dachu (aplikacja do dachów) | Nadbitka – szerokość krycia | `nadbitka_krycie` | Standard warsztatu |
| 91 | Poszycie dachu (aplikacja do dachów) | Nadbitka – długość handlowa | `nadbitka_dlugosc` | Standard warsztatu |
| 92 | Poszycie dachu (aplikacja do dachów) | Deskowanie pełne | `poszycie_deski` | Typ domu |
| 93 | Poszycie dachu (aplikacja do dachów) | Deskowanie – grubość deski | `deski_grubosc` | Standard warsztatu |
| 94 | Poszycie dachu (aplikacja do dachów) | Deskowanie – szerokość deski | `deski_szerokosc` | Standard warsztatu |
| 95 | Poszycie dachu (aplikacja do dachów) | Deskowanie – szczelina między deskami | `deski_szczelina` | Standard warsztatu |
| 96 | Poszycie dachu (aplikacja do dachów) | Deskowanie – długość handlowa | `deski_dlugosc` | Standard warsztatu |
| 97 | Poszycie dachu (aplikacja do dachów) | Płyty OSB | `poszycie_osb` | Typ domu |
| 98 | Poszycie dachu (aplikacja do dachów) | OSB – grubość | `osb_grubosc` | Standard warsztatu |
| 99 | Poszycie dachu (aplikacja do dachów) | OSB – długość płyty (wzdłuż okapu) | `osb_dlugosc` | Standard warsztatu |
| 100 | Poszycie dachu (aplikacja do dachów) | OSB – szerokość płyty | `osb_szerokosc` | Standard warsztatu |
| 101 | Poszycie dachu (aplikacja do dachów) | OSB – szczelina przy każdej krawędzi | `osb_szczelina` | Standard warsztatu |
| 102 | Taras | Taras przed ścianą szczytową | `taras` | Typ domu |
| 103 | Taras | Taras – po stronie | `taras_strona` | Ten dom |
| 104 | Taras | Taras – głębokość | `taras_glebokosc` | Ten dom |
| 105 | Taras | Podciąg – górne wieńce ścian nad tarasem | `taras_wience_gorne` | Typ domu |
| 106 | Taras | Ostatek dolnych bali ścian bocznych przy tarasie | `taras_ostatek` | Standard warsztatu |
| 107 | Taras | Słup tarasu (wzdłuż ściany × w poprzek) | `taras_slup_przekroj` | Typ domu |
| 108 | Taras | Słupy – największy rozstaw (osiowo) | `taras_slupy_rozstaw_max` | Standard warsztatu |
| 109 | Taras | Słup frontu w osi kalenicy | `taras_slup_w_osi` | Standard warsztatu |
| 110 | Taras | Słup w osi – słup wejścia bliżej osi niż tyle staje w osi | `taras_slup_os_dociag` | Standard warsztatu |
| 111 | Taras | Słup – zamek górny (wysokość obok bala) | `taras_slup_zamek_gora` | Standard warsztatu |
| 112 | Taras | Słup – zamek dolny (obok podwaliny) | `taras_slup_zamek_dol` | Standard warsztatu |
| 113 | Taras | Słupy krótsze o osiadanie ścian | `slup_osiadanie` | Standard warsztatu |
| 114 | Taras | Słup – regulacja w głowicy | `slup_regulacja` | Standard warsztatu |
| 115 | Taras | Śruba regulacyjna – wysokość po skręceniu | `slup_regulacja_wysokosc` | Standard warsztatu |
| 116 | Taras | Szczyt nad tarasem | `taras_szczyt` | Typ domu |
| 117 | Taras | Szczyt pusty – bale spinające | `taras_szczyt_bale` | Typ domu |
| 118 | Taras | Szczyt pusty – wiązar (trójkąt) z przekroju | `taras_wieniec` | Typ domu |
| 119 | Taras | Wiązar – przekrój (grub. × wys.) | `taras_wieniec_przekroj` | Typ domu |
| 120 | Taras | Wiązar – rodzaj | `taras_wiazar` | Typ domu |
| 121 | Taras | Wiązar – gniazdo płatwi, najmniejsza głębokość | `taras_wiazar_gniazdo` | Standard warsztatu |
| 122 | Taras | Wiązar – na czym stoi | `taras_wiazar_podparcie` | Typ domu |
| 123 | Taras | Wiązar – słupek i zastrzały z przekroju | `taras_wiazar_przekroje` | Typ domu |
| 124 | Taras | Wiązar – szerokość słupka | `taras_wiazar_slupek` | Standard warsztatu |
| 125 | Taras | Wiązar – szerokość zastrzału | `taras_wiazar_zastrzal` | Standard warsztatu |
| 126 | Taras | Wiązar – kąt zastrzałów od poziomu | `taras_wiazar_zastrzal_kat` | Standard warsztatu |
| 127 | Taras | Łączenie bali frontu i szczytu nad tarasem | `taras_styk` | Standard warsztatu |
| 128 | Taras | Zamek płatwi w szczycie nad tarasem | `taras_platwa_zamek` | Standard warsztatu |
| 129 | Taras | Wejście na taras od frontu | `taras_wejscie` | Ten dom |
| 130 | Taras | Wejście – szerokość w świetle słupów | `taras_wejscie_szerokosc` | Ten dom |
| 131 | Taras | Balustrada – z czego | `taras_balustrada_rodzaj` | Typ domu |
| 132 | Taras | Balustrada z wieńców – wysokość (najwyżej) | `taras_balustrada_wysokosc` | Typ domu |
| 133 | Taras | Balustrada z wieńców – zakładka w narożnikach frontu | `taras_zakladka` | Standard warsztatu |
| 134 | Taras | Zakładka – wysunięcie belki | `taras_zakladka_wypust` | Standard warsztatu |
| 135 | Taras | Balustrada – liczba bali | `taras_balustrada_bale` | Typ domu |
| 136 | Taras | Balustrada – długość przekładki | `taras_przekladka` | Standard warsztatu |
| 137 | Taras | Balustrada – największy prześwit między przekładkami | `taras_przekladka_odstep` | Standard warsztatu |
| 138 | Zadaszenie – rodzaj i wymiary | Zadaszenie przy ścianie okapowej (boczne / tylne) | `zadaszenie` | Typ domu |
| 139 | Zadaszenie – rodzaj i wymiary | Zadaszenie – przy ścianie okapowej | `zadaszenie_strona` | Ten dom |
| 140 | Zadaszenie – rodzaj i wymiary | Zadaszenie – szerokość | `zadaszenie_szerokosc` | Ten dom |
| 141 | Zadaszenie – rodzaj i wymiary | Zadaszenie – kąt (mniejszy niż kąt dachu) | `zadaszenie_kat` | Ten dom |
| 142 | Zadaszenie – rodzaj i wymiary | Zadaszenie – okap za podporą (najmniej) | `zadaszenie_okap` | Standard warsztatu |
| 143 | Zadaszenie – rodzaj i wymiary | Słupy zadaszenia – największy rozstaw (osiowo) | `zadaszenie_slupy_rozstaw` | Standard warsztatu |
| 144 | Zadaszenie – rodzaj i wymiary | Przybudówka – podłoga | `zadaszenie_podloga` | Typ domu |
| 145 | Zadaszenie – przekroje (dobór) | Przekroje zadaszenia – dobór | `zadaszenie_dobor` | Standard warsztatu |
| 146 | Zadaszenie – przekroje (dobór) | Dostępne przekroje belek zadaszenia | `zadaszenie_katalog` | Standard warsztatu |
| 147 | Zadaszenie – przekroje (dobór) | Dostępne przekroje słupów zadaszenia | `zadaszenie_slupy_katalog` | Standard warsztatu |
| 148 | Zadaszenie – przekroje (dobór) | Płatew zadaszenia (szer. × wys.) | `zadaszenie_platwa_przekroj` | Typ domu |
| 149 | Zadaszenie – przekroje (dobór) | Słup zadaszenia (wzdłuż ściany × w poprzek) | `zadaszenie_slup_przekroj` | Typ domu |
| 150 | Zadaszenie – przekroje (dobór) | Belka poprzeczna na słupie (szer. × wys.) | `zadaszenie_belka_przekroj` | Typ domu |
| 151 | Podłoga i fundamenty | Podłoga (podwaliny, legary, podciągi) | `podloga` | Typ domu |
| 152 | Podłoga i fundamenty | Podwalina pod ścianami (szer. × wys.) | `podwalina_przekroj` | Typ domu |
| 153 | Podłoga i fundamenty | Podwaliny w narożnikach | `podwalina_laczenie` | Standard warsztatu |
| 154 | Podłoga i fundamenty | Podwaliny także pod działowymi | `podwaliny_pod_dzialowymi` | Typ domu |
| 155 | Podłoga i fundamenty | Legary wzdłuż | `legary_kierunek` | Ten dom |
| 156 | Podłoga i fundamenty | Rozstaw legarów (osiowo) | `legary_rozstaw` | Standard warsztatu |
| 157 | Podłoga i fundamenty | Izolacja między legarami | `izolacja_podlogi` | Typ domu |
| 158 | Podłoga i fundamenty | Dobór przekroju legara | `legary_dobor` | Standard warsztatu |
| 159 | Podłoga i fundamenty | Legar – przekrój do sprawdzenia | `legar_przekroj` | Typ domu |
| 160 | Podłoga i fundamenty | Podciągi pod legarami | `podciagi` | Typ domu |
| 161 | Podłoga i fundamenty | Rozstaw podciągów pod legarami – największy | `podpory_rozstaw_max` | Standard warsztatu |
| 162 | Podłoga i fundamenty | Podciąg pod legarami (podpora pośrednia) | `podpora_przekroj` | Typ domu |
| 163 | Podłoga i fundamenty | Podciąg – poziom | `podciag_poziom` | Standard warsztatu |
| 164 | Podłoga i fundamenty | Fundamenty punktowe | `fundamenty` | Typ domu |
| 165 | Podłoga i fundamenty | Fundament punktowy – kształt w rzucie | `fundament_ksztalt` | Standard warsztatu |
| 166 | Podłoga i fundamenty | Fundament punktowy – wymiary w rzucie | `fundament_przekroj` | Standard warsztatu |
| 167 | Podłoga i fundamenty | Fundament punktowy – średnica | `fundament_srednica` | Standard warsztatu |
| 168 | Podłoga i fundamenty | Fundament punktowy – wysokość | `fundament_wysokosc` | Standard warsztatu |
| 169 | Podłoga i fundamenty | Rozstaw fundamentów – największy (osiowo) | `fundamenty_rozstaw_max` | Standard warsztatu |
| 170 | Podłoga i fundamenty | Obciążenie użytkowe | `obciazenie_uzytkowe` | Standard warsztatu |
| 171 | Podłoga i fundamenty | Obciążenie stałe (deski, izolacja) | `obciazenie_stale` | Standard warsztatu |
| 172 | Podłoga i fundamenty | Klasa drewna konstrukcyjnego | `drewno_klasa` | Standard warsztatu |
| 173 | Podłoga i fundamenty | Ugięcie zalecane L / | `ugiecie_zalecane` | Standard warsztatu |
| 174 | Podłoga i fundamenty | Ugięcie dopuszczalne L / | `ugiecie_minimalne` | Standard warsztatu |
| 175 | Podłoga i fundamenty | Dostępne przekroje legarów i podciągów | `przekroje_katalog` | Standard warsztatu |
| 176 | Okna i drzwi – stolarka i luzy | Kawałek bala przy otworze – najkrótszy | `min_kawalek_przy_otworze` | Standard warsztatu |
| 177 | Okna i drzwi – stolarka i luzy | Luz boczny stolarki (z każdej strony) | `luz_boczny` | Standard warsztatu |
| 178 | Okna i drzwi – stolarka i luzy | Osiadanie ścian – podpowiedź luzu górnego | `osiadanie_scian` | Standard warsztatu |
| 179 | Okna i drzwi – stolarka i luzy | Luz górny – najmniejszy w podpowiedzi | `luz_gorny_min` | Standard warsztatu |
| 180 | Okna i drzwi – stolarka i luzy | Najcieńszy pasek bala nad / pod otworem | `min_pasek_przy_otworze` | Standard warsztatu |
| 181 | Okna i drzwi – stolarka i luzy | Nowe okno – szerokość stolarki | `okno_szerokosc` | Standard warsztatu |
| 182 | Okna i drzwi – stolarka i luzy | Nowe okno – wysokość stolarki | `okno_wysokosc` | Standard warsztatu |
| 183 | Okna i drzwi – stolarka i luzy | Nowe okno – spód okna (od podwaliny) | `okno_parapet` | Standard warsztatu |
| 184 | Okna i drzwi – stolarka i luzy | Nowe drzwi – szerokość stolarki | `drzwi_szerokosc` | Standard warsztatu |
| 185 | Okna i drzwi – stolarka i luzy | Nowe drzwi – wysokość stolarki | `drzwi_wysokosc` | Standard warsztatu |
| 186 | Okna i drzwi – stolarka i luzy | Nowy otwór – odległość od narożnika | `nowy_otwor_od` | Standard warsztatu |
| 187 | Rozpoznanie rysunku i waga | Linia węgła – najdłuższa | `kontrfor_max_linia` | Standard warsztatu |
| 188 | Rozpoznanie rysunku i waga | Tolerancja rysunku obrysu | `tolerancja_rysunku` | Standard warsztatu |
| 189 | Rozpoznanie rysunku i waga | Gęstość drewna (waga) | `gestosc` | Standard warsztatu |
| 190 | Zestawienie materiałów | Zapas na docinki desek i płyt | `material_zapas` | Standard warsztatu |
| 191 | Zestawienie materiałów | Taśma między wieńcami – pasy na styk | `tasma_pasy` | Standard warsztatu |
| 192 | Zestawienie materiałów | Kotwy podwalin – rozstaw | `kotwy_podwalin_rozstaw` | Standard warsztatu |
| 193 | Zestawienie materiałów | Impregnat – wydajność | `impregnat_wydajnosc` | Standard warsztatu |
| 194 | Zestawienie materiałów | Impregnat – liczba warstw | `impregnat_warstwy` | Standard warsztatu |
