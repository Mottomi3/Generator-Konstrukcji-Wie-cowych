# Przekazanie po rundzie 1 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: jeśli użytkownik założył `Mottomi3/ArteMadera-Generator-Wiencowy` – `add_repo` (push) i sklonuj;
   jeśli nie – pliki z dysku: `C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\` (`Plugins\`,
   `testy\`, `docs\`, `CLAUDE.md`, paczka .rbz) – skopiuj do kontenera i `git init` (historia rundy 1 jest w
   `docs/stan_prac.md`).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md`, ten plik; potem szukaj w `docs/SPIS_TRESCI.md`.
3. `bash testy/uruchom.sh` → `WSZYSTKIE ZESTAWY: FAILURES 0` przed jakąkolwiek zmianą.

## 1. Mapa plików

Pełna w `docs/SPIS_TRESCI.md`. Skrót: rdzeń `rdzen/` (projekt.rb – przebieg; obrys, sciany, wience, otwory, styki,
bale, zamek, bryla, siatka, pozycje, kontrola, parametry, geometria), SketchUp `sketchup/` (sterowanie, wejscie,
budowa, atrybuty, konwersja, okno, menu), okno `html/`.

## 2. Runda 1

Pierwsza wersja całej ścieżki: linie → okno → dom z bali z zamkami, kontrforami, stykami na mijankę, otworami →
komponenty z atrybutami Dokumentacji 2D; przebudowa z parametrów. Testy offline: rdzeń 137, zamek 22, siatki 9,
SketchUp (atrapa) 45, okno w Chromium 16, zasady i spis treści.

## 3. Zasady

`CLAUDE.md` + `.claude/skills/gw-zasady-kodu/SKILL.md` (kod) + `.claude/skills/gw-runda/SKILL.md` (runda).

## 4. Luki

Brak odbioru w prawdziwym SketchUpie (rysowanie ścian z otworami metodą „dorysuj i usuń” nie jest sprawdzone poza
atrapą). Otwarte pytania – `docs/stan_prac.md` §6.

## 5. Następne kroki

Odbiór kompilacji 1 (`docs/scenariusz_odbioru.md`) → poprawki → szczyty z gniazdami (runda 2 lub 3).
