# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/usztywnienie.rb
# Zadanie: węgły 244 usztywniające ściany – limit światła ściany (zwykłej i wysokiej), rozmieszczenie nowych węgłów, miejsce, w którym węgieł może stanąć.
# Tematy: węgieł, wzmocnienie ściany, światło ściany, ściana wysoka, rozmieszczenie węgłów, węgieł od narożnika, miejsce na węgieł, kontrfor
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wysokość ścian), rdzen/sciany.rb (dodaj_kontrfor), rdzen/otwory.rb (strefy otworów)
# Używają: rdzen/projekt.rb, rdzen/styki.rb (miejsce_ok?, wolne_miejsce)
#
# Światło = odległość między licami sąsiednich podparć ściany (narożnik, działowa, węgieł) – oś do osi minus grubość.
# Limit: wegly_max_swiatlo, a dla domu ze ścianami okapowymi wyższymi niż wegly_prog_wysokosci – wegly_max_swiatlo_wysokie.
# Wartości domyślne z projektów: 1800 W-2 – 4756 bez węgła, 1200 (1,5 kondygnacji) – węgieł na ścianie 4 m.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)
require File.join(File.dirname(__FILE__), 'sciany') unless defined?(ArteMadera::GeneratorWiencowy::Sciany)
require File.join(File.dirname(__FILE__), 'otwory') unless defined?(ArteMadera::GeneratorWiencowy::Otwory)

