# Stan prac – ArteMadera Generator Wieńcowy

Stan na: runda 17, kompilacja 17 (2026-11-27), wersja 1.0.0. Poprzednio: runda 16, kompilacja 16 (2026-11-26).
Testy: `bash testy/uruchom.sh` – 37 zestawów (nowe `t_stolarka`, `t_wycena`), ok. 2360 sprawdzeń, FAILURES 0; zestaw
„Ruby 2.7.8” pominięty (brak Rubiego 2.7 w sesji – kontrola zasad Ruby 2.2 przechodzi). Poza zestawem: 600 losowych domów
(6001–6600) i 300 złożonych (10001–10300) – styki bez zamka 8 → 0, poza tym bez nowych problemów. Znane sprzed rundy
w 6001–6600: 6110, 6269 (bal 0,04–0,15 mm nad połacią), 6305, 6557 (krawędź bryły szczytu < 0,1 mm), 6311, 6410, 6430 (dwie
działowe narysowane kilkadziesiąt mm od siebie), 6444 (płatew a bale), 6495, 6528 (dom L z podbitką na płatwiach – §8);
spoza zakresu: 94, 153, 8068, 9015, 9087, 7004, 7021. Aplikacja do dachów bez zmian (3.12.0).

Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`, historia rund 1–17).
Dysk użytkownika: `C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\` (kod, dokumenty, paczka `.rbz`,
od rundy 14 także `raporty\` – raporty z testu działania i dziennik pracy zapisywane przez wtyczkę).

Ten plik to stan bieżący. Historia (nowości kompilacji 7–13, przebieg rund 1–13, moduły) – `docs/historia_rund.md`;
wartości przyjęte bez pytania – `docs/pytania_otwarte.md`; zasady konstrukcji – `docs/specyfikacja.md`.

## 1. Nowe w kompilacji 17 (polecenie z 2026-11-27 18:59 – `docs/prompt_r17.md`; odpowiedzi na pytania rundy 16 nie przyszły)

- **Odpowiedzi z rundy 16 – brak.** W poleceniu wszystkie pięć odpowiedzi zostało „…”; pytania zadane od razu (z rysunkiem
  działowej i zrzutem obu układów okna `docs/uklady_okna_r17.png`), do końca rundy bez odpowiedzi. Przyjęte: oba układy okna
  zostają (nic nie usunięte), działowa dochodzi wyżej (zasada „styk zawsze w zamku”), typy bez zmian, modele stolarki –
  mechanizm gotowy pod format z pytania 4. Folderu `raporty\` na dysku nie było – kompilacja 16 nie była uruchamiana.
- **„Standard warsztatu” z menu i paska** (`sketchup/sterowanie.rb#standard`, `sketchup/menu.rb`, `sketchup/pasek.rb`,
  ikona `ikony/standard.*`, `html/standard.js#samodzielnie`): okno z samym panelem standardu – bez zaznaczania linii
  ani domu, bez podglądu; „Zapisz standard” zostawia panel otwarty z komunikatem, „Zamknij” zamyka okno. Pasek ma cztery
  przyciski.
- **Styk bali zawsze w zamku – dwa pozostałe miejsca** (rysunek `docs/styk_w_zamku_r17.png`; 600 losowych domów
  6001–6600: styki bez zamka 8 → 0):
  - *Węgieł pod płatwią w gnieździe* (`rdzen/bale.rb#bez_platwi_nad`): w domu L płatew ścienna skrzydła bocznego leży
    w gnieździe górnego bala ściany (niżej niż góra ściany), a płatew dachu głównego przechodzi czasem przez ścianę
    w miejscu węgła – węgieł kończył się wieniec niżej. Teraz dochodzi do spodu płatwi (płatew leży na węgle), gdy bal
    ściany nad nim zachowuje między gniazdem zamka a gniazdem płatwi co najmniej `zamek_min_drewno`. Rozpoznanie z rundy 16
    („ściana szczytowa nad końcem węgła”) było nietrafne – to ściana okapowa skrzydła domu L (ziarna 6093, 6280, 6324, 6392).
  - *Działowa pod podbitką „pod płatwiami”* (`rdzen/podbitka.rb#dzialowa_do_polaci!`, `#linia_dzialowej`,
    `#dzialowe_do_polaci`; `rdzen/pod_dachem.rb#linia`): działowa, na której łączą się bale ściany okapowej, przy tej
    ścianie sięga do wierzchu bala pod jej najwyższym wieńcem (nie wyżej niż połać), dalej kończy się pod deskami jak
    dotąd; deski podbitki przerwane na działowej tylko na tym odcinku (ok. 30 cm). Ziarna 6057, 6134, 6492, 6541.
