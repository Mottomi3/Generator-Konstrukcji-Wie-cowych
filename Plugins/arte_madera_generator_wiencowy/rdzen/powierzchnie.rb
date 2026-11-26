# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/powierzchnie.rb
# Zadanie: powierzchnie i wysokość domu – powierzchnia zabudowy (po licach zewnętrznych), pomieszczeń (po licach wewnętrznych ścian), tarasu i dachu, wysokość kalenicy nad terenem, limity użytkownika z ostrzeżeniem, rodzaj obrysu.
# Tematy: powierzchnia zabudowy, powierzchnia pomieszczeń, powierzchnia użytkowa, powierzchnia tarasu, powierzchnia dachu w wyniku, wysokość kalenicy, limit powierzchni zabudowy, limit wysokości, teren pod pierwszym balem, rodzaj obrysu, pomieszczenia z rzutu
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia), rdzen/materialy.rb (powierzchnia połaci), rdzen/podbitka.rb
# Używają: rdzen/projekt.rb (plan[:powierzchnie], ostrzeżenia limitów), sketchup/sterowanie.rb (wynik do okna), rdzen/zestawienie.rb (blok w pliku CSV)
#
# Propozycja W1 (runda 15, przyjęta do rundy 16). Pomieszczenia: rzut podzielony liniami lic wszystkich ścian na
# prostokątne pola; pola wolne (wewnątrz obrysu, poza ścianami) łączone w obszary – każdy obszar to pomieszczenie albo
# taras. Ściany są prostopadłe do siebie (generator nie robi narożników 45°), więc wynik jest dokładny; węgły i otwory
# nie zmieniają podziału. Wysokość kalenicy: wierzch konstrukcji dachu (krokwie, deski, płyty) bez pokrycia, liczona od
# terenu – teren leży pod spodem pierwszego bala o parametr „Teren poniżej pierwszego bala”.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module Powierzchnie
      # Obszar mniejszy niż tyle [m²] nie jest pomieszczeniem (szczelina między ścianami).
      MIN_POMIESZCZENIE = 0.25 unless const_defined?(:MIN_POMIESZCZENIE)

      module_function

      # Powierzchnie i wysokość domu z planu: { zabudowa:, taras:, pomieszczenia: [{ nazwa:, m2:, a:, b: }], uzytkowa:,
      # dach:, kalenica: (mm nad spodem pierwszego bala albo nil), wysokosc: (mm nad terenem), rodzaj_obrysu: } – m² z dwoma miejscami.
      def licz(plan)
        p = plan[:parametry]
        obrys = plan[:obrys] || []
        return nil if obrys.length < 3 || (plan[:sciany] || []).empty?
        obszary = obszary(plan)
        taras = obszary.select { |o| o[:taras] }
        pokoje = obszary.reject { |o| o[:taras] }
        pokoje.each_with_index { |o, i| o[:nazwa] = "Pomieszczenie #{i + 1}" }
        dach = Materialy.powierzchnia_dachu(plan)
        kal = kalenica(plan)
        wys = kal || Wience.wysokosci(p)[:okapowa]
        { zabudowa: m2(pole(obrys)), taras: m2(taras.inject(0.0) { |s, o| s + o[:mm2] }),
          pomieszczenia: pokoje.map { |o| { nazwa: o[:nazwa], m2: m2(o[:mm2]), a: o[:a].round, b: o[:b].round, prostokat: o[:prostokat] } },
          uzytkowa: m2(pokoje.inject(0.0) { |s, o| s + o[:mm2] }),
          dach: dach ? (dach[:dach] + dach[:zadaszenie]).round(2) : nil, dach_przyblizony: dach ? dach[:przyblizona] : false,
          kalenica: kal ? kal.round : nil, wysokosc: (wys + p['teren_pod_balem'].to_f).round, rodzaj_obrysu: rodzaj_obrysu(obrys) }
      end

      # mm² → m² z dwoma miejscami po przecinku.
      def m2(mm2)
        (mm2 / 1.0e6).round(2)
      end

      # Pole wielokąta [mm²] (wzór Gaussa; wynik dodatni).
      def pole(pts)
        s = 0.0
        pts.each_with_index do |a, i|
          b = pts[(i + 1) % pts.length]
          s += a[0] * b[1] - b[0] * a[1]
        end
        s.abs / 2.0
      end

      # Rodzaj obrysu: 'prostokat' (4 naroża), 'l' (6 naroży) albo 'inny' – naroża bez punktów leżących na prostej.
      def rodzaj_obrysu(obrys)
        n = obrys.length
        naroza = (0...n).count do |i|
          a = obrys[i - 1]
          b = obrys[i]
          c = obrys[(i + 1) % n]
          ((b[0] - a[0]) * (c[1] - b[1]) - (b[1] - a[1]) * (c[0] - b[0])).abs > 1.0
        end
        return 'prostokat' if naroza == 4
        naroza == 6 ? 'l' : 'inny'
      end

      # Czy punkt (x, y) leży wewnątrz wielokąta (promień w prawo).
      def w_wielokacie?(pts, x, y)
        wewnatrz = false
        pts.each_with_index do |a, i|
          b = pts[(i + 1) % pts.length]
          next unless (a[1] > y) != (b[1] > y)
          wewnatrz = !wewnatrz if x < a[0] + (y - a[1]) * (b[0] - a[0]) / (b[1] - a[1])
        end
        wewnatrz
      end

      # Prostokąty ścian w rzucie (bez węgłów i bez ostatków za skrzyżowaniem): [[x0, y0, x1, y1]] – oś ściany między
      # jej końcami, grubość bala.
      def prostokaty_scian(plan)
        t2 = Parametry.grubosc(plan[:parametry]) / 2.0
        plan[:sciany].reject { |w| w[:rodzaj] == :kontrfor }.map do |w|
          a = w[:a]
          b = w[:b]
          wzdluz_x = (a[0] - b[0]).abs > (a[1] - b[1]).abs
          xs = [a[0], b[0]].sort
          ys = [a[1], b[1]].sort
          wzdluz_x ? [xs[0], ys[0] - t2, xs[1], ys[1] + t2] : [xs[0] - t2, ys[0], xs[1] + t2, ys[1]]
        end
      end

      # Wolne obszary rzutu (pomieszczenia i taras), od największego: [{ mm2:, a:, b: (wymiary prostokąta opisanego),
      # prostokat: (obszar jest prostokątem), taras: }].
      def obszary(plan)
        obrys = plan[:obrys]
        sciany = prostokaty_scian(plan)
        xs = (obrys.map { |q| q[0] } + sciany.flat_map { |r| [r[0], r[2]] }).map { |v| v.round(1) }.uniq.sort
        ys = (obrys.map { |q| q[1] } + sciany.flat_map { |r| [r[1], r[3]] }).map { |v| v.round(1) }.uniq.sort
        wolne = {}
        (0...xs.length - 1).each do |i|
          (0...ys.length - 1).each do |j|
            cx = (xs[i] + xs[i + 1]) / 2.0
            cy = (ys[j] + ys[j + 1]) / 2.0
            next unless w_wielokacie?(obrys, cx, cy)
            next if sciany.any? { |r| cx > r[0] && cx < r[2] && cy > r[1] && cy < r[3] }
            wolne[[i, j]] = true
          end
        end
        taras = (plan[:sciany].map { |w| w[:taras] }.compact.first)
        wynik = []
        until wolne.empty?
          pola = zalej(wolne, wolne.keys.first)
          mm2 = pola.inject(0.0) { |s, (i, j)| s + (xs[i + 1] - xs[i]) * (ys[j + 1] - ys[j]) }
          x0 = pola.map { |i, _j| xs[i] }.min
          x1 = pola.map { |i, _j| xs[i + 1] }.max
          y0 = pola.map { |_i, j| ys[j] }.min
          y1 = pola.map { |_i, j| ys[j + 1] }.max
          next if mm2 < MIN_POMIESZCZENIE * 1.0e6
          a, b = [x1 - x0, y1 - y0].sort.reverse
          wynik << { mm2: mm2, a: a, b: b, prostokat: (mm2 - a * b).abs < 1.0, taras: na_tarasie?(taras, [(x0 + x1) / 2.0, (y0 + y1) / 2.0]) }
        end
        wynik.sort_by { |o| -o[:mm2] }
      end

      # Pola połączone bokami z polem startowym (usuwane ze zbioru wolnych): [[i, j]].
      def zalej(wolne, start)
        kolejka = [start]
        wolne.delete(start)
        wynik = []
        until kolejka.empty?
          i, j = kolejka.pop
          wynik << [i, j]
          [[i + 1, j], [i - 1, j], [i, j + 1], [i, j - 1]].each do |k|
            next unless wolne.delete(k)
            kolejka << k
          end
        end
        wynik
      end

      # Czy punkt leży w pasie tarasu (między ścianą frontową domu a frontem tarasu – rdzen/taras.rb).
      def na_tarasie?(taras, punkt)
        return false if taras.nil?
        u = punkt[taras[:iu]]
        lo, hi = [taras[:u_dom], taras[:u_front]].sort
        u > lo && u < hi
      end

      # Wierzch konstrukcji dachu w najwyższym miejscu [mm nad spodem pierwszego bala]: linia podparcia w kalenicy (dach
      # jednospadowy – na końcu okapu za ścianą wysoką) + krokwie + warstwy poszycia; dom bez szczytów – nil.
      def kalenica(plan)
        p = plan[:parametry]
        return nil unless Parametry.tak?(p, 'szczyty')
        szczyty = plan[:sciany].map { |w| w[:szczyt] }.compact
        return nil if szczyty.empty?
        cos = Math.cos(Dach.kat(p))
        warstwy = (Podbitka.rodzaj(p) == 'na_krokwiach' || (Podbitka.rodzaj(p) == 'na_platwiach' && !Dach.krokwie?(p)) ? p['podbitka_grubosc'].to_f : 0.0) +
                  (Parametry.tak?(p, 'poszycie_deski') ? p['deski_grubosc'].to_f : 0.0) + (Parametry.tak?(p, 'poszycie_osb') ? p['osb_grubosc'].to_f : 0.0)
        szczyty.map do |geo|
          z = if Dach.jednospadowy?(p)
                Dach.linia_podparcia(geo, DachJednospadowy.wysoka_v(geo, p), p) + Dach.tg(p) * (Parametry.grubosc(p) / 2.0 + p['dach_okap_wysoki'].to_f)
              else
                Dach.linia_podparcia(geo, (geo[:v_a] + geo[:v_b]) / 2.0, p)
              end
          z + Dach.dodatek_krokwi(p) + warstwy / cos
        end.max
      end

      # Limity użytkownika: { ostrzezenia: [teksty], podpowiedzi: [{ poziom:, tekst:, sekcja: }] } – przekroczony limit to
      # ostrzeżenie, dotrzymany – pozycja „sprawdzone”; limit 0 – bez sprawdzania.
      def uwagi(pw, p)
        wynik = { ostrzezenia: [], podpowiedzi: [] }
        return wynik if pw.nil?
        [['limit_zabudowy', pw[:zabudowa], 'Powierzchnia zabudowy', 'm²', 1.0], ['limit_wysokosci', pw[:wysokosc], 'Wysokość nad terenem', 'm', 1000.0]].each do |klucz, jest, nazwa, jedn, dziel|
          limit = p[klucz].to_f
          next if limit <= 0.0
          tekst = format('%s %s %s', nazwa, liczba(jest / dziel), jedn)
          if jest > limit + 0.005
            wynik[:ostrzezenia] << format('%s – ponad Twój limit %s %s (o %s %s).', tekst, liczba(limit / dziel), jedn, liczba((jest - limit) / dziel), jedn)
          else
            wynik[:podpowiedzi] << { poziom: 'ok', sekcja: 'powierzchnie', tekst: format('%s – w limicie %s %s.', tekst, liczba(limit / dziel), jedn) }
          end
        end
        wynik
      end

      # Liczba z przecinkiem dziesiętnym, do dwóch miejsc, bez zbędnych zer.
      def liczba(v)
        format('%.2f', v).sub(/0+\z/, '').sub(/\.\z/, '').tr('.', ',')
      end

      # Wiersze do okna i pliku zestawienia: [[nazwa, wartość, jednostka, uwagi]].
      def wiersze(pw)
        return [] if pw.nil?
        w = [['Powierzchnia zabudowy', liczba(pw[:zabudowa]), 'm²', 'po licach zewnętrznych, z tarasem']]
        w << ['Taras', liczba(pw[:taras]), 'm²', 'między ścianą frontową a frontem tarasu'] if pw[:taras] > 0.0
        pw[:pomieszczenia].each do |o|
          w << [o[:nazwa], liczba(o[:m2]), 'm²', format('%d × %d mm%s', o[:a], o[:b], o[:prostokat] ? '' : ' (w obrysie – kształt inny niż prostokąt)')]
        end
        w << ['Pomieszczenia razem', liczba(pw[:uzytkowa]), 'm²', 'po licach wewnętrznych ścian'] if pw[:pomieszczenia].length > 1
        w << ['Dach – połacie', liczba(pw[:dach]), 'm²', pw[:dach_przyblizony] ? 'w przybliżeniu' : 'z okapami'] if pw[:dach]
        w << ['Wysokość nad terenem', liczba(pw[:wysokosc] / 1000.0), 'm',
              pw[:kalenica] ? 'wierzch konstrukcji dachu w najwyższym miejscu, bez pokrycia' : 'wierzch ścian (dom bez dachu)']
        w
      end
    end
  end
end
