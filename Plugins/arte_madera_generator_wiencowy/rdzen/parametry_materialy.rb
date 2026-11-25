# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_materialy.rb
# Zadanie: parametry sekcji „Zestawienie materiałów” – zapas na docinki, taśma między wieńcami, rozstaw kotew podwalin, wydajność i liczba warstw impregnatu.
# Tematy: zestawienie materiałów – parametry, zapas na docinki – parametr, taśma między wieńcami – parametr, kotwy podwalin – parametr, impregnat – parametry
# Zależy od: –
# Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji), rdzen/materialy.rb (obliczenia)
#
# Wpis jak w rdzen/parametry_lista.rb (klucz, domyślna, etykieta, jednostka, zakres, rodzaj, sekcja, wybory, podpowiedź).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module ParametryMaterialy
      # Parametry sekcji (kolejność = kolejność w oknie).
      LISTA = [
        { klucz: 'material_zapas', domyslna: 10.0, etykieta: 'Zapas na docinki desek i płyt', jednostka: '%', min: 0.0, max: 50.0,
          rodzaj: :liczba, sekcja: 'materialy',
          podpowiedz: 'Doliczany do liczby desek nadbitki, deskowania, podbitki i płyt OSB w zestawieniu materiałów.' },
        { klucz: 'tasma_pasy', domyslna: '1', etykieta: 'Taśma między wieńcami – pasy na styk', rodzaj: :wybor, sekcja: 'materialy',
          wybory: [['0', 'bez taśmy'], ['1', 'jeden pas'], ['2', 'dwa pasy']],
          podpowiedz: 'Metry taśmy uszczelniającej: długość wszystkich bali poza najniższym wieńcem × liczba pasów.' },
        { klucz: 'kotwy_podwalin_rozstaw', domyslna: 1000.0, etykieta: 'Kotwy podwalin – rozstaw', jednostka: 'mm', min: 200.0,
          max: 3000.0, rodzaj: :liczba, sekcja: 'materialy', podpowiedz: 'Liczba kotew w zestawieniu: co tyle, nie mniej niż 2 na podwalinę.' },
        { klucz: 'impregnat_wydajnosc', domyslna: 10.0, etykieta: 'Impregnat – wydajność', jednostka: 'm²/l', min: 1.0, max: 30.0,
          rodzaj: :liczba, sekcja: 'materialy', podpowiedz: 'Z etykiety impregnatu albo farby – ile m² z litra na jedną warstwę.' },
        { klucz: 'impregnat_warstwy', domyslna: '2', etykieta: 'Impregnat – liczba warstw', rodzaj: :wybor, sekcja: 'materialy',
          wybory: [['1', 'jedna'], ['2', 'dwie'], ['3', 'trzy']] }
      ].freeze unless const_defined?(:LISTA)
    end
  end
end
