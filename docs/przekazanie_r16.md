# Przekazanie po rundzie 16 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`) – `add_repo` (push); w sesji zwykle już
   sklonowane w `/home/claude/generator-konstrukcji-wie-cowych` (sprawdź `git rev-parse HEAD`, nie klonuj drugi raz).
   Użytkownik chce repozytorium prywatnego – przełącza sam w ustawieniach GitHuba (`docs/przekazanie_r14.md` §5).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md` (§5 kolejka decyzji, §6 pytania), ten plik, `docs/zadanie_r16.md` (§0 –
   odpowiedzi użytkownika z rundy 16, §1–4 – zakres rundy 17), potem `docs/SPIS_TRESCI.md`.
3. Folder na dysku: `C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych` – w rundzie 16 trzeba było
   poprosić o dostęp (`device_request_folder_access`; pierwsza prośba wygasła bez odpowiedzi – ponowić). Najpierw `raporty\`
   (na starcie rund 15 i 16 folderu nie było – kompilacje 14 i 15 nie były uruchamiane). Kopia na dysk: paczka
   `repozytorium_rN.bundle` przez `device_commit_files`, potem w `device_bash` `git clone` paczki do katalogu roboczego
   i `cp -r` katalogów `Plugins`, `testy`, `docs` oraz plików do folderu (usuwanie na dysku wyłączone – w rundzie 16 nic
   nie usuwano).
4. Aplikacja do dachów obok repozytorium (`add_repo` do odczytu → `/home/claude/aplikacja-do-konstrukcji-dach-w`, 3.12.0).
   Testy na kopii katalogu (`cp -r Plugins testy docs CLAUDE.md README.md /home/claude/kopie/x`) z
   `AM_GW_APLIKACJA_DACHOW=/home/claude/aplikacja-do-konstrukcji-dach-w bash testy/uruchom.sh` – 6–15 min na 2 rdzeniach,
   ostatnia linia `WSZYSTKIE ZESTAWY: FAILURES 0`.
5. Losowe domy: `ruby -I testy/atrapa testy/losowe_domy.rb 300 6001`, złożone: `ruby -I testy/atrapa testy/zlozone_domy.rb 120 10001`.
   Fabrycznie mają teraz pół zamka i deski „na krokwiach / na płatwiach” (wcześniej: bez pół zamka, `podbitka` = nie).
6. Nie było Rubiego 2.7 (`/opt/ruby27`) – zestaw „Ruby 2.7” pominięty.

## 1. Mapa plików (nowe i zmienione w rundzie 16)

| Temat | Plik |
|---|---|
| Ostatnie połączenie pod dachem poza narożnikiem: `ostatnie?`, wierzch bala pod dachem, `min_wysokosc` | `rdzen/pol_zamka.rb` |
| Pary bali w zamkach, kolejność: najpierw ostatnie połączenia, potem obróbki | `rdzen/zamek.rb#nanies`, `#pary_bali`, `#ostatnie_polaczenia!` |
| Ostatni bal węgła (od 20 mm pod dachem; wieniec szczytu ucięty przed węgłem) | `rdzen/bale.rb#kontrfor_obecny?`, `#ostatni_bal_wegla?` |
| Węgieł ze stykami do połaci, deski podbitki przerwane na węźle | `rdzen/podbitka.rb#obnizenie_wegla`, `#wegiel_do_polaci?`, `#wegly_do_polaci`, `#bez_wegla`; `rdzen/pod_dachem.rb#linia`, `rdzen/sciecie_dachu.rb#sciecie`, `rdzen/szczyty.rb#pod_podparciem?` |
| Jedno pole położenia desek, zamienniki, przeniesienie dawnych pól | `rdzen/parametry_dach.rb` (`DESKI_ZAMIENNIKI`, `#polozenie_desek`, `#przenies_nadbitke`), `rdzen/parametry.rb#normalizuj`, `rdzen/krok2.rb`, `rdzen/materialy.rb` |
| Poziomy, kroki, złożenie parametrów, zmiany w domu | `rdzen/poziomy.rb` (nowy); cecha `poziom:` w `rdzen/parametry_*.rb` |
| Plik ustawień v5: standard, układ okna, przeniesienie starszych plików | `sketchup/ustawienia.rb` |
| Typy domów (wbudowane, własne, wybrany, baza porównania) | `sketchup/typy_domow.rb` (nowy) |
| Wywołania okna: typy, standard, układ | `sketchup/okno_typy.rb` (nowy), `sketchup/okno.rb#dane_startowe` |
| Start: nowy dom z typu i standardu, dom z wymiarów, edycja starego domu | `sketchup/sterowanie.rb#start`, `#scal`; `sketchup/wejscie.rb` (`pusto`) |
| Dom z wymiarów | `rdzen/dom_z_wymiarow.rb` (nowy), pola `dom_dlugosc`, `dom_szerokosc` (`z_wymiarow: true`) |
| Powierzchnie, wysokość, limity, rodzaj obrysu | `rdzen/powierzchnie.rb` (nowy), parametry w `rdzen/parametry_materialy.rb`, `rdzen/zestawienie.rb#csv` |
| Lista uwag z polem i krokiem | `rdzen/uwagi_pola.rb` (nowy), `sketchup/sterowanie.rb#dla_okna` (`uwagi`, `obrys_rodzaj`, `powierzchnie`) |
| Okno: pasek typu, panel standardu, kroki, lista uwag, przełącznik układu, style | `html/typy.js`, `html/standard.js`, `html/kroki.js`, `html/uwagi.js`, `html/uklad.js`, `html/kroki.css` (nowe); `html/okno.html`, `html/okno.js` |
| Opcje wyszarzone dla obrysu, zamiennik wyboru | `html/zalezne.js` (`obrys`, `wybory`), cecha `obrys:` pól `taras`, `zadaszenie`, `podloga`, `dach_rodzaj`, `dach_wiezba` |
| Podpowiedź po wejściu w pole; liczby w polach bez zaokrąglania | `html/pomoc.js#poWejsciu`, `html/wspolne.js#fmtPola` |
| Testy | `testy/t_poziomy.rb`, `testy/t_typy.rb`, `testy/t_okno_kroki.js` (nowe); `t_pol_zamka`, `t_podbitka`, `t_jednospadowy`, `t_sketchup`, `t_okno.js` |

