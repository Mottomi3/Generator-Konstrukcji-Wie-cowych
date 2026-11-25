---
name: gw-runda
description: Start i zamknięcie rundy prac nad wtyczką ArteMadera Generator Wieńcowy – repozytorium lub pliki z dysku, testy bazowe, numer kompilacji, .rbz, dokumenty, commit, kopia na dysk i do Projektu.
---

# Runda prac – ArteMadera Generator Wieńcowy

Każda sesja, w której zmieniasz kod. Odpowiedzi do użytkownika po polsku, krótko. Zasady kodu – skill `gw-zasady-kodu`.

## Stałe

| Co | Gdzie |
|---|---|
| Repozytorium | `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`); użytkownik chce prywatnego (2026-11-25) – stan w najnowszym `przekazanie_rN.md` §0 |
| Kontener | `/home/claude/gw` (testy liczą ścieżki względem siebie – katalog może być inny) |
| Dysk użytkownika | `C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\` – `Plugins\`, `testy\`, `docs\` (z `docs\skille\`), `CLAUDE.md`, `README.md`, paczka `.rbz`, `repozytorium_rN.bundle` (historia git); obok `00_Analiza\`, `Pliki źródłowe\` (nie ruszać) |
| Projekt claude.ai | `claude/stan_prac.md`, `claude/przekazanie_rN.md`, `claude/specyfikacja.md`, `claude/scenariusz_odbioru.md`, `claude/parametry.md`, `claude/decyzje_projektowe.md`, `claude/analiza_plikow_zrodlowych.md`, `claude/zadanie_*.md` |
| Wersja | 1.0.0; **numer kompilacji = numer rundy** |

## A. Start

1. Kontekst: `CLAUDE.md`, `docs/stan_prac.md` (stan bieżący; historia w `docs/historia_rund.md` – tylko gdy potrzebna),
   najnowsze `docs/przekazanie_rN.md`; nowa runda N = ostatnia + 1. **Najpierw kolejka z `stan_prac.md` §5** (zaległe
   poprawki i decyzje), potem nowe prośby.
1a. Raporty z dysku (od rundy 14): `device_request_folder_access` na folder z tabeli „Stałe”, potem w `raporty\` najnowszy
   `raport_*.json` (pole `wynik`, `przyklady[].czas_budowy_s`) i `dziennik_pracy.jsonl` (czasy z prawdziwej pracy,
   ustawienia zmienione przez użytkownika, awarie). Awaria albo dom z problemem = pierwsza pozycja rundy.
2. Kod: `add_repo` (push); gdy odpowiada „already attached”, repozytorium jest już w
   `/home/claude/generator-konstrukcji-wie-cowych` (`git rev-parse HEAD`) – nie klonuj drugi raz. Inaczej
   `git clone https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych` (pełna historia).
   Gdy repozytorium nie istnieje: `device_list_dir` na folderze z dysku, `device_stage_files` pliku `repozytorium_rN.bundle`
   (najnowszy) i `git clone repozytorium_rN.bundle /home/claude/gw` – pełna historia; brak paczki → pliki z `Plugins\`,
   `testy\`, `docs\`, `CLAUDE.md` i `git init -b main`.
3. Zgodność z dyskiem: `PLUGIN_BUILD` w `Plugins\arte_madera_generator_wiencowy.rb` na dysku = w kodzie; inaczej zapytaj.
4. `bash testy/uruchom.sh` → `WSZYSTKIE ZESTAWY: FAILURES 0` (ok. 13 min na 2 rdzeniach – uruchamiaj na kopii katalogu
   w tle z `AM_GW_APLIKACJA_DACHOW=<ścieżka aplikacji>` i pracuj dalej; aplikacja do dachów obok repozytorium –
   `../aplikacja-do-konstrukcji-dach-w` – do zestawu „dach_aplikacja”). Zależności: ruby, node, playwright
   (`PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers`, `NODE_PATH=$(npm root -g)`), acorn, zip, python3 + matplotlib (podgląd).
5. Lista zadań (TaskCreate); ostatnie – sprawdzenie i zapis.

## B. W trakcie

- Zapisuj na dysk po każdym skończonym kawałku (krok C6), nie tylko na końcu.
- Po każdej zmianie kodu `ruby testy/spis_tresci.rb`.
- Podgląd 3D domu testowego: `ruby -I testy/atrapa testy/podglad.rb dom.obj dom900 && python3 testy/podglad.py dom.obj dom.png`.

## C. Zamknięcie

1. Data z `current_time`; `PLUGIN_BUILD` i `PLUGIN_BUILD_DATE` w rejestratorze **i** `main.rb`.
2. `ruby testy/spis_tresci.rb`, `bash testy/uruchom.sh` → FAILURES 0 (zanotuj liczbę sprawdzeń z `testy/wyniki/*.txt`).
3. `ruby testy/buduj_rbz.rb` → `arte_madera_generator_wiencowy_1.0.0.rbz` w katalogu głównym.
4. Dokumenty: `docs/stan_prac.md` (nagłówek, §1 „Nowe w kompilacji N” – poprzednie §1 przenieś do
   `docs/historia_rund.md`; §5 kolejka decyzji, §6 pytania, §8 ograniczenia, §9 plan), `docs/przekazanie_rN.md`,
   `docs/scenariusz_odbioru.md` (krótki: instalacja, test działania, co nowego obejrzeć), `docs/specyfikacja.md` przy
   zmianie zasad. `stan_prac.md` ma zostać krótki – historia do `historia_rund.md`.
5. Commit `rN: <co zrobiono>` z wynikiem testów i stopką z przypomnienia systemowego; `git push origin main`
   (gdy repozytorium istnieje). Bez znaczników.
6. Dysk – najprościej przez paczkę (od rundy 15): `git bundle create repozytorium_rN.bundle --all` → kopia do
   `/mnt/user-data/outputs/gw/` → `device_commit_files` (jeden plik) → w `device_bash`: `git clone` paczki do katalogu
   roboczego i `cp -r Plugins testy docs CLAUDE.md README.md *.rbz` do folderu z dysku (usuwanie na dysku jest wyłączone;
   plik usunięty w repozytorium trzeba zgłosić użytkownikowi). Bez `device_bash`: `device_list_dir` (rekurencyjnie) →
   kopie plików do `/mnt/user-data/outputs/gw/<ścieżka>` → `device_commit_files` (≤ 50 plików na wywołanie). Na koniec
   `PLUGIN_BUILD` na dysku = numer rundy.
7. Projekt: `project_write` dokumentów z tabeli „Stałe”.
8. Odpowiedź: co zmieniła runda, kompilacja N, które kroki scenariusza odbioru sprawdzić (zainstalować `.rbz`,
   zrestartować SketchUpa), decyzje do podjęcia.
