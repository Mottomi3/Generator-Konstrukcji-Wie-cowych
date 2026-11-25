# Przekazanie po rundzie 14 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`) – `add_repo` (push) i
   `git clone https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych`. **Użytkownik chce repozytorium prywatnego**
   (2026-11-25) – wynik przełączenia w §5 tego pliku. Sprawdzenie: jeśli `add_repo` z dostępem „read” odpowiada „public
   repository”, repozytorium nadal jest publiczne.
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md` (krótki – stan bieżący, §5 kolejka decyzji, §6 pytania), ten plik,
   `docs/zadanie_r15.md`; potem `docs/SPIS_TRESCI.md`. Historia rund 1–13 – `docs/historia_rund.md` (tylko gdy potrzebna).
3. **Folder na dysku jest dostępny**: `device_request_folder_access` na
   `C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych`. Najpierw `raporty\`: najnowszy
   `raport_*.json` (pole `wynik`; `przyklady[].czas_budowy_s`) i `dziennik_pracy.jsonl` (czasy budowy z prawdziwej pracy,
   ustawienia zmienione przez użytkownika, awarie). W rundzie 14 folder dostał kompilację 14 (wcześniej stała tam 11 –
   rundy 12 i 13 nie miały dostępu do dysku).
4. Aplikacja do dachów obok repozytorium (`../aplikacja-do-konstrukcji-dach-w`, `add_repo` read; 3.12.0).
   `bash testy/uruchom.sh` → `WSZYSTKIE ZESTAWY: FAILURES 0` (ok. 10 min – na kopii repozytorium).
5. Domy złożone: `ruby -I testy/atrapa testy/zlozone_domy.rb 120 10001` (ok. 100 s) – 0 problemów.
6. Nie było Rubiego 2.7 (`/opt/ruby27`) – zestaw „Ruby 2.7” pominięty (kontrola zasad Ruby 2.2 przechodzi).

## 1. Mapa plików (nowe i zmienione w rundzie 14)

| Temat | Plik |
|---|---|
| Działowa w linii ściany obrysu (dom L – linia uskoku) | `rdzen/sciana_w_linii.rb` (nowy), `rdzen/sciany.rb#dzialowe` |
| Linia działowej przez wcięcie obrysu, kawałek na boku obrysu | `rdzen/obrys.rb#przytnij_do_obrysu` (zwraca listę odcinków) |
| Narożnik wklęsły jako podpowiedź | `rdzen/sciany.rb#podpowiedz_wklesle`, `rdzen/projekt.rb#przebieg` (podpowiedzi ścian, sekcja „sciany”) |
| Kontrola ścian równoległych i ostrzeżenie | `rdzen/kontrola_rownoleglych.rb` (nowy), `rdzen/kontrola.rb#wszystko`, `rdzen/projekt.rb#przebieg`, `sketchup/sterowanie.rb#kontrola` |
| Komunikat zamiast wyjątku | `rdzen/awaria.rb` (nowy), `rdzen/projekt.rb#oblicz`, `sketchup/sterowanie.rb#okienko_awarii` |
| Podpowiedzi podłogi | `rdzen/podloga.rb#bez_podciagow`, `rdzen/podciagi.rb#sprawdzenie`, `#na_styk?`, `ZAPAS` |
| Wykaz drewna z hurtowni, zapis listy z długościami | `rdzen/wykaz_drewna.rb` (nowy), `rdzen/parametry.rb#katalog`, `#dlugosci_katalogu`, listy fabryczne w `rdzen/parametry_podloga.rb`, `parametry_dach.rb`, `parametry_zadaszenie.rb` |
| Długości handlowe: podpowiedź i dobór w całej długości | `rdzen/dlugosci_handlowe.rb` (nowy), `rdzen/statyka_dachu.rb#dobierz`, `#platwie` (pole `dl`), `rdzen/statyka_zadaszenia.rb#dobierz`, `rdzen/projekt.rb#belki` |
| Plik ustawień wersja 3 (stare listy przekrojów) | `sketchup/ustawienia.rb` (WERSJA, LISTY_PRZEKROJOW, DO_FABRYCZNYCH_W_SZABLONACH) |
| Pasek narzędzi, menu pod prawym przyciskiem, ikony | `sketchup/pasek.rb` (nowy), `ikony/*.svg`, `ikony/*_24.png`, `*_32.png`, `main.rb`, `sketchup/menu.rb#o_wtyczce` |
| Folder raportów, dziennik pracy, raport zapisywany sam | `sketchup/dziennik_pracy.rb` (nowy), `sketchup/raport.rb#uruchom`, `#wynik`, `#podsumowanie`, `sketchup/sterowanie.rb#generuj`, `#ostatni_czas` |
| Testy | `testy/t_zlozone.rb`, `testy/zlozone_domy.rb`, `testy/t_dlugosci.rb` (nowe); grupy rundy 14 w `t_sketchup`, `t_raport`, `t_podloga`, `t_rdzen`; `testy/losowe_domy.rb#sprawdz` (ściany równoległe); `testy/atrapa/sketchup.rb` (UI::Command, UI::Toolbar, menu kontekstowe, zaznaczenie przeglądalne) |
| Dokumenty | `docs/stan_prac.md` (odchudzony), `docs/historia_rund.md`, `docs/pytania_otwarte.md`, `docs/scenariusz_odbioru.md` (trzy kroki), `docs/scenariusz_archiwum.md`, `docs/zadanie_r15.md`, `docs/specyfikacja.md` §8i |

