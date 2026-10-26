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
| `dzialowa_nizsza_wysokosc` | Działowa pod stropem / antresolą – góra | 2500 mm | 500 … 8000 | Spód stropu, antresoli albo półki; działowa kończy się pełnym wieńcem nie wyżej (1100: 2432, 1200: 2780). |
| `dopelnienie_wewn` | Dopełnienie zamka nad niższą działową – do wnętrza | 100 mm | 40 … 600 | Odcinki nad działową przy ścianach, które idą wyżej: ostatek + grubość + tyle (1100: 244, 1200 przy ostatku 200: 344). |

## Długości bali i łączenia

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `max_dlugosc` | Maksymalna długość bala | 5100 mm | 1000 … 13000 | Najdłuższy bal od producenta (listy 1800 i 1200: 5044 i 5090). |
| `min_odcinek` | Najkrótszy kawałek bala | 200 mm | 50 … 2000 | Krótszy kawałek – ostrzeżenie. |
| `styk_uklad` | Łączenie bali na długości | na_przemian | `na_przemian` – na przemian w kolejnych węgłach / działowych (jak 1200); `para` – para węgłów w odstępie mijanki, styk w osi zamka (jak 900 W-2); `jeden_wegiel` – jeden węgieł, styki ± połowa mijanki |  |
| `mijanka` | Mijanka styków w sąsiednich wieńcach | 400 mm | 300 … 3000 | Najmniejszy odstęp styków w sąsiednich wieńcach – nie mniej niż 300. |
| `szczelina_styku` | Szczelina na styku | 0 mm | 0 … 30 |  |
| `styk_odstep_od_otworu` | Styk od krawędzi otworu – najmniej | 400 mm | 0 … 2000 | Kawałek bala między stykiem a otworem nie krótszy niż tyle. |

## Węgły 244 – wzmocnienia ścian

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `wegly_max_swiatlo` | Najdłuższe światło ściany bez węgła | 4800 mm | 1500 … 10000 | Między licami ścian podpierających (narożnik, działowa, węgieł). 1800 W-2: 4756 bez węgła. |
| `wegly_max_swiatlo_wysokie` | To samo dla ścian wysokich | 3700 mm | 1500 … 10000 | Dom 1,5 kondygnacji (1200): węgieł już na ścianie 4 m. |
| `wegly_prog_wysokosci` | Ściana wysoka od wysokości | 3000 mm | 1500 … 8000 | Wysokość ściany okapowej bez szczytu (1100: 2966 – bez węgła, 1200: 3580 – z węgłem). |
| `wegly_rozmieszczenie` | Rozmieszczenie nowych węgłów | rowno | `rowno` – równo na długości ściany; `od_naroznikow` – od narożników o zadany odstęp (jak 1000); `tylko_narysowane` – tylko narysowane (generator tylko ostrzega) |  |
| `wegly_odstep_od_naroznika` | Odstęp węgła od narożnika | 800 mm | 300 … 3000 | Dla rozmieszczenia „od narożników”. |
| `wegly_na_dzialowych` | Węgły także na ścianach działowych | tak | `tak` – tak; `nie` – nie |  |
| `min_odstep_skrzyzowan` | Odstęp węgła od innego skrzyżowania | 300 mm | 150 … 3000 |  |
| `odstep_od_otworu` | Odstęp węgła od krawędzi otworu | 150 mm | 0 … 2000 |  |

