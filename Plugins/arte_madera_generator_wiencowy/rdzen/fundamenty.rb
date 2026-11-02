# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/fundamenty.rb
# Zadanie: fundamenty punktowe pod podłogą – siatka rzędów w obu kierunkach w obrysie (skrajne licem z licem podwalin), stopy pod podwalinami, podciągami i podwalinami działowych.
# Tematy: fundamenty punktowe, fundament okrągły, średnica fundamentu, rzędy w osiach działowych, stopy fundamentowe, siatka fundamentów, rozstaw fundamentów, fundament pod działową, fundament w obrysie, rząd fundamentów
# Zależy od: rdzen/parametry.rb, rdzen/elementy.rb
# Używają: rdzen/podloga.rb (linie podciągów, elementy F), rdzen/podciagi.rb (rozpiętość podciągu między fundamentami)
#
# Układ podłogi u (rdzen/podloga.rb#uklad): d – wzdłuż legarów (indeks id), e – w poprzek (ie), ext – zasięg obrysu po licach
# zewnętrznych. Rzędy: w każdym kierunku od lica do lica, skrajne stopy licem z licem obrysu (nic nie wychodzi poza dom),
# pozostałe równo, rozstaw osiowy nie większy niż fundamenty_rozstaw_max (dom 5 × 7 m przy 2500: 3 × 4 rzędy). Stopy:
# na obwodzie (pod podwalinami) w każdym rzędzie, wewnątrz – w liniach podciągów (linie d wewnętrzne) na każdym rzędzie e,
# pod podwalinami działowych – w liniach siatki i na końcach (bez dublowania stóp bliższych niż 1,5 wymiaru stopy). Rzędy
# przechodzą przez osie działowych (stopa pod działową zawsze w jej osi, wymóg użytkownika – runda 8), odcinki między
# nimi równo. Stopa prostokątna (fundament_przekroj) albo okrągła (fundament_srednica, wielokąt 24 boki – Pryzmat).
# Wierzch stopy = spód tego, co na niej leży (podciąg albo podwalina).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)

