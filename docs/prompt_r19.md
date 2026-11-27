Runda 19 – ArteMadera Generator Wieńcowy (wtyczka SketchUp 2023, domy ze ścian z bali 44 mm).

Repozytorium: Mottomi3/Generator-Konstrukcji-Wie-cowych, gałąź main (kompilacja 18 z 2026-11-27).
Dodaj je do sesji z prawem zapisu (jeśli jest już sklonowane – nie klonuj drugi raz). Mój folder na dysku:
C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\ (kod, paczka .rbz, raporty\).

Start:
1. Przeczytaj CLAUDE.md, docs/stan_prac.md (§5 kolejka, §6 pytania), docs/przekazanie_r18.md, docs/zadanie_r18.md
   (§0 – stan odpowiedzi, §1–2 – zakres tej rundy) i procedurę rundy docs/skille/gw-runda/SKILL.md.
2. Jeśli w raporty\ na dysku są pliki (raport_*.json z testu działania, dziennik_pracy.jsonl) – przejrzyj je przed pracą
   i napisz mi jednym zdaniem, co z nich wynika; problem z raportu = pierwsza pozycja rundy.
3. Moje odpowiedzi są na końcu tej wiadomości. Jeśli którejś brakuje – zadaj to pytanie od razu, krótko, z rysunkiem tam,
   gdzie pomaga, i pracuj dalej nad resztą.

Do zrobienia, w tej kolejności:
1. Układ okna: zostaw ten, który wybrałem (odpowiedź 1), drugi usuń razem z jego kodem i testami; popraw to, co zgłosiłem
   po obejrzeniu w SketchUpie (odpowiedź 5) i co wynika z raportu.
2. Słupki w koszu domu L i front tarasu typu 300 według odpowiedzi 2 i 3; moje modele okien i drzwi, jeśli je wskazałem.
3. Typ + dodatki według odpowiedzi 4 (jeśli „tak” – zacznij od drewutni / zadaszenia przy ścianie szczytowej z tyłu,
   według wzoru dobudówki N4).
4. P5 reszta (ziarna 6305, 6557) i poprawki kanałów z docs/zadanie_r18.md §2.

Po każdym skończonym punkcie: commit „r19 (w toku): …” z pushem.

Zamknięcie: kompilacja 19 (rejestrator i main.rb), bash testy/uruchom.sh → „WSZYSTKIE ZESTAWY: FAILURES 0”, losowe
i złożone domy bez nowych problemów, paczka ruby testy/buduj_rbz.rb, commit „r19: …” z pushem, kopia na mój dysk (kod,
dokumenty, .rbz, bundle repozytorium), dokumenty w Projekcie (stan_prac, przekazanie_r19, scenariusz_odbioru,
zadanie, specyfikacja). Na końcu: krótko co zmieniła runda, co sprawdzić w SketchUpie, pytania do mnie i gotowe
polecenie na rundę 20 do wklejenia w nowym oknie.

Odpowiedzi po polsku, krótko, bez opisu kroków pracy; rysunek tam, gdzie pomaga.

Odpowiedzi na pytania z rundy 18:
1. Układ okna – nowy (kroki) czy dotychczasowy (zakładki) (zrzut docs\uklady_okna_r17.png): …
2. Dom L – koniec płatwi skrzydła w koszu: słupek na płatwi głównej (docs\kosz_slupek_r18.png) – dobrze, czy przedłużać
   płatew do płatwi głównej ze ściętym końcem: …
3. Taras typu 300 – front ze szczytem fabrycznie (zamiast otwartego) – dobrze: …
4. Typ + dodatki (taras, zadaszenie boczne, drewutnia z tyłu, ścianka o pół piętra wyżej, poddasze) – robimy tak: …
5. Co nie działało albo wyglądało źle w kompilacji 18 w SketchUpie (test działania, prosty model okna, kanał, słupki): …
