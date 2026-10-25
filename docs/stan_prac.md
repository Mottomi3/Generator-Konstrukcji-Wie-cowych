# Stan prac – ArteMadera Generator Wieńcowy

Stan na: runda 5, kompilacja 5 (2026-10-25), wersja 1.0.0. Testy: `bash testy/uruchom.sh` – 22 zestawy (w tym
15 na Ruby 2.7.8, jak w SketchUpie 2023, i sprawdzenie z prawdziwą aplikacją do dachów 3.3.1 na jej atrapie),
977 sprawdzeń, FAILURES 0; poza zestawem: 600 losowych domów na końcowym kodzie (ziarna 1–200, 2001–2200 i 2301–2500;
z krokwiami z aplikacji do dachów, luzami stolarki, dachem jednospadowym, od ziarna 2000 z tarasem 1100 / 1200) bez
problemów – wcześniej w rundzie ok. 1750 na wersjach pośrednich (błędy poprawione, ziarna w `testy/t_losowe.rb`). Repozytorium:
`Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`, pełna historia rund 1–5; od rundy 5 publiczne) + kopia
`repozytorium_r5.bundle` na dysku.

## 1. Co działa (kompilacja 5)

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
  **podniesione i ścięte do płaszczyzny dachu**; krokwie z **aplikacji do dachów** (połacie, okno KROKU 2 z kontrolą
  nośności – domyślnie) albo z generatora (z obu stron szczytu / od wewnątrz / od zewnątrz / na szczycie); okapy.
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

## 2. Jak to działa

Opis zasad: `docs/specyfikacja.md`, wszystkie parametry: `docs/parametry.md`. Mapa kodu: `docs/SPIS_TRESCI.md`.
Przebieg: `rdzen/projekt.rb#oblicz` (obrys z tarasem → ściany → ustawienia ścian z widoku → role ścian tarasu →
szczyty → otwory → styki → węgły → dopełnienie niższych działowych → gniazda płatwi → bale pod dachem → bale →
balustrada → bale ścięte dachem przy narożnikach → zamki → profil → pozycje → belki dachu, słupy tarasu i podłoga →
połacie dla aplikacji do dachów); po budowie domu `sketchup/dach_aplikacja.rb` (połacie i KROK 2).

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
Nowe w rundzie 5: `rdzen/stolarka.rb`, `rdzen/pryzmat.rb`, `rdzen/polacie.rb`, `rdzen/dach_jednospadowy.rb`,
`rdzen/skos_przy_narozniku.rb`, `rdzen/taras.rb`, `rdzen/taras_balustrada.rb`, `sketchup/dach_aplikacja.rb`,
`html/otwory.js`; testy `t_polacie`, `t_jednospadowy`, `t_taras`, `t_dach_aplikacja` (atrapa aplikacji do dachów
`testy/atrapa/aplikacja_dachow.rb`), `sprawdz_dach_aplikacja.rb` (prawdziwa aplikacja do dachów na jej atrapie),
`zrzut_dok2d.rb` (dom dla Dokumentacji 2D).

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
| S2 | Wierzch płatwi a skos dachu | **rozstrzygnięte (runda 5)**: płatew podniesiona, wierzch ścięty do płaszczyzny dachu (`platwie_sciecie`) |
| S3 | Krokwie przy szczycie | z obu stron (domyślnie); od wewnątrz / od zewnątrz / na szczycie w opcjach |
| S4 | Kawałek bala szczytu między płatwią a skosem | **rozstrzygnięte (runda 5)**: zostaje osobnym kawałkiem, jak 21-140, 22-186, 23-233 w 1100 W-2 (płatew 180 przecina bal 139 na całej wysokości); pozostałe bale szczytu w całości ze skosem |
| P1 | Obciążenia podłogi | 2,0 kN/m² użytkowe + 0,5 stałe, C24, L/400 zalecane, L/250 dopuszczalne |
| P2 | Legar a podwalina | legary między podwalinami, wierzch równo (900); wyższy legar – podpowiedź |
| H20 | Grupy w Dokumentacji 2D | belki – jej kody (P, K, Pd, L, Pw); bale Bs, Kf, Sz – dopisać w Dokumentacji 2D |
| H21 | Producent / CNC: co dostaje, BVN czy BTLx | zestawienie CSV (pozycja, długość, ilość, m³); pliki CNC – do ustalenia |
| R1 | Dach: generator czy wtyczka dachów (KROK 2) | **rozstrzygnięte (runda 5)**: płatwie z generatora, krokwie i dalsza więźba z aplikacji do dachów (`dach_wiezba`); krokwie z generatora w opcji |
| R2 | Ustawienia KROKU 2 z generatora | zapisywane w aplikacji do dachów na stałe (kierunek w górę, bez płatwi kalenicowej i zamków dolnych, krokiew 50 × 150, rozstaw 900, klasa drewna) – przy zwykłym dachu w tej aplikacji trzeba je przestawić |
| L1 | Luzy stolarki | boczny 10, górny = wysokość × 1,5 % (w górę do 5), nie mniej niż 10 |
| J1 | Dach jednospadowy | spadek w stronę mniejszych współrzędnych, okap za ścianą wysoką 500, najcieńszy górny bal ściany wysokiej 30 |
| T2 | Taras jak 1100 | 2 górne wieńce, słupy 120 × 120 co ≤ 2000, wejście 1200 pośrodku, balustrada 4 bale i przekładki 300 (prześwit ≤ 600), dolne bale ścian bocznych 100 za licem ściany domu |
| T3 | Taras jak 1200 | ściany boczne pełne do frontu, front otwarty – bez słupów i listew pionowych z projektu (osłona z listew 45 × 45 – do decyzji) |
| Z1 | Drewno w zamku przy skosie | co najmniej 20 mm nad gniazdem, inaczej bal kończy się przy licu ściany poprzecznej |

