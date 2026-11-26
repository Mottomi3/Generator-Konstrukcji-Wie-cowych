# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/zamek.rb
# Zadanie: obróbki zamka na każdym skrzyżowaniu – gniazda górne/dolne i podcięcia boczne bali (zamek 44 × 146 z rysunku IMG-20250930-WA0005).
# Tematy: zamek, gniazdo górne, gniazdo dolne, podcięcie boczne, labirynt, ustawienie bala licem, luz w zamku, półzamek przy styku
# Zależy od: rdzen/parametry.rb, rdzen/pol_zamka.rb (ostatnie połączenie pod dachem – gniazdo do połowy bala niższego, bal wyższy bez gniazda)
# Używają: rdzen/projekt.rb, testy/t_zamek.rb (sprawdzenie kolizji)
#
# Na skrzyżowaniu w osi c (współrzędna s ściany): gniazdo szerokości gniazdo_szer wycentrowane w c, głębokości gniazdo_gleb
# od wierzchu (bal niższy) i od spodu (bal wyższy) – dla par bali, których poziomy lvl różnią się o 1. Podcięcia
# (głębokość podciecie_gleb, cała wysokość) na obu licach: jedno lico [c − t/2, c + szer/2], drugie [c − szer/2, c + t/2].
# Które lico dostaje który zakres, wynika z ORIENTACJA (sprawdzone testem kolizji – bale poprzeczne odwrócone licem).
# Bal kończący się w osi skrzyżowania (styk w zamku) dostaje połowę gniazda i podcięć.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'pol_zamka') unless defined?(ArteMadera::GeneratorWiencowy::PolZamka)

