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
      # Najmniejszy uskok obrysu między częścią szczytową a okapową jednej ściany domu L [mm].
      USKOK = 1.0 unless const_defined?(:USKOK)

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
        return dla_domu_l(dom, p) if dom[:boczne]
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
        { punkty: punkty, z: Dach.linia_podparcia(geo, v_okap, p) + Dach.uniesienie_krokwi(p), kat: p['dach_kat'].to_f, okap: p['dach_okap'].to_f,
          szczyty: szczytowe(punkty, dom[:os] == :x ? 1 : 0, Dach.jednospadowy?(p) ? [v_okap] : [v0, v3]) }
      end

      # Połacie domu L (rdzen/skrzydla.rb – dwa dachy z koszem): obrys domu po licach zewnętrznych, krawędzie ścian ze
      # szczytem szczytowe i przesunięte o (wysunięcie za szczyt − okap). Ściana ze szczytem dachu głównego na części
      # długości: krawędź podzielona na linii okapu dachu głównego, część szczytowa wysunięta dalej niż okapowa (co
      # najmniej o USKOK) – krótka krawędź uskoku jest okapem tylnej połaci dachu głównego, bez niej aplikacja do dachów
      # zrobiłaby w tym miejscu naroże kopertowe zamiast szczytu i kosza.
      def dla_domu_l(dom, p)
        przesuw = p['dach_okap_szczyt'].to_f - p['dach_okap'].to_f
        iv = dom[:iv]
        vk = (dom[:v_a] + dom[:v_b]) / 2.0
        kraw = []
        dom[:zewn].each do |w|
          a, b = w[:bok]
          g = w[:szczyt]
          if g.nil? || g[:plaski]
            kraw << [a, b, 0.0, false]
          elsif g[:s_zakres].nil?
            kraw << [a, b, przesuw, true]
          else
            j = a.dup
            j[iv] = dom[:r][iv]
            czesci = [[a, j], [j, b]]
            czesci.each do |q0, q1|
              szczyt = ((q0[iv] + q1[iv]) / 2.0 - vk).abs < (dom[:v_b] - dom[:v_a]) / 2.0
              kraw << [q0, q1, szczyt ? [przesuw, USKOK].max : 0.0, szczyt]
            end
          end
        end
        punkty = []
        szczyty = []
        kraw.each_with_index do |(a, b, d1, szczyt), i|
          pa, pb, d0, = kraw[i - 1]
          n0 = normalna(pa, pb)
          n1 = normalna(a, b)
          if (n0[0] * n1[1] - n0[1] * n1[0]).abs < 1e-6
            punkty << [a[0] + n0[0] * d0, a[1] + n0[1] * d0]
            punkty << [a[0] + n1[0] * d1, a[1] + n1[1] * d1]
          else
            punkty << [a[0] + n0[0] * d0 + n1[0] * d1, a[1] + n0[1] * d0 + n1[1] * d1]
          end
          szczyty << punkty.length if szczyt
        end
        geo = Dach.geo(dom)
        { punkty: punkty, z: Dach.linia_podparcia(geo, Dach.lico_okapu_v(geo, p), p), kat: p['dach_kat'].to_f, okap: p['dach_okap'].to_f,
          szczyty: szczyty }
      end

      # Normalna zewnętrzna krawędzi a → b obrysu przeciwnego do wskazówek zegara (w prawo od kierunku).
      def normalna(a, b)
        dx = b[0] - a[0]
        dy = b[1] - a[1]
        dl = Math.sqrt(dx * dx + dy * dy)
        [dy / dl, -dx / dl]
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
        return Krok2.podpowiedzi(p) + uwagi_l(dom, p) if polacie
        return [{ poziom: 'uwaga', tekst: 'Dach: za krótki dom na połacie z tym wysunięciem za szczyt.' }] if dom
        [{ poziom: 'uwaga', tekst: 'Dach: połacie dla aplikacji do dachów tylko dla domu prostokątnego i w kształcie L – inny ' \
                                   'dach zrób w aplikacji (KROK 1 z obrysu).' }]
      end

      # Uwagi do połaci domu L: wysunięcie za szczyt mniejsze niż okap – na ścianie ze szczytem na części długości dach
      # wystaje za szczyt o okap (część szczytowa obrysu musi być wysunięta dalej niż okapowa).
      def uwagi_l(dom, p)
        return [] unless dom && dom[:boczne] && p['dach_okap_szczyt'].to_f < p['dach_okap'].to_f - 0.5
        w = dom[:zewn].find { |x| x[:szczyt] && x[:szczyt][:s_zakres] }
        return [] if w.nil?
        [{ poziom: 'uwaga', tekst: format('Dach domu L: na ścianie %s (szczyt na części długości) połać wystaje za szczyt o %.0f mm ' \
                                          '(okap), nie %.0f mm – ustaw wysunięcie za szczyt nie mniejsze niż okap.', w[:id],
                                          p['dach_okap'].to_f, p['dach_okap_szczyt'].to_f) }]
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
