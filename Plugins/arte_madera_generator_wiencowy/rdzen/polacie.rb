# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/polacie.rb
# Zadanie: połacie dachu dla aplikacji do dachów – obrys, wysokość, kąt, okap i krawędzie szczytowe tak, żeby płaszczyzna połaci leżała na wierzchu płatwi generatora (spód krokwi albo spód poszycia na samych płatwiach).
# Tematy: połacie dachu, aplikacja do dachów, ArteMadera Roof, KROK 1 z generatora, płaszczyzna spodu krokwi, krawędzie szczytowe, okap połaci, wysunięcie za szczyt w połaciach, dach z aplikacji, podpowiedź dachu, połać dachu jednospadowego, połacie przy samych płatwiach
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia, lico okapu), rdzen/dach_jednospadowy.rb (ściana niska i wysoka), rdzen/krok2.rb (podpowiedź KROKU 2)
# Używają: rdzen/projekt.rb (plan[:polacie], podpowiedzi), sketchup/dach_aplikacja.rb
#
# Aplikacja do dachów (API.polacie) prowadzi płaszczyznę połaci przez krawędź obrysu na wysokości obrysu,
# a okap (w poziomie) odsuwa wszystkie krawędzie – także szczytowe – o tyle samo. Obrys = zewnętrzne lica ścian
# okapowych na wysokości linii podparcia w tym miejscu (z_ref − tg · grubość), krawędzie szczytowe przesunięte
# o (wysunięcie za szczyt − okap): po odsunięciu połać kończy się przy szczycie razem z płatwiami, przy okapie
# w odległości dach_okap od lica ściany. Dach jednospadowy: jedna połać – krawędź okapowa tylko przy ścianie niskiej,
# pozostałe trzy szczytowe (strona wysoka przesunięta o okap za ścianą wysoką − okap). Punkty w mm układu domu (jak
# bale), przeciwnie do wskazówek zegara. Połacie dla każdego układu dachu (krokwie albo same płatwie – wtedy KROK 2
# kładzie poszycie wprost na płatwiach), gdy dach_wiezba = aplikacja.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'krok2') unless defined?(ArteMadera::GeneratorWiencowy::Krok2)

module ArteMadera
  module GeneratorWiencowy
    module Polacie
      # Najmniejsza długość obrysu połaci wzdłuż kalenicy przed odsunięciem okapu [mm].
      MIN_DLUGOSC = 100.0 unless const_defined?(:MIN_DLUGOSC)

      module_function

      # Czy krokwie i poszycie buduje aplikacja do dachów (dach_wiezba = aplikacja; każdy układ dachu).
      def z_aplikacji?(p)
        p['dach_wiezba'] != 'generator'
      end

      # Połacie domu prostokątnego dom = { os:, v_a:, v_b:, u1:, u2: } (Szczyty.dom_prostokatny):
      # { punkty: [[x, y]] (mm układu domu, przeciwnie do wskazówek zegara), z: (wysokość obrysu), kat: (°), okap: (mm),
      # szczyty: [numery krawędzi szczytowych od 1 – krawędź i: punkt i → i + 1, jak w aplikacji] };
      # nil – bez połaci (krokwie z generatora, bez belek dachu, obrys nieprostokątny).
      def dla_domu(dom, p)
        return nil if dom.nil? || !z_aplikacji?(p) || !Parametry.tak?(p, 'dach_elementy')
        t = Parametry.grubosc(p)
        przesuw = p['dach_okap_szczyt'].to_f - p['dach_okap'].to_f
        u0 = dom[:u1] - t / 2.0 - przesuw
        u3 = dom[:u2] + t / 2.0 + przesuw
        return nil if u3 - u0 < MIN_DLUGOSC
        geo = { v_a: dom[:v_a], v_b: dom[:v_b] }
        v_okap = Dach.lico_okapu_v(geo, p)
        v0, v3 = Dach.jednospadowy?(p) ? [v_okap, v_gora(geo, p)].minmax : [dom[:v_a] - t / 2.0, dom[:v_b] + t / 2.0]
        uv = [[u0, v0], [u3, v0], [u3, v3], [u0, v3]]
        punkty = uv.map { |u, v| dom[:os] == :x ? [u, v] : [v, u] }
        punkty.reverse! if pole(punkty) < 0.0
        { punkty: punkty, z: Dach.linia_podparcia(geo, v_okap, p), kat: p['dach_kat'].to_f, okap: p['dach_okap'].to_f,
          szczyty: szczytowe(punkty, dom[:os] == :x ? 1 : 0, Dach.jednospadowy?(p) ? [v_okap] : [v0, v3]) }
      end

      # Krawędź obrysu po stronie ściany wysokiej (dach jednospadowy) – v: lico zewnętrzne przesunięte o (okap za ścianą
      # wysoką − okap), żeby po odsunięciu okapu połać kończyła się w odległości dach_okap_wysoki od lica.
      def v_gora(geo, p)
        _vn, kier = DachJednospadowy.niska(geo, p)
        DachJednospadowy.wysoka_v(geo, p) +
          kier * (Parametry.grubosc(p) / 2.0 + p['dach_okap_wysoki'].to_f - p['dach_okap'].to_f)
      end

      # Numery krawędzi szczytowych (od 1): wszystkie poza okapowymi – krawędzie o stałym v (indeks iv) równym jednemu
      # z okapy (dwuspadowy – obie, jednospadowy – tylko po stronie ściany niskiej).
      def szczytowe(punkty, iv, okapy)
        n = punkty.length
        (0...n).reject do |i|
          a = punkty[i]
          b = punkty[(i + 1) % n]
          (a[iv] - b[iv]).abs < 0.5 && okapy.any? { |v| (a[iv] - v).abs < 0.5 }
        end.map { |i| i + 1 }
      end

      # Podpowiedzi do okna o dachu z aplikacji ([{ poziom:, tekst: }]); pusta lista, gdy krokwie robi generator.
      def podpowiedzi(dom, p, polacie)
        return [] unless z_aplikacji?(p) && Parametry.tak?(p, 'dach_elementy') && Parametry.tak?(p, 'szczyty')
        return Krok2.podpowiedzi(p) if polacie
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
