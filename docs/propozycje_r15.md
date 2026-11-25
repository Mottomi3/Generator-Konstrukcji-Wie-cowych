# Propozycje po rundzie 14 – więcej możliwości generatora

Stan na 2026-11-25 20:30, kompilacja 14. Odpowiedź na punkt 4 wiadomości użytkownika z 20:26: „Zaproponuj od siebie
dodatkowe usprawnienia, oraz zmiany/poprawki, które zwiększą możliwości generowania takich konstrukcji”. Propozycje
z rundy 14 (`propozycje_r14.md`: trzy poziomy ustawień, okno, klikanie otworów, magazyn drewna, pasek narzędzi) są już
w kolejce – tu tylko nowe rzeczy. Każdy punkt: co, dlaczego (z kodu albo z Twoich projektów), wielkość pracy.

Wielkość: **mała** – część jednej rundy; **średnia** – większość rundy; **duża** – cała runda albo więcej.

## 0. W skrócie – co polecam najpierw

| # | Propozycja | Rodzaj | Wielkość |
|---|---|---|---|
| P1 | Słupy krótsze o osiadanie ścian, z regulacją | poprawka konstrukcji | mała |
| W2 | Pełne zestawienie materiałów (deski, taśma, okucia, impregnat) | wynik | mała |
| W1 | Powierzchnie i limity (zabudowa, pomieszczenia, wysokość) + „buduj do wysokości” | wynik | mała–średnia |
| P2 | Podparcie końców płatwi: dom L (kosz) i taras typu 300 | poprawka konstrukcji | średnia |
| P3 | Belki dłuższe niż w hurtowni dzielone w modelu nad podporą | poprawka konstrukcji | średnia |
| N1 | Strop i antresola z belek (domy 1,5 kondygnacji) | nowa konstrukcja | duża |

## 1. Poprawki konstrukcyjne – dziś model różni się od tego, co da się postawić

### P1. Słupy a osiadanie ścian (mała)

- Dziś parametr „Osiadanie ścian” (1,5 %) działa tylko na luz nad oknami i drzwiami (`rdzen/stolarka.rb`). Słupy tarasu
  typu 200, słupy trójkąta „na słupach” i słupki pod płatwiami mają stałą długość (`rdzen/taras_slupy.rb`,
  `rdzen/taras_wiazar.rb` – brak luzu).
- Ściana z 16 wieńców (2,3 m) przy 1,5 % siada ok. 3,4 cm, słup nie siada wcale. Bale podciągu nad tarasem są
  jednocześnie wieńcami ścian bocznych: część w domu opada, część na słupach zostaje – bale się wyginają, zamki
  rozchodzą, front tarasu wisi na słupach.
- Propozycja: słup krótszy o luz osiadania bali, które stoją obok niego (osiadanie × wysokość bali pod jego głowicą),
  w głowicy podkładka albo śruba regulacyjna (okucie w zestawieniu, wysokość w parametrze); przełącznik w standardzie
  warsztatu. To samo sprawdzenie dla każdego elementu, który łączy ścianę z bali ze słupem (belka zadaszenia jest już
  tylko oparta – dobrze).
- Pliki: nowy `rdzen/osiadanie.rb` (luz dla słupa z wysokości bali), `rdzen/taras_slupy.rb`, `rdzen/taras_wiazar.rb`.

### P2. Podparcie końców płatwi (średnia)

- **Dom L**: końce płatwi skrzydła bocznego w dachu głównym nie mają podpory (`docs/stan_prac.md` §8, pytanie L2 –
  „belka koszowa?”). Propozycja: płatwie skrzydła bocznego oparte wrębem na płatwi dachu głównego, którą przecinają;
  gdzie nie trafiają na płatew – belka koszowa pod linią kosza; sprawdzenie nośności jak płatwie.
- **Taras typu 300** (ściany boczne pełne, front otwarty): płatwie nad tarasem bez podparcia od frontu. Propozycja:
  trójkąt frontu jak w typie 200 (na balach ścian bocznych) albo belka na ostatkach ścian bocznych.
- Pliki: `rdzen/skrzydla.rb`, nowy `rdzen/belka_koszowa.rb`, `rdzen/taras_wiazar.rb`.

### P3. Belki dłuższe niż w hurtowni – podział w modelu (średnia)

