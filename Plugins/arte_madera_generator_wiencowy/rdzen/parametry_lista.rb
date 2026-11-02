# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_lista.rb
# Zadanie: lista wszystkich parametrów – wartość domyślna, etykieta, jednostka, zakres, rodzaj pola, sekcja okna, podpowiedź; presety przekroju bala.
# Tematy: lista parametrów, nowy parametr, wartości domyślne, sekcje okna, podpowiedzi pól, presety, przekrój bala, wymiary zamka, stare wartości, pola podstawowe, profil bala – parametry, działowa niższa – parametry, krokwie z aplikacji do dachów – parametr, dach jednospadowy – parametry, taras – parametry, poszycie dachu – parametry
# Zależy od: rdzen/parametry_dach.rb, rdzen/parametry_taras.rb, rdzen/parametry_podloga.rb (listy sekcji)
# Używają: rdzen/parametry.rb (sprawdzanie), sketchup/okno.rb (formularz), sketchup/ustawienia.rb
#
# Nowy parametr = jeden wpis w LISTA (okno samo doda pole w swojej sekcji, wartość trafi do zapisanych ustawień);
# odczyt w kodzie tylko przez p['klucz'] (przekroje: Parametry.przekroj(p, 'klucz') → [b, h]).
# Rodzaje pól: :liczba, :calkowita, :wybor (lista :wybory), :przekroj („50x150”), :tekst.
# podstawowy: true – pole widoczne w trybie okna „Podstawowe” (pozostałe tylko w „Wszystkie” albo gdy zmienione).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

%w[parametry_dach parametry_taras parametry_podloga].each do |plik|
  require File.join(File.dirname(__FILE__), plik)
end

