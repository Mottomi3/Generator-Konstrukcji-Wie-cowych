# Przekazanie po rundzie 15 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`) – `add_repo` (push); w sesji zwykle już
   sklonowane w `/home/claude/generator-konstrukcji-wie-cowych` (sprawdź `git rev-parse HEAD`, nie klonuj drugi raz).
   Użytkownik chce repozytorium prywatnego – przełącza sam w ustawieniach GitHuba (`docs/przekazanie_r14.md` §5).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md` (§5 kolejka decyzji, §6 pytania), ten plik, `docs/zadanie_r15.md` (§0.7 –
   co wykonano i co czeka na akceptację, §1–4 – zakres rund 16–17), potem `docs/SPIS_TRESCI.md`.
3. Folder na dysku: `C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych` (zwykle już podłączony –
   `get_device_info`). Najpierw `raporty\` (na starcie rundy 15 folderu nie było – kompilacja 14 nie była uruchamiana).
   Kopia na dysk najprościej: paczka `repozytorium_rN.bundle` przez `device_commit_files`, potem w `device_bash`
   `git clone` paczki do katalogu roboczego i `cp -r` katalogów `Plugins`, `testy`, `docs` oraz plików do folderu
   (usuwanie plików na dysku jest wyłączone – w rundzie 15 nic nie usuwano).
4. Aplikacja do dachów obok repozytorium (`../aplikacja-do-konstrukcji-dach-w`, 3.12.0). Testy uruchamiaj na kopii
   katalogu (`cp -r Plugins testy docs CLAUDE.md README.md /home/claude/kopie/x`) z
   `AM_GW_APLIKACJA_DACHOW=/home/claude/aplikacja-do-konstrukcji-dach-w bash testy/uruchom.sh` – ok. 13 min na 2 rdzeniach,
   ostatnia linia `WSZYSTKIE ZESTAWY: FAILURES 0`. W tle można wtedy pracować dalej w repozytorium.
5. Losowe domy: `ruby -I testy/atrapa testy/losowe_domy.rb 300 6001` (ok. 8 min), złożone:
   `ruby -I testy/atrapa testy/zlozone_domy.rb 120 10001`. Ziarna od 9000 losują nowości rundy 15.
6. Nie było Rubiego 2.7 (`/opt/ruby27`) – zestaw „Ruby 2.7” pominięty.

## 1. Mapa plików (nowe i zmienione w rundzie 15)

| Temat | Plik |
|---|---|
| Szczyt na styk: wieniec szczytu, siatki styków, strefy zakazane | `rdzen/styki_szczytu.rb` (nowy) |
| Ściana pod szczytem jak zwykła, węgieł pod styk do wysokości ściany (`do_gory_sciany`) | `rdzen/styki.rb#planuj`, `#kotwice`, `rdzen/wience.rb#dla_sciany` |
| Styki w kawałku wieńca szczytu | `rdzen/bale.rb#kawalki_wienca` |
| Kontrola: styk na styk w szczycie nie jest „stykiem bez zamka” | `rdzen/kontrola.rb#styki_bez_zamka` |
| Pół zamka: głębokości gniazd, oznaczenie bala | `rdzen/pol_zamka.rb` (nowy) |
| Bal zostaje w narożniku z pół zamkiem | `rdzen/skos_przy_narozniku.rb#w_zamku?` |
| Gniazda półzamka w obróbkach | `rdzen/zamek.rb#nanies` |
| Deski 14 × 115, nadbitka fabrycznie, parametry pół zamka | `rdzen/parametry_dach.rb` |
| 45 × 120 w 5,4 / 6 m | `rdzen/wykaz_drewna.rb` (KONSTRUKCYJNE) |
| Plik ustawień wersja 4 | `sketchup/ustawienia.rb` (WERSJA, DESKI, DO_FABRYCZNYCH, DO_FABRYCZNYCH_W_SZABLONACH) |
| Osiadanie: luz, okucie, skrócenie słupa, podpowiedź | `rdzen/osiadanie.rb` (nowy) |
| Słup tarasu krótszy, `e[:osiadanie]` | `rdzen/taras_slupy.rb#slup`, parametry w `rdzen/parametry_taras.rb` |
| Zestawienie materiałów | `rdzen/materialy.rb` (nowy), parametry `rdzen/parametry_materialy.rb` (nowy), sekcja `materialy` w `rdzen/parametry_lista.rb` |
| Materiały w planie, oknie i CSV | `rdzen/projekt.rb#przebieg` (`plan[:dach]`, `plan[:materialy]`), `sketchup/sterowanie.rb#dla_okna`, `html/okno.html` (`tab-materialy`), `html/wyniki.js`, `rdzen/zestawienie.rb#csv` |
| Parametr `szczyt_styk` | `rdzen/parametry_lista.rb` (sekcja `laczenia`) |
| Testy | `testy/t_styki_szczytu.rb`, `t_osiadanie.rb`, `t_materialy.rb`, `t_pol_zamka.rb` (nowe); zmienione wartości fabryczne w `t_polacie`, `t_dach_aplikacja`, `t_podbitka`, `t_taras`, `t_szczyty`, `t_sketchup`, `t_dlugosci`, `t_okno.js`, `sprawdz_dach_aplikacja.rb`; `testy/losowe_domy.rb` (ZIARNA_R15 = 9000, `dodatki_r15`, pół zamka w kontroli narożnika) |
| Dokumenty do akceptacji | `docs/ostatnie_polaczenie_r15.png`, `docs/pol_zamka_r15.png`, `docs/podzial_pol_r16.md`, `docs/szkic_okna_r16.html`, `.png` |

