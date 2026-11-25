# Zadanie rund 15–18 – rozstrzygnięcia użytkownika z 2026-11-25

Analiza i pomiary, do których odnoszą się punkty: `claude/propozycje_r14.md` (w Projekcie) i `docs/propozycje_r15.md`.
Odpowiedź użytkownika z 2026-11-25 19:00 (dosłownie): „przełączyć trzeba na prywatne. Podział na typ domu, które będę sobie
w wolnych chwilach ustawiał i predefiniował. Odbiór bez 59 kroków – nie rozumiem, zrób tak by było dobrze. Twoje propozycje,
nr 2 są spoko, to można wdrożyć. 3. także fajny pomysł, dodajmy + ewentualnie przy kliknięciu by się wyświetlało okienko
z parametrami. 4. tak, odpowiada mi to. Wprowadź te zaległe zmiany.”

Runda 14 wykonała zaległości z 14 listopada, prosty odbiór i pasek narzędzi (`docs/przekazanie_r14.md`). Poniżej – to, co
zapadło i czeka. Gotowe polecenie do wklejenia w nowym oknie: `docs/prompt_r15.md`.

## 0. Decyzje z 2026-11-25 20:26 i zakres rundy 15

Odpowiedź użytkownika (dosłownie): „1. można na styk z przesunieciem o 300mm 2. podbitka a w zasadzie zazwyczaj nadbitka
(deska pióro-wpust) o grubości 14 mm, szerokość krycia 115mm, długość zazwyczaj 4m 3. tak 4. Zaproponuj od siebie
dodatkowe usprawnienia, oraz zmiany/poprawki które zwiększą możliwości generowania takich konstrukcji 5. Jak skończysz,
napisz listę "todo" co zostało do zrobienia w kolejnej rundzie, tak by wkleić prompt do nowego okna”.

Zasada „zaległości przed nowymi funkcjami” (`docs/stan_prac.md` §4): runda 15 robi najpierw to, co już zapadło. Typy
domów i okno (§1–2) przechodzą na rundę 16; w rundzie 15 powstaje do nich tabela podziału pól i szkic okna do akceptacji.
W kodzie po odpowiedzi z 20:26 nic się nie zmieniło – kompilacja 14 jest bez tych punktów.

### 0.1 T8 – wieńce w szczytach ścian domu na styk z przesunięciem 300 mm

- **Decyzja:** „można na styk z przesunięciem o 300 mm” (pytanie T8, `docs/pytania_otwarte.md`).
- Dziś ściana ze szczytem łączy się tylko w zamkach węgłów (`rdzen/styki.rb`, okolice w. 82–85: w ścianie ze szczytem
  kotwice tylko z kontrfor). Najwyższy styk bywa bez zamka, bo górny bal węgła wypadłby nad dachem (8–14 % domów,
  `claude/zadanie_r11.md` §2, ziarno 6502).
- Do zrobienia: w wieńcach szczytu (nad wysokością ścian okapowych) bale dłuższe niż `max_dlugosc` łączone na styk, bez
  węgła i bez zamka, sąsiednie wieńce przesunięte co najmniej o `mijanka` (nie mniej niż 300), na przemian – wzór jak
  front tarasu (`rdzen/styki_tarasu.rb`, `taras_styk` = styk). Wieńce poniżej (sama ściana) – bez zmian. Węgły pod styki
  tylko do wysokości ściany; węgły usztywniające i pod płatwiami bez zmian.
- Styk nie bliżej otworu w szczycie niż `styk_odstep_od_otworu`, nie w gnieździe płatwi, kawałki nie krótsze niż
  `min_odcinek`; kontrola mijanki obejmuje wieńce szczytu; `Kontrola.styki_bez_zamka` nie liczy styku na styk w szczycie
  (jak dla frontu tarasu).
- Parametr (co tylko można – parametr): łączenie wieńców szczytu = na styk (domyślnie) / w zamkach węgłów (jak do
  kompilacji 14).
- Sprawdzenie: ziarno 6502 i domy z `testy/losowe_domy.rb` – zero styków bez zamka w ścianach ze szczytem, mniej węgłów
  w szczytach; regresja w `testy/t_losowe.rb`.

### 0.2 Pół zamka – tylko tam, gdzie zostanie potrzebne

- **Decyzja z 2026-11-14** (`claude/zadanie_r11.md` §2): zamek cięty na połowie wysokości bala (ok. 70 mm przy wieńcu 139),
  „by ściany były zawsze domykane”. Przy szczytach na styk (0.1) pół zamka potrzebne tylko w narożnikach.
