# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_dach.rb
# Zadanie: parametry sekcji „Szczyty i dach” i „Poszycie dachu” – szczyty, dach, płatwie (dobór przekroju, śnieg, ciężar pokrycia), krokwie (dobór przekroju), oparcie dachu, poszycie, położenie desek nadbitki / podbitki (jedno pole) i przeniesienie dawnych pól nadbitki.
# Tematy: parametry dachu, parametry szczytów, parametry płatwi, dobór przekroju płatwi – parametry, śnieg – parametr, poszycie dachu – parametry, dach jednospadowy – parametry, krokwie z aplikacji do dachów – parametr, dobór przekroju krokwi – parametry, podbitka – parametry, nadbitka – parametry, położenie desek nadbitki i podbitki, zamiennik położenia desek, dawne pola nadbitki
# Zależy od: rdzen/parametry_lista.rb (TAK_NIE), rdzen/wykaz_drewna.rb (listy przekrojów z hurtowni)
# Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji)
#
# Wpis jak w rdzen/parametry_lista.rb (klucz, domyślna, etykieta, jednostka, zakres, rodzaj, sekcja, wybory, podpowiedź;
# gdy – pole widoczne tylko przy wybranych wartościach innych pól, pomoc – dłuższe objaśnienie pod znakiem zapytania).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'wykaz_drewna') unless defined?(ArteMadera::GeneratorWiencowy::WykazDrewna)

