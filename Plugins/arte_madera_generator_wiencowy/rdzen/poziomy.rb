# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/poziomy.rb
# Zadanie: trzy poziomy ustawień (Ten dom, Typ domu, Standard warsztatu) i kroki okna w kolejności budowy – które pole należy do którego poziomu i kroku, złożenie parametrów nowego domu ze standardu i typu, pola zmienione tylko w tym domu.
# Tematy: poziomy ustawień, poziom pola, ten dom, typ domu, standard warsztatu, kroki okna, krok pola, parametry nowego domu, pola nadpisane w domu, złożenie standardu i typu
# Zależy od: rdzen/parametry.rb, rdzen/parametry_lista.rb (cecha poziom: przy każdym polu)
# Używają: sketchup/ustawienia.rb (standard), sketchup/typy_domow.rb (typy), sketchup/sterowanie.rb (start nowego domu), sketchup/okno.rb (opisy pól, kroki)
#
# Decyzja użytkownika (2026-11-25): podział ustawień według rodzaju domu; typy domów ustawia i zapisuje sam. Podział pól –
# docs/podzial_pol_r16.md (Ten dom 16, Typ domu 48, Standard warsztatu 128); źródłem jest cecha poziom: wpisu pola.
# Parametry domu = wartości fabryczne ← standard warsztatu ← typ domu ← zmiany w tym domu. Typ pamięta pola poziomów
# „Typ domu” i „Ten dom” (wartości startowe), standard – pola poziomu „Standard warsztatu” i wymiary zamka.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module Poziomy
      # Poziomy w kolejności okna: [klucz, nazwa, kiedy się je zmienia].
      POZIOMY = [
        ['dom', 'Ten dom', 'przy każdym domu'],
        ['typ', 'Typ domu', 'gdy ustawiasz rodzaj domu'],
        ['standard', 'Standard warsztatu', 'rzadko – jak budujesz zawsze']
      ].freeze unless const_defined?(:POZIOMY)

      # Kroki okna w kolejności budowy: [klucz, tytuł, sekcje parametrów kroku].
      KROKI = [
        ['sciany', 'Ściany', %w[przekroj sciany laczenia wegly rysunek]],
        ['otwory', 'Okna i drzwi', %w[otwory]],
        ['dach', 'Dach', %w[szczyty poszycie]],
        ['taras', 'Taras i zadaszenie', %w[taras zadaszenie zadaszenie_przekroje]],
        ['podloga', 'Podłoga', %w[podloga]],
        ['zestawienie', 'Zestawienie', %w[materialy powierzchnie]]
      ].freeze unless const_defined?(:KROKI)

      module_function

      # Poziom pola ('dom' | 'typ' | 'standard'); pole spoza listy – 'standard'.
      def poziom(klucz)
        w = ParametryLista.wpis(klucz)
        w && w[:poziom] ? w[:poziom].to_s : 'standard'
      end

      # Klucze pól podanych poziomów w kolejności okna.
      def klucze(*poziomy)
        ParametryLista::LISTA.select { |w| poziomy.map(&:to_s).include?(w[:poziom].to_s) }.map { |w| w[:klucz] }
      end

      # Krok okna, do którego należy sekcja parametrów (nieznana sekcja – pierwszy krok).
      def krok_sekcji(sekcja)
        k = KROKI.find { |_klucz, _tytul, sekcje| sekcje.include?(sekcja.to_s) }
        (k || KROKI[0])[0]
      end

      # Krok okna pola o podanym kluczu.
      def krok(klucz)
        w = ParametryLista.wpis(klucz)
        krok_sekcji(w ? w[:sekcja] : nil)
      end

      # Tylko pola podanych poziomów z zestawu parametrów (klucze tekstowe; reszta pominięta).
      def wybierz(parametry, *poziomy)
        dozwolone = klucze(*poziomy)
        wynik = {}
        (parametry || {}).each { |k, v| wynik[k.to_s] = v if dozwolone.include?(k.to_s) }
        wynik
      end

      # Parametry nowego domu do okna: standard warsztatu (pola poziomu „Standard warsztatu” i wymiary zamka) uzupełniony
      # polami typu (poziomy „Typ domu” i „Ten dom”); to, czego nie ma w żadnym z nich – wartości fabryczne (Parametry.normalizuj).
      def zloz(standard, typ)
        st = standard.is_a?(Hash) ? standard : {}
        wynik = wybierz(st, :standard).merge(wybierz(typ, :typ, :dom))
        wynik['zamek'] = st['zamek'] if st['zamek'].is_a?(Hash) && !st['zamek'].empty?
        wynik
      end

      # Klucze pól, których wartość w zestawie parametry jest inna niż w zestawie baza (oba sprawdzone przez
      # Parametry.normalizuj – „20” i 20.0 to ta sama wartość); z wymiarami zamka – klucz 'zamek'.
      def rozne(parametry, baza)
        a = Parametry.normalizuj(parametry)[0]
        b = Parametry.normalizuj(baza)[0]
        klucze = ParametryLista::LISTA.map { |w| w[:klucz] }.select { |k| a[k] != b[k] }
        klucze << 'zamek' if a['zamek'] != b['zamek']
        klucze
      end

      # Pola zmienione tylko w tym domu: różne od bazy (standard ← typ) – { 'dom' => [klucze], 'typ' => […], 'standard' => […] }.
      def zmienione_w_domu(parametry, baza)
        wynik = { 'dom' => [], 'typ' => [], 'standard' => [] }
        rozne(parametry, baza).each { |k| wynik[k == 'zamek' ? 'standard' : poziom(k)] << k }
        wynik
      end
    end
  end
end
