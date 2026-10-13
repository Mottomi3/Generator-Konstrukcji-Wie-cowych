# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/styki.rb
# Zadanie: podział długich ścian na bale – wybór miejsc styków na mijankę (min. 300 mm), dostawianie kontrforów.
# Tematy: styk, łączenie bali na długość, mijanka, maksymalna długość bala, kontrfor przy styku, para skrzyżowań, styk w osi zamka, szczelina styku
# Zależy od: rdzen/geometria.rb, rdzen/parametry.rb, rdzen/sciany.rb (dodaj_kontrfor), rdzen/otwory.rb (strefy otworów)
# Używają: rdzen/projekt.rb, rdzen/bale.rb (pozycje_w_wiencu)
#
# Układ „dwa_skrzyzowania” (domyślny, jak 900 W-2): miejsce łączenia = dwa skrzyżowania a < b w odstępie ≥ mijanka
# (istniejące ściany działowe / kontrfory albo nowe kontrfory); w wieńcach parzystych (licząc od dołu, od 0) styk
# w osi a, w nieparzystych w osi b – bale kończą się w połowie zamka i trzyma je kontrfor.
# Układ „jeden_kontrfor”: jedno skrzyżowanie c, styki w c − mijanka/2 i c + mijanka/2 (poza zamkiem).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'geometria') unless defined?(ArteMadera::GeneratorWiencowy::Geometria)
require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'sciany') unless defined?(ArteMadera::GeneratorWiencowy::Sciany)
require File.join(File.dirname(__FILE__), 'otwory') unless defined?(ArteMadera::GeneratorWiencowy::Otwory)

