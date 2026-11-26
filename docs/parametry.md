# Parametry generatora (wszystkie ustawiane w oknie)

Plik generowany z `rdzen/parametry_lista.rb` (`ruby testy/lista_parametrow.rb`) – nie edytować ręcznie.
Ostatnio użyte wartości i własne szablony zapisują się na komputerze (`sketchup/ustawienia.rb`).

## Przekrój bala i zamek

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `preset` | Przekrój bala | 44x146 | `44x146` – Bal 44 × 146 (krycie 139, pióro 7) | Preset z kompletem wymiarów zamka; wymiary można zmienić poniżej. |
| `zamek_odbicie` | Kierunek podcięć zamka | rysunek | `rysunek` – jak na rysunku warsztatowym; `lustro` – lustrzane odbicie | Labirynt podcięć – oba warianty bez kolizji; zmiana odwraca bale poprzeczne licem. |
| `profil_bala` | Profil bala w modelu | prosty | `prosty` – bal prosty (lekki model, jak w listach); `pelny` – pełny profil – pióro i wpust (do wizualizacji) | Pełny profil: pióra na wierzchu, wpust od spodu (pierwszy wieniec bez wpustu). Zamki, pozycje i listy bez zmian. |
| `pioro_liczba` | Pióra – liczba | 2 | `1` – jedno pióro w osi bala; `2` – dwa pióra (podwójne pióro-wpust) | Wysokość pióra – „Pióro” w wymiarach zamka poniżej. |
| `pioro_szerokosc` | Pióro – szerokość | 8 mm | 2 … 30 |  |
| `pioro_rozstaw` | Pióra – rozstaw osi (dwa pióra) | 20 mm | 4 … 36 |  |
| `wpust_luz` | Wpust – luz (szerszy i głębszy od pióra) | 1 mm | 0 … 5 |  |

## Ściany

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `liczba_wiencow` | Liczba wieńców (ściany okapowe) | 16 szt. | 3 … 60 | Pełne wieńce ścian wzdłuż kalenicy; szczytowe mają o jeden więcej (pierwszy bal szczytu). |
| `ostatek` | Ostatek za licem | 100 mm | 40 … 600 | Wypust bala za licem ściany poprzecznej (projekty: 100, przy tarasie 200). |
| `kalenica` | Kalenica (półbal na ścianach wzdłuż kalenicy) | dluzszy | `dluzszy` – wzdłuż dłuższego boku; `krotszy` – wzdłuż krótszego boku; `x` – wzdłuż osi X obrysu; `y` – wzdłuż osi Y obrysu | Dach jednospadowy – kierunek okapów: ściana niska i wysoka biegną wzdłuż „kalenicy”. |
| `strop` | Strop nad parterem (zamknięta góra) | nie | `nie` – nie – działowe do pełnej wysokości; `tak` – tak – działowe kończą się pod stropem | Niższa działowa tylko pod stropem, antresolą lub półką. Antresolę albo półkę nad jedną działową ustawisz w widoku ściany. |
| `dzialowa_nizsza_wysokosc` | Działowa pod stropem / antresolą – góra | 2500 mm | 500 … 8000 | Spód stropu, antresoli albo półki; działowa kończy się pełnym wieńcem nie wyżej (typ 200: 2432, typ 300: 2780). |
| `dopelnienie_wewn` | Dopełnienie zamka nad niższą działową – do wnętrza | 100 mm | 40 … 600 | Odcinki nad działową przy ścianach, które idą wyżej: ostatek + grubość + tyle (typ 200: 244, typ 300 przy ostatku 200: 344). |

## Długości bali i łączenia

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `max_dlugosc` | Maksymalna długość bala | 5100 mm | 1000 … 13000 | Najdłuższy bal od producenta (zwykle ok. 5000–5100). |
| `min_odcinek` | Najkrótszy kawałek bala | 200 mm | 50 … 2000 | Krótszy kawałek – ostrzeżenie. |
| `styk_na_dzialowej` | Łączenie przy działowej | wspolny | `wspolny` – wszystkie wieńce w zamku działowej – bez węgłów i drugiego rzędu; `mijanka` – jak przy węgłach – na przemian, z mijanką | Działowa przechodzi przez ścianę w zamku – styk w jej osi trzymają bale działowej nad i pod nim, więc wszystkie wieńce łączą się w tym jednym miejscu. Działowa musi sięgać prawie do góry ściany. |
| `styk_uklad` | Łączenie bali na długości | na_przemian | `na_przemian` – na przemian w kolejnych węgłach / działowych (typ 300); `para` – para węgłów w odstępie mijanki, styk w osi zamka (typ 100); `jeden_wegiel` – jeden węgieł, styki ± połowa mijanki |  |
| `szczyt_styk` | Łączenie wieńców szczytu | styk | `styk` – na styk, na przemian z mijanką – bez węgłów pod styki w szczycie; `wegly` – w zamkach węgłów – węgły pod styki do dachu | Wieńce szczytu dłuższe niż maksymalny bal: na styk – czoła bali stykają się bez zamka, w sąsiednim wieńcu o mijankę („Mijanka styków”, nie mniej niż 300) dalej; ściana pod szczytem łączy się jak każda inna, a węgły pod jej styki kończą się na wysokości ściany. Szczyt płaski (ściana wysoka dachu jednospadowego) – zawsze w zamkach węgłów. |
| `mijanka` | Mijanka styków w sąsiednich wieńcach | 400 mm | 300 … 3000 | Najmniejszy odstęp styków w sąsiednich wieńcach – nie mniej niż 300. |
| `szczelina_styku` | Szczelina na styku | 0 mm | 0 … 30 |  |
| `styk_odstep_od_otworu` | Styk od krawędzi otworu – najmniej | 400 mm | 0 … 2000 | Kawałek bala między stykiem a otworem nie krótszy niż tyle. |

