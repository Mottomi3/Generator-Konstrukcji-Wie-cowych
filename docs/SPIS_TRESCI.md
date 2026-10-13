# Spis treści kodu – ArteMadera Generator Wieńcowy

Plik generowany – nie edytuj ręcznie. Po każdej zmianie kodu: `ruby testy/spis_tresci.rb`
(kontrola aktualności: `ruby testy/spis_tresci.rb --sprawdz`, wchodzi w `testy/uruchom.sh`).
Szukanie: najpierw tabela tematów (1), potem lista elementów pliku (3) – numer wiersza prowadzi prosto do miejsca.
Ścieżki plików wtyczki są względem `Plugins/arte_madera_generator_wiencowy/`.

## 1. Gdzie co zmieniać – tematy → pliki

| Temat | Plik |
|---|---|
| asercje | `testy/pomoc.rb` |
| atrapa | `testy/t_sketchup.rb` |
| atrapa api | `testy/atrapa/sketchup.rb` |
| atrybuty | `sketchup/atrybuty.rb` |
| atrybuty dokumentacji 2d | `testy/t_sketchup.rb` |
| bal | `rdzen/bale.rb` |
| bal obrócony | `sketchup/konwersja.rb`, `testy/t_sketchup.rb` |
| bryła bala | `rdzen/bryla.rb` |
| bryła zamknięta | `rdzen/siatka.rb`, `testy/t_siatka.rb` |
| budowa modelu | `sketchup/budowa.rb`, `testy/t_sketchup.rb` |
| błędy | `log.rb`, `rdzen/projekt.rb` |
| callback | `sketchup/okno.rb` |
| cięcie proste przy otworze | `rdzen/otwory.rb` |
| cięcie przy otworze | `rdzen/bale.rb` |
| czasy etapów | `log.rb` |
| dane dla okna | `sketchup/sterowanie.rb` |
| dane testowe okna | `testy/okno_dane.rb` |
| definicja z siatki | `sketchup/budowa.rb` |
| dom 900 | `testy/t_rdzen.rb` |
| dom testowy | `testy/podglad.rb` |
| domy testowe | `testy/pomoc.rb` |
| drzwi | `rdzen/otwory.rb` |
| dziennik | `log.rb` |
| długie ściany | `testy/t_rdzen.rb` |
| długość bala | `rdzen/bale.rb`, `rdzen/parametry.rb` |
| długość pliku | `testy/sprawdz_zasady.rb` |
| długość – sprawdzenie | `rdzen/kontrola.rb` |
| eksport obj | `testy/podglad.rb` |
| es5 | `testy/sprawdz_zasady.rb` |
| formularz | `html/okno.css`, `testy/t_okno.js` |
| formularz parametrów | `sketchup/okno.rb`, `html/okno.js` |
| gdzie co zmieniać | `testy/spis_tresci.rb` |
| geom::point3d | `testy/atrapa/sketchup.rb` |
| geom::transformation | `testy/atrapa/sketchup.rb` |
| gniazdo 40 × 36 | `testy/t_zamek.rb` |
| gniazdo dolne | `rdzen/zamek.rb` |
| gniazdo górne | `rdzen/zamek.rb` |
| grupa domu | `sketchup/budowa.rb` |
| grupa ściany | `sketchup/budowa.rb` |
| góra ścian | `rdzen/wience.rb` |
| htmldialog | `sketchup/okno.rb` |
| identyczne bale | `rdzen/bryla.rb`, `rdzen/pozycje.rb` |
| ilość sztuk | `rdzen/pozycje.rb` |
| init okna | `testy/okno_dane.rb` |
| instalacja | `testy/buduj_rbz.rb` |
| jeden temat = jeden plik | `testy/sprawdz_zasady.rb` |
| jednostki mm/cale | `sketchup/konwersja.rb` |
| kalenica | `rdzen/parametry.rb`, `rdzen/sciany.rb` |
| katalog wtyczki | `main.rb` |
| kawałek bala | `rdzen/bale.rb` |
| kierunek a/b | `rdzen/sciany.rb` |
| kolejność kroków | `rdzen/projekt.rb` |
| kolizje | `rdzen/kontrola.rb` |
| kolory | `html/okno.css` |
| komponent | `rdzen/pozycje.rb` |
| komponent bala | `sketchup/budowa.rb` |
| komunikaty | `html/okno.css` |
| komunikaty w oknie | `sketchup/okno.rb` |
| konsola ruby | `log.rb` |
| kontrfor | `rdzen/sciany.rb` |
| kontrfor przerwany przy otworze | `rdzen/bale.rb` |
| kontrfor przy styku | `rdzen/styki.rb` |
| kontrfor – wysokość | `rdzen/wience.rb` |
| kontrola | `rdzen/kontrola.rb` |
| kontrola przed commitem | `testy/uruchom.sh` |
| kontrola z menu | `testy/t_sketchup.rb` |
| kontrola zamków z menu | `sketchup/sterowanie.rb` |
| krawędzie | `sketchup/wejscie.rb` |
| labirynt | `rdzen/zamek.rb` |
| lico zewnętrzne | `rdzen/obrys.rb` |
| linie obrysu w grupie | `sketchup/wejscie.rb` |
| linie wejściowe | `rdzen/obrys.rb` |
| lista bali | `rdzen/pozycje.rb` |
| lista ścian | `rdzen/projekt.rb` |
| luz 0,5 | `testy/t_zamek.rb` |
| luz osiadania | `rdzen/otwory.rb` |
| luz pionowy | `rdzen/kontrola.rb` |
| luz pionowy 2,5 | `testy/t_zamek.rb` |
| luz w zamku | `rdzen/zamek.rb` |
| maksymalna długość bala | `rdzen/styki.rb` |
| mapa kodu | `testy/spis_tresci.rb` |
| menu | `sketchup/menu.rb` |
| mijanka | `rdzen/styki.rb`, `testy/t_rdzen.rb` |
| mijanka 300 | `rdzen/parametry.rb` |
| mijanka – sprawdzenie | `rdzen/kontrola.rb` |
| module_files | `main.rb`, `testy/sprawdz_zasady.rb` |
| nachodzenie bali | `rdzen/kontrola.rb` |
| nadproże | `rdzen/otwory.rb` |
| nagłówki plików | `testy/spis_tresci.rb`, `testy/sprawdz_zasady.rb` |
| narożnik l | `rdzen/sciany.rb` |
| narożnik wklęsły | `rdzen/sciany.rb` |
| nazwa bala 10-4200 | `rdzen/pozycje.rb` |
| numer kompilacji | `Plugins/arte_madera_generator_wiencowy.rb`, `main.rb`, `sketchup/menu.rb`, `testy/sprawdz_zasady.rb` |
| numeracja bali | `rdzen/pozycje.rb` |
| numeracja ścian | `rdzen/sciany.rb` |
| numery wierszy | `testy/spis_tresci.rb` |
| o wtyczce | `sketchup/menu.rb` |
| objętość | `rdzen/bryla.rb`, `testy/t_siatka.rb` |
| objętość siatki | `rdzen/siatka.rb` |
| obrys | `rdzen/obrys.rb` |
| obrys l | `testy/t_rdzen.rb` |
| obrys prostokątny | `testy/pomoc.rb` |
| obrys w kształcie l | `testy/pomoc.rb` |
| obróbki bala | `rdzen/bryla.rb` |
| obrót | `testy/t_rdzen.rb` |
| obrót o 180° | `rdzen/bryla.rb` |
| obrót obrysu | `testy/pomoc.rb` |
| obrót układu | `rdzen/geometria.rb` |
| odcinek 244 | `testy/t_zamek.rb` |
| odległości | `rdzen/geometria.rb` |
| okno | `rdzen/otwory.rb`, `sketchup/okno.rb`, `html/okno.html` |
| okno – wywołania | `testy/t_sketchup.rb` |
| operacja cofnij | `sketchup/budowa.rb` |
| opis w menedżerze rozszerzeń | `Plugins/arte_madera_generator_wiencowy.rb` |
| orientacja lic | `testy/t_zamek.rb` |
| osie działowych | `rdzen/obrys.rb` |
| ostatek | `rdzen/parametry.rb`, `rdzen/sciany.rb` |
| ostrzeżenia | `log.rb`, `rdzen/projekt.rb` |
| ostrzeżenie o ręcznych poprawkach | `sketchup/sterowanie.rb` |
| otwory | `testy/t_rdzen.rb` |
| otwory w ścianach siatki | `testy/t_siatka.rb` |
| otwory) | `rdzen/projekt.rb` |
| otwór | `rdzen/otwory.rb` |
| oś ściany | `rdzen/sciany.rb` |
| paczka rbz | `testy/buduj_rbz.rb` |
| para skrzyżowań | `rdzen/styki.rb` |
| parametry | `rdzen/parametry.rb`, `rdzen/projekt.rb` |
| parapet | `rdzen/otwory.rb` |
| pierwszy wieniec | `rdzen/wience.rb` |
| plan domu | `rdzen/projekt.rb` |
| playwright | `testy/t_okno.js` |
| podcięcie 2,5 × 42 | `testy/t_zamek.rb` |
| podcięcie boczne | `rdzen/zamek.rb` |
| podgląd | `sketchup/okno.rb` |
| podgląd 3d | `testy/podglad.py`, `testy/podglad.rb` |
| podgląd automatyczny | `html/okno.js` |
| podpis bala | `rdzen/bryla.rb` |
| podpis zawartości | `sketchup/atrybuty.rb` |
| podsumowanie | `rdzen/projekt.rb` |
| podział wieńca | `rdzen/bale.rb` |
| poziom domu z0 | `sketchup/wejscie.rb` |
| poziom wieńca | `rdzen/wience.rb` |
| poziom ±0 | `rdzen/otwory.rb` |
| pozycja | `rdzen/pozycje.rb`, `sketchup/atrybuty.rb` |
| pozycje menu | `sketchup/menu.rb` |
| położenie bala | `rdzen/bale.rb` |
| połączenie t | `rdzen/sciany.rb` |
| prefiks bs / kf | `rdzen/pozycje.rb` |
| prefiks bs/kf | `sketchup/atrybuty.rb` |
| presety | `rdzen/parametry.rb` |
| profil bala | `rdzen/bryla.rb` |
| przebieg generowania | `rdzen/projekt.rb` |
| przebudowa | `sketchup/atrybuty.rb`, `sketchup/budowa.rb`, `testy/t_sketchup.rb` |
| przebudowa z parametrów | `sketchup/sterowanie.rb` |
| przecięcia odcinków | `rdzen/geometria.rb` |
| przedziały | `rdzen/bryla.rb` |
| przekrój bala | `rdzen/parametry.rb` |
| przesunięcie o pół wieńca | `rdzen/wience.rb` |
| przycisk generuj | `sketchup/okno.rb` |
| przyciski | `html/okno.html` |
| punkt sketchupa | `sketchup/konwersja.rb` |
| punkty t | `rdzen/siatka.rb` |
| półbal | `rdzen/wience.rb` |
| półzamek przy styku | `rdzen/zamek.rb` |
| płaszczyzna pozioma | `sketchup/wejscie.rb` |
| rejestracja rozszerzenia | `Plugins/arte_madera_generator_wiencowy.rb` |
| rola timber | `sketchup/atrybuty.rb` |
| ruby 2.2 | `testy/sprawdz_zasady.rb` |
| rysunek domu | `testy/podglad.py` |
| rzut w oknie | `sketchup/sterowanie.rb`, `html/okno.js` |
| ręczne poprawki | `sketchup/atrybuty.rb` |
| scalanie linii | `rdzen/obrys.rb` |
| scalanie ścian współpłaszczyznowych | `rdzen/siatka.rb` |
| sekcje formularza | `html/okno.html` |
| sekcje pól | `html/okno.js` |
| siatka | `rdzen/siatka.rb` |
| skos | `testy/t_siatka.rb` |
| skos (szczyty) | `rdzen/bryla.rb` |
| skrzyżowanie x | `rdzen/sciany.rb`, `testy/t_rdzen.rb` |
| spis treści | `testy/spis_tresci.rb` |
| sprawdzenie wzrokowe | `testy/podglad.rb` |
| sprawdzenie zamka | `rdzen/kontrola.rb` |
| start z menu | `sketchup/sterowanie.rb` |
| sterowanie | `sketchup/sterowanie.rb` |
| styk | `rdzen/styki.rb` |
| styk w osi zamka | `rdzen/styki.rb` |
| styk w wieńcu | `rdzen/bale.rb` |
| szczelina styku | `rdzen/styki.rb` |
| słownik artemadera | `sketchup/atrybuty.rb` |
| tabela | `html/okno.css` |
| tabela otworów | `sketchup/okno.rb`, `html/okno.js` |
| tagi | `sketchup/budowa.rb` |
| test okna | `testy/t_okno.js` |
| testy | `testy/pomoc.rb` |
| testy offline | `testy/atrapa/sketchup.rb` |
| testy rdzenia | `testy/t_rdzen.rb` |
| testy siatki | `testy/t_siatka.rb` |
| testy sketchup | `testy/t_sketchup.rb` |
| testy zamka | `testy/t_zamek.rb` |
| tolerancje | `rdzen/geometria.rb` |
| transformacja bala | `sketchup/konwersja.rb` |
| transformacja domu (obrót układu lokalnego) | `sketchup/konwersja.rb` |
| tryb nowy / edycja | `sketchup/sterowanie.rb` |
| układ lokalny (obrót) | `rdzen/obrys.rb` |
| układ okna | `html/okno.html` |
| uruchamianie testów | `testy/uruchom.sh` |
| ustawienie bala licem | `rdzen/zamek.rb` |
| usuwanie starych definicji | `sketchup/budowa.rb` |
| wartości domyślne | `rdzen/parametry.rb` |
| wejście (segmenty | `rdzen/projekt.rb` |
| wektory | `rdzen/geometria.rb` |
| wersja | `main.rb` |
| wielokąt z otworem | `rdzen/siatka.rb` |
| wieniec | `rdzen/wience.rb` |
| wolny koniec | `rdzen/sciany.rb` |
| wybór domu do edycji | `sketchup/wejscie.rb` |
| wycięcie bala przy otworze | `rdzen/otwory.rb` |
| wydanie | `testy/buduj_rbz.rb` |
| wygląd okna | `html/okno.css` |
| wymiary zamka | `rdzen/parametry.rb` |
| wymiary zamka w oknie | `html/okno.js` |
| wynik okna | `testy/okno_dane.rb` |
| wyniki w oknie | `html/okno.js` |
| wysokość ściany | `rdzen/wience.rb` |
| wywołania ruby | `testy/t_okno.js` |
| zamek | `rdzen/zamek.rb` |
| zaokrąglenia | `rdzen/geometria.rb` |
| zapis parametrów w modelu | `sketchup/atrybuty.rb` |
| zasady kodu | `testy/sprawdz_zasady.rb` |
| zaznaczenie | `sketchup/wejscie.rb` |
| zbliżenie zamka | `testy/podglad.py` |
| zestawy testów | `testy/uruchom.sh` |
| znacznik kontrforu | `rdzen/obrys.rb` |
| zrzut okna | `testy/t_okno.js` |
| ładowanie modułów | `main.rb` |
| łączenie bali na długość | `rdzen/styki.rb` |
| ściana | `rdzen/sciany.rb` |
| ściana działowa | `testy/t_rdzen.rb` |
| ściana z otworem | `sketchup/budowa.rb` |
| ściana z otworem w atrapie | `testy/atrapa/sketchup.rb` |
| ściany bryły | `rdzen/siatka.rb` |

## 2. Pliki

| Plik | Wierszy | Zadanie |
|---|---:|---|
| `Plugins/arte_madera_generator_wiencowy.rb` | 47 | rejestracja rozszerzenia w SketchUpie – jedyny plik ładowany automatycznie z folderu Plugins. |
| `main.rb` | 64 | stałe wtyczki (wersja, numer kompilacji, katalogi) i ładowanie modułów w kolejności zależności. |
| `log.rb` | 135 | dziennik wtyczki – jedno miejsce na błędy, ostrzeżenia, informacje i czasy etapów. |
| `rdzen/bale.rb` | 134 | bale każdej ściany w każdym wieńcu – kawałki między otworami i stykami, wycięcia przy otworach, położenie w układzie domu. |
| `rdzen/bryla.rb` | 139 | bryła bala z obróbek – profil wzdłuż bala (przedziały z zakresem grubości i wysokości), przynależność punktu, objętość, podpis. |
| `rdzen/geometria.rb` | 221 | działania na punktach 2D/3D (tablice [x, y] / [x, y, z] w mm) bez API SketchUpa. |
| `rdzen/kontrola.rb` | 136 | kontrola wyniku – kolizje bali w słupach zamków, mijanka styków w sąsiednich wieńcach, długości bali. |
| `rdzen/obrys.rb` | 292 | rozpoznanie narysowanych linii – zamknięty obrys (lico zewnętrzne), osie ścian działowych, znaczniki kontrforów. |
| `rdzen/otwory.rb` | 107 | otwory okienne i drzwiowe – położenie na ścianie, sprawdzenie, cięcia bali w każdym wieńcu. |
| `rdzen/parametry.rb` | 175 | wartości domyślne, presety przekroju bala z wymiarami zamka, opisy pól okna i sprawdzenie parametrów. |
| `rdzen/pozycje.rb` | 71 | numeracja pozycji jak u producenta – identyczne bale (ta sama bryła, także po obrocie o 180°) dostają jedną pozycję „nr-długość”. |
| `rdzen/projekt.rb` | 85 | przebieg obliczeń domu od linii do listy bali (kolejność kroków) i podsumowanie do okna – bez API SketchUpa. |
| `rdzen/sciany.rb` | 244 | ściany z rozpoznanego obrysu – osie, zasięgi bali z ostatkami, skrzyżowania, kontrfory, kierunek względem kalenicy, numeracja W-n. |
| `rdzen/siatka.rb` | 340 | siatka ścian (płaskich wielokątów z otworami) zamkniętej bryły bala z profilu – do budowy komponentu w SketchUpie. |
| `rdzen/styki.rb` | 171 | podział długich ścian na bale – wybór miejsc styków na mijankę (min. 300 mm), dostawianie kontrforów. |
| `rdzen/wience.rb` | 61 | poziomy wieńców każdej ściany – półbal na dole ścian wzdłuż kalenicy, liczba wieńców, wysokości ścian. |
| `rdzen/zamek.rb` | 111 | obróbki zamka na każdym skrzyżowaniu – gniazda górne/dolne i podcięcia boczne bali (zamek 44 × 146 z rysunku IMG-20250930-WA0005). |
| `sketchup/atrybuty.rb` | 106 | atrybuty w modelu – zgodność z Dokumentacją 2D (słownik ArteMadera) i zapis wejścia generatora do przebudowy. |
| `sketchup/budowa.rb` | 136 | budowa domu w modelu – grupa domu > grupy ścian W-n > instancje komponentów bali, tagi, usuwanie poprzedniej wersji. |
| `sketchup/konwersja.rb` | 64 | przeliczenia między rdzeniem (mm, tablice) a SketchUpem (cale, Geom::Point3d, Geom::Transformation). |
| `sketchup/menu.rb` | 40 | menu Rozszerzenia → ArteMadera Generator Wieńcowy (generuj / edytuj, kontrola, o wtyczce). |
| `sketchup/okno.rb` | 115 | okno parametrów (UI::HtmlDialog) – dane startowe dla okna, wywołania z JavaScriptu, wyniki do okna. |
| `sketchup/sterowanie.rb` | 134 | przebieg pracy z menu – start (linie albo dom do edycji), podgląd, generowanie, kontrola; dane wyniku dla okna. |
| `sketchup/wejscie.rb` | 61 | odczyt zaznaczenia – narysowane linie (obrys, osie działowych, kontrfory) albo istniejący dom z generatora. |
| `html/okno.css` | 105 | wygląd okna parametrów. |
| `html/okno.html` | 101 | okno parametrów generatora – układ sekcji (formularz budowany przez okno.js z opisów pól z Ruby). |
| `html/okno.js` | 492 | logika okna parametrów – formularz z opisów pól, tabela otworów, rzut SVG, wyniki, wywołania Ruby (sketchup.*). |
| `testy/atrapa/extensions.rb` | 3 | – |
| `testy/atrapa/sketchup.rb` | 608 | atrapa API SketchUpa (Geom, Sketchup::Model/Entities/Group/ComponentDefinition/Face/Edge, UI) do testów bez SketchUpa. |
| `testy/buduj_rbz.rb` | 28 | paczka instalacyjna .rbz (zip rejestratora i folderu wtyczki) – do instalacji w Menedżerze rozszerzeń SketchUpa. |
| `testy/okno_dane.rb` | 28 | dane okna z prawdziwego przebiegu (atrapa SketchUpa) – wypisuje JSON { init:, wynik: } dla testu okna w przeglądarce. |
| `testy/podglad.py` | 71 | rysunek 3D domu z pliku OBJ (testy/podglad.rb) – cały dom i zbliżenie narożnika, do sprawdzenia wzrokowego. |
| `testy/podglad.rb` | 66 | zapis domu testowego do pliku OBJ (siatki pozycji ułożone jak w modelu) – do obejrzenia bez SketchUpa (testy/podglad.py). |
| `testy/pomoc.rb` | 89 | wspólne narzędzia testów – sprawdzenia, licznik błędów, przykładowe obrysy (domy testowe). |
| `testy/spis_tresci.rb` | 151 | generator spisu treści kodu docs/SPIS_TRESCI.md – tematy → pliki, lista plików, metody i stałe z numerami wierszy. |
| `testy/sprawdz_zasady.rb` | 163 | kontrola zasad kodu – Ruby 2.2, ES5, rdzeń bez API SketchUpa, nagłówki plików, komentarze nad metodami, długość plików, kompilacja, MODULE_FILES. |
| `testy/t_okno.js` | 105 | okno parametrów w Chromium (Playwright) – formularz z opisów, rzut, tabela otworów, wywołania sketchup.*, wyniki. |
| `testy/t_rdzen.rb` | 215 | testy rdzenia – obrys, ściany, wieńce, styki z mijanką, kontrfory, otwory, pozycje, kolizje w zamkach. |
| `testy/t_siatka.rb` | 75 | siatka brył wszystkich pozycji z kilku domów – zamknięta (każda krawędź raz w każdą stronę), objętość równa profilowi. |
| `testy/t_sketchup.rb` | 197 | warstwa SketchUpa na atrapie API – ładowanie wtyczki, okno, generowanie, atrybuty, położenie bali, przebudowa, ręczne zmiany. |
| `testy/t_zamek.rb` | 95 | zamek 44 × 146 zgodny z rysunkiem IMG-20250930-WA0005 – wymiary obróbek, luzy, labirynt (tylko poprawne ułożenie bez kolizji). |
| `testy/uruchom.sh` | 47 | wszystkie testy i kontrole jednym poleceniem – ostatnia linia „WSZYSTKIE ZESTAWY: FAILURES n”. |

## 3. Zawartość plików

### Plugins/arte_madera_generator_wiencowy.rb (47 wierszy)

rejestracja rozszerzenia w SketchUpie – jedyny plik ładowany automatycznie z folderu Plugins.

Zależy od: arte_madera_generator_wiencowy/main.rb
Używają: SketchUp

| Wiersz | Element | Opis |
|---:|---|---|
| 17 | `PLUGIN_ID` |  |
| 18 | `PLUGIN_NAME` |  |
| 19 | `PLUGIN_VERSION` |  |
| 20 | `PLUGIN_AUTHOR` |  |
| 22 | `PLUGIN_BUILD` | Numer kompilacji – ten sam co w arte_madera_generator_wiencowy/main.rb. |
| 23 | `PLUGIN_BUILD_DATE` |  |

### main.rb (64 wierszy)

stałe wtyczki (wersja, numer kompilacji, katalogi) i ładowanie modułów w kolejności zależności.

Zależy od: log.rb i wszystkie moduły z MODULE_FILES
Używają: arte_madera_generator_wiencowy.rb (rejestrator)

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `PLUGIN_ID` |  |
| 20 | `PLUGIN_NAME` |  |
| 21 | `PLUGIN_VERSION` |  |
| 22 | `PLUGIN_AUTHOR` |  |
| 24 | `PLUGIN_BUILD` | Numer kompilacji – rośnie z każdą rundą prac; ten sam w arte_madera_generator_wiencowy.rb. |
| 25 | `PLUGIN_BUILD_DATE` |  |
| 30 | `EXTENSION_DIR` |  |
| 41 | `MODULE_FILES` | Moduły w kolejności zależności: rdzeń (czysty Ruby), potem warstwa SketchUpa. |

### log.rb (135 wierszy)

dziennik wtyczki – jedno miejsce na błędy, ostrzeżenia, informacje i czasy etapów.

Zależy od: –
Używają: wszystkie pliki (rdzeń i warstwa SketchUp)

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `module Log` |  |
| 17 | `PREFIX` |  |
| 18 | `MAX_WPISOW` |  |
| 19 | `MAX_CZASOW` |  |
| 21 | `WOLNY_MS` | Etap dłuższy niż tyle milisekund jest też wypisywany w Konsoli Ruby. |
| 29 | `error(gdzie, wyjatek, linie = 6)` | Błąd z wyjątkiem: gdzie – moduł i metoda (np. „Budowa.zbuduj”). |
| 40 | `error_text(tekst)` | Błąd opisany tekstem (np. zgłoszony przez okno – JavaScript). |
| 49 | `warn(tekst)` | Ostrzeżenie (np. ostatek wchodzący do wnętrza, otwór przy skrzyżowaniu). |
| 58 | `info(tekst)` | Informacja (np. podsumowanie generowania). |
| 67 | `time(etap)` | Czas etapu; blok dostaje słownik na szczegóły, zwracany jest wynik bloku. |
| 81 | `zapisz_czas(etap, ms, szczegoly, skonczony)` | Zapis czasu etapu (wywoływany przez time). |
| 95 | `wpisy` | Kopia wpisów (do okna i raportu). |
| 100 | `czasy` | Kopia zapisanych czasów etapów. |
| 105 | `liczniki` | Liczba wpisów według poziomu. |
| 110 | `wyczysc` | Czyszczenie dziennika (testy, nowa sesja generowania). |
| 120 | `dodaj(poziom, tekst, slad)` | Zapis wpisu w pamięci (najwyżej MAX_WPISOW ostatnich). |
| 127 | `wypisz(tekst, slad = [])` | Wydruk do Konsoli Ruby – jedyne miejsce z puts w module (dziennik). |

### rdzen/bale.rb (134 wierszy)

bale każdej ściany w każdym wieńcu – kawałki między otworami i stykami, wycięcia przy otworach, położenie w układzie domu.

Zależy od: rdzen/geometria.rb, rdzen/parametry.rb, rdzen/wience.rb, rdzen/otwory.rb, rdzen/styki.rb
Używają: rdzen/projekt.rb, rdzen/zamek.rb (obróbki), rdzen/pozycje.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `module Bale` |  |
| 29 | `zbuduj(sciany, p)` | Wszystkie bale domu (bez obróbek zamka): { bale: [...], ostrzezenia: [...] }. |
| 52 | `kawalki_wienca(w, wn, i, p, uwagi)` | Kawałki bala w wieńcu: zasięg ściany minus otwory przelotowe, podzielony w miejscach styków. |
| 74 | `koniec_typ(w, s, pelne)` | Rodzaj końca bala w miejscu s: ostatek (koniec zasięgu z ostatkiem), otwór, wolny koniec ściany. |
| 84 | `nowy_bal(w, wn, i, s0, s1, konce, wyciecia)` | Nowy bal z wycięciami od otworów (cechy w układzie bala). |
| 97 | `kontrfor_obecny?(kf, wn, p)` | Czy bal kontrforu w wieńcu wn ma oparcie: bale gospodarza na poziomach lvl ± 1 obecne (bez otworu) w osi kontrforu. |
| 106 | `sprawdz_dlugosci(wynik, p)` | Ostrzeżenia o długościach: kawałek krótszy od najkrótszego, bal dłuższy od maksymalnego. |
| 126 | `polozenie(b, p)` | Położenie bala w układzie domu: początek (lico prawe, czoło s0, spód), osie x (wzdłuż), y (w lewo), z (w górę). |

### rdzen/bryla.rb (139 wierszy)

bryła bala z obróbek – profil wzdłuż bala (przedziały z zakresem grubości i wysokości), przynależność punktu, objętość, podpis.

Zależy od: –
Używają: rdzen/siatka.rb, rdzen/pozycje.rb, rdzen/kontrola.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 18 | `module Bryla` |  |
| 19 | `EPS` |  |
| 21 | `DOKLADNOSC` | Dokładność podpisu bala [mm] – bale różniące się mniej są tą samą pozycją. |
| 26 | `profil(dl, t, h, cechy)` | Profil: lista przedziałów { xa:, xb:, y0:, y1:, zb_a:, zb_b:, zt_a:, zt_b: } (puste przedziały pominięte). |
| 62 | `przeciecia(lista)` | Punkty x, w których dwie proste ograniczenia przecinają się wewnątrz wspólnego zakresu. |
| 79 | `wartosci(lista, xa, xb, xm, rodzaj)` | Wartości ograniczenia (min dla wierzchu, max dla spodu) na końcach przedziału xa…xb; aktywne te, które obejmują xm. |
| 87 | `liniowa(g, x)` | Wartość ograniczenia liniowego [x0, x1, z0, z1] w punkcie x. |
| 93 | `zawiera?(prof, x, y, z, eps = 1e-6)` | Czy punkt (x, y, z) w układzie bala jest wewnątrz bryły (ściśle, z marginesem eps). |
| 106 | `objetosc(prof)` | Objętość bryły z profilu [mm³]. |
| 113 | `obrocone(dl, cechy)` | Cechy po obrocie bala o 180° wokół osi pionowej (x → dl − x, lica zamienione). |
| 123 | `podpis(dl, t, h, cechy)` | Podpis bala (tekst) – równe podpisy = identyczna bryła (te same wymiary i obróbki). |
| 132 | `podpis_kanoniczny(dl, t, h, cechy)` | Podpis kanoniczny: [podpis, obrócony?] – mniejszy z podpisów bala i bala obróconego o 180°. |

### rdzen/geometria.rb (221 wierszy)

działania na punktach 2D/3D (tablice [x, y] / [x, y, z] w mm) bez API SketchUpa.

Zależy od: –
Używają: wszystkie pliki rdzen/

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `module Geometria` |  |
| 17 | `TOL` | Tolerancja położenia [mm] – punkty bliżej siebie są tym samym punktem. |
| 19 | `TOL_KATA` | Tolerancja kąta [rad] przy sprawdzaniu równoległości (≈ 0,5°). |
| 24 | `sub(a, b)` | Różnica a − b (2D). |
| 29 | `add(a, b)` | Suma a + b (2D). |
| 34 | `mul(a, k)` | Wektor razy liczba (2D). |
| 39 | `dot(a, b)` | Iloczyn skalarny (2D). |
| 44 | `cross(a, b)` | Iloczyn wektorowy – składowa z (2D). |
| 49 | `dl(a)` | Długość wektora (2D). |
| 54 | `odl(a, b)` | Odległość punktów (2D). |
| 59 | `norm(a)` | Wektor jednostkowy (2D); zerowy zostaje zerowy. |
| 65 | `lewa(a)` | Wektor obrócony o +90° (w lewo). |
| 70 | `obroc(p, kat)` | Punkt obrócony o kąt [rad] wokół początku układu. |
| 77 | `rowne?(a, b, tol = TOL)` | Czy punkty są równe w tolerancji. |
| 82 | `rzut(p, a, b)` | Rzut punktu p na prostą a→b: [t (0..1 na odcinku), odległość od prostej, punkt rzutu]. |
| 92 | `na_odcinku?(p, a, b, tol = TOL)` | Czy punkt leży na odcinku a–b (z końcami) w tolerancji tol. |
| 100 | `przeciecie(a, b, c, d, tol = TOL)` | Przecięcie odcinków a–b i c–d: [punkt, ta, tc] albo nil (równoległe lub rozłączne). |
| 115 | `przeciecie_prostych(a, b, c, d)` | Przecięcie prostych (nie odcinków) a→b i c→d; nil dla równoległych. |
| 125 | `pole(punkty)` | Pole wielokąta ze znakiem (dodatnie = przeciwnie do ruchu wskazówek zegara). |
| 137 | `wewnatrz?(p, punkty)` | Czy punkt jest wewnątrz wielokąta (promień w prawo; brzeg – nieokreślony). |
| 154 | `zaokr(x, krok = 0.001)` | Zaokrąglenie do siatki tol (usuwa szum obliczeń przy porównaniach i kluczach). |
| 159 | `klucz(p, krok = 0.001)` | Klucz punktu do słowników (zaokrąglony). |
| 164 | `txt(pt)` | Punkt do komunikatu: „(x; y)” w mm. |
| 169 | `sub3(a, b)` | Różnica a − b (3D). |
| 174 | `cross3(a, b)` | Iloczyn wektorowy (3D). |
| 179 | `dot3(a, b)` | Iloczyn skalarny (3D). |
| 184 | `dl3(a)` | Długość wektora (3D). |
| 189 | `scal_przedzialy(przedzialy, tol = TOL)` | Suma przedziałów [a, b] (scalanie zachodzących i stykających się w tolerancji). |
| 203 | `odejmij_przedzialy(a, b, dziury, tol = TOL)` | Przedział [a, b] pomniejszony o listę przedziałów (wynik: lista kawałków o długości > tol). |

### rdzen/kontrola.rb (136 wierszy)

kontrola wyniku – kolizje bali w słupach zamków, mijanka styków w sąsiednich wieńcach, długości bali.

Zależy od: rdzen/bryla.rb, rdzen/bale.rb (polozenie), rdzen/zamek.rb (bale_w_zamku), rdzen/parametry.rb
Używają: testy, sketchup/sterowanie.rb (menu „Kontrola”)

| Wiersz | Element | Opis |
|---:|---|---|
| 20 | `module Kontrola` |  |
| 24 | `wszystko(plan)` | Wszystkie kontrole: { kolizje: [...], mijanka: [...], za_dlugie: [...] } (puste listy = w porządku). |
| 29 | `kolizje(plan)` | Kolizje w słupach zamków: [{ sciany: [id, id], punkt: [x, y], bale: [nr, nr], z: [z0, z1], objetosc: mm³ }]. |
| 48 | `kolizje_slupa(bale, pt, t, p, profile, ids)` | Kolizje w jednym słupie zamka (środek pt, bok t + 2 mm). |
| 89 | `globalny(pol, lx, ly, lz)` | Punkt bala (układ bala) w układzie domu. |
| 95 | `zawiera_globalnie?(pol, prof, c)` | Czy punkt domu leży w bryle bala. |
| 104 | `mijanka(plan)` | Naruszenia mijanki: [{ sciana:, wieniec:, odstep: }] – styki w sąsiednich wieńcach bliżej niż MIJANKA_MIN. |
| 128 | `za_dlugie(plan)` | Bale dłuższe od maksymalnej długości: [{ sciana:, nazwa:, dl: }]. |

### rdzen/obrys.rb (292 wierszy)

rozpoznanie narysowanych linii – zamknięty obrys (lico zewnętrzne), osie ścian działowych, znaczniki kontrforów.

Zależy od: rdzen/geometria.rb, rdzen/parametry.rb
Używają: rdzen/projekt.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `module Obrys` |  |
| 25 | `rozpoznaj(segmenty, p)` | Rozpoznanie linii: { kat:, obrys:, dzialowe:, kontrfory:, ostrzezenia:, bledy: } (układ lokalny). |
| 57 | `kat_ukladu(odc)` | Kąt układu lokalnego = kierunek najdłuższej linii (0 ≤ kąt < 90°). |
| 67 | `rozdziel(lok, tol)` | Podział na poziome / pionowe (wyrównane) i pozostałe – linie w postaci {a:, b:, poz:} (a < b). |
| 89 | `scal(linie, os, tol)` | Scalanie linii leżących na jednej prostej (różnica położenia ≤ tol) i zachodzących / stykających się. os: 1 – linie poziome (poz = y), 0 – pionowe (poz = x, znacznik pion: true). |
| 114 | `przyciagnij_konce(poziome, pionowe, tol)` | Końce linii bliskie linii prostopadłej (≤ tol) są do niej dociągane – narożniki i styki T się zamykają. |
| 132 | `obwiednia(poziome, pionowe, tol)` | Zewnętrzna pętla grafu linii (po odcięciu wiszących końców): wierzchołki obrysu przeciwnie do wskazówek zegara. |
| 188 | `najbardziej_w_prawo(biezacy, kier, poprzedni, krawedzie, wezly)` | Następny węzeł obwiedni: skręt w prawo, prosto, w lewo – w tej kolejności (zewnętrze zostaje po prawej). |
| 202 | `uprosc(punkty, tol)` | Usuwa wierzchołki leżące na prostej między sąsiadami. |
| 221 | `klasyfikuj(linie, obrys, p, tol, wynik)` | Podział pozostałych linii na osie ścian działowych i znaczniki kontrforów. |
| 250 | `konce(l)` | Końce linii {a:, b:, poz:} jako punkty (poziome mają poz = y, pionowe poz = x). |
| 259 | `przeciecie_wewnetrzne(s, w, tol)` | Punkt przecięcia leżący wewnątrz obu odcinków (nie na końcach odcinka s) albo nil. |
| 268 | `przytnij_do_obrysu(s, obrys, boki, tol, wynik)` | Oś działowej przycięta do obrysu (część poza obrysem odrzucona z ostrzeżeniem); nil gdy całość na zewnątrz. |

### rdzen/otwory.rb (107 wierszy)

otwory okienne i drzwiowe – położenie na ścianie, sprawdzenie, cięcia bali w każdym wieńcu.

Zależy od: rdzen/geometria.rb, rdzen/parametry.rb
Używają: rdzen/projekt.rb, rdzen/bale.rb, rdzen/styki.rb (omijanie otworów)

| Wiersz | Element | Opis |
|---:|---|---|
| 20 | `module Otwory` |  |
| 22 | `TOL_Z` | Bal przecięty otworem na wysokości mniejszej niż tyle [mm] traktujemy jak cały w otworze. |
| 27 | `przypisz(wejscie, sciany, p, wysokosc_sciany)` | Przypisanie otworów do ścian (w[:otwory]); zwraca listę ostrzeżeń. |
| 71 | `dla_wienca(w, z0, h)` | Cięcia w wieńcu [z0, z0 + h]: { pelne: [[s0, s1]] – bal przerwany, wyciecia: [{ s0:, s1:, strona:, gleb: }], uwagi: [] }. |
| 95 | `w_otworze?(w, s, z0, z1)` | Czy w miejscu s ściany jest otwór na wysokości [z0, z1] (do kontrforów i styków). |
| 102 | `strefy_zakazane(w, zapas)` | Przedziały s zajęte przez otwory poszerzone o zapas (do wyboru miejsc styków i kontrforów). |

### rdzen/parametry.rb (175 wierszy)

wartości domyślne, presety przekroju bala z wymiarami zamka, opisy pól okna i sprawdzenie parametrów.

Zależy od: log.rb
Używają: rdzen/projekt.rb (normalizacja), wszystkie pliki rdzen/ (odczyt), sketchup/okno.rb (opisy pól)

| Wiersz | Element | Opis |
|---:|---|---|
| 18 | `module Parametry` |  |
| 20 | `MIJANKA_MIN` | Wymóg użytkownika: styki w sąsiednich wieńcach przesunięte co najmniej o tyle [mm]. |
| 23 | `PRESETY` | Presety przekroju: wymiary bala i zamka [mm]. Klucze zamka czyta rdzen/zamek.rb. |
| 37 | `DOMYSLNE` |  |
| 57 | `OPISY` | Opisy pól okna: klucz => [etykieta, jednostka, min, max, rodzaj]; rodzaj: :liczba \| :calkowita \| :wybor. |
| 77 | `OPISY_ZAMKA` | Opisy wymiarów zamka w oknie: klucz presetu => [etykieta, jednostka]. |
| 85 | `WYBORY` | Wartości pól wyboru: klucz => [[wartość, opis], ...]. |
| 95 | `normalizuj(wejscie)` | Pełny zestaw parametrów z wartości użytkownika: [parametry, ostrzeżenia]. Zamek – z presetu lub własny. |
| 130 | `zamek_z(wlasny, preset, uwagi)` | Wymiary zamka: preset uzupełniony wartościami użytkownika (sprawdzone, czy zamek się mieści). |
| 151 | `grubosc(p)` | Grubość ściany [mm]. |
| 156 | `krycie(p)` | Rozstaw wieńców = wysokość bryły bala prostego [mm]. |
| 161 | `liczba(v)` | Liczba z tekstu lub liczby (przecinek dziesiętny dozwolony); nil gdy się nie da. |
| 169 | `fmt(v)` | Liczba do komunikatu (bez zbędnego ,0). |

### rdzen/pozycje.rb (71 wierszy)

numeracja pozycji jak u producenta – identyczne bale (ta sama bryła, także po obrocie o 180°) dostają jedną pozycję „nr-długość”.

Zależy od: rdzen/bryla.rb, rdzen/parametry.rb
Używają: rdzen/projekt.rb, sketchup/budowa.rb (jedna definicja komponentu na pozycję)

| Wiersz | Element | Opis |
|---:|---|---|
| 20 | `module Pozycje` |  |
| 24 | `numeruj(bale, p)` | Pozycje wszystkich bali (lista w kolejności numerów). |
| 50 | `posortowane(bale)` | Bale w kolejności numeracji: numer ściany, wieniec, położenie wzdłuż ściany. |
| 55 | `prefiks_bala(b)` | Prefiks grupy w Dokumentacji 2D: bale ścienne (Bs) albo kontrfory (Kf). |
| 60 | `lista_zamowienia(pozycje, p)` | Lista do zamówienia: [{ nazwa:, prefiks:, przekroj:, dl:, ilosc:, objetosc_m3: }] (przekrój jak w listach producenta). |

### rdzen/projekt.rb (85 wierszy)

przebieg obliczeń domu od linii do listy bali (kolejność kroków) i podsumowanie do okna – bez API SketchUpa.

Zależy od: wszystkie pliki rdzen/
Używają: sketchup/sterowanie.rb, testy

| Wiersz | Element | Opis |
|---:|---|---|
| 25 | `module Projekt` |  |
| 29 | `oblicz(wejscie)` | Cały przebieg: obrys → ściany → otwory → styki (kontrfory) → bale → zamki → pozycje. |
| 61 | `podsumowanie(plan)` | Podsumowanie do okna: ściany, liczby bali i pozycji, objętość i waga, wysokości. |
| 79 | `siatka_pozycji(poz)` | Siatka bryły pozycji (do budowy komponentu): Siatka.z_profilu dla profilu pozycji. |

### rdzen/sciany.rb (244 wierszy)

ściany z rozpoznanego obrysu – osie, zasięgi bali z ostatkami, skrzyżowania, kontrfory, kierunek względem kalenicy, numeracja W-n.

Zależy od: rdzen/geometria.rb, rdzen/parametry.rb
Używają: rdzen/projekt.rb, rdzen/styki.rb (dodaj_kontrfor), rdzen/wience.rb, rdzen/bale.rb, rdzen/zamek.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `module Sciany` |  |
| 27 | `zbuduj(obrys, p)` | Ściany i skrzyżowania z obrysu: { sciany:, os_kalenicy:, ostrzezenia:, bledy: } (bez numeracji – numeruj!). |
| 55 | `os_kalenicy(obrys_pts, wybor)` | Oś kalenicy :x / :y w układzie lokalnym (kierunek ścian okapowych z półbalem). |
| 69 | `zewnetrzne(pts, t, p, licznik, wynik)` | Ściany zewnętrzne: oś = bok obrysu przesunięty do środka o pół grubości, narożniki = przecięcia osi. |
| 97 | `dzialowe(linie, zewn, t, p, licznik, wynik, tol)` | Ściany działowe: końce na obrysie lub na innej działowej = połączenie T (ostatek), pozostałe = wolny koniec. |
| 125 | `przy_boku?(pt, bok, zasieg)` | Czy punkt leży na boku obrysu lub w jego pobliżu po stronie ściany (koniec działowej dosunięty do lica). |
| 131 | `sciana(licznik, rodzaj, a, b, d)` | Nowa ściana (bez zasięgu): wspólne pola. |
| 139 | `wyznacz_skrzyzowania(sciany, tol)` | Skrzyżowania wszystkich par ścian prostopadłych, których osie się przecinają (narożniki, T, X). |
| 152 | `polacz(w1, w2, pt)` | Zapis skrzyżowania w obu ścianach (typ: :naroznik, :t, :x, :kontrfor). |
| 161 | `typ_skrzyzowania(w1, s1, w2, s2)` | Rodzaj skrzyżowania z położenia na osiach (koniec osi = 0 lub dl_osi). |
| 171 | `gospodarz_kontrforu(pt, sciany, zasieg)` | Ściana-gospodarz kontrforu: ściana, do której osi punkt jest najbliżej (≤ zasięg); [ściana, s] albo [nil, nil]. |
| 183 | `sprawdz_miejsce_kontrforu(w, s, p)` | Czy kontrfor w miejscu s ściany w nie wchodzi w zamek innego skrzyżowania; tekst błędu albo nil. |
| 193 | `dodaj_kontrfor(sciany, gosp, s, p, zrodlo, os_kalenicy)` | Nowy kontrfor (słupek z odcinków 2 × ostatek + grubość) w miejscu s ściany-gospodarza; zwraca ścianę kontrforu. |
| 210 | `numeruj!(sciany)` | Numeracja W-n: zewnętrzne od dolnego lewego narożnika przeciwnie do wskazówek zegara, potem działowe, potem kontrfory. |
| 230 | `punkt(w, s)` | Punkt 2D na osi ściany w odległości s od początku a. |
| 235 | `opis_rodzaju(w)` | Opis rodzaju ściany do okna i list. |

### rdzen/siatka.rb (340 wierszy)

siatka ścian (płaskich wielokątów z otworami) zamkniętej bryły bala z profilu – do budowy komponentu w SketchUpie.

Zależy od: rdzen/bryla.rb
Używają: sketchup/budowa.rb, testy/t_siatka.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 20 | `module Siatka` |  |
| 22 | `KLUCZ` | Krok klucza wierzchołka [mm]. |
| 27 | `z_profilu(prof)` | Siatka bryły z profilu (patrz Bryla.profil): { sciany: [...], wierzcholki: n }. |
| 35 | `sciany_surowe(prof)` | Ściany przedziałów i czoła, każda: { n: normalna, p: [punkty] } (kolejność przeciwna do wskazówek patrząc z zewnątrz). |
| 57 | `czolo(x, lewy, prawy)` | Czoło w płaszczyźnie x: komórki przekroju lewego bez prawego (normalna +x) i prawego bez lewego (−x). |
| 86 | `normalna(pts)` | Normalna jednostkowa trójkąta a, b, c. |
| 96 | `klucz(pt)` | Klucz wierzchołka (zaokrąglone współrzędne). |
| 101 | `punkty_t(sciany)` | Wstawia do krawędzi ścian wierzchołki innych ścian, które na nich leżą (siatka bez punktów T). |
| 119 | `indeks_osi(wszystkie)` | Indeks wierzchołków dla krawędzi równoległych do osi: klucz pozostałych dwóch współrzędnych → punkty. |
| 130 | `kandydaci(a, b, idx)` | Wierzchołki, które mogą leżeć na krawędzi a–b (dla krawędzi wzdłuż osi – tylko z tej samej prostej). |
| 140 | `na_krawedzi(a, b, lista)` | Wierzchołki leżące wewnątrz odcinka a–b, uporządkowane od a. |
| 160 | `bez_powtorzen(pts)` | Usuwa kolejne powtórzone punkty pętli. |
| 168 | `scal(sciany)` | Scalanie ścian tej samej płaszczyzny: krawędzie przeciwne się znoszą, z reszty powstają pętle (zewnętrzne i otwory). |
| 203 | `pety(krawedzie, punkty, n)` | Pętle z krawędzi skierowanych (na rozwidleniu – najostrzejszy skręt w lewo względem normalnej). |
| 235 | `skret(a, b, c, n)` | Kąt skrętu w lewo (−π…π) przy przejściu a → b → c, patrząc wzdłuż normalnej. |
| 245 | `uloz(petle, n)` | Podział pętli na zewnętrzne (pole dodatnie względem normalnej) i otwory przypisane do zawierającej je pętli. |
| 258 | `pole(pts, n)` | Pole pętli ze znakiem względem normalnej. |
| 272 | `wewnatrz?(pt, petla, n)` | Punkt wewnątrz pętli (rzut na płaszczyznę bez największej składowej normalnej). |
| 292 | `uprosc(sciany)` | Siatka do rysowania: usunięte wierzchołki leżące na prostej we wszystkich pętlach, w których występują (zostają tylko narożniki i punkty styku z innymi ścianami – krawędzie sąsiednich ścian dalej się pokrywają). |
| 310 | `wspolliniowy?(a, b, c)` | Czy b leży na prostej a–c między nimi (przejście na wprost). |
| 318 | `sprawdz(sciany)` | Kontrola siatki: { zamknieta:, objetosc:, bledne_krawedzie: } – każda krawędź raz w każdą stronę. |

### rdzen/styki.rb (171 wierszy)

podział długich ścian na bale – wybór miejsc styków na mijankę (min. 300 mm), dostawianie kontrforów.

Zależy od: rdzen/geometria.rb, rdzen/parametry.rb, rdzen/sciany.rb (dodaj_kontrfor), rdzen/otwory.rb (strefy otworów)
Używają: rdzen/projekt.rb, rdzen/bale.rb (pozycje_w_wiencu)

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `module Styki` |  |
| 25 | `KROK` | Krok przesuwania nowego kontrforu przy szukaniu wolnego miejsca [mm]. |
| 30 | `planuj(sciany, p, os_kalenicy)` | Miejsca styków dla wszystkich ścian (zewnętrznych i działowych); dostawia kontrfory. Zwraca ostrzeżenia. |
| 51 | `dobierz(w, p)` | Regiony łączenia [{ a:, b:, nowe: [s nowych kontrforów] }] albo nil; próbuje coraz większej liczby bali. |
| 64 | `proba(w, p, m)` | Jedna próba podziału na m bali: regiony przy punktach docelowych s_od + j·dł/m. |
| 81 | `najlepszy_region(w, p, cel, okno, zajete)` | Najlepszy region przy punkcie cel: najmniej nowych kontrforów, potem najbliżej celu. |
| 114 | `kotwice(w, p)` | Istniejące skrzyżowania wewnątrz ściany, w których może wypaść styk (bez narożników i otworów). |
| 123 | `miejsce_ok?(w, p, s, zajete)` | Czy w miejscu s można postawić nowy kontrfor (odstęp od skrzyżowań, otworów, końców ściany). |
| 134 | `styki_poza_zamkami?(w, p, x)` | Układ jeden_kontrfor: oba styki x ± mijanka/2 poza zamkami innych skrzyżowań (z zapasem grubości) i poza otworami. |
| 144 | `wolne_miejsce(w, _p, cel, okno, _zajete)` | Najbliższe celu miejsce (krok KROK, w oknie ± okno), dla którego blok zwraca prawdę; nil gdy brak. |
| 156 | `kawalki_ok?(w, regiony, lmax)` | Czy wszystkie kawałki (wieńce parzyste i nieparzyste) mieszczą się w maksymalnej długości. |
| 164 | `pozycje_w_wiencu(w, i)` | Położenia styków w wieńcu o indeksie i (0 = najniższy wieniec ściany). |

### rdzen/wience.rb (61 wierszy)

poziomy wieńców każdej ściany – półbal na dole ścian wzdłuż kalenicy, liczba wieńców, wysokości ścian.

Zależy od: rdzen/parametry.rb
Używają: rdzen/bale.rb, rdzen/projekt.rb (wysokości do okna)

| Wiersz | Element | Opis |
|---:|---|---|
| 18 | `module Wience` |  |
| 22 | `dla_sciany(w, p)` | Wieńce ściany od dołu: [{ nr:, z0:, h:, lvl:, polbal: }]; kontrfor dopasowany do wysokości gospodarza. |
| 33 | `pelna_lista(kierunek, zewnetrzna, p)` | Wieńce według kierunku: A – półbal + n pełnych; B zewnętrzna – n + 1 (początek szczytu); B działowa i kontrfor – n. |
| 48 | `wysokosc(w, p)` | Wysokość ściany = góra najwyższego wieńca [mm]. |
| 54 | `wysokosci(p)` | Wysokości do okna: { okapowa:, szczytowa:, dzialowa_okapowa:, dzialowa_szczytowa: } [mm]. |

### rdzen/zamek.rb (111 wierszy)

obróbki zamka na każdym skrzyżowaniu – gniazda górne/dolne i podcięcia boczne bali (zamek 44 × 146 z rysunku IMG-20250930-WA0005).

Zależy od: rdzen/parametry.rb
Używają: rdzen/projekt.rb, testy/t_zamek.rb (sprawdzenie kolizji)

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `module Zamek` |  |
| 24 | `ORIENTACJA` | Kierunek (w układzie lokalnym domu), w którym podcięcie lica o mniejszej współrzędnej wychodzi za lico ściany poprzecznej: ściany wzdłuż X – lico południowe (min y), ściany wzdłuż Y – lico zachodnie (min x). |
| 29 | `nanies(sciany, p, orientacja = ORIENTACJA)` | Obróbki zamków dla wszystkich skrzyżowań (dopisuje cechy do bali); zwraca liczbę par bali w zamkach. |
| 58 | `bale_w_zamku(w, c, t)` | Bale ściany, które zachodzą na słup zamka [c − t/2, c + t/2]. |
| 63 | `gniazdo(b, c, typ, z)` | Gniazdo (górne lub dolne) w osi c – raz na skrzyżowanie, przycięte do długości bala. |
| 70 | `podciecia(b, c, z, orientacja)` | Podcięcia boczne obu lic bala przy skrzyżowaniu w osi c (strona 0 – lico prawe y = 0, strona 1 – lico lewe y = t). |
| 82 | `kierunek_lica_prawego(w, orientacja)` | Kierunek (−1 / +1 wzdłuż s ściany), w którym podcięcie lica prawego wychodzi za lico ściany poprzecznej. |
| 96 | `dodaj_ceche(b, cecha)` | Dopisanie cechy przyciętej do bala (pomija powtórkę tej samej obróbki w tej samej osi). |
| 106 | `odl2(a, b)` | Odległość punktów 2D (pomocnicza, bez zależności od geometria.rb). |

### sketchup/atrybuty.rb (106 wierszy)

atrybuty w modelu – zgodność z Dokumentacją 2D (słownik ArteMadera) i zapis wejścia generatora do przebudowy.

Zależy od: log.rb
Używają: sketchup/budowa.rb, sketchup/wejscie.rb, sketchup/sterowanie.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module Atrybuty` |  |
| 23 | `DICT_AM` |  |
| 24 | `DICT_GW` |  |
| 29 | `dom?(ent)` | Czy encja to grupa domu z generatora. |
| 34 | `zapisz_dom(grupa, wejscie, dom_id, kompilacja)` | Zapis wejścia (segmenty, parametry, otwory, z0) i identyfikatora domu na grupie. |
| 42 | `czytaj_wejscie(grupa)` | Wejście zapisane na grupie domu (Hash) albo nil. |
| 52 | `dom_id(grupa)` | Identyfikator domu (wiąże grupę z jej definicjami bali). |
| 57 | `oznacz_definicje(defn, poz, dom_id, przekroj)` | Oznaczenie definicji bala dla Dokumentacji 2D i generatora. |
| 69 | `oznacz_instancje(inst, b)` | Oznaczenie instancji bala (ściana, wieniec, pozycja). |
| 77 | `podpis(grupa)` | Podpis zawartości domu: definicje i położenia instancji (zmiana = ręczna poprawka po generowaniu). |
| 95 | `zapisz_podpis(grupa)` | Zapis podpisu po budowie. |
| 100 | `zmieniony_recznie?(grupa)` | Czy dom zmieniono ręcznie od ostatniego generowania. |

### sketchup/budowa.rb (136 wierszy)

budowa domu w modelu – grupa domu > grupy ścian W-n > instancje komponentów bali, tagi, usuwanie poprzedniej wersji.

Zależy od: rdzen/projekt.rb (siatka pozycji), rdzen/siatka.rb, sketchup/konwersja.rb, sketchup/atrybuty.rb, log.rb
Używają: sketchup/sterowanie.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 18 | `module Budowa` |  |
| 20 | `TAGI` | Tagi (dawniej warstwy) według rodzaju ściany. |
| 29 | `zbuduj(model, plan, wejscie, istniejaca = nil)` | Budowa domu z planu; istniejąca – grupa poprzedniej wersji do zastąpienia. Zwraca { grupa:, definicje:, sciany_bez_scian: }. |
| 71 | `definicja(model, poz, p, dom_id)` | Definicja komponentu pozycji z siatki bryły; zwraca [definicja, liczba ścian, których nie udało się narysować]. |
| 86 | `rysuj_sciane(ents, s)` | Ściana bryły: pętla zewnętrzna, otwory (dorysowane i usunięte), zwrot zgodny z normalną siatki. |
| 107 | `rownolegla?(f, n)` | Czy ściana SketchUpa leży równolegle do normalnej siatki (po podziale ściany przy otworze). |
| 113 | `przygotuj_tagi(model)` | Tagi według rodzaju ściany (zakładane, gdy ich nie ma). |
| 122 | `usun_dom(model, grupa)` | Usunięcie poprzedniej wersji domu i jej nieużywanych definicji bali. |

### sketchup/konwersja.rb (64 wierszy)

przeliczenia między rdzeniem (mm, tablice) a SketchUpem (cale, Geom::Point3d, Geom::Transformation).

Zależy od: rdzen/bale.rb (polozenie), rdzen/parametry.rb
Używają: sketchup/budowa.rb, sketchup/wejscie.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `module Konwersja` |  |
| 15 | `CAL` |  |
| 20 | `cal(mm)` | Milimetry → cale (jednostka wewnętrzna SketchUpa). |
| 25 | `mm(cale)` | Cale → milimetry. |
| 30 | `punkt(xyz)` | Punkt SketchUpa z [x, y, z] w mm. |
| 35 | `z_punktu(pt)` | Punkt [x, y, z] w mm z punktu SketchUpa. |
| 40 | `transformacja_domu(kat, z0)` | Transformacja grupy domu: obrót o kąt układu lokalnego wokół początku modelu i podniesienie na poziom z0 [mm]. |
| 48 | `transformacja_bala(b, p)` | Transformacja instancji bala w grupie domu; bal obrócony – początek na drugim końcu, osie x i y odwrócone. |

### sketchup/menu.rb (40 wierszy)

menu Rozszerzenia → ArteMadera Generator Wieńcowy (generuj / edytuj, kontrola, o wtyczce).

Zależy od: sketchup/sterowanie.rb, log.rb
Używają: main.rb (ładowanie)

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `module Menu` |  |
| 18 | `dodaj` | Dodanie menu (raz na sesję SketchUpa). |
| 31 | `o_wtyczce` | Okno z wersją i numerem kompilacji. |

### sketchup/okno.rb (115 wierszy)

okno parametrów (UI::HtmlDialog) – dane startowe dla okna, wywołania z JavaScriptu, wyniki do okna.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb, sketchup/sterowanie.rb, log.rb
Używają: sketchup/sterowanie.rb (pokaz)

| Wiersz | Element | Opis |
|---:|---|---|
| 18 | `module Okno` |  |
| 19 | `SZEROKOSC` |  |
| 20 | `WYSOKOSC` |  |
| 26 | `pokaz(dane)` | Otwarcie okna z danymi startowymi (tryb: 'nowy' \| 'edycja'). |
| 43 | `dane_startowe` | Dane startowe okna: pola formularza, wartości, presety, informacja o liniach / domu. |
| 52 | `opisy_pol` | Opisy pól z Parametry::OPISY w postaci dla JavaScriptu. |
| 60 | `wyslij_wynik(dane)` | Wynik obliczeń lub budowy do okna. |
| 70 | `podlacz(dlg)` | Wywołania z JavaScriptu. |
| 107 | `zamknij_stare` | Zamknięcie poprzedniego okna generatora. |

### sketchup/sterowanie.rb (134 wierszy)

przebieg pracy z menu – start (linie albo dom do edycji), podgląd, generowanie, kontrola; dane wyniku dla okna.

Zależy od: rdzen/projekt.rb, rdzen/kontrola.rb, sketchup/wejscie.rb, sketchup/budowa.rb, sketchup/atrybuty.rb, sketchup/okno.rb, log.rb
Używają: sketchup/menu.rb, sketchup/okno.rb (wywołania z okna)

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `module Sterowanie` |  |
| 20 | `start` | Menu „Generuj / edytuj”: zaznaczone linie → nowy dom, zaznaczony dom → edycja parametrów. |
| 47 | `podglad(dane)` | Podgląd z okna: obliczenia bez zmian w modelu. |
| 53 | `generuj(dane)` | Generowanie z okna: obliczenia i budowa (zastępuje edytowany dom). |
| 76 | `kontrola` | Menu „Kontrola”: kolizje w zamkach, mijanka, długości dla zaznaczonego domu. |
| 95 | `scal(dane)` | Wejście domu: zapamiętane linie i poziom + parametry i otwory z okna. |
| 102 | `dla_okna(plan)` | Wynik dla okna (tylko typy JSON): błędy, ostrzeżenia, ściany, lista bali, rzut. |
| 116 | `rzut(plan)` | Rzut do okna: obrys i ściany (bale od końca do końca) w mm układu lokalnego. |
| 126 | `klucze_tekstowe(h)` | Hash z kluczami symbolami → kluczami tekstowymi (do JSON). |

### sketchup/wejscie.rb (61 wierszy)

odczyt zaznaczenia – narysowane linie (obrys, osie działowych, kontrfory) albo istniejący dom z generatora.

Zależy od: sketchup/konwersja.rb, sketchup/atrybuty.rb, log.rb
Używają: sketchup/sterowanie.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `module Wejscie` |  |
| 18 | `TOL_Z` | Linie różniące się wysokością o więcej niż tyle [mm] nie leżą w jednej płaszczyźnie. |
| 23 | `z_zaznaczenia(model)` | Wynik: { dom: grupa } \| { segmenty: [...], z0: mm } \| { blad: tekst }. |
| 47 | `zbierz(lista, tr, wynik, glebokosc)` | Krawędzie z zaznaczenia (także z wnętrza grup i komponentów, z ich przekształceniem). |

### html/okno.css (105 wierszy)

wygląd okna parametrów.

Zależy od: –
Używają: html/okno.html

### html/okno.html (101 wierszy)

okno parametrów generatora – układ sekcji (formularz budowany przez okno.js z opisów pól z Ruby).

Zależy od: html/okno.css, html/okno.js
Używają: sketchup/okno.rb

### html/okno.js (492 wierszy)

logika okna parametrów – formularz z opisów pól, tabela otworów, rzut SVG, wyniki, wywołania Ruby (sketchup.*).

Zależy od: html/okno.html, html/okno.css
Używają: sketchup/okno.rb (AMGW.init, AMGW.wynik)

| Wiersz | Element | Opis |
|---:|---|---|
| 12 | `AMGW` |  |
| 16 | `SEKCJE` | Sekcja okna dla klucza parametru (klucz spoza listy trafia do „Rozpoznanie rysunku i waga”). |
| 23 | `OKNO_DOMYSLNE` |  |
| 24 | `DRZWI_DOMYSLNE` |  |
| 32 | `el(tag, atrybuty, tekst)` | Nowy element z atrybutami i tekstem. |
| 45 | `wyczysc(e)` | Usunięcie zawartości elementu. |
| 48 | `liczba(v)` | Liczba z tekstu (przecinek dziesiętny dozwolony); null, gdy to nie liczba. |
| 55 | `fmt(v)` | Liczba do wyświetlenia (bez zbędnego ,0). |
| 62 | `wywolaj(nazwa, dane)` | Wywołanie Ruby (window.sketchup.nazwa) – poza SketchUpem nic nie robi. |
| 71 | `zbudujFormularz(parametry)` | Formularz z opisów pól (Parametry::OPISY) i wymiary zamka. |
| 82 | `dodajPole(opis, parametry)` | Jedno pole parametru w swojej sekcji (lista wyboru albo pole liczby). |
| 114 | `listaPresetow()` | Presety przekroju do listy wyboru. |
| 124 | `zbudujZamek(parametry)` | Pola wymiarów zamka: wartości własne albo z presetu. |
| 143 | `zbierzParametry()` | Parametry z formularza (z wymiarami zamka) do wysłania do Ruby. |
| 158 | `dodajOtwor(o)` | Wiersz otworu w tabeli (ściana, od, szerokość, wysokość, parapet, nazwa). |
| 185 | `wypelnijSciany(sel, wybrana)` | Lista ścian dla otworu (bez kontrforów); brakująca ściana zostaje z dopiskiem. |
| 204 | `zbierzOtwory()` | Otwory z tabeli do wysłania do Ruby. |
| 219 | `odswiezScianyOtworow()` | Odświeżenie list ścian w tabeli otworów po podglądzie. |
| 226 | `pierwszaSciana()` | Pierwsza ściana (nie kontrfor) – domyślna dla nowego otworu. |
| 237 | `rysujRzut(rzut)` | Rzut SVG: obrys, ściany, kontrfory, otwory, punkty odniesienia i opisy W-n. |
| 313 | `miejsceOpisu(s, kf, srodek, gr)` | Miejsce opisu na rzucie: [x, y, wyrównanie]; ściana – obok środka po stronie od środka obrysu, kontrfor – za końcem. |
| 341 | `pokazKomunikat(tekst, rodzaj)` | Komunikat nad formularzem (ok / blad). |
| 348 | `ukryjKomunikat()` | Ukrycie komunikatu. |
| 351 | `lista(idBox, pozycje, klasa)` | Lista błędów lub ostrzeżeń. |
| 362 | `wiersz(tbody, komorki, liczbowe)` | Wiersz tabeli wyników. |
| 374 | `pokazWynik(d)` | Wyniki: liczby, wysokości, tabela ścian, lista bali, rzut, błędy i ostrzeżenia. |
| 419 | `dane()` | Dane formularza jako JSON (parametry i otwory). |
| 422 | `zaplanujPodglad()` | Podgląd po zmianie pola (z opóźnieniem 350 ms – kilka zmian = jedno wywołanie). |
| 428 | `init(d)` | Start okna danymi z Ruby (AMGW.init). |
| 442 | `wynik(d)` | Wynik z Ruby (AMGW.wynik) – po podglądzie albo generowaniu. |
| 459 | `start()` | Podpięcie przycisków i zgłoszenie gotowości okna do Ruby. |

### testy/atrapa/extensions.rb (3 wierszy)

–


### testy/atrapa/sketchup.rb (608 wierszy)

atrapa API SketchUpa (Geom, Sketchup::Model/Entities/Group/ComponentDefinition/Face/Edge, UI) do testów bez SketchUpa.

Zależy od: –
Używają: testy/t_sketchup.rb, testy/pomoc.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `module Geom` |  |
| 15 | `class Vector3d` |  |
| 18 | `initialize(x = 0.0, y = 0.0, z = 0.0)` |  |
| 24 | `to_a` |  |
| 28 | `length` |  |
| 32 | `normalize` |  |
| 37 | `dot(v)` |  |
| 41 | `cross(v)` |  |
| 50 | `class Point3d` |  |
| 53 | `initialize(x = 0.0, y = 0.0, z = 0.0)` |  |
| 64 | `to_a` |  |
| 68 | `transform(tr)` |  |
| 80 | `==(other)` |  |
| 85 | `class Transformation` |  |
| 89 | `initialize(m = nil)` | Macierz 4 × 4 wierszami: [xaxis, yaxis, zaxis] w kolumnach, origin w ostatniej kolumnie. |
| 93 | `axes(origin, xa, ya, za)` |  |
| 107 | `zastosuj(p)` |  |
| 113 | `origin` |  |
| 117 | `xaxis` |  |
| 121 | `yaxis` |  |
| 125 | `zaxis` |  |
| 129 | `to_a` |  |
| 135 | `module Sketchup` |  |
| 136 | `class Atrybutowy` |  |
| 137 | `atrybuty` |  |
| 141 | `set_attribute(dict, key, value)` |  |
| 145 | `get_attribute(dict, key, domyslna = nil)` |  |
| 150 | `delete_attribute(dict, key = nil)` |  |
| 155 | `class Vertex` |  |
| 158 | `initialize(pt)` |  |
| 163 | `class Edge` |  |
| 167 | `initialize(a, b)` |  |
| 172 | `valid?` |  |
| 177 | `class Face` |  |
| 181 | `initialize(punkty, entities)` |  |
| 188 | `vertices` |  |
| 193 | `normal` | Normalna z punktów (metoda Newella). |
| 206 | `reverse!` |  |
| 211 | `erase!` |  |
| 216 | `valid?` |  |
| 220 | `classify_point(_pt)` |  |
| 225 | `class Entities` |  |
| 228 | `initialize(parent)` |  |
| 233 | `each(&blk)` |  |
| 237 | `to_a` |  |
| 241 | `length` |  |
| 245 | `grep(klasa)` |  |
| 249 | `add_group(*_args)` |  |
| 255 | `add_instance(defn, tr)` |  |
| 264 | `add_face(*pts)` | Ściana: jeśli w tej samej płaszczyźnie jest już ściana, która zawiera nową w całości – nowa jest „otworem”. |
| 273 | `add_line(a, b)` |  |
| 280 | `usun(e)` |  |
| 288 | `erase_entities(lista)` |  |
| 293 | `class ComponentDefinition` |  |
| 297 | `initialize(name)` |  |
| 303 | `instances` |  |
| 307 | `count_instances` |  |
| 311 | `group?` |  |
| 316 | `class Group` |  |
| 320 | `initialize(rodzic)` |  |
| 329 | `parent` |  |
| 333 | `definition` |  |
| 337 | `erase!` |  |
| 343 | `valid?` |  |
| 348 | `class ComponentInstance` |  |
| 352 | `initialize(defn, tr, rodzic)` |  |
| 360 | `erase!` |  |
| 365 | `valid?` |  |
| 370 | `class DefinitionList` |  |
| 371 | `initialize` |  |
| 375 | `add(name)` |  |
| 387 | `remove(d)` |  |
| 396 | `to_a` |  |
| 400 | `each(&blk)` |  |
| 404 | `length` |  |
| 409 | `class Layer` |  |
| 412 | `initialize(name)` |  |
| 417 | `class Layers` |  |
| 418 | `initialize` |  |
| 422 | `add(nazwa)` |  |
| 430 | `length` |  |
| 435 | `class Selection` |  |
| 436 | `initialize` |  |
| 440 | `to_a` |  |
| 444 | `clear` |  |
| 448 | `add(*e)` |  |
| 453 | `class Model` |  |
| 456 | `initialize` |  |
| 464 | `active_entities` |  |
| 468 | `start_operation(nazwa, *_reszta)` |  |
| 473 | `commit_operation` |  |
| 478 | `abort_operation` |  |
| 489 | `active_model` |  |
| 493 | `require(sciezka)` |  |
| 497 | `register_extension(_ext, _load)` |  |
| 501 | `version` |  |
| 507 | `class SketchupExtension` |  |
| 510 | `initialize(nazwa, sciezka)` |  |
| 516 | `module UI` |  |
| 523 | `messagebox(tekst, _typ = nil)` |  |
| 528 | `menu(_nazwa)` |  |
| 533 | `class Menu` |  |
| 536 | `initialize` |  |
| 540 | `add_submenu(_nazwa)` |  |
| 544 | `add_item(nazwa, &blk)` |  |
| 549 | `add_separator` |  |
| 554 | `class HtmlDialog` |  |
| 555 | `STYLE_DIALOG` |  |
| 558 | `initialize(opcje = {})` |  |
| 565 | `set_file(plik)` |  |
| 569 | `add_action_callback(nazwa, &blk)` |  |
| 573 | `execute_script(js)` |  |
| 577 | `show` |  |
| 581 | `close` |  |
| 585 | `visible?` |  |
| 590 | `wywolaj(nazwa, arg = '')` | Test: wywołanie jak z JavaScriptu. |
| 596 | `MB_YESNO` |  |
| 597 | `IDYES` |  |
| 598 | `IDNO` |  |
| 602 | `file_loaded?(nazwa)` |  |
| 606 | `file_loaded(nazwa)` |  |

### testy/buduj_rbz.rb (28 wierszy)

paczka instalacyjna .rbz (zip rejestratora i folderu wtyczki) – do instalacji w Menedżerze rozszerzeń SketchUpa.

Zależy od: polecenie zip
Używają: zamknięcie rundy (.claude/skills/gw-runda/SKILL.md)

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `KAT` |  |
| 17 | `PLUG` |  |

### testy/okno_dane.rb (28 wierszy)

dane okna z prawdziwego przebiegu (atrapa SketchUpa) – wypisuje JSON { init:, wynik: } dla testu okna w przeglądarce.

Zależy od: testy/atrapa/sketchup.rb, testy/pomoc.rb
Używają: testy/t_okno.js

### testy/podglad.py (71 wierszy)

rysunek 3D domu z pliku OBJ (testy/podglad.rb) – cały dom i zbliżenie narożnika, do sprawdzenia wzrokowego.

Zależy od: testy/podglad.rb, matplotlib
Używają: ręcznie (python3 testy/podglad.py dom.obj wynik.png)

| Wiersz | Element | Opis |
|---:|---|---|
| 17 | `wczytaj(plik)` |  |
| 33 | `rysuj(ax, grupy, filtr=None)` |  |
| 43 | `main()` |  |

### testy/podglad.rb (66 wierszy)

zapis domu testowego do pliku OBJ (siatki pozycji ułożone jak w modelu) – do obejrzenia bez SketchUpa (testy/podglad.py).

Zależy od: testy/pomoc.rb
Używają: testy/podglad.py

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `DOMY` |  |

### testy/pomoc.rb (89 wierszy)

wspólne narzędzia testów – sprawdzenia, licznik błędów, przykładowe obrysy (domy testowe).

Zależy od: Plugins/arte_madera_generator_wiencowy/rdzen/projekt.rb, rdzen/kontrola.rb
Używają: testy/t_*.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `KATALOG_WTYCZKI` |  |
| 18 | `module Testy` |  |
| 26 | `grupa(nazwa)` |  |
| 31 | `sprawdz(warunek, opis)` |  |
| 41 | `rowne(a, b, opis, tol = 0.01)` |  |
| 50 | `koniec` |  |
| 59 | `prostokat(x0, y0, x1, y1)` | Odcinki prostokąta (lico zewnętrzne). |
| 64 | `wielokat(punkty)` | Odcinki wielokąta zamkniętego z listy wierzchołków. |
| 69 | `obroc_odcinki(odcinki, stopnie)` | Obrót odcinków o kąt [stopnie] wokół początku układu. |
| 75 | `podziel(odcinek, *t)` | Podział odcinka na kawałki (jak SketchUp dzieli krawędź w punktach styku). |
| 82 | `plan(segmenty, parametry = {}, otwory = [])` | Plan domu z wejścia (skrót). |
| 87 | `sciana(pl, id)` | Ściana planu po identyfikatorze. |

### testy/spis_tresci.rb (151 wierszy)

generator spisu treści kodu docs/SPIS_TRESCI.md – tematy → pliki, lista plików, metody i stałe z numerami wierszy.

Zależy od: nagłówki plików (Plik:, Zadanie:, Tematy:, Zależy od:, Używają:) i komentarze nad metodami
Używają: testy/uruchom.sh (sprawdzenie aktualności), Claude przy każdej zmianie kodu

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `KAT` |  |
| 15 | `WYNIK` |  |
| 16 | `PLUG` |  |
| 17 | `GLOWNY` |  |
| 20 | `pliki` | Pliki w kolejności: rejestrator, main, log, rdzeń, SketchUp, okno, testy. |
| 30 | `wzgledna(sciezka)` | Ścieżka względna do opisu (bez Plugins/arte_madera_generator_wiencowy/). |
| 36 | `pole(linie, nazwa)` | Pole nagłówka (Plik:, Zadanie:, Tematy:…) z pierwszych 25 wierszy. |
| 45 | `elementy(sciezka, linie)` | Elementy pliku: [wiersz, nazwa, opis] – metody (def / function), klasy, moduły, stałe. |
| 75 | `komentarz_nad(linie, i, rozsz)` | Komentarz nad elementem: do 3 kolejnych wierszy komentarza bezpośrednio nad nim (bez wierszy pustych). |
| 89 | `tresc` | Treść spisu (Markdown). |

### testy/sprawdz_zasady.rb (163 wierszy)

kontrola zasad kodu – Ruby 2.2, ES5, rdzeń bez API SketchUpa, nagłówki plików, komentarze nad metodami, długość plików, kompilacja, MODULE_FILES.

Zależy od: ripper, node + acorn (ES5)
Używają: testy/uruchom.sh, przed każdym commitem

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `KAT` |  |
| 17 | `PLUG` |  |
| 18 | `DIR` |  |
| 20 | `UWAGA_WIERSZY` | Plik dłuższy – ostrzeżenie (podziel temat); znacznie dłuższy – błąd. |
| 21 | `BLAD_WIERSZY` |  |
| 26 | `RUBY22_MISSING` | Metody, których nie ma w Ruby 2.2 (NoMethodError w SketchUpie 2023 nie grozi, ale zasada jest wspólna z Dokumentacją 2D). |
| 29 | `walk(node, &blk)` |  |
| 35 | `rel(sciezka)` |  |

### testy/t_okno.js (105 wierszy)

okno parametrów w Chromium (Playwright) – formularz z opisów, rzut, tabela otworów, wywołania sketchup.*, wyniki.

Zależy od: testy/okno_dane.rb, Plugins/.../html/okno.html
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `KAT` |  |
| 20 | `HTML` |  |
| 23 | `sprawdz(w, opis)` |  |

### testy/t_rdzen.rb (215 wierszy)

testy rdzenia – obrys, ściany, wieńce, styki z mijanką, kontrfory, otwory, pozycje, kolizje w zamkach.

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `bez_kolizji(pl, opis)` |  |

### testy/t_siatka.rb (75 wierszy)

siatka brył wszystkich pozycji z kilku domów – zamknięta (każda krawędź raz w każdą stronę), objętość równa profilowi.

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `sprawdz_pozycje(pl, opis)` |  |

### testy/t_sketchup.rb (197 wierszy)

warstwa SketchUpa na atrapie API – ładowanie wtyczki, okno, generowanie, atrybuty, położenie bali, przebudowa, ręczne zmiany.

Zależy od: testy/atrapa/sketchup.rb, testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `CAL` |  |
| 21 | `model_z_liniami(odcinki, z0 = 0.0)` |  |
| 31 | `ostatni_wynik(dlg)` |  |
| 36 | `instancje(grupa)` |  |

### testy/t_zamek.rb (95 wierszy)

zamek 44 × 146 zgodny z rysunkiem IMG-20250930-WA0005 – wymiary obróbek, luzy, labirynt (tylko poprawne ułożenie bez kolizji).

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

### testy/uruchom.sh (47 wierszy)

wszystkie testy i kontrole jednym poleceniem – ostatnia linia „WSZYSTKIE ZESTAWY: FAILURES n”.

Zależy od: ruby, node (+ playwright i Chromium dla okna – bez nich test okna jest pomijany z ostrzeżeniem)
Używają: start i zamknięcie rundy
