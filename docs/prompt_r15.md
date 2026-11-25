Runda 15 – ArteMadera Generator Wieńcowy (wtyczka SketchUp 2023, domy ze ścian z bali 44 mm).

Repozytorium: Mottomi3/Generator-Konstrukcji-Wie-cowych, gałąź main (kompilacja 14 i dokumenty z 2026-11-25 20:40).
Dodaj je do sesji z prawem zapisu i sklonuj. Mój folder na dysku: C:\Users\Mottomi\Documents\ArteMadera Generator
Konstrukcji Wieńcowych\ (kod, paczka .rbz, raporty\).

Start:
1. Przeczytaj CLAUDE.md, docs/stan_prac.md, docs/przekazanie_r14.md, docs/zadanie_r15.md (§0 to zakres tej rundy)
   i procedurę rundy docs/skille/gw-runda/SKILL.md.
2. Jeśli w raporty\ na dysku są pliki (raport_*.json z testu działania, dziennik_pracy.jsonl) – przejrzyj je przed pracą
   i napisz mi jednym zdaniem, co z nich wynika.
3. Zadaj mi jedno pytanie: czy nadbitka ma być fabrycznie włączona, a deskowanie pełne wyłączone (zadanie_r15 §0.3)?

Do zrobienia, w tej kolejności:
1. Szczyty na styk (decyzja T8): wieńce w szczytach ścian domu łączone na styk z przesunięciem 300 mm, jak front
   tarasu, bez węgłów pod styki w szczycie; wybór jako parametr – zadanie_r15 §0.1.
2. Pół zamka: po punkcie 1 zmierz, gdzie zamki zostają niedomknięte pod połacią, pokaż mi rysunek pół zamka w tych
   miejscach, po mojej akceptacji wdroż – §0.2.
3. Deski nadbitki i podbitki 14 × 115 (krycie) × 4000 jako wartości fabryczne, plik ustawień w wersji 4 – §0.3.
4. Przekrój 45 × 120 z długościami 5,4 / 6 m – §0.4.
5. Z propozycji docs/propozycje_r15.md: P1 (słupy krótsze o osiadanie ścian, z regulacją) i W2 (pełne zestawienie
   materiałów: deski, taśma między wieńcami, okucia, powierzchnia do impregnatu).
6. Przygotowanie rundy 16: tabela podziału wszystkich pól na Standard warsztatu / Typ domu / Ten dom i szkic okna
   z wynikiem zawsze na widoku – pokaż mi, akceptację zapisz w zadanie_r15 §1–2 (kod okna dopiero w rundzie 16).

Po każdym skończonym punkcie: commit „r15 (w toku): …” z pushem, żeby nic nie przepadło.

Zamknięcie: kompilacja 15 (rejestrator i main.rb), bash testy/uruchom.sh → „WSZYSTKIE ZESTAWY: FAILURES 0”, losowe
i złożone domy bez problemów, paczka ruby testy/buduj_rbz.rb, commit „r15: …” z pushem, kopia na mój dysk (kod,
dokumenty, .rbz, bundle repozytorium), dokumenty w Projekcie (stan_prac, przekazanie_r15, scenariusz_odbioru,
zadanie_r15, specyfikacja). Na końcu: krótko co zmieniła runda, co sprawdzić w SketchUpie, pytania do mnie i gotowe
polecenie na rundę 16 do wklejenia w nowym oknie.

Odpowiedzi po polsku, krótko, bez opisu kroków pracy; rysunek tam, gdzie pomaga.
