# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_dach.rb
# Zadanie: parametry sekcji „Szczyty i dach” i „Poszycie dachu” – szczyty, dach, płatwie, krokwie, oparcie dachu, poszycie i podbitka.
# Tematy: parametry dachu, parametry szczytów, parametry płatwi, poszycie dachu – parametry, dach jednospadowy – parametry, krokwie z aplikacji do dachów – parametr, podbitka – parametry
# Zależy od: rdzen/parametry_lista.rb (TAK_NIE)
# Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji)
#
# Wpis jak w rdzen/parametry_lista.rb (klucz, domyślna, etykieta, jednostka, zakres, rodzaj, sekcja, wybory, podpowiedź;
# gdy – pole widoczne tylko przy wybranych wartościach innych pól, pomoc – dłuższe objaśnienie pod znakiem zapytania).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module ParametryDach
      TAK_NIE = [['tak', 'tak'], ['nie', 'nie']].freeze unless const_defined?(:TAK_NIE)

      # Parametry sekcji (kolejność = kolejność w oknie).
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
          podpowiedz: 'Jednospadowy – dom prostokątny. Inne dachy (kopertowy, wielospadowy, obrys L) zrób w aplikacji do dachów ' \
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
          podpowiedz: 'Dom prostokątny. Aplikacja do dachów (ArteMadera Roof, 3.7.0 lub nowsza) dostaje połacie na wierzchu ' \
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
        { klucz: 'krokiew_przekroj', domyslna: '50x150', etykieta: 'Krokiew (szer. × wys.)', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'szczyty', gdy: { 'dach_uklad' => %w[krokwie platwie_krokwie] }, podpowiedz: 'Z aplikacją do dachów – wartość na start KROKU 2.' },
        { klucz: 'krokwie_rozstaw', domyslna: 900.0, etykieta: 'Rozstaw krokwi – największy', jednostka: 'mm', min: 300.0,
          max: 2000.0, rodzaj: :liczba, sekcja: 'szczyty', gdy: { 'dach_uklad' => %w[krokwie platwie_krokwie] }, podpowiedz: 'Z aplikacją do dachów – wartość na start KROKU 2.' },
        { klucz: 'platwie_jeden_przekroj', podstawowy: true, domyslna: 'tak', etykieta: 'Jeden przekrój wszystkich płatwi',
          rodzaj: :wybor, sekcja: 'szczyty', wybory: TAK_NIE,
          podpowiedz: 'Tak – ścienna, pośrednie i kalenicowa z przekroju „Płatew” (wszystkie tej samej wysokości). Nie – osobne ' \
                      'przekroje płatwi ściennej i kalenicowej.' },
        { klucz: 'platwa_przekroj', podstawowy: true, domyslna: '80x200', etykieta: 'Płatew (pośrednia)', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'szczyty',
          podpowiedz: 'Wysokość płatwi zostaje w całości po wyższej stronie; wierzch ścięty pod dach tylko od strony okapu ' \
                      '(typ 100: 80 × 200).' },
        { klucz: 'platwa_kalenicowa_przekroj', domyslna: '80x200', etykieta: 'Płatew kalenicowa', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'szczyty', gdy: { 'platwie_jeden_przekroj' => ['nie'] } },
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
          gdy: { 'platwa_na_scianie' => ['tak'], 'platwie_jeden_przekroj' => ['nie'] } },
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
        { klucz: 'szczyt_min_kawalek', domyslna: 10.0, etykieta: 'Najkrótszy kawałek bala przy skosie i gnieździe', jednostka: 'mm',
          min: 0.0, max: 500.0, rodzaj: :liczba, sekcja: 'szczyty',
          podpowiedz: 'Krótsze drzazgi między skosem a gniazdem płatwi są pomijane (szczyt poza nimi wypełniony; typ 100: najkrótszy ' \
                      'kawałek 104).' },
        { klucz: 'dach_elementy', domyslna: 'tak', etykieta: 'Belki dachu w modelu (płatwie, krokwie)', rodzaj: :wybor,
          sekcja: 'szczyty', wybory: TAK_NIE, podpowiedz: 'Dla obrysu prostokątnego.' },
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
        { klucz: 'podbitka', podstawowy: true, domyslna: 'nie', etykieta: 'Podbitka – boazeria widoczna od spodu', rodzaj: :wybor,
          sekcja: 'poszycie',
          wybory: [['nie', 'bez podbitki'], ['pod_platwiami', 'pod płatwiami (wzdłuż spadku)'],
                   ['na_platwiach', 'na płatwiach (wzdłuż spadku)'],
                   ['pod_krokwiami', 'pod krokwiami (równolegle do okapu, między płatwiami)'],
                   ['na_krokwiach', 'na krokwiach (równolegle do okapu)']],
          wybory_gdy: { 'pod_platwiami' => { 'dach_uklad' => %w[platwie platwie_krokwie] },
                        'na_platwiach' => { 'dach_uklad' => %w[platwie platwie_krokwie] },
                        'pod_krokwiami' => { 'dach_uklad' => %w[krokwie platwie_krokwie] },
                        'na_krokwiach' => { 'dach_uklad' => %w[krokwie platwie_krokwie] } },
          rysunek: 'podbitka',
          pomoc: 'Boazeria widoczna od spodu, pod konstrukcją poszycia albo na niej: pod płatwiami – deski wzdłuż spadku przybite ' \
                 'do spodu płatwi; na płatwiach – deski wzdłuż spadku leżące na płatwiach (krokwie, jeśli są, leżą na nich – ' \
                 'wyżej o grubość deski); pod krokwiami – deski równolegle do okapu, przybite do spodu krokwi w polach między ' \
                 'płatwiami; na krokwiach – deski równolegle do okapu na krokwiach, pod deskowaniem. Ściany działowe i węgły pod ' \
                 'połacią kończą się pod podbitką „pod”. Na krokwiach (i na samych płatwiach) z aplikacją do dachów – robi ją ' \
                 'aplikacja jako nadbitkę (pierwszą warstwę poszycia, wymiary stąd); inaczej robi ją generator (grupa Dach). ' \
                 'Wybory zależą od układu dachu.' },
        { klucz: 'podbitka_grubosc', domyslna: 19.0, etykieta: 'Podbitka – grubość', jednostka: 'mm', min: 10.0, max: 60.0,
          rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'podbitka' => %w[pod_platwiami na_platwiach pod_krokwiami na_krokwiach] } },
        { klucz: 'podbitka_krycie', domyslna: 121.0, etykieta: 'Podbitka – szerokość deski (krycie)', jednostka: 'mm', min: 50.0,
          max: 300.0, rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'podbitka' => %w[pod_platwiami na_platwiach pod_krokwiami na_krokwiach] } },
        { klucz: 'podbitka_dlugosc', domyslna: 4000.0, etykieta: 'Podbitka – długość handlowa', jednostka: 'mm', min: 1000.0,
          max: 8000.0, rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'podbitka' => %w[pod_platwiami na_platwiach pod_krokwiami na_krokwiach] },
          podpowiedz: 'Dłuższe deski dzielone na płatwiach (pod i na płatwiach) albo równo (pod i na krokwiach).' },
        { klucz: 'poszycie_nadbitka', podstawowy: true, domyslna: 'nie', etykieta: 'Nadbitka – pierwsza warstwa poszycia (aplikacja do dachów)',
          rodzaj: :wybor, sekcja: 'poszycie', wybory: TAK_NIE,
          podpowiedz: 'Pełne deskowanie widoczne od spodu (dach bez ocieplenia) – pierwsza warstwa na krokwiach, przy samych ' \
                      'płatwiach na płatwiach. Wartości na start KROKU 2 aplikacji do dachów (Krokwie i poszycie = aplikacja).' },
        { klucz: 'nadbitka_grubosc', domyslna: 19.0, etykieta: 'Nadbitka – grubość', jednostka: 'mm', min: 10.0, max: 60.0,
          rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'poszycie_nadbitka' => ['tak'] } },
        { klucz: 'nadbitka_krycie', domyslna: 121.0, etykieta: 'Nadbitka – szerokość krycia', jednostka: 'mm', min: 50.0,
          max: 300.0, rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'poszycie_nadbitka' => ['tak'] } },
        { klucz: 'nadbitka_dlugosc', domyslna: 4000.0, etykieta: 'Nadbitka – długość handlowa', jednostka: 'mm', min: 1000.0,
          max: 8000.0, rodzaj: :liczba, sekcja: 'poszycie', gdy: { 'poszycie_nadbitka' => ['tak'] } },
        { klucz: 'poszycie_deski', podstawowy: true, domyslna: 'tak', etykieta: 'Deskowanie pełne', rodzaj: :wybor,
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
    end
  end
end
