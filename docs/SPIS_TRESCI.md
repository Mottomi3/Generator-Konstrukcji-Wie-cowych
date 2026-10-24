# Spis treści kodu – ArteMadera Generator Wieńcowy

Plik generowany – nie edytuj ręcznie. Po każdej zmianie kodu: `ruby testy/spis_tresci.rb`
(kontrola aktualności: `ruby testy/spis_tresci.rb --sprawdz`, wchodzi w `testy/uruchom.sh`).
Szukanie: najpierw tabela tematów (1), potem lista elementów pliku (3) – numer wiersza prowadzi prosto do miejsca.
Ścieżki plików wtyczki są względem `Plugins/arte_madera_generator_wiencowy/`.

## 1. Gdzie co zmieniać – tematy → pliki

| Temat | Plik |
|---|---|
| 244 nad działową | `rdzen/dopelnienie.rb` |
| 344 nad działową | `rdzen/dopelnienie.rb` |
| antresola | `rdzen/dopelnienie.rb`, `rdzen/ustawienia_scian.rb`, `testy/t_sciany_ust.rb` |
| asercje | `testy/pomoc.rb` |
| atrapa | `testy/t_sketchup.rb` |
| atrapa api | `testy/atrapa/sketchup.rb` |
| atrybuty | `sketchup/atrybuty.rb` |
| atrybuty dokumentacji 2d | `testy/t_sketchup.rb` |
| bal | `rdzen/bale.rb` |
| bal obrócony | `sketchup/konwersja.rb`, `testy/t_sketchup.rb` |
| bal szczytowy | `rdzen/szczyty.rb` |
| bal szczytu | `rdzen/bale.rb` |
| bale nad linią dachu | `testy/kolizje_belek.rb` |
| belka | `rdzen/elementy.rb` |
| belki w modelu | `sketchup/budowa.rb`, `testy/t_sketchup.rb` |
| bom | `testy/t_zestawienie.rb` |
| bom dla excela | `sketchup/eksport.rb` |
| bryła bala | `rdzen/bryla.rb` |
| bryła zamknięta | `rdzen/siatka.rb`, `testy/t_raport.rb`, `testy/t_siatka.rb` |
| bryła zamknięta w sketchupie | `sketchup/raport.rb` |
| bryły zamknięte | `testy/losowe_domy.rb` |
| budowa modelu | `sketchup/budowa.rb`, `testy/t_sketchup.rb` |
| budowa ruby ze źródeł | `testy/ruby27.sh` |
| błędy | `log.rb`, `rdzen/projekt.rb` |
| c24 | `rdzen/statyka.rb` |
| callback | `sketchup/okno.rb` |
| cienki pasek bala przy otworze | `rdzen/otwory.rb` |
| cięcie proste przy otworze | `rdzen/otwory.rb` |
| cięcie przy otworze | `rdzen/bale.rb` |
| cofnięcie operacji | `testy/t_raport.rb` |
| czas budowy | `sketchup/raport.rb` |
| czasy etapów | `log.rb` |
| dach | `rdzen/dach.rb` |
| dachowanie płatwi kalenicowej | `rdzen/pryzmat.rb` |
| dane dla okna | `sketchup/sterowanie.rb` |
| dane testowe okna | `testy/okno_dane.rb` |
| definicja z siatki | `sketchup/budowa.rb` |
| dobór przekroju | `rdzen/statyka.rb`, `testy/t_podloga.rb` |
| dobór przekroju legara | `rdzen/podloga.rb` |
| dodaj węgieł | `rdzen/ustawienia_scian.rb` |
| dodaj węgieł kliknięciem | `html/edycja.js` |
| dokumentacja 2d | `testy/zrzut_dok2d.rb` |
| dom 4 × 4 | `rdzen/przyklady.rb`, `testy/t_wegly.rb` |
| dom 900 | `testy/t_rdzen.rb` |
| dom jak 900 | `rdzen/przyklady.rb` |
| dom testowy | `testy/podglad.rb` |
| dom z działową | `rdzen/przyklady.rb` |
| domy testowe | `testy/pomoc.rb` |
| dopełnienie zamka | `rdzen/dopelnienie.rb`, `testy/t_sciany_ust.rb` |
| drzwi | `rdzen/otwory.rb`, `rdzen/stolarka.rb` |
| działowa niższa | `rdzen/dopelnienie.rb`, `rdzen/ustawienia_scian.rb`, `html/edycja.js`, `testy/t_sciany_ust.rb` |
| działowa niższa – parametry | `rdzen/parametry_lista.rb` |
| działowa pod antresolą w teście | `rdzen/przyklady.rb` |
| dziennik | `log.rb` |
| długie ściany | `testy/t_rdzen.rb` |
| długości bali | `testy/losowe_domy.rb` |
| długość bala | `rdzen/bale.rb` |
| długość pliku | `testy/sprawdz_zasady.rb` |
| długość – sprawdzenie | `rdzen/kontrola.rb` |
| edycja w widoku ściany | `html/edycja.js` |
| eksport obj | `testy/podglad.rb` |
| element | `rdzen/elementy.rb` |
| elewacja ściany | `rdzen/widok.rb`, `html/sciana.js` |
| es5 | `testy/sprawdz_zasady.rb` |
| excel | `rdzen/zestawienie.rb` |
| formatowanie liczb | `html/wspolne.js` |
| formularz | `html/okno.css`, `testy/t_okno.js` |
| formularz parametrów | `sketchup/okno.rb`, `html/okno.js` |
| funkcje pomocnicze okna | `html/wspolne.js` |
| gdzie co zmieniać | `testy/spis_tresci.rb` |
| geom::point3d | `testy/atrapa/sketchup.rb` |
| geom::transformation | `testy/atrapa/sketchup.rb` |
| gniazdo 40 × 36 | `testy/t_zamek.rb` |
| gniazdo dolne | `rdzen/zamek.rb` |
| gniazdo górne | `rdzen/zamek.rb` |
| gniazdo płatwi | `rdzen/szczyty.rb`, `testy/t_szczyty.rb` |
| gniazdo zamka w widoku | `testy/t_widok.rb` |
| graniastosłup | `rdzen/pryzmat.rb` |
| grupa dach | `sketchup/budowa.rb` |
| grupa domu | `sketchup/budowa.rb` |
| grupa podłoga | `sketchup/budowa.rb` |
| grupa ściany | `sketchup/budowa.rb` |
| grupy pozycji | `testy/zrzut_dok2d.rb` |
| góra ścian | `rdzen/wience.rb` |
| htmldialog | `sketchup/okno.rb` |
| identyczne bale | `rdzen/bryla.rb`, `rdzen/pozycje.rb` |
| ilość sztuk | `rdzen/pozycje.rb` |
| init okna | `testy/okno_dane.rb` |
| instalacja | `testy/buduj_rbz.rb` |
| izolacja | `testy/t_podloga.rb` |
| izolacja a wysokość legara | `rdzen/statyka.rb` |
| izolacja podłogi | `rdzen/podloga.rb` |
| jeden temat = jeden plik | `testy/sprawdz_zasady.rb` |
| jeden węgieł | `rdzen/styki.rb` |
| jednostki mm/cale | `sketchup/konwersja.rb` |
| kalenica | `rdzen/sciany.rb` |
| karta widoku ściany | `html/okno.html` |
| katalog appdata | `sketchup/ustawienia.rb` |
| katalog dokumenty | `sketchup/eksport.rb` |
| katalog przekrojów | `rdzen/parametry.rb` |
| katalog wtyczki | `main.rb` |
| kawałek bala | `rdzen/bale.rb` |
| kierunek a/b | `rdzen/sciany.rb` |
| kierunek legarów | `rdzen/podloga.rb` |
| klasa drewna | `rdzen/statyka.rb` |
| kliknięcie w widok ściany | `html/sciana.js` |
| kliknięcie ściany na rzucie | `html/rzut.js` |
| kolejność kroków | `rdzen/projekt.rb` |
| kolizje | `rdzen/kontrola.rb`, `testy/losowe_domy.rb` |
| kolizje belek | `testy/kolizje_belek.rb`, `testy/t_szczyty.rb` |
| kolizje krokwi z działową | `testy/t_losowe.rb` |
| kolory | `html/okno.css` |
| komponent | `rdzen/pozycje.rb` |
| komponent bala | `sketchup/budowa.rb` |
| komunikaty | `html/okno.css` |
| komunikaty w oknie | `sketchup/okno.rb`, `html/okno.js` |
| konsola ruby | `log.rb` |
| kontrfor | `rdzen/sciany.rb`, `rdzen/usztywnienie.rb` |
| kontrfor przerwany przy otworze | `rdzen/bale.rb` |
| kontrfor – wysokość | `rdzen/wience.rb` |
| kontrola | `rdzen/kontrola.rb` |
| kontrola przed commitem | `testy/uruchom.sh` |
| kontrola z menu | `testy/t_sketchup.rb` |
| kontrola zamków z menu | `sketchup/sterowanie.rb` |
| kotwice styków | `rdzen/styki.rb` |
| krawędzie | `sketchup/wejscie.rb` |
| krokiew | `rdzen/dach.rb`, `rdzen/elementy.rb` |
| krokiew na szczycie | `testy/t_szczyty.rb` |
| krokiew ukośna | `sketchup/konwersja.rb` |
| krokwie obie strony | `testy/t_szczyty.rb` |
| krokwie od wewnątrz | `testy/t_szczyty.rb` |
| krokwie przy szczycie | `rdzen/dach.rb`, `rdzen/przyklady.rb` |
| krótkie krawędzie | `testy/t_losowe.rb` |
| krótkie krawędzie brył | `testy/losowe_domy.rb` |
| kąt dachu | `rdzen/dach.rb` |
| labirynt | `rdzen/zamek.rb` |
| legar | `rdzen/elementy.rb`, `rdzen/podloga.rb` |
| legar – sprawdzenie | `rdzen/statyka.rb` |
| legary między podwalinami | `testy/t_podloga.rb` |
| lico zewnętrzne | `rdzen/obrys.rb` |
| liczba zmian w sekcji | `html/zmiany.js` |
| liczby wyniku | `html/wyniki.js` |
| linia dachu | `rdzen/dach.rb`, `testy/t_szczyty.rb` |
| linia dachu w widoku | `rdzen/widok.rb`, `testy/t_widok.rb` |
| linia podparcia | `rdzen/pod_dachem.rb` |
| linie obrysu w grupie | `sketchup/wejscie.rb` |
| linie wejściowe | `rdzen/obrys.rb` |
| lista bali | `rdzen/pozycje.rb`, `html/wyniki.js` |
| lista belek | `rdzen/elementy.rb` |
| lista do zamówienia w pliku | `rdzen/zestawienie.rb` |
| lista parametrów | `rdzen/parametry_lista.rb` |
| lista parametrów – dokument | `testy/lista_parametrow.rb` |
| lista ścian | `rdzen/projekt.rb` |
| lista ścian otworu | `html/otwory.js` |
| losowe domy | `testy/losowe_domy.rb` |
| losowe ustawienia ścian | `testy/losowe_domy.rb` |
| losowy pełny profil | `testy/losowe_domy.rb` |
| luz 0,5 | `testy/t_zamek.rb` |
| luz boczny | `rdzen/stolarka.rb` |
| luz górny | `rdzen/stolarka.rb` |
| luz górny w tabeli | `html/otwory.js` |
| luz osiadania | `rdzen/stolarka.rb` |
| luz pionowy | `rdzen/kontrola.rb` |
| luz pionowy 2,5 | `testy/t_zamek.rb` |
| luz w zamku | `rdzen/zamek.rb` |
| luz wpustu | `rdzen/profil_bala.rb` |
| maksymalna długość bala | `rdzen/styki.rb` |
| mapa kodu | `testy/spis_tresci.rb` |
| menu | `sketchup/menu.rb` |
| miejsce na węgieł | `rdzen/usztywnienie.rb` |
| mijanka | `rdzen/styki.rb`, `testy/losowe_domy.rb`, `testy/t_rdzen.rb` |
| mijanka 300 | `rdzen/parametry.rb` |
| mijanka – sprawdzenie | `rdzen/kontrola.rb` |
| module_files | `main.rb`, `testy/sprawdz_zasady.rb` |
| nachodzenie bali | `rdzen/kontrola.rb` |
| nad działową | `rdzen/ustawienia_scian.rb`, `html/edycja.js` |
| nadproże | `rdzen/otwory.rb` |
| nadstawka | `rdzen/dopelnienie.rb`, `rdzen/wience.rb` |
| nagłówki plików | `testy/spis_tresci.rb`, `testy/sprawdz_zasady.rb` |
| narożnik l | `rdzen/sciany.rb` |
| narożnik wklęsły | `rdzen/sciany.rb` |
| nazwa bala 10-4200 | `rdzen/pozycje.rb` |
| nowe drzwi | `html/otwory.js` |
| nowe okno | `html/otwory.js` |
| nowy parametr | `rdzen/parametry_lista.rb` |
| nośność belki | `rdzen/statyka.rb` |
| numer kompilacji | `Plugins/arte_madera_generator_wiencowy.rb`, `main.rb`, `sketchup/menu.rb`, `testy/sprawdz_zasady.rb` |
| numeracja bali | `rdzen/pozycje.rb` |
| numeracja ścian | `rdzen/sciany.rb` |
| numery pozycji na widoku | `html/sciana.js` |
| numery wierszy | `testy/spis_tresci.rb` |
| o wtyczce | `sketchup/menu.rb` |
| objętość | `rdzen/bryla.rb`, `rdzen/zestawienie.rb`, `testy/t_siatka.rb` |
| objętość belki | `rdzen/pryzmat.rb` |
| objętość bryły | `sketchup/raport.rb`, `testy/t_raport.rb` |
| objętość siatki | `rdzen/siatka.rb` |
| objętość z profilem | `rdzen/profil_bala.rb` |
| obrys | `rdzen/obrys.rb` |
| obrys bala w widoku | `rdzen/widok.rb`, `testy/t_widok.rb` |
| obrys l | `rdzen/przyklady.rb`, `testy/t_rdzen.rb` |
| obrys prostokątny | `testy/pomoc.rb` |
| obrys w kształcie l | `testy/pomoc.rb` |
| obróbki bala | `rdzen/bryla.rb` |
| obrót | `testy/t_rdzen.rb` |
| obrót o 180° | `rdzen/bryla.rb` |
| obrót obrysu | `testy/pomoc.rb` |
| obrót układu | `rdzen/geometria.rb` |
| odcinek 244 | `testy/t_zamek.rb` |
| odcinki 244 i 344 | `testy/t_sciany_ust.rb` |
| odcinki nad działową | `rdzen/dopelnienie.rb` |
| odcinki nadstawki | `rdzen/bale.rb` |
| odległości | `rdzen/geometria.rb` |
| okap | `rdzen/dach.rb` |
| okno | `rdzen/otwory.rb`, `rdzen/stolarka.rb`, `sketchup/okno.rb`, `html/okno.html` |
| okno zapisu | `sketchup/eksport.rb` |
| okno zapisu anulowane | `testy/t_zestawienie.rb` |
| okno – wywołania | `testy/t_sketchup.rb` |
| okruchy bali | `testy/t_losowe.rb` |
| operacja cofnij | `sketchup/budowa.rb` |
| opis w menedżerze rozszerzeń | `Plugins/arte_madera_generator_wiencowy.rb` |
| opisy ścian na rzucie | `html/rzut.js` |
| orientacja lic | `testy/t_zamek.rb` |
| osiadanie ścian | `rdzen/stolarka.rb` |
| osie działowych | `rdzen/obrys.rb` |
| ostatek | `rdzen/sciany.rb` |
| ostatek 200 na narożniku | `testy/t_sciany_ust.rb` |
| ostatek 200 pod taras | `rdzen/ustawienia_scian.rb`, `html/edycja.js` |
| ostatek na końcu ściany | `html/edycja.js` |
| ostatek na narożniku | `rdzen/ustawienia_scian.rb` |
| ostatek pod dachem | `rdzen/pod_dachem.rb` |
| ostatni plan | `sketchup/sterowanie.rb` |
| ostatnie parametry | `sketchup/sterowanie.rb`, `sketchup/ustawienia.rb` |
| ostrzeżenia | `log.rb`, `rdzen/projekt.rb` |
| ostrzeżenie o ręcznych poprawkach | `sketchup/sterowanie.rb` |
| otwory | `testy/t_rdzen.rb` |
| otwory w ścianach siatki | `testy/t_siatka.rb` |
| otwory) | `rdzen/projekt.rb` |
| otwór | `rdzen/otwory.rb` |
| otwór w balach w oknie | `html/otwory.js` |
| oś ściany | `rdzen/sciany.rb` |
| paczka rbz | `testy/buduj_rbz.rb` |
| panel ustawień ściany | `html/okno.css` |
| panel ściany | `html/edycja.js` |
| para węgłów | `rdzen/styki.rb` |
| parametry | `rdzen/projekt.rb` |
| parapet | `rdzen/otwory.rb` |
| pasy przekroju | `rdzen/profil_bala.rb`, `rdzen/siatka.rb` |
| pełny profil bala | `rdzen/profil_bala.rb` |
| pełny profil w teście | `rdzen/przyklady.rb` |
| pełzanie | `rdzen/statyka.rb` |
| pierwszy wieniec | `rdzen/wience.rb` |
| pierwszy wieniec bez wpustu | `rdzen/profil_bala.rb` |
| pióro | `rdzen/profil_bala.rb` |
| plan domu | `rdzen/projekt.rb` |
| playwright | `testy/t_okno.js` |
| plik ustawień | `sketchup/ustawienia.rb` |
| pod dachem | `rdzen/pod_dachem.rb` |
| podcięcie 2,5 × 42 | `testy/t_zamek.rb` |
| podcięcie boczne | `rdzen/zamek.rb` |
| podgląd | `sketchup/okno.rb` |
| podgląd 3d | `testy/podglad.py`, `testy/podglad.rb` |
| podgląd automatyczny | `html/okno.js` |
| podpis bala | `rdzen/bryla.rb` |
| podpis zawartości | `sketchup/atrybuty.rb` |
| podpora | `rdzen/elementy.rb` |
| podpora legarów | `rdzen/podloga.rb` |
| podpory legarów | `testy/t_podloga.rb` |
| podpowiedzi | `rdzen/projekt.rb`, `html/okno.html`, `testy/t_okno.js` |
| podpowiedzi podłogi | `rdzen/podloga.rb`, `html/wyniki.js` |
| podpowiedzi pól | `rdzen/parametry_lista.rb`, `sketchup/okno.rb`, `html/okno.css`, `html/okno.js` |
| podpowiedzi w oknie | `sketchup/sterowanie.rb` |
| podpowiedź luzu | `rdzen/stolarka.rb`, `html/otwory.js` |
| podsumowanie | `rdzen/projekt.rb` |
| podwalina | `rdzen/elementy.rb`, `rdzen/podloga.rb` |
| podwaliny na zakład | `testy/t_podloga.rb` |
| podwójne pióro | `rdzen/profil_bala.rb` |
| podział wieńca | `rdzen/bale.rb` |
| podłoga | `rdzen/podloga.rb` |
| pokaz grup | `testy/zrzut_dok2d.rb` |
| pola podstawowe | `rdzen/parametry_lista.rb`, `html/tryb.js` |
| pola zmienione | `html/okno.css` |
| pole obrysu | `testy/t_widok.rb` |
| porównanie modelu z planem | `sketchup/raport.rb` |
| poziom domu z0 | `sketchup/wejscie.rb` |
| poziom wieńca | `rdzen/wience.rb` |
| poziom ±0 | `rdzen/otwory.rb` |
| pozycja | `rdzen/pozycje.rb`, `sketchup/atrybuty.rb` |
| pozycja belki z przekrojem | `rdzen/pryzmat.rb` |
| pozycja elementu | `rdzen/elementy.rb` |
| pozycje menu | `sketchup/menu.rb` |
| położenie bala | `rdzen/bale.rb` |
| położenie belki | `rdzen/elementy.rb` |
| położenie domu przy przebudowie | `sketchup/budowa.rb` |
| połączenie t | `rdzen/sciany.rb` |
| prefiks bs / kf | `rdzen/pozycje.rb` |
| prefiks bs/kf/sz/pw/l/pd/p/k | `sketchup/atrybuty.rb` |
| prefiks elementu | `rdzen/elementy.rb` |
| prefiks sz | `rdzen/szczyty.rb` |
| prefiksy bs kf sz | `testy/zrzut_dok2d.rb` |
| presety | `rdzen/parametry_lista.rb` |
| profil bala | `rdzen/bryla.rb` |
| profil bala – parametry | `rdzen/parametry_lista.rb` |
| prostopadłościan otaczający | `testy/kolizje_belek.rb` |
| przebieg generowania | `rdzen/projekt.rb` |
| przebudowa | `sketchup/atrybuty.rb`, `sketchup/budowa.rb`, `testy/t_sketchup.rb` |
| przebudowa z parametrów | `sketchup/sterowanie.rb` |
| przecinek dziesiętny | `rdzen/zestawienie.rb` |
| przecięcia odcinków | `rdzen/geometria.rb` |
| przedziały | `rdzen/bryla.rb` |
| przekrój bala | `rdzen/parametry_lista.rb` |
| przekrój szer×wys | `rdzen/parametry.rb` |
| przekrój wielokątny | `rdzen/pryzmat.rb` |
| przesunięcie o pół wieńca | `rdzen/wience.rb` |
| przesunięty dom zostaje na miejscu | `sketchup/budowa.rb` |
| przełącznik pól | `html/okno.css`, `html/okno.html`, `html/tryb.js` |
| przełącznik pól podstawowe / wszystkie | `html/okno.js` |
| prześwit pod połacią | `rdzen/pod_dachem.rb` |
| przycisk generuj | `sketchup/okno.rb` |
| przyciski | `html/okno.html` |
| przykładowe domy | `rdzen/przyklady.rb`, `testy/t_raport.rb` |
| przywrócenie domyślnych | `sketchup/ustawienia.rb` |
| przywróć domyślne | `sketchup/okno.rb` |
| przywróć fabryczne | `html/okno.js` |
| przywróć węgły automatyczne | `html/edycja.js` |
| punkt odniesienia otworu | `html/rzut.js` |
| punkt sketchupa | `sketchup/konwersja.rb` |
| punkty próbne | `testy/kolizje_belek.rb` |
| punkty t | `rdzen/siatka.rb` |
| półbal | `rdzen/wience.rb` |
| półka | `rdzen/ustawienia_scian.rb` |
| półzamek przy styku | `rdzen/zamek.rb` |
| płaszczyzna pozioma | `sketchup/wejscie.rb` |
| płatew | `rdzen/dach.rb`, `rdzen/elementy.rb` |
| płatew kalenicowa | `rdzen/dach.rb` |
| płatew przez szczyt | `rdzen/szczyty.rb` |
| płatew ścienna | `rdzen/dach.rb`, `testy/t_szczyty.rb` |
| płatew ścięta | `rdzen/pryzmat.rb` |
| raport do testów | `sketchup/raport.rb` |
| raport json | `sketchup/raport.rb`, `testy/t_raport.rb` |
| regresja | `testy/t_losowe.rb` |
| rejestracja rozszerzenia | `Plugins/arte_madera_generator_wiencowy.rb` |
| rola timber | `sketchup/atrybuty.rb` |
| rozkład ściany | `rdzen/widok.rb`, `html/sciana.js` |
| rozmieszczenie węgłów | `rdzen/usztywnienie.rb` |
| rozpiętość legara | `rdzen/statyka.rb` |
| rozstaw krokwi | `rdzen/dach.rb` |
| rozstaw legarów | `rdzen/podloga.rb` |
| ruby 2.2 | `testy/sprawdz_zasady.rb` |
| ruby 2.7 | `testy/ruby27.sh` |
| rysunek domu | `testy/podglad.py` |
| rysunek svg | `html/rzut.js` |
| rzut w oknie | `sketchup/sterowanie.rb`, `html/rzut.js` |
| ręczne poprawki | `sketchup/atrybuty.rb` |
| scalanie linii | `rdzen/obrys.rb` |
| scalanie ścian współpłaszczyznowych | `rdzen/siatka.rb` |
| sekcje | `testy/t_okno.js` |
| sekcje formularza | `html/okno.html` |
| sekcje okna | `rdzen/parametry_lista.rb`, `sketchup/okno.rb` |
| sekcje pól | `html/okno.js` |
| siatka | `rdzen/siatka.rb` |
| siatka belki | `rdzen/pryzmat.rb` |
| siatka pełnego profilu | `rdzen/siatka.rb` |
| skos | `testy/t_siatka.rb` |
| skos (szczyty) | `rdzen/bryla.rb` |
| skos bala | `rdzen/szczyty.rb` |
| skos węgła | `rdzen/pod_dachem.rb` |
| skrzyżowania w widoku | `rdzen/widok.rb` |
| skrzyżowanie x | `rdzen/sciany.rb`, `testy/t_rdzen.rb` |
| spis treści | `testy/spis_tresci.rb` |
| sprawdzanie parametrów | `rdzen/parametry.rb` |
| sprawdzenie domu | `testy/losowe_domy.rb` |
| sprawdzenie wzrokowe | `testy/podglad.rb` |
| sprawdzenie zamka | `rdzen/kontrola.rb` |
| stare wartości | `rdzen/parametry_lista.rb` |
| start z menu | `sketchup/sterowanie.rb` |
| statyka | `rdzen/statyka.rb` |
| statyka legara | `testy/t_podloga.rb` |
| sterowanie | `sketchup/sterowanie.rb` |
| stolarka | `rdzen/stolarka.rb` |
| stolarka w oknie | `html/otwory.js` |
| stromy dach | `rdzen/pod_dachem.rb` |
| strop | `rdzen/dopelnienie.rb`, `rdzen/ustawienia_scian.rb`, `testy/t_sciany_ust.rb` |
| styk | `rdzen/styki.rb` |
| styk bez zamka | `rdzen/kontrola.rb` |
| styk przy otworze | `testy/t_wegly.rb` |
| styk w osi zamka | `rdzen/styki.rb` |
| styk w wieńcu | `rdzen/bale.rb` |
| styki bez zamka | `testy/losowe_domy.rb`, `testy/t_losowe.rb` |
| styki na widoku | `html/sciana.js` |
| styki w widoku | `rdzen/widok.rb`, `testy/t_widok.rb` |
| sumy grup | `rdzen/zestawienie.rb`, `testy/t_zestawienie.rb` |
| szablony | `html/okno.css`, `html/okno.html`, `testy/t_okno.js`, `testy/t_sketchup.rb` |
| szablony parametrów | `sketchup/ustawienia.rb` |
| szablony w oknie | `sketchup/okno.rb`, `html/okno.js` |
| szablony wbudowane | `sketchup/ustawienia.rb` |
| szablony wbudowane – dokument | `testy/lista_parametrow.rb` |
| szczelina styku | `rdzen/styki.rb` |
| szczyt | `rdzen/szczyty.rb` |
| szczyt na działowej | `rdzen/szczyty.rb` |
| słownik artemadera | `sketchup/atrybuty.rb` |
| tabela | `html/okno.css` |
| tabela otworów | `sketchup/okno.rb`, `html/otwory.js` |
| tabela ścian | `html/wyniki.js` |
| tag szczyty | `sketchup/budowa.rb` |
| tagi | `sketchup/budowa.rb` |
| tak/nie | `rdzen/parametry.rb` |
| test działania | `rdzen/przyklady.rb`, `sketchup/raport.rb`, `testy/t_raport.rb` |
| test działania z menu | `sketchup/menu.rb` |
| test losowy | `testy/losowe_domy.rb`, `testy/t_losowe.rb` |
| test okna | `testy/t_okno.js` |
| testy | `testy/pomoc.rb` |
| testy na starszym ruby | `testy/ruby27.sh` |
| testy offline | `testy/atrapa/sketchup.rb` |
| testy podłogi | `testy/t_podloga.rb` |
| testy raportu | `testy/t_raport.rb` |
| testy rdzenia | `testy/t_rdzen.rb` |
| testy siatki | `testy/t_siatka.rb` |
| testy sketchup | `testy/t_sketchup.rb` |
| testy szczytów | `testy/t_szczyty.rb` |
| testy ustawień ściany | `testy/t_sciany_ust.rb` |
| testy widoku ściany | `testy/t_widok.rb` |
| testy węgłów | `testy/t_wegly.rb` |
| testy zamka | `testy/t_zamek.rb` |
| testy zestawienia csv | `testy/t_zestawienie.rb` |
| tolerancje | `rdzen/geometria.rb` |
| transformacja bala | `sketchup/konwersja.rb` |
| transformacja belki | `sketchup/konwersja.rb` |
| transformacja domu (obrót układu lokalnego) | `sketchup/konwersja.rb` |
| tryb nowy / edycja | `sketchup/sterowanie.rb` |
| tryb podstawowe / zaawansowane | `html/tryb.js` |
| tryb pól okna | `sketchup/okno.rb`, `sketchup/ustawienia.rb` |
| tworzenie elementów | `html/wspolne.js` |
| tylko narysowane | `testy/t_wegly.rb` |
| ugięcie | `rdzen/statyka.rb`, `testy/t_podloga.rb` |
| ukrywanie pól | `html/tryb.js` |
| układ dachu | `rdzen/dach.rb` |
| układ lokalny (obrót) | `rdzen/obrys.rb` |
| układ lokalny belki | `testy/kolizje_belek.rb` |
| układ na przemian | `rdzen/styki.rb` |
| układ okna | `html/okno.html` |
| uruchamianie testów | `testy/uruchom.sh` |
| ustawienia okna | `sketchup/ustawienia.rb` |
| ustawienia ścian do ruby | `html/edycja.js` |
| ustawienia ściany | `rdzen/ustawienia_scian.rb` |
| ustawienia ściany w widoku | `rdzen/widok.rb` |
| ustawienie bala licem | `rdzen/zamek.rb` |
| usunięty węgieł | `testy/t_sciany_ust.rb` |
| usuwanie starych definicji | `sketchup/budowa.rb` |
| usuń węgieł | `rdzen/ustawienia_scian.rb` |
| usuń węgieł kliknięciem | `html/edycja.js` |
| wartości domyślne | `rdzen/parametry_lista.rb` |
| wartości domyślne – dokument | `testy/lista_parametrow.rb` |
| wartość fabryczna | `html/zmiany.js` |
| wejście (segmenty | `rdzen/projekt.rb` |
| wektory | `rdzen/geometria.rb` |
| wersja | `main.rb` |
| widok ściany | `rdzen/widok.rb`, `html/okno.css`, `html/sciana.js`, `testy/okno_dane.rb` |
| widok ściany dla okna | `sketchup/sterowanie.rb` |
| widok ściany w oknie | `sketchup/okno.rb` |
| wielokąt z otworem | `rdzen/siatka.rb` |
| wieniec | `rdzen/wience.rb` |
| wieńce niższej działowej | `rdzen/wience.rb` |
| wieńce szczytu | `rdzen/wience.rb` |
| wolny koniec | `rdzen/sciany.rb` |
| wpust | `rdzen/profil_bala.rb` |
| wybór domu do edycji | `sketchup/wejscie.rb` |
| wybór ściany do widoku | `html/okno.js` |
| wybór ściany w oknie | `html/sciana.js` |
| wycięcie bala przy otworze | `rdzen/otwory.rb` |
| wydanie | `testy/buduj_rbz.rb` |
| wygląd okna | `html/okno.css` |
| wymiary otworu w balach | `rdzen/stolarka.rb` |
| wymiary zamka | `rdzen/parametry.rb`, `rdzen/parametry_lista.rb` |
| wymiary zamka w oknie | `html/okno.js` |
| wynik okna | `testy/okno_dane.rb` |
| wyniki w oknie | `html/wyniki.js` |
| wyróżnienie zmienionych pól | `html/zmiany.js` |
| wysokości ścian | `html/wyniki.js` |
| wysokość szczytu | `rdzen/szczyty.rb` |
| wysokość ściany | `rdzen/wience.rb` |
| wysunięcie dachu | `rdzen/dach.rb` |
| wywołania ruby | `testy/t_okno.js` |
| wzmocnienie ściany | `rdzen/usztywnienie.rb` |
| węgieł | `rdzen/usztywnienie.rb` |
| węgieł od narożnika | `rdzen/usztywnienie.rb`, `testy/t_wegly.rb` |
| węgieł pod okapem | `rdzen/pod_dachem.rb` |
| węgieł ręczny na widoku | `html/sciana.js` |
| węgły ręczne | `rdzen/ustawienia_scian.rb`, `testy/t_sciany_ust.rb` |
| zakresy wartości | `rdzen/parametry.rb` |
| zakład podwalin | `rdzen/podloga.rb` |
| zamek | `rdzen/zamek.rb` |
| zaokrąglenia | `rdzen/geometria.rb` |
| zapamiętane ustawienia | `testy/t_sketchup.rb` |
| zapamiętany tryb okna | `html/tryb.js` |
| zapis parametrów w modelu | `sketchup/atrybuty.rb` |
| zapis pliku | `sketchup/eksport.rb`, `testy/t_zestawienie.rb` |
| zapis ustawień | `sketchup/ustawienia.rb` |
| zapis zestawienia z okna | `sketchup/okno.rb` |
| zasady kodu | `testy/sprawdz_zasady.rb` |
| zaznaczenie | `sketchup/wejscie.rb` |
| zaznaczona ściana (prostokąt kliknięty raz) | `sketchup/wejscie.rb` |
| zbliżenie zamka | `testy/podglad.py` |
| zestawienie csv | `rdzen/zestawienie.rb` |
| zestawienie csv do pliku | `sketchup/eksport.rb` |
| zestawy testów | `testy/uruchom.sh` |
| zgodność z dokumentacją 2d | `testy/zrzut_dok2d.rb` |
| zgodność z ruby sketchupa | `testy/ruby27.sh` |
| ziarna błędów | `testy/t_losowe.rb` |
| ziarno | `testy/losowe_domy.rb` |
| zmienione względem fabrycznych | `html/zmiany.js` |
| znacznik kontrforu | `rdzen/obrys.rb` |
| zrzut geometrii | `testy/zrzut_dok2d.rb` |
| zrzut okna | `testy/t_okno.js` |
| ładowanie modułów | `main.rb` |
| łączenie bali na długość | `rdzen/styki.rb` |
| łączenie na przemian | `rdzen/przyklady.rb`, `testy/t_wegly.rb` |
| ściana | `rdzen/sciany.rb` |
| ściana działowa | `testy/t_rdzen.rb` |
| ściana szczytowa | `rdzen/szczyty.rb` |
| ściana wysoka | `rdzen/usztywnienie.rb`, `testy/t_wegly.rb` |
| ściana z otworem | `sketchup/budowa.rb` |
| ściana z otworem w atrapie | `testy/atrapa/sketchup.rb` |
| ściany bryły | `rdzen/siatka.rb` |
| ścięcie wierzchu płatwi | `rdzen/pryzmat.rb` |
| środowisko sketchupa | `sketchup/raport.rb` |
| światło ściany | `rdzen/usztywnienie.rb`, `testy/t_wegly.rb` |
| źródło węgła | `rdzen/widok.rb` |

## 2. Pliki

| Plik | Wierszy | Zadanie |
|---|---:|---|
| `Plugins/arte_madera_generator_wiencowy.rb` | 51 | rejestracja rozszerzenia w SketchUpie – jedyny plik ładowany automatycznie z folderu Plugins. |
| `main.rb` | 67 | stałe wtyczki (wersja, numer kompilacji, katalogi) i ładowanie modułów w kolejności zależności. |
| `log.rb` | 135 | dziennik wtyczki – jedno miejsce na błędy, ostrzeżenia, informacje i czasy etapów. |
| `rdzen/bale.rb` | 175 | bale każdej ściany w każdym wieńcu – kawałki między otworami i stykami, wycięcia przy otworach, skos szczytu, położenie w układzie domu. |
| `rdzen/bryla.rb` | 159 | bryła bala z obróbek – profil wzdłuż bala (przedziały z zakresem grubości i wysokości), przynależność punktu, objętość, podpis. |
| `rdzen/dach.rb` | 241 | geometria dachu dwuspadowego – linia podparcia (wierzch płatwi), linia szczytu, płatwie w przekroju, krokwie, belki dachu. |
| `rdzen/dopelnienie.rb` | 97 | dopełnienie zamka nad niższą działową – przy ścianach, które idą wyżej, odcinki działowej (ostatek + grubość + dopelnienie_wewn) aż do góry tamtej ściany, jak 1100 W-6, W-7 i 1200 W-5, W-7. |
| `rdzen/elementy.rb` | 126 | elementy z belek (podłoga, dach) – belka prostopadłościenna w dowolnym położeniu, pozycje identycznych belek, lista zamówienia. |
| `rdzen/geometria.rb` | 221 | działania na punktach 2D/3D (tablice [x, y] / [x, y, z] w mm) bez API SketchUpa. |
| `rdzen/kontrola.rb` | 160 | kontrola wyniku – kolizje bali w słupach zamków, mijanka styków w sąsiednich wieńcach, styki poza zamkiem, długości bali. |
| `rdzen/obrys.rb` | 292 | rozpoznanie narysowanych linii – zamknięty obrys (lico zewnętrzne), osie ścian działowych, znaczniki kontrforów. |
| `rdzen/otwory.rb` | 119 | otwory okienne i drzwiowe – położenie na ścianie, sprawdzenie, cięcia bali w każdym wieńcu. |
| `rdzen/parametry.rb` | 156 | sprawdzenie i uzupełnienie parametrów z okna / modelu / ustawień (zakresy, wybory, przekroje, zamek) i odczyt pomocniczy. |
| `rdzen/parametry_lista.rb` | 301 | lista wszystkich parametrów – wartość domyślna, etykieta, jednostka, zakres, rodzaj pola, sekcja okna, podpowiedź; presety przekroju bala. |
| `rdzen/pod_dachem.rb` | 83 | bale wystające pod połać – węgły na ścianach okapowych i działowe w poprzek kalenicy ścięte linią dachu (spód krokwi / desek); ostrzeżenie o zbyt stromym dachu. |
| `rdzen/podloga.rb` | 301 | podłoga domu prostokątnego – podwaliny pod ścianami (zakład w narożnikach), legary między podwalinami, podciągi pod legarami, dobór przekroju i podpowiedzi. |
| `rdzen/pozycje.rb` | 75 | numeracja pozycji jak u producenta – identyczne bale (ta sama bryła, także po obrocie o 180°) dostają jedną pozycję „nr-długość”. |
| `rdzen/profil_bala.rb` | 137 | pełny profil bala do wizualizacji – pióra na wierzchu i wpust od spodu (pierwszy wieniec bez wpustu); przekrój pasami wzdłuż grubości, objętość. |
| `rdzen/projekt.rb` | 144 | przebieg obliczeń domu od linii do listy bali i belek (kolejność kroków) i podsumowanie do okna – bez API SketchUpa. |
| `rdzen/pryzmat.rb` | 69 | belka o przekroju wielokątnym (graniastosłup) – siatka ścian, objętość, podpis i postać kanoniczna przekroju (np. płatew ścięta do płaszczyzny dachu). |
| `rdzen/przyklady.rb` | 63 | przykładowe domy do testu działania w SketchUpie (i w testach) – linie, parametry i otwory. |
| `rdzen/sciany.rb` | 244 | ściany z rozpoznanego obrysu – osie, zasięgi bali z ostatkami, skrzyżowania, kontrfory, kierunek względem kalenicy, numeracja W-n. |
| `rdzen/siatka.rb` | 385 | siatka ścian (płaskich wielokątów z otworami) zamkniętej bryły bala z profilu – do budowy komponentu w SketchUpie. |
| `rdzen/statyka.rb` | 91 | sprawdzenie belki drewnianej swobodnie podpartej (zginanie, ścinanie, ugięcie końcowe), największa rozpiętość, dobór przekroju z katalogu. |
| `rdzen/stolarka.rb` | 51 | stolarka okien i drzwi – otwór w balach ze stolarki i luzów (boczny z obu stron, górny na osiadanie), podpowiedź luzu górnego z wysokości stolarki. |
| `rdzen/styki.rb` | 302 | podział długich ścian na bale – miejsca styków na mijankę (min. 300 mm) w trzech układach, węgły pod styki. |
| `rdzen/szczyty.rb` | 193 | szczyty z bali – które ściany mają szczyt, wieńce szczytu do kalenicy, skos bali wg linii dachu, gniazda pod płatwie. |
| `rdzen/ustawienia_scian.rb` | 124 | ustawienia pojedynczych ścian z widoku ściany – ostatek na każdym końcu, węgły ustawione ręcznie (dodane / usunięte kliknięciem), co jest nad działową (strop, antresola, półka) i jej góra. |
| `rdzen/usztywnienie.rb` | 157 | węgły 244 usztywniające ściany – limit światła ściany (zwykłej i wysokiej), rozmieszczenie nowych węgłów, miejsce, w którym węgieł może stanąć. |
| `rdzen/widok.rb` | 126 | widok ściany do okna – bale jako obrysy w płaszczyźnie ściany (s, z), otwory, styki, skrzyżowania, linia dachu. |
| `rdzen/wience.rb` | 107 | poziomy wieńców każdej ściany – półbal na dole ścian wzdłuż kalenicy, liczba wieńców, wysokości ścian. |
| `rdzen/zamek.rb` | 115 | obróbki zamka na każdym skrzyżowaniu – gniazda górne/dolne i podcięcia boczne bali (zamek 44 × 146 z rysunku IMG-20250930-WA0005). |
| `rdzen/zestawienie.rb` | 74 | zestawienie bali i belek do pliku CSV (Excel) – pozycje z długością, ilością i objętością, sumy grup i całości. |
| `sketchup/atrybuty.rb` | 114 | atrybuty w modelu – zgodność z Dokumentacją 2D (słownik ArteMadera) i zapis wejścia generatora do przebudowy. |
| `sketchup/budowa.rb` | 195 | budowa domu w modelu – grupa domu > grupy ścian W-n > instancje komponentów bali, tagi, usuwanie poprzedniej wersji. |
| `sketchup/eksport.rb` | 60 | zapis plików z wtyczki – wybór miejsca (okno zapisu SketchUpa), zestawienie CSV z ostatniego podglądu, plik tekstowy UTF-8. |
| `sketchup/konwersja.rb` | 71 | przeliczenia między rdzeniem (mm, tablice) a SketchUpem (cale, Geom::Point3d, Geom::Transformation). |
| `sketchup/menu.rb` | 42 | menu Rozszerzenia → ArteMadera Generator Wieńcowy (generuj / edytuj, kontrola, test działania, o wtyczce). |
| `sketchup/okno.rb` | 215 | okno parametrów (UI::HtmlDialog) – dane startowe dla okna, wywołania z JavaScriptu, wyniki do okna. |
| `sketchup/raport.rb` | 187 | test działania w prawdziwym SketchUpie i raport do wysłania – przykładowe domy budowane w operacji cofanej na końcu (model bez zmian), bryły zamknięte i objętości, zaznaczony dom, środowisko, dziennik. |
| `sketchup/sterowanie.rb` | 155 | przebieg pracy z menu – start (linie albo dom do edycji), podgląd, generowanie, kontrola; dane wyniku dla okna. |
| `sketchup/ustawienia.rb` | 128 | zapamiętane ustawienia na komputerze – ostatnio użyte parametry (te same po ponownym uruchomieniu SketchUpa) i szablony. |
| `sketchup/wejscie.rb` | 65 | odczyt zaznaczenia – narysowane linie (obrys, osie działowych, kontrfory) albo istniejący dom z generatora. |
| `html/edycja.js` | 168 | ustawienia pojedynczej ściany pod jej widokiem – ostatek na każdym końcu, węgły dodawane i usuwane kliknięciem w widok, co jest nad działową (strop, antresola, półka) i jej góra. |
| `html/okno.css` | 142 | wygląd okna parametrów. |
| `html/okno.html` | 126 | okno parametrów generatora – układ okna (sekcje formularza budowane przez okno.js z listy parametrów z Ruby). |
| `html/okno.js` | 323 | logika okna parametrów – sekcje i pola z listy parametrów, podpowiedzi, szablony, wywołania Ruby. |
| `html/otwory.js` | 154 | tabela okien i drzwi w oknie – stolarka (ściana, od, szerokość i wysokość stolarki, parapet, luz górny, nazwa), otwór w balach i podpowiedź luzu górnego. |
| `html/rzut.js` | 134 | rzut domu w oknie (SVG) – obrys, ściany i węgły, otwory, punkty odniesienia otworów, opisy W-n. |
| `html/sciana.js` | 217 | widok ściany w oknie (SVG) – bale z numerami pozycji, wieńce, otwory, styki, skrzyżowania z innymi ścianami i węgłami, linia dachu; wybór ściany. |
| `html/tryb.js` | 67 | tryb pól okna – „Podstawowe” (tylko najczęściej zmieniane parametry i te zmienione względem fabrycznych) albo „Wszystkie”. |
| `html/wspolne.js` | 48 | wspólne funkcje okna – element po identyfikatorze, nowy element, czyszczenie, liczby do wyświetlenia. |
| `html/wyniki.js` | 99 | wyniki w oknie – liczby, wysokości, błędy, ostrzeżenia, podpowiedzi, tabela ścian ze stykami, lista bali i belek, rzut. |
| `html/zmiany.js` | 60 | pola zmienione względem ustawień fabrycznych – wyróżnienie etykiety, wartość fabryczna w dymku, liczba zmian w nagłówku sekcji. |
| `testy/atrapa/extensions.rb` | 3 | – |
| `testy/atrapa/sketchup.rb` | 738 | atrapa API SketchUpa (Geom, Sketchup::Model/Entities/Group/ComponentDefinition/Face/Edge, UI) do testów bez SketchUpa. |
| `testy/buduj_rbz.rb` | 28 | paczka instalacyjna .rbz (zip rejestratora i folderu wtyczki) – do instalacji w Menedżerze rozszerzeń SketchUpa. |
| `testy/kolizje_belek.rb` | 69 | wspólne sprawdzenia przestrzenne testów – kolizje belek dachu z balami (punkty próbne), bale ponad linią szczytu. |
| `testy/lista_parametrow.rb` | 73 | generator docs/parametry.md – wszystkie parametry okna (sekcja, etykieta, wartość domyślna, zakres, wybory, podpowiedź) i szablony wbudowane. |
| `testy/losowe_domy.rb` | 222 | losowe domy do testów – obrys (prostokąt, L), działowe, węgły, otwory i parametry z ziarna; sprawdzenie jednego domu. |
| `testy/okno_dane.rb` | 36 | dane okna z prawdziwego przebiegu (atrapa SketchUpa) – wypisuje JSON { init:, wynik:, widok:, widok_szczytu:, widok_dzialowej: } dla testu okna w przeglądarce. |
| `testy/podglad.py` | 83 | rysunek 3D domu z pliku OBJ (testy/podglad.rb) – cały dom i zbliżenie narożnika, do sprawdzenia wzrokowego. |
| `testy/podglad.rb` | 97 | zapis domu testowego do pliku OBJ (siatki pozycji ułożone jak w modelu) – do obejrzenia bez SketchUpa (testy/podglad.py). |
| `testy/pomoc.rb` | 94 | wspólne narzędzia testów – sprawdzenia, licznik błędów, przykładowe obrysy (domy testowe). |
| `testy/ruby27.sh` | 35 | testy rdzenia i warstwy SketchUpa na Ruby 2.7.8 – tej samej linii co Ruby w SketchUpie 2023 (2.7.7); gdy brak, buduje Ruby ze źródeł z GitHuba. |
| `testy/spis_tresci.rb` | 151 | generator spisu treści kodu docs/SPIS_TRESCI.md – tematy → pliki, lista plików, metody i stałe z numerami wierszy. |
| `testy/sprawdz_zasady.rb` | 168 | kontrola zasad kodu – Ruby 2.2, ES5, rdzeń bez API SketchUpa, nagłówki plików, komentarze nad metodami, długość plików, kompilacja, MODULE_FILES. |
| `testy/t_losowe.rb` | 36 | stały zestaw losowych domów (ziarna, które kiedyś ujawniły błąd, i kilka zwykłych) – każdy bez problemów. |
| `testy/t_okno.js` | 335 | okno parametrów w Chromium (Playwright) – sekcje i pola z listy, podpowiedzi, szablony, rzut, tabela otworów, wywołania sketchup.*, wyniki. |
| `testy/t_podloga.rb` | 118 | testy podłogi i statyki – wzory belki, dobór przekroju (minimalny / zalecany / ręczny), izolacja, podpory, układ podwalin i legarów. |
| `testy/t_raport.rb` | 81 | test działania z menu (atrapa SketchUpa) – przykładowe domy bez błędów, budowa cofnięta (model bez zmian), bryły zamknięte i objętości, zaznaczony dom, raport JSON. |
| `testy/t_rdzen.rb` | 223 | testy rdzenia – obrys, ściany, wieńce, styki z mijanką, kontrfory, otwory, pozycje, kolizje w zamkach. |
| `testy/t_sciany_ust.rb` | 159 | testy ustawień pojedynczych ścian z widoku ściany – ostatek na końcu, węgły ręczne, niższa działowa pod stropem / antresolą / półką z dopełnieniem zamka. |
| `testy/t_siatka.rb` | 110 | siatka brył wszystkich pozycji z kilku domów – zamknięta (każda krawędź raz w każdą stronę), objętość równa profilowi. |
| `testy/t_sketchup.rb` | 305 | warstwa SketchUpa na atrapie API – ładowanie wtyczki, okno, generowanie, atrybuty, położenie bali, przebudowa, ręczne zmiany. |
| `testy/t_szczyty.rb` | 135 | testy szczytów i dachu – wieńce do kalenicy, skos bali pod linią dachu, gniazda płatwi, krokwie przy szczycie, belki dachu bez kolizji. |
| `testy/t_wegly.rb` | 140 | testy węgłów usztywniających i łączenia na przemian – limity światła, rozmieszczenie, ściany wysokie, otwory. |
| `testy/t_widok.rb` | 71 | widok ściany do okna – obrysy bali zgodne z profilem, gniazda zamków na skrzyżowaniach, styki, linia dachu, lista ścian. |
| `testy/t_zamek.rb` | 95 | zamek 44 × 146 zgodny z rysunkiem IMG-20250930-WA0005 – wymiary obróbek, luzy, labirynt (tylko poprawne ułożenie bez kolizji). |
| `testy/t_zestawienie.rb` | 51 | zestawienie CSV (rdzeń) i zapis pliku z okna (atrapa SketchUpa) – kolumny, przecinek dziesiętny, sumy, BOM, anulowanie. |
| `testy/uruchom.sh` | 63 | wszystkie testy i kontrole jednym poleceniem – ostatnia linia „WSZYSTKIE ZESTAWY: FAILURES n”. |
| `testy/zrzut_dok2d.rb` | 130 | przykładowy dom zbudowany na atrapie SketchUpa zapisany jako zrzut geometrii Dokumentacji 2D (format „ArteMadera-geometria”) – sprawdzenie, jak Dokumentacja 2D widzi bale i belki generatora. |

## 3. Zawartość plików

### Plugins/arte_madera_generator_wiencowy.rb (51 wierszy)

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

### main.rb (67 wierszy)

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

### rdzen/bale.rb (175 wierszy)

bale każdej ściany w każdym wieńcu – kawałki między otworami i stykami, wycięcia przy otworach, skos szczytu, położenie w układzie domu.

Zależy od: rdzen/geometria.rb, rdzen/parametry.rb, rdzen/wience.rb, rdzen/otwory.rb, rdzen/styki.rb, rdzen/szczyty.rb (zasięg i skos), rdzen/pod_dachem.rb, rdzen/dopelnienie.rb (przedziały nadstawki)
Używają: rdzen/projekt.rb, rdzen/zamek.rb (obróbki), rdzen/pozycje.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 26 | `module Bale` |  |
| 30 | `OKRUCH` | Kawałek bala krótszy niż tyle [mm] przy skosie albo gnieździe to okruch – pomijany zawsze. |
| 35 | `zbuduj(sciany, p)` | Wszystkie bale domu (bez obróbek zamka): { bale: [...], ostrzezenia: [...] }. |
| 60 | `kawalki_wienca(w, wn, i, p, uwagi)` | Kawałki bala w wieńcu: zasięg ściany (pod linią szczytu / dachu; wieniec nadstawki – tylko odcinki dopełnienia) minus otwory przelotowe, podzielony stykami – styki tylko w kawałkach dłuższych niż maksymalny bal; pomija okruchy przy skosie i gniazdach płatwi. |
| 93 | `zasieg(w, z0, p)` | Zasięg wieńca o spodzie z0: pod linią szczytu (ściana ze szczytem), pod linią dachu (ściana pod połacią), cały. |
| 100 | `skosy(w, s0, s1, z0, h, p)` | Skosy kawałka bala wg linii szczytu albo linii dachu nad ścianą. |
| 107 | `koniec_typ(w, s, ciecia, zas, wewn = [])` | Rodzaj końca bala w miejscu s: ostatek (koniec zasięgu z ostatkiem), otwór, gniazdo płatwi, skos szczytu, wolny koniec (także wewnętrzny koniec odcinka nadstawki – lista wewn). |
| 121 | `nowy_bal(w, wn, i, s0, s1, konce, wyciecia)` | Nowy bal z wycięciami od otworów (cechy w układzie bala). |
| 135 | `kontrfor_obecny?(kf, wn, p)` | Czy bal kontrforu w wieńcu wn ma oparcie: bale gospodarza na poziomach lvl ± 1 obecne (bez otworu, pod linią szczytu) w osi kontrforu. |
| 146 | `sprawdz_dlugosci(wynik, p)` | Ostrzeżenia o długościach: kawałek krótszy od najkrótszego, bal dłuższy od maksymalnego. |
| 167 | `polozenie(b, p)` | Położenie bala w układzie domu: początek (lico prawe, czoło s0, spód), osie x (wzdłuż), y (w lewo), z (w górę). |

### rdzen/bryla.rb (159 wierszy)

bryła bala z obróbek – profil wzdłuż bala (przedziały z zakresem grubości i wysokości), przynależność punktu, objętość, podpis.

Zależy od: –
Używają: rdzen/siatka.rb, rdzen/pozycje.rb, rdzen/kontrola.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 18 | `module Bryla` |  |
| 19 | `EPS` |  |
| 21 | `DOKLADNOSC` | Dokładność podpisu bala [mm] – bale różniące się mniej są tą samą pozycją. |
| 24 | `SCAL` | Punkty podziału profilu bliższe niż tyle [mm] są scalane – krawędź krótsza niż tolerancja SketchUpa (0,0254 mm) psuje ścianę bryły, a różnica 0,2 mm jest poniżej dokładności obróbki. |
| 29 | `profil(dl, t, h, cechy)` | Profil: lista przedziałów { xa:, xb:, y0:, y1:, zb_a:, zb_b:, zt_a:, zt_b: } (puste przedziały pominięte). |
| 67 | `klin_ok?(zb_a, zb_b, zt_a, zt_b)` | Czy przedział ma materiał: wysokość dodatnia na co najmniej jednym końcu i nigdzie ujemna – także klin (skos szczytu doprowadzony do spodu bala: wysokość zero na jednym końcu, bal kończy się ostrzem, nie pionowym czołem). |
| 75 | `punkty_podzialu(xs, dl)` | Punkty podziału profilu: 0, dl i punkty wewnętrzne odległe od poprzedniego (i od końców) o więcej niż SCAL. Przedział między scalonymi punktami znika – sąsiednie przedziały biorą ograniczenia ze swojego środka. |
| 82 | `przeciecia(lista)` | Punkty x, w których dwie proste ograniczenia przecinają się wewnątrz wspólnego zakresu. |
| 99 | `wartosci(lista, xa, xb, xm, rodzaj)` | Wartości ograniczenia (min dla wierzchu, max dla spodu) na końcach przedziału xa…xb; aktywne te, które obejmują xm. |
| 107 | `liniowa(g, x)` | Wartość ograniczenia liniowego [x0, x1, z0, z1] w punkcie x. |
| 113 | `zawiera?(prof, x, y, z, eps = 1e-6)` | Czy punkt (x, y, z) w układzie bala jest wewnątrz bryły (ściśle, z marginesem eps). |
| 126 | `objetosc(prof)` | Objętość bryły z profilu [mm³]. |
| 133 | `obrocone(dl, cechy)` | Cechy po obrocie bala o 180° wokół osi pionowej (x → dl − x, lica zamienione). |
| 143 | `podpis(dl, t, h, cechy)` | Podpis bala (tekst) – równe podpisy = identyczna bryła (te same wymiary i obróbki). |
| 152 | `podpis_kanoniczny(dl, t, h, cechy)` | Podpis kanoniczny: [podpis, obrócony?] – mniejszy z podpisów bala i bala obróconego o 180°. |

### rdzen/dach.rb (241 wierszy)

geometria dachu dwuspadowego – linia podparcia (wierzch płatwi), linia szczytu, płatwie w przekroju, krokwie, belki dachu.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wysokość ścian okapowych), rdzen/elementy.rb
Używają: rdzen/szczyty.rb (linia szczytu, gniazda), rdzen/projekt.rb (belki dachu)