## Węgły (kontrfory) 244 – wzmocnienia ścian

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `wegly_max_swiatlo` | Najdłuższe światło ściany bez węgła | 4800 mm | 1500 … 10000 | Między licami ścian podpierających (narożnik, działowa, węgieł), np. 4756 bez węgła. |
| `wegly_max_swiatlo_wysokie` | To samo dla ścian wysokich | 3700 mm | 1500 … 10000 | Dom 1,5 kondygnacji (typ 300): węgieł już na ścianie 4 m. |
| `wegly_prog_wysokosci` | Ściana wysoka od wysokości | 3000 mm | 1500 … 8000 | Wysokość ściany okapowej bez szczytu (typ 200: 2966 – bez węgła, typ 300: 3580 – z węgłem). |
| `wegly_rozmieszczenie` | Rozmieszczenie nowych węgłów | rowno | `rowno` – równo na długości ściany; `od_naroznikow` – od narożników o zadany odstęp; `tylko_narysowane` – tylko narysowane (generator tylko ostrzega) |  |
| `wegly_odstep_od_naroznika` | Odstęp węgła od narożnika | 800 mm | 300 … 3000 | Dla rozmieszczenia „od narożników”. |
| `wegly_srodek` | Węgieł na środku ściany – automatycznie | nie | `nie` – nie; `zewnetrzne` – na ścianach zewnętrznych; `wszystkie` – na wszystkich ścianach | Węgieł w osi ściany, gdy ściana nie jest krótsza niż podana niżej (w miejscu skrzyżowania albo otworu – obok, do pół metra). Pojedyncze węgły dodasz w tabeli „Węgły”, jak okna. |
| `wegly_srodek_min` | Węgieł na środku – od długości ściany | 4000 mm | 1000 … 20000 |  |
| `wegiel_wypust_wewn` | Węgieł – wypust wewnątrz domu | 100 mm | 40 … 1500 | Długość słupka węgła za licem wewnętrznym ściany (przy działowej – z obu stron). W tabeli węgłów można podać inną dla jednego węgła. |
| `wegiel_wypust_zewn` | Węgieł – wypust na zewnątrz | 100 mm | 40 … 1500 | Za licem zewnętrznym ściany, np. 200 przy węgle niesymetrycznym (wewnątrz 100). Tyle samo wychodzą na zewnątrz końce działowych przechodzących przez ścianę zewnętrzną. |
| `wegly_pod_platwiami` | Słupki z kontrfor (węgły) pod płatwiami | zewnetrzne | `zewnetrzne` – tak – na szczytach zewnętrznych (i ścianie domu przy tarasie); `wszystkie` – tak – także na szczytach działowych; `nie` – nie – bez słupków pod płatwiami (małe domki) | W osi płatwi przechodzącej przez szczyt – słupek węgła do spodu płatwi (płatew na nim leży). Nie powstaje, gdy pod płatwią jest już ściana, otwór lub ściana ma węgły ręczne; węgieł, który już stoi w osi płatwi, podpiera ją. W małych domkach letniskowych zwykle zbędne – wybierz „nie” albo niżej „tylko pod kalenicową”. |
| `wegly_pod_platwiami_ktore` | Słupki pod płatwiami – pod którymi | wszystkie | `wszystkie` – pod każdą płatwią; `kalenicowa` – tylko pod płatwią kalenicową | Tylko pod kalenicową: jeden słupek w osi szczytu podpiera płatew kalenicową, płatwie pośrednie leżą w gniazdach szczytu. |
| `wegly_wolny_koniec` | Węgieł na wolnym końcu niepełnej ściany | tak | `tak` – tak; `nie` – nie | Działowa, która nie dochodzi do innej ściany: węgieł przy jej końcu (bale kończą się ostatkiem za węgłem). |
| `wegly_wolny_koniec_min` | Węgieł na wolnym końcu – od długości wolnego odcinka | 1000 mm | 0 … 10000 | Od ostatniego skrzyżowania do wolnego końca ściany; krótszy wolny odcinek – bez węgła. |
| `wegly_na_dzialowych` | Węgły także na ścianach działowych | tak | `tak` – tak; `nie` – nie |  |
| `min_odstep_skrzyzowan` | Odstęp węgła od innego skrzyżowania | 300 mm | 150 … 3000 |  |
| `odstep_od_otworu` | Odstęp węgła od krawędzi otworu | 150 mm | 0 … 2000 |  |

