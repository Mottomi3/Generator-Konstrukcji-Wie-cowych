# Historia rund – ArteMadera Generator Wieńcowy

Wydzielone z `docs/stan_prac.md` w rundzie 14 (2026-11-25), żeby stan bieżący dało się przeczytać szybko. Treść bez zmian:
najpierw opis nowości kolejnych kompilacji (od najnowszej), potem stan kompilacji 6, przebieg rund z prośbami użytkownika
i lista modułów dodawanych w rundach. Bieżący stan, kolejka decyzji i plan – `docs/stan_prac.md`.

Runda 16 (kompilacja 16) – opis w `docs/stan_prac.md` §1 i `docs/przekazanie_r16.md`; przy następnej rundzie przenieść tutaj.
Runda 15 (kompilacja 15) – na końcu tego pliku („Nowe w kompilacji 15”) i w `docs/przekazanie_r15.md`.

# Część A – nowości kompilacji 7–14

## 1h. Nowe w kompilacji 14 (prośba z 2026-11-25 19:00: „wprowadź te zaległe zmiany”)

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

## 1g. Nowe w kompilacji 13 (prośba z 2026-11-25 17:19)

- **Osobna zakładka „Zadaszenie boczne / tylne”** (`html/zakladki.js`, `rdzen/parametry_lista.rb` ZAKLADKI, czwarty element
  SEKCJE): okno ma dwie zakładki – „Dom” (wszystkie dotychczasowe sekcje) i zadaszenie (sekcje „Zadaszenie – rodzaj
  i wymiary” oraz „Zadaszenie – przekroje (dobór)”); w nazwie zakładki liczba zmienionych pól, wybrana zakładka zostaje po
  wczytaniu szablonu. Wszystkie parametry `zadaszenie_*` tylko w tej zakładce.
- **Dobór przekrojów zadaszenia** (`rdzen/statyka_zadaszenia.rb`, `rdzen/statyka_slupa.rb`): „Przekroje zadaszenia –
  dobór”: automatycznie (domyślnie) – najmniejsze wystarczające z list „Dostępne przekroje belek zadaszenia” (płatwie
  z oczepem, belki poprzeczne) i „… słupów zadaszenia”; z wyboru – przekroje z pól ze sprawdzeniem i radą. Płatwie
  i oczep – przęsło między liniami słupów / ścianami, pas połaci zadaszenia; belka poprzeczna – od słupa do ściany; słup –
  ściskanie z wyboczeniem (PN-EN 1995 §6.3.2). Obciążenia jak dach (śnieg, ciężar pokrycia) przy kącie zadaszenia.
- **Dobór krokwi** (`rdzen/statyka_krokwi.rb`, „Przekrój krokwi – dobór” w „Szczyty i dach”): jeden przekrój krokwi
  całego dachu (także krokwie zadaszenia – jak KROK 2 aplikacji), automatycznie z listy „Dostępne przekroje krokwi” albo
  z wyboru ze sprawdzeniem; wynik krokwi zadaszenia w zakładce zadaszenia. Z aplikacją do dachów – dobrany przekrój na
  start KROKU 2.
- **Podłoga w przybudówce do wyboru** (`rdzen/podloga_przybudowki.rb`, „Przybudówka – podłoga”): bez podłogi – legary
  i podciągi tylko w domu (do podwaliny dawnej ściany okapowej), podwaliny i fundamenty pod ścianami przybudówki;
  kierunek legarów („krótszy / dłuższy bok”) liczony z pola podłogi. Dawna ściana okapowa zawsze na podwalinie (także gdy
  „Podwaliny pod działowymi” = nie).
- Test działania: przykład 10 – wiata z przekrojami dobranymi, 11 – przybudówki bez podłogi z krokwiami dobranymi.
- Poprawka znaleziona losowymi domami: belka poprzeczna zadaszenia przy płatwi ściennej stojącej na ścianie i szerszej niż
  ściana – gdy wierzch belki jest wyżej niż spód płatwi, belka kończy się przy boku płatwi (linia załamania), nie przy
  licu ściany (`rdzen/zadaszenie.rb#koniec_belki`; mniejsze dobrane przekroje podnosiły belkę – kolizja 5 mm, ziarno 9008).

## 1f. Nowe w kompilacji 12 (prośba z 2026-11-25 15:10)

- **Boczne zadaszenie z załamaniem dachu** (`rdzen/zadaszenie.rb`, sekcja okna „Boczne zadaszenie”): połać za ścianą
  okapową schodzi dalej pod mniejszym kątem (`zadaszenie_kat` < `dach_kat`), na całej długości ściany, po jednej albo obu
  stronach. Linia załamania nad licem zewnętrznym ściany okapowej. Do wyboru:
  - **na słupach z oczepem** (wiata, drewutnia): słupy na fundamentach punktowych, belka poprzeczna na każdym słupie do
    ściany domu (skrajne – do końca ostatków, pośrednie omijają węgły i działowe), oczep na belkach, płatwie zadaszenia na
    słupkach, pierwsza płatew przy ścianie – w gniazdach ostatków ścian szczytowych;
  - **ściany z bali** (przybudówka): obrys poszerzony, dawna ściana okapowa jako działowa z oparciem dachu domu, ściany
    szczytowe przedłużone z łamaną linią szczytu, niska ściana zewnętrzna ścięta do połaci zadaszenia.
- **Linia dachu z dwoma załomami** (`rdzen/dach.rb#linia_podparcia`, `#zalomy_v`): kalenica i załamanie – szczyty, bale pod
  dachem, węgły, ścięcia dachu, widok ściany.
- **Aplikacja do dachów 3.12.0 zna załamanie** (zmiany w tej sesji, decyzja użytkownika „tutaj, w obu”): połacie z opcją
  `:zalamania`, krawędź załamania w KROKU 2, łaty po obu stronach przy linii załamania, **pełne moduły pod załamaniem**
  (okap zadaszenia wydłużany), krokwie / kontrłaty / deski docięte w płaszczyźnie dwusiecznej, podpora na krawędzi połaci
  liczona dla obu połaci (wcześniej prośba 1 z części 2 zadania). Generator przekazuje załamanie (`rdzen/polacie.rb#zalamania`,
  `sketchup/dach_aplikacja.rb`) – ze starszą aplikacją komunikat zamiast połaci.
- Krokwie z generatora: krokiew zadaszenia od okapu zadaszenia do linii załamania.
- Test działania: 11 przykładów (dziesiąty – wiata, jedenasty – przybudówki po obu stronach).
- Poprawka znaleziona losowymi domami: skos bala (szczyt, bal pod dachem) przechodzący bliżej niż 0,2 mm od naroża gniazda
  zamka – obniżony do naroża albo do odstępu 0,2 mm (`rdzen/sciecie_dachu.rb#wyrownaj_skosy!`; krawędzie 0,003–0,015 mm
  w węgłach ściany przybudówki, ziarna 8180, 8209).
- Ściana przybudówki: najcieńszy górny bal liczony na niższym licu zewnętrznym (połać opada w poprzek ściany o grubość ·
  tg kąta zadaszenia) – koniec cienkich klinów w górnym balu (`rdzen/szczyty.rb#zasieg`, ziarno 9056 z wymuszonym zadaszeniem).

## 1e. Nowe w kompilacji 11 (uwagi z 2026-11-16 16:08 i 20:44)

- **Słupki z kontrfor (węgły) pod płatwiami – do wyboru** (`rdzen/wegly_konstrukcyjne.rb`): pole przemianowane na
  „Słupki z kontrfor (węgły) pod płatwiami” (nie / szczyty zewnętrzne / wszystkie), nowe „Słupki pod płatwiami – pod
  którymi” (pod każdą płatwią / tylko pod kalenicową). Sekcja nazywa się teraz „Węgły (kontrfory) 244”.
- **Płatew kalenicowa na ostatniej kontrforze**: węgieł, który już stoi w osi płatwi (np. automatyczny na środku ściany
  szczytowej – wtedy słupek pod kalenicową nie powstawał, a węgieł ze środka kończył się pod połacią), jest teraz
  węgłem pod płatwią i dochodzi do jej spodu. Do tego `rdzen/platwie_wience.rb` pilnuje bala węgła: dach obniżony /
  płatew pośrednia przesunięta tak, żeby górny bal węgła był pełny albo ≥ najcieńszy pasek – koniec szczelin do 20 mm
  między węgłem a płatwią (W4).
