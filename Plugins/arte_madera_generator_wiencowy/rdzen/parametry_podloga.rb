# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_podloga.rb
# Zadanie: parametry sekcji „Podłoga i fundamenty” – podwaliny, legary, podciągi, obciążenia, fundamenty punktowe.
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
        { klucz: 'podwalina_przekroj', domyslna: '100x100', etykieta: 'Podwalina pod ścianami', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'podloga', podpowiedz: 'Projekt 900: 100 × 100. Niższa niż legar – podniesiona do wysokości legara.' },
        { klucz: 'podwaliny_pod_dzialowymi', domyslna: 'tak', etykieta: 'Podwaliny także pod działowymi', rodzaj: :wybor,
          sekcja: 'podloga', wybory: TAK_NIE },
        { klucz: 'legary_kierunek', domyslna: 'krotszy', etykieta: 'Legary wzdłuż', rodzaj: :wybor, sekcja: 'podloga',
          wybory: [['krotszy', 'krótszego boku'], ['dluzszy', 'dłuższego boku'], ['x', 'osi X obrysu'], ['y', 'osi Y obrysu']] },
        { klucz: 'legary_rozstaw', domyslna: 600.0, etykieta: 'Rozstaw legarów (osiowo)', jednostka: 'mm', min: 250.0,
          max: 1200.0, rodzaj: :liczba, sekcja: 'podloga', podpowiedz: 'Projekt 900: 550–610.' },
        { klucz: 'izolacja_podlogi', podstawowy: true, domyslna: 100.0, etykieta: 'Izolacja między legarami', jednostka: 'mm', min: 0.0,
          max: 400.0, rodzaj: :liczba, sekcja: 'podloga', podpowiedz: 'Legar nie niższy niż izolacja (0 – bez izolacji).' },
        { klucz: 'legary_dobor', podstawowy: true, domyslna: 'zalecany', etykieta: 'Dobór przekroju legara', rodzaj: :wybor, sekcja: 'podloga',
          wybory: [['zalecany', 'zalecany (ugięcie ≤ L/zalecane)'], ['minimalny', 'minimalny (ugięcie ≤ L/minimalne)'],
                   ['reczny', 'ręczny – podany niżej (tylko sprawdzenie)']] },
        { klucz: 'legar_przekroj', domyslna: '50x100', etykieta: 'Legar – przekrój ręczny', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'podloga', podpowiedz: 'Projekt 900: 50 × 100.' },
        { klucz: 'podpory_rozstaw_max', domyslna: 0.0, etykieta: 'Rozstaw podciągów pod legarami – największy', jednostka: 'mm',
          min: 0.0, max: 8000.0, rodzaj: :liczba, sekcja: 'podloga',
          podpowiedz: '0 – automatycznie: podciągi tylko tam, gdzie wymaga ich przekrój legara (najmniej drewna).' },
        { klucz: 'podpora_przekroj', domyslna: '100x100', etykieta: 'Podciąg pod legarami (podpora pośrednia)', jednostka: 'mm',
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
          podpowiedz: 'Lista „szer.×wys.” po przecinku – dobór bierze najlżejszy spełniający warunki.' }
      ].freeze unless const_defined?(:LISTA)
    end
  end
end