## Szczyty i dach

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `szczyty` | Szczyty z bali | tak | `tak` – tak; `nie` – nie | Ściany szczytowe zewnętrzne dostają szczyt z bali ściętych pod kątem dachu. |
| `szczyty_na_dzialowych` | Szczyty także na działowych szczytowych | nie | `tak` – tak; `nie` – nie | Ściana działowa w poprzek kalenicy dochodzi do dachu (ze szczytem). |
| `dzialowa_wzdluz_do_dachu` | Działowe wzdłuż kalenicy – do dachu | tak | `tak` – tak; `nie` – nie | Działowa równoległa do kalenicy (dom prostokątny) rośnie do płaszczyzny dachu, górny bal ścięty pod dach; pod kalenicą podpiera płatew kalenicową (gniazdo na całej długości), w szczytach daje miejsce na styki. Nie – kończy się na wysokości ścian okapowych. |
| `dach_rodzaj` | Dach | dwuspadowy | `dwuspadowy` – dwuspadowy – dwa szczyty, kalenica w środku; `jednospadowy` – jednospadowy – ściana niska i wysoka, szczyty skośne | Jednospadowy – dom prostokątny. Dom w kształcie L dostaje dwa dachy dwuspadowe z koszem. Inne dachy (kopertowy, wielospadowy) zrób w aplikacji do dachów (KROK 1 z obrysu). |
| `dach_spadek` | Jednospadowy – spadek w stronę | min | `min` – dolnej albo lewej (rysunek z góry); `max` – górnej albo prawej (rysunek z góry) | Po stronie spadku ściana niska (wysokość ścian okapowych), naprzeciw – ściana wysoka, do połaci. Okapy wzdłuż „kalenicy”: wzdłuż X – spadek w dół / w górę rysunku, wzdłuż Y – w lewo / w prawo. |
| `dach_okap_wysoki` | Jednospadowy – okap za ścianą wysoką | 500 mm | 0 … 1500 | W poziomie, od lica ściany wysokiej. |
| `jednospad_min_pasek` | Jednospadowy – najcieńszy górny bal ściany wysokiej | 30 mm | 0 … 300 | Ściana wysoka sięga połaci, górny bal przycięty wzdłuż; cieńszy pasek jest pomijany. |
| `dach_kat` | Kąt dachu | 20 ° | 5 … 60 | Typ 100: 20°. |
| `dach_uklad` | Układ dachu | platwie | `platwie` – same płatwie (deski na płatwiach); `krokwie` – krokwie na płatwi ściennej i kalenicowej; `platwie_krokwie` – płatwie i krokwie |  |
| `dach_wiezba` | Krokwie i poszycie – kto je buduje | aplikacja | `aplikacja` – aplikacja do dachów (KROK 2: krokwie, poszycie, kontrola); `generator` – generator (krokwie bez kontroli, bez poszycia) | Dom prostokątny i w kształcie L (dom L – tylko aplikacja). Aplikacja do dachów (ArteMadera Roof, 3.7.0 lub nowsza) dostaje połacie na wierzchu płatwi generatora i jego płatwie jako podpory: z krokwiami – KROK 2 liczy krokwie (przęsła między płatwiami), poszycie, łaty i nośność; same płatwie – poszycie wprost na płatwiach, wzdłuż spadku, styki na płatwiach. Szczyt kończy się pod krokwiami, krokwie przy szczycie ustawia się w aplikacji. |
| `dach_podniesienie` | Wierzch płatwi nad ścianą okapową (przy licu wewn.) | 69,5 mm | -300 … 1500 | Typ 100: 69,5 = wierzch najwyższego bala ściany szczytowej. Nie dotyczy płatwi stojącej na ścianie. |
| `krokwie_przy_szczycie` | Krokwie przy ścianie szczytowej | obie_strony | `obie_strony` – z obu stron szczytu; `wewnatrz` – tylko od wewnątrz; `zewnatrz` – tylko od zewnątrz; `na_szczycie` – na szczycie (krokiew oparta na balach) | Krokwie z generatora: obok szczytu – szczyt dochodzi do wierzchu krokwi; na szczycie – szczyt kończy się pod nią. Krokwie z aplikacji do dachów – szczyt zawsze pod krokwiami. |
| `krokwie_dobor` | Przekrój krokwi – dobór | reczny | `reczny` – z wyboru – przekrój podany niżej (ze sprawdzeniem nośności); `auto` – automatycznie – najmniejszy wystarczający z listy | Jeden przekrój krokwi całego dachu – także krokwi bocznego zadaszenia. Automatycznie: generator liczy śnieg i ciężar pokrycia na krokiew (rozstaw krokwi, przęsło między płatwiami, okap jako wspornik) i bierze najlżejszy przekrój z listy. Z aplikacją do dachów – wartość na start KROKU 2 (tam pełna kontrola). |
| `krokiew_przekroj` | Krokiew (szer. × wys.) | 50x150 mm | szer. × wys. | Z aplikacją do dachów – wartość na start KROKU 2. Wynik sprawdzenia – pod sekcją. |
| `krokwie_katalog` | Dostępne przekroje krokwi | 45x145:4.2/5.4/6, 45x170:5.4/6, 45x195:4.2/5.4/6/7, 45x220:5.4/6, 45x245:5.4/6, 60x120:5/6, 60x140:5/6/7, 60x160:5/6, 60x200:5/7, 60x240:7, 80x160:4/5/6/7, 80x200:5/7/8 |  | Lista z hurtowni: „szer.×wys.:długości w metrach”, np. 45x195:4.2/5.4/6/7 – po przecinku; dobór bierze najlżejszy wystarczający. |
| `krokwie_rozstaw` | Rozstaw krokwi – największy | 900 mm | 300 … 2000 | Z aplikacją do dachów – wartość na start KROKU 2. |
| `platwie_dobor` | Przekrój płatwi – dobór | reczny | `reczny` – ręcznie – przekroje podane niżej (ze sprawdzeniem nośności); `auto` – automatycznie – najmniejszy wystarczający z listy | Automatycznie: generator liczy śnieg i ciężar pokrycia na każdą płatew (pas dachu, największe przęsło między ścianami) i bierze najlżejszy przekrój z listy, który to przenosi. Mały, wąski domek dostaje mniejsze płatwie – i mniejszy trójkąt nad tarasem (z przekroju płatwi). Wynik to podpowiedź, nie projekt konstruktora. |
| `platwie_katalog` | Dostępne przekroje płatwi | 60x100:6, 60x120:5/6, 60x140:5/6/7, 60x160:5/6, 60x200:5/7, 60x240:7, 80x160:4/5/6/7, 80x180:7, 80x200:5/7/8, 80x220:7, 100x200:7, 120x200:7, 140x200:7, 140x240:7, 160x200:7, 160x280:7 |  | Lista z hurtowni (drewno widoczne Nsi / DUO / BSH): „szer.×wys.:długości w metrach”, np. 80x200:5/7/8 – po przecinku. Dobór bierze najlżejszy wystarczający; płatew dłuższa niż najdłuższa belka z listy – uwaga w wynikach. |
| `dach_snieg` | Śnieg – obciążenie gruntu | 0,9 kN/m² | 0 … 6 | Strefy śniegowe Polski: 1 – 0,7; 2 – 0,9 (większość kraju); 3 – 1,2; 4 – 1,6; 5 (góry) – 2,0 i więcej. |
| `dach_ciezar` | Ciężar pokrycia z poszyciem | 0,4 kN/m² | 0,1 … 3 | Na metr kwadratowy połaci, bez płatwi: deski 25 mm z papą albo gontem ok. 0,25–0,35; z nadbitką i blachą ok. 0,35; dachówka ceramiczna z łatami 0,6–0,9. |
| `dach_ugiecie` | Ugięcie płatwi dopuszczalne L / | 200 | 100 … 600 | L/200: płatew o przęśle 4 m ugina się pod śniegiem najwyżej o 20 mm. Większa liczba – sztywniejszy dach. |
| `platwie_jeden_przekroj` | Jeden przekrój wszystkich płatwi | tak | `tak` – tak; `nie` – nie | Tak – ścienna, pośrednie i kalenicowa z przekroju „Płatew” (wszystkie tej samej wysokości). Nie – osobne przekroje płatwi ściennej i kalenicowej. |
| `platwa_przekroj` | Płatew (pośrednia) | 80x200 mm | szer. × wys. | Wysokość płatwi zostaje w całości po wyższej stronie; wierzch ścięty pod dach tylko od strony okapu (typ 100: 80 × 200). |
| `platwa_kalenicowa_przekroj` | Płatew kalenicowa | 80x200 mm | szer. × wys. |  |
| `platwie_rozstaw_max` | Największy rozstaw płatwi (w poziomie) | 1000 mm | 300 … 4000 | Typ 100: ok. 990. |
| `platwa_na_scianie` | Oparcie dachu przy ścianie okapowej | tak | `tak` – płatew ścienna – osobna belka przy ścianie albo na ścianie; `nie` – ściana nośna – bez płatwi, górny bal ścięty do płaszczyzny dachu | Ściana nośna: dach (krokwie albo deski) leży wprost na ścianie okapowej – jej górny bal jest ścięty pod kątem dachu na całej długości (dach jednospadowy – także ściana wysoka). |
| `platwa_scienna_polozenie` | Płatew ścienna – położenie | przy_licu | `przy_licu` – przy licu wewnętrznym, wierzchem na linii dachu (typ 100); `na_scianie` – stoi na ścianie okapowej, w osi – ścięta pod dach |  |
| `platwa_scienna_przekroj` | Płatew ścienna | 80x200 mm | szer. × wys. | Typ 100: 60 × 200. |
| `platwie_na_wiencach` | Płatwie oparte na pełnym balu | tak | `tak` – tak; `nie` – nie | Pod gniazdem płatwi nie zostaje pasek bala cieńszy niż „Najcieńszy pasek bala nad / pod otworem”: dach obniżony o kilkanaście mm (płatew ścienna i kalenicowa), płatwie pośrednie przesunięte o kilka cm – płatew leży na całym balu albo na grubszym pasku, bez przerwy pod spodem. |
| `dach_obnizenie_max` | Dopasowanie płatwi – największe obniżenie dachu | 60 mm | 0 … 139 |  |
| `platwie_przesuniecie_max` | Dopasowanie płatwi – największe przesunięcie pośredniej | 150 mm | 0 … 500 | W poziomie, w stronę okapu albo kalenicy; rozstaw płatwi zostaje nie większy niż największy. |
| `platwie_zamki` | Zamki w płatwiach (wręby w ścianach) | tak | `tak` – tak; `nie` – nie | Płatew w każdej ścianie, przez którą przechodzi (szczyt, działowa, węgieł), zwężona z boków i podcięta od spodu – barki po obu stronach ściany trzymają szczyt na miejscu. |
| `platwa_zamek_bok` | Zamek płatwi – wrąb z każdego boku | 5 mm | 0 … 30 |  |
| `platwa_zamek_dol` | Zamek płatwi – wrąb od spodu | 8 mm | 0 … 40 | Zalecane 5–10 mm. |
| `platwa_zamek_luz` | Zamek płatwi – luz wzdłuż (z każdej strony ściany) | 1 mm | 0 … 20 | Wrąb dłuższy od grubości ściany o tyle z każdej strony. |
| `gniazdo_luz` | Luz w gnieździe płatwi (każda strona) | 5 mm | 0 … 30 |  |
| `platwie_sciecie` | Wierzch płatwi ścięty do płaszczyzny dachu | tak | `tak` – tak; `nie` – nie | Tak – płatew podniesiona, wierzch ścięty po skosie (kalenicowa z dwóch stron), krokwie i deski leżą na całej szerokości. Nie – wierzch poziomy pod dachem. |
| `szczyt_min_wysokosc` | Najniższy kawałek bala przy skosie | 0 mm | 0 … 140 | 0 – bal szczytu idzie pełnym klinem do końca, szczyt wypełniony do linii dachu (wymóg). Więcej – niższy klin pomijany (bal kończy się pionowo). |
| `zamek_min_drewno` | Drewno w zamku przy skosie dachu – najmniej | 20 mm | 0 … 100 | Bal ścięty dachem przechodzi przez narożnik tylko w zamku, w którym zostaje co najmniej tyle drewna nad gniazdem; inaczej kończy się przy licu ściany poprzecznej (np. przy ścianie wysokiej dachu jednospadowego). |
| `polzamek` | Pół zamka w ostatnim połączeniu pod dachem | tak | `tak` – tak; `nie` – nie | Ostatni bal pod skosem dachu, któremu zwykłe gniazdo od spodu zostawia za mało drewna, przechodzi przez zamek bez gniazda, a bal pod nim dostaje gniazdo do połowy wysokości – koniec ostatniego bala nie odpada. Nie – taki bal kończy się przy licu ściany poprzecznej (jak do kompilacji 14). |
| `polzamek_gleb` | Pół zamka – gniazdo w balu dolnym (0 = do połowy bala) | 0 mm | 0 … 150 | 0 – całe wycięcie w balu dolnym (dwie głębokości gniazda, np. 72), bal górny bez gniazda. Mniej – reszta od spodu bala górnego (nie mniej niż zwykłe gniazdo). |
| `szczyt_min_kawalek` | Najkrótszy kawałek bala przy skosie i gnieździe | 10 mm | 0 … 500 | Krótsze drzazgi między skosem a gniazdem płatwi są pomijane (szczyt poza nimi wypełniony; typ 100: najkrótszy kawałek 104). |
| `dach_elementy` | Belki dachu w modelu (płatwie, krokwie) | tak | `tak` – tak; `nie` – nie | Dla obrysu prostokątnego i w kształcie L (dwa dachy z koszem). |
| `dach_okap` | Okap – wysunięcie krokwi za ścianę | 500 mm | 0 … 1500 | W poziomie, od lica ściany okapowej. |
| `dach_okap_szczyt` | Wysunięcie płatwi za szczyt | 500 mm | 0 … 1500 | Od lica szczytu (typ 100: płatwie 6082). |
| `okap_wience_wypust` | Górne wieńce ścian okapowych wypuszczone za szczyt | 2 szt. | 0 … 6 | Tyle górnych wieńców ścian okapowych kończy się tak jak płatwie (wysunięcie płatwi za szczyt) – oparcie dachu nad szczytem. 0 – zwykły ostatek. |
| `wegly_wypust_okap` | Węgły pod okapem – górne bale do nawisu okapu | nie | `tak` – tak; `nie` – nie |  |
| `wegly_okap_wience` | Węgły pod okapem – liczba górnych bali | 3 szt. | 1 … 8 |  |

