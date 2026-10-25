# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/skos_przy_narozniku.rb
# Zadanie: bale ścięte dachem przy narożnikach – przez narożnik (słup zamka) tylko w prawdziwym zamku; inaczej bal kończy się przy licu wewnętrznym ściany poprzecznej.
# Tematy: bal przy narożniku pod dachem, drewno w zamku przy skosie, mostek nad gniazdem, bal bez zamka przy narożniku, ostatek nad ścianą wysoką, dach jednospadowy przy narożniku, cienki mostek nad gniazdem
# Zależy od: rdzen/parametry.rb, rdzen/bale.rb (skosy, okruch)
# Używają: rdzen/projekt.rb (po Bale.zbuduj, przed Zamek.nanies)
#
# Dotyczy bali ze skosem dachu (szczyt, ściana wysoka dachu jednospadowego, ściana pod połacią) zachodzących na słup
# zamka narożnika [c − t/2, c + t/2]. Bal zostaje w narożniku, gdy ściana poprzeczna ma w słupie bal na sąsiednim
# poziomie i w zamku zostaje dość drewna (zamek_min_drewno): bal na niższym (lvl − 1) – nad gniazdem od spodu, do
# gniazda z góry, gdy jest też bal wyżej; tylko bal wyżej (lvl + 1) – ponad dno gniazda z góry. Drewno liczone
# z wierzchu bala po skosie w obu krawędziach gniazda. Inaczej bal kończy się przy licu wewnętrznym ściany
# poprzecznej: ostatek bez oparcia i cienki mostek nad gniazdem znikają, kawałek krótszy niż okruch – cały.
# Powtarzane do skutku, bo przycięty bal zabiera partnera innym (ściana wysoka i bal szczytu nad nią).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'bale') unless defined?(ArteMadera::GeneratorWiencowy::Bale)

module ArteMadera
  module GeneratorWiencowy
    module SkosPrzyNarozniku
      # Najwięcej przebiegów (każdy usuwa bale z narożników – po kilku nie ma już czego przycinać).
      PRZEBIEGI = 6 unless const_defined?(:PRZEBIEGI)

      module_function

      # Przycięcie bali przy narożnikach (zmienia w[:bale] i wynik[:bale] z Bale.zbuduj); zwraca liczbę przyciętych.
      def przytnij!(sciany, wynik, p)
        razem = 0
        PRZEBIEGI.times do
          zmiany = 0
          sciany.each do |w|
            next unless w[:szczyt] || w[:pod_dachem]
            (w[:skrzyzowania] || []).each do |k|
              next unless k[:typ] == :naroznik
              k2 = partner_skrzyzowania(w, k)
              next if k2.nil?
              (w[:bale] || []).dup.each do |b|
                next unless w_slupie?(b, k[:s], p) && b[:cechy].any? { |c| c[:typ] == 'skos_gora' }
                next if w_zamku?(b, k[:s], k[:inna], k2[:s], p)
                przytnij_bal!(w, b, k[:s], wynik, p)
                zmiany += 1
              end
            end
          end
          razem += zmiany
          break if zmiany.zero?
        end
        razem
      end

      # Skrzyżowanie w drugiej ścianie, odpowiadające skrzyżowaniu k ściany w (ten sam punkt).
      def partner_skrzyzowania(w, k)
        (k[:inna][:skrzyzowania] || []).find do |x|
          x[:inna].equal?(w) && (x[:punkt][0] - k[:punkt][0]).abs < 0.01 && (x[:punkt][1] - k[:punkt][1]).abs < 0.01
        end
      end

      # Czy bal zachodzi na słup zamka w osi c.
      def w_slupie?(b, c, p)
        t = Parametry.grubosc(p)
        b[:s0] < c + t / 2.0 - 0.01 && b[:s1] > c - t / 2.0 + 0.01
      end

      # Czy bal b (oś zamka c) siedzi w zamku z balem ściany w2 (oś zamka c2) i zostaje w nim dość drewna.
      def w_zamku?(b, c, w2, c2, p)
        nizej = (w2[:bale] || []).any? { |x| x[:lvl] == b[:lvl] - 1 && w_slupie?(x, c2, p) }
        wyzej = (w2[:bale] || []).any? { |x| x[:lvl] == b[:lvl] + 1 && w_slupie?(x, c2, p) }
        return false unless nizej || wyzej
        z = p['zamek']
        gleb = z['gniazdo_gleb'].to_f
        gora = wierzch_w_gniezdzie(b, c, z['gniazdo_szer'].to_f)
        return false if gora.nil?
        drewno = if nizej
                   [gora, b[:h] - (wyzej ? gleb : 0.0)].min - gleb
                 else
                   gora - (b[:h] - gleb)
                 end
        drewno >= p['zamek_min_drewno'].to_f - 0.01
      end

      # Najniższy wierzch bala (od spodu, po skosach) w krawędziach gniazda szerokości sz w osi c; nil – bal nie
      # sięga gniazda.
      def wierzch_w_gniezdzie(b, c, sz)
        xs = [c - sz / 2.0, c + sz / 2.0].map { |s| s - b[:s0] }
        return nil if xs[1] <= 0.01 || xs[0] >= b[:dl] - 0.01
        xs.map { |x| wierzch(b, [[x, 0.0].max, b[:dl]].min) }.min
      end

      # Wierzch bala w miejscu x (pełna wysokość albo niżej – skos).
      def wierzch(b, x)
        z = b[:h]
        b[:cechy].each do |c|
          next unless c[:typ] == 'skos_gora' && x >= c[:x0] - 1e-9 && x <= c[:x1] + 1e-9
          zz = c[:x1] - c[:x0] < 1e-9 ? [c[:z0], c[:z1]].min : c[:z0] + (c[:z1] - c[:z0]) * (x - c[:x0]) / (c[:x1] - c[:x0])
          z = zz if zz < z
        end
        z
      end

      # Bal kończy się przy licu wewnętrznym ściany poprzecznej (od strony środka ściany w); krótszy niż okruch – usunięty.
      def przytnij_bal!(w, b, c, wynik, p)
        t = Parametry.grubosc(p)
        poczatek = c < (w[:s_od] + w[:s_do]) / 2.0
        s0 = poczatek ? [b[:s0], c + t / 2.0].max : b[:s0]
        s1 = poczatek ? b[:s1] : [b[:s1], c - t / 2.0].min
        if s1 - s0 < [p['szczyt_min_kawalek'].to_f, Bale::OKRUCH].max
          w[:bale].delete(b)
          wynik[:bale].delete(b)
          return
        end
        przesun = s0 - b[:s0]
        cechy = b[:cechy].reject { |x| x[:typ] == 'skos_gora' }.map do |x|
          x0 = [x[:x0] - przesun, 0.0].max
          x1 = [x[:x1] - przesun, s1 - s0].min
          x1 - x0 > 0.5 ? x.merge(x0: x0, x1: x1) : nil
        end.compact
        b[:konce] = poczatek ? [:wolny, b[:konce][1]] : [b[:konce][0], :wolny]
        b[:s0] = s0
        b[:s1] = s1
        b[:dl] = s1 - s0
        b[:cechy] = cechy + Bale.skosy(w, s0, s1, b[:z0], b[:h], p)
      end
    end
  end
end
