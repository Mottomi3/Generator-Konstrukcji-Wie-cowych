# Przekazanie po rundzie 12 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`) – `add_repo` (push) i
   `git clone https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych` (przy klonie płytkim przed pushem
   `git fetch --depth=1000 origin main`).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md` (§1f – nowości kompilacji 12), ten plik; potem `docs/SPIS_TRESCI.md`.
3. Aplikacja do dachów obok repozytorium (`../aplikacja-do-konstrukcji-dach-w`, `add_repo` read; **3.12.0 lub nowsza** –
   sprawdzenie zadaszenia z prawdziwą aplikacją). `bash testy/uruchom.sh` → `WSZYSTKIE ZESTAWY: FAILURES 0` (ok. 7 min –
   uruchamiaj na kopii repozytorium albo nie edytuj plików w trakcie).
4. Losowe domy: `ruby -I testy/atrapa testy/losowe_domy.rb 100 8001` (ziarna od 8000 – boczne zadaszenie).
5. W tej sesji nie było dostępu do folderów na dysku użytkownika (zgoda odrzucona) – kopie `.rbz` przekazane w rozmowie,
   repozytoria na GitHubie; `repozytorium_r12.bundle` nie powstał na dysku.
6. Nie było Rubiego 2.7 (`/opt/ruby27`) – zestaw „Ruby 2.7” pominięty (kontrola zasad Ruby 2.2 przechodzi).

## 1. Mapa plików (nowe i zmienione w rundzie 12)

| Temat | Plik |
|---|---|
| Boczne zadaszenie: opis w przekroju, płatwie, słupy, belki, słupki, przybudówka (obrys, role ścian), podpowiedzi | `rdzen/zadaszenie.rb` (nowy) |
| Parametry sekcji „Boczne zadaszenie” | `rdzen/parametry_zadaszenie.rb` (nowy), `rdzen/parametry_lista.rb` (SEKCJE, LISTA) |
| Linia dachu z załamaniem, załomy, krokwie zadaszenia z generatora | `rdzen/dach.rb#linia_podparcia`, `#linia_glowna`, `#zalomy_v`, `#krokwie`, `#geo` |
| Przekrój dachu szczytu z zadaszeniem, wiele załomów, gniazda płatwi zadaszenia, ściana przybudówki | `rdzen/szczyty.rb#przygotuj`, `#zalom`, `#zasieg_linii`, `#skosy_linii`, `#gniazda`, `#sciany_przybudowki!`, `#dzialowe_do_dachu!`, `#dom_prostokatny` |
| Wiele załomów pod dachem i w widoku ściany | `rdzen/pod_dachem.rb#zalom`, `rdzen/widok.rb#linia_dachu` |
| Załamania dla aplikacji do dachów | `rdzen/polacie.rb#zalamania`, `sketchup/dach_aplikacja.rb#nowe_polacie`, `#za_stara_na_zalamania` |
| Dawna ściana okapowa i ściana przybudówki jako podpory | `rdzen/krok2.rb#sciany_wysokie` |
| Przebieg: obrys z przybudówką, role ścian, elementy i podpowiedzi zadaszenia | `rdzen/projekt.rb#przebieg`, `#belki` |
| Skos bala blisko naroża gniazda – obniżony (krawędzie < 0,2 mm) | `rdzen/sciecie_dachu.rb#wyrownaj_skosy!` (wołane w `rdzen/projekt.rb#przebieg`) |
| Najcieńszy górny bal ściany przybudówki na niższym licu (bez cienkich klinów) | `rdzen/szczyty.rb#zasieg` |
| Prefiks Bp, grupa i tag „Zadaszenie” | `rdzen/elementy.rb` (RODZAJE), `sketchup/budowa.rb` (TAGI, GRUPY_BELEK) |
| Przykłady testu działania (10 – wiata, 11 – przybudówki) | `rdzen/przyklady.rb` |
| Testy | `testy/t_zadaszenie.rb` (nowy), `testy/sprawdz_dach_aplikacja.rb` (trzy domy z zadaszeniem), `testy/losowe_domy.rb#dodatki_r12` (+ kolizje Bp, S, P), `testy/kolizje_belek.rb#z_polaci` (połać z załamaniem), `testy/podglad.rb` (domy `wiata`, `przybudowka`) |

