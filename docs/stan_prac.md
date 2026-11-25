# Stan prac – ArteMadera Generator Wieńcowy

Stan na: runda 14, kompilacja 14 (2026-11-25), wersja 1.0.0. Poprzednio: runda 13, kompilacja 13 (2026-11-25).
Testy: `bash testy/uruchom.sh` – 28 zestawów (nowe `t_zlozone`, `t_dlugosci`), 1923 sprawdzenia, FAILURES 0; zestaw
„Ruby 2.7.8” pominięty (brak Rubiego 2.7 w sesji – kontrola zasad Ruby 2.2 przechodzi). Poza zestawem: 120 losowych domów
złożonych (`testy/zlozone_domy.rb`, ziarna 10001–10120) – bez problemów; przed rundą 19 z nich kończyło się wyjątkiem.
Aplikacja do dachów bez zmian (3.12.0). Uzupełnione 2026-11-25 20:40 (kod bez zmian): odpowiedzi użytkownika z 20:26
(T8, deski, 45 × 120 – `docs/zadanie_r15.md` §0), propozycje `docs/propozycje_r15.md`, polecenie na rundę 15 `docs/prompt_r15.md`.

Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`, historia rund 1–14).
Dysk użytkownika: `C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\` (kod, dokumenty, paczka `.rbz`,
od rundy 14 także `raporty\` – raporty z testu działania i dziennik pracy zapisywane przez wtyczkę).

Ten plik to stan bieżący. Historia (nowości kompilacji 7–13, przebieg rund 1–13, moduły) – `docs/historia_rund.md`;
wartości przyjęte bez pytania – `docs/pytania_otwarte.md`; zasady konstrukcji – `docs/specyfikacja.md`.

## 1. Nowe w kompilacji 14 (prośba z 2026-11-25 19:00: „wprowadź te zaległe zmiany”)

Zaległe rozstrzygnięcia z 2026-11-14 (`claude/zadanie_r11.md`) i prostszy odbiór.

- **Dom L z działową w linii uskoku nie wywraca się** (`rdzen/sciana_w_linii.rb`, `rdzen/sciany.rb#dzialowe`,
  `rdzen/obrys.rb#przytnij_do_obrysu`). Działowa narysowana w linii ściany obrysu dostaje oś tej ściany (rysowana jest
  po linii lica, 22 mm obok osi) i łączy się z nią w zamku ściany poprzecznej: obie kończą się w jej osi, bez ostatków
  wchodzących w siebie. Żadnych nowych węgłów w węźle („samo skrzyżowanie ma zostać”). Sama jednowierszowa poprawka
  z 14 listopada usuwała wyjątek, ale zostawiała bale dwóch ścian w tym samym miejscu (244 × 22 mm w każdym wieńcu) –
  dlatego poprawka jest szersza. Linia narysowana jednym ruchem przez wcięcie obrysu (U, H) daje osobną działową po
  każdej stronie wcięcia; część linii na boku obrysu znika bez ostrzeżenia „poza obrysem”.
- **Kontrola ścian równoległych** (`rdzen/kontrola_rownoleglych.rb`): bale dwóch ścian o tym samym kierunku nie mogą
  zajmować tego samego miejsca. Wynik w „Kontroli” z menu, w raporcie z testu działania i jako ostrzeżenie w oknie
  („Ściany W-a i W-b zajmują to samo miejsce…” – np. dwie działowe narysowane bliżej niż długość węgła).
- **Komunikat zamiast wyjątku** (`rdzen/awaria.rb`, `rdzen/projekt.rb#oblicz`, `sketchup/sterowanie.rb#okienko_awarii`):
  nieprzewidziany błąd obliczeń daje zdanie po polsku (co się stało, co sprawdzić, krótki opis do zgłoszenia z plikiem,
  wierszem i numerem kompilacji) – w okienku przy starcie i przy „Generuj”, na liście błędów w oknie przy podglądzie;
  pełny ślad w dzienniku i w dzienniku pracy.