- Przed kodem: po 0.1 zmierzyć na losowych domach, gdzie zostają zamki niedomknięte pod połacią (narożniki ściany ze
  szczytem – `rdzen/skos_przy_narozniku.rb`, węgły pod płatwiami, dopełnienie zamka działowej pod połacią), pokazać
  użytkownikowi rysunek pół zamka w tych miejscach, potem wdrożyć. Parametr wysokości pół zamka (domyślnie połowa wieńca).
- Pliki: `rdzen/zamek.rb`, `rdzen/skos_przy_narozniku.rb`, `rdzen/wegly_konstrukcyjne.rb`, `rdzen/dopelnienie.rb`.

### 0.3 Deski nadbitki i podbitki: 14 × 115 (krycie) × 4000

- **Decyzja:** „podbitka a w zasadzie zazwyczaj nadbitka (deska pióro-wpust) o grubości 14 mm, szerokość krycia 115 mm,
  długość zazwyczaj 4 m”.
- Wartości fabryczne (`rdzen/parametry_dach.rb`): `podbitka_grubosc` i `nadbitka_grubosc` 19 → 14, `podbitka_krycie`
  i `nadbitka_krycie` 121 → 115; długości 4000 bez zmian. Plik ustawień w wersji 4: te klucze w `DO_FABRYCZNYCH`
  (zapamiętane 19 / 121 wracają do nowych wartości, także we własnych szablonach).
- Zapytać na starcie rundy (jedno pytanie): czy nadbitka ma być fabrycznie włączona (`poszycie_nadbitka` = tak), a deskowanie
  pełne (`poszycie_deski`, dziś tak) wyłączone?
- Deska 14 × 115 × 4 m – pozycja magazynu drewna w rundzie 17 (§4).

### 0.4 45 × 120: 5,4 / 6 m

- **Decyzja:** „tak” – w `rdzen/wykaz_drewna.rb` `45x120:5.4/5` → `45x120:5.4/6`; plik ustawień w wersji 4:
  `przekroje_katalog` w `DO_FABRYCZNYCH` i `DO_FABRYCZNYCH_W_SZABLONACH` (razem z deskami z §0.3).

### 0.5 Z propozycji `docs/propozycje_r15.md`

Domyślnie (jeśli użytkownik nie zmieni w poleceniu): **P1** – słupy krótsze o osiadanie ścian, z regulacją; **W2** – pełne
zestawienie materiałów (deski nadbitki 14 × 115 × 4000 w m² i sztukach, taśma między wieńcami, okucia, powierzchnia do
impregnatu). Pozostałe – w kolejce `docs/stan_prac.md` §5 jako propozycje do decyzji.

### 0.6 Przygotowanie rundy 16

Tabela podziału 185 pól na Standard warsztatu / Typ domu / Ten dom (projekt cechy `poziom:`) i szkic okna (kroki w kolejności
budowy, wynik przyklejony z prawej) – pokazać użytkownikowi, akceptację zapisać w §1–2. Kod okna dopiero w rundzie 16.

### 0.7 Wykonanie w rundzie 15 (2026-11-25, kompilacja 15)

- 0.1 **zrobione**: `rdzen/styki_szczytu.rb`, parametr `szczyt_styk`; szczyt płaski (ściana wysoka dachu jednospadowego –
  także ziarno 6502) zostaje przy węgłach – tam styk nad końcem węgła nadal daje ostrzeżenie (węgieł kończy się pod
  podbitką, pół zamka się nie mieści: zostaje < 20 mm).
- 0.2 pomiar i rysunki **pokazane** (`docs/pol_zamka_r15.png`, prościej `docs/ostatnie_polaczenie_r15.png`); użytkownik
  22:23: „Nie rozumiem twoich koncepcji z tym balem. Do dziś robiliśmy tak, że tam był zamek, ale jeżeli zachodzi taka
  potrzeba, to by można było to zaprojektować inaczej, tak by ten kawałek z jednej czy drugiej strony nie odpadał, tylko
  dlatego że zostało za mało materiału po wyfrezowaniu zamka – mowa tutaj tylko o tym jednym ostatnim niefortunnym
  połączeniu”. Kod narożnika gotowy (`rdzen/pol_zamka.rb`), **wyłączony fabrycznie do akceptacji** wymiarów (bal górny bez
  gniazda, w balu dolnym 72). Po akceptacji: `polzamek` = tak fabrycznie i ta sama zasada na górze węgła.