| Wiersz | Element | Opis |
|---:|---|---|
| 25 | `module Dach` |  |
| 29 | `kat(p)` | Kąt dachu [rad]. |
| 34 | `tg(p)` | Tangens kąta dachu. |
| 39 | `krokwie?(p)` | Czy układ dachu ma krokwie. |
| 44 | `platwie_posrednie?(p)` | Czy układ dachu ma płatwie pośrednie (między ścienną a kalenicową). |
| 49 | `dodatek_krokwi(p)` | Grubość krokwi w pionie (h / cos kąta) – o tyle wierzch krokwi jest nad linią podparcia [mm]. |
| 55 | `szczyt_do_wierzchu_krokwi?(p)` | Czy szczyt dochodzi do wierzchu krokwi (krokwie obok szczytu), a nie do linii podparcia. |
| 62 | `z_ref(p)` | Wysokość linii podparcia na licu wewnętrznym ściany okapowej [mm] (płatew ścienna na ścianie albo podniesienie). Płatew stojąca na ścianie: bez ścięcia linia przechodzi przez jej wierzch przy krawędzi od okapu, ze ścięciem – przy krawędzi od kalenicy (płatew stoi na ścianie, wierzch ścięty pod dach). |
| 74 | `linia_podparcia(geo, v, p)` | Linia podparcia w punkcie v przekroju [mm]. |
| 82 | `linia_szczytu(geo, v, p)` | Linia szczytu (wierzch bali szczytu) w punkcie v [mm]. |
| 87 | `z_szczytu(geo, p)` | Najwyższy punkt linii szczytu (w kalenicy) [mm]. |
| 93 | `platwie(geo, p)` | Płatwie w przekroju: [{ rodzaj: 'scienna' \| 'posrednia' \| 'kalenicowa', v:, b:, h:, z_spod:, gora: }] (v – oś płatwi, gora – wierzch ścięty: [[dv, dz]] od osi płatwi i od spodu, nil – wierzch poziomy). |
| 124 | `platwa(geo, p, rodzaj, v, b, h, kier)` | Jedna płatew (kier – kierunek do kalenicy): ścięta – najwyższy punkt wierzchu w linii podparcia (krawędź od kalenicy, kalenicowa – w osi), wierzch po skosie; bez ścięcia albo gdy ścięcie zostawiłoby mniej niż 1/3 wysokości – wierzch poziomy na linii przy krawędzi od strony okapu. |
| 140 | `krokwie_u(u1, u2, p, wewn = [])` | Położenia krokwi wzdłuż kalenicy (u) między szczytami w u1 < u2 (osie ścian szczytowych); wewn – osie szczytów na działowych (krokwie z obu stron albo na szczycie). Pozostałe krokwie równo między krokwiami przy szczytach; na koniec bez krokwi wchodzących w inny szczyt i bez nachodzących na siebie (bez_kolizji). |
| 181 | `bez_kolizji(lista, osie, zew, bk, obok_szczytu)` | Krokwie bez kolizji: gdy szczyty sięgają wierzchu krokwi – bez krokwi, której oś jest bliżej osi szczytu niż pół grubości + pół krokwi (np. przy dwóch bliskich szczytach na działowych); nachodzące na siebie – jedna pośrodku. |
| 193 | `elementy(dom, p)` | Belki dachu domu prostokątnego: płatwie wzdłuż kalenicy i krokwie (elementy). dom = { os:, v_a:, v_b:, u1:, u2: }. |
| 210 | `przekroj_platwi(dom, pl)` | Przekrój płatwi ściętej w układzie belki (y – szerokość: przy osi kalenicy x rośnie z v, przy osi y maleje), nil – prostokąt. |
| 218 | `krokwie(dom, geo, p)` | Krokwie obu połaci: od okapu (lico ściany okapowej + dach_okap) do kalenicy, spód na linii podparcia. |
| 236 | `xy(dom, u, v)` | Punkt rzutu z (u wzdłuż kalenicy, v w poprzek). |

