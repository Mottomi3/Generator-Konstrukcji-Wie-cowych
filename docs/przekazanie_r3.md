# Przekazanie po rundzie 3 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (prywatne, gałąź `main`) – `add_repo` (push) i
   `git clone https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych`. Zapas: `repozytorium_r3.bundle` na dysku
   (`C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\`).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md`, ten plik; potem szukaj w `docs/SPIS_TRESCI.md`.
3. `bash testy/uruchom.sh` → `WSZYSTKIE ZESTAWY: FAILURES 0` przed jakąkolwiek zmianą (ok. 1 min; zestaw Ruby 2.7
   pominięty z uwagą, gdy nie ma `/opt/ruby27` – `bash testy/ruby27.sh` zbuduje go w ok. 10 min).
4. Gdy użytkownik przyśle raport z testu działania (`ArteMadera_GW_raport_*.json`): sprawdź `przyklady[].zgodny`,
   `niezamkniete`, `inna_objetosc`, `bledne_sciany`, `wyjatek`, czasy i `dziennik.wpisy` (błędy z śladem). Liczby
   `plan` porównaj z obliczeniem w kontenerze (`rdzen/przyklady.rb`, ta sama kompilacja) – różnica = inny Ruby albo API.

## 1. Mapa plików (nowe i zmienione w rundzie 3)

| Temat | Plik |
|---|---|
| Bale pod połacią (węgły, działowe bez szczytu), ostrzeżenie o stromym dachu | `rdzen/pod_dachem.rb` |
| Kawałki bali: zasięg i skos (szczyt / pod dachem), styki tylko w za długich kawałkach, okruchy | `rdzen/bale.rb` |
| Mijanka między regionami łączenia; ściana ze szczytem – kotwice tylko na węgłach | `rdzen/styki.rb` |
| Krokwie przy szczytach na działowych; linia skosu (`skosy_linii`), linia podparcia | `rdzen/dach.rb`, `rdzen/szczyty.rb` |
| Kontrola „styk bez zamka” | `rdzen/kontrola.rb` (ostrzeżenie: `rdzen/projekt.rb#uwagi_o_stykach`) |
| Scalanie punktów podziału bryły < 0,2 mm | `rdzen/bryla.rb` (`SCAL`, `punkty_podzialu`) |
| Prefiksy belek = grupy Dokumentacji 2D (P, K, Pd, L, Pw) | `rdzen/elementy.rb` |
| Widok ściany (dane / rysunek) | `rdzen/widok.rb` / `html/sciana.js` |
| Zestawienie CSV / zapis pliku | `rdzen/zestawienie.rb` / `sketchup/eksport.rb` |
| Test działania i raport, przykładowe domy | `sketchup/raport.rb`, `rdzen/przyklady.rb` |
| Pola zmienione względem fabrycznych | `html/zmiany.js` |
| Zaznaczona ściana jako obrys | `sketchup/wejscie.rb` |
| Przebudowa w miejscu przesuniętego domu | `sketchup/budowa.rb#polozenie_domu` (atrapa: `Transformation#inverse`) |
| Losowe domy (przeszukanie) / stałe ziarna (regresja) | `testy/losowe_domy.rb` / `testy/t_losowe.rb` |
| Testy na Ruby 2.7.8 (jak SketchUp 2023) | `testy/ruby27.sh` |

## 2. Runda 3

Prośba użytkownika: „Sprawdź, czy wszystko działa. Co można poprawić i zmienić. Dobre pomysły wdrażaj od razu, inne
słabsze propozycje wypisz na końcu”. Sprawdzenie: 1000 losowych domów, Ruby 2.7.8, przegląd API SketchUpa – błędy
i poprawki w `docs/stan_prac.md` §5. Testy: rdzeń 142, węgły 51, szczyty 67, podłoga 39, zamek 22, siatki 11, widok 17,
zestawienie 14, raport 25, losowe 36, SketchUp 70, okno 43, Ruby 2.7 (10 zestawów), zasady, spis treści, parametry.

Uwaga: pierwsza próba tej rundy (2026-10-13 wieczorem) przepadła razem z kontenerem przed zapisem – odtworzona
z zapisu rozmowy i dokończona 2026-10-14. Od tej rundy: commit i push na gałąź `runda-N` po każdym większym kawałku.

## 3. Zasady

`CLAUDE.md` + `docs/skille/gw-zasady-kodu/SKILL.md` (kod) + `docs/skille/gw-runda/SKILL.md` (runda).

## 4. Luki

- Nadal brak odbioru w prawdziwym SketchUpie – test działania z raportem ma to zastąpić przy pierwszym uruchomieniu.
- Atrapa API: `manifold?` / `volume` liczone z pętli ścian (para krawędzi, twierdzenie o dywergencji) – w SketchUpie
  ściany mogą się scalić inaczej; prawdziwy wynik da raport.
- Dokumentacja 2D: bale Bs, Kf, Sz bez grupy (zmiana w tamtej wtyczce – `element_roles.rb`, `PREFIX_GROUPS`).

## 5. Następne kroki

Raport z testu działania + scenariusz odbioru kompilacji 3 → poprawki → wg użytkownika: edycja w widoku ściany,
grupy w Dokumentacji 2D, taras, dach (cięcia krokwi / połacie dla wtyczki dachów).