- 0.3 **zrobione**, nadbitka fabrycznie włączona i deskowanie pełne wyłączone (odpowiedź „1. tak” z 21:42 – do
  potwierdzenia, czy dotyczyła tego pytania). 0.4 **zrobione**. 0.5 **zrobione** (P1 – `rdzen/osiadanie.rb`, W2 –
  `rdzen/materialy.rb`).
- 0.6 **pokazane**: `docs/podzial_pol_r16.md`, `docs/szkic_okna_r16.png` – **akceptacja użytkownika: czeka** (wpisać tutaj
  i w §1–2 po odpowiedzi).
- Odpowiedzi z 21:42 na pytania z `docs/propozycje_r15.md` §6: „1. tak” (kolejność propozycji), „2. Okna drewniane, mają
  maskownice na stałe do ramy, które przykręcam od zewnątrz do ściany” (N2 – bez wpustu / czopa w czołach bali; zostaje
  samo przyciąganie otworu do krawędzi wieńca), „3. nie w tych konstrukcjach” (N6 odpada).

## 1. Typy domów ustawiane przez użytkownika (runda 16)

**Propozycja podziału z rundy 15 (akceptacja: czeka):** `docs/podzial_pol_r16.md` – Ten dom 16 pól, Typ domu 49, Standard
warsztatu 129; typ zapamiętuje pola „Typ domu” i wartości startowe pól „Ten dom”.

**Decyzja:** podział ustawień przyjęty; typy domów użytkownik chce **sam ustawiać i predefiniować w wolnych chwilach**.

Co z tego wynika:

- Trzy poziomy: **Standard warsztatu** (bal, zamek, mijanka, zasady węgłów, luzy, zamki płatwi, obciążenia, wymiary
  detali, magazyn drewna – ustawiany rzadko, osobne okno), **Typ domu** (Typ 100–400 i własne), **Ten dom** (wieńce,
  kalenica, dach i kąt, okapy, taras, zadaszenie, podłoga, poszycie, strop).
- Zapisywanie typu ma być wygodne, bo użytkownik będzie to robił często: „Zapisz jako typ” z nazwą i jednym zdaniem
  opisu, „Zapisz zmiany w typie”, powielenie typu, usunięcie; typy wbudowane jako punkt wyjścia (nie do usunięcia,
  do powielenia). Typ pamięta tylko pola poziomu „Typ domu” i „Ten dom” – standard warsztatu jest wspólny dla wszystkich.
- Nowy dom zawsze zaczyna od wybranego typu i standardu – nie od ostatniego podglądu (dziś każdy podgląd zapisuje
  parametry jako „ostatnie”: `sketchup/sterowanie.rb#podglad`). Wybór typu: karty z nazwą i opisem na starcie okna.
- Pole standardu można nadpisać dla jednego domu („zmień tylko w tym domu”) – pokazuje się wtedy w głównym oknie.
- Tryb „Podstawowe / Wszystkie” znika (58 „podstawowych” pól przestało być skrótem).
- Kod: cecha `poziom:` (`:standard` | `:typ` | `:dom`) przy każdym wpisie listy parametrów – podział do zaproponowania
  użytkownikowi w tabeli przed wdrożeniem; `sketchup/ustawienia.rb` – części `standard` i `typy` (własne szablony z plików
  starszej wersji stają się typami); `sketchup/sterowanie.rb#start`; okno.
- Do pomocy: `raporty\dziennik_pracy.jsonl` (pole `zmienione`) pokaże, których pól użytkownik faktycznie dotyka.

## 2. Okno: wynik zawsze na widoku (runda 16)

**Szkic z rundy 15 (akceptacja: czeka):** `docs/szkic_okna_r16.png` (źródło `docs/szkic_okna_r16.html`, 1060 × 860) – typ
domu w górnym pasku, sześć kroków ze znacznikiem stanu, po lewej pola „Ten dom” i zwinięta grupa „Z typu domu” („zmień
tylko w tym domu”), po prawej stale rzut, liczby i lista „Do poprawy / Sprawdzone”.

**Decyzja:** „nr 2 są spoko, to można wdrożyć”.

