# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/sciana_w_linii.rb
# Zadanie: działowa narysowana w linii ściany obrysu (np. wzdłuż uskoku domu L) – wspólna oś ze ścianą obrysu i połączenie obu w zamku ściany poprzecznej, bez ostatków wchodzących w siebie.
# Tematy: działowa w linii ściany obrysu, przedłużenie ściany zewnętrznej, działowa w narożniku wklęsłym, dom L – ściana między skrzydłami, koniec ściany bez ostatka, styk dwóch ścian w zamku
# Zależy od: rdzen/geometria.rb
# Używają: rdzen/sciany.rb (dzialowe)
#
# Decyzja użytkownika (2026-11-14): „samo skrzyżowanie ma zostać” – żadnych nowych węgłów w tym węźle. Działowa leży
# w jednej linii ze ścianą obrysu, więc dostaje jej oś (rysowana jest po linii lica, 22 mm obok osi), a w narożniku obie
# kończą się w osi ściany poprzecznej: jej bale przechodzą przez węzeł z ostatkiem i trzymają oba końce od góry i od
# spodu – tak samo jak przy łączeniu wieńców w zamku działowej („Łączenie przy działowej” = wspólne).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'geometria') unless defined?(ArteMadera::GeneratorWiencowy::Geometria)

module ArteMadera
  module GeneratorWiencowy
    module ScianaWLinii
      G = Geometria unless const_defined?(:G)
      # Iloczyn wektorowy kierunków jednostkowych, poniżej którego ściany są równoległe.
      ROWNOLEGLE = 1e-6 unless const_defined?(:ROWNOLEGLE)

      module_function

      # Końce linii działowej l ({ a:, b: }), które leżą w narożniku obrysu w linii jednej z jego ścian:
      # [[koniec (0 | 1), ściana w linii, ściana poprzeczna], …]. zasieg – odległość końca od boku obrysu [mm].
      def konce(l, zewn, zasieg)
        d = G.norm(G.sub(l[:b], l[:a]))
        [0, 1].map do |koniec|
          pt = koniec == 0 ? l[:a] : l[:b]
          dalszy = koniec == 0 ? l[:b] : l[:a]
          przy = zewn.select { |w| przy_boku?(pt, w[:bok], zasieg) }
          w_linii = przy.find { |w| rownolegle?(d, w) && poza_bokiem?(dalszy, w[:bok]) }
          poprzeczna = przy.find { |w| !rownolegle?(d, w) }
          w_linii && poprzeczna ? [koniec, w_linii, poprzeczna] : nil
        end.compact
      end

      # Czy kierunek d jest równoległy do ściany w.
      def rownolegle?(d, w)
        G.cross(d, w[:kier]).abs <= ROWNOLEGLE
      end

      # Czy punkt leży przy boku obrysu (w zasięgu, między jego końcami).
      def przy_boku?(pt, bok, zasieg)
        t, odl, _q = G.rzut(pt, bok[0], bok[1])
        odl <= zasieg && t >= -1e-6 && t <= 1.0 + 1e-6
      end

      # Czy punkt leży za końcem boku obrysu (działowa odchodzi od narożnika, nie biegnie wzdłuż ściany).
      def poza_bokiem?(pt, bok)
        t, _odl, _q = G.rzut(pt, bok[0], bok[1])
        t < -1e-6 || t > 1.0 + 1e-6
      end

      # Linia działowej przesunięta w poprzek na oś ściany w linii: { a:, b: }.
      def na_osi(l, w_linii)
        n = G.lewa(G.norm(G.sub(l[:b], l[:a])))
        przes = G.dot(G.sub(w_linii[:a], l[:a]), n)
        { a: G.add(l[:a], G.mul(n, przes)), b: G.add(l[:b], G.mul(n, przes)) }
      end

      # Czy oś ściany w leży na linii a–b (po przesunięciu działowej na oś pierwszej ściany w linii).
      def na_linii?(a, b, w)
        n = G.lewa(G.norm(G.sub(b, a)))
        G.dot(G.sub(w[:a], a), n).abs < 1.0
      end

      # Koniec ściany obrysu w narożniku c bez ostatka: jej bale kończą się w osi ściany poprzecznej, dalej biegnie
      # działowa (w[:w_linii] – które końce; ostatek tego końca nie do ustawienia w widoku ściany).
      def bez_ostatka!(w, c)
        koniec = G.odl(w[:a], c) <= G.odl(w[:b], c) ? 0 : 1
        koniec == 0 ? w[:s_od] = 0.0 : w[:s_do] = w[:dl_osi]
        w[:ostatki_param] = (w[:ostatki_param] || [nil, nil]).dup
        w[:ostatki_param][koniec] = nil
        w[:w_linii] = (w[:w_linii] || [false, false]).dup
        w[:w_linii][koniec] = true
        w
      end
    end
  end
end
