# Stan prac – ArteMadera Generator Wieńcowy

Stan na: runda 18, kompilacja 18 (2026-11-27), wersja 1.0.0. Poprzednio: runda 17, kompilacja 17 (2026-11-27).
Testy: `bash testy/uruchom.sh` – 38 zestawów (nowy `t_kanaly`), ok. 2470 sprawdzeń, FAILURES 0; zestaw „Ruby 2.7.8”
pominięty (brak Rubiego 2.7 w sesji – kontrola zasad Ruby 2.2 przechodzi). Poza zestawem: 600 losowych domów (6001–6600,
od rundy 18 co trzeci z kanałami na przewody) – problemy 10 → 2 (zostały 6305, 6557: krawędź bryły bala szczytu < 0,1 mm),
300 złożonych (10001–10300) – 0. Spoza zakresu znane: 94, 153, 8068, 9015, 9087. Aplikacja do dachów bez zmian (3.12.0).

Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`, historia rund 1–18).
Dysk użytkownika: `C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\` (kod, dokumenty, paczka `.rbz`,
od rundy 14 także `raporty\` – raporty z testu działania i dziennik pracy zapisywane przez wtyczkę).

Ten plik to stan bieżący. Historia (nowości kompilacji 7–13, przebieg rund 1–13, moduły) – `docs/historia_rund.md`;
wartości przyjęte bez pytania – `docs/pytania_otwarte.md`; zasady konstrukcji – `docs/specyfikacja.md`.

## 1. Nowe w kompilacji 18 (polecenie z 2026-11-27 20:20 – `docs/prompt_r18.md`)

- **Odpowiedzi z rundy 17**: 1 (układ okna) – „nie sprawdzałem” → pytanie zadane od razu z zrzutem, do końca rundy bez
  odpowiedzi: **oba układy zostają**; 2 – działowa z rysunku `docs/styk_w_zamku_r17.png` **potwierdzona**; 3 – typy
  100–400 zostają (pomysł „typ + dodatki” – pytanie w §6); 4 – modeli okien i drzwi nie ma, „daj ścieżkę dostępu, to
  da mi możliwość podmiany modeli”; 5 – kompilacja 17 nie była uruchamiana; 6 – przełącznik doboru „oba, zależy od
  konstrukcji”. Folderu `raporty\` na dysku nie było.
- **Ścieżka modelu stolarki i prosty model z generatora** (`rdzen/stolarka_prosta.rb`, `rdzen/parametry_stolarka.rb`,
  `sketchup/okno_sciezki.rb`, `html/sciezka.js`, rysunek `docs/stolarka_prosta_r18.png`): kolumna „Model” listy
  stolarki przyjmuje pełną ścieżkę pliku `.skp` (bez folderu modeli), przy niej i przy „Folder modeli stolarki” przycisk
  „…” (okno wyboru SketchUpa). Otwór bez pliku dostaje prosty model: rama 68 na grubość ściany, szyba (okno) albo
  skrzydło (drzwi), maskownice 95 × 20 od zewnątrz z zakładką 15 na ramę; komponent „Okno 1020 × 1010 (prosty model)”
  w grupie „Stolarka”, rola „skip” dla Dokumentacji 2D, test działania nie liczy go jako drewna. Brak pliku wskazanego
  w liście – prosty model i uwaga. Parametry: `stolarka_prosta` (tak / sam otwór), `stolarka_rama`, `maskownica_*`.
- **Przełącznik „Przekroje konstrukcji – dobór” w typie domu** (`przekroje_dobor`, poziom :typ): Typ 100 i 200 – podaję
  sam, Typ 300 i 400 – automatycznie; własne typy zapamiętują swój wybór.
- **P2 – podparcie końców płatwi**:
  - *Dom L* (`rdzen/podpory_platwi_l.rb`, rysunek `docs/kosz_slupek_r18.png`): płatew skrzydła bocznego, która kończy
    się w koszu (nie trafia na płatew dachu głównego), dostaje słupek (prefiks S, „Słupek pod płatwią”, tag Dach) na
    wierzchu płatwi dachu głównego, nad którą przechodzi najbliżej końca; odstęp < 20 mm – płatew leży na płatwi głównej.
    Płatew kończąca się przy licu płatwi głównej – styk, w zestawieniu „Wieszak płatwi”; słupki i oparcia – „Kątownik
    ciesielski” (po dwa). Statyka płatwi skrzydła liczy przęsło do słupka. Parametr `platwie_kosz` (słupek / bez podpory
    z ostrzeżeniem). W 200 domach L o różnych proporcjach ok. 1/3 końców płatwi skrzydła wypadało w koszu.
  - *Taras typu 300* (`rdzen/taras.rb#front_z_balami?`, `rdzen/taras_szczyt.rb`, `rdzen/styki_tarasu.rb`): front ma górne
    wieńce nad otworem tarasu (jak podciąg typu 200, w zamkach ścian bocznych, od półbala) i szczyt – pełny, ażurowy albo
    pusty z trójkątem na balach; płatwie nad tarasem leżą na szczycie frontu (zamek tylko od spodu jak w typie 200),
    bale frontu łączone na styk z mijanką. Parametr `taras_sciany_front` (szczyt / otwarty – jak do k17).
