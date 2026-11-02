# Przekazanie po rundzie 8 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`, publiczne) – `add_repo` (push) i
   `git clone https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych` (przy klonie płytkim przed pushem
   `git fetch --depth=1000 origin main`). Zapas: `repozytorium_r8.bundle` na dysku
   (`C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\`).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md` (§1b – nowości kompilacji 8), ten plik; potem `docs/SPIS_TRESCI.md`.
3. Aplikacja do dachów 3.7.0+ obok repozytorium (`../aplikacja-do-konstrukcji-dach-w`). `bash testy/uruchom.sh` →
   `WSZYSTKIE ZESTAWY: FAILURES 0` (ok. 9 min). Nie edytuj `testy/uruchom.sh` w trakcie jego biegu.
4. Losowe domy: `ruby -I testy/atrapa testy/losowe_domy.rb 40 4001` (ziarna od 4000 – nowości rundy 8).

## 1. Mapa plików (nowe i zmienione w rundzie 8)

| Temat | Plik |
|---|---|
| Węgły symetryczne na ścianach równoległych, równy podział odcinków | `rdzen/symetria_wegly.rb` (używa `rdzen/styki.rb`, `rdzen/usztywnienie.rb`) |
| Górne wieńce okapowe wypuszczone za szczyty, węgły pod okapem do nawisu | `rdzen/wypusty_okapu.rb` |
| Balustrada tarasu z wieńców ścian, zakładki w narożnikach frontu | `rdzen/taras_sciany.rb` |
| Trójkątny wieniec szczytu pustego | `rdzen/taras_szczyt.rb#wience` (prefiks Wt, `rdzen/elementy.rb`) |
| Wieniec węgła nad ścianą, węgieł przy szczycie do dachu | `rdzen/wience.rb#dla_sciany`, `rdzen/bale.rb#kontrfor_obecny?`, `#nad_gospodarzem?`, `rdzen/pod_dachem.rb` (`pod_dachem_wzdluz`), `rdzen/sciecie_dachu.rb` |
| Wypusty węgła wewnątrz / na zewnątrz | `rdzen/sciany.rb#wypusty_kontrforu`, `html/wegly.js` |
| Zamek płatwi bez luzu | `rdzen/szczyty.rb#gniazda_sciany` |
| Fundament okrągły, rzędy w osiach działowych | `rdzen/fundamenty.rb` |
| Podciąg na równo z podwaliną | `rdzen/podciagi.rb`, `rdzen/podloga.rb#legary` |
| Typy 100–400 | `rdzen/parametry_lista.rb` (SZABLONY), opisy w `rdzen/parametry_*.rb`, `rdzen/przyklady.rb` |
| Wyrównanie ścięcia do granic pasów | `rdzen/sciecie_dachu.rb#wyrownaj!`, `rdzen/bryla.rb#sciecie_pasow` |

## 2. Runda 8

Uwagi i odpowiedzi – `docs/stan_prac.md` §5 „Runda 8”; zasady – `docs/specyfikacja.md` §8c.

## 3. Zasady

`CLAUDE.md` + `docs/skille/gw-zasady-kodu/SKILL.md` + `docs/skille/gw-runda/SKILL.md`.

## 4. Luki

- Kompilacje 7 i 8 niesprawdzone w prawdziwym SketchUpie – scenariusz odbioru 2a–2p.
- Wypuszczone wieńce okapowe nie są podawane aplikacji do dachów jako podpory (podpory – płatwie i ściany).
- Aplikacja do dachów – część 2 zadania bez zmian; Dokumentacja 2D – grupy Bs, Kf, Sz, F, Pb, Wt.

## 5. Następne kroki

Odbiór kompilacji 8 → poprawki → aplikacja do dachów (część 2) → Dokumentacja 2D (grupy) → schody i deski tarasu.
