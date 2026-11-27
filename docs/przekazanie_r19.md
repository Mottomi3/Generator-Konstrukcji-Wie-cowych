# Przekazanie po rundzie 19 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`) – `add_repo` (push) i `git clone --depth 1`
   do `/home/claude/generator-konstrukcji-wie-cowych` (sprawdź `git rev-parse HEAD`, nie klonuj drugi raz).
   Użytkownik chce repozytorium prywatnego – przełącza sam w ustawieniach GitHuba (`docs/przekazanie_r14.md` §5).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md` (§5 kolejka, §6 pytania), ten plik, `docs/zadanie_r19.md` (§0 – odpowiedzi
   z rundy 19, §1–2 – zakres), potem `docs/SPIS_TRESCI.md`.
3. Folder na dysku: `C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych` – `device_request_folder_access`
   (w rundach 17–19 zgoda przyszła od razu). Najpierw `raporty\` (na starcie rund 15–19 folderu nie było). Kopia na dysk:
   paczka `repozytorium_rN.bundle` przez `device_commit_files`, w `device_bash` `git clone` paczki do katalogu roboczego
   i `cp -r` katalogów `Plugins`, `testy`, `docs` oraz plików (usuwanie na dysku wyłączone; w rundzie 19 nic nie usunięto).
4. Aplikacja do dachów: w rundzie 19 `add_repo` do odczytu został odmówiony – zestaw „dach_aplikacja” pominięty. Spróbuj
   ponownie (`Mottomi3/Aplikacja-do-konstrukcji-dach-w`, 3.12.0) i uruchom testy z `AM_GW_APLIKACJA_DACHOW=…`.
5. Testy: `PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers NODE_PATH=$(npm root -g) bash testy/uruchom.sh` (ok. 20 min na 2 rdzeniach,
   na kopii katalogu w tle). Losowe: `ruby -I testy/atrapa testy/losowe_domy.rb 600 6001` (ok. 18 min, od rundy 19 co trzeci
   prostokątny z drewutnią), złożone: `ruby -I testy/atrapa testy/zlozone_domy.rb 300 10001` (5 min).
6. W poleceniu rundy 19 odpowiedzi były puste („…”) – pytania zadane od razu `AskUserQuestion` z rysunkami: użytkownik
   odpowiedział w pierwszym polu na wszystkie naraz (odpowiedzi w `docs/zadanie_r19.md` §0). To działa – pytać tak samo.

## 1. Mapa plików (nowe i zmienione w rundzie 19)

| Temat | Plik |
|---|---|
| Kosz domu L – siła ze słupka na płatwi głównej, docisk | `rdzen/statyka_kosza.rb` (nowy), `rdzen/statyka_dachu.rb#podpory` (wydzielone z `#przeslo`), `#platwie` (`x[:sila]`), `#ocena` (`StatykaKosza.z_sila`), `rdzen/statyka.rb` (`fc90` w klasach), `rdzen/projekt.rb#belki` (podpowiedź) |
| Drewutnia – geometria i elementy | `rdzen/drewutnia.rb` (nowy): `geo`, `wysokosc!`, `punkty_nad`, `wystep_scian`, `wystep_dolu`, `elementy`, `krokwie`, `slup`, `podpowiedzi` |
| Drewutnia – statyka | `rdzen/statyka_drewutni.rb` (nowy) |
| Drewutnia – parametry | `rdzen/parametry_drewutnia.rb` (nowy), `rdzen/parametry_lista.rb` (SEKCJE, LISTA), `rdzen/poziomy.rb` (krok „Dodatki”) |
| Drewutnia w planie, modelu i aplikacji | `rdzen/projekt.rb#drewutnia` (po podłodze), `rdzen/krok2.rb#podpory` (bez drewutni), `rdzen/dlugosci_handlowe.rb`, `sketchup/budowa.rb` (tag i grupa „Drewutnia”), `rdzen/przyklady.rb` (12. przykład) |
| Przełącznik zadaszenia w „Ten dom” | `rdzen/parametry_zadaszenie.rb` |
| P5 | `rdzen/sciecie_dachu.rb#wyrownaj_skosy!` (dolne naroża gniazd od spodu), `#wyrownaj_przeciwne!` (nowa), `rdzen/projekt.rb` |
| Kanały | `rdzen/kanaly.rb#przypisz`, `#pod_otworem!` (nowa), `#obrob!`, `#do_widoku`; `rdzen/widok.rb`; `html/kanaly.js` (strona puszki), `html/sciana.js#kanaly` |
| Testy | `testy/t_drewutnia.rb` (nowy), `t_skrzydla.rb` (kosz wg EC5), `t_kanaly.rb`, `t_losowe.rb` (6305, 6557), `t_poziomy.rb`, `t_okno.js`, `t_sketchup.rb`; `losowe_domy.rb` (drewutnia od 6001, pary kolizji), `kolizje_belek.rb` (połać bez drewutni), `podglad.rb` (dom `drewutnia`) |
| Rysunki | `docs/drewutnia_r19.png` |

