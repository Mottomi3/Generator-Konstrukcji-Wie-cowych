# Scenariusz odbioru – kompilacja 1

Sprawdzenie w prawdziwym SketchUpie 2023. Przy problemie: zrzut ekranu + wiersze z `[ArteMadera GW]` z Konsoli Ruby
(Rozszerzenia → Programista → Konsola Ruby).

1. **Instalacja.** Rozszerzenia → Menedżer rozszerzeń → Zainstaluj rozszerzenie → `arte_madera_generator_wiencowy_1.0.0.rbz`.
   Uruchom SketchUpa ponownie. W Menedżerze: „ArteMadera – Generator Wieńcowy”, w opisie „Kompilacja 1”.
2. **Rysunek.** Prostokąt 4000 × 3000 (narzędzie Prostokąt). Linia w środku od dolnego do górnego boku w odległości
   2000 od lewego (ściana działowa). Krótka linia ok. 300 mm w poprzek dolnego boku w odległości ok. 1000 (kontrfor).
3. **Okno.** Zaznacz wszystko (także ścianę prostokąta – nie przeszkadza) → Rozszerzenia → ArteMadera Generator Wieńcowy →
   Generuj dom… Sprawdź: rzut z W-1…W-6, wysokości ścian, tabela ścian, lista bali, brak błędów.
4. **Generowanie.** „Generuj w modelu”. Sprawdź: grupa „Dom wieńcowy” > W-1…W-6 (Konspekt), komponenty „Bal …”,
   „Kontrfor …-244” (Komponenty), tagi Ściany zewnętrzne / działowe / Kontrfory, bale z wycięciami w narożnikach,
   ostatki 100, działowa wystaje 100 na zewnątrz, półbal na dole dłuższych ścian.
5. **Bryły.** Otwórz jeden komponent bala do edycji: pełna bryła (Informacje o elemencie: „Bryła”), bez zbędnych linii,
   gniazda 40 × 36, podcięcia 2,5. Jeśli bryła ma dziury lub ściany są odwrócone – zrzut tego bala.
6. **Kontrola.** Zaznacz dom → menu → Kontrola zamków… → „bez kolizji”, mijanka i długości w porządku.
7. **Cofnij.** Ctrl+Z jednym krokiem usuwa dom; Ctrl+Y przywraca.
8. **Edycja.** Zaznacz dom → Generuj dom… (okno z parametrami domu) → liczba wieńców 10 → „Zastąp dom w modelu”.
   Stary dom znika, nowy jest niższy; w Komponentach nie zostają stare „Bal …”.
9. **Okno w ścianie.** W oknie: „+ okno” → W-1, od 1500, 1020 × 1010, parapet 900 → podgląd na rzucie (niebieski
   odcinek) → „Zastąp dom”. W ścianie W-1 otwór, bale przy oknie przecięte, pod parapetem i nad nadprożem wycięcia.
10. **Styki.** Maksymalna długość bala 4000 → podgląd: ściany 4200 mają styki (kolumna „Styki”), lista bali 1900 i 2300,
    nowe kontrfory. Generuj: styki na przemian w osiach dwóch kontrforów (jak 900 W-2), 400 mm od siebie.
11. **Ręczna zmiana.** Przesuń jeden bal → zaznacz dom → Generuj → „Zastąp” → pytanie o ręczne zmiany („Nie” – bez zmian).
12. **Dokumentacja 2D.** Zestawienie więźby na domu: bale rozpoznane jako elementy konstrukcyjne (grupa „Elementy”,
    dopóki nie dopiszemy Bs / Kf).
13. **Czas.** Dom ok. 8 × 6 m z działowymi i oknami – czas generowania (Konsola Ruby pokazuje etapy dłuższe niż 2 s).