module ArteMadera
  module GeneratorWiencowy
    module Zamek
      # Kierunek (w układzie lokalnym domu), w którym podcięcie lica o mniejszej współrzędnej wychodzi za lico ściany
      # poprzecznej: ściany wzdłuż X – lico południowe (min y), ściany wzdłuż Y – lico zachodnie (min x).
      ORIENTACJA = { x: -1, y: 1 }.freeze unless const_defined?(:ORIENTACJA)
      # Odbicie lustrzane labiryntu (parametr zamek_odbicie = 'lustro').
      ORIENTACJA_LUSTRO = { x: 1, y: -1 }.freeze unless const_defined?(:ORIENTACJA_LUSTRO)

      module_function

      # Obróbki zamków dla wszystkich skrzyżowań (dopisuje cechy do bali); zwraca liczbę par bali w zamkach.
      # Orientacja – z parametru zamek_odbicie, gdy nie podano. Najpierw ostatnie połączenia pod dachem (od najniższej pary),
      # potem obróbki w kolejności skrzyżowań.
      def nanies(sciany, p, orientacja = nil)
        orientacja ||= p['zamek_odbicie'] == 'lustro' ? ORIENTACJA_LUSTRO : ORIENTACJA
        z = p['zamek']
        pary = pary_bali(sciany, z['grubosc'].to_f)
        ostatnie_polaczenia!(pary, p)
        pary.each do |x|
          nizszy, wyzszy, cn, cw = x[:nizszy], x[:wyzszy], x[:cn], x[:cw]
          if PolZamka.w_osi?(wyzszy, cw)
            # Pół zamka (rdzen/pol_zamka.rb): gniazdo do połowy bala niższego, bal wyższy bez gniazda (albo z resztą).
            gniazdo(nizszy, cn, 'gniazdo_gora', PolZamka.zamek_z_gniazdem(z, PolZamka.gniazdo_nizszego(p)))
            reszta = PolZamka.gniazdo_wyzszego(p)
            gniazdo(wyzszy, cw, 'gniazdo_dol', PolZamka.zamek_z_gniazdem(z, reszta)) if reszta > 0.01
          else
            gniazdo(nizszy, cn, 'gniazdo_gora', z)
            gniazdo(wyzszy, cw, 'gniazdo_dol', z)
          end
          podciecia(nizszy, cn, z, orientacja)
          podciecia(wyzszy, cw, z, orientacja)
        end
        pary.length
      end

      # Ostatnie połączenia pod dachem (rdzen/pol_zamka.rb) wśród par bali – od najniższej: bal wyższy oznaczony jako bal
      # półzamka; para, w której bal półzamka nie sięga bala nad nim, usunięta z listy (żadnych gniazd między nimi).
      def ostatnie_polaczenia!(pary, p)
        zbedne = []
        pary.sort_by { |x| x[:wyzszy][:z0] }.each do |x|
          if PolZamka.w_osi?(x[:nizszy], x[:cn]) && !PolZamka.siega?(x[:nizszy], x[:cn], x[:wyzszy], p)
            zbedne << x
          elsif PolZamka.ostatnie?(x[:nizszy], x[:wyzszy], x[:cw], x[:nad], x[:pod], p)
            PolZamka.oznacz!(x[:wyzszy], x[:cw])
          end
        end
        pary.reject! { |x| zbedne.any? { |y| y.equal?(x) } }
        wspolne_polzamki!(pary, p)
      end

      # Węzeł ścian w jednej linii (rdzen/sciana_w_linii.rb): dwa bale tego samego wieńca stykają się czołami w osi zamka
      # nad tym samym balem niższym, a jego gniazdo jest wspólne. Gdy jeden z nich jest balem półzamka, drugi też nim
      # zostaje (bez gniazda od spodu) – o ile nic na nim nie leży i w zamku ma co najmniej zamek_min_drewno; inaczej
      # zostaje ze zwykłym gniazdem nad głębszym gniazdem bala niższego.
      def wspolne_polzamki!(pary, p)
        szer = p['zamek']['gniazdo_szer'].to_f
        min = p['zamek_min_drewno'].to_f
        pary.select { |x| PolZamka.w_osi?(x[:wyzszy], x[:cw]) }.each do |x|
          pary.each do |y|
            next if y.equal?(x) || !y[:nizszy].equal?(x[:nizszy]) || (y[:cn] - x[:cn]).abs > 0.01
            next if y[:wyzszy][:lvl] != x[:wyzszy][:lvl] || PolZamka.w_osi?(y[:wyzszy], y[:cw])
            next if y[:nad].any? { |b| b[:lvl] == y[:wyzszy][:lvl] + 1 }
            gora = PolZamka.wierzch_w_pasie(y[:wyzszy], y[:cw], szer, :min)
            next if gora.nil? || gora < min - 0.01
            PolZamka.oznacz!(y[:wyzszy], y[:cw])
          end
        end
      end

      # Pary bali w zamkach wszystkich skrzyżowań (poziomy różne o 1): { nizszy:, wyzszy:, cn:, cw: (osie zamka na ścianach
      # obu bali), nad: (bale ściany bala niższego w słupie zamka), pod: (bale ściany bala wyższego w słupie) }.
      def pary_bali(sciany, t)
        pary = []
        sciany.each do |w1|
          w1[:skrzyzowania].each do |k|
            w2 = k[:inna]
            next unless w1[:k] < w2[:k]
            k2 = w2[:skrzyzowania].find { |x| x[:inna].equal?(w1) && odl2(x[:punkt], k[:punkt]) < 0.01 }
            next if k2.nil?
            bale1 = bale_w_zamku(w1, k[:s], t)
            bale2 = bale_w_zamku(w2, k2[:s], t)
            bale1.each do |b1|
              bale2.each do |b2|
                next unless (b1[:lvl] - b2[:lvl]).abs == 1
                pary << if b1[:lvl] < b2[:lvl]
                          { nizszy: b1, wyzszy: b2, cn: k[:s], cw: k2[:s], nad: bale1, pod: bale2 }
                        else
                          { nizszy: b2, wyzszy: b1, cn: k2[:s], cw: k[:s], nad: bale2, pod: bale1 }
                        end
              end
            end
          end
        end
        pary
      end

      # Bale ściany, które zachodzą na słup zamka [c − t/2, c + t/2].
      def bale_w_zamku(w, c, t)
        (w[:bale] || []).select { |b| b[:s0] < c + t / 2.0 - 0.01 && b[:s1] > c - t / 2.0 + 0.01 }
      end

      # Gniazdo (górne lub dolne) w osi c – raz na skrzyżowanie, przycięte do długości bala.
      def gniazdo(b, c, typ, z)
        x0 = c - z['gniazdo_szer'] / 2.0 - b[:s0]
        x1 = c + z['gniazdo_szer'] / 2.0 - b[:s0]
        dodaj_ceche(b, typ: typ, x0: x0, x1: x1, gleb: z['gniazdo_gleb'].to_f, os: c)
      end

      # Podcięcia boczne obu lic bala przy skrzyżowaniu w osi c (strona 0 – lico prawe y = 0, strona 1 – lico lewe y = t).
      def podciecia(b, c, z, orientacja)
        sig = kierunek_lica_prawego(b[:sciana], orientacja)
        [[0, sig], [1, -sig]].each do |strona, kier|
          t = z['grubosc'].to_f
          sz = z['gniazdo_szer'].to_f
          r = kier < 0 ? [c - t / 2.0, c + sz / 2.0] : [c - sz / 2.0, c + t / 2.0]
          dodaj_ceche(b, typ: 'podciecie', strona: strona, x0: r[0] - b[:s0], x1: r[1] - b[:s0],
                         gleb: z['podciecie_gleb'].to_f, os: c)
        end
      end

      # Kierunek (−1 / +1 wzdłuż s ściany), w którym podcięcie lica prawego wychodzi za lico ściany poprzecznej.
      def kierunek_lica_prawego(w, orientacja)
        if w[:os] == :x
          znak_osi = w[:kier][0] > 0 ? 1 : -1
          prawe_min = w[:nor][1] > 0
          sig_min = orientacja[:x]
        else
          znak_osi = w[:kier][1] > 0 ? 1 : -1
          prawe_min = w[:nor][0] > 0
          sig_min = orientacja[:y]
        end
        (prawe_min ? sig_min : -sig_min) * znak_osi
      end

      # Dopisanie cechy przyciętej do bala (pomija powtórkę tej samej obróbki w tej samej osi; z dwóch gniazd w tym samym
      # miejscu zostaje głębsze – gniazdo półzamka pod jednym z dwóch bali stykających się w węźle).
      def dodaj_ceche(b, cecha)
        x0 = [cecha[:x0], 0.0].max
        x1 = [cecha[:x1], b[:dl]].min
        return if x1 - x0 <= 0.01
        c = cecha.merge(x0: x0, x1: x1)
        jest = b[:cechy].find { |e| e[:typ] == c[:typ] && e[:strona] == c[:strona] && (e[:x0] - x0).abs < 0.01 && (e[:x1] - x1).abs < 0.01 }
        if jest
          jest[:gleb] = c[:gleb] if c[:gleb] && jest[:gleb] && c[:gleb] > jest[:gleb]
          return
        end
        b[:cechy] << c
      end

      # Odległość punktów 2D (pomocnicza, bez zależności od geometria.rb).
      def odl2(a, b)
        Math.sqrt((a[0] - b[0])**2 + (a[1] - b[1])**2)
      end
    end
  end
end