- Prawa kolumna przyklejona: rzut i lista „Do poprawy” / „Sprawdzone”; kliknięcie uwagi przenosi do pola.
- Lewa kolumna krokami w kolejności budowy: Ściany → Okna i drzwi → Dach → Taras i zadaszenie → Podłoga → Zestawienie.
- Podpowiedź po wejściu w pole (albo pod pytajnikiem), nie stale pod każdym polem.
- Lista bali i tabela ścian – w kroku „Zestawienie”.
- Opcje niedostępne dla obrysu wyszarzone z powodem (rodzaj obrysu podany polom zależnym – `html/zalezne.js`).
- Pomiary wyjściowe (kompilacja 13, okno 1060 × 860): 5 239 px przewijania w trybie „Podstawowe”, karta „Wynik” 1 478 px
  od góry. Cel: bieżący krok i lista uwag bez przewijania.
- Pliki: `html/okno.html`, `html/okno.css`, `html/okno.js`, `html/wyniki.js`, `html/zakladki.js`, `html/tryb.js`
  (do usunięcia), `testy/t_okno.js`.

## 3. Okna, drzwi i węgły kliknięciem – z okienkiem parametrów (runda 17)

**Decyzja:** „także fajny pomysł, dodajmy + ewentualnie przy kliknięciu by się wyświetlało okienko z parametrami”.

- Widok ściany: przełącznik „klik dodaje: węgieł / okno / drzwi” (kliknięcie z pozycją na ścianie już jest –
  `html/sciana.js#klikanie`, dziś tylko węgły).
- **Po kliknięciu małe okienko przy miejscu kliknięcia** z parametrami wstawianego elementu: typ stolarki z listy,
  szerokość, wysokość, spód okna, luz górny, nazwa; „Wstaw” / „Anuluj”. Kliknięcie w istniejący otwór albo węgieł otwiera
  to samo okienko do poprawki („Zapisz” / „Usuń”); dla węgła – położenie i wypusty.
- Przeciąganie otworu po ścianie; tabela zostaje jako podgląd i miejsce na dokładne liczby.
- Lista typowej stolarki (np. O1 1020 × 1010, D1 930 × 2100) w standardzie warsztatu – zamiast sześciu pól „Nowe okno /
  nowe drzwi”.

## 4. Jeden magazyn drewna i jeden przełącznik doboru (runda 17)

**Decyzja:** „tak, odpowiada mi to”.

- Podstawa z rundy 14: `rdzen/wykaz_drewna.rb` (wykaz z długościami, odczyt zapisu „45x145:4.2/5.4/6”),
  `rdzen/dlugosci_handlowe.rb` (podpowiedzi, dobór w całej długości).
- Do zrobienia: jedna tabela w standardzie warsztatu (przekrój, długości, rodzaj C24 / Nsi / DUO / BSH, do czego: legar,
  płatew, krokiew, słup, deska) zamiast pięciu pól tekstowych; pola przekrojów w oknie jako listy z magazynu (koniec
  z przekrojami spoza hurtowni: krokiew 50 × 150, legar 50 × 100, podciąg 100 × 150).
- Deski podbitki, nadbitki i deskowania z magazynu – deska użytkownika: 14 × 115 (krycie) × 4000 (§0.3).
- Jeden przełącznik „Przekroje konstrukcji – dobieraj automatycznie / podaję sam” z wyjątkiem dla pojedynczego elementu
  (dziś: legary i zadaszenie automatycznie, płatwie i krokwie ręcznie, trójkąt „jak płatwie”).
- Dobór w całej długości także dla legarów, podciągów i krokwi.

## 5. Odbiór (wykonane w rundzie 14)

**Decyzja:** „nie rozumiem, zrób tak by było dobrze”. Zrobione: raport z testu działania zapisuje się sam, dziennik pracy,
scenariusz w trzech krokach (`docs/scenariusz_odbioru.md`). Dalej: na starcie każdej rundy czytać `raporty\`.

## 6. Zaległe z 2026-11-14, nadal otwarte

- **Pół zamka w wieńcu szczytowym** – odblokowane decyzją T8, runda 15 (§0.2).
- **Dom T, U, krzyż** – kalenica z dachu o większej powierzchni, `rdzen/skrzydla.rb` na dowolną liczbę skrzydeł; razem
  ze wzorem dobudówki (`docs/propozycje_r15.md` N4).
- **Deski z wykazu** – rozstrzygnięte 2026-11-25 (§0.3).

## 7. Podgląd na żywo w modelu (po pomiarze)

Z `propozycje_r14.md` §4G – użytkownik się nie wypowiedział. Decyzja po odczytaniu `ms_budowy` z dziennika pracy:
do 2–3 s – opcja „odświeżaj dom w modelu po zmianie pola”; dłużej – najpierw przyspieszenie budowy (te same definicje
bali używane ponownie, szybsze tworzenie brył).
