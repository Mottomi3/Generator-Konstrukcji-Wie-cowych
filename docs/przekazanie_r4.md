# Przekazanie po rundzie 4 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (prywatne, gałąź `main`) – `add_repo` (push) i
   `git clone https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych`. Zapas: `repozytorium_r4.bundle` na dysku
   (`C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\`).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md`, ten plik; potem szukaj w `docs/SPIS_TRESCI.md`.
3. `bash testy/uruchom.sh` → `WSZYSTKIE ZESTAWY: FAILURES 0` przed jakąkolwiek zmianą (ok. 3 min; zestaw Ruby 2.7
   pominięty z uwagą, gdy nie ma `/opt/ruby27` – `bash testy/ruby27.sh` zbuduje go w ok. 10 min).
4. Raport z testu działania (`ArteMadera_GW_raport_*.json`): jak w `przekazanie_r3.md` §0.4. Siódmy przykładowy dom
   (pełny profil, działowa pod antresolą, ostatek 200, węgieł ręczny) sprawdza nowości rundy 4 w prawdziwym
   SketchUpie – zwłaszcza `niezamkniete` i `inna_objetosc` (bryły pełnego profilu mają najwięcej ścian).

## 1. Mapa plików (nowe i zmienione w rundzie 4)

| Temat | Plik |
|---|---|
| Ustawienia pojedynczej ściany: ostatki końców, węgły ręczne, co nad działową | `rdzen/ustawienia_scian.rb` |
| Działowa niższa – kolumny odcinków dopełnienia zamka | `rdzen/dopelnienie.rb` |
| Wieńce niższej działowej i nadstawki, wysokość własna / pełna | `rdzen/wience.rb` (`nizsza_lista`, `wlasne`, `wysokosc_pelna`) |
| Kawałki nadstawki (odcinki), pasek bala przy otworze | `rdzen/bale.rb`, `rdzen/otwory.rb#dla_wienca` |
| Pełny profil bala: pióra, wpusty, pierwszy wieniec bez wpustu, objętość | `rdzen/profil_bala.rb` |
| Siatka bryły z pasami przekroju (pełny profil) | `rdzen/siatka.rb` |
| Węgły ręczne – bez automatu, ostrzeżenia | `rdzen/usztywnienie.rb`, `rdzen/styki.rb` |
| Kolejność obliczeń (ustawienia ścian, dopełnienie, profil) | `rdzen/projekt.rb#oblicz` |
| Dane widoku ściany (ustawienia, wartości domyślne) | `rdzen/widok.rb` |
| Okno: tryb pól / panel ustawień ściany / kliknięcie w widok | `html/tryb.js` / `html/edycja.js` / `html/sciana.js` |
| Ustawienia ścian w domu, tryb pól w pliku ustawień | `sketchup/sterowanie.rb`, `sketchup/okno.rb`, `sketchup/ustawienia.rb` |
| Objętość pozycji w raporcie (z profilem) | `sketchup/raport.rb` |
| Przykładowy dom 7 (test działania) | `rdzen/przyklady.rb` |
| Testy ustawień ścian i działowej niższej | `testy/t_sciany_ust.rb` |
| Losowe domy z nowościami rundy 4 (osobne losowanie – stare ziarna bez zmian) | `testy/losowe_domy.rb` |

## 2. Runda 4

Decyzja użytkownika (2026-10-24 11:26): „1, 6, 8 ale tylko gdy góra jest zamknięta lub gdy jest antresola/półka
ponad, 9. Pozostałych propozycji nie rozumiem.” Wykonanie: `docs/stan_prac.md` §5, zasady: `docs/specyfikacja.md`
§5b, §5c, §7, §10. Testy: rdzeń 142, węgły 51, szczyty 67, podłoga 39, zamek 22, siatki 24, widok 17, zestawienie 14,
raport 27, ustawienia ścian 59, losowe 48, SketchUp 79, okno 55, Ruby 2.7 (11 zestawów), zasady, spis treści,
parametry.

Punkt 8 według wzorów producenta: 1100 W-6 (18 wieńców, nad nią 9 × 244 przy szczycie W-4), 1100 W-7 (17 wieńców,
3 × 244 przy ścianach okapowych), 1200 W-5, W-7 (20 wieńców pod antresolą, 6 × 344 do połaci). Działowa jest niższa
wyłącznie przy ustawieniu „nad działową: strop / antresola / półka” albo parametrze `strop` = tak.

Uwaga: sesja przerwana restartem kontenera przed zamknięciem rundy – praca była zapisana na gałęzi `runda-4` (commit
i push po każdym kawałku), nic nie przepadło; użytkownik ponowił wiadomość, odpowiedź z objaśnieniem propozycji
2, 3, 4, 5, 7, 10 poszła w podsumowaniu rundy.

## 3. Zasady

`CLAUDE.md` + `docs/skille/gw-zasady-kodu/SKILL.md` (kod) + `docs/skille/gw-runda/SKILL.md` (runda).

## 4. Luki

- Nadal brak odbioru w prawdziwym SketchUpie – test działania z raportem ma to zastąpić przy pierwszym uruchomieniu.
- Pełny profil: wymiary przyjęte (2 pióra 8 × 7, rozstaw 20, wpust 9 × 8) – czekają na zdjęcie czoła bala.
- Atrapa API: `manifold?` / `volume` liczone z pętli ścian – w SketchUpie ściany (zwłaszcza pasy pełnego profilu)
  mogą się scalić inaczej; prawdziwy wynik da raport.
- Dokumentacja 2D: bale Bs, Kf, Sz bez grupy (zmiana w tamtej wtyczce – `element_roles.rb`, `PREFIX_GROUPS`).

## 5. Następne kroki

Raport z testu działania + scenariusz odbioru kompilacji 4 → poprawki → wymiary profilu ze zdjęcia → wybór
użytkownika z propozycji 2, 3, 4, 5, 7, 10 (`docs/stan_prac.md` §9).
