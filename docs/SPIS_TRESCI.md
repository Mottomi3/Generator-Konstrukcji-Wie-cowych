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
| api aplikacji do dachów | `sketchup/dach_aplikacja.rb`, `testy/sprawdz_dach_aplikacja.rb` |
| aplikacja do dachów | `rdzen/polacie.rb` |
| aplikacja do dachów w modelu | `sketchup/dach_aplikacja.rb` |
| aplikacja do dachów w testach | `testy/t_polacie.rb` |
| aplikacja do dachów – sprawdzenie z prawdziwą wtyczką | `testy/sprawdz_dach_aplikacja.rb` |
| artemadera roof | `rdzen/polacie.rb` |
| asercje | `testy/pomoc.rb` |
| atrapa | `testy/t_sketchup.rb` |
| atrapa api | `testy/atrapa/sketchup.rb` |
| atrapa api dachów | `testy/atrapa/aplikacja_dachow.rb` |
| atrapa aplikacji do dachów | `testy/atrapa/aplikacja_dachow.rb` |
| atrybuty | `sketchup/atrybuty.rb` |
| atrybuty dokumentacji 2d | `testy/t_sketchup.rb` |
| automatyczny dobór krokwi | `rdzen/statyka_krokwi.rb` |
| automatyczny dobór płatwi | `rdzen/statyka_dachu.rb` |
| automatyczny dobór wiązara | `rdzen/statyka_wiazara.rb` |
| automatyczny dobór zadaszenia | `rdzen/statyka_zadaszenia.rb` |
| awaria obliczeń | `rdzen/awaria.rb` |
| awaria w dzienniku | `sketchup/dziennik_pracy.rb` |
| bal | `rdzen/bale.rb` |
| bal bez zamka przy narożniku | `rdzen/skos_przy_narozniku.rb` |
| bal obrócony | `sketchup/konwersja.rb`, `testy/t_sketchup.rb` |
| bal przy narożniku pod dachem | `rdzen/skos_przy_narozniku.rb` |
| bal skośny w poprzek | `rdzen/sciecie_dachu.rb` |
| bal szczytowy | `rdzen/szczyty.rb` |
| bal szczytu | `rdzen/bale.rb` |
| bal szczytu w narożniku pod skosem | `rdzen/pol_zamka.rb` |
| bal w narożniku bez zamka | `testy/losowe_domy.rb` |
| bal ściany nad węgłem pod skosem | `rdzen/pol_zamka.rb` |
| bale balustrady | `rdzen/taras_balustrada.rb` |
| bale nad linią dachu | `testy/kolizje_belek.rb` |
| bale spinające szczyt | `rdzen/taras_szczyt.rb` |
| bale w tym samym miejscu | `rdzen/kontrola_rownoleglych.rb` |
| bale w tym samym miejscu – działowe | `rdzen/dzialowe_bliskie.rb` |
| balustrada | `rdzen/taras_balustrada.rb` |
| balustrada w testach | `testy/t_taras.rb` |
| balustrada z wieńców ścian | `rdzen/taras_sciany.rb` |
| balustrada – parametry | `rdzen/parametry_taras.rb` |
| balustrada) | `sketchup/budowa.rb` |
| baza porównania | `html/typy.js` |
| baza porównania do okna | `sketchup/okno_typy.rb` |
| baza typu | `sketchup/typy_domow.rb` |
| belka | `rdzen/elementy.rb` |
| belka dolna wiązara | `rdzen/taras_wiazar.rb` |
| belka dłuższa niż w hurtowni | `rdzen/dlugosci_handlowe.rb` |
| belka dłuższa niż w hurtowni – podział | `rdzen/podzial_belek.rb` |
| belka poprzeczna zadaszenia | `rdzen/zadaszenie.rb` |
| belka poprzeczna – nośność | `rdzen/statyka_zadaszenia.rb` |
| belka wiązara na słupach – nośność | `rdzen/statyka_wiazara.rb` |
| belki w modelu | `sketchup/budowa.rb`, `testy/t_sketchup.rb` |
| bez mijanki przy działowej | `rdzen/styki_dzialowe.rb` |
| boazeria od spodu | `rdzen/podbitka.rb` |
| boczne zadaszenie | `rdzen/zadaszenie.rb` |
| boczne zadaszenie w przebiegu | `rdzen/projekt.rb` |
| boczne zadaszenie z aplikacją | `testy/sprawdz_dach_aplikacja.rb` |
| boczne zadaszenie – parametry | `rdzen/parametry_lista.rb`, `rdzen/parametry_zadaszenie.rb` |
| bom | `testy/t_zestawienie.rb` |
| bom dla excela | `sketchup/eksport.rb` |
| brak aplikacji do dachów | `sketchup/dach_aplikacja.rb`, `testy/t_dach_aplikacja.rb` |
| brak pliku modelu stolarki | `sketchup/stolarka_modele.rb` |
| bryła bala | `rdzen/bryla.rb` |
| bryła zamknięta | `rdzen/siatka.rb`, `testy/t_raport.rb`, `testy/t_siatka.rb` |
| bryła zamknięta w sketchupie | `sketchup/raport.rb` |
| bryły zamknięte | `testy/losowe_domy.rb` |
| budowa modelu | `sketchup/budowa.rb`, `testy/t_sketchup.rb` |
| budowa ruby ze źródeł | `testy/ruby27.sh` |
| błąd rysunku działowej | `rdzen/dzialowe_bliskie.rb` |
| błąd wtyczki po polsku | `rdzen/awaria.rb` |
| błędy | `log.rb`, `rdzen/projekt.rb` |
| c24 | `rdzen/statyka.rb` |
| callback | `sketchup/okno.rb` |
| cena bala | `rdzen/parametry_materialy.rb`, `rdzen/wycena.rb` |
| cena belki z magazynu | `rdzen/wycena.rb` |
| cena desek | `rdzen/wycena.rb` |
| cena drewna | `rdzen/magazyn_drewna.rb` |
| cennik materiałów | `rdzen/parametry_materialy.rb`, `rdzen/wycena.rb` |
| cienki mostek nad gniazdem | `rdzen/skos_przy_narozniku.rb` |
| cienki pasek bala przy otworze | `rdzen/otwory.rb` |
| cięcie proste przy otworze | `rdzen/otwory.rb` |
| cięcie przy otworze | `rdzen/bale.rb` |
| ciężar pokrycia | `rdzen/statyka_dachu.rb` |
| co się zmieniło | `html/przeliczenia.js` |
| cofnięcie operacji | `testy/t_raport.rb` |
| czas budowy | `sketchup/raport.rb` |
| czas budowy modelu w dzienniku | `sketchup/dziennik_pracy.rb` |
| czasy etapów | `log.rb` |
| czop węgła we wrębie płatwi | `rdzen/szczyty.rb` |
| dach | `rdzen/dach.rb` |
| dach jednospadowy | `rdzen/dach_jednospadowy.rb` |
| dach jednospadowy przy narożniku | `rdzen/skos_przy_narozniku.rb` |
| dach jednospadowy w teście | `rdzen/przyklady.rb` |
| dach jednospadowy z aplikacją | `testy/sprawdz_dach_aplikacja.rb` |
| dach jednospadowy – parametry | `rdzen/parametry_dach.rb`, `rdzen/parametry_lista.rb` |
| dach na samych płatwiach | `rdzen/krok2.rb` |
| dach z aplikacji | `rdzen/polacie.rb` |
| dach z aplikacji po budowie | `sketchup/sterowanie.rb` |
| dachowanie płatwi kalenicowej | `rdzen/pryzmat.rb` |
| dane dla okna | `sketchup/sterowanie.rb` |
| dane testowe okna | `testy/okno_dane.rb` |
| dawne listy przekrojów | `rdzen/magazyn_drewna.rb` |
| dawne pola nadbitki | `rdzen/parametry_dach.rb` |
| dawne pola nowego okna i drzwi | `rdzen/parametry_tabela.rb` |
| definicja z siatki | `sketchup/budowa.rb` |
| deska 14 × 115 | `rdzen/magazyn_drewna.rb` |
| deska podbitki | `rdzen/podbitka.rb` |
| deski na płatwiach | `rdzen/krok2.rb` |
| deski na płatwiach z aplikacji | `testy/sprawdz_dach_aplikacja.rb` |
| deski nadbitki w zestawieniu | `rdzen/materialy.rb` |
| deski przerwane na działowej | `rdzen/podbitka.rb` |
| deskowanie pełne | `rdzen/krok2.rb` |
| do poprawy | `rdzen/uwagi_pola.rb`, `html/uwagi.js` |
| dobór automatyczny albo podaję sam | `rdzen/magazyn_drewna.rb` |
| dobór przekroju | `rdzen/statyka.rb`, `testy/t_podloga.rb` |
| dobór przekroju dostępnego w całej długości | `rdzen/dlugosci_handlowe.rb` |
| dobór przekroju krokwi | `rdzen/statyka_krokwi.rb` |
| dobór przekroju krokwi – parametry | `rdzen/parametry_dach.rb` |
| dobór przekroju legara | `rdzen/podloga.rb` |
| dobór przekroju płatwi | `rdzen/statyka_dachu.rb` |
| dobór przekroju płatwi w testach | `testy/t_statyka_dachu.rb` |
| dobór przekroju płatwi – parametry | `rdzen/parametry_dach.rb` |
| dobór przekroju trójkąta nad tarasem | `rdzen/statyka_wiazara.rb` |
| dobór przekroju zadaszenia | `rdzen/statyka_zadaszenia.rb` |
| dobór przekrojów zadaszenia – parametry | `rdzen/parametry_zadaszenie.rb` |
| dobór trójkąta nad tarasem w testach | `testy/t_statyka_dachu.rb` |
| dodaj działową | `html/dzialowe.js` |
| dodaj wiersz | `html/tabela.js` |
| dodaj węgieł | `rdzen/ustawienia_scian.rb` |
| dodaj węgieł kliknięciem | `html/edycja.js` |
| dokumentacja 2d | `testy/zrzut_dok2d.rb` |
| dom 4 × 4 | `rdzen/przyklady.rb`, `testy/t_wegly.rb` |
| dom 900 | `testy/t_rdzen.rb` |
| dom jak 900 | `rdzen/przyklady.rb` |
| dom l w testach | `testy/t_skrzydla.rb` |
| dom l – ściana między skrzydłami | `rdzen/sciana_w_linii.rb` |
| dom odbity | `testy/sprawdz_dach_aplikacja.rb` |
| dom prostokątny bez rysowania | `rdzen/dom_z_wymiarow.rb` |
| dom testowy | `testy/podglad.rb` |
| dom w innym kontekście | `sketchup/dach_aplikacja.rb` |
| dom w kształcie l | `rdzen/skrzydla.rb` |
| dom z działową | `rdzen/przyklady.rb` |
| dom z wymiarów | `rdzen/dom_z_wymiarow.rb` |
| dom z zaznaczonych linii z menu kontekstowego | `sketchup/pasek.rb` |
| domy testowe | `testy/pomoc.rb` |
| domy złożone | `testy/zlozone_domy.rb` |
| dopasowanie płatwi do wieńców | `rdzen/platwie_wience.rb` |
| dopełnienie zamka | `rdzen/dopelnienie.rb`, `testy/t_sciany_ust.rb` |
| drewno konstrukcyjne c24 | `rdzen/wykaz_drewna.rb` |
| drewno w zamku przy skosie | `rdzen/skos_przy_narozniku.rb` |
| drewno widoczne nsi / duo / bsh | `rdzen/wykaz_drewna.rb` |
| drzwi | `rdzen/otwory.rb`, `rdzen/stolarka.rb` |
| drzwi kliknięciem | `html/klik_sciana.js` |
| dwa dachy z koszem | `rdzen/skrzydla.rb` |
| dwa dachy z koszem w testach | `testy/t_skrzydla.rb` |
| dwie działowe w jednym miejscu | `rdzen/dzialowe_bliskie.rb` |
| działowa do połaci przy styku ściany okapowej | `rdzen/podbitka.rb` |
| działowa na ścianie obrysu – sprawdzenie | `rdzen/kontrola_rownoleglych.rb` |
| działowa niższa | `rdzen/dopelnienie.rb`, `rdzen/ustawienia_scian.rb`, `html/edycja.js`, `testy/t_sciany_ust.rb` |
| działowa niższa – parametry | `rdzen/parametry_lista.rb` |
| działowa pod antresolą w teście | `rdzen/przyklady.rb` |
| działowa w domu z wymiarów | `rdzen/dom_z_wymiarow.rb`, `html/dzialowe.js` |
| działowa w linii uskoku w testach | `testy/zlozone_domy.rb` |
| działowa w linii uskoku – test | `testy/t_zlozone.rb` |
| działowa w linii ściany obrysu | `rdzen/sciana_w_linii.rb` |
| działowa w narożniku wklęsłym | `rdzen/sciana_w_linii.rb` |
| działowa wzdłużna pod połacią | `rdzen/sciecie_dachu.rb` |
| działowa zamiast węgła | `rdzen/styki_dzialowe.rb` |
| działowe blisko siebie | `rdzen/dzialowe_bliskie.rb` |
| działowe z tabeli okna | `rdzen/dom_z_wymiarow.rb`, `html/dzialowe.js` |
| dziennik | `log.rb` |
| dziennik pracy | `sketchup/dziennik_pracy.rb` |
| długie ściany | `testy/t_rdzen.rb` |
| długości bali | `testy/losowe_domy.rb` |
| długości handlowe | `rdzen/wykaz_drewna.rb` |
| długości handlowe z magazynu | `rdzen/magazyn_drewna.rb`, `rdzen/parametry.rb` |
| długości handlowe – sprawdzenie | `rdzen/dlugosci_handlowe.rb` |
| długość bala | `rdzen/bale.rb` |
| długość domu | `rdzen/dom_z_wymiarow.rb` |
| długość pliku | `testy/sprawdz_zasady.rb` |
| długość wypustu a maksymalny bal | `rdzen/wypusty_okapu.rb` |
| długość – sprawdzenie | `rdzen/kontrola.rb` |
| edycja w widoku ściany | `html/edycja.js` |
| edytor tabeli | `html/tabela.js` |
| edytuj dom wieńcowy z menu kontekstowego | `sketchup/pasek.rb` |
| eksport obj | `testy/podglad.rb` |
| element | `rdzen/elementy.rb` |
| elewacja ściany | `rdzen/widok.rb`, `html/sciana.js` |
| es5 | `testy/sprawdz_zasady.rb` |
| excel | `rdzen/zestawienie.rb` |
| folder modeli stolarki | `rdzen/parametry_stolarka.rb`, `rdzen/stolarka_modele.rb` |
| folder raportów | `sketchup/dziennik_pracy.rb` |
| format „45x145:4.2/5.4/6” | `rdzen/wykaz_drewna.rb` |
| formatowanie liczb | `html/wspolne.js` |
| formularz | `html/okno.css`, `testy/t_okno.js` |
| formularz parametrów | `sketchup/okno.rb`, `html/okno.js` |
| front bez bali pod wiązarem | `rdzen/taras_szczyt.rb` |
| front tarasu | `rdzen/taras.rb` |
| front tarasu bez węgłów | `rdzen/styki_tarasu.rb` |
| front tarasu na styk w testach | `testy/t_taras.rb` |
| fundament okrągły | `rdzen/fundamenty.rb` |
| fundament pod działową | `rdzen/fundamenty.rb` |
| fundament słupa zadaszenia | `rdzen/zadaszenie.rb` |
| fundament w obrysie | `rdzen/fundamenty.rb` |
| fundamenty poza wyceną drewna | `rdzen/wycena.rb` |
| fundamenty przybudówki | `rdzen/podloga_przybudowki.rb` |
| fundamenty punktowe | `rdzen/fundamenty.rb` |
| fundamenty punktowe – parametry | `rdzen/parametry_podloga.rb` |
| funkcje pomocnicze okna | `html/wspolne.js` |
| gdzie co zmieniać | `testy/spis_tresci.rb` |
| geom::point3d | `testy/atrapa/sketchup.rb` |
| geom::transformation | `testy/atrapa/sketchup.rb` |
| gniazda płatwi w wiązarze | `rdzen/taras_wiazar.rb` |
| gniazdo 40 × 36 | `testy/t_zamek.rb` |
| gniazdo do połowy bala | `rdzen/pol_zamka.rb` |
| gniazdo dolne | `rdzen/zamek.rb` |
| gniazdo górne | `rdzen/zamek.rb` |
| gniazdo płatwi | `rdzen/szczyty.rb`, `testy/t_szczyty.rb` |
| gniazdo płatwi w węgle pod nią | `rdzen/szczyty.rb` |
| gniazdo płatwi węższe | `rdzen/zamek_platwi.rb` |
| gniazdo zamka w widoku | `testy/t_widok.rb` |
| graniastosłup | `rdzen/pryzmat.rb` |
| grupa dach | `sketchup/budowa.rb` |
| grupa domu | `sketchup/budowa.rb` |
| grupa i tag taras (słupy | `sketchup/budowa.rb` |
| grupa podłoga | `sketchup/budowa.rb` |
| grupa stolarka | `sketchup/stolarka_modele.rb` |
| grupa ściany | `sketchup/budowa.rb` |
| grupy pozycji | `testy/zrzut_dok2d.rb` |
| góra ścian | `rdzen/wience.rb` |
| górne wieńce pod okapem | `rdzen/wypusty_okapu.rb` |
| górny bal ściany wysokiej | `rdzen/dach_jednospadowy.rb` |
| górny bal ścięty do płaszczyzny dachu | `rdzen/sciecie_dachu.rb` |
| głębokość gniazda płatwi w wiązarze | `rdzen/taras_wiazar.rb` |
| głębokość tarasu | `rdzen/taras.rb` |
| htmldialog | `sketchup/okno.rb` |
| identyczne bale | `rdzen/bryla.rb`, `rdzen/pozycje.rb` |
| ikony paska | `sketchup/pasek.rb` |
| ilość impregnatu | `rdzen/materialy.rb` |
| ilość sztuk | `rdzen/pozycje.rb` |
| impregnat – parametry | `rdzen/parametry_materialy.rb` |
| init okna | `testy/okno_dane.rb` |
| instalacja | `testy/buduj_rbz.rb` |
| izolacja | `testy/t_podloga.rb` |
| izolacja a wysokość legara | `rdzen/statyka.rb` |
| izolacja pod pierwszy wieniec | `rdzen/materialy.rb` |
| izolacja podłogi | `rdzen/podloga.rb` |
| jeden przekrój płatwi | `rdzen/platwie_wience.rb` |
| jeden przełącznik doboru | `rdzen/magazyn_drewna.rb` |
| jeden temat = jeden plik | `testy/sprawdz_zasady.rb` |
| jeden węgieł | `rdzen/styki.rb` |
| jedno cofnij dla domu i połaci | `testy/t_dach_aplikacja.rb` |
| jednostki mm/cale | `sketchup/konwersja.rb` |
| kalenica | `rdzen/sciany.rb` |
| kalenica w poprzek | `rdzen/skrzydla.rb` |
| kanał kliknięciem | `html/kanaly.js` |
| kanał na przewody | `rdzen/kanaly.rb` |
| kanały elektryczne | `rdzen/kanaly.rb` |
| kanały na przewody w oknie | `html/kanaly.js` |
| kanały na przewody – parametry | `rdzen/parametry_kanaly.rb` |
| karta widoku ściany | `html/okno.html` |
| karty kroku | `html/kroki.js` |
| karty kroków | `html/okno.html` |
| katalog appdata | `sketchup/ustawienia.rb` |
| katalog dokumenty | `sketchup/eksport.rb` |
| katalog przekrojów z magazynu | `rdzen/parametry.rb` |
| katalog wtyczki | `main.rb` |
| kawałek bala | `rdzen/bale.rb` |
| kawałki płatwi | `rdzen/podzial_belek.rb` |
| kierunek a/b | `rdzen/sciany.rb` |
| kierunek legarów | `rdzen/podloga.rb` |
| klasa drewna | `rdzen/statyka.rb` |
| kliknięcie tuż po zmianie pola (przebudowa odłożona) | `html/wspolne.js` |
| kliknięcie uwagi | `html/uwagi.js` |
| kliknięcie w widok ściany | `html/klik_sciana.js`, `html/sciana.js` |
| kliknięcie ściany na rzucie | `html/rzut.js` |
| kolejność kroków | `rdzen/projekt.rb` |
| kolizje | `rdzen/kontrola.rb`, `testy/losowe_domy.rb` |
| kolizje belek | `testy/kolizje_belek.rb`, `testy/t_szczyty.rb` |
| kolizje belek między sobą | `testy/kolizje_belek.rb` |
| kolizje krokwi z działową | `testy/t_losowe.rb` |
| kolory | `html/okno.css` |
| kolumny tabeli | `rdzen/parametry_tabela.rb` |
| komponent | `rdzen/pozycje.rb` |
| komponent bala | `sketchup/budowa.rb` |
| komunikat zamiast wyjątku | `rdzen/awaria.rb` |
| komunikaty | `html/okno.css` |
| komunikaty w oknie | `sketchup/okno.rb`, `html/okno.js` |
| koniec płatwi na dachu głównym | `rdzen/skrzydla.rb` |
| koniec płatwi w koszu | `rdzen/podpory_platwi_l.rb` |
| koniec ściany bez ostatka | `rdzen/sciana_w_linii.rb` |
| konsola ruby | `log.rb` |
| kontrfor | `rdzen/sciany.rb`, `rdzen/usztywnienie.rb` |
| kontrfor przerwany przy otworze | `rdzen/bale.rb` |
| kontrfor w oknie | `html/wegly.js` |
| kontrfor z tabeli | `rdzen/wegly_tabela.rb` |
| kontrfor – wysokość | `rdzen/wience.rb` |
| kontrola | `rdzen/kontrola.rb` |
| kontrola krokwi z aplikacji | `testy/sprawdz_dach_aplikacja.rb` |
| kontrola przed commitem | `testy/uruchom.sh` |
| kontrola z menu | `testy/t_sketchup.rb` |
| kontrola zamków z menu | `sketchup/sterowanie.rb` |
| kontrola ścian w jednej linii | `rdzen/kontrola_rownoleglych.rb` |
| kopia pliku ustawień | `sketchup/ustawienia.rb` |
| kosz dachu | `rdzen/skrzydla.rb` |
| kosz dachu – podpora | `rdzen/podpory_platwi_l.rb` |
| koszt materiału | `rdzen/wycena.rb` |
| koszt materiału w oknie | `html/wycena.js` |
| kotwice styków | `rdzen/styki.rb` |
| kotwy podwalin | `rdzen/materialy.rb` |
| kotwy podwalin – parametr | `rdzen/parametry_materialy.rb` |
| krawędzie | `sketchup/wejscie.rb` |
| krawędzie szczytowe | `rdzen/polacie.rb`, `testy/t_polacie.rb` |
| krawędzie szczytowe w modelu | `sketchup/dach_aplikacja.rb` |
| krok 1 z generatora | `rdzen/polacie.rb` |
| krok 2 w atrapie | `testy/atrapa/aplikacja_dachow.rb` |
| krok 2 w górę | `testy/sprawdz_dach_aplikacja.rb` |
| krok 2 z generatora | `rdzen/krok2.rb`, `sketchup/dach_aplikacja.rb`, `testy/t_dach_aplikacja.rb` |
| krok pola | `rdzen/poziomy.rb` |
| kroki okna | `rdzen/poziomy.rb`, `html/kroki.js` |
| kroki okna – dane | `sketchup/okno.rb` |
| krokiew | `rdzen/dach.rb`, `rdzen/elementy.rb` |
| krokiew na szczycie | `testy/t_szczyty.rb` |
| krokiew ukośna | `sketchup/konwersja.rb` |
| krokiew wiązara | `rdzen/taras_wiazar.rb` |
| krokiew wiązara – nośność | `rdzen/statyka_wiazara.rb` |
| krokwie dachu jednospadowego | `rdzen/dach_jednospadowy.rb` |
| krokwie obie strony | `testy/t_szczyty.rb` |
| krokwie od wewnątrz | `testy/t_szczyty.rb` |
| krokwie przy szczycie | `rdzen/dach.rb`, `rdzen/przyklady.rb` |
| krokwie z aplikacji do dachów – parametr | `rdzen/parametry_dach.rb`, `rdzen/parametry_lista.rb` |
| krokwie z aplikacji i z generatora w teście losowym | `testy/t_losowe.rb` |
| krokwie z aplikacji nad płatwiami | `testy/sprawdz_dach_aplikacja.rb` |
| krokwie z generatora albo z aplikacji | `testy/t_polacie.rb` |
| krokwie z generatora albo z aplikacji do dachów | `rdzen/dach.rb` |
| krokwie zadaszenia | `rdzen/dach.rb` |
| krokwie zadaszenia – nośność | `rdzen/statyka_krokwi.rb` |
| krótkie krawędzie | `testy/t_losowe.rb` |
| krótkie krawędzie brył | `testy/losowe_domy.rb` |
| kąt dachu | `rdzen/dach.rb` |
| kąt zadaszenia | `rdzen/zadaszenie.rb` |
| kąt zastrzału | `rdzen/taras_wiazar.rb` |
| labirynt | `rdzen/zamek.rb` |
| legar | `rdzen/elementy.rb`, `rdzen/podloga.rb` |
| legar – parametry | `rdzen/parametry_podloga.rb` |
| legar – sprawdzenie | `rdzen/statyka.rb` |
| legary dzielone na podciągu | `rdzen/podciagi.rb` |
| legary między podwalinami | `testy/t_podloga.rb` |
| lico okapu | `rdzen/dach.rb` |
| lico zewnętrzne | `rdzen/obrys.rb` |
| liczba zmian w sekcji | `html/zmiany.js` |
| liczba zmian w zakładce | `html/zakladki.js` |
| liczby wyniku | `html/wyniki.js` |
| liczniki ui.start_timer | `testy/atrapa/sketchup.rb` |
| limit powierzchni zabudowy | `rdzen/powierzchnie.rb` |
| limit powierzchni zabudowy – parametr | `rdzen/parametry_materialy.rb` |
| limit wysokości | `rdzen/powierzchnie.rb` |
| limit wysokości – parametr | `rdzen/parametry_materialy.rb` |
| linia dachu | `rdzen/dach.rb`, `testy/t_szczyty.rb` |
| linia dachu w widoku | `rdzen/widok.rb`, `testy/t_widok.rb` |
| linia dachu z załamaniem zadaszenia | `rdzen/dach.rb` |
| linia podparcia | `rdzen/pod_dachem.rb` |
| linia załamania | `rdzen/zadaszenie.rb` |
| linie obrysu w grupie | `sketchup/wejscie.rb` |
| linie wejściowe | `rdzen/obrys.rb` |
| lista bali | `rdzen/pozycje.rb`, `html/wyniki.js` |
| lista belek | `rdzen/elementy.rb` |
| lista do zamówienia w pliku | `rdzen/zestawienie.rb` |
| lista kanałów | `html/kanaly.js` |
| lista parametrów | `rdzen/parametry_lista.rb` |
| lista parametrów – dokument | `testy/lista_parametrow.rb` |
| lista przekrojów płatwi | `rdzen/statyka_dachu.rb` |
| lista przekrojów z długościami | `rdzen/wykaz_drewna.rb` |
| lista stolarki – parametr | `rdzen/parametry_stolarka.rb` |
| lista typowej stolarki w oknie | `html/otwory.js` |
| lista typowej stolarki – wiersz | `rdzen/stolarka_modele.rb` |
| lista uwag | `rdzen/uwagi_pola.rb`, `html/uwagi.js` |
| lista uwag – wygląd | `html/kroki.css` |
| lista węgłów do okna | `rdzen/wegly_tabela.rb` |
| lista węgłów w oknie | `html/wegly_przesun.js` |
| lista ścian | `rdzen/projekt.rb` |
| lista ścian otworu | `html/otwory.js` |
| losowa podłoga w przybudówce | `testy/losowe_domy.rb` |
| losowe boczne zadaszenie | `testy/losowe_domy.rb` |
| losowe domy | `testy/losowe_domy.rb` |
| losowe krokwie z aplikacji | `testy/losowe_domy.rb` |
| losowe luzy stolarki | `testy/losowe_domy.rb` |
| losowe ustawienia ścian | `testy/losowe_domy.rb` |
| losowe łączenie wieńców szczytu | `testy/losowe_domy.rb` |
| losowy dach jednospadowy | `testy/losowe_domy.rb` |
| losowy dobór przekrojów zadaszenia i krokwi | `testy/losowe_domy.rb` |
| losowy pełny profil | `testy/losowe_domy.rb` |
| losowy taras | `testy/losowe_domy.rb` |
| luka między węgłem a płatwią | `rdzen/platwie_wience.rb` |
| luz 0,5 | `testy/t_zamek.rb` |
| luz boczny | `rdzen/stolarka.rb` |
| luz górny | `rdzen/stolarka.rb` |
| luz górny w tabeli | `html/otwory.js` |
| luz osiadania | `rdzen/stolarka.rb` |
| luz osiadania pod balem | `rdzen/osiadanie.rb` |
| luz pionowy | `rdzen/kontrola.rb` |
| luz pionowy 2,5 | `testy/t_zamek.rb` |
| luz w zamku | `rdzen/zamek.rb` |
| luz wpustu | `rdzen/profil_bala.rb` |
| magazyn drewna | `rdzen/magazyn_drewna.rb` |
| magazyn drewna – parametry | `rdzen/parametry_materialy.rb` |
| maksymalna długość bala | `rdzen/styki.rb` |
| mapa kodu | `testy/spis_tresci.rb` |
| maskownice | `rdzen/stolarka_prosta.rb` |
| maskownice – parametry | `rdzen/parametry_stolarka.rb` |
| materiał szyby | `sketchup/stolarka_modele.rb` |
| menu | `sketchup/menu.rb` |
| menu kontekstowe | `sketchup/pasek.rb` |
| menu pod prawym przyciskiem | `sketchup/pasek.rb` |
| miejsce na węgieł | `rdzen/usztywnienie.rb` |
| mijanka | `rdzen/styki.rb`, `testy/losowe_domy.rb`, `testy/t_rdzen.rb` |
| mijanka 300 | `rdzen/parametry.rb` |
| mijanka – sprawdzenie | `rdzen/kontrola.rb` |
| model drzwi | `rdzen/stolarka_modele.rb` |
| model okna | `rdzen/stolarka_modele.rb` |
| model zastępczy drzwi | `rdzen/stolarka_prosta.rb` |
| model zastępczy okna | `rdzen/stolarka_prosta.rb` |
| modele stolarki | `rdzen/stolarka_modele.rb` |
| modele stolarki w modelu | `sketchup/stolarka_modele.rb` |
| module_files | `main.rb`, `testy/sprawdz_zasady.rb` |
| mostek nad gniazdem | `rdzen/skos_przy_narozniku.rb` |
| nachodzenie bali | `rdzen/kontrola.rb` |
| nad działową | `rdzen/ustawienia_scian.rb`, `html/edycja.js` |
| nadbitka | `rdzen/krok2.rb` |
| nadbitka kroku 2 w testach | `testy/t_podbitka.rb` |
| nadbitka – parametry | `rdzen/parametry_dach.rb` |
| nadproże | `rdzen/otwory.rb` |
| nadstawka | `rdzen/dopelnienie.rb`, `rdzen/wience.rb` |
| nagłówki plików | `testy/spis_tresci.rb`, `testy/sprawdz_zasady.rb` |
| nakładanie się ścian równoległych | `rdzen/kontrola_rownoleglych.rb` |
| narożnik l | `rdzen/sciany.rb` |
| narożnik wklęsły | `rdzen/sciany.rb` |
| nazwa bala 10-4200 | `rdzen/pozycje.rb` |
| nic nie zaznaczone | `rdzen/dom_z_wymiarow.rb` |
| niepełna ściana | `rdzen/wegly_konstrukcyjne.rb` |
| nowe drzwi | `html/otwory.js` |
| nowe okno | `html/otwory.js` |
| nowy parametr | `rdzen/parametry_lista.rb` |
| nowy węgieł | `html/wegly.js` |
| nośność belki | `rdzen/statyka.rb` |
| nośność krokwi | `rdzen/statyka_krokwi.rb` |
| nośność płatwi | `rdzen/statyka_dachu.rb` |
| nośność słupa | `rdzen/statyka_slupa.rb` |
| numer kompilacji | `Plugins/arte_madera_generator_wiencowy.rb`, `main.rb`, `sketchup/menu.rb`, `testy/sprawdz_zasady.rb` |
| numeracja bali | `rdzen/pozycje.rb` |
| numeracja ścian | `rdzen/sciany.rb` |
| numery pozycji na widoku | `html/sciana.js` |
| numery wierszy | `testy/spis_tresci.rb` |
| o wtyczce | `sketchup/menu.rb` |
| obciążenia | `rdzen/parametry_podloga.rb` |
| obciążenie użytkowe – rysunek | `html/pomoc.js` |
| obciążenie zadaszenia | `rdzen/statyka_zadaszenia.rb` |
| obciążenie śniegiem | `rdzen/statyka_dachu.rb` |
| objaśnienie pola | `html/pomoc.js` |
| objętość | `rdzen/bryla.rb`, `rdzen/zestawienie.rb`, `testy/t_siatka.rb` |
| objętość belki | `rdzen/pryzmat.rb` |
| objętość bryły | `sketchup/raport.rb`, `testy/t_raport.rb` |
| objętość siatki | `rdzen/siatka.rb` |
| objętość z profilem | `rdzen/profil_bala.rb` |
| obniżenie dachu | `rdzen/platwie_wience.rb` |
| obniżenie ścian pod podbitką | `rdzen/podbitka.rb` |
| obrys | `rdzen/obrys.rb` |
| obrys bala w widoku | `rdzen/widok.rb`, `testy/t_widok.rb` |
| obrys h | `testy/zlozone_domy.rb` |
| obrys krzyż | `testy/zlozone_domy.rb` |
| obrys l | `rdzen/przyklady.rb`, `rdzen/skrzydla.rb`, `testy/t_rdzen.rb` |
| obrys prostokątny | `testy/pomoc.rb` |
| obrys t | `testy/zlozone_domy.rb` |
| obrys u | `testy/zlozone_domy.rb` |
| obrys w kształcie l | `testy/pomoc.rb` |
| obrys z | `testy/zlozone_domy.rb` |
| obrys z przybudówką | `rdzen/zadaszenie.rb` |
| obrys z siatki pól | `testy/zlozone_domy.rb` |
| obrys z wymiarów | `rdzen/dom_z_wymiarow.rb` |
| obróbka kanal | `rdzen/kanaly.rb` |
| obróbka puszka | `rdzen/kanaly.rb` |
| obróbki bala | `rdzen/bryla.rb` |
| obrót | `testy/t_rdzen.rb` |
| obrót o 180° | `rdzen/bryla.rb` |
| obrót obrysu | `testy/pomoc.rb` |
| obrót układu | `rdzen/geometria.rb` |
| ocena przekroju przy polu | `html/przeliczenia.js` |
| oczep | `rdzen/zadaszenie.rb` |
| oczep – nośność | `rdzen/statyka_zadaszenia.rb` |
| odbiór bez scenariusza | `sketchup/dziennik_pracy.rb` |
| odcinek 244 | `testy/t_zamek.rb` |
| odcinki 244 i 344 | `testy/t_sciany_ust.rb` |
| odcinki nad działową | `rdzen/dopelnienie.rb` |
| odcinki nadstawki | `rdzen/bale.rb` |
| odległości | `rdzen/geometria.rb` |
| odstęp kanału od zamka | `rdzen/parametry_kanaly.rb` |
| odświeżenie pól po zmianie | `html/okno.js` |
| okap | `rdzen/dach.rb` |
| okap połaci | `rdzen/polacie.rb`, `testy/t_polacie.rb` |
| okap za ścianą wysoką | `rdzen/dach_jednospadowy.rb` |
| okap za ścianą wysoką w testach | `testy/t_jednospadowy.rb` |
| okienko kanału | `html/kanaly.js` |
| okienko kliknięcia – wygląd | `html/kroki.css` |
| okienko parametrów przy kliknięciu | `html/klik_sciana.js` |
| okienko po awarii obliczeń | `sketchup/sterowanie.rb` |
| okno | `rdzen/otwory.rb`, `rdzen/stolarka.rb`, `sketchup/okno.rb`, `html/okno.html` |
| okno kliknięciem | `html/klik_sciana.js` |
| okno wyboru pliku | `sketchup/okno_sciezki.rb` |
| okno zapisu | `sketchup/eksport.rb` |
| okno zapisu anulowane | `testy/t_zestawienie.rb` |
| okno – standard warsztatu | `sketchup/okno_typy.rb` |
| okno – typy domów | `sketchup/okno_typy.rb` |
| okno – wywołania | `testy/t_sketchup.rb` |
| okruchy bali | `testy/t_losowe.rb` |
| okucia | `rdzen/materialy.rb` |
| oparcie dachu nad szczytem | `rdzen/wypusty_okapu.rb` |
| opcja niedostępna dla obrysu – wygląd | `html/kroki.css` |
| opcja wyszarzona z powodem | `html/zalezne.js` |
| opcje niedostępne dla obrysu | `html/zalezne.js` |
| opcje zależne | `html/zalezne.js` |
| operacja cofnij | `sketchup/budowa.rb` |
| opis techniczny błędu | `rdzen/awaria.rb` |
| opis typu | `sketchup/typy_domow.rb` |
| opis w menedżerze rozszerzeń | `Plugins/arte_madera_generator_wiencowy.rb` |
| opisy ścian na rzucie | `html/rzut.js` |
| orientacja lic | `testy/t_zamek.rb` |
| osiadanie słupów | `rdzen/osiadanie.rb` |
| osiadanie ścian | `rdzen/stolarka.rb` |
| osie działowych | `rdzen/obrys.rb` |
| ostatek | `rdzen/sciany.rb` |
| ostatek 200 na narożniku | `testy/t_sciany_ust.rb` |
| ostatek 200 pod taras | `rdzen/ustawienia_scian.rb`, `html/edycja.js` |
| ostatek na końcu ściany | `html/edycja.js` |
| ostatek na narożniku | `rdzen/ustawienia_scian.rb` |
| ostatek nad ścianą wysoką | `rdzen/skos_przy_narozniku.rb` |
| ostatek pod dachem | `rdzen/pod_dachem.rb` |
| ostatek przy tarasie | `rdzen/taras.rb` |
| ostatni bal węgła pod dachem | `rdzen/pol_zamka.rb` |
| ostatni plan | `sketchup/sterowanie.rb` |
| ostatnie parametry | `sketchup/sterowanie.rb` |
| ostatnie połączenie pod dachem | `rdzen/pol_zamka.rb` |
| ostrzeżenia | `log.rb`, `rdzen/projekt.rb` |
| ostrzeżenie o ręcznych poprawkach | `sketchup/sterowanie.rb` |
| ostrzeżenie o ścianach w tym samym miejscu | `rdzen/kontrola_rownoleglych.rb` |
| otwory | `testy/t_rdzen.rb` |
| otwory w ścianach siatki | `testy/t_siatka.rb` |
| otwory) | `rdzen/projekt.rb` |
| otwór | `rdzen/otwory.rb` |
| otwór pionowy w balach | `rdzen/kanaly.rb` |
| otwór w balach w oknie | `html/otwory.js` |
| otwór z listy stolarki | `html/otwory.js` |
| oś kalenicy domu l | `rdzen/skrzydla.rb` |
| oś ściany | `rdzen/sciany.rb` |
| paczka rbz | `testy/buduj_rbz.rb` |
| panel standardu | `html/standard.js` |
| panel standardu warsztatu | `html/okno.html` |
| panel standardu – wygląd | `html/kroki.css` |
| panel ustawień ściany | `html/okno.css` |
| panel ściany | `html/edycja.js` |
| para węgłów | `rdzen/styki.rb` |
| parametr tabela | `rdzen/parametry_tabela.rb` |
| parametry | `rdzen/projekt.rb` |
| parametry dachu | `rdzen/parametry_dach.rb` |
| parametry nowego domu | `rdzen/poziomy.rb` |
| parametry płatwi | `rdzen/parametry_dach.rb` |
| parametry szczytów | `rdzen/parametry_dach.rb` |
| parametry typu | `sketchup/typy_domow.rb` |
| parapet | `rdzen/otwory.rb` |
| pas dachu na płatew | `rdzen/statyka_dachu.rb` |
| pas połaci zadaszenia | `rdzen/statyka_zadaszenia.rb` |
| pasek kroków | `html/kroki.js`, `html/okno.html` |
| pasek narzędzi | `sketchup/pasek.rb` |
| pasek pod gniazdem | `rdzen/platwie_wience.rb` |
| pasek typu domu | `html/okno.html`, `html/typy.js` |
| pasek typu – wygląd | `html/kroki.css` |
| pasek zakładek | `html/okno.html` |
| pasy przekroju | `rdzen/profil_bala.rb`, `rdzen/siatka.rb` |
| pasy ze skośnym wierzchem | `rdzen/bryla.rb` |
| pełny profil bala | `rdzen/profil_bala.rb` |
| pełny profil w teście | `rdzen/przyklady.rb` |
| pełzanie | `rdzen/statyka.rb` |
| pierwszy wieniec | `rdzen/wience.rb` |
| pierwszy wieniec bez wpustu | `rdzen/profil_bala.rb` |
| pióro | `rdzen/profil_bala.rb` |
| plan domu | `rdzen/projekt.rb` |
| plan po wyjątku | `rdzen/awaria.rb` |
| playwright | `testy/t_okno.js` |
| plik modelu stolarki | `rdzen/stolarka_modele.rb` |
| plik ustawień | `sketchup/ustawienia.rb` |
| plik ustawień ze starszej kompilacji | `sketchup/ustawienia.rb` |
| pod dachem | `rdzen/pod_dachem.rb` |
| podbitka | `rdzen/podbitka.rb` |
| podbitka na krokwiach | `rdzen/podbitka.rb` |
| podbitka na krokwiach w testach | `testy/t_podbitka.rb` |
| podbitka na płatwiach | `rdzen/podbitka.rb` |
| podbitka na płatwiach w testach | `testy/t_podbitka.rb` |
| podbitka pod krokwiami | `rdzen/podbitka.rb` |
| podbitka pod krokwiami w testach | `testy/t_podbitka.rb` |
| podbitka pod płatwiami | `rdzen/podbitka.rb` |
| podbitka pod płatwiami w testach | `testy/t_podbitka.rb` |
| podbitka z aplikacji do dachów | `rdzen/podbitka.rb` |
| podbitka – parametry | `rdzen/parametry_dach.rb` |
| podbitka – rysunek | `html/pomoc.js` |
| podciąg | `rdzen/podciagi.rb` |
| podciąg do lica podwalin | `rdzen/podciagi.rb` |
| podciąg na równo z podwaliną | `rdzen/podciagi.rb` |
| podciąg pod podwaliną | `rdzen/podciagi.rb` |
| podciąg z bali | `rdzen/taras.rb` |
| podciąg – parametry | `rdzen/parametry_podloga.rb` |
| podciągi w liniach fundamentów | `rdzen/podciagi.rb` |
| podcięcie 2,5 × 42 | `testy/t_zamek.rb` |
| podcięcie boczne | `rdzen/zamek.rb` |
| podcięcie zamka przy skosie | `testy/t_losowe.rb` |
| podgląd | `sketchup/okno.rb` |
| podgląd 3d | `testy/podglad.py`, `testy/podglad.rb` |
| podgląd automatyczny | `html/okno.js` |
| podkładki pod głowicę słupa | `rdzen/osiadanie.rb` |
| podmiana modelu stolarki | `rdzen/stolarka_prosta.rb` |
| podparcie płatwi domu l | `rdzen/podpory_platwi_l.rb` |
| podpis bala | `rdzen/bryla.rb` |
| podpis zawartości | `sketchup/atrybuty.rb` |
| podpora | `rdzen/elementy.rb` |
| podpora legarów | `rdzen/podciagi.rb` |
| podpory dla aplikacji do dachów w teście losowym | `testy/losowe_domy.rb` |
| podpory krokwi | `rdzen/krok2.rb` |
| podpory legarów | `testy/t_podloga.rb` |
| podpory w atrapie | `testy/atrapa/aplikacja_dachow.rb` |
| podpory w modelu | `sketchup/dach_aplikacja.rb`, `testy/t_dach_aplikacja.rb` |
| podpowiedzi | `rdzen/projekt.rb`, `html/okno.html`, `testy/t_okno.js` |
| podpowiedzi podłogi | `rdzen/podloga.rb`, `html/wyniki.js` |
| podpowiedzi pól | `rdzen/parametry_lista.rb`, `sketchup/okno.rb`, `html/okno.css`, `html/okno.js` |
| podpowiedzi w oknie | `sketchup/sterowanie.rb` |
| podpowiedzi w sekcji | `html/przeliczenia.js` |
| podpowiedź dachu | `rdzen/polacie.rb`, `testy/t_polacie.rb` |
| podpowiedź kroku 2 | `rdzen/krok2.rb` |
| podpowiedź luzu | `rdzen/stolarka.rb`, `html/otwory.js` |
| podpowiedź o długości legara i podciągu | `rdzen/dlugosci_handlowe.rb` |
| podpowiedź o długości płatwi | `rdzen/dlugosci_handlowe.rb` |
| podpowiedź po wejściu w pole | `html/kroki.css`, `html/pomoc.js` |
| podstawy słupów | `rdzen/materialy.rb` |
| podsumowanie | `rdzen/projekt.rb` |
| podwalina | `rdzen/elementy.rb`, `rdzen/podloga.rb` |
| podwalina dawnej ściany okapowej | `rdzen/podloga_przybudowki.rb` |
| podwalina na styk | `rdzen/podloga.rb` |
| podwalina – parametry | `rdzen/parametry_podloga.rb` |
| podwaliny na zakład | `testy/t_podloga.rb` |
| podwójne pióro | `rdzen/profil_bala.rb` |
| podział belek | `rdzen/podzial_belek.rb` |
| podział wieńca | `rdzen/bale.rb` |
| podłoga | `rdzen/podloga.rb` |
| podłoga w przybudówce | `rdzen/podloga_przybudowki.rb` |
| podłoga w przybudówce – parametr | `rdzen/parametry_zadaszenie.rb` |
| podłoga – parametry | `rdzen/parametry_podloga.rb` |
| pojemnik sekcji zakładki | `html/zakladki.js` |
| pokaz grup | `testy/zrzut_dok2d.rb` |
| pola nadpisane w domu | `rdzen/poziomy.rb` |
| pola podstawowe | `rdzen/parametry_lista.rb`, `html/tryb.js` |
| pola standardu | `html/standard.js` |
| pola typu w kroku | `html/kroki.js` |
| pola zależne | `html/zalezne.js` |
| pola zmienione | `html/okno.css` |
| pole legarów | `rdzen/podloga_przybudowki.rb` |
| pole nadrzędne | `html/zalezne.js` |
| pole obrysu | `testy/t_widok.rb` |
| pole przypięte | `html/kroki.js` |
| pole tabela w oknie | `html/tabela.js` |
| pole zmienione tylko w tym domu | `html/typy.js` |
| pole zmienione w domu – wygląd | `html/kroki.css` |
| pomieszczenia z rzutu | `rdzen/powierzchnie.rb` |
| poprawa otworu kliknięciem | `html/klik_sciana.js` |
| poprawa otworu z widoku ściany | `html/otwory.js` |
| poprzednie połacie przy przebudowie | `sketchup/dach_aplikacja.rb` |
| porównanie modelu z planem | `sketchup/raport.rb` |
| porównanie tabel | `html/tabela.js` |
| porównanie układów | `html/uklad.js` |
| poręcz bez piór | `rdzen/taras_balustrada.rb` |
| poręcz na jednej wysokości | `rdzen/taras_balustrada.rb` |
| poręcz tarasu | `rdzen/taras_sciany.rb` |
| poszycie dachu | `rdzen/krok2.rb` |
| poszycie dachu – parametry | `rdzen/parametry_dach.rb`, `rdzen/parametry_lista.rb` |
| powiel typ | `sketchup/typy_domow.rb`, `html/typy.js` |
| powierzchnia dachu | `rdzen/materialy.rb` |
| powierzchnia dachu w wyniku | `rdzen/powierzchnie.rb` |
| powierzchnia do impregnacji | `rdzen/materialy.rb` |
| powierzchnia pomieszczeń | `rdzen/powierzchnie.rb` |
| powierzchnia tarasu | `rdzen/powierzchnie.rb` |
| powierzchnia użytkowa | `rdzen/powierzchnie.rb` |
| powierzchnia zabudowy | `rdzen/powierzchnie.rb` |
| powrót pola do typu albo standardu | `html/typy.js` |
| poziom domu z0 | `sketchup/wejscie.rb` |
| poziom pola | `rdzen/poziomy.rb` |
| poziom pola w oknie | `html/typy.js` |
| poziom pola – dokument | `testy/lista_parametrow.rb` |
| poziom wieńca | `rdzen/wience.rb` |
| poziom ±0 | `rdzen/otwory.rb` |
| poziomy ustawień | `rdzen/poziomy.rb` |
| pozycja | `rdzen/pozycje.rb`, `sketchup/atrybuty.rb` |
| pozycja belki z przekrojem | `rdzen/pryzmat.rb` |
| pozycja elementu | `rdzen/elementy.rb` |
| pozycje bez ceny | `rdzen/wycena.rb`, `html/wycena.js` |
| pozycje menu | `sketchup/menu.rb` |
| połacie dachu | `rdzen/polacie.rb` |
| połacie domu l w testach | `testy/t_skrzydla.rb` |
| połacie przy samych płatwiach | `rdzen/polacie.rb` |
| połacie w atrapie | `testy/atrapa/aplikacja_dachow.rb` |
| połacie w modelu | `sketchup/dach_aplikacja.rb`, `testy/t_dach_aplikacja.rb` |
| połacie w planie | `rdzen/projekt.rb` |
| połacie w teście losowym | `testy/losowe_domy.rb` |
| połacie z api | `testy/sprawdz_dach_aplikacja.rb` |
| połać dachu jednospadowego | `rdzen/polacie.rb` |
| połać zadaszenia | `rdzen/zadaszenie.rb` |
| położenie bala | `rdzen/bale.rb` |
| położenie belki | `rdzen/elementy.rb` |
| położenie desek nadbitki i podbitki | `rdzen/parametry_dach.rb` |
| położenie domu przy przebudowie | `sketchup/budowa.rb` |
| położenie podciągów | `rdzen/podciagi.rb` |
| położenie węgła od narożnika | `rdzen/wegly_tabela.rb` |
| połączenie działowych | `rdzen/dzialowe_bliskie.rb` |
| połączenie t | `rdzen/sciany.rb` |
| prawa kolumna przyklejona | `html/kroki.css` |
| prefiks bs / kf | `rdzen/pozycje.rb` |
| prefiks bs/kf/sz/pw/l/pd/p/k | `sketchup/atrybuty.rb` |
| prefiks elementu | `rdzen/elementy.rb` |
| prefiks sz | `rdzen/szczyty.rb` |
| prefiksy bs kf sz | `testy/zrzut_dok2d.rb` |
| presety | `rdzen/parametry_lista.rb` |
| profil bala | `rdzen/bryla.rb` |
| profil bala – parametry | `rdzen/parametry_lista.rb` |
| prostopadłościan otaczający | `testy/kolizje_belek.rb` |
| prosty model stolarki | `rdzen/stolarka_prosta.rb` |
| prosty model stolarki w modelu | `sketchup/stolarka_modele.rb` |
| prosty model stolarki – parametry | `rdzen/parametry_stolarka.rb` |
| przebieg generowania | `rdzen/projekt.rb` |
| przebudowa | `sketchup/atrybuty.rb`, `sketchup/budowa.rb`, `testy/t_sketchup.rb` |
| przebudowa połaci | `testy/t_dach_aplikacja.rb` |
| przebudowa z parametrów | `sketchup/sterowanie.rb` |
| przecinek dziesiętny | `rdzen/zestawienie.rb` |
| przecięcia odcinków | `rdzen/geometria.rb` |
| przedziały | `rdzen/bryla.rb` |
| przedłużenie ściany zewnętrznej | `rdzen/sciana_w_linii.rb` |
| przejście do pola | `html/kroki.js` |
| przejście z uwagi do pola | `rdzen/uwagi_pola.rb`, `html/uwagi.js` |
| przekroje z hurtowni | `rdzen/wykaz_drewna.rb` |
| przekroje z magazynu | `rdzen/magazyn_drewna.rb` |
| przekrój bala | `rdzen/parametry_lista.rb` |
| przekrój członu wiązara | `rdzen/taras_wiazar.rb` |
| przekrój szer×wys | `rdzen/parametry.rb` |
| przekrój słupka i zastrzałów wiązara | `rdzen/taras_wiazar.rb` |
| przekrój w wrębie | `rdzen/zamek_platwi.rb` |
| przekrój wielokątny | `rdzen/pryzmat.rb` |
| przekładka balustrady | `rdzen/taras_balustrada.rb` |
| przekładki w szczycie | `rdzen/taras_szczyt.rb` |
| przeliczenia przy parametrach | `html/przeliczenia.js` |
| przeliczenia przy sekcji | `html/okno.css` |
| przerwa pod płatwią | `rdzen/platwie_wience.rb` |
| przesunięcie o pół wieńca | `rdzen/wience.rb` |
| przesunięcie płatwi | `rdzen/platwie_wience.rb` |
| przesunięcie węgła na liście ręcznej | `html/edycja.js` |
| przesunięty dom zostaje na miejscu | `sketchup/budowa.rb` |
| przesuwanie węgłów | `rdzen/wegly_tabela.rb`, `html/wegly_przesun.js` |
| przesuwanie węgłów w teście okna | `testy/t_okno.js` |
| przesuń węgieł | `html/wegly_przesun.js` |
| przesuń węgieł w okienku | `html/klik_sciana.js` |
| przeszkody przy ścianie okapowej | `rdzen/zadaszenie.rb` |
| przełączanie zakładek | `html/zakladki.js` |
| przełącznik doboru przekrojów | `rdzen/parametry_materialy.rb` |
| przełącznik klik wstawia | `html/klik_sciana.js` |
| przełącznik pól | `html/okno.css`, `html/okno.html`, `html/tryb.js` |
| przełącznik pól podstawowe / wszystkie | `html/okno.js` |
| przełącznik układu | `html/uklad.js` |
| przełącznik układu okna | `html/okno.html` |
| prześwit balustrady | `rdzen/taras_balustrada.rb` |
| prześwit pod połacią | `rdzen/pod_dachem.rb` |
| prześwit pod zadaszeniem | `rdzen/zadaszenie.rb` |
| przybudówka bez podłogi | `rdzen/podloga_przybudowki.rb` |
| przybudówka z bali | `rdzen/zadaszenie.rb` |
| przybudówka – parametry | `rdzen/parametry_zadaszenie.rb` |
| przycisk generuj | `sketchup/okno.rb` |
| przycisk wybierz | `html/sciezka.js` |
| przyciski | `html/okno.html` |
| przyciski paska | `sketchup/pasek.rb` |
| przycięcie wielokąta | `rdzen/zamek_platwi.rb` |
| przykładowe domy | `rdzen/przyklady.rb`, `testy/t_raport.rb` |
| przywrócenie fabrycznych | `sketchup/ustawienia.rb` |
| przywróć fabryczne | `html/standard.js` |
| przywróć typ | `html/typy.js` |
| przywróć węgły automatyczne | `html/edycja.js` |
| przęsła balustrady | `rdzen/taras.rb` |
| przęsła krokwi | `rdzen/krok2.rb` |
| przęsła między płatwiami | `testy/sprawdz_dach_aplikacja.rb` |
| przęsło balustrady | `rdzen/taras_balustrada.rb` |
| przęsło krokwi | `rdzen/statyka_krokwi.rb` |
| przęsło płatwi | `rdzen/statyka_dachu.rb` |
| punkt odniesienia otworu | `html/rzut.js` |
| punkt sketchupa | `sketchup/konwersja.rb` |
| punkt w przekroju belki | `testy/kolizje_belek.rb` |
| punkty podziału | `rdzen/symetria_wegly.rb` |
| punkty podziału profilu (granice obróbek przed przecięciami) | `rdzen/bryla.rb` |
| punkty próbne | `testy/kolizje_belek.rb` |
| punkty t | `rdzen/siatka.rb` |
| puszka elektryczna | `rdzen/kanaly.rb` |
| puszka elektryczna – parametry | `rdzen/parametry_kanaly.rb` |
| puszka w okienku | `html/kanaly.js` |
| pytajnik i objaśnienie | `html/okno.css` |
| pytajnik przy polu | `html/pomoc.js` |
| pół zamka | `rdzen/pol_zamka.rb` |
| pół zamka na górze węgła | `rdzen/pol_zamka.rb` |
| półbal | `rdzen/wience.rb` |
| półbal frontu tarasu | `rdzen/wience.rb` |
| półka | `rdzen/ustawienia_scian.rb` |
| półzamek przy styku | `rdzen/zamek.rb` |
| płaszczyzna pozioma | `sketchup/wejscie.rb` |
| płaszczyzna połaci w testach | `testy/kolizje_belek.rb` |
| płaszczyzna spodu krokwi | `rdzen/polacie.rb`, `testy/t_polacie.rb` |
| płatew | `rdzen/dach.rb`, `rdzen/elementy.rb` |
| płatew dzielona nad ścianą | `rdzen/podzial_belek.rb` |
| płatew kalenicowa | `rdzen/dach.rb` |
| płatew na balu | `rdzen/platwie_wience.rb` |
| płatew na balu węgła | `rdzen/platwie_wience.rb` |
| płatew na węgle | `rdzen/wegly_konstrukcyjne.rb` |
| płatew przez szczyt | `rdzen/szczyty.rb` |
| płatew przy ścianie | `rdzen/zadaszenie.rb` |
| płatew skrzydła na płatwi głównej | `rdzen/podpory_platwi_l.rb` |
| płatew trzyma szczyt | `rdzen/zamek_platwi.rb` |
| płatew w powietrzu | `rdzen/platwie_wience.rb` |
| płatew zadaszenia – nośność | `rdzen/statyka_zadaszenia.rb` |
| płatew ścienna | `rdzen/dach.rb`, `testy/t_szczyty.rb` |
| płatew ścienna – rysunek | `html/pomoc.js` |
| płatew ścięta | `rdzen/pryzmat.rb` |
| płatwie dachu jednospadowego | `rdzen/dach_jednospadowy.rb` |
| płatwie jako podpory | `rdzen/krok2.rb` |
| płatwie pod połacią | `testy/kolizje_belek.rb` |
| płatwie skrzydła bocznego | `rdzen/skrzydla.rb` |
| płatwie skrzydła bocznego w testach | `testy/t_skrzydla.rb` |
| płatwie zadaszenia | `rdzen/zadaszenie.rb` |
| płyty osb | `rdzen/krok2.rb` |
| rama grupy (bounds) | `testy/atrapa/sketchup.rb` |
| rama okna | `rdzen/stolarka_prosta.rb` |
| rama okna – parametr | `rdzen/parametry_stolarka.rb` |
| raport do testów | `sketchup/raport.rb` |
| raport json | `sketchup/raport.rb`, `testy/t_raport.rb` |
| raport zapisywany sam | `sketchup/dziennik_pracy.rb` |
| regresja | `testy/t_losowe.rb` |
| regresja rundy 14 | `testy/t_zlozone.rb` |
| regresja styków bez zamka w szczycie | `testy/t_styki_szczytu.rb` |
| regulacja słupa | `rdzen/osiadanie.rb` |
| rejestracja rozszerzenia | `Plugins/arte_madera_generator_wiencowy.rb` |
| rodzaj dachu | `rdzen/dach.rb` |
| rodzaj drewna c24 nsi duo bsh | `rdzen/magazyn_drewna.rb` |
| rodzaj obrysu | `rdzen/powierzchnie.rb` |
| rodzaj otworu okno / drzwi | `rdzen/stolarka_modele.rb` |
| rola timber | `sketchup/atrybuty.rb` |
| rozkład ściany | `rdzen/widok.rb`, `html/sciana.js` |
| rozmieszczenie kart | `html/uklad.js` |
| rozmieszczenie węgłów | `rdzen/usztywnienie.rb` |
| rozpiętość legara | `rdzen/statyka.rb` |
| rozpiętość podciągu | `rdzen/podciagi.rb` |
| rozpoznanie pola z tekstu uwagi | `rdzen/uwagi_pola.rb` |
| rozstaw fundamentów | `rdzen/fundamenty.rb` |
| rozstaw krokwi | `rdzen/dach.rb` |
| rozstaw legarów | `rdzen/podloga.rb` |
| ruby 2.2 | `testy/sprawdz_zasady.rb` |
| ruby 2.7 | `testy/ruby27.sh` |
| rysunek domu | `testy/podglad.py` |
| rysunek objaśniający | `html/pomoc.js` |
| rysunek svg | `html/rzut.js` |
| rysunki objaśniające | `html/okno.css` |
| rzut w oknie | `sketchup/sterowanie.rb`, `html/rzut.js` |
| rząd fundamentów | `rdzen/fundamenty.rb` |
| rzędy w osiach działowych | `rdzen/fundamenty.rb` |
| równy podział odcinka | `rdzen/symetria_wegly.rb` |
| ręczne poprawki | `sketchup/atrybuty.rb` |
| scalanie linii | `rdzen/obrys.rb` |
| scalanie ścian współpłaszczyznowych | `rdzen/siatka.rb` |
| sekcje | `testy/t_okno.js` |
| sekcje formularza | `html/okno.html` |
| sekcje okna | `rdzen/parametry_lista.rb`, `sketchup/okno.rb` |
| sekcje pól | `html/okno.js` |
| sekcje w zakładkach | `html/okno.js` |
| siatka | `rdzen/siatka.rb` |
| siatka belki | `rdzen/pryzmat.rb` |
| siatka belki z wrębami | `rdzen/zamek_platwi.rb` |
| siatka fundamentów | `rdzen/fundamenty.rb` |
| siatka pełnego profilu | `rdzen/siatka.rb` |
| siatka styków szczytu | `rdzen/styki_szczytu.rb` |
| skos | `testy/t_siatka.rb` |
| skos (szczyty) | `rdzen/bryla.rb` |
| skos bala | `rdzen/szczyty.rb` |
| skos węgła | `rdzen/pod_dachem.rb` |
| skrzydło boczne | `rdzen/skrzydla.rb` |
| skrzydło boczne w testach | `testy/t_skrzydla.rb` |
| skrzydło drzwi | `rdzen/stolarka_prosta.rb` |
| skrzydło główne | `rdzen/skrzydla.rb` |
| skrzyżowania w widoku | `rdzen/widok.rb` |
| skrzyżowanie x | `rdzen/sciany.rb`, `testy/t_rdzen.rb` |
| skąd węgieł | `html/wegly_przesun.js` |
| smukłość słupa | `rdzen/statyka_slupa.rb` |
| spadek dachu | `rdzen/dach_jednospadowy.rb` |
| spadek dachu w testach | `testy/t_jednospadowy.rb` |
| spis treści | `testy/spis_tresci.rb` |
| sprawdzanie parametrów | `rdzen/parametry.rb` |
| sprawdzenie domu | `testy/losowe_domy.rb` |
| sprawdzenie podciągu | `rdzen/podciagi.rb` |
| sprawdzenie wzrokowe | `testy/podglad.rb` |
| sprawdzenie zamka | `rdzen/kontrola.rb` |
| sprawdzone | `rdzen/uwagi_pola.rb`, `html/uwagi.js` |
| standard warsztatu | `rdzen/poziomy.rb`, `sketchup/ustawienia.rb` |
| standard warsztatu na pasku | `sketchup/pasek.rb` |
| standard warsztatu w menu | `sketchup/menu.rb` |
| standard warsztatu w oknie | `html/standard.js` |
| standard warsztatu z menu | `sketchup/sterowanie.rb` |
| standard warsztatu z menu – okno bez domu | `html/standard.js` |
| stara aplikacja do dachów | `sketchup/dach_aplikacja.rb`, `testy/t_dach_aplikacja.rb` |
| stare wartości | `rdzen/parametry_lista.rb` |
| start okna | `html/okno.js` |
| start z menu | `sketchup/sterowanie.rb` |
| statyka | `rdzen/statyka.rb` |
| statyka dachu | `rdzen/statyka_dachu.rb` |
| statyka krokwi | `rdzen/statyka_krokwi.rb` |
| statyka legara | `testy/t_podloga.rb` |
| statyka słupa | `rdzen/statyka_slupa.rb` |
| statyka wiązara | `rdzen/statyka_wiazara.rb` |
| statyka zadaszenia | `rdzen/statyka_zadaszenia.rb` |
| sterowanie | `sketchup/sterowanie.rb` |
| stolarka | `rdzen/stolarka.rb` |
| stolarka w oknie | `html/otwory.js` |
| stopy fundamentowe | `rdzen/fundamenty.rb` |
| strefa skrzydła | `rdzen/skrzydla.rb` |
| stromy dach | `rdzen/pod_dachem.rb` |
| strop | `rdzen/dopelnienie.rb`, `rdzen/ustawienia_scian.rb`, `testy/t_sciany_ust.rb` |
| styk | `rdzen/styki.rb` |
| styk bez zamka | `rdzen/kontrola.rb` |
| styk dwóch ścian w zamku | `rdzen/sciana_w_linii.rb` |
| styk frontu tarasu | `rdzen/styki_tarasu.rb` |
| styk na działowej | `rdzen/styki_dzialowe.rb` |
| styk na styk | `rdzen/styki_tarasu.rb` |
| styk na styk w szczycie | `rdzen/styki_szczytu.rb` |
| styk nad słupem | `rdzen/styki_tarasu.rb` |
| styk przy otworze | `testy/t_wegly.rb` |
| styk płatwi nad podporą | `rdzen/podzial_belek.rb` |
| styk w osi zamka | `rdzen/styki.rb` |
| styk w wieńcu | `rdzen/bale.rb` |
| styki bez zamka | `testy/losowe_domy.rb`, `testy/t_losowe.rb` |
| styki na widoku | `html/sciana.js` |
| styki symetryczne | `rdzen/symetria_wegly.rb` |
| styki w widoku | `rdzen/widok.rb`, `testy/t_widok.rb` |
| styki wspólne | `rdzen/styki_dzialowe.rb` |
| suma wyceny | `html/wycena.js` |
| sumy grup | `rdzen/zestawienie.rb`, `testy/t_zestawienie.rb` |
| symetria węgłów | `rdzen/symetria_wegly.rb` |
| szablony | `html/okno.css`, `testy/t_okno.js`, `testy/t_sketchup.rb` |
| szczelina styku | `rdzen/styki.rb` |
| szczyt | `rdzen/szczyty.rb` |
| szczyt ażurowy | `rdzen/taras_szczyt.rb` |
| szczyt bez bali | `rdzen/taras_wiazar.rb` |
| szczyt bez kontrfory | `rdzen/styki_tarasu.rb` |
| szczyt bez węgłów pod styki | `rdzen/styki_szczytu.rb` |
| szczyt na części ściany | `rdzen/skrzydla.rb` |
| szczyt na części ściany w testach | `testy/t_skrzydla.rb` |
| szczyt na działowej | `rdzen/szczyty.rb` |
| szczyt na styk | `rdzen/styki_szczytu.rb` |
| szczyt nad tarasem | `rdzen/taras_szczyt.rb` |
| szczyt nad tarasem w testach | `testy/t_taras.rb` |
| szczyt nad tarasem – parametry | `rdzen/parametry_taras.rb` |
| szczyt pusty | `rdzen/taras_szczyt.rb` |
| szczyt płaski ściany wysokiej | `rdzen/szczyty.rb` |
| szczyt skośny | `rdzen/dach_jednospadowy.rb` |
| szczyt skośny (jednospadowy) | `rdzen/szczyty.rb` |
| szczyt skośny w testach | `testy/t_jednospadowy.rb` |
| szerokość domu | `rdzen/dom_z_wymiarow.rb` |
| szukanie pola standardu | `html/standard.js` |
| szyba | `rdzen/stolarka_prosta.rb` |
| słownik artemadera | `sketchup/atrybuty.rb` |
| słup krótszy o osiadanie | `rdzen/osiadanie.rb` |
| słup licem z lica ściany | `rdzen/taras_slupy.rb` |
| słup na podwalinie | `rdzen/taras_slupy.rb` |
| słup narożny tarasu | `rdzen/taras_slupy.rb` |
| słup pod węgłem | `rdzen/taras_slupy.rb` |
| słup tarasu | `rdzen/elementy.rb` |
| słup w osi kalenicy w testach | `testy/t_taras.rb` |
| słup zadaszenia – nośność | `rdzen/statyka_zadaszenia.rb` |
| słupek pod płatwią | `rdzen/podpory_platwi_l.rb`, `rdzen/taras_szczyt.rb` |
| słupek pod płatwią zadaszenia | `rdzen/zadaszenie.rb` |
| słupek wiązara | `rdzen/taras_wiazar.rb` |
| słupek z kontrfor pod płatwią | `rdzen/wegly_konstrukcyjne.rb` |
| słupki pod płatwiami do wyboru w testach | `testy/t_wegly.rb` |
| słupki pod płatwiami w koszu w testach | `testy/t_skrzydla.rb` |
| słupy tarasu | `rdzen/taras.rb`, `rdzen/taras_slupy.rb` |
| słupy tarasu na widoku | `html/sciana.js` |
| słupy tarasu w testach | `testy/t_taras.rb` |
| słupy tarasu w widoku | `rdzen/widok.rb` |
| słupy tarasu – parametry | `rdzen/parametry_taras.rb` |
| słupy zadaszenia | `rdzen/zadaszenie.rb` |
| tabela | `html/okno.css` |
| tabela drewna | `rdzen/magazyn_drewna.rb` |
| tabela działowych | `html/dzialowe.js` |
| tabela jako json | `html/tabela.js` |
| tabela materiałów w oknie | `html/wyniki.js` |
| tabela otworów | `sketchup/okno.rb`, `html/otwory.js` |
| tabela w standardzie warsztatu | `rdzen/parametry_tabela.rb`, `html/standard.js` |
| tabela w standardzie – wygląd | `html/kroki.css` |
| tabela węgłów | `rdzen/wegly_tabela.rb`, `html/wegly.js` |
| tabela z okna jako json | `rdzen/parametry_tabela.rb` |
| tabela ścian | `html/wyniki.js` |
| tag stolarka | `sketchup/budowa.rb`, `sketchup/stolarka_modele.rb` |
| tag szczyty | `sketchup/budowa.rb` |
| tagi | `sketchup/budowa.rb` |
| tak/nie | `rdzen/parametry.rb` |
| taras | `rdzen/taras.rb` |
| taras 1100 w testach | `testy/t_taras.rb` |
| taras 1100 – balustrada | `rdzen/taras_balustrada.rb` |
| taras 1200 w testach | `testy/t_taras.rb` |
| taras w przebiegu | `rdzen/projekt.rb` |
| taras w teście | `rdzen/przyklady.rb` |
| taras – parametry | `rdzen/parametry_lista.rb`, `rdzen/parametry_taras.rb` |
| taśma między wieńcami – parametr | `rdzen/parametry_materialy.rb` |
| taśma uszczelniająca między wieńcami | `rdzen/materialy.rb` |
| ten dom | `rdzen/poziomy.rb` |
| teren pod pierwszym balem | `rdzen/powierzchnie.rb` |
| teren pod pierwszym balem – parametr | `rdzen/parametry_materialy.rb` |
| test bloku materiałów w csv | `testy/t_materialy.rb` |
| test brakującego modelu | `testy/t_stolarka.rb` |
| test cennika materiałów | `testy/t_wycena.rb` |
| test dawnych pól okna i drzwi | `testy/t_stolarka.rb` |
| test doboru w całej długości | `testy/t_wycena.rb` |
| test doboru z długością | `testy/t_dlugosci.rb` |
| test domu z wymiarów | `testy/t_poziomy.rb` |
| test domu z wymiarów w oknie | `testy/t_okno_kroki.js` |
| test działania | `rdzen/przyklady.rb`, `sketchup/raport.rb`, `testy/t_raport.rb` |
| test działania z menu | `sketchup/menu.rb` |
| test działowych domu z wymiarów | `testy/t_stolarka.rb` |
| test długości handlowych | `testy/t_dlugosci.rb` |
| test gniazda do połowy bala | `testy/t_pol_zamka.rb` |
| test impregnacji | `testy/t_materialy.rb` |
| test kanału przy zamku | `testy/t_kanaly.rb` |
| test kanału w widoku ściany | `testy/t_kanaly.rb` |
| test kanałów na przewody | `testy/t_kanaly.rb` |
| test komunikatu po awarii | `testy/t_zlozone.rb` |
| test kroków okna | `testy/t_poziomy.rb` |
| test listy przekrojów z długościami | `testy/t_dlugosci.rb` |
| test listy stolarki | `testy/t_stolarka.rb` |
| test listy uwag | `testy/t_okno_kroki.js`, `testy/t_poziomy.rb` |
| test losowy | `testy/losowe_domy.rb`, `testy/t_losowe.rb` |
| test luzu osiadania pod balem | `testy/t_osiadanie.rb` |
| test magazynu drewna | `testy/t_wycena.rb` |
| test modeli stolarki | `testy/t_stolarka.rb` |
| test nowego domu z typu | `testy/t_typy.rb` |
| test okna | `testy/t_okno.js` |
| test okna samego standardu | `testy/t_okno_kroki.js` |
| test okuć | `testy/t_materialy.rb` |
| test opcji niedostępnych dla obrysu | `testy/t_okno_kroki.js` |
| test ostatniego połączenia pod dachem | `testy/t_pol_zamka.rb` |
| test otworu pionowego w balu | `testy/t_kanaly.rb` |
| test panelu standardu | `testy/t_okno_kroki.js` |
| test pliku ustawień starszej wersji | `testy/t_typy.rb` |
| test podziału płatwi nad ścianą | `testy/t_dlugosci.rb` |
| test pola tabeli | `testy/t_stolarka.rb` |
| test powierzchni dachu | `testy/t_materialy.rb` |
| test powierzchni i limitów | `testy/t_poziomy.rb` |
| test poziomów pól w oknie | `testy/t_okno_kroki.js` |
| test położenia modelu w otworze | `testy/t_stolarka.rb` |
| test prostego modelu stolarki | `testy/t_stolarka.rb` |
| test przełącznika doboru | `testy/t_wycena.rb` |
| test przełącznika doboru w typie | `testy/t_stolarka.rb` |
| test przełącznika układu | `testy/t_okno_kroki.js` |
| test puszki | `testy/t_kanaly.rb` |
| test rodzaju obrysu | `testy/t_poziomy.rb` |
| test styków w wieńcach szczytu | `testy/t_styki_szczytu.rb` |
| test szablonów jako typów | `testy/t_typy.rb` |
| test taśmy między wieńcami | `testy/t_materialy.rb` |
| test układu kroków | `testy/t_okno_kroki.js` |
| test wyboru ścieżki | `testy/t_stolarka.rb` |
| test wyceny | `testy/t_wycena.rb` |
| test wyceny w csv | `testy/t_wycena.rb` |
| test wyjątku doboru | `testy/t_wycena.rb` |
| test węgła pod styk do wysokości ściany | `testy/t_styki_szczytu.rb` |
| test ścian równoległych | `testy/t_zlozone.rb` |
| test śruby regulacyjnej słupa | `testy/t_osiadanie.rb` |
| testy | `testy/pomoc.rb` |
| testy api dachów | `testy/t_dach_aplikacja.rb` |
| testy aplikacji do dachów | `testy/t_dach_aplikacja.rb` |
| testy bocznego zadaszenia | `testy/t_zadaszenie.rb` |
| testy dachu jednospadowego | `testy/t_jednospadowy.rb` |
| testy doboru krokwi | `testy/t_statyka_zadaszenia.rb` |
| testy domów złożonych | `testy/t_zlozone.rb` |
| testy kroku 2 | `testy/t_polacie.rb` |
| testy na starszym ruby | `testy/ruby27.sh` |
| testy offline | `testy/atrapa/sketchup.rb` |
| testy osiadania słupów | `testy/t_osiadanie.rb` |
| testy podbitki | `testy/t_podbitka.rb` |
| testy podpór | `testy/t_polacie.rb` |
| testy podłogi | `testy/t_podloga.rb` |
| testy podłogi w przybudówce | `testy/t_statyka_zadaszenia.rb` |
| testy poszycia | `testy/t_polacie.rb` |
| testy poziomów ustawień | `testy/t_poziomy.rb` |
| testy połaci | `testy/t_polacie.rb` |
| testy przybudówki z bali | `testy/t_zadaszenie.rb` |
| testy pół zamka | `testy/t_pol_zamka.rb` |
| testy raportu | `testy/t_raport.rb` |
| testy rdzenia | `testy/t_rdzen.rb` |
| testy siatki | `testy/t_siatka.rb` |
| testy sketchup | `testy/t_sketchup.rb` |
| testy standardu warsztatu | `testy/t_typy.rb` |
| testy statyki dachu | `testy/t_statyka_dachu.rb` |
| testy statyki zadaszenia | `testy/t_statyka_zadaszenia.rb` |
| testy szczytu na styk | `testy/t_styki_szczytu.rb` |
| testy szczytów | `testy/t_szczyty.rb` |
| testy słupa | `testy/t_statyka_zadaszenia.rb` |
| testy tarasu | `testy/t_taras.rb` |
| testy typów domów | `testy/t_typy.rb` |
| testy ustawień ściany | `testy/t_sciany_ust.rb` |
| testy wiaty bocznej | `testy/t_zadaszenie.rb` |
| testy widoku ściany | `testy/t_widok.rb` |
| testy wykazu drewna | `testy/t_dlugosci.rb` |
| testy węgłów | `testy/t_wegly.rb` |
| testy zakładki zadaszenia | `testy/t_statyka_zadaszenia.rb` |
| testy zamka | `testy/t_zamek.rb` |
| testy załamania dachu | `testy/t_zadaszenie.rb` |
| testy zestawienia csv | `testy/t_zestawienie.rb` |
| testy zestawienia materiałów | `testy/t_materialy.rb` |
| tolerancje | `rdzen/geometria.rb` |
| transformacja bala | `sketchup/konwersja.rb` |
| transformacja belki | `sketchup/konwersja.rb` |
| transformacja domu (obrót układu lokalnego) | `sketchup/konwersja.rb` |
| tryb doboru elementu | `rdzen/parametry.rb` |
| tryb nowy / edycja | `sketchup/sterowanie.rb` |
| tryb podstawowe / zaawansowane | `html/tryb.js` |
| tryb pól okna | `sketchup/okno.rb`, `sketchup/ustawienia.rb` |
| trójkąt nad tarasem | `rdzen/taras_wiazar.rb` |
| trójkąt w wąskim domu | `rdzen/taras_wiazar.rb` |
| trójkąt w wąskim domu w testach | `testy/t_statyka_dachu.rb` |
| trójkąt w wąskim domu – przekrój | `rdzen/statyka_wiazara.rb` |
| tworzenie elementów | `html/wspolne.js` |
| tylko narysowane | `testy/t_wegly.rb` |
| typ domu | `rdzen/poziomy.rb`, `sketchup/typy_domow.rb` |
| typ stolarki w tabeli | `html/otwory.js` |
| typy domów | `sketchup/typy_domow.rb` |
| typy domów w oknie – dane startowe | `sketchup/okno.rb` |
| typy wbudowane | `sketchup/typy_domow.rb` |
| typy wbudowane – dokument | `testy/lista_parametrow.rb` |
| ugięcie | `rdzen/statyka.rb`, `testy/t_podloga.rb` |
| ugięcie płatwi | `rdzen/statyka_dachu.rb` |
| ugięcie – rysunek | `html/pomoc.js` |
| ukrywanie pól | `html/tryb.js` |
| ukrywanie pól zależnych | `html/zalezne.js` |
| układ dachu | `rdzen/dach.rb` |
| układ dachu – rysunek | `html/pomoc.js` |
| układ lokalny (obrót) | `rdzen/obrys.rb` |
| układ lokalny belki | `testy/kolizje_belek.rb` |
| układ na przemian | `rdzen/styki.rb` |
| układ nowy i dotychczasowy | `html/uklad.js` |
| układ okna | `sketchup/ustawienia.rb`, `html/okno.html`, `html/uklad.js` |
| układ okna – wygląd | `html/kroki.css` |
| układ okna – zapamiętanie | `sketchup/okno_typy.rb` |
| uniesienie krokwi w testach | `testy/t_podbitka.rb` |
| uruchamianie testów | `testy/uruchom.sh` |
| ustawienia kroku 2 | `rdzen/krok2.rb` |
| ustawienia okna | `sketchup/ustawienia.rb` |
| ustawienia ścian do ruby | `html/edycja.js` |
| ustawienia ściany | `rdzen/ustawienia_scian.rb` |
| ustawienia ściany w widoku | `rdzen/widok.rb` |
| ustawienie bala licem | `rdzen/zamek.rb` |
| usunięty węgieł | `testy/t_sciany_ust.rb` |
| usuwanie starych definicji | `sketchup/budowa.rb` |
| usuń działową | `html/dzialowe.js` |
| usuń kanał | `html/kanaly.js` |
| usuń otwór kliknięciem | `html/klik_sciana.js` |
| usuń typ | `sketchup/typy_domow.rb`, `html/typy.js` |
| usuń wiersz | `html/tabela.js` |
| usuń węgieł | `rdzen/ustawienia_scian.rb` |
| usuń węgieł kliknięciem | `html/edycja.js` |
| usuń węgieł w okienku | `html/klik_sciana.js` |
| uwaga a krok | `rdzen/uwagi_pola.rb` |
| uwaga a pole | `rdzen/uwagi_pola.rb` |
| uwagi w prawej kolumnie | `html/uwagi.js` |
| wariant 1100 | `rdzen/taras.rb` |
| wariant 1200 | `rdzen/taras.rb` |
| wartości domyślne | `rdzen/parametry_lista.rb` |
| wartości domyślne – dokument | `testy/lista_parametrow.rb` |
| wartość fabryczna | `html/zmiany.js` |
| wejście (segmenty | `rdzen/projekt.rb` |
| wejście na taras | `rdzen/taras.rb` |
| wejście na taras w testach | `testy/t_taras.rb` |
| wejście w balustradzie | `rdzen/taras_sciany.rb` |
| wektory | `rdzen/geometria.rb` |
| wersja | `main.rb` |
| wersja pliku ustawień | `sketchup/ustawienia.rb` |
| wiata boczna – parametry | `rdzen/parametry_zadaszenie.rb` |
| widoczność pól według poziomu | `html/kroki.js` |
| widok ściany | `rdzen/widok.rb`, `html/okno.css`, `html/sciana.js`, `testy/okno_dane.rb` |
| widok ściany dla okna | `sketchup/sterowanie.rb` |
| widok ściany w oknie | `sketchup/okno.rb` |
| wielokąt z otworem | `rdzen/siatka.rb` |
| wieniec | `rdzen/wience.rb` |
| wieniec szczytu | `rdzen/styki_szczytu.rb` |
| wieniec węgła nad ścianą | `rdzen/wience.rb` |
| wiercenie bali | `rdzen/kanaly.rb` |
| wiersze tabeli | `rdzen/parametry_tabela.rb` |
| wiersze tabeli w oknie | `html/tabela.js` |
| wierzch bala pod dachem | `rdzen/pol_zamka.rb` |
| wieńce ciągłe przez taras | `rdzen/taras_sciany.rb` |
| wieńce niższej działowej | `rdzen/wience.rb` |
| wieńce szczytu | `rdzen/wience.rb` |
| wiązar bez belki dolnej | `rdzen/taras_wiazar.rb` |
| wiązar licem z frontem | `rdzen/taras_wiazar.rb` |
| wiązar pod płatwiami | `rdzen/taras_wiazar.rb` |
| wiązar szczytu tarasu | `rdzen/taras_wiazar.rb` |
| wiązar – parametry | `rdzen/parametry_taras.rb` |
| więźba po ok w atrapie | `testy/atrapa/aplikacja_dachow.rb` |
| więźba powiązana z domem | `sketchup/dach_aplikacja.rb`, `testy/t_dach_aplikacja.rb` |
| więźba przy przebudowie | `testy/t_dach_aplikacja.rb` |
| więźba z aplikacji | `sketchup/dach_aplikacja.rb` |
| wolny koniec | `rdzen/sciany.rb` |
| wolny koniec działowej | `rdzen/wegly_konstrukcyjne.rb` |
| wolny koniec w testach | `testy/t_wegly.rb` |
| wpis do dziennika pracy po generowaniu | `sketchup/sterowanie.rb` |
| wpust | `rdzen/profil_bala.rb` |
| wrąb płatwi | `rdzen/zamek_platwi.rb` |
| wspornik okapu | `rdzen/wypusty_okapu.rb` |
| wstawienie drzwi z pliku | `sketchup/stolarka_modele.rb` |
| wstawienie modelu w otwór | `rdzen/stolarka_modele.rb` |
| wstawienie okna z pliku | `sketchup/stolarka_modele.rb` |
| wyboczenie słupa | `rdzen/statyka_slupa.rb` |
| wybory zależne od innego pola | `html/zalezne.js` |
| wybrany typ | `sketchup/typy_domow.rb` |
| wybór domu do edycji | `sketchup/wejscie.rb` |
| wybór folderu | `sketchup/okno_sciezki.rb`, `html/sciezka.js` |
| wybór pliku modelu | `sketchup/okno_sciezki.rb`, `html/sciezka.js` |
| wybór podbitki a układ dachu | `rdzen/podbitka.rb` |
| wybór podciągów | `rdzen/podciagi.rb` |
| wybór typu | `html/typy.js` |
| wybór typu w oknie | `sketchup/okno_typy.rb` |
| wybór ściany do widoku | `html/okno.js` |
| wybór ściany w oknie | `html/sciana.js` |
| wybór ścieżki | `sketchup/okno_sciezki.rb`, `html/sciezka.js` |
| wycena | `rdzen/wycena.rb` |
| wycena w oknie | `html/wycena.js` |
| wycena w zestawieniu csv | `rdzen/wycena.rb` |
| wycięcie bala przy otworze | `rdzen/otwory.rb` |
| wydanie | `testy/buduj_rbz.rb` |
| wygląd kroków | `html/kroki.css` |
| wygląd okna | `html/okno.css` |
| wyjątek doboru dla elementu | `rdzen/magazyn_drewna.rb` |
| wykaz drewna | `rdzen/wykaz_drewna.rb` |
| wymiary otworu w balach | `rdzen/stolarka.rb` |
| wymiary zamka | `rdzen/parametry.rb`, `rdzen/parametry_lista.rb` |
| wymiary zamka w oknie | `html/okno.js` |
| wymiary zamka w standardzie | `html/standard.js` |
| wynik okna | `testy/okno_dane.rb` |
| wyniki w oknie | `html/wyniki.js` |
| wypust w narożniku tarasu | `rdzen/taras_sciany.rb` |
| wypust w narożniku wklęsłym | `testy/t_skrzydla.rb` |
| wypust węgła pod okapem | `rdzen/wypusty_okapu.rb` |
| wypust węgła wewnątrz i na zewnątrz | `rdzen/sciany.rb` |
| wypust za szczyt | `rdzen/wypusty_okapu.rb` |
| wypuszczone wieńce | `rdzen/wypusty_okapu.rb` |
| wyrównanie bliskich poziomów obróbek | `rdzen/bryla.rb` |
| wyrównanie skosu do naroży gniazd | `rdzen/sciecie_dachu.rb` |
| wyrównanie ścięcia do granic pasów | `rdzen/sciecie_dachu.rb` |
| wyróżnienie zmienionych pól | `html/zmiany.js` |
| wysokości ścian | `html/wyniki.js` |
| wysokość balustrady | `rdzen/taras_sciany.rb` |
| wysokość kalenicy | `rdzen/powierzchnie.rb` |
| wysokość szczytu | `rdzen/szczyty.rb` |
| wysokość ściany | `rdzen/wience.rb` |
| wysokość ściany poprzecznej przy styku | `rdzen/styki_dzialowe.rb` |
| wysunięcie dachu | `rdzen/dach.rb` |
| wysunięcie za szczyt w połaciach | `rdzen/polacie.rb` |
| wywołania ruby | `testy/t_okno.js` |
| wywołania typów | `sketchup/okno_typy.rb` |
| wzmocnienie ściany | `rdzen/usztywnienie.rb` |
| węgieł | `rdzen/usztywnienie.rb` |
| węgieł kliknięciem | `html/klik_sciana.js` |
| węgieł na wolnym końcu | `rdzen/wegly_konstrukcyjne.rb` |
| węgieł na środku ściany | `rdzen/wegly_tabela.rb`, `html/wegly.js` |
| węgieł od narożnika | `rdzen/usztywnienie.rb`, `testy/t_wegly.rb` |
| węgieł pod okapem | `rdzen/pod_dachem.rb` |
| węgieł pod płatwią | `rdzen/wegly_konstrukcyjne.rb` |
| węgieł pod płatwią w testach | `testy/t_wegly.rb` |
| węgieł pod styk do wysokości ściany | `rdzen/styki_szczytu.rb` |
| węgieł przy szczycie ścięty do dachu | `rdzen/sciecie_dachu.rb` |
| węgieł ręczny na widoku | `html/sciana.js` |
| węgieł tylko pod kalenicową | `rdzen/wegly_konstrukcyjne.rb` |
| węgieł w miejscu słupa tarasu | `rdzen/taras.rb` |
| węgieł w osi płatwi | `rdzen/wegly_konstrukcyjne.rb` |
| węgieł z tabeli | `rdzen/wegly_tabela.rb`, `html/wegly.js` |
| węgieł ściany wysokiej pod połacią | `rdzen/pod_dachem.rb` |
| węgły domu l pod dachem | `testy/t_skrzydla.rb` |
| węgły konstrukcyjne | `rdzen/wegly_konstrukcyjne.rb` |
| węgły na środku automatycznie | `rdzen/wegly_tabela.rb` |
| węgły przy oknach i drzwiach | `html/wegly_przesun.js` |
| węgły ręczne | `rdzen/ustawienia_scian.rb`, `testy/t_sciany_ust.rb` |
| węgły w tych samych miejscach | `rdzen/symetria_wegly.rb` |
| własne szablony jako typy | `sketchup/typy_domow.rb` |
| zakresy wartości | `rdzen/parametry.rb` |
| zakład podwalin | `rdzen/podloga.rb` |
| zakładka pod barierkę | `rdzen/taras_sciany.rb` |
| zakładka zadaszenia | `html/zakladki.js` |
| zakładki | `html/okno.css` |
| zakładki okna | `rdzen/parametry_lista.rb`, `sketchup/okno.rb`, `html/zakladki.js` |
| zakładki w teście okna | `testy/t_okno.js` |
| zamek | `rdzen/zamek.rb` |
| zamek dolny słupa | `rdzen/taras_slupy.rb` |
| zamek górny słupa | `rdzen/taras_slupy.rb` |
| zamek na połowie wysokości bala | `rdzen/pol_zamka.rb` |
| zamek płatwi | `rdzen/zamek_platwi.rb` |
| zamek płatwi nad szczytem tarasu | `rdzen/zamek_platwi.rb` |
| zamek płatwi nad tarasem w testach | `testy/t_taras.rb` |
| zamek płatwi tylko od spodu | `rdzen/zamek_platwi.rb` |
| zamiennik położenia desek | `rdzen/parametry_dach.rb` |
| zamiennik wyboru | `html/zalezne.js` |
| zamki słupów w testach | `testy/t_taras.rb` |
| zaokrąglenia | `rdzen/geometria.rb` |
| zapamiętane ustawienia | `testy/t_sketchup.rb` |
| zapamiętany tryb okna | `html/tryb.js` |
| zapas na docinki | `rdzen/materialy.rb` |
| zapas na docinki – parametr | `rdzen/parametry_materialy.rb` |
| zapis parametrów w modelu | `sketchup/atrybuty.rb` |
| zapis pliku | `sketchup/eksport.rb`, `testy/t_zestawienie.rb` |
| zapis standardu | `sketchup/ustawienia.rb` |
| zapis standardu z okna | `sketchup/okno_typy.rb` |
| zapis typu z okna | `sketchup/okno_typy.rb` |
| zapis ustawień | `sketchup/ustawienia.rb` |
| zapis zestawienia z okna | `sketchup/okno.rb` |
| zapisz jako typ | `sketchup/typy_domow.rb`, `html/typy.js` |
| zapisz standard | `html/standard.js` |
| zapisz zmiany w typie | `sketchup/typy_domow.rb`, `html/typy.js` |
| zasady kodu | `testy/sprawdz_zasady.rb` |
| zasięg pod linią dachu | `rdzen/szczyty.rb` |
| zastrzał | `rdzen/taras_wiazar.rb` |
| zaznaczenie | `sketchup/wejscie.rb` |
| zaznaczona ściana (prostokąt kliknięty raz) | `sketchup/wejscie.rb` |
| załamanie dachu | `rdzen/zadaszenie.rb` |
| załamanie dachu – parametry | `rdzen/parametry_zadaszenie.rb` |
| załamanie połaci dla aplikacji do dachów | `rdzen/polacie.rb` |
| załamanie połaci w aplikacji | `testy/sprawdz_dach_aplikacja.rb` |
| załamanie zadaszenia w szczycie | `rdzen/szczyty.rb` |
| załom linii dachu | `rdzen/dach.rb` |
| załom linii szczytu | `rdzen/szczyty.rb` |
| zbliżenie zamka | `testy/podglad.py` |
| zestawienie csv | `rdzen/zestawienie.rb` |
| zestawienie csv do pliku | `sketchup/eksport.rb` |
| zestawienie materiałów | `rdzen/materialy.rb` |
| zestawienie materiałów – parametry | `rdzen/parametry_materialy.rb` |
| zestawy testów | `testy/uruchom.sh` |
| zgodność z dokumentacją 2d | `testy/zrzut_dok2d.rb` |
| zgodność z ruby sketchupa | `testy/ruby27.sh` |
| ziarna błędów | `testy/t_losowe.rb` |
| ziarno | `testy/losowe_domy.rb` |
| ziarno domu złożonego | `testy/zlozone_domy.rb` |
| zmiana po podglądzie | `html/przeliczenia.js` |
| zmienione ustawienia w dzienniku | `sketchup/dziennik_pracy.rb` |
| zmienione względem fabrycznych | `html/zmiany.js` |
| zmień pole standardu tylko w tym domu | `html/kroki.js` |
| znacznik kontrforu | `rdzen/obrys.rb` |
| znacznik stanu kroku | `html/kroki.js` |
| zrzut geometrii | `testy/zrzut_dok2d.rb` |
| zrzut okna | `testy/t_okno.js` |
| zrzut okna – kroki | `testy/t_okno_kroki.js` |
| złożenie standardu i typu | `rdzen/poziomy.rb` |
| ładowanie modułów | `main.rb` |
| łączenie bali na długość | `rdzen/styki.rb` |
| łączenie bali szczytu nad tarasem | `rdzen/styki_tarasu.rb` |
| łączenie belki na długości | `rdzen/dlugosci_handlowe.rb` |
| łączenie na przemian | `rdzen/przyklady.rb`, `testy/t_wegly.rb` |
| łączenie podwalin na śruby | `rdzen/podloga.rb` |
| łączenie płatwi na długości | `rdzen/podzial_belek.rb` |
| łączenie w zamku działowej | `rdzen/styki_dzialowe.rb` |
| łączenie wieńców szczytu | `rdzen/styki_szczytu.rb` |
| łącznik płatwi z płatwią | `rdzen/podpory_platwi_l.rb` |
| łączniki krokwi z płatwiami | `rdzen/materialy.rb` |
| ściana | `rdzen/sciany.rb` |
| ściana bliźniacza | `rdzen/symetria_wegly.rb` |
| ściana domu przy przybudówce | `rdzen/zadaszenie.rb` |
| ściana domu przy tarasie | `rdzen/taras.rb` |
| ściana działowa | `testy/t_rdzen.rb` |
| ściana niska | `rdzen/dach_jednospadowy.rb` |
| ściana nośna | `rdzen/sciecie_dachu.rb` |
| ściana okapowa pod dachem | `rdzen/sciecie_dachu.rb` |
| ściana okapowa skrzydła bocznego | `rdzen/skrzydla.rb` |
| ściana przybudówki | `rdzen/zadaszenie.rb` |
| ściana przybudówki pod połacią | `rdzen/szczyty.rb` |
| ściana szczytowa | `rdzen/szczyty.rb` |
| ściana wysoka | `rdzen/dach_jednospadowy.rb`, `rdzen/usztywnienie.rb`, `testy/t_wegly.rb` |
| ściana wysoka w testach | `testy/t_jednospadowy.rb` |
| ściana wysoka – ścięcie skośne | `rdzen/sciecie_dachu.rb` |
| ściana z otworem | `sketchup/budowa.rb` |
| ściana z otworem w atrapie | `testy/atrapa/sketchup.rb` |
| ściany bryły | `rdzen/siatka.rb` |
| ściany równoległe | `rdzen/symetria_wegly.rb` |
| ściany tarasu na liście | `html/sciana.js` |
| ściany tarasu w widoku | `rdzen/widok.rb` |
| ścieżka modelu stolarki | `rdzen/parametry_stolarka.rb`, `rdzen/stolarka_modele.rb`, `sketchup/okno_sciezki.rb` |
| ścieżka modelu stolarki w oknie | `html/sciezka.js` |
| ściskanie wzdłuż włókien | `rdzen/statyka_slupa.rb` |
| ścięcie dachu | `rdzen/sciecie_dachu.rb` |
| ścięcie dachu w poprzek bala | `rdzen/bryla.rb` |
| ścięcie wierzchu płatwi | `rdzen/pryzmat.rb` |
| śnieg – parametr | `rdzen/parametry_dach.rb` |
| średnica fundamentu | `rdzen/fundamenty.rb` |
| średnica kanału | `rdzen/parametry_kanaly.rb` |
| środowisko sketchupa | `sketchup/raport.rb` |
| śruba regulacyjna słupa | `rdzen/osiadanie.rb` |
| światło ściany | `rdzen/usztywnienie.rb`, `testy/t_wegly.rb` |
| źródło węgła | `rdzen/widok.rb` |

## 2. Pliki

| Plik | Wierszy | Zadanie |
|---|---:|---|
| `Plugins/arte_madera_generator_wiencowy.rb` | 51 | rejestracja rozszerzenia w SketchUpie – jedyny plik ładowany automatycznie z folderu Plugins. |
| `main.rb` | 69 | stałe wtyczki (wersja, numer kompilacji, katalogi) i ładowanie modułów w kolejności zależności. |
| `log.rb` | 135 | dziennik wtyczki – jedno miejsce na błędy, ostrzeżenia, informacje i czasy etapów. |
| `rdzen/awaria.rb` | 51 | nieprzewidziany wyjątek w obliczeniach domu zamieniony na plan z komunikatem po polsku – co się stało, co sprawdzić, co wysłać; pełny ślad w dzienniku. |
| `rdzen/bale.rb` | 260 | bale każdej ściany w każdym wieńcu – kawałki między otworami i stykami, wycięcia przy otworach, skos szczytu, położenie w układzie domu. |
| `rdzen/bryla.rb` | 282 | bryła bala z obróbek – profil wzdłuż bala (przedziały z zakresem grubości i wysokości), przynależność punktu, objętość, podpis. |
| `rdzen/dach.rb` | 341 | geometria dachu – linia podparcia (wierzch płatwi), linia szczytu, płatwie w przekroju, krokwie, belki dachu; dwuspadowy tutaj, jednospadowy w rdzen/dach_jednospadowy.rb. |
| `rdzen/dach_jednospadowy.rb` | 111 | dach jednospadowy – ściana niska i wysoka, linia podparcia od ściany niskiej w górę, płatwie bez kalenicowej, krokwie w jednym kawałku, ściana wysoka do połaci. |
| `rdzen/dlugosci_handlowe.rb` | 103 | porównanie długości belek w modelu z długościami handlowymi z list przekrojów – podpowiedź, gdy belka jest dłuższa niż najdłuższa w hurtowni. |
| `rdzen/dom_z_wymiarow.rb` | 61 | dom prostokątny z wymiarów bez rysowania – obrys (lico zewnętrzne) z pól „Długość domu” i „Szerokość domu”, gdy w modelu nic nie jest zaznaczone; ściany działowe z tabeli okna. |
| `rdzen/dopelnienie.rb` | 97 | dopełnienie zamka nad niższą działową – przy ścianach, które idą wyżej, odcinki działowej (ostatek + grubość + dopelnienie_wewn) aż do góry tamtej ściany, jak 1100 W-6, W-7 i 1200 W-5, W-7. |
| `rdzen/dzialowe_bliskie.rb` | 89 | działowe narysowane bliżej siebie niż grubość bala (osie równoległe kilkadziesiąt mm od siebie, zachodzące na siebie długością) – połączone w jedną ścianę w miejscu dłuższej, z ostrzeżeniem; bale dwóch takich ścian zajmowałyby to samo miejsce. |
| `rdzen/elementy.rb` | 132 | elementy z belek (podłoga, dach) – belka prostopadłościenna w dowolnym położeniu, pozycje identycznych belek, lista zamówienia. |
| `rdzen/fundamenty.rb` | 146 | fundamenty punktowe pod podłogą – siatka rzędów w obu kierunkach w obrysie (skrajne licem z licem podwalin), stopy pod podwalinami, podciągami i podwalinami działowych. |
| `rdzen/geometria.rb` | 221 | działania na punktach 2D/3D (tablice [x, y] / [x, y, z] w mm) bez API SketchUpa. |
| `rdzen/kanaly.rb` | 106 | kanały na przewody elektryczne (N3) – pionowy otwór przez wszystkie wieńce ściany w zadanym miejscu (obróbka „kanal” bali, bryła z otworem) i opcjonalnie otwór puszki na zadanej wysokości (obróbka „puszka” – na liście obróbek); sprawdzenie miejsca (ściana, zamki skrzyżowań). |
| `rdzen/kontrola.rb` | 176 | kontrola wyniku – kolizje bali w słupach zamków, mijanka styków w sąsiednich wieńcach, styki poza zamkiem, długości bali. |
| `rdzen/kontrola_rownoleglych.rb` | 68 | kontrola ścian równoległych – bale dwóch ścian biegnących obok siebie albo w jednej linii nie mogą zajmować tego samego miejsca. |
| `rdzen/krok2.rb` | 178 | co generator przekazuje KROKOWI 2 aplikacji do dachów – ustawienia początkowe (kierunek, krokwie albo poszycie na samych płatwiach, warstwy poszycia, klasa drewna) i płatwie generatora jako podpory krokwi i poszycia. |
| `rdzen/magazyn_drewna.rb` | 155 | magazyn drewna – jedna tabela w standardzie warsztatu (przekrój, długości handlowe, rodzaj drewna, do czego: legar / podciąg, płatew, krokiew, belka zadaszenia, słup, deska; cena za m³) zamiast pięciu list tekstowych; listy przekrojów dla doboru, przeniesienie dawnych list, jeden przełącznik doboru przekrojów z wyjątkami. |
| `rdzen/materialy.rb` | 284 | zestawienie materiałów poza balami i belkami, liczone z geometrii domu – deski poszycia dachu (m² i sztuki), taśma między wieńcami, izolacja pod pierwszy wieniec, okucia (śruby regulacyjne i podstawy słupów, kotwy podwalin, łączniki krokwi) i powierzchnia drewna do impregnacji z ilością impregnatu. |
| `rdzen/obrys.rb` | 301 | rozpoznanie narysowanych linii – zamknięty obrys (lico zewnętrzne), osie ścian działowych, znaczniki kontrforów. |
| `rdzen/osiadanie.rb` | 71 | osiadanie ścian z bali a słupy – o ile krótszy ma być słup stojący pod balami (luz osiadania i okucie regulacyjne w głowicy), podpowiedź do okna. |
| `rdzen/otwory.rb` | 120 | otwory okienne i drzwiowe – położenie na ścianie, sprawdzenie, cięcia bali w każdym wieńcu. |
| `rdzen/parametry.rb` | 178 | sprawdzenie i uzupełnienie parametrów z okna / modelu / ustawień (zakresy, wybory, przekroje, zamek) i odczyt pomocniczy. |
| `rdzen/parametry_dach.rb` | 296 | parametry sekcji „Szczyty i dach” i „Poszycie dachu” – szczyty, dach, płatwie (dobór przekroju, śnieg, ciężar pokrycia), krokwie (dobór przekroju), oparcie dachu, poszycie, położenie desek nadbitki / podbitki (jedno pole) i przeniesienie dawnych pól nadbitki. |
| `rdzen/parametry_kanaly.rb` | 34 | parametry kanałów na przewody elektryczne (N3) – średnica kanału i puszki, wysokość puszki w okienku, odstęp kanału od zamków skrzyżowań. |
| `rdzen/parametry_lista.rb` | 286 | lista wszystkich parametrów – wartość domyślna, etykieta, jednostka, zakres, rodzaj pola, sekcja okna, podpowiedź; presety przekroju bala. |
| `rdzen/parametry_materialy.rb` | 72 | parametry sekcji „Zestawienie materiałów” (zapas na docinki, taśma między wieńcami, rozstaw kotew podwalin, wydajność i liczba warstw impregnatu) i „Powierzchnie i limity” (teren pod pierwszym balem, limit powierzchni zabudowy i wysokości). |
| `rdzen/parametry_podloga.rb` | 111 | parametry sekcji „Podłoga i fundamenty” – podwaliny (przekrój, łączenie), legary, podciągi, fundamenty punktowe, obciążenia. |
| `rdzen/parametry_stolarka.rb` | 52 | parametry stolarki – lista typowej stolarki (pole-tabela), folder modeli, prosty model okna i drzwi z generatora (rama, szyba, skrzydło drzwi, maskownice), gdy nie ma pliku modelu. |
| `rdzen/parametry_tabela.rb` | 104 | parametry w postaci tabeli (lista stolarki, magazyn drewna) – kolumny z opisu pola, sprawdzenie wierszy, tabela z tekstu JSON z okna, przeniesienie dawnych pól nowego okna i drzwi do listy stolarki. |
| `rdzen/parametry_taras.rb` | 184 | parametry sekcji „Taras” – wariant, głębokość, podciąg, słupy z zamkami (słup w osi kalenicy), szczyt nad tarasem z wiązarem (przekroje słupka i zastrzałów, zamek płatwi tylko od spodu), wejście, balustrada. |
| `rdzen/parametry_zadaszenie.rb` | 95 | parametry zakładki „Zadaszenie boczne / tylne” – wariant (słupy z oczepem albo przybudówka z bali), strona, szerokość, kąt mniejszy niż kąt dachu, okap, podłoga w przybudówce, dobór przekrojów (automatycznie albo z wyboru) płatwi, słupów i belek poprzecznych. |
| `rdzen/platwie_wience.rb` | 167 | płatwie oparte na pełnym balu – obniżenie dachu i przesunięcie płatwi pośrednich tak, żeby pod gniazdem płatwi nie zostawał pasek bala cieńszy niż najcieńszy dopuszczalny (bez przerw pod płatwią). |
| `rdzen/pod_dachem.rb` | 92 | bale wystające pod połać – węgły na ścianach okapowych i działowe w poprzek kalenicy ścięte linią dachu (spód krokwi / desek); ostrzeżenie o zbyt stromym dachu. |
| `rdzen/podbitka.rb` | 415 | podbitka – boazeria widoczna od spodu pod albo na płatwiach (deski wzdłuż spadku), pod albo na krokwiach (deski równolegle do okapu); wybór zależny od układu dachu; co robi aplikacja do dachów (nadbitka KROKU 2); obniżenie linii, pod którą kończą się ściany pod połacią. |
| `rdzen/podciagi.rb` | 176 | podciągi pod legarami – położenia w przęsłach (automatycznie, co najwyżej rozstaw, w liniach fundamentów albo bez podciągów), belki do lica zewnętrznego podwalin pod podwalinami, sprawdzenie podciągu między fundamentami. |
| `rdzen/podloga.rb` | 377 | podłoga domu prostokątnego – podwaliny pod ścianami (zakład albo styk na śruby w narożnikach), legary między podwalinami, dobór przekroju legara i podpowiedzi; podciągi i fundamenty punktowe w osobnych plikach. |
| `rdzen/podloga_przybudowki.rb` | 85 | podłoga w przybudówce z bali do wyboru – bez podłogi legary i podciągi tylko w domu (pole podłogi kończy się na podwalinie dawnej ściany okapowej), podwaliny i fundamenty także pod ścianami przybudówki; dawna ściana okapowa zawsze na podwalinie. |
| `rdzen/podpory_platwi_l.rb` | 108 | podparcie końców płatwi skrzydła bocznego domu L w dachu głównym – koniec przy płatwi dachu głównego (styk z łącznikiem ciesielskim) albo w koszu: słupek na niższej płatwi dachu głównego, nad którą płatew skrzydła przechodzi najbliżej swojego końca. |
| `rdzen/podzial_belek.rb` | 88 | belki dłuższe niż najdłuższa handlowa ich przekroju (magazyn drewna) dzielone w modelu nad podporą – płatwie dachu łączone na styk w osi ściany, przez którą przechodzą (szczyt, działowa, węgieł); kawałki z wrębami przeniesionymi, osobne pozycje w zestawieniu. |
| `rdzen/pol_zamka.rb` | 135 | pół zamka w ostatnim połączeniu pod dachem – ostatni bal (ścięty skosem albo płaszczyzną dachu) przechodzi przez zamek bez gniazda od spodu, a bal pod nim dostaje gniazdo do połowy wysokości; dzięki temu koniec ostatniego bala nie odpada. Narożnik, góra węgła, ściana nad węgłem i nad działową. |
| `rdzen/polacie.rb` | 191 | połacie dachu dla aplikacji do dachów – obrys, wysokość, kąt, okap i krawędzie szczytowe tak, żeby płaszczyzna połaci leżała na wierzchu płatwi generatora (spód krokwi albo spód poszycia na samych płatwiach). |
| `rdzen/powierzchnie.rb` | 216 | powierzchnie i wysokość domu – powierzchnia zabudowy (po licach zewnętrznych), pomieszczeń (po licach wewnętrznych ścian), tarasu i dachu, wysokość kalenicy nad terenem, limity użytkownika z ostrzeżeniem, rodzaj obrysu. |
| `rdzen/poziomy.rb` | 98 | trzy poziomy ustawień (Ten dom, Typ domu, Standard warsztatu) i kroki okna w kolejności budowy – które pole należy do którego poziomu i kroku, złożenie parametrów nowego domu ze standardu i typu, pola zmienione tylko w tym domu. |
| `rdzen/pozycje.rb` | 75 | numeracja pozycji jak u producenta – identyczne bale (ta sama bryła, także po obrocie o 180°) dostają jedną pozycję „nr-długość”. |
| `rdzen/profil_bala.rb` | 153 | pełny profil bala do wizualizacji – pióra na wierzchu i wpust od spodu (pierwszy wieniec bez wpustu); przekrój pasami wzdłuż grubości, objętość. |
| `rdzen/projekt.rb` | 264 | przebieg obliczeń domu od linii do listy bali i belek (kolejność kroków) i podsumowanie do okna – bez API SketchUpa. |
| `rdzen/pryzmat.rb` | 69 | belka o przekroju wielokątnym (graniastosłup) – siatka ścian, objętość, podpis i postać kanoniczna przekroju (np. płatew ścięta do płaszczyzny dachu). |
| `rdzen/przyklady.rb` | 75 | przykładowe domy do testu działania w SketchUpie (i w testach) – linie, parametry i otwory. |
| `rdzen/sciana_w_linii.rb` | 84 | działowa narysowana w linii ściany obrysu (np. wzdłuż uskoku domu L) – wspólna oś ze ścianą obrysu i połączenie obu w zamku ściany poprzecznej, bez ostatków wchodzących w siebie. |
| `rdzen/sciany.rb` | 293 | ściany z rozpoznanego obrysu – osie, zasięgi bali z ostatkami, skrzyżowania, kontrfory, kierunek względem kalenicy, numeracja W-n. |
| `rdzen/sciecie_dachu.rb` | 154 | bale ścian wzdłuż kalenicy wystające nad płaszczyznę dachu ścięte w poprzek do tej płaszczyzny – górny bal ściany okapowej przy ścianie nośnej, ściana wysoka dachu jednospadowego, działowa wzdłużna pod dachem. |
| `rdzen/siatka.rb` | 433 | siatka ścian (płaskich wielokątów z otworami) zamkniętej bryły bala z profilu – do budowy komponentu w SketchUpie. |
| `rdzen/skos_przy_narozniku.rb` | 136 | bale ścięte dachem przy narożnikach – przez narożnik (słup zamka) tylko w prawdziwym zamku; inaczej bal kończy się przy licu wewnętrznym ściany poprzecznej. |
| `rdzen/skrzydla.rb` | 239 | dach domu w kształcie L – podział obrysu na skrzydło główne i boczne, opisy obu dachów (dwa dachy dwuspadowe z koszem), szczyty i ściany okapowe skrzydeł, zasięg płatwi skrzydła bocznego. |
| `rdzen/statyka.rb` | 93 | sprawdzenie belki drewnianej swobodnie podpartej (zginanie, ścinanie, ugięcie końcowe), największa rozpiętość, dobór przekroju z katalogu. |
| `rdzen/statyka_dachu.rb` | 198 | sprawdzenie płatwi dachu (śnieg i ciężar pokrycia, przęsła między ścianami, pas dachu na płatew) i automatyczny dobór najmniejszego wystarczającego przekroju płatwi z listy. |
| `rdzen/statyka_krokwi.rb` | 166 | sprawdzenie i dobór przekroju krokwi całego dachu – połacie domu i bocznego zadaszenia (przęsła między płatwiami, okap jako wspornik, rozstaw krokwi); automatycznie najmniejszy wystarczający z listy albo przekrój z wyboru ze sprawdzeniem. |
| `rdzen/statyka_slupa.rb` | 51 | sprawdzenie słupa drewnianego ściskanego osiowo z wyboczeniem (przegubowo na obu końcach) – nośność, smukłość. |
| `rdzen/statyka_wiazara.rb` | 163 | sprawdzenie trójkąta (wiązara) nad tarasem pod obciążeniem od płatwi i automatyczny dobór jego najmniejszego wystarczającego przekroju, który mieści się pod dachem. |
| `rdzen/statyka_zadaszenia.rb` | 215 | sprawdzenie i dobór przekrojów bocznego zadaszenia – płatwie i oczep (przęsło między słupami albo ścianami, pas połaci zadaszenia), belki poprzeczne (od słupa do ściany domu) i słupy (ściskanie z wyboczeniem); automatycznie najmniejszy wystarczający z list albo przekroje z wyboru użytkownika ze sprawdzeniem. |
| `rdzen/stolarka.rb` | 51 | stolarka okien i drzwi – otwór w balach ze stolarki i luzów (boczny z obu stron, górny na osiadanie), podpowiedź luzu górnego z wysokości stolarki. |
| `rdzen/stolarka_modele.rb` | 100 | modele okien i drzwi wstawiane w otwory – wiersz listy typowej stolarki dla otworu, plik modelu (pełna ścieżka z kolumny „Model” albo nazwa w folderze modeli), prosty model z generatora, gdy pliku nie ma, położenie modelu w otworze (punkt, osie) w układzie domu. |
| `rdzen/stolarka_prosta.rb` | 102 | prosty model okna i drzwi z generatora (rama na grubość ściany, szyba albo pełne skrzydło drzwi, maskownice od zewnątrz) wstawiany w otwór, gdy nie ma pliku modelu użytkownika – części jako prostopadłościany i ich siatki. |
| `rdzen/styki.rb` | 356 | podział długich ścian na bale – miejsca styków na mijankę (min. 300 mm) w trzech układach, węgły pod styki. |
| `rdzen/styki_dzialowe.rb` | 100 | styki w zamku działowej – wszystkie wieńce ściany łączone w osi skrzyżowania z działową (zamek trzyma oba końce), bez drugiego rzędu na mijankę i bez węgłów; reszta ściany – zwykłym układem. |
| `rdzen/styki_szczytu.rb` | 141 | łączenie wieńców szczytu ściany domu na styk – bez węgła i bez zamka, na przemian z przesunięciem o mijankę (nie mniej niż 300); miejsca styków w każdym wieńcu szczytu osobno. |
| `rdzen/styki_tarasu.rb` | 102 | łączenie bali frontu tarasu z podciągiem (podciąg, bale spinające, szczyt nad tarasem, balustrada z wieńców) na styk – bez węgła i zamków, na przemian z mijanką; najniższy bal podciągu łączony nad słupem. |
| `rdzen/symetria_wegly.rb` | 119 | węgły symetrycznie na ścianach równoległych – ściana bliźniacza (ta sama oś w świecie, ten sam zasięg) dostaje styki i węgły w tych samych miejscach co ściana policzona wcześniej; równy podział odcinków między ścianami przy rozmieszczeniu „równo”. |
| `rdzen/szczyty.rb` | 404 | szczyty z bali – które ściany mają szczyt, wieńce szczytu do kalenicy, skos bali wg linii dachu, gniazda pod płatwie. |
| `rdzen/taras.rb` | 325 | taras przed ścianą szczytową domu prostokątnego – obrys przedłużony o głębokość tarasu, ściana domu jako działowa ze szczytem, wariant 1100 (górne wieńce ścian nad tarasem jako podciąg na słupach) albo 1200 (ściany boczne pełne, front otwarty), słupy tarasu. |
| `rdzen/taras_balustrada.rb` | 97 | balustrada tarasu z bali (jak 1100) – w przęsłach między słupami i ścianą domu bale na przemian z rzędami przekładek (odcinków bala), w siatce wieńców ściany. |
| `rdzen/taras_sciany.rb` | 120 | balustrada tarasu z wieńców ścian – dolne wieńce ścian bocznych biegną ciągle przez całą długość tarasu, front w tych wieńcach z balami między ścianami bocznymi (przerwa na wejście), w narożnikach frontu zamki z zakładką (co druga belka wysunięta) albo równo z licem; poręcz na jednej wysokości. |
| `rdzen/taras_slupy.rb` | 138 | słupy tarasu z podciągiem – licem równo z licami ścian zewnętrznych, zamek górny (część słupa za balem idzie w górę obok bala) i zamek dolny (część słupa obok podwaliny schodzi w dół). |
| `rdzen/taras_szczyt.rb` | 113 | szczyt nad tarasem z podciągiem – pełny (jak 1100), ażurowy (bale na przemian z rzędami przekładek, jak balustrada) albo pusty (kilka bali spinających nad podciągiem i wiązar z rdzen/taras_wiazar.rb albo słupki z przekładek pod płatwiami; wiązar na słupach – front bez bali). |
| `rdzen/taras_wiazar.rb` | 367 | wiązar (trójkąt) nad pustym szczytem frontu tarasu – dwie ciągłe krokwie wiązara pod płatwiami (płatwie leżą na nich w płytkich gniazdach – zamkach), belka dolna, słupek pod kalenicą i opcjonalnie dwa zastrzały od stopy słupka pod zadanym kątem (45°); licem z licem zewnętrznym frontu; na balach frontu albo na słupach bez bali; wręby płatwi na grubości wiązara. |
| `rdzen/ustawienia_scian.rb` | 124 | ustawienia pojedynczych ścian z widoku ściany – ostatek na każdym końcu, węgły ustawione ręcznie (dodane / usunięte kliknięciem), co jest nad działową (strop, antresola, półka) i jej góra. |
| `rdzen/usztywnienie.rb` | 175 | węgły 244 usztywniające ściany – limit światła ściany (zwykłej i wysokiej), rozmieszczenie nowych węgłów, miejsce, w którym węgieł może stanąć. |
| `rdzen/uwagi_pola.rb` | 84 | jedna lista uwag do okna – błędy, ostrzeżenia i podpowiedzi z planu z poziomem, krokiem okna i polem albo sekcją, do której uwaga prowadzi (kliknięcie uwagi przenosi do pola). |
| `rdzen/wegly_konstrukcyjne.rb` | 151 | węgły dostawiane automatycznie tam, gdzie wymaga ich konstrukcja – pod płatwiami przechodzącymi przez szczyt (słupek węgła do spodu płatwi, płatew na nim leży) i na wolnym końcu niepełnej ściany (bez węgła koniec jest wiotki). |
| `rdzen/wegly_tabela.rb` | 117 | węgły (kontrfory) wstawiane jak okna i drzwi – z tabeli w oknie (ściana, od narożnika albo na środku) i automatycznie na środku ścian (parametr). |
| `rdzen/widok.rb` | 161 | widok ściany do okna – bale jako obrysy w płaszczyźnie ściany (s, z), otwory, styki, skrzyżowania, linia dachu. |
| `rdzen/wience.rb` | 137 | poziomy wieńców każdej ściany – półbal na dole ścian wzdłuż kalenicy, liczba wieńców, wysokości ścian. |
| `rdzen/wycena.rb` | 139 | wycena materiału domu (W3) – bale (cena za m³), belki według przekroju z magazynu drewna (cena za m³), deski poszycia i podbitki z wiersza „deska” magazynu, pozostałe materiały z cennika; suma i lista pozycji bez ceny. |
| `rdzen/wykaz_drewna.rb` | 104 | wykaz drewna dostępnego w hurtowni (przekroje z długościami handlowymi) – listy fabryczne dla legarów, płatwi, krokwi, belek i słupów zadaszenia oraz odczyt listy przekrojów z długościami z tekstu parametru. |
| `rdzen/wypusty_okapu.rb` | 128 | wypusty pod dachem – górne wieńce ścian okapowych wypuszczone za szczyty o wysunięcie płatwi (oparcie dachu nad szczytem) i opcjonalnie górne bale węgłów na ścianach okapowych wysunięte na zewnątrz do nawisu okapu, ścięte linią dachu. |
| `rdzen/zadaszenie.rb` | 394 | boczne zadaszenie przy ścianie okapowej domu prostokątnego – połać dachu za linią załamania schodzi dalej pod mniejszym kątem; wariant na słupach (słupy z fundamentami, belki poprzeczne, oczep, płatwie na słupkach) albo przybudówka z bali (obrys poszerzony, dawna ściana okapowa jako działowa, niska ściana zewnętrzna); płatwie zadaszenia. |
| `rdzen/zamek.rb` | 176 | obróbki zamka na każdym skrzyżowaniu – gniazda górne/dolne i podcięcia boczne bali (zamek 44 × 146 z rysunku IMG-20250930-WA0005). |
| `rdzen/zamek_platwi.rb` | 194 | zamki w płatwiach – wręby płatwi w ścianach, przez które przechodzi (z boków i od spodu), żeby płatwie trzymały szczyty na miejscu; bryła belki z wrębami, objętość, podpis. |
| `rdzen/zestawienie.rb` | 92 | zestawienie bali i belek do pliku CSV (Excel) – pozycje z długością, ilością i objętością, sumy grup i całości, pod nimi blok materiałów. |
| `sketchup/atrybuty.rb` | 114 | atrybuty w modelu – zgodność z Dokumentacją 2D (słownik ArteMadera) i zapis wejścia generatora do przebudowy. |
| `sketchup/budowa.rb` | 199 | budowa domu w modelu – grupa domu > grupy ścian W-n > instancje komponentów bali, tagi, usuwanie poprzedniej wersji. |
| `sketchup/dach_aplikacja.rb` | 225 | dach z aplikacji do dachów (ArteMadera Roof) po budowie domu – przez jej stałe API: połacie z planu (KROK 1), płatwie domu jako podpory, okno KROKU 2 z ustawieniami domu z bali, więźba powiązana z domem, zastąpienie poprzednich połaci i więźby. |
| `sketchup/dziennik_pracy.rb` | 123 | folder raportów na komputerze użytkownika – raport z testu działania zapisywany sam (bez okna zapisu) i dziennik pracy: jeden wiersz po każdym wygenerowaniu domu (czasy, liczby, zmienione ustawienia) oraz po awarii obliczeń. |
| `sketchup/eksport.rb` | 60 | zapis plików z wtyczki – wybór miejsca (okno zapisu SketchUpa), zestawienie CSV z ostatniego podglądu, plik tekstowy UTF-8. |
| `sketchup/konwersja.rb` | 71 | przeliczenia między rdzeniem (mm, tablice) a SketchUpem (cale, Geom::Point3d, Geom::Transformation). |
| `sketchup/menu.rb` | 46 | menu Rozszerzenia → ArteMadera Generator Wieńcowy (generuj / edytuj, kontrola, standard warsztatu, test działania, o wtyczce). |
| `sketchup/okno.rb` | 202 | okno parametrów (UI::HtmlDialog) – dane startowe dla okna, wywołania z JavaScriptu, wyniki do okna. |
| `sketchup/okno_sciezki.rb` | 59 | wybór ścieżki z okna generatora – folder modeli stolarki (UI.select_directory) i plik modelu okna albo drzwi (UI.openpanel), odpowiedź do pola w oknie. |
| `sketchup/okno_typy.rb` | 71 | wywołania okna dla typów domów i standardu warsztatu – wybór typu, „Zapisz jako typ”, „Zapisz zmiany w typie”, powielenie, usunięcie, zapis i przywrócenie standardu, układ okna; odpowiedź do okna: lista typów i baza porównania. |
| `sketchup/pasek.rb` | 119 | szybki dostęp do poleceń wtyczki – pasek narzędzi z czterema przyciskami i polecenia pod prawym przyciskiem myszy na zaznaczonym domu albo liniach. |
| `sketchup/raport.rb` | 209 | test działania w prawdziwym SketchUpie i raport do wysłania – przykładowe domy budowane w operacji cofanej na końcu (model bez zmian), bryły zamknięte i objętości, zaznaczony dom, środowisko, dziennik. |
| `sketchup/sterowanie.rb` | 245 | przebieg pracy z menu – start (linie albo dom do edycji), podgląd, generowanie, kontrola; dane wyniku dla okna. |
| `sketchup/stolarka_modele.rb` | 110 | wstawienie modeli okien i drzwi w otwory domu przy generowaniu – plik .skp użytkownika albo prosty model z generatora (definicja z części), grupa „Stolarka” w domu, tag Stolarka, brakujące pliki zgłaszane. |
| `sketchup/typy_domow.rb` | 133 | typy domów – wbudowane (Typ 100–400) i własne zapisywane przez użytkownika: lista z opisami, zapis („Zapisz jako typ”, „Zapisz zmiany w typie”), powielenie, usunięcie, ostatnio wybrany typ, parametry nowego domu i baza porównania dla okna. |
| `sketchup/ustawienia.rb` | 200 | plik ustawień na komputerze – standard warsztatu (pola poziomu „Standard warsztatu” i wymiary zamka), ustawienia okna (układ, tryb pól), odczyt i zapis pliku, przeniesienie plików starszych kompilacji (ostatnie parametry → standard, szablony → typy domów). |
| `sketchup/wejscie.rb` | 69 | odczyt zaznaczenia – narysowane linie (obrys, osie działowych, kontrfory) albo istniejący dom z generatora. |
| `html/dzialowe.js` | 92 | ściany działowe w domu z wymiarów (bez rysowania) – tabela w oknie: kierunek, odległość osi od lica, początek i długość; dane do Ruby. |
| `html/edycja.js` | 179 | ustawienia pojedynczej ściany pod jej widokiem – ostatek na każdym końcu, węgły dodawane i usuwane kliknięciem w widok, co jest nad działową (strop, antresola, półka) i jej góra. |
| `html/kanaly.js` | 117 | kanały na przewody (N3) w oknie – lista kanałów domu (ściana, od, średnica, puszka), okienko kanału przy kliknięciu w widok ściany (nowy, poprawa, usunięcie), lista pod tabelą okien i drzwi. |
| `html/klik_sciana.js` | 229 | okna, drzwi, węgły i kanały kliknięciem w widok ściany – przełącznik „klik wstawia: węgieł / okno / drzwi / kanał”, okienko z parametrami przy miejscu kliknięcia (typ stolarki z listy, wymiary, spód, luz górny, nazwa, od), poprawa i usunięcie istniejącego otworu albo węgła. |
| `html/kroki.css` | 112 | wygląd nowego układu okna – kroki w kolejności budowy, prawa kolumna z rzutem i uwagami zawsze na widoku, pasek typu domu, pola zmienione tylko w tym domu, panel standardu warsztatu, lista „Do poprawy / Sprawdzone”. |
| `html/kroki.js` | 214 | nowy układ okna – kroki w kolejności budowy ze znacznikiem stanu, widoczność pól według poziomu (ten dom zawsze, pola typu po rozwinięciu, pola standardu tylko zmienione w tym domu albo wybrane do zmiany), karty kroku, przejście do pola z listy uwag. |
| `html/okno.css` | 198 | wygląd okna parametrów. |
| `html/okno.html` | 234 | okno parametrów generatora – układ okna (sekcje formularza budowane przez okno.js z listy parametrów z Ruby): pasek typu domu, kroki albo zakładki, karty rzutu, wyniku, widoku ściany, otworów, węgłów i zestawienia, panel standardu warsztatu. |
| `html/okno.js` | 401 | logika okna parametrów – sekcje i pola z listy parametrów, podpowiedzi, wymiary zamka, wynik podglądu, wywołania Ruby; typy, standard, kroki i układ w osobnych plikach. |
| `html/otwory.js` | 290 | tabela okien i drzwi w oknie – typ z listy typowej stolarki, stolarka (ściana, od, szerokość i wysokość stolarki, parapet, luz górny, nazwa), otwór w balach i podpowiedź luzu górnego; wiersz do poprawy z okienka przy widoku ściany. |
| `html/pomoc.js` | 107 | objaśnienia pól w oknie – znak zapytania w kółku przy etykiecie, po kliknięciu ramka z dłuższym opisem i rysunkiem pokazującym różnicę (obciążenie, ugięcie, podbitka, położenie płatwi ściennej, układ dachu); krótka podpowiedź pola po wejściu w pole. |
| `html/przeliczenia.js` | 78 | przeliczenia przy parametrach – podpowiedzi z obliczeń (legar, podciąg, fundamenty, dach) pokazane w sekcji parametrów, której dotyczą, i krótka informacja, co zmieniło się w domu po ostatniej zmianie pola. |
| `html/rzut.js` | 134 | rzut domu w oknie (SVG) – obrys, ściany i węgły, otwory, punkty odniesienia otworów, opisy W-n. |
| `html/sciana.js` | 258 | widok ściany w oknie (SVG) – bale z numerami pozycji, wieńce, otwory, kanały na przewody, styki, skrzyżowania z innymi ścianami i węgłami, linia dachu; wybór ściany. |
| `html/sciezka.js` | 47 | pola ze ścieżką pliku albo folderu (folder modeli stolarki, kolumna „Model” listy stolarki) – przycisk „…” obok pola otwiera okno wyboru w SketchUpie, wybrana ścieżka wraca do pola. |
| `html/standard.js` | 194 | panel „Standard warsztatu” – pola poziomu standard pogrupowane sekcjami z wymiarami zamka, wyszukiwanie pola, zapis standardu i powrót do wartości fabrycznych. |
| `html/tabela.js` | 168 | pola-tabele w oknie (lista typowej stolarki, magazyn drewna) – edytor tabeli z dodawaniem i usuwaniem wierszy, wartość jako tekst JSON w ukrytym polu, porównanie tabel bez względu na zapis liczb. |
| `html/tryb.js` | 69 | tryb pól okna – „Podstawowe” (tylko najczęściej zmieniane parametry i te zmienione względem fabrycznych) albo „Wszystkie”. |
| `html/typy.js` | 250 | typ domu w oknie – lista typów z opisem, „Zapisz zmiany w typie”, „Zapisz jako typ”, powielenie, usunięcie, „Przywróć typ”; baza porównania (standard warsztatu i typ) i pola zmienione tylko w tym domu z przyciskiem powrotu. |
| `html/uklad.js` | 87 | przełącznik układu okna – nowy (kroki w kolejności budowy, rzut i uwagi zawsze na widoku) albo dotychczasowy (zakładki i sekcje, tryb Podstawowe / Wszystkie); rozmieszczenie kart i odświeżenie widoczności pól we właściwym układzie. |
| `html/uwagi.js` | 62 | lista „Do poprawy / Sprawdzone” w prawej kolumnie okna – błędy, ostrzeżenia i podpowiedzi w jednym miejscu, z nazwą kroku; kliknięcie uwagi przenosi do pola, sekcji albo kroku. |
| `html/wegly.js` | 134 | tabela węgłów (kontrforów) w oknie – jak okna i drzwi: ściana, położenie (od narożnika albo na środku ściany), od [mm], wypust wewnątrz i na zewnątrz [mm]. |
| `html/wegly_przesun.js` | 97 | przesuwanie węgłów w karcie okien i drzwi – lista wszystkich węgłów domu (automatyczne, pod płatwiami, na wolnych końcach, z rysunku, ręczne, z tabeli) z położeniem „od” jak przy otworach; zmiana położenia przesuwa węgieł. |
| `html/wspolne.js` | 84 | wspólne funkcje okna – element po identyfikatorze, nowy element, czyszczenie, liczby do wyświetlenia, przebudowa po kliknięciu. |
| `html/wycena.js` | 74 | wycena materiału w oknie (W3) – tabela pozycji z ilością, ceną i wartością, suma, lista pozycji bez ceny z odesłaniem do standardu warsztatu. |
| `html/wyniki.js` | 143 | wyniki w oknie – liczby, wysokości, błędy, ostrzeżenia, podpowiedzi, tabela ścian ze stykami, lista bali i belek, tabela materiałów, rzut. |
| `html/zakladki.js` | 79 | zakładki formularza parametrów – „Dom” i „Zadaszenie boczne / tylne” (sekcje parametrów w osobnych pojemnikach), przełączanie zakładek i liczba zmienionych pól w nazwie zakładki. |
| `html/zalezne.js` | 130 | pola zależne w oknie – pole pokazuje się tylko przy wybranych wartościach pól nadrzędnych (np. kierunek spadku tylko przy dachu jednospadowym), wybory listy – tylko te, które pasują do innych pól (np. położenie desek a układ dachu), a opcje niedostępne dla obrysu domu są wyszarzone z powodem. |
| `html/zmiany.js` | 73 | pola zmienione względem ustawień fabrycznych – wyróżnienie etykiety, wartość fabryczna w dymku, liczba zmian w nagłówku sekcji. |
| `testy/atrapa/aplikacja_dachow.rb` | 84 | atrapa aplikacji do dachów (ArteMadera::Roof) – jej stałe API wersji 1 (polacie, podpory, wiezba) – zapisuje wywołania generatora. |
| `testy/atrapa/extensions.rb` | 3 | – |
| `testy/atrapa/sketchup.rb` | 905 | atrapa API SketchUpa (Geom, Sketchup::Model/Entities/Group/ComponentDefinition/Face/Edge, UI) do testów bez SketchUpa. |
| `testy/buduj_rbz.rb` | 28 | paczka instalacyjna .rbz (zip rejestratora i folderu wtyczki) – do instalacji w Menedżerze rozszerzeń SketchUpa. |
| `testy/kolizje_belek.rb` | 211 | wspólne sprawdzenia przestrzenne testów – kolizje belek dachu z balami (punkty próbne), bale ponad linią szczytu, bale i płatwie względem połaci dla aplikacji do dachów. |
| `testy/lista_parametrow.rb` | 74 | generator docs/parametry.md – wszystkie parametry okna (sekcja, etykieta, poziom, wartość domyślna, zakres, wybory, podpowiedź) i typy wbudowane. |
| `testy/losowe_domy.rb` | 497 | losowe domy do testów – obrys (prostokąt, L), działowe, węgły, otwory i parametry z ziarna; sprawdzenie jednego domu. |
| `testy/okno_dane.rb` | 36 | dane okna z prawdziwego przebiegu (atrapa SketchUpa) – wypisuje JSON { init:, wynik:, widok:, widok_szczytu:, widok_dzialowej: } dla testu okna w przeglądarce. |
| `testy/podglad.py` | 83 | rysunek 3D domu z pliku OBJ (testy/podglad.rb) – cały dom i zbliżenie narożnika, do sprawdzenia wzrokowego. |
| `testy/podglad.rb` | 116 | zapis domu testowego do pliku OBJ (siatki pozycji ułożone jak w modelu) – do obejrzenia bez SketchUpa (testy/podglad.py). |
| `testy/pomoc.rb` | 94 | wspólne narzędzia testów – sprawdzenia, licznik błędów, przykładowe obrysy (domy testowe). |
| `testy/ruby27.sh` | 36 | testy rdzenia i warstwy SketchUpa na Ruby 2.7.8 – tej samej linii co Ruby w SketchUpie 2023 (2.7.7); gdy brak, buduje Ruby ze źródeł z GitHuba. |
| `testy/spis_tresci.rb` | 151 | generator spisu treści kodu docs/SPIS_TRESCI.md – tematy → pliki, lista plików, metody i stałe z numerami wierszy. |
| `testy/sprawdz_dach_aplikacja.rb` | 316 | dom z bali z prawdziwą aplikacją do dachów (na jej atrapie SketchUpa) przez jej API – połacie na płaszczyźnie wierzchu płatwi, płatwie domu jako podpory, KROK 2 w górę od połaci: krokwie na płatwiach i nad szczytami, przęsła między płatwiami w kontroli nośności; same płatwie – deski na płatwiach wzdłuż spadku, styki na płatwiach; dom odbity. |
| `testy/sprawdz_zasady.rb` | 168 | kontrola zasad kodu – Ruby 2.2, ES5, rdzeń bez API SketchUpa, nagłówki plików, komentarze nad metodami, długość plików, kompilacja, MODULE_FILES. |
| `testy/t_dach_aplikacja.rb` | 244 | dach z aplikacji do dachów w modelu (atrapa SketchUpa i API aplikacji) – połacie po budowie domu, podpory z płatwi, ustawienia KROKU 2, okno KROKU 2 z licznika, więźba po OK powiązana z domem, przebudowa (poprzednie połacie i więźba), same płatwie, brak i stara aplikacja, odmowa aplikacji, inny kontekst, dom obrócony. |
| `testy/t_dlugosci.rb` | 125 | testy wykazu drewna z hurtowni i długości handlowych – odczyt list „przekrój:długości”, listy fabryczne, podpowiedź o belce dłuższej niż w hurtowni, dobór przekroju dostępnego w całej długości. |
| `testy/t_jednospadowy.rb` | 166 | dach jednospadowy – ściana niska i wysoka, szczyty skośne do linii dachu, ściana wysoka do połaci (górny bal przycięty, cienki pasek pominięty), płatwie bez kalenicowej, krokwie w jednym kawałku, połać dla aplikacji (trzy krawędzie szczytowe), widok ściany, obrys L. |
| `testy/t_kanaly.rb` | 82 | kanały na przewody (N3, runda 18) – przypisanie do ścian, pominięcie przy zamku, otwór pionowy w każdym balu ściany (bryła zamknięta z otworem, objętość), puszka na liście obróbek, kanał w widoku ściany, w pełnym profilu i w szczycie, zapis w domu (SketchUp na atrapie). |
| `testy/t_losowe.rb` | 69 | stały zestaw losowych domów (ziarna, które kiedyś ujawniły błąd, i kilka zwykłych) – każdy bez problemów. |
| `testy/t_materialy.rb` | 123 | testy zestawienia materiałów (propozycja W2, runda 15) – powierzchnia dachu, deski nadbitki / deskowania / OSB w m² i sztukach, podbitka, taśma między wieńcami, okucia (śruby i podstawy słupów, kotwy podwalin, łączniki krokwi), impregnacja, blok w pliku CSV. |
| `testy/t_okno.js` | 550 | okno parametrów w Chromium (Playwright), układ dotychczasowy (zakładki) – sekcje i pola z listy, podpowiedzi, typy domów, rzut, tabela otworów, wywołania sketchup.*, wyniki. |
| `testy/t_okno_kroki.js` | 410 | okno w Chromium (Playwright), układ nowy – kroki w kolejności budowy, prawa kolumna z rzutem i listą „Do poprawy / Sprawdzone”, pola według poziomów (ten dom, typ, standard), zmiana tylko w tym domu, panel standardu warsztatu, podpowiedź po wejściu w pole, opcje wyszarzone dla obrysu, przełącznik układu, dom z wymiarów. |
| `testy/t_osiadanie.rb` | 76 | testy słupów krótszych o osiadanie ścian (propozycja P1, runda 15) – luz osiadania, śruba regulacyjna albo podkładki, zamek górny po osiadaniu, wyłączenie, podpowiedź, brak kolizji. |
| `testy/t_podbitka.rb` | 145 | podbitka w czterech położeniach – pod / na płatwiach, pod / na krokwiach: deski przy właściwej płaszczyźnie, bez kolizji z balami, krokwie uniesione nad deskami na płatwiach, podbitka jako nadbitka KROKU 2 aplikacji do dachów, wybór niepasujący do układu dachu. |
| `testy/t_podloga.rb` | 206 | testy podłogi i statyki – wzory belki, dobór przekroju (minimalny / zalecany / ręczny), izolacja, podpory, układ podwalin i legarów. |
| `testy/t_pol_zamka.rb` | 145 | testy pół zamka w ostatnim połączeniu pod dachem (rundy 15–16: narożnik, góra węgła, ściana nad węgłem i nad działową, węgieł ze stykami do połaci) – bal szczytu przechodzi przez narożnik bez gniazda od spodu, bal pod nim ma gniazdo do połowy wysokości; wyłączone – bal ucięty przy ścianie poprzecznej; inna głębokość gniazda; brak kolizji. |
| `testy/t_polacie.rb` | 209 | połacie dla aplikacji do dachów – obrys, wysokość, krawędzie szczytowe, okap i wysunięcie za szczyt; płatwie pod połacią, szczyt pod krokwiami, bez krokwi generatora; same płatwie (poszycie na płatwiach); ustawienia KROKU 2 i podpory z płatwi; kiedy połaci nie ma. |
| `testy/t_poziomy.rb` | 94 | testy trzech poziomów ustawień i kroków okna (runda 16) – poziom przy każdym polu, podział jak w docs/podzial_pol_r16.md, kroki w kolejności budowy, złożenie parametrów ze standardu i typu, pola zmienione tylko w tym domu, lista uwag z miejscem w oknie, powierzchnie i limity, dom z wymiarów. |
| `testy/t_raport.rb` | 108 | test działania z menu (atrapa SketchUpa) – przykładowe domy bez błędów, budowa cofnięta (model bez zmian), bryły zamknięte i objętości, zaznaczony dom, raport JSON. |
| `testy/t_rdzen.rb` | 241 | testy rdzenia – obrys, ściany, wieńce, styki z mijanką, kontrfory, otwory, pozycje, kolizje w zamkach. |
| `testy/t_sciany_ust.rb` | 159 | testy ustawień pojedynczych ścian z widoku ściany – ostatek na końcu, węgły ręczne, niższa działowa pod stropem / antresolą / półką z dopełnieniem zamka. |
| `testy/t_siatka.rb` | 133 | siatka brył wszystkich pozycji z kilku domów – zamknięta (każda krawędź raz w każdą stronę), objętość równa profilowi. |
| `testy/t_sketchup.rb` | 469 | warstwa SketchUpa na atrapie API – ładowanie wtyczki, okno, generowanie, atrybuty, położenie bali, przebudowa, ręczne zmiany. |
| `testy/t_skrzydla.rb` | 188 | dom w kształcie L – dwa dachy dwuspadowe z koszem (runda 10): podział na skrzydła, oś kalenicy, szczyty (także na części ściany), ściany okapowe skrzydła bocznego, płatwie obu dachów, połacie dla aplikacji do dachów, węgły ścięte do dachu, wypust górnych wieńców tylko na zewnątrz. |
| `testy/t_statyka_dachu.rb` | 128 | testy sprawdzenia płatwi i trójkąta nad tarasem (śnieg, pas dachu, przęsła), automatycznego doboru ich przekroju i trójkąta w wąskim domu. |
| `testy/t_statyka_zadaszenia.rb` | 168 | runda 13 – dobór przekrojów bocznego zadaszenia (płatwie z oczepem, belki poprzeczne, słupy – automatycznie albo z wyboru), słup z wyboczeniem, dobór krokwi całego dachu, podłoga w przybudówce do wyboru, parametry zadaszenia w osobnej zakładce okna. |
| `testy/t_stolarka.rb` | 208 | lista typowej stolarki (pole-tabela standardu), dawne pola nowego okna i drzwi, modele okien i drzwi wstawiane w otwory (rdzeń i atrapa SketchUpa), działowe w domu z wymiarów (runda 17). |
| `testy/t_styki_szczytu.rb` | 140 | testy łączenia wieńców szczytu na styk (decyzja T8, runda 15) – styki bez węgła na przemian o mijankę, węgły pod styki do wysokości ściany, szeroki szczyt, okno w szczycie, wybór „w zamkach węgłów”, szczyt płaski bez zmian, ziarna regresji. |
| `testy/t_szczyty.rb` | 276 | testy szczytów i dachu – wieńce do kalenicy, skos bali pod linią dachu, gniazda płatwi, krokwie przy szczycie, belki dachu bez kolizji. |
| `testy/t_taras.rb` | 350 | taras – obrys przedłużony o głębokość, ściana domu ze szczytem, wariant 1100 (podciąg z górnych wieńców, słupy, wejście, balustrada z przekładkami) i 1200 (ściany boczne pełne, front bez bali), dach nad tarasem, strona tarasu, kiedy tarasu nie ma. |
| `testy/t_typy.rb` | 125 | testy typów domów i standardu warsztatu w pliku ustawień (runda 16) – typy wbudowane i własne (zapis, zmiana, powielenie, usunięcie, wybrany typ), standard (tylko pola standardu inne niż fabryczne), nowy dom z typu i standardu, pliki ustawień starszych kompilacji (ostatnie parametry → standard i typ, szablony → typy, kopia starego pliku). |
| `testy/t_wegly.rb` | 267 | testy węgłów usztywniających i łączenia na przemian – limity światła, rozmieszczenie, ściany wysokie, otwory. |
| `testy/t_widok.rb` | 76 | widok ściany do okna – obrysy bali zgodne z profilem, gniazda zamków na skrzyżowaniach, styki, linia dachu, lista ścian. |
| `testy/t_wycena.rb` | 84 | magazyn drewna (tabela fabryczna, znaczniki zastosowań, deska 14 × 115), jeden przełącznik doboru przekrojów z wyjątkami, dobór w całej długości krokwi i legarów, wycena materiału (W3) i jej blok w CSV (runda 17). |
| `testy/t_zadaszenie.rb` | 200 | boczne zadaszenie (runda 12) – linia dachu z załamaniem, płatwie zadaszenia, słupy z belkami poprzecznymi i słupkami, przybudówka z bali (obrys, role ścian, niska ściana, szczyty z załamaniem), krokwie zadaszenia z generatora, połacie z załamaniem dla aplikacji do dachów, przeszkody (kąt, taras, jednospadowy), przekazanie załamania w modelu (atrapa). |
| `testy/t_zamek.rb` | 95 | zamek 44 × 146 zgodny z rysunkiem IMG-20250930-WA0005 – wymiary obróbek, luzy, labirynt (tylko poprawne ułożenie bez kolizji). |
| `testy/t_zestawienie.rb` | 51 | zestawienie CSV (rdzeń) i zapis pliku z okna (atrapa SketchUpa) – kolumny, przecinek dziesiętny, sumy, BOM, anulowanie. |
| `testy/t_zlozone.rb` | 129 | testy domów o obrysach złożonych – działowa w linii ściany obrysu (dom L, T, U), linia przez wcięcie obrysu, ściany równoległe w tym samym miejscu, komunikat zamiast wyjątku, ziarna domów złożonych. |
| `testy/uruchom.sh` | 93 | wszystkie testy i kontrole jednym poleceniem – ostatnia linia „WSZYSTKIE ZESTAWY: FAILURES n”. |
| `testy/zlozone_domy.rb` | 105 | losowe domy o obrysach złożonych (L, T, U, Z, krzyż, H) z działowymi w liniach uskoków – obrys i działowe z ziarna, sprawdzenie jak w losowych domach. |
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

### main.rb (69 wierszy)

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

### rdzen/awaria.rb (51 wierszy)

nieprzewidziany wyjątek w obliczeniach domu zamieniony na plan z komunikatem po polsku – co się stało, co sprawdzić, co wysłać; pełny ślad w dzienniku.

Zależy od: rdzen/parametry.rb, log.rb
Używają: rdzen/projekt.rb (oblicz), sketchup/sterowanie.rb (okienko z komunikatem)

| Wiersz | Element | Opis |
|---:|---|---|
| 18 | `module Awaria` |  |
| 22 | `plan(wejscie, e)` | Plan zastępczy po wyjątku e: bez ścian i bali, jeden błąd z komunikatem, plan[:wyjatek] – opis techniczny. |
| 30 | `parametry(wejscie)` | Parametry z wejścia po sprawdzeniu (gdy i to się nie uda – fabryczne). |
| 37 | `komunikat(e)` | Komunikat dla użytkownika: co się stało, co sprawdzić, co zgłosić. |
| 44 | `opis(e)` | Krótki opis techniczny: rodzaj wyjątku, treść (do 120 znaków), plik i wiersz, numer kompilacji. |

### rdzen/bale.rb (260 wierszy)

bale każdej ściany w każdym wieńcu – kawałki między otworami i stykami, wycięcia przy otworach, skos szczytu, położenie w układzie domu.

Zależy od: rdzen/geometria.rb, rdzen/parametry.rb, rdzen/wience.rb, rdzen/otwory.rb, rdzen/styki.rb, rdzen/szczyty.rb (zasięg i skos), rdzen/pod_dachem.rb, rdzen/dopelnienie.rb (przedziały nadstawki), rdzen/taras_szczyt.rb (szczyt nad tarasem – przekładki), rdzen/wypusty_okapu.rb (wieńce i węgły wypuszczone pod dachem), rdzen/styki_szczytu.rb (styki wieńców szczytu na styk), rdzen/pol_zamka.rb (ostatni bal węgła pod dachem)
Używają: rdzen/projekt.rb, rdzen/zamek.rb (obróbki), rdzen/pozycje.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 30 | `module Bale` |  |
| 34 | `OKRUCH` | Kawałek bala krótszy niż tyle [mm] przy skosie albo gnieździe to okruch – pomijany zawsze. |
| 39 | `zbuduj(sciany, p)` | Wszystkie bale domu (bez obróbek zamka): { bale: [...], ostrzezenia: [...] }. |
| 64 | `kawalki_wienca(w, wn, i, p, uwagi)` | Kawałki bala w wieńcu: zasięg ściany (pod linią szczytu / dachu; wieniec nadstawki – tylko odcinki dopełnienia) minus otwory przelotowe, podzielony stykami – styki tylko w kawałkach dłuższych niż maksymalny bal (wieniec szczytu łączony na styk – miejsca z rdzen/styki_szczytu.rb); pomija okruchy przy skosie i gniazdach płatwi. |
| 100 | `zasieg(w, z0, p)` | Zasięg wieńca o spodzie z0: pod linią szczytu (ściana ze szczytem), pod linią dachu (ściana pod połacią), cały; ściana tarasu – ograniczony przez Taras.zasieg. |
| 112 | `skosy(w, s0, s1, z0, h, p)` | Skosy kawałka bala wg linii szczytu albo linii dachu nad ścianą. |
| 119 | `koniec_typ(w, s, ciecia, zas, wewn = [])` | Rodzaj końca bala w miejscu s: ostatek (koniec zasięgu z ostatkiem), otwór, gniazdo płatwi, skos szczytu, wolny koniec (także wewnętrzny koniec odcinka nadstawki – lista wewn). |
| 133 | `nowy_bal(w, wn, i, s0, s1, konce, wyciecia)` | Nowy bal z wycięciami od otworów (cechy w układzie bala). |
| 151 | `kontrfor_obecny?(kf, wn, p)` | spodu + najmniej drewna w zamku) – słupek węgła dochodzi do dachu (wymóg użytkownika, runda 8). Ostatni bal węgła (nad nim nie ma bala ściany: góra ściany albo wieniec szczytu ucięty skosem przed węgłem) wchodzi z pół zamkiem już od zamek_min_drewno pod dachem (rdzen/pol_zamka.rb – runda 16). |
| 180 | `bez_platwi_nad(gosp, wn, sasiedzi, p)` | bocznego niżej niż góra ściany, płatew dachu głównego przechodząca przez ścianę w miejscu węgła), węgieł dochodzi do jej spodu i trzyma zamkiem styk najwyższego wieńca (zasada „styk zawsze w zamku”, runda 17). Warunek: bal ściany nad węgłem zachowuje między gniazdem zamka od spodu a gniazdem płatwi co najmniej zamek_min_drewno. |
| 189 | `ostatni_bal_wegla?(gosp, wn, sasiedzi, s, t, p)` | Czy bal węgła w wieńcu wn byłby ostatnim połączeniem pod dachem: ściana ma bal pod nim, a nad nim żadnego – nie ma już wieńca (góra ściany) albo, przy włączonym pół zamku, wieniec szczytu skośnego kończy się przed węgłem. |
| 201 | `pod_platwia?(kf, wn, gosp, s, sasiedzi, p)` | Bal węgła pod płatwią (rdzen/wegly_konstrukcyjne.rb): wieńce do spodu płatwi – górny bal ścina gniazdo płatwi w węgle, więc gniazdo płatwi w szczycie nie odbiera mu oparcia; niższy sąsiad w ścianie bez otworu (gniazdo płatwi się nie liczy), pod płatwią zostaje co najmniej najcieńszy pasek przy otworze (inaczej bal pominięty). |
| 217 | `nad_gospodarzem?(kf, wn, gosp, s, zmin, p)` | Wieniec węgła nad górą ściany bez szczytu: tylko pod dachem domu prostokątnego (ścina go linia dachu), gdy w osi ściany pod nim jest jej górny bal i nad zamkiem zostaje drewna (linia dachu nad zmin – także na obu licach węgła biegnącego wzdłuż kalenicy). |
| 231 | `sprawdz_dlugosci(wynik, p)` | Ostrzeżenia o długościach: kawałek krótszy od najkrótszego, bal dłuższy od maksymalnego. |
| 252 | `polozenie(b, p)` | Położenie bala w układzie domu: początek (lico prawe, czoło s0, spód), osie x (wzdłuż), y (w lewo), z (w górę). |

### rdzen/bryla.rb (282 wierszy)

bryła bala z obróbek – profil wzdłuż bala (przedziały z zakresem grubości i wysokości), przynależność punktu, objętość, podpis.

Zależy od: –
Używają: rdzen/siatka.rb, rdzen/pozycje.rb, rdzen/kontrola.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module Bryla` |  |
| 23 | `EPS` |  |
| 25 | `DOKLADNOSC` | Dokładność podpisu bala [mm] – bale różniące się mniej są tą samą pozycją. |
| 28 | `SCAL` | Punkty podziału profilu bliższe niż tyle [mm] są scalane – krawędź krótsza niż tolerancja SketchUpa (0,0254 mm) psuje ścianę bryły, a różnica 0,2 mm jest poniżej dokładności obróbki. |
| 31 | `OSTRZE` | Ujemna wysokość przedziału na jednym końcu [mm], którą klin_ok? jeszcze przyjmuje (ostrze klina przesunięte najwyżej o SCAL do punktu podziału: SCAL × tg kąta dachu do 60°). |
| 36 | `profil(dl, t, h, cechy)` | Profil: lista przedziałów { xa:, xb:, y0:, y1:, zb_a:, zb_b:, zt_a:, zt_b: } (puste przedziały pominięte). |
| 83 | `nad_spodem(q, c, kt)` | Część pasa, w której płaszczyzna ścięcia c jest nad spodem pasa (spód – wyższy z końców); nil – nigdzie. |
| 93 | `z_pasami(q, pasy)` | Przedział z pasami: q[:pasy], obrys (zt_a, zt_b) – najwyższy wierzch pasów; bez pasów – nil (pusty przedział). |
| 106 | `sciecie_pasow(pasy, c, t)` | nad nią – wierzch po płaszczyźnie (kt), przecięty – dwa pasy na granicy. Wierzch zmienny wzdłuż (skos szczytu) przecięty płaszczyzną – wyrównany do niższego końca (drewna ubywa); część pasa, w której płaszczyzna schodzi pod spód, znika (klin – górny bal ściany wysokiej przecięty dachem przez całą wysokość). |
| 137 | `kanal_pasow(pasy, c)` | Pasy z kanałem na przewody c (pionowy otwór na całą wysokość bala, y0…y1 w poprzek – rdzen/kanaly.rb): pas przecięty otworem dzieli się na część przed i za otworem; część węższa niż SCAL znika (otwór przy licu). |
| 153 | `klin_ok?(zb_a, zb_b, zt_a, zt_b)` | szczytu doprowadzony do spodu bala: wysokość zero na jednym końcu, bal kończy się ostrzem, nie pionowym czołem). Ujemna do OSTRZE na jednym końcu – ostrze tuż obok punktu podziału, którego nie dodano (bliżej niż SCAL od granicy obróbki); wysokość na tym końcu = 0. |
| 163 | `wyrownaj_poziomy(lista, skraj, wierzch)` | spód: najwyższy – drewna ubywa, nie przybywa); różne od wierzchu / spodu bala (skraj) o mniej niż SCAL – na skraju (obróbka cieńsza niż 0,2 mm pominięta). Inaczej uskok krótszy niż tolerancja SketchUpa psuje ścianę bryły (np. dno gniazda płatwi 0,095 mm nad dnem gniazda zamka). |
| 183 | `punkty_podzialu(xs, dl, dodatkowe = [])` | do bliskiego przecięcia (koniec podcięcia zamka 0,13 mm za przecięciem skosu z wierzchem – bal za szeroki w zamku, kolizja); pominięte przecięcie daje cięciwę – drewna ubywa, nie przybywa. Przedział między scalonymi punktami znika – sąsiednie przedziały biorą ograniczenia ze swojego środka. |
| 194 | `przeciecia(lista)` | Punkty x, w których dwie proste ograniczenia przecinają się wewnątrz wspólnego zakresu. |
| 211 | `wartosci(lista, xa, xb, xm, rodzaj)` | Wartości ograniczenia (min dla wierzchu, max dla spodu) na końcach przedziału xa…xb; aktywne te, które obejmują xm. |
| 219 | `liniowa(g, x)` | Wartość ograniczenia liniowego [x0, x1, z0, z1] w punkcie x. |
| 225 | `zawiera?(prof, x, y, z, eps = 1e-6)` | Czy punkt (x, y, z) w układzie bala jest wewnątrz bryły (ściśle, z marginesem eps). |
| 241 | `pole_pasa(c, koniec)` | Pole przekroju pasa na końcu a albo b (wierzch skośny w poprzek – średnia). |
| 249 | `objetosc(prof)` | Objętość bryły z profilu [mm³]. |
| 256 | `obrocone(dl, cechy)` | Cechy po obrocie bala o 180° wokół osi pionowej (x → dl − x, lica zamienione). |
| 266 | `podpis(dl, t, h, cechy)` | Podpis bala (tekst) – równe podpisy = identyczna bryła (te same wymiary i obróbki). |
| 275 | `podpis_kanoniczny(dl, t, h, cechy)` | Podpis kanoniczny: [podpis, obrócony?] – mniejszy z podpisów bala i bala obróconego o 180°. |

### rdzen/dach.rb (341 wierszy)

geometria dachu – linia podparcia (wierzch płatwi), linia szczytu, płatwie w przekroju, krokwie, belki dachu; dwuspadowy tutaj, jednospadowy w rdzen/dach_jednospadowy.rb.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wysokość ścian okapowych), rdzen/elementy.rb, rdzen/dach_jednospadowy.rb, rdzen/platwie_wience.rb (obniżenie dachu, położenia płatwi pośrednich, przekroje płatwi)
Używają: rdzen/szczyty.rb (linia szczytu, gniazda), rdzen/projekt.rb (belki dachu), rdzen/polacie.rb (linia podparcia), rdzen/pod_dachem.rb, rdzen/dach_jednospadowy.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 29 | `module Dach` |  |
| 33 | `geo(dom)` | Przekrój dachu z opisu dachu (dom): osie ścian okapowych i – w domu L – wspólne obniżenie obu dachów. |
| 41 | `kat(p)` | Kąt dachu [rad]. |
| 46 | `tg(p)` | Tangens kąta dachu. |
| 51 | `jednospadowy?(p)` | Czy dach jednospadowy (ściana niska i wysoka, bez kalenicy). |
| 56 | `krokwie?(p)` | Czy układ dachu ma krokwie. |
| 61 | `krokwie_generatora?(p)` | Czy krokwie buduje generator (dach_wiezba = generator); przy aplikacji do dachów krokwie powstają w jej KROKU 2. |
| 66 | `platwie_posrednie?(p)` | Czy układ dachu ma płatwie pośrednie (między ścienną a kalenicową). |
| 72 | `dodatek_krokwi(p)` | Grubość krokwi w pionie (h / cos kąta) z uniesieniem nad podbitką na płatwiach – o tyle wierzch krokwi jest nad linią podparcia [mm]. |
| 79 | `uniesienie_krokwi(p)` | O ile krokwie leżą wyżej niż linia podparcia [mm]: podbitka na płatwiach (deski między płatwiami a krokwiami) – grubość deski w pionie; inaczej 0. |
| 85 | `szczyt_do_wierzchu_krokwi?(p)` | Czy szczyt dochodzi do wierzchu krokwi (krokwie z generatora obok szczytu), a nie do linii podparcia. |
| 93 | `z_ref(p)` | podniesienie; płatew stojąca na ścianie – bez ścięcia linia przechodzi przez jej wierzch przy krawędzi od okapu, ze ścięciem – przy krawędzi od kalenicy; bez płatwi ściennej (ściana nośna) – wierzch ściany okapowej (górny bal ścięty do płaszczyzny dachu, rdzen/sciecie_dachu.rb). |
| 106 | `z_ref_geo(geo, p)` | Wysokość linii podparcia na licu wewnętrznym ściany okapowej po obniżeniu dachu (płatwie na pełnym balu) [mm]. |
| 112 | `linia_podparcia(geo, v, p)` | Linia podparcia w punkcie v przekroju [mm]; za linią załamania bocznego zadaszenia (geo[:zad], rdzen/zadaszenie.rb) – połać zadaszenia: od wysokości dachu w linii załamania w dół o tg kąta zadaszenia. |
| 122 | `linia_glowna(geo, v, p)` | Linia podparcia dachu dwuspadowego bez zadaszenia w punkcie v [mm]. |
| 130 | `linia_szczytu(geo, v, p)` | Linia szczytu (wierzch bali szczytu) w punkcie v [mm]. |
| 135 | `z_szczytu(geo, p)` | Najwyższy punkt linii szczytu (w kalenicy) [mm]; dach jednospadowy – nad osią ściany wysokiej. |
| 141 | `zalom_v(geo, p)` | Załom linii dachu (kalenica) w przekroju – v; dach jednospadowy – nil (linia prosta). |
| 146 | `zalomy_v(geo, p)` | Wszystkie załomy linii dachu w przekroju – kalenica i linie załamania bocznego zadaszenia (v, rosnąco). |
| 151 | `lico_okapu_v(geo, p)` | Lico zewnętrzne ściany okapowej (niskiej), nad którym połać przechodzi w okap – v. |
| 158 | `platwie(geo, p)` | Płatwie w przekroju: [{ rodzaj: 'scienna' \| 'posrednia' \| 'kalenicowa', v:, b:, h:, z_spod:, gora: }] (v – oś płatwi, gora – wierzch ścięty: [[dv, dz]] od osi płatwi i od spodu, nil – wierzch poziomy); jednospadowy – bez kalenicowej. |
| 192 | `platwa(geo, p, rodzaj, v, b, h, kier)` | Jedna płatew (kier – kierunek do kalenicy): ścięta – najwyższy punkt wierzchu w linii podparcia (krawędź od kalenicy, kalenicowa – w osi), wierzch po skosie; bez ścięcia albo gdy ścięcie zostawiłoby mniej niż 1/3 wysokości – wierzch poziomy na linii przy krawędzi od strony okapu. |
| 208 | `krokwie_u(u1, u2, p, wewn = [])` | Położenia krokwi wzdłuż kalenicy (u) między szczytami w u1 < u2 (osie ścian szczytowych); wewn – osie szczytów na działowych (krokwie z obu stron albo na szczycie). Pozostałe krokwie równo między krokwiami przy szczytach; na koniec bez krokwi wchodzących w inny szczyt i bez nachodzących na siebie (bez_kolizji). |
| 249 | `bez_kolizji(lista, osie, zew, bk, obok_szczytu)` | Krokwie bez kolizji: gdy szczyty sięgają wierzchu krokwi – bez krokwi, której oś jest bliżej osi szczytu niż pół grubości + pół krokwi (np. przy dwóch bliskich szczytach na działowych); nachodzące na siebie – jedna pośrodku. |
| 263 | `elementy(dom, p)` | Belki dachu: płatwie wzdłuż kalenicy i krokwie (elementy). dom = { os:, v_a:, v_b:, u1:, u2: }; dom L (dom[:boczne]) – płatwie obu dachów (płatwie skrzydła bocznego do dachu głównego, rdzen/skrzydla.rb), krokwie tylko z aplikacji do dachów. |
| 286 | `wreby_platwi!(e, dom, pl, u0, p)` | z gniazd, t – grubość, np. wiązara nad tarasem; brak – grubość ściany; bok – własna głębokość boczna wrębu, 0 – zamek tylko od spodu nad szczytem tarasu), x wzdłuż belki od u0; belka z wrębami ma zawsze przekrój (prostokąt, gdy bez ścięcia). |
| 299 | `przekroj_platwi(dom, pl)` | Przekrój płatwi ściętej w układzie belki (y – szerokość: przy osi kalenicy x rośnie z v, przy osi y maleje), nil – prostokąt. |
| 308 | `krokwie(dom, geo, p)` | Krokwie obu połaci: od okapu (lico ściany okapowej + dach_okap) do kalenicy, spód na linii podparcia (dach jednospadowy – krokwie w jednym kawałku, DachJednospadowy.krokwie). |
| 336 | `xy(dom, u, v)` | Punkt rzutu z (u wzdłuż kalenicy, v w poprzek). |

### rdzen/dach_jednospadowy.rb (111 wierszy)

dach jednospadowy – ściana niska i wysoka, linia podparcia od ściany niskiej w górę, płatwie bez kalenicowej, krokwie w jednym kawałku, ściana wysoka do połaci.

Zależy od: rdzen/parametry.rb, rdzen/dach.rb (z_ref_geo, tg, płatew, krokwie przy szczycie), rdzen/elementy.rb, rdzen/platwie_wience.rb
Używają: rdzen/dach.rb (wybór dachu), rdzen/szczyty.rb (ściana wysoka), rdzen/polacie.rb, rdzen/pod_dachem.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `module DachJednospadowy` |  |
| 27 | `niska(geo, p)` | Oś ściany niskiej i kierunek w górę połaci (+1 – w stronę większych v): [v, kier]. |
| 32 | `wysoka_v(geo, p)` | Oś ściany wysokiej (v). |
| 37 | `lico_niskie_v(geo, p)` | Lico zewnętrzne ściany niskiej (v) – tam połać przechodzi nad wierzchem ściany (okap). |
| 43 | `lico_wysokie_v(geo, p)` | Lico wewnętrzne ściany wysokiej (v) – do tej linii sięga jej górny bal. |
| 49 | `linia_podparcia(geo, v, p)` | Linia podparcia w punkcie v [mm]: z_ref na licu wewnętrznym ściany niskiej, w górę o tg(kąt) w stronę wysokiej. |
| 56 | `platwie(geo, p)` | Płatwie: ścienna przy ścianie niskiej (płatwa_na_scianie), pośrednie równo do lica ściany wysokiej (układ z płatwiami), bez kalenicowej – jak Dach.platwie. |
| 80 | `krokwie(dom, geo, p)` | Krokwie w jednym kawałku: od okapu za ścianą niską (dach_okap) do okapu za ścianą wysoką (dach_okap_wysoki), spód na linii podparcia; położenia wzdłuż ścian jak w dachu dwuspadowym (Dach.krokwie_u). |
| 98 | `sciana_wysoka!(sciany, dom, p, z_okap)` | Szczyt płaski ściany wysokiej (wzdłuż okapu, v stałe – lico zewnętrzne, najwyższe miejsce połaci nad ścianą): wieńce do linii podparcia przy licu zewnętrznym, górny bal ścięty skośnie do płaszczyzny dachu w poprzek (rdzen/sciecie_dachu.rb); dom = { v_a:, v_b:, os: } (Szczyty.dom_prostokatny). Zwraca ścianę wysoką albo nil. |

### rdzen/dlugosci_handlowe.rb (103 wierszy)

porównanie długości belek w modelu z długościami handlowymi z list przekrojów – podpowiedź, gdy belka jest dłuższa niż najdłuższa w hurtowni.

Zależy od: rdzen/parametry.rb (dlugosci_katalogu)
Używają: rdzen/projekt.rb (belki), rdzen/statyka_dachu.rb, rdzen/statyka_zadaszenia.rb, rdzen/statyka_krokwi.rb, rdzen/podloga.rb, rdzen/podciagi.rb (dobór – przekrój dostępny w całej długości)

| Wiersz | Element | Opis |
|---:|---|---|
| 20 | `module DlugosciHandlowe` |  |
| 22 | `TOL` | Belka dłuższa od handlowej o mniej niż tyle [mm] nie jest zgłaszana (zaokrąglenia). |
| 24 | `GRUPY` | Grupy belek: [prefiks, tag (nil – każdy), klucz listy przekrojów, nazwa w liczbie mnogiej, sekcja okna]. |
| 38 | `podpowiedzi(elementy, p)` | Podpowiedzi [{ poziom: 'uwaga', tekst:, sekcja: }] dla belek dłuższych niż najdłuższa handlowa ich przekroju. |
| 58 | `najlzejszy(wystarczajace, potrzebna, p, klucz)` | Przekrój do doboru automatycznego z listy wystarczających (od najlżejszego): pierwszy dostępny w hurtowni w długości potrzebna [mm] (wpis listy bez długości – bez ograniczenia); gdy żaden nie ma takiej długości – najlżejszy (belkę trzeba wtedy łączyć – podpowiedź z podpowiedzi). Pusta lista – nil. |
| 70 | `w_calosci?(bh, potrzebna, p, klucz)` | Czy przekrój bh jest w magazynie w długości co najmniej potrzebna [mm] (wpis bez długości albo przekrój spoza magazynu – tak). |
| 77 | `najpierw_w_calosci(lista, potrzebna, p, klucz)` | Lista przekrojów: najpierw dostępne w całej długości potrzebna (kolejność zachowana), potem pozostałe – dobór legarów, podciągów i krokwi bierze pierwszy wystarczający (runda 17: „dobór w całej długości także dla legarów, podciągów i krokwi”). |
| 83 | `tekst(nazwa, bh, za_dlugie, najdluzsza, dlugosci)` | Zdanie podpowiedzi: ile belek, jak długich, najdłuższa handlowa, co zrobić (przekrój z listy w całej długości). |
| 98 | `metry(mm)` | Długość w metrach do zdania (2 miejsca, bez zbędnych zer). |

### rdzen/dom_z_wymiarow.rb (61 wierszy)

dom prostokątny z wymiarów bez rysowania – obrys (lico zewnętrzne) z pól „Długość domu” i „Szerokość domu”, gdy w modelu nic nie jest zaznaczone; ściany działowe z tabeli okna.

Zależy od: rdzen/parametry.rb (pola dom_dlugosc, dom_szerokosc – rdzen/parametry_lista.rb)
Używają: sketchup/sterowanie.rb (start bez zaznaczenia, podgląd i generowanie domu z wymiarów)

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module DomZWymiarow` |  |
| 26 | `wymiary(parametry)` | Wymiary domu [długość, szerokość] w mm z parametrów okna (niepoprawne – wartości fabryczne, poza zakresem – granica). |
| 32 | `prostokat(dl, szer)` | Obrys prostokąta dl × szer [mm] od punktu 0,0: cztery odcinki [[x, y], [x, y]] – jak cztery narysowane linie. |
| 38 | `segmenty(parametry, dzialowe = [])` | Odcinki obrysu domu z wymiarów podanych w parametrach i osie działowych z tabeli okna. |
| 44 | `osie_dzialowych(dzialowe, dl, szer)` | Osie działowych z tabeli: [[x, y], [x, y]] w obrysie dl × szer; wiersz bez „od” albo poza obrysem – pominięty. |

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

### rdzen/dzialowe_bliskie.rb (89 wierszy)

działowe narysowane bliżej siebie niż grubość bala (osie równoległe kilkadziesiąt mm od siebie, zachodzące na siebie długością) – połączone w jedną ścianę w miejscu dłuższej, z ostrzeżeniem; bale dwóch takich ścian zajmowałyby to samo miejsce.

Zależy od: rdzen/geometria.rb (txt)
Używają: rdzen/obrys.rb (rozpoznaj – po klasyfikacji linii)

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `module DzialoweBliskie` |  |
| 24 | `TOL` | Zapas [mm]: działowe bliżej niż grubość − TOL są łączone. |
| 29 | `scal(dzialowe, t, uwagi)` | Działowe po połączeniu bliskich (t – grubość bala); ostrzeżenia dopisane do uwagi. |
| 47 | `pierwsza_para(lista, t)` | Pierwsza para działowych do połączenia [i, j]; nil – brak. |
| 62 | `pozioma?(s)` | Czy odcinek jest poziomy (y stałe). |
| 67 | `poz(s)` | Położenie osi w poprzek (y poziomej, x pionowej). |
| 72 | `zasieg(s)` | Zasięg wzdłuż osi [od, do]. |
| 78 | `polacz(a, b)` | Jedna działowa z dwóch: oś dłuższej, zasięg od najdalszego do najdalszego końca. |

### rdzen/elementy.rb (132 wierszy)

elementy z belek (podłoga, dach) – belka prostopadłościenna w dowolnym położeniu, pozycje identycznych belek, lista zamówienia.

Zależy od: rdzen/geometria.rb, rdzen/bryla.rb (podpis), rdzen/parametry.rb
Używają: rdzen/dach.rb, rdzen/podloga.rb, rdzen/taras.rb, rdzen/projekt.rb, sketchup/budowa.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 25 | `module Elementy` |  |
| 30 | `RODZAJE` | Nazwy rodzajów do komponentów i list: prefiks => [nazwa, tag]. Prefiksy = grupy Dokumentacji 2D (element_roles.rb, PREFIX_GROUPS), nazwy zawierają słowa, po których Dokumentacja 2D rozpoznaje grupę także bez atrybutu. |
| 40 | `pozioma(prefiks, p0, p1, b, h, z_spod, wyrownanie = :os, cechy = [], przekroj = nil)` | Belka pozioma od p0 do p1 (rzut, mm): szerokość b w poprzek – po lewej stronie kierunku przy :lewo, symetrycznie przy :os, po prawej przy :prawo; spód na wysokości z_spod; przekroj – wielokąt (nil – prostokąt b × h). |
| 55 | `ukosna(prefiks, p, d, kat, dl, b, h)` | Belka ukośna (krokiew): oś w płaszczyźnie pionowej wzdłuż kierunku d (rzut), nachylenie kat, początek spodu p. |
| 65 | `nowy(prefiks, dl, b, h, poczatek, x, y, z, cechy)` | Nowy element z osiami (x wzdłuż, y szerokość, z wysokość). |
| 72 | `numeruj(elementy, nr_start)` | Pozycje elementów (identyczne belki = jedna pozycja), numery od nr_start; nazwa „nr-długość”. |
| 106 | `posortowane(elementy)` | Kolejność numeracji: grupa (podłoga, dach, taras, fundamenty), prefiks, długość malejąco. |
| 112 | `lista_zamowienia(pozycje)` | Wiersze listy zamówienia elementów: jak Pozycje.lista_zamowienia (przekrój szer. × wys.). |
| 121 | `polozenie_instancji(e)` | Położenie instancji pozycji (obrócona o 180° – początek na drugim końcu, osie x i y odwrócone). |

### rdzen/fundamenty.rb (146 wierszy)

fundamenty punktowe pod podłogą – siatka rzędów w obu kierunkach w obrysie (skrajne licem z licem podwalin), stopy pod podwalinami, podciągami i podwalinami działowych.

Zależy od: rdzen/parametry.rb, rdzen/elementy.rb, rdzen/podloga_przybudowki.rb (pole podłogi – stopy pod podciągami)
Używają: rdzen/podloga.rb (linie podciągów, elementy F), rdzen/podciagi.rb (rozpiętość podciągu między fundamentami)

| Wiersz | Element | Opis |
|---:|---|---|
| 26 | `module Fundamenty` |  |
| 28 | `BOKI_KOLA` | Liczba boków wielokąta stopy okrągłej. |
| 33 | `wlaczone?(p)` | Czy podłoga ma fundamenty punktowe. |
| 38 | `wymiar(p)` | Wymiar stopy w rzucie (większy bok albo średnica) [mm]. |
| 44 | `opis(p)` | Opis stopy do podpowiedzi: „400x400” albo „⌀ 400”. |
| 50 | `okragle?(p)` | Czy stopy są okrągłe. |
| 56 | `rzedy(lo, hi, p, rozstaw = nil, stale = [])` | Osie rzędów od lo do hi (lica obrysu): skrajne pół stopy od lica, rzędy stałe w osiach działowych (stale), odcinki między nimi równo, rozstaw ≤ fundamenty_rozstaw_max. |
| 73 | `siatka(u, p)` | Siatka: { d: [osie rzędów wzdłuż legarów], e: [osie w poprzek] }; u[:rozstaw_d] – rozstaw rzędów d zagęszczony przez dobór legara (rdzen/podloga.rb#zageszczone); rzędy przechodzą przez osie działowych. |
| 79 | `osie_dzialowych(u, k)` | Osie działowych w kierunku k (współrzędna k stała wzdłuż działowej – działowa w poprzek tego kierunku). |
| 84 | `linie_podciagow(u, p)` | Wewnętrzne linie d siatki (pod podciągi). |
| 90 | `stopy(u, p, podciagi, z_pd, z_pw, dzialowe)` | Stopy: [[d, e, z_wierzchu]]; podciagi – osie d podciągów (stopy wewnątrz tylko pod nimi), z_pd / z_pw – spód podciągu / podwaliny, dzialowe – odcinki podwalin działowych [[[d, e], [d, e]]]. |
| 115 | `dodatkowe(pa, pb, s)` | Stopy pod odcinkiem podwaliny działowej pa…pb (w układzie d, e): przecięcia z rzędami siatki i końce. |
| 125 | `elementy(lista, p)` | Elementy F: stopy jako bryły fb × fl w rzucie, wysokość fundament_wysokosc, wierzch na z_wierzchu; xy – blok (d, e) → punkt rzutu. |
| 137 | `okrag(d)` | Przekrój stopy okrągłej o średnicy d: wielokąt BOKI_KOLA kątów wpisany w kwadrat d × d (przeciwnie do wskazówek). |

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

### rdzen/kanaly.rb (106 wierszy)

kanały na przewody elektryczne (N3) – pionowy otwór przez wszystkie wieńce ściany w zadanym miejscu (obróbka „kanal” bali, bryła z otworem) i opcjonalnie otwór puszki na zadanej wysokości (obróbka „puszka” – na liście obróbek); sprawdzenie miejsca (ściana, zamki skrzyżowań).

Zależy od: rdzen/parametry.rb, rdzen/bryla.rb (SCAL; profil z obróbką kanal – kanal_pasow)
Używają: rdzen/projekt.rb (przypisanie po otworach, obróbka po zamkach), rdzen/widok.rb (kanały w widoku ściany), html/klik_sciana.js (okienko kanału)

| Wiersz | Element | Opis |
|---:|---|---|
| 25 | `module Kanaly` |  |
| 29 | `przypisz(wejscie, sciany, p)` | Przypisanie kanałów do ścian (w[:kanaly]); zwraca listę ostrzeżeń. |
| 65 | `kolizja_zamka(w, s, r, t, p)` | Ściana poprzeczna (id), w której zamek trafiłby kanał s ± r; nil – kanał z dala od skrzyżowań. |
| 72 | `obrob!(bale, p)` | Obróbki kanałów i puszek w balach (po zamkach): każdy bal ściany z kanałami, który zachodzi na kanał. |
| 92 | `opis(bale)` | Zdanie do wyników: ile kanałów i bali z otworem kanału i puszki; nil – bez kanałów. |
| 101 | `do_widoku(w)` | Kanały ściany w do widoku: [[s, d, puszka albo nil, nazwa, nr]]. |

### rdzen/kontrola.rb (176 wierszy)

kontrola wyniku – kolizje bali w słupach zamków, mijanka styków w sąsiednich wieńcach, styki poza zamkiem, długości bali.

Zależy od: rdzen/bryla.rb, rdzen/bale.rb (polozenie), rdzen/zamek.rb (bale_w_zamku), rdzen/parametry.rb, rdzen/styki_tarasu.rb (front tarasu łączony na styk), rdzen/styki_szczytu.rb (wieńce szczytu łączone na styk), rdzen/kontrola_rownoleglych.rb (ściany równoległe)
Używają: testy, sketchup/sterowanie.rb (menu „Kontrola”)

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `module Kontrola` |  |
| 28 | `wszystko(plan)` | Wszystkie kontrole: { kolizje:, mijanka:, za_dlugie:, styki_bez_zamka:, nakladanie: } (puste listy = w porządku); nakladanie – bale ścian równoległych w tym samym miejscu (rdzen/kontrola_rownoleglych.rb). |
| 34 | `kolizje(plan)` | Kolizje w słupach zamków: [{ sciany: [id, id], punkt: [x, y], bale: [nr, nr], z: [z0, z1], objetosc: mm³ }]. |
| 53 | `kolizje_slupa(bale, pt, t, p, profile, ids)` | Kolizje w jednym słupie zamka (środek pt, bok t + 2 mm). |
| 94 | `globalny(pol, lx, ly, lz)` | Punkt bala (układ bala) w układzie domu. |
| 100 | `zawiera_globalnie?(pol, prof, c)` | Czy punkt domu leży w bryle bala. |
| 109 | `mijanka(plan)` | Naruszenia mijanki: [{ sciana:, wieniec:, odstep: }] – styki w sąsiednich wieńcach bliżej niż MIJANKA_MIN. |
| 135 | `styki_bez_zamka(plan)` | Styki, których nie trzyma zamek (układy na przemian i para – styk w osi skrzyżowania, gdzie w wieńcu wyżej albo niżej leży bal ściany poprzecznej): [{ sciana:, wieniec:, s: }]. |
| 163 | `pod_platwia?(w, b, s)` | Czy styk w s bala b leży pod płatwią, która biegnie wzdłuż ściany (gniazdo na całej długości – działowa pod kalenicową): górny bal ścięty gniazdem, płatew dociska styk z góry. |
| 168 | `za_dlugie(plan)` | Bale dłuższe od maksymalnej długości: [{ sciana:, nazwa:, dl: }]. |

### rdzen/kontrola_rownoleglych.rb (68 wierszy)

kontrola ścian równoległych – bale dwóch ścian biegnących obok siebie albo w jednej linii nie mogą zajmować tego samego miejsca.

Zależy od: rdzen/parametry.rb
Używają: rdzen/kontrola.rb (wszystko), rdzen/projekt.rb (ostrzeżenia), testy (losowe domy, domy złożone)

| Wiersz | Element | Opis |
|---:|---|---|
| 20 | `module KontrolaRownoleglych` |  |
| 22 | `TOL` | Wspólna część mniejsza niż tyle [mm] w którymkolwiek kierunku to styk, nie nakładanie. |
| 27 | `nakladanie(plan)` | Nakładające się bale ścian równoległych: [{ sciany: [id, id], bale: [nr, nr], wymiary: [wzdłuż, w poprzek, w pionie] }]. |
| 52 | `ostrzezenia(plan)` | Ostrzeżenia do okna: jedna uwaga na parę ścian, z największą wspólną długością. Zdarza się, gdy dwie ściany narysowano bliżej siebie niż długość węgła (ich węgły wchodzą w siebie) albo jedną na drugiej. |
| 61 | `zasieg(w, b, i)` | Bal i jego zasięg wzdłuż osi i (współrzędne domu): [bal, od, do]. |

### rdzen/krok2.rb (178 wierszy)

co generator przekazuje KROKOWI 2 aplikacji do dachów – ustawienia początkowe (kierunek, krokwie albo poszycie na samych płatwiach, warstwy poszycia, klasa drewna) i płatwie generatora jako podpory krokwi i poszycia.

Zależy od: rdzen/parametry.rb, rdzen/dach.rb (układ z krokwiami, uniesienie krokwi), rdzen/podbitka.rb (podbitka jako nadbitka)
Używają: rdzen/polacie.rb (podpowiedzi), sketchup/dach_aplikacja.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 32 | `module Krok2` |  |
| 34 | `KLASY_DREWNA` | Klasy drewna, które zna KROK 2 aplikacji (inne – zostaje wybór z aplikacji). |
| 37 | `WARSTWY` |  |
| 40 | `GRZBIET_NIZEJ` | O tyle pod grzbietem płatwi kalenicowej podawany jest jej wierzch (podpora wewnątrz obu połaci) [mm]. |
| 42 | `KROK_GRZBIETU` | Krok w poprzek przy rozpoznaniu grzbietu (wierzch niżej po obu stronach osi) [mm]. |
| 47 | `bez_krokwi?(p)` | Czy dach bez krokwi – układ „same płatwie”: poszycie wprost na płatwiach. |
| 52 | `ustawienia(p)` | Ustawienia początkowe KROKU 2 (symbole – klucze aplikacji, mm). |
| 62 | `poszycie(p)` | Warstwy poszycia KROKU 2 (sheath_*) z sekcji „Poszycie dachu”; nadbitka – deski na krokwiach (na samych płatwiach na płatwiach) z pola położenia desek (rdzen/podbitka.rb). |
| 74 | `nadbitka?(p)` | Czy KROK 2 kładzie nadbitkę: deski na krokwiach albo na samych płatwiach (Podbitka.przez_aplikacje?). |
| 79 | `warstwy(p)` | Nazwy włączonych warstw poszycia (od spodu). |
| 85 | `podpory(plan)` | Podpory krokwi i poszycia z planu: płatwie i ściana wysoka dachu jednospadowego – [{ od:, do: (wierzch w osi na końcach, mm układu domu), szerokosc:, wysokosc:, nazwa: }]. |
| 96 | `sciany_wysokie(sciany, p)` | Ściany pod połacią jako podpory: ściana wysoka dachu jednospadowego (szczyt płaski) i ściany okapowe przy ścianie nośnej (bez płatwi ściennej) – górny bal ścięty do połaci, wierzch w osi ściany, grubość bala. |
| 125 | `podpora(e)` | Podpora z belki poziomej: wierzch przekroju w osi (środek szerokości; grzbiet – GRZBIET_NIZEJ niżej), na obu końcach belki. |
| 139 | `wierzch_w(przekroj, y)` | Wierzch przekroju (wielokąt [[y, z]]) w miejscu y – najwyższe przecięcie jego krawędzi z pionem. |
| 153 | `grzbiet?(przekroj, y, z)` | Czy wierzch przekroju w y to grzbiet – po obu stronach niżej. |
| 161 | `podpowiedzi(p)` | Podpowiedź do okna o tym, co zrobi KROK 2 ([{ poziom:, tekst: }]); same płatwie bez warstwy poszycia – uwaga. |

### rdzen/magazyn_drewna.rb (155 wierszy)

magazyn drewna – jedna tabela w standardzie warsztatu (przekrój, długości handlowe, rodzaj drewna, do czego: legar / podciąg, płatew, krokiew, belka zadaszenia, słup, deska; cena za m³) zamiast pięciu list tekstowych; listy przekrojów dla doboru, przeniesienie dawnych list, jeden przełącznik doboru przekrojów z wyjątkami.

Zależy od: rdzen/wykaz_drewna.rb (wykaz fabryczny z hurtowni), rdzen/parametry_tabela.rb (wiersze tabeli)
Używają: rdzen/parametry.rb (katalog, dlugosci_katalogu, dobor, normalizuj – przeniesienie), rdzen/parametry_materialy.rb (pole magazyn_drewna), rdzen/wycena.rb (ceny)

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `module MagazynDrewna` |  |
| 25 | `KOLUMNY_LIST` | Dawny klucz listy przekrojów → kolumna magazynu. |
| 28 | `ZASTOSOWANIA` | Zastosowania (kolumny znaczników) z etykietami w oknie. |
| 30 | `RODZAJE` |  |
| 32 | `KOLUMNY` | Kolumny tabeli magazynu (pole magazyn_drewna). |
| 35 | `DESKA` | Deska nadbitki / podbitki i deskowania (decyzja z rundy 15): 14 × 115 (krycie) × 4000. |
| 37 | `WSPOLNY` | Wartość pola doboru elementu, która oznacza „jak przełącznik przekroje_dobor”. |
| 43 | `fabryczny` | Magazyn fabryczny: wykaz z hurtowni (C24 – konstrukcyjne, Nsi / DUO / BSH – widoczne) ze znacznikami jak dawne listy fabryczne i deska 14 × 115; bez cen. |
| 64 | `fmt(x)` | Liczba do tekstu długości (4.2, 6). |
| 70 | `wpisy(p, zastosowanie)` | Wpisy magazynu dla zastosowania (kolumna albo dawny klucz listy): [[b, h, [długości mm rosnąco]]] – przekrój jak w wierszu (szerokość × wysokość), długości puste – bez ograniczenia. |
| 81 | `przekroje(p, zastosowanie)` | Przekroje magazynu dla zastosowania: [[b, h]] bez powtórzeń. |
| 86 | `dlugosci(p, zastosowanie)` | Długości handlowe dla zastosowania: { [mniejszy, większy] => [mm rosnąco] } – tylko wpisy z długościami. |
| 98 | `wiersz(p, bh, zastosowanie = nil)` | Wiersz magazynu o przekroju bh (kolejność wymiarów bez znaczenia; zastosowanie – tylko wiersze z tym znacznikiem, nil – dowolny); nil – brak. |
| 110 | `dobor(p, klucz)` | Tryb doboru elementu: pole doboru (np. 'platwie_dobor') z wartością „wspolny” – według przełącznika przekroje_dobor (legary: auto → 'zalecany'); inna wartość – wyjątek tego elementu. |
| 119 | `przenies_listy(wej)` | Dawne listy przekrojów (pola tekstowe do kompilacji 16) w wejściu → magazyn: wpisy wszystkich list ze znacznikami list, w których były (lista nieobecna – fabryczna), długości z list; bez dawnych list albo z magazynem – bez zmian. |
| 136 | `przekroj_dl(r)` | Wpis [b, h, [mm]] wiersza fabrycznego (do tekstu listy). |
| 142 | `dlugosci_wiersza(r)` | Długości wiersza w mm. |
| 147 | `nowy_wiersz(fab, b, h)` | Nowy wiersz magazynu b × h przy przenoszeniu list (rodzaj z wykazu fabrycznego albo C24, bez znaczników i długości). |

### rdzen/materialy.rb (284 wierszy)

zestawienie materiałów poza balami i belkami, liczone z geometrii domu – deski poszycia dachu (m² i sztuki), taśma między wieńcami, izolacja pod pierwszy wieniec, okucia (śruby regulacyjne i podstawy słupów, kotwy podwalin, łączniki krokwi) i powierzchnia drewna do impregnacji z ilością impregnatu.

Zależy od: rdzen/parametry.rb, rdzen/dach.rb (jednospadowy, geometria dachu), rdzen/krok2.rb (warstwy poszycia), rdzen/podbitka.rb (podbitka jako nadbitka z aplikacji)
Używają: rdzen/projekt.rb (plan[:materialy]), rdzen/zestawienie.rb (drugi blok pliku CSV), sketchup/sterowanie.rb (tabela w oknie)

| Wiersz | Element | Opis |
|---:|---|---|
| 29 | `module Materialy` |  |
| 30 | `NAGLOWEK` |  |
| 32 | `BELKI_WIDOCZNE` | Belki liczone do impregnacji (prefiksy elementów): płatwie, krokwie, słupy, wiązar tarasu, belki zadaszenia. |
| 37 | `lista(plan)` | Wszystkie wiersze materiałów z planu (pusta lista, gdy plan bez bali). |
| 45 | `zaokr(v, n = 1)` | Zaokrąglenie do n miejsc (Ruby 2.2 – bez floor(n) / ceil(n)). |
| 50 | `sztuki(ilosc, sztuka, p)` | Liczba sztuk w górę: ilość z zapasem / wielkość sztuki. |
| 56 | `wiersz(grupa, nazwa, wymiar, ilosc, jednostka, uwagi = '')` | Wiersz zestawienia. |
| 63 | `powierzchnia_dachu(plan)` | Powierzchnia połaci [m²]: { dach:, zadaszenie:, przyblizona: } albo nil (dom bez szczytów / dachu). |
| 86 | `przyblizona(plan, p)` | Powierzchnia dachu w przybliżeniu dla obrysu innego niż prostokąt: (pole obrysu + obwód × okap) / cos kąta. |
| 101 | `poszycie(plan, p, dach)` | Deski i płyty poszycia: warstwy z sekcji „Poszycie dachu” (jak KROK 2 aplikacji do dachów) i podbitka z generatora. |
| 126 | `deski(nazwa, grubosc, krycie, dlugosc, m2, p, uwagi, szer = nil)` | Dwa wiersze desek: m² i sztuki o długości handlowej (krycie – szerokość z odstępem; szer – szerokość deski w opisie). |
| 134 | `podbitka(plan, p)` | Deski rysowane przez generator (elementy Pb): m² i sztuki o długości handlowej; na płatwiach albo na krokwiach – nadbitka, pod nimi – podbitka. |
| 148 | `uszczelnienie(plan, p)` | Taśma między wieńcami (bale poza najniższym wieńcem każdej ściany) i izolacja pod pierwszy wieniec [m]. |
| 165 | `okucia(plan, p)` | Okucia: regulacja i podstawy słupów, kotwy podwalin, łączniki krokwi z płatwiami. |
| 196 | `laczniki_platwi_l(plan)` | Dom L: łączniki płatwi skrzydła bocznego z płatwią dachu głównego (styk – wieszak; oparcie na płatwi i słupek – kątownik z obu stron) – rdzen/podpory_platwi_l.rb. |
| 207 | `oparcia_krokwi(el)` | Liczba oparć krokwi z generatora na płatwiach: pary (krokiew, płatew), których osie w rzucie się przecinają. |
| 214 | `odcinek_rzutu(e)` | Odcinek osi belki w rzucie z góry: [[x0, y0], [x1, y1]] (początek belki i jej koniec wzdłuż osi x elementu). |
| 221 | `przecinaja?(a, b)` | Czy dwa odcinki w rzucie przecinają się (z tolerancją 100 mm na końcach – belka ma szerokość). |
| 237 | `impregnacja(plan, p, dach)` | Powierzchnie drewna do impregnatu albo farby [m²] i ilość impregnatu [l]. |
| 269 | `liczba(v, n = 1)` | Liczba z przecinkiem dziesiętnym (n miejsc, bez zbędnych zer po przecinku). |
| 276 | `wiersze_csv(materialy)` | Wiersze bloku materiałów do pliku CSV (nagłówek + wiersze; pusta lista, gdy brak materiałów). |

### rdzen/obrys.rb (301 wierszy)

rozpoznanie narysowanych linii – zamknięty obrys (lico zewnętrzne), osie ścian działowych, znaczniki kontrforów.

Zależy od: rdzen/geometria.rb, rdzen/parametry.rb, rdzen/dzialowe_bliskie.rb (działowe bliżej niż grubość bala)
Używają: rdzen/projekt.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 20 | `module Obrys` |  |
| 26 | `rozpoznaj(segmenty, p)` | Rozpoznanie linii: { kat:, obrys:, dzialowe:, kontrfory:, ostrzezenia:, bledy: } (układ lokalny). |
| 59 | `kat_ukladu(odc)` | Kąt układu lokalnego = kierunek najdłuższej linii (0 ≤ kąt < 90°). |
| 69 | `rozdziel(lok, tol)` | Podział na poziome / pionowe (wyrównane) i pozostałe – linie w postaci {a:, b:, poz:} (a < b). |
| 91 | `scal(linie, os, tol)` | Scalanie linii leżących na jednej prostej (różnica położenia ≤ tol) i zachodzących / stykających się. os: 1 – linie poziome (poz = y), 0 – pionowe (poz = x, znacznik pion: true). |
| 116 | `przyciagnij_konce(poziome, pionowe, tol)` | Końce linii bliskie linii prostopadłej (≤ tol) są do niej dociągane – narożniki i styki T się zamykają. |
| 134 | `obwiednia(poziome, pionowe, tol)` | Zewnętrzna pętla grafu linii (po odcięciu wiszących końców): wierzchołki obrysu przeciwnie do wskazówek zegara. |
| 190 | `najbardziej_w_prawo(biezacy, kier, poprzedni, krawedzie, wezly)` | Następny węzeł obwiedni: skręt w prawo, prosto, w lewo – w tej kolejności (zewnętrze zostaje po prawej). |
| 204 | `uprosc(punkty, tol)` | Usuwa wierzchołki leżące na prostej między sąsiadami. |
| 223 | `klasyfikuj(linie, obrys, p, tol, wynik)` | Podział pozostałych linii na osie ścian działowych i znaczniki kontrforów. |
| 251 | `konce(l)` | Końce linii {a:, b:, poz:} jako punkty (poziome mają poz = y, pionowe poz = x). |
| 260 | `przeciecie_wewnetrzne(s, w, tol)` | Punkt przecięcia leżący wewnątrz obu odcinków (nie na końcach odcinka s) albo nil. |
| 272 | `przytnij_do_obrysu(s, obrys, boki, tol, wynik)` | część biegnąca po boku obrysu – bez ostrzeżenia (tam stoi już ściana zewnętrzna). Linia narysowana jednym ruchem przez wcięcie obrysu (U, H) daje osobną działową po każdej stronie wcięcia – wcześniej jedna działowa od pierwszego do ostatniego kawałka wchodziła w ścianę wcięcia (runda 14). |

### rdzen/osiadanie.rb (71 wierszy)

osiadanie ścian z bali a słupy – o ile krótszy ma być słup stojący pod balami (luz osiadania i okucie regulacyjne w głowicy), podpowiedź do okna.

Zależy od: rdzen/parametry.rb
Używają: rdzen/taras_slupy.rb (długość słupa tarasu), rdzen/projekt.rb (podpowiedź w sekcji tarasu), rdzen/materialy.rb (okucia regulacyjne w zestawieniu)

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module Osiadanie` |  |
| 26 | `slupy?(p)` | Czy słupy pod balami są skracane o osiadanie ścian. |
| 31 | `luz(h, p)` | Osiadanie bali o wysokości h [mm]: h × osiadanie_scian [%], w górę do pełnego milimetra. |
| 36 | `regulacja(p)` | Rodzaj regulacji w głowicy słupa: 'sruba' albo 'podkladki'. |
| 41 | `okucie(p)` | Wysokość okucia w głowicy po osiadaniu [mm]: śruba skręcona – slup_regulacja_wysokosc, podkładki wyjęte – 0. |
| 47 | `slupa(z_gora, p)` | Skrócenie słupa, na którym leżą bale o spodzie na wysokości z_gora: { luz:, okucie:, razem:, regulacja: } [mm]; nil – słupy bez skracania albo skrócenie zerowe. |
| 56 | `podpowiedzi(elementy, p)` | Podpowiedź do okna o skróceniu słupów ([{ poziom:, tekst: }]) – z elementów, które mają e[:osiadanie]. |

### rdzen/otwory.rb (120 wierszy)

otwory okienne i drzwiowe – położenie na ścianie, sprawdzenie, cięcia bali w każdym wieńcu.

Zależy od: rdzen/geometria.rb, rdzen/parametry.rb, rdzen/stolarka.rb (otwór ze stolarki i luzów)
Używają: rdzen/projekt.rb, rdzen/bale.rb, rdzen/styki.rb (omijanie otworów)

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `module Otwory` |  |
| 25 | `TOL_Z` | Bal przecięty otworem na wysokości mniejszej niż tyle [mm] traktujemy jak cały w otworze. |
| 30 | `przypisz(wejscie, sciany, p, wysokosc_sciany)` | Przypisanie otworów do ścian (w[:otwory]); zwraca listę ostrzeżeń. |
| 77 | `dla_wienca(w, z0, h, pasek = TOL_Z)` | gniazdami płatwi, wyciecia: [{ s0:, s1:, strona:, gleb: }], uwagi: [] }. Pasek bala cieńszy niż pasek [mm] (min_pasek_przy_otworze) nad albo pod otworem – bal przecięty w całości (taki pasek się nie trzyma, a w pełnym profilu byłby płytszy niż wpust), z ostrzeżeniem. |
| 108 | `w_otworze?(w, s, z0, z1)` | Czy w miejscu s ściany jest otwór na wysokości [z0, z1] (do kontrforów i styków). |
| 115 | `strefy_zakazane(w, zapas)` | Przedziały s zajęte przez otwory poszerzone o zapas (do wyboru miejsc styków i kontrforów; bez gniazd płatwi). |

### rdzen/parametry.rb (178 wierszy)

sprawdzenie i uzupełnienie parametrów z okna / modelu / ustawień (zakresy, wybory, przekroje, zamek) i odczyt pomocniczy.

Zależy od: rdzen/parametry_lista.rb, rdzen/parametry_tabela.rb (pola tabel), rdzen/magazyn_drewna.rb (przekroje, długości, dobór), log.rb
Używają: rdzen/projekt.rb (normalizacja), wszystkie pliki rdzen/ (odczyt), sketchup/okno.rb, sketchup/ustawienia.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `module Parametry` |  |
| 21 | `MIJANKA_MIN` | Wymóg użytkownika: styki w sąsiednich wieńcach przesunięte co najmniej o tyle [mm]. |
| 23 | `PRESETY` |  |
| 24 | `DOMYSLNE` |  |
| 29 | `normalizuj(wejscie)` | Pełny zestaw parametrów z wartości użytkownika: [parametry, ostrzeżenia]. Zamek – z presetu lub własny. |
| 45 | `przenies_dawne(wej)` | Dawne pola z modeli i ustawień wcześniejszych kompilacji w obecnej postaci: nadbitka → położenie desek (r16), nowe okno i drzwi → lista stolarki, pięć list przekrojów → magazyn drewna (r17). |
| 52 | `sprawdz(w, v, uwagi)` | Jedna wartość według rodzaju pola; wartość spoza zakresu – granica zakresu i ostrzeżenie. |
| 66 | `wybor(w, v, uwagi)` | Wartość pola wyboru (stare wartości z wcześniejszych kompilacji zamieniane na obecne). |
| 75 | `liczba_w_zakresie(w, v, uwagi)` | Liczba w zakresie min…max (całkowita dla :calkowita). |
| 93 | `zamek_z(wlasny, preset, uwagi)` | Wymiary zamka: preset uzupełniony wartościami użytkownika (sprawdzone, czy zamek się mieści). |
| 114 | `grubosc(p)` | Grubość ściany [mm]. |
| 119 | `krycie(p)` | Rozstaw wieńców = wysokość bryły bala prostego [mm]. |
| 124 | `tak?(p, klucz)` | Czy parametr tak/nie jest włączony. |
| 129 | `przekroj(p, klucz)` | Przekrój parametru jako [szerokość, wysokość] w mm. |
| 134 | `przekroj_z(v)` | Przekrój z tekstu „50x150” / „50×150” / „50*150” → [50.0, 150.0]; nil gdy niepoprawny. |
| 143 | `tekst_przekroju(bh)` | Przekrój jako tekst „50x150”. |
| 149 | `katalog(p, klucz = 'przekroje_katalog')` | Przekroje z magazynu drewna dla zastosowania (dawny klucz listy, np. 'platwie_katalog', albo kolumna magazynu – rdzen/magazyn_drewna.rb) → [[b, h], …] bez powtórzeń. |
| 154 | `dlugosci_katalogu(p, klucz = 'przekroje_katalog')` | Długości handlowe przekrojów z magazynu dla zastosowania: { [mniejszy, większy] => [mm rosnąco] } (tylko z długościami). |
| 159 | `dobor(p, klucz)` | Tryb doboru elementu (pole doboru z wartością „wspolny” – według przełącznika przekroje_dobor). |
| 164 | `liczba(v)` | Liczba z tekstu lub liczby (przecinek dziesiętny dozwolony); nil gdy się nie da. |
| 172 | `fmt(v)` | Liczba do komunikatu (bez zbędnego ,0). |

### rdzen/parametry_dach.rb (296 wierszy)

parametry sekcji „Szczyty i dach” i „Poszycie dachu” – szczyty, dach, płatwie (dobór przekroju, śnieg, ciężar pokrycia), krokwie (dobór przekroju), oparcie dachu, poszycie, położenie desek nadbitki / podbitki (jedno pole) i przeniesienie dawnych pól nadbitki.

Zależy od: rdzen/parametry_lista.rb (TAK_NIE), rdzen/magazyn_drewna.rb (przekroje do doboru – pole magazyn_drewna, przełącznik przekroje_dobor)
Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji)

| Wiersz | Element | Opis |
|---:|---|---|
| 17 | `module ParametryDach` |  |
| 18 | `TAK_NIE` |  |
| 23 | `DESKI_ZAMIENNIKI` | Parametry sekcji (kolejność = kolejność w oknie). Położenie desek nadbitki / podbitki, które zastępuje wybrane, gdy układ dachu nie ma płatwi pośrednich albo krokwi (to samo w oknie – html/zalezne.js). |
| 26 | `DESKI_UKLAD` | Położenia desek dostępne w układzie dachu bez krokwi i bez płatwi pośrednich (płatwie i krokwie – wszystkie). |
| 29 | `NADBITKA_WYMIARY` | Wymiary nadbitki sprzed rundy 16 (osobne pola) => wymiary wspólnej deski nadbitki / podbitki. |
| 32 | `LISTA` |  |
| 273 | `polozenie_desek(v, uklad)` | Położenie desek zgodne z układem dachu: wybrane albo jego zamiennik (same płatwie – na / pod płatwiami, same krokwie – na / pod krokwiami). |
| 282 | `przenies_nadbitke(wej)` | Wartości zapisane przed rundą 16 (osobno „Podbitka” i „Nadbitka – pierwsza warstwa poszycia”) → jedno pole położenia desek: nadbitka włączona bez podbitki = deski na krokwiach (przy samych płatwiach – na płatwiach) z jej wymiarami; nadbitka wyłączona = bez desek; wybrana podbitka zostaje. Wejście bez dawnych kluczy – bez zmian. |

### rdzen/parametry_kanaly.rb (34 wierszy)

parametry kanałów na przewody elektryczne (N3) – średnica kanału i puszki, wysokość puszki w okienku, odstęp kanału od zamków skrzyżowań.

Zależy od: –
Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji), rdzen/kanaly.rb, html/klik_sciana.js (wartości w okienku)

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `module ParametryKanaly` |  |
| 17 | `LISTA` |  |

### rdzen/parametry_lista.rb (286 wierszy)

lista wszystkich parametrów – wartość domyślna, etykieta, jednostka, zakres, rodzaj pola, sekcja okna, podpowiedź; presety przekroju bala.

Zależy od: rdzen/parametry_dach.rb, rdzen/parametry_taras.rb, rdzen/parametry_zadaszenie.rb, rdzen/parametry_podloga.rb, rdzen/parametry_materialy.rb, rdzen/parametry_stolarka.rb, rdzen/parametry_kanaly.rb (listy sekcji)
Używają: rdzen/parametry.rb (sprawdzanie), sketchup/okno.rb (formularz), sketchup/ustawienia.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 24 | `module ParametryLista` |  |
| 26 | `SEKCJE` | Sekcje okna w kolejności wyświetlania: [klucz, tytuł, otwarta na starcie, zakładka (brak – pierwsza z ZAKLADKI)]. |
| 47 | `ZAKLADKI` | Zakładki okna: [klucz, tytuł]; sekcja bez czwartego elementu w SEKCJE należy do pierwszej zakładki. Wymóg użytkownika (2026-11-25): „cała część bocznego zadaszenia – lub tylnego – w osobnej zakładce, by się nic nie myliło”. |
| 52 | `TAK_NIE` |  |
| 55 | `LISTA_SCIANY` | Parametry sekcji przekroju, ścian, łączeń i węgłów (kolejność = kolejność w oknie w ramach sekcji). |
| 191 | `LISTA_OTWORY` | Parametry sekcji okien i drzwi oraz rozpoznania rysunku. |
| 219 | `LISTA` | Wszystkie parametry w kolejności okna: listy sekcji z tego pliku i z plików parametrów dachu, tarasu, podłogi i materiałów. |
| 224 | `SZABLONY` | Szablony wbudowane (okno – lista szablonów): nazwa => wartości różne od domyślnych. |
| 238 | `STARE_WARTOSCI` | Wartości z wcześniejszych kompilacji zapisane w modelach: klucz => { stara => nowa }. |
| 243 | `PRESETY` | Presety przekroju: wymiary bala i zamka [mm]. Klucze zamka czyta rdzen/zamek.rb. |
| 258 | `OPISY_ZAMKA` | Opisy wymiarów zamka w oknie: klucz presetu => [etykieta, jednostka]. |
| 268 | `wpis(klucz)` | Wpis parametru po kluczu (nil – nie ma takiego). |
| 273 | `domyslne` | Wartości domyślne wszystkich parametrów: { klucz => wartość }. |
| 280 | `wybory(w)` | Lista wyborów pola (preset – z PRESETY). |

### rdzen/parametry_materialy.rb (72 wierszy)

parametry sekcji „Zestawienie materiałów” (zapas na docinki, taśma między wieńcami, rozstaw kotew podwalin, wydajność i liczba warstw impregnatu) i „Powierzchnie i limity” (teren pod pierwszym balem, limit powierzchni zabudowy i wysokości).

Zależy od: rdzen/magazyn_drewna.rb (kolumny i wiersze fabryczne magazynu drewna)
Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji), rdzen/materialy.rb (obliczenia), rdzen/powierzchnie.rb (limity)

| Wiersz | Element | Opis |
|---:|---|---|
| 17 | `module ParametryMaterialy` |  |
| 20 | `CENNIK` | Parametry sekcji (kolejność = kolejność w oknie). Cennik materiałów poza drewnem – wiersze fabryczne (nazwa = początek nazwy pozycji zestawienia, ceny puste). |
| 24 | `LISTA` |  |

### rdzen/parametry_podloga.rb (111 wierszy)

parametry sekcji „Podłoga i fundamenty” – podwaliny (przekrój, łączenie), legary, podciągi, fundamenty punktowe, obciążenia.

Zależy od: rdzen/parametry_lista.rb (TAK_NIE), rdzen/magazyn_drewna.rb (przekroje do doboru – pole magazyn_drewna, przełącznik przekroje_dobor)
Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji)

| Wiersz | Element | Opis |
|---:|---|---|
| 17 | `module ParametryPodloga` |  |
| 18 | `TAK_NIE` |  |
| 21 | `LISTA` | Parametry sekcji (kolejność = kolejność w oknie). |

### rdzen/parametry_stolarka.rb (52 wierszy)

parametry stolarki – lista typowej stolarki (pole-tabela), folder modeli, prosty model okna i drzwi z generatora (rama, szyba, skrzydło drzwi, maskownice), gdy nie ma pliku modelu.

Zależy od: –
Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji), rdzen/stolarka_modele.rb, rdzen/stolarka_prosta.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 18 | `module ParametryStolarka` |  |
| 19 | `LISTA` |  |

### rdzen/parametry_tabela.rb (104 wierszy)

parametry w postaci tabeli (lista stolarki, magazyn drewna) – kolumny z opisu pola, sprawdzenie wierszy, tabela z tekstu JSON z okna, przeniesienie dawnych pól nowego okna i drzwi do listy stolarki.

Zależy od: – (Parametry.liczba przez wywołującego)
Używają: rdzen/parametry.rb (sprawdz – rodzaj :tabela, normalizuj – przeniesienie dawnych pól), rdzen/parametry_lista.rb (stolarka), rdzen/magazyn_drewna.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `module ParametryTabela` |  |
| 23 | `DAWNE_STOLARKI` | Dawne pola „Nowe okno / nowe drzwi” (do kompilacji 16) → pierwsze wiersze listy stolarki. |
| 29 | `wiersze(w, v, uwagi)` | Wiersze tabeli pola w z wartości v (tablica albo tekst JSON); niepoprawna wartość – tabela fabryczna z uwagą. |
| 39 | `z_tekstu(t)` | Tablica z tekstu JSON; nil – tekst nie jest tablicą JSON. |
| 47 | `wiersz(w, r)` | Jeden wiersz z kolumnami pola w (klucze tekstowe albo symbole); nil – wiersz pusty albo nie-Hash. |
| 58 | `wartosc(rodzaj, v, wybory)` | Wartość komórki według rodzaju kolumny. |
| 70 | `liczba(v)` | Liczba z tekstu lub liczby (przecinek dziesiętny dozwolony); nil – puste albo niepoprawne. |
| 77 | `pusty?(w, r)` | Czy wiersz nie ma żadnej wartości (puste teksty, brak liczb, wszystkie znaczniki wyłączone). |
| 91 | `przenies_stolarke(wej, domyslna)` | Dawne pola nowego okna i drzwi z wejścia (model albo ustawienia sprzed kompilacji 17) → lista stolarki, gdy wejście nie ma jeszcze listy; wejście bez dawnych pól – bez zmian. |

### rdzen/parametry_taras.rb (184 wierszy)

parametry sekcji „Taras” – wariant, głębokość, podciąg, słupy z zamkami (słup w osi kalenicy), szczyt nad tarasem z wiązarem (przekroje słupka i zastrzałów, zamek płatwi tylko od spodu), wejście, balustrada.

Zależy od: rdzen/parametry_lista.rb (TAK_NIE)
Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji)

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `module ParametryTaras` |  |
| 17 | `TAK_NIE` |  |
| 20 | `LISTA` | Parametry sekcji (kolejność = kolejność w oknie). |

### rdzen/parametry_zadaszenie.rb (95 wierszy)

parametry zakładki „Zadaszenie boczne / tylne” – wariant (słupy z oczepem albo przybudówka z bali), strona, szerokość, kąt mniejszy niż kąt dachu, okap, podłoga w przybudówce, dobór przekrojów (automatycznie albo z wyboru) płatwi, słupów i belek poprzecznych.

Zależy od: rdzen/magazyn_drewna.rb (przekroje do doboru – pole magazyn_drewna, przełącznik przekroje_dobor)
Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji)

| Wiersz | Element | Opis |
|---:|---|---|
| 17 | `module ParametryZadaszenie` |  |
| 22 | `LISTA` | Parametry sekcji (kolejność = kolejność w oknie). |

### rdzen/platwie_wience.rb (167 wierszy)

płatwie oparte na pełnym balu – obniżenie dachu i przesunięcie płatwi pośrednich tak, żeby pod gniazdem płatwi nie zostawał pasek bala cieńszy niż najcieńszy dopuszczalny (bez przerw pod płatwią).

Zależy od: rdzen/parametry.rb, rdzen/dach.rb (płatew, linia podparcia – wywołuje ten plik)
Używają: rdzen/dach.rb (linia podparcia – obniżenie, płatwie pośrednie – położenia), rdzen/dach_jednospadowy.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 28 | `module PlatwieWience` |  |
| 30 | `KLUCZE` | Parametry, od których zależy obniżenie dachu (klucz pamięci podręcznej). |
| 36 | `PAMIEC` | Pamięć obniżeń: klucz (osie ścian okapowych i parametry) → d [mm]. |
| 38 | `TOL` | Tolerancja „pasek zerowy” [mm]. |
| 43 | `przekroj(p, rodzaj)` | Przekrój płatwi danego rodzaju: jeden przekrój dla wszystkich (platwie_jeden_przekroj) albo osobne pola. |
| 53 | `pasek(z, p)` | Pasek bala pod gniazdem płatwi o spodzie z [mm] (0 … krycie); dno gniazda – spód wrębu płatwi (zamek płatwi). |
| 60 | `pasek_ok?(z, p)` | Czy płatew o spodzie z leży na pełnym balu albo nad dość grubym paskiem. |
| 67 | `wegiel_pod?(p, rodzaj)` | Czy pod płatwią danego rodzaju staje węgieł, którego górny bal ma ją podpierać (parametry węgłów pod płatwiami; płatew ścienna leży przy ścianie okapowej, podbitka pod płatwiami – węgieł kończy się pod deskami). |
| 75 | `pasek_wegla(z, p)` | Pasek górnego bala węgła pod płatwią o spodzie z [mm] (0 … krycie): wieńce węgła zaczynają się półbalem – są przesunięte o pół krycia względem wieńców szczytu. |
| 83 | `oparcie_ok?(z, p, rodzaj)` | Czy płatew danego rodzaju o spodzie z leży dobrze: w ścianie (pasek_ok?) i – gdy stoi pod nią węgieł – na pełnym balu węgła albo nad paskiem nie cieńszym niż najcieńszy. |
| 91 | `obnizenie(geo, p)` | Obniżenie dachu d [mm] dla przekroju geo (osie ścian okapowych) – w pamięci; podczas liczenia samo zwraca 0. |
| 105 | `szukaj_obnizenia(platwie, p)` | Najmniejsze d (0 … dach_obnizenie_max), przy którym płatwie o stałym położeniu mają oparcie_ok? (ściana i węgieł pod płatwią); płatew stojąca na ścianie wyznacza dach – bez obniżenia. Kandydaci: 0, d dające pasek 0 i pasek równy najcieńszemu – w ścianie i w węgle. |
| 129 | `polozenia(v0, v1, n, p, kier)` | Położenia płatwi pośrednich (v) między oparciami v0 i v1 (kier – w stronę v1, w górę połaci): równo, potem każda z za cienkim paskiem (w ścianie albo w węgle pod nią) przesunięta na pełny bal albo na najcieńszy pasek (najmniejsze przesunięcie, rozstaw dotrzymany). Blok: v → spód płatwi (Dach.platwa). |

### rdzen/pod_dachem.rb (92 wierszy)

bale wystające pod połać – węgły na ścianach okapowych i działowe w poprzek kalenicy ścięte linią dachu (spód krokwi / desek); ostrzeżenie o zbyt stromym dachu.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb, rdzen/dach.rb (linia podparcia, załom, lico okapu), rdzen/szczyty.rb (zasieg_linii, skosy_linii), rdzen/podbitka.rb (ściany kończą się pod podbitką)
Używają: rdzen/projekt.rb, rdzen/bale.rb (zasięg i skos bali pod dachem)

| Wiersz | Element | Opis |
|---:|---|---|
| 24 | `module PodDachem` |  |
| 28 | `przygotuj(sciany, p, dom)` | Oznacza ściany pod połacią (w[:pod_dachem]); zwraca ostrzeżenia (dach zbyt stromy dla ściany okapowej). |
| 57 | `v_z_s(w, s)` | Współrzędna v punktu s ściany pod dachem. |
| 65 | `linia(w, s, p)` | Linia podparcia nad punktem s ściany [mm] (z podbitką – jej spód, rdzen/podbitka.rb; węgieł ze stykami ściany – połać, Podbitka.obnizenie_wegla; koniec działowej ze stykiem ściany okapowej – Podbitka.linia_dzialowej); ściana nie pod dachem – nil. |
| 73 | `zalom(w, p)` | Załomy linii dachu nad ścianą – s: kalenica i linie załamania bocznego zadaszenia; dach jednospadowy – []. |
| 80 | `zasieg(w, z0, p)` | Zasięg [s0, s1] wieńca o spodzie z0 pod linią dachu (najniższy kawałek jak w szczycie); nil – cały nad dachem. |
| 86 | `skosy(w, s0, s1, z0, h, p)` | Skosy kawałka bala s0…s1 (spód z0, wysokość h) pod linią dachu; [] gdy mieści się pod połacią. |

### rdzen/podbitka.rb (415 wierszy)

podbitka – boazeria widoczna od spodu pod albo na płatwiach (deski wzdłuż spadku), pod albo na krokwiach (deski równolegle do okapu); wybór zależny od układu dachu; co robi aplikacja do dachów (nadbitka KROKU 2); obniżenie linii, pod którą kończą się ściany pod połacią.

Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia, płatwie, kąt, jednospadowy), rdzen/elementy.rb, rdzen/wience.rb (góra ściany okapowej)
Używają: rdzen/projekt.rb (belki – elementy Pb), rdzen/pod_dachem.rb i rdzen/szczyty.rb (obniżenie linii pod podbitką), rdzen/krok2.rb (podbitka jako nadbitka KROKU 2)

| Wiersz | Element | Opis |
|---:|---|---|
| 31 | `module Podbitka` |  |
| 36 | `rodzaj(p)` | Rodzaj podbitki dopuszczalny przy układzie dachu: 'pod_platwiami', 'na_platwiach', 'pod_krokwiami', 'na_krokwiach' albo 'nie'. |
| 45 | `przez_aplikacje?(p)` | Czy podbitkę robi aplikacja do dachów jako nadbitkę (pierwszą warstwę poszycia KROKU 2): krokwie i poszycie z aplikacji, podbitka na krokwiach albo na samych płatwiach (bez krokwi). |
| 52 | `uwaga(p)` | Uwaga, gdy wybrana podbitka nie pasuje do układu dachu (nil – pasuje). |
| 60 | `obnizenie(p)` | O ile niżej od linii podparcia kończą się ściany pod połacią [mm]: grubość podbitki w pionie (pod krokwiami) albo wysokość płatwi + grubość w pionie (pod płatwiami); bez podbitki i podbitka „na” – 0. |
| 73 | `obnizenie_wegla(kf, p)` | płatwiami – taki węgieł dochodzi do połaci (jak ściana), żeby styk w najwyższych wieńcach też był w zamku (decyzja użytkownika z 2026-11-26: „jak dotąd były tam zamki … bez zamka będzie to uciekać przy montażu i skręcać się”); deski podbitki dochodzą wtedy do węgła (wegly_do_polaci, bez_wegla). |
| 78 | `wegiel_do_polaci?(kf)` | Czy w węgle kf łączą się bale ściany (styk parzysty albo nieparzysty w jego osi). |
| 90 | `dzialowa_do_polaci!(w, p)` | (pół wieńca pod jej górą), żeby styk najwyższego wieńca też był w zamku (zasada „styk zawsze w zamku”, runda 17; wcześniej działowa kończyła się pod deskami, wieniec lub dwa niżej). Ustawia w[:do_polaci] = [{ s:, z: }] (s – miejsce ściany okapowej na osi działowej, z – wysokość, do której działowa sięga przy tej ścianie). |
| 110 | `linia_dzialowej(w, s, pod, zal, p)` | Linia, pod którą kończy się działowa pod połacią, w miejscu s [mm]: spód podbitki (linia podparcia pod − obnizenie), a przy ścianie okapowej ze stykiem na działowej (w[:do_polaci]) – nie niżej niż z tej ściany, ale nie wyżej niż połać. Strona kalenicy: zal – załomy linii dachu nad działową (puste – najbliższa ściana). |
| 125 | `dzialowe_do_polaci(dom, sciany, p)` | Działowe sięgające przy ścianie okapowej ponad podbitkę (w[:do_polaci]): obrys w rzucie jak węgieł – [{ u: [lo, hi], v: [lo, hi] }] od końca działowej do miejsca, w którym spód podbitki dochodzi do jej wierzchu. |
| 152 | `pod_spodem_platwi(p)` | Grubość podbitki w pionie pod spodem płatwi [mm] (podbitka pod płatwiami; inaczej 0) – węgły pod płatwią kończą się pod deskami (rdzen/wegly_konstrukcyjne.rb). |
| 157 | `wysokosc_platwi(p)` | Wysokość płatwi pośredniej (spód płatwi wyznacza płaszczyznę podbitki). |
| 162 | `elementy(dom, p, sciany)` | Deski podbitki (elementy Pb) domu prostokątnego; sciany – do działowych wzdłuż kalenicy. |
| 184 | `pola_u(dom, p)` | Pola wzdłuż kalenicy: [[u0, u1]] między licami wewnętrznymi szczytów. |
| 191 | `spadki(geo, p)` | Spadki w poprzek: [[v0, v1]] od lica wewnętrznego ściany okapowej (v0) w górę do kalenicy albo do ściany wysokiej (v1). |
| 202 | `dzialowe_wzdluz(dom, sciany, p)` | Działowe wzdłuż kalenicy (kierunek A) – przedziały v zajęte przez ich grubość: [[lo, hi]]. |
| 210 | `wegly_do_polaci(dom, sciany, p)` | Węgły, które przechodzą przez płaszczyznę podbitki pod płatwiami (łączą się w nich bale ściany – obnizenie_wegla): obrys w rzucie [{ u: [lo, hi] (wzdłuż kalenicy), v: [lo, hi] (w poprzek) }] – długość z ostatkami × grubość. |
| 226 | `bez_wegla(xa, xb, ua, ub, wegly, luz)` | Kawałki deski xa…xb (wzdłuż spadku, pas ua…ub) bez miejsc zajętych przez węgły, które przechodzą przez podbitkę (luz – odstęp w rzucie z każdej strony węgła: 2 mm i cofnięcie skośnego czoła deski): [[x0, x1]] w kierunku deski; bez takiego węgła – cała deska. |
| 232 | `odcinki(v0, v1, zajete)` | Odcinki v0…v1 (w dowolnej kolejności) bez przedziałów zajętych: [[a, b]] w kierunku od v0 do v1. |
| 245 | `pod_platwiami(dom, geo, p, u0, u1, v0, v1, przerwy, wegly = [])` | Pod płatwiami: deski wzdłuż spadku na odcinkach v (bez działowych), kolejne w u co krycie (ostatnia węższa), podzielone na osiach płatwi, gdy dłuższe niż długość handlowa; przerwane na węgle, który przechodzi przez podbitkę. |
| 273 | `na_platwiach(dom, geo, p, u0, u1, v0, v1)` | Na płatwiach: deski wzdłuż spadku spodem na linii podparcia (wierzch płatwi), od lica ściany okapowej do kalenicy (ściany wysokiej), kolejne w u co krycie, podzielone na osiach płatwi, gdy dłuższe niż długość handlowa. |
| 298 | `na_krokwiach(dom, geo, p, u0, u1, v0, v1)` | Na krokwiach: deski wzdłuż okapu spodem na wierzchu krokwi, od lica ściany okapowej w górę spadku co krycie (ostatnia węższa); dłuższe niż długość handlowa – dzielone równo. |
| 320 | `deska_ukosna(dom, q, d, a, dl, b, g, z)` | Deska wzdłuż spadku: belka ukośna o szerokości b (wzdłuż u od punktu q), początek spodu na wysokości z. |
| 331 | `kawalki(va, vb, osie, lmax)` | Podział odcinka va…vb (rzut) na kawałki nie dłuższe niż lmax (w rzucie), na osiach płatwi; bez płatwi – równo. |
| 350 | `pasy(u0, u1, kr)` | Pasy szerokości krycia od u0 do u1 (ostatni węższy; szerokość w dół do 0,1 mm – wymiar deski z piły). |
| 362 | `pod_krokwiami(dom, geo, p, u0, u1, v0, v1, przerwy)` | Pod krokwiami: pasy między płatwiami (i działowymi) wzdłuż spadku, w nich deski wzdłuż okapu, kolejne w górę spadku co krycie (ostatnia węższa); dłuższe niż długość handlowa – dzielone równo. |
| 391 | `deska_wzdluz(dom, geo, p, u0, u1, vs, kier, a, szer, g, nad = nil)` | Deska wzdłuż okapu u0…u1, dolna krawędź w vs (rzut), szerokość szer w górę spadku; wierzch na spodzie krokwi albo (nad – wysokość płaszczyzny nad linią podparcia) spód na wierzchu krokwi. |

### rdzen/podciagi.rb (176 wierszy)

podciągi pod legarami – położenia w przęsłach (automatycznie, co najwyżej rozstaw, w liniach fundamentów albo bez podciągów), belki do lica zewnętrznego podwalin pod podwalinami, sprawdzenie podciągu między fundamentami.

Zależy od: rdzen/parametry.rb, rdzen/statyka.rb, rdzen/elementy.rb, rdzen/fundamenty.rb (linie i rzędy), rdzen/podloga_przybudowki.rb (pole podłogi bez przybudówki)
Używają: rdzen/podloga.rb (dobór legara, elementy, podpowiedzi)

| Wiersz | Element | Opis |
|---:|---|---|
| 28 | `module Podciagi` |  |
| 31 | `OPARCIE` | Zapas oparcia doliczany do światła przęsła w obliczeniach [mm] (jak w rdzen/podloga.rb). |
| 34 | `ZAPAS` | Nośność wykorzystana od tylu w górę (0,9 = 90 %) to „bez zapasu” – podpowiedź z poziomem „uwaga” zamiast „ok” (rozstrzygnięcie użytkownika z 2026-11-14). |
| 39 | `w_liniach_fundamentow?(p)` | Czy podciągi mają stałe położenia w liniach fundamentów. |
| 44 | `stale(u, p, przesla)` | Stałe położenia (linie fundamentów) w przęsłach: [[d]] – linie wewnątrz przęsła, dalej niż 100 mm od jego lic. |
| 50 | `polozenia(u, p, przesla, lmax)` | Położenia w przęsłach dla legara o największej rozpiętości lmax: [[d]] albo nil (legar nie da rady). |
| 64 | `liczba(l, lmax, p)` | Liczba podciągów w przęśle długości l przy największej rozpiętości lmax legara; nil – nie da się. |
| 77 | `luka(przesla, poz)` | Największa luka legara (między licem podwaliny a podciągiem albo między podciągami) [mm]. |
| 85 | `rowno?(p)` | Czy podciąg na równo z podwaliną (między podwalinami, legary dzielone na nim). |
| 90 | `z_wierzchu(u, h_legara, p = {})` | Wierzch podciągu [mm]: obniżony – spód wyższego z legara i podwaliny (pod podwalinami); na równo – 0 (wierzch podwalin). |
| 97 | `elementy(u, p, poz, h_legara)` | Belki podciągów (Pd) w liniach d w poprzek legarów: obniżony – od lica do lica obrysu; na równo – między licami wewnętrznymi podwalin, przerwany na podwalinach działowych wzdłuż legarów; punkt – blok (d, e) → rzut. |
| 108 | `odcinki(u, p, d, e0, e1)` | Odcinki podciągu w linii d: obniżony – cały obrys; na równo – między podwalinami (zewnętrznymi i działowymi wzdłuż legarów, które linia przecina). |
| 119 | `podpowiedzi(u, p, poz, h_legara, przesla)` | Podpowiedzi o podciągach: liczba, odstęp od legarów (podwalina wyższa), sprawdzenie między fundamentami. |
| 137 | `na_styk?(s)` | Czy belka o wyniku s (Statyka.belka) wystarcza bez zapasu: nośność wykorzystana od ZAPAS w górę. |
| 143 | `sprawdzenie(u, p, poz, przesla)` | Sprawdzenie najbardziej obciążonego podciągu: rozpiętość między fundamentami (rzędy e), szerokość zbierania (połowa luk po obu stronach). |

### rdzen/podloga.rb (377 wierszy)

podłoga domu prostokątnego – podwaliny pod ścianami (zakład albo styk na śruby w narożnikach), legary między podwalinami, dobór przekroju legara i podpowiedzi; podciągi i fundamenty punktowe w osobnych plikach.

Zależy od: rdzen/parametry.rb, rdzen/geometria.rb, rdzen/statyka.rb, rdzen/elementy.rb, rdzen/podciagi.rb (położenia i belki podciągów), rdzen/fundamenty.rb, rdzen/podloga_przybudowki.rb (pole legarów bez przybudówki)
Używają: rdzen/projekt.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 26 | `module Podloga` |  |
| 29 | `OPARCIE` | Zapas oparcia doliczany do światła przęsła w obliczeniach [mm]. |
| 34 | `zaplanuj(sciany, p)` | Podłoga: { elementy: [...], podpowiedzi: [{ poziom: 'ok' \| 'uwaga' \| 'blad', tekst: }], legar: [b, h] \| nil }. |
| 56 | `fundamenty(u, p, poz, h_legara, wynik)` | Fundamenty punktowe (rdzen/fundamenty.rb): stopy pod podwalinami, podciągami i podwalinami działowych; podpowiedź. |
| 77 | `uklad(sciany, p)` | Układ podłogi: kierunek legarów (id – indeks osi wzdłuż legarów), zasięgi (obrys; pole legarów – bez przybudówki bez podłogi), ściany zewnętrzne i działowe z podwalinami. |
| 101 | `podwaliny(u, p)` | Podwaliny: zewnętrzne licem z licem ściany i na zakład w narożnikach, pod działowymi w osi (dosunięte do podwalin). |
| 131 | `odcinki_dzialowej(u, w)` | Odcinki podwaliny działowej [s0, s1] na jej osi: końce przy podwalinach innych ścian, działowe wzdłuż legarów przerwane na podwalinach działowych poprzecznych. |
| 154 | `wzdluz_legarow?(u, w)` | Czy ściana biegnie wzdłuż legarów. |
| 159 | `pelna?(w)` | Czy działowa przechodzi przez całą szerokość domu (oba końce na ścianach zewnętrznych). |
| 167 | `przesla(u)` | Przęsła legarów: [[f1, f2], …] – między licami podwalin prostopadłych do legarów na całej szerokości pola podłogi. |
| 181 | `linie_legarow(u, p)` | Linie legarów (współrzędna e poprzecznie): równo w polach między podwalinami bocznymi i działowymi wzdłuż legarów. |
| 197 | `dobierz(u, p, podp)` | Dobór przekroju legara i liczby podpór w każdym przęśle; [[b, h], [podpory w przęsłach]] albo [nil, nil]. |
| 224 | `wybierz(u, p, sekcje, zakresy, rozstaw, gr)` | Najlepszy przekrój z listy sekcje i położenia podciągów: [[b, h], [[d]], ocena] albo nil (żaden nie da rady). |
| 242 | `zageszczone(u, p, sekcje, zakresy, rozstaw, gr, podp)` | Legar nie przenosi rozpiętości między liniami fundamentów: rzędy pod podciągami zagęszczane co 100 mm (najmniej 800), aż przekrój da radę (u[:rozstaw_d] – rozstaw rzędów wzdłuż legarów); podpowiedź o dodatkowym rzędzie. |
| 261 | `brak_przekroju(u, p, bh, zakresy, rozstaw, gr)` | Błąd doboru: legar (ostatni sprawdzany) nie przenosi rozpiętości – co zrobić zależnie od podciągów i fundamentów. |
| 279 | `objetosc(u, p, bh, przes, n)` | Objętość drewna legarów i podpór [m³] – kryterium wyboru między większym przekrojem a podporami. |
| 290 | `podpowiedzi(u, p, bh, zakresy, poz, podp)` | Podpowiedzi do okna: ocena legara, przekroje najmniejszy i zalecany, izolacja, wysokość podwaliny, podpory. |
| 328 | `bez_podciagow(lmax, min, zal)` | Zdanie „co by było bez podciągów” (rozpiętość lmax, przekrój najmniejszy i zalecany z listy albo nil): tryb przypuszczający – podciągi są, to tylko porównanie (uwaga użytkownika z 2026-11-14: czytało się jak stan faktyczny). |
| 339 | `legary(u, p, bh, podciagi = [])` | Legary: każda linia dzielona na licach podwalin poprzecznych (także działowych częściowych) i podciągów na równo z podwaliną (podciagi – ich osie d), omija podwaliny wzdłuż. |
| 372 | `punkt(u, d, e)` | Punkt rzutu z (d wzdłuż legarów, e w poprzek). |

### rdzen/podloga_przybudowki.rb (85 wierszy)

podłoga w przybudówce z bali do wyboru – bez podłogi legary i podciągi tylko w domu (pole podłogi kończy się na podwalinie dawnej ściany okapowej), podwaliny i fundamenty także pod ścianami przybudówki; dawna ściana okapowa zawsze na podwalinie.

Zależy od: rdzen/parametry.rb
Używają: rdzen/podloga.rb (pole legarów, przęsła, linie legarów), rdzen/podciagi.rb (zasięg podciągów), rdzen/fundamenty.rb (stopy pod podciągami tylko w polu podłogi), rdzen/projekt.rb (podpowiedź w zakładce zadaszenia)

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `module PodlogaPrzybudowki` |  |
| 25 | `sciana_domu?(w)` | Czy ściana to dawna ściana okapowa domu przy przybudówce (zawsze na podwalinie – niesie dom). |
| 30 | `bez_podlogi?(sciany, p)` | Czy przybudówka jest bez podłogi (przybudówka z bali, zadaszenie_podloga = nie, podłoga domu włączona). |
| 36 | `ogranicz!(u, sciany, p)` | Ograniczenie pola podłogi do domu (u z rdzen/podloga.rb#uklad): u[:pole] i u[:dzialowe_pola]; bez zmian, gdy przybudówka ma podłogę albo jej nie ma. |
| 56 | `pole(u)` | Zasięg legarów i podciągów: [[x0, x1], [y0, y1]] (bez ograniczenia – obrys). |
| 61 | `dzialowe_pola(u)` | Działowe dzielące pole podłogi (przęsła i linie legarów). |
| 66 | `w_polu?(u, k, x)` | Czy współrzędna x w kierunku k leży w polu podłogi (z zapasem 1 mm). |
| 72 | `podpowiedzi(sciany, p)` | Podpowiedź do zakładki zadaszenia: przybudówka z podłogą albo bez ([{ poziom:, tekst: }]). |

### rdzen/podpory_platwi_l.rb (108 wierszy)

podparcie końców płatwi skrzydła bocznego domu L w dachu głównym – koniec przy płatwi dachu głównego (styk z łącznikiem ciesielskim) albo w koszu: słupek na niższej płatwi dachu głównego, nad którą płatew skrzydła przechodzi najbliżej swojego końca.

Zależy od: rdzen/parametry.rb, rdzen/dach.rb (płatwie, xy), rdzen/skrzydla.rb (domy skrzydeł, zasięg i koniec płatwi skrzydła), rdzen/elementy.rb (element pionowy)
Używają: rdzen/projekt.rb (belki – słupki), rdzen/materialy.rb (łączniki płatwi), rdzen/statyka_dachu.rb (przęsło płatwi skrzydła do słupka)

| Wiersz | Element | Opis |
|---:|---|---|
| 29 | `module PodporyPlatwiL` |  |
| 31 | `MIN_SLUPEK` | Najniższy słupek [mm]; mniejszy odstęp – płatew skrzydła leży na płatwi głównej (podkładka). |
| 32 | `EPS` |  |
| 38 | `oblicz(dom, p)` | Podpory końców płatwi skrzydła bocznego (opis wyniku w nagłówku); dom prostokątny, bez płatwi albo platwie_kosz = nie – pusty wynik. |
| 58 | `przy_licu?(glowne, pl, k, kier)` | Czy koniec k płatwi skrzydła pl leży przy licu płatwi dachu głównego, z którą zachodzi na siebie wysokością (styk). |
| 66 | `podeprzyj(wynik, d, pl, glowne, k, p)` | Podpora końca w koszu: najbliższa końcowi płatew dachu główna pod płatwią skrzydła – słupek albo oparcie; brak – bez_podpory. |
| 90 | `slupek(d, pl, pod, z0, wys)` | Słupek w osi płatwi skrzydła (v = pl[:v]) nad osią płatwi głównej (u = pod[:v]), od z0 w górę o wys. |
| 101 | `uwagi(wynik)` | Ostrzeżenia i podpowiedzi o końcach płatwi skrzydła: bez podpory (gdy są). |

### rdzen/podzial_belek.rb (88 wierszy)

belki dłuższe niż najdłuższa handlowa ich przekroju (magazyn drewna) dzielone w modelu nad podporą – płatwie dachu łączone na styk w osi ściany, przez którą przechodzą (szczyt, działowa, węgieł); kawałki z wrębami przeniesionymi, osobne pozycje w zestawieniu.

Zależy od: rdzen/parametry.rb (dlugosci_katalogu – magazyn drewna), rdzen/dlugosci_handlowe.rb (TOL)
Używają: rdzen/projekt.rb (belki – przed podpowiedziami o długościach), rdzen/dach.rb (e[:podpory] – osie ścian wzdłuż płatwi)

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `module PodzialBelek` |  |
| 25 | `MIN_KAWALEK` | Najkrótszy kawałek po podziale [mm] – podpora bliżej końca nie jest miejscem styku. |
| 30 | `podziel!(elementy, p)` | Podział płatwi dachu w liście elementów (w miejscu); zwraca liczbę styków. |
| 48 | `miejsca(dl, xs, lmax)` | Miejsca styków wzdłuż belki długości dl z podporami xs przy najdłuższej handlowej lmax: zachłannie najdalsza podpora w zasięgu; [] – nie da się (belka zostaje w całości). |
| 62 | `opis(n)` | Zdanie do wyników: ile styków płatwi nad ścianami (odmiana: 1 styk, 2–4 styki, 5 styków). |
| 73 | `kawalki(e, ciecia)` | Kawałki belki e przecięte w miejscach ciecia (x wzdłuż belki): położenie przesunięte wzdłuż osi, wręby przycięte i przesunięte do kawałka. |

### rdzen/pol_zamka.rb (135 wierszy)

pół zamka w ostatnim połączeniu pod dachem – ostatni bal (ścięty skosem albo płaszczyzną dachu) przechodzi przez zamek bez gniazda od spodu, a bal pod nim dostaje gniazdo do połowy wysokości; dzięki temu koniec ostatniego bala nie odpada. Narożnik, góra węgła, ściana nad węgłem i nad działową.

Zależy od: rdzen/parametry.rb
Używają: rdzen/skos_przy_narozniku.rb (bal zostaje w narożniku), rdzen/zamek.rb (ostatnie połączenia, głębokości gniazd w półzamku), rdzen/bale.rb (ostatni bal węgła od zamek_min_drewno pod dachem), testy/losowe_domy.rb (bal w narożniku bez gniazda)

| Wiersz | Element | Opis |
|---:|---|---|
| 32 | `module PolZamka` |  |
| 36 | `wlaczony?(p)` | Czy pół zamka jest włączone. |
| 41 | `gniazdo_nizszego(p)` | Głębokość gniazda w balu niższym [mm]: polzamek_gleb albo (0) do połowy bala = 2 × gniazdo_gleb. |
| 48 | `gniazdo_wyzszego(p)` | Głębokość gniazda od spodu bala wyższego [mm] – reszta do sumy gniazd zwykłego zamka (0 – bez gniazda). |
| 54 | `miesci_sie?(gora, p)` | Czy bal o wierzchu gora [mm od spodu, najniżej w krawędziach gniazda] zmieści pół zamka: nad gniazdem od spodu (zwykle zerowym) zostaje co najmniej zamek_min_drewno. |
| 60 | `min_wysokosc(p)` | Najmniejsza wysokość pod dachem [mm nad spodem], od której ostatni bal (nic na nim nie leży) wchodzi w zamek: z pół zamkiem – reszta gniazda od spodu + zamek_min_drewno (20), bez – zwykłe gniazdo + zamek_min_drewno (56). |
| 66 | `wierzch(b, x, ktory = :min)` | Wierzch bala [mm od spodu] w miejscu x (wzdłuż bala): pełna wysokość, skos dachu wzdłuż bala (skos_gora) albo ścięcie płaszczyzną dachu w poprzek (sciecie_dachu); ktory = :min – na niższym licu, :max – na wyższym. |
| 82 | `wierzch_w_pasie(b, c, szer, ktory)` | Najniższy (:min) albo najwyższy (:max) wierzch bala w pasie szerokości szer wokół osi zamka c (współrzędna s ściany bala); nil – bal nie sięga pasa. |
| 90 | `siega?(a, ca, b, p)` | Czy bal a (oś zamka ca) sięga bala b leżącego poziom wyżej: wierzch bala a w słupie zamka jest ponad spodem bala b. |
| 100 | `ostatnie?(nizszy, wyzszy, cw, nad, pod, p)` | żaden bal nie wycina mu gniazda od wierzchu (nad – bale ściany bala niższego w słupie zamka), a balowi niższemu po gnieździe do połowy zostaje dość drewna (pod – bale ściany bala wyższego w słupie zamka: bal poziom pod niższym wycina mu gniazdo od spodu). |
| 119 | `oznacz!(b, c)` | Oznacza bal b jako bal wyższy półzamka w osi c (współrzędna s jego ściany). |
| 125 | `w_osi?(b, c)` | Czy bal b jest balem wyższym półzamka w osi c. |
| 130 | `zamek_z_gniazdem(z, gleb)` | Opis zamka (jak p['zamek']) z inną głębokością gniazda – do obróbek w rdzen/zamek.rb. |

### rdzen/polacie.rb (191 wierszy)

połacie dachu dla aplikacji do dachów – obrys, wysokość, kąt, okap i krawędzie szczytowe tak, żeby płaszczyzna połaci leżała na wierzchu płatwi generatora (spód krokwi albo spód poszycia na samych płatwiach).

Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia, lico okapu, opis bocznego zadaszenia), rdzen/dach_jednospadowy.rb (ściana niska i wysoka), rdzen/krok2.rb (podpowiedź KROKU 2)
Używają: rdzen/projekt.rb (plan[:polacie], podpowiedzi), sketchup/dach_aplikacja.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 26 | `module Polacie` |  |
| 28 | `MIN_DLUGOSC` | Najmniejsza długość obrysu połaci wzdłuż kalenicy przed odsunięciem okapu [mm]. |
| 30 | `USKOK` | Najmniejszy uskok obrysu między częścią szczytową a okapową jednej ściany domu L [mm]. |
| 35 | `z_aplikacji?(p)` | Czy krokwie i poszycie buduje aplikacja do dachów (dach_wiezba = aplikacja; każdy układ dachu). |
| 43 | `dla_domu(dom, p)` | { punkty: [[x, y]] (mm układu domu, przeciwnie do wskazówek zegara), z: (wysokość obrysu), kat: (°), okap: (mm), szczyty: [numery krawędzi szczytowych od 1 – krawędź i: punkt i → i + 1, jak w aplikacji] }; nil – bez połaci (krokwie z generatora, bez belek dachu, obrys nieprostokątny). |
| 68 | `zalamania(punkty, iv, geo, okapy, p)` | Załamania połaci dla aplikacji do dachów (boczne zadaszenie, rdzen/zadaszenie.rb – geo[:zad]): { nr krawędzi okapowej => { od: (linia załamania od krawędzi na zewnątrz), szerokosc: (do lica podpory), okap:, kat: } } – opcja :zalamania API.polacie (aplikacja 3.12). |
| 90 | `dla_domu_l(dom, p)` | długości: krawędź podzielona na linii okapu dachu głównego, część szczytowa wysunięta dalej niż okapowa (co najmniej o USKOK) – krótka krawędź uskoku jest okapem tylnej połaci dachu głównego, bez niej aplikacja do dachów zrobiłaby w tym miejscu naroże kopertowe zamiast szczytu i kosza. |
| 134 | `normalna(a, b)` | Normalna zewnętrzna krawędzi a → b obrysu przeciwnego do wskazówek zegara (w prawo od kierunku). |
| 143 | `v_gora(geo, p)` | Krawędź obrysu po stronie ściany wysokiej (dach jednospadowy) – v: lico zewnętrzne przesunięte o (okap za ścianą wysoką − okap), żeby po odsunięciu okapu połać kończyła się w odległości dach_okap_wysoki od lica. |
| 151 | `szczytowe(punkty, iv, okapy)` | Numery krawędzi szczytowych (od 1): wszystkie poza okapowymi – krawędzie o stałym v (indeks iv) równym jednemu z okapy (dwuspadowy – obie, jednospadowy – tylko po stronie ściany niskiej). |
| 161 | `podpowiedzi(dom, p, polacie)` | Podpowiedzi do okna o dachu z aplikacji ([{ poziom:, tekst: }]); pusta lista, gdy krokwie robi generator. |
| 171 | `uwagi_l(dom, p)` | Uwagi do połaci domu L: wysunięcie za szczyt mniejsze niż okap – na ścianie ze szczytem na części długości dach wystaje za szczyt o okap (część szczytowa obrysu musi być wysunięta dalej niż okapowa). |
| 181 | `pole(punkty)` | Pole wielokąta ze znakiem (dodatnie – przeciwnie do wskazówek zegara). |

### rdzen/powierzchnie.rb (216 wierszy)

powierzchnie i wysokość domu – powierzchnia zabudowy (po licach zewnętrznych), pomieszczeń (po licach wewnętrznych ścian), tarasu i dachu, wysokość kalenicy nad terenem, limity użytkownika z ostrzeżeniem, rodzaj obrysu.

Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia), rdzen/materialy.rb (powierzchnia połaci), rdzen/podbitka.rb
Używają: rdzen/projekt.rb (plan[:powierzchnie], ostrzeżenia limitów), sketchup/sterowanie.rb (wynik do okna), rdzen/zestawienie.rb (blok w pliku CSV)

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `module Powierzchnie` |  |
| 23 | `MIN_POMIESZCZENIE` | Obszar mniejszy niż tyle [m²] nie jest pomieszczeniem (szczelina między ścianami). |
| 29 | `licz(plan)` | Powierzchnie i wysokość domu z planu: { zabudowa:, taras:, pomieszczenia: [{ nazwa:, m2:, a:, b: }], uzytkowa:, dach:, kalenica: (mm nad spodem pierwszego bala albo nil), wysokosc: (mm nad terenem), rodzaj_obrysu: } – m² z dwoma miejscami. |
| 48 | `m2(mm2)` | mm² → m² z dwoma miejscami po przecinku. |
| 53 | `pole(pts)` | Pole wielokąta [mm²] (wzór Gaussa; wynik dodatni). |
| 63 | `rodzaj_obrysu(obrys)` | Rodzaj obrysu: 'prostokat' (4 naroża), 'l' (6 naroży) albo 'inny' – naroża bez punktów leżących na prostej. |
| 76 | `w_wielokacie?(pts, x, y)` | Czy punkt (x, y) leży wewnątrz wielokąta (promień w prawo). |
| 88 | `prostokaty_scian(plan)` | Prostokąty ścian w rzucie (bez węgłów i bez ostatków za skrzyżowaniem): [[x0, y0, x1, y1]] – oś ściany między jej końcami, grubość bala. |
| 102 | `obszary(plan)` | Wolne obszary rzutu (pomieszczenia i taras), od największego: [{ mm2:, a:, b: (wymiary prostokąta opisanego), prostokat: (obszar jest prostokątem), taras: }]. |
| 134 | `zalej(wolne, start)` | Pola połączone bokami z polem startowym (usuwane ze zbioru wolnych): [[i, j]]. |
| 150 | `na_tarasie?(taras, punkt)` | Czy punkt leży w pasie tarasu (między ścianą frontową domu a frontem tarasu – rdzen/taras.rb). |
| 159 | `kalenica(plan)` | Wierzch konstrukcji dachu w najwyższym miejscu [mm nad spodem pierwszego bala]: linia podparcia w kalenicy (dach jednospadowy – na końcu okapu za ścianą wysoką) + krokwie + warstwy poszycia; dom bez szczytów – nil. |
| 179 | `uwagi(pw, p)` | Limity użytkownika: { ostrzezenia: [teksty], podpowiedzi: [{ poziom:, tekst:, sekcja: }] } – przekroczony limit to ostrzeżenie, dotrzymany – pozycja „sprawdzone”; limit 0 – bez sprawdzania. |
| 196 | `liczba(v)` | Liczba z przecinkiem dziesiętnym, do dwóch miejsc, bez zbędnych zer. |
| 201 | `wiersze(pw)` | Wiersze do okna i pliku zestawienia: [[nazwa, wartość, jednostka, uwagi]]. |

### rdzen/poziomy.rb (98 wierszy)

trzy poziomy ustawień (Ten dom, Typ domu, Standard warsztatu) i kroki okna w kolejności budowy – które pole należy do którego poziomu i kroku, złożenie parametrów nowego domu ze standardu i typu, pola zmienione tylko w tym domu.

Zależy od: rdzen/parametry.rb, rdzen/parametry_lista.rb (cecha poziom: przy każdym polu)
Używają: sketchup/ustawienia.rb (standard), sketchup/typy_domow.rb (typy), sketchup/sterowanie.rb (start nowego domu), sketchup/okno.rb (opisy pól, kroki)

| Wiersz | Element | Opis |
|---:|---|---|
| 20 | `module Poziomy` |  |
| 22 | `POZIOMY` | Poziomy w kolejności okna: [klucz, nazwa, kiedy się je zmienia]. |
| 29 | `KROKI` | Kroki okna w kolejności budowy: [klucz, tytuł, sekcje parametrów kroku]. |
| 41 | `poziom(klucz)` | Poziom pola ('dom' \| 'typ' \| 'standard'); pole spoza listy – 'standard'. |
| 47 | `klucze(*poziomy)` | Klucze pól podanych poziomów w kolejności okna. |
| 52 | `krok_sekcji(sekcja)` | Krok okna, do którego należy sekcja parametrów (nieznana sekcja – pierwszy krok). |
| 58 | `krok(klucz)` | Krok okna pola o podanym kluczu. |
| 64 | `wybierz(parametry, *poziomy)` | Tylko pola podanych poziomów z zestawu parametrów (klucze tekstowe; reszta pominięta). |
| 73 | `zloz(standard, typ)` | Parametry nowego domu do okna: standard warsztatu (pola poziomu „Standard warsztatu” i wymiary zamka) uzupełniony polami typu (poziomy „Typ domu” i „Ten dom”); to, czego nie ma w żadnym z nich – wartości fabryczne (Parametry.normalizuj). |
| 82 | `rozne(parametry, baza)` | Klucze pól, których wartość w zestawie parametry jest inna niż w zestawie baza (oba sprawdzone przez Parametry.normalizuj – „20” i 20.0 to ta sama wartość); z wymiarami zamka – klucz 'zamek'. |
| 91 | `zmienione_w_domu(parametry, baza)` | Pola zmienione tylko w tym domu: różne od bazy (standard ← typ) – { 'dom' => [klucze], 'typ' => […], 'standard' => […] }. |

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

### rdzen/profil_bala.rb (153 wierszy)

pełny profil bala do wizualizacji – pióra na wierzchu i wpust od spodu (pierwszy wieniec bez wpustu); przekrój pasami wzdłuż grubości, objętość.

Zależy od: rdzen/parametry.rb, rdzen/bryla.rb (punkty podziału, przecięcia ograniczeń, wartości)
Używają: rdzen/projekt.rb (siatka i objętość pozycji, oznaczenie bali bez wpustu), rdzen/pozycje.rb (opis profilu w pozycji), rdzen/siatka.rb (pasy)

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `module ProfilBala` |  |
| 24 | `EPS` |  |
| 27 | `WYROWNAJ` | Wierzchy / spody pasów bliższe niż tyle [mm] na końcu przedziału są wyrównywane do niższego – inaczej skos zaczynający się tuż nad wierzchem bala (0,06 mm) dałby krawędź krótszą niż tolerancja SketchUpa. |
| 32 | `pelny?(p)` | Czy model ma pełny profil bala. |
| 37 | `opis(p)` | Opis profilu z parametrów (pióra i wpusty w poprzek bala); nil – bal prosty. |
| 49 | `oznacz(bale, p)` | Bale na spodzie domu (pierwszy wieniec, półbal) bez wpustu – cecha 'bez_wpustu' (inna pozycja niż bal z wpustem). |
| 58 | `pasy_przekroju(t, opis, bez_wpustu, bez_piora = false)` | Pasy przekroju: [[y0, y1, nadwyżka wierzchu (pióro), podniesienie spodu (wpust)]] od lica prawego. |
| 71 | `przedzialy(dl, t, h, cechy, opis)` | Przedziały pełnego profilu bala dl × t × h z obróbkami (cechy jak Bryla.profil) – patrz opis pliku. |
| 112 | `przedzial(xa, xb, t, pasy, boki)` | Jeden przedział xa…xb: pasy z wierzchem i spodem (ograniczenia pasa w środku przedziału), zwężone podcięciami. |
| 135 | `wyrownaj!(pasy, klucz)` | Wyrównanie wartości (wierzchów albo spodów na jednym końcu) różnych o mniej niż WYROWNAJ – do najniższej z grupy. |
| 144 | `objetosc(prof)` | Objętość przedziałów (pełny profil albo prosty – Bryla.profil) [mm³]. |

### rdzen/projekt.rb (264 wierszy)

przebieg obliczeń domu od linii do listy bali i belek (kolejność kroków) i podsumowanie do okna – bez API SketchUpa.

Zależy od: wszystkie pliki rdzen/
Używają: sketchup/sterowanie.rb, testy

| Wiersz | Element | Opis |
|---:|---|---|
| 30 | `module Projekt` |  |
| 34 | `PRZEBIEGI_DOBORU` | Najwięcej dodatkowych przebiegów przy automatycznym doborze przekrojów. |
| 43 | `oblicz(wejscie)` | geometrii nie wystarczały – jeszcze raz z większymi. Nieprzewidziany wyjątek obliczeń nie wychodzi na zewnątrz: plan z jednym błędem po polsku (plan[:wyjatek] – opis techniczny), pełny ślad w dzienniku (rdzen/awaria.rb; decyzja użytkownika z 2026-11-14). |
| 61 | `przebieg(wejscie, nadpis, tryb)` | dopełnienie nad niższymi działowymi → gniazda płatwi → bale → balustrada tarasu → bale ścięte dachem przy narożnikach → bale ścięte do płaszczyzny dachu w poprzek → zamki → pozycje → belki dachu, słupy tarasu i podłoga. nadpis – przekroje płatwi dobrane w poprzednim przebiegu (zastępują pola), tryb – tryb doboru (StatykaDachu.sprawdz). |
| 136 | `podpory_l(plan, dom, p)` | Podpory końców płatwi skrzydła bocznego domu L (rdzen/podpory_platwi_l.rb): słupki w elementach, wynik w planie (łączniki do zestawienia), podpory w skrzydle (przęsło w statyce płatwi), ostrzeżenie o końcach bez podpory. |
| 148 | `belki(plan, dom, p, tryb = :pierwszy)` | (szczyty, podloga, taras – pokazywane przy parametrach); połacie dla aplikacji do dachów (plan[:polacie]); sprawdzenie płatwi, krokwi, zadaszenia i trójkąta nad tarasem, przekroje dobrane do następnego przebiegu (plan[:dobor_przekrojow], tryb – StatykaDachu.sprawdz). |
| 188 | `uwagi_o_stykach(plan)` | Ostrzeżenia o stykach, których nie trzyma zamek (wieńce szczytu nad węgłem, który kończy się pod połacią). |
| 196 | `podsumowanie(plan)` | Podsumowanie do okna: ściany, liczby bali i pozycji, objętość i waga, wysokości. |
| 222 | `wysokosci(plan)` | Wysokości ścian do okna (Wience.wysokosci) i ściana wysoka dachu jednospadowego (góra jej bali – do połaci). |
| 230 | `wysokosc_ciecia(b)` | O ile górny bal jest niższy po przycięciu wzdłuż (skos płaski na całej długości) [mm]. |
| 236 | `styki_opis(w)` | Styki ściany do okna: [styki wieńców parzystych, nieparzystych] w mm od początku osi (puste – bez styków). |
| 244 | `siatka_pozycji(poz)` | Siatka bryły pozycji (do budowy komponentu): Siatka.z_profilu dla profilu pozycji (pełny profil bala – z piórem i wpustem, gdy pozycja ma opis profilu). |
| 251 | `profil_pozycji(poz)` | Profil bryły pozycji: pełny (rdzen/profil_bala.rb) albo prosty (rdzen/bryla.rb). |
| 257 | `objetosc_pozycji(poz)` | Objętość bryły pozycji [mm³] (pełny albo prosty profil). |

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

### rdzen/przyklady.rb (75 wierszy)

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
| 69 | `dom(nazwa, segmenty, parametry, otwory, sciany = {})` | Przykład: nazwa i wejście domu (sciany – ustawienia ścian z widoku ściany). |

### rdzen/sciana_w_linii.rb (84 wierszy)

działowa narysowana w linii ściany obrysu (np. wzdłuż uskoku domu L) – wspólna oś ze ścianą obrysu i połączenie obu w zamku ściany poprzecznej, bez ostatków wchodzących w siebie.

Zależy od: rdzen/geometria.rb
Używają: rdzen/sciany.rb (dzialowe)

| Wiersz | Element | Opis |
|---:|---|---|
| 20 | `module ScianaWLinii` |  |
| 23 | `ROWNOLEGLE` | Iloczyn wektorowy kierunków jednostkowych, poniżej którego ściany są równoległe. |
| 29 | `konce(l, zewn, zasieg)` | Końce linii działowej l ({ a:, b: }), które leżą w narożniku obrysu w linii jednej z jego ścian: [[koniec (0 \| 1), ściana w linii, ściana poprzeczna], …]. zasieg – odległość końca od boku obrysu [mm]. |
| 42 | `rownolegle?(d, w)` | Czy kierunek d jest równoległy do ściany w. |
| 47 | `przy_boku?(pt, bok, zasieg)` | Czy punkt leży przy boku obrysu (w zasięgu, między jego końcami). |
| 53 | `poza_bokiem?(pt, bok)` | Czy punkt leży za końcem boku obrysu (działowa odchodzi od narożnika, nie biegnie wzdłuż ściany). |
| 59 | `na_osi(l, w_linii)` | Linia działowej przesunięta w poprzek na oś ściany w linii: { a:, b: }. |
| 66 | `na_linii?(a, b, w)` | Czy oś ściany w leży na linii a–b (po przesunięciu działowej na oś pierwszej ściany w linii). |
| 73 | `bez_ostatka!(w, c)` | Koniec ściany obrysu w narożniku c bez ostatka: jej bale kończą się w osi ściany poprzecznej, dalej biegnie działowa (w[:w_linii] – które końce; ostatek tego końca nie do ustawienia w widoku ściany). |

### rdzen/sciany.rb (293 wierszy)

ściany z rozpoznanego obrysu – osie, zasięgi bali z ostatkami, skrzyżowania, kontrfory, kierunek względem kalenicy, numeracja W-n.

Zależy od: rdzen/geometria.rb, rdzen/parametry.rb, rdzen/skrzydla.rb, rdzen/sciana_w_linii.rb
Używają: rdzen/projekt.rb, rdzen/styki.rb (dodaj_kontrfor), rdzen/wience.rb, rdzen/bale.rb, rdzen/zamek.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 25 | `module Sciany` |  |
| 32 | `zbuduj(obrys, p)` | Ściany i skrzyżowania z obrysu: { sciany:, os_kalenicy:, ostrzezenia:, podpowiedzi:, bledy: } (bez numeracji – numeruj!). Podpowiedzi – narożniki wklęsłe (wklesle – ich punkty, zbierane w zewnetrzne). |
| 61 | `os_kalenicy(obrys_pts, wybor)` | Oś kalenicy :x / :y w układzie lokalnym (kierunek ścian okapowych z półbalem). |
| 75 | `zewnetrzne(pts, t, p, licznik, wynik)` | Ściany zewnętrzne: oś = bok obrysu przesunięty do środka o pół grubości, narożniki = przecięcia osi. |
| 103 | `podpowiedz_wklesle(punkty)` | Podpowiedź o narożnikach wklęsłych (punkty bez powtórzeń): ostatki bali wchodzą tam do wnętrza budynku. Decyzja użytkownika (2026-11-14): ostatki zostają – przy balu 44 mm nie ma lepszego rozwiązania – a informacja jest podpowiedzią, nie ostrzeżeniem (przyda się przy grubszym balu). |
| 112 | `dzialowe(linie, zewn, t, p, licznik, wynik, tol)` | Ściany działowe: końce na obrysie = przez ścianę zewnętrzną na zewnątrz o wypust węgła na zewnątrz (jak słupek węgła, runda 9), na innej działowej = połączenie T (ostatek), pozostałe = wolny koniec. |
| 157 | `przy_boku?(pt, bok, zasieg)` | Czy punkt leży na boku obrysu lub w jego pobliżu po stronie ściany (koniec działowej dosunięty do lica). |
| 163 | `sciana(licznik, rodzaj, a, b, d)` | Nowa ściana (bez zasięgu): wspólne pola. |
| 171 | `wyznacz_skrzyzowania(sciany, tol)` | Skrzyżowania wszystkich par ścian prostopadłych, których osie się przecinają (narożniki, T, X). |
| 184 | `polacz(w1, w2, pt)` | Zapis skrzyżowania w obu ścianach (typ: :naroznik, :t, :x, :kontrfor). |
| 193 | `typ_skrzyzowania(w1, s1, w2, s2)` | Rodzaj skrzyżowania z położenia na osiach (koniec osi = 0 lub dl_osi). |
| 203 | `gospodarz_kontrforu(pt, sciany, zasieg)` | Ściana-gospodarz kontrforu: ściana, do której osi punkt jest najbliżej (≤ zasięg); [ściana, s] albo [nil, nil]. |
| 215 | `sprawdz_miejsce_kontrforu(w, s, p)` | Czy kontrfor w miejscu s ściany w nie wchodzi w zamek innego skrzyżowania; tekst błędu albo nil. |
| 226 | `dodaj_kontrfor(sciany, gosp, s, p, zrodlo, os_kalenicy, ostatki = nil)` | Nowy kontrfor (słupek: wypust wewnątrz + grubość + wypust na zewnątrz) w miejscu s ściany-gospodarza; ostatki – { wewn:, zewn: } z wiersza tabeli węgłów (nil – z parametrów); zwraca ścianę kontrforu. |
| 245 | `wypusty_kontrforu(sciany, gosp, c, d, p, ostatki)` | Wypusty kontrforu [na początku osi (−d), na końcu (+d)] [mm]: przy ścianie zewnętrznej strona wewnątrz domu dostaje wypust wewnętrzny, druga – zewnętrzny (wegiel_wypust_wewn / _zewn albo z wiersza tabeli); przy działowej obie strony są wewnątrz, przy ścianie domu przy tarasie strona tarasu jest na zewnątrz. |
| 258 | `numeruj!(sciany)` | Numeracja W-n: zewnętrzne od dolnego lewego narożnika przeciwnie do wskazówek zegara, potem działowe, potem kontrfory. |
| 278 | `punkt(w, s)` | Punkt 2D na osi ściany w odległości s od początku a. |
| 283 | `opis_rodzaju(w)` | Opis rodzaju ściany do okna i list. |

### rdzen/sciecie_dachu.rb (154 wierszy)

bale ścian wzdłuż kalenicy wystające nad płaszczyznę dachu ścięte w poprzek do tej płaszczyzny – górny bal ściany okapowej przy ścianie nośnej, ściana wysoka dachu jednospadowego, działowa wzdłużna pod dachem.

Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia), rdzen/bale.rb (położenie bala), rdzen/podbitka.rb (obniżenie)
Używają: rdzen/projekt.rb (po balach, przed zamkami i pozycjami)

| Wiersz | Element | Opis |
|---:|---|---|
| 27 | `module SciecieDachu` |  |
| 29 | `MIN` | Najpłytsze ścięcie [mm] na niższym licu – płytsze pogłębiane do tej wartości (krawędź nie krótsza niż tolerancja SketchUpa). |
| 34 | `przytnij!(bale, p, dom)` | Ścina bale ścian wzdłuż kalenicy do płaszczyzny dachu; dom – opis dachu (Szczyty.dom_prostokatny), nil – nic. |
| 54 | `w_zakresie(c, b, zakres)` | Ścięcie c bala b ograniczone do zakresu s ściany (nil – bal poza zakresem). |
| 63 | `wyrownaj!(bale, p)` | Ścięcia bliskie granic przekroju: gdzie płaszczyzna ścięcia przecina poziom wierzchu (dno gniazda zamka, wierzch pióra) bliżej niż 0,2 mm od granicy pasa (podcięcie, pióro), płaszczyzna przesunięta równolegle tak, by przecięcie wypadło na granicy – krawędź krótsza niż tolerancja SketchUpa psuje bryłę. Po zamkach i oznaczeniu profilu. |
| 90 | `wyrownaj_skosy!(bale)` | x gniazda albo wycięcia na poziomie jego dna): nad narożem – skos obniżony do naroża, pod nim – obniżony do odstępu Bryla::SCAL (krawędź krótsza niż tolerancja SketchUpa psuje bryłę; runda 12 – węgły pod połacią zadaszenia, gdzie łamana linia dachu trafia blisko dna gniazda zamka). Skos zawsze w dół – bal nie wychodzi ponad dach. |
| 117 | `przesun!(c, kt, t, poziomy, granice)` | Przesunięcie płaszczyzny ścięcia c (nachylenie kt w poprzek) do najbliższej granicy pasa dla pierwszego poziomu, którego przecięcie wypada bliżej niż Bryla::SCAL od granicy albo nad którym płaszczyzna na granicy jest niżej niż Bryla::SCAL (stopień krótszy niż tolerancja – runda 9); płaszczyzna zawsze w dół. |
| 134 | `sciecie(b, p, geo, iv, t)` | Obróbka ścięcia bala b (nil – bal pod dachem): wysokości płaszczyzny na licach y = 0 i y = t względem spodu bala. |

### rdzen/siatka.rb (433 wierszy)

siatka ścian (płaskich wielokątów z otworami) zamkniętej bryły bala z profilu – do budowy komponentu w SketchUpie.

Zależy od: rdzen/bryla.rb (profil prosty), rdzen/profil_bala.rb (pasy pełnego profilu)
Używają: sketchup/budowa.rb, testy/t_siatka.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module Siatka` |  |
| 24 | `KLUCZ` | Krok klucza wierzchołka [mm]. |
| 29 | `z_profilu(prof)` | Siatka bryły z profilu (patrz Bryla.profil): { sciany: [...], wierzcholki: n }. |
| 37 | `sciany_surowe(prof)` | Ściany przedziałów i czoła, każda: { n: normalna, p: [punkty] } (kolejność przeciwna do wskazówek patrząc z zewnątrz). |
| 60 | `pasy(q)` | Pasy przedziału: pełny profil – lista pasy, profil prosty – jeden pas y0…y1. |
| 65 | `boki_y(xa, xb, ps)` | Boki pasów przedziału xa…xb na granicach y: część pasa niezakryta przez pas sąsiedni (po drugiej stronie granicy). |
| 78 | `na_granicy(q, strona)` | Pas widziany na swojej granicy y0 albo y1: wierzch skośny w poprzek (kt) – wartości wierzchu na tej granicy. |
| 85 | `roznica(a, b)` | Część pasa a niezakryta przez pas b (nil – cały): [[spód [z_a, z_b], wierzch [z_a, z_b]]] – do dwóch trapezów. |
| 96 | `trapez(xa, xb, y, dol, gora, kier)` | Trapez boku w płaszczyźnie y od spodu dol do wierzchu gora (normalna ±y); [] gdy zerowej wysokości. |
| 110 | `czolo(x, lewe, prawe)` | Czoło w płaszczyźnie x: przekrój lewy bez prawego (normalna +x) i prawy bez lewego (−x); przekroje z pasów (lewy – wartości na końcu b, prawy – na początku a). Kolumny między granicami pasów i punktami przecięcia wierzchów / spodów (wierzch pasa może opadać w poprzek – kt); w kolumnie każda różnica to trapez o prostych bokach. |
| 129 | `zakres_czola(r, y)` | Spód i wierzch pasa czoła [y0, y1, zb, zt, kt] w punkcie y: [zb, zt(y)]. |
| 134 | `kolumny(y0, y1, l, r)` | Granice kolumny y0…y1 podzielone w punktach, w których wierzch albo spód jednego przekroju przecina drugi. |
| 152 | `roznica_czola(x, ya, yb, a, b, kier)` | Część przekroju a niezakryta przez b w kolumnie ya…yb (bez przecięć wewnątrz) – trapezy czoła (kier ±x). |
| 166 | `trapez_czola(x, ya, yb, dol, gora, kier)` | Trapez czoła w płaszczyźnie x od dol do gora ([z przy ya, z przy yb]); nil – zerowej wysokości. |
| 179 | `normalna(pts)` | Normalna jednostkowa trójkąta a, b, c. |
| 189 | `klucz(pt)` | Klucz wierzchołka (zaokrąglone współrzędne). |
| 194 | `punkty_t(sciany)` | Wstawia do krawędzi ścian wierzchołki innych ścian, które na nich leżą (siatka bez punktów T). |
| 212 | `indeks_osi(wszystkie)` | Indeks wierzchołków dla krawędzi równoległych do osi: klucz pozostałych dwóch współrzędnych → punkty. |
| 223 | `kandydaci(a, b, idx)` | Wierzchołki, które mogą leżeć na krawędzi a–b (dla krawędzi wzdłuż osi – tylko z tej samej prostej). |
| 233 | `na_krawedzi(a, b, lista)` | Wierzchołki leżące wewnątrz odcinka a–b, uporządkowane od a. |
| 253 | `bez_powtorzen(pts)` | Usuwa kolejne powtórzone punkty pętli. |
| 261 | `scal(sciany)` | Scalanie ścian tej samej płaszczyzny: krawędzie przeciwne się znoszą, z reszty powstają pętle (zewnętrzne i otwory). |
| 296 | `pety(krawedzie, punkty, n)` | Pętle z krawędzi skierowanych (na rozwidleniu – najostrzejszy skręt w lewo względem normalnej). |
| 328 | `skret(a, b, c, n)` | Kąt skrętu w lewo (−π…π) przy przejściu a → b → c, patrząc wzdłuż normalnej. |
| 338 | `uloz(petle, n)` | Podział pętli na zewnętrzne (pole dodatnie względem normalnej) i otwory przypisane do zawierającej je pętli. |
| 351 | `pole(pts, n)` | Pole pętli ze znakiem względem normalnej. |
| 365 | `wewnatrz?(pt, petla, n)` | Punkt wewnątrz pętli (rzut na płaszczyznę bez największej składowej normalnej). |
| 385 | `uprosc(sciany)` | Siatka do rysowania: usunięte wierzchołki leżące na prostej we wszystkich pętlach, w których występują (zostają tylko narożniki i punkty styku z innymi ścianami – krawędzie sąsiednich ścian dalej się pokrywają). |
| 403 | `wspolliniowy?(a, b, c)` | Czy b leży na prostej a–c między nimi (przejście na wprost). |
| 411 | `sprawdz(sciany)` | Kontrola siatki: { zamknieta:, objetosc:, bledne_krawedzie: } – każda krawędź raz w każdą stronę. |

### rdzen/skos_przy_narozniku.rb (136 wierszy)

bale ścięte dachem przy narożnikach – przez narożnik (słup zamka) tylko w prawdziwym zamku; inaczej bal kończy się przy licu wewnętrznym ściany poprzecznej.

Zależy od: rdzen/parametry.rb, rdzen/bale.rb (skosy, okruch), rdzen/pol_zamka.rb (ostatnie połączenie pod dachem bez gniazda od spodu)
Używają: rdzen/projekt.rb (po Bale.zbuduj, przed Zamek.nanies)

| Wiersz | Element | Opis |
|---:|---|---|
| 26 | `module SkosPrzyNarozniku` |  |
| 28 | `PRZEBIEGI` | Najwięcej przebiegów (każdy usuwa bale z narożników – po kilku nie ma już czego przycinać). |
| 33 | `przytnij!(sciany, wynik, p)` | Przycięcie bali przy narożnikach (zmienia w[:bale] i wynik[:bale] z Bale.zbuduj); zwraca liczbę przyciętych. |
| 58 | `partner_skrzyzowania(w, k)` | Skrzyżowanie w drugiej ścianie, odpowiadające skrzyżowaniu k ściany w (ten sam punkt). |
| 65 | `w_slupie?(b, c, p)` | Czy bal zachodzi na słup zamka w osi c. |
| 71 | `w_zamku?(b, c, w2, c2, p)` | Czy bal b (oś zamka c) siedzi w zamku z balem ściany w2 (oś zamka c2) i zostaje w nim dość drewna. |
| 94 | `wierzch_w_gniezdzie(b, c, sz)` | Najniższy wierzch bala (od spodu, po skosach) w krawędziach gniazda szerokości sz w osi c; nil – bal nie sięga gniazda. |
| 101 | `wierzch(b, x)` | Wierzch bala w miejscu x (pełna wysokość albo niżej – skos). |
| 112 | `przytnij_bal!(w, b, c, wynik, p)` | Bal kończy się przy licu wewnętrznym ściany poprzecznej (od strony środka ściany w); krótszy niż okruch – usunięty. |

### rdzen/skrzydla.rb (239 wierszy)

dach domu w kształcie L – podział obrysu na skrzydło główne i boczne, opisy obu dachów (dwa dachy dwuspadowe z koszem), szczyty i ściany okapowe skrzydeł, zasięg płatwi skrzydła bocznego.

Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia, płatwie), rdzen/platwie_wience.rb (obniżenie dachu), rdzen/wience.rb
Używają: rdzen/sciany.rb (oś kalenicy), rdzen/szczyty.rb (szczyty, gniazda), rdzen/dach.rb (belki), rdzen/pod_dachem.rb, rdzen/sciecie_dachu.rb, rdzen/wegly_konstrukcyjne.rb, rdzen/polacie.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 28 | `module Skrzydla` |  |
| 30 | `DALEKO` | Zakres „do końca ściany” [mm]. |
| 36 | `podzial(pts, wybor)` | Podział obrysu L (6 punktów, jeden narożnik wklęsły, boki równoległe do osi): { os: (kalenica dachu głównego), r: (narożnik wklęsły), n: (brakujący narożnik prostokąta), opp: (narożnik naprzeciw) }; inny obrys – nil. |
| 65 | `wybrana_os(szer, wys, wybor)` | Oś kalenicy z parametru „kalenica” dla obrysu szer × wys (jak Sciany.os_kalenicy). |
| 75 | `os(pts, wybor)` | Oś kalenicy dachu głównego domu L (nil – obrys nie jest L). |
| 82 | `dom(sciany, p, os_kalenicy)` | Opis dachu domu L ze ścian zewnętrznych: dach główny z [:boczne]; nil – obrys nie jest L albo oś kalenicy inna niż wynika z podziału (np. wymuszona przez taras). |
| 111 | `domy(dom)` | Dachy domu: [główny, boczny] albo [dom] dla domu prostokątnego; nil – []. |
| 118 | `w_strefie?(dom, q, p)` | Czy punkt rzutu q leży w strefie dachu dom (dom prostokątny – zawsze): główny – w jego rozpiętości (z grubością ściany), boczny – za linią okapu dachu głównego. |
| 128 | `dom_sciany(dom, w, p)` | Dach, w którego strefie leży ściana (węgieł – jego oś, inna ściana – środek); nil – żaden. |
| 135 | `oznacz!(sciany, dom, p, z_okap, dzialowe)` | Szczyty i ściany okapowe domu L (w[:szczyt], w[:okap_boczny]); zwraca ściany ze szczytem. dzialowe – czy działowe w poprzek kalenicy od okapu do okapu dostają szczyt. |
| 166 | `szczyt(w, d, z_okap)` | Szczyt ściany w pod dachem d: geometria przekroju dachu z kierunkiem v wzdłuż ściany. |
| 173 | `zakres_szczytu(w, d, lo, p)` | Zasięg [s0, s1] szczytu na ścianie dłuższej niż rozpiętość dachu d: od końca przy narożniku do lica wewnętrznego linii okapu po stronie, po której ściana biegnie dalej. |
| 185 | `konce_na_okapach?(w, d)` | Czy oba końce działowej leżą na ścianach zewnętrznych wzdłuż kalenicy dachu d. |
| 194 | `okapy_boczne!(sciany, boczne, p)` | Ściany okapowe skrzydła bocznego (zewnętrzne wzdłuż jego kalenicy, w osiach v_a i v_b): w[:okap_boczny] = { geo:, s_zakres: } – cała ściana albo jej część za linią okapu dachu głównego (ściana ze szczytem dachu głównego). |
| 214 | `zasieg_platwi(dom, pl, p)` | Zasięg płatwi pl dachu dom wzdłuż kalenicy [u0, u3]: za szczyty o wysunięcie dachu; płatew skrzydła bocznego – od szczytu do dachu głównego (koniec_w_dachu_glownym). |
| 223 | `koniec_w_dachu_glownym(dom, pl, p)` | Koniec płatwi skrzydła bocznego w dachu głównym (współrzędna u skrzydła = v dachu głównego): tam, gdzie wierzch płatwi w jej osi dochodzi do płaszczyzny dachu głównego (w koszu); wcześniej – przy licu płatwi dachu głównego, w którą by weszła (płatew skrzydła dochodzi do niej na styk). |

### rdzen/statyka.rb (93 wierszy)

sprawdzenie belki drewnianej swobodnie podpartej (zginanie, ścinanie, ugięcie końcowe), największa rozpiętość, dobór przekroju z katalogu.

Zależy od: rdzen/parametry.rb
Używają: rdzen/podloga.rb, rdzen/statyka_dachu.rb, rdzen/statyka_wiazara.rb, rdzen/statyka_slupa.rb (klasy drewna), rdzen/statyka_zadaszenia.rb, rdzen/statyka_krokwi.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `module Statyka` |  |
| 22 | `KLASY` | Klasy drewna: wytrzymałość na zginanie, ścinanie i ściskanie wzdłuż włókien f_m,k, f_v,k, f_c,0,k [MPa], moduły E0,mean i E0,05 [MPa], gęstość [kg/m³], γM (PN-EN 338, PN-EN 14080). |
| 28 | `KMOD` |  |
| 29 | `KDEF` |  |
| 30 | `PSI2` |  |
| 31 | `KCR` |  |
| 38 | `belka(l, b, h, g, q, klasa, granica, psi2 = PSI2)` | Sprawdzenie belki: l [mm], b × h [mm], obciążenia stałe g i użytkowe q [kN/m] bez ciężaru własnego, granica L/n; psi2 – część obciążenia zmiennego działająca długotrwale (podłoga 0,3; śnieg na dachu 0). Wynik: { wyk_m:, wyk_v:, u:, l_przez_u:, nosnosc_ok:, ugiecie_ok:, ok: }. |
| 58 | `obciazenia(p, rozstaw)` | Obciążenia legara [kN/m] z parametrów i rozstawu: [g, q]. |
| 63 | `max_rozpietosc(b, h, p, rozstaw, granica)` | Największa rozpiętość [mm], przy której belka spełnia nośność i ugięcie L/granica (szukanie połówkowe). |
| 76 | `kandydaci(p)` | Przekroje z katalogu nie niższe niż izolacja, od najlżejszego (przy równym polu – wyższy pierwszy). |
| 82 | `dobierz(l, p, rozstaw, granica)` | Najlżejszy przekrój z katalogu (nie niższy niż izolacja), który przenosi rozpiętość l; nil gdy żaden. |
| 88 | `granica(p, tryb = Parametry.dobor(p, 'legary_dobor'))` | Granica ugięcia L/n dla trybu doboru ('minimalny' – dopuszczalna, inne – zalecana). |

### rdzen/statyka_dachu.rb (198 wierszy)

sprawdzenie płatwi dachu (śnieg i ciężar pokrycia, przęsła między ścianami, pas dachu na płatew) i automatyczny dobór najmniejszego wystarczającego przekroju płatwi z listy.

Zależy od: rdzen/parametry.rb, rdzen/statyka.rb (belka), rdzen/dach.rb (płatwie, kąt), rdzen/skrzydla.rb (dachy domu, zasięg płatwi)
Używają: rdzen/projekt.rb (podpowiedzi sekcji „Szczyty i dach”, przekroje dobrane do drugiego przebiegu obliczeń), rdzen/statyka_zadaszenia.rb (obciążenia, przęsło płatwi, opis ugięcia), rdzen/statyka_krokwi.rb (współczynnik μ, opis ugięcia)

| Wiersz | Element | Opis |
|---:|---|---|
| 35 | `module StatykaDachu` |  |
| 37 | `POLA` | Pola przekroju płatwi według rodzaju (osobne przekroje) i nazwy do komunikatów. |
| 39 | `NAZWY` |  |
| 43 | `PSI2_SNIEG` | Część śniegu działająca długotrwale (pełzanie) – 0 poniżej 1000 m n.p.m. |
| 48 | `auto?(p)` | Czy przekrój płatwi dobiera generator. |
| 53 | `mi(kat)` | Współczynnik kształtu dachu dla śniegu μ (kąt w stopniach): 0,8 do 30°, liniowo do 0 przy 60°. |
| 61 | `obciazenia(pas, p, kat = nil)` | Obciążenia płatwi [kN/m] dla pasa dachu pas [mm w poziomie] przy kącie połaci kat [°] (domyślnie kąt dachu; boczne zadaszenie – jego kąt): [stałe, śnieg]. |
| 67 | `wysokosc(b, h, rodzaj, p)` | Wysokość przekroju do obliczeń [mm]: płatew ścięta do płaszczyzny dachu – średnia (kalenicowa ścięta z obu stron). |
| 74 | `pas(geo, lista, pl, p)` | Pas dachu na płatew pl [mm w poziomie]: po połowie odległości do sąsiednich linii podparcia połaci (płatwie; ściana okapowa, gdy nie ma przy niej płatwi ściennej); skrajna płatew – także okap. |
| 90 | `przeslo(d, pl, u0, u3, p)` | w poprzek – d[:przejscia]; końce ścian wzdłuż płatwi – d[:podparcia], odcinek na takiej ścianie nie jest przęsłem; koniec płatwi skrzydła bocznego w dachu głównym albo – w koszu – jej słupek na płatwi głównej, d[:podpory_kosz] z rdzen/podpory_platwi_l.rb) albo dwa wsporniki końca; bez podpór – cała długość. |
| 106 | `platwie(dom, p)` | Płatwie wszystkich dachów domu do sprawdzenia: [{ rodzaj:, b:, h:, l: (przęsło), pas:, dl: (cała długość) }]. |
| 120 | `grupy(lista, p)` | Grupy płatwi o wspólnym przekroju: { pole przekroju => [płatwie] } (jeden przekrój – wszystkie w platwa_przekroj); dach bez płatwi – {}. |
| 128 | `ocena(grupa, b, h, p)` | Ocena przekroju b × h dla płatwi grupy – wynik najbardziej wytężonej (nośność albo ugięcie względem granicy): { ok:, wyk: (nośność 0…), l_przez_u:, l:, pas: }. |
| 138 | `kandydaci(p)` | Przekroje do doboru – od najlżejszego (przy równym polu wyższy pierwszy). |
| 144 | `dobierz(grupa, p)` | Najlżejszy przekrój z listy wystarczający dla grupy – w pierwszej kolejności dostępny w hurtowni w całej długości najdłuższej płatwi grupy (rdzen/dlugosci_handlowe.rb); nil – żaden nie wystarcza. |
| 153 | `sprawdz(dom, p, tryb = :pierwszy)` | platwie: [sprawdzone płatwie – przęsło i pas dachu] }. tryb: :pierwszy – dobór od zera; :potwierdz – przebieg z dobranym już przekrojem, zmiana tylko, gdy obecny nie wystarcza; :koniec – ostatni przebieg, bez zmian (sama ocena). |
| 174 | `ugiecie_opis(l_przez_u)` | Ugięcie do komunikatu: „ugięcie L/250”, a przy znikomym – „ugięcie poniżej L/1000”. |
| 179 | `podpowiedz(pole, bh, r, min, p)` | Podpowiedź do okna dla grupy płatwi o przekroju bh z oceną r (min – najlżejszy wystarczający z listy albo nil). |

### rdzen/statyka_krokwi.rb (166 wierszy)

sprawdzenie i dobór przekroju krokwi całego dachu – połacie domu i bocznego zadaszenia (przęsła między płatwiami, okap jako wspornik, rozstaw krokwi); automatycznie najmniejszy wystarczający z listy albo przekrój z wyboru ze sprawdzeniem.

Zależy od: rdzen/parametry.rb, rdzen/statyka.rb (belka), rdzen/statyka_dachu.rb (współczynnik μ, opis ugięcia), rdzen/dach.rb (płatwie, krokwie), rdzen/dach_jednospadowy.rb, rdzen/zadaszenie.rb (płatwie zadaszenia), rdzen/skrzydla.rb
Używają: rdzen/projekt.rb (podpowiedzi sekcji „Szczyty i dach” i „Zadaszenie – przekroje”, przekrój dobrany do następnego przebiegu)

| Wiersz | Element | Opis |
|---:|---|---|
| 30 | `module StatykaKrokwi` |  |
| 32 | `POLE` | Pole przekroju krokwi. |
| 37 | `auto?(p)` | Czy przekrój krokwi dobiera generator. |
| 43 | `przeslo(e0, e1, podpory)` | Przęsło obliczeniowe krokwi w rzucie [mm] między jej końcami e0 i e1 (okap, kalenica, załamanie) przy podporach (v): największa odległość między podporami albo wspornik końca (2a); bez podpór – cała długość. |
| 52 | `krokwie(dom, p)` | Krokwie domu do sprawdzenia: [{ gdzie: :dach \| :zadaszenie, l: (przęsło w rzucie), kat: [°] }] – po jednej na połać. |
| 73 | `jednospadowa(geo, pod, p)` | Krokiew dachu jednospadowego (jeden kawałek od okapu za ścianą niską do okapu za ścianą wysoką; ściana wysoka podporą). |
| 86 | `zadaszenia(geo, c, p)` | Krokiew bocznego zadaszenia strony c: od załamania do okapu zadaszenia, na płatwiach zadaszenia (przybudówka ze ścianą nośną – także na ścianie). |
| 98 | `ocena(lista, b, h, p)` | Ocena krokwi b × h: { ok:, wyk:, l_przez_u:, l: (przęsło w rzucie) } najbardziej wytężonej z listy (nil – pusta). |
| 111 | `kandydaci(p)` | Przekroje krokwi do doboru – od najlżejszego (przy równym polu wyższy pierwszy). |
| 117 | `dobierz(lista, p)` | Najlżejszy przekrój z magazynu wystarczający dla wszystkich krokwi, najpierw dostępny w całej długości krokwi (od okapu do kalenicy); nil – żaden. |
| 124 | `sprawdz(dom, p, tryb = :pierwszy)` | Sprawdzenie i dobór krokwi domu: { podpowiedzi: [{ poziom:, tekst:, sekcja: }], nadpis: { POLE => 'b×h' } }; tryb jak StatykaDachu.sprawdz. Podpowiedź krokwi dachu – sekcja „szczyty”, krokwi zadaszenia – „zadaszenie_przekroje”. |
| 148 | `podpowiedz(nazwa, bh, r, min, p)` | Podpowiedź do okna: krokwie (nazwa) o przekroju bh z oceną r (min – najlżejszy wystarczający dla całego dachu). |

### rdzen/statyka_slupa.rb (51 wierszy)

sprawdzenie słupa drewnianego ściskanego osiowo z wyboczeniem (przegubowo na obu końcach) – nośność, smukłość.

Zależy od: rdzen/statyka.rb (klasy drewna, k_mod)
Używają: rdzen/statyka_zadaszenia.rb (słupy zadaszenia)

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `module StatykaSlupa` |  |
| 23 | `SMUKLOSC_MAX` | Największa dopuszczalna smukłość słupa. |
| 29 | `sprawdz(l, b, h, ng, nq, klasa)` | Sprawdzenie słupa: l – długość wyboczeniowa [mm], b × h [mm], siły od obciążeń stałych ng i zmiennych nq [kN] bez ciężaru własnego słupa. Wynik: { wyk: (wytężenie 0…), smuklosc:, kc:, n_d: [kN], ok: }. |
| 44 | `wspolczynnik_kc(lrel, beta)` | Współczynnik wyboczeniowy k_c ze smukłości względnej (do 0,3 – bez wyboczenia). |

### rdzen/statyka_wiazara.rb (163 wierszy)

sprawdzenie trójkąta (wiązara) nad tarasem pod obciążeniem od płatwi i automatyczny dobór jego najmniejszego wystarczającego przekroju, który mieści się pod dachem.

Zależy od: rdzen/parametry.rb, rdzen/statyka.rb (belka, klasy drewna), rdzen/statyka_dachu.rb (pas dachu, obciążenia, lista przekrojów), rdzen/dach.rb, rdzen/skrzydla.rb (zasięg płatwi), rdzen/taras.rb (słupy frontu), rdzen/taras_wiazar.rb (front, układ, postać)
Używają: rdzen/projekt.rb (podpowiedzi sekcji „Taras”, przekrój dobrany do następnego przebiegu obliczeń)

| Wiersz | Element | Opis |
|---:|---|---|
| 32 | `module StatykaWiazara` |  |
| 36 | `auto?(p)` | Czy przekrój trójkąta dobiera generator. |
| 42 | `sily(dom, u, p)` | Siły od płatwi na trójkąt: [{ v:, rodzaj:, g:, q: }] w kN (stałe z ciężarem płatwi, śnieg) – z połowy przęsła do najbliższej ściany domu i z końca płatwi za trójkątem. |
| 61 | `krokiew(sily, v_stopy, vk)` | Krokiew jednej strony: rozpiętość a [mm] i obciążenia równoważne [kN/m] [g, q] (ten sam największy moment co siły skupione od płatwi pośrednich w odległościach x od ściany), reakcja w kalenicy [g, q] w kN. |
| 75 | `belka_na_slupach(front, u, sily, krokwie, p)` | Belka dolna trójkąta na słupach: [rozpiętość między słupami przy osi, obciążenia równoważne [g, q] w kN/m] od siły słupka (płatew kalenicowa i reakcje krokwi w kalenicy); nil – słup w osi kalenicy albo trójkąt na balach. |
| 94 | `ocena(front, u, sily, b, h, p)` | Ocena przekroju b × h trójkąta: { ok:, wyk:, l_przez_u:, a: (rozpiętość krokwi) } – najgorszy z krokwi obu stron i belki dolnej na słupach. |
| 108 | `miesci_sie?(front, bh, p)` | Czy przy przekroju bh mieści się cały trójkąt (belka dolna, krokwie, słupek). |
| 115 | `dobierz(front, u, sily, p)` | Przekrój z listy: najlżejszy wystarczający, przy którym mieści się cały trójkąt; inaczej najlżejszy wystarczający; nil – żaden nie wystarcza. |
| 122 | `sprawdz(sciany, dom, p, tryb = :pierwszy)` | Sprawdzenie i dobór: { podpowiedzi: [{ poziom:, tekst: }], nadpis: { 'taras_wieniec_dobrany' => 'b×h' } }; tryb jak w StatykaDachu.sprawdz (:pierwszy – dobór, :potwierdz – zmiana tylko, gdy obecny nie wystarcza, :koniec – ocena). |
| 143 | `podpowiedz(bh, r, min, p)` | Podpowiedź do okna: przekrój trójkąta bh z oceną r (min – dobrany z listy albo nil). |

### rdzen/statyka_zadaszenia.rb (215 wierszy)

sprawdzenie i dobór przekrojów bocznego zadaszenia – płatwie i oczep (przęsło między słupami albo ścianami, pas połaci zadaszenia), belki poprzeczne (od słupa do ściany domu) i słupy (ściskanie z wyboczeniem); automatycznie najmniejszy wystarczający z list albo przekroje z wyboru użytkownika ze sprawdzeniem.

Zależy od: rdzen/parametry.rb, rdzen/statyka.rb (belka), rdzen/statyka_slupa.rb (słup), rdzen/statyka_dachu.rb (obciążenia, przęsło płatwi, opis ugięcia), rdzen/dach.rb, rdzen/zadaszenie.rb (płatwie, linie słupów), rdzen/skrzydla.rb (zasięg płatwi)
Używają: rdzen/projekt.rb (podpowiedzi sekcji „Zadaszenie – przekroje”, przekroje dobrane do następnego przebiegu)

| Wiersz | Element | Opis |
|---:|---|---|
| 35 | `module StatykaZadaszenia` |  |
| 37 | `PLATWIE` | Pola przekrojów grup i nazwy do komunikatów. |
| 38 | `BELKI` |  |
| 39 | `SLUPY` |  |
| 40 | `NAZWY` |  |
| 41 | `SLUPY` |  |
| 43 | `KATALOGI` | Lista przekrojów do doboru dla pola. |
| 44 | `SLUPY` |  |
| 49 | `auto?(p)` | Czy przekroje zadaszenia dobiera generator. |
| 54 | `kat(p)` | Kąt zadaszenia [°]. |
| 59 | `na_metr(p)` | Obciążenia na metr kwadratowy rzutu zadaszenia [kN/m²]: [stałe, śnieg]. |
| 65 | `pasy(c, strona, p)` | Szerokości pasów połaci zadaszenia [mm w poziomie] dla płatwi strona (w kolejności listy): połowa odległości do sąsiednich linii podparcia (płatwie, ściana nośna przybudówki); pierwsza – od załamania, ostatnia – do okapu. |
| 82 | `pasy_u(linie, p)` | Pasy wzdłuż ściany na linie słupów [mm]: połowa odległości do sąsiednich linii, skrajne – z wysunięciem za szczyt. |
| 92 | `czlony(dom, sciany, p)` | Człony zadaszenia domu do sprawdzenia: { PLATWIE => [{ l:, pas:, rodzaj: }], BELKI => [{ l:, pas: }], SLUPY => [{ l:, a: (pole rzutu [m²]), g_wl: (ciężar belki i oczepu [kN]) }] }; bez zadaszenia – {}. |
| 127 | `wysokosc(b, h, p)` | Wysokość płatwi do obliczeń: ścięta do połaci zadaszenia – średnia wysokość przekroju (jak płatwie dachu). |
| 134 | `ocena(pole, grupa, b, h, p)` | Ocena przekroju b × h dla grupy pola – najbardziej wytężony człon: { ok:, wyk:, l_przez_u: (belki), l:, pas:, smuklosc:, n_d: (słupy) }. |
| 152 | `kandydaci(pole, p)` | Przekroje do doboru dla pola – od najlżejszego (przy równym polu wyższy pierwszy). |
| 158 | `dobierz(pole, grupa, p)` | Najlżejszy przekrój z listy wystarczający dla grupy – w pierwszej kolejności dostępny w hurtowni w całej długości najdłuższego członu grupy (rdzen/dlugosci_handlowe.rb); nil – żaden nie wystarcza. |
| 165 | `sprawdz(dom, sciany, p, tryb = :pierwszy)` | Sprawdzenie i dobór zadaszenia domu: { podpowiedzi: [{ poziom:, tekst: }], nadpis: { pole => 'b×h' } }; tryb jak StatykaDachu.sprawdz (:pierwszy, :potwierdz, :koniec). |
| 185 | `opis(pole, bh, r)` | Opis członu do podpowiedzi: przęsło i pas (belki) albo wysokość, siła i smukłość (słupy). |
| 197 | `podpowiedz(pole, bh, r, min, p)` | Podpowiedź do okna dla grupy pola o przekroju bh z oceną r (min – najlżejszy wystarczający z listy albo nil). |

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

### rdzen/stolarka_modele.rb (100 wierszy)

modele okien i drzwi wstawiane w otwory – wiersz listy typowej stolarki dla otworu, plik modelu (pełna ścieżka z kolumny „Model” albo nazwa w folderze modeli), prosty model z generatora, gdy pliku nie ma, położenie modelu w otworze (punkt, osie) w układzie domu.

Zależy od: rdzen/parametry.rb (grubość ściany, lista stolarki p['stolarka'], folder p['stolarka_folder'], p['stolarka_prosta']), rdzen/stolarka_prosta.rb (części prostego modelu)
Używają: sketchup/stolarka_modele.rb (wstawienie komponentów przy generowaniu), html/otwory.js i html/klik_sciana.js (ta sama lista w oknie)

| Wiersz | Element | Opis |
|---:|---|---|
| 25 | `module StolarkaModele` |  |
| 27 | `ROZSZERZENIE` | Rozszerzenie pliku modelu dopisywane, gdy w kolumnie „Model” go nie ma. |
| 32 | `wiersz(p, symbol)` | Wiersz listy typowej stolarki o symbolu (wielkość liter bez znaczenia); nil – brak. |
| 40 | `plik(p, r)` | Ścieżka pliku modelu dla wiersza listy: pełna ścieżka z kolumny „Model” (bez folderu modeli) albo nazwa z kolumny „Model” lub symbol w folderze modeli; nil – brak wiersza, nazwy albo folderu dla samej nazwy. |
| 52 | `pelna_sciezka?(t)` | Czy tekst jest pełną ścieżką (C:\…, C:/…, \\serwer\…, /…). |
| 57 | `rodzaj(r, st)` | Rodzaj otworu: z wiersza listy stolarki, a bez typu – drzwi, gdy stolarka zaczyna się na spodzie ściany (spód 0). |
| 65 | `do_wstawienia(plan)` | Modele do wstawienia w planie: [{ plik: (nil – brak pliku), prosty: (części prostego modelu albo nil), nazwa:, sciana:, typ:, rodzaj:, polozenie: { poczatek:, x:, y:, z: }, szerokosc:, wysokosc: }] – każdy otwór ze stolarką, który ma plik modelu albo dostaje prosty model (stolarka_prosta = tak). |
| 90 | `polozenie(w, st, t)` | Położenie modelu: punkt 0 – lico „zewnętrzne” ściany (−nor) przy s0 stolarki na wysokości jej spodu; osie X = kier, Y = nor (w głąb ściany), Z = pion. Układ domu (mm, jak położenie belek – Konwersja.transformacja_elementu). |

### rdzen/stolarka_prosta.rb (102 wierszy)

prosty model okna i drzwi z generatora (rama na grubość ściany, szyba albo pełne skrzydło drzwi, maskownice od zewnątrz) wstawiany w otwór, gdy nie ma pliku modelu użytkownika – części jako prostopadłościany i ich siatki.

Zależy od: rdzen/parametry.rb (grubość ściany, parametry stolarka_rama, maskownica_*), rdzen/pryzmat.rb (siatka prostopadłościanu)
Używają: rdzen/stolarka_modele.rb (lista do wstawienia), sketchup/stolarka_modele.rb (definicja komponentu z części)

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module StolarkaProsta` |  |
| 24 | `SZYBA` | Grubość szyby i luz skrzydła drzwi w ramie [mm]. |
| 25 | `LUZ_SKRZYDLA` |  |
| 26 | `SKRZYDLO` |  |
| 31 | `czesci(rodzaj, szer, wys, t, p)` | Części prostego modelu stolarki rodzaju ('okno' \| 'drzwi') o wymiarach szer × wys [mm] w ścianie grubości t. |
| 42 | `rama(w, h, t, r, drzwi)` | Rama (ościeżnica) na grubość ściany: góra i boki, w oknie także dół. |
| 52 | `szyba(w, h, t, r)` | Szyba okna w środku grubości ramy. |
| 58 | `skrzydlo(w, h, t, r)` | Pełne skrzydło drzwi w ramie (z luzem), od podłogi. |
| 65 | `maskownice(w, h, r, drzwi, p)` | Maskownice od zewnątrz: góra i boki, w oknie także dół; szerokość 0 – bez maskownic. |
| 81 | `czesc(nazwa, min, max, szyba = false)` | Część (prostopadłościan) od min do max. |
| 86 | `siatka(c)` | Siatka części (ściany jak w rdzen/siatka.rb) w układzie modelu stolarki. |
| 97 | `nazwa(rodzaj, szer, wys)` | Nazwa definicji prostego modelu: rodzaj i wymiary (jedna definicja na rodzaj i wymiar w budowie). |

### rdzen/styki.rb (356 wierszy)

podział długich ścian na bale – miejsca styków na mijankę (min. 300 mm) w trzech układach, węgły pod styki.

Zależy od: rdzen/parametry.rb, rdzen/sciany.rb (dodaj_kontrfor), rdzen/otwory.rb (strefy otworów), rdzen/usztywnienie.rb (miejsce_ok?, wolne_miejsce), rdzen/styki_dzialowe.rb (najpierw styki wspólne w zamku działowej), rdzen/symetria_wegly.rb (ściana bliźniacza, równy podział), rdzen/wypusty_okapu.rb (zasięg z wypustami), rdzen/styki_tarasu.rb (front tarasu – na styk, bez węgłów), rdzen/styki_szczytu.rb (wieńce szczytu na styk – węgły pod styki tylko do wysokości ściany)
Używają: rdzen/projekt.rb, rdzen/bale.rb (pozycje_w_wiencu)

| Wiersz | Element | Opis |
|---:|---|---|
| 30 | `module Styki` |  |
| 32 | `KROK` | Krok siatki miejsc na nowy węgieł [mm] (od początku osi ściany – okrągłe odległości od narożnika). |
| 34 | `LIMIT_WEZLOW` | Najwięcej kroków przeszukiwania układu na przemian dla jednej liczby kotwic. |
| 39 | `planuj(sciany, p, os_kalenicy)` | Miejsca styków dla wszystkich ścian (zewnętrznych i działowych); dostawia węgły pod styki. Zwraca ostrzeżenia. |
| 69 | `z_weglami(w, p, gotowe)` | Styki ściany w zamkach skrzyżowań i węgłów (wszystkie ściany poza frontem tarasu łączonym na styk): jak u ściany równoległej policzonej wcześniej (ten sam zasięg – symetria), wspólne w zamku działowej albo wybrany układ; nil – nie da się. |
| 80 | `pozycje_w_wiencu(w, i)` | Położenia styków w wieńcu o indeksie i (0 = najniższy wieniec ściany). |
| 89 | `kotwice(w, p)` | Istniejące skrzyżowania wewnątrz ściany, w których może wypaść styk (bez narożników i za blisko otworów). Ściana ze szczytem łączonym w zamkach (szczyt_styk = wegly, szczyt płaski) – tylko węgły: działowa kończy się pod okapem, a styki w wieńcach szczytu też muszą leżeć w zamku. Szczyt na styk (rdzen/styki_szczytu.rb) – jak zwykła ściana. |
| 97 | `poza_otworami?(w, p, s)` | Czy styk w miejscu s jest dość daleko od otworów (styk_odstep_od_otworu, nie bliżej niż węgieł od otworu). |
| 103 | `miejsce_styku_ok?(w, p, s, zajete)` | Czy w miejscu s może stanąć nowy węgieł pod styk (miejsce na węgieł i odstęp styku od otworów). |
| 108 | `kawalki_ok?(w, listy, lmax)` | Czy kawałki bali w każdym wieńcu mieszczą się w maksymalnej długości (listy styków: parzyste, nieparzyste). |
| 118 | `na_przemian(w, p)` | Układ na przemian: najmniej nowych węgłów, potem najmniej kotwic; nil – nie da się. |
| 134 | `razem_wegli(w, p, nowe)` | Ile węgłów będzie na ścianie z nowymi węgłami pod styki: nowe + usztywniające, których wymagają światła dłuższe niż limit (szacunek do wyboru między równym podziałem a dowolnym miejscem). |
| 145 | `przemian_siatka(w, p, kotwy, siatka, dl, lmax)` | Układ na przemian z nowymi węgłami z listy miejsc siatka: najmniej nowych węgłów, potem najmniej kotwic; nil – nie da się. |
| 168 | `przemian_k(w, p, k, kotwy, siatka)` | Najlepszy układ na przemian dla k kotwic: { kotwy:, nowe:, ocena: } albo nil. |
| 175 | `przemian_szukaj(w, p, k, kotwy, siatka, a, nowe, odch, stan)` | Krok przeszukiwania: następna kotwica – istniejące skrzyżowanie (do 3 najbliższych celu) albo nowy węgieł. |
| 200 | `przemian_zakres(w, p, k, a)` | Zakres [lo, hi] kotwicy nr a.length: kawałek od poprzedniej kotwicy tej samej parzystości ≤ maks. długość, od poprzedniej kotwicy ≥ mijanka, pozostałe kotwice tej parzystości muszą jeszcze dosięgnąć końca ściany. |
| 212 | `wolna_siatka(w, p)` | Miejsca (co KROK od początku osi), w których może stanąć nowy węgieł – bez względu na inne nowe węgły. |
| 224 | `najblizsze_wolne(siatka, cel, lo, hi, zajete, min)` | Najbliższe celu miejsce z siatki w zakresie lo…hi, odległe od zajętych o ≥ min; nil gdy brak. |
| 243 | `indeks_od(lista, x)` | Indeks pierwszego elementu posortowanej listy ≥ x (długość listy, gdy brak) – wyszukiwanie połówkowe. |
| 256 | `dobierz_regiony(w, p)` | Regiony łączenia [{ a:, b:, c:, nowe: [s] }] albo nil; próbuje coraz większej liczby bali. |
| 270 | `proba(w, p, m)` | Jedna próba podziału na m bali: regiony przy punktach docelowych s_od + j·dł/m. |
| 288 | `najlepszy_region(w, p, cel, okno, zajete, regiony = [])` | Najlepszy region przy punkcie cel: najmniej nowych węgłów, potem najbliżej celu; z zachowaniem mijanki względem regionów już wybranych (styki wieńców parzystych i nieparzystych co najmniej mijanka od siebie). |
| 297 | `mijanka_ok?(regiony, d)` | Czy styki regionów (a – wieńce parzyste, b – nieparzyste) są w sąsiednich wieńcach co najmniej d od siebie. |
| 302 | `kandydaci_para(w, p, cel, okno, zajete)` | Kandydaci układu para: dwie istniejące kotwice, kotwica + nowy węgieł, dwa nowe węgły. |
| 325 | `kandydaci_jeden(w, p, cel, okno, zajete)` | Kandydaci układu jeden węgieł: istniejące kotwice i nowy węgieł; styki ± mijanka/2 poza zamkami i otworami. |
| 339 | `styki_poza_zamkami?(w, p, x)` | Układ jeden węgieł: oba styki x ± mijanka/2 poza zamkami innych skrzyżowań (z zapasem grubości) i z dala od otworów. |
| 348 | `z_regionow(_w, p, regiony)` | Wynik ściany z regionów (para / jeden węgieł); nil gdy brak regionów. |

### rdzen/styki_dzialowe.rb (100 wierszy)

styki w zamku działowej – wszystkie wieńce ściany łączone w osi skrzyżowania z działową (zamek trzyma oba końce), bez drugiego rzędu na mijankę i bez węgłów; reszta ściany – zwykłym układem.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wysokości ścian), rdzen/otwory.rb (strefy otworów – przez Styki.poza_otworami?)
Używają: rdzen/styki.rb (planuj – najpierw działowe), rdzen/kontrola.rb (mijanka – styki wspólne wyłączone)

| Wiersz | Element | Opis |
|---:|---|---|
| 24 | `module StykiDzialowe` |  |
| 28 | `wlaczone?(p)` | Czy styki wspólne w zamku działowej są włączone. |
| 34 | `kotwice(w, p)` | Skrzyżowania ściany w, w których mogą łączyć się wszystkie wieńce: ściana poprzeczna działowa albo zewnętrzna (nie węgieł), wnętrze ściany, z dala od otworów, wysoka prawie jak ściana w. |
| 48 | `planuj(w, p)` | Plan styków ściany ze stykami wspólnymi: { parzyste:, nieparzyste:, kotwy:, nowe:, wspolne: } albo nil (brak skrzyżowań z działową albo reszta ściany nie da się zaplanować – wtedy zwykły układ dla całej ściany). |
| 76 | `zloz(w, p, wspolne, odcinki)` | Złożenie wyniku: styki wspólne w obu parzystościach + układ zwykły na odcinkach dłuższych niż bal (odcinek jako ściana od styku do styku); nil, gdy odcinka nie da się zaplanować albo jego styki są bliżej niż mijanka od wspólnych. |
| 94 | `wspolny?(w, s)` | Czy styk w s (oś styku) jest stykiem wspólnym ściany (do kontroli mijanki). |

### rdzen/styki_szczytu.rb (141 wierszy)

łączenie wieńców szczytu ściany domu na styk – bez węgła i bez zamka, na przemian z przesunięciem o mijankę (nie mniej niż 300); miejsca styków w każdym wieńcu szczytu osobno.

Zależy od: rdzen/parametry.rb, rdzen/szczyty.rb (góra ściany bez szczytu, linia szczytu), rdzen/taras.rb (front tarasu ma własne zasady – rdzen/styki_tarasu.rb)
Używają: rdzen/styki.rb (ściana pod szczytem łączona jak zwykła, węgły pod styki do wysokości ściany), rdzen/bale.rb (styki w kawałku wieńca szczytu), rdzen/kontrola.rb (styk na styk nie jest „stykiem bez zamka”)

| Wiersz | Element | Opis |
|---:|---|---|
| 30 | `module StykiSzczytu` |  |
| 32 | `ZAPAS` | Najwięcej dodatkowych styków w kawałku ponad najmniejszą potrzebną liczbę. |
| 38 | `dotyczy?(w, p)` | Czy wieńce szczytu ściany łączy się na styk: ściana domu ze szczytem skośnym przy szczyt_styk = styk (nie węgieł, nie szczyt płaski, nie front tarasu). |
| 46 | `wieniec?(w, wn, p)` | Czy wieniec wn ściany w jest wieńcem szczytu łączonym na styk (spód na górze ściany bez szczytu albo wyżej). |
| 51 | `odstep(p)` | Odstęp styków sąsiednich wieńców [mm]: mijanka, nie mniej niż 300. |
| 56 | `os(w, p)` | Oś siatek styków na osi ściany [mm]: najwyższy punkt linii szczytu (kalenica); linia prosta – środek ściany. |
| 64 | `pozycje(w, wn, i, a, b, p)` | Miejsca styków w kawałku a…b wieńca szczytu wn (indeks i od dołu ściany): [] – kawałek mieści się w maksymalnym balu albo nie ma gdzie go połączyć (wtedy ostrzeżenie o za długim balu daje rdzen/bale.rb). |
| 80 | `proba(w, i, a, b, k, strefy, lmin, lmax, p)` | Jedna próba: k styków, każdy w wolnym miejscu siatki najbliżej punktu równego podziału, kawałki od najkrótszego do maksymalnego bala; nil – nie da się. |
| 93 | `najblizszy(w, i, cel, lo, hi, strefy, p)` | Wolne miejsce siatki wieńca i najbliższe celu w zakresie lo…hi; nil – brak. |
| 99 | `siatka(w, i, lo, hi, p)` | Miejsca siatki wieńca i w zakresie lo…hi: oś − pół mijanki (wieńce parzyste) albo oś + pół mijanki (nieparzyste), dalej co 2 × mijanka. |
| 114 | `strefy_zakazane(w, wn, i, p)` | Przedziały osi ściany, w których styk wieńca szczytu wn (indeks i) nie może wypaść: zamki skrzyżowań (1,5 grubości od osi), otwory sięgające szczytu z zapasem jak dla styków, gniazda płatwi przy tym wieńcu, a nad najwyższym wieńcem ściany pod szczytem – mijanka od jego styków. |
| 134 | `styki_pod(w, wn, i, gora)` | Styki wieńca tuż pod wieńcem szczytu wn, gdy jest to jeszcze wieniec ściany (łączony w zamkach – rdzen/styki.rb). |

### rdzen/styki_tarasu.rb (102 wierszy)

łączenie bali frontu tarasu z podciągiem (podciąg, bale spinające, szczyt nad tarasem, balustrada z wieńców) na styk – bez węgła i zamków, na przemian z mijanką; najniższy bal podciągu łączony nad słupem.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wieńce frontu), rdzen/taras.rb (front, słupy frontu)
Używają: rdzen/styki.rb (front tarasu zamiast węgłów pod styki), rdzen/kontrola.rb (styk na styk nie jest „stykiem bez zamka”)

| Wiersz | Element | Opis |
|---:|---|---|
| 26 | `module StykiTarasu` |  |
| 28 | `ZAPAS` | Najwięcej dodatkowych miejsc łączenia ponad najmniejszą potrzebną liczbę. |
| 34 | `dotyczy?(w, p)` | Czy bale ściany łączy się na styk bez węgła: front tarasu z balami (typ 200; typ 300 ze szczytem frontu – runda 18) przy taras_styk = styk. |
| 40 | `na_styk?(w)` | Czy ściana ma styki na styk (plan z tego pliku) – kontrola nie szuka w nich zamka. |
| 47 | `planuj(w, p)` | Plan styków frontu (zasięg bali w – z wypustami górnych wieńców): najmniej miejsc łączenia, najpierw nad słupami, potem w punktach równego podziału; nil – nie da się (kawałki dłuższe niż maksymalny bal). |
| 64 | `proba(w, p, k, podpory)` | Jedna próba: k miejsc łączenia przy punktach równego podziału, każde w najbliższej podporze z listy (pusta – w samym punkcie podziału); wieńce parzystości najniższego bala podciągu łączone w podporze, pozostałe o mijankę w stronę punktu podziału. nil – kawałki za długie, za krótkie albo styk w zamku skrzyżowania. |
| 83 | `dobre?(w, p, bazy, drugie)` | Czy listy styków obu parzystości dają kawałki nie dłuższe niż maksymalny bal i nie krótsze niż najkrótszy kawałek, styki sąsiednich wieńców mijają się o co najmniej 300, a żaden nie wypada w zamku skrzyżowania (narożniki, węgły z tabeli). |
| 96 | `parzystosc_podciagu(w, p)` | Indeks wieńca (od dołu ściany) najniższego bala podciągu frontu – jego styki wypadają nad słupami. |

### rdzen/symetria_wegly.rb (119 wierszy)

węgły symetrycznie na ścianach równoległych – ściana bliźniacza (ta sama oś w świecie, ten sam zasięg) dostaje styki i węgły w tych samych miejscach co ściana policzona wcześniej; równy podział odcinków między ścianami przy rozmieszczeniu „równo”.

Zależy od: rdzen/parametry.rb, rdzen/styki.rb (kotwice, miejsce styku, kawałki), rdzen/usztywnienie.rb (miejsce na węgieł)
Używają: rdzen/styki.rb (planuj, na_przemian), rdzen/usztywnienie.rb (planuj)

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `module SymetriaWegly` |  |
| 23 | `TOL` | Tolerancja zgodności zasięgów i skrzyżowań [mm]. |
| 25 | `PODZIAL_MAX` | Największa liczba części odcinka przy równym podziale. |
| 30 | `os(w)` | Indeks współrzędnej świata wzdłuż osi ściany (0 – x, 1 – y). |
| 35 | `swiat(w, s)` | Współrzędna świata punktu s ściany (wzdłuż jej osi). |
| 40 | `s_ze_swiata(w, x)` | Punkt s ściany dla współrzędnej świata x. |
| 45 | `zasieg(w)` | Zasięg bali ściany w świecie [min, max]. |
| 50 | `blizniak(w, lista)` | Ściana bliźniacza z listy (już policzonych): ten sam kierunek, oś równoległa, ten sam zasięg; nil – brak. |
| 60 | `przenies(w, x, lista)` | Lista miejsc ściany x przeniesiona na ścianę w (posortowana). |
| 66 | `styki(w, x, p)` | Styki ściany w w tych samych miejscach co u bliźniaka x (plan x[:styki]); nil – nie da się (nowe węgły w miejscach zakazanych, kawałki dłuższe niż bal, styk wspólny bez skrzyżowania). |
| 90 | `usztywnienie(w, x, a, b)` | Węgły usztywniające bliźniaka x w odcinku a…b ściany w (przeniesione); nil – bliźniak nie ma tu węgłów albo któryś nie może stanąć (blok: s → czy miejsce dobre przy już wybranych). |
| 104 | `podzialy(w, p)` | Punkty równego podziału odcinków między skrzyżowaniami ściany (na 2 … PODZIAL_MAX części, najpierw najmniej części) – kandydaci na nowe węgły pod styki przy rozmieszczeniu „równo”; tylko miejsca, w których węgieł może stanąć. |

### rdzen/szczyty.rb (404 wierszy)

szczyty z bali – które ściany mają szczyt, wieńce szczytu do kalenicy, skos bali wg linii dachu, gniazda pod płatwie.

Zależy od: rdzen/parametry.rb, rdzen/podbitka.rb (węgły przy szczycie pod podbitką), rdzen/wience.rb, rdzen/dach.rb (linia szczytu, płatwie), rdzen/dach_jednospadowy.rb (ściana wysoka), rdzen/taras.rb (szczyt ściany domu przy tarasie), rdzen/zamek_platwi.rb (gniazdo pod wrąb płatwi), rdzen/zadaszenie.rb (przekrój dachu z zadaszeniem, płatwie zadaszenia)
Używają: rdzen/projekt.rb, rdzen/wience.rb (liczba wieńców szczytu), rdzen/bale.rb (zasięg i skos bali), rdzen/pozycje.rb (prefiks Sz)

| Wiersz | Element | Opis |
|---:|---|---|
| 29 | `module Szczyty` |  |
| 33 | `przygotuj(sciany, p, os_kalenicy)` | Ściany ze szczytem (w[:szczyt]) i opis dachu domu prostokątnego; zwraca { uwagi:, dom: (nil – bez belek dachu) }. |
| 68 | `dom_l(sciany, p, os_kalenicy, wynik)` | Dom w kształcie L (rdzen/skrzydla.rb): dach główny i skrzydło boczne z kalenicą w poprzek – szczyty obu dachów, ściany okapowe skrzydła bocznego; krokwie tylko z aplikacji do dachów. |
| 89 | `dzialowe_do_dachu!(sciany, dom, p, z_okap)` | Działowe wzdłuż kalenicy do dachu (dzialowa_wzdluz_do_dachu, dom prostokątny): szczyt płaski jak ściana wysoka dachu jednospadowego – wieńce do linii podparcia na wyższym licu, górny bal ścięty do płaszczyzny dachu (rdzen/sciecie_dachu.rb); płatew nad działową (kalenicowa) wycina gniazdo na całej długości – działowa ją podpiera. |
| 110 | `sciany_przybudowki!(sciany, dom, p, z_okap)` | Ściana zewnętrzna przybudówki (rdzen/zadaszenie.rb): szczyt płaski do połaci zadaszenia – wieńce do linii podparcia na licu od strony domu (wyższym), wyższe pominięte, górny bal ścięty do płaszczyzny zadaszenia (rdzen/sciecie_dachu.rb). |
| 125 | `jednospadowy(sciany, wynik, p, z_okap)` | Dach jednospadowy (dom prostokątny): ściana wysoka dostaje szczyt płaski (do połaci); inny obrys – bez szczytów z ostrzeżeniem. Zwraca wynik przygotuj (z uwagami). |
| 134 | `z_max(w, p)` | Najwyższy punkt linii szczytu ściany [mm]: kalenica (dwuspadowy) albo wyższy koniec ściany (jednospadowy). |
| 141 | `szczytowa?(w, p)` | Czy ściana dostaje szczyt: zewnętrzna szczytowa od narożnika do narożnika albo działowa szczytowa od ściany do ściany (niższa działowa – pod stropem, antresolą, półką – szczytu nie ma). |
| 152 | `dom_prostokatny(sciany, szczytowe, os)` | Opis dachu domu prostokątnego (4 ściany zewnętrzne, 2 szczyty): { os:, v_a:, v_b:, u1:, u2:, wewn: [u szczytów na działowych] }; nil w innym przypadku. |
| 166 | `v_z_s(w, s)` | Współrzędna v punktu s ściany ze szczytem. |
| 171 | `s_z_v(w, v)` | Współrzędna s ściany dla v. |
| 177 | `linia(w, s, p)` | Linia szczytu (wierzch bali) w miejscu s ściany [mm]; szczyt płaski (ściana wysoka dachu jednospadowego) – linia podparcia przy jej licu wewnętrznym (krokwie i deski leżą na ścianie); bez szczytu – nil. |
| 186 | `w_zakresie?(g, s)` | Czy miejsce s ściany leży pod szczytem g (szczyt na części ściany domu L – g[:s_zakres]; inny – zawsze). |
| 192 | `gora_wlasna(w, p)` | Góra ściany bez wieńców szczytu [mm] – linia szczytu poza zakresem szczytu na części ściany. |
| 199 | `zalom(w, p)` | Załomy linii szczytu – s ściany: kalenica i linie załamania bocznego zadaszenia; dach jednospadowy i szczyt płaski – [] (linia prosta). |
| 206 | `pod_linia?(w, s, z, p)` | Czy wysokość z w miejscu s ściany jest pod linią szczytu (ściana bez szczytu – zawsze). |
| 213 | `pod_podparciem?(w, s, z, p, dz = nil)` | Czy wysokość z w miejscu s ściany jest pod linią podparcia (spód krokwi / desek) – dla węgłów przy szczycie, które wystają z obu stron szczytu pod połać; ściana bez szczytu – zawsze. |
| 221 | `zasieg(w, z0, p)` | Zasięg [s0, s1] wieńca o spodzie z0, w którym linia szczytu jest wyżej niż z0 + najniższy kawałek (szczyt płaski – najcieńszy pasek górnego bala ściany wysokiej, jednospad_min_pasek; ściana przybudówki – pasek na niższym licu); nil – brak bala. |
| 234 | `zasieg_czesci(w, z0, m, p)` | Zasięg wieńca ściany ze szczytem na części długości (dom L): pod szczytem – pod linią szczytu, poza nim – cała reszta ściany dla wieńców własnych (poniżej góry ściany), nic dla wieńców szczytu. |
| 246 | `zasieg_linii(s_od, s_do, sk, z_min)` | Zasięg [s0, s1] odcinka s_od…s_do, na którym linia dachu (blok: s → wysokość; prosta albo łamana z załomami sk – liczba albo lista; rośnie do kalenicy i maleje za nią) jest wyżej niż z_min; nil – nigdzie (krócej niż 1 mm). |
| 263 | `skosy(w, s0, s1, z0, h, p)` | Obróbki skosu dla kawałka bala s0…s1 o spodzie z0 i wysokości h: [cechy skos_gora w układzie bala]. |
| 278 | `skosy_linii(s0, s1, z0, h, sk)` | Skosy kawałka s0…s1 pod linią daszkową (blok: s → wysokość linii; załomy w sk – liczba albo lista, nil – linia prosta): odcinki, na których linia schodzi poniżej wierzchu bala. |
| 295 | `gniazda(sciany, p, dom)` | Gniazda płatwi (otwory z gniazdo: true); wywołać po stykach i węgłach. Dom prostokątny – każda ściana i węgieł, przez które przechodzi płatew (także działowe i węgły pod płatwią ścienną); inny obrys – tylko szczyty. |
| 320 | `gniazda_sciany(w, platwie, dom, p)` | Gniazda jednej ściany od płatwi domu prostokątnego (dom – opis dachu, przejścia płatwi zapisywane w dom[:przejscia]): ściana w poprzek płatwi – gniazdo na szerokości płatwi w ścianie (zamek płatwi – zwężona i podcięta od spodu, rdzen/zamek_platwi.rb) z luzem; ściana wzdłuż płatwi i pod nią – na całej długości. |
| 375 | `gniazda_wegla(w, pl, p)` | wrąb płatwi, płatew leży na węgle. Gdy górny bal węgła nie ma w słupie zamka drewna nad gniazdem dolnym (gniazdo + najcieńszy pasek), słup zamka jest otwarty od jego spodu – bal dzieli się na kawałek wewnątrz i na zewnątrz ściany (oba leżą na niższym balu węgła), w słupie płatew opiera się na balu ściany. |
| 389 | `dodaj_gniazdo(w, s, pl, z0 = pl[:z_spod])` | Gniazdo płatwi w ścianie: otwór od dna z0 (spód płatwi albo jej wrębu) w górę na odcinku s. |
| 397 | `bal_szczytu?(b)` | Czy bal należy do szczytu (prefiks Sz): ma skos albo leży nad ścianami okapowymi (ściana wysoka dachu jednospadowego – bale ścienne Bs). |

### rdzen/taras.rb (325 wierszy)

taras przed ścianą szczytową domu prostokątnego – obrys przedłużony o głębokość tarasu, ściana domu jako działowa ze szczytem, wariant 1100 (górne wieńce ścian nad tarasem jako podciąg na słupach) albo 1200 (ściany boczne pełne, front otwarty), słupy tarasu.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb, rdzen/elementy.rb, rdzen/sciany.rb (oś kalenicy), rdzen/taras_sciany.rb (balustrada z wieńców ścian)
Używają: rdzen/projekt.rb, rdzen/sciany.rb (opis ściany), rdzen/szczyty.rb (szczyt ściany domu), rdzen/bale.rb (zasięg wieńca), rdzen/usztywnienie.rb, rdzen/taras_balustrada.rb, rdzen/taras_slupy.rb, rdzen/taras_szczyt.rb, rdzen/wience.rb (półbal frontu – w[:taras][:z_polbal])

| Wiersz | Element | Opis |
|---:|---|---|
| 33 | `module Taras` |  |
| 34 | `WARIANTY` |  |
| 39 | `wlaczony?(p)` | Czy taras jest włączony. |
| 46 | `przedluz!(ob, p)` | Obrys przedłużony o taras (ob z Obrys.rozpoznaj – obrys, działowe, kontrfory w układzie lokalnym): bok obrysu po stronie tarasu przesunięty o głębokość, oś dawnej ściany szczytowej dopisana jako działowa (końce działowych narysowanych do jej lica przeniesione na oś), ob[:os_kalenicy] i ob[:taras]; zwraca ostrzeżenia. |
| 74 | `punkt_uv(iu, u, v)` | Punkt układu lokalnego z współrzędnych wzdłuż kalenicy (u, indeks iu) i w poprzek (v). |
| 79 | `prostokat?(pts)` | Czy obrys to prostokąt o bokach wzdłuż osi. |
| 91 | `oznacz!(sciany, info, p)` | Role ścian tarasu (po ustawieniach ścian, przed szczytami): front, ściana domu, ściany boczne z końcem dolnych bali (s_dol), osiami frontu i ściany domu (s_front, s_dom), kierunkiem do frontu (kier) i spodem podciągu (z_bok – ściany boczne, z_front – front). |
| 118 | `front_z_balami?(tr, p)` | Czy front tarasu ma bale (podciąg z górnych wieńców i szczyt): typ 200 zawsze, typ 300 – przy taras_sciany_front = szczyt (runda 18, P2: płatwie nad tarasem podparte od frontu); tr – w[:taras] albo opis tarasu z wariantem. |
| 124 | `z_podciagu(w, p)` | Spód podciągu ścian bocznych – najniższy z górnych taras_wience_gorne wieńców ściany bocznej [mm]. |
| 132 | `rola(w)` | Rola ściany w tarasie (:front, :dom, :bok) albo nil. |
| 137 | `sciana_domu?(w)` | Czy to ściana domu przy tarasie (działowa, która dostaje szczyt). |
| 142 | `front?(w)` | Czy front tarasu (bez węgłów usztywniających – dołem otwarty albo bez bali). |
| 147 | `przeslona_tarasu?(w, a, b)` | Czy odcinek a…b ściany bocznej leży nad tarasem z podciągiem (bez dolnych bali – bez węgłów usztywniających). |
| 155 | `opis(w)` | Opis ściany tarasu do okna (nil – zwykła ściana). |
| 163 | `zasieg(w, z0, zas, p)` | Zasięg wieńca o spodzie z0 ściany tarasu (zas – zasięg bez tarasu); nil – brak bala w tym wieńcu. |
| 192 | `slupy_frontu(front, p)` | Słupy pod frontem (s): narożniki (licem równo z licami ścian bocznych), boki wejścia, słup w osi kalenicy (taras_slup_w_osi – w jednej linii ze słupkiem wiązara nad nim) i pośrednie co najwyżej taras_slupy_rozstaw_max; { slupy:, wejscie: [a, b] osi słupów przy wejściu albo nil, os: s słupa w osi kalenicy albo nil }. |
| 216 | `uwagi_wejscia(sciany, p)` | Ostrzeżenie, gdy słup wejścia stanął w osi kalenicy i wejście ma inną szerokość w świetle niż podana; [] – bez zmian. |
| 230 | `os_frontu(front)` | Oś kalenicy na froncie (s) – środek osi frontu (dach dwuspadowy nad domem prostokątnym). |
| 238 | `slup_w_osi(front, p, c1, c2, wejscie)` | [s słupa albo nil, wejście]. Wejście z boku, którego słup stoi bliżej osi niż taras_slup_os_dociag – ten słup staje w osi (wejście szersze albo węższe o tę odległość, zamiast dwóch słupów obok siebie); oś w świetle wejścia (wejście pośrodku albo szerokie) – bez słupa w osi; pozostałe słupy pośrednie równo po obu stronach osi. |
| 257 | `wejscie_z_boku(front, c1, c2, szer, lewa)` | Osie słupów przy wejściu z lewej / prawej strony frontu (patrząc na front z zewnątrz). |
| 268 | `strefy_slupow(w, p)` | Strefy ściany tarasu (s), w których nie może stanąć węgieł – słupy (front i ściany boczne nad tarasem) z zapasem pół grubości ściany i odstępu skrzyżowań: [[lo, hi]]. |
| 283 | `wegly_przy_slupach!(sciany, p)` | Węgły (z rysunku, ręczne, z tabeli) w strefie słupa tarasu usunięte – słup stoi w ich miejscu; zwraca ostrzeżenia. |
| 297 | `posrednie(a, z, p)` | Słupy pośrednie między osiami a…z (równo, rozstaw nie większy niż taras_slupy_rozstaw_max). |
| 304 | `przesla(sciany, p)` | Przęsła balustrady [[ściana, a, b]] (s między licami słupów, ściany domu i dolnych bali): ściany boczne – od końca dolnych bali do słupa narożnego (podzielone słupami pośrednimi), front – między słupami poza wejściem. |

### rdzen/taras_balustrada.rb (97 wierszy)

balustrada tarasu z bali (jak 1100) – w przęsłach między słupami i ścianą domu bale na przemian z rzędami przekładek (odcinków bala), w siatce wieńców ściany.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb, rdzen/taras.rb (przęsła)
Używają: rdzen/projekt.rb (po Bale.zbuduj)

| Wiersz | Element | Opis |
|---:|---|---|
| 25 | `module TarasBalustrada` |  |
| 29 | `dodaj!(przesla, wynik, p)` | Balustrada w przęsłach [[ściana, a, b]] (Taras.przesla): bale dopisane do ścian i do wynik[:bale] (Bale.zbuduj). |
| 52 | `wysokosc_poreczy(przesla, n, p)` | Wspólna wysokość poręczy (wierzch najwyższego bala balustrady) na froncie i ścianach bocznych – najniższy z wierzchów najwyższych bali [mm]; nil – bez przęseł. |
| 59 | `porecz(wn, dl, gora)` | Obróbki poręczy (najwyższego bala balustrady) o długości dl: wierzch ścięty do wspólnej wysokości gora (front i ściany boczne mają wieńce przesunięte o pół – wyższy bal ścięty) i bez piór (pełny profil – wierzch płaski). |
| 67 | `wience(w, n, p)` | Wieńce balustrady ściany w: [[wieniec, indeks, :bal \| :przekladki]] – pod podciągiem tarasu, n pełnych bali. |
| 80 | `bale(a, b, p)` | Bal balustrady w przęśle a…b – dzielony równo, gdy dłuższy niż maksymalny bal. |
| 86 | `przekladki(a, b, p)` | Przekładki w przęśle a…b: przy obu końcach i równo między nimi, prześwit najwyżej taras_przekladka_odstep. |

### rdzen/taras_sciany.rb (120 wierszy)

balustrada tarasu z wieńców ścian – dolne wieńce ścian bocznych biegną ciągle przez całą długość tarasu, front w tych wieńcach z balami między ścianami bocznymi (przerwa na wejście), w narożnikach frontu zamki z zakładką (co druga belka wysunięta) albo równo z licem; poręcz na jednej wysokości.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wieńce ściany), rdzen/taras.rb (role ścian, słupy frontu)
Używają: rdzen/taras.rb (zasięg wieńca), rdzen/bale.rb (przedziały – wejście), rdzen/projekt.rb (poręcz), rdzen/taras_slupy.rb (pasy słupów)

| Wiersz | Element | Opis |
|---:|---|---|
| 25 | `module TarasSciany` |  |
| 29 | `wlaczona?(p)` | Czy balustrada z wieńców ścian (taras z podciągiem). |
| 34 | `w_balustradzie?(z0, h, p)` | Czy wieniec o spodzie z0 i wysokości h należy do balustrady (wierzch nie wyżej niż wysokość balustrady). |
| 39 | `wypust(p)` | Wypust bala za licem w narożniku frontu [mm] (zakładka albo 0 – równo z licem). |
| 45 | `zasieg(w, z0, h, zas, p)` | Zasięg wieńca o spodzie z0 (h – wysokość) ściany tarasu w balustradzie z wieńców: front i ściana boczna – pełny, koniec przy narożniku frontu z wypustem zakładki; nad balustradą – nil (dalej decyduje Taras.zasieg). |
| 64 | `przedzialy(w, wn, bazy, p)` | Przedziały wieńca frontu w balustradzie z przerwą na wejście (między licami słupów przy wejściu); bazy – przedziały bez przerwy. |
| 74 | `gora_sciany(w, p)` | Wierzch balustrady (najwyższy wierzch wieńców balustrady ściany) [mm]; nil – brak wieńców. |
| 80 | `limit(w)` | Spód podciągu ściany tarasu (front – z_front, bok – z_bok). |
| 85 | `wysokosc_poreczy(sciany, p)` | Wspólna wysokość poręczy – najniższy z wierzchów balustrad frontu i ścian bocznych [mm]; nil – brak. |
| 92 | `porecz!(sciany, p)` | Poręcz: najwyższe bale balustrady frontu i ścian bocznych (część nad tarasem) ścięte do wspólnej wysokości i bez piór (wierzch płaski). Ściana boczna – tylko odcinek od lica ściany domu do frontu. |
| 111 | `odcinek_tarasu(w, b, t)` | Odcinek bala b nad tarasem [x0, x1] w układzie bala: front – cały, ściana boczna – od lica ściany domu do końca. |

### rdzen/taras_slupy.rb (138 wierszy)

słupy tarasu z podciągiem – licem równo z licami ścian zewnętrznych, zamek górny (część słupa za balem idzie w górę obok bala) i zamek dolny (część słupa obok podwaliny schodzi w dół).

Zależy od: rdzen/parametry.rb, rdzen/elementy.rb, rdzen/taras.rb (role ścian, słupy frontu, słupy pośrednie), rdzen/taras_sciany.rb (balustrada z wieńców – pas słupa), rdzen/taras_wiazar.rb (front bez bali – lico wiązara), rdzen/osiadanie.rb (słup krótszy o osiadanie ścian)
Używają: rdzen/projekt.rb (belki – słupy S)

| Wiersz | Element | Opis |
|---:|---|---|
| 33 | `module TarasSlupy` |  |
| 38 | `slupy(sciany, p)` | Słupy tarasu z podciągiem (elementy S): pod frontem (narożne licem z licami obu ścian) i pośrednie pod ścianami bocznymi; wierzch pełnego przekroju na spodzie podciągu. |
| 56 | `srodek_domu(sciany)` | Środek obrysu (średnia punktów ścian zewnętrznych) – do strony wewnętrznej ścian. |
| 63 | `nor_do_srodka?(w, srodek)` | Czy normalna ściany w lewo (w[:nor]) patrzy do środka domu. |
| 68 | `zamek_dolny(p, g)` | Zamek dolny: [długość, szerokość pasa podwaliny] albo nil (bez podłogi, długość 0 albo podwalina szersza niż słup). |
| 79 | `slup(w, s, z_gora, srodek, naroznik, p, lico = nil)` | Słup w ścianie w w miejscu s (oś słupu wzdłuż ściany), wierzch pełnego przekroju na z_gora (lico – grubość pasa przy licu w zamku górnym: ściana albo wiązar bez bali frontu); naroznik – 0 (koniec przy s = 0 – pas ściany poprzecznej przy y = 0), 1 (przy końcu ściany – przy y = b) albo nil. |
| 115 | `skrzyzowanie_nad?(w, s, b, t)` | Czy nad słupem w miejscu s ściany w stoi węgieł albo działowa (nie narożnik) – zamek górny wszedłby w jej bale. |
| 120 | `poczatek(w, s, b, g, t, do_srodka, z0)` | Początek belki słupa (y = 0, z = 0, spód): lico zewnętrzne słupa w licu ściany. |
| 128 | `pas_lica(x0, x1, gleb, do_srodka)` | Pas przy licu zewnętrznym słupa (szerokość gleb) na x0…x1 – wycięty. |
| 133 | `pas_boku(x0, x1, gleb, naroznik)` | Pas ściany poprzecznej przy słupie narożnym (szerokość gleb, przy y = 0 albo y = b) na x0…x1 – wycięty. |

### rdzen/taras_szczyt.rb (113 wierszy)

szczyt nad tarasem z podciągiem – pełny (jak 1100), ażurowy (bale na przemian z rzędami przekładek, jak balustrada) albo pusty (kilka bali spinających nad podciągiem i wiązar z rdzen/taras_wiazar.rb albo słupki z przekładek pod płatwiami; wiązar na słupach – front bez bali).

Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wysokość ścian okapowych), rdzen/szczyty.rb (zasięg pod linią szczytu, s ↔ v), rdzen/dach.rb (płatwie), rdzen/taras.rb (front z balami)
Używają: rdzen/bale.rb (kawałki wieńca frontu tarasu), rdzen/taras_wiazar.rb (czy wiązar, front bez bali)

| Wiersz | Element | Opis |
|---:|---|---|
| 25 | `module TarasSzczyt` |  |
| 29 | `dotyczy?(w, p)` | Czy ściana to front tarasu z balami (typ 200, typ 300 ze szczytem frontu) ze szczytem innym niż pełny. |
| 35 | `numer(w, z0, p)` | Numer wieńca szczytu (0 – pierwszy nad balem zamykającym się ze ścianami bocznymi) albo nil (podciąg, balustrada). |
| 44 | `przedzialy(w, wn, zas, p)` | Przedziały bali wieńca o spodzie z0 na froncie tarasu (zas – zasięg pod linią szczytu): pełny wieniec – [zas], wieniec przekładek – kawałki przekładek, bez kawałków – []. |
| 57 | `przekladki(w, wn, zas, p, wypelnij)` | Kawałki przekładek w wieńcu (zas – zasięg wieńca); wypelnij – także przy końcach i między (ażurowy), inaczej tylko pod płatwiami (pusty). |
| 73 | `wieniec?(p)` | Czy szczyt pusty ma trójkątny wieniec – wiązar (rdzen/taras_wiazar.rb, zamiast słupków z przekładek); dach dwuspadowy. |
| 78 | `bez_bali?(w, p)` | Czy front tarasu jest bez bali od podciągu w górę (wiązar na słupach – z przodu sam trójkąt, runda 9). |
| 83 | `osie_platwi(w, p)` | Osie płatwi na froncie (s ściany). |
| 88 | `uzupelnij(srodki, l, odstep)` | Dodatkowe środki przekładek tam, gdzie prześwit między sąsiednimi przekracza odstęp (równo w luce). |
| 102 | `scal(kawalki)` | Nachodzące na siebie kawałki scalone w jeden. |

### rdzen/taras_wiazar.rb (367 wierszy)

wiązar (trójkąt) nad pustym szczytem frontu tarasu – dwie ciągłe krokwie wiązara pod płatwiami (płatwie leżą na nich w płytkich gniazdach – zamkach), belka dolna, słupek pod kalenicą i opcjonalnie dwa zastrzały od stopy słupka pod zadanym kątem (45°); licem z licem zewnętrznym frontu; na balach frontu albo na słupach bez bali; wręby płatwi na grubości wiązara.

Zależy od: rdzen/statyka_wiazara.rb (tylko wynik doboru w parametrach – p['taras_wieniec_dobrany']), rdzen/parametry.rb, rdzen/dach.rb (linia szczytu, płatwie), rdzen/elementy.rb (belka), rdzen/zamek_platwi.rb (gniazdo pod wrąb płatwi), rdzen/taras_szczyt.rb (czy szczyt pusty z wiązarem)
Używają: rdzen/projekt.rb (przejścia płatwi przed belkami dachu, człony wiązara, ostrzeżenie o zastrzałach), rdzen/taras_slupy.rb (grubość lica frontu bez bali), rdzen/taras_szczyt.rb (bez bali frontu)

| Wiersz | Element | Opis |
|---:|---|---|
| 36 | `module TarasWiazar` |  |
| 38 | `MIN_DREWNO` | Najmniej drewna pod gniazdem płatwi w członie [mm]; mniej – człon przecięty gniazdem. |
| 40 | `MIN_TROJKAT` | Najmniejsza wysokość trójkąta nad oparciem [mm] – niższy nie powstaje. |
| 42 | `MIN_SLUPEK` | Najniższy słupek wiązara bez belki dolnej (przy jego licu) [mm]. |
| 43 | `EPS` |  |
| 48 | `front(sciany, p)` | Front tarasu z wiązarem (szczyt pusty z trójkątem) albo nil. |
| 56 | `przekroj(p)` | Przekrój członów wiązara [szerokość wzdłuż kalenicy, wysokość krokwi i belki]: płatwi, podany albo – taras_wieniec = auto – dobrany do obciążenia (rdzen/statyka_wiazara.rb zapisuje go w p['taras_wieniec_dobrany']; w pierwszym przebiegu obliczeń, zanim jest dobrany – przekrój płatwi). |
| 63 | `szerokosc_czlonu(p, klucz)` | Szerokość słupka albo zastrzału w płaszczyźnie frontu [mm] (klucz – pole własnej szerokości): własna albo – przy taras_wiazar_przekroje = jak_wiazar – wysokość przekroju wiązara (cały trójkąt z jednego przekroju, np. płatwi). |
| 69 | `grubosc_lica(w, p)` | Grubość lica frontu przy słupach tarasu [mm]: wiązar bez bali – grubość wiązara, inaczej grubość ściany. |
| 77 | `uklad(w, p)` | Układ wiązara: { os:, iu:, u_c: (oś grubości), bw:, hw:, hv: (wysokość krokwi w pionie), geo:, vk:, zk: (linia szczytu w kalenicy), tg:, v_lo:, v_hi:, z_b0: (spód belki dolnej), z_b1: (wierzch), bok: (wrąb boczny płatwi w wiązarze – 0 przy zamku tylko od spodu), bez: (wiązar na słupach – bez bali frontu) }; nil – brak miejsca. |
| 104 | `postac(u)` | Postać wiązara: :pelny – belka dolna, krokwie, słupek (zastrzały); :krokwie – belka dolna z krokwiami nie mieści się pod dachem (wąski dom, wysoki przekrój): same krokwie na balach frontu; :belka – to samo przy wiązarze na słupach: sama belka dolna ścięta dachem; nil – trójkąt niższy niż MIN_TROJKAT. |
| 113 | `pod_platwiami(geo, p, bok = nil)` | O ile wierzch krokwi wiązara jest pod linią dachu [mm]: tak, żeby dno gniazda każdej płatwi (spód jej wrębu) było przy niższej krawędzi gniazda co najmniej taras_wiazar_gniazdo pod wierzchem krokwi – płatwie leżą na wiązarze, krokwie wiązara zostają ciągłe; bok – wrąb boczny płatwi w wiązarze (nil – z parametrów). |
| 125 | `przejscia!(sciany, dom, p)` | Przejścia płatwi przez wiązar (dom[:przejscia] z grubością t – wręby płatwi na grubości wiązara, bok – wrąb boczny: 0 przy zamku tylko od spodu); przed belkami dachu (Dach.elementy). |
| 139 | `elementy(sciany, p)` | Człony wiązara (elementy Wt); brak wiązara – []. |
| 156 | `uwagi(sciany, p)` | Ostrzeżenia: trójkąt w postaci uproszczonej albo wcale (za niski – wąski dom, wysoki przekrój), wybrane zastrzały się nie mieszczą (wiązar powstaje bez nich); [] – w porządku. |
| 175 | `gniazda_platwi(u, p)` | Gniazda płatwi w płaszczyźnie wiązara: [[v0, v1, z_dna]] (szerokość płatwi w wrębie – przy zamku tylko od spodu pełna szerokość płatwi, dno na spodzie wrębu). |
| 185 | `czlony(u, p)` | Człony w postaci { v0:, v1:, gora: [[a, b]], dol: [[a, b]] } (proste z = a + b·v): krokwie, belka dolna, słupek, zastrzały (rodzaj taras_wiazar); postać uproszczona (postac) – same krokwie na balach frontu ze słupkiem, gdy się mieści, albo sama belka dolna. |
| 208 | `krokwie_na_balach(u, zl, zr, spod_l, spod_r, a)` | Wiązar bez belki dolnej: dwie krokwie od wierzchu bali frontu do kalenicy (stopy ścięte poziomo na balach) i słupek od bali do krokwi, gdy przy jego licu zostaje co najmniej MIN_SLUPEK wysokości. |
| 222 | `zastrzaly(u, p, spod_l, spod_r, a)` | taras_wiazar_zastrzal_kat od poziomu (wymóg użytkownika, runda 10: 45° – podparcie krokwi i ozdoba); kąt 0 albo nie większy niż kąt dachu – do połowy wolnego spodu krokwi; szerokość taras_wiazar_zastrzal albo jak wiązar (szerokosc_czlonu); [] – za mało miejsca. |
| 247 | `wartosc(proste, v, min)` | Wartość minimum (gora) albo maksimum (dol) prostych w v. |
| 254 | `wielokaty(c, gniazda)` | Wielokąty członu (lista punktów [v, z]) – obszar B ≤ z ≤ T na odcinku v0…v1 z gniazdami płatwi w wierzchu; gniazdo, pod którym zostaje mniej niż MIN_DREWNO, przecina człon na części. |
| 268 | `punkty(c, x0, x1, gniazda)` | Punkty v podziału: końce, przecięcia prostych, krawędzie gniazd w x0…x1. |
| 281 | `obrys(c, x0, x1, gniazda)` | Obrys części członu x0…x1: zakres, gdzie T > B, spód od lewej, wierzch (z gniazdami) od prawej; nil – pusty. |
| 300 | `zakres(vs, roznica, lewy)` | Skrajny v (od lewej – lewy = true, od prawej – false), w którym człon ma grubość (T > B), z interpolacją. |
| 315 | `wierzch(c, v, gniazda, strona)` | Wierzch członu w v po stronie strona (+1 – z prawej, −1 – z lewej krawędzi gniazda): T albo dno gniazda. |
| 323 | `uprosc(pts)` | Wielokąt bez powtórzonych i współliniowych punktów; nil – mniej niż 3 punkty. |
| 345 | `belka(u, ksztalt)` | Człon Wt: graniastosłup wzdłuż kalenicy (od u_c − bw/2 do u_c + bw/2) o przekroju ksztalt ([v, z] w płaszczyźnie frontu) – przekrój w układzie belki (y wzdłuż v jak w Elementy.pozioma, z od spodu członu). |
| 359 | `pole(pts)` | Pole wielokąta [[y, z]] ze znakiem (dodatnie – przeciwnie do wskazówek). |

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

### rdzen/usztywnienie.rb (175 wierszy)

węgły 244 usztywniające ściany – limit światła ściany (zwykłej i wysokiej), rozmieszczenie nowych węgłów, miejsce, w którym węgieł może stanąć.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wysokość ścian), rdzen/sciany.rb (dodaj_kontrfor), rdzen/otwory.rb (strefy otworów), rdzen/taras.rb (front i przęsła tarasu bez węgłów), rdzen/symetria_wegly.rb (węgły jak na ścianie równoległej)
Używają: rdzen/projekt.rb, rdzen/styki.rb (miejsce_ok?, wolne_miejsce)

| Wiersz | Element | Opis |
|---:|---|---|
| 24 | `module Usztywnienie` |  |
| 26 | `KROK` | Krok przesuwania nowego węgła przy szukaniu wolnego miejsca [mm]. |
| 31 | `limit_swiatla(p)` | Limit światła ściany dla tego domu (zwykły albo dla ścian wysokich) [mm]. |
| 37 | `planuj(sciany, p, os_kalenicy)` | Dostawia węgły tam, gdzie światło ściany przekracza limit; zwraca ostrzeżenia. |
| 78 | `z_blizniaka(w, bl, p, a, b, limit)` | Węgły w odcinku a…b w tych samych miejscach co na ścianie równoległej bl (symetria); nil – nie da się (miejsce zajęte, światło dłuższe niż limit). |
| 86 | `przeslony(w)` | Odcinki ściany między kolejnymi podparciami: [[s_a, s_b, narożnik_a?, narożnik_b?], …] (osie skrzyżowań). |
| 93 | `rozmiesc(w, p, a, b, limit)` | Położenia nowych węgłów w odcinku a…b (rozmieszczenie z parametrów); nil – nie da się. „od_naroznikow”: przy każdym narożniku odcinka węgieł w zadanej odległości (symetrycznie), reszta równo. |
| 122 | `rowno(w, p, a, b, limit, zajete)` | Węgły równo w odcinku a…b: najmniejsza liczba, przy której każde światło ≤ limit; nil – nie da się. |
| 144 | `naroznik?(w, s)` | Czy w miejscu s ściany jest narożnik. |
| 150 | `miejsce_ok?(w, p, s, zajete)` | Czy w miejscu s może stanąć nowy węgieł (odstęp od skrzyżowań, otworów, końców ściany); ściana z węgłami ustawionymi ręcznie – nigdzie (automat jej nie zmienia). |
| 163 | `wolne_miejsce(w, cel, lo, hi)` | Najbliższe celu miejsce w zakresie lo…hi (krok KROK), dla którego blok zwraca prawdę; nil gdy brak. |

### rdzen/uwagi_pola.rb (84 wierszy)

jedna lista uwag do okna – błędy, ostrzeżenia i podpowiedzi z planu z poziomem, krokiem okna i polem albo sekcją, do której uwaga prowadzi (kliknięcie uwagi przenosi do pola).

Zależy od: rdzen/poziomy.rb (kroki), rdzen/parametry_lista.rb (pola)
Używają: sketchup/sterowanie.rb (wynik do okna – 'uwagi'), html/uwagi.js (lista), html/kroki.js (znaczniki kroków)

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `module UwagiPola` |  |
| 21 | `WZORCE` | [wzorzec tekstu, klucz pola albo nil, sekcja (gdy bez pola)] – kolejność ma znaczenie. |
| 56 | `miejsce(tekst, sekcja = nil)` | Pole i sekcja uwagi o podanym tekście: [klucz albo nil, sekcja albo nil]; sekcja – z pola, z wzorca albo podana. |
| 65 | `uwaga(tekst, poziom, sekcja = nil)` | Jedna uwaga do okna. |
| 73 | `lista(plan)` | Lista uwag z planu: błędy ('blad'), ostrzeżenia ('ostrzezenie') i podpowiedzi ('blad' \| 'uwaga' \| 'ok'). |

### rdzen/wegly_konstrukcyjne.rb (151 wierszy)

węgły dostawiane automatycznie tam, gdzie wymaga ich konstrukcja – pod płatwiami przechodzącymi przez szczyt (słupek węgła do spodu płatwi, płatew na nim leży) i na wolnym końcu niepełnej ściany (bez węgła koniec jest wiotki).

Zależy od: rdzen/parametry.rb, rdzen/sciany.rb (dodaj_kontrfor), rdzen/usztywnienie.rb (miejsce_ok?), rdzen/szczyty.rb (s ↔ v), rdzen/dach.rb (płatwie), rdzen/taras.rb (front i ściana domu przy tarasie), rdzen/podbitka.rb (deski pod płatwiami)
Używają: rdzen/projekt.rb (po węgłach z tabeli, przed stykami i węgłami usztywniającymi), rdzen/bale.rb (górny bal węgła pod płatwią – kf[:pod_platwia])

| Wiersz | Element | Opis |
|---:|---|---|
| 36 | `module WeglyKonstrukcyjne` |  |
| 40 | `dodaj(sciany, p, os_kalenicy, dom)` | Węgły pod płatwiami i na wolnych końcach ścian (dom – opis dachu z Szczyty.przygotuj); zwraca ostrzeżenia. |
| 48 | `sciana_pod_platwiami?(w, p)` | Czy ściana dostaje węgły pod płatwiami (szczyt nie płaski, nie front tarasu, rodzaj wg parametru). |
| 56 | `platew_z_weglem?(pl, p)` | Czy pod płatwią pl stawia się węgieł (wegly_pod_platwiami_ktore: wszystkie płatwie albo tylko kalenicowa). |
| 61 | `wegiel_w_osi(w, s)` | Węgieł ściany w stojący już w osi płatwi (miejsce s) albo nil. |
| 67 | `pod_platwiami(sciany, p, os_kalenicy, dom, uwagi)` | Węgły w osiach płatwi na ścianach ze szczytem (dom prostokątny). |
| 102 | `z_wegla(kf, pl, p, dom)` | Wierzch węgła pod płatwią [mm]: spód płatwi (podbitka pod płatwiami – spód desek na niższym licu węgła, deski leżą w spadku); gdy wierzch bala węgła wystaje nad niego o mniej niż tolerancję otworów (otwór by go nie ściął), wierzch niżej – bal ścięty o tolerancję. |
| 117 | `wolne_konce(sciany, p, os_kalenicy, uwagi)` | Węgły na wolnych końcach działowych (wolny odcinek dłuższy niż wegly_wolny_koniec_min). |
| 143 | `konce(w)` | Wolne końce działowej: [[s końca, kierunek w głąb ściany]] (koniec bez ostatka – nie dochodzi do innej ściany). |

### rdzen/wegly_tabela.rb (117 wierszy)

węgły (kontrfory) wstawiane jak okna i drzwi – z tabeli w oknie (ściana, od narożnika albo na środku) i automatycznie na środku ścian (parametr).

Zależy od: rdzen/parametry.rb, rdzen/sciany.rb (dodaj_kontrfor), rdzen/usztywnienie.rb (miejsce_ok?, wolne_miejsce), rdzen/taras.rb (front tarasu – bez węgła na środku)
Używają: rdzen/projekt.rb (po otworach, przed stykami i węgłami usztywniającymi), sketchup/sterowanie.rb (lista węgłów do okna)

| Wiersz | Element | Opis |
|---:|---|---|
| 26 | `module WeglyTabela` |  |
| 28 | `PRZESUNIECIE` | Najdalej tyle [mm] od żądanego miejsca szuka się wolnego miejsca na węgieł. |
| 33 | `dodaj(sciany, lista, p, os_kalenicy)` | Węgły z tabeli i na środku ścian; zwraca ostrzeżenia. |
| 59 | `skad(kf)` | Skąd jest węgieł (do listy w oknie): tabela, srodek, rysunek, reczny, styk, usztywnienie, platwa, koniec. |
| 68 | `lista(sciany, p)` | Wszystkie węgły domu do listy w oknie (przesuwanie w karcie okien i drzwi): [{ 'id', 'sciana', 's' (oś na osi gospodarza), 'od' (jak w tabeli: ściana zewnętrzna – od narożnika lica zewnętrznego), 'skad', 'tabela' (wiersz albo nil) }], po ścianach i położeniu. |
| 80 | `na_srodku(glowne, p)` | Ściany, które dostają węgieł na środku (parametr wegly_srodek, oś nie krótsza niż wegly_srodek_min). |
| 90 | `srodek(w)` | Środek osi ściany (s). |
| 95 | `polozenie(w, x, p)` | Położenie s węgła z wiersza tabeli; nil – niepoprawne. |
| 103 | `wstaw(sciany, w, s, p, os_kalenicy, uwagi, skad, ostatki = nil)` | Wstawia węgieł w s albo w najbliższym wolnym miejscu (do PRZESUNIECIE); ostrzeżenie o przesunięciu lub pominięciu. |

### rdzen/widok.rb (161 wierszy)

widok ściany do okna – bale jako obrysy w płaszczyźnie ściany (s, z), otwory, styki, skrzyżowania, linia dachu.

Zależy od: rdzen/parametry.rb, rdzen/bryla.rb (profil bala), rdzen/szczyty.rb, rdzen/pod_dachem.rb (linia dachu), rdzen/ustawienia_scian.rb (stan ustawień), rdzen/wience.rb, rdzen/taras.rb (opis ściany tarasu), rdzen/kanaly.rb (kanały na przewody)
Używają: sketchup/sterowanie.rb (widok dla okna), html/sciana.js (rysunek)

| Wiersz | Element | Opis |
|---:|---|---|
| 27 | `module Widok` |  |
| 32 | `lista(plan)` | Ściany do wyboru w oknie: [[id, rodzaj, opis tarasu]] – ściany z balami bez kontrforów (węgły widać na ścianach); ściany tarasu z opisem roli (front, ściana domu, ściana boczna). |
| 40 | `opis_tarasu(w)` | Opis ściany tarasu do listy i widoku ('' – zwykła ściana). |
| 46 | `slupy(plan, w)` | Słupy tarasu stojące w ścianie (środek słupa przy osi ściany): [[s0, s1, z0, z1]]. |
| 59 | `sciana(plan, id)` | Widok jednej ściany (Hash z kluczami tekstowymi) albo nil, gdy ściany nie ma. |
| 81 | `bal(b, t)` | Bal w widoku: obrys [[s, z]], pozycja, wieniec, końce. |
| 90 | `obrys(b, t)` | Obrys bala w płaszczyźnie ściany z profilu: wierzch od lewej do prawej, spód z powrotem; ciągłe odcinki profilu (przerwa w profilu – bal pokazany do przerwy). |
| 105 | `uprosc(punkty)` | Punkty bez powtórzeń i bez punktów leżących na prostej między sąsiadami. |
| 120 | `wience(w)` | Wieńce ściany: [[nr, z0, h]] od dołu (z bali). |
| 125 | `otwory(w)` | Otwory (bez gniazd płatwi): [[s0, s1, z0, z1, nazwa, stolarka [s0, s1, z0, z1] albo nil, wiersz tabeli otworów, typ]]. |
| 134 | `linia_dachu(w, p)` | Linia dachu nad ścianą (szczyt – wierzch bali szczytu, ściana pod połacią – spód krokwi): [[s, z]]; [] – brak. |
| 156 | `r(v)` | Zaokrąglenie do 0,1 mm. |

### rdzen/wience.rb (137 wierszy)

poziomy wieńców każdej ściany – półbal na dole ścian wzdłuż kalenicy, liczba wieńców, wysokości ścian.

Zależy od: rdzen/parametry.rb (kolumny dopełnienia w[:dopelnienie] liczy rdzen/dopelnienie.rb)
Używają: rdzen/bale.rb, rdzen/projekt.rb (wysokości do okna), rdzen/dopelnienie.rb, rdzen/szczyty.rb (gniazda)

| Wiersz | Element | Opis |
|---:|---|---|
| 20 | `module Wience` |  |
| 25 | `dla_sciany(w, p)` | Wieńce ściany od dołu: [{ nr:, z0:, h:, lvl:, polbal: }]; kontrfor dopasowany do wysokości gospodarza (przy szczycie – także w szczyt, dalej ogranicza go linia dachu w rdzen/bale.rb). |
| 51 | `szczyt_gospodarza(kf)` | Szczyt gospodarza w miejscu węgła kf: nil, gdy gospodarz nie ma szczytu albo węgieł stoi poza zakresem szczytu na części ściany (dom L – tam ściana jest okapową skrzydła bocznego, rdzen/skrzydla.rb). |
| 61 | `z_polbalem(lista, z)` | Wieńce z półbalem na poziomie z (front tarasu z podciągiem): wieniec, który przechodzi przez z, zaczyna się na z (górna połowa bala – jak półbal na dole ścian wzdłuż kalenicy); niższe wieńce zostają (balustrada pod podciągiem). |
| 70 | `pelna_lista(kierunek, zewnetrzna, p, z_szczytu = nil)` | Wieńce według kierunku: A – półbal + n pełnych; B zewnętrzna – n + 1 (początek szczytu); B działowa i kontrfor – n; ściana ze szczytem – wieńce aż do wierzchu szczytu z_szczytu. |
| 88 | `nizsza_lista(w, pelna, p)` | Wieńce niższej działowej: własne (góra pełnego wieńca ≤ w[:nizsza][:z], nie wyżej niż pełna wysokość), potem nadstawka – tyle wieńców, ile sięgają kolumny dopełnienia (bez kolumn – sama działowa). |
| 107 | `wlasne(w, p)` | Wieńce własne ściany (bez nadstawki niższej działowej). |
| 112 | `wysokosc(w, p)` | Wysokość ściany = góra najwyższego wieńca własnego [mm] (niższa działowa – bez nadstawki). |
| 118 | `wysokosc_calkowita(w, p)` | Wysokość ściany z nadstawką niższej działowej [mm] (np. do gniazd płatwi). |
| 124 | `wysokosc_pelna(w, p)` | Pełna wysokość ściany (jakby nie była niższą działową) [mm]. |
| 130 | `wysokosci(p)` | Wysokości do okna: { okapowa:, szczytowa:, dzialowa_okapowa:, dzialowa_szczytowa: } [mm]. |

### rdzen/wycena.rb (139 wierszy)

wycena materiału domu (W3) – bale (cena za m³), belki według przekroju z magazynu drewna (cena za m³), deski poszycia i podbitki z wiersza „deska” magazynu, pozostałe materiały z cennika; suma i lista pozycji bez ceny.

Zależy od: rdzen/parametry.rb, rdzen/magazyn_drewna.rb (wiersz o przekroju, cena), rdzen/projekt.rb (podsumowanie – lista bali i belek), rdzen/materialy.rb (wiersze materiałów)
Używają: rdzen/projekt.rb (plan[:wycena]), rdzen/zestawienie.rb (blok wyceny w CSV), sketchup/sterowanie.rb (wycena w oknie)

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module Wycena` |  |
| 24 | `BALE` | Prefiksy bali (ściany, węgły, szczyty, balustrada) – cena bala; reszta listy to belki. |
| 26 | `NIE_DREWNO` | Elementy listy poza belkami drewna z magazynu: deski Pb (w deskach z materiałów), fundamenty punktowe (beton). |
| 31 | `licz(plan)` | Wycena planu: { wiersze: [...], suma: zł, bez_ceny: [nazwy], kompletna: true/false }. |
| 47 | `wiersz(grupa, nazwa, ilosc, jednostka, cena)` | Wiersz wyceny (wartość = ilość × cena; brak ceny – wartość nil). |
| 53 | `belki(lista, p)` | Belki (bez bali i desek Pb) zgrupowane po przekroju: m³ × cena wiersza magazynu o tym przekroju. |
| 74 | `materialy(lista, p)` | Materiały (rdzen/materialy.rb): deski w sztukach – objętość × cena deski z magazynu; reszta – cennik (nazwa jako początek nazwy pozycji, ta sama jednostka). Deski w m² i impregnacja w m² (pozycje pomocnicze) – pominięte. |
| 91 | `deski?(m)` | Czy pozycja to deski poszycia albo podbitki. |
| 96 | `pomocnicza?(m)` | Pozycja pomocnicza bez własnej ceny (impregnacja w m² – cena idzie z litrów impregnatu; deski w m²). |
| 101 | `cena_deski(p, g)` | Cena za m³ deski o grubości g z magazynu (wiersz ze znacznikiem „Deska”, ta grubość); nil – brak. |
| 111 | `cena_z_cennika(p, nazwa, jednostka)` | Cena z cennika materiałów dla pozycji (nazwa wiersza cennika = początek nazwy pozycji, wielkość liter bez znaczenia, ta sama jednostka); nil – brak. |
| 120 | `wiersze_csv(w)` | Wiersze CSV bloku wyceny: nagłówek, pozycje, suma (liczby z przecinkiem dziesiętnym). |
| 132 | `liczba(v)` | Liczba do CSV: przecinek dziesiętny, bez zbędnych zer. |

### rdzen/wykaz_drewna.rb (104 wierszy)

wykaz drewna dostępnego w hurtowni (przekroje z długościami handlowymi) – listy fabryczne dla legarów, płatwi, krokwi, belek i słupów zadaszenia oraz odczyt listy przekrojów z długościami z tekstu parametru.

Zależy od: –
Używają: rdzen/parametry.rb (katalog), rdzen/parametry_podloga.rb, rdzen/parametry_dach.rb, rdzen/parametry_zadaszenie.rb (listy fabryczne), rdzen/dlugosci_handlowe.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `module WykazDrewna` |  |
| 21 | `KONSTRUKCYJNE` | Drewno konstrukcyjne C24 (niewidoczne): [szerokość, wysokość, [długości w metrach]]. |
| 26 | `WIDOCZNE` | Drewno widoczne (Nsi, klejone DUO / TRIO / BSH): [szerokość, wysokość, [długości w metrach]]. |
| 33 | `GRANICA_METROW` | Wartość długości poniżej tej liczby to metry (4.2), od niej – milimetry (4200). |
| 40 | `lista(zastosowanie)` | Tekst listy fabrycznej dla zastosowania: :legary (konstrukcyjne od 45 × 95 i widoczne), :platwie (widoczne prostokątne od szerokości 60), :krokwie (konstrukcyjne od 45 × 145, widoczne o szerokości 60 i 80 × 160 / 200), :slupy (widoczne kwadratowe). |
| 53 | `scalone(wpisy)` | Wpisy o tym samym przekroju połączone w jeden (długości razem, rosnąco), w kolejności szerokość, wysokość. |
| 60 | `tekst(wpisy)` | Lista wpisów jako tekst parametru: „45x145:4.2/5.4/6, 45x170:5.4/6”. |
| 69 | `wpisy(tekst)` | Wpisy z tekstu parametru: [[b, h, [długości mm rosnąco]], …]; długości puste – bez ograniczenia. Przekroje rozdzielone przecinkiem, średnikiem albo nowym wierszem; ułamek długości z kropką albo przecinkiem. |
| 87 | `milimetry(tekst)` | Długość z tekstu w milimetrach (liczba poniżej 100 – metry). |
| 93 | `dlugosci(tekst)` | Długości handlowe przekrojów z tekstu parametru: { [mniejszy, większy] => [mm rosnąco] } – tylko wpisy z długościami. |

### rdzen/wypusty_okapu.rb (128 wierszy)

wypusty pod dachem – górne wieńce ścian okapowych wypuszczone za szczyty o wysunięcie płatwi (oparcie dachu nad szczytem) i opcjonalnie górne bale węgłów na ścianach okapowych wysunięte na zewnątrz do nawisu okapu, ścięte linią dachu.

Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wieńce własne), rdzen/styki.rb (styki w wieńcu), rdzen/szczyty.rb (zasięg pod linią), rdzen/pod_dachem.rb (linia dachu nad węgłem)
Używają: rdzen/bale.rb (kawałki wieńca), rdzen/styki.rb (styki liczone z wypustami)

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `module WypustyOkapu` |  |
| 27 | `zasieg(w, wn, i, zas, p, uwagi)` | Zasięg [s0, s1] wieńca wn (indeks i) ściany w po wypustach; zas – zasięg bez nich; uwagi – ostrzeżenia. |
| 35 | `okapowa?(w)` | Czy ściana jest okapową: zewnętrzna wzdłuż kalenicy, bez szczytu. |
| 43 | `gorny?(w, wn, n, p)` | Czy wieniec wn jest jednym z n górnych wieńców własnych ściany. |
| 53 | `okapowa(w, wn, i, zas, p, uwagi)` | Ściana okapowa: górne wieńce dłuższe na końcach przy szczycie (do dach_okap_szczyt za licem szczytu). |
| 76 | `do_stykow(w, p)` | Ściana do planowania styków: okapowa z wypuszczonymi górnymi wieńcami – zasięg wydłużony o wypusty (kawałki górnych wieńców przy końcach mieszczą się w maksymalnym balu); inna – bez zmian. |
| 86 | `skrocony(w, cel, jest, uwagi)` | Ostrzeżenie, gdy wypust skrócony przez maksymalną długość bala. |
| 95 | `przy_szczycie?(w, s)` | Czy na końcu s ściany jest narożnik ze ścianą ze szczytem (nie płaskim) – wypukły: w narożniku wklęsłym wypust wchodziłby do środka domu (uwaga użytkownika, runda 10), zostaje zwykły ostatek. |
| 104 | `k_s(k, w)` | Miejsce s narożnika k na drugiej ścianie (k[:inna]) – do sprawdzenia, czy jej szczyt sięga narożnika. |
| 112 | `wegiel(w, wn, zas, p)` | Węgieł na ścianie okapowej: górne wegly_okap_wience bali wysunięte na zewnątrz do dach_okap od lica ściany, ścięte linią dachu (zasięg pod linią jak w szczycie). |

### rdzen/zadaszenie.rb (394 wierszy)

boczne zadaszenie przy ścianie okapowej domu prostokątnego – połać dachu za linią załamania schodzi dalej pod mniejszym kątem; wariant na słupach (słupy z fundamentami, belki poprzeczne, oczep, płatwie na słupkach) albo przybudówka z bali (obrys poszerzony, dawna ściana okapowa jako działowa, niska ściana zewnętrzna); płatwie zadaszenia.

Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia z załamaniem, płatew, wręby płatwi), rdzen/platwie_wience.rb (przekrój płatwi ściennej), rdzen/elementy.rb, rdzen/fundamenty.rb, rdzen/sciany.rb (oś kalenicy), rdzen/skrzydla.rb (zasięg płatwi)
Używają: rdzen/projekt.rb (obrys z przybudówką, role ścian, elementy, podpowiedzi), rdzen/statyka_zadaszenia.rb (płatwie, linie słupów, belki), rdzen/statyka_krokwi.rb (płatwie zadaszenia jako podpory krokwi), rdzen/podloga_przybudowki.rb (role ścian), rdzen/szczyty.rb (przekrój dachu z zadaszeniem, gniazda płatwi zadaszenia, ściana przybudówki pod połacią), rdzen/polacie.rb (załamania dla aplikacji do dachów), rdzen/krok2.rb (ściana domu przy przybudówce jako podpora)

| Wiersz | Element | Opis |
|---:|---|---|
| 37 | `module Zadaszenie` |  |
| 38 | `WARIANTY` |  |
| 40 | `MIN_SLUPEK` | Słupek pod płatwią krótszy niż tyle [mm] – pominięty (płatew leży wprost na belce poprzecznej). |
| 42 | `ODSTEP` | Odstęp belki poprzecznej od węgła albo działowej wychodzącej ze ściany okapowej [mm]. |
| 44 | `MIN_SLUP` | Najniższy słup zadaszenia [mm] – niższy: zadaszenie bez słupów (uwaga). |
| 49 | `wybrane?(p)` | Czy wybrano boczne zadaszenie (słupy albo przybudówka). |
| 54 | `kat(p)` | Kąt zadaszenia [rad]. |
| 59 | `tg(p)` | Tangens kąta zadaszenia. |
| 64 | `strony(p)` | Strony zadaszenia: −1 – przy ścianie okapowej o mniejszym v, +1 – o większym. |
| 73 | `przeszkoda(p)` | Powód, dla którego zadaszenie nie powstaje przy tych parametrach (nil – może powstać). |
| 88 | `aktywne?(p)` | Czy zadaszenie powstaje (wybrane i bez przeszkody w parametrach). |
| 95 | `przedluz!(ob, p)` | Obrys poszerzony o przybudówkę (zadaszenie = bale; ob z Obrys.rozpoznaj): bok obrysu przy ścianie okapowej po stronie zadaszenia przesunięty o szerokość, oś dawnej ściany okapowej dopisana jako działowa (końce działowych narysowanych do jej lica przeniesione na oś), ob[:os_kalenicy] z obrysu domu i ob[:zadaszenie]; zwraca ostrzeżenia. |
| 128 | `punkt(iu, u, v)` | Punkt układu lokalnego ze współrzędnych wzdłuż kalenicy (u, indeks iu) i w poprzek (v). |
| 133 | `prostokat?(pts)` | Czy obrys to prostokąt o bokach wzdłuż osi. |
| 144 | `oznacz!(sciany, info, p)` | Role ścian przybudówki (po zbudowaniu ścian): dawna ściana okapowa – w[:zadaszenie] = { rola: :dom, kier: }, ściana zewnętrzna przybudówki – { rola: :przybudowka, kier: }. |
| 162 | `rola(w)` | Rola ściany w przybudówce (:dom, :przybudowka) albo nil. |
| 169 | `geo(g, sciany, p, iv)` | Przekrój dachu ściany szczytowej z zadaszeniem: g = { v_a:, v_b: } z końców ściany (iv – indeks v); przy przybudówce osie ścian okapowych domu (dawnych – działowych), opis zadaszenia g[:zad]. Bez zadaszenia albo obrys inny niż prostokąt (cztery ściany zewnętrzne) – g bez zmian. |
| 186 | `opis(g, p, kier)` | Opis stron zadaszenia na przekroju (osie ścian okapowych domu g[:v_a], g[:v_b]): linia załamania nad licem zewnętrznym ściany (płatew ścienna stojąca na ścianie, szersza niż ściana – nad jej krawędzią), lico podpory. |
| 201 | `platwie(geo, p)` | Płatwie zadaszenia w przekroju (jak Dach.platwie): przy ścianie, pośrednie, ostatnia (oczep albo płatew ścienna przybudówki); rodzaj: zadaszenie_przy_scianie \| zadaszenie \| oczep \| zadaszenie_scienna, strona – kier. |
| 221 | `ostatnia(c, b, t, p)` | Ostatnia płatew zadaszenia [v, rodzaj]: oczep nad słupami (lico w linii podpory) albo płatew ścienna przybudówki (przy licu wewnętrznym albo na ścianie); nil – przybudówka ze ścianą nośną. |
| 230 | `elementy(dom, sciany, p)` | Elementy zadaszenia domu prostokątnego: płatwie (P, z wrębami w ścianach, przez które przechodzą) i – na słupach – słupy, fundamenty, belki poprzeczne i słupki; [] bez zadaszenia. |
| 240 | `platwie_elementy(dom, geo, p)` | Płatwie zadaszenia jako elementy P (grupa „Zadaszenie”) na zasięgu płatwi dachu (wysunięcie za szczyty). |
| 251 | `z_podstawy(p)` | Wysokość podstawy słupów [mm]: spód podwaliny (podłoga) albo 0 – na niej stoi fundament. |
| 259 | `linie_slupow(dom, geo, c, sciany, p, lista_pl = nil)` | Linie słupów strony c: [{ u:, v_konca: (koniec belki poprzecznej przy domu), v_slupa: (oś słupa), z_dol: (podstawa), z_slupa: (wierzch słupa = spód belki), z_belki: (wierzch belki = spód oczepu) }]; [] – bez słupów (przybudówka, brak oczepu albo słupy niższe niż MIN_SLUP). lista_pl – płatwie zadaszenia (platwie), gdy już policzone. |
| 276 | `koniec_belki(geo, c, z_belki, p)` | Koniec belki poprzecznej przy domu (v): lico ściany okapowej, a gdy płatew ścienna stoi na ścianie, jest szersza niż ściana i jej spód leży niżej niż wierzch belki (z_belki) – krawędź płatwi (linia załamania; belka dochodzi do boku płatwi). |
| 283 | `slupy(dom, geo, sciany, p)` | Słupy, fundamenty, belki poprzeczne i słupki zadaszenia na słupach (każda strona). |
| 311 | `nad_belka?(pl, c, v_konca)` | Czy płatew leży nad belką poprzeczną (rzut płatwi między licem podpory a końcem belki przy domu). |
| 318 | `przeszkody(sciany, c, dom, p)` | Przeszkody przy licu ściany okapowej po stronie zadaszenia: ściany w poprzek (szczytowe z ostatkami, działowe z wypustem, węgły) wychodzące przed lico – [{ u:, pol: (pół grubości), v: (koniec przed licem) }]. |
| 334 | `linie(dom, c, przeszkody, bb, p, v_bazy = c[:v_lico])` | Linie słupów [[u, v końca belki poprzecznej]]: skrajne w osiach ścian szczytowych (belka do końca ostatków), pośrednie równo co najwyżej zadaszenie_slupy_rozstaw; linia, w której belka trafiłaby w węgieł albo działową, przesunięta obok; v_bazy – koniec belki bez przeszkód (lico ściany albo krawędź płatwi ściennej – koniec_belki). |
| 349 | `omin(u, przeszkody, bb, u1, u2)` | Położenie u linii pośredniej z dala od przeszkód (najbliższe wolne, w zakresie u1…u2). |
| 359 | `slup(dom, u, v, b, l, z_dol, z_gora, rodzaj)` | Słup (S) od z_dol do z_gora: przekrój b (wzdłuż kalenicy) × l (w poprzek), oś w (u, v); x w górę. |
| 368 | `podpowiedzi(dom, p, elementy)` | Podpowiedzi do sekcji „Boczne zadaszenie” ([{ poziom:, tekst: }]). |

### rdzen/zamek.rb (176 wierszy)

obróbki zamka na każdym skrzyżowaniu – gniazda górne/dolne i podcięcia boczne bali (zamek 44 × 146 z rysunku IMG-20250930-WA0005).

Zależy od: rdzen/parametry.rb, rdzen/pol_zamka.rb (ostatnie połączenie pod dachem – gniazdo do połowy bala niższego, bal wyższy bez gniazda)
Używają: rdzen/projekt.rb, testy/t_zamek.rb (sprawdzenie kolizji)

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module Zamek` |  |
| 25 | `ORIENTACJA` | Kierunek (w układzie lokalnym domu), w którym podcięcie lica o mniejszej współrzędnej wychodzi za lico ściany poprzecznej: ściany wzdłuż X – lico południowe (min y), ściany wzdłuż Y – lico zachodnie (min x). |
| 27 | `ORIENTACJA_LUSTRO` | Odbicie lustrzane labiryntu (parametr zamek_odbicie = 'lustro'). |
| 34 | `nanies(sciany, p, orientacja = nil)` | Obróbki zamków dla wszystkich skrzyżowań (dopisuje cechy do bali); zwraca liczbę par bali w zamkach. Orientacja – z parametru zamek_odbicie, gdy nie podano. Najpierw ostatnie połączenia pod dachem (od najniższej pary), potem obróbki w kolejności skrzyżowań. |
| 58 | `ostatnie_polaczenia!(pary, p)` | Ostatnie połączenia pod dachem (rdzen/pol_zamka.rb) wśród par bali – od najniższej: bal wyższy oznaczony jako bal półzamka; para, w której bal półzamka nie sięga bala nad nim, usunięta z listy (żadnych gniazd między nimi). |
| 75 | `wspolne_polzamki!(pary, p)` | nad tym samym balem niższym, a jego gniazdo jest wspólne. Gdy jeden z nich jest balem półzamka, drugi też nim zostaje (bez gniazda od spodu) – o ile nic na nim nie leży i w zamku ma co najmniej zamek_min_drewno; inaczej zostaje ze zwykłym gniazdem nad głębszym gniazdem bala niższego. |
| 92 | `pary_bali(sciany, t)` | Pary bali w zamkach wszystkich skrzyżowań (poziomy różne o 1): { nizszy:, wyzszy:, cn:, cw: (osie zamka na ścianach obu bali), nad: (bale ściany bala niższego w słupie zamka), pod: (bale ściany bala wyższego w słupie) }. |
| 118 | `bale_w_zamku(w, c, t)` | Bale ściany, które zachodzą na słup zamka [c − t/2, c + t/2]. |
| 123 | `gniazdo(b, c, typ, z)` | Gniazdo (górne lub dolne) w osi c – raz na skrzyżowanie, przycięte do długości bala. |
| 130 | `podciecia(b, c, z, orientacja)` | Podcięcia boczne obu lic bala przy skrzyżowaniu w osi c (strona 0 – lico prawe y = 0, strona 1 – lico lewe y = t). |
| 142 | `kierunek_lica_prawego(w, orientacja)` | Kierunek (−1 / +1 wzdłuż s ściany), w którym podcięcie lica prawego wychodzi za lico ściany poprzecznej. |
| 157 | `dodaj_ceche(b, cecha)` | Dopisanie cechy przyciętej do bala (pomija powtórkę tej samej obróbki w tej samej osi; z dwóch gniazd w tym samym miejscu zostaje głębsze – gniazdo półzamka pod jednym z dwóch bali stykających się w węźle). |
| 171 | `odl2(a, b)` | Odległość punktów 2D (pomocnicza, bez zależności od geometria.rb). |

### rdzen/zamek_platwi.rb (194 wierszy)

zamki w płatwiach – wręby płatwi w ścianach, przez które przechodzi (z boków i od spodu), żeby płatwie trzymały szczyty na miejscu; bryła belki z wrębami, objętość, podpis.

Zależy od: rdzen/parametry.rb, rdzen/pryzmat.rb (pole przekroju, podpis), rdzen/siatka.rb (punkty T, scalanie ścian)
Używają: rdzen/szczyty.rb (gniazdo dopasowane do wrębu, przejścia płatwi przez ściany), rdzen/dach.rb (wręby płatwi), rdzen/elementy.rb (pozycje), rdzen/projekt.rb (siatka i objętość)

| Wiersz | Element | Opis |
|---:|---|---|
| 23 | `module ZamekPlatwi` |  |
| 24 | `EPS` |  |
| 29 | `wlaczone?(p)` | Czy płatwie mają zamki (wręby). |
| 34 | `wrab(p)` | Wymiary wrębu { bok:, dol: } [mm]; bez zamków – zera. |
| 40 | `szerokosc_w_scianie(b, p, bok = nil)` | Szerokość płatwi w ścianie (w wrębie) [mm]; bok – głębokość wrębu bocznego tej ściany (nil – z parametrów). |
| 46 | `tylko_spod?(w, p)` | Czy płatew w ścianie w ma zamek tylko od spodu (bez wrębów bocznych): front tarasu z balami (typ 200, typ 300 ze szczytem frontu – w[:taras][:z_polbal]) – szczyt albo wiązar nad tarasem – przy taras_platwa_zamek = spod. |
| 53 | `bok_w_scianie(w, p)` | Głębokość wrębu bocznego płatwi w ścianie w [mm] (0 – zamek tylko od spodu albo bez zamków). |
| 58 | `wrab_odcinka(w, bok)` | Wymiary wrębu jednego odcinka: w – wrąb belki { bok:, dol: }, bok – własna głębokość boczna odcinka albo nil. |
| 63 | `spod_w_scianie(z_spod, p)` | Spód płatwi w ścianie (dno gniazda) [mm]. |
| 69 | `wreby(dl, u_scian, t, p, bok = nil)` | Wręby belki o długości dl z osi ścian u_scian (współrzędna wzdłuż belki, od jej początku) i grubości t: [[x0, x1]] posortowane, nachodzące scalone, przycięte do belki; bok – własna głębokość boczna tych wrębów ([x0, x1, bok]). |
| 78 | `scal(lista)` | Wręby posortowane, nachodzące na siebie scalone w jeden; przy różnej głębokości bocznej zostaje głębsza (wrąb bez własnej głębokości = pełny wrąb boczny belki). |
| 93 | `przekroj_wrebu(przekroj, b, w)` | Przekrój w wrębie: przekrój belki przycięty do y ∈ [bok, b − bok] i z ≥ dol (wielokąt wypukły). |
| 100 | `przytnij(pts, os, granica, znak)` | Wielokąt [[y, z]] przycięty półpłaszczyzną: oś 1 (y) albo 2 (z), znak +1 – zostaje ≥ granica, −1 – ≤ granica. |
| 117 | `bez_powtorzen(pts)` | Punkty bez kolejnych powtórzeń (także ostatni = pierwszy). |
| 126 | `odcinki(dl, przekroj, b, wreby, w)` | Odcinki belki: [[x0, x1, przekrój, wrąb albo nil]] – przekrój pełny poza wrębami, przekrój wrębu w nich (z jego wymiarami – wrąb może mieć własną głębokość boczną). |
| 140 | `objetosc(dl, przekroj, b, wreby, w)` | Objętość belki z wrębami [mm³]. |
| 145 | `podpis(wreby, w)` | Podpis wrębów (do rozpoznania identycznych belek). |
| 152 | `obrocone(dl, wreby)` | Wręby belki obróconej o 180° (x → dl − x). |
| 158 | `siatka(dl, przekroj, b, wreby, w)` | Siatka belki z wrębami: boki każdego odcinka, czoła na końcach i barki wrębów (przekrój pełny bez przekroju wrębu – trzy pasy: z lewej, z prawej, od spodu), potem punkty T i scalenie ścian jednej płaszczyzny (rdzen/siatka.rb). |
| 185 | `barki(pelny, b, w)` | Barki wrębu w przekroju pełnym: części poza przekrojem wrębu – pas z lewej (y ≤ bok), z prawej (y ≥ b − bok) i od spodu (bok ≤ y ≤ b − bok, z ≤ dol); wielokąty przeciwnie do wskazówek patrząc od +x. |

### rdzen/zestawienie.rb (92 wierszy)

zestawienie bali i belek do pliku CSV (Excel) – pozycje z długością, ilością i objętością, sumy grup i całości, pod nimi blok materiałów.

Zależy od: rdzen/parametry.rb, rdzen/projekt.rb (podsumowanie), rdzen/materialy.rb (blok materiałów), rdzen/wycena.rb (blok wyceny)
Używają: sketchup/eksport.rb (zapis pliku)

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `module Zestawienie` |  |
| 23 | `GRUPY` | Nazwy grup w zestawieniu (prefiks => nazwa). |
| 27 | `NAGLOWEK` |  |
| 32 | `csv(plan)` | Tekst CSV zestawienia z planu (pusty, gdy plan bez podsumowania). |
| 61 | `rodzaj(l)` | Rodzaj elementu w zestawieniu (bale – nazwa grupy, belki – ich rodzaj). |
| 67 | `sumy(lista)` | Wiersze sum: każda grupa (sztuki, objętość) i razem. |
| 81 | `liczba(v, n)` | Liczba z przecinkiem dziesiętnym (n miejsc). |
| 86 | `pole(v)` | Pole CSV: w cudzysłowie, gdy zawiera średnik, cudzysłów albo nową linię. |

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

### sketchup/budowa.rb (199 wierszy)

budowa domu w modelu – grupa domu > grupy ścian W-n > instancje komponentów bali, tagi, usuwanie poprzedniej wersji.

Zależy od: rdzen/projekt.rb (siatka pozycji), rdzen/siatka.rb, rdzen/obrys.rb (kąt układu), sketchup/konwersja.rb, sketchup/atrybuty.rb, sketchup/stolarka_modele.rb (modele okien i drzwi), log.rb
Używają: sketchup/sterowanie.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `module Budowa` |  |
| 21 | `TAGI` | Tagi (dawniej warstwy) według rodzaju ściany. |
| 33 | `GRUPY_BELEK` | Grupy belek w domu: tag => nazwa grupy. |
| 39 | `zbuduj(model, plan, wejscie, istniejaca = nil)` | Budowa domu z planu w jednej operacji (jedno „Cofnij”); istniejąca – grupa poprzedniej wersji do zastąpienia. Zwraca { grupa:, definicje:, bledne_sciany:, defs: }. |
| 54 | `zbuduj_w_operacji(model, plan, wejscie, istniejaca = nil)` | Budowa domu bez własnej operacji (wołający otwiera i zamyka operację – np. test działania, który ją cofa). |
| 90 | `polozenie_domu(plan, wejscie, istniejaca)` | Położenie grupy domu: z linii (obrót układu lokalnego, poziom z0); przy przebudowie – z przesunięciem i obrotem, które użytkownik nadał poprzedniej wersji (przesunięcie = położenie poprzedniej grupy × odwrotność położenia z jej linii). |
| 104 | `dodaj_belki(grupa, plan, defs, tagi)` | Grupy „Podłoga”, „Dach”, „Taras” i „Zadaszenie” z instancjami belek (pozycje elementów). |
| 120 | `nazwa_definicji(poz)` | Nazwa komponentu pozycji: rodzaj i nazwa pozycji. |
| 126 | `definicja(model, poz, p, dom_id)` | Definicja komponentu pozycji z siatki bryły; zwraca [definicja, liczba ścian, których nie udało się narysować]. |
| 141 | `rysuj_sciane(ents, s)` | Ściana bryły: pętla zewnętrzna, otwory (dorysowane i usunięte), zwrot zgodny z normalną siatki; false – ściany albo otworu w niej nie udało się narysować. |
| 164 | `na_scianie?(f, pt)` | Czy punkt leży na ścianie SketchUpa (w środku, na krawędzi albo w wierzchołku – nie obok i nie poza płaszczyzną). |
| 170 | `rownolegla?(f, n)` | Czy ściana SketchUpa leży równolegle do normalnej siatki (po podziale ściany przy otworze). |
| 176 | `przygotuj_tagi(model)` | Tagi według rodzaju ściany (zakładane, gdy ich nie ma). |
| 185 | `usun_dom(model, grupa)` | Usunięcie poprzedniej wersji domu i jej nieużywanych definicji bali. |

### sketchup/dach_aplikacja.rb (225 wierszy)

dach z aplikacji do dachów (ArteMadera Roof) po budowie domu – przez jej stałe API: połacie z planu (KROK 1), płatwie domu jako podpory, okno KROKU 2 z ustawieniami domu z bali, więźba powiązana z domem, zastąpienie poprzednich połaci i więźby.

Zależy od: rdzen/polacie.rb (plan[:polacie]), rdzen/krok2.rb (ustawienia KROKU 2, podpory), sketchup/konwersja.rb, sketchup/atrybuty.rb, log.rb; ArteMadera::Roof::API (wersja 1, aplikacja 3.7.0+, załamanie połaci – 3.12.0+)
Używają: sketchup/sterowanie.rb (po budowie domu)

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module DachAplikacja` |  |
| 23 | `NAZWA_WIEZBY` |  |
| 25 | `API_WERSJA` | Najniższa wersja API aplikacji do dachów (aplikacja 3.7.0). |
| 27 | `ZAPAS_WIEZBY` | Zapas wokół obrysu poprzednich połaci przy szukaniu więźby bez id domu [mm]. |
| 32 | `api` | API aplikacji do dachów (ArteMadera::Roof::API, wersja ≥ 1) albo nil – brak aplikacji albo starsza niż 3.7.0. |
| 38 | `brak_api` | Komunikat, gdy API brak (nil – jest): aplikacji nie ma albo jest starsza niż 3.7.0. |
| 53 | `po_budowie(model, dom, plan, stary_id = nil)` | Po budowie domu: bez poprzednich połaci domu stary_id (jego więźba – po potwierdzeniu), nowe połacie z planu z płatwiami jako podporami, okno KROKU 2. Zwraca nil (bez połaci i więźby teraz i wcześniej) albo { 'tekst' =>, 'ok' => }. |
| 81 | `usunac_wiezbe?(ile)` | Pytanie o więźbę poprzedniej wersji domu (liczba grup) – true: usunąć. |
| 87 | `tekst_krok2(p)` | Tekst do okna generatora: co zatwierdzić w KROKU 2 (krokwie albo poszycie na płatwiach). |
| 97 | `w_operacji(model, nazwa = 'ArteMadera – połacie dachu')` | Zmiany w modelu w operacji dołączonej do poprzedniej (budowa domu) – jedno „Cofnij”; błąd cofa tylko tę część. |
| 111 | `nowe_polacie(model, dom, pol, podpory = [])` | Nowe połacie domu z podporami (Krok2.podpory – mm układu domu): [grupa, nil] albo [nil, { 'tekst' =>, 'ok' => false }] (brak lub stara aplikacja, inny kontekst, odmowa aplikacji). |
| 135 | `za_stara_na_zalamania` | Boczne zadaszenie (załamanie połaci – opcja :zalamania) wymaga aplikacji do dachów 3.12.0 lub nowszej: komunikat albo nil. |
| 143 | `przeszkoda(model, dom)` | Co nie pozwala zrobić połaci (komunikat) – brak lub stara aplikacja, dom poza aktywnym kontekstem; nil – można. |
| 151 | `w_aktywnym?(model, dom)` | Czy dom leży w aktywnym kontekście modelu (tam aplikacja do dachów dodaje połacie). |
| 156 | `punkty(dom, pol)` | Punkty obrysu połaci (mm układu domu, wysokość obrysu) jako Geom::Point3d w układzie kontekstu domu. |
| 161 | `w_kontekscie(dom, podpory)` | Podpory dla API: punkty z mm układu domu do mm układu kontekstu domu. |
| 171 | `otworz_krok2(grupa, ustawienia, dom_id)` | Okno KROKU 2 aplikacji na połaciach grupy – po zakończeniu bieżącego wywołania z okna generatora (licznik zatrzymany na starcie: okno modalne w liczniku SketchUpa potrafi go powtarzać); po OK więźba dostaje id domu. |
| 185 | `krok2(grupa, ustawienia, dom_id)` | Wywołanie KROKU 2 (okno); odmowa aplikacji – komunikat. Połacie usunięte w międzyczasie (Cofnij) – nic. |
| 195 | `oznacz_wiezbe(wiezba, dom_id)` | Więźba z KROKU 2 (po OK) powiązana z domem: ArteMadera_GW.wiezba_domu = id domu – w operacji KROKU 2. |
| 204 | `poprzednie_polacie(ents, dom_id)` | Grupy połaci poprzedniej wersji domu (słownik ArteMadera_GW, polacie_domu). |
| 210 | `wiezba_domu(ents, dom_id, polacie)` | Więźba poprzedniej wersji domu: grupy z wiezba_domu = jej id, a bez id (kompilacja 5, KROK 2 z menu) – grupy „Wiezba dachowa” ze środkiem nad obrysem jej połaci (z zapasem). |

### sketchup/dziennik_pracy.rb (123 wierszy)

folder raportów na komputerze użytkownika – raport z testu działania zapisywany sam (bez okna zapisu) i dziennik pracy: jeden wiersz po każdym wygenerowaniu domu (czasy, liczby, zmienione ustawienia) oraz po awarii obliczeń.

Zależy od: sketchup/ustawienia.rb (katalog zapasowy), rdzen/parametry.rb, log.rb
Używają: sketchup/raport.rb (zapis raportu, ostatnie wpisy), sketchup/sterowanie.rb (po generowaniu, po awarii)

| Wiersz | Element | Opis |
|---:|---|---|
| 22 | `module DziennikPracy` |  |
| 23 | `FOLDER_PROJEKTU` |  |
| 24 | `PODFOLDER` |  |
| 25 | `PLIK` |  |
| 27 | `MAX_WIERSZY` | Najwięcej wierszy dziennika; po przekroczeniu o ZAPAS zostaje MAX_WIERSZY ostatnich. |
| 28 | `ZAPAS` |  |
| 33 | `katalog` | Folder raportów: testy – pod AM_GW_USTAWIENIA; folder projektu w Dokumentach, gdy istnieje; inaczej obok ustawień. |
| 44 | `zapisz_raport(raport, kompilacja)` | Zapis raportu z testu działania; zwraca ścieżkę pliku albo nil (nie udało się – wpis w Log). |
| 55 | `generowanie(plan, wejscie, tryb, ms_obliczen, ms_budowy, zbudowane, dach, kompilacja)` | Wiersz dziennika po wygenerowaniu domu: tryb ('nowy' \| 'edycja'), czasy [ms], liczby z planu i z budowy, dach. |
| 70 | `awaria(plan, wejscie, kompilacja)` | Wiersz dziennika po awarii obliczeń (plan[:wyjatek] – rdzen/awaria.rb). |
| 77 | `zmienione(wejscie)` | Ustawienia z okna różne od fabrycznych: { klucz => wartość } (bez wymiarów zamka i bez przekrojów dobranych automatycznie) – które pola są naprawdę używane. |
| 88 | `dopisz(wpis)` | Dopisanie wiersza z czasem; plik przycinany do MAX_WIERSZY ostatnich. Błąd zapisu nie przerywa pracy. |
| 100 | `przytnij(sciezka)` | Zostawia w pliku MAX_WIERSZY ostatnich wierszy, gdy urósł ponad MAX_WIERSZY + ZAPAS. |
| 107 | `ostatnie(ile = 50)` | Ostatnie wpisy dziennika (do raportu); uszkodzone wiersze pomijane. |

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

### sketchup/menu.rb (46 wierszy)

menu Rozszerzenia → ArteMadera Generator Wieńcowy (generuj / edytuj, kontrola, standard warsztatu, test działania, o wtyczce).

Zależy od: sketchup/sterowanie.rb, sketchup/raport.rb, log.rb
Używają: main.rb (ładowanie)

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `module Menu` |  |
| 18 | `dodaj` | Dodanie menu (raz na sesję SketchUpa). |
| 33 | `o_wtyczce` | Okno z wersją i numerem kompilacji. |

### sketchup/okno.rb (202 wierszy)

okno parametrów (UI::HtmlDialog) – dane startowe dla okna, wywołania z JavaScriptu, wyniki do okna.

Zależy od: rdzen/parametry_lista.rb, rdzen/poziomy.rb, sketchup/ustawienia.rb, sketchup/okno_typy.rb, sketchup/okno_sciezki.rb (wybór ścieżki), sketchup/sterowanie.rb, sketchup/eksport.rb, log.rb
Używają: sketchup/sterowanie.rb (pokaz)

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `module Okno` |  |
| 22 | `SZEROKOSC` |  |
| 23 | `WYSOKOSC` |  |
| 31 | `pokaz(dane)` | Otwarcie okna z danymi startowymi (tryb: 'nowy' \| 'edycja'). |
| 52 | `dane_startowe` | Dane startowe okna: sekcje i pola formularza (z poziomem i krokiem), wartości, presety, typy domów z bazą porównania, układ okna, kroki, informacja o liniach / domu. |
| 68 | `opisy_pol` | Opisy pól z ParametryLista::LISTA w postaci dla JavaScriptu (sekcja, wybory, podpowiedź). |
| 81 | `kolumny(w)` | Kolumny pola tabeli dla okna: [{ klucz, etykieta, rodzaj, wybory }]; inne pole – nil. |
| 87 | `wyslij_typy(dane)` | Typy domów i baza porównania do okna (po wyborze, zapisie, usunięciu typu albo zapisie standardu): AMGW.typy. |
| 95 | `wyslij_komunikat(tekst, rodzaj)` | Komunikat w oknie (ok / blad): AMGW.komunikat. |
| 103 | `wyslij_widok(dane)` | Widok ściany do okna: AMGW.widok. |
| 111 | `wyslij_wynik(dane)` | Wynik obliczeń lub budowy do okna. |
| 121 | `podlacz(dlg)` | Wywołania z JavaScriptu. |
| 183 | `zamknij_stare` | Zamknięcie poprzedniego okna generatora (także ukrytego) – nowe okno nie dziedziczy po nim niczego. |
| 192 | `po_zamknieciu(dlg)` | Okno dlg zamknięte: jeśli to bieżące okno – bez okna i bez danych startowych w pamięci. |

### sketchup/okno_sciezki.rb (59 wierszy)

wybór ścieżki z okna generatora – folder modeli stolarki (UI.select_directory) i plik modelu okna albo drzwi (UI.openpanel), odpowiedź do pola w oknie.

Zależy od: log.rb
Używają: sketchup/okno.rb (podlacz), html/sciezka.js (przycisk „…” przy polu)

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `module OknoSciezki` |  |
| 21 | `FILTR` | Filtr okna wyboru pliku modelu. |
| 26 | `podlacz(dlg)` | Podłączenie wywołania wybierz_sciezke do okna dlg. |
| 38 | `wybierz(d)` | Okno wyboru dla danych z pola ({ 'rodzaj' =>, 'poczatek' => }); zwraca wybraną ścieżkę albo '' (anulowano). |
| 49 | `katalog_startowy(t)` | Folder, w którym zaczyna okno wyboru: ścieżka z pola, gdy jest folderem, albo folder pliku z pola; nil – brak. |

### sketchup/okno_typy.rb (71 wierszy)

wywołania okna dla typów domów i standardu warsztatu – wybór typu, „Zapisz jako typ”, „Zapisz zmiany w typie”, powielenie, usunięcie, zapis i przywrócenie standardu, układ okna; odpowiedź do okna: lista typów i baza porównania.

Zależy od: sketchup/typy_domow.rb, sketchup/ustawienia.rb, rdzen/poziomy.rb, log.rb
Używają: sketchup/okno.rb (podlacz, dane startowe)

| Wiersz | Element | Opis |
|---:|---|---|
| 17 | `module OknoTypy` |  |
| 22 | `dane(typ)` | Typy i baza porównania dla okna: lista typów, bieżący typ (nieznany – ostatnio wybrany) i wartości wszystkich pól według standardu i tego typu. |
| 28 | `podlacz(dlg, &wyslij)` | Podłączenie wywołań do okna dlg; wyslij – blok wysyłający odpowiedź (hash) do okna. |
| 60 | `akcja(dlg, nazwa)` | Jedno wywołanie okna z obsługą błędu (komunikat w dzienniku, okno działa dalej). |

### sketchup/pasek.rb (119 wierszy)

szybki dostęp do poleceń wtyczki – pasek narzędzi z czterema przyciskami i polecenia pod prawym przyciskiem myszy na zaznaczonym domu albo liniach.

Zależy od: sketchup/sterowanie.rb, sketchup/raport.rb, sketchup/atrybuty.rb (dom?), log.rb
Używają: main.rb (ładowanie)

| Wiersz | Element | Opis |
|---:|---|---|
| 17 | `module Pasek` |  |
| 18 | `NAZWA` |  |
| 20 | `PRZYCISKI` | Przyciski paska: [plik ikony, nazwa, podpowiedź na pasku stanu, polecenie]. |
| 31 | `MIN_LINII` | Najmniej zaznaczonych linii, żeby pod prawym przyciskiem pojawiło się „Dom wieńcowy z zaznaczonych linii”. |
| 33 | `NIGDY` | Stany paska z API SketchUpa (get_last_state) – własne stałe, gdyby API ich nie podało. |
| 34 | `WIDOCZNY` |  |
| 40 | `dodaj` | Pasek narzędzi i menu pod prawym przyciskiem (raz na sesję SketchUpa). |
| 52 | `polecenie(ikona, nazwa, opis, co)` | Polecenie paska z ikoną i opisami. |
| 62 | `sciezka_ikony(ikona, bok)` | Plik ikony: Windows – SVG, inne systemy – PNG o podanym boku. |
| 68 | `wykonaj(co)` | Wykonanie polecenia paska albo menu. |
| 80 | `pokaz(pasek)` | Pokazanie paska: nigdy niepokazany – pokazany; pokazany poprzednio – przywrócony; schowany – zostaje schowany. |
| 91 | `pod_prawym(menu)` | Menu pod prawym przyciskiem: na zaznaczonym domu z generatora – edycja i kontrola; na zaznaczonych liniach (co najmniej MIN_LINII, bez domu) – nowy dom. |
| 108 | `linii?(zazn)` | Czy w zaznaczeniu jest co najmniej MIN_LINII krawędzi (liczenie przerywane po osiągnięciu progu). |

### sketchup/raport.rb (209 wierszy)

test działania w prawdziwym SketchUpie i raport do wysłania – przykładowe domy budowane w operacji cofanej na końcu (model bez zmian), bryły zamknięte i objętości, zaznaczony dom, środowisko, dziennik.

Zależy od: sketchup/dziennik_pracy.rb (folder raportów, dziennik pracy), rdzen/przyklady.rb, rdzen/projekt.rb, rdzen/kontrola.rb, rdzen/bryla.rb, sketchup/budowa.rb, sketchup/atrybuty.rb, sketchup/eksport.rb, sketchup/ustawienia.rb, log.rb
Używają: sketchup/menu.rb („Test działania i raport…”)

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `module Raport` |  |
| 21 | `CAL3` | Cale³ → mm³. |
| 23 | `TOL_OBJ` | Dopuszczalna różnica objętości bryły w SketchUpie i z profilu (część objętości). |
| 29 | `uruchom` | Menu i pasek: test działania; raport zapisuje się sam w folderze raportów (sketchup/dziennik_pracy.rb – bez okna zapisu, prośba użytkownika z 2026-11-25 o prosty odbiór), w okienku wynik jednym zdaniem i lista problemów. |
| 44 | `zbierz(model)` | Cały raport: środowisko, zaznaczony dom, przykładowe domy, dziennik. |
| 56 | `srodowisko(model)` | Wersje i ustawienia: SketchUp, Ruby, wtyczka, jednostki modelu, plik ustawień. |
| 71 | `przyklady(model)` | Przykładowe domy zbudowane w jednej operacji, cofniętej na końcu (model zostaje bez zmian). |
| 90 | `test_domu(model, nazwa, wejscie)` | Jeden dom: obliczenia, budowa w modelu, bryły i liczby elementów w modelu, kontrola, czasy. |
| 110 | `liczby_planu(plan)` | Liczby z planu: bale, pozycje, belki według prefiksu. |
| 121 | `liczby_modelu(grupa)` | Liczby z modelu (grupa domu): instancje według prefiksu definicji, grupy ścian; modele okien i drzwi (grupa „Stolarka” – nie drewno z listy) liczone osobno. |
| 141 | `bryly(plan, defs)` | Bryły definicji: zamknięte (manifold) i z objętością jak z profilu; listy nazw z problemami. |
| 160 | `zgodny?(w)` | Czy dom w modelu zgadza się z planem: tyle instancji, co bali i belek, wszystkie bryły zamknięte, objętości zgodne. |
| 166 | `sprawdz_dom(dom)` | Zaznaczony dom: parametry, kompilacja, ręczne zmiany, liczby z planu i z modelu. |
| 177 | `wynik(r)` | Wynik testu jednym spojrzeniem: { 'domy' => liczba, 'w_porzadku' => liczba, 'problemy' => [nazwy], 'czas_budowy_s' => suma }. |
| 186 | `podsumowanie(r)` | Tekst okienka po teście: wynik jednym zdaniem, potem domy (z problemami opisane, pozostałe krótko). |

### sketchup/sterowanie.rb (245 wierszy)

przebieg pracy z menu – start (linie albo dom do edycji), podgląd, generowanie, kontrola; dane wyniku dla okna.

Zależy od: rdzen/projekt.rb, rdzen/awaria.rb (plan[:wyjatek]), rdzen/kontrola.rb, rdzen/widok.rb, sketchup/wejscie.rb, sketchup/budowa.rb, sketchup/dach_aplikacja.rb, sketchup/atrybuty.rb, sketchup/okno.rb, sketchup/ustawienia.rb, sketchup/dziennik_pracy.rb, log.rb
Używają: sketchup/menu.rb, sketchup/pasek.rb, sketchup/okno.rb (wywołania z okna)

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `module Sterowanie` |  |
| 20 | `start` | Menu „Generuj / edytuj”: zaznaczone linie → nowy dom, zaznaczony dom → edycja parametrów. |
| 69 | `standard` | Menu „Standard warsztatu…”: okno z samym panelem standardu (bez domu, bez podglądu) – zmiana tego, jak budujesz zawsze, bez zaznaczania linii ani domu. |
| 83 | `dom_czy_linie(z)` | Zaznaczony dom i linie razem: te same linie, z których dom powstał – edycja domu; inne – pytanie, czy zrobić nowy dom z linii (Tak) czy edytować zaznaczony dom (Nie); Anuluj – nil. Wcześniej dom w zaznaczeniu zawsze wygrywał i okno otwierało się z jego parametrami zamiast od nowa (uwaga użytkownika, runda 10). |
| 94 | `te_same_linie?(a, b)` | Czy dwa zestawy linii są takie same (końce z dokładnością 1 mm, dowolna kolejność i zwrot). |
| 103 | `podglad(dane)` | Podgląd z okna: obliczenia bez zmian w modelu (na komputerze nic się nie zapisuje – standard i typy mają własne przyciski zapisu). |
| 110 | `widok(id)` | Widok ściany z ostatniego planu (podgląd lub generowanie) dla okna; { 'blad' => tekst }, gdy nie ma ściany. |
| 117 | `generuj(dane)` | Generowanie z okna: obliczenia i budowa (zastępuje edytowany dom), potem dach z aplikacji do dachów (połacie i KROK 2 – 'dach' w wyniku: tekst do okna); parametry, typ i zmiany tylko w tym domu zostają w modelu (atrybuty domu). |
| 149 | `kontrola` | Menu „Kontrola”: kolizje w zamkach, mijanka, długości dla zaznaczonego domu. |
| 174 | `okienko_awarii(plan, wejscie = nil)` | Okienko z komunikatem, gdy obliczenia przerwał nieprzewidziany błąd (plan[:wyjatek] – rdzen/awaria.rb): przy starcie i przy „Generuj”; podgląd po zmianie pola pokazuje ten sam komunikat tylko na liście błędów w oknie. |
| 181 | `ostatni_czas` | Czas ostatniego zmierzonego etapu (Log.time) w milisekundach. |
| 188 | `scal(dane)` | Wejście domu: zapamiętane linie i poziom (dom z wymiarów – prostokąt z pól długości i szerokości) + parametry, otwory, ustawienia ścian (widok ściany) i typ domu z okna. |
| 204 | `dla_okna(plan)` | Wynik dla okna (tylko typy JSON): błędy, ostrzeżenia, podpowiedzi, ściany, lista bali i belek, rzut. |
| 227 | `rzut(plan)` | Rzut do okna: obrys i ściany (bale od końca do końca) w mm układu lokalnego. |
| 237 | `klucze_tekstowe(h)` | Hash z kluczami symbolami → kluczami tekstowymi (do JSON). |

### sketchup/stolarka_modele.rb (110 wierszy)

wstawienie modeli okien i drzwi w otwory domu przy generowaniu – plik .skp użytkownika albo prosty model z generatora (definicja z części), grupa „Stolarka” w domu, tag Stolarka, brakujące pliki zgłaszane.

Zależy od: rdzen/stolarka_modele.rb (lista do wstawienia i położenie), rdzen/stolarka_prosta.rb (części i siatki prostego modelu), sketchup/konwersja.rb (transformacja_elementu, punkt), sketchup/budowa.rb (rysuj_sciane), sketchup/atrybuty.rb (słowniki), log.rb
Używają: sketchup/budowa.rb (po belkach)

| Wiersz | Element | Opis |
|---:|---|---|
| 18 | `module StolarkaModeleSU` |  |
| 20 | `TOL` | Różnica wymiaru modelu i stolarki z listy, od której jest uwaga [mm]. |
| 25 | `wstaw(grupa, plan, model, tag, dom_id = '')` | Modele stolarki w grupie domu: { wstawione: n, proste: n, uwagi: [tekst] }. |
| 50 | `definicja(model, s, defs, wynik, dom_id)` | Definicja dla otworu: z pliku (gdy istnieje), inaczej prosty model (gdy włączony); nil – sam otwór. Liczy wstawione i dopisuje uwagi (brak pliku, inny wymiar modelu). |
| 69 | `prosta(model, nazwa, czesci, dom_id)` | Definicja prostego modelu z części (każda w swojej grupie; szyba z materiałem przezroczystym). |
| 85 | `material_szyby(model)` | Materiał szyby (niebieskawy, przezroczysty) – zakładany raz w modelu; nil – model bez materiałów. |
| 99 | `uwaga_wymiaru(d, s)` | Uwaga, gdy model ma inną szerokość albo wysokość niż stolarka z listy (o więcej niż TOL); nil – zgodny. |

### sketchup/typy_domow.rb (133 wierszy)

typy domów – wbudowane (Typ 100–400) i własne zapisywane przez użytkownika: lista z opisami, zapis („Zapisz jako typ”, „Zapisz zmiany w typie”), powielenie, usunięcie, ostatnio wybrany typ, parametry nowego domu i baza porównania dla okna.

Zależy od: sketchup/ustawienia.rb (plik ustawień), rdzen/poziomy.rb (pola typu i domu), rdzen/parametry_lista.rb (SZABLONY – typy wbudowane)
Używają: sketchup/sterowanie.rb (start nowego domu), sketchup/okno.rb (dane startowe), sketchup/okno_typy.rb (wywołania okna)

| Wiersz | Element | Opis |
|---:|---|---|
| 17 | `module TypyDomow` |  |
| 19 | `OPISY` | Opisy typów wbudowanych (jedno zdanie pod nazwą na liście). |
| 25 | `NAJDLUZSZA_NAZWA` |  |
| 30 | `wbudowane` | Typy wbudowane: { nazwa => { 'opis' =>, 'parametry' => } } – z szablonów „Typ …” listy parametrów. |
| 42 | `wlasne` | Własne typy z pliku ustawień: { nazwa => { 'opis' =>, 'parametry' => } }. |
| 52 | `lista` | Lista typów do okna: wbudowane, potem własne alfabetycznie – [{ 'nazwa' =>, 'opis' =>, 'wbudowany' => }]. |
| 58 | `typ(nazwa)` | Typ o podanej nazwie ({ 'opis' =>, 'parametry' => }); nil – nie ma takiego. |
| 63 | `parametry(nazwa)` | Pola typu (poziomy „Typ domu” i „Ten dom”); nieznany typ – {}. |
| 69 | `wbudowany?(nazwa)` | Czy typ jest wbudowany. |
| 74 | `wybrany` | Ostatnio wybrany typ (gdy już go nie ma – pierwszy wbudowany). |
| 80 | `wybierz(nazwa)` | Zapamiętanie wybranego typu; zwraca tekst błędu albo nil. |
| 88 | `nowy_dom(nazwa)` | Parametry nowego domu tego typu do okna: standard warsztatu uzupełniony polami typu (Poziomy.zloz). |
| 94 | `baza(nazwa)` | Baza porównania dla okna – wartości wszystkich pól według standardu i typu (sprawdzone, z wymiarami zamka): pole o innej wartości jest „zmienione tylko w tym domu”. |
| 100 | `zapisz(nazwa, opis, parametry)` | Zapis własnego typu z parametrów okna („Zapisz jako typ” – nowa nazwa, „Zapisz zmiany w typie” – ta sama): zostają pola poziomów „Typ domu” i „Ten dom”; zwraca tekst błędu albo nil. |
| 115 | `powiel(nazwa, nowa)` | Powielenie typu (także wbudowanego) pod nową nazwą; zwraca tekst błędu albo nil. |
| 123 | `usun(nazwa)` | Usunięcie własnego typu; zwraca tekst błędu albo nil. |

### sketchup/ustawienia.rb (200 wierszy)

plik ustawień na komputerze – standard warsztatu (pola poziomu „Standard warsztatu” i wymiary zamka), ustawienia okna (układ, tryb pól), odczyt i zapis pliku, przeniesienie plików starszych kompilacji (ostatnie parametry → standard, szablony → typy domów).

Zależy od: rdzen/poziomy.rb (pola poziomu standard), rdzen/parametry_lista.rb, log.rb
Używają: sketchup/typy_domow.rb (typy w tym samym pliku), sketchup/sterowanie.rb (start nowego domu), sketchup/okno.rb, sketchup/okno_typy.rb, sketchup/dziennik_pracy.rb (katalog), sketchup/raport.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 26 | `module Ustawienia` |  |
| 27 | `PLIK` |  |
| 28 | `KOPIA` |  |
| 32 | `WERSJA` | Wersja pliku: 2 (runda 10) – podciąg domyślnie na równo z podwaliną; 3 (runda 14) – listy przekrojów z hurtowni z długościami handlowymi; 4 (runda 15) – deski nadbitki i podbitki 14 × 115, przekrój 45 × 120 w długościach 5,4 / 6 m; 5 (runda 16) – standard warsztatu i typy domów zamiast ostatnich parametrów i szablonów, pół zamka fabrycznie włączone. |
| 34 | `LISTY_PRZEKROJOW` | Listy przekrojów (rdzen/wykaz_drewna.rb) – w pliku starszym niż wersja 3 zastępowane fabrycznymi także w szablonach. |
| 38 | `DESKI` | Wymiary desek nadbitki i podbitki (rdzen/parametry_dach.rb) – w pliku starszym niż wersja 4 wracają do fabrycznych 14 × 115 (decyzja użytkownika z 2026-11-25), także w szablonach. |
| 41 | `DO_FABRYCZNYCH` | Ostatnie parametry z pliku starszej wersji, które wracają do wartości fabrycznych: wersja pliku => klucze (wersja 4: deski, lista legarów z przekrojem 45 × 120 i wybór warstw poszycia; wersja 5: pół zamka). |
| 45 | `DO_FABRYCZNYCH_W_SZABLONACH` | To samo we własnych szablonach: wersja pliku => klucze. |
| 48 | `TYP_OSTATNIE` | Nazwa typu, którym stają się ostatnie parametry z pliku starszej wersji, i jego opis. |
| 49 | `UKLADY` |  |
| 54 | `katalog` | Katalog ustawień na tym komputerze. |
| 66 | `sciezka` | Pełna ścieżka pliku ustawień. |
| 71 | `pusty` | Pusty zestaw ustawień bieżącej wersji. |
| 77 | `wczytaj` | Zawartość pliku (pusty zestaw, gdy brak pliku albo plik uszkodzony – wtedy ostrzeżenie w Log); plik starszej wersji przeniesiony do bieżącej (ze_starszej) i zapisany, stary zostaje obok jako kopia. |
| 96 | `standard_biezacy(st)` | Standard z pliku w obecnej postaci: dawne pola (listy przekrojów, nowe okno i drzwi – do kompilacji 16) przeniesione do magazynu drewna i listy stolarki; bez dawnych pól – bez zmian. |
| 105 | `hash(v)` | Hash albo pusty hash, gdy to coś innego. |
| 112 | `ze_starszej(d)` | Ustawienia z pliku starszej wersji: zmienione wartości fabryczne zastępują zapamiętane (DO_FABRYCZNYCH), ostatnie parametry – pola standardu inne niż fabryczne stają się standardem warsztatu, pola typu i domu – typem TYP_OSTATNIE; własne szablony – typami (pola typu i domu). |
| 134 | `tylko_inne(parametry)` | Tylko te pola zestawu, których wartość jest inna niż fabryczna. |
| 142 | `inny_zamek?(parametry)` | Czy wymiary zamka w zestawie są inne niż wymiary presetu. |
| 147 | `zapisz(dane)` | Zapis całego pliku (najpierw plik tymczasowy, potem zamiana); true gdy się udało. |
| 159 | `standard` | Standard warsztatu: zapisane pola poziomu „Standard warsztatu” (inne niż fabryczne) i wymiary zamka. |
| 165 | `zapisz_standard(parametry)` | Zapis standardu warsztatu z zestawu parametrów (pola innych poziomów pominięte, zostają tylko wartości inne niż fabryczne; pusty zestaw – powrót do fabrycznych); zwraca tekst błędu albo nil. |
| 175 | `uklad` | Układ okna: 'kroki' (nowy – kroki w kolejności budowy, wynik zawsze na widoku; domyślnie) albo 'zakladki' (dotychczasowy). |
| 181 | `zapamietaj_uklad(nazwa)` | Zapamiętanie układu okna. |
| 188 | `tryb_pol` | Tryb pól okna w układzie dotychczasowym: 'podstawowe' (domyślnie) albo 'wszystkie'. |
| 193 | `zapamietaj_tryb_pol(tryb)` | Zapamiętanie trybu pól okna. |

### sketchup/wejscie.rb (69 wierszy)

odczyt zaznaczenia – narysowane linie (obrys, osie działowych, kontrfory) albo istniejący dom z generatora.

Zależy od: sketchup/konwersja.rb, sketchup/atrybuty.rb, log.rb
Używają: sketchup/sterowanie.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `module Wejscie` |  |
| 18 | `TOL_Z` | Linie różniące się wysokością o więcej niż tyle [mm] nie leżą w jednej płaszczyźnie. |
| 24 | `z_zaznaczenia(model)` | Wynik: { dom: grupa } \| { segmenty: [...], z0: mm } \| { dom:, segmenty:, z0: } (zaznaczony dom i linie) \| { pusto: true } (nic nie zaznaczone – dom z wymiarów) \| { blad: tekst }. |
| 53 | `zbierz(lista, tr, wynik, glebokosc)` | Krawędzie z zaznaczenia (także krawędzie zaznaczonej ściany – prostokąt kliknięty raz – i wnętrza grup i komponentów, z ich przekształceniem). |

### html/dzialowe.js (92 wierszy)

ściany działowe w domu z wymiarów (bez rysowania) – tabela w oknie: kierunek, odległość osi od lica, początek i długość; dane do Ruby.

Zależy od: html/wspolne.js (AMGW_DOM), html/okno.html (karta #karta-dzialowe, tabela #tab-dzialowe)
Używają: html/okno.js (init, zbierz – klucz 'dzialowe' w danych do Ruby)

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `AMGW_DZIALOWE` |  |
| 19 | `KIERUNKI` |  |
| 20 | `KLUCZE` |  |
| 24 | `tbody()` | Ciało tabeli działowych. |
| 27 | `dodaj(d)` | Nowy wiersz tabeli z danymi d ({ kierunek, od, poczatek, dlugosc }). |
| 57 | `init(lista, zWymiarow, zmiana)` | Start: działowe zapisane w domu, czy to dom z wymiarów (karta widoczna) i podgląd po zmianie. |
| 69 | `zbierz()` | Działowe z tabeli do wysłania do Ruby; poza domem z wymiarów – null (Ruby zostawia działowe domu bez zmian). |
| 85 | `nowa(dlugoscDomu)` | Nowa działowa w poprzek na środku długości domu (od – z pola długości). |

### html/edycja.js (179 wierszy)

ustawienia pojedynczej ściany pod jej widokiem – ostatek na każdym końcu, węgły dodawane i usuwane kliknięciem w widok, co jest nad działową (strop, antresola, półka) i jej góra.

Zależy od: html/wspolne.js (AMGW_DOM), dane widoku z Ruby (rdzen/widok.rb: ustawienia, domyslne, skrzyzowania)
Używają: html/okno.js (init, panel po widoku, klik z html/sciana.js, dane do podglądu), html/wegly_przesun.js (przesun)

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
| 86 | `przesun(id, osie, stare, nowe)` | Przesunięcie węgła ściany id z osi stare na nowe (html/wegly_przesun.js): węgły ściany (osie – lista z podglądu, bez węgłów z tabeli) zapisane jako ręczne z nowym położeniem; potem podgląd. |
| 96 | `wegielPrzy(d, s, zasieg)` | Najbliższy węgieł do miejsca s w zasięgu BLISKO (albo zasieg [mm]); null – brak. |
| 109 | `poleLiczby(box, id, etykieta, wartosc, naZmiane)` | Pole liczby w panelu (etykieta, wartość, po zmianie – funkcja z nową wartością). |
| 122 | `panel(box, d)` | Panel ustawień ściany pod widokiem (d – dane widoku z Ruby; brak – panel pusty). |
| 157 | `panelDzialowej(pola, d, u, s, dom)` | Pola działowej: co jest nad nią (strop, antresola, półka – tylko wtedy niższa) i góra działowej. |

### html/kanaly.js (117 wierszy)

kanały na przewody (N3) w oknie – lista kanałów domu (ściana, od, średnica, puszka), okienko kanału przy kliknięciu w widok ściany (nowy, poprawa, usunięcie), lista pod tabelą okien i drzwi.

Zależy od: html/wspolne.js (AMGW_DOM), html/klik_sciana.js (AMGW_KLIK – okienko, pola, przyciski), html/okno.html (#lista-kanalow)
Używają: html/okno.js (dane domu – kanaly, start), html/klik_sciana.js (kliknięcie przy kanale albo w trybie „kanał”), html/sciana.js (rysunek kanałów z widoku)

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `AMGW_KANALY` |  |
| 24 | `init(lista, parametr, zmiana)` | Start: kanały domu, odczyt parametru z formularza, podgląd po zmianie. |
| 34 | `kopia(k)` | Kopia kanału z polami tekstowymi. |
| 39 | `tekst(v)` | Wartość pola jako tekst (puste – ''). |
| 42 | `lista()` | Lista kanałów do danych domu. |
| 50 | `przy(d, s, zasieg)` | Kanał widoku ściany d trafiony w miejscu s (zasięg – tolerancja [mm]); numer wiersza albo null. |
| 60 | `okienko(d, ev, nr, s)` | Okienko kanału: nowy w miejscu s ściany d (nr null) albo poprawa wiersza nr. |
| 82 | `usun(nr)` | Usunięcie kanału nr. |
| 88 | `zmiana()` | Po zmianie listy: okienko zamknięte, lista odświeżona, podgląd. |
| 95 | `pokaz()` | Lista kanałów pod tabelą okien i drzwi (z przyciskiem usunięcia). |

### html/klik_sciana.js (229 wierszy)

okna, drzwi, węgły i kanały kliknięciem w widok ściany – przełącznik „klik wstawia: węgieł / okno / drzwi / kanał”, okienko z parametrami przy miejscu kliknięcia (typ stolarki z listy, wymiary, spód, luz górny, nazwa, od), poprawa i usunięcie istniejącego otworu albo węgła.

Zależy od: html/wspolne.js (AMGW_DOM), html/otwory.js (lista stolarki, wiersze tabeli otworów), html/edycja.js (węgły ręczne ściany), html/kanaly.js (AMGW_KANALY – okienko kanału), html/okno.html (#klik-tryb, #karta-widok)
Używają: html/okno.js (klik w widok ściany, start przełącznika), html/kanaly.js (okienko, pola i przyciski okienka)

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `AMGW_KLIK` |  |
| 22 | `TRYBY` |  |
| 25 | `init(parametr, zmiana)` | Start: odczyt parametru z formularza i podgląd po zmianie; przyciski przełącznika nad widokiem ściany. |
| 41 | `ustawTryb(t)` | Wybór, co wstawia kliknięcie w widok ściany ('wegiel' \| 'okno' \| 'drzwi' \| 'kanal'). |
| 53 | `luzBoczny()` | Luz boczny stolarki z formularza [mm]. |
| 56 | `otworPrzy(d, s, h)` | Otwór widoku trafiony kliknięciem (s, h); null – brak. |
| 68 | `klik(d, s, zasieg, h, ev)` | Kliknięcie w widok ściany d w miejscu s (wysokość h, zasięg trafienia w węgieł, zdarzenie ev): przy węgle – okienko węgła (węgieł to wąski cel, więc ma pierwszeństwo), przy kanale – okienko kanału, w otworze – okienko poprawy otworu, wolne miejsce – okienko nowego elementu według przełącznika. |
| 82 | `okienko(ev, tytul)` | Okienko przy miejscu kliknięcia (pozycja względem karty widoku): tytuł, pola, przyciski. |
| 97 | `pole(box, klucz, etykieta, wartosc, wybory)` | Wiersz okienka: etykieta i pole (tekst albo lista wyboru) z identyfikatorem k-<klucz>. |
| 119 | `przyciski(box, lista)` | Przyciski okienka: [[id, tekst, funkcja, główny]]. |
| 131 | `okienkoOtworu(d, ev, nr, s)` | Okienko okna / drzwi: nowy otwór w miejscu s (nr null) albo poprawa wiersza nr tabeli otworów. |
| 184 | `okienkoWegla(d, ev, sWegla, s)` | Okienko węgła: nowy w miejscu s (sWegla null) albo istniejący w osi sWegla – przesunięcie („od”) i usunięcie. |
| 212 | `wegly(d)` | Osie węgłów na ścianie z widoku. |
| 222 | `zamknij()` | Zamknięcie okienka (gdy otwarte). |

### html/kroki.css (112 wierszy)

wygląd nowego układu okna – kroki w kolejności budowy, prawa kolumna z rzutem i uwagami zawsze na widoku, pasek typu domu, pola zmienione tylko w tym domu, panel standardu warsztatu, lista „Do poprawy / Sprawdzone”.

Zależy od: html/okno.css (kolory)
Używają: html/okno.html

### html/kroki.js (214 wierszy)

nowy układ okna – kroki w kolejności budowy ze znacznikiem stanu, widoczność pól według poziomu (ten dom zawsze, pola typu po rozwinięciu, pola standardu tylko zmienione w tym domu albo wybrane do zmiany), karty kroku, przejście do pola z listy uwag.

Zależy od: html/wspolne.js (AMGW_DOM), html/zalezne.js (pola zależne), html/typy.js (pola zmienione w domu)
Używają: html/uklad.js (odświeżenie układu), html/uwagi.js (kliknięcie uwagi), html/okno.js (start, wynik)

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `AMGW_KROKI` |  |
| 22 | `pokaz(e, widoczny)` | Pokazanie albo ukrycie elementu (pusty display – wartość z arkusza stylów). |
| 27 | `znajdz(klucz)` | Krok po kluczu (null – nie ma). |
| 34 | `zbuduj(kroki)` | Pasek kroków: przycisk na każdy krok z miejscem na znacznik stanu. |
| 51 | `widoczne(o)` | Czy pole jest widoczne w bieżącym kroku: warunki pól zależnych, krok, poziom (ten dom – zawsze; typ – po rozwinięciu, zmienione albo przypięte; standard – zmienione w tym domu albo przypięte). |
| 59 | `zastosuj(opisy)` | Widoczność pól, sekcji i kart według kroku i poziomów; pasek z liczbą pól typu i wyborem pola standardu. |
| 95 | `znajdzKrokSekcji(sekcja)` | Krok, do którego należy sekcja parametrów. |
| 102 | `pasekPoziomow(typ, ukryte, zamekWidoczny)` | Pasek nad polami kroku: przycisk „pola typu domu” (rozwiń / zwiń) i lista pól standardu do zmiany tylko w tym domu. |
| 127 | `karty()` | Karty okna z atrybutem data-krok: widoczne tylko w swoich krokach. |
| 136 | `przyciski()` | Wyróżnienie przycisku bieżącego kroku. |
| 145 | `wybierz(klucz)` | Przejście do kroku. |
| 152 | `znaczniki(uwagi)` | Znaczniki stanu kroków z listy uwag (html/uwagi.js): liczba uwag do poprawy albo ✓. |
| 174 | `opis(klucz)` | Opis pola po kluczu. |
| 182 | `idzDo(klucz, sekcja, krok)` | Przejście do pola (klucz), sekcji albo kroku: właściwy krok, pole ukryte poziomem przypięte, przewinięcie, wejście w pole i krótkie podświetlenie. Zwraca true, gdy było dokąd przejść. |
| 211 | `krok()` | Bieżący krok. |

### html/okno.css (198 wierszy)

wygląd okna parametrów.

Zależy od: –
Używają: html/okno.html

### html/okno.html (234 wierszy)

okno parametrów generatora – układ okna (sekcje formularza budowane przez okno.js z listy parametrów z Ruby): pasek typu domu, kroki albo zakładki, karty rzutu, wyniku, widoku ściany, otworów, węgłów i zestawienia, panel standardu warsztatu.

Zależy od: html/okno.css, html/kroki.css, html/wspolne.js, html/rzut.js, html/sciana.js, html/tabela.js, html/klik_sciana.js, html/kanaly.js, html/dzialowe.js, html/wycena.js, html/zmiany.js, html/tryb.js, html/zakladki.js, html/typy.js, html/standard.js, html/kroki.js, html/uwagi.js, html/uklad.js, html/edycja.js, html/wyniki.js, html/okno.js
Używają: sketchup/okno.rb

### html/okno.js (401 wierszy)

logika okna parametrów – sekcje i pola z listy parametrów, podpowiedzi, wymiary zamka, wynik podglądu, wywołania Ruby; typy, standard, kroki i układ w osobnych plikach.

Zależy od: html/okno.html, html/okno.css, html/wspolne.js (AMGW_DOM), html/wyniki.js (AMGW_WYNIKI.pokaz), html/sciana.js (AMGW_SCIANA), html/zmiany.js (AMGW_ZMIANY), html/tryb.js (AMGW_TRYB), html/typy.js (AMGW_TYPY), html/standard.js (AMGW_STANDARD), html/kroki.js (AMGW_KROKI), html/uwagi.js (AMGW_UWAGI), html/uklad.js (AMGW_UKLAD), html/edycja.js (AMGW_EDYCJA), html/otwory.js (AMGW_OTWORY – tabela okien i drzwi), html/klik_sciana.js (AMGW_KLIK – okienko przy kliknięciu w widok ściany), html/kanaly.js (AMGW_KANALY – kanały na przewody), html/dzialowe.js (AMGW_DZIALOWE – działowe domu z wymiarów), html/wegly.js (AMGW_WEGLY), html/wegly_przesun.js, html/przeliczenia.js, html/zalezne.js, html/pomoc.js, html/zakladki.js, html/tabela.js (pola-tabele), html/sciezka.js (pole ze ścieżką)
Używają: sketchup/okno.rb (AMGW.init, AMGW.wynik, AMGW.typy, AMGW.widok, AMGW.komunikat)

| Wiersz | Element | Opis |
|---:|---|---|
| 12 | `AMGW` |  |
| 23 | `wywolaj(nazwa, dane)` | Wywołanie Ruby (window.sketchup.nazwa) – poza SketchUpem nic nie robi. |
| 33 | `zbudujSekcje()` | Sekcje formularza (rozwijane) z listy sekcji, każda w pojemniku swojej zakładki (AMGW_ZAKLADKI); zachowuje rozwinięcie przy przebudowie. |
| 52 | `zbudujFormularz(parametry)` | Formularz: sekcje, pole na każdy parametr (z podpowiedzią) i wymiary zamka. |
| 63 | `listyMagazynu()` | Podpowiedzi przekrojów z magazynu drewna (datalist magazyn-<zastosowanie>) dla pól przekrojów z cechą „magazyn”. |
| 81 | `odswiezPola()` | Po zmianie wartości pól: podpowiedzi przekrojów z magazynu, wybory zależne, wyróżnienie zmienionych (względem fabrycznych i względem typu ze standardem), nazwy zakładek i widoczność pól w bieżącym układzie. |
| 93 | `dodajPole(opis, parametry)` | Jedno pole parametru w swojej sekcji (lista wyboru, liczba, przekrój albo tekst), podpowiedź pod nim i pytajnik z objaśnieniem; zmiana pola – pola zależne, wyróżnienie zmienionych, widoczność i podgląd. |
| 151 | `poleTabeli(sekcja, opis, wartosc)` | Pole-tabela w formularzu domu (lista stolarki, magazyn drewna): wartość w ukrytym polu (tekst JSON), etykieta z liczbą wierszy – tabelę zmienia się w panelu „Standard warsztatu”. |
| 161 | `wartoscPola(klucz, domyslna)` | Wartość pola parametru z formularza (gdy brak pola – domyślna). |
| 169 | `zbudujZamek(parametry)` | Pola wymiarów zamka: wartości własne albo z presetu. |
| 191 | `zbierzParametry()` | Parametry z formularza (z wymiarami zamka) do wysłania do Ruby. |
| 206 | `pokazKomunikat(tekst, rodzaj)` | Komunikat nad formularzem (ok / blad). |
| 213 | `ukryjKomunikat()` | Ukrycie komunikatu. |
| 216 | `pokazWynik(d)` | Wyniki do okna (html/wyniki.js), lista ścian dla tabeli otworów (html/otwory.js) i odświeżenie widoku ściany. |
| 240 | `wybierzSciane(id)` | Wybór ściany do widoku (lista albo kliknięcie na rzucie). |
| 255 | `widok(d)` | Widok ściany z Ruby (AMGW.widok) – rysunek, gdy to nadal wybrana ściana; kliknięcie w rysunek dodaje albo usuwa węgieł; pod rysunkiem panel ustawień ściany. |
| 265 | `dane()` | Dane formularza jako JSON (parametry, otwory, kanały, węgły, ustawienia ścian z widoku, typ; dom z wymiarów – działowe). |
| 275 | `zaplanujPodglad()` | Podgląd po zmianie pola (z opóźnieniem 350 ms – kilka zmian = jedno wywołanie); przeliczenie otworów w tabeli; okno samego standardu (z menu) – bez podglądu. |
| 284 | `init(d)` | Start okna danymi z Ruby (AMGW.init): pola (pola domu z wymiarów tylko dla domu bez narysowanego obrysu), typy i standard, kroki, układ okna, wynik pierwszego przeliczenia; tryb 'standard' (z menu) – sam panel standardu. |
| 322 | `ustaw(d)` | Nowy formularz z podanych parametrów (pola bez wartości – fabryczne) i podgląd; do testów okna (AMGW._ustaw). |
| 328 | `typy(d)` | Typy domów i baza porównania z Ruby (AMGW.typy) – po wyborze, zapisie albo usunięciu typu i po zapisie standardu. |
| 331 | `wynik(d)` | Wynik z Ruby (AMGW.wynik) – po podglądzie albo generowaniu. |
| 350 | `opisStolarki(st)` | Zdanie o modelach okien i drzwi wstawionych w otwory (sketchup/stolarka_modele.rb): z plików i proste z generatora; bez modeli – pusty tekst. |
| 357 | `start()` | Podpięcie przycisków i zgłoszenie gotowości okna do Ruby. |
| 398 | `komunikat(d)` | Komunikat z Ruby (AMGW.komunikat) – np. po zapisie zestawienia. |

### html/otwory.js (290 wierszy)

tabela okien i drzwi w oknie – typ z listy typowej stolarki, stolarka (ściana, od, szerokość i wysokość stolarki, parapet, luz górny, nazwa), otwór w balach i podpowiedź luzu górnego; wiersz do poprawy z okienka przy widoku ściany.

Zależy od: html/wspolne.js (AMGW_DOM), html/tabela.js (lista stolarki z pola „stolarka”), html/okno.html (tabela #tab-otwory, #nowy-typ)
Używają: html/okno.js (init, dodaj, zbierz, sciany, pierwszaSciana, przelicz, dodajTyp), html/klik_sciana.js (lista, wiersz, ustaw, usun)

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `AMGW_OTWORY` |  |
| 19 | `KLUCZE` |  |
| 23 | `lista()` | Lista typowej stolarki z pola „stolarka” (standard warsztatu): [{ symbol, rodzaj, szerokosc, wysokosc, spod, model }]. |
| 33 | `typ(symbol)` | Pozycja listy stolarki po symbolu (null – brak). |
| 41 | `opisTypu(t)` | Opis pozycji listy: „O1 – okno 1020 × 1010”. |
| 46 | `wypelnijTypy(sel, wybrany)` | Opcje listy typów w polu wyboru (pierwsza: inny wymiar – bez typu); zachowuje wybrany. |
| 64 | `init(parametr, zmiana)` | Start: odczyt parametru z formularza (klucz, wartość domyślna) i reakcja na zmianę wiersza (podgląd). |
| 70 | `liczba(t)` | Liczba z pola tekstowego (przecinek albo kropka, spacje pomijane) albo null. |
| 78 | `podpowiedz(h)` | Podpowiedź luzu górnego dla wysokości stolarki h [mm] (jak Stolarka.luz_podpowiedz w Ruby). |
| 86 | `przeliczWiersz(tr)` | Wiersz: podpowiedź luzu w pustym polu i wymiary otworu w balach (szer. × wys.). |
| 108 | `przelicz()` | Przeliczenie wszystkich wierszy (po zmianie luzu bocznego albo osiadania w parametrach) i odświeżenie list typów, gdy zmieniła się lista stolarki. |
| 124 | `wypelnijNowy()` | Lista typów przy przycisku „+ dodaj” (bez pozycji pustej). |
| 139 | `wypelnijSciany(sel, wybrana)` | Lista ścian dla otworu (bez kontrforów); brakująca ściana zostaje z dopiskiem. |
| 158 | `dodaj(o)` | Nowy wiersz tabeli z danymi otworu o (klucze jak w Ruby: sciana, od, szerokosc, wysokosc, parapet, luz_gorny, nazwa). |
| 202 | `zbierz()` | Otwory z tabeli do wysłania do Ruby. |
| 217 | `sciany(lista)` | Nowa lista ścian (po podglądzie) – odświeżenie list w wierszach. |
| 225 | `dodajZListy(symbol, sciana, od)` | Nowy wiersz z pozycji listy stolarki o symbolu (ściana, od – podane albo domyślne); false – brak takiej pozycji. |
| 234 | `dodajTyp(rodzaj)` | Nowy wiersz z pierwszej pozycji listy danego rodzaju ('okno' \| 'drzwi'); false – lista nie ma takiej pozycji. |
| 242 | `wiersze()` | Wiersze tabeli (elementy tr). |
| 245 | `wiersz(nr)` | Dane wiersza nr (kolejność w tabeli – jak nr otworu z Ruby); null – brak. |
| 256 | `ustaw(nr, o)` | Nowe wartości wiersza nr (klucze jak w dodaj; brakujące zostają) i podgląd. |
| 271 | `usun(nr)` | Usunięcie wiersza nr i podgląd. |
| 279 | `pierwszaSciana()` | Pierwsza ściana (nie kontrfor) – domyślna dla nowego otworu. |

### html/pomoc.js (107 wierszy)

objaśnienia pól w oknie – znak zapytania w kółku przy etykiecie, po kliknięciu ramka z dłuższym opisem i rysunkiem pokazującym różnicę (obciążenie, ugięcie, podbitka, położenie płatwi ściennej, układ dachu); krótka podpowiedź pola po wejściu w pole.

Zależy od: html/wspolne.js (AMGW_DOM)
Używają: html/okno.js (dodajPole)

| Wiersz | Element | Opis |
|---:|---|---|
| 12 | `AMGW_POMOC` |  |
| 19 | `RYSUNKI` | Rysunki SVG (viewBox 0 0 320 120): podpisy po polsku, linie w kolorze tekstu, drewno – kolor akcentu. |
| 72 | `dodaj(sekcja, etykieta, opis)` | Znak zapytania przy etykiecie pola i ukryta ramka objaśnienia (po polu); nic, gdy pole nie ma pomocy ani rysunku. |
| 95 | `poWejsciu(pole, klucz)` | Podpowiedź pola pokazywana po wejściu w pole (układ nowy – html/kroki.css chowa podpowiedzi bez klasy „aktywna”); po wyjściu z pola znika. |

### html/przeliczenia.js (78 wierszy)

przeliczenia przy parametrach – podpowiedzi z obliczeń (legar, podciąg, fundamenty, dach) pokazane w sekcji parametrów, której dotyczą, i krótka informacja, co zmieniło się w domu po ostatniej zmianie pola.

Zależy od: html/wspolne.js (AMGW_DOM)
Używają: html/okno.js (pokazWynik – po każdym podglądzie)

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `AMGW_PRZELICZENIA` |  |
| 21 | `LICZBY` | Liczby porównywane po podglądzie: [klucz, nazwa, miejsca po przecinku, jednostka]. |
| 25 | `wSekcjach(podp)` | Podpowiedzi w sekcjach: ramka „przeliczenia” na końcu pól każdej sekcji, do której są podpowiedzi. |
| 44 | `liczba(v, m)` | Liczba z zaokrągleniem i przecinkiem. |
| 49 | `zmiana(n)` | Co się zmieniło względem poprzedniego podglądu (tekst; pusty – bez zmian albo pierwszy podgląd). |
| 67 | `pokaz(d)` | Po podglądzie: podpowiedzi w sekcjach i informacja o zmianie (element #zmiana-podgladu). |

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

### html/sciana.js (258 wierszy)

widok ściany w oknie (SVG) – bale z numerami pozycji, wieńce, otwory, kanały na przewody, styki, skrzyżowania z innymi ścianami i węgłami, linia dachu; wybór ściany.

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
| 69 | `rysuj(box, d, opis, naKlik)` | Rysunek ściany w kontenerze; opis nad rysunkiem w elemencie opis (gdy podany); naKlik(s, zasieg, h, zdarzenie) – kliknięcie w rysunek: miejsce s na osi ściany, zasięg trafienia w węgieł [mm] (8 px rysunku) i wysokość h. |
| 109 | `klikanie(svg, d, z, m, k, naKlik)` | Kliknięcie w rysunek: miejsce na osi ściany s i wysokość h (z odwróconego przekształcenia SVG) do funkcji naKlik(s, zasięg trafienia [mm], h, zdarzenie). |
| 125 | `skrzyzowania(svg, d, z, X, Y, px)` | Skrzyżowania z innymi ścianami i węgłami: linia przerywana i opis nad ścianą (węgieł ręczny – opis pogrubiony). |
| 141 | `slupy(svg, d, X, Y)` | Słupy tarasu w ścianie: prostokąty pod balami (z zamkiem górnym i dolnym – cała długość słupa). |
| 152 | `bale(svg, d, X, Y, px, k)` | Bale: obrys z gniazdami zamków i skosem, kolor wg grupy, numer pozycji (gdy się mieści) i opis po najechaniu. |
| 175 | `otwory(svg, d, X, Y, px)` | Otwory: prostokąt otworu w balach, w nim stolarka (przerywana – widać luz boczny i górny) i nazwa. |
| 198 | `kanaly(svg, d, z, X, Y, px)` | Kanały na przewody (rdzen/kanaly.rb): pionowy pas na całą wysokość ściany, kółko puszki i nazwa. |
| 216 | `styki(svg, d, X, Y)` | Styki bali: czerwona kreska na końcu bala oznaczonym jako styk. |
| 231 | `dach(svg, d, X, Y)` | Linia dachu (szczyt – wierzch bali szczytu, ściana pod połacią – spód krokwi). |
| 241 | `wience(svg, d, z, m, X, Y, px, k)` | Numery wieńców z lewej (co który się mieści). |

### html/sciezka.js (47 wierszy)

pola ze ścieżką pliku albo folderu (folder modeli stolarki, kolumna „Model” listy stolarki) – przycisk „…” obok pola otwiera okno wyboru w SketchUpie, wybrana ścieżka wraca do pola.

Zależy od: html/wspolne.js (AMGW_DOM)
Używają: html/tabela.js (kolumna rodzaju 'plik'), html/standard.js i html/okno.js (pole z cechą sciezka), sketchup/okno_sciezki.rb (AMGW_SCIEZKA.wybrana)

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `AMGW_SCIEZKA` |  |
| 21 | `opakuj(p, rodzaj)` | Pole p (input) w opakowaniu z przyciskiem „…” wyboru ścieżki rodzaju 'folder' albo 'plik'; zwraca opakowanie. |
| 37 | `wybrana(d)` | Odpowiedź Ruby: wpisanie wybranej ścieżki do pola i zdarzenie „change” (jak po wpisaniu ręcznym). |

### html/standard.js (194 wierszy)

panel „Standard warsztatu” – pola poziomu standard pogrupowane sekcjami z wymiarami zamka, wyszukiwanie pola, zapis standardu i powrót do wartości fabrycznych.

Zależy od: html/wspolne.js (AMGW_DOM), html/zmiany.js (porównanie z fabrycznymi), html/typy.js (baza – bieżący standard), html/tabela.js (pola-tabele), html/sciezka.js (pole ze ścieżką)
Używają: html/okno.js (przycisk „Standard warsztatu…”, odpowiedź Ruby, okno otwarte z menu „Standard warsztatu…” – tryb 'standard')

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `AMGW_STANDARD` |  |
| 25 | `tabela(box, o, v)` | Pole-tabela panelu (lista stolarki, magazyn drewna): etykieta na całą szerokość, edytor tabeli (html/tabela.js) z ukrytym polem s-<klucz> trzymającym tekst JSON, podpowiedź pod tabelą. |
| 39 | `pole(box, o, v)` | Pole panelu dla opisu o z wartością v (lista wyboru, pole tekstowe albo tabela) i etykieta wyróżniona, gdy inne niż fabryczne. |
| 64 | `wyroznij(o)` | Etykieta pola panelu wyróżniona, gdy wartość inna niż fabryczna. |
| 73 | `zbuduj(baza)` | Zawartość panelu: sekcje z polami poziomu standard (wartości z bazy) i wymiary zamka. |
| 98 | `zamek(box, wymiary)` | Pola wymiarów zamka w panelu. |
| 112 | `zbierz()` | Wartości z panelu: { klucz: wartość, zamek: { … } }. |
| 125 | `szukaj(tekst)` | Filtr pól panelu po tekście etykiety (puste – wszystkie); grupy bez pasujących pól schowane. |
| 148 | `otworz()` | Otwarcie panelu z bieżącym standardem (baza z html/typy.js). |
| 156 | `zamknij()` | Zamknięcie panelu; okno otwarte z menu „Standard warsztatu” (bez domu) – zamknięcie całego okna. |
| 162 | `samodzielnie()` | Okno otwarte z menu „Standard warsztatu…” – sam panel standardu na całe okno, bez domu i bez podglądu. |
| 169 | `samodzielny()` | Czy okno pokazuje sam standard (otwarte z menu, bez domu). |
| 172 | `poZapisie()` | Po zapisie standardu albo powrocie do fabrycznych w oknie bez domu: pola panelu z nowego standardu. |
| 175 | `otwarty()` | Czy panel jest otwarty. |
| 178 | `init(opisy, sekcje, opisyZamka, wywolaj)` | Start: opisy pól, sekcje, opisy wymiarów zamka i wywołanie Ruby; podpięcie przycisków panelu. |

### html/tabela.js (168 wierszy)

pola-tabele w oknie (lista typowej stolarki, magazyn drewna) – edytor tabeli z dodawaniem i usuwaniem wierszy, wartość jako tekst JSON w ukrytym polu, porównanie tabel bez względu na zapis liczb.

Zależy od: html/wspolne.js (AMGW_DOM), html/sciezka.js (AMGW_SCIEZKA – kolumna 'plik')
Używają: html/standard.js (tabele w panelu standardu), html/okno.js (ukryte pole tabeli w formularzu domu), html/zmiany.js i html/typy.js (porównanie, wpisanie), html/otwory.js (lista stolarki)

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `AMGW_TABELA` |  |
| 21 | `wiersze(v)` | Tablica wierszy z wartości pola (tablica albo tekst JSON); niepoprawna – pusta tablica. |
| 32 | `komorka(k, v)` | Wartość komórki w postaci porównywalnej (liczba – bez zbędnych zer, znacznik – true / false, tekst – bez spacji na końcach). |
| 42 | `pusty(opis, r)` | Czy wiersz nie ma żadnej wartości (jak w Ruby: wiersz pusty pomijany). |
| 56 | `kanon(opis, v)` | Tabela w postaci kanonicznej (wiersze z kolumnami opisu, bez pustych) – do porównań i zapisu. |
| 73 | `rozne(opis, a, b)` | Czy dwie wartości tabeli są różne. |
| 78 | `tekst(opis, v)` | Tekst JSON tabeli do ukrytego pola. |
| 81 | `poleKomorki(k, v, naZmiane)` | Komórka edytora: pole tekstowe (kolumna 'plik' – z przyciskiem wyboru pliku), lista wyboru albo znacznik; zmiana – naZmiane. |
| 104 | `zEdytora(opis, tab)` | Wiersze z edytora (tabela HTML) w postaci kanonicznej. |
| 122 | `edytor(box, opis, wartosc, naZmiane)` | Edytor tabeli w kontenerze box: tabela z wierszami wartości, przycisk „+ wiersz”, × przy wierszu; ukryte pole (zwracane) trzyma tekst JSON i jest aktualizowane po każdej zmianie (potem naZmiane, gdy podane). |

### html/tryb.js (69 wierszy)

tryb pól okna – „Podstawowe” (tylko najczęściej zmieniane parametry i te zmienione względem fabrycznych) albo „Wszystkie”.

Zależy od: html/wspolne.js (AMGW_DOM), html/zmiany.js (klasa „zmieniony” na etykiecie), html/zalezne.js (pola zależne – ukryte, gdy pole nadrzędne ma inną wartość)
Używają: html/okno.js (po zbudowaniu formularza, po zmianie pola, przełącznik w nagłówku formularza)

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `AMGW_TRYB` |  |
| 20 | `pokaz(e, widoczny)` | Pokazanie albo ukrycie elementu (pusty display – wartość z arkusza stylów). |
| 27 | `zastosuj(opisy)` | Widoczność pól według trybu: w trybie podstawowym pola podstawowe i zmienione, pola zależne tylko przy spełnionym warunku (AMGW_ZALEZNE), sekcje bez widocznych pól ukryte, wymiary zamka tylko w trybie „Wszystkie”. |
| 51 | `przyciski()` | Wyróżnienie przycisku bieżącego trybu. |
| 59 | `ustaw(tryb, opisy)` | Ustawienie trybu ('podstawowe' \| 'wszystkie') i odświeżenie widoczności pól. |
| 66 | `tryb()` | Bieżący tryb. |

### html/typy.js (250 wierszy)

typ domu w oknie – lista typów z opisem, „Zapisz zmiany w typie”, „Zapisz jako typ”, powielenie, usunięcie, „Przywróć typ”; baza porównania (standard warsztatu i typ) i pola zmienione tylko w tym domu z przyciskiem powrotu.

Zależy od: html/wspolne.js (AMGW_DOM), html/zmiany.js (porównanie wartości)
Używają: html/okno.js (start, odpowiedź Ruby, zmiana pola), html/kroki.js (widoczność pól), html/standard.js (wartości standardu)

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `AMGW_TYPY` |  |
| 19 | `NAZWY` |  |
| 23 | `znajdz(nazwa)` | Typ z listy po nazwie (null – nie ma). |
| 30 | `pokazListe()` | Lista typów w polu wyboru, opis wybranego i dostępność przycisków (typ wbudowany – bez zapisu zmian i usuwania). |
| 49 | `komunikat(tekst, blad)` | Komunikat pod paskiem typu (blad – na czerwono). |
| 58 | `bazowa(o)` | Wartość bazowa pola (standard i typ); brak w bazie – fabryczna. |
| 64 | `zmienione(o)` | Czy pole ma inną wartość niż w typie i standardzie (zmienione tylko w tym domu). |
| 70 | `wpisz(o, v)` | Wpisanie wartości w pole parametru (liczby bez zbędnego ,0). |
| 78 | `zamekZmieniony()` | Czy wymiary zamka w oknie są inne niż w bazie. |
| 91 | `oznacz(opisy)` | Znacznik poziomu przy etykiecie (typ / standard; „tylko w tym domu”, gdy pole zmienione) i przycisk powrotu pola. |
| 122 | `przyciskPowrotu(o, lab, pokaz)` | Przycisk „↺” przy etykiecie pola zmienionego w tym domu: wartość z typu albo standardu. |
| 140 | `przywroc(poziomy)` | Wszystkie pola (albo tylko podanych poziomów) z powrotem według bazy; z wymiarami zamka przy poziomie standard. |
| 151 | `odpowiedz(d)` | Odpowiedź Ruby (AMGW.typy): nowa lista i baza; wczytaj – pola typu i domu według typu; standard – pola standardu, których w tym domu nie zmieniono, według nowego standardu. |
| 178 | `otworzNowy(tryb)` | Wiersz nazwy i opisu nowego typu: tryb 'zapisz' (Zapisz jako typ) albo 'powiel'. |
| 188 | `zamknijNowy()` | Schowanie wiersza nowego typu. |
| 194 | `zatwierdzNowy(parametry)` | Zatwierdzenie nazwy: zapis nowego typu z pól okna albo powielenie wybranego. |
| 203 | `init(d, opisy, wywolaj, parametry, poZmianie, ustawZamek)` | Start: dane typów z Ruby, wywołanie Ruby, zbieranie parametrów z okna, odświeżenie po zmianie i wpisanie wymiarów zamka. |
| 243 | `typ()` | Nazwa wybranego typu. |
| 246 | `baza()` | Baza porównania (wartości pól według standardu i typu). |

### html/uklad.js (87 wierszy)

przełącznik układu okna – nowy (kroki w kolejności budowy, rzut i uwagi zawsze na widoku) albo dotychczasowy (zakładki i sekcje, tryb Podstawowe / Wszystkie); rozmieszczenie kart i odświeżenie widoczności pól we właściwym układzie.

Zależy od: html/wspolne.js (AMGW_DOM), html/kroki.js (układ nowy), html/tryb.js (układ dotychczasowy), html/zakladki.js
Używają: html/okno.js (start, zmiana pola, odpowiedź typów)

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `AMGW_UKLAD` |  |
| 19 | `KARTY` | Karty w kolejności układu dotychczasowego (prawa kolumna) i karty zawsze po prawej w układzie nowym. |
| 21 | `PRAWE` |  |
| 26 | `rozmiesc()` | Karty we właściwych kolumnach: układ nowy – rzut i wynik po prawej, reszta pod polami kroku; dotychczasowy – wszystkie po prawej w dawnej kolejności i widoczne. |
| 43 | `sekcje()` | Rozwinięcie sekcji: przy przejściu do układu nowego zapamiętane (kroki rozwijają wszystkie), przy powrocie odtworzone. |
| 61 | `odswiez(opisy)` | Widoczność pól, sekcji i kart w bieżącym układzie. |
| 72 | `ustaw(nazwa, opisy)` | Ustawienie układu ('kroki' \| 'zakladki'): klasa na <body>, karty, przyciski, widoczność pól. |
| 84 | `uklad()` | Bieżący układ. |

### html/uwagi.js (62 wierszy)

lista „Do poprawy / Sprawdzone” w prawej kolumnie okna – błędy, ostrzeżenia i podpowiedzi w jednym miejscu, z nazwą kroku; kliknięcie uwagi przenosi do pola, sekcji albo kroku.

Zależy od: html/wspolne.js (AMGW_DOM), html/kroki.js (przejście do pola, znaczniki kroków)
Używają: html/okno.js (wynik podglądu)

| Wiersz | Element | Opis |
|---:|---|---|
| 12 | `AMGW_UWAGI` |  |
| 18 | `KOLEJNOSC` |  |
| 21 | `pozycja(u)` | Jedna pozycja listy: tekst, nazwa kroku i kliknięcie (gdy uwaga ma pole, sekcję albo krok). |
| 33 | `pokaz(uwagi)` | Lista uwag: „Do poprawy” (błędy, ostrzeżenia, uwagi – w tej kolejności) i zwinięte „Sprawdzone”; znaczniki kroków. |

### html/wegly.js (134 wierszy)

tabela węgłów (kontrforów) w oknie – jak okna i drzwi: ściana, położenie (od narożnika albo na środku ściany), od [mm], wypust wewnątrz i na zewnątrz [mm].

Zależy od: html/wspolne.js (AMGW_DOM), html/okno.html (tabela #tab-wegly)
Używają: html/okno.js (init, dodaj, zbierz, sciany), html/wegly_przesun.js (ustawOd – przesunięcie węgła z tabeli)

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `AMGW_WEGLY` |  |
| 22 | `init(zmiana)` | Start: reakcja na zmianę wiersza (podgląd). |
| 27 | `tbody()` | Treść tabeli. |
| 30 | `wypelnijSciany(sel, wybrana)` | Lista ścian (bez węgłów); brakująca ściana zostaje z dopiskiem. |
| 49 | `odswiezWiersz(tr)` | Pole „od” aktywne tylko przy położeniu od narożnika. |
| 57 | `poleWypustu(tr, klucz, wartosc, opis)` | Pole wypustu węgła (wewn / zewn) w wierszu tr; puste – z parametrów. |
| 67 | `dodaj(x)` | Nowy wiersz tabeli z danymi węgła x (sciana, polozenie, od, wewn, zewn). |
| 101 | `zbierz()` | Węgły z tabeli do wysłania do Ruby. |
| 116 | `sciany(lista)` | Nowa lista ścian (po podglądzie) – odświeżenie list w wierszach. |
| 124 | `ustawOd(i, od)` | Nowe położenie węgła z wiersza nr i (przesunięcie z listy węgłów – html/wegly_przesun.js): od narożnika, od [mm]. |

### html/wegly_przesun.js (97 wierszy)

przesuwanie węgłów w karcie okien i drzwi – lista wszystkich węgłów domu (automatyczne, pod płatwiami, na wolnych końcach, z rysunku, ręczne, z tabeli) z położeniem „od” jak przy otworach; zmiana położenia przesuwa węgieł.

Zależy od: html/wspolne.js (AMGW_DOM), html/okno.html (tabela #tab-wegly-przesun), html/wegly.js (AMGW_WEGLY.ustawOd – węgieł z tabeli), html/edycja.js (AMGW_EDYCJA.przesun – węgły ręczne ściany)
Używają: html/okno.js (pokaz po podglądzie)

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `AMGW_PRZESUN` |  |
| 22 | `KROK` |  |
| 23 | `OPISY` |  |
| 30 | `tbody()` | Treść tabeli. |
| 33 | `osieRecznych(sciana)` | Osie (s) węgłów ściany, które idą na listę ręczną (bez z tabeli i na środku z parametru). |
| 44 | `przesun(x, od)` | Przesunięcie węgła x na nowe „od” [mm]. |
| 54 | `przycisk(x, znak)` | Przycisk przesunięcia o krok (znak −1 / +1). |
| 61 | `wiersz(x)` | Wiersz węgła x. |
| 87 | `pokaz(lista)` | Lista węgłów z wyniku podglądu (d.wegly_lista); brak – tabela pusta. |

### html/wspolne.js (84 wierszy)

wspólne funkcje okna – element po identyfikatorze, nowy element, czyszczenie, liczby do wyświetlenia, przebudowa po kliknięciu.

Zależy od: html/okno.html (ładowany pierwszy)
Używają: html/okno.js, html/rzut.js, html/wyniki.js

| Wiersz | Element | Opis |
|---:|---|---|
| 11 | `AMGW_DOM` |  |
| 18 | `el(tag, atrybuty, tekst)` | Nowy element z atrybutami i tekstem. |
| 31 | `wyczysc(e)` | Usunięcie zawartości elementu. |
| 34 | `liczba(v)` | Liczba z tekstu (przecinek dziesiętny dozwolony); null, gdy to nie liczba. |
| 41 | `fmt(v)` | Liczba do wyświetlenia (bez zbędnego ,0). |
| 48 | `fmtPola(v)` | Liczba do pola formularza: bez zaokrąglania do jednego miejsca (0,35 zostaje 0.35 – do trzech miejsc, bez zbędnych zer). |
| 60 | `wykonajOdlozone()` | Wykonanie odłożonych przebudów (po kliknięciu albo gdy okno straciło fokus z wciśniętym przyciskiem). |
| 70 | `poKliknieciu(fn)` | Funkcja przebudowy: od razu, gdy przycisk myszy nie jest wciśnięty; inaczej tuż po kliknięciu (najpóźniej po 0,4 s – gdy przycisk został puszczony poza oknem). |

### html/wycena.js (74 wierszy)

wycena materiału w oknie (W3) – tabela pozycji z ilością, ceną i wartością, suma, lista pozycji bez ceny z odesłaniem do standardu warsztatu.

Zależy od: html/wspolne.js (AMGW_DOM), dane wyniku z Ruby (rdzen/wycena.rb przez sketchup/sterowanie.rb – klucz wycena)
Używają: html/wyniki.js (po każdym podglądzie)

| Wiersz | Element | Opis |
|---:|---|---|
| 11 | `AMGW_WYCENA` |  |
| 19 | `zl(v)` | Kwota w złotych z dwoma miejscami i spacjami tysięcy. |
| 25 | `suma(w)` | Suma wyceny do liczb wyniku (null – żadnej ceny). |
| 33 | `pokaz(w)` | Tabela wyceny w karcie zestawienia; bez żadnej ceny – jedno zdanie, gdzie je wpisać. |

### html/wyniki.js (143 wierszy)

wyniki w oknie – liczby, wysokości, błędy, ostrzeżenia, podpowiedzi, tabela ścian ze stykami, lista bali i belek, tabela materiałów, rzut.

Zależy od: html/wycena.js (AMGW_WYCENA), html/wspolne.js (AMGW_DOM), html/rzut.js (AMGW_RZUT)
Używają: html/okno.js (pokazWynik)

| Wiersz | Element | Opis |
|---:|---|---|
| 11 | `AMGW_WYNIKI` |  |
| 20 | `lista(idBox, pozycje, klasa)` | Lista błędów lub ostrzeżeń. |
| 31 | `wiersz(tbody, komorki, liczbowe)` | Wiersz tabeli wyników. |
| 43 | `podpowiedzi(pozycje)` | Podpowiedzi (podłoga, dobór przekrojów) z poziomem ok / uwaga / blad. |
| 55 | `powierzchnie(wiersze)` | Tabela powierzchni i wysokości w karcie zestawienia: [[nazwa, wartość, jednostka, uwagi]]. |
| 80 | `pokaz(d, naKlik)` | Wyniki: liczby, wysokości, tabela ścian, lista bali, rzut, błędy, ostrzeżenia i podpowiedzi; naKlik(id) – kliknięta ściana na rzucie. |

### html/zakladki.js (79 wierszy)

zakładki formularza parametrów – „Dom” i „Zadaszenie boczne / tylne” (sekcje parametrów w osobnych pojemnikach), przełączanie zakładek i liczba zmienionych pól w nazwie zakładki.

Zależy od: html/wspolne.js (AMGW_DOM), html/okno.html (#zakladki, #sekcje)
Używają: html/okno.js (budowa sekcji formularza, po zmianie pola), html/zmiany.js (klasa „zmieniony” na etykiecie)

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `AMGW_ZAKLADKI` |  |
| 23 | `zbuduj(lista)` | Pasek zakładek (#zakladki) i pusty pojemnik sekcji każdej zakładki (#sekcje-<klucz> w #sekcje); wybrana zakładka zostaje po przebudowie formularza (szablon, fabryczne). |
| 43 | `pojemnik(klucz)` | Pojemnik sekcji zakładki (nieznana zakładka – pierwsza). |
| 48 | `wybierz(klucz)` | Pokazanie zakładki: jej pojemnik widoczny, pozostałe ukryte, przycisk wyróżniony. |
| 63 | `oznacz()` | Nazwy zakładek z liczbą pól zmienionych względem fabrycznych (etykiety z klasą „zmieniony” w pojemniku zakładki). |
| 76 | `biezaca()` | Klucz bieżącej zakładki. |

### html/zalezne.js (130 wierszy)

pola zależne w oknie – pole pokazuje się tylko przy wybranych wartościach pól nadrzędnych (np. kierunek spadku tylko przy dachu jednospadowym), wybory listy – tylko te, które pasują do innych pól (np. położenie desek a układ dachu), a opcje niedostępne dla obrysu domu są wyszarzone z powodem.

Zależy od: html/wspolne.js (AMGW_DOM)
Używają: html/tryb.js (widoczność pól), html/okno.js (po zmianie pola)

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `AMGW_ZALEZNE` |  |
| 23 | `wartosc(klucz)` | Bieżąca wartość pola parametru (brak pola – null); pole doboru „jak przełącznik” (data-wspolny) – wartość przełącznika przekroje_dobor po przełożeniu (data-wspolny-mapa, np. auto → zalecany przy legarach). |
| 37 | `warunek(gdy)` | Czy warunek { klucz: [wartości] } jest spełniony przez bieżące wartości pól. |
| 49 | `spelnione(o, opisy, glebokosc)` | Czy pole o opisie o ma spełnione warunki (także pola nadrzędne – rekurencyjnie po opisach). |
| 61 | `znajdz(opisy, k)` | Opis pola o kluczu k. |
| 69 | `obrys(rodzaj)` | Rodzaj obrysu domu z ostatniego wyniku ('prostokat' \| 'l' \| 'inny'; '' – jeszcze nieznany): opcje niedostępne dla obrysu są wyszarzone z powodem pod polem. |
| 74 | `powod(sel, o, tekst)` | Powód niedostępnych opcji pod polem (pusty tekst – bez wiersza). |
| 92 | `wybory(o)` | Wybory listy zgodne z innymi polami i z obrysem domu: ukrywa opcje niepasujące do innych pól, wyszarza niedostępne dla obrysu (opis.obrys – { tylko: [rodzaje obrysu], zostaje: [wartości zawsze dostępne], powod: tekst }); zwraca true, gdy wybór trzeba było zmienić. |
| 122 | `wszystkieWybory(opisy)` | Wybory zależne wszystkich pól; true – któryś wybór zmieniony (trzeba przeliczyć podgląd). |

### html/zmiany.js (73 wierszy)

pola zmienione względem ustawień fabrycznych – wyróżnienie etykiety, wartość fabryczna w dymku, liczba zmian w nagłówku sekcji.

Zależy od: html/wspolne.js (AMGW_DOM)
Używają: html/okno.js (po zbudowaniu formularza i po zmianie pola)

| Wiersz | Element | Opis |
|---:|---|---|
| 11 | `AMGW_ZMIANY` |  |
| 18 | `rozne(opis, wartosc, wzorzec)` | Czy wartość pola różni się od wzorca (liczby – po wartości, reszta – tekst bez spacji i wielkości liter). |
| 29 | `inneNizFabryczne(opis, wartosc)` | Czy wartość pola różni się od fabrycznej. |
| 35 | `oznacz(opisy)` | Pola zmienione względem ustawień fabrycznych: wyróżniona etykieta (z wartością fabryczną w dymku) i liczba zmienionych pól w nagłówku sekcji. |
| 56 | `opisWartosci(opis, wartosc)` | Wartość pola do opisu w dymku: wybór – jego tekst, tabela – liczba wierszy, liczba – bez zbędnych zer. |
| 63 | `opisWyboru(opis, wartosc)` | Tekst wyboru (np. „wzdłuż dłuższego boku”) dla wartości pola wyboru. |

### testy/atrapa/aplikacja_dachow.rb (84 wierszy)

atrapa aplikacji do dachów (ArteMadera::Roof) – jej stałe API wersji 1 (polacie, podpory, wiezba) – zapisuje wywołania generatora.

Zależy od: testy/atrapa/sketchup.rb
Używają: testy/t_dach_aplikacja.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `module Roof` |  |
| 20 | `PLUGIN_VERSION` |  |
| 22 | `module API` |  |
| 23 | `wersja` |  |
| 27 | `wersja_wtyczki` |  |
| 31 | `polacie(model, punkty, z, kat, okap, krawedzie_szczytowe = [], opcje = {})` |  |
| 48 | `podpory(grupa, lista, _model = nil)` |  |
| 54 | `wiezba(grupa, ustawienia = {}, opcje = {})` |  |
| 64 | `module AtrapaDachow` |  |
| 68 | `wywolania` |  |
| 73 | `ostatnie(nazwa)` | Ostatnie wywołanie o nazwie (nil – nie było). |
| 77 | `wyczysc` |  |

### testy/atrapa/extensions.rb (3 wierszy)

–


### testy/atrapa/sketchup.rb (905 wierszy)

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
| 151 | `module Geom` |  |
| 153 | `class BoundingBox` | Prostopadłościan otaczający (jak Geom::BoundingBox): add punktów albo innej ramy, min, max, center, empty?. |
| 156 | `add(*rzeczy)` |  |
| 168 | `empty?` |  |
| 172 | `center` |  |
| 179 | `module Sketchup` |  |
| 181 | `module AtrapaRamy` | Rama zawartości (ściany, grupy, instancje) w układzie rodzica przez przekształcenie tr – do Group#bounds. |
| 184 | `rama(ents, tr)` |  |
| 199 | `class Atrybutowy` |  |
| 200 | `atrybuty` |  |
| 205 | `entityID` | Numer encji (jak Entity#entityID – stały dla obiektu w sesji). |
| 209 | `set_attribute(dict, key, value)` |  |
| 213 | `get_attribute(dict, key, domyslna = nil)` |  |
| 218 | `delete_attribute(dict, key = nil)` |  |
| 223 | `class Vertex` |  |
| 226 | `initialize(pt)` |  |
| 231 | `class Edge` |  |
| 235 | `initialize(a, b)` |  |
| 240 | `valid?` |  |
| 245 | `class Face` |  |
| 257 | `initialize(punkty, entities)` |  |
| 264 | `vertices` |  |
| 269 | `edges` | Krawędzie pętli zewnętrznej (jak Face#edges w SketchUpie – te same obiekty przy kolejnych wywołaniach). |
| 274 | `normal` | Normalna z punktów (metoda Newella). |
| 287 | `reverse!` |  |
| 292 | `erase!` |  |
| 297 | `valid?` |  |
| 301 | `classify_point(_pt)` |  |
| 306 | `class Entities` |  |
| 309 | `initialize(parent)` |  |
| 314 | `each(&blk)` |  |
| 318 | `to_a` |  |
| 322 | `length` |  |
| 326 | `grep(klasa)` |  |
| 330 | `add_group(*_args)` |  |
| 336 | `add_instance(defn, tr)` |  |
| 345 | `add_face(*pts)` | Ściana: jeśli w tej samej płaszczyźnie jest już ściana, która zawiera nową w całości – nowa jest „otworem”. |
| 354 | `add_line(a, b)` |  |
| 361 | `usun(e)` |  |
| 369 | `erase_entities(lista)` |  |
| 374 | `przywroc(lista)` | Atrapa: przywrócenie listy po abort_operation. |
| 379 | `class ComponentDefinition` |  |
| 383 | `initialize(name)` |  |
| 389 | `instances` |  |
| 393 | `count_instances` |  |
| 397 | `group?` |  |
| 402 | `class Group` |  |
| 406 | `initialize(rodzic)` |  |
| 415 | `parent` |  |
| 419 | `definition` |  |
| 424 | `bounds` | Rama w układzie rodzica (jak Group#bounds). |
| 428 | `erase!` |  |
| 434 | `valid?` |  |
| 441 | `module AtrapaBryly` | Bryła z ścian (atrapa Group/ComponentInstance#manifold? i #volume): każda krawędź pętli ścian (z otworami) użyta dokładnie dwa razy; objętość z twierdzenia o dywergencji (ściany skierowane na zewnątrz), cale³. |
| 444 | `sciany(ents)` |  |
| 448 | `klucz(p)` |  |
| 452 | `manifold?(ents)` |  |
| 462 | `wektor_pola(pts)` |  |
| 473 | `dlugosc(w)` |  |
| 477 | `volume(ents)` |  |
| 492 | `class ComponentInstance` |  |
| 496 | `manifold?` |  |
| 500 | `volume` |  |
| 504 | `initialize(defn, tr, rodzic)` |  |
| 512 | `erase!` |  |
| 517 | `valid?` |  |
| 522 | `class DefinitionList` |  |
| 523 | `initialize` |  |
| 527 | `add(name)` |  |
| 539 | `remove(d)` |  |
| 545 | `load(sciezka)` | Atrapa: wczytanie komponentu z pliku .skp – definicja o nazwie pliku (bez rozszerzenia); brak pliku – wyjątek jak w API. |
| 551 | `przywroc(lista)` | Atrapa: przywrócenie listy po abort_operation. |
| 559 | `to_a` |  |
| 563 | `each(&blk)` |  |
| 567 | `length` |  |
| 572 | `class Layer` |  |
| 575 | `initialize(name)` |  |
| 580 | `class Layers` |  |
| 581 | `initialize` |  |
| 585 | `add(nazwa)` |  |
| 593 | `length` |  |
| 598 | `class Selection` |  |
| 602 | `initialize` |  |
| 606 | `each(&blk)` |  |
| 610 | `length` |  |
| 614 | `to_a` |  |
| 618 | `clear` |  |
| 622 | `add(*e)` |  |
| 627 | `class Model` |  |
| 630 | `initialize` |  |
| 638 | `active_entities` |  |
| 643 | `start_operation(nazwa, *reszta)` | Operacja dołączona do poprzedniej (4. argument transparent = true) – zapis z :dolaczona. |
| 649 | `commit_operation` |  |
| 656 | `abort_operation` | Jak w SketchUpie: cofnięcie wszystkiego od start_operation (encje najwyższego poziomu i definicje). |
| 666 | `options` |  |
| 676 | `active_model` |  |
| 680 | `require(sciezka)` |  |
| 684 | `register_extension(_ext, _load)` |  |
| 688 | `version` |  |
| 692 | `is_pro?` |  |
| 696 | `os_language` |  |
| 702 | `class SketchupExtension` |  |
| 705 | `initialize(nazwa, sciezka)` |  |
| 711 | `TB_HIDDEN` |  |
| 712 | `TB_VISIBLE` |  |
| 713 | `TB_NEVER_SHOWN` |  |
| 715 | `module UI` |  |
| 722 | `messagebox(tekst, _typ = nil)` |  |
| 728 | `savepanel(_tytul, _katalog = nil, _nazwa = nil)` | Okno zapisu: test ustawia UI.plik_zapisu (nil – „Anuluj”). |
| 734 | `liczniki` | Liczniki: blok czeka w UI.liczniki, test uruchamia go przez UI.uruchom_liczniki (jak SketchUp po zakończeniu bieżącego wywołania); stop_timer zapisuje zatrzymane. |
| 738 | `zatrzymane` |  |
| 742 | `start_timer(_sekundy, _powtarzaj = false, &blk)` |  |
| 747 | `stop_timer(id)` |  |
| 752 | `uruchom_liczniki` |  |
| 759 | `menu(_nazwa)` |  |
| 765 | `menu_kontekstowe` | Menu pod prawym przyciskiem: bloki zapisane w UI.menu_kontekstowe; test woła UI.prawy_przycisk i dostaje Menu z pozycjami, które dodały. |
| 769 | `add_context_menu_handler(&blk)` |  |
| 774 | `prawy_przycisk` |  |
| 782 | `class Command` | Polecenie paska narzędzi (nazwa, blok, ikony, opisy); wywolaj – kliknięcie przycisku. |
| 786 | `initialize(nazwa, &blk)` |  |
| 791 | `wywolaj` |  |
| 797 | `class Toolbar` | Pasek narzędzi: Toolbar.ostatni_stan ustawia test (nil – pierwsze uruchomienie, TB_NEVER_SHOWN). |
| 803 | `initialize(nazwa)` |  |
| 810 | `add_item(polecenie)` |  |
| 815 | `get_last_state` |  |
| 819 | `show` |  |
| 823 | `restore` |  |
| 828 | `class Menu` |  |
| 831 | `initialize` |  |
| 835 | `add_submenu(_nazwa)` |  |
| 839 | `add_item(nazwa, &blk)` |  |
| 844 | `add_separator` |  |
| 849 | `class HtmlDialog` |  |
| 850 | `STYLE_DIALOG` |  |
| 853 | `initialize(opcje = {})` |  |
| 860 | `set_file(plik)` |  |
| 864 | `add_action_callback(nazwa, &blk)` |  |
| 868 | `execute_script(js)` |  |
| 872 | `show` |  |
| 876 | `close` |  |
| 880 | `visible?` |  |
| 885 | `wywolaj(nazwa, arg = '')` | Test: wywołanie jak z JavaScriptu. |
| 891 | `MB_YESNO` |  |
| 892 | `MB_YESNOCANCEL` |  |
| 893 | `IDCANCEL` |  |
| 894 | `IDYES` |  |
| 895 | `IDNO` |  |
| 899 | `file_loaded?(nazwa)` |  |
| 903 | `file_loaded(nazwa)` |  |

### testy/buduj_rbz.rb (28 wierszy)

paczka instalacyjna .rbz (zip rejestratora i folderu wtyczki) – do instalacji w Menedżerze rozszerzeń SketchUpa.

Zależy od: polecenie zip
Używają: zamknięcie rundy (docs/skille/gw-runda/SKILL.md)

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `KAT` |  |
| 17 | `PLUG` |  |

### testy/kolizje_belek.rb (211 wierszy)

wspólne sprawdzenia przestrzenne testów – kolizje belek dachu z balami (punkty próbne), bale ponad linią szczytu, bale i płatwie względem połaci dla aplikacji do dachów.

Zależy od: testy/pomoc.rb (rdzeń wtyczki)
Używają: testy/t_szczyty.rb, testy/t_losowe.rb, testy/t_polacie.rb

| Wiersz | Element | Opis |
|---:|---|---|
| 11 | `probki(a, b, n)` | Punkty próbne (n × n × n) w części wspólnej prostopadłościanów otaczających [min, max]. |
| 21 | `otoczka(pol, dl, b, h)` | Prostopadłościan otaczający bryły o położeniu pol i wymiarach dl × b × h. |
| 28 | `lokalnie(pol, q)` | Punkt w układzie lokalnym (rzut na osie położenia). |
| 35 | `kolizje_belek(pl, prefiks, n = 7)` | Liczba punktów wspólnych belek (prefiks; belka z obróbkami – bryła z jej profilu, np. słup z zamkami) i bali (z marginesem 0,5 mm) – 0 = bez kolizji. |
| 64 | `w_wrebie?(e, le)` | Czy punkt lokalny belki le leży poza przekrojem jej wrębu (zamek płatwi) – w wrębie belka jest węższa i wyżej od spodu. |
| 73 | `w_wielokacie?(pts, y, z, m)` | Czy punkt [y, z] leży wewnątrz wielokąta (z marginesem m od krawędzi). |
| 93 | `w_belce?(e, q, m = 0.5)` | Czy punkt q (układ domu) leży w belce e (przekrój, wręby zamka płatwi, obróbki) z marginesem m. |
| 110 | `kolizje_elementow(pl, a, b, n = 6, tag_a = nil)` | Liczba punktów wspólnych belek o prefiksach a i b (punkty próbne n × n × n we wspólnej części otoczek) – 0 = bez kolizji; tag_a – tylko belki a z tym tagiem (np. słupy zadaszenia). |
| 125 | `nad_linia(pl, id)` | Największe wystawanie bali ściany ponad linię szczytu [mm] (≤ 0 – wszystko pod linią). |
| 140 | `z_polaci(pol, x, y)` | Wysokość płaszczyzny połaci (plan[:polacie] – dla aplikacji do dachów) nad punktem [x, y] układu domu, liczona niezależnie od rdzenia: wysokość obrysu + tg kąta × odległość w głąb od najbliższej krawędzi okapowej (obrys przeciwnie do wskazówek zegara – wnętrze po lewej stronie krawędzi). Obrys L (dwa dachy z koszem) – z_polaci_l. |
| 164 | `z_polaci_l(pol, x, y)` | Połać domu L: krawędzie okapowe w dwóch kierunkach = dwa dachy dwuspadowe. Dach główny ma trzy krawędzie okapowe (z krótkim uskokiem na ścianie ze szczytem na części długości) i sięga wszędzie; dach skrzydła bocznego (dwie krawędzie) liczy się tylko po swojej stronie kalenicy dachu głównego – tam dach domu to wyższa z dwóch płaszczyzn. |
| 185 | `wzgledem_polaci(pl)` | Bale i płatwie względem połaci: { bale: największe wystawanie wierzchu bali ponad połać, platwie: największe wystawanie płatwi, dotyk: najmniejsze z „najwyższy punkt płatwi − połać” (0 – każda płatew podpiera krokwie), krokwie: liczba krokwi generatora } [mm]; nil – plan bez połaci. |

### testy/lista_parametrow.rb (74 wierszy)

generator docs/parametry.md – wszystkie parametry okna (sekcja, etykieta, poziom, wartość domyślna, zakres, wybory, podpowiedź) i typy wbudowane.

Zależy od: Plugins/arte_madera_generator_wiencowy/rdzen/parametry_lista.rb
Używają: testy/uruchom.sh (sprawdzenie aktualności)

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `KAT` |  |
| 17 | `WYNIK` |  |
| 20 | `fmt(v)` | Liczba bez zbędnego ,0 (przecinek dziesiętny). |
| 27 | `kom(t)` | Komórka tabeli bez znaków psujących Markdown. |
| 32 | `tresc` | Treść dokumentu. |

### testy/losowe_domy.rb (497 wierszy)

losowe domy do testów – obrys (prostokąt, L), działowe, węgły, otwory i parametry z ziarna; sprawdzenie jednego domu.

Zależy od: testy/pomoc.rb, testy/kolizje_belek.rb
Używają: testy/t_losowe.rb, ręcznie (ruby -I testy/atrapa testy/losowe_domy.rb [liczba] [ziarno])

| Wiersz | Element | Opis |
|---:|---|---|
| 17 | `module LosoweDomy` |  |
| 20 | `MIN_KRAWEDZ` | Najkrótsza dopuszczalna krawędź bryły [mm] – zapas ponad tolerancję SketchUpa (0,0254 mm). |
| 22 | `ZIARNA_Z_TARASEM` | Ziarna od tego numeru dostają losowy taras (runda 5). |
| 24 | `ZIARNA_R7` | Ziarna od tego numeru dostają losowe nowości rundy 7 (podbitka, zamki płatwi, styki w zamku działowej, fundamenty…). |
| 26 | `ZIARNA_R8` | Ziarna od tego numeru dostają losowe nowości rundy 8 (wypusty pod okapem, węgły niesymetryczne, podłoga, taras…). |
| 28 | `ZIARNA_R9` | Ziarna od tego numeru dostają losowe nowości rundy 9 (węgły pod płatwiami i na wolnym końcu, wiązar nad tarasem). |
| 30 | `ZIARNA_R10` | Od tego ziarna – nowości rundy 10 (wiązar pod płatwiami, zastrzały pod kątem, poziom podciągu). |
| 33 | `ZIARNA_R11` | Od tego ziarna – nowości rundy 11 (słupki tylko pod kalenicową, węgieł w osi płatwi, przekroje wiązara, zamek płatwi nad tarasem tylko od spodu, front tarasu łączony na styk, słup w osi kalenicy). |
| 35 | `ZIARNA_R12` | Od tego ziarna – nowości rundy 12 (boczne zadaszenie: wiata na słupach albo przybudówka z bali). |
| 37 | `ZIARNA_R13` | Od tego ziarna – nowości rundy 13 (dobór przekrojów zadaszenia i krokwi, podłoga w przybudówce do wyboru). |
| 39 | `ZIARNA_R15` | Od tego ziarna – nowości rundy 15 (wieńce szczytu łączone na styk albo w zamkach węgłów, słupy krótsze o osiadanie). |
| 41 | `ZIARNA_R18` | Od tego ziarna dom dostaje kanały na przewody (runda 18, N3). |
| 46 | `wybierz(r, lista)` | Losowy wybór z listy. |
| 51 | `dom(ziarno)` | Dom z ziarna: { ziarno:, opis:, segmenty:, parametry:, otwory: }. |
| 110 | `dodatki(r, p, dl_w1, opis)` | Dodatki rundy 4 (osobne losowanie): pełny profil, strop, ostatek 200 na końcu ściany, działowa pod antresolą, węgły ręczne na W-1; zwraca ustawienia ścian (parametry uzupełnia w p, opis w opis). |
| 140 | `dodatki_r5(r, p, opis)` | Dodatki rundy 5 (osobne losowanie – domy z ziaren rund 1–4 bez zmian): krokwie z aplikacji do dachów (połacie), luzy stolarki (boczny, osiadanie ścian – luz górny z podpowiedzi), dach jednospadowy. |
| 159 | `taras(r, p, opis)` | Taras (osobne losowanie, tylko ziarna od ZIARNA_Z_TARASEM – domy z ziaren wcześniejszych rund bez zmian): wariant 1100 albo 1200, strona, głębokość, podciąg, wejście, balustrada, słupy. |
| 175 | `dodatki_r7(r, p, opis)` | Dodatki rundy 7 (osobne losowanie, ziarna od ZIARNA_R7): podbitka w czterech położeniach, zamki płatwi, płatwie na pełnym balu, styki w zamku działowej, węgieł na środku, działowa do dachu, podwalina 50 × 150 na śruby, fundamenty, szczyt nad tarasem. |
| 194 | `dodatki_r8(r, p, opis)` | Dodatki rundy 8 (osobne losowanie, ziarna od ZIARNA_R8): wypuszczone górne wieńce okapowe, węgły pod okapem do nawisu, węgły niesymetryczne, podciąg na równo, fundament okrągły, balustrada z wieńców ścian, trójkątny wieniec. |
| 213 | `dodatki_r9(r, p, opis)` | Dodatki rundy 9 (osobne losowanie, ziarna od ZIARNA_R9): węgły pod płatwiami, węgieł na wolnym końcu, wiązar nad tarasem (rodzaj, na balach albo na słupach, słupek, zastrzał); szczyt pusty częściej. |
| 228 | `dodatki_r10(r, p, opis)` | Dodatki rundy 10: wiązar pod płatwiami (głębokość gniazda, kąt zastrzałów), poziom podciągu; domy L mają dwa dachy z koszem przy każdym ziarnie (rdzen/skrzydla.rb). |
| 240 | `dodatki_r11(r, p, opis)` | kalenicowej), słupek i zastrzały wiązara z przekroju wiązara, zamek płatwi nad tarasem tylko od spodu, front tarasu łączony na styk albo na węgłach, słup frontu w osi kalenicy, automatyczny dobór przekroju płatwi i trójkąta nad tarasem (śnieg z kilku stref). |
| 260 | `dodatki_r12(r, p, opis)` | Dodatki rundy 12: boczne zadaszenie (słupy albo przybudówka, strona, szerokość, kąt mniejszy niż dachu – czasem nie, okap, przekroje, rozstaw słupów); dom z tarasem, jednospadowy albo L – zadaszenie pominięte z ostrzeżeniem. |
| 280 | `dodatki_r13(r, p, opis)` | Dodatki rundy 13: dobór przekrojów zadaszenia (automatycznie / z wyboru), dobór krokwi, podłoga w przybudówce. |
| 289 | `dodatki_r15(r, p, opis)` | Dodatki rundy 15: łączenie wieńców szczytu (na styk – fabrycznie – albo w zamkach węgłów, jak do kompilacji 14), słupy krótsze o osiadanie ścian (śruba / podkładki / wyłączone) przy różnym osiadaniu, pół zamka w ostatnim połączeniu. |
| 300 | `kanaly_r18(r, dlugosci, opis)` | Kanały na przewody rundy 18 (osobne losowanie): w co trzecim domu 1–3 kanały na ścianach zewnętrznych W-1…W-4 (część z puszką; te przy zamku albo poza ścianą generator pomija z ostrzeżeniem). |
| 314 | `parametry(r)` | Losowe parametry (wartości tekstowe jak z okna); krokwie z generatora (aplikacja – w dodatkach rundy 5). |
| 332 | `otwory(r, dlugosci)` | Losowe otwory na ścianach W-1…W-4 (długości lica ścian w kolejności numeracji). |
| 346 | `sprawdz(dom, belki = true)` | Sprawdzenie domu: lista problemów (pusta – w porządku) i plan. |
| 405 | `bez_zamka_w_narozniku(pl)` | Bale ścięte dachem, które zachodzą na słup zamka narożnika bez gniazda w jego osi (ostatek bez oparcia) – opisy; bal wyższy półzamka (rdzen/pol_zamka.rb) nie ma gniazda z założenia – leży w gnieździe bala pod nim. |
| 420 | `na_balu_polzamka?(b, k, t, p)` | Czy bal b leży w narożniku k tylko na balu półzamka ściany poprzecznej, który go nie sięga (górny bal ściany ścięty płaszczyzną dachu kończy się pod spodem bala b – gniazda między nimi nie ma z założenia, rdzen/zamek.rb). |
| 429 | `problemy_polaci(pl)` | Połacie dla aplikacji do dachów: bale i płatwie pod połacią, każda płatew ją podpiera, bez krokwi generatora; podpory (płatwie, ściana wysoka) w granicy aplikacji (wierzch w osi pod połacią o ≤ b/2·sin α + 30 mm po normalnej). |
| 444 | `podpory_poza(pl)` | Podpory, których aplikacja do dachów nie uzna (za wysoko, za nisko albo nie równolegle do okapu) – opisy. |
| 457 | `siatka(poz)` | Siatka pozycji: { ok: zamknięta i z objętością profilu, min_krawedz: najkrótsza krawędź ścian [mm] }. |
| 465 | `min_krawedz(sciany)` | Najkrótsza krawędź pętli ścian siatki [mm] (SketchUp scala punkty bliższe niż 0,0254 mm). |

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

### testy/podglad.rb (116 wierszy)

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

### testy/ruby27.sh (36 wierszy)

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

### testy/sprawdz_dach_aplikacja.rb (316 wierszy)

dom z bali z prawdziwą aplikacją do dachów (na jej atrapie SketchUpa) przez jej API – połacie na płaszczyźnie wierzchu płatwi, płatwie domu jako podpory, KROK 2 w górę od połaci: krokwie na płatwiach i nad szczytami, przęsła między płatwiami w kontroli nośności; same płatwie – deski na płatwiach wzdłuż spadku, styki na płatwiach; dom odbity.

Zależy od: aplikacja do dachów 3.7.0+ (katalog obok repozytorium albo AM_GW_APLIKACJA_DACHOW, jej tests/support), testy/pomoc.rb, testy/kolizje_belek.rb, sketchup/dach_aplikacja.rb, sketchup/konwersja.rb, sketchup/atrybuty.rb
Używają: testy/uruchom.sh (gdy aplikacja do dachów jest obok), ręcznie

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `KATALOG_DACHOW` |  |
| 28 | `ROOF` |  |
| 31 | `dom_w_modelu(model, pl, z0, odbity = false)` | Grupa domu w modelu atrapy (bez bali – tylko położenie i id, jak po Budowa.zbuduj); odbity – lustro (oś y odwrócona). |
| 44 | `punkty_lokalnie(grupa, dom)` | Punkty ścian grupy (z jej elementami) w mm układu domu. |
| 53 | `odchylki(punkty, pol)` | Odchyłki punktów od połaci [mm]: [najniżej pod, najwyżej nad]. |
| 59 | `czesci(wiezba, rodzaj)` | Elementy więźby danego rodzaju (ArteMaderaTimber.kind). |
| 64 | `os_kalenicy(pol)` | Oś kalenicy połaci w układzie domu: 0 – x, 1 – y (krawędź szczytowa ma stałe drugie z nich). |
| 71 | `platwie_w_poprzek(pl, iv)` | Zakresy płatwi w poprzek kalenicy (mm układu domu): [[od, do]]. |
| 79 | `PRZYPADKI` | [nazwa, linie, parametry, poziom linii z0, liczba połaci, dom odbity] |
| 198 | `L_OBRYS` | Dom L (runda 10 – dwa dachy z koszem): jeden obrys z uskokiem na ścianie ze szczytem na części długości → aplikacja robi pięć połaci (dwie dachu głównego, w tym tylna z dwóch części, i dwie skrzydła bocznego) z koszami. |

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

### testy/t_dach_aplikacja.rb (244 wierszy)

dach z aplikacji do dachów w modelu (atrapa SketchUpa i API aplikacji) – połacie po budowie domu, podpory z płatwi, ustawienia KROKU 2, okno KROKU 2 z licznika, więźba po OK powiązana z domem, przebudowa (poprzednie połacie i więźba), same płatwie, brak i stara aplikacja, odmowa aplikacji, inny kontekst, dom obrócony.

Zależy od: testy/atrapa/sketchup.rb, testy/atrapa/aplikacja_dachow.rb, testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 24 | `CAL` |  |
| 26 | `model_z_liniami(odcinki, z0 = 0.0)` |  |
| 36 | `ostatni_wynik(dlg)` |  |
| 42 | `generuj(parametry)` | Nowy dom z linii (albo edycja zaznaczonego domu) i generowanie z parametrami; wynik okna. |
| 50 | `polacie(m)` |  |
| 55 | `wiezba(m, x0, y0, x1, y1, z)` | Grupa „Wiezba dachowa” (jak z KROKU 2) z jedną ścianą nad prostokątem x0…x1 × y0…y1 [mm] na wysokości z [mm]. |

### testy/t_dlugosci.rb (125 wierszy)

testy wykazu drewna z hurtowni i długości handlowych – odczyt list „przekrój:długości”, listy fabryczne, podpowiedź o belce dłuższej niż w hurtowni, dobór przekroju dostępnego w całej długości.

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `dom(w, d, parametry = {})` | Plan domu prostokątnego w × d [mm] z parametrami. |
| 21 | `dlugie(pl)` | Podpowiedzi o długościach handlowych z planu. |

### testy/t_jednospadowy.rb (166 wierszy)

dach jednospadowy – ściana niska i wysoka, szczyty skośne do linii dachu, ściana wysoka do połaci (górny bal przycięty, cienki pasek pominięty), płatwie bez kalenicowej, krokwie w jednym kawałku, połać dla aplikacji (trzy krawędzie szczytowe), widok ściany, obrys L.

Zależy od: testy/pomoc.rb, testy/kolizje_belek.rb, Plugins/.../rdzen/dach_jednospadowy.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `JEDNO` |  |
| 17 | `czysto(pl, opis)` |  |
| 23 | `gora_bali(w)` | Najwyższy wierzch bali ściany po przycięciu [mm]. |

### testy/t_kanaly.rb (82 wierszy)

kanały na przewody (N3, runda 18) – przypisanie do ścian, pominięcie przy zamku, otwór pionowy w każdym balu ściany (bryła zamknięta z otworem, objętość), puszka na liście obróbek, kanał w widoku ściany, w pełnym profilu i w szczycie, zapis w domu (SketchUp na atrapie).

Zależy od: testy/losowe_domy.rb (sprawdzenie całego domu), testy/atrapa/sketchup.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 21 | `SEG` |  |
| 22 | `KAN` |  |

### testy/t_losowe.rb (69 wierszy)

stały zestaw losowych domów (ziarna, które kiedyś ujawniły błąd, i kilka zwykłych) – każdy bez problemów.

Zależy od: testy/losowe_domy.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `ZIARNA` | Ziarno => co ujawniło (runda 3, runda 4 – r4, runda 5 – r5). |

### testy/t_materialy.rb (123 wierszy)

testy zestawienia materiałów (propozycja W2, runda 15) – powierzchnia dachu, deski nadbitki / deskowania / OSB w m² i sztukach, podbitka, taśma między wieńcami, okucia (śruby i podstawy słupów, kotwy podwalin, łączniki krokwi), impregnacja, blok w pliku CSV.

Zależy od: testy/pomoc.rb, Plugins/.../rdzen/materialy.rb, rdzen/zestawienie.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `DOM` |  |
| 19 | `mat(pl, nazwa, jednostka = nil)` | Wiersz materiałów o nazwie zaczynającej się od tekstu i jednostce. |

### testy/t_okno.js (550 wierszy)

okno parametrów w Chromium (Playwright), układ dotychczasowy (zakładki) – sekcje i pola z listy, podpowiedzi, typy domów, rzut, tabela otworów, wywołania sketchup.*, wyniki.

Zależy od: testy/okno_dane.rb, Plugins/.../html/okno.html
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `KAT` |  |
| 20 | `HTML` |  |
| 23 | `sprawdz(w, opis)` |  |

### testy/t_okno_kroki.js (410 wierszy)

okno w Chromium (Playwright), układ nowy – kroki w kolejności budowy, prawa kolumna z rzutem i listą „Do poprawy / Sprawdzone”, pola według poziomów (ten dom, typ, standard), zmiana tylko w tym domu, panel standardu warsztatu, podpowiedź po wejściu w pole, opcje wyszarzone dla obrysu, przełącznik układu, dom z wymiarów.

Zależy od: testy/okno_dane.rb, Plugins/.../html/okno.html
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `KAT` |  |
| 20 | `HTML` |  |
| 23 | `sprawdz(w, opis)` |  |

### testy/t_osiadanie.rb (76 wierszy)

testy słupów krótszych o osiadanie ścian (propozycja P1, runda 15) – luz osiadania, śruba regulacyjna albo podkładki, zamek górny po osiadaniu, wyłączenie, podpowiedź, brak kolizji.

Zależy od: testy/pomoc.rb, testy/losowe_domy.rb, Plugins/.../rdzen/osiadanie.rb, rdzen/taras_slupy.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `TARAS` | Dom 6000 × 4000 z tarasem na słupach (typ 200). |
| 19 | `slupy_tarasu(pl)` | Słupy tarasu z planu. |
| 24 | `wierzch_pelny(e)` | Wierzch pełnego przekroju słupa [mm nad poziomem 0]: początek wycięcia zamka górnego albo koniec słupa. |

### testy/t_podbitka.rb (145 wierszy)

podbitka w czterech położeniach – pod / na płatwiach, pod / na krokwiach: deski przy właściwej płaszczyźnie, bez kolizji z balami, krokwie uniesione nad deskami na płatwiach, podbitka jako nadbitka KROKU 2 aplikacji do dachów, wybór niepasujący do układu dachu.

Zależy od: testy/pomoc.rb, testy/kolizje_belek.rb, Plugins/.../rdzen/podbitka.rb, Plugins/.../rdzen/krok2.rb
Używają: testy/uruchom.sh, testy/ruby27.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `DOM` |  |
| 17 | `sciany_deski(e)` | Narożniki ściany spodniej (lokalne z = 0) i wierzchniej (z = h) elementu – [spód, wierzch] w świecie. |
| 25 | `odchylka(pl, strona, dz)` | Największa odchyłka ściany deski (:spod albo :wierzch) od linii podparcia przesuniętej o dz [mm]. |
| 37 | `deski(pl)` | Deski podbitki planu. |

### testy/t_podloga.rb (206 wierszy)

testy podłogi i statyki – wzory belki, dobór przekroju (minimalny / zalecany / ręczny), izolacja, podpory, układ podwalin i legarów.

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `plan_pelny_auto(segmenty, parametry = {}, otwory = [])` | Runda 17: dobór legara fabrycznie „jak przełącznik Przekroje konstrukcji” (podaję sam); testy podłogi sprawdzają dobór automatyczny (zalecany), jak fabrycznie do kompilacji 16 – chyba że test podaje inny. |
| 23 | `kolizje_elementow(pl, prefiksy)` | Elementy planu o prefiksie. Liczba par elementów (prefiksy z listy) zachodzących na siebie – prostopadłościany otaczające, zapas 0,5 mm (belki podłogi są równoległe do osi; podwaliny między sobą pominięte). |
| 31 | `el(pl, prefiks)` |  |
| 36 | `podp?(pl, poziom, tekst)` | Czy jest podpowiedź danego poziomu zawierająca tekst. |
| 40 | `P0` |  |

### testy/t_pol_zamka.rb (145 wierszy)

testy pół zamka w ostatnim połączeniu pod dachem (rundy 15–16: narożnik, góra węgła, ściana nad węgłem i nad działową, węgieł ze stykami do połaci) – bal szczytu przechodzi przez narożnik bez gniazda od spodu, bal pod nim ma gniazdo do połowy wysokości; wyłączone – bal ucięty przy ścianie poprzecznej; inna głębokość gniazda; brak kolizji.

Zależy od: testy/pomoc.rb, testy/losowe_domy.rb, Plugins/.../rdzen/pol_zamka.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `plan_ziarna(z, dodatki)` | Plan domu z ziarna z dodatkowymi parametrami. |
| 24 | `gniazda(b, c)` | Gniazda bala w osi c: { 'gniazdo_gora' => głębokość, 'gniazdo_dol' => głębokość }. |
| 29 | `cienkie(pl)` | Liczba gniazd od spodu, nad którymi pod skosem albo ścięciem dachu zostaje mniej niż zamek_min_drewno. |
| 39 | `miejsca(pl)` | Miejsca półzamków w planie: pz_naroznik, pz_t, pz_x, pz_gora_wegla (bal węgła), pz_sciana_nad_weglem. |

### testy/t_polacie.rb (209 wierszy)

połacie dla aplikacji do dachów – obrys, wysokość, krawędzie szczytowe, okap i wysunięcie za szczyt; płatwie pod połacią, szczyt pod krokwiami, bez krokwi generatora; same płatwie (poszycie na płatwiach); ustawienia KROKU 2 i podpory z płatwi; kiedy połaci nie ma.

Zależy od: testy/pomoc.rb, testy/kolizje_belek.rb, Plugins/.../rdzen/polacie.rb, Plugins/.../rdzen/krok2.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `pole_ze_znakiem(pts)` | Pole wielokąta ze znakiem. |
| 22 | `obrys_dachu(pol)` | Obrys połaci po odsunięciu okapu (jak aplikacja: każda krawędź o okap na zewnątrz) – [x_min, x_max, y_min, y_max]. |
| 29 | `zakres_platwi(pl, os)` | Zakres płatwi wzdłuż osi (0 – x, 1 – y): [min, max] końców wszystkich płatwi. |
| 123 | `pod_polacia(pol, q)` | Odległość wierzchu podpory od połaci w pionie [mm] na obu końcach (dodatnia – pod połacią). |

### testy/t_poziomy.rb (94 wierszy)

testy trzech poziomów ustawień i kroków okna (runda 16) – poziom przy każdym polu, podział jak w docs/podzial_pol_r16.md, kroki w kolejności budowy, złożenie parametrów ze standardu i typu, pola zmienione tylko w tym domu, lista uwag z miejscem w oknie, powierzchnie i limity, dom z wymiarów.

Zależy od: testy/pomoc.rb, Plugins/.../rdzen/poziomy.rb, rdzen/uwagi_pola.rb, rdzen/powierzchnie.rb, rdzen/dom_z_wymiarow.rb
Używają: testy/uruchom.sh

### testy/t_raport.rb (108 wierszy)

test działania z menu (atrapa SketchUpa) – przykładowe domy bez błędów, budowa cofnięta (model bez zmian), bryły zamknięte i objętości, zaznaczony dom, raport JSON.

Zależy od: testy/atrapa/sketchup.rb, testy/pomoc.rb, Plugins/.../sketchup/raport.rb, rdzen/przyklady.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 19 | `CAL` |  |

### testy/t_rdzen.rb (241 wierszy)

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

### testy/t_siatka.rb (133 wierszy)

siatka brył wszystkich pozycji z kilku domów – zamknięta (każda krawędź raz w każdą stronę), objętość równa profilowi.

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 13 | `sprawdz_pozycje(pl, opis)` |  |

### testy/t_sketchup.rb (469 wierszy)

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

### testy/t_skrzydla.rb (188 wierszy)

dom w kształcie L – dwa dachy dwuspadowe z koszem (runda 10): podział na skrzydła, oś kalenicy, szczyty (także na części ściany), ściany okapowe skrzydła bocznego, płatwie obu dachów, połacie dla aplikacji do dachów, węgły ścięte do dachu, wypust górnych wieńców tylko na zewnątrz.

Zależy od: testy/pomoc.rb, testy/kolizje_belek.rb, testy/losowe_domy.rb (sprawdzenie całego domu), rdzen/skrzydla.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `L1` |  |
| 18 | `bez_problemow(seg, par, opis)` | Cały dom bez problemów (zamki, bryły, kolizje belek, bale i płatwie pod połaciami, podpory dla aplikacji do dachów). |
| 155 | `LK` |  |

### testy/t_statyka_dachu.rb (128 wierszy)

testy sprawdzenia płatwi i trójkąta nad tarasem (śnieg, pas dachu, przęsła), automatycznego doboru ich przekroju i trójkąta w wąskim domu.

Zależy od: testy/pomoc.rb, testy/losowe_domy.rb (sprawdzenie domu)
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `podpowiedzi(pl, slowo)` | Podpowiedzi planu zaczynające się od słowa (Płatwie / Płatew / Trójkąt): [[poziom, tekst]]. |
| 20 | `belki(pl, prefiks)` | Elementy planu o prefiksie. |
| 24 | `BAZA` |  |

### testy/t_statyka_zadaszenia.rb (168 wierszy)

runda 13 – dobór przekrojów bocznego zadaszenia (płatwie z oczepem, belki poprzeczne, słupy – automatycznie albo z wyboru), słup z wyboczeniem, dobór krokwi całego dachu, podłoga w przybudówce do wyboru, parametry zadaszenia w osobnej zakładce okna.

Zależy od: testy/pomoc.rb, testy/losowe_domy.rb (sprawdzenie domu), testy/atrapa/sketchup.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 17 | `plan(seg, par)` | Plan domu z parametrami (pełny przebieg z doborem). |
| 22 | `podp(pl, sekcja)` | Podpowiedzi sekcji okna. |
| 28 | `liczba_po(tekst, slowo)` | Liczba po słowie (np. „przęsło 2.0 m”) z tekstu podpowiedzi. |
| 34 | `zakres(e, k)` | Zakres elementu w osi k (wszystkie naroża prostopadłościanu) [min, max]. |
| 41 | `DOM` |  |
| 42 | `WIATA` |  |

### testy/t_stolarka.rb (208 wierszy)

lista typowej stolarki (pole-tabela standardu), dawne pola nowego okna i drzwi, modele okien i drzwi wstawiane w otwory (rdzeń i atrapa SketchUpa), działowe w domu z wymiarów (runda 17).

Zależy od: testy/atrapa/sketchup.rb, testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 157 | `select_directory(o = {})` |  |
| 162 | `openpanel(*a)` |  |
| 167 | `ostatnie` |  |

### testy/t_styki_szczytu.rb (140 wierszy)

testy łączenia wieńców szczytu na styk (decyzja T8, runda 15) – styki bez węgła na przemian o mijankę, węgły pod styki do wysokości ściany, szeroki szczyt, okno w szczycie, wybór „w zamkach węgłów”, szczyt płaski bez zmian, ziarna regresji.

Zależy od: testy/pomoc.rb, testy/losowe_domy.rb, Plugins/.../rdzen/styki_szczytu.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `DACH` | Dach z krokwiami z generatora, bez węgłów pod płatwiami – szczyt bez gniazd co kilkadziesiąt centymetrów. |
| 19 | `styki_wienca(w, i)` | Styki (koniec s1 bala zakończonego stykiem) w wieńcu o indeksie i ściany w. |
| 24 | `wience_szczytu(w, p)` | Indeksy wieńców szczytu ściany w (spód na górze ściany bez szczytu albo wyżej). |
| 29 | `wegly_stykow(pl, w)` | Węgły pod styki na ścianie w. |

### testy/t_szczyty.rb (276 wierszy)

testy szczytów i dachu – wieńce do kalenicy, skos bali pod linią dachu, gniazda płatwi, krokwie przy szczycie, belki dachu bez kolizji.

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `czysto(pl, opis)` |  |
| 139 | `pod_platwia_drewno?(pl, w)` | Drewno tuż pod spodem płatwi w środku każdego gniazda ściany – bal ściany albo węgła pod płatwią (runda 9) w tym punkcie. |

### testy/t_taras.rb (350 wierszy)

taras – obrys przedłużony o głębokość, ściana domu ze szczytem, wariant 1100 (podciąg z górnych wieńców, słupy, wejście, balustrada z przekładkami) i 1200 (ściany boczne pełne, front bez bali), dach nad tarasem, strona tarasu, kiedy tarasu nie ma.

Zależy od: testy/pomoc.rb, testy/kolizje_belek.rb, testy/losowe_domy.rb (sprawdzenie domu), Plugins/.../rdzen/taras.rb, rdzen/taras_balustrada.rb, rdzen/taras_slupy.rb, rdzen/taras_szczyt.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `caly(seg, par, opis)` | Sprawdzenie całego domu (bryły, zamki, mijanka, kolizje belek, połacie) jak w teście losowym. |
| 21 | `role(pl, rola)` |  |
| 25 | `slupy(pl)` |  |
| 30 | `srodek(e)` | Środek słupa w rzucie [x, y]. |

### testy/t_typy.rb (125 wierszy)

testy typów domów i standardu warsztatu w pliku ustawień (runda 16) – typy wbudowane i własne (zapis, zmiana, powielenie, usunięcie, wybrany typ), standard (tylko pola standardu inne niż fabryczne), nowy dom z typu i standardu, pliki ustawień starszych kompilacji (ostatnie parametry → standard i typ, szablony → typy, kopia starego pliku).

Zależy od: testy/pomoc.rb, testy/atrapa/sketchup.rb, Plugins/.../sketchup/ustawienia.rb, sketchup/typy_domow.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 24 | `plik_ustawien(dane)` | Zapis pliku ustawień o podanej zawartości (jak z wcześniejszej kompilacji). |

### testy/t_wegly.rb (267 wierszy)

testy węgłów usztywniających i łączenia na przemian – limity światła, rozmieszczenie, ściany wysokie, otwory.

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 14 | `wegly(pl, id, zrodlo)` | Węgły ściany według źródła: osie s (zaokrąglone) węgłów danego źródła na ścianie id. |
| 19 | `czysto(pl, opis)` | Kontrola bez kolizji, bez naruszeń mijanki i bez za długich bali. |
| 25 | `max_swiatlo(pl, id)` | Największe światło ściany (między licami podparć) [mm]. |
| 223 | `luka_pod_platwia(kf)` | Luka między spodem płatwi a wierzchem górnego bala węgła pod nią [mm] (bal ścięty pod płatew – od dna wycięcia). |
| 229 | `pod_platwiami_w2(szer, par)` | Węgły pod płatwiami na ścianie szczytowej W-2 domu szer × 7000 (kalenica wzdłuż x). |

### testy/t_widok.rb (76 wierszy)

widok ściany do okna – obrysy bali zgodne z profilem, gniazda zamków na skrzyżowaniach, styki, linia dachu, lista ścian.

Zależy od: testy/pomoc.rb, Plugins/.../rdzen/widok.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 15 | `pole(pts)` | Pole wielokąta [[s, z]] (wzór Gaussa). |
| 22 | `pole_profilu(b, t)` | Pole boku bala z profilu (rzut na płaszczyznę ściany). |

### testy/t_wycena.rb (84 wierszy)

magazyn drewna (tabela fabryczna, znaczniki zastosowań, deska 14 × 115), jeden przełącznik doboru przekrojów z wyjątkami, dobór w całej długości krokwi i legarów, wycena materiału (W3) i jej blok w CSV (runda 17).

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

### testy/t_zadaszenie.rb (200 wierszy)

boczne zadaszenie (runda 12) – linia dachu z załamaniem, płatwie zadaszenia, słupy z belkami poprzecznymi i słupkami, przybudówka z bali (obrys, role ścian, niska ściana, szczyty z załamaniem), krokwie zadaszenia z generatora, połacie z załamaniem dla aplikacji do dachów, przeszkody (kąt, taras, jednospadowy), przekazanie załamania w modelu (atrapa).

Zależy od: testy/pomoc.rb, testy/losowe_domy.rb (sprawdzenie domu), testy/atrapa/sketchup.rb, testy/atrapa/aplikacja_dachow.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 24 | `TG30` |  |
| 25 | `TG12` |  |
| 27 | `el(pl, rodzaj)` |  |
| 32 | `zakres(e, k)` | Zakres elementu w osi k układu domu (wszystkie naroża prostopadłościanu) [min, max]. |
| 186 | `module Roof` |  |
| 187 | `module API` |  |
| 188 | `wersja_wtyczki` |  |

### testy/t_zamek.rb (95 wierszy)

zamek 44 × 146 zgodny z rysunkiem IMG-20250930-WA0005 – wymiary obróbek, luzy, labirynt (tylko poprawne ułożenie bez kolizji).

Zależy od: testy/pomoc.rb
Używają: testy/uruchom.sh

### testy/t_zestawienie.rb (51 wierszy)

zestawienie CSV (rdzeń) i zapis pliku z okna (atrapa SketchUpa) – kolumny, przecinek dziesiętny, sumy, BOM, anulowanie.

Zależy od: testy/pomoc.rb, testy/atrapa/sketchup.rb, Plugins/.../rdzen/zestawienie.rb, sketchup/eksport.rb
Używają: testy/uruchom.sh

### testy/t_zlozone.rb (129 wierszy)

testy domów o obrysach złożonych – działowa w linii ściany obrysu (dom L, T, U), linia przez wcięcie obrysu, ściany równoległe w tym samym miejscu, komunikat zamiast wyjątku, ziarna domów złożonych.

Zależy od: testy/zlozone_domy.rb, testy/losowe_domy.rb, testy/pomoc.rb
Używają: testy/uruchom.sh

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `plan_z(odcinki, parametry = {})` | Plan domu z odcinków i parametrów. |
| 21 | `ulozone(odcinki, n, odbicie)` | Odcinki obrócone o n ćwierćobrotów i odbite (odbicie = true) – to samo w ośmiu ułożeniach. |
| 31 | `W_LINII` |  |

### testy/uruchom.sh (93 wierszy)

wszystkie testy i kontrole jednym poleceniem – ostatnia linia „WSZYSTKIE ZESTAWY: FAILURES n”.

Zależy od: ruby, node (+ playwright i Chromium dla okna – bez nich test okna jest pomijany z ostrzeżeniem), aplikacja do dachów obok
Używają: start i zamknięcie rundy

### testy/zlozone_domy.rb (105 wierszy)

losowe domy o obrysach złożonych (L, T, U, Z, krzyż, H) z działowymi w liniach uskoków – obrys i działowe z ziarna, sprawdzenie jak w losowych domach.

Zależy od: testy/losowe_domy.rb (parametry, dodatki rund, sprawdzenie), testy/pomoc.rb
Używają: testy/t_zlozone.rb, ręcznie (ruby -I testy/atrapa testy/zlozone_domy.rb [liczba] [ziarno])

| Wiersz | Element | Opis |
|---:|---|---|
| 16 | `module ZlozoneDomy` |  |
| 18 | `WZORY` | Wzory pól (wiersze od dołu, kolumny od lewej): 1 – pole należy do domu. |
| 28 | `ZIARNA_OD` | Ziarna domów złożonych zaczynają się od tego numeru (niżej – domy z testy/losowe_domy.rb). |
| 33 | `ulozony(wzor, n, odbicie)` | Wzór obrócony o ćwierć obrotu n razy i odbity (odbicie = true) – wszystkie ułożenia kształtu. |
| 40 | `obrys(wzor, xs, ys)` | Wierzchołki obrysu (przeciwnie do wskazówek zegara) sumy pól wzoru na siatce xs × ys. |
| 65 | `dom(ziarno)` | Dom z ziarna: { ziarno:, opis:, segmenty:, parametry:, otwory:, sciany: }. |

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
