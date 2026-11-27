# Przekazanie po rundzie 17 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`) – `add_repo` (push); w sesji zwykle już
   sklonowane w `/home/claude/generator-konstrukcji-wie-cowych` (sprawdź `git rev-parse HEAD`, nie klonuj drugi raz).
   Użytkownik chce repozytorium prywatnego – przełącza sam w ustawieniach GitHuba (`docs/przekazanie_r14.md` §5).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md` (§5 kolejka, §6 pytania), ten plik, `docs/zadanie_r17.md` (§0 – odpowiedzi
   użytkownika z polecenia rundy 18, §1–3 – zakres), potem `docs/SPIS_TRESCI.md`.
3. Folder na dysku: `C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych` – `device_request_folder_access`
   (w rundzie 17 zgoda przyszła od razu). Najpierw `raporty\` (na starcie rund 15–17 folderu nie było – kompilacje 14–16 nie
   były uruchamiane). Kopia na dysk: paczka `repozytorium_rN.bundle` przez `device_commit_files`, w `device_bash` `git clone`
   paczki do katalogu roboczego i `cp -r` katalogów `Plugins`, `testy`, `docs` oraz plików (usuwanie na dysku wyłączone).
4. Aplikacja do dachów obok repozytorium (`add_repo` do odczytu → `/home/claude/aplikacja-do-konstrukcji-dach-w`, 3.12.0).
   Testy na kopii katalogu z `AM_GW_APLIKACJA_DACHOW=/home/claude/aplikacja-do-konstrukcji-dach-w
   PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers NODE_PATH=$(npm root -g) bash testy/uruchom.sh` – ok. 15 min na 2 rdzeniach.
5. Losowe domy: `ruby -I testy/atrapa testy/losowe_domy.rb 600 6001` (16 min), złożone: `ruby -I testy/atrapa
   testy/zlozone_domy.rb 300 10001` (5 min). Znane sprzed rundy w 6001–6600: 6110, 6269 (bal 0,04–0,15 mm nad połacią),
   6305, 6557 (krawędź bryły szczytu < 0,1 mm), 6311, 6410, 6430 (dwie działowe narysowane kilkadziesiąt mm od siebie),
   6444 (płatew a bale), 6495, 6528 (dom L z podbitką na płatwiach – podpory o grubość deski).
6. Odpowiedzi użytkownika w poleceniu rundy 17 były puste („…”) – jeśli w poleceniu rundy 18 też ich nie ma, zapytaj od razu
   (zrzut układów `docs/uklady_okna_r17.png`, rysunek `docs/styk_w_zamku_r17.png`).

## 1. Mapa plików (nowe i zmienione w rundzie 17)

| Temat | Plik |
|---|---|
| Standard warsztatu z menu i paska (okno samego standardu) | `sketchup/sterowanie.rb#standard`, `sketchup/menu.rb`, `sketchup/pasek.rb`, `ikony/standard.*`, `html/standard.js#samodzielnie`, `html/kroki.css` (`body.tylko-standard`) |
| Węgieł do spodu płatwi w gnieździe ściany | `rdzen/bale.rb#bez_platwi_nad` (wołane z `#kontrfor_obecny?`) |
| Działowa przy ścianie okapowej ze stykiem ponad podbitkę pod płatwiami | `rdzen/podbitka.rb#dzialowa_do_polaci!`, `#linia_dzialowej`, `#dzialowe_do_polaci`; `rdzen/pod_dachem.rb#linia`, `#przygotuj` |
| Pola-tabele parametrów (kolumny, wiersze, JSON z okna, dawne pola okna i drzwi) | `rdzen/parametry_tabela.rb` (nowy), `rdzen/parametry.rb#sprawdz`, `#przenies_dawne`; `html/tabela.js` (nowy) |
| Lista typowej stolarki, folder modeli | `rdzen/parametry_lista.rb` (`stolarka`, `stolarka_folder`) |
| Modele okien i drzwi w otworach | `rdzen/stolarka_modele.rb` (nowy – wiersz, plik, położenie), `sketchup/stolarka_modele.rb` (nowy – `StolarkaModeleSU.wstaw`), `sketchup/budowa.rb` (tag Stolarka) |
| Typ i wiersz otworu w planie i widoku | `rdzen/otwory.rb#przypisz` (`nr`, `typ`), `rdzen/widok.rb` (`ref`, otwór `[…, nr, typ]`) |
| Okienko przy kliknięciu w widok ściany | `html/klik_sciana.js` (nowy), `html/sciana.js#klikanie` (s, h, zdarzenie), `html/okno.js#widok` |
| Tabela otworów z typem i „+ dodaj z listy” | `html/otwory.js` (`lista`, `dodajZListy`, `dodajTyp`, `wiersz`, `ustaw`, `usun`) |
| Działowe domu z wymiarów | `rdzen/dom_z_wymiarow.rb#osie_dzialowych`, `html/dzialowe.js` (nowy), `sketchup/sterowanie.rb#scal` (`dzialowe`) |
| Magazyn drewna, przełącznik doboru, dawne listy | `rdzen/magazyn_drewna.rb` (nowy), `rdzen/parametry_materialy.rb` (sekcja `magazyn`), `rdzen/parametry.rb#katalog`, `#dlugosci_katalogu`, `#dobor` |
| Pola doboru „jak przełącznik” | `wspolny:` w `rdzen/parametry_dach.rb`, `_podloga.rb`, `_zadaszenie.rb`; `html/zalezne.js#wartosc`; `html/okno.js#dodajPole` |
| Podpowiedzi przekrojów z magazynu przy polach | cecha `magazyn:` pól przekrojów, `html/okno.js#listyMagazynu` |
| Dobór w całej długości | `rdzen/dlugosci_handlowe.rb#w_calosci?`, `#najpierw_w_calosci`; `rdzen/statyka_krokwi.rb#dobierz`, `rdzen/podloga.rb#wybierz`, `rdzen/podciagi.rb` |
| Wycena materiału (W3) | `rdzen/wycena.rb` (nowy), `rdzen/projekt.rb` (`plan[:wycena]`), `rdzen/zestawienie.rb` (blok CSV), `html/wycena.js` (nowy), `html/wyniki.js` |
| Ustawienia z dawnymi polami | `sketchup/ustawienia.rb#standard_biezacy`, `#ze_starszej` |
| Testy | `testy/t_stolarka.rb`, `testy/t_wycena.rb` (nowe); `t_okno.js`, `t_okno_kroki.js`, `t_sketchup.rb`, `t_podbitka.rb`, `t_losowe.rb` (ziarna 6093, 6324, 6134, 6492), `t_dlugosci.rb`, `t_typy.rb`, `t_podloga.rb`, `t_statyka_zadaszenia.rb`, `t_poziomy.rb`; atrapa `DefinitionList#load` |

