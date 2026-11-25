# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/podloga_przybudowki.rb
# Zadanie: podłoga w przybudówce z bali do wyboru – bez podłogi legary i podciągi tylko w domu (pole podłogi kończy się na podwalinie dawnej ściany okapowej), podwaliny i fundamenty także pod ścianami przybudówki; dawna ściana okapowa zawsze na podwalinie.
# Tematy: podłoga w przybudówce, przybudówka bez podłogi, pole legarów, podwalina dawnej ściany okapowej, fundamenty przybudówki
# Zależy od: rdzen/parametry.rb
# Używają: rdzen/podloga.rb (pole legarów, przęsła, linie legarów), rdzen/podciagi.rb (zasięg podciągów), rdzen/fundamenty.rb (stopy pod podciągami tylko w polu podłogi), rdzen/projekt.rb (podpowiedź w zakładce zadaszenia)
#
# Wymóg użytkownika (2026-11-25): „podłogi w przybudówce w opcjach” (zadaszenie_podloga). Ściany przybudówki rozpoznaje
# rola ściany (rdzen/zadaszenie.rb#oznacz!: w[:zadaszenie][:rola] = :dom – dawna ściana okapowa, :przybudowka – ściana
# zewnętrzna przybudówki). Układ podłogi u (rdzen/podloga.rb#uklad): u[:ext] – obrys (podwaliny i siatka fundamentów), u[:pole]
# – zasięg legarów i podciągów (bez przybudówki: po stronie przybudówki do osi dawnej ściany okapowej ± pół podwaliny, tak że
# lico podwaliny działowej jest licem pola), u[:dzialowe_pola] – działowe dzielące pole (bez dawnej ściany okapowej).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module PodlogaPrzybudowki
      module_function

      # Czy ściana to dawna ściana okapowa domu przy przybudówce (zawsze na podwalinie – niesie dom).
      def sciana_domu?(w)
        !w[:zadaszenie].nil? && w[:zadaszenie][:rola] == :dom
      end

      # Czy przybudówka jest bez podłogi (przybudówka z bali, zadaszenie_podloga = nie, podłoga domu włączona).
      def bez_podlogi?(sciany, p)
        p['zadaszenie_podloga'].to_s == 'nie' && Parametry.tak?(p, 'podloga') && sciany.any? { |w| sciana_domu?(w) }
      end

      # Ograniczenie pola podłogi do domu (u z rdzen/podloga.rb#uklad): u[:pole] i u[:dzialowe_pola]; bez zmian, gdy
      # przybudówka ma podłogę albo jej nie ma.
      def ogranicz!(u, sciany, p)
        return u unless bez_podlogi?(sciany, p)
        b = u[:pw][0]
        pole = u[:ext].map(&:dup)
        domowe = sciany.select { |w| sciana_domu?(w) }
        domowe.each do |w|
          k = (w[:a][0] - w[:b][0]).abs < 0.5 ? 0 : 1
          c = w[:a][k]
          if w[:zadaszenie][:kier] < 0
            pole[k][0] = c - b / 2.0
          else
            pole[k][1] = c + b / 2.0
          end
        end
        u[:pole] = pole
        u[:dzialowe_pola] = u[:dzialowe].reject { |w| domowe.include?(w) }
        u
      end

      # Zasięg legarów i podciągów: [[x0, x1], [y0, y1]] (bez ograniczenia – obrys).
      def pole(u)
        u[:pole] || u[:ext]
      end

      # Działowe dzielące pole podłogi (przęsła i linie legarów).
      def dzialowe_pola(u)
        u[:dzialowe_pola] || u[:dzialowe] || []
      end

      # Czy współrzędna x w kierunku k leży w polu podłogi (z zapasem 1 mm).
      def w_polu?(u, k, x)
        lo, hi = pole(u)[k]
        x >= lo - 1.0 && x <= hi + 1.0
      end

      # Podpowiedź do zakładki zadaszenia: przybudówka z podłogą albo bez ([{ poziom:, tekst: }]).
      def podpowiedzi(sciany, p)
        return [] unless sciany.any? { |w| sciana_domu?(w) }
        unless Parametry.tak?(p, 'podloga')
          return [{ poziom: 'ok', tekst: 'Przybudówka: podłoga domu wyłączona (zakładka Dom → „Podłoga i fundamenty”).' }]
        end
        if bez_podlogi?(sciany, p)
          return [{ poziom: 'ok', tekst: 'Przybudówka bez podłogi: podwaliny pod jej ścianami (na fundamentach, gdy włączone); ' \
                                         'legary i podciągi tylko w domu – do podwaliny dawnej ściany okapowej.' }]
        end
        [{ poziom: 'ok', tekst: 'Przybudówka z podłogą: legary domu sięgają do ściany przybudówki (dawna ściana okapowa – na podwalinie).' }]
      end
    end
  end
end