### rdzen/dopelnienie.rb (97 wierszy)

dopełnienie zamka nad niższą działową – przy ścianach, które idą wyżej, odcinki działowej (ostatek + grubość + dopelnienie_wewn) aż do góry tamtej ściany, jak 1100 W-6, W-7 i 1200 W-5, W-7.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wysokość ściany), rdzen/szczyty.rb (położenie na szczycie), rdzen/dach.rb (linia podparcia)
Używają: rdzen/projekt.rb (po węgłach, przed gniazdami płatwi), rdzen/wience.rb (wieńce nadstawki), rdzen/bale.rb (kawałki nadstawki)

| Wiersz | Element | Opis |
|---:|---|---|
| 26 | `module Dopelnienie` |  |
| 30 | `planuj(sciany, p)` | Kolumny odcinków dopełnienia wszystkich niższych działowych (w[:dopelnienie]); zwraca ostrzeżenia. |
| 61 | `wysokosc_przy(x, s, t, p)` | Wysokość ściany x w miejscu s (oś skrzyżowania ± pół grubości): [z, czy limit dachu]; ściana ze szczytem – linia podparcia dachu (odcinek wchodzi pod połać po obu stronach szczytu, tam leżą krokwie i deski). |
| 68 | `odcinek(w, s, t, wewn)` | Odcinek dopełnienia na osi działowej przy skrzyżowaniu s: [s0, s1]. |
| 75 | `w_kolumnie?(k, z0, h)` | Czy wieniec nadstawki o spodzie z0 i wysokości h leży w kolumnie k. |
| 80 | `przedzialy(w, wn, zas)` | Przedziały wieńca nadstawki w zasięgu zas: [[s0, s1], …] (sąsiednie kolumny scalone). |

