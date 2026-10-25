# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/polacie.rb
# Zadanie: połacie dachu dla aplikacji do dachów – obrys, wysokość, kąt, okap i krawędzie szczytowe tak, żeby płaszczyzna połaci była spodem krokwi na płatwiach generatora.
# Tematy: połacie dachu, aplikacja do dachów, ArteMadera Roof, KROK 1 z generatora, płaszczyzna spodu krokwi, krawędzie szczytowe, okap połaci, wysunięcie za szczyt w połaciach, dach z aplikacji, podpowiedź dachu
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia, krokwie)
# Używają: rdzen/projekt.rb (plan[:polacie], podpowiedzi), sketchup/dach_aplikacja.rb
#
# Aplikacja do dachów (RoofBuilder.generate) prowadzi płaszczyznę połaci przez krawędź obrysu na wysokości obrysu,
# a okap (w poziomie) odsuwa wszystkie krawędzie – także szczytowe – o tyle samo. Obrys = zewnętrzne lica ścian
# okapowych na wysokości linii podparcia w tym miejscu (z_ref − tg · grubość), krawędzie szczytowe przesunięte
# o (wysunięcie za szczyt − okap): po odsunięciu połać kończy się przy szczycie razem z płatwiami, przy okapie
# w odległości dach_okap od lica ściany. Punkty w mm układu domu (jak bale), przeciwnie do wskazówek zegara.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)

module ArteMadera
  module GeneratorWiencowy
    module Polacie
      # Najmniejsza długość obrysu połaci wzdłuż kalenicy przed odsunięciem okapu [mm].
      MIN_DLUGOSC = 100.0 unless const_defined?(:MIN_DLUGOSC)

      module_function

      # Czy krokwie buduje aplikacja do dachów (układ z krokwiami i dach_wiezba = aplikacja).
      def z_aplikacji?(p)
        Dach.krokwie?(p) && p['dach_wiezba'] != 'generator'
      end

      # Połacie domu prostokątnego dom = { os:, v_a:, v_b:, u1:, u2: } (Szczyty.dom_prostokatny):
      # { punkty: [[x, y]] (mm układu domu, przeciwnie do wskazówek zegara), z: (wysokość obrysu), kat: (°), okap: (mm),
      # szczyty: [numery krawędzi szczytowych od 1 – krawędź i: punkt i → i + 1, jak w aplikacji] };
      # nil – bez połaci (krokwie z generatora, bez krokwi, bez belek dachu, obrys nieprostokątny).
      def dla_domu(dom, p)
        return nil if dom.nil? || !z_aplikacji?(p) || !Parametry.tak?(p, 'dach_elementy')
        t = Parametry.grubosc(p)
        przesuw = p['dach_okap_szczyt'].to_f - p['dach_okap'].to_f
        u0 = dom[:u1] - t / 2.0 - przesuw
        u3 = dom[:u2] + t / 2.0 + przesuw
        return nil if u3 - u0 < MIN_DLUGOSC
        v0 = dom[:v_a] - t / 2.0
        v3 = dom[:v_b] + t / 2.0
        uv = [[u0, v0], [u3, v0], [u3, v3], [u0, v3]]
        punkty = uv.map { |u, v| dom[:os] == :x ? [u, v] : [v, u] }
        punkty.reverse! if pole(punkty) < 0.0
        iu = dom[:os] == :x ? 0 : 1
        szczyty = (0...punkty.length).select { |i| (punkty[i][iu] - punkty[(i + 1) % punkty.length][iu]).abs < 0.5 }
        { punkty: punkty, z: Dach.linia_podparcia({ v_a: dom[:v_a], v_b: dom[:v_b] }, v0, p), kat: p['dach_kat'].to_f,
          okap: p['dach_okap'].to_f, szczyty: szczyty.map { |i| i + 1 } }
      end

      # Podpowiedzi do okna o dachu z aplikacji ([{ poziom:, tekst: }]); pusta lista, gdy krokwie robi generator.
      def podpowiedzi(dom, p, polacie)
        return [] unless z_aplikacji?(p) && Parametry.tak?(p, 'dach_elementy') && Parametry.tak?(p, 'szczyty')
        if polacie
          return [{ poziom: 'ok', tekst: 'Dach: krokwie z aplikacji do dachów – po wygenerowaniu powstaną połacie (spód krokwi ' \
                                         'na płatwiach) i otworzy się KROK 2: krokwie, łaty, deski i kontrola nośności.' }]
        end
        return [{ poziom: 'uwaga', tekst: 'Dach: za krótki dom na połacie z tym wysunięciem za szczyt.' }] if dom
        [{ poziom: 'uwaga', tekst: 'Dach: połacie dla aplikacji do dachów tylko dla domu prostokątnego – inny dach zrób w ' \
                                   'aplikacji (KROK 1 z obrysu).' }]
      end

      # Pole wielokąta ze znakiem (dodatnie – przeciwnie do wskazówek zegara).
      def pole(punkty)
        s = 0.0
        punkty.each_with_index do |a, i|
          b = punkty[(i + 1) % punkty.length]
          s += a[0] * b[1] - b[0] * a[1]
        end
        s / 2.0
      end
    end
  end
end
