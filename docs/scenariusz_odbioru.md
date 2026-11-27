# Odbiór – kompilacja 19

Trzy kroki. Nie trzeba niczego zapisywać ani wysyłać – wtyczka sama odkłada raport i dziennik pracy w folderze
`Dokumenty\ArteMadera Generator Konstrukcji Wieńcowych\raporty\`, a Claude czyta je stamtąd na początku następnej rozmowy.
(Na starcie rund 16–19 folderu `raporty\` nie było – kompilacje 14–18 nie były jeszcze uruchamiane w SketchUpie.)

## 1. Instalacja

SketchUp → Rozszerzenia → Menedżer rozszerzeń → Zainstaluj rozszerzenie → `arte_madera_generator_wiencowy_1.0.0.rbz`
(leży w folderze `Dokumenty\ArteMadera Generator Konstrukcji Wieńcowych\`). **Zamknij i uruchom SketchUpa ponownie.**
W menu Rozszerzenia → ArteMadera Generator Wieńcowy → „O wtyczce” ma być „Kompilacja 19”. Pasek „ArteMadera Generator
Wieńcowy” ma cztery przyciski; gdyby paska nie było – Widok → Paski narzędzi.

Aplikacja do dachów (ArteMadera Roof) 3.12.0 – bez zmian, zostaje ta, która jest.

## 2. Test działania – jedno kliknięcie

Pusty model → przycisk testu (kartka z zieloną strzałką). Po chwili okienko:

- **„WSZYSTKO W PORZĄDKU – 12 z 12 przykładowych domów”** – kompilacja działa, koniec odbioru.
- **„PROBLEMY w … z 12”** – napisz w rozmowie „test pokazał problemy”; szczegóły są w raporcie, który już leży w folderze.

Model po teście zostaje pusty.

## 3. Zwykła praca

Rysuj i generuj domy jak zawsze. Po każdym „Generuj” wtyczka dopisuje jeden wiersz do `raporty\dziennik_pracy.jsonl`.
Gdy coś wygląda źle, wystarczy jedno zdanie i zrzut ekranu.

## Co nowego warto zobaczyć w tej kompilacji (10 minut)

1. **Drewutnia z tyłu.** Prostokąt 7 × 5 m, krok „4. Dodatki” → „Drewutnia / zadaszenie przy ścianie szczytowej: na
   słupach” → „Generuj”. Przy ścianie szczytowej naprzeciw tarasu (bez tarasu – lewa albo dolna na rysunku) stoi wiata:
   dwa rzędy słupów, płatew i oczep, krokwie ze spadkiem 10°, grupa i tag „Drewutnia” (rysunek `docs\drewutnia_r19.png`).
   Sprawdź: słupy i krokwie nie dotykają ściany ani węgłów, wierzch krokwi pod płatwiami dachu domu. W „Wyniku” –
   wymiary, prześwit pod oczepem i nośność krokwi, płatwi i słupów. Z tarasem (Typ 200) drewutnia staje po drugiej stronie.
2. **Kosz domu L.** L 7,5 × 6,5 m ze skrzydłem 3 × 3 m, dach 35° → w „Wyniku” (sekcja „Szczyty i dach”) zdanie „Dom L –
   kosz: płatew skrzydła oddaje na płatew dachu głównego … kN, docisk … %”. Słupki w koszu jak w kompilacji 18.
3. **Kanał pod oknem.** Ściana z oknem → widok ściany → „kanał” → kliknij w miejscu okna → w okienku nowe pole „Puszka – od
   strony” → „Wstaw”. Pomarańczowy pas kończy się pod oknem, w „Wyniku” uwaga „trafia w otwór … tylko pod nim”.
4. **Test działania** ma teraz 12 domów (dwunasty – drewutnia z tarasem typu 300).

Dawny scenariusz (59 kroków, kompilacje 5–13) – `docs/scenariusz_archiwum.md`.
