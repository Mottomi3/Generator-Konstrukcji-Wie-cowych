Runda 18 – ArteMadera Generator Wieńcowy (wtyczka SketchUp 2023, domy ze ścian z bali 44 mm).

Repozytorium: Mottomi3/Generator-Konstrukcji-Wie-cowych, gałąź main (kompilacja 17 z 2026-11-27).
Dodaj je do sesji z prawem zapisu (jeśli jest już sklonowane – nie klonuj drugi raz). Mój folder na dysku:
C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\ (kod, paczka .rbz, raporty\).

Start:
1. Przeczytaj CLAUDE.md, docs/stan_prac.md (§5 kolejka, §6 pytania), docs/przekazanie_r17.md, docs/zadanie_r17.md
   (§0 – stan odpowiedzi, §1–2 – zakres tej rundy) i procedurę rundy docs/skille/gw-runda/SKILL.md.
2. Jeśli w raporty\ na dysku są pliki (raport_*.json z testu działania, dziennik_pracy.jsonl) – przejrzyj je przed pracą
   i napisz mi jednym zdaniem, co z nich wynika.
3. Moje odpowiedzi są na końcu tej wiadomości. Jeśli którejś brakuje – zadaj to pytanie od razu, krótko, z rysunkiem tam,
   gdzie pomaga, i pracuj dalej nad resztą.

Do zrobienia, w tej kolejności:
1. Układ okna: zostaw ten, który wybrałem (odpowiedź 1), drugi usuń razem z jego kodem i testami; popraw w nim to, co
   zgłosiłem po obejrzeniu w SketchUpie (odpowiedź 5).
2. Moje modele okien i drzwi (odpowiedź 4) – sprawdź wstawianie na moich plikach; działowa pod stykiem i przełącznik doboru
   według odpowiedzi 2 i 6; typy z projektów według odpowiedzi 3.
3. Zaległe propozycje P2, P3, P5 (docs/zadanie_r17.md §2): podparcie końców płatwi w domu L i tarasie typu 300, belki
   dłuższe niż handlowe dzielone nad podporą, drobne błędy geometrii ze znanych ziaren.
4. Kanały na przewody (N3) kliknięciem w widok ściany – czwarta pozycja przełącznika „Klik w widok wstawia”.

Po każdym skończonym punkcie: commit „r18 (w toku): …” z pushem.

Zamknięcie: kompilacja 18 (rejestrator i main.rb), bash testy/uruchom.sh → „WSZYSTKIE ZESTAWY: FAILURES 0”, losowe
i złożone domy bez nowych problemów, paczka ruby testy/buduj_rbz.rb, commit „r18: …” z pushem, kopia na mój dysk (kod,
dokumenty, .rbz, bundle repozytorium), dokumenty w Projekcie (stan_prac, przekazanie_r18, scenariusz_odbioru,
zadanie, specyfikacja). Na końcu: krótko co zmieniła runda, co sprawdzić w SketchUpie, pytania do mnie i gotowe
polecenie na rundę 19 do wklejenia w nowym oknie.

Odpowiedzi po polsku, krótko, bez opisu kroków pracy; rysunek tam, gdzie pomaga.

Odpowiedzi na pytania z rundy 17:
1. Układ okna – nowy (kroki) czy dotychczasowy (zakładki) (zrzut docs\uklady_okna_r17.png): …
2. Działowa pod stykiem – wariant z rysunku docs\styk_w_zamku_r17.png jest dobry: …
3. Typy 100–400 wystarczą na start, czy dodać typy z projektów 900, 1100, 1200, 1800: …
4. Modele okien i drzwi – folder i nazwy plików (generator szuka <symbol>.skp albo nazwy z kolumny „Model”): …
5. Co nie działało albo wyglądało źle w kompilacji 17 w SketchUpie: …
6. Przełącznik „Przekroje konstrukcji” fabrycznie – „podaję sam” czy „dobieraj automatycznie”: …
