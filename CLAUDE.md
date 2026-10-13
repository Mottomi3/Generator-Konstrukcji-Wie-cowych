# ArteMadera – Generator Wieńcowy (wtyczka SketchUp 2023)

Generator domów z bali 44 mm (konstrukcja wieńcowa): z narysowanego obrysu tworzy ściany z bali z zamkami narożnymi,
kontrforami i stykami na mijankę; każdy bal to komponent z atrybutami dla wtyczki Dokumentacja 2D.
Odpowiedzi dla użytkownika zawsze po polsku, krótko, bez opisu kroków pracy.

## Zanim zmienisz kod

1. Przeczytaj `docs/stan_prac.md` (stan, decyzje, otwarte pytania) i najnowsze `docs/przekazanie_rN.md`.
2. **Szukaj w `docs/SPIS_TRESCI.md`**: tabela tematów → plik, potem lista metod z numerami wierszy. Nie przeszukuj
   wszystkich plików na ślepo.
3. Zasady kodu i rundy: `docs/skille/gw-zasady-kodu/SKILL.md`, `docs/skille/gw-runda/SKILL.md`.

## Najważniejsze zasady (wymóg użytkownika)

- **Jeden temat = jeden plik.** Zmiana jednej rzeczy (np. wymiary zamka, układ styków, okno otworów) ma dotykać jednego
  pliku. Nowy temat → nowy plik (z nagłówkiem), nie dopisek w cudzym pliku. Plik > 450 wierszy → podziel.
- **Spis treści** `docs/SPIS_TRESCI.md` jest generowany ze źródeł: nagłówki plików (`Plik:`, `Zadanie:`, `Tematy:`,
  `Zależy od:`, `Używają:`) i komentarz nad każdą metodą / funkcją. Po każdej zmianie: `ruby testy/spis_tresci.rb`.
- Rdzeń (`rdzen/`) to czysty Ruby bez API SketchUpa (mm, tablice) – testowany bez atrapy. API SketchUpa tylko w `sketchup/`.
- Ruby 2.2 (bez `&.`, `Array#sum`, `<<~`, `rescue` w `do…end` bez `begin`…), JS w oknie ES5, komunikaty przez `Log`,
  zero placeholderów. Kontrola: `ruby testy/sprawdz_zasady.rb`.
- Każda runda: numer kompilacji = numer rundy (rejestrator i `main.rb`), wersja 1.0.0.

## Testy

`bash testy/uruchom.sh` → ostatnia linia `WSZYSTKIE ZESTAWY: FAILURES 0` (rdzeń, zamek, siatki, SketchUp na atrapie,
okno w Chromium, zasady, aktualność spisu treści). Paczka: `ruby testy/buduj_rbz.rb`.

## Mapa katalogów

| Katalog | Co |
|---|---|
| `Plugins/arte_madera_generator_wiencowy.rb` | rejestrator rozszerzenia |
| `Plugins/arte_madera_generator_wiencowy/rdzen/` | obliczenia: obrys → ściany → otwory → styki → bale → zamki → pozycje → siatki brył |
| `Plugins/arte_madera_generator_wiencowy/sketchup/` | wejście z zaznaczenia, budowa modelu, atrybuty, okno, menu |
| `Plugins/arte_madera_generator_wiencowy/html/` | okno parametrów (HTML, CSS, JS ES5) |
| `testy/` | testy, atrapa API (`testy/atrapa/`), kontrola zasad, spis treści, paczka .rbz, podgląd 3D |
| `docs/` | spis treści, specyfikacja, stan prac, scenariusz odbioru, przekazania |

Pliki źródłowe projektów (PDF, zdjęcia, BVN) są na dysku użytkownika:
`C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\Pliki źródłowe\`, analiza w `00_Analiza\`.
