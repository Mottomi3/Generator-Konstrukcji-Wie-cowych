# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/dziennik_pracy.rb
# Zadanie: folder raportów na komputerze użytkownika – raport z testu działania zapisywany sam (bez okna zapisu) i dziennik pracy: jeden wiersz po każdym wygenerowaniu domu (czasy, liczby, zmienione ustawienia) oraz po awarii obliczeń.
# Tematy: folder raportów, raport zapisywany sam, dziennik pracy, czas budowy modelu w dzienniku, zmienione ustawienia w dzienniku, awaria w dzienniku, odbiór bez scenariusza
# Zależy od: sketchup/ustawienia.rb (katalog zapasowy), rdzen/parametry.rb, log.rb
# Używają: sketchup/raport.rb (zapis raportu, ostatnie wpisy), sketchup/sterowanie.rb (po generowaniu, po awarii)
#
# Prośba użytkownika (2026-11-25): odbiór ma być prosty („zrób tak, by było dobrze”). Zamiast scenariusza z kilkudziesięciu
# kroków wtyczka sama zapisuje to, co potrzebne do oceny kompilacji: raport z testu działania i krótki dziennik zwykłej
# pracy. Pliki zostają na dysku użytkownika (nic nie jest nigdzie wysyłane): folder projektu w Dokumentach
# („ArteMadera Generator Konstrukcji Wieńcowych\raporty”), a gdy go nie ma – „raporty” obok pliku ustawień.
# Dziennik: dziennik_pracy.jsonl – jeden wiersz JSON na zdarzenie, najwyżej MAX_WIERSZY ostatnich.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require 'json'
require 'fileutils'

