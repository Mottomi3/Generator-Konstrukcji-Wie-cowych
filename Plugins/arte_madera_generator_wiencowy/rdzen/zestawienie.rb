# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/zestawienie.rb
# Zadanie: zestawienie bali i belek do pliku CSV (Excel) – pozycje z długością, ilością i objętością, sumy grup i całości.
# Tematy: zestawienie CSV, lista do zamówienia w pliku, sumy grup, objętość, Excel, przecinek dziesiętny
# Zależy od: rdzen/parametry.rb, rdzen/projekt.rb (podsumowanie)
# Używają: sketchup/eksport.rb (zapis pliku)
#
# Format dla polskiego Excela: średnik między kolumnami, przecinek dziesiętny, nagłówek w pierwszym wierszu.
# Znacznik BOM dopisuje warstwa zapisu (sketchup/eksport.rb).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module Zestawienie
      # Nazwy grup w zestawieniu (prefiks => nazwa).
      GRUPY = {
        'Bs' => 'Bale ścienne', 'Kf' => 'Węgły (kontrfory)', 'Sz' => 'Bale szczytowe', 'Pw' => 'Podwaliny', 'L' => 'Legary',
        'Pd' => 'Podciągi', 'P' => 'Płatwie', 'K' => 'Krokwie'
      }.freeze unless const_defined?(:GRUPY)
      NAGLOWEK = ['Grupa', 'Pozycja', 'Rodzaj', 'Przekrój [mm]', 'Długość [mm]', 'Ilość [szt.]', 'Objętość [m³]'].freeze unless const_defined?(:NAGLOWEK)

      module_function

      # Tekst CSV zestawienia z planu (pusty, gdy plan bez podsumowania).
      def csv(plan)
        return '' if plan.nil? || plan[:podsumowanie].nil?
        lista = plan[:podsumowanie][:lista]
        wiersze = [NAGLOWEK]
        lista.each do |l|
          wiersze << [l[:prefiks], l[:nazwa], rodzaj(l), l[:przekroj].to_s.tr('×', 'x').delete(' '), l[:dl].to_s, l[:ilosc].to_s,
                      liczba(l[:objetosc_m3], 4)]
        end
        wiersze << []
        sumy(lista).each { |s| wiersze << s }
        wiersze.map { |w| w.map { |k| pole(k) }.join(';') }.join("\r\n") + "\r\n"
      end

      # Rodzaj elementu w zestawieniu (bale – nazwa grupy, belki – ich rodzaj).
      def rodzaj(l)
        return l[:rodzaj].to_s if l[:rodzaj] && !l[:rodzaj].to_s.empty?
        GRUPY.fetch(l[:prefiks].to_s, l[:prefiks].to_s)
      end

      # Wiersze sum: każda grupa (sztuki, objętość) i razem.
      def sumy(lista)
        wynik = []
        lista.group_by { |l| l[:prefiks].to_s }.each do |pr, wiersze|
          szt = wiersze.inject(0) { |s, l| s + l[:ilosc].to_i }
          m3 = wiersze.inject(0.0) { |s, l| s + l[:objetosc_m3].to_f }
          wynik << [pr, 'Razem', GRUPY.fetch(pr, pr), '', '', szt.to_s, liczba(m3, 3)]
        end
        szt = lista.inject(0) { |s, l| s + l[:ilosc].to_i }
        m3 = lista.inject(0.0) { |s, l| s + l[:objetosc_m3].to_f }
        wynik << ['', 'Razem wszystko', '', '', '', szt.to_s, liczba(m3, 3)]
        wynik
      end

      # Liczba z przecinkiem dziesiętnym (n miejsc).
      def liczba(v, n)
        format("%.#{n}f", v.to_f).tr('.', ',')
      end

      # Pole CSV: w cudzysłowie, gdy zawiera średnik, cudzysłów albo nową linię.
      def pole(v)
        t = v.to_s
        t =~ /[;"\r\n]/ ? '"' + t.gsub('"', '""') + '"' : t
      end
    end
  end
end
