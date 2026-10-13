# Stan prac – ArteMadera Generator Wieńcowy

Stan na: runda 2, kompilacja 2 (2026-10-13), wersja 1.0.0. Testy: `bash testy/uruchom.sh` – 11 zestawów, 424 sprawdzenia,
FAILURES 0. Repozytorium: prywatne `Mottomi3/Generator-Konstrukcji-Wie-cowych` na GitHubie (gałąź `main`, pełna
historia rund 1 i 2) + kopia `repozytorium_r2.bundle` na dysku.

## 1. Co działa (kompilacja 2)

- Rozpoznanie linii: obrys (lico zewnętrzne), osie działowych, węgły z krótkich linii; scalanie linii, dociąganie
  końców, dowolny obrót domu, obrys wielokątny (L, U…).
- Ściany zewnętrzne, działowe (T, X, wolny koniec), węgły 244 jako ściany W-n; ostatki; numeracja jak producent.
- Wieńce: półbal na ścianach wzdłuż kalenicy, szczytowe o wieniec wyżej, ze szczytem – do kalenicy.
- Zamek 44 × 146 wg rysunku na każdym skrzyżowaniu (0 kolizji), wariant lustrzany z parametru.
- **Łączenie bali** w trzech układach: na przemian w kolejnych węgłach / działowych (domyślny, jak 1200), para
  (900 W-2), jeden węgieł; mijanka ≥ 300; styk z dala od otworów.
- **Węgły usztywniające**: limit światła 4800 / 3700 (ściany wysokie od 3000), rozmieszczenie równo / od narożników /
  tylko narysowane, przełącznik dla działowych. Dom 4 × 4 – bez łączeń i bez węgłów.
- **Szczyty**: bale ścięte pod kątem dachu, gniazda płatwi (ściennej, pośrednich, kalenicowej), szczyt na działowej
  (opcja), okno w szczycie.
- **Dach** (dom prostokątny): płatwie i krokwie jako belki; krokwie przy szczycie z obu stron / od wewnątrz / od
  zewnątrz / na szczycie; okapy.
- **Podłoga** (dom prostokątny): podwaliny na zakład, legary między podwalinami, podpory legarów, dobór przekroju
  (zalecany / minimalny / ręczny) z katalogu wg izolacji, podpowiedzi o nośności i ugięciu.
- Otwory: przecięcia i wycięcia bali, węgły przerwane przy otworach, ostrzeżenia.
- Pozycje „nr-długość” bali (Bs, Kf, Sz) i belek (Pw, L, Pd, Pl, Kr), lista bali i belek (przekrój, długość, ilość, m³).
- Model: Dom > W-n / Podłoga / Dach > komponenty z wycięciami (bryły zamknięte), tagi (także Szczyty, Podłoga, Dach),
  atrybuty Dokumentacji 2D, zapis parametrów, przebudowa, wykrywanie ręcznych zmian, jedno „Cofnij”.
- **Okno**: sekcje z listy parametrów, podpowiedź pod każdym polem, szablony (wbudowane i własne), „Przywróć
  fabryczne”, rzut, okna i drzwi (wymiary nowych z ustawień), wynik z podpowiedziami.
- **Ustawienia zapamiętane na komputerze** (ostatnie parametry i szablony) – te same po ponownym uruchomieniu SketchUpa.

## 2. Jak to działa

Opis zasad: `docs/specyfikacja.md`, wszystkie parametry: `docs/parametry.md`. Mapa kodu: `docs/SPIS_TRESCI.md`.
Przebieg: `rdzen/projekt.rb#oblicz` (obrys → ściany → szczyty → otwory → styki → węgły → gniazda płatwi → bale →
zamki → pozycje → belki dachu i podłogi).

## 3. Zasady (stałe)

- Jeden temat = jeden plik; nagłówek pliku (Plik, Zadanie, Tematy, Zależy od, Używają); komentarz nad każdą metodą
  i funkcją JS; plik > 450 wierszy – podział (> 700 – błąd kontroli).
- `docs/SPIS_TRESCI.md` i `docs/parametry.md` tylko z generatorów, kontrola aktualności w testach.
- Rdzeń bez API SketchUpa; API tylko w `sketchup/`. Ruby 2.2, JS ES5, `Log`, zero placeholderów.
- Co tylko można – parametr: jeden wpis w `rdzen/parametry_lista.rb` (okno, zapis i szablony – same).
- Numer kompilacji = numer rundy, ten sam w rejestratorze i `main.rb`.
- Grupy domu, ścian, podłogi i dachu bez roli Dokumentacji 2D (rola „skip” na grupie wyłącza zawartość).

## 4. Moduły

Patrz `docs/SPIS_TRESCI.md` §2. Nowe w rundzie 2: `rdzen/parametry_lista.rb`, `usztywnienie.rb`, `elementy.rb`,
`dach.rb`, `szczyty.rb`, `statyka.rb`, `podloga.rb`, `sketchup/ustawienia.rb`, testy `t_wegly`, `t_szczyty`,
`t_podloga`, `lista_parametrow.rb`.