- **Słup frontu tarasu w osi kalenicy** (`rdzen/taras.rb#slup_w_osi`): słup tarasu i słupek trójkąta w jednej linii;
  słup wejścia bliżej osi niż 500 staje w osi.
- **Front tarasu bez kontrfor** (`rdzen/wegly_tabela.rb`, `rdzen/styki_tarasu.rb`): bez węgła „na środku ściany” (to on
  dawał kontrforę z półzamkami w trójkącie) i bez węgłów pod styki; długi front łączony na styk nad słupem, sąsiedni
  wieniec o mijankę dalej.
- **Zamek płatwi nad szczytem tarasu tylko od spodu** (`rdzen/zamek_platwi.rb`, `taras_platwa_zamek`): wręby płatwi
  z własną głębokością boczną.
- **Słupek i zastrzały trójkąta** z własnych szerokości albo jak reszta trójkąta (`taras_wiazar_przekroje`).
- **Trójkąt w wąskim domu** (`rdzen/taras_wiazar.rb#postac`): nie znika – postać uproszczona z ostrzeżeniem (same
  krokwie na balach frontu; na słupach – sama belka dolna).
- **Automatyczny dobór przekrojów dachu** (`rdzen/statyka_dachu.rb`, `rdzen/statyka_wiazara.rb`): „Przekrój płatwi –
  dobór” (ręcznie ze sprawdzeniem / automatycznie) i „Trójkąt z przekroju – dobranego automatycznie”; parametry „Śnieg –
  obciążenie gruntu” (0,9), „Ciężar pokrycia z poszyciem” (0,35), „Ugięcie płatwi dopuszczalne L /” (200), „Dostępne
  przekroje płatwi” (Nsi / DUO / BSH z wykazu użytkownika). Obliczenia domu w dwóch przebiegach (`rdzen/projekt.rb`).
  Wynik: podpowiedzi w sekcjach „Szczyty i dach” i „Taras” – także przy doborze ręcznym.
- Ostrzeżenie, gdy zastrzały trójkąta się nie mieszczą (wcześniej pomijane bez słowa).

## 1d. Nowe w kompilacji 10 (uwagi z 2026-11-10 22:24)

- **Dom w kształcie L – dwa dachy z koszem** (`rdzen/skrzydla.rb`; wybór użytkownika z trzech wariantów): skrzydło główne
  (o większej rozpiętości; przy równych – wg „kalenica”) ma dach dwuspadowy na całej długości z dwoma szczytami, skrzydło
  boczne – kalenicę w poprzek, szczyt na wolnym końcu i wchodzi w dach główny dwoma koszami. Trzy szczyty z bali; ściana
  wspólna (szczyt dachu głównego + ściana okapowa skrzydła bocznego) ma szczyt na części długości. Płatwie obu dachów:
  głównego na całą długość, bocznego od szczytu do kosza (albo na styk do płatwi dachu głównego, w którą by weszły).
  Ten sam poziom okapu obu dachów. Węgły, działowe, bale pod okapem ścinane do dachu skrzydła, w którym stoją; gniazda
  płatwi, węgły pod płatwiami, wypuszczone górne wieńce – w obu skrzydłach. Połacie dla aplikacji do dachów: jeden obrys
  z uskokiem (≥ 1 mm) na ścianie wspólnej → aplikacja 3.7.0 robi 5 połaci z koszami (sprawdzone na prawdziwej wtyczce:
  ±0,01 mm względem generatora; deski na płatwiach i krokwie z KROKU 2).
- **Wypust górnych wieńców tylko na zewnątrz** (`rdzen/wypusty_okapu.rb`): w narożniku wklęsłym (do środka domu) górny bal
  kończy się zwykłym ostatkiem (100), nie wysunięciem płatwi (300) – także przy obrysach bez dachu z generatora.
- **Okno zawsze od nowa** (`sketchup/sterowanie.rb#dom_czy_linie`, `sketchup/okno.rb`, `sketchup/ustawienia.rb`):
  zaznaczony dom razem z innymi liniami – pytanie „nowy dom z linii / edycja domu” (wcześniej dom w zaznaczeniu zawsze
  wygrywał i okno otwierało się z jego parametrami); po zamknięciu okna nic po nim nie zostaje w pamięci, pamięć
  podręczna płatwi czyszczona przy każdym otwarciu; plik ustawień w wersji 2 (zmienione wartości fabryczne zastępują
  zapamiętane – `DO_FABRYCZNYCH`).
- **Wiązar nad tarasem pod płatwiami** (`rdzen/taras_wiazar.rb`): wierzch krokwi wiązara obniżony pod płatwie – każda
  płatew leży na nich w gnieździe (zamku) o głębokości ≥ `taras_wiazar_gniazdo` (20), krokwie w jednym kawałku (wcześniej
  gniazda na całą wysokość cięły je na części); zastrzały od stopy słupka pod kątem `taras_wiazar_zastrzal_kat` (45°;
  0 – do połowy krokwi), pomijane, gdy się nie mieszczą.
- **Podciąg podłogi domyślnie na wysokości podwalin** (`podciag_poziom` = rowno): legary dzielone na podciągu; zapamiętane
  „obniżony” z kompilacji 9 wraca jednorazowo do nowej wartości fabrycznej.

## 1c. Nowe w kompilacji 9 (uwagi z 2026-11-02 23:24)

- **Węgły pod płatwiami** (`rdzen/wegly_konstrukcyjne.rb`, `wegly_pod_platwiami`, domyślnie na szczytach zewnętrznych
  i ścianie domu przy tarasie): pod każdą płatwią przechodzącą przez szczyt węgieł do spodu płatwi – płatew na nim leży,
  w słupie zamka czop we wrębie płatwi; przy narożniku, skrzyżowaniu (np. działowa pod kalenicą) i na ścianie z węgłami
  ręcznymi – bez.
- **Wypust 200 na zewnątrz wszędzie**: końce działowych przechodzące przez ścianę zewnętrzną (i ściana domu przy tarasie)
  wychodzą o „Węgieł – wypust na zewnątrz”; węgły na ścianie domu przy tarasie – 200 od strony tarasu.
- **Węgieł na wolnym końcu** niepełnej ściany (`wegly_wolny_koniec`, od wolnego odcinka `wegly_wolny_koniec_min` 1000).
- **Przesuwanie węgłów** w karcie „Okna i drzwi” (`html/wegly_przesun.js`): lista wszystkich węgłów z „od” i strzałkami ±50.
- **Wiązar nad tarasem** (`rdzen/taras_wiazar.rb`): licem z frontem, krokwie z gniazdami pod płatwie (płatwie z wrębem
  5 / 10 na grubości wiązara), belka dolna, słupek, opcja zastrzałów (`taras_wiazar`), opcja „na słupach” – szczyt bez
  bali, z przodu sam trójkąt (`taras_wiazar_podparcie`).
- Poprawki znalezione losowymi domami: ścięcie dachu ze stopniem 0,077 mm przy granicy pióra (płaszczyzna tylko w dół),
  węgieł ręczny w miejscu słupa tarasu (pominięty z ostrzeżeniem).

## 1b. Nowe w kompilacji 8 (uwagi z 2026-11-02 21:17)

- **Zamek płatwi bez szczeliny**: gniazdo w ścianie = szerokość wrębu (bez luzu gniazda), dno na spodzie wrębu – bal
  dochodzi do końca zamka z boków i od spodu, ściana zablokowana w płatwiach.
- **Węgły pod dachem**: słupek węgła przy szczycie dochodzi do płaszczyzny dachu (górny bal ścięty w poprzek, gdy nad
  zamkiem zostaje drewna: gniazdo + `zamek_min_drewno`); węgły na ścianach okapowych dostają wieniec nad górą ściany,
  ścięty linią dachu – podpierają płatwie i krokwie.
- **Węgły niesymetryczne**: `wegiel_wypust_wewn` / `wegiel_wypust_zewn` (domyślnie 100 / 100) i kolumny „Wewn.”, „Zewn.”
  w tabeli węgłów (pojedynczy węgieł).
