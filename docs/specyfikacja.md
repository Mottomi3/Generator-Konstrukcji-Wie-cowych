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
- **Szczyt na styk** (`szczyt_styk` = styk – fabrycznie, runda 15, §8j): wieńce szczytu łączą się na styk bez węgła,
  ściana pod szczytem – jak każda inna (w zamkach węgłów i działowych). `szczyt_styk` = wegly (jak do kompilacji 14)
  i szczyt płaski: ściana ze szczytem łączy się tylko na węgłach (działowa kończy się pod okapem, więc w wieńcach
  szczytu nie trzyma styku). Gdy styk wypada nad węgłem, który kończy się pod połacią – ostrzeżenie „styk bez zamka”
  (zwiększ maksymalną długość bala albo dorysuj węgieł bliżej kalenicy).
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
  połacią ścina go linia dachu; przy ścianie ze szczytem – tylko całe odcinki pod linią podparcia dachu (spód krokwi
  i desek), jak węgieł przy szczycie.
- Niższa działowa nie ma szczytu; otwór wyższy niż jej góra – ostrzeżenie; węgły na niej – do jej góry.

## 6. Otwory

- Wpis: ściana (W-n), od, szerokość i wysokość **stolarki** (okna, drzwi), parapet, luz górny, nazwa. „Od” liczone od
  narożnika lica zewnętrznego na początku ściany (kropka na rzucie w oknie); dla działowej – od początku narysowanej
  osi. Parapet od ±0 (spód pierwszego bala) = spód stolarki.
- **Otwór w balach = stolarka + luzy** (`rdzen/stolarka.rb`, runda 5): po bokach `luz_boczny` (10) z każdej strony,
  u góry luz na osiadanie ścian – wpisany w wierszu otworu albo (puste pole) podpowiedź: wysokość stolarki ×
  `osiadanie_scian` (1,5 %), w górę do 5 mm, nie mniej niż `luz_gorny_min` (10); w oknie widać podpowiedź w polu
  i wymiary otworu w balach, w widoku ściany – stolarkę w otworze (przerywana linia).
- Bal w całości w wysokości otworu – przecięty (cięcie proste); bal częściowo – wycięcie od góry (pod parapetem) lub
  od dołu (nad nadprożem).
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
  bliskie obróbki (np. podcięcie zamka 0,07 mm za wycięciem otworu) psułyby ściany bryły. Granice obróbek mają
  pierwszeństwo przed przecięciami skosu z wierzchem lub spodem (runda 5): pominięte przecięcie ścina odrobinę więcej
  drewna, przesunięta granica podcięcia zamka dawała bal 0,13 mm za szeroki w zamku.
- Identyczne bale (ta sama bryła, także po obrocie o 180° wokół pionu) = jedna pozycja „nr-długość” (np. `2-4200`)
  i jeden komponent. Numery: W-1, W-2…, w ścianie wieńce od dołu, w wieńcu wzdłuż ściany.
- Model: grupa „Dom wieńcowy” (obrót układu lokalnego, poziom ±0) > grupy W-n > instancje komponentów „Bal 2-4200”,
  „Bal szczytu 7-2747”, „Kontrfor 9-244”; grupy „Podłoga”, „Dach” i „Taras” z belkami („Legar 15-2800”, „Płatew
  16-5000”, „Słup tarasu 40-1946”…). Tagi: Ściany zewnętrzne, Ściany działowe, Kontrfory, Szczyty, Podłoga, Dach, Taras
  (słupy i bale balustrady).
- Atrybuty dla Dokumentacji 2D (słownik `ArteMadera` na definicji): `rola` = timber, `prefiks` = Bs (bale ścienne) /
  Kf (węgły) / Sz (bale szczytu) / Pw (podwaliny) / L (legary) / Pd (podciągi pod legarami) / P (płatwie) / K (krokwie)
  / S (słupy tarasu)
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
  990–1000 w poziomie), kalenicowa (80 × 180). **Wierzch ścięty do płaszczyzny dachu** (`platwie_sciecie` = tak, wymóg
  użytkownika z rundy 5): płatew podniesiona tak, że ścięty po skosie wierzch leży w linii podparcia na całej szerokości
  (pośrednia i ścienna – z jednej strony, kalenicowa – z dwóch), krokwie i deski leżą na całej płatwi; bez ścięcia –
  wierzch poziomy przy krawędzi od okapu. Długość = dom + 2 × `dach_okap_szczyt` (500).
- Gniazdo płatwi = otwór od spodu płatwi w górę (z luzem `gniazdo_luz` 5 na stronę): bal przy spodzie płatwi ma
  wycięcie od góry, bale wyżej są przecięte (jak 900: kawałki 66-147, 68-372). Gniazda dostają też działowe i węgły,
  pod którymi przechodzi płatew ścienna.
- Krokwie i poszycie – **kto je buduje** (`dach_wiezba`, runda 5, od rundy 6 także przy samych płatwiach):
  - **aplikacja do dachów** (domyślnie; `rdzen/polacie.rb`, `rdzen/krok2.rb`, `sketchup/dach_aplikacja.rb`), tylko przez
    jej stałe API (`ArteMadera::Roof::API`, wersja 1 – aplikacja 3.7.0 lub nowsza; starsza albo brak – komunikat w oknie):
    po budowie domu generator tworzy połacie (`API.polacie` – obrys = lica zewnętrzne ścian okapowych na wysokości linii
    podparcia, krawędzie szczytowe przesunięte o wysunięcie za szczyt − okap, kąt, okap; w operacji budowy domu),
    zapisuje w grupie połaci **podpory** (`API.podpory` – płatwie: wierzch w osi, kalenicowa 1 mm pod grzbietem, żeby
    leżała pod obiema połaciami; dach jednospadowy – także ściana wysoka) i otwiera okno KROKU 2 (`API.wiezba`) z
    ustawieniami domu: w górę od połaci, bez płatwi kalenicowej i zamków dolnych, krokiew, rozstaw, klasa drewna,
    kontrola nośności, warstwy poszycia z sekcji „Poszycie dachu”. Kontrola krokwi liczy przęsła między płatwiami
    (płatew kalenicowa – krokwie na płatwi, bez rozporu). **Same płatwie** (`dach_uklad` = platwie, jak 900): KROK 2 bez
    krokwi – poszycie (deskowanie / nadbitka / OSB) wprost na płatwiach, wzdłuż spadku, styki na płatwiach; bez żadnej
    warstwy – uwaga w podpowiedziach. Po OK więźba dostaje `ArteMadera_GW.wiezba_domu` (id domu). Generator robi same
    płatwie; szczyt kończy się pod krokwiami / poszyciem (linia podparcia). Przebudowa domu usuwa poprzednie połacie, a
    więźbę poprzedniej wersji (po id domu, bez id – nad obrysem poprzednich połaci) – po potwierdzeniu. Jedno „Cofnij”
    dla domu i połaci;
  - **generator** (uproszczone, bez kontroli i bez poszycia): krokwie na linii podparcia, od okapu (`dach_okap` 500 za licem) do
    kalenicy, rozstaw ≤ `krokwie_rozstaw` (900). Przy szczycie (`krokwie_przy_szczycie`): z obu stron szczytu, tylko
    od wewnątrz, tylko od zewnątrz – szczyt dochodzi do wierzchu krokwi; albo krokiew na szczycie – szczyt kończy
    się pod krokwią.
- Bale szczytu: skos wg linii szczytu **pełnym klinem do końca** – szczyt wypełniony do linii dachu (wymóg
  użytkownika z rundy 5; `szczyt_min_wysokosc` 0, większa wartość pomija niższe kliny), okruchy krótsze niż
  `szczyt_min_kawalek` (10) między skosem a gniazdem płatwi pomijane; prefiks Sz. Bal szczytu to jeden element ze
  skosem ściętym z całego bala; osobny krótki kawałek jest tylko tam, gdzie płatew przechodzi przez całą wysokość bala
  (między płatwią a skosem dachu) – jak 21-140, 22-186, 23-233 w 1100 W-2 (decyzja użytkownika 2026-10-25: zostają).
- **Bal ścięty dachem przez narożnik tylko w zamku** (`rdzen/skos_przy_narozniku.rb`, runda 5): gdy ściana poprzeczna
  nie ma w słupie zamka bala na sąsiednim poziomie albo nad gniazdem od spodu zostałoby mniej niż `zamek_min_drewno`
  (20) drewna, bal kończy się przy licu wewnętrznym ściany poprzecznej (bez wiszącego ostatka i cienkiego mostka –
  np. przy ścianie wysokiej dachu jednospadowego).
- Szczyt na działowej (`szczyty_na_dzialowych`): krokwie z obu stron takiego szczytu (albo na nim – opcja „na
  szczycie”), pozostałe krokwie równo między krokwiami przy szczytach.
- Bale pod połacią (`rdzen/pod_dachem.rb`): ściany w poprzek kalenicy bez własnego szczytu (działowe niższe od dachu,
  węgły na ścianach okapowych) ścinane linią podparcia (spód krokwi / desek) – przy stromym dachu ostatki węgłów nie
  wchodzą w połać. Ostrzeżenie, gdy przy licu zewnętrznym ściany okapowej spód krokwi wypada niżej niż jej wierzch.
- Węgły przy szczycie wchodzą w szczyt (do linii dachu); węgły dostawione pod styki – tylko przy `szczyt_styk` = wegly
  (przy szczycie na styk kończą się na wysokości ściany, §8j).
- Belki dachu tylko dla obrysu prostokątnego (inny obrys – szczyty liczone dla każdej ściany osobno, ostrzeżenie;
  dach zrób w aplikacji do dachów – KROK 1 z obrysu).
- **Dach jednospadowy** (`dach_rodzaj`, `rdzen/dach_jednospadowy.rb`, runda 5): ściany wzdłuż „kalenicy” to ściana
  niska (po stronie `dach_spadek`, wysokość ścian okapowych) i wysoka – sięga połaci: wieńce do linii podparcia przy jej
  licu wewnętrznym, górny bal przycięty wzdłuż, pasek cieńszy niż `jednospad_min_pasek` (30) pomijany. Linia podparcia
  od lica wewnętrznego ściany niskiej (z_ref) w górę pod kątem dachu; ściany w poprzek – szczyty skośne (jeden spadek);
  płatew ścienna przy ścianie niskiej, pośrednie do lica ściany wysokiej, bez kalenicowej; krokwie z generatora
  w jednym kawałku od okapu do okapu za ścianą wysoką (`dach_okap_wysoki`); połać dla aplikacji do dachów – jedna,
  z trzema krawędziami szczytowymi. Tylko dom prostokątny.

