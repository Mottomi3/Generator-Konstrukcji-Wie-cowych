# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/kontrola_rownoleglych.rb
# Zadanie: kontrola ścian równoległych – bale dwóch ścian biegnących obok siebie albo w jednej linii nie mogą zajmować tego samego miejsca.
# Tematy: nakładanie się ścian równoległych, ostrzeżenie o ścianach w tym samym miejscu, bale w tym samym miejscu, kontrola ścian w jednej linii, działowa na ścianie obrysu – sprawdzenie
# Zależy od: rdzen/parametry.rb
# Używają: rdzen/kontrola.rb (wszystko), rdzen/projekt.rb (ostrzeżenia), testy (losowe domy, domy złożone)
#
# Kontrola zamków (rdzen/kontrola.rb#kolizje) patrzy tylko na skrzyżowania ścian prostopadłych. Tu – pary ścian
# o tym samym kierunku, których osie są bliżej niż grubość bala: prostopadłościany bali (zasięg wzdłuż osi, grubość,
# wysokość wieńca) porównywane parami. Znalezione w rundzie 14: działowa narysowana w linii ściany obrysu wchodziła
# w jej ostatek na 244 × 22 mm w każdym wieńcu.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module KontrolaRownoleglych
      # Wspólna część mniejsza niż tyle [mm] w którymkolwiek kierunku to styk, nie nakładanie.
      TOL = 0.5 unless const_defined?(:TOL)

      module_function

      # Nakładające się bale ścian równoległych: [{ sciany: [id, id], bale: [nr, nr], wymiary: [wzdłuż, w poprzek, w pionie] }].
      def nakladanie(plan)
        t = Parametry.grubosc(plan[:parametry])
        wynik = []
        plan[:sciany].combination(2).each do |w1, w2|
          next unless w1[:os] == w2[:os]
          i = w1[:os] == :x ? 0 : 1
          poprzek = t - (w1[:a][1 - i] - w2[:a][1 - i]).abs
          next if poprzek <= TOL
          z1 = (w1[:bale] || []).map { |b| zasieg(w1, b, i) }
          z2 = (w2[:bale] || []).map { |b| zasieg(w2, b, i) }
          z1.each do |b1, a1, c1|
            z2.each do |b2, a2, c2|
              wzdluz = [c1, c2].min - [a1, a2].max
              next if wzdluz <= TOL
              pion = [b1[:z0] + b1[:h], b2[:z0] + b2[:h]].min - [b1[:z0], b2[:z0]].max
              next if pion <= TOL
              wynik << { sciany: [w1[:id], w2[:id]], bale: [b1[:nr], b2[:nr]], wymiary: [wzdluz.round(1), poprzek.round(1), pion.round(1)] }
            end
          end
        end
        wynik
      end

      # Ostrzeżenia do okna: jedna uwaga na parę ścian, z największą wspólną długością. Zdarza się, gdy dwie ściany narysowano
      # bliżej siebie niż długość węgła (ich węgły wchodzą w siebie) albo jedną na drugiej.
      def ostrzezenia(plan)
        nakladanie(plan).group_by { |n| n[:sciany] }.map do |ids, lista|
          format('Ściany %s i %s zajmują to samo miejsce – bale nachodzą na siebie na długości %d mm (%d par bali). ' \
                 'Odsuń linie tych ścian od siebie albo usuń jedną z nich.', ids[0], ids[1],
                 lista.map { |n| n[:wymiary][0] }.max.round, lista.length)
        end
      end

      # Bal i jego zasięg wzdłuż osi i (współrzędne domu): [bal, od, do].
      def zasieg(w, b, i)
        k0 = w[:a][i] + w[:kier][i] * b[:s0]
        k1 = w[:a][i] + w[:kier][i] * b[:s1]
        [b, [k0, k1].min, [k0, k1].max]
      end
    end
  end
end