### rdzen/elementy.rb (126 wierszy)

elementy z belek (podłoga, dach) – belka prostopadłościenna w dowolnym położeniu, pozycje identycznych belek, lista zamówienia.

Zależy od: rdzen/geometria.rb, rdzen/bryla.rb (podpis), rdzen/parametry.rb
Używają: rdzen/dach.rb, rdzen/podloga.rb, rdzen/projekt.rb, sketchup/budowa.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `module Elementy` |  |
| 28 | `RODZAJE` | Nazwy rodzajów do komponentów i list: prefiks => [nazwa, tag]. Prefiksy = grupy Dokumentacji 2D (element_roles.rb, PREFIX_GROUPS), nazwy zawierają słowa, po których Dokumentacja 2D rozpoznaje grupę także bez atrybutu. |
| 37 | `pozioma(prefiks, p0, p1, b, h, z_spod, wyrownanie = :os, cechy = [], przekroj = nil)` | Belka pozioma od p0 do p1 (rzut, mm): szerokość b w poprzek – po lewej stronie kierunku przy :lewo, symetrycznie przy :os, po prawej przy :prawo; spód na wysokości z_spod; przekroj – wielokąt (nil – prostokąt b × h). |
| 52 | `ukosna(prefiks, p, d, kat, dl, b, h)` | Belka ukośna (krokiew): oś w płaszczyźnie pionowej wzdłuż kierunku d (rzut), nachylenie kat, początek spodu p. |
| 62 | `nowy(prefiks, dl, b, h, poczatek, x, y, z, cechy)` | Nowy element z osiami (x wzdłuż, y szerokość, z wysokość). |
| 69 | `numeruj(elementy, nr_start)` | Pozycje elementów (identyczne belki = jedna pozycja), numery od nr_start; nazwa „nr-długość”. |
| 100 | `posortowane(elementy)` | Kolejność numeracji: grupa (podłoga, potem dach), prefiks, długość malejąco. |
| 106 | `lista_zamowienia(pozycje)` | Wiersze listy zamówienia elementów: jak Pozycje.lista_zamowienia (przekrój szer. × wys.). |
| 115 | `polozenie_instancji(e)` | Położenie instancji pozycji (obrócona o 180° – początek na drugim końcu, osie x i y odwrócone). |

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

### rdzen/kontrola.rb (160 wierszy)

kontrola wyniku – kolizje bali w słupach zamków, mijanka styków w sąsiednich wieńcach, styki poza zamkiem, długości bali.

Zależy od: rdzen/bryla.rb, rdzen/bale.rb (polozenie), rdzen/zamek.rb (bale_w_zamku), rdzen/parametry.rb
Używają: testy, sketchup/sterowanie.rb (menu „Kontrola”)

| Wiersz | Element | Opis |
|---:|---|---|
| 20 | `module Kontrola` |  |
| 24 | `wszystko(plan)` | Wszystkie kontrole: { kolizje:, mijanka:, za_dlugie:, styki_bez_zamka: } (puste listy = w porządku). |
| 29 | `kolizje(plan)` | Kolizje w słupach zamków: [{ sciany: [id, id], punkt: [x, y], bale: [nr, nr], z: [z0, z1], objetosc: mm³ }]. |
| 48 | `kolizje_slupa(bale, pt, t, p, profile, ids)` | Kolizje w jednym słupie zamka (środek pt, bok t + 2 mm). |
| 89 | `globalny(pol, lx, ly, lz)` | Punkt bala (układ bala) w układzie domu. |
| 95 | `zawiera_globalnie?(pol, prof, c)` | Czy punkt domu leży w bryle bala. |
| 104 | `mijanka(plan)` | Naruszenia mijanki: [{ sciana:, wieniec:, odstep: }] – styki w sąsiednich wieńcach bliżej niż MIJANKA_MIN. |
| 129 | `styki_bez_zamka(plan)` | Styki, których nie trzyma zamek (układy na przemian i para – styk w osi skrzyżowania, gdzie w wieńcu wyżej albo niżej leży bal ściany poprzecznej): [{ sciana:, wieniec:, s: }]. |
| 152 | `za_dlugie(plan)` | Bale dłuższe od maksymalnej długości: [{ sciana:, nazwa:, dl: }]. |

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

### rdzen/otwory.rb (119 wierszy)

otwory okienne i drzwiowe – położenie na ścianie, sprawdzenie, cięcia bali w każdym wieńcu.

Zależy od: rdzen/geometria.rb, rdzen/parametry.rb, rdzen/stolarka.rb (otwór ze stolarki i luzów)
Używają: rdzen/projekt.rb, rdzen/bale.rb, rdzen/styki.rb (omijanie otworów)

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `module Otwory` |  |
| 25 | `TOL_Z` | Bal przecięty otworem na wysokości mniejszej niż tyle [mm] traktujemy jak cały w otworze. |
| 30 | `przypisz(wejscie, sciany, p, wysokosc_sciany)` | Przypisanie otworów do ścian (w[:otwory]); zwraca listę ostrzeżeń. |
| 77 | `dla_wienca(w, z0, h, pasek = TOL_Z)` | gniazdami płatwi, wyciecia: [{ s0:, s1:, strona:, gleb: }], uwagi: [] }. Pasek bala cieńszy niż pasek [mm] (min_pasek_przy_otworze) nad albo pod otworem – bal przecięty w całości (taki pasek się nie trzyma, a w pełnym profilu byłby płytszy niż wpust), z ostrzeżeniem. |
| 107 | `w_otworze?(w, s, z0, z1)` | Czy w miejscu s ściany jest otwór na wysokości [z0, z1] (do kontrforów i styków). |
| 114 | `strefy_zakazane(w, zapas)` | Przedziały s zajęte przez otwory poszerzone o zapas (do wyboru miejsc styków i kontrforów; bez gniazd płatwi). |

### rdzen/parametry.rb (156 wierszy)

sprawdzenie i uzupełnienie parametrów z okna / modelu / ustawień (zakresy, wybory, przekroje, zamek) i odczyt pomocniczy.

Zależy od: rdzen/parametry_lista.rb, log.rb
Używają: rdzen/projekt.rb (normalizacja), wszystkie pliki rdzen/ (odczyt), sketchup/okno.rb, sketchup/ustawienia.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 18 | `module Parametry` |  |
| 20 | `MIJANKA_MIN` | Wymóg użytkownika: styki w sąsiednich wieńcach przesunięte co najmniej o tyle [mm]. |
| 22 | `PRESETY` |  |
| 23 | `DOMYSLNE` |  |
| 28 | `normalizuj(wejscie)` | Pełny zestaw parametrów z wartości użytkownika: [parametry, ostrzeżenia]. Zamek – z presetu lub własny. |
| 42 | `sprawdz(w, v, uwagi)` | Jedna wartość według rodzaju pola; wartość spoza zakresu – granica zakresu i ostrzeżenie. |
| 55 | `wybor(w, v, uwagi)` | Wartość pola wyboru (stare wartości z wcześniejszych kompilacji zamieniane na obecne). |
| 64 | `liczba_w_zakresie(w, v, uwagi)` | Liczba w zakresie min…max (całkowita dla :calkowita). |
| 82 | `zamek_z(wlasny, preset, uwagi)` | Wymiary zamka: preset uzupełniony wartościami użytkownika (sprawdzone, czy zamek się mieści). |
| 103 | `grubosc(p)` | Grubość ściany [mm]. |
| 108 | `krycie(p)` | Rozstaw wieńców = wysokość bryły bala prostego [mm]. |
| 113 | `tak?(p, klucz)` | Czy parametr tak/nie jest włączony. |
| 118 | `przekroj(p, klucz)` | Przekrój parametru jako [szerokość, wysokość] w mm. |
| 123 | `przekroj_z(v)` | Przekrój z tekstu „50x150” / „50×150” / „50*150” → [50.0, 150.0]; nil gdy niepoprawny. |
| 132 | `tekst_przekroju(bh)` | Przekrój jako tekst „50x150”. |
| 137 | `katalog(p, klucz = 'przekroje_katalog')` | Katalog przekrojów (lista „szer×wys” po przecinku) → [[b, h], …] bez niepoprawnych wpisów. |
| 142 | `liczba(v)` | Liczba z tekstu lub liczby (przecinek dziesiętny dozwolony); nil gdy się nie da. |
| 150 | `fmt(v)` | Liczba do komunikatu (bez zbędnego ,0). |

### rdzen/parametry_lista.rb (301 wierszy)

lista wszystkich parametrów – wartość domyślna, etykieta, jednostka, zakres, rodzaj pola, sekcja okna, podpowiedź; presety przekroju bala.

Zależy od: –
Używają: rdzen/parametry.rb (sprawdzanie), sketchup/okno.rb (formularz), sketchup/ustawienia.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 18 | `module ParametryLista` |  |
| 20 | `SEKCJE` | Sekcje okna w kolejności wyświetlania: [klucz, tytuł, otwarta na starcie]. |
| 31 | `TAK_NIE` |  |
| 34 | `LISTA` | Wszystkie parametry (kolejność = kolejność w oknie w ramach sekcji). |
| 242 | `SZABLONY` | Szablony wbudowane (okno – lista szablonów): nazwa => wartości różne od domyślnych. |
| 253 | `STARE_WARTOSCI` | Wartości z wcześniejszych kompilacji zapisane w modelach: klucz => { stara => nowa }. |
| 258 | `PRESETY` | Presety przekroju: wymiary bala i zamka [mm]. Klucze zamka czyta rdzen/zamek.rb. |
| 273 | `OPISY_ZAMKA` | Opisy wymiarów zamka w oknie: klucz presetu => [etykieta, jednostka]. |
| 283 | `wpis(klucz)` | Wpis parametru po kluczu (nil – nie ma takiego). |
| 288 | `domyslne` | Wartości domyślne wszystkich parametrów: { klucz => wartość }. |
| 295 | `wybory(w)` | Lista wyborów pola (preset – z PRESETY). |

### rdzen/pod_dachem.rb (83 wierszy)

bale wystające pod połać – węgły na ścianach okapowych i działowe w poprzek kalenicy ścięte linią dachu (spód krokwi / desek); ostrzeżenie o zbyt stromym dachu.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb, rdzen/dach.rb (linia podparcia), rdzen/szczyty.rb (skosy_linii)
Używają: rdzen/projekt.rb, rdzen/bale.rb (zasięg i skos bali pod dachem)

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module PodDachem` |  |
| 26 | `przygotuj(sciany, p, dom)` | Oznacza ściany pod połacią (w[:pod_dachem]); zwraca ostrzeżenia (dach zbyt stromy dla ściany okapowej). |
| 48 | `v_z_s(w, s)` | Współrzędna v punktu s ściany pod dachem. |
| 54 | `linia(w, s, p)` | Linia podparcia nad punktem s ściany [mm]; ściana nie pod dachem – nil. |
| 60 | `zasieg(w, z0, p)` | Zasięg [s0, s1] wieńca o spodzie z0 pod linią dachu (najniższy kawałek jak w szczycie); nil – cały nad dachem. |
| 75 | `skosy(w, s0, s1, z0, h, p)` | Skosy kawałka bala s0…s1 (spód z0, wysokość h) pod linią dachu; [] gdy mieści się pod połacią. |

### rdzen/podloga.rb (301 wierszy)

podłoga domu prostokątnego – podwaliny pod ścianami (zakład w narożnikach), legary między podwalinami, podciągi pod legarami, dobór przekroju i podpowiedzi.

Zależy od: rdzen/parametry.rb, rdzen/geometria.rb, rdzen/statyka.rb, rdzen/elementy.rb
Używają: rdzen/projekt.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module Podloga` |  |
| 25 | `OPARCIE` | Zapas oparcia doliczany do światła przęsła w obliczeniach [mm]. |
| 30 | `zaplanuj(sciany, p)` | Podłoga: { elementy: [...], podpowiedzi: [{ poziom: 'ok' \| 'uwaga' \| 'blad', tekst: }], legar: [b, h] \| nil }. |
| 50 | `uklad(sciany, p)` | Układ podłogi: kierunek legarów (id – indeks osi wzdłuż legarów), zasięgi, ściany zewnętrzne i działowe z podwalinami. |
| 68 | `podwaliny(u, p)` | Podwaliny: zewnętrzne licem z licem ściany i na zakład w narożnikach, pod działowymi w osi (dosunięte do podwalin). |
| 89 | `odcinki_dzialowej(u, w)` | Odcinki podwaliny działowej [s0, s1] na jej osi: końce przy podwalinach innych ścian, działowe wzdłuż legarów przerwane na podwalinach działowych poprzecznych. |
| 112 | `wzdluz_legarow?(u, w)` | Czy ściana biegnie wzdłuż legarów. |
| 117 | `pelna?(w)` | Czy działowa przechodzi przez całą szerokość domu (oba końce na ścianach zewnętrznych). |
| 125 | `przesla(u)` | Przęsła legarów: [[f1, f2], …] – między licami podwalin prostopadłych do legarów na całej szerokości. |
| 139 | `linie_legarow(u, p)` | Linie legarów (współrzędna e poprzecznie): równo w polach między podwalinami bocznymi i działowymi wzdłuż legarów. |
| 155 | `dobierz(u, p, podp)` | Dobór przekroju legara i liczby podpór w każdym przęśle; [[b, h], [podpory w przęsłach]] albo [nil, nil]. |
| 189 | `podpory_w_przesle(l, lmax, p)` | Liczba podpór w przęśle długości l przy największej rozpiętości lmax legara; nil – nie da się. |
| 198 | `objetosc(u, p, bh, przes, n)` | Objętość drewna legarów i podpór [m³] – kryterium wyboru między większym przekrojem a podporami. |
| 209 | `podpowiedzi(u, p, bh, przes, n, podp)` | Podpowiedzi do okna: ocena legara, przekroje najmniejszy i zalecany, izolacja, wysokość podwaliny, podpory. |
| 249 | `legary(u, p, bh)` | Legary: każda linia dzielona na licach podwalin poprzecznych (także działowych częściowych) i omija podwaliny wzdłuż. |
| 280 | `podpory_elementy(u, p, bh, n)` | Podpory legarów: w każdym przęśle n belek w poprzek, równo, pod legarami (między podwalinami bocznymi). |
| 296 | `punkt(u, d, e)` | Punkt rzutu z (d wzdłuż legarów, e w poprzek). |

### rdzen/pozycje.rb (75 wierszy)

numeracja pozycji jak u producenta – identyczne bale (ta sama bryła, także po obrocie o 180°) dostają jedną pozycję „nr-długość”.

Zależy od: rdzen/bryla.rb, rdzen/parametry.rb, rdzen/profil_bala.rb (opis pełnego profilu w pozycji)
Używają: rdzen/projekt.rb, sketchup/budowa.rb (jedna definicja komponentu na pozycję)

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module Pozycje` |  |
| 26 | `numeruj(bale, p)` | Pozycje wszystkich bali (lista w kolejności numerów). |
| 53 | `posortowane(bale)` | Bale w kolejności numeracji: numer ściany, wieniec, położenie wzdłuż ściany. |
| 58 | `prefiks_bala(b)` | Prefiks grupy w Dokumentacji 2D: bale ścienne (Bs), kontrfory (Kf), bale szczytu (Sz). |
| 64 | `lista_zamowienia(pozycje, p)` | Lista do zamówienia: [{ nazwa:, prefiks:, przekroj:, dl:, ilosc:, objetosc_m3: }] (przekrój jak w listach producenta). |

### rdzen/profil_bala.rb (137 wierszy)

pełny profil bala do wizualizacji – pióra na wierzchu i wpust od spodu (pierwszy wieniec bez wpustu); przekrój pasami wzdłuż grubości, objętość.

Zależy od: rdzen/parametry.rb, rdzen/bryla.rb (punkty podziału, przecięcia ograniczeń, wartości)
Używają: rdzen/projekt.rb (siatka i objętość pozycji, oznaczenie bali bez wpustu), rdzen/pozycje.rb (opis profilu w pozycji), rdzen/siatka.rb (pasy)

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module ProfilBala` |  |
| 23 | `EPS` |  |
| 26 | `WYROWNAJ` | Wierzchy / spody pasów bliższe niż tyle [mm] na końcu przedziału są wyrównywane do niższego – inaczej skos zaczynający się tuż nad wierzchem bala (0,06 mm) dałby krawędź krótszą niż tolerancja SketchUpa. |
| 31 | `pelny?(p)` | Czy model ma pełny profil bala. |
| 36 | `opis(p)` | Opis profilu z parametrów (pióra i wpusty w poprzek bala); nil – bal prosty. |
| 48 | `oznacz(bale, p)` | Bale na spodzie domu (pierwszy wieniec, półbal) bez wpustu – cecha 'bez_wpustu' (inna pozycja niż bal z wpustem). |
| 57 | `pasy_przekroju(t, opis, bez_wpustu)` | Pasy przekroju: [[y0, y1, nadwyżka wierzchu (pióro), podniesienie spodu (wpust)]] od lica prawego. |
| 70 | `przedzialy(dl, t, h, cechy, opis)` | Przedziały pełnego profilu bala dl × t × h z obróbkami (cechy jak Bryla.profil) – patrz opis pliku. |
| 96 | `przedzial(xa, xb, t, pasy, boki)` | Jeden przedział xa…xb: pasy z wierzchem i spodem (ograniczenia pasa w środku przedziału), zwężone podcięciami. |
| 119 | `wyrownaj!(pasy, klucz)` | Wyrównanie wartości (wierzchów albo spodów na jednym końcu) różnych o mniej niż WYROWNAJ – do najniższej z grupy. |
| 128 | `objetosc(prof)` | Objętość przedziałów (pełny profil albo prosty – Bryla.profil) [mm³]. |

### rdzen/projekt.rb (144 wierszy)

przebieg obliczeń domu od linii do listy bali i belek (kolejność kroków) i podsumowanie do okna – bez API SketchUpa.

Zależy od: wszystkie pliki rdzen/
Używają: sketchup/sterowanie.rb, testy

| Wiersz | Element | Opis |
|---:|---|---|
| 26 | `module Projekt` |  |
| 31 | `oblicz(wejscie)` | Cały przebieg: obrys → ściany → ustawienia ścian → szczyty → otwory → styki → węgły → dopełnienie nad niższymi działowymi → gniazda płatwi → bale → zamki → pozycje → belki dachu i podłogi. |
| 75 | `belki(plan, dom, p)` | Belki dachu (dom prostokątny) i podłogi: elementy, pozycje (numery po balach), podpowiedzi podłogi. |
| 85 | `uwagi_o_stykach(plan)` | Ostrzeżenia o stykach, których nie trzyma zamek (wieńce szczytu nad węgłem, który kończy się pod połacią). |
| 93 | `podsumowanie(plan)` | Podsumowanie do okna: ściany, liczby bali i pozycji, objętość i waga, wysokości. |
| 118 | `styki_opis(w)` | Styki ściany do okna: [styki wieńców parzystych, nieparzystych] w mm od początku osi (puste – bez styków). |
| 126 | `siatka_pozycji(poz)` | Siatka bryły pozycji (do budowy komponentu): Siatka.z_profilu dla profilu pozycji (pełny profil bala – z piórem i wpustem, gdy pozycja ma opis profilu). |
| 132 | `profil_pozycji(poz)` | Profil bryły pozycji: pełny (rdzen/profil_bala.rb) albo prosty (rdzen/bryla.rb). |
| 138 | `objetosc_pozycji(poz)` | Objętość bryły pozycji [mm³] (pełny albo prosty profil). |