- **Węgły symetrycznie** (`rdzen/symetria_wegly.rb`): ściana równoległa o tym samym zasięgu dostaje styki i węgły
  w tych samych miejscach; przy „równo” nowe węgły w punktach równego podziału odcinków między ścianami / działowymi,
  wybór układu po najmniejszej liczbie węgłów razem (pod styki + usztywniające).
- **Wypusty pod dachem** (`rdzen/wypusty_okapu.rb`): `okap_wience_wypust` (2) górnych wieńców ścian okapowych wypuszczonych
  za szczyty jak płatwie (styki liczone z wypustami); opcja `wegly_wypust_okap` (domyślnie nie) – górne bale węgłów na
  ścianach okapowych wysunięte do nawisu okapu, ścięte linią dachu (wsporniki).
- **Podłoga**: fundament okrągły (`fundament_ksztalt`, `fundament_srednica`, wielokąt 24 boki); rzędy fundamentów
  przechodzą przez osie działowych (stopa zawsze w osi działowej, także przy tarasie), odcinki między nimi równo;
  podciąg obniżony albo na równo z podwaliną (`podciag_poziom` – między licami wewnętrznymi podwalin, legary dzielone na
  podciągu).
- **Taras**: balustrada z wieńców ścian (`taras_balustrada_rodzaj` = sciany, `rdzen/taras_sciany.rb`) – ściany boczne
  ciągle przez cały taras do wysokości balustrady, front w tych wieńcach z przerwą na wejście, zamki w narożnikach frontu
  z zakładką (co druga belka wysunięta o `taras_zakladka_wypust` 100) albo równo z licem, poręcz na jednej wysokości,
  słupy z wyciętym pasem; szczyt pusty – trójkątny wieniec (`taras_wieniec`: z przekroju płatwi albo podanego, prefiks
  Wt) – dwie belki od bali spinających do kalenicy, płatwie na nich.
- **Typy 100–400** zamiast numerów projektów: szablony wbudowane „Typ 100 – domek parterowy na samych płatwiach”,
  „Typ 200 – … taras na słupach”, „Typ 300 – 1,5 kondygnacji ze stropem, taras między ścianami”, „Typ 400 – dach
  jednospadowy”; opisy pól i wybory bez „jak 900 / 1100 / 1200 / 1800” (wersje użytkownika: 101, 102…).
- Poprawki geometrii: ścięcie w poprzek bliskie granicy pasa – płaszczyzna dosunięta do granicy; koniec klina szczytu
  niżej niż 0,2 mm – ostrze na spodzie (krawędzie krótsze niż tolerancja SketchUpa).

## 1a. Nowe w kompilacji 7 (uwagi z odbioru kompilacji 6, 2026-11-01)

- **Płatwie**: jeden przekrój wszystkich płatwi (domyślnie 80 × 200, `platwie_jeden_przekroj`); pełna wysokość po
  wyższej stronie, ścięcie pod dach tylko od strony okapu; płatew ścienna stojąca na ścianie też ścięta do dachu.
- **Płatwie na pełnym balu** (`rdzen/platwie_wience.rb`): dach obniżony (≤ `dach_obnizenie_max` 60) i płatwie
  pośrednie przesunięte (≤ `platwie_przesuniecie_max` 150), żeby pod gniazdem nie zostawał pasek cieńszy niż 20 mm –
  koniec przerw pod płatwiami; czego się nie da – pasek zostaje (bez przerwy).
- **Ściana nośna** zamiast płatwi ściennej (`platwa_na_scianie` = nie): górny bal ściany okapowej **ścięty w poprzek do
  płaszczyzny dachu** (`rdzen/sciecie_dachu.rb`, obróbka `sciecie_dachu`), ściana jako podpora krokwi w KROKU 2; tak samo
  ściana wysoka dachu jednospadowego i działowa wzdłużna pod dachem.
- **Zamki w płatwiach** (`rdzen/zamek_platwi.rb`): wrąb 5 z boku i 8 od spodu (parametry, luz 1 wzdłuż) w każdej ścianie,
  przez którą płatew przechodzi – płatwie trzymają szczyty.
- **Działowa wzdłuż kalenicy do dachu** (`dzialowa_wzdluz_do_dachu`): pod kalenicą do płatwi kalenicowej (gniazdo na
  całej długości), boczne – górny bal ścięty do dachu.
- **Styki w zamku działowej** (`rdzen/styki_dzialowe.rb`, `styk_na_dzialowej` = wspolny): wszystkie wieńce łączone
  w osi działowej – bez węgłów i drugiego rzędu; reszta ściany na przemian z mijanką ≥ 300 od styku wspólnego.
- **Węgły jak okna** (`rdzen/wegly_tabela.rb`, `html/wegly.js`): tabela (ściana, od narożnika albo na środku) i węgieł
  automatycznie na środku ścian (`wegly_srodek`, od `wegly_srodek_min` 4000).
- **Taras jak 1100**: słupy licem z licami ścian, zamek górny 150 i dolny 100 (`rdzen/taras_slupy.rb`); naroże na
  jednym poziomie – bale ścian bocznych na półbalu frontu z gniazdem; poręcz frontu i boku na tej samej wysokości,
  ostatni bal bez piór; szczyt nad tarasem pełny / ażurowy / pusty (`rdzen/taras_szczyt.rb`); widoki ścian tarasu.
- **Podłoga**: podwalina z wyboru (np. 50 × 150 na kant, łączenie na zakład albo na śruby bez zamków), podciągi
  z wyboru (auto / tak / nie), od lica do lica podwalin i pod nimi (`rdzen/podciagi.rb`), **fundamenty punktowe**
  w obrysie (siatka ≤ 2500, skrajne licem z licem, pod podwalinami działowych; `rdzen/fundamenty.rb`), legar ręczny do
  sprawdzenia z wynikiem przy polu, dodatkowy rząd fundamentów z podpowiedzią, gdy legar za słaby.
- **Podbitka** (`rdzen/podbitka.rb`): pod płatwiami, na płatwiach, pod krokwiami, na krokwiach – wybory zależne od
  układu dachu; na płatwiach krokwie leżą na deskach (uniesione o grubość deski), na krokwiach – na wierzchu krokwi;
  na krokwiach (i na samych płatwiach) z aplikacją do dachów – nadbitka KROKU 2 z wymiarami podbitki.
- **Okno**: pola i wybory zależne pokazują się / znikają (`html/zalezne.js`), pytajniki z objaśnieniem i rysunkiem
  (`html/pomoc.js` – obciążenie, ugięcie, podbitka, płatew ścienna, układ dachu), przeliczenia przy sekcjach i „co się
  zmieniło” po podglądzie (`html/przeliczenia.js`), „Spód okna (od podwaliny)” zamiast „parapet”; parametry podzielone
  na pliki sekcji (`rdzen/parametry_dach.rb`, `parametry_podloga.rb`, `parametry_taras.rb`).

# Część B – stan kompilacji 6

## 1. Co działa (kompilacja 6)

- Rozpoznanie linii: obrys (lico zewnętrzne), osie działowych, węgły z krótkich linii; także zaznaczona ściana
  (prostokąt kliknięty raz); scalanie linii, dociąganie końców, dowolny obrót domu, obrys wielokątny (L, U…).
- Ściany zewnętrzne, działowe (T, X, wolny koniec), węgły 244 jako ściany W-n; ostatki; numeracja jak producent.
- Wieńce: półbal na ścianach wzdłuż kalenicy, szczytowe o wieniec wyżej, ze szczytem – do kalenicy.
- Zamek 44 × 146 wg rysunku na każdym skrzyżowaniu (0 kolizji), wariant lustrzany z parametru.
- **Łączenie bali** na przemian (domyślne, jak 1200), para (900 W-2), jeden węgieł; mijanka ≥ 300 także między
  miejscami łączenia; styk tylko tam, gdzie kawałek jest dłuższy niż maksymalny bal; ściany ze szczytem łączone na
  węgłach; ostrzeżenie i kontrola „styk bez zamka”.
- **Węgły usztywniające**: limit światła 4800 / 3700 (ściany wysokie od 3000), rozmieszczenie równo / od narożników /
  tylko narysowane. Dom 4 × 4 – bez łączeń i bez węgłów. Węgły przy szczycie wchodzą w szczyt.