- **P3 – płatwie dłuższe niż w magazynie dzielone nad ścianą** (`rdzen/podzial_belek.rb`, parametr `belki_podzial`):
  płatew dachu dłuższa niż najdłuższa belka jej przekroju w magazynie drewna dzielona zachłannie na ścianach, przez które
  przechodzi (szczyt, działowa, węgieł) – styk w osi ściany, wręby przeniesione na kawałki, osobne pozycje; bez ściany
  w zasięgu – w całości z podpowiedzią jak dotąd. Zdanie w wynikach („Płatwie … podzielone nad ścianami: 2 styki …”).
- **P5 – drobne błędy geometrii** (regresja w `testy/t_losowe.rb`): 6110, 6269 – bal 0,04–0,15 mm nad połacią
  (`rdzen/sciecie_dachu.rb#sciecie` – ścięcie płytsze niż 0,2 mm pogłębiane do 0,2); 6311, 6410, 6430 – dwie działowe
  narysowane bliżej niż grubość bala łączone w jedną z ostrzeżeniem (`rdzen/dzialowe_bliskie.rb`); 6444 – koniec węgła
  pod bokiem płatwi (4 mm) – gniazdo na pełnej szerokości płatwi (`rdzen/szczyty.rb#gniazda_sciany`); 6495, 6528, 7004,
  7021 – dom L z podbitką na płatwiach: połacie dla aplikacji wyżej o deskę (`rdzen/polacie.rb#dla_domu_l`).
  Zostają 6305, 6557 – krawędzie 0,008–0,07 mm w balach szczytu (§8).
- **N3 – kanały na przewody** (`rdzen/kanaly.rb`, `rdzen/parametry_kanaly.rb`, `html/kanaly.js`; obróbka `kanal`
  w `rdzen/bryla.rb#kanal_pasow` i `rdzen/profil_bala.rb`): czwarta pozycja przełącznika „Klik w widok wstawia: kanał”,
  okienko z „od”, średnicą (puste – 25) i puszką (środek od spodu ściany; fabrycznie 300, puste – bez); kliknięcie przy
  kanale – „Zapisz” / „Usuń”; lista kanałów pod tabelą okien. Każdy bal ściany w miejscu kanału ma pionowy otwór
  (w modelu kwadrat o boku średnicy) w osi grubości – także bale szczytu i pełny profil; bal z puszką ma obróbkę
  „puszka” (otwór Ø68 od wnętrza – tylko na liście, bryła bez zmian). Kanał bliżej niż 60 mm od lica ściany poprzecznej
  (zamek) – pominięty z ostrzeżeniem. Kanały zapisane w domu, w widoku ściany (pomarańczowy pas, kółko puszki),
  w losowych domach od ziarna 6001.
