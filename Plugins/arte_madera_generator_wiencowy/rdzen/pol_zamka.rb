# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/pol_zamka.rb
# Zadanie: pół zamka w ostatnim połączeniu pod dachem – ostatni bal (ścięty skosem albo płaszczyzną dachu) przechodzi przez zamek bez gniazda od spodu, a bal pod nim dostaje gniazdo do połowy wysokości; dzięki temu koniec ostatniego bala nie odpada. Narożnik, góra węgła, ściana nad węgłem i nad działową.
# Tematy: pół zamka, ostatnie połączenie pod dachem, zamek na połowie wysokości bala, gniazdo do połowy bala, bal szczytu w narożniku pod skosem, pół zamka na górze węgła, ostatni bal węgła pod dachem, bal ściany nad węgłem pod skosem, wierzch bala pod dachem
# Zależy od: rdzen/parametry.rb
# Używają: rdzen/skos_przy_narozniku.rb (bal zostaje w narożniku), rdzen/zamek.rb (ostatnie połączenia, głębokości gniazd w półzamku), rdzen/bale.rb (ostatni bal węgła od zamek_min_drewno pod dachem), testy/losowe_domy.rb (bal w narożniku bez gniazda)
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
# Runda 16 (akceptacja użytkownika 2026-11-25: „dobry pomysł … i tak trzeba podfrezować gniazda na bokach górnego elementu,
# by wszedł w ten poniżej”): włączone fabrycznie; bal wyższy ma podcięcia boczne jak w zwykłym zamku (rdzen/zamek.rb –
# podciecia), brak tylko gniazda od spodu. Ta sama zasada poza narożnikiem (ostatnie?): góra węgła pod krokwiami albo
# podbitką, bal ściany nad ostatnim balem węgła, bal nad działową pod połacią, górny bal ściany ścięty płaszczyzną dachu –
# wszędzie tam, gdzie zwykłe gniazdo zostawia balowi pod dachem mniej niż zamek_min_drewno i nic na nim nie leży.
# W środku ściany bal nie jest ucinany (jak ostatek w narożniku) – zostaje cały także wtedy, gdy pod skosem ma mniej
# niż zamek_min_drewno: gniazdo od spodu przecięłoby go na dwa kawałki.
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

      # Najmniejsza wysokość pod dachem [mm nad spodem], od której ostatni bal (nic na nim nie leży) wchodzi w zamek:
      # z pół zamkiem – reszta gniazda od spodu + zamek_min_drewno (20), bez – zwykłe gniazdo + zamek_min_drewno (56).
      def min_wysokosc(p)
        (wlaczony?(p) ? gniazdo_wyzszego(p) : p['zamek']['gniazdo_gleb'].to_f) + p['zamek_min_drewno'].to_f
      end

      # Wierzch bala [mm od spodu] w miejscu x (wzdłuż bala): pełna wysokość, skos dachu wzdłuż bala (skos_gora) albo
      # ścięcie płaszczyzną dachu w poprzek (sciecie_dachu); ktory = :min – na niższym licu, :max – na wyższym.
      def wierzch(b, x, ktory = :min)
        z = b[:h]
        b[:cechy].each do |c|
          next unless x >= c[:x0] - 1e-9 && x <= c[:x1] + 1e-9
          zz = if c[:typ] == 'skos_gora'
                 c[:x1] - c[:x0] < 1e-9 ? [c[:z0], c[:z1]].min : c[:z0] + (c[:z1] - c[:z0]) * (x - c[:x0]) / (c[:x1] - c[:x0])
               elsif c[:typ] == 'sciecie_dachu'
                 ktory == :max ? [c[:z0], c[:z1]].max : [c[:z0], c[:z1]].min
               end
          z = zz if zz && zz < z
        end
        z
      end

      # Najniższy (:min) albo najwyższy (:max) wierzch bala w pasie szerokości szer wokół osi zamka c (współrzędna s
      # ściany bala); nil – bal nie sięga pasa.
      def wierzch_w_pasie(b, c, szer, ktory)
        xs = [c - szer / 2.0, c + szer / 2.0].map { |s| s - b[:s0] }
        return nil if xs[1] <= 0.01 || xs[0] >= b[:dl] - 0.01
        zs = xs.map { |x| wierzch(b, [[x, 0.0].max, b[:dl]].min, ktory) }
        ktory == :max ? zs.max : zs.min
      end

      # Czy bal a (oś zamka ca) sięga bala b leżącego poziom wyżej: wierzch bala a w słupie zamka jest ponad spodem bala b.
      def siega?(a, ca, b, p)
        g = wierzch_w_pasie(a, ca, Parametry.grubosc(p), :max)
        !g.nil? && a[:z0] + g > b[:z0] + 0.01
      end

      # Czy para bali zamka (nizszy, wyzszy w osi cw) to ostatnie połączenie pod dachem: zwykłe gniazdo od spodu zostawia
      # balowi wyższemu pod skosem albo ścięciem dachu mniej niż zamek_min_drewno, żaden bal nie wycina mu gniazda od wierzchu (nad – bale
      # ściany bala niższego w słupie zamka), a balowi niższemu po gnieździe do połowy zostaje dość drewna (pod – bale
      # ściany bala wyższego w słupie zamka: bal poziom pod niższym wycina mu gniazdo od spodu).
      def ostatnie?(nizszy, wyzszy, cw, nad, pod, p)
        return false unless wlaczony?(p)
        z = p['zamek']
        gleb = z['gniazdo_gleb'].to_f
        min = p['zamek_min_drewno'].to_f
        gora = wierzch_w_pasie(wyzszy, cw, z['gniazdo_szer'].to_f, :min)
        return false if gora.nil? || gora >= wyzszy[:h] - 0.01 || gora - gleb >= min - 0.01
        # Bal nad nim liczy się tylko wtedy, gdy wycina w bali wyższym prawdziwe gniazdo od wierzchu (wierzch pod dachem
        # sięga ponad dno tego gniazda); bal ścięty niżej nie ma gniazda górnego i zostaje ostatnim połączeniem.
        gmax = wierzch_w_pasie(wyzszy, cw, Parametry.grubosc(p), :max)
        return false if gmax > wyzszy[:h] - gleb + 0.01 && nad.any? { |x| x[:lvl] == wyzszy[:lvl] + 1 }
        zostaje = nizszy[:h] - gniazdo_nizszego(p) - (pod.any? { |x| x[:lvl] == nizszy[:lvl] - 1 } ? gleb : 0.0)
        zostaje >= min - 0.01
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