module ArteMadera
  module GeneratorWiencowy
    module Fundamenty
      # Liczba boków wielokąta stopy okrągłej.
      BOKI_KOLA = 24 unless const_defined?(:BOKI_KOLA)

      module_function

      # Czy podłoga ma fundamenty punktowe.
      def wlaczone?(p)
        Parametry.tak?(p, 'podloga') && Parametry.tak?(p, 'fundamenty')
      end

      # Wymiar stopy w rzucie (większy bok albo średnica) [mm].
      def wymiar(p)
        return p['fundament_srednica'].to_f if okragle?(p)
        Parametry.przekroj(p, 'fundament_przekroj').max
      end

      # Opis stopy do podpowiedzi: „400x400” albo „⌀ 400”.
      def opis(p)
        return format('⌀ %s', Parametry.fmt(wymiar(p))) if okragle?(p)
        Parametry.tekst_przekroju(Parametry.przekroj(p, 'fundament_przekroj'))
      end

      # Czy stopy są okrągłe.
      def okragle?(p)
        p['fundament_ksztalt'] == 'okragly'
      end

      # Osie rzędów od lo do hi (lica obrysu): skrajne pół stopy od lica, rzędy stałe w osiach działowych (stale), odcinki
      # między nimi równo, rozstaw ≤ fundamenty_rozstaw_max.
      def rzedy(lo, hi, p, rozstaw = nil, stale = [])
        fb = wymiar(p)
        a = lo + fb / 2.0
        b = hi - fb / 2.0
        return [(lo + hi) / 2.0] if b - a < 1.0
        r = rozstaw || p['fundamenty_rozstaw_max'].to_f
        punkty = ([a] + stale.select { |x| x > a + fb && x < b - fb }.sort + [b]).uniq
        wynik = [a]
        punkty.each_cons(2) do |x0, x1|
          n = [((x1 - x0) / r - 1e-9).ceil, 1].max
          (1..n).each { |i| wynik << x0 + (x1 - x0) * i / n }
        end
        wynik
      end

      # Siatka: { d: [osie rzędów wzdłuż legarów], e: [osie w poprzek] }; u[:rozstaw_d] – rozstaw rzędów d zagęszczony
      # przez dobór legara (rdzen/podloga.rb#zageszczone); rzędy przechodzą przez osie działowych.
      def siatka(u, p)
        { d: rzedy(u[:ext][u[:id]][0], u[:ext][u[:id]][1], p, u[:rozstaw_d], osie_dzialowych(u, u[:id])),
          e: rzedy(u[:ext][u[:ie]][0], u[:ext][u[:ie]][1], p, nil, osie_dzialowych(u, u[:ie])) }
      end

      # Osie działowych w kierunku k (współrzędna k stała wzdłuż działowej – działowa w poprzek tego kierunku).
      def osie_dzialowych(u, k)
        (u[:dzialowe] || []).select { |w| (w[:a][k] - w[:b][k]).abs < 0.5 }.map { |w| w[:a][k] }
      end

      # Wewnętrzne linie d siatki (pod podciągi).
      def linie_podciagow(u, p)
        siatka(u, p)[:d][1..-2] || []
      end

      # Stopy: [[d, e, z_wierzchu]]; podciagi – osie d podciągów (stopy wewnątrz tylko pod nimi), z_pd / z_pw – spód podciągu
      # / podwaliny, dzialowe – odcinki podwalin działowych [[[d, e], [d, e]]].
      def stopy(u, p, podciagi, z_pd, z_pw, dzialowe)
        s = siatka(u, p)
        wynik = []
        s[:d].each_with_index do |d, i|
          brzeg = i.zero? || i == s[:d].length - 1
          pod = !brzeg && podciagi.any? { |x| (x - d).abs < 1.0 }
          s[:e].each_with_index do |e, j|
            next unless brzeg || pod || j.zero? || j == s[:e].length - 1
            wynik << [d, e, pod ? z_pd : z_pw]
          end
        end
        fb = wymiar(p)
        dzialowe.each do |pa, pb|
          dodatkowe(pa, pb, s).each do |q|
            next if wynik.any? { |x| (x[0] - q[0]).abs < 1.5 * fb && (x[1] - q[1]).abs < 1.5 * fb }
            wynik << [q[0], q[1], z_pw]
          end
        end
        wynik
      end

      # Stopy pod odcinkiem podwaliny działowej pa…pb (w układzie d, e): przecięcia z rzędami siatki i końce.
      def dodatkowe(pa, pb, s)
        wzdluz_d = (pa[1] - pb[1]).abs < 1.0
        lo, hi = wzdluz_d ? [pa[0], pb[0]].sort : [pa[1], pb[1]].sort
        rzad = wzdluz_d ? s[:d] : s[:e]
        punkty = [lo, hi] + rzad.select { |x| x > lo && x < hi }
        punkty.map { |x| wzdluz_d ? [x, pa[1]] : [pa[0], x] }
      end

      # Elementy F: stopy jako bryły fb × fl w rzucie, wysokość fundament_wysokosc, wierzch na z_wierzchu; xy – blok
      # (d, e) → punkt rzutu.
      def elementy(lista, p)
        fb, fl = okragle?(p) ? [wymiar(p)] * 2 : Parametry.przekroj(p, 'fundament_przekroj')
        fh = p['fundament_wysokosc'].to_f
        kolo = okragle?(p) ? okrag(fb) : nil
        lista.map do |c, z|
          e = Elementy.nowy('F', fh, fb, fl, [c[0] - fb / 2.0, c[1] - fl / 2.0, z - fh], [0.0, 0.0, 1.0], [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [])
          e[:przekroj] = kolo if kolo
          e
        end
      end

      # Przekrój stopy okrągłej o średnicy d: wielokąt BOKI_KOLA kątów wpisany w kwadrat d × d (przeciwnie do wskazówek).
      def okrag(d)
        n = BOKI_KOLA
        (0...n).map do |i|
          a = 2.0 * Math::PI * (i + 0.5) / n
          [d / 2.0 + d / 2.0 * Math.cos(a), d / 2.0 + d / 2.0 * Math.sin(a)]
        end
      end
    end
  end
end
