# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/dlugosci_handlowe.rb
# Zadanie: porównanie długości belek w modelu z długościami handlowymi z list przekrojów – podpowiedź, gdy belka jest dłuższa niż najdłuższa w hurtowni.
# Tematy: długości handlowe – sprawdzenie, dobór przekroju dostępnego w całej długości, belka dłuższa niż w hurtowni, łączenie belki na długości, podpowiedź o długości płatwi, podpowiedź o długości legara i podciągu
# Zależy od: rdzen/parametry.rb (dlugosci_katalogu)
# Używają: rdzen/projekt.rb (belki), rdzen/statyka_dachu.rb i rdzen/statyka_zadaszenia.rb (dobór – przekrój dostępny w całej długości)
#
# Rozstrzygnięcie użytkownika z 2026-11-14: dobór nie wiedział, że belki się kończą (najdłuższa w wykazie to 8 m,
# większość 7 m) – ma to mówić wprost. Dobór płatwi i belek zadaszenia bierze najlżejszy wystarczający przekrój dostępny
# w całej długości belki (najlzejszy); gdy takiego nie ma – najlżejszy wystarczający i podpowiedź, że belkę trzeba łączyć
# nad podporą. Przekrój spoza listy albo wpis bez długości (lista ze starszej kompilacji) – bez podpowiedzi.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module DlugosciHandlowe
      # Belka dłuższa od handlowej o mniej niż tyle [mm] nie jest zgłaszana (zaokrąglenia).
      TOL = 1.0 unless const_defined?(:TOL)
      # Grupy belek: [prefiks, tag (nil – każdy), klucz listy przekrojów, nazwa w liczbie mnogiej, sekcja okna].
      GRUPY = [
        ['L', nil, 'przekroje_katalog', 'Legary', 'podloga'],
        ['Pd', nil, 'przekroje_katalog', 'Podciągi', 'podloga'],
        ['P', :dach, 'platwie_katalog', 'Płatwie', 'szczyty'],
        ['K', nil, 'krokwie_katalog', 'Krokwie', 'szczyty'],
        ['Wt', nil, 'platwie_katalog', 'Belki trójkąta nad tarasem', 'taras'],
        ['P', :zadaszenie, 'zadaszenie_katalog', 'Płatwie zadaszenia', 'zadaszenie_przekroje'],
        ['Bp', nil, 'zadaszenie_katalog', 'Belki poprzeczne zadaszenia', 'zadaszenie_przekroje'],
        ['S', :zadaszenie, 'zadaszenie_slupy_katalog', 'Słupy zadaszenia', 'zadaszenie_przekroje']
      ].freeze unless const_defined?(:GRUPY)

      module_function

      # Podpowiedzi [{ poziom: 'uwaga', tekst:, sekcja: }] dla belek dłuższych niż najdłuższa handlowa ich przekroju.
      def podpowiedzi(elementy, p)
        wynik = []
        GRUPY.each do |prefiks, tag, klucz, nazwa, sekcja|
          dlugosci = Parametry.dlugosci_katalogu(p, klucz)
          next if dlugosci.empty?
          belki = (elementy || []).select { |e| e[:prefiks] == prefiks && (tag.nil? || e[:tag] == tag) }
          belki.group_by { |e| [e[:b], e[:h]].sort }.each do |bh, lista|
            handlowe = dlugosci[bh]
            next if handlowe.nil?
            za_dlugie = lista.select { |e| e[:dl] > handlowe.last + TOL }
            next if za_dlugie.empty?
            wynik << { poziom: 'uwaga', sekcja: sekcja, tekst: tekst(nazwa, bh, za_dlugie, handlowe.last, dlugosci) }
          end
        end
        wynik
      end

      # Przekrój do doboru automatycznego z listy wystarczających (od najlżejszego): pierwszy dostępny w hurtowni w długości
      # potrzebna [mm] (wpis listy bez długości – bez ograniczenia); gdy żaden nie ma takiej długości – najlżejszy (belkę
      # trzeba wtedy łączyć – podpowiedź z podpowiedzi). Pusta lista – nil.
      def najlzejszy(wystarczajace, potrzebna, p, klucz)
        return wystarczajace.first if wystarczajace.empty? || potrzebna.nil?
        dlugosci = Parametry.dlugosci_katalogu(p, klucz)
        w_calosci = wystarczajace.find do |b, h|
          dl = dlugosci[[b, h].sort]
          dl.nil? || dl.last + TOL >= potrzebna
        end
        w_calosci || wystarczajace.first
      end

      # Zdanie podpowiedzi: ile belek, jak długich, najdłuższa handlowa, co zrobić (przekrój z listy w całej długości).
      def tekst(nazwa, bh, za_dlugie, najdluzsza, dlugosci)
        potrzeba = za_dlugie.map { |e| e[:dl] }.max
        w_calosci = dlugosci.select { |k, dl| k != bh && dl.last + TOL >= potrzeba }.keys.sort_by { |b, h| [b * h, -h] }
        rada = if w_calosci.empty?
                 'żadna belka z listy nie ma takiej długości'
               else
                 "w całej długości są: #{w_calosci.first(3).map { |k| Parametry.tekst_przekroju(k).sub('x', ' × ') }.join(', ')} " \
                 '(sprawdź nośność w wynikach)'
               end
        format('%s %s: %d szt. o długości do %s m, a najdłuższa belka tego przekroju z listy ma %s m – połącz je nad podporą ' \
               '(ścianą, węgłem, słupem albo fundamentem); %s.', nazwa, Parametry.tekst_przekroju(bh).sub('x', ' × '), za_dlugie.length,
               metry(potrzeba), metry(najdluzsza), rada)
      end

      # Długość w metrach do zdania (2 miejsca, bez zbędnych zer).
      def metry(mm)
        format('%.2f', mm / 1000.0).sub(/0\z/, '').sub(/\.0\z/, '').tr('.', ',')
      end
    end
  end
end
