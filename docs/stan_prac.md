# Stan prac – ArteMadera Generator Wieńcowy

Stan na: runda 4, kompilacja 4 (2026-10-24), wersja 1.0.0. Testy: `bash testy/uruchom.sh` – 17 zestawów (w tym
testy na Ruby 2.7.8, jak w SketchUpie 2023), 660 sprawdzeń, FAILURES 0; poza zestawem: 1600 losowych domów
(od rundy 4 także z pełnym profilem, działowymi pod stropem / antresolą / półką, ostatkami końców i węgłami ręcznymi)
bez problemów. Repozytorium: prywatne `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`, pełna historia rund
1–4) + kopia `repozytorium_r4.bundle` na dysku.

## 1. Co działa (kompilacja 4)

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
- **Test działania i raport** (menu): 7 przykładowych domów budowanych w cofanej operacji (siódmy – nowości rundy 4),
  sprawdzenie brył (`manifold?`, objętość), liczby z planu i z modelu, zaznaczony dom, środowisko, dziennik → plik
  JSON do wysłania.
- Ustawienia zapamiętane na komputerze (ostatnie parametry i szablony).

## 2. Jak to działa

Opis zasad: `docs/specyfikacja.md`, wszystkie parametry: `docs/parametry.md`. Mapa kodu: `docs/SPIS_TRESCI.md`.
Przebieg: `rdzen/projekt.rb#oblicz` (obrys → ściany → ustawienia ścian z widoku → szczyty → otwory → styki → węgły →
dopełnienie niższych działowych → gniazda płatwi → bale pod dachem → bale → zamki → profil → pozycje → belki dachu
i podłogi).

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
Nowe w rundzie 4: `rdzen/ustawienia_scian.rb`, `rdzen/dopelnienie.rb`, `rdzen/profil_bala.rb`, `html/tryb.js`,
`html/edycja.js`; test `t_sciany_ust`.

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

## 6. Otwarte pytania (przyjęte wartości domyślne – do potwierdzenia)

| # | Pytanie | Przyjęto |
|---|---|---|
| A3 | Profil bala (pióra, wpust, fazy) | domyślnie bal prosty; pełny profil: 2 pióra 8 × 7 w rozstawie 20, wpust 9 × 8 (luz 1), pierwszy wieniec bez wpustu, bez faz – do potwierdzenia zdjęciem czoła bala z miarką |
| A5 | Kiedy ostatek 200 | parametr wspólny dla domu + osobno na każdym końcu ściany (widok ściany) |
| D1 | Działowa niższa: góra i dopełnienie | tylko pod stropem / antresolą / półką; góra 2500 (17 wieńców, jak 1100 W-6) albo z ustawienia ściany, szablon ze stropem 2780 (20 wieńców, jak 1200); odcinki ostatek + 44 + 100 przy każdej wyższej ścianie, do jej góry |
| D2 | Węgły ręczne a automat | pierwsza zmiana w widoku przepisuje węgły ściany na listę ręczną (automat ściany wyłączony); węgieł bliżej niż 300 od skrzyżowania pominięty |
| T1 | Pola w trybie Podstawowe | 25 z 75 (preset, profil, wieńce, ostatek, kalenica, strop, maks. bal, łączenia, węgły, szczyty, dach, podłoga, okna, drzwi) – lista do korekty |
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

`docs/scenariusz_odbioru.md` – kompilacja 4: najpierw menu „Test działania i raport do wysłania…” (plik JSON),
potem pola Podstawowe / Wszystkie, widok ściany (ostatek, węgły kliknięciem), działowa pod antresolą i strop nad
parterem, pełny profil, czas generowania.

## 8. Ograniczenia (kompilacja 4)

- Tylko ściany pod kątem prostym; linie ukośne – błąd.
- Dach (belki) i podłoga tylko dla obrysu prostokątnego; szczyty dla innych obrysów liczone każdy osobno.
- Krokwie z czołami prostopadłymi do osi (bez cięć przy kalenicy i okapie); płatwie bez fazowania.
- Pełny profil tylko do wizualizacji: zamki, kolizje, pozycje i listy liczone dla bala prostego; bez faz; wymiary
  pióra i wpustu przyjęte (do potwierdzenia).
- Działowa niższa: tylko działowe (ściany zewnętrzne zawsze pełnej wysokości), bez szczytu; strop / antresola to
  ustawienie – belek stropu generator nie rysuje.
- Węgły ręczne wyłączają automat tej ściany – łączenia muszą trafić w węgły ręczne (inaczej ostrzeżenie).
- Bez tarasu i desek.
- Statyka podłogi uproszczona – podpowiedź, nie projekt konstrukcyjny.
- Dokumentacja 2D nie zna jeszcze grup Bs, Kf, Sz – bale trafią do grupy „Elementy”.
- Brak odbioru w prawdziwym SketchUpie (kompilacje 1–4) – stąd test działania z raportem.

## 9. Plan kolejnych rund

1. Odbiór kompilacji 4: raport z testu działania (JSON) + scenariusz → poprawki.
2. Wymiary pełnego profilu ze zdjęcia czoła bala (pióra, wpust, fazy).
3. Wybór użytkownika z propozycji objaśnionych w rundzie 4: 2 – grupy Bs / Kf / Sz w Dokumentacji 2D (zmiana w tamtej
   wtyczce), 3 – dach dokładniej (cięcia krokwi, deski, obrysy L / U albo połacie dla wtyczki dachów), 4 – taras
   (wysunięte górne bale, słupy, balustrada), 5 – szybsza budowa modelu (po czasach z raportu), 7 – okna i drzwi
   (typowe wymiary z projektów, dociąganie do krawędzi bala, ościeżnice), 10 – pliki dla producenta (rozkłady ścian,
   CNC).