## Poszycie dachu (aplikacja do dachów)

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `podbitka` | Nadbitka / podbitka – gdzie leżą deski | na_krokwiach | `na_platwiach` – na płatwiach (nadbitka, deski wzdłuż spadku); `na_krokwiach` – na krokwiach (nadbitka, deski równolegle do okapu); `pod_krokwiami` – pod krokwiami (podbitka, równolegle do okapu, między płatwiami); `pod_platwiami` – pod płatwiami (podbitka, deski wzdłuż spadku); `nie` – bez nadbitki i podbitki |  |
| `podbitka_grubosc` | Deska nadbitki / podbitki – grubość | 14 mm | 10 … 60 |  |
| `podbitka_krycie` | Deska nadbitki / podbitki – szerokość krycia | 115 mm | 50 … 300 |  |
| `podbitka_dlugosc` | Deska nadbitki / podbitki – długość handlowa | 4000 mm | 1000 … 8000 | Dłuższe deski dzielone na płatwiach (pod i na płatwiach) albo równo (pod i na krokwiach). |
| `poszycie_deski` | Deskowanie pełne | nie | `tak` – tak; `nie` – nie | Na krokwiach (albo na nadbitce) równolegle do okapu, styki na krokwiach; przy samych płatwiach (typ 100) – deski na płatwiach wzdłuż spadku, styki na płatwiach. |
| `deski_grubosc` | Deskowanie – grubość deski | 25 mm | 10 … 80 |  |
| `deski_szerokosc` | Deskowanie – szerokość deski | 100 mm | 50 … 300 |  |
| `deski_szczelina` | Deskowanie – szczelina między deskami | 3 mm | 0 … 30 |  |
| `deski_dlugosc` | Deskowanie – długość handlowa | 4000 mm | 1000 … 8000 |  |
| `poszycie_osb` | Płyty OSB | nie | `tak` – tak; `nie` – nie | Na poprzedniej warstwie (albo na krokwiach), dłuższy bok wzdłuż okapu, styki w mijance. |
| `osb_grubosc` | OSB – grubość | 18 mm | 6 … 40 | Zwykle 18 albo 22. |
| `osb_dlugosc` | OSB – długość płyty (wzdłuż okapu) | 2500 mm | 500 … 5000 |  |
| `osb_szerokosc` | OSB – szerokość płyty | 1250 mm | 300 … 2500 |  |
| `osb_szczelina` | OSB – szczelina przy każdej krawędzi | 3 mm | 0 … 20 |  |

