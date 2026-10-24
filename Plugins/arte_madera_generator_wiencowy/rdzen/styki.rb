# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/styki.rb
# Zadanie: podział długich ścian na bale – miejsca styków na mijankę (min. 300 mm) w trzech układach, węgły pod styki.
# Tematy: styk, łączenie bali na długość, mijanka, maksymalna długość bala, układ na przemian, para węgłów, jeden węgieł, styk w osi zamka, szczelina styku, kotwice styków
# Zależy od: rdzen/parametry.rb, rdzen/sciany.rb (dodaj_kontrfor), rdzen/otwory.rb (strefy otworów), rdzen/usztywnienie.rb (miejsce_ok?, wolne_miejsce)
# Używają: rdzen/projekt.rb, rdzen/bale.rb (pozycje_w_wiencu)
#
# Wynik w ścianie: w[:styki] = { uklad:, parzyste: [s], nieparzyste: [s], kotwy: [s], nowe: [s] } – styki w wieńcach
# parzystych i nieparzystych (indeks wieńca od 0, od dołu ściany), osie skrzyżowań użytych do łączenia, osie nowych węgłów.
# „na_przemian” (domyślny, jak 1200): kotwice a0 < a1 < … co ≥ mijanka; wieńce parzyste łączą się w a0, a2, …,
#   nieparzyste w a1, a3, … – styk w osi zamka; najpierw istniejące działowe / węgły, nowe węgły tylko gdy trzeba.
# „para” (jak 900 W-2): na każde miejsce łączenia dwa skrzyżowania a < b w odstępie ≥ mijanka; parzyste w a, nieparzyste w b.
# „jeden_wegiel”: jedno skrzyżowanie c, styki w c − mijanka/2 i c + mijanka/2 (poza zamkiem).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'sciany') unless defined?(ArteMadera::GeneratorWiencowy::Sciany)
require File.join(File.dirname(__FILE__), 'otwory') unless defined?(ArteMadera::GeneratorWiencowy::Otwory)
require File.join(File.dirname(__FILE__), 'usztywnienie') unless defined?(ArteMadera::GeneratorWiencowy::Usztywnienie)