module ArteMadera
  module GeneratorWiencowy
    module Styki
      # Krok przesuwania nowego kontrforu przy szukaniu wolnego miejsca [mm].
      KROK = 10.0 unless const_defined?(:KROK)

      module_function

      # Miejsca styków dla wszystkich ścian (zewnętrznych i działowych); dostawia kontrfory. Zwraca ostrzeżenia.
      def planuj(sciany, p, os_kalenicy)
        uwagi = []
        sciany.select { |w| w[:rodzaj] != :kontrfor }.each do |w|
          w[:styki] = { uklad: p['styk_uklad'], regiony: [] }
          dl = w[:s_do] - w[:s_od]
          next if dl <= p['max_dlugosc'].to_f + 0.01
          regiony = dobierz(w, p)
          if regiony.nil?
            uwagi << format('Ściana %s (%.0f mm): nie udało się dobrać miejsc styków przy maksymalnej długości bala %.0f mm ' \
                            '(otwory lub skrzyżowania zajmują miejsce) – bale dłuższe niż dopuszczalne.', w[:id], dl, p['max_dlugosc'])
            next
          end
          regiony.each do |r|
            r[:nowe].each { |s| Sciany.dodaj_kontrfor(sciany, w, s, p, :styk, os_kalenicy) }
          end
          w[:styki][:regiony] = regiony
        end
        uwagi
      end

      # Regiony łączenia [{ a:, b:, nowe: [s nowych kontrforów] }] albo nil; próbuje coraz większej liczby bali.
      def dobierz(w, p)
        lmax = p['max_dlugosc'].to_f
        d = p['mijanka'].to_f
        dl = w[:s_do] - w[:s_od]
        m0 = [(dl / (lmax - d / 2.0)).ceil, 2].max
        (m0..(m0 + 4)).each do |m|
          regiony = proba(w, p, m)
          return regiony if regiony && kawalki_ok?(w, regiony, lmax)
        end
        nil
      end

      # Jedna próba podziału na m bali: regiony przy punktach docelowych s_od + j·dł/m.
      def proba(w, p, m)
        d = p['mijanka'].to_f
        dl = w[:s_do] - w[:s_od]
        okno = [(p['max_dlugosc'].to_f - d / 2.0 - dl / m) / 2.0, 0.0].max
        zajete = []
        regiony = []
        (1...m).each do |j|
          cel = w[:s_od] + j * dl / m
          r = najlepszy_region(w, p, cel, okno, zajete)
          return nil if r.nil?
          zajete.concat(r[:nowe])
          regiony << r
        end
        regiony
      end

      # Najlepszy region przy punkcie cel: najmniej nowych kontrforów, potem najbliżej celu.
      def najlepszy_region(w, p, cel, okno, zajete)
        d = p['mijanka'].to_f
        dmin = Parametry::MIJANKA_MIN
        jeden = p['styk_uklad'] == 'jeden_kontrfor'
        kotwy = kotwice(w, p)
        kandydaci = []
        if jeden
          kotwy.each do |c|
            kandydaci << { a: c - d / 2.0, b: c + d / 2.0, c: c, nowe: [] } if styki_poza_zamkami?(w, p, c)
          end
          s = wolne_miejsce(w, p, cel, okno, zajete) { |x| miejsce_ok?(w, p, x, zajete) && styki_poza_zamkami?(w, p, x) }
          kandydaci << { a: s - d / 2.0, b: s + d / 2.0, c: s, nowe: [s] } if s
        else
          kotwy.each do |c1|
            kotwy.each do |c2|
              next unless c2 - c1 >= dmin - 0.01 && c2 - c1 <= [2.0 * d, dmin + 600.0].max
              kandydaci << { a: c1, b: c2, nowe: [] }
            end
            [c1 - d, c1 + d].each do |c2|
              next unless miejsce_ok?(w, p, c2, zajete)
              kandydaci << { a: [c1, c2].min, b: [c1, c2].max, nowe: [c2] }
            end
          end
          s = wolne_miejsce(w, p, cel, okno, zajete) do |x|
            miejsce_ok?(w, p, x - d / 2.0, zajete) && miejsce_ok?(w, p, x + d / 2.0, zajete + [x - d / 2.0])
          end
          kandydaci << { a: s - d / 2.0, b: s + d / 2.0, nowe: [s - d / 2.0, s + d / 2.0] } if s
        end
        kandydaci = kandydaci.select { |k| ((k[:a] + k[:b]) / 2.0 - cel).abs <= okno + 0.01 }
        kandydaci.min_by { |k| [k[:nowe].length, ((k[:a] + k[:b]) / 2.0 - cel).abs] }
      end

      # Istniejące skrzyżowania wewnątrz ściany, w których może wypaść styk (bez narożników i otworów).
      def kotwice(w, p)
        t = Parametry.grubosc(p)
        zak = Otwory.strefy_zakazane(w, p['odstep_od_otworu'].to_f)
        w[:skrzyzowania].map { |k| k[:s] }.select do |s|
          s > t && s < w[:dl_osi] - t && zak.none? { |z| s > z[0] && s < z[1] }
        end
      end

      # Czy w miejscu s można postawić nowy kontrfor (odstęp od skrzyżowań, otworów, końców ściany).
      def miejsce_ok?(w, p, s, zajete)
        min = p['min_odstep_skrzyzowan'].to_f
        t = Parametry.grubosc(p)
        o = p['ostatek'].to_f
        return false if s < w[:s_od] + t + o + min || s > w[:s_do] - t - o - min
        return false if w[:skrzyzowania].any? { |k| (k[:s] - s).abs < min - 0.01 }
        return false if zajete.any? { |z| (z - s).abs < min - 0.01 }
        Otwory.strefy_zakazane(w, p['odstep_od_otworu'].to_f + t / 2.0 + o).none? { |z| s > z[0] && s < z[1] }
      end

      # Układ jeden_kontrfor: oba styki x ± mijanka/2 poza zamkami innych skrzyżowań (z zapasem grubości) i poza otworami.
      def styki_poza_zamkami?(w, p, x)
        d = p['mijanka'].to_f
        t = Parametry.grubosc(p)
        [x - d / 2.0, x + d / 2.0].all? do |s|
          w[:skrzyzowania].none? { |k| (k[:s] - s).abs < t / 2.0 + t } &&
            Otwory.strefy_zakazane(w, 0.0).none? { |z| s > z[0] && s < z[1] }
        end
      end

      # Najbliższe celu miejsce (krok KROK, w oknie ± okno), dla którego blok zwraca prawdę; nil gdy brak.
      def wolne_miejsce(w, _p, cel, okno, _zajete)
        kroki = (okno / KROK).floor
        (0..kroki).each do |i|
          [cel - i * KROK, cel + i * KROK].uniq.each do |x|
            next if x <= w[:s_od] || x >= w[:s_do]
            return x if yield(x)
          end
        end
        nil
      end

      # Czy wszystkie kawałki (wieńce parzyste i nieparzyste) mieszczą się w maksymalnej długości.
      def kawalki_ok?(w, regiony, lmax)
        [:a, :b].all? do |klucz|
          punkty = [w[:s_od]] + regiony.map { |r| r[klucz] } + [w[:s_do]]
          punkty.each_cons(2).all? { |x0, x1| x1 - x0 <= lmax + 0.01 && x1 > x0 }
        end
      end

      # Położenia styków w wieńcu o indeksie i (0 = najniższy wieniec ściany).
      def pozycje_w_wiencu(w, i)
        st = w[:styki]
        return [] if st.nil? || st[:regiony].empty?
        st[:regiony].map { |r| i.even? ? r[:a] : r[:b] }
      end
    end
  end
end