## Taras

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `taras` | Taras przed ścianą szczytową | nie | `nie` – bez tarasu; `podciag` – typ 200 – podciąg na słupach, balustrada; `sciany` – typ 300 – ściany pełne, front otwarty | Narysuj sam dom – taras dokłada generator: obrys dłuższy o głębokość tarasu, ściana domu zostaje (działowa ze szczytem), dach i płatwie idą nad taras. Typ 200: nad tarasem górne wieńce ścian na słupach, szczyt frontu, balustrada z bali; typ 300: ściany boczne na całą wysokość. Tylko obrys prostokątny. |
| `taras_strona` | Taras – po stronie | max | `max` – prawej albo górnej (rysunek z góry); `min` – lewej albo dolnej (rysunek z góry) | Na końcu wzdłuż kalenicy: kalenica wzdłuż X – prawa / lewa strona rysunku, wzdłuż Y – górna / dolna. |
| `taras_glebokosc` | Taras – głębokość | 2000 mm | 500 … 6000 | Od lica ściany domu do lica frontu tarasu (typ 300: 2000). |
| `taras_wience_gorne` | Podciąg – górne wieńce ścian nad tarasem | 2 | 1 … 6 | Typ 200: dwa górne bale ścian bocznych i front od wieńca, który zamyka się z nimi w narożniku. |
| `taras_ostatek` | Ostatek dolnych bali ścian bocznych przy tarasie | 100 mm | 0 … 600 | Za licem ściany domu, pod podciągiem. |
| `taras_slup_przekroj` | Słup tarasu (wzdłuż ściany × w poprzek) | 120x120 mm | szer. × wys. | Projekty: 80 × 180, 120 × 120, 140 × 140. |
| `taras_slupy_rozstaw_max` | Słupy – największy rozstaw (osiowo) | 2000 mm | 800 … 5000 | Pod frontem i pod ścianami bocznymi nad tarasem; słupy zawsze w narożnikach frontu i przy wejściu. |
| `taras_slup_w_osi` | Słup frontu w osi kalenicy | tak | `tak` – tak; `nie` – nie | Tak – pod kalenicą zawsze stoi słup, w jednej linii ze słupkiem trójkąta nad tarasem; pozostałe słupy równo po obu stronach. Bez słupa w osi tylko wtedy, gdy oś wypada w świetle wejścia. |
| `taras_slup_os_dociag` | Słup w osi – słup wejścia bliżej osi niż tyle staje w osi | 500 mm | 0 … 2000 | Wejście z boku: zamiast dwóch słupów obok siebie słup wejścia przesuwa się w oś kalenicy – wejście wychodzi szersze albo węższe o tę odległość. 0 – nigdy nie przesuwaj. |
| `taras_slup_zamek_gora` | Słup – zamek górny (wysokość obok bala) | 150 mm | 0 … 600 | Słup licem równo z licem ściany; nad spodem podciągu część słupa za balem idzie dalej w górę, bal leży w wycięciu. 0 – słup kończy się pod balem. |
| `taras_slup_zamek_dol` | Słup – zamek dolny (obok podwaliny) | 100 mm | 0 … 300 | Część słupa obok podwaliny schodzi w dół (najwyżej na wysokość podwaliny). 0 – słup stoi na podwalinie. Tylko z podłogą. |
| `slup_osiadanie` | Słupy krótsze o osiadanie ścian | tak | `tak` – tak; `nie` – nie | Ściany z bali siadają („Osiadanie ścian” w sekcji okien i drzwi), słup nie. Słup krótszy o osiadanie bali stojących obok niego (wysokość do głowicy × osiadanie) – inaczej bale podciągu zostają na słupach, gdy reszta ściany opada. Nie – słup do spodu bali, jak do kompilacji 14. |
| `slup_regulacja` | Słup – regulacja w głowicy | sruba | `sruba` – śruba regulacyjna – dokręcana, gdy ściany siadają; `podkladki` – podkładki – wyjmowane, gdy ściany siadają | Okucie między głowicą słupa a balem trzyma podciąg na wysokości ścian domu. Trafia do zestawienia materiałów. |
| `slup_regulacja_wysokosc` | Śruba regulacyjna – wysokość po skręceniu | 40 mm | 0 … 300 | Słup krótszy dodatkowo o tyle – tyle zajmuje śruba po osiadaniu ścian (z płytkami). |
| `taras_szczyt` | Szczyt nad tarasem | pelny | `pelny` – pełny (typ 200); `azurowy` – ażurowy – bale na przemian z przekładkami, jak balustrada; `pusty` – pusty – bale spinające i trójkątny wieniec pod płatwiami |  |
| `taras_szczyt_bale` | Szczyt pusty – bale spinające | 1 | 0 … 6 | Pełne bale szczytu nad podciągiem (nad balem, który zamyka się ze ścianami bocznymi) – dolny pas trójkąta. |
| `taras_wieniec` | Szczyt pusty – wiązar (trójkąt) z przekroju | platwa | `platwa` – płatwi (jak płatwie); `wlasny` – podanego niżej; `auto` – dobranego automatycznie – najmniejszy wystarczający; `brak` – bez wiązara – słupki z przekładek pod płatwiami | Automatycznie: z listy „Dostępne przekroje płatwi” (sekcja „Szczyty i dach”) najlżejszy przekrój, który przenosi obciążenie od płatwi i przy którym mieści się cały trójkąt – wąski domek dostaje mały trójkąt zamiast przekroju płatwi. Przy pozostałych wyborach w wynikach jest sprawdzenie nośności. |
| `taras_wieniec_przekroj` | Wiązar – przekrój (grub. × wys.) | 80x160 mm | szer. × wys. | Grubość wiązara (wzdłuż kalenicy) × wysokość krokwi wiązara (prostopadle do połaci) i belki dolnej. |
| `taras_wiazar` | Wiązar – rodzaj | slupek | `slupek` – krokwie, belka dolna i słupek pod kalenicą; `zastrzaly` – jak obok + dwa zastrzały od stopy słupka do krokwi (45°) |  |
| `taras_wiazar_gniazdo` | Wiązar – gniazdo płatwi, najmniejsza głębokość | 20 mm | 0 … 100 | O tyle płatew wchodzi w krokiew wiązara przy niższej krawędzi gniazda (przy wyższej głębiej – dno gniazda jest poziome). 0 – płatew tylko dotyka krokwi niższą krawędzią. |
| `taras_wiazar_podparcie` | Wiązar – na czym stoi | bale | `bale` – na balach frontu (podciąg i bale spinające); `slupy` – na słupach – szczyt bez bali, z przodu sam trójkąt | Na słupach: belka dolna wiązara zamiast bali frontu – leży na słupach frontu od spodu podciągu, między ścianami bocznymi. |
| `taras_wiazar_przekroje` | Wiązar – słupek i zastrzały z przekroju | wlasne | `wlasne` – własnego – szerokości podane niżej (smuklejsze, ładniejsze przy małych konstrukcjach); `jak_wiazar` – dokładnie jak reszta trójkąta – przekrój płatwi albo podany dla wiązara | Jak reszta trójkąta: słupek i zastrzały mają w płaszczyźnie frontu wysokość przekroju wiązara (np. płatew 80 × 200 – słupek i zastrzały 200); grubość zawsze jak wiązar. |
| `taras_wiazar_slupek` | Wiązar – szerokość słupka | 120 mm | 40 … 400 | W płaszczyźnie frontu; grubość jak wiązar. |
| `taras_wiazar_zastrzal` | Wiązar – szerokość zastrzału | 100 mm | 40 … 400 |  |
| `taras_wiazar_zastrzal_kat` | Wiązar – kąt zastrzałów od poziomu | 45 ° | 0 … 80 | Zastrzały rozchodzą się od stopy słupka w górę pod tym kątem do spodu krokwi wiązara. 0 albo kąt nie większy niż kąt dachu – do połowy krokwi. |
| `taras_styk` | Łączenie bali frontu i szczytu nad tarasem | styk | `styk` – na styk, na przemian z mijanką – bez kontrfory; `wegly` – w zamkach kontrfor (węgłów) – jak w ścianach | Front dłuższy niż maksymalny bal: na styk – bale łączą się nad słupem, a w sąsiednim wieńcu o mijankę („Mijanka styków”, nie mniej niż 300) dalej; kontrfora z półzamkami nie powstaje. |
| `taras_platwa_zamek` | Zamek płatwi w szczycie nad tarasem | spod | `spod` – tylko od spodu – płatew leży w gnieździe pełną szerokością; `pelny` – z boków i od spodu – jak w ścianach | Płatwie nad trójkątem (wiązarem) albo szczytem frontu tarasu: sam wrąb od spodu wystarcza, żeby trzymały front; wręby boczne jak w ścianach – do wyboru. |
| `taras_wejscie` | Wejście na taras od frontu | srodek | `srodek` – pośrodku; `lewa` – z lewej (patrząc na front z zewnątrz); `prawa` – z prawej (patrząc na front z zewnątrz); `brak` – bez wejścia – balustrada na całym froncie |  |
| `taras_wejscie_szerokosc` | Wejście – szerokość w świetle słupów | 1200 mm | 600 … 4000 |  |
| `taras_balustrada_rodzaj` | Balustrada – z czego | przesla | `przesla` – dołożona – bale i przekładki między słupami; `sciany` – z wieńców ścian – ściany boczne ciągle przez taras, zamki w narożnikach frontu |  |
| `taras_balustrada_wysokosc` | Balustrada z wieńców – wysokość (najwyżej) | 1000 mm | 200 … 2000 | Wieńce, których wierzch nie przekracza tej wysokości; poręcz frontu i boków na wspólnej wysokości. |
| `taras_zakladka` | Balustrada z wieńców – zakładka w narożnikach frontu | tak | `tak` – tak; `nie` – nie | Tak – co druga belka wysunięta za lico (zakładka pod barierkę). Nie – końce równo z licem. |
| `taras_zakladka_wypust` | Zakładka – wysunięcie belki | 100 mm | 20 … 400 |  |
| `taras_balustrada_bale` | Balustrada – liczba bali | 4 | 0 … 8 | Bale na przemian z rzędami przekładek (typ 200: 4 bale i 3 rzędy, ok. 1 m). 0 – bez balustrady. |
| `taras_przekladka` | Balustrada – długość przekładki | 300 mm | 50 … 1000 | Odcinek bala między balami balustrady (typ 200: 300). |
| `taras_przekladka_odstep` | Balustrada – największy prześwit między przekładkami | 600 mm | 50 … 2000 | Przekładki przy obu końcach przęsła i równo między nimi. |