- **Okna, drzwi i węgły kliknięciem w widok ściany** (`html/klik_sciana.js`, zrzut `docs/klik_okno_r17.png`): nad widokiem
  przełącznik „Klik w widok wstawia: węgieł / okno / drzwi”; kliknięcie otwiera okienko przy miejscu kliknięcia – typ
  z listy stolarki, szerokość, wysokość, spód, „od” (środek otworu w miejscu kliknięcia), luz górny, nazwa; „Wstaw” /
  „Anuluj”. Kliknięcie w otwór – okienko poprawy („Zapisz” / „Usuń”), przy węgle – „od” węgła („Zapisz” przesuwa) i „Usuń”.
  Węgieł ma pierwszeństwo przed otworem (wąski cel). Widok podaje punkt odniesienia `ref` i wiersz tabeli otworu.
- **Lista typowej stolarki w standardzie** (`stolarka` – pierwsze pole-tabela, `rdzen/parametry_tabela.rb`, `html/tabela.js`):
  symbol, rodzaj, szerokość, wysokość, spód, model; fabrycznie O1 1020 × 1010 (900) i D1 930 × 2100. Zastępuje sześć pól
  „Nowe okno / nowe drzwi” (dawne wartości przechodzą do O1 i D1). Tabela otworów ma kolumnę „Typ” (wybór typu wpisuje
  wymiary), pod nią „+ dodaj z listy”, „+ okno”, „+ drzwi” (pierwsze z listy).
- **Modele okien i drzwi w otworach** (`rdzen/stolarka_modele.rb`, `sketchup/stolarka_modele.rb`): pole `stolarka_folder`
  (folder modeli); otwór z typem dostaje przy generowaniu komponent z pliku `<model>.skp` albo `<symbol>.skp` – punkt 0
  w dolnym lewym narożniku stolarki od zewnątrz, X wzdłuż szerokości, Y w głąb ściany, Z w górę; grupa i tag „Stolarka”;
  brak pliku – sam otwór i zdanie w komunikacie, model innej wielkości niż stolarka – uwaga.
- **Działowe w domu z wymiarów** (`html/dzialowe.js`, `rdzen/dom_z_wymiarow.rb#osie_dzialowych`): karta „Ściany działowe”
  w kroku „Ściany” (tylko dom z wymiarów): kierunek, oś od lica, początek, długość (puste – od lica do lica); zapis w domu.
- **Magazyn drewna – jedna tabela** (`rdzen/magazyn_drewna.rb`, pole `magazyn_drewna`, sekcja „Magazyn drewna, dobór
  przekrojów i ceny” w kroku „Zestawienie”): przekrój, długości [m], rodzaj (C24, Nsi/KVH, DUO/TRIO, BSH, deska), znaczniki
  „do czego” (legar/podciąg, płatew, krokiew, belka zadaszenia, słup, deska), cena za m³. Fabrycznie wykaz Drewno Partner
  (33 wiersze z deską 14 × 115 × 4 m). Zastępuje pięć list tekstowych – dawne listy z ustawień i modeli przechodzą do
  magazynu. Pola przekrojów w oknie podpowiadają przekroje z magazynu (lista przy polu).
