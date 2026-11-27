# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/wycena.rb
# Zadanie: wycena materiału domu (W3) – bale (cena za m³), belki według przekroju z magazynu drewna (cena za m³), deski poszycia i podbitki z wiersza „deska” magazynu, pozostałe materiały z cennika; suma i lista pozycji bez ceny.
# Tematy: wycena, koszt materiału, cena bala, cena belki z magazynu, cena desek, cennik materiałów, pozycje bez ceny, wycena w zestawieniu CSV, fundamenty poza wyceną drewna
# Zależy od: rdzen/parametry.rb, rdzen/magazyn_drewna.rb (wiersz o przekroju, cena), rdzen/projekt.rb (podsumowanie – lista bali i belek), rdzen/materialy.rb (wiersze materiałów)
# Używają: rdzen/projekt.rb (plan[:wycena]), rdzen/zestawienie.rb (blok wyceny w CSV), sketchup/sterowanie.rb (wycena w oknie)
#
# Propozycja W3 (runda 15, przyjęta 2026-11-25): cena przy pozycji magazynu drewna i przy materiałach z W2 → koszt materiału
# domu w oknie i w zestawieniu. Wiersz: { grupa:, nazwa:, ilosc:, jednostka:, cena: (nil – brak), wartosc: (nil – brak) }.
# Deski poszycia i podbitki: objętość ze sztuk o długości handlowej (wymiar „g × s × d”) – razem z zapasem na docinki,
# cena wiersza magazynu ze znacznikiem „Deska” o tej grubości. Elementy Pb (deski rysowane przez generator) liczą się raz –
# w deskach z materiałów, nie w belkach. Ceny są podpowiedzią do oferty, nie kosztorysem (bez robocizny i transportu).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'magazyn_drewna') unless defined?(ArteMadera::GeneratorWiencowy::MagazynDrewna)

