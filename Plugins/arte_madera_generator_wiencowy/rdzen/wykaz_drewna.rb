# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/wykaz_drewna.rb
# Zadanie: wykaz drewna dostępnego w hurtowni (przekroje z długościami handlowymi) – listy fabryczne dla legarów, płatwi, krokwi, belek i słupów zadaszenia oraz odczyt listy przekrojów z długościami z tekstu parametru.
# Tematy: wykaz drewna, przekroje z hurtowni, długości handlowe, lista przekrojów z długościami, format „45x145:4.2/5.4/6”, drewno konstrukcyjne C24, drewno widoczne Nsi / DUO / BSH
# Zależy od: –
# Używają: rdzen/parametry.rb (katalog), rdzen/parametry_podloga.rb, rdzen/parametry_dach.rb, rdzen/parametry_zadaszenie.rb (listy fabryczne), rdzen/dlugosci_handlowe.rb
#
# Wykaz „od ręki” od użytkownika z 2026-11-14 (hurtownia Drewno Partner); przekrój zapisany jako szerokość × wysokość –
# mniejszy wymiar × większy (belka stoi wyższym bokiem w pionie). Zapis w parametrze: „45x145:4.2/5.4/6” – po
# dwukropku długości w metrach rozdzielone ukośnikiem; wpis bez dwukropka = bez ograniczenia długości (listy ze
# starszych kompilacji). Klasa drewna do obliczeń jedna (parametr „Klasa drewna konstrukcyjnego”): Nsi jest sortowane
# do C24, a DUO / TRIO / BSH mają tę samą wytrzymałość na zginanie.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module WykazDrewna
      # Drewno konstrukcyjne C24 (niewidoczne): [szerokość, wysokość, [długości w metrach]].
      KONSTRUKCYJNE = [
        [38, 58, [4.2]], [45, 45, [4.8]], [45, 70, [5.4, 6]], [45, 95, [6]], [45, 120, [5, 5.4]], [45, 145, [4.2, 5.4, 6]],
        [45, 170, [5.4, 6]], [45, 195, [4.2, 5.4, 6]], [45, 220, [5.4, 6]], [45, 245, [5.4, 6]]
      ].freeze unless const_defined?(:KONSTRUKCYJNE)
      # Drewno widoczne (Nsi, klejone DUO / TRIO / BSH): [szerokość, wysokość, [długości w metrach]].
      WIDOCZNE = [
        [45, 195, [7]], [60, 100, [6]], [60, 120, [5, 6]], [60, 140, [5, 6, 7]], [60, 160, [5, 6]], [60, 200, [5, 7]],
        [60, 240, [7]], [80, 160, [4, 5, 6, 7]], [80, 180, [7]], [80, 200, [5, 7, 8]], [80, 220, [7]], [100, 100, [5, 6]],
        [100, 200, [7]], [120, 120, [5, 6]], [120, 200, [7]], [140, 140, [5, 6, 7]], [140, 200, [7]], [140, 240, [7]],
        [160, 160, [5, 6, 7]], [160, 200, [7]], [160, 280, [7]], [200, 200, [7]]
      ].freeze unless const_defined?(:WIDOCZNE)
      # Wartość długości poniżej tej liczby to metry (4.2), od niej – milimetry (4200).
      GRANICA_METROW = 100.0 unless const_defined?(:GRANICA_METROW)

      module_function

      # Tekst listy fabrycznej dla zastosowania: :legary (konstrukcyjne od 45 × 95 i widoczne), :platwie (widoczne
      # prostokątne od szerokości 60), :krokwie (konstrukcyjne od 45 × 145, widoczne o szerokości 60 i 80 × 160 / 200),
      # :slupy (widoczne kwadratowe).
      def lista(zastosowanie)
        wpisy = case zastosowanie
                when :legary then KONSTRUKCYJNE.select { |_b, h, _d| h >= 95 } + WIDOCZNE
                when :platwie then WIDOCZNE.select { |b, h, _d| b >= 60 && h > b }
                when :krokwie
                  KONSTRUKCYJNE.select { |_b, h, _d| h >= 145 } +
                  WIDOCZNE.select { |b, h, _d| b == 45 || (b == 60 && h >= 120) || (b == 80 && [160, 200].include?(h)) }
                else WIDOCZNE.select { |b, h, _d| b == h }
                end
        tekst(scalone(wpisy))
      end

      # Wpisy o tym samym przekroju połączone w jeden (długości razem, rosnąco), w kolejności szerokość, wysokość.
      def scalone(wpisy)
        wg = {}
        wpisy.each { |b, h, d| (wg[[b, h]] ||= []).concat(d) }
        wg.keys.sort.map { |b, h| [b, h, wg[[b, h]].uniq.sort] }
      end

      # Lista wpisów jako tekst parametru: „45x145:4.2/5.4/6, 45x170:5.4/6”.
      def tekst(wpisy)
        wpisy.map do |b, h, d|
          dl = d.map { |x| (x - x.round).abs < 1e-9 ? x.round.to_s : x.to_s }
          dl.empty? ? "#{b}x#{h}" : "#{b}x#{h}:#{dl.join('/')}"
        end.join(', ')
      end

      # Wpisy z tekstu parametru: [[b, h, [długości mm rosnąco]], …]; długości puste – bez ograniczenia. Przekroje
      # rozdzielone przecinkiem, średnikiem albo nowym wierszem; ułamek długości z kropką albo przecinkiem.
      def wpisy(tekst)
        t = tekst.to_s
        trafienia = []
        t.scan(/(\d+(?:\.\d+)?)\s*[x×X*]\s*(\d+(?:\.\d+)?)/) { trafienia << Regexp.last_match }
        wynik = []
        trafienia.each_with_index do |m, i|
          b = m[1].to_f
          h = m[2].to_f
          next unless b > 0 && h > 0
          koniec = i + 1 < trafienia.length ? trafienia[i + 1].begin(0) : t.length
          ogon = t[m.end(0)...koniec].to_s
          dl = ogon =~ /\A\s*:/ ? ogon.scan(/\d+(?:[.,]\d+)?/).map { |x| milimetry(x) }.select { |x| x > 0 }.uniq.sort : []
          wynik << [b, h, dl]
        end
        wynik
      end

      # Długość z tekstu w milimetrach (liczba poniżej 100 – metry).
      def milimetry(tekst)
        x = tekst.to_s.tr(',', '.').to_f
        x < GRANICA_METROW ? x * 1000.0 : x
      end

      # Długości handlowe przekrojów z tekstu parametru: { [mniejszy, większy] => [mm rosnąco] } – tylko wpisy z długościami.
      def dlugosci(tekst)
        wynik = {}
        wpisy(tekst).each do |b, h, dl|
          next if dl.empty?
          k = [b, h].sort
          wynik[k] = ((wynik[k] || []) + dl).uniq.sort
        end
        wynik
      end
    end
  end
end