- **Jeden przełącznik doboru** (`przekroje_dobor`: podaję sam / dobieraj automatycznie; `Parametry.dobor`): pola doboru
  płatwi, krokwi, legarów i zadaszenia mają fabrycznie „jak przełącznik”, inna wartość – wyjątek elementu. Fabrycznie
  „podaję sam”. **Zmiana:** legary i zadaszenie do kompilacji 16 dobierały się same – teraz też „jak przełącznik”
  (pytanie w §6). Okno rozwiązuje „jak przełącznik” przy polach zależnych (`html/zalezne.js#wartosc`).
- **Dobór w całej długości** także dla krokwi (od okapu do kalenicy), legarów (najdłuższe przęsło) i podpowiedzi
  podciągu (`DlugosciHandlowe.najpierw_w_calosci`, `#w_calosci?`).
- **Wycena materiału – W3** (`rdzen/wycena.rb`, `html/wycena.js`): bale (`cena_bala` zł/m³), belki według przekroju
  z magazynu (zł/m³), deski poszycia i podbitki ze sztuk × wiersz „deska” magazynu, reszta z cennika
  (`cennik_materialow`: początek nazwy pozycji, jednostka, cena). W kroku „Zestawienie” tabela z sumą i pozycjami bez ceny,
  w „Wynik” liczba „Materiał”, w CSV blok „Wycena”. Ceny fabrycznie puste. Fundamenty punktowe poza wyceną drewna.
- Parametrów: 193 (nowe: `stolarka`, `stolarka_folder`, `przekroje_dobor`, `magazyn_drewna`, `cena_bala`, `cennik_materialow`;
  usunięte: `okno_szerokosc`, `okno_wysokosc`, `okno_parapet`, `drzwi_szerokosc`, `drzwi_wysokosc`, `przekroje_katalog`,
  `platwie_katalog`, `krokwie_katalog`, `zadaszenie_katalog`, `zadaszenie_slupy_katalog`).

## 2. Co potrafi generator (skrót)

- **Rysunek**: obrys = lico zewnętrzne, linie w środku = osie działowych, krótka linia w poprzek ściany = węgieł;
  zaznaczona ściana (prostokąt); scalanie linii, dociąganie końców, dowolny obrót; obrysy wielokątne (L, T, U, Z, krzyż, H);
  działowa w linii ściany obrysu.
- **Ściany i bale**: zamek 44 × 146 na każdym skrzyżowaniu, ostatki, numeracja jak producent; półbal na ścianach wzdłuż
  kalenicy; łączenie bali (na przemian / para / jeden węgieł, mijanka ≥ 300, styk wspólny w zamku działowej); węgły
  usztywniające, narysowane, z tabeli, ręczne w widoku ściany, pod płatwiami, na wolnym końcu, symetryczne; działowa
  niższa pod stropem z dopełnieniem zamka; pełny profil bala do wizualizacji; okna i drzwi ze stolarką i luzami.
- **Szczyty i dach**: dwuspadowy, jednospadowy, dom L (dwa dachy z koszem); płatwie ścięte do dachu, na pełnym balu,
  z zamkami; ściana nośna zamiast płatwi ściennej; krokwie z generatora albo krokwie i poszycie z aplikacji do dachów
  (połacie, podpory, KROK 2); podbitka; wypusty okapu.
- **Taras** (typ 200 na słupach z balustradą, typ 300 ściany pełne) z trójkątem nad tarasem; **boczne zadaszenie**
  (wiata na słupach albo przybudówka z bali) z załamaniem dachu.
- **Podłoga**: podwaliny, legary, podciągi, fundamenty punktowe; statyka podłogi, płatwi, krokwi, zadaszenia i trójkąta
  z podpowiedziami; dobór przekrojów z list hurtowni z długościami; słupy tarasu krótsze o osiadanie ścian.
