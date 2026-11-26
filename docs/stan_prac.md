# Stan prac – ArteMadera Generator Wieńcowy

Stan na: runda 16, kompilacja 16 (2026-11-26), wersja 1.0.0. Poprzednio: runda 15, kompilacja 15 (2026-11-25).
Testy: `bash testy/uruchom.sh` – 35 zestawów (nowe `t_poziomy`, `t_typy`, `t_okno_kroki`), 2255 sprawdzeń, FAILURES 0; zestaw
„Ruby 2.7.8” pominięty (brak Rubiego 2.7 w sesji – kontrola zasad Ruby 2.2 przechodzi). Poza zestawem, na ostatecznym kodzie: 1250 losowych domów
(ziarna 1–300, 3001–3100, 5001–5100, 6001–6300, 7001–7100, 8001–8100, 8501–8600, 9001–9150) i 300 złożonych (10001–10300)
z nowymi ustawieniami fabrycznymi (pół zamka, deski na krokwiach / płatwiach) – bez nowych problemów. Znane sprzed rundy:
94, 153, 8068, 9015, 9087 (dwie działowe narysowane 7–32 mm od siebie), 6110, 6269 (bal 0,04–0,15 mm nad połacią), 7004, 7021
(dom L z podbitką na płatwiach – §8). Dwa błędy rundy znalezione tymi domami i poprawione: 6201 i 10019 (w regresji).
Aplikacja do dachów bez zmian (3.12.0).

Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`, historia rund 1–16).
Dysk użytkownika: `C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\` (kod, dokumenty, paczka `.rbz`,
od rundy 14 także `raporty\` – raporty z testu działania i dziennik pracy zapisywane przez wtyczkę).

Ten plik to stan bieżący. Historia (nowości kompilacji 7–13, przebieg rund 1–13, moduły) – `docs/historia_rund.md`;
wartości przyjęte bez pytania – `docs/pytania_otwarte.md`; zasady konstrukcji – `docs/specyfikacja.md`.

## 1. Nowe w kompilacji 16 (polecenie z 2026-11-25 23:27 – `docs/prompt_r16.md`, odpowiedzi użytkownika w `docs/zadanie_r16.md` §0)

- **Pół zamka fabrycznie i w każdym ostatnim połączeniu pod dachem** (`rdzen/pol_zamka.rb#ostatnie?`, `rdzen/zamek.rb`,
  `rdzen/bale.rb#kontrfor_obecny?`): akceptacja z 2026-11-25 („dobry pomysł … i tak trzeba podfrezować gniazda na bokach
  górnego elementu”). `polzamek` = tak; bal górny bez gniazda od spodu **z podcięciami bocznymi jak w zwykłym zamku**
  (rysunek `docs/ostatnie_polaczenie_r16.png`). Poza narożnikiem szczytu: górny bal ściany ścięty płaszczyzną dachu,
  ostatni bal węgła (od 20 mm pod dachem zamiast 56), bal ściany nad ostatnim balem węgła, bal nad działową pod połacią.
  Pomiar: w 240 losowych domach kompilacji 15 było 268 gniazd od spodu, nad którymi pod dachem zostawało mniej niż 20 mm
  drewna (79 bali przeciętych gniazdem na wylot) – teraz 49, wszystkie w klinach, które same mają w zamku mniej niż 20 mm
  (drzazga między gniazdem płatwi a skosem – zwykłe gniazdo jak dotąd); półzamków 497 w 300 domach (ziarna 1–300). W węźle ścian w jednej
  linii oba bale stykające się czołami są balami półzamka (`Zamek.wspolne_polzamki!`).
- **Styk w najwyższym wieńcu zostaje w zamku** (odpowiedź z 2026-11-26 02:40: „jak dotąd były tam zamki … bez zamka będzie
  to uciekać przy montażu i skręcać się”): węgieł, w którym łączą się bale ściany, dochodzi do połaci także przy podbitce
  pod płatwiami (`rdzen/podbitka.rb#obnizenie_wegla`), deski podbitki są przerwane na węźle (`#bez_wegla`). Domy ze stykiem
  bez zamka na 600 losowych: 23 → 8; ostrzeżenie zostaje ostrzeżeniem (propozycja „podpowiedź zamiast ostrzeżenia” odrzucona).
