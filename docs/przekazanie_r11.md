# Przekazanie po rundzie 11 – ArteMadera Generator Wieńcowy

## 0. Start następnej sesji

1. Repozytorium: `Mottomi3/Generator-Konstrukcji-Wie-cowych` (gałąź `main`) – `add_repo` (push) i
   `git clone https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych` (przy klonie płytkim przed pushem
   `git fetch --depth=1000 origin main`). Zapas: `repozytorium_r11.bundle` na dysku
   (`C:\Users\Mottomi\Documents\ArteMadera Generator Konstrukcji Wieńcowych\`).
2. Przeczytaj `CLAUDE.md`, `docs/stan_prac.md` (§1e – nowości kompilacji 11), ten plik; potem `docs/SPIS_TRESCI.md`.
3. Aplikacja do dachów obok repozytorium (`../aplikacja-do-konstrukcji-dach-w`, `add_repo` read). `bash testy/uruchom.sh` →
   `WSZYSTKIE ZESTAWY: FAILURES 0` (ok. 6 min – uruchamiaj na kopii repozytorium albo nie edytuj plików w trakcie).
4. Losowe domy: `ruby -I testy/atrapa testy/losowe_domy.rb 60 7001` (ziarna od 7000 – nowości rundy 11).
5. Ostatnie parametry użytkownika: `C:\Users\Mottomi\AppData\Roaming\ArteMadera\GeneratorWiencowy\ustawienia.json`
   (folder udostępniany sesji na prośbę; obrysu w nim nie ma – dom odtwarza się prostokątem o kilku szerokościach).
6. W tej sesji nie było Rubiego 2.7 (`/opt/ruby27`) ani sieci do jego zbudowania – zestaw „Ruby 2.7” pominięty.

## 1. Mapa plików (nowe i zmienione w rundzie 11)

| Temat | Plik |
|---|---|
| Słupki z kontrfor pod płatwiami: które płatwie, węgieł stojący w osi płatwi | `rdzen/wegly_konstrukcyjne.rb#pod_platwiami`, `#platew_z_weglem?`, `#wegiel_w_osi` |
| Płatew zawsze na balu węgła (obniżenie dachu, przesunięcie płatwi) | `rdzen/platwie_wience.rb#wegiel_pod?`, `#pasek_wegla`, `#oparcie_ok?` |
| Słup frontu tarasu w osi kalenicy | `rdzen/taras.rb#slup_w_osi`, `#os_frontu`, `#slupy_frontu` |
| Front tarasu bez węgła na środku | `rdzen/wegly_tabela.rb#na_srodku` |
| Front tarasu łączony na styk | `rdzen/styki_tarasu.rb` (nowy), wejście w `rdzen/styki.rb#planuj`, `#z_weglami`; `rdzen/kontrola.rb#styki_bez_zamka` |
| Zamek płatwi tylko od spodu (wrąb z własną głębokością boczną `[x0, x1, bok]`) | `rdzen/zamek_platwi.rb#tylko_spod?`, `#bok_w_scianie`, `#wrab_odcinka`, `#wreby`, `#scal`, `#odcinki`; `rdzen/szczyty.rb#gniazda_sciany`; `rdzen/dach.rb#wreby_platwi!` |
| Trójkąt: przekroje słupka i zastrzałów, postać w wąskim domu, ostrzeżenia, przekrój dobrany | `rdzen/taras_wiazar.rb#szerokosc_czlonu`, `#postac`, `#krokwie_na_balach`, `#uwagi`, `#przekroj` |
| Płatwie – obciążenia, przęsło, pas dachu, dobór | `rdzen/statyka_dachu.rb` (nowy); podpory wzdłuż płatwi `dom[:podparcia]` – `rdzen/szczyty.rb#gniazda_sciany` |
| Trójkąt nad tarasem – siły od płatwi, krokiew, belka na słupach, dobór | `rdzen/statyka_wiazara.rb` (nowy) |
| Dwa przebiegi obliczeń z dobranymi przekrojami | `rdzen/projekt.rb#oblicz`, `#przebieg`, `#belki` (`plan[:dobor_przekrojow]`, `plan[:platwie_statyka]`) |
| Belka: część obciążenia zmiennego długotrwała (psi2) | `rdzen/statyka.rb#belka` |
| Parametry | `rdzen/parametry_lista.rb` (węgły), `rdzen/parametry_taras.rb`, `rdzen/parametry_dach.rb` |
| Testy | `testy/t_statyka_dachu.rb` (nowy), grupy rundy 11 w `testy/t_wegly.rb`, `testy/t_taras.rb`; `testy/losowe_domy.rb#dodatki_r11`; `testy/kolizje_belek.rb` (wrąb z własną głębokością boczną) |

## 2. Runda 11

Uwagi i odpowiedzi – `docs/stan_prac.md` §5 „Runda 11”; zasady – `docs/specyfikacja.md` §8f; kroki odbioru 3a–3h.

Nowe parametry: `wegly_pod_platwiami_ktore`, `taras_slup_w_osi`, `taras_slup_os_dociag`, `taras_styk`,
`taras_platwa_zamek`, `taras_wiazar_przekroje`, `platwie_dobor`, `platwie_katalog`, `dach_snieg`, `dach_ciezar`,
`dach_ugiecie`; `taras_wieniec` z wyborem `auto`. Wewnętrzny (nie z okna): `taras_wieniec_dobrany` – przekrój trójkąta
z doboru, wpisywany do parametrów roboczych drugiego przebiegu.

## 3. Zasady

`CLAUDE.md` + `docs/skille/gw-zasady-kodu/SKILL.md` + `docs/skille/gw-runda/SKILL.md`. Z tej rundy:
- Wręby płatwi mogą mieć trzeci element (własna głębokość boczna) – przy każdej pętli po `e[:wreby]` brać `|x0, x1, bok|`
  i `ZamekPlatwi.wrab_odcinka(e[:wrab], bok)`.
- Wszystko, co czyta przekrój płatwi albo trójkąta, czyta go z parametrów roboczych (`plan[:parametry]`,
  `TarasWiazar.przekroj(p)`) – tam są przekroje dobrane; nie z wejścia okna.
- Nowy dobór przekroju czegokolwiek: wynik jako `nadpis` w `plan[:dobor_przekrojow]`, nie przez zmianę parametrów
  w trakcie przebiegu.

## 4. Luki

- Kompilacje 7–11 niesprawdzone w prawdziwym SketchUpie – scenariusz odbioru 3a–3h, 2v–2z, 2q–2u, 2i–2p.
- Ruby 2.7.8 nie uruchomiony w tej rundzie (kod nowych plików pisany pod Ruby 2.2; kontrola zasad przechodzi).
- Rozstrzygnięcia z 2026-11-14 (Projekt: `claude/zadanie_r11.md`) niezrobione – runda 12; w tym poprawka wyjątku
  działowej współliniowej ze ścianą obrysu (jeden wiersz w `rdzen/sciany.rb#dzialowe`).
- „Na styk” tylko na froncie tarasu; szczyty ścian domu łączone jak dotąd na węgłach – pytanie T8 do użytkownika.
- Statyka dachu: uproszczenia w `docs/stan_prac.md` §8; lista przekrojów bez długości handlowych.
- Dom L + podbitka na płatwiach + krokwie z aplikacji: podpory 19 mm pod połacią (ziarna 7004, 7021, sprzed rundy 11).
- Losowe domy sprzed rundy 10: ziarna 75, 318, 472, 6110 – bez zmian.

## 5. Następne kroki

Odbiór kompilacji 11 → poprawki → runda 12 (rozstrzygnięcia z 2026-11-14 + decyzja T8) → dom L: podłoga, taras, belka
koszowa → aplikacja do dachów (część 2) → Dokumentacja 2D (grupy) → schody i deski tarasu.
