# Stan prac – ArteMadera Generator Wieńcowy

Stan na: runda 19, kompilacja 19 (2026-11-27), wersja 1.0.0. Poprzednio: runda 18, kompilacja 18 (2026-11-27).
Testy: `bash testy/uruchom.sh` – 39 zestawów (nowy `t_drewutnia`), ok. 2270 sprawdzeń, FAILURES 0; pominięte: „Ruby 2.7.8”
(brak Rubiego 2.7 w sesji – kontrola zasad Ruby 2.2 przechodzi) i „dach_aplikacja” (dostęp do repozytorium aplikacji do dachów
odmówiony w tej sesji). Poza zestawem: 600 losowych domów (6001–6600, co trzeci z kanałami, co trzeci prostokątny
z drewutnią) – 0 problemów (k18: 2), 300 złożonych (10001–10300) – 0. Spoza zakresu znane: 94, 153, 8068, 9015, 9087.
Aplikacja do dachów bez zmian (3.12.0).

Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`, historia rund 1–19).
Dysk użytkownika: `C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\` (kod, dokumenty, paczka `.rbz`,
od rundy 14 także `raporty\` – raporty z testu działania i dziennik pracy zapisywane przez wtyczkę).

Ten plik to stan bieżący. Historia (nowości kompilacji 7–13, przebieg rund 1–13, moduły) – `docs/historia_rund.md`;
wartości przyjęte bez pytania – `docs/pytania_otwarte.md`; zasady konstrukcji – `docs/specyfikacja.md`.

## 1. Nowe w kompilacji 19 (polecenie z 2026-11-27 22:08 – `docs/prompt_r19.md`)

- **Odpowiedzi z rundy 18** (w poleceniu same „…” – pytania zadane od razu z rysunkami, odpowiedź w oknie pytań):
  1 (układ okna) – „oba”: **oba układy zostają** (wybór później); 2 (kosz domu L) – „nie wiem, sprawdź w wytycznych dla
  konstruktorów / architektów / prawie budowlanym / normach”; 3 (front tarasu 300) – „może być, ma być wybór”: szczyt
  fabrycznie, wybór `taras_sciany_front` (był od k18); 4 (typ + dodatki) – „tak”; 5 – brak uwag (folderu `raporty\` na
  dysku nadal nie ma – kompilacje 14–18 nie były uruchamiane w SketchUpie).
- **Kosz domu L według wytycznych** (`rdzen/statyka_kosza.rb`, `docs/specyfikacja.md` „Dom L – koniec płatwi skrzydła”):
  oparcie płatwi dobudówki na płatwi pośredniej dachu głównego krótkimi słupkami to zwykłe rozwiązanie ciesielskie
  (lukarny – Dietrich's) – **słupek zostaje**. Dodane dwa sprawdzenia wymagane przez PN-EN 1995-1-1: siła skupiona ze
  słupka (reakcja płatwi skrzydła R = q (L + a)² / 2L) doliczona do statyki i doboru płatwi dachu głównego (zastępczo
  2R / L) i docisk w poprzek włókien pod słupkiem (p. 6.1.5, fc,90,k z PN-EN 338 – nowa wartość w klasach drewna).
  Podpowiedź w „Szczyty i dach”: siła i docisk; docisk > 100 % – uwaga.
- **Dodatki: drewutnia / zadaszenie przy ścianie szczytowej** (`rdzen/drewutnia.rb`, `rdzen/statyka_drewutni.rb`,
  `rdzen/parametry_drewutnia.rb`, rysunek `docs/drewutnia_r19.png`): wiata na słupach z dachem jednospadowym od ściany
  szczytowej – fabrycznie z tyłu (naprzeciw tarasu). Dwa rzędy słupów (przy ścianie – nie dotyka ściany, która osiada –
  i zewnętrzny) z fundamentami, płatew przy ścianie i oczep, krokwie (przekrój i rozstaw krokwi dachu). Wierzch krokwi
  najwyżej pod dachem domu: pod płatwiami i krokwiami wysuniętymi za szczyt o odstęp 50 i osiadanie ścian; słupy
  i krokwie omijają węgły, działowe, podwaliny i fundamenty domu. Statyka krokwi, płatwi i oczepu, słupów z podpowiedzią
  najmniejszego przekroju z magazynu. Tag i grupa „Drewutnia”; płatew i oczep drewutni nie są podporami połaci dla
  aplikacji do dachów. 12 parametrów (`drewutnia*`); dwunasty przykład testu działania.
- **Krok „Dodatki”** (dawniej „Taras i zadaszenie”): przełączniki zadaszenia bocznego i drewutni są polami „Ten dom”
  (widoczne od razu, nie w typie); taras zostaje w typie (Typ 200 i 300 go mają – pytanie w §6).
- **P5 – reszta** (regresja w `testy/t_losowe.rb`): 6305 – szpic klina szczytu 0,07 mm przed gniazdem zamka – skos
  obniżony do dolnego naroża gniazda (`rdzen/sciecie_dachu.rb#wyrownaj_skosy!`); 6557 – 0,008 mm bala między gniazdem
  płatwi a gniazdem zamka nad węgłem – zostaje 0,2 mm (`#wyrownaj_przeciwne!`). W 600 losowych domach – 0 problemów.