- Parametrów: 205 (nowe: `stolarka_prosta`, `stolarka_rama`, `maskownica_szerokosc`, `maskownica_grubosc`,
  `maskownica_zakladka`, `taras_sciany_front`, `platwie_kosz`, `belki_podzial`, `kanal_srednica`,
  `kanal_puszka_wysokosc`, `kanal_puszka_srednica`, `kanal_odstep_zamka`; `przekroje_dobor` – z standardu do typu).

## 2. Co potrafi generator (skrót)

- **Rysunek**: obrys = lico zewnętrzne, linie w środku = osie działowych, krótka linia w poprzek ściany = węgieł;
  zaznaczona ściana (prostokąt); scalanie linii, dociąganie końców, dowolny obrót; obrysy wielokątne (L, T, U, Z, krzyż, H);
  działowa w linii ściany obrysu; działowe narysowane bliżej niż grubość bala – jedna ściana.
- **Ściany i bale**: zamek 44 × 146 na każdym skrzyżowaniu, ostatki, numeracja jak producent; półbal na ścianach wzdłuż
  kalenicy; łączenie bali (na przemian / para / jeden węgieł, mijanka ≥ 300, styk wspólny w zamku działowej); węgły
  usztywniające, narysowane, z tabeli, ręczne w widoku ściany, pod płatwiami, na wolnym końcu, symetryczne; działowa
  niższa pod stropem z dopełnieniem zamka; pełny profil bala do wizualizacji; okna i drzwi ze stolarką i luzami (model
  z pliku .skp albo prosty z generatora); kanały na przewody (otwór pionowy przez wieńce, puszka).
- **Szczyty i dach**: dwuspadowy, jednospadowy, dom L (dwa dachy z koszem); płatwie ścięte do dachu, na pełnym balu,
  z zamkami, dłuższe niż w magazynie dzielone nad ścianą; dom L – słupki pod końcami płatwi skrzydła w koszu; ściana nośna
  zamiast płatwi ściennej; krokwie z generatora albo krokwie i poszycie z aplikacji do dachów
  (połacie, podpory, KROK 2); podbitka; wypusty okapu.
- **Taras** (typ 200 na słupach z balustradą, typ 300 ściany pełne z frontem ze szczytem) z trójkątem nad tarasem; **boczne zadaszenie**
  (wiata na słupach albo przybudówka z bali) z załamaniem dachu.
- **Podłoga**: podwaliny, legary, podciągi, fundamenty punktowe; statyka podłogi, płatwi, krokwi, zadaszenia i trójkąta
  z podpowiedziami; dobór przekrojów z list hurtowni z długościami; słupy tarasu krótsze o osiadanie ścian.
- **Okno**: kroki w kolejności budowy z rzutem i uwagami na widoku (obok – dawny układ z zakładkami, do wyboru), typy
  domów i standard warsztatu (też z menu), pola-tabele (lista stolarki, magazyn drewna), widok ściany z okienkiem
  wstawiania okien, drzwi, węgłów i kanałów, wybór pliku i folderu („…”), działowe domu z wymiarów, zestawienie CSV
  z materiałami i wyceną.
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
| Układ okna: nowy (kroki) albo dotychczasowy (zakładki) – „chcę mieć możliwość porównania obu, a w późniejszym czasie zostaniemy przy jednym” | 2026-11-25 | oba w kompilacjach 16–18; **czeka na wybór** (w rundzie 18 „nie sprawdzałem”, pytanie bez odpowiedzi) – potem drugi układ, `html/tryb.js` i cecha `podstawowy` do usunięcia, `t_okno.js` na układ wybrany | 19 |
| Modele okien i drzwi użytkownika – „daj ścieżkę dostępu, to da mi możliwość podmiany modeli” | 2026-11-27 | zrobione w r18: pełna ścieżka w kolumnie „Model”, przycisk „…”, prosty model z generatora; **czeka na pliki** użytkownika (sprawdzenie punktu wstawienia) | 19+ |
| Przełącznik doboru – „oba wybory, zależy jakie konstrukcje” | 2026-11-27 | zrobione w r18: przełącznik w typie domu (100, 200 – podaję sam; 300, 400 – automatycznie) | – |
| Działowa pod stykiem (rysunek `styk_w_zamku_r17.png`) | 2026-11-27 | **potwierdzona** | – |
| Typy domów: „zostaw albo opracujmy typy, do których można dołożyć taras, boczne zadaszenie, drewutnię z tyłu, podnieść o pół piętra, poddasze użytkowe” | 2026-11-27 | typy 100–400 zostają; propozycja „typ + dodatki” – **pytanie** w §6 | 19+ |
| Propozycje po rundzie 14: N1, N4, N5, W4, W5 | 2026-11-25 21:42 | P2, P3, P5 (10 z 12 ziaren), N3 zrobione w r18; dalej według §9 | 19+ |
| Dom T, U, krzyż: kalenica z dachu o większej powierzchni, skrzydeł dowolnie wiele | 2026-11-14 | osobna runda, razem ze wzorem dobudówki (N4) | po 19 |
| Repozytorium prywatne | 2026-11-25 | do zrobienia przez użytkownika w ustawieniach GitHuba (`docs/przekazanie_r14.md` §5) | – |

