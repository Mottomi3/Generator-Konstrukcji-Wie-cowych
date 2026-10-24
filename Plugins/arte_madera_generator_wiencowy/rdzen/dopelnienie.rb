# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/dopelnienie.rb
# Zadanie: dopełnienie zamka nad niższą działową – przy ścianach, które idą wyżej, odcinki działowej (ostatek + grubość + dopelnienie_wewn) aż do góry tamtej ściany, jak 1100 W-6, W-7 i 1200 W-5, W-7.
# Tematy: dopełnienie zamka, nadstawka, odcinki nad działową, działowa niższa, 244 nad działową, 344 nad działową, strop, antresola
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wysokość ściany), rdzen/szczyty.rb (położenie na szczycie), rdzen/dach.rb (linia podparcia)
# Używają: rdzen/projekt.rb (po węgłach, przed gniazdami płatwi), rdzen/wience.rb (wieńce nadstawki), rdzen/bale.rb (kawałki nadstawki)
#
# Działowa z w[:nizsza] kończy się pełnym wieńcem nie wyżej niż w[:nizsza][:z]. Przy każdym skrzyżowaniu ze ścianą
# zewnętrzną albo działową pełnej wysokości, która jest wyżej, działowa dostaje kolumnę odcinków (w[:dopelnienie] =
# [{ s0:, s1:, z_do:, z_gora: }]): wieniec nadstawki leży w kolumnie, gdy zaczyna się niżej niż z_do (góra tamtej
# ściany – ostatni odcinek wystaje o pół wieńca i zamyka zamek; pod połacią ścina go linia dachu), a przy ścianie ze
# szczytem – gdy cały mieści się pod linią podparcia dachu (z_gora; spód krokwi / desek – odcinek wystaje z obu stron
# szczytu pod połać, jak węgieł przy szczycie). Odcinek przy końcu działowej: od końca z ostatkiem do
# osi skrzyżowania + pół grubości + dopelnienie_wewn; w środku działowej – po tyle z obu stron (jak węgieł 244).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)
require File.join(File.dirname(__FILE__), 'szczyty') unless defined?(ArteMadera::GeneratorWiencowy::Szczyty)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)

module ArteMadera
  module GeneratorWiencowy
    module Dopelnienie
      module_function

      # Kolumny odcinków dopełnienia wszystkich niższych działowych (w[:dopelnienie]); zwraca ostrzeżenia.
      def planuj(sciany, p)
        uwagi = []
        t = Parametry.grubosc(p)
        wewn = p['dopelnienie_wewn'].to_f
        sciany.each do |w|
          w.delete(:dopelnienie)
          next unless w[:rodzaj] == :dzialowa && w[:nizsza]
          gora = Wience.wysokosc(w, p)
          pelna = Wience.wysokosc_pelna(w, p)
          if w[:nizsza][:z] > pelna + 0.5
            uwagi << format('Ściana %s: góra działowej %.0f mm wyżej niż jej pełna wysokość %.0f mm – działowa pełnej wysokości.',
                            w[:id], w[:nizsza][:z], pelna)
          end
          kolumny = []
          w[:skrzyzowania].each do |k|
            x = k[:inna]
            next if x[:rodzaj] == :kontrfor || x[:nizsza]
            kx = x[:skrzyzowania].find { |q| q[:inna].equal?(w) }
            next if kx.nil?
            z_do, pod_szczytem = wysokosc_przy(x, kx[:s], t, p)
            next if z_do <= gora + 1.0
            s0, s1 = odcinek(w, k[:s], t, wewn)
            kolumny << { s0: s0, s1: s1, z_do: z_do, z_gora: pod_szczytem ? z_do : nil, sciana: x[:id] }
          end
          w[:dopelnienie] = gora < pelna - 0.5 ? kolumny : []
        end
        uwagi
      end

      # Wysokość ściany x w miejscu s (oś skrzyżowania ± pół grubości): [z, czy limit dachu]; ściana ze szczytem – linia
      # podparcia dachu (odcinek wchodzi pod połać po obu stronach szczytu, tam leżą krokwie i deski).
      def wysokosc_przy(x, s, t, p)
        return [Wience.wysokosc(x, p), false] if x[:szczyt].nil?
        l = [s - t / 2.0, s + t / 2.0].map { |q| Dach.linia_podparcia(x[:szczyt], Szczyty.v_z_s(x, q), p) }.min
        [l, true]
      end

      # Odcinek dopełnienia na osi działowej przy skrzyżowaniu s: [s0, s1].
      def odcinek(w, s, t, wewn)
        return [w[:s_od], s + t / 2.0 + wewn] if s < 1.0
        return [s - t / 2.0 - wewn, w[:s_do]] if s > w[:dl_osi] - 1.0
        [s - t / 2.0 - wewn, s + t / 2.0 + wewn]
      end

      # Czy wieniec nadstawki o spodzie z0 i wysokości h leży w kolumnie k.
      def w_kolumnie?(k, z0, h)
        z0 < k[:z_do] - 0.01 && (k[:z_gora].nil? || z0 + h <= k[:z_gora] + 0.01)
      end

      # Przedziały wieńca nadstawki w zasięgu zas: [[s0, s1], …] (sąsiednie kolumny scalone).
      def przedzialy(w, wn, zas)
        lista = (w[:dopelnienie] || []).select { |k| w_kolumnie?(k, wn[:z0], wn[:h]) }.map do |k|
          [[k[:s0], zas[0]].max, [k[:s1], zas[1]].min]
        end
        lista = lista.select { |a, b| b - a > 1.0 }.sort
        wynik = []
        lista.each do |a, b|
          if !wynik.empty? && a <= wynik.last[1] + 0.01
            wynik.last[1] = [wynik.last[1], b].max
          else
            wynik << [a, b]
          end
        end
        wynik
      end
    end
  end
end
