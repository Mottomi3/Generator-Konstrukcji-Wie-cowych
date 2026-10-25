# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/pryzmat.rb
# Zadanie: belka o przekroju wielokątnym (graniastosłup) – siatka ścian, objętość, podpis i postać kanoniczna przekroju (np. płatew ścięta do płaszczyzny dachu).
# Tematy: graniastosłup, przekrój wielokątny, płatew ścięta, ścięcie wierzchu płatwi, dachowanie płatwi kalenicowej, siatka belki, objętość belki, pozycja belki z przekrojem
# Zależy od: –
# Używają: rdzen/elementy.rb (pozycje belek z przekrojem), rdzen/projekt.rb (siatka i objętość pozycji)
#
# Przekrój: [[y, z], …] w układzie belki (y – szerokość 0…b, z – wysokość od spodu), przeciwnie do wskazówek zegara
# patrząc od końca belki (x = dl ku obserwatorowi): spód od y = 0 do y = b, potem wierzch od y = b do y = 0.
# Belka biegnie wzdłuż x od 0 do dl; ściany siatki jak w rdzen/siatka.rb: [{ normalna:, petle: [[[x, y, z], …]] }].
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module Pryzmat
      module_function

      # Siatka graniastosłupa: dwa czoła i ściana na każdym boku przekroju.
      def siatka(dl, przekroj)
        pts = przekroj
        n = pts.length
        sciany = []
        sciany << { normalna: [-1.0, 0.0, 0.0], petle: [pts.reverse.map { |y, z| [0.0, y, z] }] }
        sciany << { normalna: [1.0, 0.0, 0.0], petle: [pts.map { |y, z| [dl, y, z] }] }
        n.times do |i|
          ya, za = pts[i]
          yb, zb = pts[(i + 1) % n]
          d = Math.sqrt((yb - ya)**2 + (zb - za)**2)
          next if d < 1e-9
          sciany << { normalna: [0.0, (zb - za) / d, -(yb - ya) / d],
                      petle: [[[0.0, ya, za], [0.0, yb, zb], [dl, yb, zb], [dl, ya, za]]] }
        end
        sciany
      end

      # Pole przekroju [mm²] (wzór Gaussa).
      def pole(przekroj)
        s = 0.0
        przekroj.each_with_index do |(ya, za), i|
          yb, zb = przekroj[(i + 1) % przekroj.length]
          s += ya * zb - yb * za
        end
        s.abs / 2.0
      end

      # Objętość [mm³].
      def objetosc(dl, przekroj)
        pole(przekroj) * dl
      end

      # Podpis przekroju (punkty zaokrąglone do 0,1 mm) – do rozpoznania identycznych belek.
      def podpis(przekroj)
        przekroj.map { |y, z| format('%.1f,%.1f', y, z) }.join(';')
      end

      # Postać kanoniczna: przekrój albo jego odbicie (y → b − y, belka obrócona o 180° wokół pionu) – mniejszy podpis;
      # [przekrój, czy_obrócony].
      def kanoniczny(przekroj, b)
        lustro = przekroj.map { |y, z| [b - y, z] }.reverse
        # Odbicie zmienia kierunek obiegu – po odwróceniu kolejności zaczynamy znów od (0, 0) spodu.
        start = lustro.index { |y, z| y.abs < 1e-6 && z.abs < 1e-6 } || 0
        lustro = lustro.rotate(start)
        podpis(lustro) < podpis(przekroj) ? [lustro, true] : [przekroj, false]
      end
    end
  end
end
