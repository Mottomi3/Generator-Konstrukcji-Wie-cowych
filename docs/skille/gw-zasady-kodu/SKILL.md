---
name: gw-zasady-kodu
description: Zasady kodu wtyczki ArteMadera Generator Wieńcowy (jeden temat = jeden plik, spis treści, rdzeń bez API SketchUpa, Ruby 2.2, ES5, Log) – przed i po każdej zmianie kodu.
---

# Zasady kodu – ArteMadera Generator Wieńcowy

Używaj przy każdej zmianie w `Plugins/` i przed commitem.

## Szukanie miejsca zmiany

1. `docs/SPIS_TRESCI.md` §1 – temat → plik (np. „mijanka” → `rdzen/styki.rb`).
2. §3 tego pliku – metoda z numerem wiersza → `Read` z `offset` w okolicy wiersza.
3. Nie przeglądaj wielu plików „na wszelki wypadek” – jeśli temat jest w kilku plikach, to znak, że trzeba go
   wydzielić do jednego.

## Jeden temat = jeden plik (wymóg użytkownika)

- Zmiana jednej rzeczy dotyka jednego pliku. Nowa funkcja = nowy plik z nagłówkiem, gdy nie pasuje do tematów
  istniejącego pliku (patrz jego „Tematy:”).
- Nagłówek każdego pliku (`.rb`, `html/*`): `Plik:`, `Zadanie:`, `Tematy:` (po przecinku, małe litery),
  `Zależy od:`, `Używają:`. Nad każdą metodą Ruby i funkcją JS – komentarz jednym zdaniem (wchodzi do spisu).
- Plik > 450 wierszy – UWAGA, > 700 – BŁĄD kontroli: dziel według tematów.
- Stałe tematu w jego pliku (np. wymiary zamka – `rdzen/parametry_lista.rb` PRESETY, ułożenie lic – `rdzen/zamek.rb`
  ORIENTACJA). **Nowy parametr = jeden wpis w `LISTA` w `rdzen/parametry_lista.rb`** (klucz, domyślna, etykieta,
  jednostka, zakres, rodzaj, sekcja, wybory, podpowiedź) – okno samo doda pole w sekcji, wartość trafi do zapisanych
  ustawień i szablonów; potem `ruby testy/lista_parametrow.rb` (docs/parametry.md). Odczyt w kodzie tylko `p['klucz']`
  (przekroje: `Parametry.przekroj(p, 'klucz')`). Co tylko można – parametr, nie stała (wymóg użytkownika).
- Stara wartość parametru z wcześniejszej kompilacji (zapisana w modelach) → `STARE_WARTOSCI` w tym samym pliku.

## Warstwy

- `rdzen/` – czysty Ruby: mm, punkty jako tablice, bez `Sketchup::`, `Geom::`, `UI` (kontrola to sprawdza).
  Każdy plik rdzenia wczytuje swoje zależności przez `require … unless defined?(…)` (testy bez SketchUpa).
- `sketchup/` – API SketchUpa, cale (`Konwersja`), `Geom::Vector3d.new` jawnie, operacje w `start_operation`.
- Nowy plik `.rb` → `MODULE_FILES` w `main.rb` (kolejność zależności).

## Ruby 2.2 i JS ES5

- Bez `&.`, `Array#sum` (`inject(0.0) { |s, x| s + x }`), `dig`, `match?`, `transform_values`, `clamp`, `then`,
  `filter_map`, `<<~`, `floor(n)` / `ceil(n)`, `rescue` w `do…end` bez `begin`.
- Komunikaty tylko przez `Log` (`error`, `warn`, `info`, `time`); `puts` tylko w `log.rb`.
- JS okna: `var`, `function`, bez `let`, `const`, `=>`, szablonów, `class`; `window.onerror` → `sketchup.blad_js`.
- Zero placeholderów (`TODO`, `FIXME`, „reszta kodu”).

## Po zmianie

```bash
ruby testy/spis_tresci.rb          # spis treści (zawsze po zmianie kodu)
bash testy/uruchom.sh              # WSZYSTKIE ZESTAWY: FAILURES 0
```

Testy nowej funkcji: rdzeń – `testy/t_rdzen.rb` / `t_zamek.rb` / `t_siatka.rb` (albo nowy `t_<temat>.rb` dopisany do
`testy/uruchom.sh`), warstwa SketchUpa – `testy/t_sketchup.rb` (atrapa `testy/atrapa/sketchup.rb`), okno – `testy/t_okno.js`.
Geometria bali: każda nowa obróbka musi dać zamkniętą siatkę (`t_siatka.rb`) i zero kolizji (`Kontrola.kolizje`).