## Szczyty i dach

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `szczyty` | Szczyty z bali | tak | `tak` – tak; `nie` – nie | Ściany szczytowe zewnętrzne dostają szczyt z bali ściętych pod kątem dachu. |
| `szczyty_na_dzialowych` | Szczyty także na działowych szczytowych | nie | `tak` – tak; `nie` – nie | Jak 1800 W-2 – ściana działowa do kalenicy. |
| `dach_rodzaj` | Dach | dwuspadowy | `dwuspadowy` – dwuspadowy – dwa szczyty, kalenica w środku; `jednospadowy` – jednospadowy – ściana niska i wysoka, szczyty skośne | Jednospadowy – dom prostokątny. Inne dachy (kopertowy, wielospadowy, obrys L) zrób w aplikacji do dachów (KROK 1 z obrysu). |
| `dach_spadek` | Jednospadowy – spadek w stronę | min | `min` – dolnej albo lewej (rysunek z góry); `max` – górnej albo prawej (rysunek z góry) | Po stronie spadku ściana niska (wysokość ścian okapowych), naprzeciw – ściana wysoka, do połaci. Okapy wzdłuż „kalenicy”: wzdłuż X – spadek w dół / w górę rysunku, wzdłuż Y – w lewo / w prawo. |
| `dach_okap_wysoki` | Jednospadowy – okap za ścianą wysoką | 500 mm | 0 … 1500 | W poziomie, od lica ściany wysokiej. |
| `jednospad_min_pasek` | Jednospadowy – najcieńszy górny bal ściany wysokiej | 30 mm | 0 … 300 | Ściana wysoka sięga połaci, górny bal przycięty wzdłuż; cieńszy pasek jest pomijany. |
| `dach_kat` | Kąt dachu | 20 ° | 5 … 60 | Projekty 900 i 1000: 20°. |
| `dach_uklad` | Układ dachu | platwie | `platwie` – same płatwie (deski na płatwiach); `krokwie` – krokwie na płatwi ściennej i kalenicowej; `platwie_krokwie` – płatwie i krokwie |  |
| `dach_wiezba` | Krokwie i poszycie – kto je buduje | aplikacja | `aplikacja` – aplikacja do dachów (KROK 2: krokwie, poszycie, kontrola); `generator` – generator (krokwie bez kontroli, bez poszycia) | Dom prostokątny. Aplikacja do dachów (ArteMadera Roof, 3.7.0 lub nowsza) dostaje połacie na wierzchu płatwi generatora i jego płatwie jako podpory: z krokwiami – KROK 2 liczy krokwie (przęsła między płatwiami), poszycie, łaty i nośność; same płatwie – poszycie wprost na płatwiach, wzdłuż spadku, styki na płatwiach. Szczyt kończy się pod krokwiami, krokwie przy szczycie ustawia się w aplikacji. |
| `dach_podniesienie` | Wierzch płatwi nad ścianą okapową (przy licu wewn.) | 69,5 mm | -300 … 1500 | Projekt 900: 69,5 = wierzch najwyższego bala ściany szczytowej. Nie dotyczy płatwi stojącej na ścianie. |
| `krokwie_przy_szczycie` | Krokwie przy ścianie szczytowej | obie_strony | `obie_strony` – z obu stron szczytu; `wewnatrz` – tylko od wewnątrz; `zewnatrz` – tylko od zewnątrz; `na_szczycie` – na szczycie (krokiew oparta na balach) | Krokwie z generatora: obok szczytu – szczyt dochodzi do wierzchu krokwi; na szczycie – szczyt kończy się pod nią. Krokwie z aplikacji do dachów – szczyt zawsze pod krokwiami. |
| `krokiew_przekroj` | Krokiew (szer. × wys.) | 50x150 mm | szer. × wys. | Z aplikacją do dachów – wartość na start KROKU 2. |
| `krokwie_rozstaw` | Rozstaw krokwi – największy | 900 mm | 300 … 2000 | Z aplikacją do dachów – wartość na start KROKU 2. |
| `platwa_przekroj` | Płatew pośrednia | 80x180 mm | szer. × wys. | Projekt 900: 80 × 180. |
| `platwa_kalenicowa_przekroj` | Płatew kalenicowa | 80x180 mm | szer. × wys. |  |
| `platwie_rozstaw_max` | Największy rozstaw płatwi (w poziomie) | 1000 mm | 300 … 4000 | 900: ok. 990. |
| `platwa_na_scianie` | Płatew ścienna (przy ścianie okapowej) | tak | `tak` – tak; `nie` – nie |  |
| `platwa_scienna_polozenie` | Płatew ścienna – położenie | przy_licu | `przy_licu` – przy licu wewnętrznym, wierzchem na linii dachu (jak 900); `na_scianie` – stoi na ścianie okapowej, w osi |  |
| `platwa_scienna_przekroj` | Płatew na ścianie | 60x200 mm | szer. × wys. | Projekt 900: 60 × 200. |
| `gniazdo_luz` | Luz w gnieździe płatwi (każda strona) | 5 mm | 0 … 30 |  |
| `platwie_sciecie` | Wierzch płatwi ścięty do płaszczyzny dachu | tak | `tak` – tak; `nie` – nie | Tak – płatew podniesiona, wierzch ścięty po skosie (kalenicowa z dwóch stron), krokwie i deski leżą na całej szerokości. Nie – wierzch poziomy pod dachem. |
| `szczyt_min_wysokosc` | Najniższy kawałek bala przy skosie | 0 mm | 0 … 140 | 0 – bal szczytu idzie pełnym klinem do końca, szczyt wypełniony do linii dachu (wymóg). Więcej – niższy klin pomijany (bal kończy się pionowo). |
| `zamek_min_drewno` | Drewno w zamku przy skosie dachu – najmniej | 20 mm | 0 … 100 | Bal ścięty dachem przechodzi przez narożnik tylko w zamku, w którym zostaje co najmniej tyle drewna nad gniazdem; inaczej kończy się przy licu ściany poprzecznej (np. przy ścianie wysokiej dachu jednospadowego). |
| `szczyt_min_kawalek` | Najkrótszy kawałek bala przy skosie i gnieździe | 10 mm | 0 … 500 | Krótsze drzazgi między skosem a gniazdem płatwi są pomijane (szczyt poza nimi wypełniony; 900: najkrótszy kawałek 104). |
| `dach_elementy` | Belki dachu w modelu (płatwie, krokwie) | tak | `tak` – tak; `nie` – nie | Dla obrysu prostokątnego. |
| `dach_okap` | Okap – wysunięcie krokwi za ścianę | 500 mm | 0 … 1500 | W poziomie, od lica ściany okapowej. |
| `dach_okap_szczyt` | Wysunięcie płatwi za szczyt | 500 mm | 0 … 1500 | Od lica szczytu (900: płatwie 6082). |

