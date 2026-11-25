# Scenariusz odbioru – kompilacja 13

Sprawdzenie w prawdziwym SketchUpie 2023. Przy problemie: zrzut ekranu + wiersze z `[ArteMadera GW]` z Konsoli Ruby
(Rozszerzenia → Programista → Konsola Ruby) albo raport z kroku 2.

1. **Instalacja.** Rozszerzenia → Menedżer rozszerzeń → Zainstaluj rozszerzenie → `arte_madera_generator_wiencowy_1.0.0.rbz`
   (zastępuje kompilację 12). **Uruchom SketchUpa ponownie** (bez tego stara i nowa wersja mieszają się w pamięci). W opisie rozszerzenia „Kompilacja 13 (2026-11-25)”.
   Aplikacja do dachów (ArteMadera Roof) **3.12.0** zainstalowana (`artemadera_roof_3.12.0.rbz` z tej rundy – bez niej
   zadaszenie nie dostanie połaci) – do kroków 4d–4h, 5, 5a i 6.
2. **Test działania (najważniejsze).** Pusty model → Rozszerzenia → ArteMadera Generator Wieńcowy → „Test działania
   i raport do wysłania…”. Zapisz `ArteMadera_GW_raport_….json`. Każdy z 11 domów „w porządku” (ósmy: dach
   jednospadowy, dziewiąty: taras jak 1100, dziesiąty: wiata boczna na słupach z dobranymi przekrojami, jedenasty: przybudówki z bali bez podłogi, krokwie dobrane). **Prześlij
   ten plik.** Model po teście pusty.
**Nowe w kompilacji 13 (prośba z 25 listopada, 17:19):**

5a. **Zakładka zadaszenia.** Generuj dom… → nad polami dwie zakładki: „Dom” i „Zadaszenie boczne / tylne”. W „Dom” nie
   ma żadnego pola zadaszenia; w zakładce zadaszenia – sekcje „Zadaszenie – rodzaj i wymiary” i „Zadaszenie – przekroje
   (dobór)”. Wybierz „na słupach z oczepem” → w nazwie zakładki „· zmienione: 1”. Wczytaj szablon → zostajesz w tej samej
   zakładce.
5b. **Dobór automatyczny.** Prostokąt 8000 × 5000, dach 30°, zadaszenie na słupach (szerokość 2000, kąt 12°) → pod sekcją
   „Zadaszenie – przekroje” trzy wiersze: płatwie z oczepem (przęsło = rozstaw słupów), belki poprzeczne, słupy (wysokość,
   siła, wyboczenie) – „dobrane automatycznie”. Pola przekrojów są ukryte. W modelu słupy, belki i płatwie mają te
   przekroje. Zmień „Śnieg – obciążenie gruntu” (zakładka Dom) z 0,9 na 2,5 → przekroje rosną.
5c. **Z wyboru.** „Przekroje zadaszenia – dobór”: z wyboru → pokazują się pola płatwi, słupa i belki (80 × 160, 120 × 120,
   80 × 160) – wynik „wystarczy; najmniejszy wystarczający z listy: …”. Wpisz płatew 40x60 → „za słaby – z listy
   wystarczy …”.
5d. **Krokwie.** Zakładka Dom → „Szczyty i dach”: układ „płatwie i krokwie”, „Przekrój krokwi – dobór”: automatycznie →
   pod sekcją „Krokwie … dobrane automatycznie”, w zakładce zadaszenia „Krokwie zadaszenia …” (ten sam przekrój). Z aplikacją
   do dachów – KROK 2 startuje z dobranym przekrojem krokwi.
5e. **Przybudówka bez podłogi.** Zadaszenie „ściany z bali (przybudówka)”, podłoga w zakładce Dom włączona, „Przybudówka –
   podłoga”: nie → w przybudówce tylko podwaliny pod jej ścianami na fundamentach, legary i podciągi kończą się na
   podwalinie dawnej ściany okapowej. „tak” → legary do ściany przybudówki.
5f. **Przybudówka – płatwie.** Ta sama przybudówka przy domu 8 m: płatwie zadaszenia mają przęsło całej długości domu –
   dobór daje duży przekrój (np. 160 × 280). Zgłoś, czy w przybudówce mają stanąć słupki / węgły pod płatwiami.

**Nowe w kompilacji 12 (prośba z 25 listopada – boczne zadaszenie):**

