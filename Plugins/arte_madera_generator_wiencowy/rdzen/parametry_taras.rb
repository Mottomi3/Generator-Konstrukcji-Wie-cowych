# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_taras.rb
# Zadanie: parametry sekcji „Taras” – wariant, głębokość, podciąg, słupy z zamkami (słup w osi kalenicy), szczyt nad tarasem z wiązarem (przekroje słupka i zastrzałów, zamek płatwi tylko od spodu), wejście, balustrada.
# Tematy: taras – parametry, słupy tarasu – parametry, balustrada – parametry, szczyt nad tarasem – parametry, wiązar – parametry
# Zależy od: rdzen/parametry_lista.rb (TAK_NIE)
# Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji)
#
# Wpis jak w rdzen/parametry_lista.rb (klucz, domyślna, etykieta, jednostka, zakres, rodzaj, sekcja, wybory, podpowiedź;
# gdy – pole widoczne tylko przy wybranych wartościach innych pól, pomoc – dłuższe objaśnienie pod znakiem zapytania).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module ParametryTaras
      TAK_NIE = [['tak', 'tak'], ['nie', 'nie']].freeze unless const_defined?(:TAK_NIE)

      # Parametry sekcji (kolejność = kolejność w oknie).
      LISTA = [
        { klucz: 'taras', poziom: :typ, obrys: { tylko: %w[prostokat], zostaje: %w[nie], powod: 'Taras tylko przy obrysie prostokątnym.' }, podstawowy: true, domyslna: 'nie', etykieta: 'Taras przed ścianą szczytową', rodzaj: :wybor, sekcja: 'taras',
          wybory: [['nie', 'bez tarasu'], ['podciag', 'typ 200 – podciąg na słupach, balustrada'],
                   ['sciany', 'typ 300 – ściany pełne, front otwarty']],
          podpowiedz: 'Narysuj sam dom – taras dokłada generator: obrys dłuższy o głębokość tarasu, ściana domu zostaje ' \
                      '(działowa ze szczytem), dach i płatwie idą nad taras. Typ 200: nad tarasem górne wieńce ścian na ' \
                      'słupach, szczyt frontu, balustrada z bali; typ 300: ściany boczne na całą wysokość. Tylko obrys prostokątny.' },
        { klucz: 'taras_strona', poziom: :dom, podstawowy: true, domyslna: 'max', etykieta: 'Taras – po stronie', rodzaj: :wybor, sekcja: 'taras', gdy: { 'taras' => %w[podciag sciany] },
          wybory: [['max', 'prawej albo górnej (rysunek z góry)'], ['min', 'lewej albo dolnej (rysunek z góry)']],
          podpowiedz: 'Na końcu wzdłuż kalenicy: kalenica wzdłuż X – prawa / lewa strona rysunku, wzdłuż Y – górna / dolna.' },
        { klucz: 'taras_glebokosc', poziom: :dom, podstawowy: true, domyslna: 2000.0, etykieta: 'Taras – głębokość', jednostka: 'mm', min: 500.0,
          max: 6000.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => %w[podciag sciany] }, podpowiedz: 'Od lica ściany domu do lica frontu tarasu (typ 300: 2000).' },
        { klucz: 'taras_wience_gorne', poziom: :typ, domyslna: 2, etykieta: 'Podciąg – górne wieńce ścian nad tarasem', min: 1, max: 6,
          rodzaj: :calkowita, sekcja: 'taras', gdy: { 'taras' => ['podciag'] }, podpowiedz: 'Typ 200: dwa górne bale ścian bocznych ' \
                                                          'i front od wieńca, który zamyka się z nimi w narożniku.' },
        { klucz: 'taras_ostatek', poziom: :standard, domyslna: 100.0, etykieta: 'Ostatek dolnych bali ścian bocznych przy tarasie', jednostka: 'mm',
          min: 0.0, max: 600.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'] }, podpowiedz: 'Za licem ściany domu, pod podciągiem.' },
        { klucz: 'taras_slup_przekroj', poziom: :typ, domyslna: '120x120', etykieta: 'Słup tarasu (wzdłuż ściany × w poprzek)', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'taras', gdy: { 'taras' => ['podciag'] }, podpowiedz: 'Projekty: 80 × 180, 120 × 120, 140 × 140.' },
        { klucz: 'taras_slupy_rozstaw_max', poziom: :standard, domyslna: 2000.0, etykieta: 'Słupy – największy rozstaw (osiowo)', jednostka: 'mm',
          min: 800.0, max: 5000.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'] },
          podpowiedz: 'Pod frontem i pod ścianami bocznymi nad tarasem; słupy zawsze w narożnikach frontu i przy wejściu.' },
        { klucz: 'taras_slup_w_osi', poziom: :standard, domyslna: 'tak', etykieta: 'Słup frontu w osi kalenicy', rodzaj: :wybor, sekcja: 'taras',
          wybory: TAK_NIE, gdy: { 'taras' => ['podciag'] },
          podpowiedz: 'Tak – pod kalenicą zawsze stoi słup, w jednej linii ze słupkiem trójkąta nad tarasem; pozostałe słupy ' \
                      'równo po obu stronach. Bez słupa w osi tylko wtedy, gdy oś wypada w świetle wejścia.' },
        { klucz: 'taras_slup_os_dociag', poziom: :standard, domyslna: 500.0, etykieta: 'Słup w osi – słup wejścia bliżej osi niż tyle staje w osi',
          jednostka: 'mm', min: 0.0, max: 2000.0, rodzaj: :liczba, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'], 'taras_slup_w_osi' => ['tak'], 'taras_wejscie' => %w[lewa prawa] },
          podpowiedz: 'Wejście z boku: zamiast dwóch słupów obok siebie słup wejścia przesuwa się w oś kalenicy – wejście ' \
                      'wychodzi szersze albo węższe o tę odległość. 0 – nigdy nie przesuwaj.' },
        { klucz: 'taras_slup_zamek_gora', poziom: :standard, domyslna: 150.0, etykieta: 'Słup – zamek górny (wysokość obok bala)', jednostka: 'mm',
          min: 0.0, max: 600.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'] },
          podpowiedz: 'Słup licem równo z licem ściany; nad spodem podciągu część słupa za balem idzie dalej w górę, bal leży ' \
                      'w wycięciu. 0 – słup kończy się pod balem.' },
        { klucz: 'taras_slup_zamek_dol', poziom: :standard, domyslna: 100.0, etykieta: 'Słup – zamek dolny (obok podwaliny)', jednostka: 'mm',
          min: 0.0, max: 300.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'] },
          podpowiedz: 'Część słupa obok podwaliny schodzi w dół (najwyżej na wysokość podwaliny). 0 – słup stoi na podwalinie. ' \
                      'Tylko z podłogą.' },
        { klucz: 'slup_osiadanie', poziom: :standard, domyslna: 'tak', etykieta: 'Słupy krótsze o osiadanie ścian', rodzaj: :wybor, sekcja: 'taras',
          wybory: TAK_NIE, gdy: { 'taras' => ['podciag'] },
          podpowiedz: 'Ściany z bali siadają („Osiadanie ścian” w sekcji okien i drzwi), słup nie. Słup krótszy o osiadanie bali ' \
                      'stojących obok niego (wysokość do głowicy × osiadanie) – inaczej bale podciągu zostają na słupach, gdy ' \
                      'reszta ściany opada. Nie – słup do spodu bali, jak do kompilacji 14.' },
        { klucz: 'slup_regulacja', poziom: :standard, domyslna: 'sruba', etykieta: 'Słup – regulacja w głowicy', rodzaj: :wybor, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'], 'slup_osiadanie' => ['tak'] },
          wybory: [['sruba', 'śruba regulacyjna – dokręcana, gdy ściany siadają'],
                   ['podkladki', 'podkładki – wyjmowane, gdy ściany siadają']],
          podpowiedz: 'Okucie między głowicą słupa a balem trzyma podciąg na wysokości ścian domu. Trafia do zestawienia materiałów.' },
        { klucz: 'slup_regulacja_wysokosc', poziom: :standard, domyslna: 40.0, etykieta: 'Śruba regulacyjna – wysokość po skręceniu', jednostka: 'mm',
          min: 0.0, max: 300.0, rodzaj: :liczba, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'], 'slup_osiadanie' => ['tak'], 'slup_regulacja' => ['sruba'] },
          podpowiedz: 'Słup krótszy dodatkowo o tyle – tyle zajmuje śruba po osiadaniu ścian (z płytkami).' },
        { klucz: 'taras_szczyt', poziom: :typ, domyslna: 'pelny', etykieta: 'Szczyt nad tarasem', rodzaj: :wybor, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'] },
          wybory: [['pelny', 'pełny (typ 200)'], ['azurowy', 'ażurowy – bale na przemian z przekładkami, jak balustrada'],
                   ['pusty', 'pusty – bale spinające i trójkątny wieniec pod płatwiami']],
          pomoc: 'Pełny – szczyt z bali do linii dachu. Ażurowy – co drugi wieniec szczytu to przekładki (pod płatwiami, przy ' \
                 'końcach i co najwyżej co „największy prześwit”). Pusty – nad podciągiem tylko podana liczba bali spinających ' \
                 'front, a na nich wiązar (trójkąt): krokwie wiązara z gniazdami pod płatwie, belka dolna i słupek pod kalenicą ' \
                 '(opcjonalnie zastrzały) – spina konstrukcję i szczyt. Wiązar może też stać na słupach bez bali pod nim.' },
        { klucz: 'taras_szczyt_bale', poziom: :typ, domyslna: 1, etykieta: 'Szczyt pusty – bale spinające', min: 0, max: 6, rodzaj: :calkowita,
          sekcja: 'taras', gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'] },
          podpowiedz: 'Pełne bale szczytu nad podciągiem (nad balem, który zamyka się ze ścianami bocznymi) – dolny pas trójkąta.' },
        { klucz: 'taras_wieniec', poziom: :typ, domyslna: 'platwa', etykieta: 'Szczyt pusty – wiązar (trójkąt) z przekroju', rodzaj: :wybor,
          sekcja: 'taras', gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'] },
          wybory: [['platwa', 'płatwi (jak płatwie)'], ['wlasny', 'podanego niżej'],
                   ['auto', 'dobranego automatycznie – najmniejszy wystarczający'],
                   ['brak', 'bez wiązara – słupki z przekładek pod płatwiami']],
          podpowiedz: 'Automatycznie: z listy „Dostępne przekroje płatwi” (sekcja „Szczyty i dach”) najlżejszy przekrój, który ' \
                      'przenosi obciążenie od płatwi i przy którym mieści się cały trójkąt – wąski domek dostaje mały trójkąt ' \
                      'zamiast przekroju płatwi. Przy pozostałych wyborach w wynikach jest sprawdzenie nośności.' },
        { klucz: 'taras_wieniec_przekroj', poziom: :typ, domyslna: '80x160', etykieta: 'Wiązar – przekrój (grub. × wys.)', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'taras', gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'], 'taras_wieniec' => ['wlasny'] },
          podpowiedz: 'Grubość wiązara (wzdłuż kalenicy) × wysokość krokwi wiązara (prostopadle do połaci) i belki dolnej.' },
        { klucz: 'taras_wiazar', poziom: :typ, domyslna: 'slupek', etykieta: 'Wiązar – rodzaj', rodzaj: :wybor, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'], 'taras_wieniec' => %w[platwa wlasny auto] },
          wybory: [['slupek', 'krokwie, belka dolna i słupek pod kalenicą'],
                   ['zastrzaly', 'jak obok + dwa zastrzały od stopy słupka do krokwi (45°)']],
          pomoc: 'Wiązar licuje się z licem zewnętrznym frontu i podpiera płatwie od spodu: krokwie wiązara biegną w jednym ' \
                 'kawałku pod płatwiami, każda płatew leży na nich w płytkim gnieździe (zamku) i ma wrąb z boków i od spodu ' \
                 'na grubości wiązara. Krokwie leżą na belce dolnej, słupek pod kalenicą podpiera obie krokwie; zastrzały ' \
                 'rozchodzą się od stopy słupka pod podanym kątem do spodu krokwi – wzmocnienie i ozdoba.' },
        { klucz: 'taras_wiazar_gniazdo', poziom: :standard, domyslna: 20.0, etykieta: 'Wiązar – gniazdo płatwi, najmniejsza głębokość', jednostka: 'mm',
          min: 0.0, max: 100.0, rodzaj: :liczba, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'], 'taras_wieniec' => %w[platwa wlasny auto] },
          podpowiedz: 'O tyle płatew wchodzi w krokiew wiązara przy niższej krawędzi gniazda (przy wyższej głębiej – dno gniazda ' \
                      'jest poziome). 0 – płatew tylko dotyka krokwi niższą krawędzią.' },
        { klucz: 'taras_wiazar_podparcie', poziom: :typ, domyslna: 'bale', etykieta: 'Wiązar – na czym stoi', rodzaj: :wybor, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'], 'taras_wieniec' => %w[platwa wlasny auto] },
          wybory: [['bale', 'na balach frontu (podciąg i bale spinające)'], ['slupy', 'na słupach – szczyt bez bali, z przodu sam trójkąt']],
          podpowiedz: 'Na słupach: belka dolna wiązara zamiast bali frontu – leży na słupach frontu od spodu podciągu, między ' \
                      'ścianami bocznymi.' },
        { klucz: 'taras_wiazar_przekroje', poziom: :typ, domyslna: 'wlasne', etykieta: 'Wiązar – słupek i zastrzały z przekroju', rodzaj: :wybor,
          sekcja: 'taras', gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'], 'taras_wieniec' => %w[platwa wlasny auto] },
          wybory: [['wlasne', 'własnego – szerokości podane niżej (smuklejsze, ładniejsze przy małych konstrukcjach)'],
                   ['jak_wiazar', 'dokładnie jak reszta trójkąta – przekrój płatwi albo podany dla wiązara']],
          podpowiedz: 'Jak reszta trójkąta: słupek i zastrzały mają w płaszczyźnie frontu wysokość przekroju wiązara ' \
                      '(np. płatew 80 × 200 – słupek i zastrzały 200); grubość zawsze jak wiązar.' },
        { klucz: 'taras_wiazar_slupek', poziom: :standard, domyslna: 120.0, etykieta: 'Wiązar – szerokość słupka', jednostka: 'mm', min: 40.0,
          max: 400.0, rodzaj: :liczba, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'], 'taras_wieniec' => %w[platwa wlasny auto], 'taras_wiazar_przekroje' => ['wlasne'] },
          podpowiedz: 'W płaszczyźnie frontu; grubość jak wiązar.' },
        { klucz: 'taras_wiazar_zastrzal', poziom: :standard, domyslna: 100.0, etykieta: 'Wiązar – szerokość zastrzału', jednostka: 'mm', min: 40.0,
          max: 400.0, rodzaj: :liczba, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'], 'taras_wieniec' => %w[platwa wlasny auto], 'taras_wiazar' => ['zastrzaly'],
                 'taras_wiazar_przekroje' => ['wlasne'] } },
        { klucz: 'taras_wiazar_zastrzal_kat', poziom: :standard, domyslna: 45.0, etykieta: 'Wiązar – kąt zastrzałów od poziomu', jednostka: '°', min: 0.0,
          max: 80.0, rodzaj: :liczba, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'], 'taras_wieniec' => %w[platwa wlasny auto], 'taras_wiazar' => ['zastrzaly'] },
          podpowiedz: 'Zastrzały rozchodzą się od stopy słupka w górę pod tym kątem do spodu krokwi wiązara. 0 albo kąt nie ' \
                      'większy niż kąt dachu – do połowy krokwi.' },
        { klucz: 'taras_styk', poziom: :standard, domyslna: 'styk', etykieta: 'Łączenie bali frontu i szczytu nad tarasem', rodzaj: :wybor,
          sekcja: 'taras', gdy: { 'taras' => ['podciag'] },
          wybory: [['styk', 'na styk, na przemian z mijanką – bez kontrfory'],
                   ['wegly', 'w zamkach kontrfor (węgłów) – jak w ścianach']],
          podpowiedz: 'Front dłuższy niż maksymalny bal: na styk – bale łączą się nad słupem, a w sąsiednim wieńcu ' \
                      'o mijankę („Mijanka styków”, nie mniej niż 300) dalej; kontrfora z półzamkami nie powstaje.' },
        { klucz: 'taras_platwa_zamek', poziom: :standard, domyslna: 'spod', etykieta: 'Zamek płatwi w szczycie nad tarasem', rodzaj: :wybor,
          sekcja: 'taras', gdy: { 'taras' => ['podciag'], 'platwie_zamki' => ['tak'] },
          wybory: [['spod', 'tylko od spodu – płatew leży w gnieździe pełną szerokością'],
                   ['pelny', 'z boków i od spodu – jak w ścianach']],
          podpowiedz: 'Płatwie nad trójkątem (wiązarem) albo szczytem frontu tarasu: sam wrąb od spodu wystarcza, żeby ' \
                      'trzymały front; wręby boczne jak w ścianach – do wyboru.' },
        { klucz: 'taras_wejscie', poziom: :dom, domyslna: 'srodek', etykieta: 'Wejście na taras od frontu', rodzaj: :wybor, sekcja: 'taras', gdy: { 'taras' => ['podciag'] },
          wybory: [['srodek', 'pośrodku'], ['lewa', 'z lewej (patrząc na front z zewnątrz)'],
                   ['prawa', 'z prawej (patrząc na front z zewnątrz)'], ['brak', 'bez wejścia – balustrada na całym froncie']] },
        { klucz: 'taras_wejscie_szerokosc', poziom: :dom, domyslna: 1200.0, etykieta: 'Wejście – szerokość w świetle słupów', jednostka: 'mm',
          min: 600.0, max: 4000.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'], 'taras_wejscie' => %w[srodek lewa prawa] } },
        { klucz: 'taras_balustrada_rodzaj', poziom: :typ, domyslna: 'przesla', etykieta: 'Balustrada – z czego', rodzaj: :wybor, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'] },
          wybory: [['przesla', 'dołożona – bale i przekładki między słupami'],
                   ['sciany', 'z wieńców ścian – ściany boczne ciągle przez taras, zamki w narożnikach frontu']],
          pomoc: 'Dołożona: w przęsłach między słupami bale na przemian z przekładkami, ściany boczne kończą się za ścianą domu. ' \
                 'Z wieńców ścian: dolne wieńce ścian bocznych biegną ciągle przez cały taras (bez krótkich kawałków), front w ' \
                 'tych samych wieńcach między ścianami bocznymi (przerwa na wejście), w narożnikach frontu zamki – z zakładką ' \
                 '(co druga belka wysunięta, np. o 100 mm) albo równo z licem; do wysokości balustrady.' },
        { klucz: 'taras_balustrada_wysokosc', poziom: :typ, domyslna: 1000.0, etykieta: 'Balustrada z wieńców – wysokość (najwyżej)', jednostka: 'mm',
          min: 200.0, max: 2000.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'], 'taras_balustrada_rodzaj' => ['sciany'] },
          podpowiedz: 'Wieńce, których wierzch nie przekracza tej wysokości; poręcz frontu i boków na wspólnej wysokości.' },
        { klucz: 'taras_zakladka', poziom: :standard, domyslna: 'tak', etykieta: 'Balustrada z wieńców – zakładka w narożnikach frontu', rodzaj: :wybor,
          sekcja: 'taras', wybory: TAK_NIE, gdy: { 'taras' => ['podciag'], 'taras_balustrada_rodzaj' => ['sciany'] },
          podpowiedz: 'Tak – co druga belka wysunięta za lico (zakładka pod barierkę). Nie – końce równo z licem.' },
        { klucz: 'taras_zakladka_wypust', poziom: :standard, domyslna: 100.0, etykieta: 'Zakładka – wysunięcie belki', jednostka: 'mm', min: 20.0,
          max: 400.0, rodzaj: :liczba, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'], 'taras_balustrada_rodzaj' => ['sciany'], 'taras_zakladka' => ['tak'] } },
        { klucz: 'taras_balustrada_bale', poziom: :typ, domyslna: 4, etykieta: 'Balustrada – liczba bali', min: 0, max: 8, rodzaj: :calkowita,
          sekcja: 'taras', gdy: { 'taras' => ['podciag'] }, podpowiedz: 'Bale na przemian z rzędami przekładek (typ 200: 4 bale i 3 rzędy, ok. 1 m). 0 – bez balustrady.' },
        { klucz: 'taras_przekladka', poziom: :standard, domyslna: 300.0, etykieta: 'Balustrada – długość przekładki', jednostka: 'mm', min: 50.0,
          max: 1000.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'] }, podpowiedz: 'Odcinek bala między balami balustrady (typ 200: 300).' },
        { klucz: 'taras_przekladka_odstep', poziom: :standard, domyslna: 600.0, etykieta: 'Balustrada – największy prześwit między przekładkami',
          jednostka: 'mm', min: 50.0, max: 2000.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'] },
          podpowiedz: 'Przekładki przy obu końcach przęsła i równo między nimi.' }
      ].freeze unless const_defined?(:LISTA)
    end
  end
end
