# Przekazanie po rundzie 9 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`) – `add_repo` (push) i
   `git clone https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych` (przy klonie płytkim przed pushem
   `git fetch --depth=1000 origin main`). Zapas: `repozytorium_r9.bundle` na dysku
   (`C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\`).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md` (§1c – nowości kompilacji 9), ten plik; potem `docs/SPIS_TRESCI.md`.
3. Aplikacja do dachów obok repozytorium (`../aplikacja-do-konstrukcji-dach-w`, `add_repo` read). `bash testy/uruchom.sh` →
   `WSZYSTKIE ZESTAWY: FAILURES 0`. Nie edytuj `testy/uruchom.sh` w trakcie jego biegu.
4. Losowe domy: `ruby -I testy/atrapa testy/losowe_domy.rb 40 5001` (ziarna od 5000 – nowości rundy 9).
5. Ostatnie parametry użytkownika: `C:\Users\Mottomi\AppData\Roaming\ArteMadera\GeneratorWiencowy\ustawienia.json`
   (folder można udostępnić sesji – odtworzenie jego domu).

## 1. Mapa plików (nowe i zmienione w rundzie 9)

| Temat | Plik |
|---|---|
| Węgieł pod płatwią, węgieł na wolnym końcu | `rdzen/wegly_konstrukcyjne.rb` (po węgłach z tabeli, przed stykami) |
| Gniazdo płatwi w węgle (czop we wrębie, słup zamka otwarty) | `rdzen/szczyty.rb#gniazda_wegla` |
| Górny bal węgła pod płatwią | `rdzen/bale.rb#pod_platwia?` |
| Wypust końca działowej przez ścianę zewnętrzną, węgły ściany domu przy tarasie | `rdzen/sciany.rb#dzialowe`, `#wypusty_kontrforu` |
| Węgieł w miejscu słupa tarasu – pominięty | `rdzen/taras.rb#wegly_przy_slupach!` |
| Lista węgłów do okna, przesuwanie | `rdzen/wegly_tabela.rb#lista`, `html/wegly_przesun.js`, `html/wegly.js#ustawOd`, `html/edycja.js#przesun` |
| Wiązar nad tarasem (krokwie, belka dolna, słupek, zastrzały, gniazda) | `rdzen/taras_wiazar.rb` (parametry w `rdzen/parametry_taras.rb`) |
| Front bez bali pod wiązarem | `rdzen/taras_szczyt.rb#bez_bali?`, `rdzen/taras_slupy.rb#slup` (lico) |
| Wręby płatwi na grubości wiązara | `rdzen/dach.rb#wreby_platwi!`, `rdzen/zamek_platwi.rb#scal` |
| Ścięcie dachu – stopień w pionie, tylko w dół | `rdzen/sciecie_dachu.rb#przesun!` |
| Kolizje belka – belka w testach | `testy/kolizje_belek.rb#kolizje_elementow` |

## 2. Runda 9

Uwagi i odpowiedzi – `docs/stan_prac.md` §5 „Runda 9”; zasady – `docs/specyfikacja.md` §8d.

## 3. Zasady

`CLAUDE.md` + `docs/skille/gw-zasady-kodu/SKILL.md` + `docs/skille/gw-runda/SKILL.md`.

## 4. Luki

- Kompilacje 7–9 niesprawdzone w prawdziwym SketchUpie – scenariusz odbioru 2a–2u.
- Węgieł pod płatwią: gdy bal węgła kończy się tuż pod płatwią (mniej niż najcieńszy pasek), zostaje luka < 20 mm.
- Przesunięcie węgła automatycznego przepisuje całą ścianę na węgły ręczne (automat styków i usztywnienia tej ściany wyłączony).
- Aplikacja do dachów – część 2 zadania bez zmian; Dokumentacja 2D – grupy Bs, Kf, Sz, F, Pb, Wt.

## 5. Następne kroki

Odbiór kompilacji 9 → poprawki → aplikacja do dachów (część 2) → Dokumentacja 2D (grupy) → schody i deski tarasu.
