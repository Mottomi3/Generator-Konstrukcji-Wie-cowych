# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/awaria.rb
# Zadanie: nieprzewidziany wyjątek w obliczeniach domu zamieniony na plan z komunikatem po polsku – co się stało, co sprawdzić, co wysłać; pełny ślad w dzienniku.
# Tematy: komunikat zamiast wyjątku, awaria obliczeń, błąd wtyczki po polsku, plan po wyjątku, opis techniczny błędu
# Zależy od: rdzen/parametry.rb, log.rb
# Używają: rdzen/projekt.rb (oblicz), sketchup/sterowanie.rb (okienko z komunikatem)
#
# Decyzja użytkownika (2026-11-14): zamiast „NoMethodError: undefined method…” zdanie po polsku i okienko z informacją;
# szczegóły techniczne zostają w dzienniku (Konsola Ruby, raport z testu działania) i krótko na końcu komunikatu.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module Awaria
      module_function

      # Plan zastępczy po wyjątku e: bez ścian i bali, jeden błąd z komunikatem, plan[:wyjatek] – opis techniczny.
      def plan(wejscie, e)
        Log.error('Projekt.oblicz', e, 12)
        { parametry: parametry(wejscie), kat: 0.0, obrys: [], sciany: [], bale: [], pozycje: [], elementy: [],
          pozycje_elementow: [], pary_zamkow: 0, ostrzezenia: [], bledy: [komunikat(e)], podpowiedzi: [], podsumowanie: nil,
          wyjatek: opis(e) }
      end

      # Parametry z wejścia po sprawdzeniu (gdy i to się nie uda – fabryczne).
      def parametry(wejscie)
        Parametry.normalizuj(wejscie.is_a?(Hash) ? wejscie['parametry'] : nil)[0]
      rescue StandardError
        Parametry.normalizuj({})[0]
      end

      # Komunikat dla użytkownika: co się stało, co sprawdzić, co zgłosić.
      def komunikat(e)
        'Nie udało się policzyć domu z tych linii i ustawień – wtyczka trafiła na przypadek, którego nie obsługuje. ' \
        'Cofnij ostatnio zmienione ustawienie albo sprawdź rysunek (obrys zamknięty, linie działowych w środku obrysu). ' \
        "Zgłoś ten błąd z opisem: #{opis(e)}."
      end

      # Krótki opis techniczny: rodzaj wyjątku, treść (do 120 znaków), plik i wiersz, numer kompilacji.
      def opis(e)
        gdzie = e.backtrace && e.backtrace.first ? e.backtrace.first.to_s.sub(/\A.*[\\\/]/, '').sub(/:in .*\z/, '') : 'brak śladu'
        kompilacja = GeneratorWiencowy.const_defined?(:PLUGIN_BUILD) ? ", kompilacja #{GeneratorWiencowy::PLUGIN_BUILD}" : ''
        "#{e.class} – #{e.message.to_s[0, 120]} [#{gdzie}#{kompilacja}]"
      end
    end
  end
end
