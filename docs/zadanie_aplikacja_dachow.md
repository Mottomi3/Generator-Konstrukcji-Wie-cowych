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

2. WSPÓŁPRACA Z GENERATOREM WIEŃCOWYM (dom z bali)
   Generator tworzy połacie przez RoofBuilder.generate (płaszczyzna = spód krokwi na jego płatwiach, krawędzie
   szczytowe z jego ścian szczytowych; dwuspadowy i jednospadowy – trzy krawędzie szczytowe), zapisuje w ustawieniach
   KROKU 2: kierunek „w górę”, kalenica – nie (płatew kalenicowa leży w szczytach z bali), zamki dolne – nie,
   i otwiera KROK 2 (Commands.generate_framing). Prośby:
   a) stałe, opisane wejście dla innych wtyczek, np. ArteMadera::Roof::API.polacie(model, punkty, z, kąt, okap,
      krawędzie_szczytowe) i API.wiezba(grupa_połaci, ustawienia_początkowe) – żeby zmiany wewnątrz aplikacji
      nie psuły generatora;
   b) kontrola krokwi z podporami pośrednimi: płatwie generatora pod połacią (pośrednie i kalenicowa, elementy
      z prefiksem P albo lista podana w wywołaniu) jako podpory krokwi – rozpiętość między podporami;
   c) poszycie bez krokwi: deski / OSB bezpośrednio na płatwiach (domek na samych płatwiach).
```