- **Szczyty**: skos dachu **pełnym klinem do końca** (szczyt wypełniony do linii dachu), gniazda płatwi, szczyt na
  działowej (opcja – krokwie z obu stron albo na nim), okruchy bali przy gniazdach pomijane; bale pod połacią (węgły,
  działowe) ścinane linią dachu; bal ścięty dachem przez narożnik tylko w zamku; ostrzeżenie o zbyt stromym dachu.
- **Dach** (dom prostokątny): dwuspadowy albo **jednospadowy** (ściana niska i wysoka, szczyty skośne); płatwie
  **podniesione i ścięte do płaszczyzny dachu**; krokwie i poszycie z **aplikacji do dachów** (domyślnie; przez jej
  stałe API, wersja 3.7.0+): połacie na wierzchu płatwi, **płatwie domu jako podpory** (kontrola krokwi – przęsła między
  płatwiami, kalenicowa bez rozporu; jednospadowy – także ściana wysoka), okno KROKU 2 z ustawieniami domu i
  **poszyciem** z sekcji „Poszycie dachu” (nadbitka, deskowanie, OSB); **same płatwie** (jak 900) – deski / OSB wprost
  na płatwiach, wzdłuż spadku, styki na płatwiach; więźba po OK powiązana z domem (przebudowa usuwa właściwą). Albo
  krokwie z generatora (z obu stron szczytu / od wewnątrz / od zewnątrz / na szczycie, bez poszycia); okapy.
- **Taras** przed ścianą szczytową: jak 1100 (podciąg z górnych wieńców na słupach, szczyt frontu, balustrada z bali
  i przekładek, wejście) albo jak 1200 (ściany boczne pełne, front otwarty); dach nad tarasem.
- **Podłoga**: podwaliny na zakład, legary, podciągi, dobór przekroju z podpowiedziami.
- **Okna i drzwi – stolarka**: wymiary stolarki w tabeli, otwór w balach = stolarka + luz boczny i górny (podpowiedź
  luzu na osiadanie z wysokości), stolarka w widoku ściany.
- Pozycje „nr-długość” bali (Bs, Kf, Sz) i belek (Pw, L, Pd, P, K, S – kody grup Dokumentacji 2D).
- Model: Dom > W-n / Podłoga / Dach / Taras > komponenty (bryły zamknięte, punkty bliższe niż 0,2 mm scalane), tagi,
  atrybuty Dokumentacji 2D, zapis parametrów, przebudowa (przesunięty lub obrócony dom zostaje na miejscu),
  wykrywanie ręcznych zmian, jedno „Cofnij”.
- **Okno**: sekcje z listy parametrów, podpowiedzi, szablony, „Przywróć fabryczne”, pola zmienione względem
  fabrycznych wyróżnione, **pola Podstawowe / Wszystkie** (25 najczęstszych z 75; tryb zapamiętany), rzut (klik
  ściany → widok), **widok ściany** (bale z numerami pozycji, styki, skrzyżowania, otwory, linia dachu), okna i drzwi,
  wynik z podpowiedziami, **zestawienie CSV** dla Excela.
- **Edycja w widoku ściany** (runda 4): ostatek każdego końca ściany (np. 200 pod taras), węgły kliknięciem (dodaj /
  usuń, „Przywróć automatyczne”), co jest nad działową (nic / strop / antresola / półka) i jej góra – zapisane w domu,
  przebudowa je zachowuje.
- **Działowa niższa – tylko pod stropem, antresolą albo półką** (runda 4): kończy się pełnym wieńcem pod podaną górą,
  nad nią przy każdej wyższej ścianie kolumna odcinków działowej 244 (344 przy ostatku 200) aż do góry tamtej ściany –
  jak 1100 W-6, W-7 i 1200 W-5, W-7; przy ścianie ze szczytem pod linią podparcia dachu. Parametr „strop nad
  parterem” – wszystkie działowe naraz; szablon „Dom 1,5 kondygnacji ze stropem nad parterem”.
- **Pełny profil bala** (przełącznik, do wizualizacji; runda 4): dwa pióra na wierzchu i wpusty od spodu (wymiary
  parametrami), pierwszy wieniec bez wpustu; zamki, pozycje i listy jak dla bala prostego.
- **Test działania i raport** (menu): 9 przykładowych domów budowanych w cofanej operacji (ósmy i dziewiąty – dach
  jednospadowy i taras z rundy 5),
  sprawdzenie brył (`manifold?`, objętość), liczby z planu i z modelu, zaznaczony dom, środowisko, dziennik → plik
  JSON do wysłania.
- Ustawienia zapamiętane na komputerze (ostatnie parametry i szablony).

# Część C – przebieg rund 1–13

## 5. Rundy

### Runda 1 (kompilacja 1)

Szkielet, rdzeń ścian, zamki, styki (para jak 900 W-2), otwory, warstwa SketchUpa, okno, testy z atrapą, spis treści,
paczka .rbz, podgląd 3D.

### Runda 2 (kompilacja 2) – „wszystko jako parametry”

Lista parametrów (okno z sekcjami i podpowiedziami, zapis ustawień, szablony), łączenia na przemian, węgły
usztywniające, szczyty z gniazdami płatwi, płatwie i krokwie, podłoga ze statyką.

### Runda 3 (kompilacja 3) – sprawdzenie całości i usprawnienia

- **Sprawdzenie**: 1000 losowych domów (prostokąty i L, działowe, węgły, otwory, losowe parametry) – wyjątki, kolizje
  w zamkach, mijanka, styki bez zamka, długości, bryły zamknięte, krótkie krawędzie, bale nad dachem, kolizje płatwi
  i krokwi z balami; wszystkie zestawy testów na Ruby 2.7.8; przegląd wywołań API SketchUpa.
- **Znalezione i poprawione błędy**: krokwie wchodzące w działową ze szczytem i w węgły przy szczycie; okruchy bali
  (poniżej 1 mm) między skosem a gniazdem płatwi; mijanka naruszona między miejscami łączenia (jeden węgieł, bal 3 m);
  styki w wieńcach szczytu poza zamkiem (działowa kończy się pod okapem); węgły przy szczycie zbyt niskie; krawędzie brył
  0,07–0,09 mm (SketchUp nie tworzy krawędzi < 0,0254 mm); błędne odszukanie ściany bryły po podziale (classify_point);
  nieudany otwór w ścianie bryły nie był zgłaszany; powtórzone ostrzeżenia.
- **Zgodność z Dokumentacją 2D**: belki z kodami jej grup (P płatwie, K krokwie, Pd podciągi, L, Pw); bale Bs/Kf/Sz
  czekają na dopisanie grup w Dokumentacji 2D. „Podpory legarów” → „podciągi pod legarami”.
- **Nowe**: widok ściany, zestawienie CSV, test działania z raportem JSON, wyróżnienie zmienionych pól, zaznaczona
  ściana jako obrys, parametr `szczyt_min_kawalek`.
- **Drugi przegląd** (po przerwie sesji): przebudowa zostawia przesunięty / obrócony dom na miejscu (wcześniej wracał
  na linie, z których powstał); widok ściany mieści całą ścianę w szerokości okna; opisy węgłów na rzucie w środku
  domu (nie nachodzą na opisy ścian); „Kontrola” domu bez zapisanych parametrów – jasny komunikat zamiast błędu.

### Runda 4 (kompilacja 4) – wybrane propozycje 1, 6, 8, 9

Decyzja użytkownika (2026-10-24): „1, 6, 8 ale tylko gdy góra jest zamknięta lub gdy jest antresola / półka ponad, 9”;
propozycji 2, 3, 4, 5, 7, 10 nie zrozumiał – objaśnione prościej, czekają na wybór.
- **1 – edycja w widoku ściany** (`rdzen/ustawienia_scian.rb`, `html/edycja.js`, `html/sciana.js`): ostatki końców,
  węgły ręczne kliknięciem (pierwsza zmiana przepisuje węgły ściany na listę ręczną – automat tej ściany wyłączony,
  ostrzeżenia przy za długim świetle i stykach bez węgła), „Przywróć automatyczne”, co nad działową i jej góra.
