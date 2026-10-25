# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/taras_balustrada.rb
# Zadanie: balustrada tarasu z bali (jak 1100) – w przęsłach między słupami i ścianą domu bale na przemian z rzędami przekładek (odcinków bala), w siatce wieńców ściany.
# Tematy: balustrada, przekładka balustrady, prześwit balustrady, bale balustrady, przęsło balustrady, taras 1100 – balustrada
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb, rdzen/taras.rb (przęsła)
# Używają: rdzen/projekt.rb (po Bale.zbuduj)
#
# Balustrada leży w wieńcach ściany (te same wysokości co bale ściany): od dołu do wieńca z najwyższym balem
# balustrady; najwyższy wieniec balustrady – bal, niżej na przemian przekładki i bale, najniższy wieniec zawsze bal
# (ściana z półbalem: półbal i bal nad nim – jak 1100 W-1). taras_balustrada_bale – liczba pełnych bali. Rząd przekładek:
# odcinki taras_przekladka przy obu końcach przęsła i równo między nimi, prześwit najwyżej taras_przekladka_odstep.
# Bale balustrady: bez zamków (końce wolne – przy słupie, ścianie domu albo dolnych balach ściany), w[:bale] ściany,
# b[:taras] = true; dłuższe niż maksymalny bal – dzielone równo.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)

module ArteMadera
  module GeneratorWiencowy
    module TarasBalustrada
      module_function

      # Balustrada w przęsłach [[ściana, a, b]] (Taras.przesla): bale dopisane do ścian i do wynik[:bale] (Bale.zbuduj).
      def dodaj!(przesla, wynik, p)
        n = p['taras_balustrada_bale'].to_i
        return if n <= 0
        nr = wynik[:bale].map { |b| b[:nr] }.max || 0
        przesla.each do |w, a, b|
          wience(w, n, p).each do |wn, i, rodzaj|
            kawalki = rodzaj == :bal ? bale(a, b, p) : przekladki(a, b, p)
            kawalki.each do |s0, s1|
              nr += 1
              bal = { nr: nr, sciana: w, wieniec: wn, i: i, s0: s0, s1: s1, dl: s1 - s0, z0: wn[:z0], h: wn[:h], lvl: wn[:lvl],
                      polbal: wn[:polbal], cechy: [], konce: [:wolny, :wolny], taras: true }
              (w[:bale] ||= []) << bal
              wynik[:bale] << bal
            end
          end
        end
      end

      # Wieńce balustrady ściany w: [[wieniec, indeks, :bal | :przekladki]] – pod podciągiem tarasu, n pełnych bali.
      def wience(w, n, p)
        kursy = Wience.dla_sciany(w, p)
        gora = kursy.first && kursy.first[:polbal] ? 2 * n - 1 : 2 * n - 2
        limit = w[:taras][:rola] == :front ? w[:taras][:z_front] : w[:taras][:z_bok]
        wynik = []
        kursy.each_with_index do |wn, i|
          break if i > gora || wn[:z0] + wn[:h] > limit + 0.01
          wynik << [wn, i, i.zero? || (gora - i).even? ? :bal : :przekladki]
        end
        wynik
      end

      # Bal balustrady w przęśle a…b – dzielony równo, gdy dłuższy niż maksymalny bal.
      def bale(a, b, p)
        k = [((b - a) / p['max_dlugosc'].to_f - 1e-9).ceil, 1].max
        (0...k).map { |j| [a + (b - a) * j / k, a + (b - a) * (j + 1) / k] }
      end

      # Przekładki w przęśle a…b: przy obu końcach i równo między nimi, prześwit najwyżej taras_przekladka_odstep.
      def przekladki(a, b, p)
        dl = p['taras_przekladka'].to_f
        odstep = p['taras_przekladka_odstep'].to_f
        l = b - a
        return [[a, b]] if l <= 2.0 * dl + 1.0
        n = 2
        n += 1 while (l - n * dl) / (n - 1) > odstep + 1e-6 && n < 200
        (0...n).map { |i| x = a + (l - dl) * i / (n - 1); [x, x + dl] }
      end
    end
  end
end