### rdzen/pryzmat.rb (69 wierszy)

belka o przekroju wielokątnym (graniastosłup) – siatka ścian, objętość, podpis i postać kanoniczna przekroju (np. płatew ścięta do płaszczyzny dachu).

Zależy od: –
Używają: rdzen/elementy.rb (pozycje belek z przekrojem), rdzen/projekt.rb (siatka i objętość pozycji)

| Wiersz | Element | Opis |
|---:|---|---|
| 17 | `module Pryzmat` |  |
| 21 | `siatka(dl, przekroj)` | Siatka graniastosłupa: dwa czoła i ściana na każdym boku przekroju. |
| 39 | `pole(przekroj)` | Pole przekroju [mm²] (wzór Gaussa). |
| 49 | `objetosc(dl, przekroj)` | Objętość [mm³]. |
| 54 | `podpis(przekroj)` | Podpis przekroju (punkty zaokrąglone do 0,1 mm) – do rozpoznania identycznych belek. |
| 60 | `kanoniczny(przekroj, b)` | Postać kanoniczna: przekrój albo jego odbicie (y → b − y, belka obrócona o 180° wokół pionu) – mniejszy podpis; [przekrój, czy_obrócony]. |

### rdzen/przyklady.rb (63 wierszy)

przykładowe domy do testu działania w SketchUpie (i w testach) – linie, parametry i otwory.

Zależy od: –
Używają: sketchup/raport.rb (test działania), testy/t_raport.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `module Przyklady` |  |
| 20 | `prostokat(x0, y0, x1, y1)` | Odcinki prostokąta (lico zewnętrzne). |
| 25 | `wielokat(punkty)` | Odcinki wielokąta zamkniętego. |
| 30 | `otwor(sciana, od, szer, wys, parapet, nazwa)` | Otwór w tabeli otworów (jak z okna). |
| 35 | `lista` | Lista przykładów: [{ 'nazwa' =>, 'wejscie' => { 'segmenty', 'z0', 'parametry', 'otwory', 'sciany' } }]. |
| 57 | `dom(nazwa, segmenty, parametry, otwory, sciany = {})` | Przykład: nazwa i wejście domu (sciany – ustawienia ścian z widoku ściany). |

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

### rdzen/siatka.rb (385 wierszy)

siatka ścian (płaskich wielokątów z otworami) zamkniętej bryły bala z profilu – do budowy komponentu w SketchUpie.

Zależy od: rdzen/bryla.rb (profil prosty), rdzen/profil_bala.rb (pasy pełnego profilu)
Używają: sketchup/budowa.rb, testy/t_siatka.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module Siatka` |  |
| 24 | `KLUCZ` | Krok klucza wierzchołka [mm]. |
| 29 | `z_profilu(prof)` | Siatka bryły z profilu (patrz Bryla.profil): { sciany: [...], wierzcholki: n }. |
| 37 | `sciany_surowe(prof)` | Ściany przedziałów i czoła, każda: { n: normalna, p: [punkty] } (kolejność przeciwna do wskazówek patrząc z zewnątrz). |
| 59 | `pasy(q)` | Pasy przedziału: pełny profil – lista pasy, profil prosty – jeden pas y0…y1. |
| 64 | `boki_y(xa, xb, ps)` | Boki pasów przedziału xa…xb na granicach y: część pasa niezakryta przez pas sąsiedni (po drugiej stronie granicy). |
| 77 | `roznica(a, b)` | Część pasa a niezakryta przez pas b (nil – cały): [[spód [z_a, z_b], wierzch [z_a, z_b]]] – do dwóch trapezów. |
| 88 | `trapez(xa, xb, y, dol, gora, kier)` | Trapez boku w płaszczyźnie y od spodu dol do wierzchu gora (normalna ±y); [] gdy zerowej wysokości. |
| 101 | `czolo(x, lewe, prawe)` | Czoło w płaszczyźnie x: komórki przekroju lewego bez prawego (normalna +x) i prawego bez lewego (−x); przekroje z pasów (lewy – wartości na końcu b, prawy – na początku a). |
| 131 | `normalna(pts)` | Normalna jednostkowa trójkąta a, b, c. |
| 141 | `klucz(pt)` | Klucz wierzchołka (zaokrąglone współrzędne). |
| 146 | `punkty_t(sciany)` | Wstawia do krawędzi ścian wierzchołki innych ścian, które na nich leżą (siatka bez punktów T). |
| 164 | `indeks_osi(wszystkie)` | Indeks wierzchołków dla krawędzi równoległych do osi: klucz pozostałych dwóch współrzędnych → punkty. |
| 175 | `kandydaci(a, b, idx)` | Wierzchołki, które mogą leżeć na krawędzi a–b (dla krawędzi wzdłuż osi – tylko z tej samej prostej). |
| 185 | `na_krawedzi(a, b, lista)` | Wierzchołki leżące wewnątrz odcinka a–b, uporządkowane od a. |
| 205 | `bez_powtorzen(pts)` | Usuwa kolejne powtórzone punkty pętli. |
| 213 | `scal(sciany)` | Scalanie ścian tej samej płaszczyzny: krawędzie przeciwne się znoszą, z reszty powstają pętle (zewnętrzne i otwory). |
| 248 | `pety(krawedzie, punkty, n)` | Pętle z krawędzi skierowanych (na rozwidleniu – najostrzejszy skręt w lewo względem normalnej). |
| 280 | `skret(a, b, c, n)` | Kąt skrętu w lewo (−π…π) przy przejściu a → b → c, patrząc wzdłuż normalnej. |
| 290 | `uloz(petle, n)` | Podział pętli na zewnętrzne (pole dodatnie względem normalnej) i otwory przypisane do zawierającej je pętli. |
| 303 | `pole(pts, n)` | Pole pętli ze znakiem względem normalnej. |
| 317 | `wewnatrz?(pt, petla, n)` | Punkt wewnątrz pętli (rzut na płaszczyznę bez największej składowej normalnej). |
| 337 | `uprosc(sciany)` | Siatka do rysowania: usunięte wierzchołki leżące na prostej we wszystkich pętlach, w których występują (zostają tylko narożniki i punkty styku z innymi ścianami – krawędzie sąsiednich ścian dalej się pokrywają). |
| 355 | `wspolliniowy?(a, b, c)` | Czy b leży na prostej a–c między nimi (przejście na wprost). |
| 363 | `sprawdz(sciany)` | Kontrola siatki: { zamknieta:, objetosc:, bledne_krawedzie: } – każda krawędź raz w każdą stronę. |

### rdzen/statyka.rb (91 wierszy)

sprawdzenie belki drewnianej swobodnie podpartej (zginanie, ścinanie, ugięcie końcowe), największa rozpiętość, dobór przekroju z katalogu.

Zależy od: rdzen/parametry.rb
Używają: rdzen/podloga.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `module Statyka` |  |
| 21 | `KLASY` | Klasy drewna: wytrzymałość na zginanie i ścinanie f_m,k, f_v,k [MPa], moduł E0,mean [MPa], gęstość [kg/m³], γM. |
| 27 | `KMOD` |  |
| 28 | `KDEF` |  |
| 29 | `PSI2` |  |
| 30 | `KCR` |  |
| 36 | `belka(l, b, h, g, q, klasa, granica)` | Sprawdzenie belki: l [mm], b × h [mm], obciążenia stałe g i użytkowe q [kN/m] bez ciężaru własnego, granica L/n. Wynik: { wyk_m:, wyk_v:, u:, l_przez_u:, nosnosc_ok:, ugiecie_ok:, ok: }. |
| 56 | `obciazenia(p, rozstaw)` | Obciążenia legara [kN/m] z parametrów i rozstawu: [g, q]. |
| 61 | `max_rozpietosc(b, h, p, rozstaw, granica)` | Największa rozpiętość [mm], przy której belka spełnia nośność i ugięcie L/granica (szukanie połówkowe). |
| 74 | `kandydaci(p)` | Przekroje z katalogu nie niższe niż izolacja, od najlżejszego (przy równym polu – wyższy pierwszy). |
| 80 | `dobierz(l, p, rozstaw, granica)` | Najlżejszy przekrój z katalogu (nie niższy niż izolacja), który przenosi rozpiętość l; nil gdy żaden. |
| 86 | `granica(p, tryb = p['legary_dobor'])` | Granica ugięcia L/n dla trybu doboru ('minimalny' – dopuszczalna, inne – zalecana). |

### rdzen/stolarka.rb (51 wierszy)

stolarka okien i drzwi – otwór w balach ze stolarki i luzów (boczny z obu stron, górny na osiadanie), podpowiedź luzu górnego z wysokości stolarki.

Zależy od: rdzen/parametry.rb
Używają: rdzen/otwory.rb (otwór w balach), rdzen/widok.rb (stolarka w widoku ściany); html/otwory.js liczy to samo w oknie

| Wiersz | Element | Opis |
|---:|---|---|
| 20 | `module Stolarka` |  |
| 22 | `KROK` | Podpowiedź luzu górnego zaokrąglana w górę do tylu mm. |
| 27 | `luz_podpowiedz(h, p)` | Podpowiedź luzu górnego (osiadanie) dla stolarki o wysokości h [mm]. |
| 34 | `luz_gorny(o, h, p)` | Luz górny otworu: wpisany w wierszu (liczba ≥ 0) albo podpowiedź; [luz, czy_podpowiedz]. |
| 42 | `otwor(s0, szer, wys, parapet, o, p)` | Otwór w balach ze stolarki: { s0:, s1:, z0:, z1:, stolarka: { s0:, s1:, z0:, z1: }, luz_gorny:, podpowiedz: }; s0 – krawędź otworu na osi ściany (punkt odniesienia + od). |

### rdzen/styki.rb (302 wierszy)

podział długich ścian na bale – miejsca styków na mijankę (min. 300 mm) w trzech układach, węgły pod styki.

Zależy od: rdzen/parametry.rb, rdzen/sciany.rb (dodaj_kontrfor), rdzen/otwory.rb (strefy otworów), rdzen/usztywnienie.rb (miejsce_ok?, wolne_miejsce)
Używają: rdzen/projekt.rb, rdzen/bale.rb (pozycje_w_wiencu)

| Wiersz | Element | Opis |
|---:|---|---|
| 25 | `module Styki` |  |
| 27 | `KROK` | Krok siatki miejsc na nowy węgieł [mm] (od początku osi ściany – okrągłe odległości od narożnika). |
| 29 | `LIMIT_WEZLOW` | Najwięcej kroków przeszukiwania układu na przemian dla jednej liczby kotwic. |
| 34 | `planuj(sciany, p, os_kalenicy)` | Miejsca styków dla wszystkich ścian (zewnętrznych i działowych); dostawia węgły pod styki. Zwraca ostrzeżenia. |
| 57 | `pozycje_w_wiencu(w, i)` | Położenia styków w wieńcu o indeksie i (0 = najniższy wieniec ściany). |
| 65 | `kotwice(w, p)` | Istniejące skrzyżowania wewnątrz ściany, w których może wypaść styk (bez narożników i za blisko otworów). Ściana ze szczytem – tylko węgły: działowa kończy się pod okapem, a styki w wieńcach szczytu też muszą leżeć w zamku. |
| 72 | `poza_otworami?(w, p, s)` | Czy styk w miejscu s jest dość daleko od otworów (styk_odstep_od_otworu, nie bliżej niż węgieł od otworu). |
| 78 | `miejsce_styku_ok?(w, p, s, zajete)` | Czy w miejscu s może stanąć nowy węgieł pod styk (miejsce na węgieł i odstęp styku od otworów). |
| 83 | `kawalki_ok?(w, listy, lmax)` | Czy kawałki bali w każdym wieńcu mieszczą się w maksymalnej długości (listy styków: parzyste, nieparzyste). |
| 93 | `na_przemian(w, p)` | Układ na przemian: najmniej nowych węgłów, potem najmniej kotwic; nil – nie da się. |
| 114 | `przemian_k(w, p, k, kotwy, siatka)` | Najlepszy układ na przemian dla k kotwic: { kotwy:, nowe:, ocena: } albo nil. |
| 121 | `przemian_szukaj(w, p, k, kotwy, siatka, a, nowe, odch, stan)` | Krok przeszukiwania: następna kotwica – istniejące skrzyżowanie (do 3 najbliższych celu) albo nowy węgieł. |
| 146 | `przemian_zakres(w, p, k, a)` | Zakres [lo, hi] kotwicy nr a.length: kawałek od poprzedniej kotwicy tej samej parzystości ≤ maks. długość, od poprzedniej kotwicy ≥ mijanka, pozostałe kotwice tej parzystości muszą jeszcze dosięgnąć końca ściany. |
| 158 | `wolna_siatka(w, p)` | Miejsca (co KROK od początku osi), w których może stanąć nowy węgieł – bez względu na inne nowe węgły. |
| 170 | `najblizsze_wolne(siatka, cel, lo, hi, zajete, min)` | Najbliższe celu miejsce z siatki w zakresie lo…hi, odległe od zajętych o ≥ min; nil gdy brak. |
| 189 | `indeks_od(lista, x)` | Indeks pierwszego elementu posortowanej listy ≥ x (długość listy, gdy brak) – wyszukiwanie połówkowe. |
| 202 | `dobierz_regiony(w, p)` | Regiony łączenia [{ a:, b:, c:, nowe: [s] }] albo nil; próbuje coraz większej liczby bali. |
| 216 | `proba(w, p, m)` | Jedna próba podziału na m bali: regiony przy punktach docelowych s_od + j·dł/m. |
| 234 | `najlepszy_region(w, p, cel, okno, zajete, regiony = [])` | Najlepszy region przy punkcie cel: najmniej nowych węgłów, potem najbliżej celu; z zachowaniem mijanki względem regionów już wybranych (styki wieńców parzystych i nieparzystych co najmniej mijanka od siebie). |
| 243 | `mijanka_ok?(regiony, d)` | Czy styki regionów (a – wieńce parzyste, b – nieparzyste) są w sąsiednich wieńcach co najmniej d od siebie. |
| 248 | `kandydaci_para(w, p, cel, okno, zajete)` | Kandydaci układu para: dwie istniejące kotwice, kotwica + nowy węgieł, dwa nowe węgły. |
| 271 | `kandydaci_jeden(w, p, cel, okno, zajete)` | Kandydaci układu jeden węgieł: istniejące kotwice i nowy węgieł; styki ± mijanka/2 poza zamkami i otworami. |
| 285 | `styki_poza_zamkami?(w, p, x)` | Układ jeden węgieł: oba styki x ± mijanka/2 poza zamkami innych skrzyżowań (z zapasem grubości) i z dala od otworów. |
| 294 | `z_regionow(_w, p, regiony)` | Wynik ściany z regionów (para / jeden węgieł); nil gdy brak regionów. |

### rdzen/szczyty.rb (193 wierszy)

szczyty z bali – które ściany mają szczyt, wieńce szczytu do kalenicy, skos bali wg linii dachu, gniazda pod płatwie.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb, rdzen/dach.rb (linia szczytu, płatwie)
Używają: rdzen/projekt.rb, rdzen/wience.rb (liczba wieńców szczytu), rdzen/bale.rb (zasięg i skos bali), rdzen/pozycje.rb (prefiks Sz)

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `module Szczyty` |  |
| 25 | `przygotuj(sciany, p, os_kalenicy)` | Ściany ze szczytem (w[:szczyt]) i opis dachu domu prostokątnego; zwraca { uwagi:, dom: (nil – bez belek dachu) }. |
| 51 | `szczytowa?(w, p)` | Czy ściana dostaje szczyt: zewnętrzna szczytowa od narożnika do narożnika albo działowa szczytowa od ściany do ściany (niższa działowa – pod stropem, antresolą, półką – szczytu nie ma). |
| 61 | `dom_prostokatny(sciany, szczytowe, os)` | Opis dachu domu prostokątnego (4 ściany zewnętrzne, 2 szczyty): { os:, v_a:, v_b:, u1:, u2:, wewn: [u szczytów na działowych] }; nil w innym przypadku. |
| 73 | `v_z_s(w, s)` | Współrzędna v punktu s ściany ze szczytem. |
| 78 | `s_z_v(w, v)` | Współrzędna s ściany dla v. |
| 83 | `linia(w, s, p)` | Linia szczytu (wierzch bali) w miejscu s ściany [mm]; bez szczytu – nil. |
| 89 | `pod_linia?(w, s, z, p)` | Czy wysokość z w miejscu s ściany jest pod linią szczytu (ściana bez szczytu – zawsze). |
| 96 | `pod_podparciem?(w, s, z, p)` | Czy wysokość z w miejscu s ściany jest pod linią podparcia (spód krokwi / desek) – dla węgłów przy szczycie, które wystają z obu stron szczytu pod połać; ściana bez szczytu – zawsze. |
| 102 | `zasieg(w, z0, p)` | Zasięg [s0, s1] wieńca o spodzie z0, w którym linia szczytu jest wyżej niż z0 + najniższy kawałek; nil – brak bala. |
| 117 | `skosy(w, s0, s1, z0, h, p)` | Obróbki skosu dla kawałka bala s0…s1 o spodzie z0 i wysokości h: [cechy skos_gora w układzie bala]. |
| 125 | `skosy_linii(s0, s1, z0, h, sk)` | Skosy kawałka s0…s1 pod linią daszkową (blok: s → wysokość linii; załom w sk): odcinki, na których linia schodzi poniżej wierzchu bala. |
| 140 | `gniazda(sciany, p, dom)` | Gniazda płatwi (otwory z gniazdo: true); wywołać po stykach i węgłach. Dom prostokątny – każda ściana i węgieł, przez które przechodzi płatew (także działowe i węgły pod płatwią ścienną); inny obrys – tylko szczyty. |
| 159 | `gniazda_sciany(w, platwie, iv, p)` | Gniazda jednej ściany od płatwi domu prostokątnego (iv – indeks współrzędnej v): ściana w poprzek płatwi – gniazdo na szerokości płatwi z luzem; ściana wzdłuż płatwi i pod nią – na całej długości. |
| 179 | `dodaj_gniazdo(w, s, pl)` | Gniazdo płatwi w ścianie: otwór od spodu płatwi w górę na odcinku s. |
| 186 | `bal_szczytu?(b)` | Czy bal należy do szczytu (prefiks Sz): ma skos albo leży nad ścianami okapowymi. |

### rdzen/ustawienia_scian.rb (124 wierszy)

ustawienia pojedynczych ścian z widoku ściany – ostatek na każdym końcu, węgły ustawione ręcznie (dodane / usunięte kliknięciem), co jest nad działową (strop, antresola, półka) i jej góra.

Zależy od: rdzen/parametry.rb, rdzen/sciany.rb (dodaj_kontrfor, sprawdz_miejsce_kontrforu)
Używają: rdzen/projekt.rb (zaraz po numeracji ścian), rdzen/widok.rb (stan dla panelu ściany)

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `module UstawieniaScian` |  |
| 25 | `NAD` | Co może być nad działową: nic (pełna wysokość) albo to, co pozwala ją obniżyć. |
| 27 | `OPISY_NAD` | Opisy dla okna i ostrzeżeń. |
| 30 | `OSTATEK_MIN` | Zakres ostatka ustawianego na końcu ściany [mm] (jak parametr ostatek). |
| 31 | `OSTATEK_MAX` |  |
| 36 | `zastosuj(sciany, ustawienia, p, os_kalenicy)` | Ustawienia ścian do planu (po numeracji ścian, przed szczytami i stykami); zwraca ostrzeżenia. |
| 54 | `ostatki(w, u, p, uwagi)` | Ostatki na końcach ściany (tylko końce, które mają ostatek – nie wolne końce działowych). |
| 77 | `wegly(sciany, w, lista, p, os_kalenicy, uwagi)` | Węgły ręczne ściany: usunięte węgły narysowane na tej ścianie, dostawione z listy (miejsca sprawdzone), automat (usztywnienie, styki) na tej ścianie wyłączony – w[:wegly_reczne]. |
| 95 | `usun_kontrfor(sciany, kf)` | Usunięcie węgła (ściany kontrforu i jego skrzyżowania z gospodarzem). |
| 101 | `nad(w, u, p)` | Co jest nad działową i jej góra: w[:nizsza] = { nad:, z: } (brak – pełna wysokość). |
| 114 | `stan(w, p)` | Stan ustawień ściany dla okna: ostatki końców (nil – wolny koniec), węgły ręczne, co nad działową. |

### rdzen/usztywnienie.rb (157 wierszy)

węgły 244 usztywniające ściany – limit światła ściany (zwykłej i wysokiej), rozmieszczenie nowych węgłów, miejsce, w którym węgieł może stanąć.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wysokość ścian), rdzen/sciany.rb (dodaj_kontrfor), rdzen/otwory.rb (strefy otworów)
Używają: rdzen/projekt.rb, rdzen/styki.rb (miejsce_ok?, wolne_miejsce)

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module Usztywnienie` |  |
| 24 | `KROK` | Krok przesuwania nowego węgła przy szukaniu wolnego miejsca [mm]. |
| 29 | `limit_swiatla(p)` | Limit światła ściany dla tego domu (zwykły albo dla ścian wysokich) [mm]. |
| 35 | `planuj(sciany, p, os_kalenicy)` | Dostawia węgły tam, gdzie światło ściany przekracza limit; zwraca ostrzeżenia. |
| 69 | `przeslony(w)` | Odcinki ściany między kolejnymi podparciami: [[s_a, s_b, narożnik_a?, narożnik_b?], …] (osie skrzyżowań). |
| 76 | `rozmiesc(w, p, a, b, limit)` | Położenia nowych węgłów w odcinku a…b (rozmieszczenie z parametrów); nil – nie da się. „od_naroznikow”: przy każdym narożniku odcinka węgieł w zadanej odległości (symetrycznie), reszta równo. |
| 105 | `rowno(w, p, a, b, limit, zajete)` | Węgły równo w odcinku a…b: najmniejsza liczba, przy której każde światło ≤ limit; nil – nie da się. |
| 127 | `naroznik?(w, s)` | Czy w miejscu s ściany jest narożnik. |
| 133 | `miejsce_ok?(w, p, s, zajete)` | Czy w miejscu s może stanąć nowy węgieł (odstęp od skrzyżowań, otworów, końców ściany); ściana z węgłami ustawionymi ręcznie – nigdzie (automat jej nie zmienia). |
| 145 | `wolne_miejsce(w, cel, lo, hi)` | Najbliższe celu miejsce w zakresie lo…hi (krok KROK), dla którego blok zwraca prawdę; nil gdy brak. |

