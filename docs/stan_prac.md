# Stan prac – ArteMadera Generator Wieńcowy

Stan na: runda 1, kompilacja 1 (2026-10-13), wersja 1.0.0. Testy: `bash testy/uruchom.sh` – 7 zestawów, 229 sprawdzeń,
FAILURES 0. Repozytorium: lokalne (git, gałąź `main`); zdalne `Mottomi3/ArteMadera-Generator-Wiencowy` do założenia
przez użytkownika (sesja nie ma uprawnień do tworzenia repozytoriów).

## 1. Co działa (kompilacja 1)

- Rozpoznanie linii: obrys (lico zewnętrzne), osie działowych, kontrfory z krótkich linii; scalanie linii dzielonych
  przez SketchUpa, dociąganie końców (tolerancja), dowolny obrót domu w modelu, obrys wielokątny (L, U…).
- Ściany zewnętrzne, działowe (T, X, wolny koniec), kontrfory jako ściany W-n; ostatki 100; numeracja jak producent.
- Wieńce: półbal na ścianach wzdłuż kalenicy, szczytowe o wieniec wyżej (pierwszy bal szczytu).
- Zamek 44 × 146 wg rysunku na każdym skrzyżowaniu; sprawdzony testem kolizji (0 kolizji, luzy 2,5 i 0,5).
- Styki na mijankę ≥ 300 jak w 900 W-2 (dwa skrzyżowania, styk w osi zamka, na przemian), dostawianie kontrforów,
  wariant „jeden kontrfor”.
- Otwory: przecięcia i wycięcia bali, kontrfory przerwane przy otworach, ostrzeżenia.
- Pozycje „nr-długość”, jeden komponent na pozycję, lista bali (przekrój, długość, ilość, m³), waga.
- Model: Dom > W-n > komponenty z prawdziwymi wycięciami (bryły zamknięte), tagi, atrybuty Dokumentacji 2D, zapis
  parametrów, przebudowa, wykrywanie ręcznych zmian, jedno „Cofnij”.
- Okno: formularz z opisów pól, wymiary zamka, rzut z numerami ścian, okna i drzwi, wynik na żywo.
- Menu: Generuj / edytuj, Kontrola (kolizje, mijanka, długości), O wtyczce.

## 2. Jak to działa

Opis zasad: `docs/specyfikacja.md`. Mapa kodu: `docs/SPIS_TRESCI.md` (generowany). Przebieg obliczeń:
`rdzen/projekt.rb#oblicz` (obrys → ściany → numeracja → otwory → styki (kontrfory) → numeracja → bale → zamki → pozycje).

## 3. Zasady (stałe)

- Jeden temat = jeden plik; nagłówek pliku (Plik, Zadanie, Tematy, Zależy od, Używają); komentarz nad każdą metodą
  i funkcją JS; plik > 450 wierszy – podział (> 700 – błąd kontroli).
- `docs/SPIS_TRESCI.md` tylko z generatora (`ruby testy/spis_tresci.rb`), kontrola aktualności w testach.
- Rdzeń bez API SketchUpa; API tylko w `sketchup/`. Ruby 2.2, JS ES5, `Log`, zero placeholderów.
- Nowy parametr: `rdzen/parametry.rb` (DOMYSLNE + OPISY) – okno samo doda pole; sekcję okna wskazuje `SEKCJE` w `html/okno.js`.
- Numer kompilacji = numer rundy, ten sam w rejestratorze i `main.rb`.
- Grupy domu i ścian bez roli Dokumentacji 2D (rola „skip” na grupie wyłącza zawartość).

## 4. Moduły

Patrz `docs/SPIS_TRESCI.md` §2 (lista plików z zadaniami i liczbą wierszy).

## 5. Co zrobiła runda 1

- Szkielet wtyczki, dziennik, rdzeń (13 plików), warstwa SketchUpa (7), okno (3), testy z atrapą API, kontrola zasad,
  generator spisu treści, paczka .rbz, podgląd 3D domu testowego (`testy/podglad.rb` + `podglad.py`).
- Decyzja o stykach: przyjęty układ z 900 W-2 (styk w osi zamka, dwa kontrfory na przemian). W rozmowie poprzednio
  opisałem 900 W-2 jako „styk 150 obok jednego kontrforu” – to było błędne; wariant z jednym kontrforem jest w opcjach.

## 6. Otwarte pytania (przyjęte wartości domyślne – do potwierdzenia)

| # | Pytanie | Przyjęto |
|---|---|---|
| A1 | Czy zamek na obrazku `zamek_interpretacja.png` / w modelu to Twój zamek | tak, wg rysunku; test kolizji potwierdza ułożenie |
| A2 | Czerwone „62” przy środku 67 | gniazda 36 (środek 67) |
| A3 | Profil bala (pióra, wpust, fazy) | bal prosty; profil w późniejszej rundzie |
| A5 | Kiedy ostatek 200 | parametr wspólny dla całego domu |
| A6 | Półbal 70 / 73, na których ścianach | bryła 69,5 (lista 70), ściany wzdłuż kalenicy |
| C9 | Układ styków | dwa skrzyżowania co 400, styk w osi zamka (jak 900 W-2) |
| D11 | „1020 (1010)” – otwór w balach czy ościeżnica, luz | otwór w balach, luz osiadania 0 |
| D12 | Poziom ±0 | spód pierwszego bala |
| – | Narożnik wklęsły (obrys L): ostatki do środka? | tak, z ostrzeżeniem |
| H20 | Grupy w Dokumentacji 2D | Bs – bale ścienne, Kf – kontrfory (Sz – szczyty później) |
| H21 | Producent / CNC: co dostaje, BVN czy BTLx | do ustalenia przy eksporcie |
| I23 | Repozytorium | użytkownik zakłada puste prywatne `Mottomi3/ArteMadera-Generator-Wiencowy` |

## 7. Do sprawdzenia w SketchUpie (pierwszy odbiór)

`docs/scenariusz_odbioru.md` – szczególnie: czy bryły bali są pełne (bez dziur i zbędnych krawędzi), czy otwory w
ścianach czołowych rysują się poprawnie (sztuczka „dorysuj i usuń”), czas generowania dużego domu, wygląd okna.

## 8. Ograniczenia (kompilacja 1)

- Tylko ściany pod kątem prostym; linie ukośne – błąd.
- Bez szczytów, tarasu, podłogi, pełnego profilu bala, okna ściany z elewacją, eksportu list.
- Dokumentacja 2D nie zna jeszcze prefiksów Bs / Kf (bale będą w grupie „Elementy”, dopóki ich nie dopiszemy).
- Bal przecięty otworem w środku swojej wysokości (otwór niższy niż bal) – traktowany jak przecięty w całości.

## 9. Plan kolejnych rund

1. Odbiór kompilacji 1 w SketchUpie i poprawki (raport z modelu).
2. Szczyty: bale ścięte pod kątem dachu, gniazda pod płatwie / krokwie (wybór układu dachu), kąt i przekroje w oknie.
3. Okno ściany: lista otworów z podglądem elewacji, otwory przeciąganiem; ostatek 200 na wybranych narożnikach.
4. Taras: wysunięte górne bale, słupy, balustrada z odcinków.
5. Dokumentacja 2D: grupy Bs / Kf / Sz, karty bali ściennych, listy do producenta.
6. Podwaliny, legary, ocieplenie, elewacja (opcje); pełny profil bala do wizualizacji.
7. Etap 2: dach (płatwie, krokwie, okapy).