## 8b. Płatwie, oparcie dachu, podbitka (runda 7 – uwagi z odbioru kompilacji 6)

Te zasady zastępują wcześniejsze opisy w §8, gdy się różnią.
- **Przekrój płatwi w całości** (wymóg użytkownika): jeden przekrój wszystkich płatwi (`platwie_jeden_przekroj`,
  domyślnie 80 × 200); pełna wysokość zostaje po wyższej stronie, wierzch ścięty pod dach tylko od strony okapu
  (kalenicowa – grzbiet = pełna wysokość). Płatew ścienna stojąca na ścianie też ścięta do dachu.
- **Płatwie na pełnym balu** (`rdzen/platwie_wience.rb`): pod gniazdem płatwi nie może zostać pasek bala cieńszy niż
  `min_pasek_przy_otworze` (20) – dach obniżony o najmniejsze d ≤ `dach_obnizenie_max` (60), żeby płatwie o stałym
  położeniu (ścienna przy licu, kalenicowa) leżały na pełnym balu albo na pasku ≥ 20, potem pośrednie przesunięte
  (≤ `platwie_przesuniecie_max` 150, bez przekroczenia rozstawu); czego się nie da – pasek zostaje (nie ma przerwy).
- **Ściana nośna** (`platwa_na_scianie` = nie): bez płatwi ściennej, krokwie / deski na ścianie okapowej – jej górny bal
  ścięty w poprzek do płaszczyzny dachu (`rdzen/sciecie_dachu.rb`); ściana jest podporą w KROKU 2.
- **Zamki w płatwiach** (`platwie_zamki`): w każdej ścianie, przez którą przechodzi płatew – wrąb `platwa_zamek_bok` (5)
  z każdego boku i `platwa_zamek_dol` (8) od spodu, dłuższy od grubości ściany o `platwa_zamek_luz` (1) z każdej strony;
  gniazdo w ścianie węższe o 2 × wrąb boczny.
- **Działowa wzdłuż kalenicy** (`dzialowa_wzdluz_do_dachu`): do płatwi kalenicowej (pod kalenicą) albo do płaszczyzny
  dachu (górny bal ścięty).
- **Podbitka** (`podbitka`, `rdzen/podbitka.rb`): boazeria widoczna od spodu – pod płatwiami (wzdłuż spadku, wierzch na
  spodzie płatwi), na płatwiach (wzdłuż spadku, spód na wierzchu płatwi; krokwie leżą na deskach – wyżej o grubość
  deski / cos kąta, także połać i podpory dla aplikacji), pod krokwiami (wzdłuż okapu, między płatwiami), na krokwiach
  (wzdłuż okapu, spód na wierzchu krokwi). Wybory zależą od układu dachu (płatwie pośrednie / krokwie). Na krokwiach
  i na samych płatwiach z aplikacją do dachów – nadbitka KROKU 2 (wymiary podbitki), generator jej nie rysuje. Ściany
  pod połacią kończą się pod podbitką „pod” (obniżenie w pionie). Deski dłuższe niż handlowe – dzielone na płatwiach
  (wzdłuż spadku) albo równo (wzdłuż okapu); prefiks Pb, grupa Dach.
- **Styki w zamku działowej** (`styk_na_dzialowej` = wspolny): wszystkie wieńce łączone w osi skrzyżowania z działową
  sięgającą co najmniej wieniec poniżej wierzchu ściany – bez węgłów i drugiego rzędu.
- **Węgły z tabeli** (`rdzen/wegly_tabela.rb`): ściana + od narożnika albo na środku; `wegly_srodek` – węgieł na
  środku ścian od `wegly_srodek_min`; miejsce zajęte – najbliższe wolne do 500 mm, z ostrzeżeniem.

## 8c. Runda 8 – węgły, wypusty, taras, typy

- Zamek płatwi: gniazdo w ścianie = szerokość wrębu (bez `gniazdo_luz`), dno na spodzie wrębu.
- Węgieł przy szczycie (wzdłuż kalenicy): górny wieniec może wystawać nad płaszczyznę dachu, gdy pod nią zostaje
  `gniazdo_gleb` + `zamek_min_drewno`; ścina go `rdzen/sciecie_dachu.rb` (pod podbitką „pod” – niżej o jej obniżenie).
  Węgieł na ścianie bez szczytu: dodatkowy wieniec nad górą ściany (na jej górnym balu), ścięty linią dachu.
- Węgieł: wypust wewnątrz domu `wegiel_wypust_wewn`, na zewnątrz `wegiel_wypust_zewn` (przy działowej obie strony
  wewnątrz); wiersz tabeli węgłów może podać własne.
- Symetria (`rdzen/symetria_wegly.rb`): ściana bliźniacza – ten sam kierunek, oś równoległa, ten sam zasięg w świecie;
  styki i węgły usztywniające przenoszone przez współrzędną świata, gdy pasują (otwory, długości). „Równo”: nowe węgły
  pod styki w punktach podziału odcinków między skrzyżowaniami na 2…8 części; układ wybierany po najmniejszej liczbie
  węgłów razem (szacunek usztywniających z limitu światła).
- Wypusty (`rdzen/wypusty_okapu.rb`): `okap_wience_wypust` górnych wieńców własnych ściany okapowej kończy się
  `dach_okap_szczyt` za licem szczytu (na końcach z narożnikiem ze szczytem); styki tej ściany liczone na zasięgu
  z wypustami. `wegly_wypust_okap`: `wegly_okap_wience` górnych bali węgła na ścianie okapowej wysuniętych na zewnątrz do
  `dach_okap`, zasięg pod linią dachu.
- Podłoga: rzędy fundamentów przez osie działowych, odcinki równo; stopa okrągła – graniastosłup 24 boki;
  `podciag_poziom` = rowno – wierzch podciągu 0, między licami wewnętrznymi podwalin (przerwany na podwalinach
  działowych wzdłuż legarów), legary przerwane na podciągu.
- Taras (`rdzen/taras_sciany.rb`): balustrada z wieńców ścian – wieńce frontu i ścian bocznych z wierzchem nie wyżej
  niż `taras_balustrada_wysokosc` pełne, koniec przy narożniku frontu z wypustem `taras_zakladka_wypust` albo równo
  z licem; front z przerwą między licami słupów wejścia; poręcz wspólna (wyższa ścięta, bez piór); słupy z wyciętym pasem
  ściany do wierzchu balustrady; węgły nie stają w strefach słupów. Szczyt pusty – `taras_wieniec`: od rundy 9 wiązar
  (§8d) zamiast dwóch belek pod płatwiami.
- Szablony wbudowane – typy bazowe 100 (domek na samych płatwiach), 200 (parterowy wysoki, taras na słupach), 300
  (1,5 kondygnacji ze stropem, taras między ścianami), 400 (dach jednospadowy); wersje użytkownika – 101, 102… (szablony
  zapisane w oknie).

## 8d. Runda 9 – węgły pod płatwiami, wolny koniec, przesuwanie węgłów, wiązar nad tarasem

- Koniec działowej przechodzący przez ścianę zewnętrzną wychodzi na zewnątrz o `wegiel_wypust_zewn` (jak słupek węgła);
  przy innych połączeniach T – `ostatek`. Węgieł na ścianie domu przy tarasie: strona tarasu jak na zewnątrz.
- Węgieł pod płatwią (`rdzen/wegly_konstrukcyjne.rb`, `wegly_pod_platwiami` = zewnetrzne | wszystkie | nie): na ścianie ze
  szczytem (dom prostokątny; zewnętrzne – szczyty zewnętrzne i ściana domu przy tarasie, wszystkie – także szczyty
  działowych, bez frontu tarasu) w osi każdej płatwi, poza miejscami przy narożniku / skrzyżowaniu (odstęp skrzyżowań)
  i ścianami z węgłami ręcznymi. Wieńce węgła do spodu płatwi (podbitka pod płatwiami – do spodu desek w spadku);
  górny bal ścięty, w słupie zamka czop o wrąb od spodu płatwi; gdy w słupie zamka nie ma drewna nad gniazdem dolnym
  (gniazdo + `min_pasek_przy_otworze`) – słup otwarty, bal węgła w dwóch kawałkach (wewnątrz i na zewnątrz); bal, pod
  którym zostaje mniej niż `min_pasek_przy_otworze`, pominięty (luka pod płatwią < 20 mm).
- Wolny koniec (`wegly_wolny_koniec`, `wegly_wolny_koniec_min` 1000): działowa, której koniec nie dochodzi do ściany –
  węgieł w osi ostatek + pół grubości od końca, gdy wolny odcinek od ostatniego skrzyżowania jest dłuższy niż próg.
- Węgły w strefie słupa tarasu (ręczne, z rysunku, z tabeli) – pominięte z ostrzeżeniem.
- Przesuwanie węgłów (okno, karta okien i drzwi): lista wszystkich węgłów (`rdzen/wegly_tabela.rb#lista`), „od” jak przy
  otworach; zmiana węgła z tabeli – wiersz tabeli, innego – węgły ściany (bez z tabeli i z parametru „na środku”) jako
  ręczne z nowym położeniem.
- Wiązar nad pustym szczytem frontu tarasu (`rdzen/taras_wiazar.rb`, prefiks Wt): grubość z przekroju płatwi albo
  podanego, lico zewnętrzne równo z licem frontu; krokwie wiązara – wierzch na linii szczytu, gniazda płatwi (szerokość
  w wrębie, dno na spodzie wrębu), płatwie z wrębem na grubości wiązara; belka dolna (wysokość jak krokwie) na balach
  frontu albo – `taras_wiazar_podparcie` = slupy – na słupach od spodu podciągu między licami ścian bocznych (front bez
  bali, zamek górny słupów frontu z pasem grubości wiązara); słupek `taras_wiazar_slupek`; `taras_wiazar` = zastrzaly –
  dwa zastrzały `taras_wiazar_zastrzal` od stopy słupka do połowy wolnego spodu krokwi. Człon przecięty gniazdem płatwi
  dzielony; okruchy krótsze niż `min_odcinek` pominięte.