### rdzen/widok.rb (126 wierszy)

widok ściany do okna – bale jako obrysy w płaszczyźnie ściany (s, z), otwory, styki, skrzyżowania, linia dachu.

Zależy od: rdzen/parametry.rb, rdzen/bryla.rb (profil bala), rdzen/szczyty.rb, rdzen/pod_dachem.rb (linia dachu), rdzen/ustawienia_scian.rb (stan ustawień), rdzen/wience.rb
Używają: sketchup/sterowanie.rb (widok dla okna), html/sciana.js (rysunek)

| Wiersz | Element | Opis |
|---:|---|---|
| 26 | `module Widok` |  |
| 30 | `lista(plan)` | Ściany do wyboru w oknie: [[id, rodzaj]] – ściany z balami bez kontrforów (węgły widać na ścianach). |
| 36 | `sciana(plan, id)` | Widok jednej ściany (Hash z kluczami tekstowymi) albo nil, gdy ściany nie ma. |
| 55 | `bal(b, t)` | Bal w widoku: obrys [[s, z]], pozycja, wieniec, końce. |
| 64 | `obrys(b, t)` | Obrys bala w płaszczyźnie ściany z profilu: wierzch od lewej do prawej, spód z powrotem; ciągłe odcinki profilu (przerwa w profilu – bal pokazany do przerwy). |
| 79 | `uprosc(punkty)` | Punkty bez powtórzeń i bez punktów leżących na prostej między sąsiadami. |
| 94 | `wience(w)` | Wieńce ściany: [[nr, z0, h]] od dołu (z bali). |
| 99 | `otwory(w)` | Otwory (bez gniazd płatwi): [[s0, s1, z0, z1, nazwa]]. |
| 104 | `linia_dachu(w, p)` | Linia dachu nad ścianą (szczyt – wierzch bali szczytu, ściana pod połacią – spód krokwi): [[s, z]]; [] – brak. |
| 121 | `r(v)` | Zaokrąglenie do 0,1 mm. |

### rdzen/wience.rb (107 wierszy)

poziomy wieńców każdej ściany – półbal na dole ścian wzdłuż kalenicy, liczba wieńców, wysokości ścian.

Zależy od: rdzen/parametry.rb (kolumny dopełnienia w[:dopelnienie] liczy rdzen/dopelnienie.rb)
Używają: rdzen/bale.rb, rdzen/projekt.rb (wysokości do okna), rdzen/dopelnienie.rb, rdzen/szczyty.rb (gniazda)

| Wiersz | Element | Opis |
|---:|---|---|
| 20 | `module Wience` |  |
| 25 | `dla_sciany(w, p)` | Wieńce ściany od dołu: [{ nr:, z0:, h:, lvl:, polbal: }]; kontrfor dopasowany do wysokości gospodarza (przy szczycie – także w szczyt, dalej ogranicza go linia dachu w rdzen/bale.rb). |
| 40 | `pelna_lista(kierunek, zewnetrzna, p, z_szczytu = nil)` | Wieńce według kierunku: A – półbal + n pełnych; B zewnętrzna – n + 1 (początek szczytu); B działowa i kontrfor – n; ściana ze szczytem – wieńce aż do wierzchu szczytu z_szczytu. |
| 58 | `nizsza_lista(w, pelna, p)` | Wieńce niższej działowej: własne (góra pełnego wieńca ≤ w[:nizsza][:z], nie wyżej niż pełna wysokość), potem nadstawka – tyle wieńców, ile sięgają kolumny dopełnienia (bez kolumn – sama działowa). |
| 77 | `wlasne(w, p)` | Wieńce własne ściany (bez nadstawki niższej działowej). |
| 82 | `wysokosc(w, p)` | Wysokość ściany = góra najwyższego wieńca własnego [mm] (niższa działowa – bez nadstawki). |
| 88 | `wysokosc_calkowita(w, p)` | Wysokość ściany z nadstawką niższej działowej [mm] (np. do gniazd płatwi). |
| 94 | `wysokosc_pelna(w, p)` | Pełna wysokość ściany (jakby nie była niższą działową) [mm]. |
| 100 | `wysokosci(p)` | Wysokości do okna: { okapowa:, szczytowa:, dzialowa_okapowa:, dzialowa_szczytowa: } [mm]. |

### rdzen/zamek.rb (115 wierszy)

obróbki zamka na każdym skrzyżowaniu – gniazda górne/dolne i podcięcia boczne bali (zamek 44 × 146 z rysunku IMG-20250930-WA0005).

Zależy od: rdzen/parametry.rb
Używają: rdzen/projekt.rb, testy/t_zamek.rb (sprawdzenie kolizji)

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `module Zamek` |  |
| 24 | `ORIENTACJA` | Kierunek (w układzie lokalnym domu), w którym podcięcie lica o mniejszej współrzędnej wychodzi za lico ściany poprzecznej: ściany wzdłuż X – lico południowe (min y), ściany wzdłuż Y – lico zachodnie (min x). |
| 26 | `ORIENTACJA_LUSTRO` | Odbicie lustrzane labiryntu (parametr zamek_odbicie = 'lustro'). |
| 32 | `nanies(sciany, p, orientacja = nil)` | Obróbki zamków dla wszystkich skrzyżowań (dopisuje cechy do bali); zwraca liczbę par bali w zamkach. Orientacja – z parametru zamek_odbicie, gdy nie podano. |
| 62 | `bale_w_zamku(w, c, t)` | Bale ściany, które zachodzą na słup zamka [c − t/2, c + t/2]. |
| 67 | `gniazdo(b, c, typ, z)` | Gniazdo (górne lub dolne) w osi c – raz na skrzyżowanie, przycięte do długości bala. |
| 74 | `podciecia(b, c, z, orientacja)` | Podcięcia boczne obu lic bala przy skrzyżowaniu w osi c (strona 0 – lico prawe y = 0, strona 1 – lico lewe y = t). |
| 86 | `kierunek_lica_prawego(w, orientacja)` | Kierunek (−1 / +1 wzdłuż s ściany), w którym podcięcie lica prawego wychodzi za lico ściany poprzecznej. |
| 100 | `dodaj_ceche(b, cecha)` | Dopisanie cechy przyciętej do bala (pomija powtórkę tej samej obróbki w tej samej osi). |
| 110 | `odl2(a, b)` | Odległość punktów 2D (pomocnicza, bez zależności od geometria.rb). |

### rdzen/zestawienie.rb (74 wierszy)

zestawienie bali i belek do pliku CSV (Excel) – pozycje z długością, ilością i objętością, sumy grup i całości.

Zależy od: rdzen/parametry.rb, rdzen/projekt.rb (podsumowanie)
Używają: sketchup/eksport.rb (zapis pliku)

| Wiersz | Element | Opis |
|---:|---|---|
| 18 | `module Zestawienie` |  |
| 20 | `GRUPY` | Nazwy grup w zestawieniu (prefiks => nazwa). |
| 24 | `NAGLOWEK` |  |
| 29 | `csv(plan)` | Tekst CSV zestawienia z planu (pusty, gdy plan bez podsumowania). |
| 43 | `rodzaj(l)` | Rodzaj elementu w zestawieniu (bale – nazwa grupy, belki – ich rodzaj). |
| 49 | `sumy(lista)` | Wiersze sum: każda grupa (sztuki, objętość) i razem. |
| 63 | `liczba(v, n)` | Liczba z przecinkiem dziesiętnym (n miejsc). |
| 68 | `pole(v)` | Pole CSV: w cudzysłowie, gdy zawiera średnik, cudzysłów albo nową linię. |

### sketchup/atrybuty.rb (114 wierszy)

atrybuty w modelu – zgodność z Dokumentacją 2D (słownik ArteMadera) i zapis wejścia generatora do przebudowy.

Zależy od: log.rb
Używają: sketchup/budowa.rb, sketchup/wejscie.rb, sketchup/sterowanie.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `module Atrybuty` |  |
| 24 | `DICT_AM` |  |
| 25 | `DICT_GW` |  |
| 30 | `dom?(ent)` | Czy encja to grupa domu z generatora. |
| 35 | `zapisz_dom(grupa, wejscie, dom_id, kompilacja)` | Zapis wejścia (segmenty, parametry, otwory, z0) i identyfikatora domu na grupie. |
| 43 | `czytaj_wejscie(grupa)` | Wejście zapisane na grupie domu (Hash) albo nil. |
| 53 | `dom_id(grupa)` | Identyfikator domu (wiąże grupę z jej definicjami bali). |
| 58 | `oznacz_definicje(defn, poz, dom_id, przekroj)` | Oznaczenie definicji bala dla Dokumentacji 2D i generatora. |
| 70 | `oznacz_instancje(inst, b)` | Oznaczenie instancji bala (ściana, wieniec, pozycja). |
| 78 | `oznacz_element(inst, e)` | Oznaczenie instancji belki podłogi lub dachu (rodzaj, pozycja). |
| 85 | `podpis(grupa)` | Podpis zawartości domu: definicje i położenia instancji (zmiana = ręczna poprawka po generowaniu). |
| 103 | `zapisz_podpis(grupa)` | Zapis podpisu po budowie. |
| 108 | `zmieniony_recznie?(grupa)` | Czy dom zmieniono ręcznie od ostatniego generowania. |

### sketchup/budowa.rb (195 wierszy)

budowa domu w modelu – grupa domu > grupy ścian W-n > instancje komponentów bali, tagi, usuwanie poprzedniej wersji.

Zależy od: rdzen/projekt.rb (siatka pozycji), rdzen/siatka.rb, rdzen/obrys.rb (kąt układu), sketchup/konwersja.rb, sketchup/atrybuty.rb, log.rb
Używają: sketchup/sterowanie.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `module Budowa` |  |
| 21 | `TAGI` | Tagi (dawniej warstwy) według rodzaju ściany. |
| 30 | `GRUPY_BELEK` | Grupy belek w domu: tag => nazwa grupy. |
| 36 | `zbuduj(model, plan, wejscie, istniejaca = nil)` | Budowa domu z planu w jednej operacji (jedno „Cofnij”); istniejąca – grupa poprzedniej wersji do zastąpienia. Zwraca { grupa:, definicje:, bledne_sciany:, defs: }. |
| 51 | `zbuduj_w_operacji(model, plan, wejscie, istniejaca = nil)` | Budowa domu bez własnej operacji (wołający otwiera i zamyka operację – np. test działania, który ją cofa). |
| 86 | `polozenie_domu(plan, wejscie, istniejaca)` | Położenie grupy domu: z linii (obrót układu lokalnego, poziom z0); przy przebudowie – z przesunięciem i obrotem, które użytkownik nadał poprzedniej wersji (przesunięcie = położenie poprzedniej grupy × odwrotność położenia z jej linii). |
| 100 | `dodaj_belki(grupa, plan, defs, tagi)` | Grupy „Podłoga” i „Dach” z instancjami belek (pozycje elementów). |
| 116 | `nazwa_definicji(poz)` | Nazwa komponentu pozycji: rodzaj i nazwa pozycji. |
| 122 | `definicja(model, poz, p, dom_id)` | Definicja komponentu pozycji z siatki bryły; zwraca [definicja, liczba ścian, których nie udało się narysować]. |
| 137 | `rysuj_sciane(ents, s)` | Ściana bryły: pętla zewnętrzna, otwory (dorysowane i usunięte), zwrot zgodny z normalną siatki; false – ściany albo otworu w niej nie udało się narysować. |
| 160 | `na_scianie?(f, pt)` | Czy punkt leży na ścianie SketchUpa (w środku, na krawędzi albo w wierzchołku – nie obok i nie poza płaszczyzną). |
| 166 | `rownolegla?(f, n)` | Czy ściana SketchUpa leży równolegle do normalnej siatki (po podziale ściany przy otworze). |
| 172 | `przygotuj_tagi(model)` | Tagi według rodzaju ściany (zakładane, gdy ich nie ma). |
| 181 | `usun_dom(model, grupa)` | Usunięcie poprzedniej wersji domu i jej nieużywanych definicji bali. |

### sketchup/eksport.rb (60 wierszy)

zapis plików z wtyczki – wybór miejsca (okno zapisu SketchUpa), zestawienie CSV z ostatniego podglądu, plik tekstowy UTF-8.

Zależy od: rdzen/zestawienie.rb, log.rb
Używają: sketchup/okno.rb (przycisk „Zapisz zestawienie”), sketchup/raport.rb (zapis raportu)

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `module Eksport` |  |
| 16 | `BOM` | Znacznik UTF-8 na początku pliku CSV – Excel rozpozna polskie znaki. |
| 21 | `zapisz_liste(plan)` | Zapis zestawienia CSV ostatniego planu; zwraca [komunikat, rodzaj 'ok' \| 'blad']. |
| 34 | `wybierz_plik(tytul, nazwa, rozszerzenie)` | Okno zapisu SketchUpa w katalogu Dokumenty; ścieżka z rozszerzeniem albo nil (anulowano). |
| 44 | `zapisz(sciezka, tekst, bom = false)` | Zapis tekstu UTF-8 (z BOM dla Excela, gdy bom = true). |
| 53 | `katalog_startowy` | Katalog startowy okna zapisu: Dokumenty użytkownika (gdy jest), inaczej katalog domowy. |

### sketchup/konwersja.rb (71 wierszy)

przeliczenia między rdzeniem (mm, tablice) a SketchUpem (cale, Geom::Point3d, Geom::Transformation).

Zależy od: rdzen/bale.rb (polozenie), rdzen/elementy.rb (polozenie_instancji), rdzen/parametry.rb
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
| 48 | `transformacja_elementu(e)` | Transformacja instancji belki (podłoga, dach) z położenia elementu (osie dowolne, także ukośne). |
| 55 | `transformacja_bala(b, p)` | Transformacja instancji bala w grupie domu; bal obrócony – początek na drugim końcu, osie x i y odwrócone. |

### sketchup/menu.rb (42 wierszy)

menu Rozszerzenia → ArteMadera Generator Wieńcowy (generuj / edytuj, kontrola, test działania, o wtyczce).

Zależy od: sketchup/sterowanie.rb, sketchup/raport.rb, log.rb
Używają: main.rb (ładowanie)

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `module Menu` |  |
| 18 | `dodaj` | Dodanie menu (raz na sesję SketchUpa). |
| 32 | `o_wtyczce` | Okno z wersją i numerem kompilacji. |

### sketchup/okno.rb (215 wierszy)

okno parametrów (UI::HtmlDialog) – dane startowe dla okna, wywołania z JavaScriptu, wyniki do okna.

Zależy od: rdzen/parametry_lista.rb, sketchup/ustawienia.rb, sketchup/sterowanie.rb, sketchup/eksport.rb, log.rb
Używają: sketchup/sterowanie.rb (pokaz)

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `module Okno` |  |
| 22 | `SZEROKOSC` |  |
| 23 | `WYSOKOSC` |  |
| 31 | `pokaz(dane)` | Otwarcie okna z danymi startowymi (tryb: 'nowy' \| 'edycja'). |
| 48 | `dane_startowe` | Dane startowe okna: sekcje i pola formularza, wartości, presety, szablony, informacja o liniach / domu. |
| 59 | `opisy_pol` | Opisy pól z ParametryLista::LISTA w postaci dla JavaScriptu (sekcja, wybory, podpowiedź). |
| 68 | `wyslij_parametry(parametry, komunikat)` | Szablon do okna (wczytanie albo domyślne): AMGW.ustaw. |
| 76 | `wyslij_szablony(komunikat)` | Lista szablonów do okna po zapisie / usunięciu: AMGW.szablony. |
| 84 | `wyslij_komunikat(tekst, rodzaj)` | Komunikat w oknie (ok / blad): AMGW.komunikat. |
| 92 | `wyslij_widok(dane)` | Widok ściany do okna: AMGW.widok. |
| 100 | `wyslij_wynik(dane)` | Wynik obliczeń lub budowy do okna. |
| 110 | `podlacz(dlg)` | Wywołania z JavaScriptu. |
| 171 | `podlacz_szablony(dlg)` | Wywołania szablonów: wczytaj (nazwa), zapisz ({ nazwa, parametry }), usuń (nazwa), domyślne. |
| 207 | `zamknij_stare` | Zamknięcie poprzedniego okna generatora. |

### sketchup/raport.rb (187 wierszy)

test działania w prawdziwym SketchUpie i raport do wysłania – przykładowe domy budowane w operacji cofanej na końcu (model bez zmian), bryły zamknięte i objętości, zaznaczony dom, środowisko, dziennik.

Zależy od: rdzen/przyklady.rb, rdzen/projekt.rb, rdzen/kontrola.rb, rdzen/bryla.rb, sketchup/budowa.rb, sketchup/atrybuty.rb, sketchup/eksport.rb, sketchup/ustawienia.rb, log.rb
Używają: sketchup/menu.rb („Test działania i raport…”)

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `module Raport` |  |
| 21 | `CAL3` | Cale³ → mm³. |
| 23 | `TOL_OBJ` | Dopuszczalna różnica objętości bryły w SketchUpie i z profilu (część objętości). |
| 28 | `uruchom` | Menu: test działania, zapis raportu (okno zapisu) i podsumowanie w okienku. |
| 44 | `zbierz(model)` | Cały raport: środowisko, zaznaczony dom, przykładowe domy, dziennik. |
| 54 | `srodowisko(model)` | Wersje i ustawienia: SketchUp, Ruby, wtyczka, jednostki modelu, plik ustawień. |
| 68 | `przyklady(model)` | Przykładowe domy zbudowane w jednej operacji, cofniętej na końcu (model zostaje bez zmian). |
| 87 | `test_domu(model, nazwa, wejscie)` | Jeden dom: obliczenia, budowa w modelu, bryły i liczby elementów w modelu, kontrola, czasy. |
| 107 | `liczby_planu(plan)` | Liczby z planu: bale, pozycje, belki według prefiksu. |
| 117 | `liczby_modelu(grupa)` | Liczby z modelu (grupa domu): instancje według prefiksu definicji, grupy ścian. |
| 132 | `bryly(plan, defs)` | Bryły definicji: zamknięte (manifold) i z objętością jak z profilu; listy nazw z problemami. |
| 151 | `zgodny?(w)` | Czy dom w modelu zgadza się z planem: tyle instancji, co bali i belek, wszystkie bryły zamknięte, objętości zgodne. |
| 157 | `sprawdz_dom(dom)` | Zaznaczony dom: parametry, kompilacja, ręczne zmiany, liczby z planu i z modelu. |
| 168 | `podsumowanie(r)` | Tekst okienka po teście. |

### sketchup/sterowanie.rb (155 wierszy)