## Poszycie dachu (aplikacja do dachów)

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `poszycie_nadbitka` | Nadbitka – boazeria pióro-wpust | nie | `tak` – tak; `nie` – nie | Pełne deskowanie widoczne od spodu (dach bez ocieplenia) – pierwsza warstwa na krokwiach, przy samych płatwiach na płatwiach. Wartości na start KROKU 2 aplikacji do dachów (Krokwie i poszycie = aplikacja). |
| `nadbitka_grubosc` | Nadbitka – grubość | 19 mm | 10 … 60 |  |
| `nadbitka_krycie` | Nadbitka – szerokość krycia | 121 mm | 50 … 300 |  |
| `nadbitka_dlugosc` | Nadbitka – długość handlowa | 4000 mm | 1000 … 8000 |  |
| `poszycie_deski` | Deskowanie pełne | tak | `tak` – tak; `nie` – nie | Na krokwiach (albo na nadbitce) równolegle do okapu, styki na krokwiach; przy samych płatwiach (jak 900) – deski na płatwiach wzdłuż spadku, styki na płatwiach. |
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
| `taras` | Taras przed ścianą szczytową | nie | `nie` – bez tarasu; `podciag` – jak 1100 – podciąg na słupach, balustrada; `sciany` – jak 1200 – ściany pełne, front otwarty | Narysuj sam dom – taras dokłada generator: obrys dłuższy o głębokość tarasu, ściana domu zostaje (działowa ze szczytem), dach i płatwie idą nad taras. 1100: nad tarasem górne wieńce ścian na słupach, szczyt frontu, balustrada z bali; 1200: ściany boczne na całą wysokość. Tylko obrys prostokątny. |
| `taras_strona` | Taras – po stronie | max | `max` – prawej albo górnej (rysunek z góry); `min` – lewej albo dolnej (rysunek z góry) | Na końcu wzdłuż kalenicy: kalenica wzdłuż X – prawa / lewa strona rysunku, wzdłuż Y – górna / dolna. |
| `taras_glebokosc` | Taras – głębokość | 2000 mm | 500 … 6000 | Od lica ściany domu do lica frontu tarasu (1200: 2000). |
| `taras_wience_gorne` | Podciąg – górne wieńce ścian nad tarasem | 2 | 1 … 6 | Wariant 1100: dwa górne bale ścian bocznych (95-2372, 96-2372) i front od wieńca, który zamyka się z nimi w narożniku. |
| `taras_ostatek` | Ostatek dolnych bali ścian bocznych przy tarasie | 100 mm | 0 … 600 | Za licem ściany domu, pod podciągiem. |
| `taras_slup_przekroj` | Słup tarasu (wzdłuż ściany × w poprzek) | 120x120 mm | szer. × wys. | Projekty: 80 × 180, 120 × 120, 140 × 140. |
| `taras_slupy_rozstaw_max` | Słupy – największy rozstaw (osiowo) | 2000 mm | 800 … 5000 | Pod frontem i pod ścianami bocznymi nad tarasem; słupy zawsze w narożnikach frontu i przy wejściu. |
| `taras_wejscie` | Wejście na taras od frontu | srodek | `srodek` – pośrodku; `lewa` – z lewej (patrząc na front z zewnątrz); `prawa` – z prawej (patrząc na front z zewnątrz); `brak` – bez wejścia – balustrada na całym froncie |  |
| `taras_wejscie_szerokosc` | Wejście – szerokość w świetle słupów | 1200 mm | 600 … 4000 |  |
| `taras_balustrada_bale` | Balustrada – liczba bali | 4 | 0 … 8 | Bale na przemian z rzędami przekładek (1100: 4 bale i 3 rzędy, ok. 1 m). 0 – bez balustrady. |
| `taras_przekladka` | Balustrada – długość przekładki | 300 mm | 50 … 1000 | Odcinek bala między balami balustrady (1100: 300). |
| `taras_przekladka_odstep` | Balustrada – największy prześwit między przekładkami | 600 mm | 50 … 2000 | Przekładki przy obu końcach przęsła i równo między nimi. |

