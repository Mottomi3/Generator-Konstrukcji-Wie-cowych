# Scenariusz odbioru – kompilacja 2

Sprawdzenie w prawdziwym SketchUpie 2023. Przy problemie: zrzut ekranu + wiersze z `[ArteMadera GW]` z Konsoli Ruby
(Rozszerzenia → Programista → Konsola Ruby).

1. **Instalacja.** Rozszerzenia → Menedżer rozszerzeń → Zainstaluj rozszerzenie → `arte_madera_generator_wiencowy_1.0.0.rbz`
   (zastępuje kompilację 1). Uruchom SketchUpa ponownie. W opisie rozszerzenia „Kompilacja 2”.
2. **Rysunek.** Prostokąt 4000 × 3000. Linia w środku od dolnego do górnego boku 2000 od lewego (działowa).
3. **Okno.** Zaznacz → Rozszerzenia → ArteMadera Generator Wieńcowy → Generuj dom… Sprawdź: sekcje (rozwijane),
   pod polami szare podpowiedzi, u góry szablony; w wyniku „Szczyty: 2”, belki podłogi i dachu, „Podpowiedzi” (legary).
4. **Generowanie.** „Generuj w modelu”. Sprawdź w Konspekcie: Dom > W-1…, Podłoga, Dach. Tagi Szczyty, Podłoga, Dach.
   Szczyty na krótszych ścianach: bale ścięte pod 20°, płatwie przechodzą przez szczyty w gniazdach (bal przy spodzie
   płatwi z wycięciem od góry, wyżej przecięty), płatwie wystają 500 za szczyty.
5. **Bryły.** Otwórz do edycji „Bal szczytu …” ze skosem i gniazdem oraz „Podwalina …” z zakładem: pełne bryły, bez
   dziur i zbędnych linii. Jeśli coś jest nie tak – zrzut tego elementu.
6. **Krokwie przy szczycie.** Zaznacz dom → Generuj… → Szczyty i dach → Układ dachu „płatwie i krokwie”, Krokwie
   przy ścianie szczytowej kolejno: z obu stron, tylko od wewnątrz, na szczycie → „Zastąp dom”. Sprawdź: krokiew przy
   licu szczytu po właściwej stronie; przy „na szczycie” szczyt niższy, krokiew leży na balach.
7. **Węgły.** Nowy prostokąt 6000 × 4000 (bez działowej), maks. długość bala 7000 → po jednym węgle 244 w środku
   ścian 6 m (światło 5912 > 4800). Rozmieszczenie „od narożników” → węgły 800 od narożników. Domyślne 5100 → łączenie
   na przemian w dwóch węgłach (kolumna „Styki”).
8. **Podłoga.** Legary „ręczny” 50x100 na domu 6000 × 5000 → podpowiedź (nośność, ugięcie), dodane podpory pod
   legarami. Izolacja 150 przy legarze 100 → czerwona podpowiedź „niższy niż izolacja”. Tryb „zalecany” → przekrój ≥ 150.
9. **Zapamiętanie ustawień.** Zmień np. kąt dachu na 30° (podgląd), zamknij SketchUpa, uruchom ponownie, narysuj nowy
   prostokąt → Generuj dom… → kąt 30° i informacja „Parametry z ostatniego użycia”.
10. **Szablony.** Wpisz nazwę → „Zapisz jako szablon” → zmień parametry → wybierz szablon → „Wczytaj” → wartości wracają.
    „Dom 1,5 kondygnacji (wbudowany)” → 25 wieńców, węgły już na ścianach ok. 4 m. „Przywróć fabryczne”.
11. **Kontrola.** Zaznacz dom → menu → Kontrola zamków… → „bez kolizji”, mijanka i długości w porządku.
12. **Cofnij / edycja / ręczna zmiana** – jak w kompilacji 1 (jedno Ctrl+Z, „Zastąp dom”, pytanie o ręczne zmiany).
13. **Czas.** Dom ok. 8 × 6 m z działowymi, oknami, szczytami, dachem i podłogą – czas generowania (Konsola Ruby).