## Podłoga i fundamenty

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `podloga` | Podłoga (podwaliny, legary, podciągi) | tak | `tak` – tak; `nie` – nie |  |
| `podwalina_przekroj` | Podwalina pod ścianami (szer. × wys.) | 100x100 mm | szer. × wys. | Typ 100: 100 × 100. 50 × 150 (na kant) – równo z legarami 50 × 150, łatwo skręcić śrubami bez zamków. |
| `podwalina_laczenie` | Podwaliny w narożnikach | zaklad | `zaklad` – na zakład (pół wysokości); `sruby` – na styk, bez zamków – skręcane śrubami | Na styk: podwaliny w poprzek legarów na całą długość, pozostałe między nimi. |
| `podwaliny_pod_dzialowymi` | Podwaliny także pod działowymi | tak | `tak` – tak; `nie` – nie |  |
| `legary_kierunek` | Legary wzdłuż | krotszy | `krotszy` – krótszego boku; `dluzszy` – dłuższego boku; `x` – osi X obrysu; `y` – osi Y obrysu |  |
| `legary_rozstaw` | Rozstaw legarów (osiowo) | 600 mm | 250 … 1200 | Projekt 900: 550–610. |
| `izolacja_podlogi` | Izolacja między legarami | 100 mm | 0 … 400 | Legar nie niższy niż izolacja (0 – bez izolacji). |
| `legary_dobor` | Dobór przekroju legara | zalecany | `zalecany` – zalecany (ugięcie ≤ L/zalecane); `minimalny` – minimalny (ugięcie ≤ L/minimalne); `reczny` – ręczny – podany niżej (tylko sprawdzenie) |  |
| `legar_przekroj` | Legar – przekrój do sprawdzenia | 50x100 mm | szer. × wys. | Wpisz przekrój „szer. x wys.”, np. 50x150 – wynik sprawdzenia pod polem i w podpowiedziach. Typ 100: 50 × 100. |
| `podciagi` | Podciągi pod legarami | auto | `auto` – gdy wymaga ich legar (najmniej drewna); `tak` – tak – co najwyżej co podany rozstaw; `nie` – nie – legary od podwaliny do podwaliny |  |
| `podpory_rozstaw_max` | Rozstaw podciągów pod legarami – największy | 0 mm | 0 … 8000 | 0 – automatycznie: tylko tam, gdzie wymaga ich przekrój legara. Z fundamentami punktowymi podciągi leżą w ich liniach. |
| `podpora_przekroj` | Podciąg pod legarami (podpora pośrednia) | 100x150 mm | szer. × wys. |  |
| `podciag_poziom` | Podciąg – poziom | rowno | `rowno` – na wysokości podwalin – między podwalinami, legary dzielone na podciągu; `pod` – obniżony – pod podwalinami, legary w całości na nim |  |
| `fundamenty` | Fundamenty punktowe | tak | `tak` – tak; `nie` – nie |  |
| `fundament_ksztalt` | Fundament punktowy – kształt w rzucie | kwadrat | `kwadrat` – prostokątny – wymiary niżej; `okragly` – okrągły – średnica niżej (np. bloczek w rurze) |  |
| `fundament_przekroj` | Fundament punktowy – wymiary w rzucie | 400x400 mm | szer. × wys. |  |
| `fundament_srednica` | Fundament punktowy – średnica | 400 mm | 100 … 1500 |  |
| `fundament_wysokosc` | Fundament punktowy – wysokość | 400 mm | 50 … 2000 | Część nad gruntem do rysunku (bez części w gruncie). |
| `fundamenty_rozstaw_max` | Rozstaw fundamentów – największy (osiowo) | 2500 mm | 800 … 6000 | Dom 5 × 7 m przy 2500: 3 rzędy na 5 m i 4 na 7 m. |
| `obciazenie_uzytkowe` | Obciążenie użytkowe | 2 kN/m² | 0,5 … 10 | Ludzie i meble na podłodze. Mieszkanie: 1,5–2,0, poddasze bez mieszkania 1,0, magazyn 5,0. |
| `obciazenie_stale` | Obciążenie stałe (deski, izolacja) | 0,5 kN/m² | 0 … 5 | Bez ciężaru legarów (liczony osobno). |
| `drewno_klasa` | Klasa drewna konstrukcyjnego | C24 | `C18` – C18; `C24` – C24; `C30` – C30; `GL24h` – GL24h (klejone) |  |
| `ugiecie_zalecane` | Ugięcie zalecane L / | 400 | 150 … 1000 | Sztywna podłoga bez drgań. |
| `ugiecie_minimalne` | Ugięcie dopuszczalne L / | 250 | 100 … 1000 | Granica – mniej sztywna podłoga już niedopuszczalna. |
| `przekroje_katalog` | Dostępne przekroje legarów i podciągów | 45x95:6, 45x120:5.4/6, 45x145:4.2/5.4/6, 45x170:5.4/6, 45x195:4.2/5.4/6/7, 45x220:5.4/6, 45x245:5.4/6, 60x100:6, 60x120:5/6, 60x140:5/6/7, 60x160:5/6, 60x200:5/7, 60x240:7, 80x160:4/5/6/7, 80x180:7, 80x200:5/7/8, 80x220:7, 100x100:5/6, 100x200:7, 120x120:5/6, 120x200:7, 140x140:5/6/7, 140x200:7, 140x240:7, 160x160:5/6/7, 160x200:7, 160x280:7, 200x200:7 |  | Lista z hurtowni: „szer.×wys.:długości w metrach”, np. 45x145:4.2/5.4/6 – po przecinku. Dobór bierze najlżejszy spełniający warunki; belka dłuższa niż najdłuższa z listy – uwaga w wynikach. |

