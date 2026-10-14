# Scenariusz odbioru – kompilacja 3

Sprawdzenie w prawdziwym SketchUpie 2023. Przy problemie: zrzut ekranu + wiersze z `[ArteMadera GW]` z Konsoli Ruby
(Rozszerzenia → Programista → Konsola Ruby) albo raport z kroku 2.

1. **Instalacja.** Rozszerzenia → Menedżer rozszerzeń → Zainstaluj rozszerzenie → `arte_madera_generator_wiencowy_1.0.0.rbz`
   (zastępuje kompilację 2). Uruchom SketchUpa ponownie. W opisie rozszerzenia „Kompilacja 3 (2026-10-14)”.
2. **Test działania (najważniejsze).** Pusty model → Rozszerzenia → ArteMadera Generator Wieńcowy → „Test działania
   i raport do wysłania…”. Po kilku–kilkunastu sekundach okno zapisu: zapisz plik `ArteMadera_GW_raport_….json`
   (np. w Dokumentach). W okienku podsumowania każdy z 6 domów powinien mieć „w porządku”. **Prześlij ten plik** –
   z niego widać, czy bryły są zamknięte, czy objętości się zgadzają i ile trwa budowa. Model po teście jest pusty
   (domy testowe cofnięte).
3. **Zaznaczona ściana.** Narysuj prostokąt 4000 × 3000 narzędziem Prostokąt, kliknij raz ścianę (bez krawędzi) →
   Generuj dom… → okno otwiera się jak przy zaznaczonych liniach („Zaznaczono 4 linii”).
4. **Widok ściany.** W oknie, karta „Widok ściany”: wybierz W-1 z listy albo kliknij ścianę na rzucie. Bale z numerami
   pozycji, z lewej numery wieńców, przy narożnikach gniazda zamków. Zmień maks. długość bala na 3000 (podgląd) →
   czerwone kreski styków na przemian w kolejnych wieńcach. W-2 (szczytowa) → bale szczytu pod brązową linią dachu,
   białe gniazda płatwi.
5. **Zmienione pola.** Zmień kąt dachu na 30° → etykieta wyróżniona, w nagłówku sekcji „zmienione: 1”, w dymku
   „fabrycznie: 20”. Wpisz z powrotem 20 → wyróżnienie znika.
6. **Zestawienie CSV.** „Zapisz zestawienie (CSV)” przy liście bali → zapisz → otwórz w Excelu: kolumny, polskie znaki,
   liczby z przecinkiem, sumy grup i „Razem wszystko”.
7. **Generowanie.** „Generuj w modelu”. Konspekt: Dom > W-1…, Podłoga, Dach. Bryły bali szczytu i węgłów – pełne,
   bez dziur (otwórz do edycji „Bal szczytu …” z gniazdem płatwi).
8. **Dom z działową ze szczytem.** Prostokąt 8000 × 6000, działowa w poprzek kalenicy (od dłuższego boku do
   dłuższego), Szczyty → „Szczyty także na działowych: tak”, Układ dachu „płatwie i krokwie”: krokwie z obu stron
   szczytu działowej, nie wchodzą w bale; węgły na ścianach okapowych ścięte pod połacią.
9. **Belki w Dokumentacji 2D.** (gdy zainstalowana) Odśwież projekt: płatwie w grupie P, krokwie w K, legary L,
   podwaliny Pw, podciągi Pd. Bale – na razie w grupie E (do dopisania grup Bs / Kf / Sz).
10. **Przebudowa przesuniętego domu.** Przesuń wygenerowany dom (Przesuń, np. o 5 m) i obróć go → zaznacz →
    Generuj dom… → zmień liczbę wieńców → „Zastąp dom w modelu”: nowa wersja stoi w nowym miejscu, bez pytania
    o ręczne zmiany. Potem otwórz dom do edycji, przesuń jeden bal → ponowne „Zastąp…” pyta o ręczne zmiany.
11. **Zapamiętanie ustawień i szablony.** Zmień kilka parametrów → Podgląd → zamknij SketchUpa → uruchom ponownie →
    nowy dom z linii startuje z tymi parametrami („Parametry z ostatniego użycia”). Zapisz własny szablon, wczytaj
    wbudowany „Dom 1,5 kondygnacji”, usuń własny; „Przywróć fabryczne”.
12. **Kontrola i cofnij.** Zaznacz dom → „Kontrola zamków, styków i długości”: bez kolizji, mijanka, długości, styki
    w zamkach w porządku. Jedno Ctrl+Z po „Generuj w modelu” usuwa cały dom.
13. **Czas.** Dom ok. 10 × 8 m z działową, oknami, szczytami, dachem i podłogą – czas generowania (raport z kroku 2
    podaje czasy przykładowych domów).
