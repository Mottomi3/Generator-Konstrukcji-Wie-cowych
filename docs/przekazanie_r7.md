# Przekazanie po rundzie 7 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`, publiczne) – `add_repo` (push) i
   `git clone https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych`. Zapas: `repozytorium_r7.bundle` na dysku
   (`C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\`).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md` (§1a – nowości kompilacji 7), ten plik; potem szukaj w
   `docs/SPIS_TRESCI.md`.
3. Aplikacja do dachów 3.7.0 lub nowsza obok repozytorium (`add_repo` Mottomi3/Aplikacja-do-konstrukcji-dach-w,
   `git clone … ../aplikacja-do-konstrukcji-dach-w`). `bash testy/uruchom.sh` → `WSZYSTKIE ZESTAWY: FAILURES 0`
   (ok. 8 min; Ruby 2.7 – `bash testy/ruby27.sh` zbuduje go, gdy nie ma `/opt/ruby27`, ok. 10 min). Nie edytuj
   `testy/uruchom.sh` w trakcie jego biegu (bash czyta skrypt kawałkami – błąd składni w połowie).
4. Raport z testu działania (`ArteMadera_GW_raport_*.json`): jak w `przekazanie_r3.md` §0.4 – 9 przykładowych domów.

## 1. Mapa plików (nowe w rundzie 7)

| Temat | Plik |
|---|---|
| Płatwie na pełnym balu (obniżenie dachu, przesunięcie pośrednich) | `rdzen/platwie_wience.rb` |
| Górny bal ścięty w poprzek do płaszczyzny dachu (ściana nośna, ściana wysoka, działowa wzdłużna) | `rdzen/sciecie_dachu.rb` |
| Zamki (wręby) w płatwiach | `rdzen/zamek_platwi.rb` |
| Styki w zamku działowej | `rdzen/styki_dzialowe.rb` |
| Węgły z tabeli i na środku ściany | `rdzen/wegly_tabela.rb`, `html/wegly.js` |
| Słupy tarasu z zamkami, szczyt nad tarasem | `rdzen/taras_slupy.rb`, `rdzen/taras_szczyt.rb` |
| Fundamenty punktowe, podciągi pod podwalinami | `rdzen/fundamenty.rb`, `rdzen/podciagi.rb` |
| Podbitka – pod / na płatwiach, pod / na krokwiach, nadbitka KROKU 2 | `rdzen/podbitka.rb` (uniesienie krokwi – `rdzen/dach.rb#uniesienie_krokwi`) |
| Parametry sekcji (dach i poszycie, podłoga, taras) | `rdzen/parametry_dach.rb`, `rdzen/parametry_podloga.rb`, `rdzen/parametry_taras.rb` |
| Okno: pola zależne, pytajniki z rysunkami, przeliczenia przy sekcjach | `html/zalezne.js`, `html/pomoc.js`, `html/przeliczenia.js` |
| Testy | `testy/t_podbitka.rb` (nowy), grupy „runda 7” w `t_szczyty`, `t_rdzen`, `t_wegly`, `t_taras`, `t_podloga`, `t_siatka`, `t_jednospadowy`, `t_okno.js`; `testy/losowe_domy.rb#dodatki_r7` (ziarna od 3000) |

## 2. Runda 7

Uwagi użytkownika z odbioru kompilacji 6 (26 punktów, 2026-11-01) i odpowiedzi – `docs/stan_prac.md` §5 „Runda 7”,
zasady – `docs/specyfikacja.md` §8b i §9a. Runda w trzech częściach (dwa zapisy „w toku” 2026-11-01/02 i zamknięcie
2026-11-02 z doprecyzowaną podbitką: także na płatwiach i na krokwiach).

## 3. Zasady

`CLAUDE.md` + `docs/skille/gw-zasady-kodu/SKILL.md` (kod) + `docs/skille/gw-runda/SKILL.md` (runda).

## 4. Luki

- Kompilacja 7 niesprawdzona w prawdziwym SketchUpie – scenariusz odbioru kroki 2a–2h.
- Podbitka „na płatwiach” z krokwiami z aplikacji: generator rysuje deski, połać i podpory podaje wyżej o grubość
  deski – aplikacja kładzie krokwie na deskach (sprawdzone na atrapie API, nie w prawdziwym KROKU 2).
- Aplikacja do dachów – część 2 zadania bez zmian (kalenica w obu połaciach, dach jednospadowy, osie krokwi przy
  szczycie, `:zapisz => false`).
- Dokumentacja 2D nie zna grup Bs, Kf, Sz, F (fundamenty), Pb (podbitka).

## 5. Następne kroki

Raport i scenariusz odbioru kompilacji 7 → poprawki → zmiany w aplikacji do dachów (część 2) → grupy w Dokumentacji 2D
→ szczegóły tarasu (schody, deski, osłona z listew 1200).