- Ścięcie dachu w poprzek (`rdzen/sciecie_dachu.rb#wyrownaj!`): także stopień krótszy niż 0,2 mm w pionie przy granicy
  pasa; płaszczyzna przesuwana tylko w dół.

## 8e. Runda 10 – dom L, wiązar pod płatwiami, podciąg, okno od nowa

- **Dom L – dwa dachy z koszem** (`rdzen/skrzydla.rb`). Obrys o 6 narożnikach z jednym wklęsłym dzieli się na skrzydło
  główne i boczne. Główne = to o większej rozpiętości (wtedy kalenica boczna jest nie wyżej niż główna); przy równych –
  parametr „kalenica”. Dach główny: dwuspadowy na całej długości, szczyty na obu końcach. Dach boczny: kalenica
  w poprzek, szczyt na wolnym końcu, od strony dachu głównego dwa kosze (dach domu = wyższa z dwóch płaszczyzn po stronie
  skrzydła bocznego od kalenicy głównej). Linia podparcia obu dachów na licu wewnętrznym ściany okapowej na tej samej
  wysokości (wspólne obniżenie dachu).
- **Ściana wspólna** (szczyt dachu głównego, dalej ściana okapowa skrzydła bocznego): szczyt do lica wewnętrznego linii
  okapu dachu głównego; dalej wieńce własne w całości, górny bal ścięty w poprzek do dachu skrzydła bocznego. Ściany
  okapowe skrzydła bocznego są o pół bala wyższe od linii dachu – górny bal ścięty w poprzek.
- **Płatwie skrzydła bocznego**: od wysunięcia za jego szczyt do kosza (wierzch w osi płatwi = płaszczyzna dachu
  głównego); jeśli po drodze weszłyby w płatew dachu głównego – kończą się na styk przy jej licu. Gniazda w ścianach
  tylko na zasięgu płatwi.
- **Połacie domu L** dla aplikacji do dachów: obrys domu, krawędzie szczytowe przesunięte o (wysunięcie − okap); na
  ścianie wspólnej część szczytowa wysunięta dalej niż okapowa co najmniej o 1 mm – krótka krawędź uskoku jest okapem
  tylnej połaci dachu głównego (bez niej aplikacja robi naroże kopertowe).
- **Wypust górnych wieńców okapowych** tylko w narożnikach wypukłych; w wklęsłym – zwykły ostatek.
- **Wiązar nad tarasem** podpiera płatwie: wierzch krokwi wiązara równoległy do dachu, obniżony tak, by dno gniazda
  każdej płatwi (spód jej wrębu) było ≥ `taras_wiazar_gniazdo` pod wierzchem krokwi przy niższej krawędzi gniazda.
  Zastrzały: oś od stopy słupka pod kątem `taras_wiazar_zastrzal_kat` od poziomu do spodu krokwi; krótsze niż dwie
  szerokości – pomijane.
- **Podciąg** domyślnie na wysokości podwalin (legary dzielone). **Ustawienia**: plik w wersji 2; parametry z listy
  `DO_FABRYCZNYCH` zapamiętane w starszym pliku wracają do wartości fabrycznych.
- **Zaznaczenie**: sam dom – edycja; dom + linie, z których powstał – edycja; dom + inne linie – pytanie.

## 8f. Runda 11 – słupki pod płatwiami do wyboru, front tarasu bez kontrfor, dobór przekrojów dachu

- **Słupki z kontrfor (węgły) pod płatwiami** (`rdzen/wegly_konstrukcyjne.rb`): `wegly_pod_platwiami` = nie / szczyty
  zewnętrzne / wszystkie szczyty; `wegly_pod_platwiami_ktore` = pod każdą płatwią / tylko pod kalenicową. Węgieł, który
  już stoi w osi płatwi (środek ściany, tabela, rysunek, ręczny), staje się węgłem pod płatwią – jego bale dochodzą do
  spodu płatwi.
- **Płatew zawsze na balu węgła** (`rdzen/platwie_wience.rb`): wieńce węgła są przesunięte o pół bala względem szczytu;
  obniżenie dachu (≤ `dach_obnizenie_max`) i przesunięcie płatwi pośrednich (≤ `platwie_przesuniecie_max`) pilnują, żeby
  górny bal węgła pod płatwią był pełny albo nie cieńszy niż `min_pasek_przy_otworze` – bez szczeliny między węgłem
  a płatwią. Nie dotyczy podbitki pod płatwiami (węgieł kończy się pod deskami).
- **Słup frontu tarasu w osi kalenicy** (`rdzen/taras.rb#slup_w_osi`, `taras_slup_w_osi`): pod kalenicą stoi słup –
  w jednej linii ze słupkiem trójkąta; pozostałe pośrednie równo po obu stronach. Wejście z boku, którego słup jest
  bliżej osi niż `taras_slup_os_dociag` (500) – ten słup staje w osi (wejście szersze albo węższe o tę odległość).
  Oś w świetle wejścia – bez słupa w osi.
- **Front tarasu bez kontrfor** (`rdzen/styki_tarasu.rb`, `rdzen/wegly_tabela.rb`): na froncie z podciągiem nie powstaje
  węgieł „na środku ściany” ani węgły pod styki. Bale dłuższe niż maksymalny łączone na styk (`taras_styk` = styk):
  wieńce jednej parzystości (z najniższym balem podciągu) w osi słupa, drugiej – o mijankę (≥ 300) dalej, na przemian.
  `taras_styk` = wegly – jak zwykła ściana.
- **Zamek płatwi nad szczytem tarasu tylko od spodu** (`rdzen/zamek_platwi.rb`, `taras_platwa_zamek` = spod): wrąb
  płatwi na grubości trójkąta (i frontu) bez wrębów bocznych – `e[:wreby]` z własną głębokością boczną `[x0, x1, 0]`;
  gniazdo w krokwi trójkąta na pełną szerokość płatwi. `pelny` – jak w ścianach.
- **Słupek i zastrzały trójkąta** (`taras_wiazar_przekroje`): własne szerokości (120 / 100) albo jak reszta trójkąta
  (wysokość przekroju wiązara).
- **Trójkąt w wąskim domu** (`rdzen/taras_wiazar.rb#postac`): gdy belka dolna z krokwiami nie mieści się pod dachem –
  same krokwie na balach frontu (ze słupkiem, jeśli jest miejsce) albo, na słupach, sama belka dolna; zawsze
  z ostrzeżeniem. Trójkąt nigdy nie znika bez słowa.
- **Dobór przekroju płatwi** (`rdzen/statyka_dachu.rb`, `platwie_dobor` = reczny / auto): obciążenie na metr płatwi =
  ciężar pokrycia (`dach_ciezar`, kN/m² połaci) × pas dachu / cos kąta + śnieg gruntu (`dach_snieg`) × μ (0,8 do 30°,
  liniowo do 0 przy 60°) × pas dachu; pas = po połowie odległości do sąsiednich linii podparcia połaci; przęsło =
  największa odległość między ścianami, przez które płatew przechodzi (ściana wzdłuż płatwi podpiera ją na całej
  długości; koniec za szczytem liczony jak przęsło dwa razy dłuższe). Sprawdzenie jak legarów (`rdzen/statyka.rb`,
  zginanie, ścinanie, ugięcie końcowe ≤ L / `dach_ugiecie`, śnieg bez części długotrwałej). Auto – najlżejszy
  wystarczający z `platwie_katalog`; ręcznie – wynik sprawdzenia w podpowiedziach sekcji „Szczyty i dach”.
- **Dobór przekroju trójkąta** (`rdzen/statyka_wiazara.rb`, `taras_wieniec` = auto): krokiew trójkąta od ściany bocznej
  do kalenicy pod siłami od płatwi pośrednich (połowa przęsła płatwi do ściany domu + koniec za trójkątem), wysokość
  pomniejszona o gniazdo płatwi; na słupach – także belka dolna między słupami przy osi. Najlżejszy wystarczający
  przekrój z listy płatwi, przy którym mieści się cały trójkąt.
- **Dwa przebiegi obliczeń** (`rdzen/projekt.rb#oblicz`): dobór liczy dom z przekrojami z pól, dobiera, liczy dom od
  nowa z dobranymi i potwierdza (najwyżej 3 dodatkowe przebiegi). `plan[:parametry]` ma przekroje dobrane; zapis domu
  w modelu – parametry z okna.
- Statyka dachu to podpowiedź – nie zastępuje projektu konstruktora.

## 8g. Runda 12 – boczne zadaszenie z załamaniem dachu (`rdzen/zadaszenie.rb`)

Wymóg użytkownika (2026-11-25): boczne zadaszenie doklejone do połaci dachu, **pod mniejszym kątem niż połać**; aplikacja
do dachów dostaje informację o załamaniu (łaty pod blachę). Wybory: podparcie do wyboru (słupy z oczepem albo ściany
z bali), na całej długości ściany okapowej, łaty przy załamaniu z obu stron i pełne moduły pod załamaniem.

- **Kiedy**: dom prostokątny, dach dwuspadowy ze szczytami z bali, bez tarasu; kąt zadaszenia co najmniej 0,5° mniejszy
  niż kąt dachu – inaczej ostrzeżenie i dom bez zadaszenia. Strona: ściana okapowa o mniejszej / większej współrzędnej
  albo obie (`zadaszenie_strona`).
- **Linia załamania**: nad licem zewnętrznym ściany okapowej (płatew ścienna stojąca na ścianie, szersza niż ściana – nad
  jej krawędzią). Dach domu do niej bez zmian, dalej połać zadaszenia pod `zadaszenie_kat` do lica podpory
  (`zadaszenie_szerokosc` od lica ściany) i okap `zadaszenie_okap` (najmniej – aplikacja wydłuża do pełnych modułów).
  Linia dachu w przekroju (`Dach.linia_podparcia`) ma dwa załomy: kalenicę i załamanie – szczyty, węgły, ściany pod
  dachem i bale ścięte dachem liczą się z łamanej (`Dach.zalomy_v`).
