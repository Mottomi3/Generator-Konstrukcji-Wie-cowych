# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_materialy.rb
# Zadanie: parametry sekcji „Zestawienie materiałów” (zapas na docinki, taśma między wieńcami, rozstaw kotew podwalin, wydajność i liczba warstw impregnatu) i „Powierzchnie i limity” (teren pod pierwszym balem, limit powierzchni zabudowy i wysokości).
# Tematy: magazyn drewna – parametry, przełącznik doboru przekrojów, cena bala, cennik materiałów, zestawienie materiałów – parametry, zapas na docinki – parametr, taśma między wieńcami – parametr, kotwy podwalin – parametr, impregnat – parametry, limit powierzchni zabudowy – parametr, limit wysokości – parametr, teren pod pierwszym balem – parametr
# Zależy od: rdzen/magazyn_drewna.rb (kolumny i wiersze fabryczne magazynu drewna)
# Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji), rdzen/materialy.rb (obliczenia), rdzen/powierzchnie.rb (limity)
#
# Wpis jak w rdzen/parametry_lista.rb (klucz, domyślna, etykieta, jednostka, zakres, rodzaj, sekcja, wybory, podpowiedź).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'magazyn_drewna') unless defined?(ArteMadera::GeneratorWiencowy::MagazynDrewna)

