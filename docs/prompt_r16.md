Runda 16 – ArteMadera Generator Wieńcowy (wtyczka SketchUp 2023, domy ze ścian z bali 44 mm).

Repozytorium: Mottomi3/Generator-Konstrukcji-Wie-cowych, gałąź main (kompilacja 15 z 2026-11-25).
Dodaj je do sesji z prawem zapisu (jeśli jest już sklonowane – nie klonuj drugi raz). Mój folder na dysku:
C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\ (kod, paczka .rbz, raporty\).

Start:
1. Przeczytaj CLAUDE.md, docs/stan_prac.md (§5 kolejka, §6 pytania), docs/przekazanie_r15.md, docs/zadanie_r15.md
   (§0.7 – co czeka na akceptację, §1–2 – zakres tej rundy) i procedurę rundy docs/skille/gw-runda/SKILL.md.
2. Jeśli w raporty\ na dysku są pliki (raport_*.json z testu działania, dziennik_pracy.jsonl) – przejrzyj je przed pracą
   i napisz mi jednym zdaniem, co z nich wynika.
3. Moje odpowiedzi na pytania z rundy 15 są na końcu tej wiadomości. Jeśli którejś brakuje – zadaj to pytanie od razu,
   krótko, z rysunkiem tam, gdzie pomaga, i pracuj dalej nad resztą.

Do zrobienia, w tej kolejności:
1. Pół zamka w ostatnim połączeniu pod dachem (docs/ostatnie_polaczenie_r15.png): po mojej akceptacji włącz fabrycznie
   (polzamek = tak), dodaj tę samą zasadę na górze węgła, który kończy się pod krokwiami albo podbitką, sprawdź losowe
   i złożone domy. Styk w najwyższym wieńcu nad końcem węgła – podpowiedź zamiast ostrzeżenia (jeśli się zgodzę).
2. Trzy poziomy ustawień według docs/podzial_pol_r16.md (z moimi poprawkami): cecha poziom przy każdym polu, okno
   „Standard warsztatu”, typy domów, które sam zapisuję („Zapisz jako typ”, „Zapisz zmiany w typie”, powiel, usuń),
   pole standardu albo typu nadpisane „tylko w tym domu”; własne szablony z dotychczasowego pliku ustawień stają się
   typami; nowy dom zaczyna od wybranego typu, nie od ostatniego podglądu.
3. Okno według docs/szkic_okna_r16.png: kroki w kolejności budowy ze znacznikiem stanu, po prawej zawsze rzut i lista
   „Do poprawy / Sprawdzone” (kliknięcie uwagi przenosi do pola), podpowiedź po wejściu w pole, lista bali i materiały
   w kroku „Zestawienie”, opcje niedostępne dla obrysu wyszarzone z powodem; tryb „Podstawowe / Wszystkie” znika.
4. Z propozycji: S1 (dom prostokątny z wymiarów, gdy nic nie jest zaznaczone) i W1 (powierzchnia zabudowy, pomieszczeń
   i dachu, wysokość kalenicy, moje limity z ostrzeżeniem).

Po każdym skończonym punkcie: commit „r16 (w toku): …” z pushem.

Zamknięcie: kompilacja 16 (rejestrator i main.rb), bash testy/uruchom.sh → „WSZYSTKIE ZESTAWY: FAILURES 0”, losowe
i złożone domy bez problemów, paczka ruby testy/buduj_rbz.rb, commit „r16: …” z pushem, kopia na mój dysk (kod,
dokumenty, .rbz, bundle repozytorium), dokumenty w Projekcie (stan_prac, przekazanie_r16, scenariusz_odbioru,
zadanie, specyfikacja). Na końcu: krótko co zmieniła runda, co sprawdzić w SketchUpie, pytania do mnie i gotowe
polecenie na rundę 17 do wklejenia w nowym oknie.

Odpowiedzi po polsku, krótko, bez opisu kroków pracy; rysunek tam, gdzie pomaga.

Odpowiedzi na pytania z rundy 15:
1. Pół zamka (bal górny bez wycięcia, w balu pod nim 72 mm zamiast 36): …
2. Podział pól (docs/podzial_pol_r16.md): …
3. Szkic okna (docs/szkic_okna_r16.png): …
4. Nadbitka fabrycznie włączona, deskowanie pełne wyłączone: …
5. Styk nad końcem węgła jako podpowiedź zamiast ostrzeżenia: …
