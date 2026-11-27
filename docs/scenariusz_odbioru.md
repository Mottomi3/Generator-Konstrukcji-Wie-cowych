# Odbiór – kompilacja 17

Trzy kroki. Nie trzeba niczego zapisywać ani wysyłać – wtyczka sama odkłada raport i dziennik pracy w folderze
`Dokumenty\ArteMadera Generator Konstrukcji Wieńcowych\raporty\`, a Claude czyta je stamtąd na początku następnej rozmowy.
(Na starcie rund 16 i 17 folderu `raporty\` nie było – kompilacje 14–16 nie były jeszcze uruchamiane w SketchUpie.)

## 1. Instalacja

SketchUp → Rozszerzenia → Menedżer rozszerzeń → Zainstaluj rozszerzenie → `arte_madera_generator_wiencowy_1.0.0.rbz`
(leży w folderze `Dokumenty\ArteMadera Generator Konstrukcji Wieńcowych\`). **Zamknij i uruchom SketchUpa ponownie.**
W menu Rozszerzenia → ArteMadera Generator Wieńcowy → „O wtyczce” ma być „Kompilacja 17”. Pasek „ArteMadera Generator
Wieńcowy” ma teraz cztery przyciski (nowy: „Standard warsztatu” – bale z ekierką); gdyby paska nie było – Widok → Paski
narzędzi.

Aplikacja do dachów (ArteMadera Roof) 3.12.0 – bez zmian, zostaje ta, która jest.

## 2. Test działania – jedno kliknięcie

Pusty model → przycisk testu (kartka z zieloną strzałką). Po chwili okienko:

- **„WSZYSTKO W PORZĄDKU – 11 z 11 przykładowych domów”** – kompilacja działa, koniec odbioru.
- **„PROBLEMY w … z 11”** – napisz w rozmowie „test pokazał problemy”; szczegóły są w raporcie, który już leży w folderze.

Model po teście zostaje pusty.

## 3. Zwykła praca

Rysuj i generuj domy jak zawsze. Po każdym „Generuj” wtyczka dopisuje jeden wiersz do `raporty\dziennik_pracy.jsonl`.
Gdy coś wygląda źle, wystarczy jedno zdanie i zrzut ekranu.

## Co nowego warto zobaczyć w tej kompilacji (15 minut)

1. **Układ okna – wybór.** W nagłówku okna „Układ: nowy / dotychczasowy”. Napisz, przy którym zostajemy
   (zrzut obu: `docs\uklady_okna_r17.png`).
2. **Standard warsztatu z menu.** Rozszerzenia → ArteMadera Generator Wieńcowy → „Standard warsztatu…” (albo nowy przycisk
   paska): okno z samym standardem, bez zaznaczania domu. Na dole sekcji „Okna i drzwi” – tabela „Typowa stolarka”,
   w sekcji „Magazyn drewna, dobór przekrojów i ceny” – magazyn drewna (33 przekroje z deską 14 × 115), przełącznik
   „Przekroje konstrukcji”, cena bala, cennik materiałów. Dopisz np. okno O2, wpisz kilka cen, „Zapisz standard”.
3. **Okno kliknięciem.** Krok „Okna i drzwi” → nad widokiem ściany „Klik w widok wstawia: węgieł / okno / drzwi” → wybierz
   „okno” i kliknij w ścianę: okienko z typem z listy i wymiarami, „Wstaw”. Kliknij w otwór – „Zapisz” / „Usuń”; kliknij
   przy węgle – przesunięcie („od”) albo „Usuń”. Zrzut: `docs\klik_okno_r17.png`.
4. **Modele okien i drzwi** (gdy są): w standardzie „Folder modeli stolarki” = folder z plikami `.skp`; plik o nazwie
   symbolu (np. `O1.skp`) albo nazwa w kolumnie „Model”. Otwór z typem dostaje model przy „Generuj” (grupa „Stolarka”,
   tag Stolarka). Sprawdź, czy model siedzi w otworze od zewnątrz – punkt 0 modelu w dolnym lewym narożniku stolarki.
5. **Styk zawsze w zamku.** Rysunek `docs\styk_w_zamku_r17.png`: działowa przy podbitce pod płatwiami dochodzi przy ścianie
   okapowej pełnym balem (deski przerwane na ok. 30 cm), węgieł w domu L dochodzi do spodu płatwi.
6. **Dom z wymiarów z działowymi.** Pusty model, nic nie zaznaczone → generator: w kroku „Ściany” karta „Ściany działowe” –
   „+ ściana działowa”, wpisz „od lica” i ewentualnie długość.
7. **Wycena.** Krok „Zestawienie” → „Wycena materiału”: bez cen – zdanie, gdzie je wpisać; z cenami – tabela, suma i liczba
   „Materiał” w „Wyniku”; w pliku CSV blok „Wycena”.

Dawny scenariusz (59 kroków, kompilacje 5–13) – `docs/scenariusz_archiwum.md`.