## Okna i drzwi – stolarka i luzy

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `min_kawalek_przy_otworze` | Kawałek bala przy otworze – najkrótszy | 70 mm | 0 … 1000 |  |
| `luz_boczny` | Luz boczny stolarki (z każdej strony) | 10 mm | 0 … 100 | Otwór w balach = szerokość stolarki + 2 × luz boczny (typowo 5–10 mm, zakryty listwą). |
| `osiadanie_scian` | Osiadanie ścian – podpowiedź luzu górnego | 1,5 % | 0 … 10 | Luz nad stolarką, gdy w tabeli puste pole „Luz górny”: wysokość stolarki × osiadanie, w górę do 5 mm. Bal suszony 44 mm ok. 1–2 % (montaż latem mniej, zimą więcej), drewno świeże 4–6 %. O tyle krótsze są też słupy tarasu („Słupy krótsze o osiadanie ścian”). |
| `luz_gorny_min` | Luz górny – najmniejszy w podpowiedzi | 10 mm | 0 … 200 |  |
| `min_pasek_przy_otworze` | Najcieńszy pasek bala nad / pod otworem | 20 mm | 1 … 100 | Cieńszy pasek – bal przecięty w całości (otwór sięga do krawędzi bala), z ostrzeżeniem. |
| `okno_szerokosc` | Nowe okno – szerokość stolarki | 1020 mm | 100 … 6000 | Wymiary stolarki wstawiane przyciskiem „+ okno” (typ 100: 1020 × 1010). |
| `okno_wysokosc` | Nowe okno – wysokość stolarki | 1010 mm | 100 … 4000 |  |
| `okno_parapet` | Nowe okno – spód okna (od podwaliny) | 900 mm | 0 … 4000 |  |
| `drzwi_szerokosc` | Nowe drzwi – szerokość stolarki | 930 mm | 300 … 6000 |  |
| `drzwi_wysokosc` | Nowe drzwi – wysokość stolarki | 2100 mm | 1000 … 4000 |  |
| `nowy_otwor_od` | Nowy otwór – odległość od narożnika | 1000 mm | 0 … 30000 |  |

## Rozpoznanie rysunku i waga

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `kontrfor_max_linia` | Linia węgła – najdłuższa | 600 mm | 100 … 3000 | Krótsza linia przecinająca jedną ścianę = węgieł. |
| `tolerancja_rysunku` | Tolerancja rysunku obrysu | 5 mm | 0,5 … 50 |  |
| `gestosc` | Gęstość drewna (waga) | 450 kg/m³ | 300 … 900 |  |

## Zestawienie materiałów

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `material_zapas` | Zapas na docinki desek i płyt | 10 % | 0 … 50 | Doliczany do liczby desek nadbitki, deskowania, podbitki i płyt OSB w zestawieniu materiałów. |
| `tasma_pasy` | Taśma między wieńcami – pasy na styk | 1 | `0` – bez taśmy; `1` – jeden pas; `2` – dwa pasy | Metry taśmy uszczelniającej: długość wszystkich bali poza najniższym wieńcem × liczba pasów. |
| `kotwy_podwalin_rozstaw` | Kotwy podwalin – rozstaw | 1000 mm | 200 … 3000 | Liczba kotew w zestawieniu: co tyle, nie mniej niż 2 na podwalinę. |
| `impregnat_wydajnosc` | Impregnat – wydajność | 10 m²/l | 1 … 30 | Z etykiety impregnatu albo farby – ile m² z litra na jedną warstwę. |
| `impregnat_warstwy` | Impregnat – liczba warstw | 2 | `1` – jedna; `2` – dwie; `3` – trzy |  |