- Dziś płatew 11 m przy najdłuższej belce z listy 8 m zostaje w modelu jednym kawałkiem; generator tylko podpowiada
  „połącz nad podporą” (`rdzen/dlugosci_handlowe.rb`). Zestawienie zamawia belkę, której nie ma.
- Propozycja: podział nad podporą (ściana, węgieł, słup) – styk na zakład albo ukośny, do wyboru; dwie pozycje
  w zestawieniu; statyka liczy belkę dzieloną. Dotyczy płatwi, legarów, podciągów, krokwi z generatora.
- Pliki: nowy `rdzen/podzial_belek.rb`, `rdzen/elementy.rb`, wywołanie w `rdzen/projekt.rb#belki`.

### P4. Szczyty na styk i pół zamka – zdecydowane 2026-11-25 20:26

W kolejce rundy 15 (`docs/zadanie_r15.md` §0). Skutek dla możliwości: w szczytach znikają węgły stawiane tylko po to,
żeby trzymać styki – szczyt wyższego domu jest prostszy i tańszy.

### P5. Drobne błędy geometrii z listy ograniczeń (mała)

Zebrać w jednym miejscu i zamknąć testem regresji: dom L z podbitką na płatwiach – podpory 19 mm pod połacią (ziarna 7004,
7021); słupy tarasu a płatew ścienna na ścianie (8064); krawędzie 0,025 mm i bale 0,04–0,16 mm nad dachem (75, 318, 472,
6110).

## 2. Nowe konstrukcje

### N1. Strop i antresola z belek (duża)

- Dziś „strop” i „antresola” to tylko wysokość, na której kończą się działowe (`strop`, `dzialowa_nizsza_wysokosc`).
  Belek stropu, desek ani otworu na schody generator nie rysuje, choć projekty 1200 i 2000 (1,5 kondygnacji) je mają.
- Propozycja: belki stropu (przekrój z magazynu, rozstaw, kierunek) w gniazdach bali ścian zewnętrznych albo na wieńcu,
  z luzem na osiadanie przy słupach; opcjonalnie wysunięte za ścianę (balkon, okap); otwór na schody prostokątem
  w widoku z góry; deski stropu; dobór przekroju jak legary. Antresola = strop na części domu, do działowej.
- Pliki: nowe `rdzen/strop.rb`, `rdzen/statyka_stropu.rb`, gniazda w `rdzen/bale.rb`, sekcja w liście parametrów.

### N2. Okna i drzwi lepiej dopasowane do bali (mała)

- Przyciąganie spodu i góry otworu do krawędzi wieńca (przełącznik): mniej bali przyciętych wzdłuż, brak cienkich pasków
  pod parapetem i nad nadprożem. Okno pokazuje, o ile przesunął.
- Czoła bali przy otworze: wpust albo czop pod ościeżnicę (listwa ślizgowa trzyma bale w pionie i pozwala im osiadać) –
  tylko jeśli tak montujesz okna (pytanie 2). Obróbka trafia do bryły bala, więc i do CNC.

### N3. Kanały na przewody elektryczne (mała)

Kliknięcie w widoku ściany (razem z oknami i węgłami z rundy 16) → pionowy otwór o zadanej średnicy przez wszystkie
wieńce, opcjonalnie gniazdo na puszkę na zadanej wysokości. W ścianie z bali przewodu nie da się poprowadzić później.

### N4. Dobudówki według jednego wzoru (duża, ale każda następna tańsza)

Wzór „dobudówki” (przedłużenie obrysu, oznaczenie ścian, elementy, statyka, podpowiedzi) z propozycji H rundy 14.
Na nim: zadaszenie od–do i zamknięcie boku, ganek / wiatrołap, taras w domu L, potem obrysy T i U. Taras jest dziś
w połowie plików rdzenia (kompilacja 13: 32 z 64) – kolejna dobudówka bez wzoru to znów kilkanaście plików.

### N5. Grubszy bal i inne systemy ścian (średnia–duża)

Wspominałeś 14 listopada o ścianach z grubszego bala. „System ściany” w standardzie warsztatu: przekrój bala, zamek,
ostatek, wypusty, półbal (dziś 44 × 146 i presety zamka). Bal 58 / 70 mm – średnia praca (te same zasady, inne liczby).
Brus profilowany 160 × 185 jak w projekcie 2300 (połączenie T na czop, ościeżnice, kołki) – duża, osobny moduł.

