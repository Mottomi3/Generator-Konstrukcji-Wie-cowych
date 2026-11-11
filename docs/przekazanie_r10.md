# Przekazanie po rundzie 10 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`) – `add_repo` (push) i
   `git clone https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych` (przy klonie płytkim przed pushem
   `git fetch --depth=1000 origin main`). Zapas: `repozytorium_r10.bundle` na dysku
   (`C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\`).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md` (§1d – nowości kompilacji 10), ten plik; potem `docs/SPIS_TRESCI.md`.
3. Aplikacja do dachów obok repozytorium (`../aplikacja-do-konstrukcji-dach-w`, `add_repo` read). `bash testy/uruchom.sh` →
   `WSZYSTKIE ZESTAWY: FAILURES 0` (ok. 12 min – uruchamiaj w tle albo na kopii repozytorium; nie edytuj plików w trakcie).
4. Losowe domy: `ruby -I testy/atrapa testy/losowe_domy.rb 60 6001` (ziarna od 6000 – nowości rundy 10; co czwarty dom L).
5. Ostatnie parametry użytkownika: `C:\Users\Mottomi\AppData\Roaming\ArteMadera\GeneratorWiencowy\ustawienia.json`
   (folder udostępniany sesji na prośbę – odtworzenie jego domu; obrysu w nim nie ma).

## 1. Mapa plików (nowe i zmienione w rundzie 10)

| Temat | Plik |
|---|---|
| Dom L: podział na skrzydła, oś kalenicy, opisy dachów, szczyty, ściany okapowe skrzydła bocznego, zasięg płatwi | `rdzen/skrzydla.rb` |
| Szczyt na części ściany (`s_zakres`): linia, zasięg wieńca, skosy; gniazda na zasięgu płatwi | `rdzen/szczyty.rb#dom_l`, `#zasieg_czesci`, `#skosy`, `#gniazda_sciany` |
| Płatwie obu dachów, `Dach.geo(dom)` | `rdzen/dach.rb#elementy`, `#geo` |
| Węgieł na ścianie wspólnej poza szczytem | `rdzen/wience.rb#szczyt_gospodarza` |
| Ścięcie górnego bala ścian okapowych skrzydła bocznego (także na części długości) | `rdzen/sciecie_dachu.rb#przytnij!`, `#w_zakresie` |
| Bale pod dachem – dach skrzydła, w którym stoi ściana | `rdzen/pod_dachem.rb#przygotuj` |
| Wypust górnych wieńców tylko w narożniku wypukłym | `rdzen/wypusty_okapu.rb#przy_szczycie?`, `rdzen/sciany.rb` (`w[:wklesle]`) |
| Połacie domu L (obrys z uskokiem) | `rdzen/polacie.rb#dla_domu_l`, `#uwagi_l` |
| Linia dachu w widoku ściany wspólnej | `rdzen/widok.rb#linia_dachu` |
| Wiązar pod płatwiami, kąt zastrzałów | `rdzen/taras_wiazar.rb#pod_platwiami`, `#zastrzaly`; parametry w `rdzen/parametry_taras.rb` |
| Podciąg domyślnie na równo | `rdzen/parametry_podloga.rb` (`podciag_poziom`) |
| Dom + linie w zaznaczeniu, start od nowa | `sketchup/wejscie.rb#z_zaznaczenia`, `sketchup/sterowanie.rb#dom_czy_linie`, `sketchup/okno.rb#po_zamknieciu` |
| Wersja pliku ustawień, powrót do wartości fabrycznych | `sketchup/ustawienia.rb` (`WERSJA`, `DO_FABRYCZNYCH`) |
| Połać domu L liczona niezależnie w testach | `testy/kolizje_belek.rb#z_polaci_l` |
| Testy domu L | `testy/t_skrzydla.rb`, `testy/sprawdz_dach_aplikacja.rb` (3 domy L) |

## 2. Runda 10

Uwagi i odpowiedzi – `docs/stan_prac.md` §5 „Runda 10”; zasady – `docs/specyfikacja.md` §8e.

## 3. Zasady

`CLAUDE.md` + `docs/skille/gw-zasady-kodu/SKILL.md` + `docs/skille/gw-runda/SKILL.md`. Nowy kod dachu: nigdy
`dom[:os] == :x ? 1 : 0` ani `{ v_a:, v_b: }` wprost – zawsze `dom[:iv]`, `Dach.geo(dom)` i pętla po `Skrzydla.domy(dom)`.

## 4. Luki

- Kompilacje 7–10 niesprawdzone w prawdziwym SketchUpie – scenariusz odbioru 2i–2z.
- „Okno nie wczytuje się od nowa” – przyczyna niepotwierdzona (poprawione: dom + linie w zaznaczeniu, stan po zamknięciu
  okna, pamięć podręczna, wersja ustawień). Jeśli wróci – opis objawu i raport z testu działania.
- Dom L: bez podłogi, tarasu, podbitki i krokwi z generatora; końce płatwi skrzydła bocznego bez własnej podpory;
  obrysy T, U – nadal bez dachu z generatora.
- Losowe domy sprzed rundy 10: ziarna 75, 318, 472 (jednospadowy, 0,03–0,16 mm), 6110 (bal 0,15 mm nad połacią).
- Aplikacja do dachów – część 2 zadania bez zmian; Dokumentacja 2D – grupy Bs, Kf, Sz, F, Pb, Wt.

## 5. Następne kroki

Odbiór kompilacji 10 → poprawki → dom L: podłoga, taras, belka koszowa → aplikacja do dachów (część 2) → Dokumentacja 2D
(grupy) → schody i deski tarasu.