## Podłoga

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `podloga` | Podłoga (podwaliny, legary, podciągi) | tak | `tak` – tak; `nie` – nie |  |
| `podwalina_przekroj` | Podwalina pod ścianami | 100x100 mm | szer. × wys. | Projekt 900: 100 × 100. Niższa niż legar – podniesiona do wysokości legara. |
| `podwaliny_pod_dzialowymi` | Podwaliny także pod działowymi | tak | `tak` – tak; `nie` – nie |  |
| `legary_kierunek` | Legary wzdłuż | krotszy | `krotszy` – krótszego boku; `dluzszy` – dłuższego boku; `x` – osi X obrysu; `y` – osi Y obrysu |  |
| `legary_rozstaw` | Rozstaw legarów (osiowo) | 600 mm | 250 … 1200 | Projekt 900: 550–610. |
| `izolacja_podlogi` | Izolacja między legarami | 100 mm | 0 … 400 | Legar nie niższy niż izolacja (0 – bez izolacji). |
| `legary_dobor` | Dobór przekroju legara | zalecany | `zalecany` – zalecany (ugięcie ≤ L/zalecane); `minimalny` – minimalny (ugięcie ≤ L/minimalne); `reczny` – ręczny – podany niżej (tylko sprawdzenie) |  |
| `legar_przekroj` | Legar – przekrój ręczny | 50x100 mm | szer. × wys. | Projekt 900: 50 × 100. |
| `podpory_rozstaw_max` | Rozstaw podciągów pod legarami – największy | 0 mm | 0 … 8000 | 0 – automatycznie: podciągi tylko tam, gdzie wymaga ich przekrój legara (najmniej drewna). |
| `podpora_przekroj` | Podciąg pod legarami (podpora pośrednia) | 100x100 mm | szer. × wys. |  |
| `obciazenie_uzytkowe` | Obciążenie użytkowe | 2 kN/m² | 0,5 … 10 | Mieszkanie: 1,5–2,0 (PN-EN 1991-1-1, kat. A). |
| `obciazenie_stale` | Obciążenie stałe (deski, izolacja) | 0,5 kN/m² | 0 … 5 | Bez ciężaru legarów (liczony osobno). |
| `drewno_klasa` | Klasa drewna konstrukcyjnego | C24 | `C18` – C18; `C24` – C24; `C30` – C30; `GL24h` – GL24h (klejone) |  |
| `ugiecie_zalecane` | Ugięcie zalecane L / | 400 | 150 … 1000 | Sztywna podłoga bez drgań. |
| `ugiecie_minimalne` | Ugięcie dopuszczalne L / | 250 | 100 … 1000 | Granica – mniej sztywna podłoga już niedopuszczalna. |
| `przekroje_katalog` | Dostępne przekroje legarów | 45x95, 45x120, 45x145, 45x170, 45x195, 45x220, 50x100, 50x150, 50x175, 50x200, 50x225, 63x175, 63x200, 63x225, 75x200, 75x225, 75x250, 100x100, 100x150 |  | Lista „szer.×wys.” po przecinku – dobór bierze najlżejszy spełniający warunki. |

