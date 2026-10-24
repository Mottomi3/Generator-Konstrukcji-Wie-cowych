# Scenariusz odbioru – kompilacja 4

Sprawdzenie w prawdziwym SketchUpie 2023. Przy problemie: zrzut ekranu + wiersze z `[ArteMadera GW]` z Konsoli Ruby
(Rozszerzenia → Programista → Konsola Ruby) albo raport z kroku 2.

1. **Instalacja.** Rozszerzenia → Menedżer rozszerzeń → Zainstaluj rozszerzenie → `arte_madera_generator_wiencowy_1.0.0.rbz`
   (zastępuje kompilację 3). Uruchom SketchUpa ponownie. W opisie rozszerzenia „Kompilacja 4 (2026-10-24)”.
2. **Test działania (najważniejsze).** Pusty model → Rozszerzenia → ArteMadera Generator Wieńcowy → „Test działania
   i raport do wysłania…”. Okno zapisu: zapisz `ArteMadera_GW_raport_….json`. W okienku podsumowania każdy z 7 domów
   „w porządku” (siódmy: pełny profil, działowa pod antresolą, ostatek 200, węgieł ręczny). **Prześlij ten plik.**
   Model po teście pusty.
3. **Pola Podstawowe / Wszystkie.** Zaznacz linie → Generuj dom… → nad sekcjami przełącznik „Pola”: w „Podstawowe”
   kilkanaście najczęstszych pól; „Wszystkie” – pełna lista. Zmień w „Wszystkie” np. mijankę na 500, wróć do
   „Podstawowe” – pole mijanki widać (zmienione). Zamknij i otwórz okno ponownie – tryb zapamiętany.
4. **Widok ściany – ostatek i węgły.** Dom 7000 × 4500 z działową. W widoku W-1 pod rysunkiem „Ustawienia ściany”:
   ostatek lewego końca 200 → podgląd: bale W-1 dłuższe o 100 z tej strony. Kliknij w rysunek ściany między węgłami →
   nowy węgieł (pogrubiony opis), w panelu „ustawione ręcznie”. Kliknij przy węgle (przerywana linia) → znika.
   „Przywróć automatyczne” → węgły jak wcześniej, ostatek 200 zostaje.
5. **Działowa pod antresolą.** Prostokąt 6000 × 4200, działowa w poprzek na x = 2000, liczba wieńców 20. Widok W-5 →
   „Nad działową: antresola”, góra 2450 → działowa kończy się niżej (2363), nad nią przy obu ścianach okapowych kolumna
   odcinków 244 aż pod dach (ostatni ścięty połacią). „Generuj w modelu” → sprawdź odcinki i zamki w modelu.
   To samo z ostatkiem 200 – odcinki 344.
6. **Strop nad parterem.** Wczytaj szablon „Dom 1,5 kondygnacji ze stropem nad parterem” (25 wieńców, strop 2780) →
   wszystkie działowe kończą się pod stropem (20 wieńców), z dopełnieniem zamka. Działowa ustawiona w widoku na
   „nic – pełna wysokość” zostaje pełna.
7. **Pełny profil.** Przekrój bala → „Profil bala w modelu: pełny profil” → Generuj. W modelu przybliż narożnik: na
   czołach bali dwa pióra na wierzchu i wpusty od spodu, pierwszy wieniec bez wpustu, w zamku pióro wycięte. Otwórz
   komponent bala – bryła pełna, bez dziur (Informacje o elemencie: bryła / solid).
8. **Jak w kompilacji 3:** zaznaczona sama ściana prostokąta, zestawienie CSV, przebudowa przesuniętego domu (zostaje
   na miejscu), zapamiętanie ustawień po ponownym uruchomieniu SketchUpa, szablony (nowe: „Dom 1,5 kondygnacji ze
   stropem nad parterem”, „Pełny profil bala”), „Kontrola…”, jedno Ctrl+Z po generowaniu.
9. **Czas.** Dom ok. 10 × 8 m z działową, oknami, szczytami, dachem i podłogą – czas generowania z prostym i pełnym
   profilem (raport z kroku 2 podaje czasy przykładowych domów).
