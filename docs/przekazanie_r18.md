# Przekazanie po rundzie 18 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`) – `add_repo` (push); w sesji zwykle już
   sklonowane w `/home/claude/generator-konstrukcji-wie-cowych` (sprawdź `git rev-parse HEAD`, nie klonuj drugi raz).
   Użytkownik chce repozytorium prywatnego – przełącza sam w ustawieniach GitHuba (`docs/przekazanie_r14.md` §5).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md` (§5 kolejka, §6 pytania), ten plik, `docs/zadanie_r18.md` (§0 – odpowiedzi
   użytkownika z polecenia rundy 19, §1–3 – zakres), potem `docs/SPIS_TRESCI.md`.
3. Folder na dysku: `C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych` – `device_request_folder_access`
   (w rundach 17 i 18 zgoda przyszła od razu). Najpierw `raporty\` (na starcie rund 15–18 folderu nie było – kompilacje 14–17
   nie były uruchamiane). Kopia na dysk: paczka `repozytorium_rN.bundle` przez `device_commit_files`, w `device_bash`
   `git clone` paczki do katalogu roboczego i `cp -r` katalogów `Plugins`, `testy`, `docs` oraz plików (usuwanie na dysku
   wyłączone – pliki usunięte w repozytorium zostają na dysku; w rundzie 18 nic nie usunięto).
4. Aplikacja do dachów obok repozytorium (`add_repo` do odczytu → `git clone --depth 1` do
   `/home/claude/aplikacja-do-konstrukcji-dach-w`, 3.12.0). Testy na kopii katalogu z
   `AM_GW_APLIKACJA_DACHOW=/home/claude/aplikacja-do-konstrukcji-dach-w PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers
   NODE_PATH=$(npm root -g) bash testy/uruchom.sh` – ok. 15–20 min na 2 rdzeniach.
5. Losowe domy: `ruby -I testy/atrapa testy/losowe_domy.rb 600 6001` (ok. 17 min, od rundy 18 z kanałami na przewody),
   złożone: `ruby -I testy/atrapa testy/zlozone_domy.rb 300 10001` (6 min). Znane w 6001–6600: 6305, 6557 (krawędź bryły
   bala szczytu < 0,1 mm).
6. W poleceniu rundy 18 odpowiedź 1 (układ okna) brzmiała „nie sprawdzałem” – pytanie zadane od razu ze zrzutem
   `docs/uklady_okna_r17.png`, bez odpowiedzi do końca rundy. Jeśli w poleceniu rundy 19 też jej nie ma – zapytaj od razu.

## 1. Mapa plików (nowe i zmienione w rundzie 18)

| Temat | Plik |
|---|---|
| Parametry stolarki (lista, folder, prosty model, maskownice) | `rdzen/parametry_stolarka.rb` (nowy – przeniesione z `parametry_lista.rb`) |
| Prosty model okna i drzwi (części, siatki, nazwa) | `rdzen/stolarka_prosta.rb` (nowy) |
| Plik modelu: pełna ścieżka w kolumnie „Model”, rodzaj otworu | `rdzen/stolarka_modele.rb#plik`, `#pelna_sciezka?`, `#rodzaj`, `#do_wstawienia` |
| Wstawienie: plik albo prosty model, materiał szyby, rola skip | `sketchup/stolarka_modele.rb#wstaw`, `#definicja`, `#prosta`, `#material_szyby`; `sketchup/budowa.rb` (dom_id) |
| Wybór ścieżki („…”) | `sketchup/okno_sciezki.rb` (nowy), `html/sciezka.js` (nowy), `html/tabela.js` (kolumna `plik`), `html/standard.js`, `html/okno.js#dodajPole`, cecha `sciezka:` przy polu |
| Test działania – stolarka poza drewnem | `sketchup/raport.rb#liczby_modelu` |
| Przełącznik doboru w typie | `rdzen/parametry_materialy.rb` (`poziom: :typ`), `rdzen/parametry_lista.rb#SZABLONY` (Typ 300, 400 – auto) |
| Dom L – słupki pod końcami płatwi skrzydła w koszu | `rdzen/podpory_platwi_l.rb` (nowy), `rdzen/projekt.rb#podpory_l`, `rdzen/statyka_dachu.rb#przeslo` (`d[:podpory_kosz]`), `rdzen/materialy.rb#laczniki_platwi_l` |
| Taras 300 – front ze szczytem | `rdzen/taras.rb#front_z_balami?` (z_polbal, zasięg, opis), `rdzen/taras_szczyt.rb#dotyczy?`, `#bez_bali?`, `rdzen/styki_tarasu.rb#dotyczy?`, `#planuj`, `rdzen/zamek_platwi.rb#tylko_spod?`, `rdzen/parametry_taras.rb` (`taras_sciany_front`, warunki `gdy`) |
| Płatwie dzielone nad ścianą (P3) | `rdzen/podzial_belek.rb` (nowy), `rdzen/dach.rb#elementy` (`e[:podpory]`), `rdzen/projekt.rb#belki` |
| P5 | `rdzen/sciecie_dachu.rb#sciecie` (ścięcie ≥ 0,2 mm), `rdzen/dzialowe_bliskie.rb` (nowy) + `rdzen/obrys.rb#rozpoznaj`, `rdzen/szczyty.rb#gniazda_sciany` (gniazdo pod bokiem płatwi), `rdzen/polacie.rb#dla_domu_l` (+ deska podbitki) |
| Kanały na przewody (N3) | `rdzen/kanaly.rb` (nowy), `rdzen/parametry_kanaly.rb` (nowy), `rdzen/bryla.rb#kanal_pasow` (+ `profil`, `obrocone`), `rdzen/profil_bala.rb#przedzialy`, `rdzen/widok.rb` (`kanaly`), `html/kanaly.js` (nowy), `html/klik_sciana.js` (tryb `kanal`, eksport okienka), `html/sciana.js#kanaly`, `html/okno.html` (`#lista-kanalow`), `sketchup/sterowanie.rb`, `sketchup/okno.rb` (`kanaly` w wejściu domu) |
| Testy | `testy/t_kanaly.rb` (nowy); `t_stolarka.rb`, `t_skrzydla.rb`, `t_taras.rb`, `t_dlugosci.rb`, `t_losowe.rb` (ziarna 6110, 6269, 6311, 6430, 6444, 6495, 7021), `t_poziomy.rb`, `t_sketchup.rb`, `t_okno.js` (kanał kliknięciem, pole ze ścieżką), `t_okno_kroki.js` („…” w liście stolarki); `losowe_domy.rb` (kanały od ziarna 6001, kolizje słupków S z P i Pb, `kanaly` w `sprawdz`), `podglad.rb` (dom `koszL`) |
| Rysunki | `docs/kosz_slupek_r18.png`, `docs/stolarka_prosta_r18.png` |

