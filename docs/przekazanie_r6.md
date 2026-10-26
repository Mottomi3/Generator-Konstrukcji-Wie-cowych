# Przekazanie po rundzie 6 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`, publiczne) – `add_repo` (push) i
   `git clone https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych`. Zapas: `repozytorium_r6.bundle` na dysku
   (`C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\`).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md`, ten plik; potem szukaj w `docs/SPIS_TRESCI.md`.
3. Aplikacja do dachów **3.7.0 lub nowsza** obok repozytorium (`add_repo` Mottomi3/Aplikacja-do-konstrukcji-dach-w
   i `git clone … ../aplikacja-do-konstrukcji-dach-w` albo `AM_GW_APLIKACJA_DACHOW`) – bez niej zestaw „dach_aplikacja”
   jest pomijany z uwagą. `bash testy/uruchom.sh` → `WSZYSTKIE ZESTAWY: FAILURES 0` przed zmianą (ok. 7 min; Ruby 2.7 –
   `bash testy/ruby27.sh` zbuduje go, gdy nie ma `/opt/ruby27`, ok. 10 min).
4. Raport z testu działania (`ArteMadera_GW_raport_*.json`): jak w `przekazanie_r3.md` §0.4 – 9 przykładowych domów.

## 1. Mapa plików (nowe i zmienione w rundzie 6)

| Temat | Plik |
|---|---|
| Ustawienia KROKU 2 (kierunek, krokwie albo poszycie na płatwiach, warstwy poszycia, klasa drewna), podpory z płatwi i ściany wysokiej, podpowiedź KROKU 2 | `rdzen/krok2.rb` |
| Połacie także przy samych płatwiach (`z_aplikacji?` = `dach_wiezba` aplikacja) | `rdzen/polacie.rb` |
| Wywołania API aplikacji (polacie, podpory, wiezba z oknem, więźba po OK z id domu, przebudowa po id), brak / stara aplikacja | `sketchup/dach_aplikacja.rb` |
| Sekcja „Poszycie dachu” (14 parametrów), etykieta `dach_wiezba` | `rdzen/parametry_lista.rb` |
| Atrapa API aplikacji | `testy/atrapa/aplikacja_dachow.rb` |
| Testy | `testy/t_dach_aplikacja.rb`, `testy/t_polacie.rb`, `testy/sprawdz_dach_aplikacja.rb` (prawdziwa 3.7.0, 8 domów), `testy/losowe_domy.rb#podpory_poza` |
| Zadanie dla aplikacji do dachów – część 2 | `docs/zadanie_aplikacja_dachow.md` |

## 2. Runda 6

Decyzje i wykonanie: `docs/stan_prac.md` §5 „Runda 6”, zasady: `docs/specyfikacja.md` §8 (krokwie i poszycie – kto je
buduje). Pytania R3–R5 w `docs/stan_prac.md` §6.

Sesja w jednym kawałku (bez gałęzi roboczej). Wywołania aplikacji: tylko `ArteMadera::Roof::API` (opis w jej `API.md`);
kalenicowa podawana 1 mm pod grzbietem – po poprawce w aplikacji (zadanie, część 2, punkt 1) wrócić do grzbietu
(`Krok2::GRZBIET_NIZEJ` = 0 i test w `t_polacie.rb`).

## 3. Zasady

`CLAUDE.md` + `docs/skille/gw-zasady-kodu/SKILL.md` (kod) + `docs/skille/gw-runda/SKILL.md` (runda).

## 4. Luki

- Nadal brak odbioru w prawdziwym SketchUpie – raport z testu działania (9 domów) i scenariusz kompilacji 6.
- Domyślny dom (same płatwie) z aplikacją do dachów otwiera teraz KROK 2 po każdej budowie; bez aplikacji – komunikat
  w oknie (dom powstaje). Wyłączenie: „Krokwie i poszycie – kto je buduje” = generator.
- Aplikacja do dachów: kalenica w obu połaciach, dach jednospadowy (wspornik za ścianą wysoką, rozpór), osie krokwi
  przy szczycie, `:zapisz => false` dla okna – część 2 zadania.
- Taras i Dokumentacja 2D – jak po rundzie 5.

## 5. Następne kroki

Raport i scenariusz odbioru kompilacji 6 → poprawki → po zmianach w aplikacji do dachów (część 2): osie krokwi przy
szczycie z generatora, kalenicowa w grzbiecie → po Dokumentacji 2D: grupy Bs, Kf, Sz → szczegóły tarasu.