module ArteMadera
  module GeneratorWiencowy
    module ParametryDach
      TAK_NIE = [['tak', 'tak'], ['nie', 'nie']].freeze unless const_defined?(:TAK_NIE)

      # Parametry sekcji (kolejność = kolejność w oknie).
      # Położenie desek nadbitki / podbitki, które zastępuje wybrane, gdy układ dachu nie ma płatwi pośrednich albo krokwi
      # (to samo w oknie – html/zalezne.js).
      DESKI_ZAMIENNIKI = { 'na_krokwiach' => 'na_platwiach', 'na_platwiach' => 'na_krokwiach', 'pod_krokwiami' => 'pod_platwiami',
                           'pod_platwiami' => 'pod_krokwiami' }.freeze unless const_defined?(:DESKI_ZAMIENNIKI)
      # Położenia desek dostępne w układzie dachu bez krokwi i bez płatwi pośrednich (płatwie i krokwie – wszystkie).
      DESKI_UKLAD = { 'platwie' => %w[na_platwiach pod_platwiami], 'krokwie' => %w[na_krokwiach pod_krokwiami] }.freeze unless
        const_defined?(:DESKI_UKLAD)
      # Wymiary nadbitki sprzed rundy 16 (osobne pola) => wymiary wspólnej deski nadbitki / podbitki.
      NADBITKA_WYMIARY = { 'nadbitka_grubosc' => 'podbitka_grubosc', 'nadbitka_krycie' => 'podbitka_krycie',
                           'nadbitka_dlugosc' => 'podbitka_dlugosc' }.freeze unless const_defined?(:NADBITKA_WYMIARY)

      LISTA = [
        { klucz: 'szczyty', podstawowy: true, domyslna: 'tak', etykieta: 'Szczyty z bali', rodzaj: :wybor, sekcja: 'szczyty', wybory: TAK_NIE,
          podpowiedz: 'Ściany szczytowe zewnętrzne dostają szczyt z bali ściętych pod kątem dachu.' },
        { klucz: 'szczyty_na_dzialowych', domyslna: 'nie', etykieta: 'Szczyty także na działowych szczytowych',
          rodzaj: :wybor, sekcja: 'szczyty', gdy: { 'szczyty' => ['tak'] }, wybory: TAK_NIE, podpowiedz: 'Ściana działowa w poprzek kalenicy dochodzi do dachu (ze szczytem).' },
        { klucz: 'dzialowa_wzdluz_do_dachu', podstawowy: true, domyslna: 'tak', etykieta: 'Działowe wzdłuż kalenicy – do dachu',
          rodzaj: :wybor, sekcja: 'szczyty', wybory: TAK_NIE,
          podpowiedz: 'Działowa równoległa do kalenicy (dom prostokątny) rośnie do płaszczyzny dachu, górny bal ścięty pod dach; ' \
                      'pod kalenicą podpiera płatew kalenicową (gniazdo na całej długości), w szczytach daje miejsce na styki. ' \
                      'Nie – kończy się na wysokości ścian okapowych.' },
        { klucz: 'dach_rodzaj', podstawowy: true, domyslna: 'dwuspadowy', etykieta: 'Dach', rodzaj: :wybor, sekcja: 'szczyty', gdy: { 'szczyty' => ['tak'] },
          wybory: [['dwuspadowy', 'dwuspadowy – dwa szczyty, kalenica w środku'],
                   ['jednospadowy', 'jednospadowy – ściana niska i wysoka, szczyty skośne']],
          podpowiedz: 'Jednospadowy – dom prostokątny. Dom w kształcie L dostaje dwa dachy dwuspadowe z koszem. Inne dachy (kopertowy, wielospadowy) zrób w aplikacji do dachów ' \
                      '(KROK 1 z obrysu).' },
        { klucz: 'dach_spadek', podstawowy: true, domyslna: 'min', etykieta: 'Jednospadowy – spadek w stronę', rodzaj: :wybor,
          sekcja: 'szczyty', gdy: { 'dach_rodzaj' => ['jednospadowy'] }, wybory: [['min', 'dolnej albo lewej (rysunek z góry)'], ['max', 'górnej albo prawej (rysunek z góry)']],
          podpowiedz: 'Po stronie spadku ściana niska (wysokość ścian okapowych), naprzeciw – ściana wysoka, do połaci. Okapy ' \
                      'wzdłuż „kalenicy”: wzdłuż X – spadek w dół / w górę rysunku, wzdłuż Y – w lewo / w prawo.' },
        { klucz: 'dach_okap_wysoki', domyslna: 500.0, etykieta: 'Jednospadowy – okap za ścianą wysoką', jednostka: 'mm', min: 0.0,
          max: 1500.0, rodzaj: :liczba, sekcja: 'szczyty', gdy: { 'dach_rodzaj' => ['jednospadowy'] }, podpowiedz: 'W poziomie, od lica ściany wysokiej.' },
        { klucz: 'jednospad_min_pasek', domyslna: 30.0, etykieta: 'Jednospadowy – najcieńszy górny bal ściany wysokiej',
          jednostka: 'mm', min: 0.0, max: 300.0, rodzaj: :liczba, sekcja: 'szczyty', gdy: { 'dach_rodzaj' => ['jednospadowy'] },
          podpowiedz: 'Ściana wysoka sięga połaci, górny bal przycięty wzdłuż; cieńszy pasek jest pomijany.' },
        { klucz: 'dach_kat', podstawowy: true, domyslna: 20.0, etykieta: 'Kąt dachu', jednostka: '°', min: 5.0, max: 60.0, rodzaj: :liczba,
          sekcja: 'szczyty', gdy: { 'szczyty' => ['tak'] }, podpowiedz: 'Typ 100: 20°.' },
        { klucz: 'dach_uklad', podstawowy: true, domyslna: 'platwie', etykieta: 'Układ dachu', rodzaj: :wybor, sekcja: 'szczyty', rysunek: 'uklad_dachu', gdy: { 'szczyty' => ['tak'] },
          wybory: [['platwie', 'same płatwie (deski na płatwiach)'], ['krokwie', 'krokwie na płatwi ściennej i kalenicowej'],
                   ['platwie_krokwie', 'płatwie i krokwie']] },
        { klucz: 'dach_wiezba', podstawowy: true, domyslna: 'aplikacja', etykieta: 'Krokwie i poszycie – kto je buduje',
          rodzaj: :wybor, sekcja: 'szczyty',
          wybory: [['aplikacja', 'aplikacja do dachów (KROK 2: krokwie, poszycie, kontrola)'],
                   ['generator', 'generator (krokwie bez kontroli, bez poszycia)']],
          podpowiedz: 'Dom prostokątny i w kształcie L (dom L – tylko aplikacja). Aplikacja do dachów (ArteMadera Roof, 3.7.0 lub nowsza) dostaje połacie na wierzchu ' \
                      'płatwi generatora i jego płatwie jako podpory: z krokwiami – KROK 2 liczy krokwie (przęsła między ' \
                      'płatwiami), poszycie, łaty i nośność; same płatwie – poszycie wprost na płatwiach, wzdłuż spadku, styki ' \
                      'na płatwiach. Szczyt kończy się pod krokwiami, krokwie przy szczycie ustawia się w aplikacji.' },
        { klucz: 'dach_podniesienie', domyslna: 69.5, etykieta: 'Wierzch płatwi nad ścianą okapową (przy licu wewn.)',
          jednostka: 'mm', min: -300.0, max: 1500.0, rodzaj: :liczba, sekcja: 'szczyty',
          podpowiedz: 'Typ 100: 69,5 = wierzch najwyższego bala ściany szczytowej. Nie dotyczy płatwi stojącej na ścianie.',
          gdy: { 'platwa_na_scianie' => ['tak'], 'platwa_scienna_polozenie' => ['przy_licu'] } },
        { klucz: 'krokwie_przy_szczycie', podstawowy: true, domyslna: 'obie_strony', etykieta: 'Krokwie przy ścianie szczytowej',
          rodzaj: :wybor, sekcja: 'szczyty', gdy: { 'dach_uklad' => %w[krokwie platwie_krokwie], 'dach_wiezba' => ['generator'] },
          wybory: [['obie_strony', 'z obu stron szczytu'], ['wewnatrz', 'tylko od wewnątrz'], ['zewnatrz', 'tylko od zewnątrz'],
                   ['na_szczycie', 'na szczycie (krokiew oparta na balach)']],
          podpowiedz: 'Krokwie z generatora: obok szczytu – szczyt dochodzi do wierzchu krokwi; na szczycie – szczyt kończy się pod ' \
                      'nią. Krokwie z aplikacji do dachów – szczyt zawsze pod krokwiami.' },
        { klucz: 'krokwie_dobor', podstawowy: true, domyslna: 'reczny', etykieta: 'Przekrój krokwi – dobór', rodzaj: :wybor,
          sekcja: 'szczyty', gdy: { 'dach_uklad' => %w[krokwie platwie_krokwie] },
          wybory: [['reczny', 'z wyboru – przekrój podany niżej (ze sprawdzeniem nośności)'],
                   ['auto', 'automatycznie – najmniejszy wystarczający z listy']],
          podpowiedz: 'Jeden przekrój krokwi całego dachu – także krokwi bocznego zadaszenia. Automatycznie: generator liczy śnieg ' \
                      'i ciężar pokrycia na krokiew (rozstaw krokwi, przęsło między płatwiami, okap jako wspornik) i bierze ' \
                      'najlżejszy przekrój z listy. Z aplikacją do dachów – wartość na start KROKU 2 (tam pełna kontrola).' },
        { klucz: 'krokiew_przekroj', domyslna: '50x150', etykieta: 'Krokiew (szer. × wys.)', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'szczyty', gdy: { 'dach_uklad' => %w[krokwie platwie_krokwie], 'krokwie_dobor' => ['reczny'] },
          podpowiedz: 'Z aplikacją do dachów – wartość na start KROKU 2. Wynik sprawdzenia – pod sekcją.' },
        { klucz: 'krokwie_katalog', domyslna: WykazDrewna.lista(:krokwie),
          etykieta: 'Dostępne przekroje krokwi', rodzaj: :tekst, sekcja: 'szczyty',
          gdy: { 'dach_uklad' => %w[krokwie platwie_krokwie], 'krokwie_dobor' => ['auto'] },
          podpowiedz: 'Lista z hurtowni: „szer.×wys.:długości w metrach”, np. 45x195:4.2/5.4/6/7 – po przecinku; dobór bierze ' \
                      'najlżejszy wystarczający.' },
        { klucz: 'krokwie_rozstaw', domyslna: 900.0, etykieta: 'Rozstaw krokwi – największy', jednostka: 'mm', min: 300.0,
          max: 2000.0, rodzaj: :liczba, sekcja: 'szczyty', gdy: { 'dach_uklad' => %w[krokwie platwie_krokwie] }, podpowiedz: 'Z aplikacją do dachów – wartość na start KROKU 2.' },
        { klucz: 'platwie_dobor', podstawowy: true, domyslna: 'reczny', etykieta: 'Przekrój płatwi – dobór', rodzaj: :wybor,
          sekcja: 'szczyty', gdy: { 'szczyty' => ['tak'] },
          wybory: [['reczny', 'ręcznie – przekroje podane niżej (ze sprawdzeniem nośności)'],
                   ['auto', 'automatycznie – najmniejszy wystarczający z listy']],
          podpowiedz: 'Automatycznie: generator liczy śnieg i ciężar pokrycia na każdą płatew (pas dachu, największe przęsło ' \
                      'między ścianami) i bierze najlżejszy przekrój z listy, który to przenosi. Mały, wąski domek dostaje ' \
                      'mniejsze płatwie – i mniejszy trójkąt nad tarasem (z przekroju płatwi). Wynik to podpowiedź, nie projekt ' \
                      'konstruktora.',
          pomoc: 'Przęsło płatwi to odległość między ścianami, które ją podpierają: szczyty, działowe ze szczytem, ściana domu ' \
                 'przy tarasie, trójkąt nad tarasem. Im dłuższe przęsło i większy rozstaw płatwi, tym większy przekrój. Ręcznie – ' \
                 'przy polach przekroju pojawia się wynik sprawdzenia i najmniejszy wystarczający przekrój z listy.' },
        { klucz: 'platwie_katalog', domyslna: WykazDrewna.lista(:platwie),
          etykieta: 'Dostępne przekroje płatwi', rodzaj: :tekst, sekcja: 'szczyty', gdy: { 'szczyty' => ['tak'] },
          podpowiedz: 'Lista z hurtowni (drewno widoczne Nsi / DUO / BSH): „szer.×wys.:długości w metrach”, np. 80x200:5/7/8 – ' \
                      'po przecinku. Dobór bierze najlżejszy wystarczający; płatew dłuższa niż najdłuższa belka z listy – uwaga w wynikach.' },
        { klucz: 'dach_snieg', domyslna: 0.9, etykieta: 'Śnieg – obciążenie gruntu', jednostka: 'kN/m²', min: 0.0, max: 6.0,
          rodzaj: :liczba, sekcja: 'szczyty', gdy: { 'szczyty' => ['tak'] },
          podpowiedz: 'Strefy śniegowe Polski: 1 – 0,7; 2 – 0,9 (większość kraju); 3 – 1,2; 4 – 1,6; 5 (góry) – 2,0 i więcej.',
          pomoc: 'Obciążenie śniegiem gruntu z mapy stref (PN-EN 1991-1-3). Na dach generator przelicza je współczynnikiem ' \
                 'kształtu: 0,8 do kąta 30°, coraz mniej do 60° (śnieg się zsuwa). 1 kN/m² ≈ 100 kg na metr kwadratowy.' },
        { klucz: 'dach_ciezar', domyslna: 0.35, etykieta: 'Ciężar pokrycia z poszyciem', jednostka: 'kN/m²', min: 0.05, max: 3.0,
          rodzaj: :liczba, sekcja: 'szczyty', gdy: { 'szczyty' => ['tak'] },
          podpowiedz: 'Na metr kwadratowy połaci, bez płatwi: deski 25 mm z papą albo gontem ok. 0,25–0,35; z nadbitką i ' \
                      'blachą ok. 0,35; dachówka ceramiczna z łatami 0,6–0,9.' },
        { klucz: 'dach_ugiecie', domyslna: 200.0, etykieta: 'Ugięcie płatwi dopuszczalne L /', jednostka: '', min: 100.0,
          max: 600.0, rodzaj: :liczba, sekcja: 'szczyty', gdy: { 'szczyty' => ['tak'] },
          podpowiedz: 'L/200: płatew o przęśle 4 m ugina się pod śniegiem najwyżej o 20 mm. Większa liczba – sztywniejszy dach.' },
        { klucz: 'platwie_jeden_przekroj', podstawowy: true, domyslna: 'tak', etykieta: 'Jeden przekrój wszystkich płatwi',
          rodzaj: :wybor, sekcja: 'szczyty', wybory: TAK_NIE,
          podpowiedz: 'Tak – ścienna, pośrednie i kalenicowa z przekroju „Płatew” (wszystkie tej samej wysokości). Nie – osobne ' \
                      'przekroje płatwi ściennej i kalenicowej.' },
        { klucz: 'platwa_przekroj', podstawowy: true, domyslna: '80x200', etykieta: 'Płatew (pośrednia)', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'szczyty', gdy: { 'platwie_dobor' => ['reczny'] },
          podpowiedz: 'Wysokość płatwi zostaje w całości po wyższej stronie; wierzch ścięty pod dach tylko od strony okapu ' \
                      '(typ 100: 80 × 200).' },
        { klucz: 'platwa_kalenicowa_przekroj', domyslna: '80x200', etykieta: 'Płatew kalenicowa', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'szczyty', gdy: { 'platwie_jeden_przekroj' => ['nie'], 'platwie_dobor' => ['reczny'] } },
        { klucz: 'platwie_rozstaw_max', domyslna: 1000.0, etykieta: 'Największy rozstaw płatwi (w poziomie)',
          jednostka: 'mm', min: 300.0, max: 4000.0, rodzaj: :liczba, sekcja: 'szczyty', gdy: { 'dach_uklad' => %w[platwie platwie_krokwie] }, podpowiedz: 'Typ 100: ok. 990.' },
        { klucz: 'platwa_na_scianie', podstawowy: true, domyslna: 'tak', etykieta: 'Oparcie dachu przy ścianie okapowej',
          rodzaj: :wybor, sekcja: 'szczyty',
          wybory: [['tak', 'płatew ścienna – osobna belka przy ścianie albo na ścianie'],
                   ['nie', 'ściana nośna – bez płatwi, górny bal ścięty do płaszczyzny dachu']],
          podpowiedz: 'Ściana nośna: dach (krokwie albo deski) leży wprost na ścianie okapowej – jej górny bal jest ścięty pod ' \
                      'kątem dachu na całej długości (dach jednospadowy – także ściana wysoka).' },
        { klucz: 'platwa_scienna_polozenie', domyslna: 'przy_licu', etykieta: 'Płatew ścienna – położenie', rodzaj: :wybor,
          sekcja: 'szczyty', rysunek: 'platwa_scienna', wybory: [['przy_licu', 'przy licu wewnętrznym, wierzchem na linii dachu (typ 100)'],
                                      ['na_scianie', 'stoi na ścianie okapowej, w osi – ścięta pod dach']],
          gdy: { 'platwa_na_scianie' => ['tak'] } },
        { klucz: 'platwa_scienna_przekroj', domyslna: '80x200', etykieta: 'Płatew ścienna', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'szczyty', podpowiedz: 'Typ 100: 60 × 200.',
          gdy: { 'platwa_na_scianie' => ['tak'], 'platwie_jeden_przekroj' => ['nie'], 'platwie_dobor' => ['reczny'] } },
        { klucz: 'platwie_na_wiencach', domyslna: 'tak', etykieta: 'Płatwie oparte na pełnym balu', rodzaj: :wybor,
          sekcja: 'szczyty', wybory: TAK_NIE,
          podpowiedz: 'Pod gniazdem płatwi nie zostaje pasek bala cieńszy niż „Najcieńszy pasek bala nad / pod otworem”: dach ' \
                      'obniżony o kilkanaście mm (płatew ścienna i kalenicowa), płatwie pośrednie przesunięte o kilka cm – płatew ' \
                      'leży na całym balu albo na grubszym pasku, bez przerwy pod spodem.' },
        { klucz: 'dach_obnizenie_max', domyslna: 60.0, etykieta: 'Dopasowanie płatwi – największe obniżenie dachu',
          jednostka: 'mm', min: 0.0, max: 139.0, rodzaj: :liczba, sekcja: 'szczyty', gdy: { 'platwie_na_wiencach' => ['tak'] } },
        { klucz: 'platwie_przesuniecie_max', domyslna: 150.0, etykieta: 'Dopasowanie płatwi – największe przesunięcie pośredniej',
          jednostka: 'mm', min: 0.0, max: 500.0, rodzaj: :liczba, sekcja: 'szczyty', gdy: { 'platwie_na_wiencach' => ['tak'] },
          podpowiedz: 'W poziomie, w stronę okapu albo kalenicy; rozstaw płatwi zostaje nie większy niż największy.' },
        { klucz: 'platwie_zamki', podstawowy: true, domyslna: 'tak', etykieta: 'Zamki w płatwiach (wręby w ścianach)',
          rodzaj: :wybor, sekcja: 'szczyty', wybory: TAK_NIE,
          podpowiedz: 'Płatew w każdej ścianie, przez którą przechodzi (szczyt, działowa, węgieł), zwężona z boków i podcięta od ' \
                      'spodu – barki po obu stronach ściany trzymają szczyt na miejscu.' },
        { klucz: 'platwa_zamek_bok', domyslna: 5.0, etykieta: 'Zamek płatwi – wrąb z każdego boku', jednostka: 'mm', min: 0.0,
          max: 30.0, rodzaj: :liczba, sekcja: 'szczyty', gdy: { 'platwie_zamki' => ['tak'] } },
        { klucz: 'platwa_zamek_dol', domyslna: 8.0, etykieta: 'Zamek płatwi – wrąb od spodu', jednostka: 'mm', min: 0.0,
          max: 40.0, rodzaj: :liczba, sekcja: 'szczyty', gdy: { 'platwie_zamki' => ['tak'] }, podpowiedz: 'Zalecane 5–10 mm.' },
        { klucz: 'platwa_zamek_luz', domyslna: 1.0, etykieta: 'Zamek płatwi – luz wzdłuż (z każdej strony ściany)', jednostka: 'mm',
          min: 0.0, max: 20.0, rodzaj: :liczba, sekcja: 'szczyty', gdy: { 'platwie_zamki' => ['tak'] },
          podpowiedz: 'Wrąb dłuższy od grubości ściany o tyle z każdej strony.' },
        { klucz: 'gniazdo_luz', domyslna: 5.0, etykieta: 'Luz w gnieździe płatwi (każda strona)', jednostka: 'mm',
          min: 0.0, max: 30.0, rodzaj: :liczba, sekcja: 'szczyty' },
        { klucz: 'platwie_sciecie', domyslna: 'tak', etykieta: 'Wierzch płatwi ścięty do płaszczyzny dachu', rodzaj: :wybor,
          sekcja: 'szczyty', wybory: TAK_NIE,
          podpowiedz: 'Tak – płatew podniesiona, wierzch ścięty po skosie (kalenicowa z dwóch stron), krokwie i deski leżą ' \
                      'na całej szerokości. Nie – wierzch poziomy pod dachem.' },
        { klucz: 'szczyt_min_wysokosc', domyslna: 0.0, etykieta: 'Najniższy kawałek bala przy skosie', jednostka: 'mm',
          min: 0.0, max: 140.0, rodzaj: :liczba, sekcja: 'szczyty',
          podpowiedz: '0 – bal szczytu idzie pełnym klinem do końca, szczyt wypełniony do linii dachu (wymóg). Więcej – niższy ' \
                      'klin pomijany (bal kończy się pionowo).' },
        { klucz: 'zamek_min_drewno', domyslna: 20.0, etykieta: 'Drewno w zamku przy skosie dachu – najmniej', jednostka: 'mm',
          min: 0.0, max: 100.0, rodzaj: :liczba, sekcja: 'szczyty',
          podpowiedz: 'Bal ścięty dachem przechodzi przez narożnik tylko w zamku, w którym zostaje co najmniej tyle drewna nad ' \
                      'gniazdem; inaczej kończy się przy licu ściany poprzecznej (np. przy ścianie wysokiej dachu jednospadowego).' },
        { klucz: 'polzamek', domyslna: 'tak', etykieta: 'Pół zamka w ostatnim połączeniu pod dachem', rodzaj: :wybor, sekcja: 'szczyty',
          wybory: TAK_NIE, gdy: { 'szczyty' => ['tak'] },
          podpowiedz: 'Ostatni bal pod skosem dachu, któremu zwykłe gniazdo od spodu zostawia za mało drewna, przechodzi przez ' \
                      'zamek bez gniazda, a bal pod nim dostaje gniazdo do połowy wysokości – koniec ostatniego bala nie odpada. ' \
                      'Nie – taki bal kończy się przy licu ściany poprzecznej (jak do kompilacji 14).' },
        { klucz: 'polzamek_gleb', domyslna: 0.0, etykieta: 'Pół zamka – gniazdo w balu dolnym (0 = do połowy bala)', jednostka: 'mm',
          min: 0.0, max: 150.0, rodzaj: :liczba, sekcja: 'szczyty', gdy: { 'szczyty' => ['tak'], 'polzamek' => ['tak'] },
          podpowiedz: '0 – całe wycięcie w balu dolnym (dwie głębokości gniazda, np. 72), bal górny bez gniazda. Mniej – reszta ' \
                      'od spodu bala górnego (nie mniej niż zwykłe gniazdo).' },
        { klucz: 'szczyt_min_kawalek', domyslna: 10.0, etykieta: 'Najkrótszy kawałek bala przy skosie i gnieździe', jednostka: 'mm',
          min: 0.0, max: 500.0, rodzaj: :liczba, sekcja: 'szczyty',
          podpowiedz: 'Krótsze drzazgi między skosem a gniazdem płatwi są pomijane (szczyt poza nimi wypełniony; typ 100: najkrótszy ' \
                      'kawałek 104).' },
        { klucz: 'dach_elementy', domyslna: 'tak', etykieta: 'Belki dachu w modelu (płatwie, krokwie)', rodzaj: :wybor,
          sekcja: 'szczyty', wybory: TAK_NIE, podpowiedz: 'Dla obrysu prostokątnego i w kształcie L (dwa dachy z koszem).' },
        { klucz: 'dach_okap', podstawowy: true, domyslna: 500.0, etykieta: 'Okap – wysunięcie krokwi za ścianę', jednostka: 'mm', min: 0.0,
          max: 1500.0, rodzaj: :liczba, sekcja: 'szczyty', podpowiedz: 'W poziomie, od lica ściany okapowej.' },
        { klucz: 'dach_okap_szczyt', podstawowy: true, domyslna: 500.0, etykieta: 'Wysunięcie płatwi za szczyt', jednostka: 'mm', min: 0.0,
          max: 1500.0, rodzaj: :liczba, sekcja: 'szczyty', podpowiedz: 'Od lica szczytu (typ 100: płatwie 6082).' },

        { klucz: 'okap_wience_wypust', domyslna: 2, etykieta: 'Górne wieńce ścian okapowych wypuszczone za szczyt', jednostka: 'szt.',
          min: 0, max: 6, rodzaj: :calkowita, sekcja: 'szczyty', gdy: { 'szczyty' => ['tak'] },
          podpowiedz: 'Tyle górnych wieńców ścian okapowych kończy się tak jak płatwie (wysunięcie płatwi za szczyt) – oparcie ' \
                      'dachu nad szczytem. 0 – zwykły ostatek.' },
        { klucz: 'wegly_wypust_okap', domyslna: 'nie', etykieta: 'Węgły pod okapem – górne bale do nawisu okapu', rodzaj: :wybor,
          sekcja: 'szczyty', wybory: TAK_NIE, gdy: { 'szczyty' => ['tak'] },
          pomoc: 'Górne bale węgłów na ścianach okapowych wysunięte na zewnątrz aż do nawisu okapu i ścięte linią dachu – ' \
                 'wsporniki pod płatew okapową albo krokwie. Ma sens z płatwią okapową na wypustach (krótsze krokwie, nawis ' \
                 'bez zastrzałów); przy zwykłym okapie zbędne – więcej drewna i czoła bali na deszczu.' },
        { klucz: 'wegly_okap_wience', domyslna: 3, etykieta: 'Węgły pod okapem – liczba górnych bali', jednostka: 'szt.',
          min: 1, max: 8, rodzaj: :calkowita, sekcja: 'szczyty', gdy: { 'wegly_wypust_okap' => ['tak'] } },
        { klucz: 'podbitka', podstawowy: true, domyslna: 'na_krokwiach', etykieta: 'Nadbitka / podbitka – gdzie leżą deski', rodzaj: :wybor,
          sekcja: 'poszycie',
          wybory: [['na_platwiach', 'na płatwiach (nadbitka, deski wzdłuż spadku)'],
                   ['na_krokwiach', 'na krokwiach (nadbitka, deski równolegle do okapu)'],
                   ['pod_krokwiami', 'pod krokwiami (podbitka, równolegle do okapu, między płatwiami)'],
                   ['pod_platwiami', 'pod płatwiami (podbitka, deski wzdłuż spadku)'],
                   ['nie', 'bez nadbitki i podbitki']],
          wybory_gdy: { 'pod_platwiami' => { 'dach_uklad' => %w[platwie platwie_krokwie] },
                        'na_platwiach' => { 'dach_uklad' => %w[platwie platwie_krokwie] },
                        'pod_krokwiami' => { 'dach_uklad' => %w[krokwie platwie_krokwie] },
                        'na_krokwiach' => { 'dach_uklad' => %w[krokwie platwie_krokwie] } },
          zamienniki: DESKI_ZAMIENNIKI,
          rysunek: 'podbitka',
          pomoc: 'Jedno miejsce dla desek pióro-wpust widocznych od spodu (decyzja z 2026-11-25): na płatwiach – nadbitka, deski ' \
                 'wzdłuż spadku leżą na płatwiach (krokwie, jeśli są, leżą na nich – wyżej o grubość deski); na krokwiach – ' \
                 'nadbitka, deski równolegle do okapu na krokwiach, pierwsza warstwa poszycia; pod krokwiami – podbitka przybita ' \
                 'do spodu krokwi w polach między płatwiami; pod płatwiami – podbitka wzdłuż spadku przybita do spodu płatwi; ' \
                 'bez – dach bez desek od spodu. Ściany działowe i węgły pod połacią kończą się pod podbitką „pod”. Nadbitkę na ' \
                 'krokwiach (i na samych płatwiach) z aplikacją do dachów robi aplikacja jako pierwszą warstwę poszycia; ' \
                 'pozostałe rysuje generator (grupa Dach). Wybory zależą od układu dachu: przy samych płatwiach „na krokwiach” ' \
                 'znaczy „na płatwiach”, przy samych krokwiach odwrotnie.' },
        { klucz: 'podbitka_grubosc', domyslna: 14.0, etykieta: 'Deska nadbitki / podbitki – grubość', jednostka: 'mm', min: 10.0, max: 60.0,
          rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'podbitka' => %w[pod_platwiami na_platwiach pod_krokwiami na_krokwiach] } },
        { klucz: 'podbitka_krycie', domyslna: 115.0, etykieta: 'Deska nadbitki / podbitki – szerokość krycia', jednostka: 'mm', min: 50.0,
          max: 300.0, rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'podbitka' => %w[pod_platwiami na_platwiach pod_krokwiami na_krokwiach] } },
        { klucz: 'podbitka_dlugosc', domyslna: 4000.0, etykieta: 'Deska nadbitki / podbitki – długość handlowa', jednostka: 'mm', min: 1000.0,
          max: 8000.0, rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'podbitka' => %w[pod_platwiami na_platwiach pod_krokwiami na_krokwiach] },
          podpowiedz: 'Dłuższe deski dzielone na płatwiach (pod i na płatwiach) albo równo (pod i na krokwiach).' },
        { klucz: 'poszycie_deski', podstawowy: true, domyslna: 'nie', etykieta: 'Deskowanie pełne', rodzaj: :wybor,
          sekcja: 'poszycie', wybory: TAK_NIE,
          podpowiedz: 'Na krokwiach (albo na nadbitce) równolegle do okapu, styki na krokwiach; przy samych płatwiach (typ 100) ' \
                      '– deski na płatwiach wzdłuż spadku, styki na płatwiach.' },
        { klucz: 'deski_grubosc', domyslna: 25.0, etykieta: 'Deskowanie – grubość deski', jednostka: 'mm', min: 10.0, max: 80.0,
          rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'poszycie_deski' => ['tak'] } },
        { klucz: 'deski_szerokosc', domyslna: 100.0, etykieta: 'Deskowanie – szerokość deski', jednostka: 'mm', min: 50.0,
          max: 300.0, rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'poszycie_deski' => ['tak'] } },
        { klucz: 'deski_szczelina', domyslna: 3.0, etykieta: 'Deskowanie – szczelina między deskami', jednostka: 'mm', min: 0.0,
          max: 30.0, rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'poszycie_deski' => ['tak'] } },
        { klucz: 'deski_dlugosc', domyslna: 4000.0, etykieta: 'Deskowanie – długość handlowa', jednostka: 'mm', min: 1000.0,
          max: 8000.0, rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'poszycie_deski' => ['tak'] } },
        { klucz: 'poszycie_osb', podstawowy: true, domyslna: 'nie', etykieta: 'Płyty OSB', rodzaj: :wybor, sekcja: 'poszycie',
          wybory: TAK_NIE, podpowiedz: 'Na poprzedniej warstwie (albo na krokwiach), dłuższy bok wzdłuż okapu, styki w mijance.' },
        { klucz: 'osb_grubosc', domyslna: 18.0, etykieta: 'OSB – grubość', jednostka: 'mm', min: 6.0, max: 40.0, rodzaj: :liczba,
          sekcja: 'poszycie', gdy: { 'poszycie_osb' => ['tak'] }, podpowiedz: 'Zwykle 18 albo 22.' },
        { klucz: 'osb_dlugosc', domyslna: 2500.0, etykieta: 'OSB – długość płyty (wzdłuż okapu)', jednostka: 'mm', min: 500.0,
          max: 5000.0, rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'poszycie_osb' => ['tak'] } },
        { klucz: 'osb_szerokosc', domyslna: 1250.0, etykieta: 'OSB – szerokość płyty', jednostka: 'mm', min: 300.0, max: 2500.0,
          rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'poszycie_osb' => ['tak'] } },
        { klucz: 'osb_szczelina', domyslna: 3.0, etykieta: 'OSB – szczelina przy każdej krawędzi', jednostka: 'mm', min: 0.0,
          max: 20.0, rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'poszycie_osb' => ['tak'] } }
      ].freeze unless const_defined?(:LISTA)

      module_function

      # Położenie desek zgodne z układem dachu: wybrane albo jego zamiennik (same płatwie – na / pod płatwiami, same
      # krokwie – na / pod krokwiami).
      def polozenie_desek(v, uklad)
        dozwolone = DESKI_UKLAD[uklad.to_s]
        return v if v == 'nie' || dozwolone.nil? || dozwolone.include?(v)
        DESKI_ZAMIENNIKI[v] || v
      end

      # Wartości zapisane przed rundą 16 (osobno „Podbitka” i „Nadbitka – pierwsza warstwa poszycia”) → jedno pole położenia
      # desek: nadbitka włączona bez podbitki = deski na krokwiach (przy samych płatwiach – na płatwiach) z jej wymiarami;
      # nadbitka wyłączona = bez desek; wybrana podbitka zostaje. Wejście bez dawnych kluczy – bez zmian.
      def przenies_nadbitke(wej)
        return wej unless wej.key?('poszycie_nadbitka') || NADBITKA_WYMIARY.keys.any? { |k| wej.key?(k) }
        w = wej.dup
        nb = w.delete('poszycie_nadbitka')
        if (w['podbitka'] || 'nie').to_s == 'nie'
          wlaczona = nb.nil? || nb.to_s == 'tak'
          w['podbitka'] = wlaczona ? 'na_krokwiach' : 'nie'
          NADBITKA_WYMIARY.each { |stary, nowy| w[nowy] = w[stary] if wlaczona && w.key?(stary) }
        end
        NADBITKA_WYMIARY.each_key { |k| w.delete(k) }
        w
      end
    end
  end
end
