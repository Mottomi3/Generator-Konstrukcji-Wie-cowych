# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_kanaly.rb
# Zadanie: parametry kanałów na przewody elektryczne (N3) – średnica kanału i puszki, wysokość puszki w okienku, odstęp kanału od zamków skrzyżowań.
# Tematy: kanały na przewody – parametry, średnica kanału, puszka elektryczna – parametry, odstęp kanału od zamka
# Zależy od: –
# Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji), rdzen/kanaly.rb, html/klik_sciana.js (wartości w okienku)
#
# Wpis jak w rdzen/parametry_lista.rb. Kanały wstawia się kliknięciem w widok ściany (przełącznik „Klik w widok wstawia”
# – kanał); tu wartości startowe okienka i zasady wspólne.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module ParametryKanaly
      LISTA = [
        { klucz: 'kanal_srednica', poziom: :standard, domyslna: 25.0, etykieta: 'Kanał na przewody – średnica', jednostka: 'mm', min: 10.0,
          max: 40.0, rodzaj: :liczba, sekcja: 'otwory',
          podpowiedz: 'Pionowy otwór przez wszystkie wieńce ściany (w modelu kwadrat o tym boku), wiercony w osi grubości bala. ' \
                      'Kanał wstawiasz kliknięciem w widok ściany („Klik w widok wstawia: kanał”).' },
        { klucz: 'kanal_puszka_wysokosc', poziom: :standard, domyslna: 300.0, etykieta: 'Kanał – puszka, wysokość (nowy kanał)', jednostka: 'mm',
          min: 0.0, max: 3000.0, rodzaj: :liczba, sekcja: 'otwory',
          podpowiedz: 'Środek puszki od spodu pierwszego bala – podpowiedź w okienku (gniazdka 300, włączniki 1100).' },
        { klucz: 'kanal_puszka_srednica', poziom: :standard, domyslna: 68.0, etykieta: 'Kanał – puszka, średnica otworu', jednostka: 'mm',
          min: 40.0, max: 120.0, rodzaj: :liczba, sekcja: 'otwory',
          podpowiedz: 'Otwór puszki od strony wnętrza do kanału – na liście obróbek bala (wiercenie), bez wycięcia w modelu.' },
        { klucz: 'kanal_odstep_zamka', poziom: :standard, domyslna: 60.0, etykieta: 'Kanał – najmniejszy odstęp od lica ściany poprzecznej',
          jednostka: 'mm', min: 0.0, max: 500.0, rodzaj: :liczba, sekcja: 'otwory',
          podpowiedz: 'Kanał bliżej skrzyżowania ze ścianą albo węgłem trafiłby w zamek – pominięty z ostrzeżeniem.' }
      ].freeze unless const_defined?(:LISTA)
    end
  end
end
