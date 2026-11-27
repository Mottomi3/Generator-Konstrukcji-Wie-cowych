Runda 20 – ArteMadera Generator Wieńcowy (wtyczka SketchUp 2023, domy ze ścian z bali 44 mm).

Repozytorium: Mottomi3/Generator-Konstrukcji-Wie-cowych, gałąź main (kompilacja 19 z 2026-11-27).
Dodaj je do sesji z prawem zapisu (jeśli jest już sklonowane – nie klonuj drugi raz). Aplikację do dachów
(Mottomi3/Aplikacja-do-konstrukcji-dach-w) dodaj do odczytu – do testów. Mój folder na dysku:
C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\ (kod, paczka .rbz, raporty\).

Start:
1. Przeczytaj CLAUDE.md, docs/stan_prac.md (§5 kolejka, §6 pytania), docs/przekazanie_r19.md, docs/zadanie_r19.md
   (§0 – odpowiedzi, §1–2 – zakres tej rundy) i procedurę rundy docs/skille/gw-runda/SKILL.md.
2. Jeśli w raporty\ na dysku są pliki (raport_*.json z testu działania, dziennik_pracy.jsonl) – przejrzyj je przed pracą
   i napisz mi jednym zdaniem, co z nich wynika; problem z raportu = pierwsza pozycja rundy.
3. Moje odpowiedzi są na końcu tej wiadomości. Jeśli którejś brakuje – zadaj to pytanie od razu, krótko, z rysunkiem tam,
   gdzie pomaga, i pracuj dalej nad resztą.

Do zrobienia, w tej kolejności:
1. Poprawki z SketchUpa (odpowiedź 4) i z raportu.
2. Drewutnia według odpowiedzi 1 (słupy przy ścianie albo płatew na łącznikach przesuwnych; ściany drewutni, jeśli „tak”);
   dach drewutni w zestawieniu materiałów.
3. Taras w „Ten dom” według odpowiedzi 2.
4. Kolejny dodatek według odpowiedzi 3 (poddasze użytkowe – strop z belek N1 albo ścianka o pół piętra).
5. Moje modele okien i drzwi, jeśli je wskazałem.

Po każdym skończonym punkcie: commit „r20 (w toku): …” z pushem.

Zamknięcie: kompilacja 20 (rejestrator i main.rb), bash testy/uruchom.sh → „WSZYSTKIE ZESTAWY: FAILURES 0” (z aplikacją
do dachów), losowe i złożone domy bez nowych problemów, paczka ruby testy/buduj_rbz.rb, commit „r20: …” z pushem, kopia
na mój dysk (kod, dokumenty, .rbz, bundle repozytorium), dokumenty w Projekcie (stan_prac, przekazanie_r20,
scenariusz_odbioru, zadanie, specyfikacja). Na końcu: krótko co zmieniła runda, co sprawdzić w SketchUpie, pytania do mnie
i gotowe polecenie na rundę 21 do wklejenia w nowym oknie.

Odpowiedzi po polsku, krótko, bez opisu kroków pracy; rysunek tam, gdzie pomaga.

Odpowiedzi na pytania z rundy 19:
1. Drewutnia (docs\drewutnia_r19.png) – słupy przy ścianie (nie dotyka ściany) dobrze, czy płatew przykręcona do ściany na
   łącznikach przesuwnych? Ściany drewutni z desek (boki, tył) – potrzebne: …
2. Taras jako dodatek – przełącznik tarasu też w „Ten dom” (Typ 200 i 300 dalej z tarasem): …
3. Kolejny dodatek – poddasze użytkowe (strop z belek) czy ścianka o pół piętra wyżej: …
4. Co nie działało albo wyglądało źle w kompilacji 19 w SketchUpie (test działania – 12 domów, drewutnia, kanał pod oknem,
   zdanie o koszu domu L): …
