# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/podciagi.rb
# Zadanie: podciągi pod legarami – położenia w przęsłach (automatycznie, co najwyżej rozstaw, w liniach fundamentów albo bez podciągów), belki do lica zewnętrznego podwalin pod podwalinami, sprawdzenie podciągu między fundamentami.
# Tematy: podciąg na równo z podwaliną, legary dzielone na podciągu, podciąg, podpora legarów, położenie podciągów, podciągi w liniach fundamentów, podciąg pod podwaliną, podciąg do lica podwalin, wybór podciągów, sprawdzenie podciągu, rozpiętość podciągu
# Zależy od: rdzen/parametry.rb, rdzen/statyka.rb, rdzen/elementy.rb, rdzen/fundamenty.rb (linie i rzędy)
# Używają: rdzen/podloga.rb (dobór legara, elementy, podpowiedzi)
#
# Przęsło legarów [a, c] (między licami podwalin w poprzek legarów, wzdłuż d). Położenia podciągów: lista d w każdym
# przęśle. Tryby (parametr podciagi): auto – tyle, ile wymaga legar (najmniej drewna); tak – co najwyżej
# podpory_rozstaw_max (0 – co najmniej jeden); nie – bez podciągów. Z fundamentami punktowymi (auto, tak) podciągi leżą
# w wewnętrznych liniach siatki fundamentów (stałe położenia – legar dobierany do największej luki).
# Podciąg biegnie w poprzek legarów od lica zewnętrznego do lica zewnętrznego podwalin, pod nimi (wymóg użytkownika,
# runda 7): wierzch na spodzie wyższego z legara i podwaliny.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'geometria') unless defined?(ArteMadera::GeneratorWiencowy::Geometria)
require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'statyka') unless defined?(ArteMadera::GeneratorWiencowy::Statyka)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)
require File.join(File.dirname(__FILE__), 'fundamenty') unless defined?(ArteMadera::GeneratorWiencowy::Fundamenty)