4a. **Wiata na słupach.** Prostokąt 6000 × 4000, dach 30°, zakładka „Zadaszenie boczne / tylne” → „na słupach z oczepem”, strona
   dolna, szerokość 2000, kąt 12°. Podgląd / budowa: dach domu do lica ściany okapowej, dalej połać 12°; cztery słupy na
   fundamentach (skrajne w osiach ścian szczytowych), na każdym belka poprzeczna do ściany (skrajne do końca ostatków),
   oczep na belkach nad słupami, płatew pośrednia i płatew przy ścianie na słupkach; płatew przy ścianie przechodzi przez
   ostatki ścian szczytowych (gniazda). Wszystko w grupie i tagu „Zadaszenie”. W wynikach „Zadaszenie: … prześwit pod
   belkami …”.
4b. **Strony i kąt.** „Zadaszenie – przy ścianie okapowej”: po obu stronach → dwie wiaty. Kąt zadaszenia 30° przy dachu
   30° → ostrzeżenie „musi być mniejszy niż kąt dachu” i dom bez zadaszenia. Taras + zadaszenie → ostrzeżenie (jeszcze nie).
4c. **Przybudówka z bali.** To samo z „ściany z bali (przybudówka)”: ściany szczytowe dłuższe o 2 m z łamaną linią szczytu
   (kalenica i załamanie), dawna ściana okapowa jako działowa (wysokość jak była), ściana zewnętrzna przybudówki niska,
   górny bal ścięty do połaci zadaszenia; płatwie zadaszenia w ścianach szczytowych. Węgieł ręczny / drzwi w ścianie
   przybudówki – jak w każdej ścianie.
4d. **Aplikacja do dachów 3.12.0 – połacie z załamaniem.** „Krokwie i poszycie – kto je buduje”: aplikacja → po budowie
   trzy połacie (dwie dachu i zadaszenie), dolna pod 12°, wszystkie na wierzchu płatwi; okno KROKU 2. Ze starszą aplikacją –
   komunikat „wymaga aplikacji do dachów 3.12.0”.
4e. **Łaty pod blachę.** W KROKU 2 włącz łaty (np. moduł 350): nad załamaniem pierwsza łata przy samej linii załamania (jak
   przy okapie), pod załamaniem ostatnia łata dotyka linii załamania; nowe pole „Pod załamaniem połaci – pełne moduły”
   (włączone) → okap zadaszenia wydłużony tak, że od okapu do załamania same pełne moduły (podgląd i raport: „Połać pod
   załamaniem … okap wydłużony o … mm – pełne moduły do linii załamania”). Łaty obu połaci nie nachodzą na siebie.
4f. **Krokwie przy załamaniu.** Układ „płatwie i krokwie” albo „krokwie” → krokwie dachu kończą się nad załamaniem, krokwie
   zadaszenia zaczynają się tam – styk w płaszczyźnie dwusiecznej (bez szczeliny na wierzchu). Raport: krokiew zadaszenia
   od oczepu do załamania (płatew przy ścianie jako podpora u góry), krokiew dachu od załamania bez wspornika.
4g. **Deski na płatwiach.** Układ „same płatwie”, deskowanie pełne → deski wzdłuż spadku na płatwiach obu połaci, styki na
   płatwiach, przy załamaniu deski obu połaci się nie nachodzą.
4h. **Krokwie z generatora.** „Krokwie i poszycie – kto je buduje”: generator → przy zadaszeniu krokiew zadaszenia (12°) od
   jego okapu do linii załamania obok każdej krokwi dachu.

**Nowe w kompilacji 11 (uwagi z 16 listopada):**

3a. **Słupki z kontrfor pod płatwiami – do wyboru.** Sekcja „Węgły (kontrfory) 244” → „Słupki z kontrfor (węgły) pod
   płatwiami”: „nie” → szczyty bez słupków pod płatwiami; „tak” + „Słupki pod płatwiami – pod którymi”: „tylko pod płatwią
   kalenicową” → jeden słupek w osi szczytu.
3b. **Płatew kalenicowa na ostatniej kontrforze.** Dom szerszy niż 4 m z „Węgieł automatycznie na środku ściany”: na
   zewnętrznych → węgieł ze środka ściany szczytowej dochodzi do spodu płatwi kalenicowej (górny bal ścięty pod płatew).
   Sprawdź też płatwie pośrednie: każda leży na górnym balu swojego słupka, bez szczeliny.