- **8 – działowa niższa** (`rdzen/dopelnienie.rb`, `rdzen/wience.rb`): tylko gdy nad działową jest strop, antresola
  albo półka (ustawienie ściany albo parametr `strop`); bez tego działowa ma pełną wysokość jak dotąd. Dopełnienie
  zamka odcinkami działowej przy wyższych ścianach (ostatek + 44 + 100 = 244 / 344), ostatni wystaje o pół wieńca
  i zamyka zamek; pod połacią ścięty linią dachu, przy szczycie – całe odcinki pod linią podparcia dachu.
- **6 – pełny profil bala** (`rdzen/profil_bala.rb`, `rdzen/siatka.rb` – pasy przekroju): pióra i wpusty z parametrów,
  pierwszy wieniec bez wpustu (osobne pozycje), objętość z profilem w raporcie; w gnieździe zamka pióro wycięte.
- **9 – pola Podstawowe / Wszystkie** (`html/tryb.js`, flaga `podstawowy` w liście parametrów): w podstawowych także
  każde pole zmienione względem fabrycznych.
- **Nowe parametry**: `profil_bala`, `pioro_liczba`, `pioro_szerokosc`, `pioro_rozstaw`, `wpust_luz`, `strop`,
  `dzialowa_nizsza_wysokosc`, `dopelnienie_wewn`, `min_pasek_przy_otworze`; szablony „Dom 1,5 kondygnacji ze stropem
  nad parterem”, „Pełny profil bala – pióro i wpust (wizualizacja)”; siódmy przykładowy dom testu działania.
- **Sprawdzenie**: 1600 losowych domów z nowościami rundy – znalezione i poprawione: odcinki dopełnienia przy
  szczycie wchodzące w krokwie (teraz pod linią podparcia dachu), krawędzie 0,06–0,09 mm w bryłach pełnego profilu
  (wierzchy pasów różne o mniej niż 0,2 mm wyrównywane), pasek bala 7,9 mm pod wpustem przy oknie (pasek cieńszy niż
  `min_pasek_przy_otworze` 20 jest usuwany z ostrzeżeniem – otwór sięga krawędzi bala); także błąd sprzed rundy 4:
  dwa szczyty na działowych blisko siebie (75 mm) – krokwie wchodziły w sąsiedni szczyt (teraz pomijane, nachodzące
  na siebie scalone w jedną pośrodku, `rdzen/dach.rb#bez_kolizji`); ziarna w `testy/t_losowe.rb`.

### Runda 5 (kompilacja 5) – propozycje 2, 3, 4, 7 i poprawki dachu

Decyzje użytkownika (2026-10-24 18:32 i dalej): 2 – pokazać grupy Dokumentacji 2D na teście; 3 – dachy kompleksowo:
dwuspadowy i jednospadowy w generatorze, pozostałe w aplikacji do dachów, deskowanie / nadbitka (pełne deskowanie
z boazerii pióro-wpust na krokwiach, dach bez ocieplenia) / OSB – w aplikacji do dachów (użytkownik zleci tam);
„konstrukcję dachu niech buduje w oparciu o aplikację do dachów – ona przelicza i analizuje”; 4 – taras, oba warianty
(1100 i 1200) do wyboru; 7 – wymiary stolarki, luz parametrem (górny i boczne), aplikacja podpowiada luz; 5 – nie
teraz; 10 – odpada (inna aplikacja). 2026-10-25: płatwie za nisko – podnieść i ściąć do płaszczyzny dachu; bal szczytu
nie może być urwany – pełnym skosem do końca; prompt dla Dokumentacji 2D (wysłany dwa razy – ponowiona wiadomość).
2026-10-25 16:05: „ściany szczytowe na wysokości płatwi są z krótkich kawałków – skosy ścinamy z całego bala” – mylił
rysunek z sesji (pionowe kreski na granicach odcinków obliczeń); bale szczytu są w całości ze skosem, krótkie są tylko
kawałki między płatwią a skosem, gdzie płatew przecina bal na całej wysokości – decyzja: zostają jak w 1100 (S4).
- **2 – Dokumentacja 2D**: `testy/zrzut_dok2d.rb` – dom z generatora w formacie „ArteMadera-geometria” (krawędzie,
  objętości brył) dla `model_dump_loader.rb`; pokaz: bale trafiają do grupy E, zamek opisany jako otwór, płatew ścięta
  jako nakładka, przekroje bali szczytu z obrysu. Zadanie dla tamtej wtyczki: `docs/zadanie_dokumentacja2d.md`.
- **7 – stolarka** (`rdzen/stolarka.rb`, `rdzen/otwory.rb`, `html/otwory.js`): tabela otworów z wymiarami stolarki
  i luzem górnym (puste – podpowiedź: wysokość × `osiadanie_scian` 1,5 %, w górę do 5, min. `luz_gorny_min` 10),
  `luz_boczny` 10; otwór w balach liczony i pokazany w tabeli, stolarka w widoku ściany. `luz_nad_otworem` usunięty.
- **Płatwie i szczyty** (`rdzen/dach.rb`, `rdzen/pryzmat.rb`, `rdzen/bryla.rb#klin_ok?`): płatwie podniesione, wierzch
  ścięty do płaszczyzny dachu (kalenicowa dwustronnie; bryła z przekroju – pryzmat), bale szczytu pełnym klinem
  (`szczyt_min_wysokosc` 0, `szczyt_min_kawalek` 10).
- **3 – krokwie z aplikacji do dachów** (`rdzen/polacie.rb`, `sketchup/dach_aplikacja.rb`, parametr `dach_wiezba`):
  połacie na spodzie krokwi przez `RoofBuilder.generate`, ustawienia i okno KROKU 2, przebudowa (poprzednie połacie,
  więźba nad nimi po potwierdzeniu), jedno „Cofnij”; sprawdzone na prawdziwej wtyczce 3.3.1 (jej atrapa, 5 domów –
  połacie w płaszczyźnie spodu krokwi z dokładnością 0,01 mm, krokwie KROKU 2 na płatwiach, kontrola krokwi
  w raporcie). Zadanie dla aplikacji do dachów (poszycie, stałe wejście, podpory pośrednie, osie krokwi przy
  szczycie, więźba powiązana z połaciami): `docs/zadanie_aplikacja_dachow.md`.
- **3 – dach jednospadowy** (`rdzen/dach_jednospadowy.rb`): ściana niska / wysoka (do połaci, górny bal przycięty),
  szczyty skośne, płatwie bez kalenicowej, krokwie w jednym kawałku, połać z trzema krawędziami szczytowymi.
- **4 – taras** (`rdzen/taras.rb`, `rdzen/taras_balustrada.rb`): obrys przedłużony, ściana domu jako działowa ze
  szczytem; jak 1100 – podciąg z górnych wieńców, słupy S (grupa i tag „Taras”), wejście, balustrada z bali
  i przekładek 300 w wieńcach ściany; jak 1200 – ściany boczne pełne, front bez bali.
- **Narożnik pod dachem** (`rdzen/skos_przy_narozniku.rb`, parametr `zamek_min_drewno` 20): bal ścięty dachem przez
  słup zamka tylko w zamku z dość drewna – inaczej kończy się przy licu ściany poprzecznej (ściana wysoka dachu
  jednospadowego: mostek 0,03 mm nad gniazdem, ostatek szczytu bez zamka). Bale węgła tylko tam, gdzie gospodarz ma
  bale (nad tarasem z podciągiem dolnych nie ma).
- **Sprawdzenie**: losowe domy z nowościami rundy (krokwie z aplikacji, luzy, dach jednospadowy, taras – od ziarna
  2000) – znalezione i poprawione: mostek nad gniazdem i ostatek szczytu bez zamka (jednospadowy, ziarna 105, 250),
  węgieł styku na froncie tarasu z balami w powietrzu (2023), dno gniazda płatwi 0,095 mm nad dnem gniazda zamka –
  krótka krawędź (2130, błąd sprzed rundy 5; poziomy obróbek różne o mniej niż 0,2 mm wyrównywane); koniec podcięcia
  zamka scalony z przecięciem skosu z wierzchem bala 0,13 mm wcześniej – bal szczytu za szeroki w zamku z węgłem
  (2348, błąd sprzed rundy 5; granice obróbek mają pierwszeństwo przed przecięciami, `rdzen/bryla.rb#punkty_podzialu`);
  ziarna w `testy/t_losowe.rb`.

