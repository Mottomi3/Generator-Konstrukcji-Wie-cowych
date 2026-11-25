# Stan prac – ArteMadera Generator Wieńcowy

Stan na: runda 15, kompilacja 15 (2026-11-25), wersja 1.0.0. Poprzednio: runda 14, kompilacja 14 (2026-11-25).
Testy: `bash testy/uruchom.sh` – 32 zestawy (nowe `t_styki_szczytu`, `t_osiadanie`, `t_materialy`, `t_pol_zamka`), 2090 sprawdzeń,
FAILURES 0; zestaw „Ruby 2.7.8” pominięty (brak Rubiego 2.7 w sesji – kontrola zasad Ruby 2.2 przechodzi). Poza zestawem:
600 losowych domów po szczytach na styk (ziarna 1–300 i 6001–6300), 150 z nowościami rundy 15 (9001–9150), 200 z pół zamkiem
włączonym i 120 złożonych (10001–10120) – bez nowych problemów (znane sprzed rundy: 94, 153, 6110, 6269; 9015 i 9087 to ten
sam rodzaj co 94 – dwie działowe narysowane 7–10 mm od siebie). Aplikacja do dachów bez zmian (3.12.0).

Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`, historia rund 1–14).
Dysk użytkownika: `C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\` (kod, dokumenty, paczka `.rbz`,
od rundy 14 także `raporty\` – raporty z testu działania i dziennik pracy zapisywane przez wtyczkę).

Ten plik to stan bieżący. Historia (nowości kompilacji 7–13, przebieg rund 1–13, moduły) – `docs/historia_rund.md`;
wartości przyjęte bez pytania – `docs/pytania_otwarte.md`; zasady konstrukcji – `docs/specyfikacja.md`.

## 1. Nowe w kompilacji 15 (polecenie z 2026-11-25 21:42 – `docs/prompt_r15.md`)

Zdecydowane zaległości (T8, deski, 45 × 120), propozycje P1 i W2, przygotowanie rundy 16.

- **Szczyty na styk** (`rdzen/styki_szczytu.rb`, parametr „Łączenie wieńców szczytu” `szczyt_styk` = styk | wegly): wieńce
  szczytu (od góry ściany w górę) dłuższe niż maksymalny bal łączą się na styk bez węgła i zamka – kalenica ∓ pół mijanki
  na przemian, w szerokim szczycie przy punktach równego podziału; ściana pod szczytem łączy się jak zwykła (także
  w zamku działowej), a węgły pod jej styki kończą się na wysokości ściany. Szczyt płaski (ściana wysoka dachu
  jednospadowego) i front tarasu – bez zmian. Na 600 losowych domach: domy ze stykiem bez zamka w ścianie ze szczytem
  31 → 10, bali węgłów pod styki na ścianach szczytowych o 28 % mniej.
- **Pół zamka w ostatnim połączeniu pod dachem** (`rdzen/pol_zamka.rb`, parametry `polzamek`, `polzamek_gleb`): bal
  szczytu, któremu zwykłe gniazdo od spodu zostawia pod skosem mniej niż 20 mm, przechodzi przez narożnik bez gniazda,
  a bal pod nim dostaje gniazdo do połowy wysokości (72 zamiast 36; zostaje mu 31). **Fabrycznie wyłączone** – czeka na
  akceptację rysunku `docs/ostatnie_polaczenie_r15.png` (użytkownik 22:23: „tak, by ten kawałek … nie odpadał – mowa tylko
  o tym jednym ostatnim niefortunnym połączeniu”). Pomiar (444 domy ze szczytami): 370 bali uciętych przy narożniku mimo
  bala pod spodem, 324 mieszczą pół zamka; z włączonym – 200 domów bez nowych problemów.
- **Deski 14 × 115 × 4000** (`rdzen/parametry_dach.rb`): grubość i krycie nadbitki i podbitki 19 × 121 → 14 × 115;
  **nadbitka fabrycznie włączona, deskowanie pełne wyłączone**. **45 × 120** w długościach 5,4 / 6 m
  (`rdzen/wykaz_drewna.rb`). Plik ustawień w wersji 4 (`sketchup/ustawienia.rb`): zapamiętane 19 / 121, lista legarów
  i wybór warstw poszycia wracają do fabrycznych (deski i lista – także we własnych szablonach).
- **Słupy krótsze o osiadanie ścian** (P1 – `rdzen/osiadanie.rb`, `rdzen/taras_slupy.rb`; parametry `slup_osiadanie`,
  `slup_regulacja`, `slup_regulacja_wysokosc`): wierzch słupa tarasu niżej o luz osiadania (wysokość do głowicy ×
  „Osiadanie ścian”, np. 34 mm) i śrubę regulacyjną (40 mm) albo podkładki; zamek górny słupa dłuższy o śrubę. Podpowiedź
  w sekcji tarasu.
- **Zestawienie materiałów** (W2 – `rdzen/materialy.rb`, sekcja parametrów „Zestawienie materiałów”): deski nadbitki,
  deskowania, podbitki i płyty OSB w m² i sztukach z zapasem, taśma między wieńcami i izolacja pod pierwszy wieniec
  w metrach, okucia (śruby regulacyjne i podstawy słupów, kotwy podwalin, łączniki krokwi z płatwiami), powierzchnie do
  impregnacji i litry impregnatu. Tabela w oknie pod listą bali i drugi blok w pliku CSV.
- **Przygotowanie rundy 16** – do akceptacji: `docs/podzial_pol_r16.md` (194 pola: Ten dom 16, Typ domu 49, Standard
  warsztatu 129) i `docs/szkic_okna_r16.png` (`.html`).
- Parametrów: 194 (nowe: `szczyt_styk`, `polzamek`, `polzamek_gleb`, `slup_osiadanie`, `slup_regulacja`,
  `slup_regulacja_wysokosc`, `material_zapas`, `tasma_pasy`, `kotwy_podwalin_rozstaw`, `impregnat_wydajnosc`,
  `impregnat_warstwy`).

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
| Pół zamka w ostatnim połączeniu pod dachem (bal bez gniazda od spodu, bal pod nim wycięty do połowy – 72 mm) | 2026-11-14, rysunek 2026-11-25 22:30 | kod gotowy i przetestowany, **fabrycznie wyłączony** – czeka na akceptację rysunku `docs/ostatnie_polaczenie_r15.png`; po „tak”: `polzamek` domyślnie tak + to samo na górze węgła pod krokwiami / podbitką | 16 |
| Podział pól: Ten dom 16 / Typ domu 49 / Standard warsztatu 129 (`docs/podzial_pol_r16.md`) | 2026-11-25 | **do akceptacji** – potem cecha `poziom:` w liście parametrów, typy domów zapisywane przez użytkownika (`docs/zadanie_r15.md` §1) | 16 |
| Okno: wynik zawsze na widoku, kroki w kolejności budowy, podpowiedź po wejściu w pole (`docs/szkic_okna_r16.png`) | 2026-11-25 | **do akceptacji** szkicu – kod w rundzie 16 (§2) | 16 |
| Styk w najwyższym wieńcu nad końcem węgła (ściana wysoka dachu jednospadowego, podbitka pod płatwiami) – traktować jak styk na styk z mijanką: podpowiedź zamiast ostrzeżenia | 2026-11-25 (propozycja) | do decyzji – dziś ostrzeżenie „styk bez zamka” (15 domów na 600) | 16 |
| Okna, drzwi i węgły kliknięciem w widoku ściany; przy kliknięciu okienko z parametrami; lista typowej stolarki | 2026-11-25 | do zrobienia – §3 | 17 |
| Jeden magazyn drewna (tabela zamiast pięciu list, z deską 14 × 115) i jeden przełącznik doboru przekrojów | 2026-11-25 | podstawa gotowa w r14 (`rdzen/wykaz_drewna.rb`); tabela i przełącznik – §4 | 17 |
| Propozycje po rundzie 14: W1, S1 (runda 16), N3, W3 (17), P2, P3, P5 (18), N1, N4, N5, W4, W5 (dalej) | 2026-11-25 21:42 („tak” – kolejność z `docs/propozycje_r15.md` §5) | przyjęte w tej kolejności; N2 – bez wpustu w czołach bali (okna drewniane z maskownicą na stałe, przykręcane od zewnątrz), N6 – odpada („nie w tych konstrukcjach”) | 16–18 |
| Dom T, U, krzyż: kalenica z dachu o większej powierzchni, skrzydeł dowolnie wiele | 2026-11-14 | osobna runda, razem ze wzorem dobudówki (N4) | po 18 |
| Repozytorium prywatne | 2026-11-25 | do zrobienia przez użytkownika w ustawieniach GitHuba (`docs/przekazanie_r14.md` §5) | – |

Wykonane w rundzie 15: T8 (szczyty na styk), deski 14 × 115 × 4000 z nadbitką fabrycznie, 45 × 120 w 5,4 / 6 m, P1 (słupy
krótsze o osiadanie), W2 (zestawienie materiałów), tabela podziału pól i szkic okna.
Wykonane w rundzie 14 (z 2026-11-14): poprawka działowej w linii ściany, komunikat zamiast wyjątku, narożnik wklęsły
do podpowiedzi, podpowiedzi podłogi, listy przekrojów z długościami. Podbitka w polach zależnych – była już w kodzie od
rundy 7 (`wybory_gdy` w `rdzen/parametry_dach.rb`). Z 2026-11-25: prosty odbiór, pasek narzędzi.

## 6. Pytania do użytkownika (krótka lista)

Pełna tabela wartości przyjętych bez pytania – `docs/pytania_otwarte.md`. Odpowiedzi z 2026-11-25 21:42: kolejność propozycji
jak w `docs/propozycje_r15.md` §5; okna drewniane z maskownicą na stałe, przykręcane od zewnątrz do ściany; narożników 45°
i wykuszy nie buduje. Naprawdę potrzebne odpowiedzi:

1. **Pół zamka**: czy ostatnie połączenie pod dachem robić jak na rysunku `docs/ostatnie_polaczenie_r15.png` (bal górny
   bez wycięcia, w balu pod nim 72 mm zamiast 36)? Po „tak” włączam fabrycznie.
2. **Podział pól** (`docs/podzial_pol_r16.md`) i **szkic okna** (`docs/szkic_okna_r16.png`) – przyjmujesz?
3. **Nadbitka fabrycznie**: włączona, deskowanie pełne wyłączone – tak zrobione w kompilacji 15; jeśli „1. tak” z 21:42
   dotyczyło tylko kolejności propozycji, potwierdź albo każ cofnąć.
4. **Z9 – przybudówka**: czym podeprzeć płatwie zadaszenia w długim domu (słupki, węgły albo działowe przybudówki)?
5. **D1a – śnieg**: w jakich strefach stoją Twoje domy (dziś 0,9 kN/m² – strefa 2)?
6. **H21 – CNC**: co dostaje wykonawca CNC – zestawienie CSV wystarcza, czy potrzebne pliki BTLx / BVN?
7. **Okucia w zestawieniu**: jakich podstaw słupów, kotew i łączników krokwi używasz naprawdę (nazwy do zestawienia)?

## 7. Odbiór

`docs/scenariusz_odbioru.md` – trzy kroki: instalacja, przycisk „Test działania”, zwykła praca. Raport i dziennik pracy
zapisują się same w `raporty\`. Kompilacje 7–13 nie przeszły formalnego odbioru (użytkownik zgłaszał uwagi z pracy);
dawny scenariusz z 59 krokami – `docs/scenariusz_archiwum.md`. W prawdziwym SketchUpie do potwierdzenia z kompilacji 14:
pasek narzędzi i ikony, menu pod prawym przyciskiem, zapis raportu do folderu w Dokumentach, okienko po awarii (na starcie
rundy 15 folderu `raporty\` nie było – kompilacja 14 nie była uruchamiana); z kompilacji 15: pięć punktów scenariusza.

## 8. Ograniczenia (kompilacja 15)

- Szczyt na styk: tylko szczyt skośny ściany domu; szczyt płaski (ściana wysoka dachu jednospadowego, działowa do dachu,
  ściana przybudówki) łączy się w zamkach węgłów – tam i w ścianie domu L pod dachem skrzydła bocznego zostaje ostrzeżenie
  „styk bez zamka”, gdy węgieł kończy się pod podbitką albo krokwiami (15 domów na 600 losowych). W szerokim szczycie bez
  węgłów nic nie usztywnia wieńców szczytu poza płatwiami.
- Pół zamka: tylko narożnik (bal ścięty skosem, bal ściany poprzecznej poziom niżej, żadnego wyżej, pod skosem ≥ 20 mm);
  góra węgła pod krokwiami albo podbitką – jeszcze nie (29 miejsc na 600 domów). Fabrycznie wyłączone.
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
  zadaszenie i krokwie z generatora – tylko dom prostokątny (dom L: krokwie i poszycie z aplikacji do dachów). Okno nie
  ukrywa jeszcze opcji niedostępnych dla danego obrysu – ostrzega po przeliczeniu (runda 16).
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
| 16 | Po akceptacji: pół zamka fabrycznie i na górze węgła; trzy poziomy ustawień z typami domów zapisywanymi przez użytkownika (`docs/podzial_pol_r16.md`), okno z wynikiem zawsze na widoku (`docs/szkic_okna_r16.png`), opcje wyszarzone dla obrysu; dom prostokątny z wymiarów (S1), powierzchnie i limity (W1). Polecenie: `docs/prompt_r16.md` |
| 17 | Okna, drzwi, węgły i kanały na przewody kliknięciem z okienkiem parametrów; lista typowej stolarki; magazyn drewna jako tabela (z deską 14 × 115) i jeden przełącznik doboru; wycena materiału (W3) |
| 18 | Podparcie końców płatwi (dom L, taras typu 300), belki dzielone nad podporą, drobne błędy geometrii (P2, P3, P5) |
| dalej | Strop i antresola z belek (N1), wzór dobudówki z obrysami T i U (N4), okna dopasowane do wieńców (N2), grubszy bal (N5); Dokumentacja 2D (grupy bali, plan montażu); podgląd na żywo po pomiarze |

Na starcie każdej rundy: `raporty\` z dysku (§4), potem kolejka z §5.
