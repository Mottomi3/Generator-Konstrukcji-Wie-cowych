# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/pol_zamka.rb
# Zadanie: pół zamka w ostatnim połączeniu pod dachem – ostatni bal (ścięty skosem) przechodzi przez zamek bez gniazda od spodu, a bal pod nim dostaje gniazdo do połowy wysokości; dzięki temu koniec ostatniego bala nie odpada.
# Tematy: pół zamka, ostatnie połączenie pod dachem, zamek na połowie wysokości bala, gniazdo do połowy bala, bal szczytu w narożniku pod skosem
# Zależy od: rdzen/parametry.rb
# Używają: rdzen/skos_przy_narozniku.rb (bal zostaje w narożniku), rdzen/zamek.rb (głębokości gniazd w półzamku), testy/losowe_domy.rb (bal w narożniku bez gniazda)
#
# Decyzja użytkownika z 2026-11-14 („połowa wysokości zamka, by ściany były zawsze domykane”) i 2026-11-25 („tak, by ten
# kawałek z jednej czy drugiej strony nie odpadał tylko dlatego, że zostało za mało materiału po wyfrezowaniu zamka –
# mowa tylko o tym jednym ostatnim niefortunnym połączeniu”).
# Zwykły zamek: bal niższy – gniazdo od wierzchu, bal wyższy – gniazdo od spodu, oba po gniazdo_gleb (36); razem 72 =
# pół wieńca 69,5 + luz 2,5. Pod skosem dachu nad gniazdem od spodu zostaje ostatniemu balowi 9–20 mm i koniec się
# odłamuje. Pół zamka: całe 72 mm wycina się w balu niższym (do połowy jego wysokości), bal wyższy zostaje bez gniazda.
# polzamek_gleb > 0 – inna głębokość gniazda w balu niższym (od gniazdo_gleb do 2 × gniazdo_gleb), reszta od spodu
# bala wyższego. Bal oznaczony b[:polzamek] = [osie zamków]; stosowany tylko, gdy ściana poprzeczna ma bal poziom niżej
# i nie ma bala poziom wyżej (ostatnie połączenie), a pod skosem zostaje co najmniej zamek_min_drewno.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module PolZamka
      module_function

      # Czy pół zamka jest włączone.
      def wlaczony?(p)
        Parametry.tak?(p, 'polzamek')
      end

      # Głębokość gniazda w balu niższym [mm]: polzamek_gleb albo (0) do połowy bala = 2 × gniazdo_gleb.
      def gniazdo_nizszego(p)
        g = p['zamek']['gniazdo_gleb'].to_f
        d = p['polzamek_gleb'].to_f
        d < 0.5 ? 2.0 * g : [[d, g].max, 2.0 * g].min
      end

      # Głębokość gniazda od spodu bala wyższego [mm] – reszta do sumy gniazd zwykłego zamka (0 – bez gniazda).
      def gniazdo_wyzszego(p)
        2.0 * p['zamek']['gniazdo_gleb'].to_f - gniazdo_nizszego(p)
      end

      # Czy bal o wierzchu gora [mm od spodu, najniżej w krawędziach gniazda] zmieści pół zamka: nad gniazdem od spodu
      # (zwykle zerowym) zostaje co najmniej zamek_min_drewno.
      def miesci_sie?(gora, p)
        wlaczony?(p) && !gora.nil? && gora - gniazdo_wyzszego(p) >= p['zamek_min_drewno'].to_f - 0.01
      end

      # Oznacza bal b jako bal wyższy półzamka w osi c (współrzędna s jego ściany).
      def oznacz!(b, c)
        b[:polzamek] ||= []
        b[:polzamek] << c unless w_osi?(b, c)
      end

      # Czy bal b jest balem wyższym półzamka w osi c.
      def w_osi?(b, c)
        (b[:polzamek] || []).any? { |x| (x - c).abs < 0.01 }
      end

      # Opis zamka (jak p['zamek']) z inną głębokością gniazda – do obróbek w rdzen/zamek.rb.
      def zamek_z_gniazdem(z, gleb)
        z.merge('gniazdo_gleb' => gleb)
      end
    end
  end
end
