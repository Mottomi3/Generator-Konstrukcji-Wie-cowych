# Specyfikacja – ArteMadera Generator Wieńcowy

Stan: kompilacja 1 (2026-10-13). Wszystkie wymiary w mm. Decyzje użytkownika: `decyzje_projektowe.md` (Projekt claude.ai
i `00_Analiza\` na dysku).

## 1. Wejście – rysunek w SketchUpie

| Linia | Znaczenie |
|---|---|
| Zamknięta pętla linii | **lico zewnętrzne** ścian zewnętrznych (obrys domu) |
| Linia wewnątrz obrysu | **oś ściany działowej**; koniec na obrysie lub na innej działowej = połączenie T, koniec w pomieszczeniu = wolny koniec |
| Krótka linia (≤ 600) przecinająca jedną ścianę | **kontrfor** w miejscu przecięcia |

- Linie mogą być luzem albo w grupie; wszystkie na jednej wysokości – to spód pierwszego bala (poziom ±0).
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
  szczytowa n wieńców; kontrfor – do wysokości swojej ściany.
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
- Inne przekroje: tabela presetów w `rdzen/parametry.rb`, wymiary edytowalne w oknie.

## 5. Długości bali i styki (mijanka ≥ 300 – wymóg użytkownika)

- Bal dłuższy niż `max_dlugosc` (5000) → ściana dzielona. Liczba bali m – najmniejsza, przy której każdy kawałek
  mieści się w maksymalnej długości.
- **Układ domyślny „dwa skrzyżowania” (jak 900 W-2):** miejsce łączenia = dwa skrzyżowania a < b w odstępie
  `mijanka` (400, nie mniej niż 300). W wieńcach parzystych (licząc od dołu od 0) bale stykają się w osi a, w
  nieparzystych w osi b – czoła bali w połowie zamka, styk trzymają bale kontrforu nad i pod nim. Najpierw używane są
  istniejące skrzyżowania (działowe, narysowane kontrfory), brakujące – nowe kontrfory. Dom 4000 × 3000 przy
  maks. 4000 daje bale 1900 / 2300 z kontrforami jak w 900.
- Układ „jeden kontrfor”: styki c − 200 i c + 200 obok jednego kontrforu (poza zamkiem).
- Nowy kontrfor nie stanie bliżej niż 300 od innego skrzyżowania, przy otworze (150 + zapas), przy narożniku.
- `szczelina_styku` (0) – szczelina między czołami bali.
- Kontrola: `Kontrola.mijanka` – styki w sąsiednich wieńcach co najmniej 300 od siebie.

## 6. Otwory

- Wpis: ściana (W-n), od, szerokość, wysokość, parapet. „Od” liczone od narożnika lica zewnętrznego na początku
  ściany (kropka na rzucie w oknie); dla działowej – od początku narysowanej osi. Parapet od ±0 (spód pierwszego bala).
- Bal w całości w wysokości otworu – przecięty (cięcie proste); bal częściowo – wycięcie od góry (pod parapetem) lub
  od dołu (nad nadprożem). `luz_nad_otworem` (0) podnosi górną krawędź wycięcia.
- Kontrfor w miejscu otworu – bez bali na wysokości otworu (przerwany). Otwór bliżej niż 70 od lica ściany
  poprzecznej – ostrzeżenie.

## 7. Bale, pozycje, model

- Bryła bala prostego: 44 × 139 (półbal 69,5), obróbki: gniazda, podcięcia, wycięcia przy otworach (w przyszłości skosy
  szczytów). Pióro i wpust (pełny profil) – późniejsza runda (przełącznik).
- Identyczne bale (ta sama bryła, także po obrocie o 180° wokół pionu) = jedna pozycja „nr-długość” (np. `2-4200`)
  i jeden komponent. Numery: W-1, W-2…, w ścianie wieńce od dołu, w wieńcu wzdłuż ściany.
- Model: grupa „Dom wieńcowy” (obrót układu lokalnego, poziom ±0) > grupy W-n > instancje komponentów „Bal 2-4200”,
  „Kontrfor 9-244”. Tagi: Ściany zewnętrzne, Ściany działowe, Kontrfory.
- Atrybuty dla Dokumentacji 2D (słownik `ArteMadera` na definicji): `rola` = timber, `prefiks` = Bs / Kf, `pozycja`,
  `nazwa`. **Grupa domu nie ma roli** (rola „skip” na grupie wyłączyłaby wszystkie bale w Dokumentacji 2D).
  Prefiksy Bs i Kf trzeba jeszcze dopisać w Dokumentacji 2D (`element_roles.rb`, `PREFIX_GROUPS`).
- Wejście (linie, poziom, parametry, otwory) zapisane w grupie domu (`ArteMadera_GW`/`wejscie`): zaznacz dom →
  to samo polecenie → okno z parametrami → „Zastąp dom w modelu”. Ręczne zmiany w domu wykrywa podpis zawartości –
  przed nadpisaniem pytanie.

## 8. Okno

Formularz budowany z `Parametry::OPISY` (nowy parametr = jeden wpis w `rdzen/parametry.rb`), wymiary zamka,
rzut z numerami ścian i punktami odniesienia, tabela okien i drzwi, wynik (liczby, wysokości, ściany ze stykami,
lista bali do zamówienia). Każda zmiana pola → podgląd (bez zmian w modelu).

## 9. Etapy dalej

Szczyty z gniazdami pod płatwie/krokwie, taras (wysunięte górne bale + słupy, balustrada), podwaliny/legary/ocieplenie
(opcje), pełny profil bala, okno ściany z podglądem elewacji, Dokumentacja 2D – grupy Bs/Kf/Sz, dach (etap 2).