- **Płatwie zadaszenia** (`zadaszenie_platwa_przekroj`, wierzch ścięty do połaci jak płatwie dachu): pierwsza tuż za linią
  załamania (przechodzi przez ostatki ścian szczytowych – gniazda i wręby jak płatwie dachu), pośrednie co najwyżej
  `platwie_rozstaw_max` (układy z płatwiami pośrednimi), ostatnia – oczep nad słupami albo płatew ścienna przybudówki;
  od rundy 13 dobierane automatycznie albo sprawdzane (§8h).
- **Na słupach**: słupy (`zadaszenie_slup_przekroj`) licem w linii podpory, skrajne w osiach ścian szczytowych, pośrednie
  równo co najwyżej `zadaszenie_slupy_rozstaw`, na fundamentach punktowych (gdy podłoga ma fundamenty), podstawa – spód
  podwaliny. Na słupie belka poprzeczna (`zadaszenie_belka_przekroj`, prefiks Bp) od lica podpory do ściany domu (skrajne –
  do końca ostatków ścian szczytowych; linia pośrednia, w której belka trafiłaby w węgieł albo działową, przesunięta obok),
  na belkach oczep, pozostałe płatwie na słupkach. Ściana z bali osiada – belka jest tylko oparta o ścianę.
- **Przybudówka z bali**: obrys poszerzony o szerokość (jak taras), dawna ściana okapowa – działowa o wysokości ściany
  okapowej z oparciem dachu domu (`w[:zadaszenie][:rola] = :dom`), ściany szczytowe przedłużone ze szczytem łamanym,
  ściana zewnętrzna przybudówki – szczyt płaski do połaci zadaszenia (wyższe wieńce pominięte, górny bal ścięty), przy
  ścianie nośnej podpora połaci w KROKU 2.
- **Aplikacja do dachów** (3.12.0+): połacie z opcją `:zalamania` (krawędź okapowa domu, `od` – linia załamania od
  krawędzi, `szerokosc`, `okap`, `kat`), płatwie zadaszenia jako podpory; KROK 2 – krawędź załamania, łaty przy linii
  załamania, okap zadaszenia do pełnych modułów, krokwie i deski docięte w płaszczyźnie dwusiecznej. Starsza aplikacja –
  komunikat zamiast połaci.
- **Krokwie z generatora**: przy zadaszeniu krokiew dachu od linii załamania i krokiew zadaszenia od jego okapu do niej
  (czoła prostopadłe do osi, jak dotąd).
- Elementy zadaszenia w grupie i tagu „Zadaszenie” (płatwie P, słupy i słupki S, belki Bp, fundamenty F).

## 8h. Runda 13 – zakładka zadaszenia, dobór przekrojów zadaszenia i krokwi, podłoga w przybudówce

Wymóg użytkownika (2026-11-25 17:19): płatwie, słupy, krokwie dobierane z minimalnego przekroju automatycznie albo z wyboru
użytkownika; podłoga w przybudówce w opcjach; cała część bocznego (tylnego) zadaszenia w osobnej zakładce.
- **Zakładki okna** (`rdzen/parametry_lista.rb` ZAKLADKI, czwarty element SEKCJE, `html/zakladki.js`): „Dom” i „Zadaszenie
  boczne / tylne”; sekcja bez zakładki należy do „Dom”. Parametry `zadaszenie_*` tylko w sekcjach zakładki zadaszenia.
- **Dobór zadaszenia** (`zadaszenie_dobor`: auto – domyślnie, reczny; `rdzen/statyka_zadaszenia.rb`): grupy o wspólnym
  przekroju – płatwie z oczepem (`zadaszenie_platwa_przekroj`), belki poprzeczne (`zadaszenie_belka_przekroj`), słupy
  (`zadaszenie_slup_przekroj`); listy `zadaszenie_katalog` (belki) i `zadaszenie_slupy_katalog`. Obciążenia jak dach
  (`dach_ciezar` na m² połaci, `dach_snieg` × μ) przy kącie zadaszenia, ugięcie `dach_ugiecie`.
  - Płatew / oczep: przęsło – największa odległość między podporami (linie słupów pod płatwią – belka poprzeczna i słupek,
    oczep – słupy; ściany i ostatki, przez które płatew przechodzi; ściana wzdłuż płatwi niesie ją w całości), wspornik za
    szczytem jak 2a; pas – połowa odległości do sąsiednich płatwi zadaszenia (pierwsza od załamania, ostatnia do okapu).
  - Belka poprzeczna: przęsło od osi słupa do końca belki przy ścianie domu, obciążenie z pasa między sąsiednimi liniami
    słupów (skrajne – z wysunięciem za szczyt).
  - Słup (`rdzen/statyka_slupa.rb`): ściskanie z wyboczeniem, długość = od fundamentu do spodu belki, siła z połowy szerokości
    zadaszenia i okapu na pasie słupa + ciężar belki i oczepu; k_c wg PN-EN 1995 §6.3.2, smukłość ≤ 150.
  - Auto: najlżejszy przekrój z listy spełniający warunki całej grupy – wynik do następnego przebiegu obliczeń (jak płatwie
    dachu); z wyboru: przekrój z pola, podpowiedź z najmniejszym wystarczającym albo radą.
- **Dobór krokwi** (`krokwie_dobor`: reczny – domyślnie, auto; `krokwie_katalog`; `rdzen/statyka_krokwi.rb`): jeden przekrój
  krokwi całego dachu (krokwie zadaszenia z tego samego przekroju). Krokiew – belka na płatwiach (ściana nośna – lico
  wewnętrzne ściany; kalenica i załamanie to końce krokwi), przęsło w rzucie, okap jako wspornik 2a; obciążenia na rozstaw
  `krokwie_rozstaw`, składowe prostopadłe, długość po skosie. Podpowiedź krokwi dachu w „Szczyty i dach”, krokwi zadaszenia –
  w zakładce zadaszenia. Z aplikacją do dachów – przekrój na start KROKU 2.
- **Podłoga w przybudówce** (`zadaszenie_podloga`: tak – domyślnie, nie; `rdzen/podloga_przybudowki.rb`): bez podłogi pole
  podłogi (legary, przęsła, podciągi, objętość) kończy się na osi dawnej ściany okapowej ± pół podwaliny; podwaliny na całym
  obrysie (także pod ścianami przybudówki) i siatka fundamentów na całym obrysie, fundamenty pod podciągami tylko w polu
  podłogi. Kierunek legarów (krótszy / dłuższy bok) z pola podłogi. Dawna ściana okapowa zawsze na podwalinie.

## 8i. Runda 14 – zaległe rozstrzygnięcia z 2026-11-14, długości z hurtowni, pasek narzędzi, prosty odbiór

- **Działowa w linii ściany obrysu** (`rdzen/sciana_w_linii.rb`): koniec linii działowej leży w narożniku obrysu (w zasięgu
  grubość + tolerancja od boku), jedna ściana obrysu jest do niej równoległa, druga poprzeczna, a działowa odchodzi od
  narożnika (drugi koniec poza bokiem ściany równoległej). Wtedy: linia działowej przesuwana w poprzek na oś ściany
  równoległej; koniec działowej = przecięcie z osią ściany poprzecznej, bez wypustu; ściana równoległa traci ostatek na tym
  końcu (`s_od` = 0 albo `s_do` = `dl_osi`, `ostatki_param` = nil, `w_linii` = true). Bale obu ścian stykają się w osi
  zamka, każdy ma na końcu połowę gniazda; ściana poprzeczna przechodzi przez węzeł z ostatkiem i trzyma oba końce.
  Drugi koniec działowej tak samo, gdy oś drugiej ściany równoległej leży na tej samej linii (± 1 mm); inaczej – zwykłe
  przejście przez ścianę poprzeczną.
- **Linia działowej a obrys** (`rdzen/obrys.rb#przytnij_do_obrysu`): linia dzielona na punktach przecięcia z bokami;
  kawałek na boku obrysu – pomijany bez ostrzeżenia; kawałek poza obrysem – ostrzeżenie; każdy ciąg kawałków w środku domu
  to osobna działowa.
- **Ściany równoległe** (`rdzen/kontrola_rownoleglych.rb`): pary ścian o tym samym kierunku z osiami bliżej niż grubość
  bala; bale porównywane jako prostopadłościany (wzdłuż, w poprzek, w pionie), wspólna część powyżej 0,5 mm w każdym
  kierunku = nakładanie. Wynik: `Kontrola.wszystko[:nakladanie]` i ostrzeżenie w oknie. W teście losowym bale ścian
  i działowych nie mogą się nakładać nigdy; węgły dwóch ścian bliższych niż długość węgła – tylko z ostrzeżeniem.
- **Awaria obliczeń** (`rdzen/awaria.rb`): `Projekt.oblicz` nie wypuszcza wyjątku – plan bez ścian, `bledy` = [zdanie po
  polsku], `wyjatek` = „Klasa – treść [plik:wiersz, kompilacja N]”. Okienko przy starcie i „Generuj”; przy podglądzie tylko
  lista błędów w oknie.
- **Wykaz drewna** (`rdzen/wykaz_drewna.rb`): przekrój = mniejszy × większy wymiar; lista w parametrze
  „b×h:długości w metrach przez ukośnik”, wpis bez dwukropka = bez ograniczenia; liczba poniżej 100 to metry, od 100 –
  milimetry. Listy fabryczne: legary (C24 od 45 × 95 i drewno widoczne), płatwie i belki zadaszenia (widoczne prostokątne
  od szerokości 60), krokwie (C24 od 45 × 145, widoczne 45 i 60 × ≥ 120, 80 × 160 / 200), słupy zadaszenia (kwadratowe).