- **Kanały** (`rdzen/kanaly.rb`, `html/kanaly.js`, `html/sciana.js`): strona puszki w okienku (lewa – wnętrze ściany
  zewnętrznej, prawa – od zewnątrz / druga strona działowej); kanał w miejscu okna albo drzwi – otwór tylko w balach pod
  otworem, puszka w otworze pominięta (uwaga), w widoku ściany pas do spodu otworu.
- Losowe domy: od ziarna 6001 co trzeci (prostokątny) z drewutnią (osobne losowanie). Parametrów: 217.
- Aplikacja do dachów: w tej sesji dostęp do jej repozytorium odmówiony – zestaw „dach_aplikacja” pominięty (UWAGA);
  zmiany rundy nie dotykają połaci domu (drewutnia ma własny dach i nie trafia do aplikacji).

## 2. Co potrafi generator (skrót)

- **Rysunek**: obrys = lico zewnętrzne, linie w środku = osie działowych, krótka linia w poprzek ściany = węgieł;
  zaznaczona ściana (prostokąt); scalanie linii, dociąganie końców, dowolny obrót; obrysy wielokątne (L, T, U, Z, krzyż, H);
  działowa w linii ściany obrysu; działowe narysowane bliżej niż grubość bala – jedna ściana.
- **Ściany i bale**: zamek 44 × 146 na każdym skrzyżowaniu, ostatki, numeracja jak producent; półbal na ścianach wzdłuż
  kalenicy; łączenie bali (na przemian / para / jeden węgieł, mijanka ≥ 300, styk wspólny w zamku działowej); węgły
  usztywniające, narysowane, z tabeli, ręczne w widoku ściany, pod płatwiami, na wolnym końcu, symetryczne; działowa
  niższa pod stropem z dopełnieniem zamka; pełny profil bala do wizualizacji; okna i drzwi ze stolarką i luzami (model
  z pliku .skp albo prosty z generatora); kanały na przewody (otwór pionowy przez wieńce, w miejscu okna – pod nim; puszka
  z wybraną stroną).
- **Szczyty i dach**: dwuspadowy, jednospadowy, dom L (dwa dachy z koszem); płatwie ścięte do dachu, na pełnym balu,
  z zamkami, dłuższe niż w magazynie dzielone nad ścianą; dom L – słupki pod końcami płatwi skrzydła w koszu (siła na
  płatwi głównej i docisk w statyce); ściana nośna
  zamiast płatwi ściennej; krokwie z generatora albo krokwie i poszycie z aplikacji do dachów
  (połacie, podpory, KROK 2); podbitka; wypusty okapu.
- **Dodatki**: **taras** (typ 200 na słupach z balustradą, typ 300 ściany pełne z frontem ze szczytem albo otwartym)
  z trójkątem nad tarasem; **boczne zadaszenie** (wiata na słupach albo przybudówka z bali) z załamaniem dachu;
  **drewutnia** przy ścianie szczytowej (wiata na słupach z dachem jednospadowym pod okapem domu).
- **Podłoga**: podwaliny, legary, podciągi, fundamenty punktowe; statyka podłogi, płatwi, krokwi, zadaszenia i trójkąta
  z podpowiedziami; dobór przekrojów z list hurtowni z długościami; słupy tarasu krótsze o osiadanie ścian.
- **Okno**: kroki w kolejności budowy z rzutem i uwagami na widoku (obok – dawny układ z zakładkami, do wyboru), typy
  domów i standard warsztatu (też z menu), pola-tabele (lista stolarki, magazyn drewna), widok ściany z okienkiem
  wstawiania okien, drzwi, węgłów i kanałów, wybór pliku i folderu („…”), działowe domu z wymiarów, zestawienie CSV
  z materiałami i wyceną.
