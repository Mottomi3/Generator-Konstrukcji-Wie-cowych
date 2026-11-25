# Zadanie rund 15–17 – rozstrzygnięcia użytkownika z 2026-11-25

Analiza i pomiary, do których odnoszą się punkty: `claude/propozycje_r14.md` (w Projekcie). Odpowiedź użytkownika
z 2026-11-25 19:00 (dosłownie): „przełączyć trzeba na prywatne. Podział na typ domu, które będę sobie w wolnych chwilach
ustawiał i predefiniował. Odbiór bez 59 kroków – nie rozumiem, zrób tak by było dobrze. Twoje propozycje, nr 2 są spoko, to
można wdrożyć. 3. także fajny pomysł, dodajmy + ewentualnie przy kliknięciu by się wyświetlało okienko z parametrami.
4. tak, odpowiada mi to. Wprowadź te zaległe zmiany.”

Runda 14 wykonała zaległości z 14 listopada, prosty odbiór i pasek narzędzi (`docs/przekazanie_r14.md`). Poniżej – to, co
zapadło i czeka.

## 1. Typy domów ustawiane przez użytkownika (runda 15)

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

## 2. Okno: wynik zawsze na widoku (runda 15)

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

## 3. Okna, drzwi i węgły kliknięciem – z okienkiem parametrów (runda 16)

**Decyzja:** „także fajny pomysł, dodajmy + ewentualnie przy kliknięciu by się wyświetlało okienko z parametrami”.

- Widok ściany: przełącznik „klik dodaje: węgieł / okno / drzwi” (kliknięcie z pozycją na ścianie już jest –
  `html/sciana.js#klikanie`, dziś tylko węgły).
- **Po kliknięciu małe okienko przy miejscu kliknięcia** z parametrami wstawianego elementu: typ stolarki z listy,
  szerokość, wysokość, spód okna, luz górny, nazwa; „Wstaw” / „Anuluj”. Kliknięcie w istniejący otwór albo węgieł otwiera
  to samo okienko do poprawki („Zapisz” / „Usuń”); dla węgła – położenie i wypusty.
- Przeciąganie otworu po ścianie; tabela zostaje jako podgląd i miejsce na dokładne liczby.
- Lista typowej stolarki (np. O1 1020 × 1010, D1 930 × 2100) w standardzie warsztatu – zamiast sześciu pól „Nowe okno /
  nowe drzwi”.

## 4. Jeden magazyn drewna i jeden przełącznik doboru (runda 16)

**Decyzja:** „tak, odpowiada mi to”.

- Podstawa z rundy 14: `rdzen/wykaz_drewna.rb` (wykaz z długościami, odczyt zapisu „45x145:4.2/5.4/6”),
  `rdzen/dlugosci_handlowe.rb` (podpowiedzi, dobór w całej długości).
- Do zrobienia: jedna tabela w standardzie warsztatu (przekrój, długości, rodzaj C24 / Nsi / DUO / BSH, do czego: legar,
  płatew, krokiew, słup, deska) zamiast pięciu pól tekstowych; pola przekrojów w oknie jako listy z magazynu (koniec
  z przekrojami spoza hurtowni: krokiew 50 × 150, legar 50 × 100, podciąg 100 × 150).
- Deski podbitki, nadbitki i deskowania z magazynu – po odpowiedzi, której deski użytkownik używa (`docs/stan_prac.md`
  §6, pytanie 2).
- Jeden przełącznik „Przekroje konstrukcji – dobieraj automatycznie / podaję sam” z wyjątkiem dla pojedynczego elementu
  (dziś: legary i zadaszenie automatycznie, płatwie i krokwie ręcznie, trójkąt „jak płatwie”).
- Dobór w całej długości także dla legarów, podciągów i krokwi.

## 5. Odbiór (wykonane w rundzie 14)

**Decyzja:** „nie rozumiem, zrób tak by było dobrze”. Zrobione: raport z testu działania zapisuje się sam, dziennik pracy,
scenariusz w trzech krokach (`docs/scenariusz_odbioru.md`). Dalej: na starcie każdej rundy czytać `raporty\`.

## 6. Zaległe z 2026-11-14, nadal otwarte

- **Pół zamka w wieńcu szczytowym** – czeka na decyzję T8 (łączenie wieńców w szczytach ścian domu na styk czy
  w zamkach węgłów). Przed wdrożeniem pokazać użytkownikowi rysunek obu wariantów.
- **Dom T, U, krzyż** – kalenica z dachu o większej powierzchni, `rdzen/skrzydla.rb` na dowolną liczbę skrzydeł.
- **Deski z wykazu** – patrz punkt 4.

## 7. Podgląd na żywo w modelu (runda 17, po pomiarze)

Z `propozycje_r14.md` §4G – użytkownik się nie wypowiedział. Decyzja po odczytaniu `ms_budowy` z dziennika pracy:
do 2–3 s – opcja „odświeżaj dom w modelu po zmianie pola”; dłużej – najpierw przyspieszenie budowy (te same definicje
bali używane ponownie, szybsze tworzenie brył).
