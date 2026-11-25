# Odbiór – kompilacja 14

Trzy kroki. Nie trzeba niczego zapisywać ani wysyłać – wtyczka sama odkłada raport i dziennik pracy w folderze
`Dokumenty\ArteMadera Generator Konstrukcji Wieńcowych\raporty\`, a Claude czyta je stamtąd na początku następnej rozmowy.

## 1. Instalacja

SketchUp → Rozszerzenia → Menedżer rozszerzeń → Zainstaluj rozszerzenie → `arte_madera_generator_wiencowy_1.0.0.rbz`
(leży w folderze `Dokumenty\ArteMadera Generator Konstrukcji Wieńcowych\`). **Zamknij i uruchom SketchUpa ponownie.**
Po uruchomieniu pojawia się nowy pasek „ArteMadera Generator Wieńcowy” z trzema przyciskami. Gdyby go nie było:
Widok → Paski narzędzi → zaznacz „ArteMadera Generator Wieńcowy”.

Aplikacja do dachów (ArteMadera Roof) 3.12.0 – bez zmian, zostaje ta, która jest.

## 2. Test działania – jedno kliknięcie

Pusty model → trzeci przycisk paska (kartka z zieloną strzałką). Po chwili okienko:

- **„WSZYSTKO W PORZĄDKU – 11 z 11 przykładowych domów”** – kompilacja działa, koniec odbioru.
- **„PROBLEMY w … z 11”** – napisz w rozmowie „test pokazał problemy”; szczegóły są w raporcie, który już leży w folderze.

Model po teście zostaje pusty.

## 3. Zwykła praca

Rysuj i generuj domy jak zawsze. Po każdym „Generuj” wtyczka dopisuje jeden wiersz do `raporty\dziennik_pracy.jsonl`
(ile trwały obliczenia i budowa modelu, ile bali, które ustawienia były zmienione) – z tego widać, co działa wolno i których
pól naprawdę używasz. Gdy coś wygląda źle, wystarczy jedno zdanie i zrzut ekranu.

## Co nowego warto zobaczyć w tej kompilacji (5 minut)

1. **Pasek i prawy przycisk.** Zaznacz linie obrysu → prawy przycisk myszy → „Dom wieńcowy z zaznaczonych linii…”.
   Zaznacz wygenerowany dom → prawy przycisk → „Edytuj dom wieńcowy…”. To samo robi pierwszy przycisk paska.
2. **Dom L z działową po linii uskoku.** Obrys L, do tego jedna linia narysowana przez cały dom w linii ściany wklęsłej.
   Dom powstaje (wcześniej okienko z błędem), działowa jest przedłużeniem ściany zewnętrznej, w narożniku jeden zamek.
3. **Podpowiedzi.** W sekcji „Ściany” – narożnik wklęsły jako zwykła podpowiedź. W sekcji „Podłoga i fundamenty” – „Bez
   podciągów trzeba by legara…” i żółta uwaga przy podciągu obciążonym ponad 90 %.
4. **Długości z hurtowni.** Dom dłuższy niż 7 m → w sekcji „Szczyty i dach” uwaga, że płatwie są dłuższe niż najdłuższa
   belka z listy i trzeba je łączyć nad podporą. Listy przekrojów (tryb „Wszystkie”) mają teraz długości: „80x200:5/7/8”.

Dawny scenariusz (59 kroków, kompilacje 5–13) – `docs/scenariusz_archiwum.md`.