## Okna i drzwi – stolarka i luzy

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `min_kawalek_przy_otworze` | Kawałek bala przy otworze – najkrótszy | 70 mm | 0 … 1000 |  |
| `luz_boczny` | Luz boczny stolarki (z każdej strony) | 10 mm | 0 … 100 | Otwór w balach = szerokość stolarki + 2 × luz boczny (typowo 5–10 mm, zakryty listwą). |
| `osiadanie_scian` | Osiadanie ścian – podpowiedź luzu górnego | 1,5 % | 0 … 10 | Luz nad stolarką, gdy w tabeli puste pole „Luz górny”: wysokość stolarki × osiadanie, w górę do 5 mm. Bal suszony 44 mm ok. 1–2 % (montaż latem mniej, zimą więcej), drewno świeże 4–6 %. |
| `luz_gorny_min` | Luz górny – najmniejszy w podpowiedzi | 10 mm | 0 … 200 |  |
| `min_pasek_przy_otworze` | Najcieńszy pasek bala nad / pod otworem | 20 mm | 1 … 100 | Cieńszy pasek – bal przecięty w całości (otwór sięga do krawędzi bala), z ostrzeżeniem. |
| `okno_szerokosc` | Nowe okno – szerokość stolarki | 1020 mm | 100 … 6000 | Wymiary stolarki wstawiane przyciskiem „+ okno” (900: 1020 × 1010). |
| `okno_wysokosc` | Nowe okno – wysokość stolarki | 1010 mm | 100 … 4000 |  |
| `okno_parapet` | Nowe okno – parapet (spód stolarki) | 900 mm | 0 … 4000 |  |
| `drzwi_szerokosc` | Nowe drzwi – szerokość stolarki | 930 mm | 300 … 6000 |  |
| `drzwi_wysokosc` | Nowe drzwi – wysokość stolarki | 2100 mm | 1000 … 4000 |  |
| `nowy_otwor_od` | Nowy otwór – odległość od narożnika | 1000 mm | 0 … 30000 |  |

## Rozpoznanie rysunku i waga

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `kontrfor_max_linia` | Linia węgła – najdłuższa | 600 mm | 100 … 3000 | Krótsza linia przecinająca jedną ścianę = węgieł. |
| `tolerancja_rysunku` | Tolerancja rysunku obrysu | 5 mm | 0,5 … 50 |  |
| `gestosc` | Gęstość drewna (waga) | 450 kg/m³ | 300 … 900 |  |

## Szablony wbudowane

| Szablon | Zmienione wartości |
|---|---|
| Domek parterowy 44 (jak 900) | `liczba_wiencow` = 16 |
| Dom parterowy wysoki (jak 1800) | `liczba_wiencow` = 20 |
| Dom 1,5 kondygnacji (jak 1200) | `liczba_wiencow` = 25 |
| Dom 1,5 kondygnacji ze stropem nad parterem | `liczba_wiencow` = 25, `strop` = tak, `dzialowa_nizsza_wysokosc` = 2780 |
| Pełny profil bala – pióro i wpust (wizualizacja) | `profil_bala` = pelny |
| Bez łączenia bali (bale do 7 m) | `max_dlugosc` = 7000 |
| Podłoga ocieplona 150 mm | `izolacja_podlogi` = 150 |