- **Nadbitka / podbitka – jedno pole położenia desek** (`podbitka`: na płatwiach, na krokwiach, pod krokwiami, pod płatwiami,
  bez; odpowiedź z 2026-11-25). Pola `poszycie_nadbitka` i `nadbitka_*` zniknęły – stare wartości z modeli i ustawień
  przenosi `ParametryDach.przenies_nadbitke`; położenie niepasujące do układu dachu zamieniane na odpowiednik
  (same płatwie: „na krokwiach” = „na płatwiach”). Jedna deska `podbitka_grubosc / _krycie / _dlugosc`.
- **Trzy poziomy ustawień** (`rdzen/poziomy.rb`; cecha `poziom:` przy każdym polu): Ten dom 18 pól (16 + długość i szerokość
  domu z wymiarów), Typ domu 48, Standard warsztatu 131. Plik ustawień w wersji 5 (`sketchup/ustawienia.rb`): `standard`
  (tylko pola inne niż fabryczne), `typy`, `typ`, `okno`; plik starszy – ostatnie parametry stają się standardem i typem
  „Ostatnie ustawienia (do kompilacji 15)”, własne szablony – typami, stary plik zostaje jako `ustawienia_przed_r16.json`.
  **Podgląd niczego już nie zapisuje** – nowy dom zaczyna od wybranego typu i standardu.
- **Typy domów** (`sketchup/typy_domow.rb`, `sketchup/okno_typy.rb`, `html/typy.js`): Typ 100–400 wbudowane (do powielenia),
  własne: „Zapisz jako typ…” (nazwa + zdanie opisu), „Zapisz zmiany w typie”, „Powiel…”, „Usuń” (drugie kliknięcie),
  „Przywróć typ”. Pole typu albo standardu o innej wartości jest oznaczone „tylko w tym domu” z przyciskiem powrotu ↺.
  **Standard warsztatu** – panel z przycisku w nagłówku okna (`html/standard.js`): 131 pól i wymiary zamka, szukanie,
  „Zapisz standard”, „Przywróć fabryczne”.
- **Okno – układ nowy** (`html/kroki.js`, `html/uklad.js`, `html/uwagi.js`, `html/kroki.css`): sześć kroków w kolejności
  budowy ze znacznikiem stanu (✓ albo liczba uwag), po prawej stale rzut, liczby i lista „Do poprawy / Sprawdzone”
  (kliknięcie uwagi przenosi do pola – `rdzen/uwagi_pola.rb`), podpowiedź po wejściu w pole, lista bali, materiały
  i powierzchnie w kroku „Zestawienie”, opcje niedostępne dla obrysu wyszarzone z powodem (cecha `obrys:` pola).
  W kroku widać pola „Ten dom”; pola typu – po „Pola typu domu w tym kroku”, pole standardu – z listy „Zmień pole
  standardu tylko w tym domu…”. Pomiar (okno 1060 × 860, dom testowy): krok „Ściany” 999 px przewijania zamiast 3 694 px
  w układzie dotychczasowym, karta „Wynik” 446 px od góry (było 1 202 px), 3 pola zamiast 45.
  **Przełącznik „Układ: nowy / dotychczasowy”** w nagłówku (użytkownik chce porównać oba i zostać przy jednym) – w układzie
  dotychczasowym zostały zakładki i tryb „Podstawowe / Wszystkie”.
- **Dom prostokątny z wymiarów** (S1 – `rdzen/dom_z_wymiarow.rb`): nic nie zaznaczone → okno z polami „Długość domu”
  i „Szerokość domu” (fabrycznie 6000 × 4000), obrys w punkcie 0,0 modelu.
- **Powierzchnie i limity** (W1 – `rdzen/powierzchnie.rb`, sekcja „Powierzchnie i limity”): zabudowa, taras, każde
  pomieszczenie po licach wewnętrznych, dach, wysokość konstrukcji nad terenem; limity `limit_zabudowy`,
  `limit_wysokosci` (0 = bez limitu) z ostrzeżeniem, `teren_pod_balem` 300 mm. W wyniku, w kroku „Zestawienie” i w CSV.