module ArteMadera
  module GeneratorWiencowy
    module DziennikPracy
      FOLDER_PROJEKTU = 'ArteMadera Generator Konstrukcji Wieńcowych'.freeze unless const_defined?(:FOLDER_PROJEKTU)
      PODFOLDER = 'raporty'.freeze unless const_defined?(:PODFOLDER)
      PLIK = 'dziennik_pracy.jsonl'.freeze unless const_defined?(:PLIK)
      # Najwięcej wierszy dziennika; po przekroczeniu o ZAPAS zostaje MAX_WIERSZY ostatnich.
      MAX_WIERSZY = 400 unless const_defined?(:MAX_WIERSZY)
      ZAPAS = 100 unless const_defined?(:ZAPAS)

      module_function

      # Folder raportów: testy – pod AM_GW_USTAWIENIA; folder projektu w Dokumentach, gdy istnieje; inaczej obok ustawień.
      def katalog
        return File.join(Ustawienia.katalog, PODFOLDER) if ENV['AM_GW_USTAWIENIA'] && !ENV['AM_GW_USTAWIENIA'].empty?
        dom = ENV['USERPROFILE'] || ENV['HOME']
        if dom && !dom.empty?
          projekt = File.join(dom, 'Documents', FOLDER_PROJEKTU)
          return File.join(projekt, PODFOLDER) if File.directory?(projekt)
        end
        File.join(Ustawienia.katalog, PODFOLDER)
      end

      # Zapis raportu z testu działania; zwraca ścieżkę pliku albo nil (nie udało się – wpis w Log).
      def zapisz_raport(raport, kompilacja)
        FileUtils.mkdir_p(katalog)
        sciezka = File.join(katalog, "raport_#{Time.now.strftime('%Y-%m-%d_%H%M%S')}_k#{kompilacja}.json")
        File.open(sciezka, 'w:UTF-8') { |f| f.write(JSON.pretty_generate(raport)) }
        sciezka
      rescue => e
        Log.error('DziennikPracy.zapisz_raport', e)
        nil
      end

      # Wiersz dziennika po wygenerowaniu domu: tryb ('nowy' | 'edycja'), czasy [ms], liczby z planu i z budowy, dach.
      def generowanie(plan, wejscie, tryb, ms_obliczen, ms_budowy, zbudowane, dach, kompilacja)
        xs = (plan[:obrys] || []).map { |q| q[0] }
        ys = (plan[:obrys] || []).map { |q| q[1] }
        dopisz('zdarzenie' => 'generowanie', 'tryb' => tryb.to_s, 'kompilacja' => kompilacja.to_s,
               'obrys' => { 'boki' => (plan[:obrys] || []).length, 'x' => xs.empty? ? 0 : (xs.max - xs.min).round, 'y' => ys.empty? ? 0 : (ys.max - ys.min).round },
               'linie' => (wejscie['segmenty'] || []).length, 'otwory' => (wejscie['otwory'] || []).length,
               'sciany' => (plan[:sciany] || []).length, 'bale' => (plan[:bale] || []).length, 'belki' => (plan[:elementy] || []).length,
               'definicje' => zbudowane ? zbudowane[:definicje] : nil, 'bledne_sciany' => zbudowane ? zbudowane[:bledne_sciany] : nil,
               'ms_obliczen' => ms_obliczen, 'ms_budowy' => ms_budowy,
               'ostrzezenia' => (plan[:ostrzezenia] || []).length, 'uwagi' => (plan[:podpowiedzi] || []).count { |h| h[:poziom] == 'uwaga' },
               'bledy_podpowiedzi' => (plan[:podpowiedzi] || []).count { |h| h[:poziom] == 'blad' },
               'dach' => dach.is_a?(Hash) ? dach['tekst'].to_s[0, 160] : nil, 'zmienione' => zmienione(wejscie))
      end

      # Wiersz dziennika po awarii obliczeń (plan[:wyjatek] – rdzen/awaria.rb).
      def awaria(plan, wejscie, kompilacja)
        dopisz('zdarzenie' => 'awaria', 'kompilacja' => kompilacja.to_s, 'opis' => plan[:wyjatek].to_s,
               'linie' => (wejscie.is_a?(Hash) ? wejscie['segmenty'] || [] : []), 'zmienione' => zmienione(wejscie))
      end

      # Ustawienia z okna różne od fabrycznych: { klucz => wartość } (bez wymiarów zamka i bez przekrojów dobranych
      # automatycznie) – które pola są naprawdę używane.
      def zmienione(wejscie)
        z_okna = Parametry.normalizuj(wejscie.is_a?(Hash) ? wejscie['parametry'] : nil)[0]
        fabryczne = Parametry.normalizuj({})[0]
        wynik = {}
        fabryczne.each { |k, v| wynik[k] = z_okna[k] if k != 'zamek' && z_okna[k] != v }
        wynik
      rescue StandardError
        {}
      end

      # Dopisanie wiersza z czasem; plik przycinany do MAX_WIERSZY ostatnich. Błąd zapisu nie przerywa pracy.
      def dopisz(wpis)
        FileUtils.mkdir_p(katalog)
        sciezka = File.join(katalog, PLIK)
        File.open(sciezka, 'a:UTF-8') { |f| f.puts(JSON.generate({ 'czas' => Time.now.strftime('%Y-%m-%d %H:%M:%S') }.merge(wpis))) }
        przytnij(sciezka)
        true
      rescue => e
        Log.error('DziennikPracy.dopisz', e)
        false
      end

      # Zostawia w pliku MAX_WIERSZY ostatnich wierszy, gdy urósł ponad MAX_WIERSZY + ZAPAS.
      def przytnij(sciezka)
        wiersze = File.readlines(sciezka, encoding: 'UTF-8')
        return if wiersze.length <= MAX_WIERSZY + ZAPAS
        File.open(sciezka, 'w:UTF-8') { |f| f.write(wiersze.last(MAX_WIERSZY).join) }
      end

      # Ostatnie wpisy dziennika (do raportu); uszkodzone wiersze pomijane.
      def ostatnie(ile = 50)
        sciezka = File.join(katalog, PLIK)
        return [] unless File.exist?(sciezka)
        File.readlines(sciezka, encoding: 'UTF-8').last(ile).map do |w|
          begin
            JSON.parse(w)
          rescue StandardError
            nil
          end
        end.compact
      rescue => e
        Log.error('DziennikPracy.ostatnie', e)
        []
      end
    end
  end
end