- **Okno**: kroki w kolejności budowy z rzutem i uwagami na widoku (obok – dawny układ z zakładkami, do wyboru), typy
  domów i standard warsztatu (też z menu), pola-tabele (lista stolarki, magazyn drewna), widok ściany z okienkiem
  wstawiania okien, drzwi i węgłów, działowe domu z wymiarów, zestawienie CSV z materiałami i wyceną.
- **Model**: Dom > W-n / Podłoga / Dach / Taras / Zadaszenie / Stolarka > komponenty z atrybutami Dokumentacji 2D, tagi; przebudowa
  z zachowaniem położenia, jedno „Cofnij”, wykrywanie ręcznych zmian.
- **Narzędzia**: pasek narzędzi i menu pod prawym przyciskiem, kontrola domu, test działania z raportem, dziennik pracy.

## 3. Jak to działa

Opis zasad: `docs/specyfikacja.md`, wszystkie parametry: `docs/parametry.md`. Mapa kodu: `docs/SPIS_TRESCI.md`.
Przebieg: `rdzen/projekt.rb#oblicz` (obrys z tarasem → ściany → ustawienia ścian z widoku → role ścian tarasu →
szczyty → otwory → styki → węgły → dopełnienie niższych działowych → gniazda płatwi → bale pod dachem → bale →
balustrada → bale ścięte dachem przy narożnikach → zamki → profil → pozycje → belki dachu, słupy tarasu i podłoga →
połacie dla aplikacji do dachów → długości handlowe); wyjątek w obliczeniach → plan z komunikatem (`rdzen/awaria.rb`).
Po budowie domu `sketchup/dach_aplikacja.rb` (połacie, podpory i KROK 2 przez API aplikacji – ustawienia i podpory
z `rdzen/krok2.rb`) i wpis do dziennika pracy.

## 4. Zasady (stałe)

- Jeden temat = jeden plik; nagłówek pliku (Plik, Zadanie, Tematy, Zależy od, Używają); komentarz nad każdą metodą
  i funkcją JS; plik > 450 wierszy – podział (> 700 – błąd kontroli).
- `docs/SPIS_TRESCI.md` i `docs/parametry.md` tylko z generatorów, kontrola aktualności w testach.
- Rdzeń bez API SketchUpa; API tylko w `sketchup/`. Ruby 2.2 (testy także na Ruby 2.7.8 – `testy/ruby27.sh`), JS ES5,
  `Log`, zero placeholderów.
- Co tylko można – parametr: jeden wpis w `rdzen/parametry_lista.rb` (okno, zapis i szablony – same).
- Numer kompilacji = numer rundy, ten sam w rejestratorze i `main.rb`.
- Grupy domu, ścian, podłogi i dachu bez roli Dokumentacji 2D (rola „skip” na grupie wyłącza zawartość).
- Błąd znaleziony losowym domem → ziarno dopisane do `testy/t_losowe.rb` albo `testy/t_zlozone.rb` (regresja).
- **Zaległości przed nowymi funkcjami (od r14)**: każda runda zaczyna od kolejki z §5 – najpierw poprawki błędów
  i decyzje, które już zapadły, potem nowe prośby. Decyzja przeniesiona na kolejną rundę musi mieć w §5 powód.
- **Raporty z dysku na starcie rundy (od r14)**: najnowszy `raporty\raport_*.json` (pole `wynik`, czasy budowy)
  i `raporty\dziennik_pracy.jsonl` (czasy z prawdziwej pracy, zmienione ustawienia, awarie) – przed planowaniem rundy.
- Poprawka „usuwa wyjątek” nie wystarcza – po niej pełne sprawdzenie geometrii (`LosoweDomy.sprawdz`: kolizje w zamkach,
  ściany równoległe, bryły zamknięte), bo wyjątek bywa objawem błędnej geometrii (lekcja z r14).

## 5. Kolejka decyzji użytkownika (co zapadło i czeka na wykonanie)

