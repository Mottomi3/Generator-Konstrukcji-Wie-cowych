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