przebieg pracy z menu – start (linie albo dom do edycji), podgląd, generowanie, kontrola; dane wyniku dla okna.

Zależy od: rdzen/projekt.rb, rdzen/kontrola.rb, rdzen/widok.rb, sketchup/wejscie.rb, sketchup/budowa.rb, sketchup/atrybuty.rb, sketchup/okno.rb, sketchup/ustawienia.rb, log.rb
Używają: sketchup/menu.rb, sketchup/okno.rb (wywołania z okna)

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `module Sterowanie` |  |
| 20 | `start` | Menu „Generuj / edytuj”: zaznaczone linie → nowy dom, zaznaczony dom → edycja parametrów. |
| 50 | `podglad(dane)` | Podgląd z okna: obliczenia bez zmian w modelu; parametry zapamiętane na komputerze. |
| 58 | `widok(id)` | Widok ściany z ostatniego planu (podgląd lub generowanie) dla okna; { 'blad' => tekst }, gdy nie ma ściany. |
| 64 | `generuj(dane)` | Generowanie z okna: obliczenia i budowa (zastępuje edytowany dom); parametry zapamiętane na komputerze. |
| 89 | `kontrola` | Menu „Kontrola”: kolizje w zamkach, mijanka, długości dla zaznaczonego domu. |
| 111 | `scal(dane)` | Wejście domu: zapamiętane linie i poziom + parametry, otwory i ustawienia ścian (widok ściany) z okna. |
| 119 | `dla_okna(plan)` | Wynik dla okna (tylko typy JSON): błędy, ostrzeżenia, podpowiedzi, ściany, lista bali i belek, rzut. |
| 137 | `rzut(plan)` | Rzut do okna: obrys i ściany (bale od końca do końca) w mm układu lokalnego. |
| 147 | `klucze_tekstowe(h)` | Hash z kluczami symbolami → kluczami tekstowymi (do JSON). |

### sketchup/ustawienia.rb (128 wierszy)

zapamiętane ustawienia na komputerze – ostatnio użyte parametry (te same po ponownym uruchomieniu SketchUpa) i szablony.

Zależy od: rdzen/parametry_lista.rb (szablony wbudowane), log.rb
Używają: sketchup/sterowanie.rb (start, podgląd, generowanie), sketchup/okno.rb (szablony w oknie)

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `module Ustawienia` |  |
| 22 | `PLIK` |  |
| 23 | `WERSJA` |  |
| 28 | `katalog` | Katalog ustawień na tym komputerze. |
| 40 | `sciezka` | Pełna ścieżka pliku ustawień. |
| 45 | `wczytaj` | Zawartość pliku (pusty zestaw, gdy brak pliku albo plik uszkodzony – wtedy ostrzeżenie w Log). |
| 59 | `zapisz(dane)` | Zapis całego pliku (najpierw plik tymczasowy, potem zamiana); true gdy się udało. |
| 71 | `ostatnie` | Ostatnio użyte parametry (do nowego domu). |
| 76 | `zapamietaj(parametry)` | Zapamiętanie parametrów jako ostatnio użytych. |
| 84 | `tryb_pol` | Tryb pól okna: 'podstawowe' (domyślnie) albo 'wszystkie'. |
| 89 | `zapamietaj_tryb_pol(tryb)` | Zapamiętanie trybu pól okna. |
| 96 | `nazwy_szablonow` | Nazwy szablonów: wbudowane (z dopiskiem) i własne, alfabetycznie. |
| 101 | `szablon(nazwa)` | Parametry szablonu (wbudowany – wartości szablonu na tle domyślnych); nil gdy brak. |
| 108 | `zapisz_szablon(nazwa, parametry)` | Zapis własnego szablonu; zwraca tekst błędu albo nil. |
| 119 | `usun_szablon(nazwa)` | Usunięcie własnego szablonu; zwraca tekst błędu albo nil. |

### sketchup/wejscie.rb (65 wierszy)

odczyt zaznaczenia – narysowane linie (obrys, osie działowych, kontrfory) albo istniejący dom z generatora.

Zależy od: sketchup/konwersja.rb, sketchup/atrybuty.rb, log.rb
Używają: sketchup/sterowanie.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `module Wejscie` |  |
| 18 | `TOL_Z` | Linie różniące się wysokością o więcej niż tyle [mm] nie leżą w jednej płaszczyźnie. |
| 23 | `z_zaznaczenia(model)` | Wynik: { dom: grupa } \| { segmenty: [...], z0: mm } \| { blad: tekst }. |
| 49 | `zbierz(lista, tr, wynik, glebokosc)` | Krawędzie z zaznaczenia (także krawędzie zaznaczonej ściany – prostokąt kliknięty raz – i wnętrza grup i komponentów, z ich przekształceniem). |

### html/edycja.js (168 wierszy)

ustawienia pojedynczej ściany pod jej widokiem – ostatek na każdym końcu, węgły dodawane i usuwane kliknięciem w widok, co jest nad działową (strop, antresola, półka) i jej góra.

Zależy od: html/wspolne.js (AMGW_DOM), dane widoku z Ruby (rdzen/widok.rb: ustawienia, domyslne, skrzyzowania)
Używają: html/okno.js (init, panel po widoku, klik z html/sciana.js, dane do podglądu)

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `AMGW_EDYCJA` |  |
| 21 | `NAD` |  |
| 24 | `BLISKO` | Odległość kliknięcia od węgła, przy której klik usuwa węgieł [mm]. |
| 27 | `init(ustawienia, naZmiane)` | Start: ustawienia ścian zapisane w domu i funkcja wołana po każdej zmianie (podgląd). |
| 33 | `dane()` | Ustawienia ścian do wysłania (bez pustych wpisów). |
| 43 | `ust(id)` | Ustawienia ściany id (tworzone przy pierwszej zmianie). |
| 49 | `ustaw(id, klucz, wartosc, domyslna)` | Zmiana ustawienia: wartość pusta albo równa domyślnej – usunięta z ustawień; potem podgląd. |
| 60 | `weglyWidoku(d)` | Osie węgłów na ścianie z danych widoku (skrzyżowania z węgłami). |
| 71 | `klik(d, s, sWegla)` | Klik w widoku ściany: przy węgle (sWegla) – usunięcie, w innym miejscu – nowy węgieł (oś zaokrąglona do 10 mm). Pierwsza zmiana przepisuje węgły ściany na listę ręczną (automat tej ściany wyłączony). |
| 85 | `wegielPrzy(d, s, zasieg)` | Najbliższy węgieł do miejsca s w zasięgu BLISKO (albo zasieg [mm]); null – brak. |
| 98 | `poleLiczby(box, id, etykieta, wartosc, naZmiane)` | Pole liczby w panelu (etykieta, wartość, po zmianie – funkcja z nową wartością). |
| 111 | `panel(box, d)` | Panel ustawień ściany pod widokiem (d – dane widoku z Ruby; brak – panel pusty). |
| 146 | `panelDzialowej(pola, d, u, s, dom)` | Pola działowej: co jest nad nią (strop, antresola, półka – tylko wtedy niższa) i góra działowej. |

### html/okno.css (142 wierszy)

wygląd okna parametrów.

Zależy od: –
Używają: html/okno.html

### html/okno.html (126 wierszy)

okno parametrów generatora – układ okna (sekcje formularza budowane przez okno.js z listy parametrów z Ruby).

Zależy od: html/okno.css, html/wspolne.js, html/rzut.js, html/sciana.js, html/zmiany.js, html/tryb.js, html/edycja.js, html/wyniki.js, html/okno.js
Używają: sketchup/okno.rb

### html/okno.js (323 wierszy)

logika okna parametrów – sekcje i pola z listy parametrów, podpowiedzi, szablony, wywołania Ruby.

Zależy od: html/okno.html, html/okno.css, html/wspolne.js (AMGW_DOM), html/wyniki.js (AMGW_WYNIKI.pokaz), html/sciana.js (AMGW_SCIANA), html/zmiany.js (AMGW_ZMIANY), html/tryb.js (AMGW_TRYB), html/edycja.js (AMGW_EDYCJA), html/otwory.js (AMGW_OTWORY – tabela okien i drzwi)
Używają: sketchup/okno.rb (AMGW.init, AMGW.wynik, AMGW.ustaw, AMGW.szablony, AMGW.widok, AMGW.komunikat)

| Wiersz | Element | Opis |
|---:|---|---|
| 12 | `AMGW` |  |
| 23 | `wywolaj(nazwa, dane)` | Wywołanie Ruby (window.sketchup.nazwa) – poza SketchUpem nic nie robi. |
| 32 | `zbudujSekcje()` | Sekcje formularza (rozwijane) z listy sekcji; zachowuje rozwinięcie przy przebudowie. |
| 51 | `zbudujFormularz(parametry)` | Formularz: sekcje, pole na każdy parametr (z podpowiedzią) i wymiary zamka. |
| 63 | `dodajPole(opis, parametry)` | Jedno pole parametru w swojej sekcji (lista wyboru, liczba, przekrój albo tekst) i podpowiedź pod nim. |
| 106 | `wartoscPola(klucz, domyslna)` | Wartość pola parametru z formularza (gdy brak pola – domyślna). |
| 114 | `wypelnijSzablony(lista)` | Lista szablonów w polu wyboru. |
| 122 | `komunikatSzablonu(tekst)` | Komunikat przy szablonach. |
| 125 | `zbudujZamek(parametry)` | Pola wymiarów zamka: wartości własne albo z presetu. |
| 144 | `zbierzParametry()` | Parametry z formularza (z wymiarami zamka) do wysłania do Ruby. |
| 159 | `pokazKomunikat(tekst, rodzaj)` | Komunikat nad formularzem (ok / blad). |
| 166 | `ukryjKomunikat()` | Ukrycie komunikatu. |
| 169 | `pokazWynik(d)` | Wyniki do okna (html/wyniki.js), lista ścian dla tabeli otworów (html/otwory.js) i odświeżenie widoku ściany. |
| 186 | `wybierzSciane(id)` | Wybór ściany do widoku (lista albo kliknięcie na rzucie). |
| 201 | `widok(d)` | Widok ściany z Ruby (AMGW.widok) – rysunek, gdy to nadal wybrana ściana; kliknięcie w rysunek dodaje albo usuwa węgieł; pod rysunkiem panel ustawień ściany. |
| 212 | `dane()` | Dane formularza jako JSON (parametry, otwory i ustawienia ścian z widoku). |
| 215 | `zaplanujPodglad()` | Podgląd po zmianie pola (z opóźnieniem 350 ms – kilka zmian = jedno wywołanie); przeliczenie otworów w tabeli. |
| 222 | `init(d)` | Start okna danymi z Ruby (AMGW.init). |
| 241 | `ustaw(d)` | Parametry z szablonu albo fabryczne (AMGW.ustaw): nowy formularz i podgląd. |
| 248 | `szablony(d)` | Lista szablonów po zapisie / usunięciu (AMGW.szablony). |
| 254 | `wynik(d)` | Wynik z Ruby (AMGW.wynik) – po podglądzie albo generowaniu. |
| 271 | `start()` | Podpięcie przycisków i zgłoszenie gotowości okna do Ruby. |
| 320 | `komunikat(d)` | Komunikat z Ruby (AMGW.komunikat) – np. po zapisie zestawienia. |

### html/otwory.js (154 wierszy)

tabela okien i drzwi w oknie – stolarka (ściana, od, szerokość i wysokość stolarki, parapet, luz górny, nazwa), otwór w balach i podpowiedź luzu górnego.