## 2. Runda 15

Polecenie – `docs/prompt_r15.md`; zakres – `docs/zadanie_r15.md` §0, wykonanie §0.7; zasady – `docs/specyfikacja.md` §8j.

Ustalenia:
- **Wieniec szczytu** = wieniec o spodzie na górze ściany bez szczytu (`Szczyty.gora_wlasna`) albo wyżej. Styki liczone
  dla każdego kawałka wieńca osobno w `Bale.kawalki_wienca` (po gniazdach płatwi i otworach), na dwóch siatkach o kroku
  2 × mijanka przesuniętych o mijankę – mijanka sąsiednich wieńców wynika z konstrukcji siatek.
- Ziarno 6502 z zadania to ściana wysoka dachu jednospadowego (szczyt płaski) – szczyt na styk jej nie dotyczy; styk bez
  zamka zostaje tam, bo węgieł kończy się 220 mm pod linią dachu (podbitka pod płatwiami). Propozycja w kolejce: traktować
  to jak styk na styk z mijanką (podpowiedź zamiast ostrzeżenia).
- **Pół zamka**: pierwszy rysunek (przekrój narożnika) użytkownik uznał za niezrozumiały; drugi pokazuje frezowanie dwóch
  bali osobno, „dziś” i „propozycja”. Zasada w kodzie: suma gniazd zwykłego zamka (2 × `gniazdo_gleb`) w całości w balu
  niższym. Kod jest, przełącznik `polzamek` fabrycznie „nie” – po akceptacji zmienić wartość domyślną w
  `rdzen/parametry_dach.rb`, uruchomić wszystkie zestawy i losowe domy, dopisać górę węgła (`Bale.kontrfor_obecny?`:
  dziś ostatni bal węgła powstaje od 56 mm pod podparciem; z pół zamkiem od 20 mm, bez gniazda od spodu, a bal ściany
  nad nim bez gniazda).
- Nadbitka fabrycznie: przy podbitce z generatora (pod płatwiami, na płatwiach) nadbitka zostaje włączona jako poszycie –
  testy podbitki sprawdzają teraz, że sama podbitka jej nie włącza.
- Zmiana wartości fabrycznej, którą okno zapisuje przy każdym podglądzie („ostatnie”), wymaga wpisu w
  `Ustawienia::DO_FABRYCZNYCH` i nowej wersji pliku – inaczej u użytkownika zostaje stara wartość.

Liczby: 32 zestawy testów; 600 losowych domów po punkcie 1 bez nowych problemów (4 znane sprzed rundy: 94, 153, 6110,
6269); 200 domów z pół zamkiem włączonym – bez nowych problemów.

## 3. Zasady

`CLAUDE.md` + `docs/skille/gw-zasady-kodu/SKILL.md` + `docs/skille/gw-runda/SKILL.md`. Z tej rundy:
- Rysunek dla użytkownika: nie przekrój konstrukcyjny, tylko „dziś / propozycja” dla każdego elementu osobno (jak rysunek
  frezowania), z jednym pytaniem. Użytkownik odpowiada w trakcie pracy – pytania wysyłać od razu, nie na końcu.
- Wartość fabryczna, na którą czeka decyzja użytkownika: kod za parametrem, wyłączony – runda nie stoi.
- Parametry nowego tematu w osobnym pliku sekcji (`rdzen/parametry_materialy.rb`), nie w `parametry_lista.rb`.
- Długie testy na kopii katalogu w tle; w repozytorium w tym czasie można pisać dalej.

## 4. Luki

- Czekają na odpowiedź użytkownika: pół zamka (wymiary), podział pól i szkic okna, potwierdzenie nadbitki fabrycznie.
- Pół zamka tylko w narożniku; góra węgła – nie. Szczyt płaski bez zmian (styk bez zamka w najwyższym wieńcu).
- Okucia w zestawieniu mają nazwy ogólne; nie ma cen. Powierzchnia dachu obrysu L – w przybliżeniu.
- Słupy bocznego zadaszenia bez skracania o osiadanie. Okucie regulacyjne nie jest rysowane w modelu.
- W prawdziwym SketchUpie niesprawdzone: wszystko z kompilacji 14 (pasek, menu pod prawym przyciskiem, zapis raportu,
  okienko po awarii) i z kompilacji 15 (tabela materiałów w oknie, nowe pola).
- Ze wcześniejszych rund: `docs/stan_prac.md` §8.

## 5. Następne kroki

Runda 16 – `docs/prompt_r16.md`: po odpowiedziach użytkownika pół zamka fabrycznie i na górze węgła, potem trzy poziomy
ustawień z typami domów i okno z wynikiem zawsze na widoku (według `docs/podzial_pol_r16.md` i `docs/szkic_okna_r16.png`),
opcje wyszarzone dla obrysu, dom prostokątny z wymiarów (S1), powierzchnie i limity (W1). Runda 17 – klikanie okien,
drzwi, węgłów i kanałów, magazyn drewna, wycena. Runda 18 – podparcia płatwi, belki dzielone, drobne błędy geometrii.