## 2. Jak to działa – rzeczy nieoczywiste

- **Pół zamka poza narożnikiem** decyduje się w `Zamek.nanies` na liście wszystkich par bali (posortowanej od najniższej):
  para jest ostatnim połączeniem, gdy bal wyższy ma pod skosem (`skos_gora`) albo ścięciem (`sciecie_dachu`) mniej niż
  `zamek_min_drewno` nad zwykłym gniazdem, nie ma prawdziwego gniazda od wierzchu, a balowi niższemu po gnieździe 72
  zostaje dość drewna. Para, w której bal półzamka nie sięga bala nad sobą, znika z listy (bez pustych gniazd).
  Narożnik szczytu obsługuje dalej `SkosPrzyNarozniku` (tam bal poniżej 20 mm jest ucinany).
  Dwa wyjątki znalezione losowymi domami **dopiero przy zamknięciu** (ziarna dopisane do regresji): bal wyższy cieńszy
  w zamku niż 20 mm nie jest balem półzamka (6201 – podcięcia boczne na klinie cieńszym niż wpust pełnego profilu dawały
  bryłę niezamkniętą); w węźle ścian w jednej linii dwa bale stykające się czołami nad jednym gniazdem muszą być oba
  balami półzamka (10019 – `Zamek.wspolne_polzamki!`, `dodaj_ceche` zostawia głębsze z dwóch gniazd w tym samym miejscu).
  **Lekcja:** po każdej zmianie zamków puszczać od razu także domy złożone (`zlozone_domy.rb 300 10001`) i pełne 300
  ziaren od 6001 – po punkcie 1 sprawdzone były tylko 1–200 i 6001–6200.
- **Węgieł do połaci**: `Podbitka.obnizenie_wegla(kf, p)` zwraca 0 tylko przy podbitce „pod płatwiami” i węźle, w którego
  osi ściana ma styk (`w[:styki][:parzyste / :nieparzyste]`). Trzy miejsca muszą używać tej samej wartości: istnienie
  bala (`Szczyty.pod_podparciem?` z `dz`), ścięcie (`SciecieDachu.sciecie`) i linia nad węgłem pod połacią
  (`PodDachem.linia`).
- **Położenie desek** jest normalizowane w `Parametry.normalizuj` – reszta kodu czyta `p['podbitka']` już zgodne z układem
  dachu. Wartość fabryczna to `na_krokwiach`; przy samych płatwiach zamienia się na `na_platwiach` (nadbitkę robi aplikacja
  do dachów jak dotąd). Okno robi tę samą zamianę (`zamienniki` w opisie pola).
- **Baza porównania**: `TypyDomow.baza(typ)` = `Parametry.normalizuj(standard ← pola typu)`. Okno ma wszystkie pola
  w DOM (jak dotąd) – układ nowy tylko je chowa; pole jest „zmienione tylko w tym domu”, gdy różni się od bazy
  (`AMGW_TYPY.zmienione`). Po zapisie standardu pola standardu równe starej bazie dostają nową wartość, zmienione zostają.
- **Układy okna**: klasa `uklad-kroki` / `uklad-zakladki` na `<body>`; karty mają stałe identyfikatory i `data-krok`,
  `AMGW_UKLAD.rozmiesc` przenosi je między kolumnami. Widoczność pól: `AMGW_KROKI.zastosuj` (nowy) albo
  `AMGW_TRYB.zastosuj` (dotychczasowy). Testy okna: `t_okno.js` ustawia `uklad = 'zakladki'`, `t_okno_kroki.js` – nowy.
- `AMGW._ustaw` i `AMGW._zbierz` to wejścia dla testów okna.

## 3. Zostało na rundę 17

`docs/zadanie_r16.md`. W skrócie: wybór układu okna (usunąć drugi, `html/tryb.js`, cechę `podstawowy`), okna / drzwi / węgły
kliknięciem z okienkiem parametrów i gotowe modele stolarki użytkownika, magazyn drewna jako tabela, wycena (W3), styk na
działowej pod podbitką i w ścianie szczytowej nad końcem węgła, pozycja menu „Standard warsztatu”.

## 4. Pomiary z rundy 16 (do porównań)

| Co | Kompilacja 15 | Kompilacja 16 |
|---|---|---|
| Gniazda od spodu z < 20 mm drewna pod dachem (240 domów: 1–120 i 6001–6120) | 268 (79 bali przeciętych) | 49 – same kliny cieńsze w zamku niż 20 mm |
| Domy ze stykiem bez zamka (600 domów: 6001–6600) | 23 | 8 (6057, 6093, 6134, 6280, 6324, 6392, 6492, 6541) |
| Bale węgłów (300 domów: 1–150 i 6001–6150) | 86 706 | 86 879 |
| Krok „Ściany” – przewijanie / karta „Wynik” od góry (okno 1060 × 860) | 3 694 px / 1 202 px | 999 px / 446 px |