### Runda 6 (kompilacja 6) – aplikacja do dachów 3.7.0: API, płatwie jako podpory, poszycie

Wiadomość użytkownika (2026-10-26 19:10): „sprawdź i ewentualnie, jeżeli ma to obecnie sens, wdroż” – aplikacja do
dachów 3.7.0 (API dla innych wtyczek, płatwie pod połacią jako podpory krokwi, poszycie 3.6.0). Ocena: sens ma
wszystko – stałe wejście usuwa zależność od wnętrza aplikacji (ograniczenie kompilacji 5), podpory poprawiają kontrolę
krokwi (przęsła między płatwiami zamiast okap–kalenica), a poszycie na płatwiach daje deski domowi na samych płatwiach
(domyślny układ, jak 900), który dotąd nie dostawał połaci.
- **API** (`sketchup/dach_aplikacja.rb`): `API.polacie` (punkty Geom::Point3d w układzie kontekstu domu, z = nil,
  szczyty w kolejności punktów – odwrócenie obiegu robi API, `:operacja => false` – w operacji budowy domu),
  `API.podpory` (lista w grupie połaci), `API.wiezba` z oknem w liczniku i `:po_generowaniu` – więźba dostaje
  `ArteMadera_GW.wiezba_domu`; przebudowa usuwa więźbę poprzedniej wersji po id (bez id – po położeniu, jak dotąd).
  Brak API (aplikacja starsza niż 3.7.0) – komunikat; brak aplikacji albo inny kontekst – komunikat bez pustej operacji.
  Usunięte: Footprint, RoofBuilder, Config, Commands i własne odwracanie obiegu.
- **Podpory** (`rdzen/krok2.rb#podpory`): płatwie – wierzch w osi (ścięta – na połaci, kalenicowa – 1 mm pod grzbietem,
  bo aplikacja 3.7.0 punkt na samej kalenicy przypisuje do jednej połaci albo żadnej), szerokość, wysokość, nazwa
  pozycji; dach jednospadowy – także ściana wysoka (bez niej rozpór i przęsło do krawędzi połaci).
- **Poszycie** (sekcja „Poszycie dachu”, 14 parametrów, przełączniki w polach podstawowych): nadbitka, deskowanie
  pełne (domyślnie tak), OSB → `sheath_*` KROKU 2. „Krokwie i poszycie – kto je buduje” (`dach_wiezba`) = aplikacja
  działa teraz dla każdego układu dachu; same płatwie – KROK 2 z `rafter_on` false; bez warstwy – uwaga.
- **Testy**: atrapa API (`testy/atrapa/aplikacja_dachow.rb`), `t_dach_aplikacja` (punkty, podpory, okno, więźba po OK,
  przebudowa po id, same płatwie, odmowa KROKU 2, aplikacja bez API), `t_polacie` (ustawienia KROKU 2, podpory,
  ściana wysoka), `sprawdz_dach_aplikacja` z prawdziwą 3.7.0 – 8 domów: połacie w płaszczyźnie wierzchu płatwi
  (±0,01 mm), każda podpora pod połacią (kalenicowa pod obiema), krokwie na połaci, przęsła w raporcie, deski
  i nadbitka na płatwiach wzdłuż spadku ze stykami na płatwiach, OSB na nadbitce, dom odbity; losowe domy sprawdzają
  podpory w granicy aplikacji.
- Uwagi dla aplikacji do dachów – `docs/zadanie_aplikacja_dachow.md`, część 2.

### Runda 7 (kompilacja 7) – uwagi z odbioru kompilacji 6

Wiadomość użytkownika (2026-11-01 12:36): 26 uwag po budowie domów kompilacją 6 (podpowiedzi i podgląd zmian,
płatwie w powietrzu i różnej wysokości, przekrój płatwi w całości, ściana jako element nośny, bale ścięte do dachu,
zamki w płatwiach, pola zależne, legar ręczny, przeliczenia, podbitka, obciążenie użytkowe z rysunkiem, taras – poręcz,
szczyt, słupy z zamkami, naroże, widok; podciągi pod podwaliną, podwalina 50 × 150, fundamenty punktowe, „parapet”,
działowa zamiast węgłów, działowa wzdłużna do szczytu, płatew nad balem okapowym nieścięta, węgły jak okna). Odpowiedzi
(2026-11-01): płatew – 200 zostaje od wyższej strony, reszta ścięta; podbitka – do wyboru w ustawieniach; węgły – opcja
węgła automatycznie na środku ściany. 2026-11-02: „podbitka z opcjami, by powstała pod konstrukcją poszycia np.
płatwie lub krokwie, na płatwiach, pod krokwiami lub na krokwiach w zależności od rodzaju konstrukcji”.
- Wykonanie – §1a. Nowe pliki: `rdzen/platwie_wience.rb`, `sciecie_dachu.rb`, `zamek_platwi.rb`, `styki_dzialowe.rb`,
  `wegly_tabela.rb`, `taras_slupy.rb`, `taras_szczyt.rb`, `fundamenty.rb`, `podciagi.rb`, `podbitka.rb`,
  `parametry_dach.rb`, `parametry_podloga.rb`, `parametry_taras.rb`; `html/wegly.js`, `zalezne.js`, `pomoc.js`,
  `przeliczenia.js`; testy `t_podbitka.rb` i grupy rundy 7 w `t_szczyty`, `t_rdzen`, `t_wegly`, `t_taras`, `t_podloga`,
  `t_siatka`, `t_jednospadowy`, `t_okno.js`; losowe domy od ziarna 3000 z nowościami rundy 7 (`losowe_domy.rb#dodatki_r7`).
- Podbitka „na płatwiach” z krokwiami: połać dla aplikacji do dachów i podpory wyżej o grubość deski (krokwie leżą na
  deskach); obniżenie ścian pod podbitką liczone w pionie (grubość / cos kąta) – wcześniej węgły na ścianach okapowych
  wchodziły 0,6 mm w deski pod płatwiami.

### Runda 13 (kompilacja 13) – dobór przekrojów zadaszenia i krokwi, podłoga w przybudówce, zakładka zadaszenia

Wiadomość użytkownika (2026-11-25 17:19): „płatwie, słupy, krokwie niech są dobierane z minimalnego przekroju jako
automatyczne, lub z wyboru przekroju użytkownika. Podłogi w przybudówce w opcjach. Pamiętaj, by cała ta część bocznego
zadaszenia – lub tylnego – była w osobnej zakładce, by się nic nie myliło.”
- Wykonanie – §1g. Nowe pliki: `rdzen/statyka_zadaszenia.rb`, `rdzen/statyka_slupa.rb`, `rdzen/statyka_krokwi.rb`,
  `rdzen/podloga_przybudowki.rb`, `html/zakladki.js`, `testy/t_statyka_zadaszenia.rb`; zmiany: `rdzen/parametry_zadaszenie.rb`
  (sekcje, dobór, listy, podłoga), `rdzen/parametry_dach.rb` (dobór krokwi), `rdzen/parametry_lista.rb` (ZAKLADKI),
  `rdzen/statyka.rb` (f_c,0,k i E0,05 klas), `rdzen/statyka_dachu.rb#obciazenia` (kąt połaci), `rdzen/zadaszenie.rb#linie_slupow`,
  `rdzen/podloga.rb#uklad` (pole podłogi), `rdzen/podciagi.rb`, `rdzen/fundamenty.rb#stopy`, `rdzen/projekt.rb#belki`,
  `sketchup/okno.rb`, `html/okno.html`, `html/okno.js`, `html/okno.css`, `rdzen/przyklady.rb`.
- Przyjęte bez pytania (§6, Z6–Z9): krokwie zadaszenia z przekrojem krokwi dachu; dobór zadaszenia domyślnie
  automatyczny, krokwi – z wyboru (jak płatwie – stare domy bez zmian); podłoga w przybudówce domyślnie tak (jak
  w kompilacji 12); obciążenia zadaszenia jak dachu.
- Uwaga z obliczeń: przybudówka bez ścian poprzecznych – płatwie zadaszenia mają przęsło równe długości domu (dom 8 m →
  dobór 160 × 280). Słupów ani działowych w przybudówce generator jeszcze nie stawia (do decyzji – §6 Z9).