### N6. Narożnik 45°, wykusz, altana wielokątna (duża)

Dziś tylko kąty proste (linia ukośna = błąd). Sens tylko wtedy, gdy takie budujesz (pytanie 3).

## 3. Więcej z gotowego modelu – oferta i zamówienie

### W1. Powierzchnie i limity (mała–średnia)

- Generator nie liczy dziś żadnej powierzchni. Propozycja: powierzchnia zabudowy (po licach zewnętrznych), powierzchnia
  każdego pomieszczenia (po licach wewnętrznych, z linii działowych), powierzchnia dachu; wysokość kalenicy od terenu.
- Limity wpisujesz sam w standardzie warsztatu (np. powierzchnia i wysokość do zgłoszenia) – okno ostrzega, gdy dom je
  przekracza, zanim pójdzie do klienta.
- „Buduj do wysokości” (odłożone 2026-11-14): podajesz wysokość kalenicy, generator podaje kąt dachu albo liczbę wieńców.
- Pliki: nowy `rdzen/powierzchnie.rb`, wynik w oknie i w zestawieniu.

### W2. Pełne zestawienie materiałów (mała)

Do dzisiejszego CSV (bale i belki) dopisać rzeczy liczone z geometrii:
- nadbitka / podbitka i deskowanie: m² i liczba desek (np. 14 × 115 × 4000 – z odpowiedzi z 20:26);
- taśma uszczelniająca między wieńcami: metry (z długości bali, wieniec po wieńcu);
- okucia: kotwy słupów, łączniki krokwi z płatwiami, śruby regulacyjne słupów (P1), kotwy podwaliny;
- powierzchnia drewna do impregnatu / farby (lica zewnętrzne i wewnętrzne, m²).
Pliki: `rdzen/zestawienie.rb` + nowy `rdzen/materialy.rb`.

### W3. Wycena materiału (mała, po magazynie drewna)

Cena przy pozycji magazynu drewna (zł/m³ albo zł/szt.) i przy materiałach z W2 → koszt materiału domu w oknie
i w zestawieniu. Szybsza oferta dla klienta.

### W4. Dokumentacja 2D zna bale (mała, w tamtej wtyczce)

Grupy Bs / Kf / Sz w Dokumentacji 2D (`element_roles.rb`, `PREFIX_GROUPS`) – dziś bale trafiają do grupy „Elementy”.
Mała zmiana, a rozkłady ścian i listy bali od razu porządne. Zadanie: `docs/zadanie_dokumentacja2d.md`.

### W5. Plan montażu wieniec po wieńcu (średnia)

Rzut każdego wieńca z numerami bali (jak w schematach montażu producenta) – w Dokumentacji 2D albo jako widok w oknie.

## 4. Szybciej – uzupełnienie rundy 14

- **S1. Dom prostokątny z wymiarów** bez rysowania (z `propozycje_r14.md` §4E – jeszcze niezrobione): nic nie zaznaczone →
  okno pyta o długość i szerokość. Pasuje do rundy z typami domów.
- **S2. Typy z Twoich projektów** 900, 1100, 1200, 1800 jako gotowe punkty wyjścia (testy odtwarzają je od rundy 5) – jeśli
  chcesz, żeby nie zaczynać typów od zera.

## 5. Proponowana kolejność

| Runda | Zakres |
|---|---|
| 15 | Zdecydowane zaległości: szczyty na styk (T8), pół zamka, deski 14 × 115 × 4000, 45 × 120; P1, W2; przygotowanie rundy 16 – tabela podziału pól i szkic okna do akceptacji |
| 16 | Typy domów i okno z wynikiem na widoku (zgodnie z akceptacją z rundy 15), opcje wyszarzone dla obrysu, S1, W1 |
| 17 | Klikanie okien, drzwi, węgłów i kanałów (N3) z okienkiem parametrów; magazyn drewna i jeden przełącznik doboru; W3 |
| 18 | P2, P3, P5 |
| dalej | N1 strop, N4 dobudówki i obrysy T / U, N2, N5, W4–W5, podgląd na żywo po pomiarze |

## 6. Pytania

1. Które propozycje bierzemy (domyślnie: kolejność z §5)?
2. Jak mocujesz okna i drzwi w ścianie z bala 44 mm – ościeżnica na listwie ślizgowej w czołach bali, czy inaczej?
3. Budujesz narożniki 45°, wykusze albo altany wielokątne?