- **Długości handlowe** (`rdzen/dlugosci_handlowe.rb`): dobór płatwi (`StatykaDachu.dobierz`) i członów zadaszenia
  (`StatykaZadaszenia.dobierz`) – spośród wystarczających najlżejszy, którego najdłuższa belka z listy ≥ długość
  najdłuższego członu grupy; gdy żaden – najlżejszy wystarczający. Podpowiedź (poziom „uwaga”, sekcja grupy) dla belek
  modelu dłuższych niż najdłuższa handlowa ich przekroju: legary, podciągi, płatwie, krokwie, belki trójkąta, płatwie,
  belki i słupy zadaszenia; przekrój spoza listy albo bez długości – bez podpowiedzi.
- **Podpowiedzi podłogi**: podciąg wystarczający z nośnością ≥ 90 % (`Podciagi::ZAPAS`) – poziom „uwaga” z radą; zdanie
  o legarze bez podciągów w trybie przypuszczającym.
- **Pasek narzędzi** (`sketchup/pasek.rb`): trzy polecenia (start, kontrola, test działania); pierwsze uruchomienie – pasek
  pokazany, potem stan zapamiętany przez SketchUpa. Menu pod prawym przyciskiem: dom z generatora w zaznaczeniu – edycja
  i kontrola; co najmniej 4 zaznaczone linie bez domu – nowy dom.
- **Folder raportów i dziennik pracy** (`sketchup/dziennik_pracy.rb`): `Dokumenty\ArteMadera Generator Konstrukcji
  Wieńcowych\raporty\` (gdy folder projektu istnieje; inaczej `raporty` obok pliku ustawień). Raport z testu działania:
  `raport_RRRR-MM-DD_GGMMSS_kN.json` z polem `wynik` (domy, w porządku, problemy, czasy). Dziennik: `dziennik_pracy.jsonl`,
  wiersz po każdym „Generuj” (tryb, obrys, liczby, `ms_obliczen`, `ms_budowy`, ostrzeżenia, ustawienia zmienione względem
  fabrycznych) i po awarii; najwyżej 400 ostatnich wierszy.
- **Plik ustawień wersja 3** (`sketchup/ustawienia.rb`): listy przekrojów z pliku starszej wersji (ostatnie parametry
  i własne szablony) zastępowane fabrycznymi.

## 8j. Runda 15 – szczyty na styk, pół zamka, deski 14 × 115, osiadanie słupów, zestawienie materiałów

- **Szczyt na styk** (`rdzen/styki_szczytu.rb`, decyzja T8 z 2026-11-25: „można na styk z przesunięciem o 300 mm”):
  wieniec szczytu = wieniec o spodzie na górze ściany bez szczytu albo wyżej (ściana zewnętrzna: od wieńca n + 2).
  Kawałek takiego wieńca dłuższy niż `max_dlugosc` łączy się na styk – bez węgła i bez zamka. Miejsca styków leżą na
  dwóch siatkach o kroku 2 × `mijanka` (nie mniej niż 2 × 300), przesuniętych o mijankę: wieńce parzyste – kalenica
  − pół mijanki, nieparzyste – kalenica + pół mijanki, więc styki sąsiednich wieńców zawsze mijają się o mijankę.
  W kawałku: jak najmniej styków, w wolnym miejscu siatki najbliżej punktu równego podziału. Styk nie wypada w zamku
  skrzyżowania (1,5 grubości od osi), bliżej otworu sięgającego szczytu niż `styk_odstep_od_otworu`, przy gnieździe
  płatwi ani bliżej niż mijanka od styku najwyższego wieńca ściany; kawałki od `min_odcinek` do `max_dlugosc`.
- Ściana pod szczytem łączy się jak ściana bez szczytu: miejscem styku jest także zamek działowej, a węgły dostawione
  pod styki (`do_gory_sciany`) kończą się na wysokości ściany okapowej – najwyższy wieniec ściany trzyma zamek od spodu.
  Węgły usztywniające, narysowane, z tabeli i pod płatwiami – bez zmian (do dachu).
- Nie dotyczy: szczytu płaskiego (ściana wysoka dachu jednospadowego, działowa do dachu, ściana przybudówki – pełne
  wieńce na całej długości, zostają przy węgłach) i frontu tarasu (`taras_styk`). `szczyt_styk` = wegly – jak do
  kompilacji 14. `Kontrola.styki_bez_zamka` nie liczy styków wieńców szczytu łączonych na styk; mijanka – liczy.
- Pomiar (600 losowych domów, ziarna 1–300 i 6001–6300): domy ze stykiem bez zamka w ścianie ze szczytem 31 → 10
  (zostały: ściana wysoka dachu jednospadowego i ściana domu L pod dachem skrzydła bocznego – węgieł kończy się tam pod
  podbitką albo krokwiami), bale węgłów pod styki na ścianach ze szczytem 30 542 → 22 056 (−28 %).
- **Pół zamka w ostatnim połączeniu pod dachem** (`rdzen/pol_zamka.rb`, `polzamek` = tak | nie – fabrycznie nie, do
  akceptacji rysunku `docs/ostatnie_polaczenie_r15.png`): zwykły zamek to gniazdo 36 od wierzchu bala niższego i 36 od
  spodu wyższego (razem 72 = pół wieńca 69,5 + luz 2,5). Bal ścięty skosem dachu, któremu nad gniazdem od spodu zostaje
  mniej niż `zamek_min_drewno` (20), był ucinany przy licu ściany poprzecznej (`rdzen/skos_przy_narozniku.rb`). Pół
  zamka: gdy ściana poprzeczna ma bal poziom niżej i żadnego poziom wyżej, a pod skosem jest ≥ 20 mm, bal zostaje
  w narożniku bez gniazda (`b[:polzamek]` – osie zamków), a `Zamek.nanies` daje balowi niższemu gniazdo
  `PolZamka.gniazdo_nizszego` (2 × `gniazdo_gleb` = 72; zostaje mu 139 − 36 − 72 = 31). `polzamek_gleb` > 0 – tyle w balu
  niższym (36…72), reszta od spodu wyższego. Pomiar (444 domy ze szczytami): 370 bali uciętych przy narożniku mimo bala
  pod spodem (głównie dach na ścianie nośnej, bez płatwi ściennej), 324 mieszczą pół zamka; 510 bali bez partnera (nad
  ścianą okapową) – bez zmian.
- **Deski** (`rdzen/parametry_dach.rb`): nadbitka i podbitka 14 × 115 (krycie) × 4000; fabrycznie `poszycie_nadbitka`
  = tak, `poszycie_deski` = nie. Przy podbitce pod płatwiami nadbitka zostaje poszyciem na płatwiach. Plik ustawień
  w wersji 4 (`Ustawienia::DESKI`, `DO_FABRYCZNYCH[4]`).
- **Osiadanie słupów** (`rdzen/osiadanie.rb`): luz = wysokość do głowicy słupa × `osiadanie_scian` %, w górę do 1 mm;
  wierzch pełnego przekroju słupa tarasu = spód podciągu − luz − `slup_regulacja_wysokosc` (śruba; podkładki – bez
  dodatku); zamek górny dłuższy o śrubę (po osiadaniu obejmuje bal na `taras_slup_zamek_gora`). `slup_osiadanie` = nie –
  jak do kompilacji 14. Element słupa niesie `e[:osiadanie]` = { luz, okucie, razem, regulacja }.
- **Zestawienie materiałów** (`rdzen/materialy.rb`, `plan[:materialy]`, parametry `rdzen/parametry_materialy.rb`):
  powierzchnia połaci domu prostokątnego = (długość + 2 × `dach_okap_szczyt`) × (rozpiętość + okapy) / cos kąta (boczne
  zadaszenie osobno, po jego stronie połać domu do linii załamania); inny obrys – (pole obrysu + obwód × okap) / cos,
  z dopiskiem. Deski i płyty: m² × (1 + `material_zapas` %) / (krycie × długość), w górę. Taśma: długość bali poza
  najniższym wieńcem × `tasma_pasy`. Okucia: regulacja i podstawy słupów, kotwy podwalin co `kotwy_podwalin_rozstaw`
  (≥ 2 na podwalinę), łącznik na każde przecięcie osi krokwi z generatora z płatwią w rzucie. Impregnacja: lica bali,
  obwód × długość belek, spód desek; litry = m² × `impregnat_warstwy` / `impregnat_wydajnosc`. Blok CSV pod sumami.

## 8k. Runda 16 – pół zamka pod całym dachem, jedno pole desek, trzy poziomy ustawień, okno krokami, dom z wymiarów, powierzchnie

- **Pół zamka fabrycznie** (`polzamek` = tak; odpowiedź z 2026-11-25: „dobry pomysł, z tymże trzeba i tak podfrezować
  gniazda na bokach górnego elementu”): bal górny nie ma wycięcia od spodu, ale ma podcięcia boczne zamka
  (`Zamek.podciecia`: 2 × `podciecie_gleb` 2,5 – szyjka 39 w gnieździe 40), bal pod nim gniazdo 72 od wierzchu.
  Rysunek `docs/ostatnie_polaczenie_r16.png`.
- **To samo poza narożnikiem** (`PolZamka.ostatnie?`, `Zamek.ostatnie_polaczenia!`): w każdym skrzyżowaniu (góra węgła,
  działowa pod połacią, ściana wysoka dachu jednospadowego) para bali jest ostatnim połączeniem, gdy balowi wyższemu
  pod skosem albo ścięciem dachu zostaje nad zwykłym gniazdem mniej niż `zamek_min_drewno` (20), ale sam ma w zamku
  co najmniej tyle (cieńszy klin – zwykłe gniazdo jak dotąd), żaden bal nie siada na nim pełnym gniazdem, a balowi
  niższemu po gnieździe 72 (i jego własnym gnieździe od spodu) zostaje ≥ 20 mm. W węźle ścian w jednej linii (§8i), gdzie
  dwa bale tego samego wieńca stykają się czołami nad wspólnym gniazdem, oba są balami półzamka albo – gdy na drugim coś
  leży – drugi zostaje ze zwykłym gniazdem nad głębszym (`Zamek.wspolne_polzamki!`; z dwóch gniazd w tym samym miejscu
  zostaje głębsze).
  Decyzje zapadają na liście par od najniższej, obróbki nanoszone są potem w dotychczasowej kolejności. Para, w której
  bal pół zamka nie sięga bala nad sobą, nie dostaje gniazda (koniec pustych gniazd).
- **Ostatni bal węgła** (`Bale.kontrfor_obecny?`, `#ostatni_bal_wegla?`): węgieł ma bal także w wieńcu, w którym pod
  dachem zostaje od `PolZamka.min_wysokosc` (20 mm zamiast 36 + 20), gdy nad nim nie ma już wieńca ściany; przy ścianie
  szczytowej – gdy wyższy wieniec szczytu nie przechodzi przez oś węgła.
