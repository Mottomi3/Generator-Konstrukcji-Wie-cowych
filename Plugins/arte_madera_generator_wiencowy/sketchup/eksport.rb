# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/eksport.rb
# Zadanie: zapis plików z wtyczki – wybór miejsca (okno zapisu SketchUpa), zestawienie CSV z ostatniego podglądu, plik tekstowy UTF-8.
# Tematy: zapis pliku, okno zapisu, zestawienie CSV do pliku, BOM dla Excela, katalog Dokumenty
# Zależy od: rdzen/zestawienie.rb, log.rb
# Używają: sketchup/okno.rb (przycisk „Zapisz zestawienie”), sketchup/raport.rb (zapis raportu)
#
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module Eksport
      # Znacznik UTF-8 na początku pliku CSV – Excel rozpozna polskie znaki.
      BOM = "\xEF\xBB\xBF".b.freeze unless const_defined?(:BOM)

      module_function

      # Zapis zestawienia CSV ostatniego planu; zwraca [komunikat, rodzaj 'ok' | 'blad'].
      def zapisz_liste(plan)
        tekst = Zestawienie.csv(plan)
        return ['Brak zestawienia – najpierw zrób podgląd domu.', 'blad'] if tekst.empty?
        sciezka = wybierz_plik('Zapisz zestawienie bali i belek (CSV)', "Zestawienie_bali_#{Time.now.strftime('%Y-%m-%d_%H%M')}.csv", '.csv')
        return ['Nie zapisano – anulowano wybór pliku.', 'blad'] if sciezka.nil?
        zapisz(sciezka, tekst, true)
        ["Zapisano zestawienie: #{sciezka}", 'ok']
      rescue => e
        Log.error('Eksport.zapisz_liste', e)
        ["Nie można zapisać pliku: #{e.message}", 'blad']
      end

      # Okno zapisu SketchUpa w katalogu Dokumenty; ścieżka z rozszerzeniem albo nil (anulowano).
      def wybierz_plik(tytul, nazwa, rozszerzenie)
        sciezka = UI.savepanel(tytul, katalog_startowy, nazwa)
        return nil if sciezka.nil? || sciezka.to_s.empty?
        sciezka = sciezka.to_s.dup
        sciezka.force_encoding('UTF-8') if sciezka.respond_to?(:force_encoding)
        sciezka += rozszerzenie unless sciezka.downcase.end_with?(rozszerzenie)
        sciezka
      end

      # Zapis tekstu UTF-8 (z BOM dla Excela, gdy bom = true).
      def zapisz(sciezka, tekst, bom = false)
        File.open(sciezka, 'wb') do |f|
          f.write(BOM) if bom
          f.write(tekst.to_s.encode('UTF-8').b)
        end
        sciezka
      end

      # Katalog startowy okna zapisu: Dokumenty użytkownika (gdy jest), inaczej katalog domowy.
      def katalog_startowy
        dom = ENV['USERPROFILE'] || ENV['HOME'] || Dir.pwd
        dok = File.join(dom, 'Documents')
        File.directory?(dok) ? dok : dom
      end
    end
  end
end
