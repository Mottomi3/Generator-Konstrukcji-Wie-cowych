# Pytania otwarte – wartości przyjęte bez pytania (do potwierdzenia)

Wydzielone z `docs/stan_prac.md` §6 w rundzie 14 (2026-11-25). Tabela bez zmian. Każdy wiersz to wartość, którą generator
przyjął sam – działa tak od rundy, w której powstała. Propozycja z `claude/propozycje_r14.md` (bez odpowiedzi użytkownika,
więc status wierszy się nie zmienia): uznać całość za przyjętą poza pięcioma pytaniami wymienionymi w `docs/stan_prac.md` §6.
Uwaga: numer Z1 występuje dwa razy (drewno w zamku przy skosie – runda 5; linia załamania zadaszenia – runda 12).

| # | Pytanie | Przyjęto |
|---|---|---|
| A3 | Profil bala (pióra, wpust, fazy) | domyślnie bal prosty; pełny profil: 2 pióra 8 × 7 w rozstawie 20, wpust 9 × 8 (luz 1), pierwszy wieniec bez wpustu, bez faz – do potwierdzenia zdjęciem czoła bala z miarką |
| A5 | Kiedy ostatek 200 | parametr wspólny dla domu + osobno na każdym końcu ściany (widok ściany) |
| D1 | Działowa niższa: góra i dopełnienie | tylko pod stropem / antresolą / półką; góra 2500 (17 wieńców, jak 1100 W-6) albo z ustawienia ściany, szablon ze stropem 2780 (20 wieńców, jak 1200); odcinki ostatek + 44 + 100 przy każdej wyższej ścianie, do jej góry |
| D2 | Węgły ręczne a automat | pierwsza zmiana w widoku przepisuje węgły ściany na listę ręczną (automat ściany wyłączony); węgieł bliżej niż 300 od skrzyżowania pominięty |
| T1 | Pola w trybie Podstawowe | 25 z 75 (preset, profil, wieńce, ostatek, kalenica, strop, maks. bal, łączenia, węgły, szczyty, dach, podłoga, okna, drzwi) – lista do korekty |
| C9 | Układ łączeń | na przemian (1200); para (900 W-2) i jeden węgieł w opcjach |
| W1 | Limity 4800 / 3700, próg 3000 | z projektów 1800, 1200, 1100 – do potwierdzenia z praktyką |
| W2 | Rozmieszczenie węgłów | równo; od narożników (1000) w opcjach |
| S1 | Gdzie stoi płatew ścienna 60 × 200 (900) i wysokość linii dachu | przy licu wewnętrznym, wierzch płatwi 69,5 nad ścianą okapową; oba parametry |
| S2 | Wierzch płatwi a skos dachu | **rozstrzygnięte (runda 5)**: płatew podniesiona, wierzch ścięty do płaszczyzny dachu (`platwie_sciecie`) |
| S3 | Krokwie przy szczycie | z obu stron (domyślnie); od wewnątrz / od zewnątrz / na szczycie w opcjach |
| S4 | Kawałek bala szczytu między płatwią a skosem | **rozstrzygnięte (runda 5)**: zostaje osobnym kawałkiem, jak 21-140, 22-186, 23-233 w 1100 W-2 (płatew 180 przecina bal 139 na całej wysokości); pozostałe bale szczytu w całości ze skosem |
| P1 | Obciążenia podłogi | 2,0 kN/m² użytkowe + 0,5 stałe, C24, L/400 zalecane, L/250 dopuszczalne |
| P2 | Legar a podwalina | legary między podwalinami, wierzch równo (900); wyższy legar – podpowiedź |
| H20 | Grupy w Dokumentacji 2D | belki – jej kody (P, K, Pd, L, Pw); bale Bs, Kf, Sz – dopisać w Dokumentacji 2D |
| H21 | Producent / CNC: co dostaje, BVN czy BTLx | zestawienie CSV (pozycja, długość, ilość, m³); pliki CNC – do ustalenia |
| R1 | Dach: generator czy wtyczka dachów (KROK 2) | **rozstrzygnięte (runda 5)**: płatwie z generatora, krokwie i dalsza więźba z aplikacji do dachów (`dach_wiezba`); krokwie z generatora w opcji |
| R2 | Ustawienia KROKU 2 z generatora | `API.wiezba` z oknem zapisuje je w aplikacji jako ostatnie (kierunek w górę, bez płatwi kalenicowej i zamków dolnych, krokiew 50 × 150, rozstaw 900, klasa drewna, poszycie) – przy zwykłym dachu w tej aplikacji trzeba je przestawić (prośba o `:zapisz => false` dla okna – zadanie, część 2) |
| R3 | Same płatwie a aplikacja do dachów | **runda 6**: przy „Krokwie i poszycie – kto je buduje” = aplikacja także dom na samych płatwiach (domyślny, jak 900) dostaje połacie i KROK 2 bez krokwi – poszycie na płatwiach; bez poszycia – „generator” |
| R4 | Poszycie na start KROKU 2 | deskowanie pełne 25 × 100, szczelina 3, długość 4000 – tak; nadbitka 19 × 121 / 4000 i OSB 18, 2500 × 1250, szczelina 3 – nie (wartości jak domyślne w aplikacji); grubość desek na płatwiach co ≤ 1000 – do potwierdzenia (wytyczne aplikacji) |
| R5 | Płatew kalenicowa jako podpora | wierzch podany 1 mm pod grzbietem – aplikacja 3.7.0 punkt na samej kalenicy przypisuje do jednej połaci albo żadnej (zadanie, część 2) |
| L1 | Luzy stolarki | boczny 10, górny = wysokość × 1,5 % (w górę do 5), nie mniej niż 10 |
| J1 | Dach jednospadowy | spadek w stronę mniejszych współrzędnych, okap za ścianą wysoką 500, najcieńszy górny bal ściany wysokiej 30 |
| T2 | Taras jak 1100 | 2 górne wieńce, słupy 120 × 120 co ≤ 2000, wejście 1200 pośrodku, balustrada 4 bale i przekładki 300 (prześwit ≤ 600), dolne bale ścian bocznych 100 za licem ściany domu |
| T3 | Taras jak 1200 | ściany boczne pełne do frontu, front otwarty – bez słupów i listew pionowych z projektu (osłona z listew 45 × 45 – do decyzji) |
| Z1 | Drewno w zamku przy skosie | co najmniej 20 mm nad gniazdem, inaczej bal kończy się przy licu ściany poprzecznej |
| P3 | Płatwie na pełnym balu | obniżenie dachu ≤ 60, przesunięcie pośredniej ≤ 150, pasek pod gniazdem ≥ 20 albo 0 |
| P4 | Zamek płatwi | wrąb 5 z boku, 8 od spodu (zalecane 5–10), luz 1 wzdłuż |
| F1 | Fundamenty punktowe | 400 × 400, wysokość 400, rozstaw ≤ 2500 (dom 5 × 7: 3 × 4 rzędy), skrajne licem z obrysem |
| T4 | Słupy tarasu | lico z licem ścian, zamek górny 150, dolny 100 (najwyżej wysokość podwaliny) |
| B1 | Podbitka | 19 × 121, długość 4000; na krokwiach / na samych płatwiach z aplikacją – nadbitka KROKU 2 |
| W3 | Węgły symetryczne | ściana równoległa o tym samym zasięgu – te same miejsca; „równo” – punkty równego podziału, gdy nie zwiększa liczby węgłów |
| O1 | Wypuszczone wieńce okapowe | 2 górne wieńce, do wysunięcia płatwi za szczyt (500); węgły pod okapem do nawisu – opcja (3 górne bale) |
| T5 | Balustrada z wieńców | do 1000 mm, zakładka 100 w narożnikach frontu |
| T6 | Trójkątny wieniec | przekrój płatwi (80 × 200) albo podany (80 × 160) |
| W4 | Węgły pod płatwiami | na szczytach zewnętrznych i ścianie domu przy tarasie (domyślnie), pod każdą płatwią albo tylko pod kalenicową; **runda 11**: bez luki – dach / płatew dopasowane do bala węgła, węgieł w osi płatwi ją podpiera (luka zostaje tylko przy „Płatwie oparte na pełnym balu” = nie albo wyczerpanych limitach dopasowania) |
| W5 | Węgieł na wolnym końcu | od wolnego odcinka 1000 mm (parametr), oś 122 mm od końca (ostatek 100) |
| T7 | Wiązar nad tarasem | słupek 120, zastrzał 100 (opcja), na balach frontu (domyślnie) albo na słupach; **runda 10**: pod płatwiami, gniazdo płatwi ≥ 20, zastrzały 45° |
| L2 | Dach domu L | **rozstrzygnięte (runda 10)**: dwa dachy z koszem; skrzydło główne = większa rozpiętość (równe – parametr „kalenica”); płatwie skrzydła bocznego do kosza albo na styk do płatwi dachu głównego – podparcie ich końców (belka koszowa?) do potwierdzenia z praktyką |
| L3 | Wspólny poziom okapu w domu L | linia dachu obu skrzydeł na tej samej wysokości; ściany okapowe skrzydła bocznego (wyższe o pół bala) – górny bal ścięty do dachu |
| P5 | Poziom podciągu | **rozstrzygnięte (runda 10)**: na wysokości podwalin (legary dzielone); obniżony w opcji |
| T8 | Łączenie na styk | **rozstrzygnięte 2026-11-25 20:26**: „można na styk z przesunięciem o 300 mm” – wieńce szczytów ścian domu jak front tarasu (runda 11), wykonane w rundzie 15 (`szczyt_styk`, `rdzen/styki_szczytu.rb`); pół zamka w ostatnim połączeniu pod dachem – kod w rundzie 15 (`polzamek`, wyłączony do akceptacji rysunku) |
| T9 | Słup w osi kalenicy | domyślnie tak; słup wejścia bliżej niż 500 od osi staje w osi (wejście szersze / węższe) |
| T10 | Zamek płatwi nad szczytem tarasu | domyślnie tylko od spodu (wrąb 8–10 na grubości trójkąta), boczne w opcji |
| D1a | Obciążenia dachu do doboru | śnieg gruntu 0,9 kN/m² (strefa 2), pokrycie z poszyciem 0,35 kN/m² połaci, ugięcie L/200, drewno jak podłoga (C24) – do potwierdzenia dla miejsc, gdzie stoją domy |
| D1b | Lista przekrojów płatwi | 60×100 … 160×280 z wykazu „od ręki” (Nsi / DUO / BSH) z 2026-11-14, bez długości handlowych (długości – runda 12 razem z katalogiem legarów) |
| D1c | Dobór domyślnie | ręcznie ze sprawdzeniem (jak dotąd przekroje z pól); automatyczny – wybór użytkownika |
| Z1 | Linia załamania bocznego zadaszenia | nad licem zewnętrznym ściany okapowej (płatew ścienna na ścianie, szersza niż ściana – nad jej krawędzią); dach domu do niej bez zmian |
| Z2 | Płatwie zadaszenia | jeden przekrój (80 × 160), wierzch ścięty do połaci, rozstaw jak płatwie dachu (≤ 1000), pierwsza przy samej ścianie w gniazdach ostatków ścian szczytowych; **runda 13**: przekrój dobierany albo sprawdzany (Z6) |
| Z3 | Zadaszenie na słupach | słup 120 × 120 co ≤ 2500 (skrajne w osiach szczytów), na fundamencie punktowym; belka poprzeczna 80 × 160 na słupie do ściany domu (oparta, bez gniazda – osiadanie); oczep na belkach, płatwie na słupkach |
| Z4 | Przybudówka z bali | dawna ściana okapowa – działowa o wysokości ściany okapowej (bez „do dachu”), ściana przybudówki ścięta do połaci; podłoga także pod przybudówką |
| Z5 | Łaty przy załamaniu (aplikacja 3.12) | po obu stronach łata przy linii załamania (górne krawędzie w dwusiecznej); nad załamaniem jak od okapu (nakładka i podwójna łata jak przy okapie), pod załamaniem pojedyncza; pełne moduły pod załamaniem – okap zadaszenia wydłużany 0…1 moduł |
| Z6 | Dobór przekrojów zadaszenia | domyślnie automatycznie; listy: belki jak płatwie (60×100 … 160×280), słupy 100×100 … 200×200; obciążenia jak dach (śnieg 0,9, pokrycie 0,35) przy kącie zadaszenia, ugięcie L/200 |
| Z7 | Krokwie zadaszenia | jeden przekrój krokwi całego dachu (KROK 2 aplikacji ma jeden przekrój); dobór krokwi domyślnie z wyboru (stare domy bez zmian), lista 45×145 … 80×240 |
| Z8 | Podłoga w przybudówce | domyślnie tak; bez podłogi – podwaliny i fundamenty pod ścianami przybudówki, legary do dawnej ściany okapowej |
| Z9 | Podparcie płatwi zadaszenia w przybudówce | tylko ściany szczytowe – przęsło = długość domu (duże przekroje przy długich domach); słupki / węgły pod płatwiami w przybudówce albo jej działowe – do decyzji |