Zależy od: html/wspolne.js (AMGW_DOM), html/okno.html (tabela #tab-otwory)
Używają: html/okno.js (init, dodaj, zbierz, sciany, pierwszaSciana, przelicz)

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `AMGW_OTWORY` |  |
| 19 | `KLUCZE` |  |
| 23 | `init(parametr, zmiana)` | Start: odczyt parametru z formularza (klucz, wartość domyślna) i reakcja na zmianę wiersza (podgląd). |
| 29 | `liczba(t)` | Liczba z pola tekstowego (przecinek albo kropka, spacje pomijane) albo null. |
| 37 | `podpowiedz(h)` | Podpowiedź luzu górnego dla wysokości stolarki h [mm] (jak Stolarka.luz_podpowiedz w Ruby). |
| 45 | `przeliczWiersz(tr)` | Wiersz: podpowiedź luzu w pustym polu i wymiary otworu w balach (szer. × wys.). |
| 66 | `przelicz()` | Przeliczenie wszystkich wierszy (po zmianie luzu bocznego albo osiadania w parametrach). |
| 73 | `wypelnijSciany(sel, wybrana)` | Lista ścian dla otworu (bez kontrforów); brakująca ściana zostaje z dopiskiem. |
| 92 | `dodaj(o)` | Nowy wiersz tabeli z danymi otworu o (klucze jak w Ruby: sciana, od, szerokosc, wysokosc, parapet, luz_gorny, nazwa). |
| 121 | `zbierz()` | Otwory z tabeli do wysłania do Ruby. |
| 136 | `sciany(lista)` | Nowa lista ścian (po podglądzie) – odświeżenie list w wierszach. |
| 144 | `pierwszaSciana()` | Pierwsza ściana (nie kontrfor) – domyślna dla nowego otworu. |

### html/rzut.js (134 wierszy)

rzut domu w oknie (SVG) – obrys, ściany i węgły, otwory, punkty odniesienia otworów, opisy W-n.

Zależy od: html/wspolne.js (AMGW_DOM)
Używają: html/wyniki.js (AMGW_RZUT.rysuj)

| Wiersz | Element | Opis |
|---:|---|---|
| 11 | `AMGW_RZUT` |  |
| 18 | `rysuj(box, rzut, naKlik)` | Rzut SVG: obrys, ściany, kontrfory, otwory, punkty odniesienia i opisy W-n; naKlik(id) – kliknięcie ściany. |
| 94 | `polePrzycisku(ns, s, sx, sy, gr, naKlik)` | Szeroka, niewidoczna linia nad ścianą – łatwiej ją kliknąć (wybór ściany do widoku). |
| 108 | `miejsceOpisu(s, kf, srodek, gr)` | Miejsce opisu na rzucie: [x, y, wyrównanie]; ściana – obok środka po stronie od środka obrysu, kontrfor – za końcem bliższym środka obrysu (w środku domu – opis nie wchodzi na opis ściany zewnętrznej). |

### html/sciana.js (217 wierszy)

widok ściany w oknie (SVG) – bale z numerami pozycji, wieńce, otwory, styki, skrzyżowania z innymi ścianami i węgłami, linia dachu; wybór ściany.

Zależy od: html/wspolne.js (AMGW_DOM)
Używają: html/okno.js (AMGW.widok, lista ścian po podglądzie)

| Wiersz | Element | Opis |
|---:|---|---|
| 12 | `AMGW_SCIANA` |  |
| 18 | `NS` |  |
| 19 | `KOLORY` |  |
| 20 | `RODZAJE` |  |
| 22 | `WYS_MIN` | Wysokość rysunku w oknie [px]: najmniejsza i największa. |
| 23 | `WYS_MAX` |  |
| 25 | `SPLASZCZENIE` | Najniższy rysunek (część WYS_MIN), przy którym cała ściana mieści się jeszcze w szerokości okna. |
| 28 | `svgEl(tag, atr)` | Element SVG z atrybutami. |
| 38 | `lista(sel, widoki, wybrana)` | Lista ścian w polu wyboru (po podglądzie); zachowuje wybraną, gdy nadal istnieje. Zwraca wybraną ścianę albo ''. |
| 52 | `zakres(d)` | Zakres rysunku: [smin, smax, zmin, zmax] z bali, otworów i linii dachu. |
| 68 | `rysuj(box, d, opis, naKlik)` | Rysunek ściany w kontenerze; opis nad rysunkiem w elemencie opis (gdy podany); naKlik(s, zasieg) – kliknięcie w rysunek: miejsce s na osi ściany i zasięg trafienia w węgieł [mm] (8 px rysunku). |
| 105 | `klikanie(svg, d, z, m, k, naKlik)` | Kliknięcie w rysunek: miejsce na osi ściany (z odwróconego przekształcenia SVG) do funkcji naKlik. |
| 119 | `skrzyzowania(svg, d, z, X, Y, px)` | Skrzyżowania z innymi ścianami i węgłami: linia przerywana i opis nad ścianą (węgieł ręczny – opis pogrubiony). |
| 135 | `bale(svg, d, X, Y, px, k)` | Bale: obrys z gniazdami zamków i skosem, kolor wg grupy, numer pozycji (gdy się mieści) i opis po najechaniu. |
| 158 | `otwory(svg, d, X, Y, px)` | Otwory: prostokąt z nazwą. |
| 175 | `styki(svg, d, X, Y)` | Styki bali: czerwona kreska na końcu bala oznaczonym jako styk. |
| 190 | `dach(svg, d, X, Y)` | Linia dachu (szczyt – wierzch bali szczytu, ściana pod połacią – spód krokwi). |
| 200 | `wience(svg, d, z, m, X, Y, px, k)` | Numery wieńców z lewej (co który się mieści). |

### html/tryb.js (67 wierszy)

tryb pól okna – „Podstawowe” (tylko najczęściej zmieniane parametry i te zmienione względem fabrycznych) albo „Wszystkie”.

Zależy od: html/wspolne.js (AMGW_DOM), html/zmiany.js (klasa „zmieniony” na etykiecie)
Używają: html/okno.js (po zbudowaniu formularza, po zmianie pola, przełącznik w nagłówku formularza)

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `AMGW_TRYB` |  |
| 20 | `pokaz(e, widoczny)` | Pokazanie albo ukrycie elementu (pusty display – wartość z arkusza stylów). |
| 26 | `zastosuj(opisy)` | Widoczność pól według trybu: w trybie podstawowym pola podstawowe i zmienione, sekcje bez widocznych pól ukryte, wymiary zamka tylko w trybie „Wszystkie”. |
| 49 | `przyciski()` | Wyróżnienie przycisku bieżącego trybu. |
| 57 | `ustaw(tryb, opisy)` | Ustawienie trybu ('podstawowe' \| 'wszystkie') i odświeżenie widoczności pól. |
| 64 | `tryb()` | Bieżący tryb. |

### html/wspolne.js (48 wierszy)

wspólne funkcje okna – element po identyfikatorze, nowy element, czyszczenie, liczby do wyświetlenia.

Zależy od: html/okno.html (ładowany pierwszy)
Używają: html/okno.js, html/rzut.js, html/wyniki.js

| Wiersz | Element | Opis |
|---:|---|---|
| 11 | `AMGW_DOM` |  |
| 18 | `el(tag, atrybuty, tekst)` | Nowy element z atrybutami i tekstem. |
| 31 | `wyczysc(e)` | Usunięcie zawartości elementu. |
| 34 | `liczba(v)` | Liczba z tekstu (przecinek dziesiętny dozwolony); null, gdy to nie liczba. |
| 41 | `fmt(v)` | Liczba do wyświetlenia (bez zbędnego ,0). |

### html/wyniki.js (99 wierszy)

wyniki w oknie – liczby, wysokości, błędy, ostrzeżenia, podpowiedzi, tabela ścian ze stykami, lista bali i belek, rzut.

Zależy od: html/wspolne.js (AMGW_DOM), html/rzut.js (AMGW_RZUT)
Używają: html/okno.js (pokazWynik)

| Wiersz | Element | Opis |
|---:|---|---|
| 11 | `AMGW_WYNIKI` |  |
| 20 | `lista(idBox, pozycje, klasa)` | Lista błędów lub ostrzeżeń. |
| 31 | `wiersz(tbody, komorki, liczbowe)` | Wiersz tabeli wyników. |
| 43 | `podpowiedzi(pozycje)` | Podpowiedzi (podłoga, dobór przekrojów) z poziomem ok / uwaga / blad. |
| 56 | `pokaz(d, naKlik)` | Wyniki: liczby, wysokości, tabela ścian, lista bali, rzut, błędy, ostrzeżenia i podpowiedzi; naKlik(id) – kliknięta ściana na rzucie. |

### html/zmiany.js (60 wierszy)

pola zmienione względem ustawień fabrycznych – wyróżnienie etykiety, wartość fabryczna w dymku, liczba zmian w nagłówku sekcji.

Zależy od: html/wspolne.js (AMGW_DOM)
Używają: html/okno.js (po zbudowaniu formularza i po zmianie pola)

| Wiersz | Element | Opis |
|---:|---|---|
| 11 | `AMGW_ZMIANY` |  |
| 18 | `inneNizFabryczne(opis, wartosc)` | Czy wartość pola różni się od fabrycznej (liczby – po wartości, reszta – tekst bez spacji i wielkości liter). |
| 29 | `oznacz(opisy)` | Pola zmienione względem ustawień fabrycznych: wyróżniona etykieta (z wartością fabryczną w dymku) i liczba zmienionych pól w nagłówku sekcji. |
| 50 | `opisWyboru(opis, wartosc)` | Tekst wyboru (np. „wzdłuż dłuższego boku”) dla wartości pola wyboru. |

### testy/atrapa/extensions.rb (3 wierszy)

–


### testy/atrapa/sketchup.rb (738 wierszy)

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
| 108 | `inverse` | Odwrotność przekształcenia afinicznego (macierz 3 × 3 i przesunięcie), jak Geom::Transformation#inverse. |
| 123 | `zastosuj(p)` |  |
| 129 | `origin` |  |
| 133 | `xaxis` |  |
| 137 | `yaxis` |  |
| 141 | `zaxis` |  |
| 145 | `to_a` |  |
| 151 | `module Sketchup` |  |
| 152 | `class Atrybutowy` |  |
| 153 | `atrybuty` |  |
| 158 | `entityID` | Numer encji (jak Entity#entityID – stały dla obiektu w sesji). |
| 162 | `set_attribute(dict, key, value)` |  |
| 166 | `get_attribute(dict, key, domyslna = nil)` |  |
| 171 | `delete_attribute(dict, key = nil)` |  |
| 176 | `class Vertex` |  |
| 179 | `initialize(pt)` |  |
| 184 | `class Edge` |  |
| 188 | `initialize(a, b)` |  |
| 193 | `valid?` |  |
| 198 | `class Face` |  |
| 210 | `initialize(punkty, entities)` |  |
| 217 | `vertices` |  |
| 222 | `edges` | Krawędzie pętli zewnętrznej (jak Face#edges w SketchUpie – te same obiekty przy kolejnych wywołaniach). |
| 227 | `normal` | Normalna z punktów (metoda Newella). |
| 240 | `reverse!` |  |
| 245 | `erase!` |  |
| 250 | `valid?` |  |
| 254 | `classify_point(_pt)` |  |
| 259 | `class Entities` |  |
| 262 | `initialize(parent)` |  |
| 267 | `each(&blk)` |  |
| 271 | `to_a` |  |
| 275 | `length` |  |
| 279 | `grep(klasa)` |  |
| 283 | `add_group(*_args)` |  |
| 289 | `add_instance(defn, tr)` |  |
| 298 | `add_face(*pts)` | Ściana: jeśli w tej samej płaszczyźnie jest już ściana, która zawiera nową w całości – nowa jest „otworem”. |
| 307 | `add_line(a, b)` |  |
| 314 | `usun(e)` |  |
| 322 | `erase_entities(lista)` |  |
| 327 | `przywroc(lista)` | Atrapa: przywrócenie listy po abort_operation. |
| 332 | `class ComponentDefinition` |  |
| 336 | `initialize(name)` |  |
| 342 | `instances` |  |
| 346 | `count_instances` |  |
| 350 | `group?` |  |
| 355 | `class Group` |  |
| 359 | `initialize(rodzic)` |  |
| 368 | `parent` |  |
| 372 | `definition` |  |
| 376 | `erase!` |  |
| 382 | `valid?` |  |
| 389 | `module AtrapaBryly` | Bryła z ścian (atrapa Group/ComponentInstance#manifold? i #volume): każda krawędź pętli ścian (z otworami) użyta dokładnie dwa razy; objętość z twierdzenia o dywergencji (ściany skierowane na zewnątrz), cale³. |
| 392 | `sciany(ents)` |  |
| 396 | `klucz(p)` |  |
| 400 | `manifold?(ents)` |  |
| 410 | `wektor_pola(pts)` |  |
| 421 | `dlugosc(w)` |  |
| 425 | `volume(ents)` |  |
| 440 | `class ComponentInstance` |  |
| 444 | `manifold?` |  |
| 448 | `volume` |  |
| 452 | `initialize(defn, tr, rodzic)` |  |
| 460 | `erase!` |  |
| 465 | `valid?` |  |
| 470 | `class DefinitionList` |  |
| 471 | `initialize` |  |
| 475 | `add(name)` |  |
| 487 | `remove(d)` |  |
| 493 | `przywroc(lista)` | Atrapa: przywrócenie listy po abort_operation. |
| 501 | `to_a` |  |
| 505 | `each(&blk)` |  |
| 509 | `length` |  |
| 514 | `class Layer` |  |
| 517 | `initialize(name)` |  |
| 522 | `class Layers` |  |
| 523 | `initialize` |  |
| 527 | `add(nazwa)` |  |
| 535 | `length` |  |
| 540 | `class Selection` |  |
| 541 | `initialize` |  |
| 545 | `to_a` |  |
| 549 | `clear` |  |
| 553 | `add(*e)` |  |
| 558 | `class Model` |  |
| 561 | `initialize` |  |
| 569 | `active_entities` |  |
| 573 | `start_operation(nazwa, *_reszta)` |  |
| 579 | `commit_operation` |  |
| 586 | `abort_operation` | Jak w SketchUpie: cofnięcie wszystkiego od start_operation (encje najwyższego poziomu i definicje). |
| 596 | `options` |  |
| 606 | `active_model` |  |
| 610 | `require(sciezka)` |  |
| 614 | `register_extension(_ext, _load)` |  |
| 618 | `version` |  |
| 622 | `is_pro?` |  |
| 626 | `os_language` |  |
| 632 | `class SketchupExtension` |  |
| 635 | `initialize(nazwa, sciezka)` |  |
| 641 | `module UI` |  |
| 648 | `messagebox(tekst, _typ = nil)` |  |
| 654 | `savepanel(_tytul, _katalog = nil, _nazwa = nil)` | Okno zapisu: test ustawia UI.plik_zapisu (nil – „Anuluj”). |
| 658 | `menu(_nazwa)` |  |
| 663 | `class Menu` |  |
| 666 | `initialize` |  |
| 670 | `add_submenu(_nazwa)` |  |
| 674 | `add_item(nazwa, &blk)` |  |
| 679 | `add_separator` |  |
| 684 | `class HtmlDialog` |  |
| 685 | `STYLE_DIALOG` |  |
| 688 | `initialize(opcje = {})` |  |
| 695 | `set_file(plik)` |  |
| 699 | `add_action_callback(nazwa, &blk)` |  |
| 703 | `execute_script(js)` |  |
| 707 | `show` |  |
| 711 | `close` |  |
| 715 | `visible?` |  |
| 720 | `wywolaj(nazwa, arg = '')` | Test: wywołanie jak z JavaScriptu. |
| 726 | `MB_YESNO` |  |
| 727 | `IDYES` |  |
| 728 | `IDNO` |  |
| 732 | `file_loaded?(nazwa)` |  |
| 736 | `file_loaded(nazwa)` |  |

### testy/buduj_rbz.rb (28 wierszy)

paczka instalacyjna .rbz (zip rejestratora i folderu wtyczki) – do instalacji w Menedżerze rozszerzeń SketchUpa.

Zależy od: polecenie zip
Używają: zamknięcie rundy (docs/skille/gw-runda/SKILL.md)

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `KAT` |  |
| 17 | `PLUG` |  |

### testy/kolizje_belek.rb (69 wierszy)

wspólne sprawdzenia przestrzenne testów – kolizje belek dachu z balami (punkty próbne), bale ponad linią szczytu.

Zależy od: testy/pomoc.rb (rdzeń wtyczki)
Używają: testy/t_szczyty.rb, testy/t_losowe.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 11 | `probki(a, b, n)` | Punkty próbne (n × n × n) w części wspólnej prostopadłościanów otaczających [min, max]. |
| 21 | `otoczka(pol, dl, b, h)` | Prostopadłościan otaczający bryły o położeniu pol i wymiarach dl × b × h. |
| 28 | `lokalnie(pol, q)` | Punkt w układzie lokalnym (rzut na osie położenia). |
| 34 | `kolizje_belek(pl, prefiks, n = 7)` | Liczba punktów wspólnych belek dachu (prefiks) i bali (z marginesem 0,5 mm) – 0 = bez kolizji. |
| 59 | `nad_linia(pl, id)` | Największe wystawanie bali ściany ponad linię szczytu [mm] (≤ 0 – wszystko pod linią). |

### testy/lista_parametrow.rb (73 wierszy)

generator docs/parametry.md – wszystkie parametry okna (sekcja, etykieta, wartość domyślna, zakres, wybory, podpowiedź) i szablony wbudowane.

Zależy od: Plugins/arte_madera_generator_wiencowy/rdzen/parametry_lista.rb
Używają: testy/uruchom.sh (sprawdzenie aktualności)

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `KAT` |  |
| 17 | `WYNIK` |  |
| 20 | `fmt(v)` | Liczba bez zbędnego ,0 (przecinek dziesiętny). |
| 27 | `kom(t)` | Komórka tabeli bez znaków psujących Markdown. |
| 32 | `tresc` | Treść dokumentu. |

### testy/losowe_domy.rb (222 wierszy)

losowe domy do testów – obrys (prostokąt, L), działowe, węgły, otwory i parametry z ziarna; sprawdzenie jednego domu.

Zależy od: testy/pomoc.rb, testy/kolizje_belek.rb
Używają: testy/t_losowe.rb, ręcznie (ruby -I testy/atrapa testy/losowe_domy.rb [liczba] [ziarno])

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `module LosoweDomy` |  |
| 19 | `MIN_KRAWEDZ` | Najkrótsza dopuszczalna krawędź bryły [mm] – zapas ponad tolerancję SketchUpa (0,0254 mm). |
| 24 | `wybierz(r, lista)` | Losowy wybór z listy. |
| 29 | `dom(ziarno)` | Dom z ziarna: { ziarno:, opis:, segmenty:, parametry:, otwory: }. |
| 77 | `dodatki(r, p, dl_w1, opis)` | Dodatki rundy 4 (osobne losowanie): pełny profil, strop, ostatek 200 na końcu ściany, działowa pod antresolą, węgły ręczne na W-1; zwraca ustawienia ścian (parametry uzupełnia w p, opis w opis). |
| 106 | `parametry(r)` | Losowe parametry (wartości tekstowe jak z okna). |
| 124 | `otwory(r, dlugosci)` | Losowe otwory na ścianach W-1…W-4 (długości lica ścian w kolejności numeracji). |
| 138 | `sprawdz(dom, belki = true)` | Sprawdzenie domu: lista problemów (pusta – w porządku) i plan. |
| 182 | `siatka(poz)` | Siatka pozycji: { ok: zamknięta i z objętością profilu, min_krawedz: najkrótsza krawędź ścian [mm] }. |
| 190 | `min_krawedz(sciany)` | Najkrótsza krawędź pętli ścian siatki [mm] (SketchUp scala punkty bliższe niż 0,0254 mm). |

### testy/okno_dane.rb (36 wierszy)

dane okna z prawdziwego przebiegu (atrapa SketchUpa) – wypisuje JSON { init:, wynik:, widok:, widok_szczytu:, widok_dzialowej: } dla testu okna w przeglądarce.

Zależy od: testy/atrapa/sketchup.rb, testy/pomoc.rb
Używają: testy/t_okno.js

### testy/podglad.py (83 wierszy)

rysunek 3D domu z pliku OBJ (testy/podglad.rb) – cały dom i zbliżenie narożnika, do sprawdzenia wzrokowego.

Zależy od: testy/podglad.rb, matplotlib
Używają: ręcznie (python3 testy/podglad.py dom.obj wynik.png)

| Wiersz | Element | Opis |
|---:|---|---|
| 18 | `wczytaj(plik)` |  |
| 34 | `rysuj(ax, grupy, filtr=None)` |  |
| 44 | `main()` |  |

### testy/podglad.rb (97 wierszy)

zapis domu testowego do pliku OBJ (siatki pozycji ułożone jak w modelu) – do obejrzenia bez SketchUpa (testy/podglad.py).

Zależy od: testy/pomoc.rb, rdzen/przyklady.rb
Używają: testy/podglad.py

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `DOMY` |  |

### testy/pomoc.rb (94 wierszy)

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
| 82 | `plan(segmenty, parametry = {}, otwory = [])` | Plan samych ścian (bez szczytów i podłogi – testy ścian z kompilacji 1); parametry nadpisują. |
| 87 | `plan_pelny(segmenty, parametry = {}, otwory = [])` | Plan domu z parametrami domyślnymi (ze szczytami, dachem i podłogą). |
| 92 | `sciana(pl, id)` | Ściana planu po identyfikatorze. |

### testy/ruby27.sh (35 wierszy)

testy rdzenia i warstwy SketchUpa na Ruby 2.7.8 – tej samej linii co Ruby w SketchUpie 2023 (2.7.7); gdy brak, buduje Ruby ze źródeł z GitHuba.

Zależy od: git, gcc, make, autoconf, bison, ruby (jako baseruby przy budowie)
Używają: testy/uruchom.sh (sam wykrywa /opt/ruby27), zamknięcie rundy

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

### testy/sprawdz_zasady.rb (168 wierszy)

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

### testy/t_losowe.rb (36 wierszy)

stały zestaw losowych domów (ziarna, które kiedyś ujawniły błąd, i kilka zwykłych) – każdy bez problemów.

Zależy od: testy/losowe_domy.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `ZIARNA` | Ziarno => co ujawniło (runda 3, runda 4 – r4). |

### testy/t_okno.js (335 wierszy)

okno parametrów w Chromium (Playwright) – sekcje i pola z listy, podpowiedzi, szablony, rzut, tabela otworów, wywołania sketchup.*, wyniki.

Zależy od: testy/okno_dane.rb, Plugins/.../html/okno.html
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `KAT` |  |
| 20 | `HTML` |  |
| 23 | `sprawdz(w, opis)` |  |

### testy/t_podloga.rb (118 wierszy)

testy podłogi i statyki – wzory belki, dobór przekroju (minimalny / zalecany / ręczny), izolacja, podpory, układ podwalin i legarów.

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `el(pl, prefiks)` | Elementy planu o prefiksie. |
| 19 | `podp?(pl, poziom, tekst)` | Czy jest podpowiedź danego poziomu zawierająca tekst. |
| 23 | `P0` |  |

### testy/t_raport.rb (81 wierszy)

test działania z menu (atrapa SketchUpa) – przykładowe domy bez błędów, budowa cofnięta (model bez zmian), bryły zamknięte i objętości, zaznaczony dom, raport JSON.

Zależy od: testy/atrapa/sketchup.rb, testy/pomoc.rb, Plugins/.../sketchup/raport.rb, rdzen/przyklady.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `CAL` |  |

### testy/t_rdzen.rb (223 wierszy)

testy rdzenia – obrys, ściany, wieńce, styki z mijanką, kontrfory, otwory, pozycje, kolizje w zamkach.

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `bez_kolizji(pl, opis)` |  |

### testy/t_sciany_ust.rb (159 wierszy)

testy ustawień pojedynczych ścian z widoku ściany – ostatek na końcu, węgły ręczne, niższa działowa pod stropem / antresolą / półką z dopełnieniem zamka.

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `plan_s(segmenty, parametry, sciany, otwory = [], pelny = false)` | Plan z ustawieniami ścian (bez szczytów i podłogi, gdy pelny = false). |
| 21 | `wegly_sciany(pl, id)` | Węgły ściany: [[s, źródło]] (s zaokrąglone). |
| 26 | `czysto(pl, opis)` | Kontrola bez kolizji, mijanki i za długich bali. |
| 33 | `nadstawka(pl, id)` | Bale nadstawki (wieńce ponad własną wysokością ściany). |
| 38 | `nad_dachem(pl, id)` | Największe wystawanie bali ściany pod połacią ponad linię dachu [mm] (≤ 0 – wszystko pod połacią). |

### testy/t_siatka.rb (110 wierszy)

siatka brył wszystkich pozycji z kilku domów – zamknięta (każda krawędź raz w każdą stronę), objętość równa profilowi.

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `sprawdz_pozycje(pl, opis)` |  |

### testy/t_sketchup.rb (305 wierszy)

warstwa SketchUpa na atrapie API – ładowanie wtyczki, okno, generowanie, atrybuty, położenie bali, przebudowa, ręczne zmiany.

Zależy od: testy/atrapa/sketchup.rb, testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `CAL` |  |
| 25 | `model_z_liniami(odcinki, z0 = 0.0)` |  |
| 35 | `ostatni_wynik(dlg)` |  |
| 40 | `instancje(grupa)` |  |
| 45 | `ostatni_skrypt(dlg, poczatek)` | Ostatni skrypt okna o danym początku jako Hash (np. 'AMGW.ustaw('). |

### testy/t_szczyty.rb (135 wierszy)

testy szczytów i dachu – wieńce do kalenicy, skos bali pod linią dachu, gniazda płatwi, krokwie przy szczycie, belki dachu bez kolizji.

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `czysto(pl, opis)` |  |

### testy/t_wegly.rb (140 wierszy)

testy węgłów usztywniających i łączenia na przemian – limity światła, rozmieszczenie, ściany wysokie, otwory.

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `wegly(pl, id, zrodlo)` | Węgły ściany według źródła: osie s (zaokrąglone) węgłów danego źródła na ścianie id. |
| 19 | `czysto(pl, opis)` | Kontrola bez kolizji, bez naruszeń mijanki i bez za długich bali. |
| 25 | `max_swiatlo(pl, id)` | Największe światło ściany (między licami podparć) [mm]. |

### testy/t_widok.rb (71 wierszy)

widok ściany do okna – obrysy bali zgodne z profilem, gniazda zamków na skrzyżowaniach, styki, linia dachu, lista ścian.

Zależy od: testy/pomoc.rb, Plugins/.../rdzen/widok.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `pole(pts)` | Pole wielokąta [[s, z]] (wzór Gaussa). |
| 22 | `pole_profilu(b, t)` | Pole boku bala z profilu (rzut na płaszczyznę ściany). |

### testy/t_zamek.rb (95 wierszy)

zamek 44 × 146 zgodny z rysunkiem IMG-20250930-WA0005 – wymiary obróbek, luzy, labirynt (tylko poprawne ułożenie bez kolizji).

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

### testy/t_zestawienie.rb (51 wierszy)

zestawienie CSV (rdzeń) i zapis pliku z okna (atrapa SketchUpa) – kolumny, przecinek dziesiętny, sumy, BOM, anulowanie.

Zależy od: testy/pomoc.rb, testy/atrapa/sketchup.rb, Plugins/.../rdzen/zestawienie.rb, sketchup/eksport.rb
Używają: testy/uruchom.sh

### testy/uruchom.sh (63 wierszy)

wszystkie testy i kontrole jednym poleceniem – ostatnia linia „WSZYSTKIE ZESTAWY: FAILURES n”.

Zależy od: ruby, node (+ playwright i Chromium dla okna – bez nich test okna jest pomijany z ostrzeżeniem)
Używają: start i zamknięcie rundy

### testy/zrzut_dok2d.rb (130 wierszy)

przykładowy dom zbudowany na atrapie SketchUpa zapisany jako zrzut geometrii Dokumentacji 2D (format „ArteMadera-geometria”) – sprawdzenie, jak Dokumentacja 2D widzi bale i belki generatora.

Zależy od: testy/atrapa/sketchup.rb, sketchup/budowa.rb, rdzen/przyklady.rb
Używają: ręcznie – ruby -I testy/atrapa testy/zrzut_dok2d.rb [numer przykładu] plik.json; potem w repozytorium

| Wiersz | Element | Opis |
|---:|---|---|
| 24 | `module ZrzutDok2D` |  |
| 30 | `zrzut(model)` | Zrzut całego modelu atrapy: Hash w formacie „ArteMadera-geometria”. |
| 43 | `lista(ents)` | Lista encji: ściany, ich krawędzie (w SketchUpie powstają ze ścianą – atrapa ich nie ma) i wystąpienia. |
| 55 | `krawedzie(sciany)` | Krawędzie pętli ścian – każda raz (klucz z końców zaokrąglonych do 1e-6 cala). |
| 73 | `wystapienie(e)` | Grupa albo komponent: definicja (indeks), transformacja, nazwa, tag, atrybuty. |
| 87 | `definicja(d, grupa, ents = nil)` | Indeks definicji w zrzucie (każda definicja raz, z encjami i atrybutami); ents – encje grupy. |
| 100 | `tag(t)` | Nazwa tagu (zapamiętana do listy tagów). |
| 107 | `atrybuty(obj)` | Atrybuty jak w zrzucie: { słownik => { klucz => wartość } } albo nil. |
| 114 | `zbuduj(n)` | Przykładowy dom nr n (rdzen/przyklady.rb) zbudowany na atrapie; zwraca model. |