- Testy: `t_statyka_zadaszenia` (62: słup, dobór i sprawdzenie zadaszenia, przybudówka, krokwie, podłoga, zakładka),
  `t_okno.js` (+9: zakładki, pola zależne doboru), `t_zadaszenie` (belka obok węgła z dobranym przekrojem), losowe domy
  od ziarna 8500 (`dodatki_r13`): 8501–8800, 8001–8250, wymuszone zadaszenie 9001–9200 i 108 wariantów – bez problemów
  (jedna kolizja znaleziona i poprawiona – §1g, ziarno 9008).

### Runda 12 (kompilacja 12) – boczne zadaszenie z załamaniem dachu

Wiadomość użytkownika (2026-11-25 15:10): „Chcę, by była możliwość dawania także bocznego zadaszenia, z tymże musi być pod
mniejszym kątem niż połać dachu, do której została doklejona. Generator dachów powinien dostać informacje o tym, że w tym
a tym miejscu jest załamanie dachu, by np. łaty pod blachę rozstawiał poprawnie.” Odpowiedzi na pytania (15:2x): podparcie –
„Do wyboru – oba” (słupy z oczepem albo ściany z bali); zasięg – cała ściana okapowa (strona parametrem); łaty – każda połać
od dołu, łata przy linii załamania z obu stron **i pełne moduły pod załamaniem**; aplikacja do dachów – zmiany „tutaj,
w obu” (generator i aplikacja w tej sesji).
- Wykonanie – §1f. Nowe pliki: `rdzen/zadaszenie.rb`, `rdzen/parametry_zadaszenie.rb`, `testy/t_zadaszenie.rb`; zmiany:
  `rdzen/dach.rb` (linia z załamaniem, krokwie zadaszenia), `rdzen/szczyty.rb` (opis zadaszenia w przekroju, wiele załomów,
  gniazda płatwi zadaszenia, ściana przybudówki), `rdzen/pod_dachem.rb`, `rdzen/widok.rb` (wiele załomów), `rdzen/polacie.rb`
  (załamania dla aplikacji), `rdzen/krok2.rb` (ściany domu i przybudówki jako podpory), `rdzen/projekt.rb`, `rdzen/elementy.rb`
  (prefiks Bp), `sketchup/budowa.rb` (grupa i tag „Zadaszenie”), `sketchup/dach_aplikacja.rb` (opcja `:zalamania`,
  aplikacja 3.12.0+), `rdzen/przyklady.rb` (dwa przykłady).
- Aplikacja do dachów 3.12.0 (`Mottomi3/Aplikacja-do-konstrukcji-dach-w`): `artemadera_roof/07b_kinks.rb` (nowy, `[ZL]`),
  `08_face_analysis.rb` (krawędź `:kink`, przesuwanie krawędzi), `10_joints.rb` (`[JN-2e]` dwusieczna), `14_battens.rb`
  (`[BT-1b]`, `[BT-5b]`), `15_framing_builder.rb` (podniesienie każdej połaci o własną wysokość, dopasowanie okapu pod
  załamaniem), `14h_supports.rb` (`[SP-3b]`), `15b_rafter_check.rb`, `15a_preview.rb`, `16_ui_dialogs.rb` (pole „Pod
  załamaniem połaci – pełne moduły”), `18_api.rb`, testy `tests/test_zalamanie.rb` (8), CHANGELOG, API.md, INSTRUKCJA.
- Testy generatora: `t_zadaszenie` (wiata, przybudówka, krokwie, przeszkody, atrapa API), `sprawdz_dach_aplikacja` – trzy
  domy z zadaszeniem na prawdziwej aplikacji (połacie ±0,01 mm względem generatora, podpory przy załamaniu pod obiema
  połaciami, łaty, deski na płatwiach, krokwie na obu połaciach), losowe domy od ziarna 8000 (`dodatki_r12`), kolizje
  Bp, S, P między sobą i z balami w każdym losowym domu.
- Decyzje przyjęte bez pytania (do potwierdzenia, §6 Z1–Z5): linia załamania nad licem zewnętrznym ściany (przy płatwi
  ściennej stojącej na ścianie – nad jej krawędzią); płatew zadaszenia przy samej ścianie w gniazdach ostatków ścian
  szczytowych; słupy na słupach – belka poprzeczna oparta o ścianę (bez gniazda – osiadanie bali); wszystkie płatwie
  zadaszenia z jednego przekroju bez sprawdzenia nośności; zadaszenie z tarasem, w domu L i przy dachu jednospadowym – jeszcze
  nie (ostrzeżenie).
- Rozstrzygnięcia z 2026-11-14 (Projekt: `claude/zadanie_r11.md`) – nadal na rundę 13.

### Runda 11 (kompilacja 11) – uwagi z 2026-11-16

Wiadomość użytkownika (16:08, 6 punktów): słupek z kontrfor pod każdą płatwią – do wyboru („przy niewielkich domkach
letniskowych nie ma takiej potrzeby”); słupek i zastrzały trójkąta – przekrój jak płatwie albo jak dotąd; słup środkowy
tarasu nie w osi – nie w jednej linii ze słupkiem trójkąta; półzamki i kontrfora „do połączenia” w trójkącie nad tarasem –
zbędne, „wystarczy na styk łączyć z przesunięciem o 300 mm na przemian”; zamki boczne w płatwiach nad szczytem tarasu
zbędne – wystarczy od spodu; „w płatwi kalenicowej nadal brakuje ostatniej kontrfory”. Druga wiadomość (20:44): „przy
bardzo wąskich konstrukcjach nie buduje trójkąta nad tarasem; do opcji dodać automatyczne dobieranie przekroju, do
minimalnej nośności konstrukcji dachu”.
- Odtworzenie z `ustawienia.json` użytkownika (taras na słupach, szczyt pusty, wiązar z zastrzałami, płatwie 60 × 200 co
  900, 30°): dom 5 m – węgieł „na środku ściany” na froncie tarasu (jeden bal z półzamkami) i słup pośredni 670 mm od
  osi; dom ≥ 4,25 m – pod kalenicową brak słupka (stał tam węgieł ze środka ściany, który nie dochodził do płatwi); dom
  3,25 m – szczelina 17,8 mm pod kalenicową; dom ≤ 2,2 m – trójkąt nie powstawał wcale.
- Wykonanie – §1e. Decyzje przyjęte bez pytania (do potwierdzenia, §6): „na styk” tylko na froncie tarasu (szczyty ścian
  domu jak dotąd), zamek tylko od spodu domyślnie, słup w osi domyślnie, dobór automatyczny wyłączony domyślnie (ręcznie
  ze sprawdzeniem), obciążenia 0,9 i 0,35 kN/m², ugięcie L/200.
- „Dobór przekroju” zrozumiany jako dobór płatwi **i** trójkąta: przy wąskim domu płatwie rządzi długość domu (60 × 200
  na 5 m to nie za dużo), a trójkąt – szerokość, dlatego to dobór trójkąta zmieścił go w wąskim domu (60 × 100).
- Testy: nowy zestaw `t_statyka_dachu` (35), grupy rundy 11 w `t_wegly` i `t_taras`, losowe domy od ziarna 7000
  (`dodatki_r11`): 120 domów + 70 z ziaren 6001–6070 + 60 z 5001–5060 – bez nowych problemów.
- Znalezione przy okazji (sprzed rundy 11, nie poprawione): dom L + podbitka na płatwiach + krokwie z aplikacji –
  podpory 19 mm pod połacią (ziarna 7004, 7021; §8).
- Rozstrzygnięcia z 2026-11-14 (Projekt: `claude/zadanie_r11.md` – pół zamka w wieńcu szczytowym, katalog przekrojów
  z długościami, komunikat zamiast wyjątku, podbitka w polach zależnych, ostrzeżenie o ostatkach do podpowiedzi,
  poprawka działowej współliniowej) – **nie weszły do tej kompilacji**, zostają na rundę 12.

### Runda 10 (kompilacja 10) – uwagi z 2026-11-10 22:24