module ArteMadera
  module GeneratorWiencowy
    module Podciagi
      G = Geometria unless const_defined?(:G)
      # Zapas oparcia doliczany do światła przęsła w obliczeniach [mm] (jak w rdzen/podloga.rb).
      OPARCIE = 50.0 unless const_defined?(:OPARCIE)

      module_function

      # Czy podciągi mają stałe położenia w liniach fundamentów.
      def w_liniach_fundamentow?(p)
        Fundamenty.wlaczone?(p) && p['podciagi'] != 'nie'
      end

      # Stałe położenia (linie fundamentów) w przęsłach: [[d]] – linie wewnątrz przęsła, dalej niż 100 mm od jego lic.
      def stale(u, p, przesla)
        linie = Fundamenty.linie_podciagow(u, p)
        przesla.map { |a, c| linie.select { |d| d > a + 100.0 && d < c - 100.0 } }
      end

      # Położenia w przęsłach dla legara o największej rozpiętości lmax: [[d]] albo nil (legar nie da rady).
      def polozenia(u, p, przesla, lmax)
        if w_liniach_fundamentow?(p)
          poz = stale(u, p, przesla)
          return nil if luka(przesla, poz) + OPARCIE > lmax
          return poz
        end
        przesla.map do |a, c|
          n = liczba(c - a, lmax, p)
          return nil if n.nil?
          (1..n).map { |j| a + j * (c - a) / (n + 1) }
        end
      end

      # Liczba podciągów w przęśle długości l przy największej rozpiętości lmax legara; nil – nie da się.
      def liczba(l, lmax, p)
        return nil if lmax < 300.0
        if p['podciagi'] == 'nie'
          return l + OPARCIE > lmax ? nil : 0
        end
        rmax = p['podpory_rozstaw_max'].to_f
        n = rmax > 0 ? [(l / rmax - 1e-9).ceil - 1, 0].max : 0
        n = [n, 1].max if p['podciagi'] == 'tak'
        n += 1 while n <= 30 && l / (n + 1) + OPARCIE > lmax
        n > 30 ? nil : n
      end

      # Największa luka legara (między licem podwaliny a podciągiem albo między podciągami) [mm].
      def luka(przesla, poz)
        przesla.each_with_index.map do |(a, c), i|
          pkt = [a] + poz[i].sort + [c]
          pkt.each_cons(2).map { |x, y| y - x }.max
        end.max || 0.0
      end

      # Czy podciąg na równo z podwaliną (między podwalinami, legary dzielone na nim).
      def rowno?(p)
        p['podciag_poziom'] == 'rowno'
      end

      # Wierzch podciągu [mm]: obniżony – spód wyższego z legara i podwaliny (pod podwalinami); na równo – 0 (wierzch podwalin).
      def z_wierzchu(u, h_legara, p = {})
        return 0.0 if rowno?(p)
        -[h_legara, u[:pw][1]].max
      end

      # Belki podciągów (Pd) w liniach d w poprzek legarów: obniżony – od lica do lica obrysu; na równo – między licami
      # wewnętrznymi podwalin, przerwany na podwalinach działowych wzdłuż legarów; punkt – blok (d, e) → rzut.
      def elementy(u, p, poz, h_legara)
        bp, hp = Parametry.przekroj(p, 'podpora_przekroj')
        e0, e1 = u[:ext][u[:ie]]
        z = z_wierzchu(u, h_legara, p)
        poz.flatten.flat_map do |d|
          odcinki(u, p, d, e0, e1).map { |a, c| Elementy.pozioma('Pd', yield(d, a), yield(d, c), bp, hp, z - hp, :os) }
        end
      end

      # Odcinki podciągu w linii d: obniżony – cały obrys; na równo – między podwalinami (zewnętrznymi i działowymi
      # wzdłuż legarów, które linia przecina).
      def odcinki(u, p, d, e0, e1)
        return [[e0, e1]] unless rowno?(p)
        b = u[:pw][0]
        zakaz = (u[:dzialowe] || []).select { |w| (w[:a][u[:ie]] - w[:b][u[:ie]]).abs < 0.5 }.select do |w|
          lo, hi = [w[:a][u[:id]], w[:b][u[:id]]].sort
          d > lo && d < hi
        end.map { |w| [w[:a][u[:ie]] - b / 2.0, w[:a][u[:ie]] + b / 2.0] }
        G.odejmij_przedzialy(e0 + b, e1 - b, zakaz, 0.5).select { |a, c| c - a > 50.0 }
      end

      # Podpowiedzi o podciągach: liczba, odstęp od legarów (podwalina wyższa), sprawdzenie między fundamentami.
      def podpowiedzi(u, p, poz, h_legara, przesla)
        wynik = []
        suma = poz.flatten.length
        return wynik if suma.zero?
        nazwa = Parametry.tekst_przekroju(Parametry.przekroj(p, 'podpora_przekroj'))
        gdzie = rowno?(p) ? 'na równo z podwalinami, między nimi – legary dzielone na podciągach' : 'od lica do lica podwalin, pod podwalinami'
        wynik << { poziom: 'ok', tekst: format('Podciągi %s pod legarami: %d szt. – %s%s.', nazwa, suma, gdzie,
                                               Fundamenty.wlaczone?(p) ? ', na fundamentach punktowych' : ' – oprzyj je na stopach fundamentowych') }
        if u[:pw][1] > h_legara + 0.01 && !rowno?(p)
          wynik << { poziom: 'uwaga', tekst: format('Podwalina (%s mm) wyższa niż legar (%s mm) – pod legarami nad podciągiem %s mm ' \
                                                    'podkładki albo wyższy legar.', Parametry.fmt(u[:pw][1]), Parametry.fmt(h_legara),
                                                    Parametry.fmt(u[:pw][1] - h_legara)) }
        end
        wynik << sprawdzenie(u, p, poz, przesla) if Fundamenty.wlaczone?(p)
        wynik
      end

      # Sprawdzenie najbardziej obciążonego podciągu: rozpiętość między fundamentami (rzędy e), szerokość zbierania
      # (połowa luk po obu stronach).
      def sprawdzenie(u, p, poz, przesla)
        e = Fundamenty.siatka(u, p)[:e]
        l = e.each_cons(2).map { |a, b| b - a }.max || 0.0
        szer = przesla.each_with_index.map do |(a, c), i|
          pkt = [a] + poz[i].sort + [c]
          (1...(pkt.length - 1)).map { |k| (pkt[k + 1] - pkt[k - 1]) / 2.0 }.max || 0.0
        end.max
        bp, hp = Parametry.przekroj(p, 'podpora_przekroj')
        g, q = Statyka.obciazenia(p, szer)
        s = Statyka.belka(l, bp, hp, g, q, p['drewno_klasa'], p['ugiecie_minimalne'].to_f)
        nazwa = Parametry.tekst_przekroju([bp, hp])
        txt = format('Podciąg %s między fundamentami co %s m (zbiera %s m podłogi): nośność %d %%, ugięcie L/%d', nazwa,
                     format('%.2f', l / 1000.0), format('%.2f', szer / 1000.0), ([s[:wyk_m], s[:wyk_v]].max * 100).round, s[:l_przez_u].round)
        return { poziom: 'ok', tekst: txt + ' – wystarczy.' } if s[:ok]
        lepszy = Parametry.katalog(p).sort_by { |b, h| [b * h, -h] }.find do |b, h|
          Statyka.belka(l, b, h, g, q, p['drewno_klasa'], p['ugiecie_minimalne'].to_f)[:ok]
        end
        { poziom: 'blad', tekst: txt + format(' – za słaby: %szmniejsz rozstaw fundamentów (dodatkowy rząd w poprzek, np. co %s mm).',
                                              lepszy ? "podciąg #{Parametry.tekst_przekroju(lepszy)} albo z" : 'z',
                                              Parametry.fmt(((l * 0.75) / 50.0).floor * 50.0)) }
      end
    end
  end
end
