# Zadanie dla Dokumentacji 2D – konstrukcja wieńcowa (bal / balik)

Do wklejenia w sesji, która rozwija ArteMadera Dokumentacja 2D (`Mottomi3/Aplikacja-do-rzut-w-produkcyjnych`).

```
Temat: obsługa konstrukcji wieńcowej (bal / balik 44 mm) z wtyczki ArteMadera Generator Wieńcowy

KONTEKST
Generator Wieńcowy (repo Mottomi3/Generator-Konstrukcji-Wie-cowych) robi domy z bali 44 × 139 (półbal 44 × 69,5):
ściany z zamkami narożnymi, węgły (kontrfory 244), szczyty z bali ściętych skosem dachu, płatwie (ścięte do
płaszczyzny dachu), krokwie, podwaliny, legary. Każdy bal i belka to komponent – bryła z prawdziwymi wycięciami.
Dokumentacja 2D ma z takiego modelu robić pełną dokumentację produkcyjną (karty, zestawienia, zakupy, montaż, CNC),
tak jak dziś z więźby.

DANE Z GENERATORA (stałe, nic nie trzeba zmieniać po jego stronie)
- Definicja komponentu, słownik „ArteMadera”: rola = timber; prefiks = Bs (bal ścienny) | Kf (węgieł / kontrfor)
  | Sz (bal szczytu) | P | K | Pd | L | Pw; pozycja = numer pozycji generatora; nazwa = „nr-długość”
  (np. 27-4802 – tak numeruje producent bali).
- Definicja, słownik „ArteMadera_GW”: przekroj („44 × 139”, „44 × 69.5”), nazwa, dom.
- Instancja bala, słownik „ArteMadera_GW”: sciana (W-1, W-2…), wieniec (numer wieńca od dołu), pozycja.
- Struktura: grupa „Dom wieńcowy” > grupy ścian W-1, W-2… oraz „Podłoga”, „Dach” > instancje. Grupy bez roli.

CO POKAZAŁ TEST (dom 7 × 4,5 m z generatora przez Dokumentację 2D 1.4.3, model_dump_loader)
1. Bale Bs, Kf, Sz lądują w grupie E „Elementy” (E1…E33 wymieszane: bal ścienny, bal szczytu, węgieł).
2. Zamek narożny bala (gniazdo z góry i z dołu 40 × 36 + podcięcia boczne 2,5 mm) jest na karcie opisany jako
   „Otwór Ø139 – łączy z Bs15” (przelot w osi Y) – błędnie.
3. Płatew ścięta wzdłuż do płaszczyzny dachu (pośrednia – z jednej strony, kalenicowa – z dwóch) jest opisana jako
   „Nakładka” / „Wrąb czołowy / nakładka” na całej długości – błędnie.
4. Bale szczytu ścięte skosem: zestawienie bierze przekrój z obrysu (44 × 137, 44 × 120, 44 × 92…), odpad 65–80 %;
   w rzeczywistości każdy jest z bala 44 × 139.
5. Plan montażu już idzie poziomami (wieńcami) – brakuje tylko opisu kroków jako wieńców.

DO ZROBIENIA (w tej kolejności)
1. Grupy: Bs „Bale ścienne”, Kf „Węgły (kontrfory)”, Sz „Bale szczytowe” w PREFIX_GROUPS (element_roles.rb),
   przed grupami więźby; słowa w PREFIX_RULES / PREFIX_WORDS (bal, balik, półbal → Bs; węgieł, kontrfor → Kf;
   bal szczytu → Sz), żeby rozpoznawać też bale narysowane ręcznie. Nagłówki grup, kolejność i numeracja przez
   istniejące PREFIX_ORDER / PREFIX_NAMES.
2. Numeracja: opcja w Ustawieniach „Numery pozycji z generatora wieńcowego” – gdy definicja ma ArteMadera.pozycja
   (prefiks Bs / Kf / Sz), etykieta = prefiks + ten numer (np. Bs27), żeby karty zgadzały się z rozkładami ścian
   generatora; bez opcji – numeracja jak dziś.
3. Nazwy obróbek bala (joint_names.rb): „Zamek narożny z góry / z dołu 40 × 36, podcięcia 2,5 – ze ścianą W-2
   (Bs15)” (partner: grupa ściany drugiego bala albo atrybut sciana); „Cięcie przy otworze”, „Wycięcie przy
   otworze”, „Skos szczytu”, „Gniazdo pod płatew” (już działa), „Styk”. Płatew: „Ścięcie wierzchu pod kąt dachu”
   (jednostronne; kalenicowa – obustronne, dachowanie) zamiast nakładki.
4. Przekrój i zakupy bali: dla Bs / Kf / Sz przekrój z ArteMadera_GW.przekroj, długość = długość bala; zakup
   i odpad liczone od bala handlowego tego przekroju.
5. Plan montażu bali: krok = wieniec (ArteMadera_GW.wieniec), w kroku bale ścianami W-n; tytuł np.
   „Wieniec 3 – ściany W-1…W-4”.
6. Rozkłady ścian – nowy dokument / zakładka „Ściany”: dla każdej grupy W-n widok ściany od lica jak u producenta
   – bale z numerami „nr-długość”, wieńce, otwory, zamki, skos szczytu, wymiary; pod rysunkiem lista bali ściany
   (poz., przekrój, długość, ilość, m³). Wzór: rozkłady W-1…W-7 z pliku użytkownika „Schemat montazu domek
   1100.pdf”.
7. Pliki CNC (BVN, BTLx): bal z zamkiem – zamek jako zaciosy z góry i z dołu (BVN 0300 / BTLx Lap) z podcięciami,
   skos szczytu, cięcia i wycięcia przy otworach; sprawdzić na balach z testu.
8. Dach domu z bali z dwóch wtyczek w jednym modelu: płatwie (P) robi generator – grupa „Dach” w domu, płatwie
   ścięte do płaszczyzny dachu; krokwie, łaty, kontrłaty i deski robi aplikacja do dachów (KROK 2 – grupa
   „Wiezba dachowa” obok domu; grupa „Dach - polacie” to same płaszczyzny, nie elementy). Jedna dokumentacja
   z obu źródeł: płatwie generatora w grupie P razem z resztą więźby, bez dublowania i bez pomijania.

JAK TESTOWAĆ
- git clone -b runda-5 https://github.com/Mottomi3/Generator-Konstrukcji-Wie-cowych gw && cd gw
  ruby -I testy/atrapa testy/zrzut_dok2d.rb 2 dom_wiencowy.json
  (przykład 2 – dom 7 × 4,5 z działową, węgłem, oknem, szczytami, płatwiami i podłogą; numery 0–7 to inne
  przykładowe domy). Plik to zrzut w formacie „ArteMadera-geometria” (z krawędziami i objętością brył).
- W Dokumentacji 2D: ruby -I stublib model_dump_loader.rb dom_wiencowy.json payloads_wiencowy
  → karty, zestawienia, telefon.html, klient.html.
- Odbiór: grupy Bs / Kf / Sz z nagłówkami i własną numeracją; zamek opisany jako zamek z partnerem; płatew jako
  ścięcie; bale w zakupach jako 44 × 139; plan montażu wieńcami; rozkład ściany W-1 zgodny z widokiem ściany
  w generatorze (okno „Generuj dom…” → widok ściany).
```
