# Zadanie po rundzie 17 – odpowiedzi użytkownika i zakres rundy 18

## 0. Odpowiedzi użytkownika z rundy 17

Polecenie rundy 17 (2026-11-27 18:59) miało wszystkie pięć odpowiedzi puste („…”). Pytania zadane od razu, z rysunkiem
działowej i zrzutem obu układów okna – do końca rundy bez odpowiedzi. Przyjęte w rundzie 17 (do potwierdzenia):

1. **Układ okna** – bez wyboru: oba zostają (nic nie usunięte).
2. **Działowa pod stykiem przy podbitce pod płatwiami** – zrobione: przy ścianie okapowej działowa pełnym balem do wierzchu
   bala pod najwyższym wieńcem ściany, deski przerwane na ok. 30 cm (rysunek `docs/styk_w_zamku_r17.png`).
3. **Typy 900–1800** – bez zmian (Typ 100–400).
4. **Modele okien i drzwi** – mechanizm gotowy: folder w standardzie („Folder modeli stolarki”), plik `<symbol>.skp` albo
   nazwa z kolumny „Model”, punkt 0 w dolnym lewym narożniku stolarki od zewnątrz.
5. **Uwagi z SketchUpa** – brak (folderu `raporty\` nie było).

## 1. Układ okna i modele stolarki (runda 18 – po odpowiedziach)

- Po wyborze układu: usunąć drugi (`html/tryb.js` albo `html/kroki.js` / `html/uklad.js`, cecha `podstawowy:` w liście
  parametrów, `Ustawienia.tryb_pol`), testy okna przenieść na wybrany; poprawki z prawdziwego SketchUpa.
- Modele użytkownika: sprawdzić punkt wstawienia i osie na jego plikach (`rdzen/stolarka_modele.rb#polozenie`), w razie
  potrzeby parametr przesunięcia modelu w głąb ściany (np. ościeżnica w osi ściany, nie przy licu).
- Przełącznik „Przekroje konstrukcji” – fabrycznie według odpowiedzi na pytanie 6 (`docs/stan_prac.md` §6).
- Typy z projektów 900, 1100, 1200, 1800 (S2) – jeśli użytkownik ich chce.

## 2. Zaległe propozycje (runda 18)

- **P2, P3, P5** (`docs/propozycje_r15.md`): podparcie końców płatwi skrzydła bocznego w domu L (belka koszowa) i w tarasie
  typu 300, belki dłuższe niż handlowe dzielone nad podporą, drobne błędy geometrii z listy znanych ziaren (6110, 6269,
  6305, 6557 – krawędzie i bal nad połacią poniżej 0,2 mm; 6444 – płatew a bale; 6311, 6410, 6430 – działowe narysowane
  kilkadziesiąt mm od siebie).
- **N3 – kanały na przewody**: kliknięcie w widok ściany (przełącznik „Klik w widok wstawia” – czwarta pozycja), okienko
  z średnicą i opcjonalnym gniazdem na puszkę; pionowy otwór przez wszystkie wieńce (obróbka bali w `rdzen/bale.rb`, siatka
  zamknięta, kolizje).

## 3. Dalej

Strop i antresola z belek (N1), wzór dobudówki z obrysami T i U (N4), okna dopasowane do wieńców (N2), grubszy bal (N5),
Dokumentacja 2D (W4), „buduj do wysokości”, podgląd na żywo po pomiarze; pytania Z9, D1a, H21, okucia (`docs/stan_prac.md` §6).