3c. **Słup tarasu w osi.** Taras na słupach, wejście z lewej → pod kalenicą stoi słup, dokładnie pod słupkiem trójkąta.
   Wąski dom (ok. 3 m): słup wejścia sam staje w osi („Słup w osi – słup wejścia bliżej osi niż tyle staje w osi”).
3d. **Front tarasu bez kontrfor.** Dom o froncie 5 m i 8 m: na froncie tarasu nie ma kontrfory ani półzamków; przy 8 m
   bale łączą się na styk nad słupem, w sąsiednim wieńcu o mijankę dalej („Łączenie bali frontu i szczytu nad tarasem”).
3e. **Zamek płatwi nad trójkątem tylko od spodu.** W płatwi nad trójkątem jest tylko wrąb od spodu, bez bocznych;
   w ścianach domu wręby jak dotąd („Zamek płatwi w szczycie nad tarasem”).
3f. **Przekroje słupka i zastrzałów.** „Wiązar – słupek i zastrzały z przekroju”: własnego (120 i 100) albo dokładnie
   jak reszta trójkąta.
3g. **Wąski dom.** Dom 2 m szerokości z tarasem: trójkąt z płatwi 60 × 200 – same krokwie na balach frontu
   i ostrzeżenie; „Szczyt pusty – wiązar (trójkąt) z przekroju”: dobranego automatycznie → cały trójkąt z małego
   przekroju (60 × 100), w wynikach podpowiedź z nośnością.
3h. **Dobór płatwi.** Sekcja „Szczyty i dach” → „Przekrój płatwi – dobór”: automatycznie → pola przekroju znikają,
   w wynikach „Płatwie … – dobrane automatycznie” z przęsłem, pasem dachu, nośnością i ugięciem. Zmień „Śnieg –
   obciążenie gruntu” z 0,9 na 2,0 → większy przekrój. Ręcznie → przy Twoim przekroju wynik sprawdzenia.

**Nowe w kompilacji 10 (uwagi z 10 listopada):**

2v. **Dom L – dwa dachy z koszem.** Narysuj obrys L (np. 8000 × 4000 z dobudówką 4000 × 3000), ustawienia jak u Ciebie
   → trzy szczyty z bali (dwa dachu głównego, jeden skrzydła bocznego), płatwie obu dachów: głównego na całą długość,
   bocznego od szczytu do dachu głównego (do kosza albo na styk do płatwi dachu głównego). Ściana wspólna: do połowy
   szczyt, dalej ściana okapowa ze ściętym górnym balem. Węgły dochodzą do dachu i są ścięte jego linią. Z aplikacją do
   dachów („Krokwie i poszycie – kto je buduje”: aplikacja) → 5 połaci z dwoma koszami, KROK 2 kładzie deski / krokwie.
   Zmień proporcje tak, żeby dobudówka była szersza niż część główna → kalenica główna przechodzi na szersze skrzydło.
2w. **Wypust górnych belek w domu L.** Górne belki ścian okapowych: za szczyt wysunięte jak płatwie (300), w narożniku
   wklęsłym (do środka domu) tylko 100 jak pozostałe.
2x. **Okno od nowa.** Wygeneruj dom, zamknij okno. Zaznacz inne linie razem z tym domem → pytanie: Tak – nowy dom
   z linii (okno bez otworów i ustawień starego domu), Nie – edycja domu. Zaznacz sam dom → edycja. Jeśli okno nadal
   „nie wczytuje się od nowa” – opisz, co dokładnie widać (puste okno? stare parametry? stary podgląd?) i prześlij raport
   z kroku 2.
2y. **Wiązar pod płatwiami.** Taras na słupach, szczyt pusty → krokwie wiązara w jednym kawałku pod płatwiami, każda
   płatew leży na nich w płytkim gnieździe (zamku). „Wiązar – rodzaj”: z zastrzałami → dwie belki od spodu słupka pod
   kątem 45° do krokwi („Wiązar – kąt zastrzałów”; przy niskim, wąskim szczycie się nie mieszczą – wtedy ich nie ma).
2z. **Podciąg na wysokości podwalin.** Nowy dom z podłogą → podciąg między podwalinami, wierzch równo z nimi, legary
   dzielone na podciągu (bez podpór od spodu). „Podciąg – poziom”: obniżony → jak dotąd, pod podwalinami.

