# Odbiór – kompilacja 18

Trzy kroki. Nie trzeba niczego zapisywać ani wysyłać – wtyczka sama odkłada raport i dziennik pracy w folderze
`Dokumenty\ArteMadera Generator Konstrukcji Wieńcowych\raporty\`, a Claude czyta je stamtąd na początku następnej rozmowy.
(Na starcie rund 16–18 folderu `raporty\` nie było – kompilacje 14–17 nie były jeszcze uruchamiane w SketchUpie.)

## 1. Instalacja

SketchUp → Rozszerzenia → Menedżer rozszerzeń → Zainstaluj rozszerzenie → `arte_madera_generator_wiencowy_1.0.0.rbz`
(leży w folderze `Dokumenty\ArteMadera Generator Konstrukcji Wieńcowych\`). **Zamknij i uruchom SketchUpa ponownie.**
W menu Rozszerzenia → ArteMadera Generator Wieńcowy → „O wtyczce” ma być „Kompilacja 18”. Pasek „ArteMadera Generator
Wieńcowy” ma cztery przyciski; gdyby paska nie było – Widok → Paski narzędzi.

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
2. **Okna i drzwi w modelu.** Prostokąt 6 × 4 m, krok „Okna i drzwi” → „+ okno”, „+ drzwi” → „Generuj”. W otworach stoi prosty
   model (rama, szyba albo skrzydło, maskownice od zewnątrz – rysunek `docs\stolarka_prosta_r18.png`), grupa „Stolarka”.
   Podmiana: Standard warsztatu → sekcja „Okna i drzwi” → w liście „Typowa stolarka” przy O1 przycisk „…” w kolumnie
   „Model” → wybierz swój plik `.skp` (albo „Folder modeli stolarki” → „…”). Punkt 0 Twojego modelu: dolny lewy narożnik
   stolarki od zewnątrz, czerwona oś wzdłuż szerokości, zielona w głąb ściany.
3. **Kanał na przewody.** Ten sam dom, widok ściany W-1 → „Klik w widok wstawia: kanał” → kliknij w ścianę → okienko
   (od, średnica, puszka 300) → „Wstaw”. W widoku pomarańczowy pas z kółkiem puszki, pod tabelą okien lista kanałów.
   „Generuj” → bale ściany mają pionowy otwór w osi grubości (sprawdź przekrojem albo „Ukryj” kilku bali).
4. **Taras typu 300.** Typ 300 (albo „Taras: typ 300”) → front tarasu ma górne wieńce nad otworem i szczyt – płatwie nad
   tarasem leżą na szczycie frontu. Inaczej: „Typ 300 – front tarasu: otwarty”.
5. **Dom L ze słupkami w koszu.** Narysuj L np. 7,5 × 6,5 m z wąskim skrzydłem 3 × 3 m, dach 35° → „Generuj”. Pod końcami
   płatwi skrzydła, które kończą się w koszu, stoją słupki na płatwi dachu głównego (rysunek `docs\kosz_slupek_r18.png`).
6. **Długie płatwie.** Prostokąt 11 × 4 m z działową → płatwie ścienne podzielone nad węgłem / ścianą na kawałki do 8 m,
   w „Wyniku” zdanie o stykach płatwi.
7. **Przełącznik doboru w typie.** Typ 300 i 400 – „Przekroje konstrukcji – dobór: automatycznie”, Typ 100 i 200 – „podaję
   sam” (krok „Zestawienie”, sekcja „Magazyn drewna…”).

Dawny scenariusz (59 kroków, kompilacje 5–13) – `docs/scenariusz_archiwum.md`.