- **Błąd znaleziony przy okazji**: okno pokazywało i odsyłało „Ciężar pokrycia z poszyciem” 0,35 kN/m² jako 0,3 (każda
  wartość z dwoma miejscami po przecinku była zaokrąglana do jednego) – płatwie liczone z mniejszym obciążeniem. Poprawione
  (`html/wspolne.js#fmtPola`).
- **Drugi błąd znaleziony testem okna**: po wpisaniu wartości i kliknięciu od razu w przycisk (np. „+ drzwi”, krok, „Generuj”)
  okno przebudowywało się między naciśnięciem a puszczeniem przycisku myszy i kliknięcie trafiało obok – trzeba było klikać
  drugi raz. Przebudowa po zmianie pola czeka teraz na puszczenie przycisku (`html/wspolne.js#poKliknieciu`).
- Parametrów: 197 (nowe: `dom_dlugosc`, `dom_szerokosc`, `teren_pod_balem`, `limit_zabudowy`, `limit_wysokosci`; usunięte:
  `poszycie_nadbitka`, `nadbitka_grubosc`, `nadbitka_krycie`, `nadbitka_dlugosc`).

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
- **Okno**: zakładki Dom / Zadaszenie, sekcje z listy parametrów (194 pola), pola Podstawowe / Wszystkie i zależne,
  szablony (Typ 100–400 i własne), rzut, widok ściany z edycją, przesuwanie węgłów, wynik przy sekcjach, zestawienie CSV
  z materiałami (deski, taśma, okucia, impregnacja).
- **Model**: Dom > W-n / Podłoga / Dach / Taras / Zadaszenie > komponenty z atrybutami Dokumentacji 2D, tagi; przebudowa
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
| Układ okna: nowy (kroki) albo dotychczasowy (zakładki) – „chcę mieć możliwość porównania obu, a w późniejszym czasie zostaniemy przy jednym” | 2026-11-25 | oba w kompilacji 16 z przełącznikiem; **czeka na wybór** – potem drugi układ, `html/tryb.js` i pole `podstawowy` do usunięcia | 17 |
| Stolarka: „zostaw otwór, w wolnym czasie zrobię modele typowych okien i drzwi, wtedy damy funkcję, by je od razu wstawiać do modeli” | 2026-11-25 | do zrobienia, gdy użytkownik przygotuje modele (komponenty) – razem z oknami i drzwiami kliknięciem | 17 |
| Okna, drzwi i węgły kliknięciem w widoku ściany; przy kliknięciu okienko z parametrami; lista typowej stolarki | 2026-11-25 | do zrobienia – `docs/zadanie_r16.md` §2 | 17 |
| Jeden magazyn drewna (tabela zamiast pięciu list, z deską 14 × 115) i jeden przełącznik doboru przekrojów | 2026-11-25 | podstawa gotowa w r14 (`rdzen/wykaz_drewna.rb`); tabela i przełącznik – `docs/zadanie_r16.md` §3 | 17 |
| Styk bali zawsze w zamku („jak dotąd były tam zamki”) – pozostałe miejsca: styk ściany okapowej na działowej, która kończy się pod podbitką „pod płatwiami”; styk w ścianie szczytowej nad końcem węgła | 2026-11-26 | węgły ze stykami dochodzą do połaci (r16); dwa pozostałe przypadki (8 domów na 600) – ostrzeżenie; pytanie w §6 | 17 |
| Propozycje po rundzie 14: N3, W3 (17), P2, P3, P5 (18), N1, N4, N5, W4, W5 (dalej) | 2026-11-25 21:42 | przyjęte w tej kolejności; N2 – bez wpustu w czołach bali, N6 – odpada | 17–18+ |
| Dom T, U, krzyż: kalenica z dachu o większej powierzchni, skrzydeł dowolnie wiele | 2026-11-14 | osobna runda, razem ze wzorem dobudówki (N4) | po 18 |
| Repozytorium prywatne | 2026-11-25 | do zrobienia przez użytkownika w ustawieniach GitHuba (`docs/przekazanie_r14.md` §5) | – |

Wykonane w rundzie 16: pół zamka fabrycznie i poza narożnikiem, węgieł ze stykami do połaci, jedno pole położenia desek,
trzy poziomy ustawień z typami domów i standardem warsztatu, okno z krokami i wynikiem na widoku (obok dotychczasowego),
opcje wyszarzone dla obrysu, S1 (dom z wymiarów), W1 (powierzchnie i limity).
Wykonane w rundzie 15: T8 (szczyty na styk), deski 14 × 115 × 4000 z nadbitką fabrycznie, 45 × 120 w 5,4 / 6 m, P1 (słupy
krótsze o osiadanie), W2 (zestawienie materiałów), tabela podziału pól i szkic okna.

