# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/stolarka.rb
# Zadanie: stolarka okien i drzwi – otwór w balach ze stolarki i luzów (boczny z obu stron, górny na osiadanie), podpowiedź luzu górnego z wysokości stolarki.
# Tematy: stolarka, okno, drzwi, luz boczny, luz górny, luz osiadania, osiadanie ścian, podpowiedź luzu, wymiary otworu w balach
# Zależy od: rdzen/parametry.rb
# Używają: rdzen/otwory.rb (otwór w balach), rdzen/widok.rb (stolarka w widoku ściany); html/otwory.js liczy to samo w oknie
#
# Wiersz tabeli otworów podaje wymiary STOLARKI (szerokosc × wysokosc), parapet (spód stolarki = spód otworu) i od
# (krawędź otworu w balach od punktu odniesienia ściany). Otwór w balach: szerokość = stolarka + 2 × luz_boczny,
# wysokość = stolarka + luz górny; luz górny wpisany w wierszu (luz_gorny) albo – gdy pusty – podpowiedź:
# wysokość stolarki × osiadanie_scian [%], w górę do pełnych 5 mm, nie mniej niż luz_gorny_min.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module Stolarka
      # Podpowiedź luzu górnego zaokrąglana w górę do tylu mm.
      KROK = 5.0 unless const_defined?(:KROK)

      module_function

      # Podpowiedź luzu górnego (osiadanie) dla stolarki o wysokości h [mm].
      def luz_podpowiedz(h, p)
        surowy = h.to_f * p['osiadanie_scian'].to_f / 100.0
        zaokr = (surowy / KROK - 1e-9).ceil * KROK
        [zaokr, p['luz_gorny_min'].to_f].max
      end

      # Luz górny otworu: wpisany w wierszu (liczba ≥ 0) albo podpowiedź; [luz, czy_podpowiedz].
      def luz_gorny(o, h, p)
        wpisany = Parametry.liczba(o['luz_gorny'])
        return [wpisany, false] if wpisany && wpisany >= 0.0
        [luz_podpowiedz(h, p), true]
      end

      # Otwór w balach ze stolarki: { s0:, s1:, z0:, z1:, stolarka: { s0:, s1:, z0:, z1: }, luz_gorny:, podpowiedz: };
      # s0 – krawędź otworu na osi ściany (punkt odniesienia + od).
      def otwor(s0, szer, wys, parapet, o, p)
        lb = p['luz_boczny'].to_f
        lg, podp = luz_gorny(o, wys, p)
        s1 = s0 + szer + 2.0 * lb
        { s0: s0, s1: s1, z0: parapet, z1: parapet + wys + lg, luz_gorny: lg, podpowiedz: podp,
          stolarka: { s0: s0 + lb, s1: s1 - lb, z0: parapet, z1: parapet + wys } }
      end
    end
  end
end
