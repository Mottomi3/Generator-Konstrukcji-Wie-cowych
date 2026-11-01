# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/fundamenty.rb
# Zadanie: fundamenty punktowe pod podłogą – siatka rzędów w obu kierunkach w obrysie (skrajne licem z licem podwalin), stopy pod podwalinami, podciągami i podwalinami działowych.
# Tematy: fundamenty punktowe, stopy fundamentowe, siatka fundamentów, rozstaw fundamentów, fundament pod działową, fundament w obrysie, rząd fundamentów
# Zależy od: rdzen/parametry.rb, rdzen/elementy.rb
# Używają: rdzen/podloga.rb (linie podciągów, elementy F), rdzen/podciagi.rb (rozpiętość podciągu między fundamentami)
#
# Układ podłogi u (rdzen/podloga.rb#uklad): d – wzdłuż legarów (indeks id), e – w poprzek (ie), ext – zasięg obrysu po licach
# zewnętrznych. Rzędy: w każdym kierunku od lica do lica, skrajne stopy licem z licem obrysu (nic nie wychodzi poza dom),
# pozostałe równo, rozstaw osiowy nie większy niż fundamenty_rozstaw_max (dom 5 × 7 m przy 2500: 3 × 4 rzędy). Stopy:
# na obwodzie (pod podwalinami) w każdym rzędzie, wewnątrz – w liniach podciągów (linie d wewnętrzne) na każdym rzędzie e,
# pod podwalinami działowych – w liniach siatki i na końcach (bez dublowania stóp bliższych niż 1,5 wymiaru stopy).
# Wierzch stopy = spód tego, co na niej leży (podciąg albo podwalina).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)

module ArteMadera
  module GeneratorWiencowy
    module Fundamenty
      module_function

      # Czy podłoga ma fundamenty punktowe.
      def wlaczone?(p)
        Parametry.tak?(p, 'podloga') && Parametry.tak?(p, 'fundamenty')
      end

      # Osie rzędów od lo do hi (lica obrysu): skrajne pół stopy od lica, równo, rozstaw ≤ fundamenty_rozstaw_max.
      def rzedy(lo, hi, p, rozstaw = nil)
        fb = Parametry.przekroj(p, 'fundament_przekroj').max
        a = lo + fb / 2.0
        b = hi - fb / 2.0
        return [(lo + hi) / 2.0] if b - a < 1.0
        n = [((b - a) / (rozstaw || p['fundamenty_rozstaw_max'].to_f) - 1e-9).ceil, 1].max
        (0..n).map { |i| a + (b - a) * i / n }
      end

      # Siatka: { d: [osie rzędów wzdłuż legarów], e: [osie w poprzek] }; u[:rozstaw_d] – rozstaw rzędów d zagęszczony
      # przez dobór legara (rdzen/podloga.rb#zageszczone).
      def siatka(u, p)
        { d: rzedy(u[:ext][u[:id]][0], u[:ext][u[:id]][1], p, u[:rozstaw_d]), e: rzedy(u[:ext][u[:ie]][0], u[:ext][u[:ie]][1], p) }
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
        fb = Parametry.przekroj(p, 'fundament_przekroj').max
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
        fb, fl = Parametry.przekroj(p, 'fundament_przekroj')
        fh = p['fundament_wysokosc'].to_f
        lista.map do |c, z|
          Elementy.nowy('F', fh, fb, fl, [c[0] - fb / 2.0, c[1] - fl / 2.0, z - fh], [0.0, 0.0, 1.0], [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [])
        end
      end
    end
  end
end