module ArteMadera
  module GeneratorWiencowy
    module ParametryLista
      # Sekcje okna w kolejności wyświetlania: [klucz, tytuł, otwarta na starcie].
      SEKCJE = [
        ['przekroj', 'Przekrój bala i zamek', true],
        ['sciany', 'Ściany', true],
        ['laczenia', 'Długości bali i łączenia', true],
        ['wegly', 'Węgły 244 – wzmocnienia ścian', true],
        ['szczyty', 'Szczyty i dach', false],
        ['poszycie', 'Poszycie dachu (aplikacja do dachów)', false],
        ['taras', 'Taras', false],
        ['podloga', 'Podłoga i fundamenty', false],
        ['otwory', 'Okna i drzwi – stolarka i luzy', false],
        ['rysunek', 'Rozpoznanie rysunku i waga', false]
      ].freeze unless const_defined?(:SEKCJE)

      TAK_NIE = [['tak', 'tak'], ['nie', 'nie']].freeze unless const_defined?(:TAK_NIE)

      # Parametry sekcji przekroju, ścian, łączeń i węgłów (kolejność = kolejność w oknie w ramach sekcji).
      LISTA_SCIANY = [
        { klucz: 'preset', podstawowy: true, domyslna: '44x146', etykieta: 'Przekrój bala', rodzaj: :wybor, sekcja: 'przekroj',
          wybory: nil, podpowiedz: 'Preset z kompletem wymiarów zamka; wymiary można zmienić poniżej.' },
        { klucz: 'zamek_odbicie', domyslna: 'rysunek', etykieta: 'Kierunek podcięć zamka', rodzaj: :wybor, sekcja: 'przekroj',
          wybory: [['rysunek', 'jak na rysunku warsztatowym'], ['lustro', 'lustrzane odbicie']],
          podpowiedz: 'Labirynt podcięć – oba warianty bez kolizji; zmiana odwraca bale poprzeczne licem.' },
        { klucz: 'profil_bala', podstawowy: true, domyslna: 'prosty', etykieta: 'Profil bala w modelu', rodzaj: :wybor,
          sekcja: 'przekroj', wybory: [['prosty', 'bal prosty (lekki model, jak w listach)'],
                                       ['pelny', 'pełny profil – pióro i wpust (do wizualizacji)']],
          podpowiedz: 'Pełny profil: pióra na wierzchu, wpust od spodu (pierwszy wieniec bez wpustu). Zamki, pozycje i listy bez zmian.' },
        { klucz: 'pioro_liczba', domyslna: '2', etykieta: 'Pióra – liczba', rodzaj: :wybor, sekcja: 'przekroj', gdy: { 'profil_bala' => ['pelny'] },
          wybory: [['1', 'jedno pióro w osi bala'], ['2', 'dwa pióra (podwójne pióro-wpust)']],
          podpowiedz: 'Wysokość pióra – „Pióro” w wymiarach zamka poniżej.' },
        { klucz: 'pioro_szerokosc', domyslna: 8.0, etykieta: 'Pióro – szerokość', jednostka: 'mm', min: 2.0, max: 30.0,
          rodzaj: :liczba, sekcja: 'przekroj', gdy: { 'profil_bala' => ['pelny'] } },
        { klucz: 'pioro_rozstaw', domyslna: 20.0, etykieta: 'Pióra – rozstaw osi (dwa pióra)', jednostka: 'mm', min: 4.0,
          max: 36.0, rodzaj: :liczba, sekcja: 'przekroj', gdy: { 'profil_bala' => ['pelny'] } },
        { klucz: 'wpust_luz', domyslna: 1.0, etykieta: 'Wpust – luz (szerszy i głębszy od pióra)', jednostka: 'mm', min: 0.0,
          max: 5.0, rodzaj: :liczba, sekcja: 'przekroj', gdy: { 'profil_bala' => ['pelny'] } },

        { klucz: 'liczba_wiencow', podstawowy: true, domyslna: 16, etykieta: 'Liczba wieńców (ściany okapowe)', jednostka: 'szt.',
          min: 3, max: 60, rodzaj: :calkowita, sekcja: 'sciany',
          podpowiedz: 'Pełne wieńce ścian wzdłuż kalenicy; szczytowe mają o jeden więcej (pierwszy bal szczytu).' },
        { klucz: 'ostatek', podstawowy: true, domyslna: 100.0, etykieta: 'Ostatek za licem', jednostka: 'mm', min: 40.0, max: 600.0,
          rodzaj: :liczba, sekcja: 'sciany', podpowiedz: 'Wypust bala za licem ściany poprzecznej (projekty: 100, przy tarasie 200).' },
        { klucz: 'kalenica', podstawowy: true, domyslna: 'dluzszy', etykieta: 'Kalenica (półbal na ścianach wzdłuż kalenicy)', rodzaj: :wybor,
          sekcja: 'sciany', wybory: [['dluzszy', 'wzdłuż dłuższego boku'], ['krotszy', 'wzdłuż krótszego boku'],
                                     ['x', 'wzdłuż osi X obrysu'], ['y', 'wzdłuż osi Y obrysu']],
          podpowiedz: 'Dach jednospadowy – kierunek okapów: ściana niska i wysoka biegną wzdłuż „kalenicy”.' },
        { klucz: 'strop', podstawowy: true, domyslna: 'nie', etykieta: 'Strop nad parterem (zamknięta góra)', rodzaj: :wybor,
          sekcja: 'sciany', wybory: [['nie', 'nie – działowe do pełnej wysokości'], ['tak', 'tak – działowe kończą się pod stropem']],
          podpowiedz: 'Niższa działowa tylko pod stropem, antresolą lub półką. Antresolę albo półkę nad jedną działową ustawisz w widoku ściany.' },
        { klucz: 'dzialowa_nizsza_wysokosc', podstawowy: true, domyslna: 2500.0, etykieta: 'Działowa pod stropem / antresolą – góra',
          jednostka: 'mm', min: 500.0, max: 8000.0, rodzaj: :liczba, sekcja: 'sciany',
          podpowiedz: 'Spód stropu, antresoli albo półki; działowa kończy się pełnym wieńcem nie wyżej (1100: 2432, 1200: 2780).' },
        { klucz: 'dopelnienie_wewn', domyslna: 100.0, etykieta: 'Dopełnienie zamka nad niższą działową – do wnętrza',
          jednostka: 'mm', min: 40.0, max: 600.0, rodzaj: :liczba, sekcja: 'sciany',
          podpowiedz: 'Odcinki nad działową przy ścianach, które idą wyżej: ostatek + grubość + tyle (1100: 244, 1200 przy ostatku 200: 344).' },

        { klucz: 'max_dlugosc', podstawowy: true, domyslna: 5100.0, etykieta: 'Maksymalna długość bala', jednostka: 'mm', min: 1000.0,
          max: 13_000.0, rodzaj: :liczba, sekcja: 'laczenia',
          podpowiedz: 'Najdłuższy bal od producenta (listy 1800 i 1200: 5044 i 5090).' },
        { klucz: 'min_odcinek', domyslna: 200.0, etykieta: 'Najkrótszy kawałek bala', jednostka: 'mm', min: 50.0,
          max: 2000.0, rodzaj: :liczba, sekcja: 'laczenia', podpowiedz: 'Krótszy kawałek – ostrzeżenie.' },
        { klucz: 'styk_na_dzialowej', podstawowy: true, domyslna: 'wspolny', etykieta: 'Łączenie przy działowej',
          rodzaj: :wybor, sekcja: 'laczenia',
          wybory: [['wspolny', 'wszystkie wieńce w zamku działowej – bez węgłów i drugiego rzędu'],
                   ['mijanka', 'jak przy węgłach – na przemian, z mijanką']],
          podpowiedz: 'Działowa przechodzi przez ścianę w zamku – styk w jej osi trzymają bale działowej nad i pod nim, więc ' \
                      'wszystkie wieńce łączą się w tym jednym miejscu. Działowa musi sięgać prawie do góry ściany.' },
        { klucz: 'styk_uklad', podstawowy: true, domyslna: 'na_przemian', etykieta: 'Łączenie bali na długości', rodzaj: :wybor,
          sekcja: 'laczenia',
          wybory: [['na_przemian', 'na przemian w kolejnych węgłach / działowych (jak 1200)'],
                   ['para', 'para węgłów w odstępie mijanki, styk w osi zamka (jak 900 W-2)'],
                   ['jeden_wegiel', 'jeden węgieł, styki ± połowa mijanki']] },
        { klucz: 'mijanka', domyslna: 400.0, etykieta: 'Mijanka styków w sąsiednich wieńcach', jednostka: 'mm',
          min: 300.0, max: 3000.0, rodzaj: :liczba, sekcja: 'laczenia',
          podpowiedz: 'Najmniejszy odstęp styków w sąsiednich wieńcach – nie mniej niż 300.' },
        { klucz: 'szczelina_styku', domyslna: 0.0, etykieta: 'Szczelina na styku', jednostka: 'mm', min: 0.0, max: 30.0,
          rodzaj: :liczba, sekcja: 'laczenia' },
        { klucz: 'styk_odstep_od_otworu', domyslna: 400.0, etykieta: 'Styk od krawędzi otworu – najmniej', jednostka: 'mm',
          min: 0.0, max: 2000.0, rodzaj: :liczba, sekcja: 'laczenia',
          podpowiedz: 'Kawałek bala między stykiem a otworem nie krótszy niż tyle.' },

        { klucz: 'wegly_max_swiatlo', podstawowy: true, domyslna: 4800.0, etykieta: 'Najdłuższe światło ściany bez węgła', jednostka: 'mm',
          min: 1500.0, max: 10_000.0, rodzaj: :liczba, sekcja: 'wegly',
          podpowiedz: 'Między licami ścian podpierających (narożnik, działowa, węgieł). 1800 W-2: 4756 bez węgła.' },
        { klucz: 'wegly_max_swiatlo_wysokie', domyslna: 3700.0, etykieta: 'To samo dla ścian wysokich', jednostka: 'mm',
          min: 1500.0, max: 10_000.0, rodzaj: :liczba, sekcja: 'wegly',
          podpowiedz: 'Dom 1,5 kondygnacji (1200): węgieł już na ścianie 4 m.' },
        { klucz: 'wegly_prog_wysokosci', domyslna: 3000.0, etykieta: 'Ściana wysoka od wysokości', jednostka: 'mm',
          min: 1500.0, max: 8000.0, rodzaj: :liczba, sekcja: 'wegly',
          podpowiedz: 'Wysokość ściany okapowej bez szczytu (1100: 2966 – bez węgła, 1200: 3580 – z węgłem).' },
        { klucz: 'wegly_rozmieszczenie', podstawowy: true, domyslna: 'rowno', etykieta: 'Rozmieszczenie nowych węgłów', rodzaj: :wybor,
          sekcja: 'wegly',
          wybory: [['rowno', 'równo na długości ściany'], ['od_naroznikow', 'od narożników o zadany odstęp (jak 1000)'],
                   ['tylko_narysowane', 'tylko narysowane (generator tylko ostrzega)']] },
        { klucz: 'wegly_odstep_od_naroznika', domyslna: 800.0, etykieta: 'Odstęp węgła od narożnika', jednostka: 'mm',
          min: 300.0, max: 3000.0, rodzaj: :liczba, sekcja: 'wegly', gdy: { 'wegly_rozmieszczenie' => ['od_naroznikow'] }, podpowiedz: 'Dla rozmieszczenia „od narożników”.' },
        { klucz: 'wegly_srodek', podstawowy: true, domyslna: 'nie', etykieta: 'Węgieł na środku ściany – automatycznie',
          rodzaj: :wybor, sekcja: 'wegly',
          wybory: [['nie', 'nie'], ['zewnetrzne', 'na ścianach zewnętrznych'], ['wszystkie', 'na wszystkich ścianach']],
          podpowiedz: 'Węgieł w osi ściany, gdy ściana nie jest krótsza niż podana niżej (w miejscu skrzyżowania albo otworu – ' \
                      'obok, do pół metra). Pojedyncze węgły dodasz w tabeli „Węgły”, jak okna.' },
        { klucz: 'wegly_srodek_min', domyslna: 4000.0, etykieta: 'Węgieł na środku – od długości ściany', jednostka: 'mm',
          min: 1000.0, max: 20_000.0, rodzaj: :liczba, sekcja: 'wegly', gdy: { 'wegly_srodek' => %w[zewnetrzne wszystkie] } },
        { klucz: 'wegly_na_dzialowych', domyslna: 'tak', etykieta: 'Węgły także na ścianach działowych', rodzaj: :wybor,
          sekcja: 'wegly', wybory: TAK_NIE },
        { klucz: 'min_odstep_skrzyzowan', domyslna: 300.0, etykieta: 'Odstęp węgła od innego skrzyżowania', jednostka: 'mm',
          min: 150.0, max: 3000.0, rodzaj: :liczba, sekcja: 'wegly' },
        { klucz: 'odstep_od_otworu', domyslna: 150.0, etykieta: 'Odstęp węgła od krawędzi otworu', jednostka: 'mm',
          min: 0.0, max: 2000.0, rodzaj: :liczba, sekcja: 'wegly' }
      ].freeze unless const_defined?(:LISTA_SCIANY)

      # Parametry sekcji okien i drzwi oraz rozpoznania rysunku.
      LISTA_OTWORY = [
        { klucz: 'min_kawalek_przy_otworze', domyslna: 70.0, etykieta: 'Kawałek bala przy otworze – najkrótszy',
          jednostka: 'mm', min: 0.0, max: 1000.0, rodzaj: :liczba, sekcja: 'otwory' },
        { klucz: 'luz_boczny', podstawowy: true, domyslna: 10.0, etykieta: 'Luz boczny stolarki (z każdej strony)', jednostka: 'mm',
          min: 0.0, max: 100.0, rodzaj: :liczba, sekcja: 'otwory',
          podpowiedz: 'Otwór w balach = szerokość stolarki + 2 × luz boczny (typowo 5–10 mm, zakryty listwą).' },
        { klucz: 'osiadanie_scian', podstawowy: true, domyslna: 1.5, etykieta: 'Osiadanie ścian – podpowiedź luzu górnego',
          jednostka: '%', min: 0.0, max: 10.0, rodzaj: :liczba, sekcja: 'otwory',
          podpowiedz: 'Luz nad stolarką, gdy w tabeli puste pole „Luz górny”: wysokość stolarki × osiadanie, w górę do 5 mm. ' \
                      'Bal suszony 44 mm ok. 1–2 % (montaż latem mniej, zimą więcej), drewno świeże 4–6 %.' },
        { klucz: 'luz_gorny_min', domyslna: 10.0, etykieta: 'Luz górny – najmniejszy w podpowiedzi', jednostka: 'mm', min: 0.0,
          max: 200.0, rodzaj: :liczba, sekcja: 'otwory' },
        { klucz: 'min_pasek_przy_otworze', domyslna: 20.0, etykieta: 'Najcieńszy pasek bala nad / pod otworem', jednostka: 'mm',
          min: 1.0, max: 100.0, rodzaj: :liczba, sekcja: 'otwory',
          podpowiedz: 'Cieńszy pasek – bal przecięty w całości (otwór sięga do krawędzi bala), z ostrzeżeniem.' },
        { klucz: 'okno_szerokosc', podstawowy: true, domyslna: 1020.0, etykieta: 'Nowe okno – szerokość stolarki', jednostka: 'mm',
          min: 100.0, max: 6000.0, rodzaj: :liczba, sekcja: 'otwory',
          podpowiedz: 'Wymiary stolarki wstawiane przyciskiem „+ okno” (900: 1020 × 1010).' },
        { klucz: 'okno_wysokosc', podstawowy: true, domyslna: 1010.0, etykieta: 'Nowe okno – wysokość stolarki', jednostka: 'mm',
          min: 100.0, max: 4000.0, rodzaj: :liczba, sekcja: 'otwory' },
        { klucz: 'okno_parapet', podstawowy: true, domyslna: 900.0, etykieta: 'Nowe okno – spód okna (od podwaliny)', jednostka: 'mm',
          min: 0.0, max: 4000.0, rodzaj: :liczba, sekcja: 'otwory' },
        { klucz: 'drzwi_szerokosc', podstawowy: true, domyslna: 930.0, etykieta: 'Nowe drzwi – szerokość stolarki', jednostka: 'mm',
          min: 300.0, max: 6000.0, rodzaj: :liczba, sekcja: 'otwory' },
        { klucz: 'drzwi_wysokosc', podstawowy: true, domyslna: 2100.0, etykieta: 'Nowe drzwi – wysokość stolarki', jednostka: 'mm',
          min: 1000.0, max: 4000.0, rodzaj: :liczba, sekcja: 'otwory' },
        { klucz: 'nowy_otwor_od', domyslna: 1000.0, etykieta: 'Nowy otwór – odległość od narożnika', jednostka: 'mm',
          min: 0.0, max: 30_000.0, rodzaj: :liczba, sekcja: 'otwory' },

        { klucz: 'kontrfor_max_linia', domyslna: 600.0, etykieta: 'Linia węgła – najdłuższa', jednostka: 'mm', min: 100.0,
          max: 3000.0, rodzaj: :liczba, sekcja: 'rysunek', podpowiedz: 'Krótsza linia przecinająca jedną ścianę = węgieł.' },
        { klucz: 'tolerancja_rysunku', domyslna: 5.0, etykieta: 'Tolerancja rysunku obrysu', jednostka: 'mm', min: 0.5,
          max: 50.0, rodzaj: :liczba, sekcja: 'rysunek' },
        { klucz: 'gestosc', domyslna: 450.0, etykieta: 'Gęstość drewna (waga)', jednostka: 'kg/m³', min: 300.0, max: 900.0,
          rodzaj: :liczba, sekcja: 'rysunek' }
      ].freeze unless const_defined?(:LISTA_OTWORY)

      # Wszystkie parametry w kolejności okna: listy sekcji z tego pliku i z plików parametrów dachu, tarasu i podłogi.
      LISTA = (LISTA_SCIANY + ParametryDach::LISTA + ParametryTaras::LISTA + ParametryPodloga::LISTA + LISTA_OTWORY).freeze unless
        const_defined?(:LISTA)

      # Szablony wbudowane (okno – lista szablonów): nazwa => wartości różne od domyślnych.
      SZABLONY = {
        'Domek parterowy 44 (jak 900)' => { 'liczba_wiencow' => 16 },
        'Dom parterowy wysoki (jak 1800)' => { 'liczba_wiencow' => 20 },
        'Dom 1,5 kondygnacji (jak 1200)' => { 'liczba_wiencow' => 25 },
        'Dom 1,5 kondygnacji ze stropem nad parterem' => { 'liczba_wiencow' => 25, 'strop' => 'tak', 'dzialowa_nizsza_wysokosc' => 2780.0 },
        'Pełny profil bala – pióro i wpust (wizualizacja)' => { 'profil_bala' => 'pelny' },
        'Bez łączenia bali (bale do 7 m)' => { 'max_dlugosc' => 7000.0 },
        'Podłoga ocieplona 150 mm' => { 'izolacja_podlogi' => 150.0 }
      }.freeze unless const_defined?(:SZABLONY)

      # Wartości z wcześniejszych kompilacji zapisane w modelach: klucz => { stara => nowa }.
      STARE_WARTOSCI = {
        'styk_uklad' => { 'dwa_skrzyzowania' => 'para', 'jeden_kontrfor' => 'jeden_wegiel' }
      }.freeze unless const_defined?(:STARE_WARTOSCI)

      # Presety przekroju: wymiary bala i zamka [mm]. Klucze zamka czyta rdzen/zamek.rb.
      PRESETY = {
        '44x146' => {
          'nazwa' => 'Bal 44 × 146 (krycie 139, pióro 7)',
          'grubosc' => 44.0,        # grubość ściany
          'wysokosc' => 146.0,      # wysokość bala z piórem (do list zamówień)
          'krycie' => 139.0,        # rozstaw wieńców = wysokość bryły bala prostego
          'pioro' => 7.0,           # wysokość pióra (pełny profil – rdzen/profil_bala.rb)
          'gniazdo_szer' => 40.0,   # szerokość gniazda górnego i dolnego w zamku
          'gniazdo_gleb' => 36.0,   # głębokość gniazda od wierzchu i od spodu bryły
          'podciecie_gleb' => 2.5,  # głębokość podcięcia bocznego (każde lico)
          'polbal_lista' => 70.0    # wysokość półbala w listach producenta
        }
      }.freeze unless const_defined?(:PRESETY)

      # Opisy wymiarów zamka w oknie: klucz presetu => [etykieta, jednostka].
      OPISY_ZAMKA = [
        ['grubosc', 'Grubość bala', 'mm'], ['krycie', 'Krycie (rozstaw wieńców)', 'mm'],
        ['wysokosc', 'Wysokość z piórem (listy)', 'mm'], ['pioro', 'Pióro', 'mm'],
        ['gniazdo_szer', 'Gniazdo – szerokość', 'mm'], ['gniazdo_gleb', 'Gniazdo – głębokość', 'mm'],
        ['podciecie_gleb', 'Podcięcie boczne – głębokość', 'mm'], ['polbal_lista', 'Półbal – wysokość w listach', 'mm']
      ].freeze unless const_defined?(:OPISY_ZAMKA)

      module_function

      # Wpis parametru po kluczu (nil – nie ma takiego).
      def wpis(klucz)
        LISTA.find { |w| w[:klucz] == klucz }
      end

      # Wartości domyślne wszystkich parametrów: { klucz => wartość }.
      def domyslne
        wynik = {}
        LISTA.each { |w| wynik[w[:klucz]] = w[:domyslna] }
        wynik
      end

      # Lista wyborów pola (preset – z PRESETY).
      def wybory(w)
        return PRESETY.map { |k, v| [k, v['nazwa']] } if w[:klucz] == 'preset'
        w[:wybory] || []
      end
    end
  end
end
