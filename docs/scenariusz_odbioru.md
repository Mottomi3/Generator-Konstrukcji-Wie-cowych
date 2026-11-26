# Odbiór – kompilacja 16

Trzy kroki. Nie trzeba niczego zapisywać ani wysyłać – wtyczka sama odkłada raport i dziennik pracy w folderze
`Dokumenty\ArteMadera Generator Konstrukcji Wieńcowych\raporty\`, a Claude czyta je stamtąd na początku następnej rozmowy.
(Na starcie rundy 16 folderu `raporty\` nie było – kompilacje 14 i 15 nie były jeszcze uruchamiane w SketchUpie.)

## 1. Instalacja

SketchUp → Rozszerzenia → Menedżer rozszerzeń → Zainstaluj rozszerzenie → `arte_madera_generator_wiencowy_1.0.0.rbz`
(leży w folderze `Dokumenty\ArteMadera Generator Konstrukcji Wieńcowych\`). **Zamknij i uruchom SketchUpa ponownie.**
W menu Rozszerzenia → ArteMadera Generator Wieńcowy → „O wtyczce” ma być „Kompilacja 16”. Pasek „ArteMadera Generator
Wieńcowy” z trzema przyciskami: gdyby go nie było – Widok → Paski narzędzi.

Aplikacja do dachów (ArteMadera Roof) 3.12.0 – bez zmian, zostaje ta, która jest.

## 2. Test działania – jedno kliknięcie

Pusty model → trzeci przycisk paska (kartka z zieloną strzałką). Po chwili okienko:

- **„WSZYSTKO W PORZĄDKU – 11 z 11 przykładowych domów”** – kompilacja działa, koniec odbioru.
- **„PROBLEMY w … z 11”** – napisz w rozmowie „test pokazał problemy”; szczegóły są w raporcie, który już leży w folderze.

Model po teście zostaje pusty.

## 3. Zwykła praca

Rysuj i generuj domy jak zawsze. Po każdym „Generuj” wtyczka dopisuje jeden wiersz do `raporty\dziennik_pracy.jsonl`.
Gdy coś wygląda źle, wystarczy jedno zdanie i zrzut ekranu.

## Co nowego warto zobaczyć w tej kompilacji (15 minut)

1. **Nowe okno.** Zaznacz obrys, otwórz generator. U góry „Typ domu”, pod nim sześć kroków (Ściany → Okna i drzwi → Dach →
   Taras i zadaszenie → Podłoga → Zestawienie), po prawej stale rzut i lista „Do poprawy / Sprawdzone”. Kliknij uwagę na
   liście – okno ma przejść do właściwego pola. Wejdź w pole – pod nim pokazuje się podpowiedź. W nagłówku przełącznik
   **„Układ: nowy / dotychczasowy”** – porównaj oba i napisz, przy którym zostajemy.
2. **Typy domów.** Wybierz „Typ 200” – pola wieńców i tarasu zmieniają się na wartości typu. Zmień kilka pól, kliknij
   „Zapisz jako typ…”, wpisz nazwę i zdanie opisu. Zamknij okno, otwórz ponownie na nowym obrysie – ma zacząć od Twojego
   typu, nie od ostatniego podglądu. Sprawdź też „Zapisz zmiany w typie”, „Powiel…”, „Usuń” (dwa kliknięcia).
   Jeśli miałeś własne szablony – są na liście typów; dawne „ostatnie ustawienia” to typ „Ostatnie ustawienia (do kompilacji 15)”.
3. **Standard warsztatu.** Przycisk w nagłówku: 131 pól, które ustawia się rzadko (szukaj po nazwie). Zmień np. mijankę,
   „Zapisz standard” – nowy dom każdego typu ma ją od razu. W kroku okna: lista „Zmień pole standardu tylko w tym domu…” –
   pole pojawia się w kroku z dopiskiem „tylko w tym domu” i strzałką powrotu ↺.
4. **Pół zamka.** Dom ze szczytami, dach na ścianie nośnej („Oparcie dachu przy ścianie okapowej” = ściana nośna): w narożniku
   ostatni bal przechodzi przez zamek bez wycięcia od spodu, z podfrezowanymi bokami; bal pod nim ma gniazdo 72 mm. To samo
   na górze węgła i nad działową pod połacią. Rysunek: `docs\ostatnie_polaczenie_r16.png`. Wyłączenie: standard → „Pół zamka
   w ostatnim połączeniu pod dachem”.
5. **Nadbitka / podbitka.** Krok „Dach” → „Pola typu domu w tym kroku” → „Nadbitka / podbitka – gdzie leżą deski”: na
   płatwiach, na krokwiach, pod krokwiami, pod płatwiami, bez. Przy podbitce pod płatwiami węgieł, w którym łączą się bale
   ściany, przechodzi przez deski do połaci (styk w najwyższym wieńcu ma zamek).
6. **Dom z wymiarów.** Pusty model, nic nie zaznaczone → przycisk generatora: okno z polami „Długość domu” i „Szerokość domu”.
7. **Powierzchnie i limity.** Po prawej w „Wynik”: powierzchnia zabudowy, pomieszczeń, dachu i wysokość nad terenem; w kroku
   „Zestawienie” tabela z każdym pomieszczeniem. Limity (standard → „Powierzchnie i limity”) – po przekroczeniu ostrzeżenie.
8. **Opcje dla obrysu.** Obrys L: w polach „Taras”, „Podłoga”, „Dach” niedostępne wybory są wyszarzone, pod polem powód.

Dawny scenariusz (59 kroków, kompilacje 5–13) – `docs/scenariusz_archiwum.md`.