- **Model**: Dom > W-n / Podłoga / Dach / Taras / Zadaszenie / Drewutnia / Stolarka > komponenty z atrybutami Dokumentacji 2D, tagi; przebudowa
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
| Układ okna: nowy (kroki) albo dotychczasowy (zakładki) – „chcę mieć możliwość porównania obu, a w późniejszym czasie zostaniemy przy jednym”; w r19 – „oba” | 2026-11-27 | **oba zostają** (decyzja z r19); usunięcie jednego – gdy użytkownik wybierze (`html/tryb.js`, cecha `podstawowy`, `t_okno.js`) | – |
| Kosz domu L – „sprawdź w wytycznych / normach” | 2026-11-27 | zrobione w r19: słupek zostaje (praktyka ciesielska), siła na płatwi głównej i docisk wg PN-EN 1995-1-1 | – |
| Front tarasu 300 – „może być, ma być wybór” | 2026-11-27 | zrobione (szczyt fabrycznie, `taras_sciany_front`) | – |
| Typ + dodatki – „tak” | 2026-11-27 | r19: krok „Dodatki”, drewutnia przy szczycie, przełączniki zadaszenia i drewutni w „Ten dom”; dalej: taras w „Ten dom”? (pytanie §6), poddasze użytkowe (N1), ścianka o pół piętra (liczba wieńców – jest) | 20+ |
| Modele okien i drzwi użytkownika – „daj ścieżkę dostępu, to da mi możliwość podmiany modeli” | 2026-11-27 | zrobione w r18 (ścieżka, „…”, prosty model); **czeka na pliki** użytkownika (sprawdzenie punktu wstawienia) | 20+ |
| Przełącznik doboru – „oba wybory, zależy jakie konstrukcje” | 2026-11-27 | zrobione w r18 | – |
| Propozycje po rundzie 14: N1, N4, N5, W4, W5 | 2026-11-25 21:42 | P2, P3, P5, N3 zrobione (r18–r19), N4 – drewutnia (r19); dalej według §9 | 20+ |
| Dom T, U, krzyż: kalenica z dachu o większej powierzchni, skrzydeł dowolnie wiele | 2026-11-14 | osobna runda, razem ze wzorem dobudówki (N4) | po 20 |
| Repozytorium prywatne | 2026-11-25 | do zrobienia przez użytkownika w ustawieniach GitHuba (`docs/przekazanie_r14.md` §5) | – |

Wykonane w rundzie 19: kosz domu L wg PN-EN 1995-1-1, drewutnia i krok „Dodatki”, P5 reszta (6305, 6557), kanały (strona
puszki, kanał pod oknem), dwunasty przykład testu działania.
Wykonane w rundzie 18: ścieżka i przycisk „…” dla modeli stolarki, prosty model okna i drzwi, przełącznik doboru w typie,
P2 (słupki w koszu domu L, front ze szczytem w tarasie 300), P3 (płatwie dzielone nad ścianą), P5 (10 z 12 ziaren), N3
(kanały na przewody).
Wykonane w rundzie 17: menu i przycisk „Standard warsztatu”, styk zawsze w zamku, okna / drzwi / węgły kliknięciem,
lista stolarki, modele w otworach, działowe w domu z wymiarów, magazyn drewna, jeden przełącznik doboru, wycena (W3).

## 6. Pytania do użytkownika (krótka lista)

Pełna tabela wartości przyjętych bez pytania – `docs/pytania_otwarte.md`.

1. **Drewutnia** (rysunek `docs/drewutnia_r19.png`): rząd słupów przy ścianie (wiata nie dotyka ściany, bo ściana
   osiada) – dobrze, czy płatew przykręcona do ściany na łącznikach przesuwnych (bez słupów przy ścianie)? Ściany
   drewutni (boki i tył z desek ażurowych) – potrzebne?
2. **Taras jako dodatek**: przełącznik tarasu też w „Ten dom” (widoczny od razu w kroku „Dodatki”; Typ 200 i 300 dalej
   z tarasem w szablonie)?
