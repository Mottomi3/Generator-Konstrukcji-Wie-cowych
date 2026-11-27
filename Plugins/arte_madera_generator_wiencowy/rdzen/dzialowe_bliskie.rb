# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/dzialowe_bliskie.rb
# Zadanie: działowe narysowane bliżej siebie niż grubość bala (osie równoległe kilkadziesiąt mm od siebie, zachodzące na siebie długością) – połączone w jedną ścianę w miejscu dłuższej, z ostrzeżeniem; bale dwóch takich ścian zajmowałyby to samo miejsce.
# Tematy: działowe blisko siebie, dwie działowe w jednym miejscu, połączenie działowych, błąd rysunku działowej, bale w tym samym miejscu – działowe
# Zależy od: rdzen/geometria.rb (txt)
# Używają: rdzen/obrys.rb (rozpoznaj – po klasyfikacji linii)
#
# Propozycja P5 z rundy 15 (ziarna 6311, 6410, 6430): dwie działowe narysowane 6–42 mm od siebie dawały bale nachodzące
# na siebie w każdym wieńcu (ostrzeżenie „zajmują to samo miejsce”). Dwie linie bliżej niż t − TOL (t – grubość bala),
# których zasięgi zachodzą na siebie albo stykają się (z zapasem grubości bala), to jedna ściana: oś dłuższej, zasięg
# od najdalszego do najdalszego końca. Działowe w odległości co najmniej grubości bala zostają osobno (bale obok siebie).
# Odcinek działowej: [[x, y], [x, y]] w układzie lokalnym obrysu (poziomy albo pionowy).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'geometria') unless defined?(ArteMadera::GeneratorWiencowy::Geometria)

module ArteMadera
  module GeneratorWiencowy
    module DzialoweBliskie
      G = Geometria unless const_defined?(:G)
      # Zapas [mm]: działowe bliżej niż grubość − TOL są łączone.
      TOL = 0.5 unless const_defined?(:TOL)

      module_function

      # Działowe po połączeniu bliskich (t – grubość bala); ostrzeżenia dopisane do uwagi.
      def scal(dzialowe, t, uwagi)
        lista = dzialowe.map { |s| [s[0].dup, s[1].dup] }
        loop do
          para = pierwsza_para(lista, t)
          break if para.nil?
          i, j = para
          a = lista[i]
          b = lista[j]
          uwagi << format('Działowe %s – %s i %s – %s narysowane %.0f mm od siebie (bliżej niż grubość bala) – połączone ' \
                          'w jedną ścianę w miejscu dłuższej. Sprawdź rysunek.', G.txt(a[0]), G.txt(a[1]), G.txt(b[0]), G.txt(b[1]),
                          (poz(a) - poz(b)).abs)
          lista[i] = polacz(a, b)
          lista.delete_at(j)
        end
        lista
      end

      # Pierwsza para działowych do połączenia [i, j]; nil – brak.
      def pierwsza_para(lista, t)
        lista.each_with_index do |a, i|
          ((i + 1)...lista.length).each do |j|
            b = lista[j]
            next unless pozioma?(a) == pozioma?(b)
            next unless (poz(a) - poz(b)).abs < t - TOL
            lo_a, hi_a = zasieg(a)
            lo_b, hi_b = zasieg(b)
            return [i, j] if [lo_a, lo_b].max < [hi_a, hi_b].min + t
          end
        end
        nil
      end

      # Czy odcinek jest poziomy (y stałe).
      def pozioma?(s)
        (s[0][1] - s[1][1]).abs < (s[0][0] - s[1][0]).abs
      end

      # Położenie osi w poprzek (y poziomej, x pionowej).
      def poz(s)
        pozioma?(s) ? s[0][1] : s[0][0]
      end

      # Zasięg wzdłuż osi [od, do].
      def zasieg(s)
        k = pozioma?(s) ? 0 : 1
        [s[0][k], s[1][k]].minmax
      end

      # Jedna działowa z dwóch: oś dłuższej, zasięg od najdalszego do najdalszego końca.
      def polacz(a, b)
        la = zasieg(a)
        lb = zasieg(b)
        dluzsza = la[1] - la[0] >= lb[1] - lb[0] ? a : b
        lo = [la[0], lb[0]].min
        hi = [la[1], lb[1]].max
        q = poz(dluzsza)
        pozioma?(dluzsza) ? [[lo, q], [hi, q]] : [[q, lo], [q, hi]]
      end
    end
  end
end