- **Styk bali zawsze w zamku** (odpowiedź z 2026-11-26: „jak dotąd były tam zamki i chciałbym tego nie zmieniać – bez
  zamka będzie to uciekać przy montażu oraz będzie mieć tendencję do skręcania się”): przy podbitce pod płatwiami węgieł,
  w którego osi ściana ma styk, nie jest obniżany pod deski (`Podbitka.obnizenie_wegla` = 0, `#wegiel_do_polaci?`) –
  dochodzi do połaci, a deski podbitki są na nim przerwane z luzem 2 mm + grubość deski × sin kąta (`#bez_wegla`).
  Ostrzeżenie o styku bez zamka zostaje ostrzeżeniem. Pomiar (600 domów, 6001–6600): 23 → 8 domów; zostały działowa pod
  podbitką niosąca styk ściany okapowej i styk ściany szczytowej nad końcem węgła (`docs/zadanie_r16.md` §4).
- **Jedno pole położenia desek** `podbitka` (odpowiedź z 2026-11-25): na_platwiach | na_krokwiach | pod_krokwiami |
  pod_platwiami | nie; fabrycznie na_krokwiach. Wartość niezgodna z układem dachu (`dach_uklad`) zamienia się na
  odpowiednik (`ParametryDach::DESKI_ZAMIENNIKI`: krokwie ↔ płatwie) w `Parametry.normalizuj` i w oknie. Deski „na …”
  robi aplikacja do dachów (warstwa „podbitka” KROK 2), „pod …” – generator. Dawne pola `poszycie_nadbitka`
  i `nadbitka_*` są przenoszone przy wczytaniu domu i ustawień (`#przenies_nadbitke`).
- **Trzy poziomy ustawień** (`rdzen/poziomy.rb`, cecha `poziom:` każdego pola – :dom 18, :typ 48, :standard 131):
  parametry nowego domu = fabryczne ← standard warsztatu ← pola typu; dom w modelu ma swoje (edycja). Szczegóły – §10.
- **Dom z wymiarów** (`rdzen/dom_z_wymiarow.rb`): generator uruchomiony bez zaznaczenia buduje prostokąt
  `dom_dlugosc` × `dom_szerokosc` (lica zewnętrzne, 6000 × 4000) od początku układu, kalenica wzdłuż długości;
  pola widać tylko w takim domu (`z_wymiarow: true`), edycja domu zmienia wymiary bez rysowania.
- **Powierzchnie i limity** (`rdzen/powierzchnie.rb`, `plan[:powierzchnie]`): zabudowa = pole obrysu po licach
  zewnętrznych z tarasem; pomieszczenia = obszary między licami wewnętrznymi ścian (siatka z krawędzi ścian, zalewanie;
  węgły nie dzielą), z wymiarami; dach = połacie z okapami (jak w zestawieniu materiałów); wysokość = najwyższy punkt
  konstrukcji dachu nad terenem (`teren_pod_balem` 300 pod spodem pierwszego bala). `limit_zabudowy` [m²]
  i `limit_wysokosci` [m] (0 = bez limitu) – po przekroczeniu ostrzeżenie, od 95 % podpowiedź. Trzeci blok w CSV.
- **Lista uwag z miejscem** (`rdzen/uwagi_pola.rb`): każde ostrzeżenie i podpowiedź dostaje pole, sekcję i krok
  (tabela wzorców) – okno prowadzi kliknięciem do pola.
- **Opcje zależne od obrysu** (cecha `obrys:` pola: `tylko`, `zostaje`, `powod`): rodzaj obrysu (prostokąt, L, inny)
  z podglądu; wybory niedostępne są wyszarzone, pod polem powód, wartość niedostępna wraca do dozwolonej.

## 8l. Runda 17 – styk zawsze w zamku, stolarka z listy i kliknięciem, magazyn drewna, wycena

- **Styk zawsze w zamku** (zasada użytkownika z 2026-11-26: „jak dotąd były tam zamki … bez zamka będzie to uciekać przy
  montażu i skręcać się”). Oprócz węgłów ze stykami do połaci (runda 16):
  - węgieł dochodzi do spodu płatwi leżącej w gnieździe ściany (płatew ścienna skrzydła domu L niżej niż góra ściany,
    płatew dachu przechodząca przez ścianę w miejscu węgła), gdy bal ściany nad nim zachowuje między gniazdem zamka od
    spodu a gniazdem płatwi co najmniej „Najmniej drewna w zamku” (`rdzen/bale.rb#bez_platwi_nad`);
  - przy podbitce pod płatwiami działowa, na której łączą się bale ściany okapowej, sięga przy tej ścianie do wierzchu bala
    pod jej najwyższym wieńcem (pół wieńca pod górą ściany, nie wyżej niż połać); dalej kończy się pod deskami; deski
    podbitki przerwane na działowej na odcinku, na którym działowa wystaje nad nie (`rdzen/podbitka.rb`).
- **Typowa stolarka** (pole-tabela standardu `stolarka`): symbol, rodzaj (okno / drzwi), szerokość i wysokość stolarki,
  spód od podwaliny, model (plik .skp). Otwór ma kolumnę „Typ” – wybór typu wpisuje wymiary; otwór z typem dostaje przy
  generowaniu model z folderu „Folder modeli stolarki” (`<model>.skp` albo `<symbol>.skp`; punkt 0 w dolnym lewym narożniku
  stolarki widzianej od zewnątrz, X wzdłuż szerokości, Y w głąb ściany, Z w górę; grupa i tag „Stolarka”). Brak pliku – sam
  otwór i uwaga w komunikacie; model innej wielkości niż stolarka – uwaga, bez skalowania.
- **Kliknięcie w widok ściany** (`html/klik_sciana.js`): przełącznik „węgieł / okno / drzwi”; okienko z parametrami przy
  miejscu kliknięcia (środek nowego otworu w miejscu kliknięcia); kliknięcie w otwór – poprawa albo usunięcie wiersza
  tabeli; przy węgle (do 80 mm albo 8 px) – przesunięcie („od”) albo usunięcie; pierwsza zmiana węgła przepisuje węgły
  ściany na ręczne (jak dotąd).
- **Dom z wymiarów – działowe z tabeli okna**: kierunek (w poprzek – równoległa do szerokości, wzdłuż), oś od lica ściany
  początkowej, początek i długość (puste – od lica do lica); jak linia narysowana w środku obrysu.
- **Magazyn drewna** (pole-tabela standardu `magazyn_drewna`, `rdzen/magazyn_drewna.rb`): wiersz = przekrój „szer.x wys.”,
  długości handlowe w metrach (puste – bez ograniczenia), rodzaj, znaczniki „do czego” (legar / podciąg, płatew, krokiew,
  belka zadaszenia, słup, deska), cena za m³. Dobór przekrojów bierze przekroje ze znacznikiem swojego elementu; fabrycznie
  wykaz Drewno Partner (konstrukcyjne C24 i widoczne Nsi / DUO / BSH) i deska 14 × 115 × 4 m. Dawne listy tekstowe
  przechodzą do magazynu same. Pola przekrojów w oknie podpowiadają przekroje z magazynu.
- **Jeden przełącznik doboru** „Przekroje konstrukcji”: podaję sam (fabrycznie – sprawdzenie i podpowiedź najmniejszego
  wystarczającego) / dobieraj automatycznie (najlżejszy wystarczający z magazynu). Pola doboru płatwi, krokwi, legarów
  i zadaszenia: „jak przełącznik” (fabrycznie) albo wyjątek elementu. Dobór automatyczny bierze najpierw przekroje dostępne
  w całej długości: płatwie, belki zadaszenia, krokwie (od okapu do kalenicy), legary (najdłuższe przęsło); podpowiedź
  podciągu – tak samo.
- **Wycena materiału** (`rdzen/wycena.rb`): bale – objętość × „Cena bala”; belki – objętość według przekroju × cena wiersza
  magazynu o tym przekroju; deski poszycia i podbitki – objętość sztuk o długości handlowej (z zapasem) × cena wiersza
  „deska” tej grubości; reszta – cennik materiałów (wiersz, którego nazwa jest początkiem nazwy pozycji, ta sama jednostka).
  Fundamenty punktowe poza wyceną. Pozycja bez ceny – na liście, poza sumą. Okno: tabela w kroku „Zestawienie”, liczba
  „Materiał” w wyniku; CSV: blok „Wycena”. Bez robocizny i transportu.
- **Standard warsztatu z menu i z paska**: okno z samym panelem standardu (bez domu i bez podglądu).

## 8m. Runda 18 – ścieżka i prosty model stolarki, podparcie płatwi, płatwie dzielone, kanały na przewody

- **Model stolarki – ścieżka** (`rdzen/stolarka_modele.rb#plik`): kolumna „Model” listy stolarki = pełna ścieżka pliku
  `.skp` (działa bez folderu modeli) albo nazwa pliku w folderze `stolarka_folder`; puste – `<symbol>.skp`. Przy kolumnie
  i przy polu folderu przycisk „…” (`UI.openpanel` / `UI.select_directory`). Wymóg użytkownika (2026-11-27): „ścieżka
  dostępu da mi możliwość podmiany modeli”.
- **Prosty model** (`rdzen/stolarka_prosta.rb`, `stolarka_prosta` = tak): otwór bez pliku (bez typu, bez folderu, plik
  nie istnieje) dostaje komponent z części: rama `stolarka_rama` (68) na grubość ściany (okno – 4 boki, drzwi – bez progu),
  szyba 4 mm w środku grubości (materiał przezroczysty) albo skrzydło drzwi 40 mm z luzem 3, maskownice
  `maskownica_szerokosc` × `maskownica_grubosc` (95 × 20) na licu zewnętrznym, zachodzące na ramę o `maskownica_zakladka`
  (15) – okno z 4 stron, drzwi z 3. Układ jak model użytkownika (punkt 0 – dolny lewy narożnik stolarki od zewnątrz).
  Rola „skip” dla Dokumentacji 2D; test działania liczy modele stolarki osobno (nie drewno z listy).
