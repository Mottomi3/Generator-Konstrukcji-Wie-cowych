Runda 17 – ArteMadera Generator Wieńcowy (wtyczka SketchUp 2023, domy ze ścian z bali 44 mm).

Repozytorium: Mottomi3/Generator-Konstrukcji-Wie-cowych, gałąź main (kompilacja 16 z 2026-11-26).
Dodaj je do sesji z prawem zapisu (jeśli jest już sklonowane – nie klonuj drugi raz). Mój folder na dysku:
C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\ (kod, paczka .rbz, raporty\).

Start:
1. Przeczytaj CLAUDE.md, docs/stan_prac.md (§5 kolejka, §6 pytania), docs/przekazanie_r16.md, docs/zadanie_r16.md
   (§0 – moje odpowiedzi z rundy 16, §1–4 – zakres tej rundy) i procedurę rundy docs/skille/gw-runda/SKILL.md.
2. Jeśli w raporty\ na dysku są pliki (raport_*.json z testu działania, dziennik_pracy.jsonl) – przejrzyj je przed pracą
   i napisz mi jednym zdaniem, co z nich wynika.
3. Moje odpowiedzi na pytania z rundy 16 są na końcu tej wiadomości. Jeśli którejś brakuje – zadaj to pytanie od razu,
   krótko, z rysunkiem tam, gdzie pomaga, i pracuj dalej nad resztą.

Do zrobienia, w tej kolejności:
1. Układ okna: zostaw ten, który wybrałem (odpowiedź 1), drugi usuń razem z jego kodem i testami; popraw w nim to, co
   zgłosiłem po obejrzeniu w SketchUpie. Dodaj pozycję menu „Standard warsztatu”.
2. Styk bali zawsze w zamku – dwa pozostałe miejsca (docs/zadanie_r16.md §4): działowa pod podbitką „pod płatwiami”
   i ściana szczytowa nad końcem węgła; pokaż rysunek przed zmianą, jeśli są dwa sensowne rozwiązania.
3. Okna, drzwi i węgły kliknięciem w widoku ściany z okienkiem parametrów; lista typowej stolarki w standardzie warsztatu;
   moje modele okien i drzwi wstawiane w otwory przy generowaniu (jeśli je już przygotowałem – odpowiedź 5); działowe
   w domu z wymiarów z tabeli okna.
4. Magazyn drewna jako jedna tabela (z deską 14 × 115) i jeden przełącznik doboru przekrojów; wycena materiału (W3).

Po każdym skończonym punkcie: commit „r17 (w toku): …” z pushem.

Zamknięcie: kompilacja 17 (rejestrator i main.rb), bash testy/uruchom.sh → „WSZYSTKIE ZESTAWY: FAILURES 0”, losowe
i złożone domy bez nowych problemów, paczka ruby testy/buduj_rbz.rb, commit „r17: …” z pushem, kopia na mój dysk (kod,
dokumenty, .rbz, bundle repozytorium), dokumenty w Projekcie (stan_prac, przekazanie_r17, scenariusz_odbioru,
zadanie, specyfikacja). Na końcu: krótko co zmieniła runda, co sprawdzić w SketchUpie, pytania do mnie i gotowe
polecenie na rundę 18 do wklejenia w nowym oknie.

Odpowiedzi po polsku, krótko, bez opisu kroków pracy; rysunek tam, gdzie pomaga.

Odpowiedzi na pytania z rundy 16:
1. Układ okna – nowy (kroki) czy dotychczasowy (zakładki): …
2. Działowa, na której wypada styk ściany okapowej, przy podbitce pod płatwiami – ma dochodzić do połaci jak węgieł: …
3. Typy 100–400 wystarczą na start, czy dodać typy z projektów 900, 1100, 1200, 1800: …
4. Modele okien i drzwi – w jakiej postaci je przygotowałem (folder, nazwy plików): …
5. Co nie działało albo wyglądało źle w kompilacji 16 w SketchUpie: …