## 2. Jak to działa – rzeczy nieoczywiste

- **Pole-tabela**: w Ruby wartość to tablica wierszy (Hash z kluczami kolumn), w oknie – tekst JSON w ukrytym polu
  `p-<klucz>` (formularz domu) albo `s-<klucz>` (panel standardu z edytorem `AMGW_TABELA.edytor`). Porównania
  (`Poziomy.rozne`, `AMGW_ZMIANY.rozne`) idą po postaci kanonicznej, więc ta sama lista jako tekst i jako tablica nie jest
  „zmieniona”. Pola-tabele są tylko w standardzie (nie ma ich na liście „Zmień pole standardu tylko w tym domu”).
- **Dawne pola**: `Parametry.przenies_dawne` = nadbitka (r16) + nowe okno / drzwi → `stolarka` + pięć list → `magazyn_drewna`.
  Wołane w `normalizuj` (modele) i w `Ustawienia` (standard z pliku i plik starszej wersji). Magazyn z dawnych list ma
  jeden wiersz na przekrój: długości wszystkich list, w których był, razem.
- **„jak przełącznik”**: wartość `wspolny` zostaje w parametrach (nie jest zamieniana w `normalizuj`), bo inaczej wyjątek
  równy przełącznikowi znikałby przy zapisie standardu. Kod czyta tryb przez `Parametry.dobor(p, klucz)`; okno – przez
  `data-wspolny` przy polu wyboru (`AMGW_ZALEZNE.wartosc`).
- **Węgieł do spodu płatwi**: `Bale.bez_platwi_nad` usuwa z listy otworów ściany gniazda płatwi zaczynające się nad balem
  węgła, gdy w balu ściany nad węgłem zostaje ≥ `zamek_min_drewno` między gniazdem zamka od spodu a gniazdem płatwi.
  Bal węgła kończy się 0,5 mm pod płatwią (kolizje belek bez zmian).
- **Działowa przy ścianie okapowej**: `w[:do_polaci] = [{ s:, z: }]` (miejsce ściany okapowej i wysokość: pół wieńca pod
  jej górą). Linia działowej = min(połać, max(spód desek, z)) po tej stronie kalenicy, po której leży ściana. Deski
  podbitki są przerwane na działowej od jej końca do miejsca, gdzie spód desek dochodzi do z (krok 10 mm).
- **Okienko kliknięcia**: „od” otworu = s kliknięcia − połowa otworu w balach − `ref` ściany; „od” węgła = s − `ref`.
  Poprawa otworu działa na wierszu tabeli o numerze `nr` z widoku (kolejność wierszy = kolejność otworów w Ruby).
- **Wycena**: pozycje listy bali (Bs, Kf, Sz) × `cena_bala`; belki po przekroju z magazynu (dowolny wiersz o tym
  przekroju); elementy Pb (deski z generatora) i F (fundamenty) poza belkami – deski liczone z wierszy materiałów w sztukach.

## 3. Zostało na rundę 18

`docs/zadanie_r17.md`. W skrócie: wybór układu okna (po odpowiedzi), modele stolarki użytkownika, potwierdzenie działowej,
przełącznik doboru fabrycznie, P2 / P3 / P5, N3 (kanały na przewody).

## 4. Pomiary z rundy 17 (do porównań)

| Co | Kompilacja 16 | Kompilacja 17 |
|---|---|---|
| Domy ze stykiem bez zamka (600 domów: 6001–6600) | 8 | 0 |
| Domy z problemami (600 domów: 6001–6600) | 18 (8 styków + 10 znanych) | 10 (te same znane) |
| Domy złożone z problemami (300: 10001–10300) | 0 | 0 |
| Parametry | 197 | 193 (pola-tabele: stolarka, magazyn drewna, cennik) |