module ArteMadera
  module GeneratorWiencowy
    module Usztywnienie
      # Krok przesuwania nowego węgła przy szukaniu wolnego miejsca [mm].
      KROK = 10.0 unless const_defined?(:KROK)

      module_function

      # Limit światła ściany dla tego domu (zwykły albo dla ścian wysokich) [mm].
      def limit_swiatla(p)
        wysoka = Wience.wysokosci(p)[:okapowa] > p['wegly_prog_wysokosci'].to_f + 0.01
        (wysoka ? p['wegly_max_swiatlo_wysokie'] : p['wegly_max_swiatlo']).to_f
      end

      # Dostawia węgły tam, gdzie światło ściany przekracza limit; zwraca ostrzeżenia.
      def planuj(sciany, p, os_kalenicy)
        uwagi = []
        limit = limit_swiatla(p)
        t = Parametry.grubosc(p)
        do_sprawdzenia = sciany.select do |w|
          w[:rodzaj] == :zewnetrzna || (w[:rodzaj] == :dzialowa && Parametry.tak?(p, 'wegly_na_dzialowych'))
        end
        do_sprawdzenia.each do |w|
          przeslony(w).each do |a, b|
            swiatlo = b - a - t
            next if swiatlo <= limit + 0.5
            if w[:wegly_reczne]
              uwagi << format('Ściana %s: światło %.0f mm dłuższe niż %.0f mm – węgły tej ściany ustawione ręcznie: dodaj węgieł ' \
                              'kliknięciem w widoku ściany albo przywróć automatyczne.', w[:id], swiatlo, limit)
              next
            end
            if p['wegly_rozmieszczenie'] == 'tylko_narysowane'
              uwagi << format('Ściana %s: światło %.0f mm dłuższe niż %.0f mm – narysuj węgieł (krótka linia w poprzek ściany).',
                              w[:id], swiatlo, limit)
              next
            end
            pozycje = rozmiesc(w, p, a, b, limit)
            if pozycje.nil?
              uwagi << format('Ściana %s: światło %.0f mm dłuższe niż %.0f mm, a otwory nie zostawiają miejsca na węgieł.',
                              w[:id], swiatlo, limit)
              next
            end
            pozycje.each { |s| Sciany.dodaj_kontrfor(sciany, w, s, p, :usztywnienie, os_kalenicy) }
          end
        end
        uwagi
      end

      # Odcinki ściany między kolejnymi podparciami: [[s_a, s_b, narożnik_a?, narożnik_b?], …] (osie skrzyżowań).
      def przeslony(w)
        podp = w[:skrzyzowania].map { |k| [k[:s], k[:typ] == :naroznik] }.sort_by { |s, _n| s }
        podp.each_cons(2).map { |(a, na), (b, nb)| [a, b, na, nb] }.select { |a, b, _na, _nb| b - a > 0.5 }
      end

      # Położenia nowych węgłów w odcinku a…b (rozmieszczenie z parametrów); nil – nie da się.
      # „od_naroznikow”: przy każdym narożniku odcinka węgieł w zadanej odległości (symetrycznie), reszta równo.
      def rozmiesc(w, p, a, b, limit)
        t = Parametry.grubosc(p)
        if p['wegly_rozmieszczenie'] == 'od_naroznikow'
          d = p['wegly_odstep_od_naroznika'].to_f
          wynik = []
          lewy = a
          prawy = b
          if naroznik?(w, a) && b - a - 2.0 * t > d
            x = wolne_miejsce(w, a + d, a + t, b - t) { |s| miejsce_ok?(w, p, s, wynik) }
            if x
              wynik << x
              lewy = x
            end
          end
          if naroznik?(w, b) && b - d - lewy >= p['min_odstep_skrzyzowan'].to_f
            x = wolne_miejsce(w, b - d, lewy + t, b - t) { |s| miejsce_ok?(w, p, s, wynik) }
            if x
              wynik << x
              prawy = x
            end
          end
          return wynik if prawy - lewy - t <= limit + 0.5
          reszta = rowno(w, p, lewy, prawy, limit, wynik)
          return reszta.nil? ? nil : wynik + reszta
        end
        rowno(w, p, a, b, limit, [])
      end

      # Węgły równo w odcinku a…b: najmniejsza liczba, przy której każde światło ≤ limit; nil – nie da się.
      def rowno(w, p, a, b, limit, zajete)
        t = Parametry.grubosc(p)
        k = 1
        k += 1 while (b - a) / (k + 1) - t > limit
        (k..(k + 4)).each do |n|
          krok = (b - a) / (n + 1)
          wynik = []
          ok = (1..n).all? do |i|
            cel = a + i * krok
            luz = [(limit + t - krok) / 2.0, 0.0].max
            x = wolne_miejsce(w, cel, cel - luz, cel + luz) { |s| miejsce_ok?(w, p, s, zajete + wynik) }
            wynik << x if x
            !x.nil?
          end
          next unless ok
          punkty = [a] + wynik.sort + [b]
          return wynik if punkty.each_cons(2).all? { |x0, x1| x1 - x0 - t <= limit + 0.5 }
        end
        nil
      end

      # Czy w miejscu s ściany jest narożnik.
      def naroznik?(w, s)
        w[:skrzyzowania].any? { |k| k[:typ] == :naroznik && (k[:s] - s).abs < 1.0 }
      end

      # Czy w miejscu s może stanąć nowy węgieł (odstęp od skrzyżowań, otworów, końców ściany); ściana z węgłami
      # ustawionymi ręcznie – nigdzie (automat jej nie zmienia).
      def miejsce_ok?(w, p, s, zajete)
        return false if w[:wegly_reczne]
        min = p['min_odstep_skrzyzowan'].to_f
        t = Parametry.grubosc(p)
        o = p['ostatek'].to_f
        return false if s < w[:s_od] + t + o + min || s > w[:s_do] - t - o - min
        return false if w[:skrzyzowania].any? { |k| (k[:s] - s).abs < min - 0.01 }
        return false if zajete.any? { |z| (z - s).abs < min - 0.01 }
        Otwory.strefy_zakazane(w, p['odstep_od_otworu'].to_f + t / 2.0).none? { |z| s > z[0] && s < z[1] }
      end

      # Najbliższe celu miejsce w zakresie lo…hi (krok KROK), dla którego blok zwraca prawdę; nil gdy brak.
      def wolne_miejsce(w, cel, lo, hi)
        zasieg = [cel - lo, hi - cel, 0.0].max
        (0..(zasieg / KROK).ceil).each do |i|
          [cel - i * KROK, cel + i * KROK].uniq.each do |x|
            next if x < lo - 0.01 || x > hi + 0.01 || x <= w[:s_od] || x >= w[:s_do]
            return x if yield(x)
          end
        end
        nil
      end
    end
  end
end
