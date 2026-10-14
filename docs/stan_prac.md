# Stan prac – ArteMadera Generator Wieńcowy

Stan na: runda 3, kompilacja 3 (2026-10-14), wersja 1.0.0. Testy: `bash testy/uruchom.sh` – 16 zestawów (w tym
testy na Ruby 2.7.8, jak w SketchUpie 2023), 537 sprawdzeń, FAILURES 0; poza zestawem: 1000 losowych domów bez
problemów. Repozytorium: prywatne `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`, pełna historia rund 1–3)
+ kopia `repozytorium_r3.bundle` na dysku.

## 1. Co działa (kompilacja 3)

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
- **Szczyty**: skos dachu, gniazda płatwi, szczyt na działowej (opcja – krokwie z obu stron albo na nim), okruchy bali
  przy gniazdach pomijane; bale pod połacią (węgły, działowe) ścinane linią dachu; ostrzeżenie o zbyt stromym dachu.
- **Dach** (dom prostokątny): płatwie i krokwie; krokwie przy szczycie z obu stron / od wewnątrz / od zewnątrz / na
  szczycie; okapy. **Podłoga**: podwaliny na zakład, legary, podciągi, dobór przekroju z podpowiedziami.
- Pozycje „nr-długość” bali (Bs, Kf, Sz) i belek (Pw, L, Pd, P, K – kody grup Dokumentacji 2D).
- Model: Dom > W-n / Podłoga / Dach > komponenty (bryły zamknięte, punkty bliższe niż 0,2 mm scalane), tagi,
  atrybuty Dokumentacji 2D, zapis parametrów, przebudowa (przesunięty lub obrócony dom zostaje na miejscu),
  wykrywanie ręcznych zmian, jedno „Cofnij”.
- **Okno**: sekcje z listy parametrów, podpowiedzi, szablony, „Przywróć fabryczne”, pola zmienione względem
  fabrycznych wyróżnione, rzut (klik ściany → widok), **widok ściany** (bale z numerami pozycji, styki, skrzyżowania,
  otwory, linia dachu), okna i drzwi, wynik z podpowiedziami, **zestawienie CSV** dla Excela.
- **Test działania i raport** (menu): 6 przykładowych domów budowanych w cofanej operacji, sprawdzenie brył
  (`manifold?`, objętość), liczby z planu i z modelu, zaznaczony dom, środowisko, dziennik → plik JSON do wysłania.
- Ustawienia zapamiętane na komputerze (ostatnie parametry i szablony).

## 2. Jak to działa

Opis zasad: `docs/specyfikacja.md`, wszystkie parametry: `docs/parametry.md`. Mapa kodu: `docs/SPIS_TRESCI.md`.
Przebieg: `rdzen/projekt.rb#oblicz` (obrys → ściany → szczyty → otwory → styki → węgły → gniazda płatwi → bale pod
dachem → bale → zamki → pozycje → belki dachu i podłogi).

## 3. Zasady (stałe)

- Jeden temat = jeden plik; nagłówek pliku (Plik, Zadanie, Tematy, Zależy od, Używają); komentarz nad każdą metodą
  i funkcją JS; plik > 450 wierszy – podział (> 700 – błąd kontroli).
- `docs/SPIS_TRESCI.md` i `docs/parametry.md` tylko z generatorów, kontrola aktualności w testach.
- Rdzeń bez API SketchUpa; API tylko w `sketchup/`. Ruby 2.2 (testy także na Ruby 2.7.8 – `testy/ruby27.sh`), JS ES5,
  `Log`, zero placeholderów.
- Co tylko można – parametr: jeden wpis w `rdzen/parametry_lista.rb` (okno, zapis i szablony – same).
- Numer kompilacji = numer rundy, ten sam w rejestratorze i `main.rb`.
- Grupy domu, ścian, podłogi i dachu bez roli Dokumentacji 2D (rola „skip” na grupie wyłącza zawartość).
- Błąd znaleziony losowym domem → ziarno dopisane do `testy/t_losowe.rb` (regresja).

## 4. Moduły