## 6. Pytania do użytkownika (krótka lista)

Pełna tabela wartości przyjętych bez pytania – `docs/pytania_otwarte.md`. Odpowiedzi z 2026-11-25 / 26 – `docs/zadanie_r16.md` §0.

1. **Układ okna**: po obejrzeniu obu – zostajemy przy nowym (kroki), czy przy dotychczasowym (zakładki)? Szkic
   `docs/szkic_okna_r16.png` nie dotarł, pytanie o niego zostało bez odpowiedzi – nowy układ jest zrobiony według szkicu.
2. **Styk na działowej pod podbitką**: przy podbitce „pod płatwiami” ściana działowa w poprzek kalenicy kończy się pod
   deskami, a ściana okapowa idzie 1–2 wieńce wyżej – gdy bale ściany okapowej łączą się na tej działowej, najwyższy styk
   nie ma zamka (4 domy na 600). Czy działowa, na której wypada styk, ma też dochodzić do połaci (jak węgieł)?
   Rysunek: `docs/styk_nad_dzialowa_r16.png`.
3. **Styk w ścianie szczytowej nad końcem węgła** (4 domy na 600, niezależnie od podbitki) – bez pytania na teraz:
   rozpoznanie i rysunek w rundzie 17 (`docs/zadanie_r16.md` §4).
4. **Typy domów**: Typ 100–400 jako punkt wyjścia wystarczą, czy dodać gotowe typy z Twoich projektów 900, 1100, 1200, 1800 (S2)?
5. **Modele okien i drzwi**: w jakiej postaci je przygotujesz (komponenty SketchUpa w jednym folderze, nazwa = wymiar stolarki)?
6. **Z9 – przybudówka**: czym podeprzeć płatwie zadaszenia w długim domu (słupki, węgły albo działowe przybudówki)?
7. **D1a – śnieg**: w jakich strefach stoją Twoje domy (dziś 0,9 kN/m² – strefa 2)?
8. **H21 – CNC**: co dostaje wykonawca CNC – zestawienie CSV wystarcza, czy potrzebne pliki BTLx / BVN?
9. **Okucia w zestawieniu**: jakich podstaw słupów, kotew i łączników krokwi używasz naprawdę (nazwy do zestawienia)?

## 7. Odbiór