3. **Kolejny dodatek**: poddasze użytkowe (strop z belek – N1) czy ścianka o pół piętra wyżej jako osobny przełącznik?
4. **Test w SketchUpie**: kompilacje 14–19 nie były uruchamiane – jeden „Test działania” (12 domów) i raport sam się
   zapisze w `raporty\`.
5. Starsze: Z9 (przybudówka – podparcie płatwi), D1a (strefy śniegowe), H21 (co dostaje CNC), nazwy okuć do zestawienia.

## 7. Odbiór

`docs/scenariusz_odbioru.md` – trzy kroki: instalacja, przycisk „Test działania”, zwykła praca. Raport i dziennik pracy
zapisują się same w `raporty\`. Na starcie rund 16–19 folderu `raporty\` nie było – **kompilacje 14–18 nie były
uruchamiane w SketchUpie**; wszystko od rundy 14 (pasek, menu pod prawym przyciskiem, raport, szczyty na styk, zestawienie,
pół zamka, typy, okno krokami, okienko kliknięcia, modele stolarki, magazyn, wycena, prosty model okna, kanały, wybór
ścieżki, drewutnia) jest sprawdzone tylko na atrapie API i w Chromium.
Dawny scenariusz z 59 krokami – `docs/scenariusz_archiwum.md`.

## 8. Ograniczenia (kompilacja 19)

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
- Okno: dwa układy naraz (nowy i dotychczasowy) – decyzja z rundy 19 („oba”); w nowym uwaga bez rozpoznanego pola prowadzi
  tylko do kroku (tabela wzorców `rdzen/uwagi_pola.rb`); ostrzeżenia o otworach prowadzą do kroku „Okna i drzwi”, nie do
  wiersza tabeli. Układ nowy sprawdzony w Chromium 1060 × 860 – w prawdziwym oknie SketchUpa jeszcze nie.
- Okienko kliknięcia: wstawia w ścianę widoczną w widoku; „od” węgła liczone jak „od” otworu (od narożnika lica
  zewnętrznego). Węgieł z tabeli węgłów poprawia się w tabeli (okienko przesuwa węgły ręczne ściany).
- Modele stolarki: bez skalowania (model innego wymiaru – uwaga); w działowej strona „zewnętrzna” = prawa strona osi
  (jak lico zewnętrzne ściany obrysu); sprawdzone tylko na atrapie API (`definitions.load` z pliku .skp, okno wyboru
  `UI.openpanel` / `UI.select_directory`). Prosty model: rama na grubość ściany bez skrzydła okna i okuć, maskownice tylko
  od zewnątrz, w działowej po stronie −nor.
- Kanały na przewody: otwór w modelu kwadratowy (bok = średnica), w osi grubości bala, przez wszystkie bale ściany
  w tym miejscu (także szczytu); w miejscu okna albo drzwi – tylko pod otworem (kanału nad oknem, np. do lampy, nie ma);
  puszka tylko jako obróbka na liście (bryła bez otworu puszki), strona: lewa (+nor, wnętrze ściany zewnętrznej) albo
  prawa.
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
  zwykle do 1 m); bez płatwi pod spodem – ostrzeżenie; belki koszowej generator nie rysuje. Statyka kosza (r19): siła
  ze słupka w środku największego przęsła płatwi głównej (zastępczo 2R / L, z zapasem), docisk z kc,90 = 1,0; słupek bez
  sprawdzenia ściskania (krótki). Gdy
  wysunięcie za szczyt jest mniejsze niż okap, na ścianie wspólnej połać wystaje za szczyt o okap; ściana przez oba
  skrzydła bierze dach tego skrzydła, w którym leży jej środek. Dom L z podbitką na płatwiach: połacie dla aplikacji wyżej
  o grubość deski (od rundy 18, jak w domu prostokątnym).
- Losowe domy – drobiazgi (poza zestawem stałym): ziarna 75, 318, 472 (sprzed rundy 10). Bal szczytu w miejscu, gdzie
  gniazdo płatwi i gniazdo zamka prawie się spotykają, ma 0,2 mm drewna (płatew wchodzi w nie do 0,2 mm); szpic klina
  przed gniazdem zamka znika (bal zaczyna się za gniazdem, długość na liście bez zmian).
- Drewutnia: tylko dom prostokątny, dach z generatora; na słupach (bez ścian z desek, bez wariantu z bali); na całej
  szerokości między ostatkami ścian okapowych albo węższa na środku (bez odcinka od–do); krokwie z generatora (przekrój
  i rozstaw krokwi dachu, czoła prostopadłe do osi, bez wrębu na belkach) – bez łat, deskowania i pokrycia, aplikacja
  do dachów jej nie dostaje; dach drewutni nie wchodzi do powierzchni dachu w zestawieniu; rzut w oknie jej nie
  pokazuje; obok tarasu po tej samej stronie – nie; statyka bez wiatru (słupy wolnostojące wymagają stężeń), słup przy
  ścianie liczony jak zewnętrzny; fundamenty tylko przy podłodze z fundamentami (jak pod domem), mogą stykać się
  z fundamentami domu.
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
| 20 | Odpowiedzi z §6 (drewutnia – słupy przy ścianie czy łączniki przesuwne, ściany drewutni; taras w „Ten dom”; kolejny dodatek), poprawki z prawdziwego SketchUpa (raport z testu działania), modele stolarki użytkownika (gdy będą); potem kolejny dodatek (poddasze użytkowe – strop z belek N1 albo ścianka o pół piętra), dach drewutni w zestawieniu i dla aplikacji do dachów. Polecenie: `docs/prompt_r20.md`, zakres: `docs/zadanie_r19.md` |
| dalej | Strop i antresola z belek (N1), obrysy T i U (N4), okna dopasowane do wieńców (N2), grubszy bal (N5); Dokumentacja 2D (grupy bali, obróbki kanałów i puszek, plan montażu); „buduj do wysokości”; podgląd na żywo po pomiarze |

Na starcie każdej rundy: `raporty\` z dysku (§4), potem kolejka z §5.