## Zadaszenie – rodzaj i wymiary

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `zadaszenie` | Zadaszenie przy ścianie okapowej (boczne / tylne) | nie | `nie` – bez zadaszenia; `slupy` – na słupach z oczepem (wiata, drewutnia); `bale` – ściany z bali (przybudówka) | Połać dachu za ścianą okapową schodzi dalej pod mniejszym kątem – załamanie nad licem zewnętrznym ściany. Narysuj sam dom: słupy, belki i płatwie zadaszenia albo ściany przybudówki dokłada generator. Aplikacja do dachów dostaje połacie z załamaniem (łaty przy załamaniu, pełne moduły pod nim). Dom prostokątny, dach dwuspadowy, bez tarasu. |
| `zadaszenie_strona` | Zadaszenie – przy ścianie okapowej | min | `min` – dolnej albo lewej (rysunek z góry); `max` – górnej albo prawej (rysunek z góry); `obie` – po obu stronach | Kalenica wzdłuż X – ściana dolna / górna rysunku, wzdłuż Y – lewa / prawa. |
| `zadaszenie_szerokosc` | Zadaszenie – szerokość | 2000 mm | 600 … 6000 | Od lica zewnętrznego ściany domu do lica zewnętrznego podpory (słupów albo ściany przybudówki), w poziomie. |
| `zadaszenie_kat` | Zadaszenie – kąt (mniejszy niż kąt dachu) | 12 ° | 3 … 50 | Musi być mniejszy niż kąt dachu (załamanie). Blachodachówka zwykle od 9–12°, blacha na rąbek od 3–5° – sprawdź kartę pokrycia. |
| `zadaszenie_okap` | Zadaszenie – okap za podporą (najmniej) | 300 mm | 0 … 1500 | W poziomie, od lica podpory. Aplikacja do dachów wydłuża go do pełnych modułów łat (0 … 1 moduł). |
| `zadaszenie_slupy_rozstaw` | Słupy zadaszenia – największy rozstaw (osiowo) | 2500 mm | 800 … 6000 | Skrajne słupy w osiach ścian szczytowych, pośrednie równo; słup w miejscu węgła albo działowej przesunięty obok. Rozstaw słupów to przęsło płatwi i oczepu. |
| `zadaszenie_podloga` | Przybudówka – podłoga | tak | `tak` – tak – podłoga domu sięga do ściany przybudówki; `nie` – nie – same podwaliny i fundamenty pod ścianami przybudówki | Podłogę domu (legary, podciągi, fundamenty) ustawiasz w zakładce Dom → „Podłoga i fundamenty”; tu tylko, czy wchodzi do przybudówki. Bez podłogi w przybudówce zostają podwaliny pod jej ścianami na fundamentach. |

## Zadaszenie – przekroje (dobór)

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `zadaszenie_dobor` | Przekroje zadaszenia – dobór | auto | `auto` – automatycznie – najmniejsze wystarczające z list; `reczny` – z wyboru – przekroje podane niżej (ze sprawdzeniem nośności) | Płatwie i oczep, belki poprzeczne i słupy zadaszenia: generator liczy śnieg i ciężar pokrycia (jak dach – zakładka Dom → „Szczyty i dach”) i bierze najlżejszy przekrój z listy, który to przenosi. Krokwie zadaszenia mają przekrój krokwi dachu (dobór przy krokwiach w zakładce Dom). Wynik to podpowiedź, nie projekt konstruktora. |
| `zadaszenie_katalog` | Dostępne przekroje belek zadaszenia | 60x100:6, 60x120:5/6, 60x140:5/6/7, 60x160:5/6, 60x200:5/7, 60x240:7, 80x160:4/5/6/7, 80x180:7, 80x200:5/7/8, 80x220:7, 100x200:7, 120x200:7, 140x200:7, 140x240:7, 160x200:7, 160x280:7 |  | Płatwie, oczep i belki poprzeczne – lista z hurtowni „szer.×wys.:długości w metrach” po przecinku; dobór bierze najlżejszy wystarczający. |
| `zadaszenie_slupy_katalog` | Dostępne przekroje słupów zadaszenia | 100x100:5/6, 120x120:5/6, 140x140:5/6/7, 160x160:5/6/7, 200x200:7 |  | Lista z hurtowni „wzdłuż ściany×w poprzek:długości w metrach” po przecinku; dobór bierze najlżejszy wystarczający. |
| `zadaszenie_platwa_przekroj` | Płatew zadaszenia (szer. × wys.) | 80x160 mm | szer. × wys. | Wszystkie płatwie zadaszenia (przy ścianie, pośrednie, oczep nad słupami); wierzch ścięty do połaci jak płatwie dachu. Wynik sprawdzenia – pod sekcją. |
| `zadaszenie_slup_przekroj` | Słup zadaszenia (wzdłuż ściany × w poprzek) | 120x120 mm | szer. × wys. | Słupy na fundamentach punktowych (wymiary fundamentu jak pod podłogą), lico zewnętrzne w linii podpory. |
| `zadaszenie_belka_przekroj` | Belka poprzeczna na słupie (szer. × wys.) | 80x160 mm | szer. × wys. | Na każdym słupie od lica podpory do ściany domu (przy szczycie – do końca ostatków); na niej oczep, na słupkach płatwie zadaszenia. Ściana domu osiada (bale) – belka tylko oparta o ścianę. |

## Szablony wbudowane

| Szablon | Zmienione wartości |
|---|---|
| Typ 100 – domek parterowy na samych płatwiach | `liczba_wiencow` = 16 |
| Typ 200 – dom parterowy wysoki, taras na słupach | `liczba_wiencow` = 20, `taras` = podciag, `taras_glebokosc` = 2000 |
| Typ 300 – dom 1,5 kondygnacji ze stropem, taras między ścianami | `liczba_wiencow` = 25, `strop` = tak, `dzialowa_nizsza_wysokosc` = 2780, `taras` = sciany, `taras_glebokosc` = 2000, `dach_uklad` = platwie_krokwie |
| Typ 400 – dach jednospadowy, płatwie i krokwie | `dach_rodzaj` = jednospadowy, `dach_kat` = 15, `dach_uklad` = platwie_krokwie |
| Pełny profil bala – pióro i wpust (wizualizacja) | `profil_bala` = pelny |
| Bez łączenia bali (bale do 7 m) | `max_dlugosc` = 7000 |
| Podłoga ocieplona 150 mm | `izolacja_podlogi` = 150 |