## Runda 18 – przyjęte bez pytania (do potwierdzenia)

| Nr | Temat | Przyjęte |
|---|---|---|
| R18-1 | Prosty model okna i drzwi | fabrycznie tak; rama 68 na grubość ściany, szyba 4 mm / skrzydło 40 mm, maskownice 95 × 20 od zewnątrz z zakładką 15 na ramę (okno z 4 stron, drzwi z 3); otwór bez typu: drzwi, gdy spód stolarki = 0 |
| R18-2 | Przełącznik doboru w typach wbudowanych | Typ 100, 200 – podaję sam; Typ 300, 400 – automatycznie (płatwie i krokwie) |
| R18-3 | Dom L – koniec płatwi skrzydła w koszu | słupek na najbliższej niższej płatwi dachu głównego (przekrój: szerokości obu płatwi); odstęp < 20 mm – płatew leży na płatwi głównej; styk z płatwią główną – wieszak; słupek i oparcie – 2 kątowniki |
| R18-4 | Taras typu 300 | fabrycznie front ze szczytem (górne wieńce nad otworem, szczyt jak typ 200), bez słupów pod frontem |
| R18-5 | Płatwie dłuższe niż w magazynie | fabrycznie dzielone nad ścianą na styk w osi ściany (bez zakładu); tylko płatwie dachu |
| R18-6 | Działowe bliżej niż grubość bala | jedna ściana w miejscu dłuższej, z ostrzeżeniem (dwie ściany w tym miejscu są niewykonalne) |
| R18-7 | Kanały na przewody | Ø 25 (w modelu kwadrat 25 × 25 w osi bala), puszka 300 od spodu ściany, otwór puszki Ø 68 tylko na liście (od strony wnętrza), odstęp od lica ściany poprzecznej ≥ 60 |
