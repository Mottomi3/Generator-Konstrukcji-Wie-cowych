# Scenariusz odbioru – kompilacja 6

Sprawdzenie w prawdziwym SketchUpie 2023. Przy problemie: zrzut ekranu + wiersze z `[ArteMadera GW]` z Konsoli Ruby
(Rozszerzenia → Programista → Konsola Ruby) albo raport z kroku 2.

1. **Instalacja.** Rozszerzenia → Menedżer rozszerzeń → Zainstaluj rozszerzenie → `arte_madera_generator_wiencowy_1.0.0.rbz`
   (zastępuje kompilację 5). Uruchom SketchUpa ponownie. W opisie rozszerzenia „Kompilacja 6 (2026-10-26)”.
   Aplikacja do dachów (ArteMadera Roof) **3.7.0** zainstalowana – do kroków 5, 5a i 6.
2. **Test działania (najważniejsze).** Pusty model → Rozszerzenia → ArteMadera Generator Wieńcowy → „Test działania
   i raport do wysłania…”. Zapisz `ArteMadera_GW_raport_….json`. Każdy z 9 domów „w porządku” (ósmy: dach
   jednospadowy, dziewiąty: taras jak 1100). **Prześlij ten plik.** Model po teście pusty.
3. **Stolarka i luzy.** Prostokąt 5000 × 4000 → Generuj dom… → „Okna i drzwi”: nowe okno – szerokość i wysokość
   stolarki 1020 × 1010, luz górny pusty → w polu podpowiedź 20 (1,5 % wysokości), kolumna „Otwór w balach”
   1040 × 1030. Wpisz luz 30 → 1040 × 1040. W sekcji „Okna i drzwi – stolarka i luzy” luz boczny 5 → 1030 × …
   W widoku ściany otwór i przerywana stolarka w nim.
4. **Płatwie i szczyt.** Ten sam dom, widok ściany szczytowej: płatwie (fioletowe) wierzchem w linii dachu – ścięte po
   skosie (kalenicowa z dwóch stron), bale szczytu pełnym klinem do końca, bez urwanych końcówek. „Generuj w modelu”
   → w modelu płatwie ścięte, krokwie i deski leżałyby na całej szerokości.
5. **Dom na samych płatwiach – deski z aplikacji (nowe).** Prostokąt 6000 × 4500 → Generuj dom… (ustawienia
   fabryczne: układ dachu „same płatwie”, „Krokwie i poszycie – kto je buduje”: aplikacja; sekcja „Poszycie dachu”:
   deskowanie pełne – tak). Podpowiedź „Dach: poszycie z aplikacji… deskowanie na płatwiach”. „Generuj w modelu” →
   komunikat „Połacie dachu gotowe – zatwierdź poszycie…”, okno KROKU 2: krokwie wyłączone, zakładka Poszycie –
   deskowanie 25 × 100, zakładka Krokwie – „Płatwie pod połacią jako podpory” włączone. OK → deski wzdłuż spadku, leżą
   na płatwiach, styki nad płatwiami; raport: „Płatwie pod połaciami” (źródło: lista z wywołania innej wtyczki),
   „Bez krokwi: poszycie leży na płatwiach”, zakładka Poszycie (szt., m², m³). Wyłącz deskowanie w generatorze →
   podpowiedź-uwaga „same płatwie bez poszycia”.
5a. **Krokwie z aplikacji do dachów.** Układ dachu „płatwie i krokwie” → „Generuj w modelu”: okno KROKU 2 (kierunek „w
   górę”, bez płatwi kalenicowej i zamków dolnych, krokiew 50 × 150, rozstaw 900, deskowanie). OK → krokwie leżą na
   płatwiach, nie wchodzą w szczyty, deski na krokwiach; raport – Nośność: „Podpory pośrednie – … płatwie pod połacią
   i płatew u góry: przęsła …” (przęsła między płatwiami, nie od okapu do kalenicy). W generatorze włącz nadbitkę i OSB
   22 → w KROKU 2 te warstwy. Zmień kąt dachu → „Zastąp dom w modelu” → pytanie o więźbę poprzedniej wersji (także
   gdy przesunięto ją dalej od domu) → Tak → nowe połacie i KROK 2. Jedno Ctrl+Z cofa dom razem z połaciami.
   Aplikacja do dachów starsza niż 3.7.0: komunikat „…jest za stara – potrzebna 3.7.0 lub nowsza”; wyłączona
   w Menedżerze rozszerzeń: komunikat, że nie jest wczytana (dom powstaje).
6. **Dach jednospadowy.** „Dach”: jednospadowy, kąt 15°, płatwie i krokwie → podgląd i widok ścian: ściana niska
   (po stronie spadku), wysoka – do połaci (górny bal przycięty), szczyty skośne. Generuj z krokwiami z aplikacji:
   jedna połać, KROK 2; w raporcie podpory: płatwie i „Ściana wysoka W-…”. Z krokwiami z generatora – krokwie
   w jednym kawałku od okapu do okapu.
7. **Taras jak 1100.** Prostokąt 4000 × 4000, „Taras”: jak 1100, głębokość 2000, wejście z lewej, liczba wieńców 20
   → rzut dłuższy o taras, ściana domu jako działowa ze szczytem. Widoki: ściana boczna – nad tarasem dwa górne
   wieńce, pod nimi balustrada (bale i przekładki 300), front – podciąg i szczyt, słupy. „Generuj w modelu” → grupa
   i tag „Taras” ze słupami, bale balustrady w ścianach z tagiem „Taras”; drzwi w ścianie domu od strony tarasu.
8. **Taras jak 1200.** Prostokąt 7000 × 4000, taras jak 1200 → ściany boczne pełne do frontu, front bez bali, dach
   i płatwie nad tarasem.
9. **Jak w kompilacjach 4 i 5:** pola Podstawowe / Wszystkie, widok ściany (ostatki, węgły kliknięciem), działowa pod
   antresolą, strop nad parterem, pełny profil, zestawienie CSV, przebudowa przesuniętego domu, zapamiętanie ustawień,
   szablony, „Kontrola…”.
10. **Dokumentacja 2D (gdy wdrożone zadanie `docs/zadanie_dokumentacja2d.md`):** dom z generatora → grupy Bs / Kf / Sz,
    zamki jako zamki, płatwie jako ścięcie, bale w zakupach 44 × 139.