Wykonane w rundzie 18: ścieżka i przycisk „…” dla modeli stolarki, prosty model okna i drzwi, przełącznik doboru w typie,
P2 (słupki w koszu domu L, front ze szczytem w tarasie 300), P3 (płatwie dzielone nad ścianą), P5 (10 z 12 ziaren), N3
(kanały na przewody).
Wykonane w rundzie 17: menu i przycisk „Standard warsztatu”, styk zawsze w zamku, okna / drzwi / węgły kliknięciem,
lista stolarki, modele w otworach, działowe w domu z wymiarów, magazyn drewna, jeden przełącznik doboru, wycena (W3).
Wykonane w rundzie 16: pół zamka, węgieł ze stykami do połaci, poziomy ustawień z typami i standardem, okno z krokami, S1, W1.

## 6. Pytania do użytkownika (krótka lista)

Pełna tabela wartości przyjętych bez pytania – `docs/pytania_otwarte.md`.

1. **Układ okna**: zostajemy przy nowym (kroki) czy dotychczasowym (zakładki)? Zrzut obu: `docs/uklady_okna_r17.png`.
2. **Dom L – koniec płatwi skrzydła w koszu** (rysunek `docs/kosz_slupek_r18.png`): słupek na niższej płatwi dachu
   głównego – dobrze? Czy wolisz przedłużać płatew skrzydła do płatwi głównej (styk) ze ściętym wierzchem końca?
3. **Taras typu 300**: front ze szczytem (górne wieńce nad otworem i szczyt jak w typie 200) zamiast otwartego – dobrze
   jako fabryczny?
4. **Typy + dodatki**: typ = bryła domu (100–400), a dodatki osobnymi przełącznikami w kroku „Taras i zadaszenie”: taras,
   zadaszenie boczne (są), drewutnia / zadaszenie przy ścianie szczytowej z tyłu (nowe – N4), wyższa ścianka o pół
   piętra (liczba wieńców – jest), poddasze użytkowe (strop – N1). Robimy to tak?
5. **Uwagi z SketchUpa** do kompilacji 18 (prosty model okna, kanał na przewody, słupki w koszu, front tarasu 300).
6. Starsze: Z9 (przybudówka – podparcie płatwi), D1a (strefy śniegowe), H21 (co dostaje CNC), nazwy okuć do zestawienia.

## 7. Odbiór