## 5. Rundy

### Runda 1 (kompilacja 1)

Szkielet, rdzeń ścian, zamki, styki (para jak 900 W-2), otwory, warstwa SketchUpa, okno, testy z atrapą, spis treści,
paczka .rbz, podgląd 3D. Wcześniejszy błędny opis 900 W-2 („styk 150 obok jednego kontrforu”) poprawiony.

### Runda 2 (kompilacja 2) – „wszystko jako parametry”

- Analiza projektów 900, 1000, 1100, 1200, 1800, 2000 → domyślne limity węgłów i łączeń (`00_Analiza\analiza_wzmocnien.md`).
- Lista parametrów w jednym pliku (65 parametrów w 8 sekcjach), okno budowane z listy, podpowiedzi, zapis ustawień,
  szablony.
- Łączenia na przemian (wzór 1200), węgły usztywniające, szczyty z gniazdami płatwi (wzór 900: kawałki przy gniazdach),
  płatwie i krokwie z wyborem krokwi przy szczycie, podłoga ze statyką.

## 6. Otwarte pytania (przyjęte wartości domyślne – do potwierdzenia)

| # | Pytanie | Przyjęto |
|---|---|---|
| A3 | Profil bala (pióra, wpust, fazy) | bal prosty; profil w późniejszej rundzie |
| A5 | Kiedy ostatek 200 | parametr wspólny dla domu (osobno na narożnik – okno ściany) |
| C9 | Układ łączeń | na przemian (1200); para (900 W-2) i jeden węgieł w opcjach |
| W1 | Limity 4800 / 3700, próg 3000 | z projektów 1800, 1200, 1100 – do potwierdzenia z praktyką |
| W2 | Rozmieszczenie węgłów | równo; od narożników (1000) w opcjach |
| S1 | Gdzie stoi płatew ścienna 60 × 200 (900) i wysokość linii dachu | przy licu wewnętrznym, wierzch płatwi 69,5 nad ścianą okapową (jak szczyt 900); oba parametry |
| S2 | Wierzch płatwi a skos dachu | płatew wierzchem na linii przy krawędzi od okapu (nic nie wystaje); bez fazowania |
| S3 | Krokwie przy szczycie | z obu stron (domyślnie); od wewnątrz / od zewnątrz / na szczycie w opcjach |
| P1 | Obciążenia podłogi | 2,0 kN/m² użytkowe + 0,5 stałe, C24, L/400 zalecane, L/250 dopuszczalne |
| P2 | Legar a podwalina | legary między podwalinami, wierzch równo (900); wyższy legar – podpowiedź |
| H20 | Grupy w Dokumentacji 2D | Bs, Kf, Sz, Pw, L, Pd, Pl, Kr – do dopisania w Dokumentacji 2D |
| H21 | Producent / CNC: co dostaje, BVN czy BTLx | do ustalenia przy eksporcie |
| I23 | Repozytorium GitHub | `Mottomi3/Generator-Konstrukcji-Wie-cowych` (założone przez użytkownika 2026-10-13) |

## 7. Do sprawdzenia w SketchUpie

`docs/scenariusz_odbioru.md` – kompilacja 2: szczyty (skosy, gniazda), krokwie przy szczycie, podłoga i podpowiedzi,
zapamiętanie ustawień po ponownym uruchomieniu SketchUpa, szablony, czas generowania.

## 8. Ograniczenia (kompilacja 2)

- Tylko ściany pod kątem prostym; linie ukośne – błąd.
- Dach (belki) i podłoga tylko dla obrysu prostokątnego; szczyty dla innych obrysów liczone każdy osobno.
- Krokwie z czołami prostopadłymi do osi (bez cięć pionowych przy kalenicy i okapie); płatwie bez fazowania.
- Bez tarasu, desek dachu i podłogi, pełnego profilu bala, okna ściany z elewacją, eksportu list.
- Statyka podłogi uproszczona (belka swobodnie podparta, bez drgań) – podpowiedź, nie projekt konstrukcyjny.
- Dokumentacja 2D nie zna jeszcze prefiksów (elementy trafią do grupy „Elementy”, dopóki ich nie dopiszemy).

## 9. Plan kolejnych rund

1. Odbiór kompilacji 2 w SketchUpie i poprawki (raport z modelu).
2. Okno ściany: elewacja W-n z węgłami, stykami i otworami; klik – dodaj / usuń węgieł; ostatek na narożnik.
3. Taras: wysunięte górne bale, słupy, balustrada z odcinków.
4. Dokumentacja 2D: grupy i karty, listy do producenta (CSV / XLSX).
5. Dach: cięcia krokwi, deski, dach dla obrysów L / U; deski podłogi.
6. Pełny profil bala do wizualizacji.
