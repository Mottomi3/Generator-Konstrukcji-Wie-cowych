# Zadanie po rundzie 16 – odpowiedzi użytkownika i zakres rundy 17

## 0. Odpowiedzi użytkownika z rundy 16 (2026-11-25 23:27 i 2026-11-26 02:40) – dosłownie

1. **Pół zamka** (bal górny bez wycięcia, w balu pod nim 72 mm zamiast 36): „myślę że to dobry pomysł, z tymże trzeba
   wziąć pod uwagę, że trzeba i tak podfrezować gniazda na bokach górnego elementu, by wszedł w ten poniżej, gdyż szerokość
   gniazda jest mniejsza o zamki.” → wykonane: fabrycznie włączone, bal górny z podcięciami bocznymi (2 × 2,5 mm, szyjka 39
   w gnieździe 40) – `docs/ostatnie_polaczenie_r16.png`.
2. **Podział pól** (Ten dom / Typ domu / Standard warsztatu): „Możemy spróbować, wygląda dobrze, chcę mieć możliwość
   porównania obu, a w późniejszym czasie zostaniemy przy jednym.” → wykonane: trzy poziomy + przełącznik układu okna
   (nowy / dotychczasowy). **Czeka na wybór.**
3. **Szkic okna**: „nie dostałem szkicu okna, zostaw otwór, w wolnym czasie zrobię modele typowych okien i drzwi, wtedy damy
   funkcje by je od razu wstawiać do modeli.” → pytanie dotyczyło okna wtyczki; szkic wysłany ponownie 2026-11-25 23:40,
   bez odpowiedzi – nowy układ zrobiony według szkicu obok dotychczasowego. Odpowiedź o stolarce → §2.
4. **Nadbitka fabrycznie**: „nadbitka zostaje, tyle że w opcjach trzeba wyboru, czy ma być na płatwiach, na krokwiach, pod
   krokwiami, pod płatwiami, czy w ogóle bez nadbitki/podbitki.” → wykonane: jedno pole położenia desek.
5. **Styk nad końcem węgła** (podpowiedź zamiast ostrzeżenia?): „nie rozumiem, jeżeli chodzi o łączenie podbitki na długość,
   to nie potrzeba ostrzeżenia”; po rysunku `docs/styk_nad_weglem_r16.png`: „jak dotąd były tam zamki, i chciałbym tego nie
   zmieniać, gdyż bez zamka będzie to uciekać przy montażu, oraz będzie mieć tendencję do skręcania się.” → **styk bali
   zawsze w zamku**; wykonane dla węgłów (dochodzą do połaci), zostały dwa miejsca – §4.

## 1. Układ okna – po wyborze użytkownika (runda 17)

- Zostaje jeden układ. Przy „nowy”: usunąć zakładki dotychczasowego układu z formularza (`html/tryb.js`, przełącznik pól,
  cecha `podstawowy:` w liście parametrów, `Ustawienia.tryb_pol`), `html/zakladki.js` zostawić tylko, jeśli zadaszenie ma
  mieć własny widok; `t_okno.js` przenieść na nowy układ.
- Do dopracowania w nowym układzie po uwagach z prawdziwego SketchUpa: szerokość kolumn, kolejność kart w krokach, czy
  „Widok ściany” ma być w obu krokach (Ściany, Okna i drzwi); ostrzeżenia o otworach → przejście do wiersza tabeli.
- Pozycja menu i przycisk paska „Standard warsztatu” (dziś tylko z okna generatora); karty typów z opisem na starcie
  nowego domu zamiast listy rozwijanej – jeśli użytkownik będzie miał więcej typów.
- Typy z projektów użytkownika 900, 1100, 1200, 1800 (S2) – po odpowiedzi na pytanie 4 z `docs/stan_prac.md` §6.

## 2. Okna, drzwi i węgły kliknięciem – z okienkiem parametrów; gotowe modele stolarki (runda 17)

**Decyzje:** 2026-11-25 „także fajny pomysł, dodajmy + ewentualnie przy kliknięciu by się wyświetlało okienko z parametrami”;
2026-11-25 23:27 „zostaw otwór, w wolnym czasie zrobię modele typowych okien i drzwi, wtedy damy funkcje by je od razu
wstawiać do modeli”.