`docs/scenariusz_odbioru.md` – trzy kroki: instalacja, przycisk „Test działania”, zwykła praca. Raport i dziennik pracy
zapisują się same w `raporty\`. Na starcie rund 16–18 folderu `raporty\` nie było – **kompilacje 14–17 nie były
uruchamiane w SketchUpie**; wszystko od rundy 14 (pasek, menu pod prawym przyciskiem, raport, szczyty na styk, zestawienie,
pół zamka, typy, okno krokami, okienko kliknięcia, modele stolarki, magazyn, wycena, prosty model okna, kanały, wybór
ścieżki) jest sprawdzone tylko na atrapie API
i w Chromium.
Dawny scenariusz z 59 krokami – `docs/scenariusz_archiwum.md`.

## 8. Ograniczenia (kompilacja 18)

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
  (jak lico zewnętrzne ściany obrysu); sprawdzone tylko na atrapie API (`definitions.load` z pliku .skp, okno wyboru
  `UI.openpanel` / `UI.select_directory`). Prosty model: rama na grubość ściany bez skrzydła okna i okuć, maskownice tylko
  od zewnątrz, w działowej po stronie −nor.
- Kanały na przewody: otwór w modelu kwadratowy (bok = średnica), w osi grubości bala, przez wszystkie bale ściany
  w tym miejscu (także szczytu); puszka tylko jako obróbka na liście (bryła bez otworu puszki), zawsze po stronie +nor
  (wnętrze ściany zewnętrznej); kanał w działowej – bez wyboru strony puszki; kanał nie omija otworów okien.
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
  i podpowiedzi podciągu; trójkąt nad tarasem – sama podpowiedź. Płatwie dachu dłuższe niż w magazynie dzielone nad
  ścianą na styk w osi ściany (bez zakładu); płatwie zadaszenia, krokwie i podciągi – w jednym kawałku z podpowiedzią.
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
- Dom L: koniec płatwi skrzydła bocznego w koszu – słupek na niższej płatwi dachu głównego (wspornik od słupka do końca,
  zwykle do 1 m); bez płatwi pod spodem – ostrzeżenie; belki koszowej generator nie rysuje. Gdy
  wysunięcie za szczyt jest mniejsze niż okap, na ścianie wspólnej połać wystaje za szczyt o okap; ściana przez oba
  skrzydła bierze dach tego skrzydła, w którym leży jej środek. Dom L z podbitką na płatwiach: połacie dla aplikacji wyżej
  o grubość deski (od rundy 18, jak w domu prostokątnym).
- Losowe domy – drobiazgi (poza zestawem stałym): ziarna 75, 318, 472 (sprzed rundy 10), 6305, 6557 (krawędź bryły
  bala szczytu 0,07 / 0,008 mm – wycięcie gniazda płatwi kończy się tuż nad gniazdem zamka; SketchUp może scalić
  wierzchołki bliższe niż 0,025 mm).
- Krokwie z generatora z czołami prostopadłymi do osi, bez poszycia; pełne krokwie i poszycie robi aplikacja do dachów
  (3.7.0 lub nowsza; szczyt zawsze pod krokwiami; dach jednospadowy – okap za ścianą wysoką liczony jak przęsło).
- Taras: przed jedną ścianą szczytową; bez schodów, desek tarasu i osłony z listew; w typie 300 front ze szczytem
  (fabrycznie) bez słupów – górne wieńce frontu nad całym otworem tarasu, statyki tego „nadproża” generator nie liczy;
  front bez słupów pośrednich łączony na
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
| 19 | Odpowiedzi z §6: wybór układu okna i usunięcie drugiego, poprawki z prawdziwego SketchUpa (raport z testu działania), modele stolarki użytkownika (gdy będą), ewentualne zmiany słupków w koszu i frontu tarasu 300; potem P5 reszta (6305, 6557) i wzór dobudówki (N4) z drewutnią / zadaszeniem przy ścianie szczytowej – jeśli „typ + dodatki” dostanie zgodę. Polecenie: `docs/prompt_r19.md`, zakres: `docs/zadanie_r18.md` |
| dalej | Strop i antresola z belek (N1), obrysy T i U (N4), okna dopasowane do wieńców (N2), grubszy bal (N5); Dokumentacja 2D (grupy bali, obróbki kanałów i puszek, plan montażu); „buduj do wysokości”; podgląd na żywo po pomiarze |

Na starcie każdej rundy: `raporty\` z dysku (§4), potem kolejka z §5.