- **Narożnik wklęsły – podpowiedź, nie ostrzeżenie** (`rdzen/sciany.rb#podpowiedz_wklesle`): jedna podpowiedź w sekcji
  „Ściany” ze wszystkimi narożnikami („przy balu 44 mm tak ma być”).
- **Podpowiedzi podłogi** (`rdzen/podloga.rb#bez_podciagow`, `rdzen/podciagi.rb#sprawdzenie`): „Bez podciągów trzeba by
  legara …” w trybie przypuszczającym (albo „Bez podciągów się nie da…”); podciąg z nośnością od 90 % – poziom „uwaga”
  z radą (większy podciąg z listy albo gęstsze fundamenty); poprawiona literówka „zzmniejsz”.
- **Listy przekrojów z hurtowni z długościami** (`rdzen/wykaz_drewna.rb`, `rdzen/dlugosci_handlowe.rb`): zapis
  „45x145:4.2/5.4/6”; listy fabryczne legarów, płatwi, krokwi, belek i słupów zadaszenia z wykazu użytkownika z 14
  listopada (wypadły przekroje, których nie ma: 50 × …, 63 × …, 75 × …, 100 × 150, 180 × 180). Dobór płatwi i członów
  zadaszenia bierze najlżejszy wystarczający przekrój **dostępny w całej długości belki**; gdy takiego nie ma – najlżejszy
  wystarczający i podpowiedź „… szt. o długości do 11 m, a najdłuższa belka tego przekroju z listy ma 8 m – połącz je nad
  podporą”. Podpowiedź także dla legarów, podciągów, krokwi i belek trójkąta. Plik ustawień w wersji 3: listy ze
  starszych kompilacji (także we własnych szablonach) zastępowane nowymi.
- **Pasek narzędzi i prawy przycisk** (`sketchup/pasek.rb`, `ikony/`): pasek „ArteMadera Generator Wieńcowy” z trzema
  przyciskami (dom – nowy z linii albo edycja; kontrola; test działania); pod prawym przyciskiem na zaznaczonym domu
  „Edytuj dom wieńcowy…” i „Kontrola domu wieńcowego”, na zaznaczonych liniach (od 4) „Dom wieńcowy z zaznaczonych linii…”.