| Decyzja | Kiedy | Stan | Runda |
|---|---|---|---|
| Układ okna: nowy (kroki) albo dotychczasowy (zakładki) – „chcę mieć możliwość porównania obu, a w późniejszym czasie zostaniemy przy jednym” | 2026-11-25 | oba w kompilacjach 16–17; **czeka na wybór** (odpowiedź w poleceniu rundy 17 pusta) – potem drugi układ, `html/tryb.js` i cecha `podstawowy` do usunięcia, `t_okno.js` na układ wybrany | 18 |
| Modele okien i drzwi użytkownika | 2026-11-25 | mechanizm gotowy w r17 (folder `stolarka_folder`, plik `<symbol>.skp`); **czeka na modele** i odpowiedź, w jakiej są postaci | 18 |
| Działowa pod stykiem przy podbitce pod płatwiami – „ma dochodzić do połaci jak węgieł?” | 2026-11-26 | zrobione wariantem „przy ścianie okapowej działowa pełnym balem” (zasada „styk zawsze w zamku”); **do potwierdzenia** na rysunku `docs/styk_w_zamku_r17.png` | 18 |
| Przełącznik doboru przekrojów – fabrycznie „podaję sam” czy „automatycznie” (do k16 legary i zadaszenie same) | – | fabrycznie „podaję sam”; **pytanie** w §6 | 18 |
| Propozycje po rundzie 14: P2, P3, P5 (18), N1, N4, N5, W4, W5 (dalej); N3 – kanały na przewody | 2026-11-25 21:42 | N3 przeniesione z r17 na 18 (polecenie rundy 17 go nie wymieniało) | 18+ |
| Dom T, U, krzyż: kalenica z dachu o większej powierzchni, skrzydeł dowolnie wiele | 2026-11-14 | osobna runda, razem ze wzorem dobudówki (N4) | po 18 |
| Repozytorium prywatne | 2026-11-25 | do zrobienia przez użytkownika w ustawieniach GitHuba (`docs/przekazanie_r14.md` §5) | – |

Wykonane w rundzie 17: menu i przycisk „Standard warsztatu”, styk zawsze w zamku (węgieł do spodu płatwi, działowa przy
ścianie okapowej), okna / drzwi / węgły kliknięciem z okienkiem, lista stolarki, modele w otworach, działowe w domu
z wymiarów, magazyn drewna, jeden przełącznik doboru, dobór w całej długości, wycena (W3).
Wykonane w rundzie 16: pół zamka fabrycznie i poza narożnikiem, węgieł ze stykami do połaci, jedno pole położenia desek,
trzy poziomy ustawień z typami domów i standardem warsztatu, okno z krokami i wynikiem na widoku (obok dotychczasowego),
opcje wyszarzone dla obrysu, S1 (dom z wymiarów), W1 (powierzchnie i limity).
Wykonane w rundzie 15: T8 (szczyty na styk), deski 14 × 115 × 4000 z nadbitką fabrycznie, 45 × 120 w 5,4 / 6 m, P1 (słupy
krótsze o osiadanie), W2 (zestawienie materiałów), tabela podziału pól i szkic okna.

## 6. Pytania do użytkownika (krótka lista)

Pełna tabela wartości przyjętych bez pytania – `docs/pytania_otwarte.md`. W rundzie 17 odpowiedzi nie przyszły (pytania 1–5
powtórzone).

1. **Układ okna**: zostajemy przy nowym (kroki) czy dotychczasowym (zakładki)? Zrzut obu: `docs/uklady_okna_r17.png`.
2. **Działowa pod stykiem** (podbitka pod płatwiami): czy wariant z rysunku `docs/styk_w_zamku_r17.png` (działowa przy
   ścianie okapowej pełnym balem, deski przerwane na ok. 30 cm) jest dobry?
