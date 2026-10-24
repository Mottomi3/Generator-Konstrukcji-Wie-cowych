# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/ustawienia.rb
# Zadanie: zapamiętane ustawienia na komputerze – ostatnio użyte parametry (te same po ponownym uruchomieniu SketchUpa) i szablony.
# Tematy: zapis ustawień, ostatnie parametry, szablony parametrów, szablony wbudowane, plik ustawień, przywrócenie domyślnych, katalog AppData, ustawienia okna, tryb pól okna
# Zależy od: rdzen/parametry_lista.rb (szablony wbudowane), log.rb
# Używają: sketchup/sterowanie.rb (start, podgląd, generowanie), sketchup/okno.rb (szablony w oknie)
#
# Plik JSON: Windows %APPDATA%\ArteMadera\GeneratorWiencowy\ustawienia.json, macOS ~/Library/Application Support/…,
# inne ~/.artemadera_gw/ (testy: zmienna AM_GW_USTAWIENIA = katalog). Zawartość: { 'wersja' => 1, 'ostatnie' => {…},
# 'szablony' => { nazwa => {…} }, 'okno' => { 'tryb_pol' => 'podstawowe' | 'wszystkie' } } – wartości tak, jak w oknie
# (teksty); sprawdza je Parametry.normalizuj.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require 'json'
require 'fileutils'

module ArteMadera
  module GeneratorWiencowy
    module Ustawienia
      PLIK = 'ustawienia.json'.freeze unless const_defined?(:PLIK)
      WERSJA = 1 unless const_defined?(:WERSJA)

      module_function

      # Katalog ustawień na tym komputerze.
      def katalog
        return ENV['AM_GW_USTAWIENIA'] if ENV['AM_GW_USTAWIENIA'] && !ENV['AM_GW_USTAWIENIA'].empty?
        if ENV['APPDATA'] && !ENV['APPDATA'].empty?
          File.join(ENV['APPDATA'], 'ArteMadera', 'GeneratorWiencowy')
        elsif RUBY_PLATFORM =~ /darwin/
          File.join(File.expand_path('~'), 'Library', 'Application Support', 'ArteMadera', 'GeneratorWiencowy')
        else
          File.join(File.expand_path('~'), '.artemadera_gw')
        end
      end

      # Pełna ścieżka pliku ustawień.
      def sciezka
        File.join(katalog, PLIK)
      end

      # Zawartość pliku (pusty zestaw, gdy brak pliku albo plik uszkodzony – wtedy ostrzeżenie w Log).
      def wczytaj
        pusty = { 'wersja' => WERSJA, 'ostatnie' => {}, 'szablony' => {}, 'okno' => {} }
        return pusty unless File.exist?(sciezka)
        d = JSON.parse(File.read(sciezka, encoding: 'UTF-8'))
        return pusty unless d.is_a?(Hash)
        pusty.merge('ostatnie' => d['ostatnie'].is_a?(Hash) ? d['ostatnie'] : {},
                    'szablony' => d['szablony'].is_a?(Hash) ? d['szablony'] : {},
                    'okno' => d['okno'].is_a?(Hash) ? d['okno'] : {})
      rescue => e
        Log.warn("Ustawienia: nie można odczytać #{sciezka} (#{e.class}: #{e.message}) – przyjęto domyślne.")
        pusty
      end

      # Zapis całego pliku (najpierw plik tymczasowy, potem zamiana); true gdy się udało.
      def zapisz(dane)
        FileUtils.mkdir_p(katalog)
        tmp = sciezka + '.tmp'
        File.open(tmp, 'w:UTF-8') { |f| f.write(JSON.pretty_generate(dane.merge('wersja' => WERSJA))) }
        File.rename(tmp, sciezka)
        true
      rescue => e
        Log.error('Ustawienia.zapisz', e)
        false
      end

      # Ostatnio użyte parametry (do nowego domu).
      def ostatnie
        wczytaj['ostatnie']
      end

      # Zapamiętanie parametrów jako ostatnio użytych.
      def zapamietaj(parametry)
        return false unless parametry.is_a?(Hash)
        d = wczytaj
        d['ostatnie'] = parametry
        zapisz(d)
      end

      # Tryb pól okna: 'podstawowe' (domyślnie) albo 'wszystkie'.
      def tryb_pol
        wczytaj['okno']['tryb_pol'] == 'wszystkie' ? 'wszystkie' : 'podstawowe'
      end

      # Zapamiętanie trybu pól okna.
      def zapamietaj_tryb_pol(tryb)
        d = wczytaj
        d['okno']['tryb_pol'] = tryb.to_s == 'wszystkie' ? 'wszystkie' : 'podstawowe'
        zapisz(d)
      end

      # Nazwy szablonów: wbudowane (z dopiskiem) i własne, alfabetycznie.
      def nazwy_szablonow
        ParametryLista::SZABLONY.keys.map { |n| "#{n} (wbudowany)" } + wczytaj['szablony'].keys.sort
      end

      # Parametry szablonu (wbudowany – wartości szablonu na tle domyślnych); nil gdy brak.
      def szablon(nazwa)
        n = nazwa.to_s.sub(/ \(wbudowany\)\z/, '')
        return ParametryLista.domyslne.merge(ParametryLista::SZABLONY[n]) if nazwa.to_s.end_with?(' (wbudowany)') && ParametryLista::SZABLONY[n]
        wczytaj['szablony'][nazwa.to_s]
      end

      # Zapis własnego szablonu; zwraca tekst błędu albo nil.
      def zapisz_szablon(nazwa, parametry)
        n = nazwa.to_s.strip
        return 'Podaj nazwę szablonu.' if n.empty?
        return 'Nazwa zajęta przez szablon wbudowany.' if n.end_with?('(wbudowany)') || ParametryLista::SZABLONY.key?(n)
        return 'Brak parametrów do zapisania.' unless parametry.is_a?(Hash)
        d = wczytaj
        d['szablony'][n] = parametry
        zapisz(d) ? nil : "Nie można zapisać pliku #{sciezka}."
      end

      # Usunięcie własnego szablonu; zwraca tekst błędu albo nil.
      def usun_szablon(nazwa)
        d = wczytaj
        return 'Szablonów wbudowanych nie można usunąć.' if nazwa.to_s.end_with?(' (wbudowany)')
        return "Nie ma szablonu „#{nazwa}”." unless d['szablony'].key?(nazwa.to_s)
        d['szablony'].delete(nazwa.to_s)
        zapisz(d) ? nil : "Nie można zapisać pliku #{sciezka}."
      end
    end
  end
end