Aplikacja do dachów 3.12.0 (ta sama sesja): `artemadera_roof/07b_kinks.rb` (nowy `[ZL]`), `08_face_analysis.rb`
(`:kink`, `kink_top?` / `kink_bottom?`, `shift_edges!`, `move_kink!`), `10_joints.rb#kink_plane` `[JN-2e]`,
`14_battens.rb` `[BT-1b]` `[BT-5b]`, `15_framing_builder.rb` (`apply_direction` – własne podniesienie, `settle_kinks`,
`apply_kink_fit`), `14h_supports.rb#inside_v` `[SP-3b]`, `15b_rafter_check.rb`, `15a_preview.rb#kink_lines`,
`16_ui_dialogs.rb` (pole i pomoc `batten_kink`), `01_config.rb` (`:batten_kink_fit`), `18_api.rb` (`:zalamania`),
`tests/test_zalamanie.rb`; dokumenty `CHANGELOG.md`, `API.md`, `INSTRUKCJA.md`, `README.md`.

## 2. Runda 12

Prośba i odpowiedzi – `docs/stan_prac.md` §5 „Runda 12”; zasady – `docs/specyfikacja.md` §8g; kroki odbioru 4a–4h.

Nowe parametry: `zadaszenie`, `zadaszenie_strona`, `zadaszenie_szerokosc`, `zadaszenie_kat`, `zadaszenie_okap`,
`zadaszenie_platwa_przekroj`, `zadaszenie_slup_przekroj`, `zadaszenie_slupy_rozstaw`, `zadaszenie_belka_przekroj`.
Aplikacja do dachów: `:batten_kink_fit` (KROK 2), opcja `:zalamania` (`API.polacie`).

## 3. Zasady

`CLAUDE.md` + `docs/skille/gw-zasady-kodu/SKILL.md` + `docs/skille/gw-runda/SKILL.md`. Z tej rundy:
- Przekrój dachu (`geo`) może mieć `geo[:zad]` – każdy, kto buduje `geo` ręcznie, ma brać `Dach.geo(dom)` (kopiuje
  zadaszenie); linia dachu zawsze z `Dach.linia_podparcia`, załomy z `Dach.zalomy_v` (lista).
- `Szczyty.zalom` / `PodDachem.zalom` zwracają listę; `zasieg_linii` / `skosy_linii` przyjmują liczbę albo listę.
- Płatwie zadaszenia nie są w `Dach.platwie` (statyka i węgły pod płatwiami – tylko dach domu); gniazda – przez
  `Szczyty.gniazda` (`Dach.platwie + Zadaszenie.platwie`), elementy – `Zadaszenie.elementy`.

## 4. Luki

- Kompilacje 7–12 niesprawdzone w prawdziwym SketchUpie – scenariusz odbioru 4a–4h, 3a–3h, 2v–2z, 2q–2u, 2i–2p.
- Aplikacja do dachów 3.12.0 niesprawdzona w prawdziwym SketchUpie (tylko jej atrapa) – kroki 4d–4g.
- Znalezione przy okazji (sprzed rundy 12, nie poprawione): taras na słupach z wiązarem „na słupach”, płatew ścienna na
  ścianie, 10 wieńców – słupy tarasu wchodzą 11 mm w płatew ścienną (ziarno 8064; kontrola S z P w losowych domach tylko
  dla słupów zadaszenia).
- Zadaszenie: tylko dom prostokątny, dach dwuspadowy, bez tarasu, cała długość ściany; płatwie zadaszenia bez statyki.
- Rozstrzygnięcia z 2026-11-14 (Projekt: `claude/zadanie_r11.md`) niezrobione – runda 13; decyzja T8 nadal otwarta.
- Dom L + podbitka na płatwiach + krokwie z aplikacji: podpory 19 mm pod połacią (ziarna 7004, 7021) – bez zmian.

## 5. Następne kroki

Odbiór kompilacji 12 (z aplikacją do dachów 3.12.0) → poprawki → runda 13 (rozstrzygnięcia z 2026-11-14 + decyzja T8,
słupy tarasu a płatew ścienna) → zadaszenie: odcinek od–do, szczyty zadaszenia (zamknięcie boku), z tarasem → dom L:
podłoga, taras, belka koszowa → Dokumentacja 2D (grupy) → schody i deski tarasu.
