# Przekazanie po rundzie 2 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (prywatne, gałąź `main`) – `add_repo` (push) i
   `git clone https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych`. Zapas: `repozytorium_r2.bundle` na dysku
   (`C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\`).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md`, ten plik; potem szukaj w `docs/SPIS_TRESCI.md`.
3. `bash testy/uruchom.sh` → `WSZYSTKIE ZESTAWY: FAILURES 0` przed jakąkolwiek zmianą.

## 1. Mapa plików (nowe i zmienione w rundzie 2)

| Temat | Plik |
|---|---|
| Lista parametrów, sekcje, podpowiedzi, presety, szablony wbudowane | `rdzen/parametry_lista.rb` |
| Sprawdzanie parametrów, przekroje „50x150”, katalog | `rdzen/parametry.rb` |
| Łączenia: na przemian / para / jeden węgieł | `rdzen/styki.rb` |
| Węgły usztywniające (światło ściany) | `rdzen/usztywnienie.rb` |
| Linia dachu, płatwie, krokwie, belki dachu | `rdzen/dach.rb` |
| Szczyty: wieńce, skos, gniazda płatwi, prefiks Sz | `rdzen/szczyty.rb` |
| Belki (położenie, pozycje, lista) | `rdzen/elementy.rb` |
| Statyka belki, dobór przekroju | `rdzen/statyka.rb` |
| Podłoga: podwaliny, legary, podpory, podpowiedzi | `rdzen/podloga.rb` |
| Zapamiętane ustawienia i szablony (plik JSON) | `sketchup/ustawienia.rb` |
| Okno: sekcje, podpowiedzi, szablony | `sketchup/okno.rb`, `html/okno.js` |
| Budowa belek, tagi Szczyty / Podłoga / Dach | `sketchup/budowa.rb`, `sketchup/konwersja.rb` |

## 2. Runda 2

Wymóg użytkownika: wszystko jako parametry w ustawieniach, zapamiętane między uruchomieniami SketchUpa; krokwie przy
szczycie z obu stron albo z jednej; mądra podłoga z przekrojami minimalnymi / zalecanymi i podpowiedziami, dobór wg
izolacji; zapis na dysku i na GitHubie. Testy: rdzeń 142, węgły 51, szczyty 67, podłoga 39, zamek 22, siatki 11,
SketchUp (atrapa) 66, okno w Chromium 26, zasady, spis treści, lista parametrów.

## 3. Zasady

`CLAUDE.md` + `docs/skille/gw-zasady-kodu/SKILL.md` (kod) + `docs/skille/gw-runda/SKILL.md` (runda).

## 4. Luki

- Brak odbioru w prawdziwym SketchUpie (kompilacje 1 i 2) – bryły szczytów i belek ukośnych sprawdzone tylko na atrapie
  i w podglądzie 3D (`testy/podglad.rb pelny900 | krokwie` + `podglad.py … szczyt`).
- Położenie płatwi ściennej i wysokość linii dachu w 900 nie są jednoznaczne w rysunkach – parametry
  `platwa_scienna_polozenie`, `dach_podniesienie` (pytanie S1 w `stan_prac.md`).

## 5. Następne kroki

Odbiór kompilacji 2 (`docs/scenariusz_odbioru.md`) → poprawki → okno ściany (elewacja) albo taras – wg użytkownika.
