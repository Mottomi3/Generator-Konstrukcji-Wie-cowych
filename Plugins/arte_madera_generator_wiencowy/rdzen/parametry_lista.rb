# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_lista.rb
# Zadanie: lista wszystkich parametrów – wartość domyślna, etykieta, jednostka, zakres, rodzaj pola, sekcja okna, podpowiedź; presety przekroju bala.
# Tematy: lista parametrów, nowy parametr, wartości domyślne, sekcje okna, podpowiedzi pól, presety, przekrój bala, wymiary zamka, stare wartości
# Zależy od: –
# Używają: rdzen/parametry.rb (sprawdzanie), sketchup/okno.rb (formularz), sketchup/ustawienia.rb
#
# Nowy parametr = jeden wpis w LISTA (okno samo doda pole w swojej sekcji, wartość trafi do zapisanych ustawień);
# odczyt w kodzie tylko przez p['klucz'] (przekroje: Parametry.przekroj(p, 'klucz') → [b, h]).
# Rodzaje pól: :liczba, :calkowita, :wybor (lista :wybory), :przekroj („50x150”), :tekst.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

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
        ['podloga', 'Podłoga', false],
        ['otwory', 'Otwory – ustawienia', false],
        ['rysunek', 'Rozpoznanie rysunku i waga', false]
      ].freeze unless const_defined?(:SEKCJE)

      TAK_NIE = [['tak', 'tak'], ['nie', 'nie']].freeze unless const_defined?(:TAK_NIE)

      # Wszystkie parametry (kolejność = kolejność w oknie w ramach sekcji).
      LISTA = [
        { klucz: 'preset', domyslna: '44x146', etykieta: 'Przekrój bala', rodzaj: :wybor, sekcja: 'przekroj',
          wybory: nil, podpowiedz: 'Preset z kompletem wymiarów zamka; wymiary można zmienić poniżej.' },
        { klucz: 'zamek_odbicie', domyslna: 'rysunek', etykieta: 'Kierunek podcięć zamka', rodzaj: :wybor, sekcja: 'przekroj',
          wybory: [['rysunek', 'jak na rysunku warsztatowym'], ['lustro', 'lustrzane odbicie']],
          podpowiedz: 'Labirynt podcięć – oba warianty bez kolizji; zmiana odwraca bale poprzeczne licem.' },

        { klucz: 'liczba_wiencow', domyslna: 16, etykieta: 'Liczba wieńców (ściany okapowe)', jednostka: 'szt.',
          min: 3, max: 60, rodzaj: :calkowita, sekcja: 'sciany',
          podpowiedz: 'Pełne wieńce ścian wzdłuż kalenicy; szczytowe mają o jeden więcej (pierwszy bal szczytu).' },
        { klucz: 'ostatek', domyslna: 100.0, etykieta: 'Ostatek za licem', jednostka: 'mm', min: 40.0, max: 600.0,
          rodzaj: :liczba, sekcja: 'sciany', podpowiedz: 'Wypust bala za licem ściany poprzecznej (projekty: 100, przy tarasie 200).' },
        { klucz: 'kalenica', domyslna: 'dluzszy', etykieta: 'Kalenica (półbal na ścianach wzdłuż kalenicy)', rodzaj: :wybor,
          sekcja: 'sciany', wybory: [['dluzszy', 'wzdłuż dłuższego boku'], ['krotszy', 'wzdłuż krótszego boku'],
                                     ['x', 'wzdłuż osi X obrysu'], ['y', 'wzdłuż osi Y obrysu']] },

        { klucz: 'max_dlugosc', domyslna: 5100.0, etykieta: 'Maksymalna długość bala', jednostka: 'mm', min: 1000.0,
          max: 13_000.0, rodzaj: :liczba, sekcja: 'laczenia',
          podpowiedz: 'Najdłuższy bal od producenta (listy 1800 i 1200: 5044 i 5090).' },
        { klucz: 'min_odcinek', domyslna: 200.0, etykieta: 'Najkrótszy kawałek bala', jednostka: 'mm', min: 50.0,
          max: 2000.0, rodzaj: :liczba, sekcja: 'laczenia', podpowiedz: 'Krótszy kawałek – ostrzeżenie.' },
        { klucz: 'styk_uklad', domyslna: 'na_przemian', etykieta: 'Łączenie bali na długości', rodzaj: :wybor,
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

        { klucz: 'wegly_max_swiatlo', domyslna: 4800.0, etykieta: 'Najdłuższe światło ściany bez węgła', jednostka: 'mm',
          min: 1500.0, max: 10_000.0, rodzaj: :liczba, sekcja: 'wegly',
          podpowiedz: 'Między licami ścian podpierających (narożnik, działowa, węgieł). 1800 W-2: 4756 bez węgła.' },
        { klucz: 'wegly_max_swiatlo_wysokie', domyslna: 3700.0, etykieta: 'To samo dla ścian wysokich', jednostka: 'mm',
          min: 1500.0, max: 10_000.0, rodzaj: :liczba, sekcja: 'wegly',
          podpowiedz: 'Dom 1,5 kondygnacji (1200): węgieł już na ścianie 4 m.' },
        { klucz: 'wegly_prog_wysokosci', domyslna: 3000.0, etykieta: 'Ściana wysoka od wysokości', jednostka: 'mm',
          min: 1500.0, max: 8000.0, rodzaj: :liczba, sekcja: 'wegly',
          podpowiedz: 'Wysokość ściany okapowej bez szczytu (1100: 2966 – bez węgła, 1200: 3580 – z węgłem).' },
        { klucz: 'wegly_rozmieszczenie', domyslna: 'rowno', etykieta: 'Rozmieszczenie nowych węgłów', rodzaj: :wybor,
          sekcja: 'wegly',
          wybory: [['rowno', 'równo na długości ściany'], ['od_naroznikow', 'od narożników o zadany odstęp (jak 1000)'],
                   ['tylko_narysowane', 'tylko narysowane (generator tylko ostrzega)']] },
        { klucz: 'wegly_odstep_od_naroznika', domyslna: 800.0, etykieta: 'Odstęp węgła od narożnika', jednostka: 'mm',
          min: 300.0, max: 3000.0, rodzaj: :liczba, sekcja: 'wegly', podpowiedz: 'Dla rozmieszczenia „od narożników”.' },
        { klucz: 'wegly_na_dzialowych', domyslna: 'tak', etykieta: 'Węgły także na ścianach działowych', rodzaj: :wybor,
          sekcja: 'wegly', wybory: TAK_NIE },
        { klucz: 'min_odstep_skrzyzowan', domyslna: 300.0, etykieta: 'Odstęp węgła od innego skrzyżowania', jednostka: 'mm',
          min: 150.0, max: 3000.0, rodzaj: :liczba, sekcja: 'wegly' },
        { klucz: 'odstep_od_otworu', domyslna: 150.0, etykieta: 'Odstęp węgła od krawędzi otworu', jednostka: 'mm',
          min: 0.0, max: 2000.0, rodzaj: :liczba, sekcja: 'wegly' },

        { klucz: 'szczyty', domyslna: 'tak', etykieta: 'Szczyty z bali', rodzaj: :wybor, sekcja: 'szczyty', wybory: TAK_NIE,
          podpowiedz: 'Ściany szczytowe zewnętrzne dostają szczyt z bali ściętych pod kątem dachu.' },
        { klucz: 'szczyty_na_dzialowych', domyslna: 'nie', etykieta: 'Szczyty także na działowych szczytowych',
          rodzaj: :wybor, sekcja: 'szczyty', wybory: TAK_NIE, podpowiedz: 'Jak 1800 W-2 – ściana działowa do kalenicy.' },
        { klucz: 'dach_kat', domyslna: 20.0, etykieta: 'Kąt dachu', jednostka: '°', min: 5.0, max: 60.0, rodzaj: :liczba,
          sekcja: 'szczyty', podpowiedz: 'Projekty 900 i 1000: 20°.' },
        { klucz: 'dach_uklad', domyslna: 'platwie', etykieta: 'Układ dachu', rodzaj: :wybor, sekcja: 'szczyty',
          wybory: [['platwie', 'same płatwie (deski na płatwiach)'], ['krokwie', 'krokwie na płatwi ściennej i kalenicowej'],
                   ['platwie_krokwie', 'płatwie i krokwie']] },
        { klucz: 'dach_podniesienie', domyslna: 69.5, etykieta: 'Wierzch płatwi nad ścianą okapową (przy licu wewn.)',
          jednostka: 'mm', min: -300.0, max: 1500.0, rodzaj: :liczba, sekcja: 'szczyty',
          podpowiedz: 'Projekt 900: 69,5 = wierzch najwyższego bala ściany szczytowej. Nie dotyczy płatwi stojącej na ścianie.' },
        { klucz: 'krokwie_przy_szczycie', domyslna: 'obie_strony', etykieta: 'Krokwie przy ścianie szczytowej',
          rodzaj: :wybor, sekcja: 'szczyty',
          wybory: [['obie_strony', 'z obu stron szczytu'], ['wewnatrz', 'tylko od wewnątrz'], ['zewnatrz', 'tylko od zewnątrz'],
                   ['na_szczycie', 'na szczycie (krokiew oparta na balach)']],
          podpowiedz: 'Krokwie obok szczytu – szczyt dochodzi do wierzchu krokwi; krokiew na szczycie – szczyt kończy się pod nią.' },
        { klucz: 'krokiew_przekroj', domyslna: '50x150', etykieta: 'Krokiew (szer. × wys.)', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'szczyty' },
        { klucz: 'krokwie_rozstaw', domyslna: 900.0, etykieta: 'Rozstaw krokwi – największy', jednostka: 'mm', min: 300.0,
          max: 2000.0, rodzaj: :liczba, sekcja: 'szczyty' },
        { klucz: 'platwa_przekroj', domyslna: '80x180', etykieta: 'Płatew pośrednia', jednostka: 'mm', rodzaj: :przekroj,
          sekcja: 'szczyty', podpowiedz: 'Projekt 900: 80 × 180.' },
        { klucz: 'platwa_kalenicowa_przekroj', domyslna: '80x180', etykieta: 'Płatew kalenicowa', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'szczyty' },
        { klucz: 'platwie_rozstaw_max', domyslna: 1000.0, etykieta: 'Największy rozstaw płatwi (w poziomie)',
          jednostka: 'mm', min: 300.0, max: 4000.0, rodzaj: :liczba, sekcja: 'szczyty', podpowiedz: '900: ok. 990.' },
        { klucz: 'platwa_na_scianie', domyslna: 'tak', etykieta: 'Płatew ścienna (przy ścianie okapowej)', rodzaj: :wybor,
          sekcja: 'szczyty', wybory: TAK_NIE },
        { klucz: 'platwa_scienna_polozenie', domyslna: 'przy_licu', etykieta: 'Płatew ścienna – położenie', rodzaj: :wybor,
          sekcja: 'szczyty', wybory: [['przy_licu', 'przy licu wewnętrznym, wierzchem na linii dachu (jak 900)'],
                                      ['na_scianie', 'stoi na ścianie okapowej, w osi']] },
        { klucz: 'platwa_scienna_przekroj', domyslna: '60x200', etykieta: 'Płatew na ścianie', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'szczyty', podpowiedz: 'Projekt 900: 60 × 200.' },
        { klucz: 'gniazdo_luz', domyslna: 5.0, etykieta: 'Luz w gnieździe płatwi (każda strona)', jednostka: 'mm',
          min: 0.0, max: 30.0, rodzaj: :liczba, sekcja: 'szczyty' },
        { klucz: 'szczyt_min_wysokosc', domyslna: 30.0, etykieta: 'Najniższy kawałek bala przy skosie', jednostka: 'mm',
          min: 5.0, max: 140.0, rodzaj: :liczba, sekcja: 'szczyty', podpowiedz: 'Niższy klin bala przy skosie dachu jest pomijany.' },
        { klucz: 'dach_elementy', domyslna: 'tak', etykieta: 'Belki dachu w modelu (płatwie, krokwie)', rodzaj: :wybor,
          sekcja: 'szczyty', wybory: TAK_NIE, podpowiedz: 'Dla obrysu prostokątnego.' },
        { klucz: 'dach_okap', domyslna: 500.0, etykieta: 'Okap – wysunięcie krokwi za ścianę', jednostka: 'mm', min: 0.0,
          max: 1500.0, rodzaj: :liczba, sekcja: 'szczyty', podpowiedz: 'W poziomie, od lica ściany okapowej.' },
        { klucz: 'dach_okap_szczyt', domyslna: 500.0, etykieta: 'Wysunięcie płatwi za szczyt', jednostka: 'mm', min: 0.0,
          max: 1500.0, rodzaj: :liczba, sekcja: 'szczyty', podpowiedz: 'Od lica szczytu (900: płatwie 6082).' },

        { klucz: 'podloga', domyslna: 'tak', etykieta: 'Podłoga (podwaliny, legary, podpory)', rodzaj: :wybor,
          sekcja: 'podloga', wybory: TAK_NIE },
        { klucz: 'podwalina_przekroj', domyslna: '100x100', etykieta: 'Podwalina pod ścianami', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'podloga', podpowiedz: 'Projekt 900: 100 × 100. Niższa niż legar – podniesiona do wysokości legara.' },
        { klucz: 'podwaliny_pod_dzialowymi', domyslna: 'tak', etykieta: 'Podwaliny także pod działowymi', rodzaj: :wybor,
          sekcja: 'podloga', wybory: TAK_NIE },
        { klucz: 'legary_kierunek', domyslna: 'krotszy', etykieta: 'Legary wzdłuż', rodzaj: :wybor, sekcja: 'podloga',
          wybory: [['krotszy', 'krótszego boku'], ['dluzszy', 'dłuższego boku'], ['x', 'osi X obrysu'], ['y', 'osi Y obrysu']] },
        { klucz: 'legary_rozstaw', domyslna: 600.0, etykieta: 'Rozstaw legarów (osiowo)', jednostka: 'mm', min: 250.0,
          max: 1200.0, rodzaj: :liczba, sekcja: 'podloga', podpowiedz: 'Projekt 900: 550–610.' },
        { klucz: 'izolacja_podlogi', domyslna: 100.0, etykieta: 'Izolacja między legarami', jednostka: 'mm', min: 0.0,
          max: 400.0, rodzaj: :liczba, sekcja: 'podloga', podpowiedz: 'Legar nie niższy niż izolacja (0 – bez izolacji).' },
        { klucz: 'legary_dobor', domyslna: 'zalecany', etykieta: 'Dobór przekroju legara', rodzaj: :wybor, sekcja: 'podloga',
          wybory: [['zalecany', 'zalecany (ugięcie ≤ L/zalecane)'], ['minimalny', 'minimalny (ugięcie ≤ L/minimalne)'],
                   ['reczny', 'ręczny – podany niżej (tylko sprawdzenie)']] },
        { klucz: 'legar_przekroj', domyslna: '50x100', etykieta: 'Legar – przekrój ręczny', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'podloga', podpowiedz: 'Projekt 900: 50 × 100.' },
        { klucz: 'podpory_rozstaw_max', domyslna: 0.0, etykieta: 'Rozstaw podpór legarów – największy', jednostka: 'mm',
          min: 0.0, max: 8000.0, rodzaj: :liczba, sekcja: 'podloga',
          podpowiedz: '0 – automatycznie: podpory tak gęsto, jak wymaga przekrój legara.' },
        { klucz: 'podpora_przekroj', domyslna: '100x100', etykieta: 'Podpora legarów (podwalina pośrednia)', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'podloga' },
        { klucz: 'obciazenie_uzytkowe', domyslna: 2.0, etykieta: 'Obciążenie użytkowe', jednostka: 'kN/m²', min: 0.5,
          max: 10.0, rodzaj: :liczba, sekcja: 'podloga', podpowiedz: 'Mieszkanie: 1,5–2,0 (PN-EN 1991-1-1, kat. A).' },
        { klucz: 'obciazenie_stale', domyslna: 0.5, etykieta: 'Obciążenie stałe (deski, izolacja)', jednostka: 'kN/m²',
          min: 0.0, max: 5.0, rodzaj: :liczba, sekcja: 'podloga', podpowiedz: 'Bez ciężaru legarów (liczony osobno).' },
        { klucz: 'drewno_klasa', domyslna: 'C24', etykieta: 'Klasa drewna konstrukcyjnego', rodzaj: :wybor, sekcja: 'podloga',
          wybory: [['C18', 'C18'], ['C24', 'C24'], ['C30', 'C30'], ['GL24h', 'GL24h (klejone)']] },
        { klucz: 'ugiecie_zalecane', domyslna: 400.0, etykieta: 'Ugięcie zalecane L /', jednostka: '', min: 150.0,
          max: 1000.0, rodzaj: :liczba, sekcja: 'podloga', podpowiedz: 'Sztywna podłoga bez drgań.' },
        { klucz: 'ugiecie_minimalne', domyslna: 250.0, etykieta: 'Ugięcie dopuszczalne L /', jednostka: '', min: 100.0,
          max: 1000.0, rodzaj: :liczba, sekcja: 'podloga', podpowiedz: 'Granica – mniej sztywna podłoga już niedopuszczalna.' },
        { klucz: 'przekroje_katalog', domyslna: '45x95, 45x120, 45x145, 45x170, 45x195, 45x220, 50x100, 50x150, 50x175, ' \
                                                '50x200, 50x225, 63x175, 63x200, 63x225, 75x200, 75x225, 75x250, 100x100, 100x150',
          etykieta: 'Dostępne przekroje legarów', rodzaj: :tekst, sekcja: 'podloga',
          podpowiedz: 'Lista „szer.×wys.” po przecinku – dobór bierze najlżejszy spełniający warunki.' },

        { klucz: 'min_kawalek_przy_otworze', domyslna: 70.0, etykieta: 'Kawałek bala przy otworze – najkrótszy',
          jednostka: 'mm', min: 0.0, max: 1000.0, rodzaj: :liczba, sekcja: 'otwory' },
        { klucz: 'luz_nad_otworem', domyslna: 0.0, etykieta: 'Luz osiadania nad otworem', jednostka: 'mm', min: 0.0,
          max: 200.0, rodzaj: :liczba, sekcja: 'otwory' },
        { klucz: 'okno_szerokosc', domyslna: 1020.0, etykieta: 'Nowe okno – szerokość', jednostka: 'mm', min: 100.0,
          max: 6000.0, rodzaj: :liczba, sekcja: 'otwory', podpowiedz: 'Wymiary wstawiane przyciskiem „+ okno” (900: 1020 × 1010).' },
        { klucz: 'okno_wysokosc', domyslna: 1010.0, etykieta: 'Nowe okno – wysokość', jednostka: 'mm', min: 100.0,
          max: 4000.0, rodzaj: :liczba, sekcja: 'otwory' },
        { klucz: 'okno_parapet', domyslna: 900.0, etykieta: 'Nowe okno – parapet', jednostka: 'mm', min: 0.0, max: 4000.0,
          rodzaj: :liczba, sekcja: 'otwory' },
        { klucz: 'drzwi_szerokosc', domyslna: 930.0, etykieta: 'Nowe drzwi – szerokość', jednostka: 'mm', min: 300.0,
          max: 6000.0, rodzaj: :liczba, sekcja: 'otwory' },
        { klucz: 'drzwi_wysokosc', domyslna: 2100.0, etykieta: 'Nowe drzwi – wysokość', jednostka: 'mm', min: 1000.0,
          max: 4000.0, rodzaj: :liczba, sekcja: 'otwory' },
        { klucz: 'nowy_otwor_od', domyslna: 1000.0, etykieta: 'Nowy otwór – odległość od narożnika', jednostka: 'mm',
          min: 0.0, max: 30_000.0, rodzaj: :liczba, sekcja: 'otwory' },

        { klucz: 'kontrfor_max_linia', domyslna: 600.0, etykieta: 'Linia węgła – najdłuższa', jednostka: 'mm', min: 100.0,
          max: 3000.0, rodzaj: :liczba, sekcja: 'rysunek', podpowiedz: 'Krótsza linia przecinająca jedną ścianę = węgieł.' },
        { klucz: 'tolerancja_rysunku', domyslna: 5.0, etykieta: 'Tolerancja rysunku obrysu', jednostka: 'mm', min: 0.5,
          max: 50.0, rodzaj: :liczba, sekcja: 'rysunek' },
        { klucz: 'gestosc', domyslna: 450.0, etykieta: 'Gęstość drewna (waga)', jednostka: 'kg/m³', min: 300.0, max: 900.0,
          rodzaj: :liczba, sekcja: 'rysunek' }
      ].freeze unless const_defined?(:LISTA)

      # Szablony wbudowane (okno – lista szablonów): nazwa => wartości różne od domyślnych.
      SZABLONY = {
        'Domek parterowy 44 (jak 900)' => { 'liczba_wiencow' => 16 },
        'Dom parterowy wysoki (jak 1800)' => { 'liczba_wiencow' => 20 },
        'Dom 1,5 kondygnacji (jak 1200)' => { 'liczba_wiencow' => 25 },
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
          'pioro' => 7.0,           # wysokość pióra (pełny profil – późniejsza runda)
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