`docs/scenariusz_odbioru.md` – trzy kroki: instalacja, przycisk „Test działania”, zwykła praca. Raport i dziennik pracy
zapisują się same w `raporty\`. Na starcie rundy 16 folderu `raporty\` nie było – **kompilacje 14 i 15 nie były uruchamiane
w SketchUpie**; wszystko od rundy 14 (pasek narzędzi, menu pod prawym przyciskiem, zapis raportu, okienko po awarii, szczyty
na styk, zestawienie materiałów, pół zamka, typy, nowe okno) jest sprawdzone tylko na atrapie API i w Chromium.
Dawny scenariusz z 59 krokami – `docs/scenariusz_archiwum.md`.

## 8. Ograniczenia (kompilacja 16)

- Styk bez zamka zostaje (z ostrzeżeniem) w dwóch miejscach – 8 domów na 600 losowych: styk ściany okapowej na działowej,
  która kończy się pod podbitką „pod płatwiami” (działowa nie przechodzi przez deski), i styk w ścianie szczytowej nad
  końcem węgła. Szczyt na styk (runda 15): tylko szczyt skośny ściany domu; w szerokim szczycie bez węgłów nic nie
  usztywnia wieńców szczytu poza płatwiami.
- Pół zamka: tylko dla bala, który w zamku ma pod dachem co najmniej 20 mm. Cieńszy: w narożniku jest dalej ucinany
  przy ścianie poprzecznej, w środku ściany (klin szczytu nad węgłem albo działową) dostaje zwykłe gniazdo jak do
  kompilacji 15 (gniazdo przecina klin). Węgieł ze stykami przy podbitce
  pod płatwiami przechodzi przez deski – deski kończą się 2 mm od węgła (docinka na budowie); przy podbitce pod krokwiami
  węgieł kończy się pod deskami jak dotąd.
- Poziomy i typy: typ pamięta tylko pola „Typ domu” i „Ten dom” – pola standardu z dawnych szablonów nie są w typach
  (ostatnie parametry stały się standardem); przy dwóch przekrojach bala (dziś jeden) wymiary zamka w standardzie byłyby
  wspólne. Dom zapisany przed rundą 16 nie ma typu – okno porównuje go z ostatnio wybranym typem. Standard warsztatu
  otwiera się z okna generatora (osobnej pozycji w menu nie ma).
- Okno: dwa układy naraz (nowy i dotychczasowy) do czasu wyboru użytkownika; w nowym uwaga bez rozpoznanego pola prowadzi
  tylko do kroku (tabela wzorców `rdzen/uwagi_pola.rb`); ostrzeżenia o otworach prowadzą do kroku „Okna i drzwi”, nie do
  wiersza tabeli. Układ nowy sprawdzony w Chromium 1060 × 860 – w prawdziwym oknie SketchUpa jeszcze nie.
- Dom z wymiarów: tylko prostokąt w punkcie 0,0 modelu, bez działowych (działowe – po narysowaniu obrysu albo w rundzie 17).
- Powierzchnie: pomieszczenia liczone bez węgłów i ostatków, otwory drzwiowe nie łączą pomieszczeń; wysokość do wierzchu
  konstrukcji dachu (bez pokrycia), teren – jedna liczba pod spodem pierwszego bala; „buduj do wysokości” – nie ma.
- Osiadanie: skracane są tylko słupy tarasu; słupy bocznego zadaszenia stoją pod belką opartą na ścianie (bez skracania).
  Okucia regulacyjnego generator nie rysuje – jest w zestawieniu materiałów.
- Zestawienie materiałów: powierzchnia dachu dokładna dla domu prostokątnego, dla obrysu L i innych – w przybliżeniu
  (z dopiskiem); łączniki krokwi tylko dla krokwi z generatora; okucia jako nazwy ogólne, bez cen (wycena – runda 17).

- Działowa w linii ściany obrysu: obie ściany łączą się na styk w zamku ściany poprzecznej we wszystkich wieńcach (jak
  „Łączenie przy działowej” = wspólne); bala ciągłego przez ten węzeł generator nie robi. Gdy linia leży między dwoma
  uskokami o ścianach po przeciwnych stronach (obrys Z), działowa bierze oś pierwszej z nich.
- Dwie ściany narysowane bliżej niż długość węgła: generator ostrzega („zajmują to samo miejsce”), nie poprawia.
- Długości handlowe: dobór bierze przekrój dostępny w całej długości tylko dla płatwi i członów zadaszenia; legary,
  podciągi, krokwie i trójkąt nad tarasem – sama podpowiedź. Belka dłuższa niż handlowa zostaje w modelu w jednym kawałku
  (łączenia generator nie rysuje).
- Przekroje fabryczne spoza wykazu hurtowni: krokiew 50 × 150, legar ręczny 50 × 100, podciąg 100 × 150, deskowanie 25 × 100
  – do wymiany razem z magazynem drewna (runda 17).
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
| 17 | Wybór układu okna i usunięcie drugiego; okna, drzwi, węgły i kanały na przewody kliknięciem z okienkiem parametrów; gotowe modele okien i drzwi użytkownika wstawiane w otwory; magazyn drewna jako tabela (z deską 14 × 115) i jeden przełącznik doboru; wycena materiału (W3); styk na działowej pod podbitką i w ścianie szczytowej. Polecenie: `docs/prompt_r17.md`, zakres: `docs/zadanie_r16.md` |
| 18 | Podparcie końców płatwi (dom L, taras typu 300), belki dzielone nad podporą, drobne błędy geometrii (P2, P3, P5) |
| dalej | Strop i antresola z belek (N1), wzór dobudówki z obrysami T i U (N4), okna dopasowane do wieńców (N2), grubszy bal (N5); Dokumentacja 2D (grupy bali, plan montażu); „buduj do wysokości”; podgląd na żywo po pomiarze |

Na starcie każdej rundy: `raporty\` z dysku (§4), potem kolejka z §5.
