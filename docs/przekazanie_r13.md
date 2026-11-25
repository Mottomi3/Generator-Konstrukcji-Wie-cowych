# Przekazanie po rundzie 13 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`) – `add_repo` (push) i
   `git clone https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych` (przy klonie płytkim przed pushem
   `git fetch --depth=1000 origin main`).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md` (§1g – nowości kompilacji 13, §6 Z6–Z9), ten plik; potem `docs/SPIS_TRESCI.md`.
3. Aplikacja do dachów obok repozytorium (`../aplikacja-do-konstrukcji-dach-w`, `add_repo` read; 3.12.0 lub nowsza).
   `bash testy/uruchom.sh` → `WSZYSTKIE ZESTAWY: FAILURES 0` (ok. 8 min – uruchamiaj na kopii repozytorium albo nie
   edytuj plików w trakcie).
4. Losowe domy: `ruby -I testy/atrapa testy/losowe_domy.rb 100 8501` (ziarna od 8500 – dobór zadaszenia i krokwi, podłoga
   w przybudówce).
5. W tej sesji nie było dostępu do folderów na dysku użytkownika – kopie `.rbz` w rozmowie, repozytorium na GitHubie.
6. Nie było Rubiego 2.7 (`/opt/ruby27`) – zestaw „Ruby 2.7” pominięty (kontrola zasad Ruby 2.2 przechodzi).

## 1. Mapa plików (nowe i zmienione w rundzie 13)

| Temat | Plik |
|---|---|
| Zakładki okna „Dom” / „Zadaszenie boczne / tylne” | `html/zakladki.js` (nowy), `rdzen/parametry_lista.rb` (ZAKLADKI, czwarty element SEKCJE), `sketchup/okno.rb#dane_startowe`, `html/okno.js#zbudujSekcje`, `html/okno.html`, `html/okno.css` |
| Parametry zakładki zadaszenia (sekcje, dobór, listy, podłoga przybudówki) | `rdzen/parametry_zadaszenie.rb` |
| Dobór i sprawdzenie płatwi z oczepem, belek poprzecznych i słupów zadaszenia | `rdzen/statyka_zadaszenia.rb` (nowy) |
| Słup ściskany z wyboczeniem | `rdzen/statyka_slupa.rb` (nowy), `rdzen/statyka.rb` (KLASY – f_c,0,k, E0,05) |
| Dobór i sprawdzenie krokwi (dach i zadaszenie) | `rdzen/statyka_krokwi.rb` (nowy), `rdzen/parametry_dach.rb` (`krokwie_dobor`, `krokwie_katalog`) |
| Obciążenia przy kącie zadaszenia | `rdzen/statyka_dachu.rb#obciazenia` |
| Linie słupów zadaszenia (wspólne dla modelu i statyki); koniec belki przy płatwi ściennej szerszej niż ściana | `rdzen/zadaszenie.rb#linie_slupow`, `#slupy`, `#koniec_belki`, `#linie` |
| Podłoga w przybudówce do wyboru | `rdzen/podloga_przybudowki.rb` (nowy), `rdzen/podloga.rb#uklad`, `#przesla`, `#linie_legarow`, `#objetosc`, `#legary`, `rdzen/podciagi.rb#elementy`, `#odcinki`, `rdzen/fundamenty.rb#stopy` |
| Przebieg: dobór zadaszenia i krokwi, podpowiedzi w zakładce | `rdzen/projekt.rb#belki` |
| Przykłady testu działania (10, 11) | `rdzen/przyklady.rb` |
| Testy | `testy/t_statyka_zadaszenia.rb` (nowy), `testy/t_okno.js` (zakładki), `testy/t_zadaszenie.rb`, `testy/losowe_domy.rb#dodatki_r13`, `testy/podglad.rb` (dom `przybudowka_podloga`) |

## 2. Runda 13

Prośba – `docs/stan_prac.md` §5 „Runda 13”; zasady – `docs/specyfikacja.md` §8h; kroki odbioru 5a–5f.

Nowe parametry: `zadaszenie_podloga`, `zadaszenie_dobor`, `zadaszenie_katalog`, `zadaszenie_slupy_katalog`,
`krokwie_dobor`, `krokwie_katalog`. Przeniesione do sekcji „Zadaszenie – przekroje (dobór)”: `zadaszenie_platwa_przekroj`,
`zadaszenie_slup_przekroj`, `zadaszenie_belka_przekroj` (klucze bez zmian – domy z kompilacji 12 wczytują się).
Uwaga: dobór zadaszenia domyślnie automatyczny – dom z kompilacji 12 z zadaszeniem po przebudowie dostanie przekroje
dobrane (pola z kompilacji 12 działają po wybraniu „z wyboru”).

## 3. Zasady

`CLAUDE.md` + `docs/skille/gw-zasady-kodu/SKILL.md` + `docs/skille/gw-runda/SKILL.md`. Z tej rundy:
- Nowa zakładka okna = wpis w `ParametryLista::ZAKLADKI` i czwarty element sekcji w SEKCJE; `html/zakladki.js` buduje
  pasek i pojemniki sam.
- Dobór przekroju – wzór `StatykaDachu.sprawdz` (tryby `:pierwszy`, `:potwierdz`, `:koniec`, `nadpis` do następnego
  przebiegu w `Projekt.oblicz`); podpowiedzi z polem `sekcja` (zakładka zadaszenia – `zadaszenie_przekroje`).
- Pole podłogi: `PodlogaPrzybudowki.pole(u)` i `.dzialowe_pola(u)` zamiast `u[:ext]` / `u[:dzialowe]` wszędzie, gdzie chodzi
  o legary i podciągi; `u[:ext]` – obrys (podwaliny, siatka fundamentów).

## 4. Luki

- Kompilacje 7–13 niesprawdzone w prawdziwym SketchUpie – scenariusz odbioru 5a–5f, 4a–4h, 3a–3h, 2v–2z, 2q–2u, 2i–2p.
- Przybudówka: płatwie zadaszenia oparte tylko na ścianach szczytowych – przy długim domu duże przekroje (Z9).
- Statyka zadaszenia bez wiatru i bez zsuwania śniegu z wyższej połaci; słupy wolnostojące – stężenia na budowie.
- Ze wcześniejszych: słupy tarasu a płatew ścienna na ścianie (ziarno 8064), dom L + podbitka na płatwiach + krokwie
  z aplikacji (ziarna 7004, 7021), rozstrzygnięcia z 2026-11-14 i decyzja T8.

## 5. Następne kroki

Odbiór kompilacji 13 → decyzje Z6–Z9 (zwłaszcza podparcie płatwi w przybudówce) → rozstrzygnięcia z 2026-11-14 → zadaszenie:
odcinek od–do, zamknięcie boku, z tarasem → dom L: podłoga, taras, belka koszowa → Dokumentacja 2D (grupy).