module ArteMadera
  module GeneratorWiencowy
    module ParametryMaterialy
      # Parametry sekcji (kolejność = kolejność w oknie).
      # Cennik materiałów poza drewnem – wiersze fabryczne (nazwa = początek nazwy pozycji zestawienia, ceny puste).
      CENNIK = [['Płyty OSB', 'm²'], ['Taśma uszczelniająca', 'm'], ['Izolacja pod pierwszy wieniec', 'm'], ['Śruba regulacyjna słupa', 'szt.'],
                ['Podkładki pod głowicę słupa', 'kpl.'], ['Podstawa słupa', 'szt.'], ['Kotwa podwaliny', 'szt.'],
                ['Łącznik krokwi z płatwią', 'szt.'], ['Impregnat albo farba', 'l']].freeze unless const_defined?(:CENNIK)

      LISTA = [
        # Magazyn drewna i jeden przełącznik doboru przekrojów (rdzen/magazyn_drewna.rb), ceny do wyceny (rdzen/wycena.rb).
        { klucz: 'przekroje_dobor', poziom: :standard, podstawowy: true, domyslna: 'reczny', etykieta: 'Przekroje konstrukcji – dobór',
          rodzaj: :wybor, sekcja: 'magazyn',
          wybory: [['reczny', 'podaję sam – generator sprawdza i podpowiada najmniejszy wystarczający'],
                   ['auto', 'dobieraj automatycznie – najlżejszy wystarczający z magazynu, dostępny w całej długości']],
          podpowiedz: 'Jeden przełącznik dla płatwi, krokwi, legarów i belek zadaszenia. Wyjątek dla jednego elementu – w jego polu ' \
                      '„dobór” (np. „Przekrój płatwi – dobór”) zamiast „jak przełącznik”.' },
        { klucz: 'magazyn_drewna', poziom: :standard, rodzaj: :tabela, sekcja: 'magazyn', etykieta: 'Magazyn drewna',
          kolumny: MagazynDrewna::KOLUMNY, domyslna: MagazynDrewna.fabryczny,
          podpowiedz: 'Przekrój „szer.x wys.” (belka stoi wyższym bokiem), długości handlowe w metrach po ukośniku (puste – bez ' \
                      'ograniczenia), znaczniki – do czego dobór może wziąć przekrój; cena za m³ do wyceny (puste – bez ceny). ' \
                      'Fabrycznie: wykaz hurtowni Drewno Partner i deska 14 × 115 × 4000.' },
        { klucz: 'cena_bala', poziom: :standard, domyslna: 0.0, etykieta: 'Cena bala (ściany, węgły, szczyty)', jednostka: 'zł/m³', min: 0.0,
          max: 100_000.0, rodzaj: :liczba, sekcja: 'magazyn', podpowiedz: 'Do wyceny materiału; 0 – bez ceny.' },
        { klucz: 'cennik_materialow', poziom: :standard, rodzaj: :tabela, sekcja: 'magazyn', etykieta: 'Cennik materiałów (poza drewnem)',
          kolumny: [['nazwa', 'Pozycja (początek nazwy)', :tekst], ['jednostka', 'Jednostka', :tekst], ['cena', 'Cena za jednostkę [zł]', :liczba]],
          domyslna: CENNIK.map { |n, j| { 'nazwa' => n, 'jednostka' => j, 'cena' => nil } },
          podpowiedz: 'Pozycja zestawienia materiałów dostaje cenę z wiersza, którego nazwa jest początkiem jej nazwy, przy tej samej ' \
                      'jednostce. Deski poszycia i podbitki – z magazynu drewna (wiersz „Deska” o tej grubości, cena za m³).' },

        { klucz: 'material_zapas', poziom: :standard, domyslna: 10.0, etykieta: 'Zapas na docinki desek i płyt', jednostka: '%', min: 0.0, max: 50.0,
          rodzaj: :liczba, sekcja: 'materialy',
          podpowiedz: 'Doliczany do liczby desek nadbitki, deskowania, podbitki i płyt OSB w zestawieniu materiałów.' },
        { klucz: 'tasma_pasy', poziom: :standard, domyslna: '1', etykieta: 'Taśma między wieńcami – pasy na styk', rodzaj: :wybor, sekcja: 'materialy',
          wybory: [['0', 'bez taśmy'], ['1', 'jeden pas'], ['2', 'dwa pasy']],
          podpowiedz: 'Metry taśmy uszczelniającej: długość wszystkich bali poza najniższym wieńcem × liczba pasów.' },
        { klucz: 'kotwy_podwalin_rozstaw', poziom: :standard, domyslna: 1000.0, etykieta: 'Kotwy podwalin – rozstaw', jednostka: 'mm', min: 200.0,
          max: 3000.0, rodzaj: :liczba, sekcja: 'materialy', podpowiedz: 'Liczba kotew w zestawieniu: co tyle, nie mniej niż 2 na podwalinę.' },
        { klucz: 'impregnat_wydajnosc', poziom: :standard, domyslna: 10.0, etykieta: 'Impregnat – wydajność', jednostka: 'm²/l', min: 1.0, max: 30.0,
          rodzaj: :liczba, sekcja: 'materialy', podpowiedz: 'Z etykiety impregnatu albo farby – ile m² z litra na jedną warstwę.' },
        { klucz: 'impregnat_warstwy', poziom: :standard, domyslna: '2', etykieta: 'Impregnat – liczba warstw', rodzaj: :wybor, sekcja: 'materialy',
          wybory: [['1', 'jedna'], ['2', 'dwie'], ['3', 'trzy']] },

        # Powierzchnie i limity (rdzen/powierzchnie.rb) – limity wpisuje użytkownik, 0 = bez sprawdzania.
        { klucz: 'teren_pod_balem', poziom: :standard, domyslna: 300.0, etykieta: 'Teren poniżej spodu pierwszego bala', jednostka: 'mm', min: 0.0,
          max: 3000.0, rodzaj: :liczba, sekcja: 'powierzchnie',
          podpowiedz: 'Podwalina i fundament nad terenem – od tego poziomu liczy się wysokość domu.' },
        { klucz: 'limit_zabudowy', poziom: :standard, domyslna: 0.0, etykieta: 'Limit powierzchni zabudowy', jednostka: 'm²', min: 0.0, max: 2000.0,
          rodzaj: :liczba, sekcja: 'powierzchnie',
          podpowiedz: 'Twój limit (np. z warunków zgłoszenia albo umowy) – okno ostrzega, gdy dom go przekracza. 0 – bez limitu.' },
        { klucz: 'limit_wysokosci', poziom: :standard, domyslna: 0.0, etykieta: 'Limit wysokości nad terenem', jednostka: 'mm', min: 0.0, max: 30_000.0,
          rodzaj: :liczba, sekcja: 'powierzchnie',
          podpowiedz: 'Najwyższy punkt konstrukcji dachu (bez pokrycia) nad terenem. 0 – bez limitu.' }
      ].freeze unless const_defined?(:LISTA)
    end
  end
end