Wiadomość użytkownika (5 punktów): belka ściany użyta jako płatew przy domu L wystaje do środka 300 zamiast 100; dom L –
brak płaszczyzny dachu i części konstrukcji, węgły nieścięte do szczytu; aplikacja „nie wczytuje się od nowa” po
zamknięciu i otwarciu („jakby w buforze były parametry” – bez pewności); trójkąt nad tarasem ma podpierać płatwie od
spodu na zamkach i być ciągły + opcja dwóch belek od spodu słupka pod kątem 45°; podciąg podłogi na wysokości podwalin.
Pytanie o dach domu L (trzy warianty z rysunkami) – odpowiedź: **„Dwa dachy z koszem”**.
- Wykonanie – §1d. Nowe pliki: `rdzen/skrzydla.rb`, `testy/t_skrzydla.rb`. Dach główny i boczny to dwa opisy „dom”
  (`Skrzydla.domy`), wszystkie moduły dachu liczą po kolei dla każdego (`Dach.geo(dom)`, `dom[:iv]`); ściana należy do
  dachu, w którego strefie leży (`Skrzydla.dom_sciany`); szczyt na części ściany – `szczyt[:s_zakres]`, część okapowa –
  `w[:okap_boczny]`.
- Testy: `t_skrzydla` (podział, szczyty, płatwie, wypusty, połacie, węgły, 12 ułożeń i wariantów bez problemów), grupy
  rundy 10 w `t_taras`, `t_podloga`, `t_sketchup`; `sprawdz_dach_aplikacja` – 3 domy L na prawdziwej aplikacji;
  `kolizje_belek.rb#z_polaci_l` (połać domu L liczona niezależnie); losowe domy od ziarna 6000 (`dodatki_r10`).
- Znalezione losowymi domami i poprawione: płatew ścienna skrzydła bocznego „na ścianie” w górnym balu ściany wyższej
  o pół bala (gniazdo na całym zasięgu płatwi, także pod wypuszczonymi wieńcami – ziarna 4, 77); koniec płatwi skrzydła
  bocznego liczony w jej osi (podpora w granicy aplikacji – ziarno 204).
- „Nie wczytuje się od nowa” – przyczyna nie jest pewna; poprawione to, co mogło tak wyglądać (§1d). Jeśli wróci –
  potrzebny opis, co dokładnie widać, i raport z testu działania.

### Runda 9 (kompilacja 9) – uwagi z 2026-11-02 23:24

Wiadomość użytkownika (8 punktów, zrzut z SketchUpa i okna): brak węgła pod płatwią na ścianie zewnętrznej; węgieł
z działowej wychodzi 100 zamiast 200 („sprawdzić wszystkie”); niepełna ściana wewnętrzna bez węgła na końcu – dodawać
automatycznie powyżej długości; przesuwanie węgłów w części z oknami i drzwiami; trójkąt nad tarasem – zamki pod płatwie,
płatwie z zamkami 5 / 10, belka dolna, słupek; trójkąt licem ze ścianą zewnętrzną; opcja dwóch zastrzałów; czy szczyt
może być bez bala (sam trójkąt).
- Wykonanie – §1c. Nowe pliki: `rdzen/wegly_konstrukcyjne.rb`, `rdzen/taras_wiazar.rb`, `html/wegly_przesun.js`; testy:
  grupy rundy 9 w `t_wegly`, `t_taras`, `t_okno.js`; `kolizje_elementow` (belka z belką) w `testy/kolizje_belek.rb`;
  losowe domy od ziarna 5000 (`dodatki_r9`), kolizje Wt z P, S i Wt w każdym losowym domu.
- Szczyt bez bala – tak: „Wiązar – na czym stoi” = na słupach (belka dolna wiązara zamiast podciągu frontu).

### Runda 8 (kompilacja 8) – uwagi z 2026-11-02 21:17

Wiadomość użytkownika (13 punktów): fundament okrągły, podciągi równomiernie, podciąg obniżony albo na równo z podwaliną,
fundamenty w osi działowych (przesunięcia przy tarasie), deski tarasu ze ścian albo dołożone, górne wieńce pod okapem
wypuszczone jak płatwie, opcja górnych węgłów pod okapem do nawisu, węgły pod płatwią mają ją podpierać, słupek węgła
przy szczycie nie dochodzi do dachu (zdjęcie), węgły niesymetryczne 100 / 200, bal ma wchodzić do końca zamka płatwi
(szczelina 5 mm), typy zamiast „jak 900 / 1100”, szczyt pusty – trójkątny wieniec, węgły symetrycznie i równy podział.
Odpowiedzi (2026-11-02 21:2x): podciąg na równo – kończy się przy licu wewnętrznym podwaliny; typy 100–400; wypusty
węgłów pod okapem – opcja, domyślnie wyłączona; taras: „belki ścian kontynuowane na długość tarasu (bez krótkich
kawałków), co druga belka wysunięta o 100 mm – zakładka pod barierkę, zakładki do wysokości tarasu”.
- Wykonanie – §1b. Nowe pliki: `rdzen/symetria_wegly.rb`, `rdzen/wypusty_okapu.rb`, `rdzen/taras_sciany.rb`; testy:
  grupy rundy 8 w `t_szczyty`, `t_wegly`, `t_podloga`, `t_taras`; losowe domy od ziarna 4000 (`dodatki_r8`).
- Znalezione losowymi domami i poprawione: węgieł na froncie tarasu z pustym szczytem w belce wieńca (węgieł bez
  oparcia w wieńcu bez bali – pominięty), węgieł styku w miejscu słupa tarasu (strefy słupów zakazane dla węgłów),
  krawędzie 0,03–0,05 mm (ścięcie w poprzek przy granicy pasa, klin szczytu 0,025 mm nad spodem).

# Część D – moduły dodawane w rundach

## 4. Moduły

Patrz `docs/SPIS_TRESCI.md` §2. Nowe w rundzie 3: `rdzen/pod_dachem.rb`, `rdzen/widok.rb`, `rdzen/zestawienie.rb`,
`rdzen/przyklady.rb`, `sketchup/eksport.rb`, `sketchup/raport.rb`, `html/sciana.js`, `html/zmiany.js`; testy
`t_losowe`, `t_widok`, `t_zestawienie`, `t_raport`, `losowe_domy.rb`, `kolizje_belek.rb`, `ruby27.sh`.
Nowe w rundzie 4: `rdzen/ustawienia_scian.rb`, `rdzen/dopelnienie.rb`, `rdzen/profil_bala.rb`, `html/tryb.js`,
`html/edycja.js`; test `t_sciany_ust`.
Nowe w rundzie 10: `rdzen/skrzydla.rb` (dom L – dwa dachy z koszem); test `t_skrzydla`.
Nowe w rundzie 13: `rdzen/statyka_zadaszenia.rb`, `rdzen/statyka_slupa.rb`, `rdzen/statyka_krokwi.rb`, `rdzen/podloga_przybudowki.rb`,
`html/zakladki.js`; test `t_statyka_zadaszenia`.
Nowe w rundzie 11: `rdzen/styki_tarasu.rb` (front tarasu na styk), `rdzen/statyka_dachu.rb` (płatwie – sprawdzenie
i dobór), `rdzen/statyka_wiazara.rb` (trójkąt nad tarasem – sprawdzenie i dobór); test `t_statyka_dachu`.
Nowe w rundzie 6: `rdzen/krok2.rb` (ustawienia KROKU 2, poszycie, podpory); sekcja parametrów „Poszycie dachu”;
atrapa API aplikacji do dachów `testy/atrapa/aplikacja_dachow.rb`.
Nowe w rundzie 5: `rdzen/stolarka.rb`, `rdzen/pryzmat.rb`, `rdzen/polacie.rb`, `rdzen/dach_jednospadowy.rb`,
`rdzen/skos_przy_narozniku.rb`, `rdzen/taras.rb`, `rdzen/taras_balustrada.rb`, `sketchup/dach_aplikacja.rb`,
`html/otwory.js`; testy `t_polacie`, `t_jednospadowy`, `t_taras`, `t_dach_aplikacja` (atrapa aplikacji do dachów
`testy/atrapa/aplikacja_dachow.rb`), `sprawdz_dach_aplikacja.rb` (prawdziwa aplikacja do dachów na jej atrapie),
`zrzut_dok2d.rb` (dom dla Dokumentacji 2D).

## Nowe w kompilacji 15 (polecenie z 2026-11-25 21:42 – `docs/prompt_r15.md`)

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