module ArteMadera
  module GeneratorWiencowy
    module Styki
      # Krok siatki miejsc na nowy węgieł [mm] (od początku osi ściany – okrągłe odległości od narożnika).
      KROK = 10.0 unless const_defined?(:KROK)
      # Najwięcej kroków przeszukiwania układu na przemian dla jednej liczby kotwic.
      LIMIT_WEZLOW = 3000 unless const_defined?(:LIMIT_WEZLOW)

      module_function

      # Miejsca styków dla wszystkich ścian (zewnętrznych i działowych); dostawia węgły pod styki. Zwraca ostrzeżenia.
      def planuj(sciany, p, os_kalenicy)
        uwagi = []
        sciany.select { |w| w[:rodzaj] != :kontrfor }.each do |w|
          w[:styki] = { uklad: p['styk_uklad'], parzyste: [], nieparzyste: [], kotwy: [], nowe: [] }
          dl = w[:s_do] - w[:s_od]
          next if dl <= p['max_dlugosc'].to_f + 0.01
          wynik = case p['styk_uklad']
                  when 'para', 'jeden_wegiel' then z_regionow(w, p, dobierz_regiony(w, p))
                  else na_przemian(w, p)
                  end
          if wynik.nil?
            uwagi << format('Ściana %s (%.0f mm): nie udało się dobrać miejsc styków przy maksymalnej długości bala %.0f mm ' \
                            '(otwory lub skrzyżowania zajmują miejsce) – bale dłuższe niż dopuszczalne.%s', w[:id], dl, p['max_dlugosc'],
                            w[:wegly_reczne] ? ' Węgły tej ściany ustawione ręcznie – dodaj węgieł w widoku ściany.' : '')
            next
          end
          wynik[:nowe].each { |s| Sciany.dodaj_kontrfor(sciany, w, s, p, :styk, os_kalenicy) }
          w[:styki] = wynik.merge(uklad: p['styk_uklad'])
        end
        uwagi
      end

      # Położenia styków w wieńcu o indeksie i (0 = najniższy wieniec ściany).
      def pozycje_w_wiencu(w, i)
        st = w[:styki]
        return [] if st.nil?
        i.even? ? st[:parzyste] : st[:nieparzyste]
      end

      # Istniejące skrzyżowania wewnątrz ściany, w których może wypaść styk (bez narożników i za blisko otworów). Ściana ze
      # szczytem – tylko węgły: działowa kończy się pod okapem, a styki w wieńcach szczytu też muszą leżeć w zamku.
      def kotwice(w, p)
        t = Parametry.grubosc(p)
        lista = w[:szczyt] ? w[:skrzyzowania].select { |k| k[:inna][:rodzaj] == :kontrfor } : w[:skrzyzowania]
        lista.map { |k| k[:s] }.select { |s| s > t && s < w[:dl_osi] - t && poza_otworami?(w, p, s) }
      end

      # Czy styk w miejscu s jest dość daleko od otworów (styk_odstep_od_otworu, nie bliżej niż węgieł od otworu).
      def poza_otworami?(w, p, s)
        zapas = [p['styk_odstep_od_otworu'].to_f, p['odstep_od_otworu'].to_f + Parametry.grubosc(p) / 2.0].max
        Otwory.strefy_zakazane(w, zapas).none? { |z| s > z[0] - 0.01 && s < z[1] + 0.01 }
      end

      # Czy w miejscu s może stanąć nowy węgieł pod styk (miejsce na węgieł i odstęp styku od otworów).
      def miejsce_styku_ok?(w, p, s, zajete)
        Usztywnienie.miejsce_ok?(w, p, s, zajete) && poza_otworami?(w, p, s)
      end

      # Czy kawałki bali w każdym wieńcu mieszczą się w maksymalnej długości (listy styków: parzyste, nieparzyste).
      def kawalki_ok?(w, listy, lmax)
        listy.all? do |lista|
          punkty = [w[:s_od]] + lista.sort + [w[:s_do]]
          punkty.each_cons(2).all? { |x0, x1| x1 - x0 <= lmax + 0.01 && x1 > x0 }
        end
      end

      # ---------- układ na przemian ----------

      # Układ na przemian: najmniej nowych węgłów, potem najmniej kotwic; nil – nie da się.
      def na_przemian(w, p)
        lmax = p['max_dlugosc'].to_f
        dl = w[:s_do] - w[:s_od]
        kmin = 2 * ((dl / lmax).ceil - 1)
        kotwy = kotwice(w, p)
        siatka = wolna_siatka(w, p)
        najl = nil
        (kmin..(kmin + 4)).each do |k|
          r = przemian_k(w, p, k, kotwy, siatka)
          next if r.nil?
          najl = r if najl.nil? || r[:nowe].length < najl[:nowe].length
          break if najl[:nowe].empty?
        end
        return nil if najl.nil?
        a = najl[:kotwy]
        parz = a.each_with_index.select { |_s, j| j.even? }.map { |s, _j| s }
        nieparz = a.each_with_index.select { |_s, j| j.odd? }.map { |s, _j| s }
        { parzyste: parz, nieparzyste: nieparz, kotwy: a, nowe: najl[:nowe] }
      end

      # Najlepszy układ na przemian dla k kotwic: { kotwy:, nowe:, ocena: } albo nil.
      def przemian_k(w, p, k, kotwy, siatka)
        stan = { najl: nil, wezly: 0 }
        przemian_szukaj(w, p, k, kotwy, siatka, [], [], 0.0, stan)
        stan[:najl]
      end

      # Krok przeszukiwania: następna kotwica – istniejące skrzyżowanie (do 3 najbliższych celu) albo nowy węgieł.
      def przemian_szukaj(w, p, k, kotwy, siatka, a, nowe, odch, stan)
        stan[:wezly] += 1
        return if stan[:wezly] > LIMIT_WEZLOW
        najl = stan[:najl]
        return if najl && nowe.length > najl[:nowe].length
        j = a.length
        if j == k
          parz = a.each_with_index.select { |_s, i| i.even? }.map { |s, _i| s }
          nieparz = a.each_with_index.select { |_s, i| i.odd? }.map { |s, _i| s }
          return unless kawalki_ok?(w, [parz, nieparz], p['max_dlugosc'].to_f)
          ocena = [nowe.length, odch]
          stan[:najl] = { kotwy: a.dup, nowe: nowe.dup, ocena: ocena } if najl.nil? || (ocena <=> najl[:ocena]) < 0
          return
        end
        lo, hi = przemian_zakres(w, p, k, a)
        return if lo > hi + 0.01
        cel = [[w[:s_od] + (j + 1) * (w[:s_do] - w[:s_od]) / (k + 1), lo].max, hi].min
        istn = kotwy.select { |s| s >= lo - 0.01 && s <= hi + 0.01 }.sort_by { |s| (s - cel).abs }.first(3)
        istn.each { |s| przemian_szukaj(w, p, k, kotwy, siatka, a + [s], nowe, odch + (s - cel).abs, stan) }
        x = najblizsze_wolne(siatka, cel, lo, hi, nowe, p['min_odstep_skrzyzowan'].to_f)
        przemian_szukaj(w, p, k, kotwy, siatka, a + [x], nowe + [x], odch + (x - cel).abs, stan) if x
      end

      # Zakres [lo, hi] kotwicy nr a.length: kawałek od poprzedniej kotwicy tej samej parzystości ≤ maks. długość,
      # od poprzedniej kotwicy ≥ mijanka, pozostałe kotwice tej parzystości muszą jeszcze dosięgnąć końca ściany.
      def przemian_zakres(w, p, k, a)
        lmax = p['max_dlugosc'].to_f
        d = p['mijanka'].to_f
        lmin = p['min_odcinek'].to_f
        j = a.length
        pop = j >= 2 ? a[j - 2] : w[:s_od]
        hi = [pop + lmax, w[:s_do] - (k - 1 - j) * d - lmin].min
        lo = [j >= 1 ? a[j - 1] + d : w[:s_od] + lmin, pop + lmin, w[:s_do] - ((k - 1 - j) / 2 + 1) * lmax].max
        [lo, hi]
      end

      # Miejsca (co KROK od początku osi), w których może stanąć nowy węgieł – bez względu na inne nowe węgły.
      def wolna_siatka(w, p)
        wynik = []
        i = (w[:s_od] / KROK).ceil
        while i * KROK < w[:s_do]
          x = i * KROK
          wynik << x if miejsce_styku_ok?(w, p, x, [])
          i += 1
        end
        wynik
      end

      # Najbliższe celu miejsce z siatki w zakresie lo…hi, odległe od zajętych o ≥ min; nil gdy brak.
      def najblizsze_wolne(siatka, cel, lo, hi, zajete, min)
        return nil if siatka.empty?
        prawy = indeks_od(siatka, cel)
        lewy = prawy - 1
        loop do
          xl = lewy >= 0 && siatka[lewy] >= lo - 0.01 ? siatka[lewy] : nil
          xp = prawy < siatka.length && siatka[prawy] <= hi + 0.01 ? siatka[prawy] : nil
          return nil if xl.nil? && xp.nil?
          if xp && (xl.nil? || (xp - cel).abs <= (cel - xl).abs)
            return xp if xp >= lo - 0.01 && zajete.none? { |z| (z - xp).abs < min - 0.01 }
            prawy += 1
          else
            return xl if xl <= hi + 0.01 && zajete.none? { |z| (z - xl).abs < min - 0.01 }
            lewy -= 1
          end
        end
      end

      # Indeks pierwszego elementu posortowanej listy ≥ x (długość listy, gdy brak) – wyszukiwanie połówkowe.
      def indeks_od(lista, x)
        lo = 0
        hi = lista.length
        while lo < hi
          m = (lo + hi) / 2
          lista[m] < x ? lo = m + 1 : hi = m
        end
        lo
      end

      # ---------- układy para i jeden węgieł ----------

      # Regiony łączenia [{ a:, b:, c:, nowe: [s] }] albo nil; próbuje coraz większej liczby bali.
      def dobierz_regiony(w, p)
        lmax = p['max_dlugosc'].to_f
        d = p['mijanka'].to_f
        dl = w[:s_do] - w[:s_od]
        m0 = [(dl / (lmax - d / 2.0)).ceil, 2].max
        (m0..(m0 + 4)).each do |m|
          regiony = proba(w, p, m)
          next if regiony.nil?
          return regiony if kawalki_ok?(w, [regiony.map { |r| r[:a] }, regiony.map { |r| r[:b] }], lmax)
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
          r = najlepszy_region(w, p, cel, okno, zajete, regiony)
          return nil if r.nil?
          zajete.concat(r[:nowe])
          regiony << r
        end
        regiony
      end

      # Najlepszy region przy punkcie cel: najmniej nowych węgłów, potem najbliżej celu; z zachowaniem mijanki względem
      # regionów już wybranych (styki wieńców parzystych i nieparzystych co najmniej mijanka od siebie).
      def najlepszy_region(w, p, cel, okno, zajete, regiony = [])
        kandydaci = p['styk_uklad'] == 'jeden_wegiel' ? kandydaci_jeden(w, p, cel, okno, zajete) : kandydaci_para(w, p, cel, okno, zajete)
        kandydaci = kandydaci.select do |k|
          ((k[:a] + k[:b]) / 2.0 - cel).abs <= okno + 0.01 && mijanka_ok?(regiony + [k], p['mijanka'].to_f)
        end
        kandydaci.min_by { |k| [k[:nowe].length, ((k[:a] + k[:b]) / 2.0 - cel).abs] }
      end

      # Czy styki regionów (a – wieńce parzyste, b – nieparzyste) są w sąsiednich wieńcach co najmniej d od siebie.
      def mijanka_ok?(regiony, d)
        regiony.all? { |r1| regiony.all? { |r2| (r1[:a] - r2[:b]).abs >= d - 0.01 } }
      end

      # Kandydaci układu para: dwie istniejące kotwice, kotwica + nowy węgieł, dwa nowe węgły.
      def kandydaci_para(w, p, cel, okno, zajete)
        d = p['mijanka'].to_f
        dmin = Parametry::MIJANKA_MIN
        kotwy = kotwice(w, p)
        wynik = []
        kotwy.each do |c1|
          kotwy.each do |c2|
            next unless c2 - c1 >= dmin - 0.01 && c2 - c1 <= [2.0 * d, dmin + 600.0].max
            wynik << { a: c1, b: c2, nowe: [] }
          end
          [c1 - d, c1 + d].each do |c2|
            next unless miejsce_styku_ok?(w, p, c2, zajete)
            wynik << { a: [c1, c2].min, b: [c1, c2].max, nowe: [c2] }
          end
        end
        s = Usztywnienie.wolne_miejsce(w, cel, cel - okno, cel + okno) do |x|
          miejsce_styku_ok?(w, p, x - d / 2.0, zajete) && miejsce_styku_ok?(w, p, x + d / 2.0, zajete + [x - d / 2.0])
        end
        wynik << { a: s - d / 2.0, b: s + d / 2.0, nowe: [s - d / 2.0, s + d / 2.0] } if s
        wynik
      end

      # Kandydaci układu jeden węgieł: istniejące kotwice i nowy węgieł; styki ± mijanka/2 poza zamkami i otworami.
      def kandydaci_jeden(w, p, cel, okno, zajete)
        d = p['mijanka'].to_f
        wynik = []
        kotwice(w, p).each do |c|
          wynik << { a: c - d / 2.0, b: c + d / 2.0, c: c, nowe: [] } if styki_poza_zamkami?(w, p, c)
        end
        s = Usztywnienie.wolne_miejsce(w, cel, cel - okno, cel + okno) do |x|
          Usztywnienie.miejsce_ok?(w, p, x, zajete) && styki_poza_zamkami?(w, p, x)
        end
        wynik << { a: s - d / 2.0, b: s + d / 2.0, c: s, nowe: [s] } if s
        wynik
      end

      # Układ jeden węgieł: oba styki x ± mijanka/2 poza zamkami innych skrzyżowań (z zapasem grubości) i z dala od otworów.
      def styki_poza_zamkami?(w, p, x)
        d = p['mijanka'].to_f
        t = Parametry.grubosc(p)
        [x - d / 2.0, x + d / 2.0].all? do |s|
          w[:skrzyzowania].none? { |k| (k[:s] - s).abs < t / 2.0 + t } && poza_otworami?(w, p, s)
        end
      end

      # Wynik ściany z regionów (para / jeden węgieł); nil gdy brak regionów.
      def z_regionow(_w, p, regiony)
        return nil if regiony.nil?
        kotwy = p['styk_uklad'] == 'jeden_wegiel' ? regiony.map { |r| r[:c] } : regiony.map { |r| [r[:a], r[:b]] }.flatten
        { parzyste: regiony.map { |r| r[:a] }, nieparzyste: regiony.map { |r| r[:b] }, kotwy: kotwy,
          nowe: regiony.map { |r| r[:nowe] }.flatten }
      end
    end
  end
end