**Nowe w kompilacji 9 (uwagi z 2 listopada, 23:24):**

2q. **Węgły pod płatwiami.** Prostokąt 6000 × 8000 z działową wzdłuż kalenicy, ustawienia jak u Ciebie (wypust na zewnątrz
   200) → na obu ścianach szczytowych pod każdą płatwią pośrednią węgieł do spodu płatwi (płatew na nim leży, w ścianie
   czop węgła we wrębie płatwi); pod płatwią kalenicową – działowa. Słupki 100 w środku, 200 na zewnątrz. „Węgieł pod
   płatwią na szczycie”: nie → węgłów pod płatwiami nie ma.
2r. **Wypust działowej.** Koniec działowej wychodzący przez ścianę zewnętrzną – 200 (jak węgieł, parametr „Węgieł – wypust
   na zewnątrz”); ściana domu przy tarasie i jej węgły – 200 od strony tarasu.
2s. **Wolny koniec.** Narysuj działową, która nie dochodzi do drugiej ściany (np. od ściany 2500 mm w głąb) → przy jej końcu
   węgieł (bale kończą się 100 za nim). „Węgieł na wolnym końcu – od długości” 3000 → przy tej ścianie węgła nie ma.
2t. **Przesuwanie węgłów.** Karta „Okna i drzwi” → „Węgły – przesuwanie”: lista wszystkich węgłów; wpisz nowe „od” albo
   kliknij ◀ ▶ (50 mm) → węgieł przesunięty w podglądzie, w panelu ściany „Węgły tej ściany ustawione ręcznie”; węgieł
   z tabeli węgłów – zmienia się wiersz tabeli. „Przywróć automatyczne” w panelu ściany cofa przesunięcia.
2u. **Wiązar nad tarasem.** Taras na słupach, szczyt pusty → wiązar licem z licem frontu (od kompilacji 10 pod
   płatwiami – krok 2y), płatwie z zamkiem (5 z boku, 10 od spodu), belka dolna, słupek pod kalenicą. „Wiązar – na czym stoi”: na słupach → front bez bali, z przodu
   sam trójkąt na słupach.

**Nowe w kompilacji 8 (uwagi z 2 listopada wieczorem):**

2i. **Zamek płatwi.** Dom 7000 × 5000 → w modelu płatew w szczycie: bal dochodzi do dna wrębu z obu boków i od spodu,
   bez szczeliny 5 mm.
2j. **Słupek węgła przy szczycie.** Prostokąt 8000 × 6400 (węgły na szczytach): górny bal słupka ścięty skośnie do
   płaszczyzny dachu, bez przerwy pod dachem; węgły na ścianach okapowych – wieniec nad ścianą, ścięty linią dachu.
2k. **Węgły symetryczne i równo.** Prostokąt 12000 × 6000: węgły na W-1 i W-3 w tych samych miejscach, odstępy równe;
   „Węgieł – wypust na zewnątrz” 200 → słupki 100 w środku, 200 na zewnątrz; w tabeli węgłów kolumny Wewn. / Zewn.
2l. **Wypuszczone wieńce.** Dwa górne wieńce ścian okapowych wychodzą za szczyty tak jak płatwie (500). „Węgły pod
   okapem – górne bale do nawisu okapu”: tak → górne bale węgłów na ścianach okapowych wysunięte i ścięte dachem.
2m. **Podłoga.** „Fundament – kształt”: okrągły, średnica 300 → stopy okrągłe. Dom z tarasem: stopy pod ścianą domu
   w jej osi. „Podciąg – poziom”: na równo → podciąg między podwalinami, wierzch równo z nimi, legary podzielone.
2n. **Balustrada z wieńców ścian.** Taras na słupach, „Balustrada – z czego”: z wieńców ścian → ściany boczne ciągłe
   do frontu (do 1 m), front z przerwą na wejście, w narożnikach frontu co druga belka wysunięta 100; zakładka „nie” →
   końce równo z licem.
2o. **Szczyt pusty.** „Szczyt nad tarasem”: pusty → nad balem spinającym wiązar aż do kalenicy (od kompilacji 9 – krok 2u).
2p. **Typy.** Lista szablonów: Typ 100, 200, 300, 400 – wczytaj kolejno; w opisach pól nie ma „jak 900 / 1100”.