## 2. Runda 14

Prośba – `docs/zadanie_r15.md` (cytat) i `docs/stan_prac.md` §1; zasady – `docs/specyfikacja.md` §8i.

Najważniejsze ustalenie rundy: jednowierszowa poprawka działowej z 14 listopada (pomijanie ścian równoległych) usuwała
wyjątek, ale zostawiała **bale dwóch ścian w tym samym miejscu** – dawna kontrola patrzyła tylko na zamki ścian
prostopadłych. Stąd nowa kontrola ścian równoległych i szersza poprawka (wspólna oś, styk w zamku ściany poprzecznej).
Nowa kontrola pokazała też ten sam błąd przy linii działowej prowadzonej przez wcięcie obrysu U / H.

Liczby: 120 losowych domów złożonych – przed rundą 19 wyjątków, po rundzie 0 problemów. Zestaw stały: 28 zestawów.

Nowych parametrów nie ma. Zmienione wartości fabryczne pięciu list przekrojów (z długościami); plik ustawień wersja 3.
Dobór płatwi i członów zadaszenia może dać inny przekrój niż w kompilacji 13, gdy najlżejszy wystarczający nie jest
dostępny w całej długości belki.

## 3. Zasady

`CLAUDE.md` + `docs/skille/gw-zasady-kodu/SKILL.md` + `docs/skille/gw-runda/SKILL.md`. Z tej rundy:
- Zaległości przed nowymi funkcjami – kolejka `docs/stan_prac.md` §5; na starcie rundy raporty z dysku.
- Poprawka „usuwa wyjątek” to za mało – po niej `LosoweDomy.sprawdz` (kolizje, ściany równoległe, bryły zamknięte).
- Nowa lista przekrojów albo dobór – przez `WykazDrewna` i `DlugosciHandlowe.najlzejszy`, nie własne parsowanie.
- Podpowiedź z rdzenia do sekcji okna: `{ poziom:, tekst:, sekcja: }` w `plan[:podpowiedzi]`.
- `docs/stan_prac.md` zostaje krótki: przy zamknięciu rundy poprzednie §1 przenieść do `docs/historia_rund.md`.

## 4. Luki

- W prawdziwym SketchUpie niesprawdzone: pasek narzędzi i ikony SVG, menu pod prawym przyciskiem, zapis raportu do folderu
  w Dokumentach (ścieżka z polskimi znakami), okienko po awarii. Wszystko przechodzi na atrapie API.
- Kompilacje 7–13 nadal bez formalnego odbioru – od rundy 14 zastępuje go raport z testu działania i dziennik pracy.
- Działowa w linii ściany: styk w zamku we wszystkich wieńcach, bez bala ciągłego przez węzeł; obrys Z (ściany po
  przeciwnych stronach linii) – oś pierwszej ściany.
- Dobór w całej długości tylko dla płatwi i zadaszenia; łączenia belki dłuższej niż handlowa generator nie rysuje.
- Przekroje fabryczne spoza wykazu (krokiew 50 × 150, legar ręczny 50 × 100, podciąg 100 × 150) i deski – runda 16.
- Ze wcześniejszych: przybudówka – płatwie zadaszenia tylko na ścianach szczytowych (Z9); dom L + podbitka na płatwiach
  + krokwie z aplikacji (ziarna 7004, 7021); słupy tarasu a płatew ścienna na ścianie (8064).

## 5. Repozytorium prywatne – stan

Użytkownik: „przełączyć trzeba na prywatne” (2026-11-25 19:00). Z sesji się nie dało: `gh` nie ma ważnego tokenu, a strona
ustawień repozytorium w przeglądarce wbudowanej wymaga zalogowania użytkownika do GitHuba (404 bez logowania). Użytkownik
dostał instrukcję: GitHub → repozytorium → Settings → General → na dole „Danger Zone” → Change repository visibility →
Change to private. Dostęp sesji z prawem zapisu (`add_repo` push) działa także dla repozytorium prywatnego. Repozytorium
aplikacji do dachów wygląda na prywatne (sesja dołącza je z poświadczeniami, bez dostępu anonimowego).

## 6. Następne kroki

Runda 15: trzy poziomy ustawień z typami domów zapisywanymi przez użytkownika + okno z wynikiem zawsze na widoku
(`docs/zadanie_r15.md` §1–2) – przed kodem pokazać użytkownikowi podział pól na poziomy i szkic okna. Runda 16: klikanie
okien z okienkiem parametrów, magazyn drewna, deski. Runda 17: pół zamka (po odpowiedzi na T8), podgląd na żywo po
odczytaniu czasów budowy. Pytania do użytkownika – `docs/stan_prac.md` §6.