- **Prosty odbiór** (`sketchup/dziennik_pracy.rb`, `sketchup/raport.rb`): test działania zapisuje raport sam do folderu
  `raporty\` (bez okna zapisu), okienko zaczyna się od „WSZYSTKO W PORZĄDKU – 11 z 11…” albo „PROBLEMY w …”. Po każdym
  „Generuj” wtyczka dopisuje wiersz do `raporty\dziennik_pracy.jsonl` (czasy obliczeń i budowy modelu, liczby, ustawienia
  zmienione względem fabrycznych, awarie) – nic nie jest wysyłane, pliki czyta się z podłączonego folderu na starcie rundy.
- Znalezione przy okazji: działowa przez wcięcie obrysu U / H biegła także po ścianie wcięcia (bale w tym samym miejscu
  na całej jej długości); radzony „większy” podciąg bywał mniejszy od obecnego (rada liczona teraz tylko z przekrojów,
  które wystarczają z zapasem).

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
  z podpowiedziami; dobór przekrojów z list hurtowni z długościami.
- **Okno**: zakładki Dom / Zadaszenie, sekcje z listy parametrów (185 pól), pola Podstawowe / Wszystkie i zależne,
  szablony (Typ 100–400 i własne), rzut, widok ściany z edycją, przesuwanie węgłów, wynik przy sekcjach, zestawienie CSV.
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
| T8: wieńce w szczytach ścian domu na styk z przesunięciem 300 mm (bez węgłów pod styki w szczycie) | 2026-11-25 20:26 | do zrobienia – `docs/zadanie_r15.md` §0.1 | 15 |
| Pół zamka (zamek na połowie wysokości bala) – po T8 tylko tam, gdzie zamek zostaje niedomknięty pod połacią | 2026-11-14, zakres 2026-11-25 | do zrobienia – najpierw pomiar i rysunek dla użytkownika, §0.2 | 15 |
| Deski nadbitki / podbitki 14 × 115 (krycie) × 4000 („zazwyczaj nadbitka”) | 2026-11-25 20:26 | do zrobienia – §0.3 (pytanie: nadbitka włączona fabrycznie?) | 15 |
| 45 × 120: długości 5,4 / 6 m | 2026-11-25 20:26 | do zrobienia – §0.4 | 15 |
| Propozycje po rundzie 14 (P1–P5, N1–N6, W1–W5, S1–S2) | 2026-11-25 20:40 | do decyzji – `docs/propozycje_r15.md`; domyślnie P1 i W2 w rundzie 15 | 15–18 |
| Typy domów ustawiane i predefiniowane przez użytkownika („w wolnych chwilach”); podział Standard warsztatu / Typ domu / Ten dom | 2026-11-25 | tabela podziału pól do akceptacji w r15, kod w r16 – §1 | 16 |
| Okno: wynik zawsze na widoku, kroki w kolejności budowy, podpowiedzi po wejściu w pole | 2026-11-25 | szkic do akceptacji w r15, kod w r16 – §2 | 16 |
| Okna, drzwi i węgły kliknięciem w widoku ściany; przy kliknięciu okienko z parametrami; lista typowej stolarki | 2026-11-25 | do zrobienia – §3 | 17 |
| Jeden magazyn drewna (tabela zamiast pięciu list) i jeden przełącznik doboru przekrojów | 2026-11-25 | podstawa gotowa w r14 (`rdzen/wykaz_drewna.rb`); tabela i przełącznik – §4 | 17 |
| Dom T, U, krzyż: kalenica z dachu o większej powierzchni, skrzydeł dowolnie wiele | 2026-11-14 | osobna runda, razem ze wzorem dobudówki (propozycja N4) | po 18 |
| Repozytorium prywatne | 2026-11-25 | do zrobienia przez użytkownika w ustawieniach GitHuba (z sesji się nie da – `docs/przekazanie_r14.md` §5) | – |

Wykonane w rundzie 14 (z 2026-11-14): poprawka działowej w linii ściany, komunikat zamiast wyjątku, narożnik wklęsły
do podpowiedzi, podpowiedzi podłogi, listy przekrojów z długościami. Podbitka w polach zależnych – była już w kodzie od
rundy 7 (`wybory_gdy` w `rdzen/parametry_dach.rb`). Z 2026-11-25: prosty odbiór, pasek narzędzi.

## 6. Pytania do użytkownika (krótka lista)

Pełna tabela wartości przyjętych bez pytania – `docs/pytania_otwarte.md`. Rozstrzygnięte 2026-11-25 20:26: T8 (szczyty na
styk z przesunięciem 300), deski (14 × 115 × 4000), 45 × 120 (5,4 / 6). Naprawdę potrzebne odpowiedzi:

1. **Nadbitka fabrycznie**: włączyć nadbitkę w ustawieniach fabrycznych, a deskowanie pełne wyłączyć?
2. **Propozycje r15**: które bierzemy (`docs/propozycje_r15.md` §5 – domyślnie ta kolejność)?
3. **Okna w ścianie z bala**: ościeżnica na listwie ślizgowej w czołach bali czy inaczej (propozycja N2)?
4. **Narożniki 45°, wykusze, altany wielokątne** – budujesz (propozycja N6)?
5. **Z9 – przybudówka**: czym podeprzeć płatwie zadaszenia w długim domu (słupki, węgły albo działowe przybudówki)?
6. **D1a – śnieg**: w jakich strefach stoją Twoje domy (dziś 0,9 kN/m² – strefa 2)?
7. **H21 – CNC**: co dostaje wykonawca CNC – zestawienie CSV wystarcza, czy potrzebne pliki BTLx / BVN?

## 7. Odbiór

`docs/scenariusz_odbioru.md` – trzy kroki: instalacja, przycisk „Test działania”, zwykła praca. Raport i dziennik pracy
zapisują się same w `raporty\`. Kompilacje 7–13 nie przeszły formalnego odbioru (użytkownik zgłaszał uwagi z pracy);
dawny scenariusz z 59 krokami – `docs/scenariusz_archiwum.md`. Z kompilacji 14 w prawdziwym SketchUpie do potwierdzenia:
pasek narzędzi i ikony, menu pod prawym przyciskiem, zapis raportu do folderu w Dokumentach, okienko po awarii.

## 8. Ograniczenia (kompilacja 14)

- Działowa w linii ściany obrysu: obie ściany łączą się na styk w zamku ściany poprzecznej we wszystkich wieńcach (jak
  „Łączenie przy działowej” = wspólne); bala ciągłego przez ten węzeł generator nie robi. Gdy linia leży między dwoma
  uskokami o ścianach po przeciwnych stronach (obrys Z), działowa bierze oś pierwszej z nich.
- Dwie ściany narysowane bliżej niż długość węgła: generator ostrzega („zajmują to samo miejsce”), nie poprawia.
- Długości handlowe: dobór bierze przekrój dostępny w całej długości tylko dla płatwi i członów zadaszenia; legary,
  podciągi, krokwie i trójkąt nad tarasem – sama podpowiedź. Belka dłuższa niż handlowa zostaje w modelu w jednym kawałku
  (łączenia generator nie rysuje).
- Przekroje fabryczne spoza wykazu hurtowni: krokiew 50 × 150, legar ręczny 50 × 100, podciąg 100 × 150, deskowanie 25 × 100
  – do wymiany razem z magazynem drewna (runda 17); deski nadbitki i podbitki 19 × 121 → 14 × 115 w rundzie 15.
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
  zadaszenie i krokwie z generatora – tylko dom prostokątny (dom L: krokwie i poszycie z aplikacji do dachów). Okno nie
  ukrywa jeszcze opcji niedostępnych dla danego obrysu – ostrzega po przeliczeniu (runda 15).
- Dom L: końce płatwi skrzydła bocznego w dachu głównym bez własnej podpory (belki koszowej generator nie rysuje); gdy
  wysunięcie za szczyt jest mniejsze niż okap, na ścianie wspólnej połać wystaje za szczyt o okap; ściana przez oba
  skrzydła bierze dach tego skrzydła, w którym leży jej środek. Dom L z podbitką na płatwiach i krokwiami z aplikacji:
  podpory 19 mm pod połacią (ziarna 7004, 7021).
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
| 15 | Zdecydowane zaległości: szczyty na styk (T8), pół zamka, deski 14 × 115 × 4000, 45 × 120; z propozycji P1 (osiadanie słupów) i W2 (pełne zestawienie materiałów); przygotowanie rundy 16 – tabela podziału pól i szkic okna do akceptacji. Polecenie: `docs/prompt_r15.md` |
| 16 | Trzy poziomy ustawień z typami domów zapisywanymi przez użytkownika, okno z wynikiem zawsze na widoku, opcje wyszarzone dla obrysu; dom prostokątny z wymiarów (S1), powierzchnie i limity (W1) |
| 17 | Okna, drzwi, węgły i kanały na przewody kliknięciem z okienkiem parametrów; lista typowej stolarki; magazyn drewna jako tabela (z deską 14 × 115) i jeden przełącznik doboru; wycena materiału (W3) |
| 18 | Podparcie końców płatwi (dom L, taras typu 300), belki dzielone nad podporą, drobne błędy geometrii (P2, P3, P5) |
| dalej | Strop i antresola z belek (N1), wzór dobudówki z obrysami T i U (N4), okna dopasowane do wieńców (N2), grubszy bal (N5); Dokumentacja 2D (grupy bali, plan montażu); podgląd na żywo po pomiarze |

Na starcie każdej rundy: `raporty\` z dysku (§4), potem kolejka z §5.