- **Przełącznik doboru w typie** (`przekroje_dobor`, poziom :typ): Typ 100, 200 – podaję sam; Typ 300, 400 – automatycznie
  (odpowiedź użytkownika: „oba wybory, zależy jakie konstrukcje”).
- **Dom L – koniec płatwi skrzydła** (`rdzen/podpory_platwi_l.rb`, P2): koniec przy licu płatwi dachu głównego (zachodzą
  wysokością) – styk, w zestawieniu „Wieszak płatwi”; koniec w koszu (wierzch płatwi dochodzi do połaci dachu głównego,
  płatwi głównej na tej wysokości brak) – słupek (S, „Słupek pod płatwią”, tag Dach) na wierzchu płatwi dachu głównego,
  nad którą płatew skrzydła przechodzi najbliżej końca, do spodu płatwi skrzydła; przekrój = szerokość płatwi skrzydła ×
  szerokość płatwi głównej; odstęp < 20 mm – płatew leży na płatwi głównej. Słupki i oparcia – po 2 kątowniki ciesielskie.
  Statyka: przęsło płatwi skrzydła do słupka (wspornik do końca). `platwie_kosz` = nie – bez słupków, ostrzeżenie.
  **Sprawdzenie z wytycznymi (runda 19, odpowiedź „sprawdź w wytycznych / normach”)**: oparcie płatwi dobudówki na
  płatwi pośredniej dachu głównego krótkimi słupkami to zwykłe rozwiązanie ciesielskie (np. lukarny – Dietrich's,
  „Lukarny” LDS extra: płatwie i belka kalenicowa lukarny oparte na płatwi pośredniej za pomocą krótkich słupków; krokwie
  koszowe dużej lukarny – na płatwi). Słupek zostaje. PN-EN 1995-1-1 wymaga przy nim dwóch sprawdzeń, dodanych
  w `rdzen/statyka_kosza.rb`: (1) płatew dachu głównego niesie siłę skupioną od słupka – reakcja płatwi skrzydła
  R = q (L + a)² / 2L (przęsło L do sąsiedniej podpory, wspornik a do końca w koszu), doliczona jako 2R / L w środku
  największego przęsła płatwi głównej (statyka i dobór automatyczny); (2) docisk w poprzek włókien pod słupkiem i nad nim
  (p. 6.1.5): σc,90,d = Fd / Aef ≤ kc,90 · fc,90,d, długość docisku + 30 mm z obu stron, kc,90 = 1,0, fc,90,k z PN-EN 338
  (C24 – 2,5 MPa). Podpowiedź w sekcji „Szczyty i dach” (siła i docisk), docisk > 100 % – uwaga (blacha rozkładająca albo
  szersza płatew). Przedłużenie płatwi skrzydła do płatwi głównej ze ściętym końcem – nie (koniec wchodziłby w połać
  dachu głównego i i tak potrzebowałby oparcia na płatwi głównej).
- **Taras typu 300 – front ze szczytem** (`taras_sciany_front` = szczyt, fabrycznie; P2): front tarasu jak w typie 200 –
  górne `taras_wience_gorne` wieńce nad otworem (od półbala, w zamkach ścian bocznych) i szczyt pełny / ażurowy / pusty
  z trójkątem na balach; płatwie nad tarasem w zamku tylko od spodu; bale frontu na styk z mijanką w punktach równego
  podziału (bez słupów). „otwarty” – front bez bali jak do kompilacji 17.
- **Płatwie dzielone nad ścianą** (`rdzen/podzial_belek.rb`, `belki_podzial` = podpora; P3): płatew dachu dłuższa niż
  najdłuższa belka jej przekroju w magazynie drewna – styk w osi ściany, przez którą przechodzi (szczyt, działowa, węgieł,
  wiązar), wybieranej zachłannie (najdalsza w zasięgu, ≥ 300 od końców); kawałki z wrębami, osobne pozycje; bez ściany
  w zasięgu – w całości z podpowiedzią o łączeniu.
- **Drobne poprawki geometrii** (P5): ścięcie dachu płytsze niż 0,2 mm na niższym licu pogłębiane do 0,2 mm (bal nigdy
  nad połacią); działowe narysowane bliżej niż grubość bala i zachodzące na siebie – jedna ściana w miejscu dłuższej
  (`rdzen/dzialowe_bliskie.rb`, ostrzeżenie); ściana w poprzek płatwi, której koniec wchodzi tylko pod bok płatwi (poza
  wrębem) – gniazdo na pełnej szerokości płatwi od jej spodu; połacie domu L dla aplikacji wyżej o deskę podbitki na
  płatwiach (jak w domu prostokątnym).
- **Kanały na przewody** (`rdzen/kanaly.rb`, N3): wejście domu `kanaly` (ściana, od – oś od punktu odniesienia ściany,
  średnica – puste: `kanal_srednica` 25, puszka – środek od spodu ściany, puste: bez); kliknięcie w widok ściany w trybie
  „kanał” (okienko, poprawa, usunięcie), lista pod tabelą okien. Każdy bal ściany w miejscu kanału – obróbka `kanal`:
  otwór pionowy kwadratowy (bok = średnica, najwyżej grubość − 1,4) w osi grubości, na całą wysokość bala (także bale
  szczytu, pełny profil); bal ze środkiem puszki – obróbka `puszka` (otwór Ø `kanal_puszka_srednica` 68 od strony +nor,
  tylko na liście obróbek). Kanał bliżej niż `kanal_odstep_zamka` (60) od lica ściany poprzecznej albo poza ścianą –
  pominięty z ostrzeżeniem. Bal z otworem albo z puszką – osobna pozycja.

## 8n. Runda 19 – kosz domu L według normy, drewutnia (dodatki), P5 reszta, kanały

- **Kosz domu L** – patrz „Dom L – koniec płatwi skrzydła” w 8m (sprawdzenie z wytycznymi, `rdzen/statyka_kosza.rb`).
- **Typ + dodatki** (odpowiedź „tak”): typ = bryła domu (100–400), dodatki osobnymi przełącznikami w kroku „Dodatki”
  (dawniej „Taras i zadaszenie”). Przełączniki `zadaszenie` i `drewutnia` są polami „Ten dom”; `taras` zostaje w typie
  (Typ 200 i 300).
- **Drewutnia przy ścianie szczytowej** (`rdzen/drewutnia.rb`, `drewutnia` = slupy): wiata z dachem jednospadowym od
  ściany szczytowej, strona `drewutnia_strona` (z tyłu = naprzeciw tarasu; bez tarasu – szczyt o mniejszym u, bo taras
  stoi fabrycznie po stronie większego). Szerokość wzdłuż ściany: między ostatkami ścian okapowych z odstępem
  `drewutnia_odstep` (30) albo `drewutnia_szerokosc` na środku. W przekroju (s – odległość od lica ściany szczytowej):
  krokwie od s_k = wystawanie węgłów i działowych przed lico w pasie drewutni + odstęp do okapu s_e = głębokość +
  `drewutnia_okap`; rząd słupów przy ścianie w s_a – za krokwiami (pół szerszego z słupa i belki) i za podwalinami
  i fundamentami domu (z miejscem na fundament słupa) + odstęp; rząd zewnętrzny – lico zewnętrzne słupów na głębokości.
  Słupy (`drewutnia_slup_przekroj`, wzdłuż ściany × w poprzek) na końcach i równo co najwyżej `drewutnia_slupy_rozstaw`,
  od podstawy (spód podwaliny przy podłodze, inaczej 0) do spodu płatwi / oczepu (`drewutnia_belka_przekroj`); wierzch
  belki = spód krokwi przy jej krawędzi zewnętrznej. Krokwie – przekrój i rozstaw krokwi dachu, czoła prostopadłe do
  osi. Wierzch krokwi przy ścianie (`drewutnia_wysokosc`, 0 – najwyżej): najniżej z linii podparcia dachu domu przy
  brzegach pasa i punktów krawędzi belek dachu nad drewutnią, każdy minus osiadanie ścian pod nim (`osiadanie_scian`)
  i `drewutnia_odstep_dachu` (50) – dach domu siada razem ze ścianami, drewutnia nie; wyższa wartość z parametru –
  obniżona z uwagą. Za płytka (odstęp rzędów < 400) albo słupy < 300 – pominięta z uwagą. Fundamenty jak pod podłogą.
  Statyka (`rdzen/statyka_drewutni.rb`): krokiew na dwóch podporach (wsporniki jak przęsło 2a), płatew i oczep na
  rozstawie słupów z pasem dachu (połowa odstępu rzędów + wspornik krokwi), słup – ściskanie z wyboczeniem; śnieg
  μ(kąt drewutni) i ciężar pokrycia jak dach; podpowiedź z najmniejszym wystarczającym przekrojem z magazynu.
  Tag i grupa „Drewutnia”; płatew i oczep drewutni nie są podporami połaci domu dla aplikacji do dachów.
- **P5 – reszta**: skos bala (szczyt) przechodzący mniej niż 0,2 mm nad dolnym narożem gniazda od spodu – obniżony do
  naroża (szpic klina przed gniazdem znika); gniazdo / wycięcie od góry i gniazdo od dołu w tym samym miejscu zostawiające
  0–0,2 mm drewna – wycięcie od góry płytsze, tak by zostało 0,2 mm.
- **Kanały**: strona puszki (`strona` w wejściu kanału: lewa – +nor, wnętrze ściany zewnętrznej; prawa – −nor); kanał
  w miejscu okna albo drzwi – obróbka `kanal` tylko w balach poniżej spodu otworu, puszka w otworze pominięta (uwaga),
  w widoku ściany pas do spodu otworu.

## 8a. Taras (`rdzen/taras.rb`, `rdzen/taras_balustrada.rb`, runda 5)