Patrz `docs/SPIS_TRESCI.md` §2. Nowe w rundzie 3: `rdzen/pod_dachem.rb`, `rdzen/widok.rb`, `rdzen/zestawienie.rb`,
`rdzen/przyklady.rb`, `sketchup/eksport.rb`, `sketchup/raport.rb`, `html/sciana.js`, `html/zmiany.js`; testy
`t_losowe`, `t_widok`, `t_zestawienie`, `t_raport`, `losowe_domy.rb`, `kolizje_belek.rb`, `ruby27.sh`.

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

## 6. Otwarte pytania (przyjęte wartości domyślne – do potwierdzenia)

| # | Pytanie | Przyjęto |
|---|---|---|
| A3 | Profil bala (pióra, wpust, fazy) | bal prosty; profil w późniejszej rundzie |
| A5 | Kiedy ostatek 200 | parametr wspólny dla domu (osobno na narożnik – edycja w widoku ściany) |
| C9 | Układ łączeń | na przemian (1200); para (900 W-2) i jeden węgieł w opcjach |
| W1 | Limity 4800 / 3700, próg 3000 | z projektów 1800, 1200, 1100 – do potwierdzenia z praktyką |
| W2 | Rozmieszczenie węgłów | równo; od narożników (1000) w opcjach |
| S1 | Gdzie stoi płatew ścienna 60 × 200 (900) i wysokość linii dachu | przy licu wewnętrznym, wierzch płatwi 69,5 nad ścianą okapową; oba parametry |
| S2 | Wierzch płatwi a skos dachu | płatew wierzchem na linii przy krawędzi od okapu; bez fazowania |
| S3 | Krokwie przy szczycie | z obu stron (domyślnie); od wewnątrz / od zewnątrz / na szczycie w opcjach |
| P1 | Obciążenia podłogi | 2,0 kN/m² użytkowe + 0,5 stałe, C24, L/400 zalecane, L/250 dopuszczalne |
| P2 | Legar a podwalina | legary między podwalinami, wierzch równo (900); wyższy legar – podpowiedź |
| H20 | Grupy w Dokumentacji 2D | belki – jej kody (P, K, Pd, L, Pw); bale Bs, Kf, Sz – dopisać w Dokumentacji 2D |
| H21 | Producent / CNC: co dostaje, BVN czy BTLx | zestawienie CSV (pozycja, długość, ilość, m³); pliki CNC – do ustalenia |
| R1 | Dach: generator czy wtyczka dachów (KROK 2) | płatwie i krokwie z generatora; połacie dla wtyczki dachów – propozycja |

## 7. Do sprawdzenia w SketchUpie

`docs/scenariusz_odbioru.md` – kompilacja 3: najpierw menu „Test działania i raport do wysłania…” (plik JSON),
potem widok ściany, zestawienie CSV, zaznaczona ściana jako obrys, szczyty i dach na domach z działową.

## 8. Ograniczenia (kompilacja 3)

- Tylko ściany pod kątem prostym; linie ukośne – błąd.
- Dach (belki) i podłoga tylko dla obrysu prostokątnego; szczyty dla innych obrysów liczone każdy osobno.
- Krokwie z czołami prostopadłymi do osi (bez cięć przy kalenicy i okapie); płatwie bez fazowania.
- Widok ściany tylko do oglądania (bez dodawania węgłów kliknięciem); bez tarasu, desek, pełnego profilu bala.
- Statyka podłogi uproszczona – podpowiedź, nie projekt konstrukcyjny.
- Dokumentacja 2D nie zna jeszcze grup Bs, Kf, Sz – bale trafią do grupy „Elementy”.
- Brak odbioru w prawdziwym SketchUpie (kompilacje 1–3) – stąd test działania z raportem.

## 9. Plan kolejnych rund

1. Odbiór kompilacji 3: raport z testu działania (JSON) + scenariusz → poprawki.
2. Edycja w widoku ściany: klik – dodaj / usuń węgieł, ostatek 200 na wybranym narożniku.
3. Dokumentacja 2D: grupy Bs / Kf / Sz (zmiana w tamtej wtyczce) – karty i listy bali.
4. Taras: wysunięte górne bale, słupy, balustrada z odcinków.
5. Dach: cięcia krokwi, deski, obrysy L / U albo połacie dla wtyczki dachów; deski podłogi.
6. Pełny profil bala do wizualizacji.