## 7. Do sprawdzenia w SketchUpie

`docs/scenariusz_odbioru.md` – kompilacja 5: najpierw menu „Test działania i raport do wysłania…” (plik JSON),
potem stolarka i luzy, płatwie ścięte i pełny klin szczytu, krokwie z aplikacji do dachów (połacie, KROK 2), dach
jednospadowy, taras 1100 i 1200.

## 8. Ograniczenia (kompilacja 5)

- Tylko ściany pod kątem prostym; linie ukośne – błąd.
- Dach (belki, połacie, dach jednospadowy, taras) i podłoga tylko dla obrysu prostokątnego; szczyty dla innych obrysów
  liczone każdy osobno – inne dachy w aplikacji do dachów (KROK 1 z obrysu).
- Krokwie z generatora z czołami prostopadłymi do osi (bez cięć przy kalenicy i okapie) – pełne krokwie robi aplikacja.
- Krokwie z aplikacji: szczyt zawsze pod krokwiami (krokwie przy szczycie ustawia aplikacja); kontrola krokwi liczy
  rozpiętość od okapu do kalenicy (płatwie pośrednie jeszcze nie jako podpory – zadanie dla aplikacji); więźbę do
  usunięcia przy przebudowie generator rozpoznaje po położeniu nad poprzednimi połaciami.
- Taras: przed jedną ścianą szczytową, dach dwuspadowy (1100) albo dowolny (1200); bez schodów, desek tarasu
  i osłony z listew (1200); w wariancie 1200 płatwie nad tarasem bez podparcia od frontu.
- Pełny profil tylko do wizualizacji: zamki, kolizje, pozycje i listy liczone dla bala prostego; bez faz; wymiary
  pióra i wpustu przyjęte (do potwierdzenia).
- Działowa niższa: tylko działowe (ściany zewnętrzne zawsze pełnej wysokości), bez szczytu; strop / antresola to
  ustawienie – belek stropu generator nie rysuje.
- Węgły ręczne wyłączają automat tej ściany – łączenia muszą trafić w węgły ręczne (inaczej ostrzeżenie).
- Bez desek dachu i poszycia (zadanie dla aplikacji do dachów).
- Statyka podłogi uproszczona – podpowiedź, nie projekt konstrukcyjny.
- Dokumentacja 2D nie zna jeszcze grup Bs, Kf, Sz – bale trafią do grupy „Elementy”.
- Brak odbioru w prawdziwym SketchUpie (kompilacje 1–4) – stąd test działania z raportem.

## 9. Plan kolejnych rund

1. Odbiór kompilacji 5: raport z testu działania (JSON) + scenariusz → poprawki.
2. Dokumentacja 2D i aplikacja do dachów – zadania zlecone w tamtych sesjach (`docs/zadanie_*.md`); po zmianach
   w aplikacji do dachów – generator na jej stałym wejściu (API), osie krokwi przy szczycie, podpory pośrednie.
3. Taras – szczegóły z odbioru (słupy, wejście, osłona z listew 1200, schody, deski).
4. Wymiary pełnego profilu ze zdjęcia czoła bala (pióra, wpust, fazy).