## 2. Jak to działa – rzeczy nieoczywiste

- **Prosty model**: definicja na rodzaj i wymiar (`StolarkaProsta.nazwa`), każda część w swojej grupie (ściany części
  stykających się nie scalają się), siatka części z `Pryzmat.siatka` przesunięta o `min`. Układ jak model użytkownika:
  y = 0 – lico zewnętrzne, rama y 0…t, maskownice y −g…0. Definicja ma `dom` w słowniku GW – przebudowa usuwa nieużywane.
- **Ścieżka**: `StolarkaModele.plik` – najpierw pełna ścieżka z „Model” (`C:\…`, `\\serwer\…`, `/…`), potem nazwa w folderze.
  Okno: przycisk „…” wysyła `wybierz_sciezke({ id, rodzaj, poczatek })`, Ruby odpowiada `AMGW_SCIEZKA.wybrana`, pole dostaje
  zdarzenie `change` (jak po wpisaniu).
- **Słupki w koszu**: `Skrzydla.koniec_w_dachu_glownym` zwraca koniec przy licu płatwi głównej (gdy zachodzą wysokością)
  albo w koszu (v_t). Przy licu – styk (łącznik). W koszu – najbliższa końcowi płatew główna, której wierzch jest pod spodem
  płatwi skrzydła i której oś leży po stronie szczytu skrzydła od końca; słupek `b_skrzydła × b_głównej` od jej wierzchu
  (najwyższego – `z_spod + h`) do spodu płatwi skrzydła. Przekrój słupka zależy od osi skrzydła (`d[:os]`).
- **Front tarasu 300**: znacznik `w[:taras][:z_polbal]` (ustawiany dla frontu z balami) rozstrzyga o balach frontu, zamku
  płatwi od spodu, opisie; `Taras.front_z_balami?(tr, p)` – w szczytach i stykach. Słupów w typie 300 nie ma – styki frontu
  w punktach równego podziału.
- **Podział płatwi**: miejsca styku z `e[:podpory]` (przejścia płatwi przez ściany, x od początku belki), zachłannie
  najdalsza w zasięgu najdłuższej handlowej (`MIN_KAWALEK` 300 od końców). Kawałek = `e.merge` z przesuniętym początkiem;
  wręby przycięte do kawałka (wrąb w osi ściany dzieli się na dwa półwręby).
- **Kanał**: obróbka `kanal` (x0…x1 wzdłuż bala, y0…y1 w poprzek) dzieli pasy przekroju w przedziale profilu na część
  przed i za otworem (`Bryla.kanal_pasow`, także w pełnym profilu); siatka ma otwory w wierzchu i spodzie (pętle wewnętrzne).
  `puszka` nie zmienia bryły – jest w podpisie pozycji (bal z puszką to osobna pozycja), `strona` odwracana przy obrocie.
- **Działowe bliskie**: łączone po klasyfikacji linii, przed budową ścian; oś dłuższej, zasięg sumy (z zapasem grubości).

## 3. Zostało na rundę 19

`docs/zadanie_r18.md`. W skrócie: wybór układu okna (po odpowiedzi), uwagi z SketchUpa, modele stolarki użytkownika,
odpowiedzi o słupkach w koszu, froncie tarasu 300 i „typ + dodatki”; P5 reszta (6305, 6557); dalej N4 / N1.

## 4. Pomiary z rundy 18 (do porównań)

| Co | Kompilacja 17 | Kompilacja 18 |
|---|---|---|
| Domy z problemami (600 domów: 6001–6600; od k18 część z kanałami) | 10 (znane) | 2 (6305, 6557 – krawędź < 0,1 mm) |
| Domy złożone z problemami (300: 10001–10300) | 0 | 0 |
| Parametry | 193 | 205 |
| Zestawy testów / sprawdzenia | 37 / ok. 2360 | 38 / ok. 2470 |
