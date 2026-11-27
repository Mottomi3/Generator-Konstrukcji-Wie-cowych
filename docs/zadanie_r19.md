# Zadanie po rundzie 19 – odpowiedzi użytkownika i zakres rundy 20

## 0. Odpowiedzi użytkownika z rundy 18 (polecenie 2026-11-27 22:08; w poleceniu same „…”, odpowiedź w oknie pytań)

1. **Układ okna** – „oba”. Oba układy zostają (wybór później).
2. **Dom L – koniec płatwi skrzydła w koszu** – „nie wiem, sprawdź w wytycznych dla konstruktorów / architektów / prawie
   budowlanym / normach budowlanych”. Sprawdzone (`docs/specyfikacja.md`, „Dom L – koniec płatwi skrzydła”): słupek na
   płatwi dachu głównego to zwykłe rozwiązanie ciesielskie (płatwie lukarn na płatwi pośredniej krótkimi słupkami –
   Dietrich's); PN-EN 1995-1-1 wymaga sprawdzenia płatwi głównej z siłą skupioną i docisku w poprzek włókien (p. 6.1.5) –
   oba dodane (`rdzen/statyka_kosza.rb`).
3. **Taras typu 300 – front ze szczytem** – „może być, ma być wybór”. Szczyt fabrycznie, wybór „Typ 300 – front tarasu”
   (`taras_sciany_front`) – bez zmian od kompilacji 18.
4. **Typ + dodatki** – „tak”. Zrobione: krok „Dodatki”, drewutnia przy ścianie szczytowej z tyłu, przełączniki zadaszenia
   i drewutni w „Ten dom”.
5. **Uwagi z SketchUpa** – brak (folderu `raporty\` na dysku nie ma).

## 1. Runda 20 – po odpowiedziach na pytania z `docs/stan_prac.md` §6

- **Drewutnia** (pytanie 1, rysunek `docs/drewutnia_r19.png`): gdy płatew ma być przykręcona do ściany – rząd słupów przy
  ścianie znika, płatew przy ścianie na łącznikach przesuwnych (luz na osiadanie w zestawieniu okuć), statyka płatwi
  bez zmian; ściany drewutni (boki i tył z desek ażurowych – deski, rygle) – gdy potrzebne; dach drewutni w zestawieniu
  (powierzchnia, łaty, pokrycie) i ewentualnie dla aplikacji do dachów.
- **Taras w „Ten dom”** (pytanie 2): `taras` z poziomu :typ na :dom (szablony Typ 200 i 300 zostają z tarasem – typ
  pamięta pola „Ten dom”); testy `t_poziomy.rb` (przykład pola typu – inne pole niż taras).
- **Kolejny dodatek** (pytanie 3): poddasze użytkowe – strop z belek (N1) albo ścianka o pół piętra jako przełącznik.
- **Raport z testu działania** (gdy będzie w `raporty\`): niezgodne domy, czasy budowy, awarie – pierwsza pozycja rundy.
- **Modele stolarki** (gdy będą): punkt wstawienia i osie na plikach użytkownika.

## 2. Zaległe

- Aplikacja do dachów: w sesji rundy 19 dostęp do repozytorium aplikacji (odczyt) był odmówiony – zestaw „dach_aplikacja”
  pominięty; w rundzie 20 sprawdzić (`add_repo` do odczytu, `AM_GW_APLIKACJA_DACHOW`).
- Kanały: otwór puszki w bryle (gdy Dokumentacja 2D ma go rysować), kanał nad oknem (np. do lampy) – na prośbę.

## 3. Dalej

Strop i antresola z belek (N1), obrysy T i U (N4 – wzór dobudówki), okna dopasowane do wieńców (N2), grubszy bal (N5),
Dokumentacja 2D (W4: grupy Bs, Kf, Sz, obróbki kanałów i puszek), „buduj do wysokości”, podgląd na żywo po pomiarze;
pytania Z9, D1a, H21, okucia (`docs/stan_prac.md` §6).