- Rysujesz sam dom; taras (`taras`) dokłada generator przed ścianą szczytową po stronie `taras_strona` (wzdłuż kalenicy):
  obrys dłuższy o `taras_glebokosc` (od lica ściany domu do lica frontu), oś kalenicy jak dla domu bez tarasu, dawna
  ściana szczytowa zostaje jako działowa ze szczytem (ostatki na zewnątrz), dach, płatwie i połacie idą nad taras.
  Tylko obrys prostokątny.
- **Jak 1100** (`podciag`): nad tarasem tylko górne `taras_wience_gorne` (2) wieńce ścian bocznych (podciąg z bali
  do frontu, z ostatkiem) i front od wieńca, który zamyka się z nimi w narożniku, ze szczytem; dolne bale ścian
  bocznych kończą się `taras_ostatek` (100) za licem ściany domu. Słupy (`taras_slup_przekroj` 120 × 120, prefiks S,
  grupa i tag „Taras”) od poziomu 0 do spodu podciągu: w narożnikach frontu, przy wejściu (`taras_wejscie` pośrodku /
  z lewej / z prawej patrząc na front z zewnątrz / brak, `taras_wejscie_szerokosc` 1200 w świetle) i pośrednie co
  ≤ `taras_slupy_rozstaw_max` (2000) pod frontem i pod ścianami bocznymi. **Balustrada** z bali w przęsłach między
  słupami i ścianą domu, w wieńcach ściany: `taras_balustrada_bale` (4) pełnych bali na przemian z rzędami przekładek
  `taras_przekladka` (300) przy końcach przęsła i równo między nimi (prześwit ≤ `taras_przekladka_odstep` 600);
  najniższy wieniec zawsze bal (ściana z półbalem: półbal i bal – jak 1100 W-1); bale bez zamków. Tylko dach
  dwuspadowy.
- **Jak 1200** (`sciany`): ściany boczne przedłużone na całą wysokość do frontu; od rundy 18 front ze szczytem (§8m), przy
  `taras_sciany_front` = otwarty – front otwarty (bez bali – zostaje
  w planie dla dachu i płatwi), bez słupów i balustrady; działa też z dachem jednospadowym.

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

## 9a. Podłoga i fundamenty (runda 7)

- Podwalina z wyboru (`podwalina_przekroj`, np. 50 × 150 na kant), w narożnikach na zakład albo na śruby bez zamków
  (`podwalina_laczenie`).
- Podciągi (`podciagi` auto / tak / nie) od lica do lica zewnętrznego podwalin, **pod podwalinami** (wymóg użytkownika).
- Fundamenty punktowe (`fundamenty`): siatka rzędów co ≤ `fundamenty_rozstaw_max` (2500) w obu kierunkach, skrajne
  licem z licem obrysu (nie wychodzą poza dom), stopy pod podwalinami, podciągami i podwalinami działowych; wierzch
  stopy = spód tego, co na niej leży. Legar za słaby na rozstaw – dodatkowy rząd z podpowiedzią.

## 10. Okno, ustawienia, typy domów

- Formularz budowany z `rdzen/parametry_lista.rb` (SEKCJE, LISTA): pod polem podpowiedź (skąd wartość). Nowy parametr
  = jeden wpis w LISTA z cechą `poziom:` – pole pojawia się samo w swojej sekcji, kroku i na swoim poziomie.
- **Plik ustawień** (Windows: `%APPDATA%\ArteMadera\GeneratorWiencowy\ustawienia.json`, wersja 5,
  `sketchup/ustawienia.rb`): `standard` (tylko pola inne niż fabryczne), `typy` (własne), `typ` (ostatnio wybrany),
  `okno` (układ, tryb pól). Starszy plik jest przenoszony raz: ostatnie parametry → pola standardu do standardu, reszta
  do typu „Ostatnie ustawienia (do kompilacji 15)”, szablony → typy; kopia w `ustawienia_przed_r16.json`.
  Podgląd i generowanie niczego nie zapisują w ustawieniach.
- **Typy domów** (`sketchup/typy_domow.rb`, `html/typy.js`): wbudowane Typ 100–400 i własne. Typ = nazwa, zdanie opisu
  i wartości pól poziomu „typ” oraz startowe pól „dom”, różne od standardu. Nowy dom startuje z ostatnio wybranego
  typu. „Zapisz jako typ…”, „Zapisz zmiany w typie” (własny), „Powiel…”, „Usuń” (własny, dwa kliknięcia),
  „Przywróć z typu”. Wymiary zamka należą do standardu.
- **Standard warsztatu** (`html/standard.js`, przycisk w nagłówku): pola poziomu „standard” z wyszukiwarką, wymiary
  zamka; „Zapisz standard”, „Przywróć fabryczne”. Po zapisie pola domu równe dotychczasowemu standardowi dostają nową
  wartość, zmienione tylko w tym domu – zostają.
- **Zmienione tylko w tym domu**: pole typu albo standardu o wartości innej niż typ ze standardem – etykieta
  z dopiskiem, w dymku wartość bazowa, przycisk ↺; licznik pod typem. Pola standardu trafiają do kroku z listy „Zmień
  pole standardu tylko w tym domu…”.
- **Układ nowy – kroki** (`html/kroki.js`, `html/uklad.js`, `html/kroki.css`; fabrycznie): Ściany → Okna i drzwi →
  Dach → Taras i zadaszenie → Podłoga → Zestawienie, przy kroku znacznik (błąd / ostrzeżenie / w porządku / liczba pól
  zmienionych). W kroku: pola poziomu „dom”, pod przyciskiem pola typu, pola standardu tylko zmienione albo dopięte;
  karty kroku (widok ściany, tabela otworów, węgły, lista bali i materiały z powierzchniami w „Zestawieniu”). Po prawej
  stale rzut i „Wynik” z listą „Do poprawy / Sprawdzone” (`html/uwagi.js`) – kliknięcie przechodzi do kroku i pola.
  Podpowiedź pola pokazuje się po wejściu w pole.
- **Układ dotychczasowy – zakładki** (do porównania, przełącznik w nagłówku; wybór zapamiętany): sekcje rozwijane,
  „Pola: Podstawowe / Wszystkie” (`html/tryb.js`), wszystkie karty w prawej kolumnie. Do usunięcia po wyborze użytkownika.
- Przebudowa okna po zmianie pola czeka na puszczenie przycisku myszy (`AMGW_DOM.poKliknieciu`) – kliknięcie
  przycisku zaraz po wpisaniu wartości działa za pierwszym razem. Liczby w polach bez zaokrąglania (`fmtPola`).
- Rzut z numerami ścian i punktami odniesienia, tabela okien i drzwi (nowe okno / drzwi z wymiarów w ustawieniach),
  wynik: liczby (bale, węgły, szczyty, belki, powierzchnie, wysokość), ściany ze stykami, lista bali i belek.
- **Widok ściany** (`rdzen/widok.rb`, `html/sciana.js`): wybór z listy albo kliknięcie ściany na rzucie; widok od lica
  jak rozkład ściany producenta – bale z gniazdami zamków i skosem dachu, numery pozycji na balach, numery wieńców,
  styki (czerwone), skrzyżowania ze ścianami i węgłami (przerywane; węgieł ręczny – pogrubiony opis), otwory, linia
  dachu. Odświeża się po podglądzie. Pod widokiem panel ustawień ściany (§5b, `html/edycja.js`): ostatki końców,
  co nad działową i jej góra, stan węgłów („Przywróć automatyczne”); kliknięcie w rysunek dodaje / usuwa węgieł.
  Cała ściana w szerokości okna (długa i niska – przewijanie w poziomie); na rzucie opisy węgłów w środku domu.
- **Zestawienie CSV** (przycisk przy liście; `rdzen/zestawienie.rb`, `sketchup/eksport.rb`): grupa, pozycja, rodzaj,
  przekrój, długość, ilość, objętość; sumy grup i całości; materiały; powierzchnie; średnik i przecinek dziesiętny,
  BOM – otwiera się w Excelu.

## 10a. Test działania i raport (menu)

„Rozszerzenia → ArteMadera Generator Wieńcowy → Test działania i raport do wysłania…” (`sketchup/raport.rb`):
- buduje 9 przykładowych domów (`rdzen/przyklady.rb`: 4 × 4 bez łączeń, jak 900 z oknem i drzwiami, 7 × 4,5 z działową
  i węgłem, 10 × 8 z łączeniami i węgłami usztywniającymi, obrys L, krokwie z obu stron szczytu i podłoga 150, pełny
  profil z działową pod antresolą, ostatkiem 200 i węgłem ręcznym, dach jednospadowy ze szczytem na działowej, taras
  jak 1100 z drzwiami w ścianie domu) w jednej operacji, którą na końcu cofa – model zostaje bez zmian;
- dla każdego domu: liczby z planu i z modelu (instancje według prefiksu), bryły niezamknięte (`manifold?`), bryły
  o objętości innej niż z profilu (> 0,2 %), ściany, których nie narysowano, kontrola zamków i styków, czasy;
- zaznaczony dom: kompilacja, ręczne zmiany, zgodność modelu z parametrami;
- środowisko (SketchUp, Ruby, jednostki modelu, plik ustawień) i dziennik (błędy, ostrzeżenia, czasy);
- zapis do pliku JSON w folderze raportów – sam, bez okna zapisu (od rundy 14, §8i) – i okienko z wynikiem jednym zdaniem;
  w raporcie także ostatnie wpisy dziennika pracy i kontrola ścian równoległych.

## 11. Etapy dalej

Po rundzie 6: odbiór kompilacji 6 w SketchUpie (z aplikacją do dachów 3.7.0); Dokumentacja 2D – konstrukcja
wieńcowa (zadanie `docs/zadanie_dokumentacja2d.md` – w tamtej wtyczce); aplikacja do dachów – osie krokwi przy
szczycie z wywołania, podpora dokładnie na kalenicy w obu połaciach, dach jednospadowy (ściana wysoka jako podpora
u góry, okap za nią jako wspornik) – zadanie `docs/zadanie_aplikacja_dachow.md` (część 2); taras – szczegóły
z odbioru (słupy, wejście, schody, deski tarasu). Propozycje 5 (szybsza budowa) i 10 (pliki dla producenta) – odpadły /
później.