## 2. Jak to działa – rzeczy nieoczywiste

- **Kosz**: `StatykaKosza.sily_glownych` liczy reakcję płatwi skrzydła na słupku z `StatykaDachu.podpory` (podpory płatwi:
  przejścia przez ściany, końce ścian, słupek) – przęsło L do najbliższej podpory po drugiej stronie niż koniec w koszu,
  wspornik a do końca; R = q (L + a)² / 2L. `StatykaDachu.platwie` dopisuje `sila: [stałe, śnieg]` płatwiom dachu
  głównego o osi = `podp[:u]`; `ocena` dodaje 2R / L do obciążeń. `statyka_dachu.rb` wczytuje `statyka_kosza.rb` (a nie
  odwrotnie – kosz woła `StatykaDachu` dopiero przy liczeniu).
- **Drewutnia – układ**: `s` = odległość od lica ściany szczytowej na zewnątrz (`u = u_lico + kier · s`), `v` wzdłuż ściany.
  `s_k` (krokwie) za wystającymi ścianami (`wystep_scian` – węgły, działowe w pasie drewutni) + odstęp; `s_a` (rząd przy
  ścianie) za krokwiami i za podwalinami / fundamentami domu (`wystep_dolu`, elementy `Pw`, `F` – dlatego drewutnia
  liczona po podłodze w `projekt.rb#belki`) z miejscem na fundament słupa; `s_b` = głębokość − pół słupa; `s_e` = głębokość
  + okap. Wysokość `h_k` (wierzch krokwi w `s_k`): minimum z linii podparcia dachu przy brzegach pasa i punktów krawędzi
  belek dachu domu nad drewutnią (`punkty_nad`, co 25 mm – krokiew dachu liczy się tam, gdzie wisi nad drewutnią), każde
  minus osiadanie ścian (`Osiadanie.luz`) i odstęp, przesunięte o tg α · (s − s_k).
- **Drewutnia a aplikacja do dachów**: belki drewutni (tag `:drewutnia`) pominięte w `Krok2.podpory` i w testowym
  `wzgledem_polaci` (nie podpierają połaci domu).
- **P5**: `wyrownaj_skosy!` ma teraz także dolne naroża gniazd od spodu (x, 0) – tylko gdy skos jest nad narożem (d > 0);
  `wyrownaj_przeciwne!` – gniazdo / wycięcie od góry i od dołu w tym samym x, resztka 0 < r < SCAL → wycięcie od góry
  płytsze o SCAL − r.
- **Kanały**: `pod_otworem!` – najniższy otwór (bez gniazd płatwi) w zasięgu kanału; `k[:do]` = spód otworu, bale od
  tej wysokości bez obróbki `kanal`; widok dostaje szósty element (koniec u góry).

## 3. Zostało na rundę 20

`docs/zadanie_r19.md`. W skrócie: odpowiedzi o drewutni (słupy przy ścianie / łączniki, ściany), taras w „Ten dom”, kolejny
dodatek; uwagi z SketchUpa (raport testu działania); modele stolarki; zestaw z aplikacją do dachów.

## 4. Pomiary z rundy 19 (do porównań)

| Co | Kompilacja 18 | Kompilacja 19 |
|---|---|---|
| Domy z problemami (600 domów: 6001–6600; od k19 co trzeci prostokątny z drewutnią) | 2 (6305, 6557) | 0 |
| Domy złożone z problemami (300: 10001–10300) | 0 | 0 |
| Parametry | 205 | 217 |
| Zestawy testów / sprawdzenia | 38 / ok. 2470 | 39 / ok. 2270 (bez zestawu z aplikacją do dachów) |
