# Zadanie po rundzie 18 – odpowiedzi użytkownika i zakres rundy 19

## 0. Odpowiedzi użytkownika z rundy 18 (polecenie 2026-11-27 20:20)

1. **Układ okna** – „nie sprawdzałem”. Pytanie zadane od razu (zrzut `docs/uklady_okna_r17.png`), bez odpowiedzi – oba
   układy zostają.
2. **Działowa pod stykiem** – „wariant z rysunku 17 jest poprawny” – potwierdzone, bez zmian.
3. **Typy** – „albo zostaw to, albo musimy opracować sami typy domków, do których np. można dołożyć taras, boczne
   zadaszenie czy drewutnię z tyłu, lub podnieść o pół piętra, lub dołożyć użytkowe poddasze – ale wydaje mi się to
   trudne (…) można rozważyć takie opcje”. Typy 100–400 zostają; propozycja „typ + dodatki” – pytanie 4 w
   `docs/stan_prac.md` §6.
4. **Modele okien i drzwi** – „nie stworzyłem modeli okien i drzwi, możesz dać tam do wprowadzenia ścieżkę dostępu, to da
   mi możliwość podmiany modeli”. Zrobione: pełna ścieżka w kolumnie „Model”, przycisk „…” (plik i folder), prosty model
   z generatora, gdy pliku nie ma.
5. **Uwagi z SketchUpa** – „nie sprawdzałem”.
6. **Przełącznik doboru** – „wydaje mi się, że oba wybory, też zależy jakie konstrukcje”. Zrobione: przełącznik w typie
   domu (Typ 100, 200 – podaję sam; Typ 300, 400 – automatycznie).

## 1. Runda 19 – po odpowiedziach

- **Układ okna**: po wyborze usunąć drugi (`html/tryb.js` albo `html/kroki.js` / `html/uklad.js`, cecha `podstawowy:`
  w liście parametrów, `Ustawienia.tryb_pol`), testy okna przenieść na wybrany; poprawki z prawdziwego SketchUpa.
- **Raport z testu działania** (gdy będzie w `raporty\`): niezgodne domy, czasy budowy, awarie – pierwsza pozycja rundy.
- **Modele stolarki** (gdy będą): punkt wstawienia i osie na plikach użytkownika (`rdzen/stolarka_modele.rb#polozenie`),
  w razie potrzeby przesunięcie modelu w głąb ściany (parametr).
- **Słupki w koszu domu L** (pytanie 2): gdy użytkownik woli przedłużenie płatwi skrzydła do płatwi głównej – koniec
  płatwi ścięty do połaci dachu głównego (obróbka końca belki), styk z łącznikiem; słupek tylko bez płatwi w zasięgu.
- **Front tarasu 300** (pytanie 3): fabrycznie „szczyt” albo „otwarty”; ewentualnie słupy pod frontem także w typie 300.
- **Typ + dodatki** (pytanie 4): przy zgodzie – blok „Dodatki” (taras, zadaszenie boczne, drewutnia / zadaszenie przy
  ścianie szczytowej z tyłu – N4, ścianka o pół piętra wyżej, poddasze – N1) w kroku „Taras i zadaszenie”.

## 2. Zaległe (runda 19)

- **P5 reszta**: ziarna 6305, 6557 – krawędzie 0,07 / 0,008 mm w balach szczytu (wycięcie gniazda płatwi od góry kończy się
  tuż nad gniazdem zamka od spodu; wyrównać do gniazda albo zostawić ≥ 0,2 mm).
- **Kanały**: strona puszki w działowej (lewa / prawa), kanał omijający otwór okna (przerwany nad / pod oknem), otwór puszki
  w bryle (gdy Dokumentacja 2D ma go rysować).

## 3. Dalej

Strop i antresola z belek (N1), wzór dobudówki z obrysami T i U (N4), okna dopasowane do wieńców (N2), grubszy bal (N5),
Dokumentacja 2D (W4: grupy Bs, Kf, Sz, obróbki kanałów i puszek), „buduj do wysokości”, podgląd na żywo po pomiarze;
pytania Z9, D1a, H21, okucia (`docs/stan_prac.md` §6).
