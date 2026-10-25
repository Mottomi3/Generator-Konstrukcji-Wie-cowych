# ArteMadera – Generator Wieńcowy

Wtyczka SketchUp 2023: z narysowanego obrysu domu (lico zewnętrzne), osi ścian działowych i linii węgłów tworzy
dom z bali 44 mm: ściany z zamkami narożnymi, węgłami 244 (pod styki i usztywniające), łączeniem bali na mijankę,
otworami (wymiary stolarki z luzami), szczytami z gniazdami płatwi, płatwiami ściętymi do płaszczyzny dachu, dachem
dwuspadowym albo jednospadowym, tarasem (jak 1100 albo 1200) oraz podłogą (podwaliny, legary dobrane statycznie).
Krokwie i dalszą więźbę z kontrolą nośności buduje aplikacja do dachów ArteMadera Roof (połacie i KROK 2 z generatora);
krokwie uproszczone – w generatorze (opcja).
Każdy bal i belka to komponent z wycięciami i atrybutami dla wtyczki ArteMadera Dokumentacja 2D. Wszystkie ustawienia
są parametrami w oknie (`docs/parametry.md`; pola Podstawowe / Wszystkie), zapamiętywanymi na komputerze, z szablonami.
W widoku ściany: ostatek każdego końca, węgły kliknięciem, działowa niższa pod stropem / antresolą / półką (zamek
dopełniony odcinkami); bal prosty albo pełny profil (pióra i wpust) do wizualizacji.

- Instalacja: Rozszerzenia → Menedżer rozszerzeń → Zainstaluj rozszerzenie → `arte_madera_generator_wiencowy_1.0.0.rbz`.
- Użycie: zaznacz linie → Rozszerzenia → ArteMadera Generator Wieńcowy → Generuj dom…
- Dokumentacja: `docs/specyfikacja.md`, parametry: `docs/parametry.md`, stan prac: `docs/stan_prac.md`,
  mapa kodu: `docs/SPIS_TRESCI.md`.
- Testy: `bash testy/uruchom.sh`.
