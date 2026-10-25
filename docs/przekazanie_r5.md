# Przekazanie po rundzie 5 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`; od rundy 5 **publiczne** na GitHubie –
   użytkownik wie) – `add_repo` (push) i `git clone https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych`.
   Zapas: `repozytorium_r5.bundle` na dysku (`C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\`).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md`, ten plik; potem szukaj w `docs/SPIS_TRESCI.md`.
3. Aplikacja do dachów obok repozytorium (`git clone https://github.com/Mottomi3/Aplikacja-do-konstrukcji-dach-w
   ../aplikacja-do-konstrukcji-dach-w` albo `AM_GW_APLIKACJA_DACHOW`) – bez niej zestaw „dach_aplikacja” jest pomijany
   z uwagą. `bash testy/uruchom.sh` → `WSZYSTKIE ZESTAWY: FAILURES 0` przed jakąkolwiek zmianą (ok. 6 min; Ruby 2.7 –
   `bash testy/ruby27.sh` zbuduje go, gdy nie ma `/opt/ruby27`).
4. Raport z testu działania (`ArteMadera_GW_raport_*.json`): jak w `przekazanie_r3.md` §0.4 – 9 przykładowych domów
   (ósmy dach jednospadowy, dziewiąty taras jak 1100).

## 1. Mapa plików (nowe i zmienione w rundzie 5)

| Temat | Plik |
|---|---|
| Stolarka i luzy (otwór w balach z wymiarów stolarki, podpowiedź luzu górnego) | `rdzen/stolarka.rb`, `rdzen/otwory.rb`, `html/otwory.js` |
| Płatew ścięta – bryła z przekroju (pryzmat) | `rdzen/pryzmat.rb`, `rdzen/dach.rb#platwa`, `#przekroj_platwi` |
| Bal szczytu pełnym klinem | `rdzen/bryla.rb#klin_ok?`, `rdzen/szczyty.rb#zasieg` |
| Krokwie z aplikacji do dachów – połacie w planie | `rdzen/polacie.rb`, parametr `dach_wiezba`, `rdzen/dach.rb#krokwie_generatora?` |
| Połacie i KROK 2 w modelu (ArteMadera Roof), przebudowa połaci i więźby | `sketchup/dach_aplikacja.rb`, `sketchup/sterowanie.rb#generuj` |
| Dach jednospadowy | `rdzen/dach_jednospadowy.rb`, `rdzen/szczyty.rb#jednospadowy`, `rdzen/pod_dachem.rb` |
| Bal ścięty dachem przez narożnik tylko w zamku | `rdzen/skos_przy_narozniku.rb` |
| Taras – obrys, role ścian, zasięg wieńców, słupy, przęsła | `rdzen/taras.rb` |
| Balustrada tarasu (bale i przekładki) | `rdzen/taras_balustrada.rb` |
| Bale węgła tylko przy balach gospodarza | `rdzen/bale.rb#kontrfor_obecny?` |
| Poziomy obróbek różne o mniej niż 0,2 mm – wyrównane | `rdzen/bryla.rb#wyrownaj_poziomy` (też `rdzen/profil_bala.rb`) |
| Grupa i tag „Taras” (słupy S, bale balustrady) | `sketchup/budowa.rb`, `rdzen/elementy.rb` |
| Przykłady 8 (jednospadowy) i 9 (taras jak 1100) | `rdzen/przyklady.rb` |
| Testy | `testy/t_polacie.rb`, `t_jednospadowy.rb`, `t_taras.rb`, `t_dach_aplikacja.rb` + `atrapa/aplikacja_dachow.rb`, `sprawdz_dach_aplikacja.rb` (prawdziwa aplikacja do dachów), `zrzut_dok2d.rb`, `kolizje_belek.rb#wzgledem_polaci`, `losowe_domy.rb` (dodatki rundy 5, taras od ziarna 2000) |
| Zadania dla innych wtyczek | `docs/zadanie_dokumentacja2d.md`, `docs/zadanie_aplikacja_dachow.md` |

## 2. Runda 5

Decyzje i wykonanie: `docs/stan_prac.md` §5 „Runda 5”, zasady: `docs/specyfikacja.md` §6, §8, §8a, §10a.

Przebieg sesji: praca zapisywana na gałęzi `runda-5` commitami „r5 (w toku)” i push po każdym kawałku. Kontekst
rozmowy kilka razy się kończył – po wznowieniu stan odtwarzany z gałęzi (commity 7ee491e, 3ca4854 powstały
w częściach sesji, których nie było w streszczeniu – zawsze sprawdzaj `git log --all` i niezatwierdzone zmiany).
Użytkownik ponowił wiadomość o płatwiach i szczycie (2026-10-25 15:01) – odpowiedź: rysunek przed / po
(`szczyt_przed_po.png`) i prompt dla Dokumentacji 2D (także w Projekcie: `claude/zadanie_dokumentacja2d.md`).
2026-10-25 16:05: „ściany szczytowe na wysokości płatwi z krótkich kawałków” – rysunek przed / po był rysowany
odcinkami profilu (kreski wyglądały jak styki). Rysunki dla użytkownika rysuj obrysem bala (`Widok.sciana` –
jak widok ściany w oknie, opis pozycja-długość). Krótkie kawałki między płatwią a skosem zostają (decyzja S4).

## 3. Zasady

`CLAUDE.md` + `docs/skille/gw-zasady-kodu/SKILL.md` (kod) + `docs/skille/gw-runda/SKILL.md` (runda).

## 4. Luki

- Nadal brak odbioru w prawdziwym SketchUpie – raport z testu działania (9 domów) i scenariusz kompilacji 5.
- Integracja z aplikacją do dachów opiera się na jej wewnętrznych klasach (Footprint, RoofBuilder, Config, Commands,
  wersja 3.3.1) – po zmianach tam uruchom `ruby testy/sprawdz_dach_aplikacja.rb`; docelowo stałe API (zadanie).
- Taras: wymiary słupów, wejścia i balustrady przyjęte z rysunków 1100; wariant 1200 bez osłony z listew i bez
  słupów frontu (do decyzji użytkownika).
- Dokumentacja 2D: bale Bs, Kf, Sz bez grup – zadanie w tamtej wtyczce.

## 5. Następne kroki

Raport i scenariusz odbioru kompilacji 5 → poprawki → po zmianach w Dokumentacji 2D i aplikacji do dachów:
dostosowanie generatora (stałe API dachów, osie krokwi przy szczycie, podpory pośrednie) → szczegóły tarasu.