- Widok ściany: przełącznik „klik dodaje: węgieł / okno / drzwi” (kliknięcie z pozycją na ścianie już jest –
  `html/sciana.js#klikanie`, dziś tylko węgły).
- Po kliknięciu małe okienko przy miejscu kliknięcia z parametrami wstawianego elementu: typ stolarki z listy, szerokość,
  wysokość, spód okna, luz górny, nazwa; „Wstaw” / „Anuluj”. Kliknięcie w istniejący otwór albo węgieł otwiera to samo
  okienko do poprawki („Zapisz” / „Usuń”).
- Lista typowej stolarki w standardzie warsztatu (np. O1 1020 × 1010, D1 930 × 2100) – zamiast sześciu pól „Nowe okno /
  nowe drzwi”; do pozycji listy można przypisać **model użytkownika** (komponent SketchUpa) wstawiany w otwór przy
  generowaniu. Format modeli – pytanie 5 w `docs/stan_prac.md` §6 (propozycja: pliki `.skp` w jednym folderze, punkt
  wstawienia w dolnym lewym narożniku stolarki od zewnątrz).
- Dom z wymiarów: działowe z tabeli okna („+ ściana działowa”: od, długość, kierunek), żeby nie trzeba było rysować.

## 3. Jeden magazyn drewna i jeden przełącznik doboru (runda 17)

**Decyzja:** „tak, odpowiada mi to”.

- Podstawa z rundy 14: `rdzen/wykaz_drewna.rb`, `rdzen/dlugosci_handlowe.rb`.
- Do zrobienia: jedna tabela w standardzie warsztatu (przekrój, długości, rodzaj C24 / Nsi / DUO / BSH, do czego: legar,
  płatew, krokiew, słup, deska) zamiast pięciu pól tekstowych; pola przekrojów w oknie jako listy z magazynu.
- Deska nadbitki / podbitki i deskowanie z magazynu – 14 × 115 (krycie) × 4000.
- Jeden przełącznik „Przekroje konstrukcji – dobieraj automatycznie / podaję sam” z wyjątkiem dla pojedynczego elementu.
- Dobór w całej długości także dla legarów, podciągów i krokwi. Wycena materiału (W3).

## 4. Styk bali zawsze w zamku – pozostałe miejsca (runda 17)

Na 600 losowych domach (6001–6600) styk bez zamka został w 8:

- **Działowa pod podbitką „pod płatwiami”** (6057, 6134, 6492, 6541): ściana działowa w poprzek kalenicy kończy się pod
  deskami, ściana okapowa idzie 1–2 wieńce wyżej; styk ściany okapowej na tej działowej w najwyższym wieńcu nie ma zamka.
  Propozycja do decyzji (rysunek `docs/styk_nad_dzialowa_r16.png`): działowa, na której wypada styk, dochodzi do połaci
  (jak węgieł) – deski podbitki przerwane na ścianie; albo styk najwyższych wieńców przenoszony na najbliższy węgieł.
- **Ściana szczytowa** (6093, 6280, 6324, 6392): styk w wieńcu przy wysokości ściany okapowej nad końcem węgła pod styki
  (węgieł „do wysokości ściany” z rundy 15 kończy się wieniec niżej). Do rozpoznania: ostatni bal węgła z pół zamkiem.

## 5. Zaległe, nadal otwarte

- **Dom T, U, krzyż** – kalenica z dachu o większej powierzchni, `rdzen/skrzydla.rb` na dowolną liczbę skrzydeł; razem
  ze wzorem dobudówki (`docs/propozycje_r15.md` N4).
- **„Buduj do wysokości”** (odłożone 2026-11-14) – po W1 jest wysokość nad terenem; do zrobienia: podana wysokość →
  kąt dachu albo liczba wieńców.
- **Podgląd na żywo w modelu** – po odczytaniu `ms_budowy` z dziennika pracy (dziennika jeszcze nie ma).
- Pytania Z9 (przybudówka), D1a (śnieg), H21 (CNC), okucia – `docs/stan_prac.md` §6.
