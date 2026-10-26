# Zadanie dla aplikacji do dachów – poszycie i współpraca z Generatorem Wieńcowym

Do wklejenia w sesji, która rozwija ArteMadera – Generator konstrukcji dachów (`Mottomi3/Aplikacja-do-konstrukcji-dach-w`).

```
Temat: poszycie dachu jako elementy (nadbitka, deskowanie, OSB) i współpraca z Generatorem Wieńcowym

1. POSZYCIE – NOWA ZAKŁADKA KROKU 2 „Poszycie”
   Warstwy nad krokwiami, każda osobno włączana, każda leży na poprzedniej włączonej (albo na krokwiach):
   a) Nadbitka – boazeria (deska pióro-wpust) na krokwiach jako pełne deskowanie, widoczna od spodu (dach bez
      ocieplenia): grubość (np. 19), szerokość krycia (np. 121), długość handlowa (np. 4000).
   b) Deskowanie pełne – deski: grubość × szerokość (np. 25 × 100), szczelina między deskami, długość handlowa.
   c) OSB – płyty: grubość (18 / 22), format (2500 × 1250), szczelina 3 mm; dłuższy bok wzdłuż okapu.
   Dla każdej warstwy: deski / płyty równolegle do okapu, styki zawsze na krokwi, przesunięte co rząd (mijanka,
   OSB – o pół płyty), docięte do połaci (okap, kalenica / naroże, kosz, szczyt, otwory), numery pozycji,
   zestawienie (szt., m², m³), eksport danych. Warstwy biorą udział w obciążeniach (zakładka Obciążenia –
   poszycie z tej zakładki) i w wytycznych (pokrycie wymagające pełnego poszycia).

2. WSPÓŁPRACA Z GENERATOREM WIEŃCOWYM (dom z bali) – działa od kompilacji 5 generatora
   Generator (parametr „Krokwie – kto je buduje” = aplikacja do dachów) po zbudowaniu domu:
   - tworzy połacie: Footprint.new(obrys w calach, wysokość, nil, []) + RoofBuilder.generate (kąt, okap,
     krawędzie szczytowe, keep_base_face) – płaszczyzna = spód krokwi na jego płatwiach (płatwie ścięte do niej),
     krawędzie szczytowe z jego ścian szczytowych; grupa „Dach - polacie” dostaje atrybut ArteMadera_GW.polacie_domu;
   - zapisuje ustawienia KROKU 2: build_dir = up, ridge_on = false (płatew kalenicowa leży w szczytach z bali),
     seat_on = false, rafter_w_mm / rafter_h_mm / rafter_spacing_mm (rafter_mode = max), timber_class, check_on;
   - zaznacza połacie i otwiera KROK 2 (Commands.generate_framing).
   Sprawdzone na wtyczce 3.3.1 (jej atrapa, trzy domy): połacie leżą dokładnie na płaszczyźnie spodu krokwi
   generatora, krokwie z KROKU 2 leżą na płatwiach i nad szczytami, kontrola krokwi w raporcie.
   Prośby:
   a) stałe, opisane wejście dla innych wtyczek, np. ArteMadera::Roof::API.polacie(model, punkty, z, kąt, okap,
      krawędzie_szczytowe) i API.wiezba(grupa_połaci, ustawienia_początkowe) – żeby zmiany wewnątrz aplikacji
      (Footprint, RoofBuilder, Config, Commands) nie psuły generatora;
   b) kontrola krokwi z podporami pośrednimi: płatwie generatora pod połacią (pośrednie i kalenicowa, elementy
      z prefiksem P albo lista podana w wywołaniu) jako podpory krokwi – rozpiętość między podporami (teraz
      liczona od okapu do kalenicy – przy płatwiach pośrednich zawyżona);
   c) poszycie bez krokwi: deski / OSB bezpośrednio na płatwiach (domek na samych płatwiach);
   d) osie krokwi wymuszone z wywołania – generator poda osie i grubość ścian szczytowych, a KROK 2 postawi krokwie
      z obu stron szczytu / tylko od wewnątrz / od zewnątrz / na szczycie (jak parametr generatora „Krokwie przy
      ścianie szczytowej”); dziś szczyt kończy się pod krokwiami, a krokwie stoją tam, gdzie wypadnie podział;
   e) więźba powiązana z połaciami (np. atrybut na grupie „Wiezba dachowa” z id grupy połaci) – generator przy
      przebudowie domu usunie wtedy właściwą więźbę (dziś szuka jej nad obrysem poprzednich połaci i pyta).
```

## Część 2 – po wersji 3.7.0 (runda 6 generatora, 2026-10-26)

Generator od kompilacji 6 używa tylko `ArteMadera::Roof::API` (polacie z `:operacja => false`, podpory jako lista
hashy w mm, wiezba z oknem i `:po_generowaniu` – więźba dostaje `ArteMadera_GW.wiezba_domu`, więc prośba (e) jest
załatwiona po stronie generatora). Sprawdzone na wtyczce 3.7.0 (jej atrapa, 8 domów: krokwie, płatwie i krokwie,
jednospadowy, same płatwie z deskami / nadbitką i OSB, dom obrócony i odbity) – `testy/sprawdz_dach_aplikacja.rb`.

```
Temat: współpraca z Generatorem Wieńcowym – uwagi po 3.7.0

1. Podpora dokładnie na kalenicy (płatew kalenicowa ścięta z dwóch stron, wierzch = grzbiet): Supports.covered liczy
   przecięcia w przedziale półotwartym, więc linia v równa górnej krawędzi połaci trafia do jednej połaci albo do
   żadnej – zależnie od zaokrągleń (dom 4 × 6,5 m, 35°, okap 600: kalenicowa tylko pod jedną połacią; druga liczona
   bez „płatwi u góry”, z rozporem). Generator obchodzi to, podając wierzch kalenicowej 1 mm pod grzbietem – prośba:
   tolerancja na krawędzi obrysu (np. v w [v_min − 1 mm, v_max + 1 mm]), potem generator wróci do grzbietu.
2. Dach jednospadowy z domu z bali: generator podaje jako podporę także ścianę wysoką (górny bal płasko pod połacią).
   a) Okap za ścianą wysoką (300–500 mm) jest liczony jako przęsło (np. „4,63 + 0,54 m”), a to wspornik.
   b) Z płatwiami pośrednimi raport pokazuje rozpór na murłacie (1,43 kN/m przy 6 × 4,5 m, 15°), choć krokwie leżą
      na płatwiach i na ścianie wysokiej.
   Prośba: podpora przy górnej krawędzi połaci jednospadowej (w odległości okapu) = podpora górna (bez rozporu),
   a odcinek za nią – wspornik.
3. Osie krokwi wymuszone z wywołania (prośba d z części 1) – nadal otwarta: generator poda osie i grubość ścian
   szczytowych, KROK 2 postawi krokwie z obu stron szczytu / od wewnątrz / od zewnątrz / na szczycie.
4. Ustawienia z API.wiezba z oknem zapisują się jako ostatnie – zwykły dach z menu dostaje potem kierunek „w górę”
   i bez płatwi kalenicowej. Prośba (opcjonalnie): opcja `:zapisz => false` także dla okna (ustawienia tylko na
   start okna, ostatnie użytkownika bez zmian).
```