**Nowe w kompilacji 7 (Twoje uwagi do kompilacji 6):**

2a. **Okno.** Generuj dom… → „Dach”: dwuspadowy – pola „Jednospadowy – …” ukryte; jednospadowy – pokazują się.
   „Podłoga” → dobór legara „ręczny” – pojawia się pole „Legar – przekrój do sprawdzenia” (wpisz 50x150) i ocena
   w ramce przeliczeń pod sekcją. Pytajnik przy „Obciążenie użytkowe” i „Podbitka” – objaśnienie z rysunkiem. Po każdej
   zmianie w „Wynik” linijka „Po ostatniej zmianie: bale … (+…)”. Tabela okien: kolumna „Spód okna”.
2b. **Płatwie na pełnym balu.** Prostokąt 7000 × 5000, ustawienia fabryczne → widok ściany szczytowej: wszystkie płatwie
   80 × 200, pod każdą drewno (bez przerwy), wysokość 200 po wyższej stronie. W modelu płatwie z wrębami 5 mm z boku
   i 8 mm od spodu w szczytach – płatwie trzymają szczyty.
2c. **Ściana nośna.** „Oparcie dachu przy ścianie okapowej”: ściana nośna → bez płatwi ściennej, górny bal ścian
   okapowych ścięty skośnie do dachu (widok ściany – linia dachu na wierzchu). Płatew ścienna „na ścianie” – też ścięta.
2d. **Działowe.** Ten sam dom z działową wzdłuż kalenicy pod kalenicą i drugą w poprzek: wzdłużna sięga płatwi
   kalenicowej (gniazdo na całej długości); dom 6000 × 4000 z działową w poprzek przy bale do 5100 – styki wszystkich
   wieńców w zamku działowej, bez węgłów.
2e. **Węgły jak okna.** Sekcja „Węgły (kontrfory)”: + węgieł → ściana W-1, od 2000 → węgieł w rzucie i widoku;
   „+ węgieł na środku” → w osi wybranej ściany. „Węgieł na środku ściany – automatycznie”: na ścianach zewnętrznych.
2f. **Taras jak 1100** (4000 × 4000, taras 2000, wejście z lewej): słupy licem z licami ścian, w modelu zamek górny
   (150 obok bala) i dolny (100 obok podwaliny); naroże na jednym poziomie (bale ścian bocznych na półbalu frontu);
   poręcz frontu i boku na tej samej wysokości, ostatni bal bez piór. „Szczyt nad tarasem”: ażurowy, pusty. Widoki
   ścian tarasu w liście ścian.
2g. **Podłoga i fundamenty.** Prostokąt 7000 × 5000: fundamenty 3 × 4 rzędy w obrysie (skrajne licem z obrysem),
   podciągi od lica do lica podwalin, pod podwalinami. Podwalina 50 × 150 i „na śruby” – bez zamków. Podciągi „nie” –
   wyższy legar; legar ręczny za słaby – podpowiedź o dodatkowym rzędzie fundamentów.
2h. **Podbitka (nowe położenia).** „Podbitka”: przy samych płatwiach – do wyboru pod / na płatwiach; przy płatwiach
   i krokwiach – wszystkie cztery. Na płatwiach z krokwiami z aplikacji: deski wzdłuż spadku na płatwiach, krokwie
   z KROKU 2 leżą na deskach. Na krokwiach z aplikacją – KROK 2 ma włączoną nadbitkę z wymiarami podbitki. Pod płatwiami
   – deski pod spodem płatwi, węgły na ścianach okapowych kończą się pod deskami.

3. **Stolarka i luzy.** Prostokąt 5000 × 4000 → Generuj dom… → „Okna i drzwi”: nowe okno – szerokość i wysokość
   stolarki 1020 × 1010, luz górny pusty → w polu podpowiedź 20 (1,5 % wysokości), kolumna „Otwór w balach”
   1040 × 1030. Wpisz luz 30 → 1040 × 1040. W sekcji „Okna i drzwi – stolarka i luzy” luz boczny 5 → 1030 × …
   W widoku ściany otwór i przerywana stolarka w nim.
4. **Płatwie i szczyt.** Ten sam dom, widok ściany szczytowej: płatwie (fioletowe) wierzchem w linii dachu – ścięte po
   skosie (kalenicowa z dwóch stron), bale szczytu pełnym klinem do końca, bez urwanych końcówek. „Generuj w modelu”
   → w modelu płatwie ścięte, krokwie i deski leżałyby na całej szerokości.
