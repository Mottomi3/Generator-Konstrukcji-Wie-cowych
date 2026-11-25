# Odbiór – kompilacja 15

Trzy kroki. Nie trzeba niczego zapisywać ani wysyłać – wtyczka sama odkłada raport i dziennik pracy w folderze
`Dokumenty\ArteMadera Generator Konstrukcji Wieńcowych\raporty\`, a Claude czyta je stamtąd na początku następnej rozmowy.
(Na starcie rundy 15 folderu `raporty\` jeszcze nie było – kompilacja 14 nie była uruchamiana.)

## 1. Instalacja

SketchUp → Rozszerzenia → Menedżer rozszerzeń → Zainstaluj rozszerzenie → `arte_madera_generator_wiencowy_1.0.0.rbz`
(leży w folderze `Dokumenty\ArteMadera Generator Konstrukcji Wieńcowych\`). **Zamknij i uruchom SketchUpa ponownie.**
W menu Rozszerzenia → ArteMadera Generator Wieńcowy → „O wtyczce” ma być „Kompilacja 15”. Pasek „ArteMadera Generator
Wieńcowy” z trzema przyciskami: gdyby go nie było – Widok → Paski narzędzi.

Aplikacja do dachów (ArteMadera Roof) 3.12.0 – bez zmian, zostaje ta, która jest.

## 2. Test działania – jedno kliknięcie

Pusty model → trzeci przycisk paska (kartka z zieloną strzałką). Po chwili okienko:

- **„WSZYSTKO W PORZĄDKU – 11 z 11 przykładowych domów”** – kompilacja działa, koniec odbioru.
- **„PROBLEMY w … z 11”** – napisz w rozmowie „test pokazał problemy”; szczegóły są w raporcie, który już leży w folderze.

Model po teście zostaje pusty.

## 3. Zwykła praca

Rysuj i generuj domy jak zawsze. Po każdym „Generuj” wtyczka dopisuje jeden wiersz do `raporty\dziennik_pracy.jsonl`
(ile trwały obliczenia i budowa modelu, ile bali, które ustawienia były zmienione). Gdy coś wygląda źle, wystarczy jedno
zdanie i zrzut ekranu.

## Co nowego warto zobaczyć w tej kompilacji (10 minut)

1. **Szczyt na styk.** Dom ze ścianą szczytową dłuższą niż 5,1 m (np. 8 × 6,4 m). W widoku ściany szczytowej: wieńce nad
   wysokością ściany łączą się przy kalenicy raz z lewej, raz z prawej (± 200 mm), bez węgła; węgły pod styki kończą się
   na wysokości ściany okapowej. Sekcja „Długości bali i łączenia” → „Łączenie wieńców szczytu” = „w zamkach węgłów”
   przywraca dawny układ.
2. **Deski i poszycie.** Sekcja „Poszycie dachu”: nadbitka włączona, 14 × 115 × 4000; deskowanie pełne wyłączone. Jeśli
   miałeś zapamiętane 19 × 121 – wróciły do 14 × 115 (jednorazowo, przy pierwszym uruchomieniu kompilacji 15).
3. **Słupy tarasu.** Dom z tarasem na słupach (Typ 200): słup kończy się kilka centymetrów pod balem podciągu (luz na
   osiadanie + śruba regulacyjna), w sekcji „Taras” podpowiedź „Słupy … krótsze o osiadanie ścian”. Pola: „Słupy krótsze
   o osiadanie ścian”, „Słup – regulacja w głowicy”, „Śruba regulacyjna – wysokość po skręceniu”.
4. **Zestawienie materiałów.** Na dole okna, pod listą bali i belek, tabela „Materiały: deski, taśma, okucia,
   impregnacja”; to samo w pliku z przycisku „Zapisz zestawienie (CSV)”. Ustawienia: sekcja „Zestawienie materiałów”
   (zapas na docinki, pasy taśmy, rozstaw kotew, wydajność impregnatu). Sprawdź, czy liczby zgadzają się z tym, co
   zamawiasz – jeśli nie, napisz, o ile.
5. **Pół zamka (wyłączone, do Twojej decyzji).** Sekcja „Szczyty i dach” → „Pół zamka w ostatnim połączeniu pod dachem”
   = tak. Dach na ścianie nośnej („Oparcie dachu przy ścianie okapowej” = ściana nośna – bez płatwi): w narożniku ostatni bal szczytu
   przechodzi przez zamek cały (bez gniazda od spodu), a górny bal ściany okapowej ma gniazdo 72 mm. Rysunek:
   `docs\ostatnie_polaczenie_r15.png`.

Dawny scenariusz (59 kroków, kompilacje 5–13) – `docs/scenariusz_archiwum.md`.
