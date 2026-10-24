# Specyfikacja – ArteMadera Generator Wieńcowy

Stan: kompilacja 4 (2026-10-24). Wszystkie wymiary w mm. Pełna lista parametrów z wartościami domyślnymi:
`docs/parametry.md` (generowana). Decyzje użytkownika: `decyzje_projektowe.md` (Projekt claude.ai
i `00_Analiza\` na dysku).

## 1. Wejście – rysunek w SketchUpie

| Linia | Znaczenie |
|---|---|
| Zamknięta pętla linii | **lico zewnętrzne** ścian zewnętrznych (obrys domu) |
| Linia wewnątrz obrysu | **oś ściany działowej**; koniec na obrysie lub na innej działowej = połączenie T, koniec w pomieszczeniu = wolny koniec |
| Krótka linia (≤ 600) przecinająca jedną ścianę | **kontrfor** w miejscu przecięcia |

- Linie mogą być luzem albo w grupie; wszystkie na jednej wysokości – to spód pierwszego bala (poziom ±0).
- Zaznaczona ściana (np. prostokąt kliknięty raz) też wystarcza – generator bierze jej krawędzie (powtórzone krawędzie
  liczone raz).
- Ściany pod kątem prostym (układ lokalny obrócony wg najdłuższej linii – dom może stać pod dowolnym kątem w modelu).
- SketchUp dzieli krawędzie w punktach styku – generator scala linie współliniowe; końce bliżej niż tolerancja
  (domyślnie 5 mm) są dociągane.
- Linie poza obrysem (np. taras) są na razie pomijane z ostrzeżeniem.

## 2. Ściany

- Oś ściany zewnętrznej = lico zewnętrzne przesunięte do środka o pół grubości (22).
- Bal sięga za lico ściany poprzecznej o **ostatek** (100): długość bala ściany = długość lica + 2 × 100
  (dom 4000 × 3000 → bale 4200 i 3200, jak w 900).
- Ściana działowa przy ścianie zewnętrznej przechodzi przez nią i wystaje ostatkiem 100 na zewnątrz; skrzyżowanie
  dwóch działowych (X) – obie ciągłe.
- Narożnik wklęsły (obrys L) – ostatki wchodzą do środka (ostrzeżenie; do potwierdzenia z użytkownikiem).
- Numeracja W-n: ściany zewnętrzne od lewego dolnego narożnika przeciwnie do wskazówek zegara, potem działowe
  (najpierw poziome), na końcu kontrfory (wg ściany i położenia) – jak producent (900: kontrfory W-6, W-7).

## 3. Wieńce

- Krycie H = 139 (rozstaw wieńców = wysokość bryły bala prostego). Ściany wzdłuż kalenicy (okapowe, kierunek A)
  zaczynają się **półbalem** H/2 = 69,5 (w listach 70), ściany szczytowe (B) pełnym balem.
- `liczba_wiencow` n = pełne wieńce ścian okapowych: okapowa = półbal + n → wysokość n·H + H/2; szczytowa zewnętrzna
  n + 1 wieńców → (n + 1)·H (górny bal = pierwszy bal szczytu, zamyka zamek z górnym balem okapowej); działowa
  szczytowa n wieńców; kontrfor – do wysokości swojej ściany (przy szczycie – tylko pod linią dachu).
- Ściana ze szczytem (§8) ma wieńce aż do kalenicy; bale ścięte skosem dachu.
- Kierunek kalenicy: dłuższy bok (domyślnie), krótszy bok, oś X, oś Y.

## 4. Zamek (preset 44 × 146, rysunek IMG-20250930-WA0005)

Na każdym skrzyżowaniu w osi c (narożnik, T, X, kontrfor – ten sam zamek):

| Obróbka | Położenie (względem osi c) | Wymiar |
|---|---|---|
| gniazdo górne / dolne | c − 20 … c + 20 | szer. 40, głęb. 36 od wierzchu / spodu bryły |
| podcięcie lica 1 | c − 22 … c + 20 | głęb. 2,5, cała wysokość |
| podcięcie lica 2 | c − 20 … c + 22 | głęb. 2,5, cała wysokość |

- Dwa bale ścian prostopadłych tworzą zamek, gdy ich poziomy różnią się o pół wieńca: niższy dostaje gniazdo
  górne, wyższy – dolne. W zamku: środek 67, grubość 39 (gniazdo 40 → luz 0,5), luz pionowy 2,5 na każdym styku.
- Które lico ma które podcięcie: `Zamek::ORIENTACJA` (x: −1, y: +1) – test kolizji pokazał, że tylko dwa lustrzane
  ułożenia składają się bez nachodzenia („labirynt”; bal poprzeczny odwrócony licem).
- Odcinek kontrforu = 100 + 44 + 100 = 244, obróbki dokładnie jak na rysunku (gniazda 102…142, podcięcia 100…142 i 102…144).
- Inne przekroje: tabela presetów w `rdzen/parametry_lista.rb`, wymiary edytowalne w oknie; `zamek_odbicie` = lustro
  odwraca labirynt (oba ułożenia bez kolizji).

## 5. Długości bali i łączenia (mijanka ≥ 300 – wymóg użytkownika)

- Bal dłuższy niż `max_dlugosc` (5100 – najdłuższe bale producenta 5044 / 5090) → ściana łączona. Styk zawsze w osi
  zamka (węgieł 244 albo ściana działowa), czoła bali w połowie zamka.
- **Układ domyślny „na przemian” (jak 1200):** kotwice a0 < a1 < … co najmniej `mijanka` (400, nie mniej niż 300);
  wieńce parzyste (od dołu, od 0) łączą się w a0, a2, …, nieparzyste w a1, a3, … – kawałek bala sięga od kotwicy do
  kotwicy co drugiej. Kotwic co najmniej 2 × (bale w wieńcu − 1). Najpierw istniejące działowe i narysowane węgły,
  nowe węgły tylko, gdy trzeba (najmniej nowych, potem najbliżej równego podziału).
- Układ „para” (jak 900 W-2): na każde miejsce łączenia dwa skrzyżowania w odstępie mijanki; „jeden węgieł”: styki
  c ± mijanka/2 obok jednego węgła (poza zamkiem).
- Styk nie bliżej otworu niż `styk_odstep_od_otworu` (400 – kawałek bala przy otworze), węgieł nie bliżej innego
  skrzyżowania niż 300 i otworu niż 150, nie przy narożniku. `szczelina_styku` (0) – szczelina między czołami.
- Styk tylko w kawałku dłuższym niż `max_dlugosc` – kawałek między otworami, który się mieści, zostaje w całości.
- Mijanka pilnowana także między miejscami łączenia (styki wieńców parzystych i nieparzystych różnych miejsc).
- Ściana ze szczytem łączy się tylko na węgłach (działowa kończy się pod okapem, więc w wieńcach szczytu nie trzyma
  styku). Gdy styk wypada nad węgłem, który kończy się pod połacią – ostrzeżenie „styk bez zamka” (zwiększ maksymalną
  długość bala albo dorysuj węgieł bliżej kalenicy).
- Kontrola: `Kontrola.mijanka` – styki w sąsiednich wieńcach co najmniej 300 od siebie; `Kontrola.styki_bez_zamka` –
  styk w osi skrzyżowania, w którym ściana poprzeczna ma bal wieniec wyżej lub niżej.

## 5a. Węgły usztywniające (244)

- Światło ściany = odległość między licami podparć (narożnik, działowa, węgieł). Gdy przekracza
  `wegly_max_swiatlo` (4800 – 1800 W-2: 4756 bez węgła), generator dostawia węgły; dla domu ze ścianami okapowymi
  wyższymi niż `wegly_prog_wysokosci` (3000) limit `wegly_max_swiatlo_wysokie` (3700 – 1200: węgieł na ścianie 4 m).
- Rozmieszczenie: równo (najmniej węgłów, światła ≤ limit), od narożników o `wegly_odstep_od_naroznika` (800,
  symetrycznie, reszta równo), albo tylko narysowane (ostrzeżenie zamiast węgła). Działowe – przełącznik.
- Kolejność: najpierw węgły pod styki (§5), potem usztywniające – węgły styków często wystarczają.
- Dom 4 × 4 (lico): bale 4200 w całości, światło 3956 – bez łączeń i bez węgłów (jak 1000, 1100, 900 W-4).

## 5b. Ustawienia pojedynczej ściany (widok ściany, `rdzen/ustawienia_scian.rb`)

Wejście domu ma `sciany` – ustawienia ścian zmienione pod widokiem ściany (zapisane w domu, przebudowa je zachowuje):
- **Ostatek na każdym końcu** (`ostatek_od` – lewy koniec widoku od lica, `ostatek_do` – prawy) zamiast parametru
  `ostatek` – np. 200 pod taras (1100, 1200); 40…600, wolny koniec działowej bez ostatka.
- **Węgły ręczne** (`wegly` – osie wszystkich węgłów ściany w mm od początku osi): kliknięcie w widok dodaje węgieł
  (oś zaokrąglona do 10 mm), kliknięcie przy węgle (± 80 mm) go usuwa. Pierwsza zmiana przepisuje węgły ściany
  (narysowane, pod styki, usztywniające) na listę ręczną – automat tej ściany jest wyłączony; za długie światło albo
  styki, których nie da się dobrać, dają ostrzeżenie. „Przywróć automatyczne” usuwa listę. Węgieł za blisko innego
  skrzyżowania (300) – pominięty z ostrzeżeniem.
- **Co jest nad działową** (`nad`): nic (pełna wysokość), strop, antresola, półka; brak – według parametru `strop`.
  Wymóg użytkownika: **działowa niższa od ścian zewnętrznych tylko pod stropem, antresolą albo półką** (§5c).

## 5c. Działowa niższa – dopełnienie zamka (`rdzen/dopelnienie.rb`)

- Działowa pod stropem / antresolą / półką kończy się najwyższym pełnym wieńcem nie wyżej niż `wysokosc` z ustawień
  ściany albo parametr `dzialowa_nizsza_wysokosc` (2500 → szczytowa 17 wieńców = 2363, wzdłuż kalenicy półbal + 17 =
  2432,5 jak 1100 W-6; 2780 → 20 wieńców jak 1200 W-5, W-7). Parametr `strop` = tak – wszystkie działowe pod stropem.
- Nad nią, przy każdej ścianie zewnętrznej albo działowej pełnej wysokości, która idzie wyżej, kolumna odcinków
  działowej: ostatek + grubość + `dopelnienie_wewn` (100) → 244, przy ostatku 200 → 344 (jak 1100 W-6, W-7, 1200
  W-5, W-7); w środku działowej (skrzyżowanie X) – po 100 z obu stron. Odcinki to bale ścienne działowej (Bs, jej
  numery pozycji). Kolumna sięga do góry tamtej ściany: ostatni odcinek wystaje o pół wieńca i zamyka zamek; pod
  połacią ścina go linia dachu; przy ścianie ze szczytem – tylko całe odcinki pod linią szczytu.
- Niższa działowa nie ma szczytu; otwór wyższy niż jej góra – ostrzeżenie; węgły na niej – do jej góry.

## 6. Otwory

- Wpis: ściana (W-n), od, szerokość, wysokość, parapet. „Od” liczone od narożnika lica zewnętrznego na początku
  ściany (kropka na rzucie w oknie); dla działowej – od początku narysowanej osi. Parapet od ±0 (spód pierwszego bala).
- Bal w całości w wysokości otworu – przecięty (cięcie proste); bal częściowo – wycięcie od góry (pod parapetem) lub
  od dołu (nad nadprożem). `luz_nad_otworem` (0) podnosi górną krawędź wycięcia.
- Kontrfor w miejscu otworu – bez bali na wysokości otworu (przerwany). Otwór bliżej niż 70 od lica ściany
  poprzecznej – ostrzeżenie.

## 7. Bale, pozycje, model

- Bryła bala prostego: 44 × 139 (półbal 69,5), obróbki: gniazda, podcięcia, wycięcia przy otworach, gniazda płatwi,
  skosy szczytów.
- **Pełny profil** (`profil_bala` = pelny, do wizualizacji; `rdzen/profil_bala.rb`): bal prosty + pióra na wierzchu
  (wysokość „Pióro” z wymiarów zamka, 7) − wpusty od spodu (o `wpust_luz` 1 szersze i głębsze); `pioro_liczba` 1 albo
  2 (domyślnie 2 × 8 mm w rozstawie 20 – do potwierdzenia). Pierwszy wieniec (na podwalinie, także półbal) bez wpustu –
  osobne pozycje. Obróbki tną wszystkie pasy (w gnieździe zamka pióro i wpust znikają – zamek bez zmian). Pozycje,
  listy, zestawienie, kontrola kolizji – jak dla bala prostego; zmienia się tylko bryła komponentu.
- Punkty podziału bryły bliższe niż 0,2 mm są scalane – SketchUp nie tworzy krawędzi krótszych niż 0,0254 mm, a tak
  bliskie obróbki (np. podcięcie zamka 0,07 mm za wycięciem otworu) psułyby ściany bryły.
- Identyczne bale (ta sama bryła, także po obrocie o 180° wokół pionu) = jedna pozycja „nr-długość” (np. `2-4200`)
  i jeden komponent. Numery: W-1, W-2…, w ścianie wieńce od dołu, w wieńcu wzdłuż ściany.
- Model: grupa „Dom wieńcowy” (obrót układu lokalnego, poziom ±0) > grupy W-n > instancje komponentów „Bal 2-4200”,
  „Bal szczytu 7-2747”, „Kontrfor 9-244”; grupy „Podłoga” i „Dach” z belkami („Legar 15-2800”, „Płatew 16-5000”…).
  Tagi: Ściany zewnętrzne, Ściany działowe, Kontrfory, Szczyty, Podłoga, Dach.
- Atrybuty dla Dokumentacji 2D (słownik `ArteMadera` na definicji): `rola` = timber, `prefiks` = Bs (bale ścienne) /
  Kf (węgły) / Sz (bale szczytu) / Pw (podwaliny) / L (legary) / Pd (podciągi pod legarami) / P (płatwie) / K (krokwie)
  – kody belek to grupy Dokumentacji 2D (rozpoznaje je od razu); Bs, Kf, Sz trzeba w niej dopisać
  (`element_roles.rb`, `PREFIX_GROUPS`) – do tego czasu bale trafią do grupy E. Dalej `pozycja`, `nazwa`.
  **Grupa domu nie ma roli** (rola „skip” na grupie wyłączyłaby wszystkie bale w Dokumentacji 2D).
- Pozycje belek numerowane po balach (te same zasady: identyczna belka = jedna pozycja).
- Wejście (linie, poziom, parametry, otwory) zapisane w grupie domu (`ArteMadera_GW`/`wejscie`): zaznacz dom →
  to samo polecenie → okno z parametrami → „Zastąp dom w modelu”. Ręczne zmiany w domu wykrywa podpis zawartości –
  przed nadpisaniem pytanie. Przesunięcie lub obrót całego domu (np. ustawienie na planie działki) to nie ręczna
  zmiana – nowa wersja powstaje w tym samym miejscu (`Budowa.polozenie_domu`).

## 8. Szczyty i dach

- Szczyt dostają ściany zewnętrzne szczytowe od narożnika do narożnika (i działowe szczytowe – przełącznik, jak 1800 W-2).
- Linia podparcia (wierzch płatwi) w przekroju poprzecznym: na licu wewnętrznym ściany okapowej `dach_podniesienie`
  nad jej wierzchem (69,5 = wierzch najwyższego bala szczytowej, jak 900), w stronę kalenicy rośnie pod kątem
  `dach_kat` (20°). Płatew stojąca na ścianie (`platwa_scienna_polozenie` = na_scianie) wyznacza linię swoim wierzchem.
- Płatwie: ścienne (60 × 200, przy licu wewnętrznym albo na ścianie), pośrednie (80 × 180, co ≤ `platwie_rozstaw_max`
  990–1000 w poziomie), kalenicowa (80 × 180). Płatew stoi wierzchem na linii przy krawędzi od strony okapu – nic nie
  wystaje nad dach. Długość = dom + 2 × `dach_okap_szczyt` (500).
- Gniazdo płatwi = otwór od spodu płatwi w górę (z luzem `gniazdo_luz` 5 na stronę): bal przy spodzie płatwi ma
  wycięcie od góry, bale wyżej są przecięte (jak 900: kawałki 66-147, 68-372). Gniazda dostają też działowe i węgły,
  pod którymi przechodzi płatew ścienna.
- Krokwie (`dach_uklad` = krokwie / płatwie i krokwie): leżą na linii podparcia, od okapu (`dach_okap` 500 za
  licem) do kalenicy, rozstaw ≤ `krokwie_rozstaw` (900). Przy szczycie (`krokwie_przy_szczycie`): z obu stron
  szczytu, tylko od wewnątrz, tylko od zewnątrz – szczyt dochodzi do wierzchu krokwi; albo krokiew na szczycie –
  szczyt kończy się pod krokwią.
- Bale szczytu: skos wg linii szczytu, kliny niższe niż `szczyt_min_wysokosc` (30) pomijane, okruchy krótsze niż
  `szczyt_min_kawalek` (50) między skosem a gniazdem płatwi pomijane; prefiks Sz.
- Szczyt na działowej (`szczyty_na_dzialowych`): krokwie z obu stron takiego szczytu (albo na nim – opcja „na
  szczycie”), pozostałe krokwie równo między krokwiami przy szczytach.
- Bale pod połacią (`rdzen/pod_dachem.rb`): ściany w poprzek kalenicy bez własnego szczytu (działowe niższe od dachu,
  węgły na ścianach okapowych) ścinane linią podparcia (spód krokwi / desek) – przy stromym dachu ostatki węgłów nie
  wchodzą w połać. Ostrzeżenie, gdy przy licu zewnętrznym ściany okapowej spód krokwi wypada niżej niż jej wierzch.
- Węgły przy szczycie wchodzą w szczyt (do linii dachu), żeby trzymać styki bali szczytu.
- Belki dachu tylko dla obrysu prostokątnego (inny obrys – szczyty liczone dla każdej ściany osobno, ostrzeżenie).

## 9. Podłoga

- Poziom 0 = spód pierwszego bala = wierzch podwalin i legarów (legary między podwalinami, wierzchem równo – jak 900).
- Podwaliny (100 × 100) pod ścianami zewnętrznymi licem równo z licem ściany, w narożnikach na zakład (pół wysokości);
  pod działowymi w osi (przełącznik), dosunięte do innych podwalin.
- Legary wzdłuż krótszego boku (albo dłuższego, X, Y), rozstaw ≤ `legary_rozstaw` (600), równo między podwalinami
  bocznymi i działowymi wzdłuż legarów; dzielone na podwalinach poprzecznych. Przęsła – między podwalinami
  poprzecznymi na całą szerokość.
- Dobór (`rdzen/statyka.rb`, uproszczony PN-EN 1995: k_mod 0,8, k_def 0,6, ψ2 0,3, γM 1,3, 1,35 G + 1,5 Q): przekroje
  z katalogu `przekroje_katalog`, nie niższe niż `izolacja_podlogi`; warunek nośności i ugięcia L/`ugiecie_zalecane`
  (400, tryb zalecany) albo L/`ugiecie_minimalne` (250, tryb minimalny); tryb ręczny – sprawdzenie podanego przekroju.
  Podciągi pod legarami (prefiks Pd) dodawane, gdy przęsło za długie (`podpory_rozstaw_max` 0 = automatycznie –
  wybór wariantu z najmniejszą objętością drewna; > 0 – podciągi co najwyżej tyle).
- Podpowiedzi w oknie: ocena legara (nośność %, ugięcie L/x, „spełnia zalecane / tylko dopuszczalne / za słaby”),
  najmniejszy i zalecany przekrój bez podciągów, izolacja (mieści się / za niski legar), legar wyższy niż podwalina,
  liczba podciągów. To podpowiedź – nie zastępuje projektu konstruktora.
- Tylko dla obrysu prostokątnego (inny – podpowiedź, bez podłogi).

## 10. Okno, ustawienia, szablony

- Formularz budowany z `rdzen/parametry_lista.rb` (SEKCJE, LISTA): sekcje rozwijane, pod polem podpowiedź (skąd
  wartość). Nowy parametr = jeden wpis w LISTA – pole pojawia się samo w swojej sekcji.
- Ostatnio użyte parametry zapisują się przy każdym podglądzie i generowaniu w pliku ustawień na komputerze
  (Windows: `%APPDATA%\ArteMadera\GeneratorWiencowy\ustawienia.json`) – nowy dom startuje z nimi po ponownym
  uruchomieniu SketchUpa. Dom w modelu ma swoje parametry (edycja).
- Szablony: wbudowane (jak 900, jak 1800, 1,5 kondygnacji, 1,5 kondygnacji ze stropem nad parterem, bez łączenia,
  podłoga 150, pełny profil bala) i własne (zapisz / wczytaj / usuń); „Przywróć fabryczne”. Szablony obejmują
  parametry – ustawienia pojedynczych ścian należą do domu.
- Pola zmienione względem ustawień fabrycznych – wyróżniona etykieta (w dymku wartość fabryczna), w nagłówku sekcji
  liczba zmian.
- **Pola: Podstawowe / Wszystkie** (`html/tryb.js`): w trybie podstawowym tylko parametry oznaczone `podstawowy: true`
  w liście i te zmienione względem fabrycznych (nic, co zmienia dom, nie znika); sekcje bez widocznych pól i wymiary
  zamka ukryte. Tryb zapamiętany na komputerze (domyślnie podstawowe).
- Rzut z numerami ścian i punktami odniesienia, tabela okien i drzwi (nowe okno / drzwi z wymiarów w ustawieniach),
  wynik: liczby (bale, węgły, szczyty, belki), ostrzeżenia, podpowiedzi, ściany ze stykami, lista bali i belek.
- **Widok ściany** (`rdzen/widok.rb`, `html/sciana.js`): wybór z listy albo kliknięcie ściany na rzucie; widok od lica
  jak rozkład ściany producenta – bale z gniazdami zamków i skosem dachu, numery pozycji na balach, numery wieńców,
  styki (czerwone), skrzyżowania ze ścianami i węgłami (przerywane; węgieł ręczny – pogrubiony opis), otwory, linia
  dachu. Odświeża się po podglądzie. Pod widokiem panel ustawień ściany (§5b, `html/edycja.js`): ostatki końców,
  co nad działową i jej góra, stan węgłów („Przywróć automatyczne”); kliknięcie w rysunek dodaje / usuwa węgieł.
  Cała ściana w szerokości okna (długa i niska – przewijanie w poziomie); na rzucie opisy węgłów w środku domu.
- **Zestawienie CSV** (przycisk przy liście; `rdzen/zestawienie.rb`, `sketchup/eksport.rb`): grupa, pozycja, rodzaj,
  przekrój, długość, ilość, objętość; sumy grup i całości; średnik i przecinek dziesiętny, BOM – otwiera się w Excelu.

## 10a. Test działania i raport (menu)

„Rozszerzenia → ArteMadera Generator Wieńcowy → Test działania i raport do wysłania…” (`sketchup/raport.rb`):
- buduje 7 przykładowych domów (`rdzen/przyklady.rb`: 4 × 4 bez łączeń, jak 900 z oknem i drzwiami, 7 × 4,5 z działową
  i węgłem, 10 × 8 z łączeniami i węgłami usztywniającymi, obrys L, krokwie z obu stron szczytu i podłoga 150, pełny
  profil z działową pod antresolą, ostatkiem 200 i węgłem ręcznym) w jednej operacji, którą na końcu cofa – model
  zostaje bez zmian;
- dla każdego domu: liczby z planu i z modelu (instancje według prefiksu), bryły niezamknięte (`manifold?`), bryły
  o objętości innej niż z profilu (> 0,2 %), ściany, których nie narysowano, kontrola zamków i styków, czasy;
- zaznaczony dom: kompilacja, ręczne zmiany, zgodność modelu z parametrami;
- środowisko (SketchUp, Ruby, jednostki modelu, plik ustawień) i dziennik (błędy, ostrzeżenia, czasy);
- zapis do pliku JSON (okno zapisu) i okienko z podsumowaniem – plik do wysłania przy zgłoszeniu problemu.

## 11. Etapy dalej

Według decyzji użytkownika (propozycje 2, 3, 4, 5, 7, 10 objaśnione w rundzie 4 – czekają na wybór): Dokumentacja
2D – grupy Bs/Kf/Sz, dach dokładniej (cięcia krokwi, deski, obrysy L / U albo połacie dla wtyczki dachów), taras,
szybsza budowa modelu, okna i drzwi (typowe wymiary, dociąganie do krawędzi bala, ościeżnice), pliki dla producenta
(XLSX, CNC).