module ArteMadera
  module GeneratorWiencowy
    module Wycena
      # Prefiksy bali (ściany, węgły, szczyty, balustrada) – cena bala; reszta listy to belki.
      BALE = %w[Bs Kf Sz].freeze unless const_defined?(:BALE)
      # Elementy listy poza belkami drewna z magazynu: deski Pb (w deskach z materiałów), fundamenty punktowe (beton).
      NIE_DREWNO = %w[Pb F].freeze unless const_defined?(:NIE_DREWNO)

      module_function

      # Wycena planu: { wiersze: [...], suma: zł, bez_ceny: [nazwy], kompletna: true/false }.
      def licz(plan)
        p = plan[:parametry]
        s = plan[:podsumowanie] || {}
        lista = s[:lista] || []
        wiersze = []
        m3_bali = lista.select { |l| BALE.include?(l[:prefiks].to_s) }.inject(0.0) { |a, l| a + l[:objetosc_m3].to_f }
        cb = p['cena_bala'].to_f
        wiersze << wiersz('Drewno', "Bale ścian, węgłów i szczytów (#{s[:przekroj]})", m3_bali.round(3), 'm³', cb > 0 ? cb : nil) if m3_bali > 0
        wiersze.concat(belki(lista, p))
        wiersze.concat(materialy(plan[:materialy] || [], p))
        policzone = wiersze.select { |w| w[:wartosc] }
        { wiersze: wiersze, suma: policzone.inject(0.0) { |a, w| a + w[:wartosc] }.round(2),
          bez_ceny: wiersze.reject { |w| w[:wartosc] }.map { |w| w[:nazwa] }, kompletna: policzone.length == wiersze.length }
      end

      # Wiersz wyceny (wartość = ilość × cena; brak ceny – wartość nil).
      def wiersz(grupa, nazwa, ilosc, jednostka, cena)
        { grupa: grupa, nazwa: nazwa, ilosc: ilosc, jednostka: jednostka, cena: cena,
          wartosc: cena ? (ilosc.to_f * cena).round(2) : nil }
      end

      # Belki (bez bali i desek Pb) zgrupowane po przekroju: m³ × cena wiersza magazynu o tym przekroju.
      def belki(lista, p)
        wg = {}
        lista.each do |l|
          next if BALE.include?(l[:prefiks].to_s) || NIE_DREWNO.include?(l[:prefiks].to_s)
          bh = Parametry.przekroj_z(l[:przekroj].to_s.delete(' '))
          next if bh.nil?
          k = bh.sort
          wg[k] ||= { m3: 0.0, bh: bh, nazwy: [] }
          wg[k][:m3] += l[:objetosc_m3].to_f
          wg[k][:nazwy] << (l[:rodzaj] || l[:prefiks]).to_s
        end
        wg.keys.sort.map do |k|
          g = wg[k]
          r = MagazynDrewna.wiersz(p, g[:bh])
          c = r && r['cena'] && r['cena'] > 0 ? r['cena'] : nil
          wiersz('Drewno', "Belki #{Parametry.tekst_przekroju(k).sub('x', ' × ')} (#{g[:nazwy].uniq.first(3).join(', ')})", g[:m3].round(3), 'm³', c)
        end
      end

      # Materiały (rdzen/materialy.rb): deski w sztukach – objętość × cena deski z magazynu; reszta – cennik (nazwa jako
      # początek nazwy pozycji, ta sama jednostka). Deski w m² i impregnacja w m² (pozycje pomocnicze) – pominięte.
      def materialy(lista, p)
        lista.map do |m|
          if deski?(m)
            next nil unless m[:jednostka] == 'szt.'
            g, sz, d = m[:wymiar].to_s.scan(/\d+(?:[.,]\d+)?/).map { |x| x.tr(',', '.').to_f }
            next nil unless g && sz && d
            m3 = (m[:ilosc].to_f * g * sz * d / 1.0e9).round(3)
            wiersz(m[:grupa], "#{m[:nazwa]} #{m[:wymiar]}", m3, 'm³', cena_deski(p, g))
          else
            c = cena_z_cennika(p, m[:nazwa], m[:jednostka])
            next nil if c.nil? && pomocnicza?(m)
            wiersz(m[:grupa], m[:nazwa], m[:ilosc], m[:jednostka], c)
          end
        end.compact
      end

      # Czy pozycja to deski poszycia albo podbitki.
      def deski?(m)
        m[:grupa].to_s == 'Poszycie dachu' && m[:nazwa].to_s =~ /desk/i
      end

      # Pozycja pomocnicza bez własnej ceny (impregnacja w m² – cena idzie z litrów impregnatu; deski w m²).
      def pomocnicza?(m)
        (m[:grupa].to_s == 'Impregnacja' && m[:jednostka] == 'm²') || (deski?(m) && m[:jednostka] == 'm²')
      end

      # Cena za m³ deski o grubości g z magazynu (wiersz ze znacznikiem „Deska”, ta grubość); nil – brak.
      def cena_deski(p, g)
        r = (p['magazyn_drewna'] || []).find do |x|
          bh = x['deska'] ? WykazDrewna.wpisy(x['przekroj'].to_s).first : nil
          bh && (bh[0] - g).abs < 0.5
        end
        r && r['cena'] && r['cena'] > 0 ? r['cena'] : nil
      end

      # Cena z cennika materiałów dla pozycji (nazwa wiersza cennika = początek nazwy pozycji, wielkość liter bez znaczenia,
      # ta sama jednostka); nil – brak.
      def cena_z_cennika(p, nazwa, jednostka)
        n = nazwa.to_s.downcase
        r = (p['cennik_materialow'] || []).find do |x|
          x['nazwa'].to_s.strip != '' && n.start_with?(x['nazwa'].to_s.strip.downcase) && x['jednostka'].to_s.strip == jednostka.to_s
        end
        r && r['cena'] && r['cena'] > 0 ? r['cena'] : nil
      end

      # Wiersze CSV bloku wyceny: nagłówek, pozycje, suma (liczby z przecinkiem dziesiętnym).
      def wiersze_csv(w)
        return [] if w.nil? || w[:wiersze].empty?
        wynik = [['Wycena', 'Pozycja', 'Ilość', 'Jednostka', 'Cena [zł]', 'Wartość [zł]']]
        w[:wiersze].each do |x|
          wynik << [x[:grupa], x[:nazwa], liczba(x[:ilosc]), x[:jednostka], x[:cena] ? liczba(x[:cena]) : 'brak ceny',
                    x[:wartosc] ? liczba(x[:wartosc]) : '']
        end
        wynik << ['Wycena', w[:kompletna] ? 'Razem' : "Razem (bez #{w[:bez_ceny].length} pozycji bez ceny)", '', '', '', liczba(w[:suma])]
        wynik
      end

      # Liczba do CSV: przecinek dziesiętny, bez zbędnych zer.
      def liczba(v)
        f = v.to_f
        t = (f - f.round).abs < 1e-9 ? f.round.to_s : format('%.3f', f).sub(/0+\z/, '')
        t.tr('.', ',')
      end
    end
  end
end