3. **Typy domów**: Typ 100–400 wystarczą, czy dodać typy z projektów 900, 1100, 1200, 1800 (S2)?
4. **Modele okien i drzwi**: czy są? Folder i nazwy plików (generator szuka `<symbol>.skp` albo nazwy z kolumny „Model”).
5. **Uwagi z SketchUpa** do kompilacji 16 / 17.
6. **Przełącznik doboru przekrojów**: fabrycznie „podaję sam” (płatwie i krokwie jak dotąd; legary i zadaszenie do k16
   dobierały się same) – zostaje, czy fabrycznie „dobieraj automatycznie”?
7. Starsze: Z9 (przybudówka – podparcie płatwi), D1a (strefy śniegowe), H21 (co dostaje CNC), nazwy okuć do zestawienia.

## 7. Odbiór

`docs/scenariusz_odbioru.md` – trzy kroki: instalacja, przycisk „Test działania”, zwykła praca. Raport i dziennik pracy
zapisują się same w `raporty\`. Na starcie rund 16 i 17 folderu `raporty\` nie było – **kompilacje 14–16 nie były
uruchamiane w SketchUpie**; wszystko od rundy 14 (pasek, menu pod prawym przyciskiem, raport, szczyty na styk, zestawienie,
pół zamka, typy, okno krokami, okienko kliknięcia, modele stolarki, magazyn, wycena) jest sprawdzone tylko na atrapie API
i w Chromium.
Dawny scenariusz z 59 krokami – `docs/scenariusz_archiwum.md`.

## 8. Ograniczenia (kompilacja 17)

- Styk bez zamka: w 600 losowych domach nie ma żadnego (ostrzeżenie zostaje na nieprzewidziane przypadki). Działowa
  pod stykiem przy podbitce pod płatwiami sięga wyżej przy ścianie okapowej; deski przerwane tylko przy domu prostokątnym
  z deskami z generatora. Szczyt na styk (runda 15): tylko szczyt skośny ściany domu; w szerokim szczycie bez węgłów nic nie
  usztywnia wieńców szczytu poza płatwiami.
- Pół zamka: tylko dla bala, który w zamku ma pod dachem co najmniej 20 mm. Cieńszy: w narożniku jest dalej ucinany
  przy ścianie poprzecznej, w środku ściany (klin szczytu nad węgłem albo działową) dostaje zwykłe gniazdo jak do
  kompilacji 15 (gniazdo przecina klin). Węgieł ze stykami przy podbitce
  pod płatwiami przechodzi przez deski – deski kończą się 2 mm od węgła (docinka na budowie); przy podbitce pod krokwiami
  węgieł kończy się pod deskami jak dotąd.
- Poziomy i typy: typ pamięta tylko pola „Typ domu” i „Ten dom” – pola standardu z dawnych szablonów nie są w typach
  (ostatnie parametry stały się standardem); przy dwóch przekrojach bala (dziś jeden) wymiary zamka w standardzie byłyby
  wspólne. Dom zapisany przed rundą 16 nie ma typu – okno porównuje go z ostatnio wybranym typem. Standard warsztatu
  otwiera się z okna generatora, z menu i z paska.
- Okno: dwa układy naraz (nowy i dotychczasowy) do czasu wyboru użytkownika; w nowym uwaga bez rozpoznanego pola prowadzi
  tylko do kroku (tabela wzorców `rdzen/uwagi_pola.rb`); ostrzeżenia o otworach prowadzą do kroku „Okna i drzwi”, nie do
  wiersza tabeli. Układ nowy sprawdzony w Chromium 1060 × 860 – w prawdziwym oknie SketchUpa jeszcze nie.
- Okienko kliknięcia: wstawia w ścianę widoczną w widoku; „od” węgła liczone jak „od” otworu (od narożnika lica
  zewnętrznego). Węgieł z tabeli węgłów poprawia się w tabeli (okienko przesuwa węgły ręczne ściany).
- Modele stolarki: bez skalowania (model innego wymiaru – uwaga); w działowej strona „zewnętrzna” = prawa strona osi
  (jak lico zewnętrzne ściany obrysu); sprawdzone tylko na atrapie API (`definitions.load` z pliku .skp).
- Magazyn drewna: przekroje fabryczne pól typów spoza magazynu (legar 50 × 100, krokiew 50 × 150, podciąg 100 × 150) zostają
  – przy „podaję sam” dostają podpowiedź najmniejszego wystarczającego z magazynu; w wycenie są „bez ceny”. Rodzaj drewna
  w magazynie to opis (do obliczeń jedna klasa – „Klasa drewna konstrukcyjnego”).
- Wycena: materiał bez robocizny, transportu i pokrycia dachu; deski poszycia z aplikacji do dachów liczone z powierzchni
  połaci (jak w zestawieniu materiałów).
- Dom z wymiarów: tylko prostokąt w punkcie 0,0 modelu; działowe z tabeli okna (pełne albo z wolnym końcem), węgły – z tabeli węgłów.
- Powierzchnie: pomieszczenia liczone bez węgłów i ostatków, otwory drzwiowe nie łączą pomieszczeń; wysokość do wierzchu
  konstrukcji dachu (bez pokrycia), teren – jedna liczba pod spodem pierwszego bala; „buduj do wysokości” – nie ma.
- Osiadanie: skracane są tylko słupy tarasu; słupy bocznego zadaszenia stoją pod belką opartą na ścianie (bez skracania).
  Okucia regulacyjnego generator nie rysuje – jest w zestawieniu materiałów.
- Zestawienie materiałów: powierzchnia dachu dokładna dla domu prostokątnego, dla obrysu L i innych – w przybliżeniu
  (z dopiskiem); łączniki krokwi tylko dla krokwi z generatora; okucia jako nazwy ogólne (ceny – z cennika materiałów).

- Działowa w linii ściany obrysu: obie ściany łączą się na styk w zamku ściany poprzecznej we wszystkich wieńcach (jak
  „Łączenie przy działowej” = wspólne); bala ciągłego przez ten węzeł generator nie robi. Gdy linia leży między dwoma
  uskokami o ścianach po przeciwnych stronach (obrys Z), działowa bierze oś pierwszej z nich.
- Dwie ściany narysowane bliżej niż długość węgła: generator ostrzega („zajmują to samo miejsce”), nie poprawia.
- Długości handlowe: dobór bierze przekrój dostępny w całej długości dla płatwi, członów zadaszenia, krokwi, legarów
  i podpowiedzi podciągu; trójkąt nad tarasem – sama podpowiedź. Belka dłuższa niż handlowa zostaje w modelu w jednym
  kawałku (łączenia generator nie rysuje).
- Pasek narzędzi, menu pod prawym przyciskiem, okienko po awarii i zapis raportu do folderu sprawdzone tylko na atrapie API.
- Próg „bez zapasu” dla podciągu (90 %) jest stałą w `rdzen/podciagi.rb`, nie parametrem.
- Statyka zadaszenia i krokwi (runda 13) uproszczona jak dachu: bez wiatru (słupy wolnostojące wymagają stężeń), bez
  zsuwania śniegu z wyższej połaci na zadaszenie, krokwie jako belki swobodnie podparte; podpowiedź, nie projekt.
- Boczne zadaszenie: tylko dom prostokątny, dach dwuspadowy, bez tarasu; na całej długości ściany okapowej (bez odcinka
  od–do); w przybudówce płatwie zadaszenia oparte tylko na ścianach szczytowych; zadaszenie na słupach – belka poprzeczna
  w modelu dosunięta do lica ściany (mocowanie z luzem na osiadanie do wykonania na budowie); ścian szczytowych zadaszenia
  na słupach (zamknięcia boku) generator nie robi; podbitka tylko w domu.
- Aplikacja do dachów 3.12: deski poszycia przy załamaniu docięte pionowo, krokwie, kontrłaty i łaty – w dwusiecznej;
  załamanie tylko wklęsłe.
- Tylko ściany pod kątem prostym; linie ukośne – błąd.
- Dach z generatora: obrys prostokątny i L (dwa dachy z koszem); inne obrysy (T, U…) – szczyty liczone każdy osobno,
  dach w aplikacji do dachów (KROK 1 z obrysu). Dach jednospadowy, taras, podłoga, podbitka, fundamenty, podciągi, boczne
  zadaszenie i krokwie z generatora – tylko dom prostokątny (dom L: krokwie i poszycie z aplikacji do dachów); okno
  wyszarza te opcje z powodem (taras, zadaszenie, podłoga, dach jednospadowy, krokwie z generatora).
- Dom L: końce płatwi skrzydła bocznego w dachu głównym bez własnej podpory (belki koszowej generator nie rysuje); gdy
  wysunięcie za szczyt jest mniejsze niż okap, na ścianie wspólnej połać wystaje za szczyt o okap; ściana przez oba
  skrzydła bierze dach tego skrzydła, w którym leży jej środek. Dom L z podbitką na płatwiach i krokwiami z aplikacji:
  podpory pod połacią o grubość deski (14 mm – ziarna 7004, 7021).
- Losowe domy – drobiazgi sprzed rundy 10 (poza zestawem stałym): ziarna 75, 318, 472, 6110 (krawędź 0,025 mm albo bal
  0,04–0,16 mm nad dachem).
- Krokwie z generatora z czołami prostopadłymi do osi, bez poszycia; pełne krokwie i poszycie robi aplikacja do dachów
  (3.7.0 lub nowsza; szczyt zawsze pod krokwiami; dach jednospadowy – okap za ścianą wysoką liczony jak przęsło).
- Taras: przed jedną ścianą szczytową; bez schodów, desek tarasu i osłony z listew; w typie 300 płatwie nad tarasem bez
  podparcia od frontu; słupy tarasu a płatew ścienna na ścianie (ziarno 8064); front bez słupów pośrednich łączony na
  styk w punkcie równego podziału. Balustrada z wieńców ścian tylko w typie 200; trójkątny wieniec tylko przy dachu
  dwuspadowym.
- Pełny profil tylko do wizualizacji: zamki, kolizje, pozycje i listy liczone dla bala prostego; bez faz.
- Działowa niższa: tylko działowe, bez szczytu; strop / antresola to ustawienie – belek stropu generator nie rysuje.
- Węgły ręczne wyłączają automat tej ściany; przesunięty węgieł automatyczny zmienia całą ścianę na węgły ręczne; węgły
  pod płatwiami tylko przy dachu z generatora.
- Statyka podłogi i dachu uproszczona – podpowiedź, nie projekt konstrukcyjny (płatwie jako belki jednoprzęsłowe, bez
  wiatru i worków śnieżnych).
- Dokumentacja 2D nie zna jeszcze grup Bs, Kf, Sz – bale trafią do grupy „Elementy”.

## 9. Plan kolejnych rund

| Runda | Zakres |
|---|---|
| 18 | Odpowiedzi z §6: wybór układu okna i usunięcie drugiego (z poprawkami z prawdziwego SketchUpa), modele stolarki użytkownika, ewentualnie typy 900–1800; potem P2, P3, P5 (podparcie końców płatwi w domu L i tarasie 300, belki dzielone nad podporą, drobne błędy geometrii), N3 – kanały na przewody kliknięciem w widok ściany. Polecenie: `docs/prompt_r18.md`, zakres: `docs/zadanie_r17.md` |
| dalej | Strop i antresola z belek (N1), wzór dobudówki z obrysami T i U (N4), okna dopasowane do wieńców (N2), grubszy bal (N5); Dokumentacja 2D (grupy bali, plan montażu); „buduj do wysokości”; podgląd na żywo po pomiarze |

Na starcie każdej rundy: `raporty\` z dysku (§4), potem kolejka z §5.
