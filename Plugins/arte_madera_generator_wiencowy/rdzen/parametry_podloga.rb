# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_podloga.rb
# Zadanie: parametry sekcji „Podłoga i fundamenty” – podwaliny (przekrój, łączenie), legary, podciągi, fundamenty punktowe, obciążenia.
# Tematy: podłoga – parametry, podwalina – parametry, legar – parametry, podciąg – parametry, obciążenia, fundamenty punktowe – parametry
# Zależy od: rdzen/parametry_lista.rb (TAK_NIE)
# Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji)
#
# Wpis jak w rdzen/parametry_lista.rb (klucz, domyślna, etykieta, jednostka, zakres, rodzaj, sekcja, wybory, podpowiedź;
# gdy – pole widoczne tylko przy wybranych wartościach innych pól, pomoc – dłuższe objaśnienie pod znakiem zapytania).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module ParametryPodloga
      TAK_NIE = [['tak', 'tak'], ['nie', 'nie']].freeze unless const_defined?(:TAK_NIE)

      # Parametry sekcji (kolejność = kolejność w oknie).
      LISTA = [
        { klucz: 'podloga', podstawowy: true, domyslna: 'tak', etykieta: 'Podłoga (podwaliny, legary, podciągi)', rodzaj: :wybor,
          sekcja: 'podloga', wybory: TAK_NIE },
        { klucz: 'podwalina_przekroj', podstawowy: true, domyslna: '100x100', etykieta: 'Podwalina pod ścianami (szer. × wys.)',
          jednostka: 'mm', rodzaj: :przekroj, sekcja: 'podloga', gdy: { 'podloga' => ['tak'] },
          podpowiedz: 'Typ 100: 100 × 100. 50 × 150 (na kant) – równo z legarami 50 × 150, łatwo skręcić śrubami bez zamków.' },
        { klucz: 'podwalina_laczenie', domyslna: 'zaklad', etykieta: 'Podwaliny w narożnikach', rodzaj: :wybor, sekcja: 'podloga',
          gdy: { 'podloga' => ['tak'] },
          wybory: [['zaklad', 'na zakład (pół wysokości)'], ['sruby', 'na styk, bez zamków – skręcane śrubami']],
          podpowiedz: 'Na styk: podwaliny w poprzek legarów na całą długość, pozostałe między nimi.' },
        { klucz: 'podwaliny_pod_dzialowymi', domyslna: 'tak', etykieta: 'Podwaliny także pod działowymi', rodzaj: :wybor,
          sekcja: 'podloga', gdy: { 'podloga' => ['tak'] }, wybory: TAK_NIE },
        { klucz: 'legary_kierunek', domyslna: 'krotszy', etykieta: 'Legary wzdłuż', rodzaj: :wybor, sekcja: 'podloga', gdy: { 'podloga' => ['tak'] },
          wybory: [['krotszy', 'krótszego boku'], ['dluzszy', 'dłuższego boku'], ['x', 'osi X obrysu'], ['y', 'osi Y obrysu']] },
        { klucz: 'legary_rozstaw', domyslna: 600.0, etykieta: 'Rozstaw legarów (osiowo)', jednostka: 'mm', min: 250.0,
          max: 1200.0, rodzaj: :liczba, sekcja: 'podloga', gdy: { 'podloga' => ['tak'] }, podpowiedz: 'Projekt 900: 550–610.' },
        { klucz: 'izolacja_podlogi', podstawowy: true, domyslna: 100.0, etykieta: 'Izolacja między legarami', jednostka: 'mm', min: 0.0,
          max: 400.0, rodzaj: :liczba, sekcja: 'podloga', gdy: { 'podloga' => ['tak'] }, podpowiedz: 'Legar nie niższy niż izolacja (0 – bez izolacji).' },
        { klucz: 'legary_dobor', podstawowy: true, domyslna: 'zalecany', etykieta: 'Dobór przekroju legara', rodzaj: :wybor, sekcja: 'podloga', gdy: { 'podloga' => ['tak'] },
          rysunek: 'ugiecie',
          pomoc: 'Zalecany – najlżejszy przekrój z katalogu, który ugina się nie więcej niż L/zalecane (sztywna podłoga). ' \
                 'Minimalny – wystarczy ugięcie dopuszczalne (taniej, podłoga bardziej sprężysta). Ręczny – wpisujesz swój ' \
                 'przekrój, generator tylko go sprawdza.',
          wybory: [['zalecany', 'zalecany (ugięcie ≤ L/zalecane)'], ['minimalny', 'minimalny (ugięcie ≤ L/minimalne)'],
                   ['reczny', 'ręczny – podany niżej (tylko sprawdzenie)']] },
        { klucz: 'legar_przekroj', podstawowy: true, domyslna: '50x100', etykieta: 'Legar – przekrój do sprawdzenia', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'podloga', gdy: { 'legary_dobor' => ['reczny'] },
          podpowiedz: 'Wpisz przekrój „szer. x wys.”, np. 50x150 – wynik sprawdzenia pod polem i w podpowiedziach. Typ 100: 50 × 100.' },
        { klucz: 'podciagi', podstawowy: true, domyslna: 'auto', etykieta: 'Podciągi pod legarami', rodzaj: :wybor, sekcja: 'podloga',
          gdy: { 'podloga' => ['tak'] },
          wybory: [['auto', 'gdy wymaga ich legar (najmniej drewna)'], ['tak', 'tak – co najwyżej co podany rozstaw'],
                   ['nie', 'nie – legary od podwaliny do podwaliny']],
          pomoc: 'Podciąg to belka w poprzek legarów, pod nimi – skraca ich rozpiętość, więc legar może być niższy. Biegnie do ' \
                 'zewnętrznego lica podwalin, pod podwalinami, i leży na fundamentach punktowych. „Nie” – legar musi przenieść ' \
                 'całą rozpiętość (dobór weźmie wyższy przekrój albo pokaże błąd).' },
        { klucz: 'podpory_rozstaw_max', domyslna: 0.0, etykieta: 'Rozstaw podciągów pod legarami – największy', jednostka: 'mm',
          min: 0.0, max: 8000.0, rodzaj: :liczba, sekcja: 'podloga', gdy: { 'podloga' => ['tak'], 'podciagi' => %w[auto tak] },
          podpowiedz: '0 – automatycznie: tylko tam, gdzie wymaga ich przekrój legara. Z fundamentami punktowymi podciągi leżą ' \
                      'w ich liniach.' },
        { klucz: 'podpora_przekroj', domyslna: '100x150', etykieta: 'Podciąg pod legarami (podpora pośrednia)', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'podloga', gdy: { 'podloga' => ['tak'], 'podciagi' => %w[auto tak] } },
        { klucz: 'podciag_poziom', domyslna: 'pod', etykieta: 'Podciąg – poziom', rodzaj: :wybor, sekcja: 'podloga',
          gdy: { 'podloga' => ['tak'], 'podciagi' => %w[auto tak] },
          wybory: [['pod', 'obniżony – pod podwalinami, legary w całości na nim'],
                   ['rowno', 'na równo z podwaliną – między podwalinami, legary dzielone na podciągu']],
          pomoc: 'Obniżony: podciąg biegnie pod podwalinami od lica do lica obrysu, legary leżą na nim w całości. Na równo: ' \
                 'wierzch podciągu równo z wierzchem podwalin, podciąg między licami wewnętrznymi podwalin (skręcony), legary ' \
                 'dzielone na podciągu – każdy kawałek o połowę krótszy, od podwaliny do podciągu; podłoga niżej o wysokość ' \
                 'podciągu.' },
        { klucz: 'fundamenty', podstawowy: true, domyslna: 'tak', etykieta: 'Fundamenty punktowe', rodzaj: :wybor, sekcja: 'podloga',
          gdy: { 'podloga' => ['tak'] }, wybory: TAK_NIE,
          pomoc: 'Stopy (bloczki, słupki betonowe) pod podwalinami i podciągami, w siatce: rzędy równo co najwyżej „rozstaw ' \
                 'fundamentów” w obu kierunkach, skrajne licem z licem podwalin – nic nie wychodzi poza obrys. Dodatkowe stopy pod ' \
                 'podwalinami działowych – zawsze w osi działowej (rzędy siatki przechodzą przez osie działowych, odcinki między nimi dzielone ' \
                 'równo). Podciągi leżą w liniach fundamentów.' },
        { klucz: 'fundament_ksztalt', domyslna: 'kwadrat', etykieta: 'Fundament punktowy – kształt w rzucie', rodzaj: :wybor,
          sekcja: 'podloga', gdy: { 'podloga' => ['tak'], 'fundamenty' => ['tak'] },
          wybory: [['kwadrat', 'prostokątny – wymiary niżej'], ['okragly', 'okrągły – średnica niżej (np. bloczek w rurze)']] },
        { klucz: 'fundament_przekroj', domyslna: '400x400', etykieta: 'Fundament punktowy – wymiary w rzucie', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'podloga', gdy: { 'podloga' => ['tak'], 'fundamenty' => ['tak'], 'fundament_ksztalt' => ['kwadrat'] } },
        { klucz: 'fundament_srednica', domyslna: 400.0, etykieta: 'Fundament punktowy – średnica', jednostka: 'mm', min: 100.0,
          max: 1500.0, rodzaj: :liczba, sekcja: 'podloga', gdy: { 'podloga' => ['tak'], 'fundamenty' => ['tak'], 'fundament_ksztalt' => ['okragly'] } },
        { klucz: 'fundament_wysokosc', domyslna: 400.0, etykieta: 'Fundament punktowy – wysokość', jednostka: 'mm', min: 50.0,
          max: 2000.0, rodzaj: :liczba, sekcja: 'podloga', gdy: { 'podloga' => ['tak'], 'fundamenty' => ['tak'] },
          podpowiedz: 'Część nad gruntem do rysunku (bez części w gruncie).' },
        { klucz: 'fundamenty_rozstaw_max', domyslna: 2500.0, etykieta: 'Rozstaw fundamentów – największy (osiowo)', jednostka: 'mm',
          min: 800.0, max: 6000.0, rodzaj: :liczba, sekcja: 'podloga', gdy: { 'podloga' => ['tak'], 'fundamenty' => ['tak'] },
          podpowiedz: 'Dom 5 × 7 m przy 2500: 3 rzędy na 5 m i 4 na 7 m.' },
        { klucz: 'obciazenie_uzytkowe', domyslna: 2.0, etykieta: 'Obciążenie użytkowe', jednostka: 'kN/m²', min: 0.5,
          max: 10.0, rodzaj: :liczba, sekcja: 'podloga', rysunek: 'obciazenie',
          podpowiedz: 'Ludzie i meble na podłodze. Mieszkanie: 1,5–2,0, poddasze bez mieszkania 1,0, magazyn 5,0.',
          pomoc: 'Obciążenie użytkowe to ciężar wszystkiego, co stoi i chodzi po podłodze (ludzie, meble, sprzęt) – na metr ' \
                 'kwadratowy. 1 kN/m² ≈ 100 kg na każdym metrze kwadratowym. Dom mieszkalny wg PN-EN 1991-1-1 kat. A: 1,5–2,0 ' \
                 '(2,0 – z zapasem na regały, szafy). Większa wartość → wyższy legar albo podciąg. Obciążenie stałe to ciężar ' \
                 'samej podłogi (deski, izolacja) – legary liczą się osobno.' },
        { klucz: 'obciazenie_stale', domyslna: 0.5, etykieta: 'Obciążenie stałe (deski, izolacja)', jednostka: 'kN/m²',
          min: 0.0, max: 5.0, rodzaj: :liczba, sekcja: 'podloga', podpowiedz: 'Bez ciężaru legarów (liczony osobno).' },
        { klucz: 'drewno_klasa', domyslna: 'C24', etykieta: 'Klasa drewna konstrukcyjnego', rodzaj: :wybor, sekcja: 'podloga',
          wybory: [['C18', 'C18'], ['C24', 'C24'], ['C30', 'C30'], ['GL24h', 'GL24h (klejone)']] },
        { klucz: 'ugiecie_zalecane', domyslna: 400.0, etykieta: 'Ugięcie zalecane L /', jednostka: '', min: 150.0,
          max: 1000.0, rodzaj: :liczba, sekcja: 'podloga', podpowiedz: 'Sztywna podłoga bez drgań.', rysunek: 'ugiecie',
          pomoc: 'Ugięcie L/400: legar o rozpiętości 4 m ugina się pod obciążeniem najwyżej o 10 mm. L/250 – o 16 mm (podłoga ' \
                 '„sprężynuje”, szklanki w kredensie dzwonią). Im większa liczba, tym sztywniej.' },
        { klucz: 'ugiecie_minimalne', domyslna: 250.0, etykieta: 'Ugięcie dopuszczalne L /', jednostka: '', min: 100.0,
          max: 1000.0, rodzaj: :liczba, sekcja: 'podloga', podpowiedz: 'Granica – mniej sztywna podłoga już niedopuszczalna.' },
        { klucz: 'przekroje_katalog', domyslna: '45x95, 45x120, 45x145, 45x170, 45x195, 45x220, 50x100, 50x150, 50x175, ' \
                                                '50x200, 50x225, 63x175, 63x200, 63x225, 75x200, 75x225, 75x250, 100x100, 100x150',
          etykieta: 'Dostępne przekroje legarów', rodzaj: :tekst, sekcja: 'podloga',
          podpowiedz: 'Lista „szer.×wys.” po przecinku – dobór bierze najlżejszy spełniający warunki.' }
      ].freeze unless const_defined?(:LISTA)
    end
  end
end