5. **Dom na samych płatwiach – deski z aplikacji (nowe).** Prostokąt 6000 × 4500 → Generuj dom… (ustawienia
   fabryczne: układ dachu „same płatwie”, „Krokwie i poszycie – kto je buduje”: aplikacja; sekcja „Poszycie dachu”:
   deskowanie pełne – tak). Podpowiedź „Dach: poszycie z aplikacji… deskowanie na płatwiach”. „Generuj w modelu” →
   komunikat „Połacie dachu gotowe – zatwierdź poszycie…”, okno KROKU 2: krokwie wyłączone, zakładka Poszycie –
   deskowanie 25 × 100, zakładka Krokwie – „Płatwie pod połacią jako podpory” włączone. OK → deski wzdłuż spadku, leżą
   na płatwiach, styki nad płatwiami; raport: „Płatwie pod połaciami” (źródło: lista z wywołania innej wtyczki),
   „Bez krokwi: poszycie leży na płatwiach”, zakładka Poszycie (szt., m², m³). Wyłącz deskowanie w generatorze →
   podpowiedź-uwaga „same płatwie bez poszycia”.
5a. **Krokwie z aplikacji do dachów.** Układ dachu „płatwie i krokwie” → „Generuj w modelu”: okno KROKU 2 (kierunek „w
   górę”, bez płatwi kalenicowej i zamków dolnych, krokiew 50 × 150, rozstaw 900, deskowanie). OK → krokwie leżą na
   płatwiach, nie wchodzą w szczyty, deski na krokwiach; raport – Nośność: „Podpory pośrednie – … płatwie pod połacią
   i płatew u góry: przęsła …” (przęsła między płatwiami, nie od okapu do kalenicy). W generatorze włącz nadbitkę i OSB
   22 → w KROKU 2 te warstwy. Zmień kąt dachu → „Zastąp dom w modelu” → pytanie o więźbę poprzedniej wersji (także
   gdy przesunięto ją dalej od domu) → Tak → nowe połacie i KROK 2. Jedno Ctrl+Z cofa dom razem z połaciami.
   Aplikacja do dachów starsza niż 3.7.0: komunikat „…jest za stara – potrzebna 3.7.0 lub nowsza”; wyłączona
   w Menedżerze rozszerzeń: komunikat, że nie jest wczytana (dom powstaje).
6. **Dach jednospadowy.** „Dach”: jednospadowy, kąt 15°, płatwie i krokwie → podgląd i widok ścian: ściana niska
   (po stronie spadku), wysoka – do połaci (górny bal przycięty), szczyty skośne. Generuj z krokwiami z aplikacji:
   jedna połać, KROK 2; w raporcie podpory: płatwie i „Ściana wysoka W-…”. Z krokwiami z generatora – krokwie
   w jednym kawałku od okapu do okapu.
7. **Taras jak 1100.** Prostokąt 4000 × 4000, „Taras”: jak 1100, głębokość 2000, wejście z lewej, liczba wieńców 20
   → rzut dłuższy o taras, ściana domu jako działowa ze szczytem. Widoki: ściana boczna – nad tarasem dwa górne
   wieńce, pod nimi balustrada (bale i przekładki 300), front – podciąg i szczyt, słupy. „Generuj w modelu” → grupa
   i tag „Taras” ze słupami, bale balustrady w ścianach z tagiem „Taras”; drzwi w ścianie domu od strony tarasu.
8. **Taras jak 1200.** Prostokąt 7000 × 4000, taras jak 1200 → ściany boczne pełne do frontu, front bez bali, dach
   i płatwie nad tarasem.
9. **Jak w kompilacjach 4 i 5:** pola Podstawowe / Wszystkie, widok ściany (ostatki, węgły kliknięciem), działowa pod
   antresolą, strop nad parterem, pełny profil, zestawienie CSV, przebudowa przesuniętego domu, zapamiętanie ustawień,
   szablony, „Kontrola…”.
10. **Dokumentacja 2D (gdy wdrożone zadanie `docs/zadanie_dokumentacja2d.md`):** dom z generatora → grupy Bs / Kf / Sz,
    zamki jako zamki, płatwie jako ścięcie, bale w zakupach 44 × 139.
