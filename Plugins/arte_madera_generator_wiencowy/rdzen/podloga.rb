# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/podloga.rb
# Zadanie: podłoga domu prostokątnego – podwaliny pod ścianami (zakład w narożnikach), legary między podwalinami, podpory legarów, dobór przekroju i podpowiedzi.
# Tematy: podłoga, podwalina, legar, podpora legarów, rozstaw legarów, kierunek legarów, dobór przekroju legara, izolacja podłogi, podpowiedzi podłogi, zakład podwalin
# Zależy od: rdzen/parametry.rb, rdzen/geometria.rb, rdzen/statyka.rb, rdzen/elementy.rb
# Używają: rdzen/projekt.rb
#
# Poziom 0 = spód pierwszego bala = wierzch podwalin i legarów (legary między podwalinami, wierzchem równo, jak 900).
# Podwaliny ścian zewnętrznych licem równo z licem ściany, w narożnikach na zakład (pół wysokości); pod działowymi – w osi.
# Pola legara: między licami podwalin prostopadłych do legarów („przęsła”); podpory – belki pod legarami w poprzek.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'geometria') unless defined?(ArteMadera::GeneratorWiencowy::Geometria)
require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'statyka') unless defined?(ArteMadera::GeneratorWiencowy::Statyka)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)

module ArteMadera
  module GeneratorWiencowy
    module Podloga
      G = Geometria unless const_defined?(:G)
      # Zapas oparcia doliczany do światła przęsła w obliczeniach [mm].
      OPARCIE = 50.0 unless const_defined?(:OPARCIE)

      module_function

      # Podłoga: { elementy: [...], podpowiedzi: [{ poziom: 'ok' | 'uwaga' | 'blad', tekst: }], legar: [b, h] | nil }.
      def zaplanuj(sciany, p)
        wynik = { elementy: [], podpowiedzi: [], legar: nil, podpory: 0 }
        return wynik unless Parametry.tak?(p, 'podloga')
        zewn = sciany.select { |w| w[:rodzaj] == :zewnetrzna }
        if zewn.length != 4
          wynik[:podpowiedzi] << { poziom: 'uwaga', tekst: 'Podłoga: generowana tylko dla obrysu prostokątnego – pominięta.' }
          return wynik
        end
        u = uklad(sciany, p)
        wynik[:elementy].concat(podwaliny(u, p))
        przekroj, podpory = dobierz(u, p, wynik[:podpowiedzi])
        return wynik if przekroj.nil?
        wynik[:legar] = przekroj
        wynik[:podpory] = podpory.inject(0) { |s, n| s + n }
        wynik[:elementy].concat(legary(u, p, przekroj))
        wynik[:elementy].concat(podpory_elementy(u, p, przekroj, podpory))
        wynik
      end

      # Układ podłogi: kierunek legarów (id – indeks osi wzdłuż legarów), zasięgi, ściany zewnętrzne i działowe z podwalinami.
      def uklad(sciany, p)
        t = Parametry.grubosc(p)
        zewn = sciany.select { |w| w[:rodzaj] == :zewnetrzna }
        xs = zewn.map { |w| [w[:a][0], w[:b][0]] }.flatten
        ys = zewn.map { |w| [w[:a][1], w[:b][1]] }.flatten
        ext = [[xs.min - t / 2.0, xs.max + t / 2.0], [ys.min - t / 2.0, ys.max + t / 2.0]]
        dl = [ext[0][1] - ext[0][0], ext[1][1] - ext[1][0]]
        id = case p['legary_kierunek']
             when 'x' then 0
             when 'y' then 1
             when 'dluzszy' then dl[0] >= dl[1] ? 0 : 1
             else dl[0] <= dl[1] ? 0 : 1
             end
        dz = Parametry.tak?(p, 'podwaliny_pod_dzialowymi') ? sciany.select { |w| w[:rodzaj] == :dzialowa } : []
        { id: id, ie: 1 - id, ext: ext, t: t, dzialowe: dz, pw: Parametry.przekroj(p, 'podwalina_przekroj') }
      end

      # Podwaliny: zewnętrzne licem z licem ściany i na zakład w narożnikach, pod działowymi w osi (dosunięte do podwalin).
      def podwaliny(u, p)
        b, h = u[:pw]
        x0, x1 = u[:ext][0]
        y0, y1 = u[:ext][1]
        wynik = []
        [[[x0, y0], [x1, y0], 'wyciecie_dol'], [[x1, y0], [x1, y1], 'wyciecie_gora'],
         [[x1, y1], [x0, y1], 'wyciecie_dol'], [[x0, y1], [x0, y0], 'wyciecie_gora']].each do |a, c, zakl|
          dl = G.odl(a, c)
          cechy = [{ typ: zakl, x0: 0.0, x1: b, gleb: h / 2.0 }, { typ: zakl, x0: dl - b, x1: dl, gleb: h / 2.0 }]
          wynik << Elementy.pozioma('Pw', a, c, b, h, -h, :lewo, cechy)
        end
        u[:dzialowe].each do |w|
          odcinki_dzialowej(u, w).each do |s0, s1|
            wynik << Elementy.pozioma('Pw', G.add(w[:a], G.mul(w[:kier], s0)), G.add(w[:a], G.mul(w[:kier], s1)), b, h, -h, :os)
          end
        end
        wynik
      end

      # Odcinki podwaliny działowej [s0, s1] na jej osi: końce przy podwalinach innych ścian, działowe wzdłuż legarów
      # przerwane na podwalinach działowych poprzecznych.
      def odcinki_dzialowej(u, w)
        b = u[:pw][0]
        t = u[:t]
        konce = [0.0, w[:dl_osi]].map do |s|
          k = w[:skrzyzowania].find { |x| (x[:s] - s).abs < 1.0 && x[:typ] != :kontrfor }
          kier = s.zero? ? 1.0 : -1.0
          if k.nil? then s
          elsif k[:inna][:rodzaj] == :zewnetrzna then s + kier * (b - t / 2.0)
          else s + kier * b / 2.0
          end
        end
        return [] if konce[1] - konce[0] < 1.0
        zakaz = []
        if wzdluz_legarow?(u, w)
          w[:skrzyzowania].each do |k|
            next unless k[:typ] == :x && k[:inna][:rodzaj] == :dzialowa
            zakaz << [k[:s] - b / 2.0, k[:s] + b / 2.0]
          end
        end
        G.odejmij_przedzialy(konce[0], konce[1], zakaz, 0.5)
      end

      # Czy ściana biegnie wzdłuż legarów.
      def wzdluz_legarow?(u, w)
        (w[:os] == :x ? 0 : 1) == u[:id]
      end

      # Czy działowa przechodzi przez całą szerokość domu (oba końce na ścianach zewnętrznych).
      def pelna?(w)
        [0.0, w[:dl_osi]].all? do |s|
          k = w[:skrzyzowania].find { |x| (x[:s] - s).abs < 1.0 && x[:typ] != :kontrfor }
          k && k[:inna][:rodzaj] == :zewnetrzna
        end
      end

      # Przęsła legarów: [[f1, f2], …] – między licami podwalin prostopadłych do legarów na całej szerokości.
      def przesla(u)
        b = u[:pw][0]
        d0, d1 = u[:ext][u[:id]]
        lica = [[d0 + b, :start]]
        u[:dzialowe].each do |w|
          next if wzdluz_legarow?(u, w) || !pelna?(w)
          c = w[:a][u[:id]]
          lica << [c - b / 2.0, :koniec] << [c + b / 2.0, :start]
        end
        lica << [d1 - b, :koniec]
        lica.sort_by { |x, _r| x }.map { |x, _r| x }.each_slice(2).map { |a, c| [a, c] }.select { |a, c| c - a > 1.0 }
      end

      # Linie legarów (współrzędna e poprzecznie): równo w polach między podwalinami bocznymi i działowymi wzdłuż legarów.
      def linie_legarow(u, p)
        b = u[:pw][0]
        e0, e1 = u[:ext][u[:ie]]
        gr = [e0 + b, e1 - b]
        u[:dzialowe].each do |w|
          next unless wzdluz_legarow?(u, w) && pelna?(w)
          c = w[:a][u[:ie]]
          gr << c - b / 2.0 << c + b / 2.0
        end
        gr.sort.each_slice(2).map do |a, c|
          n = ((c - a) / p['legary_rozstaw'].to_f - 1e-9).ceil - 1
          (1..n).map { |i| a + i * (c - a) / (n + 1) }
        end.flatten
      end

      # Dobór przekroju legara i liczby podpór w każdym przęśle; [[b, h], [podpory w przęsłach]] albo [nil, nil].
      def dobierz(u, p, podp)
        rozstaw = p['legary_rozstaw'].to_f
        gr = Statyka.granica(p)
        przes = przesla(u).map { |a, c| c - a }
        if przes.empty?
          podp << { poziom: 'blad', tekst: 'Podłoga: brak miejsca na legary między podwalinami.' }
          return [nil, nil]
        end
        reczny = p['legary_dobor'] == 'reczny'
        sekcje = reczny ? [Parametry.przekroj(p, 'legar_przekroj')] : Statyka.kandydaci(p)
        if sekcje.empty?
          podp << { poziom: 'blad', tekst: format('Podłoga: żaden przekrój z katalogu nie ma wysokości izolacji %s mm – dopisz wyższe przekroje.',
                                                    Parametry.fmt(p['izolacja_podlogi'])) }
          return [nil, nil]
        end
        najl = nil
        sekcje.each do |b, h|
          lmax = Statyka.max_rozpietosc(b, h, p, rozstaw, gr)
          n = przes.map { |l| podpory_w_przesle(l, lmax, p) }
          next if n.any?(&:nil?)
          ocena = [objetosc(u, p, [b, h], przes, n), n.inject(0) { |s, x| s + x }]
          najl = [[b, h], n, ocena] if najl.nil? || (ocena <=> najl[2]) < 0
        end
        if najl.nil?
          b, h = sekcje.last
          podp << { poziom: 'blad', tekst: format('Podłoga: legar %s nie przenosi obciążenia nawet przy gęstych podporach – zwiększ przekrój.',
                                                    Parametry.tekst_przekroju([b, h])) }
          return [nil, nil]
        end
        podpowiedzi(u, p, najl[0], przes, najl[1], podp)
        [najl[0], najl[1]]
      end

      # Liczba podpór w przęśle długości l przy największej rozpiętości lmax legara; nil – nie da się.
      def podpory_w_przesle(l, lmax, p)
        return nil if lmax < 300.0
        rmax = p['podpory_rozstaw_max'].to_f
        n = rmax > 0 ? [(l / rmax - 1e-9).ceil - 1, 0].max : 0
        n += 1 while n <= 30 && l / (n + 1) + OPARCIE > lmax
        n > 30 ? nil : n
      end

      # Objętość drewna legarów i podpór [m³] – kryterium wyboru między większym przekrojem a podporami.
      def objetosc(u, p, bh, przes, n)
        linie = linie_legarow(u, p).length
        bp, hp = Parametry.przekroj(p, 'podpora_przekroj')
        e0, e1 = u[:ext][u[:ie]]
        szer = e1 - e0 - 2.0 * u[:pw][0]
        leg = linie * przes.inject(0.0) { |s, l| s + l } * bh[0] * bh[1]
        pod = n.inject(0) { |s, x| s + x } * szer * bp * hp
        ((leg + pod) / 1.0e9).round(4)
      end

      # Podpowiedzi do okna: ocena legara, przekroje najmniejszy i zalecany, izolacja, wysokość podwaliny, podpory.
      def podpowiedzi(u, p, bh, przes, n, podp)
        rozstaw = p['legary_rozstaw'].to_f
        g, q = Statyka.obciazenia(p, rozstaw)
        klasa = p['drewno_klasa']
        rozp = przes.each_with_index.map { |l, i| l / (n[i] + 1) + OPARCIE }.max
        s = Statyka.belka(rozp, bh[0], bh[1], g, q, klasa, p['ugiecie_zalecane'].to_f)
        nazwa = Parametry.tekst_przekroju(bh)
        poziom, ocena = if s[:ok] then ['ok', 'spełnia zalecane ugięcie – podłoga sztywna']
                        elsif s[:nosnosc_ok] && s[:l_przez_u] >= p['ugiecie_minimalne'].to_f then ['uwaga', 'spełnia tylko dopuszczalne ugięcie – podłoga sprężysta']
                        else ['blad', 'za słaby – za niski albo za długie przęsło']
                        end
        podp << { poziom: poziom, tekst: format('Legary %s %s co %s mm wzdłuż %s: rozpiętość %s m, nośność %d %%, ugięcie L/%d ' \
                                                 '(zalecane L/%s, dopuszczalne L/%s) – %s.', nazwa, klasa, Parametry.fmt(rozstaw),
                                                 u[:id].zero? ? 'X' : 'Y', format('%.2f', rozp / 1000.0),
                                                 ([s[:wyk_m], s[:wyk_v]].max * 100).round, s[:l_przez_u].round,
                                                 Parametry.fmt(p['ugiecie_zalecane']), Parametry.fmt(p['ugiecie_minimalne']), ocena) }
        lmax = przes.max + OPARCIE
        min = Statyka.dobierz(lmax, p, rozstaw, p['ugiecie_minimalne'].to_f)
        zal = Statyka.dobierz(lmax, p, rozstaw, p['ugiecie_zalecane'].to_f)
        podp << { poziom: 'ok', tekst: format('Bez podpór (rozpiętość %s m): najmniejszy wystarczający przekrój %s, zalecany %s.',
                                              format('%.2f', lmax / 1000.0), min ? Parametry.tekst_przekroju(min) : 'brak w katalogu',
                                              zal ? Parametry.tekst_przekroju(zal) : 'brak w katalogu') }
        izol = p['izolacja_podlogi'].to_f
        if bh[1] < izol - 0.01
          podp << { poziom: 'blad', tekst: format('Legar %s jest niższy niż izolacja %s mm – izolacja się nie zmieści.', nazwa, Parametry.fmt(izol)) }
        elsif izol > 0
          podp << { poziom: 'ok', tekst: format('Izolacja %s mm mieści się między legarami (wysokość legara %s mm).', Parametry.fmt(izol), Parametry.fmt(bh[1])) }
        end
        hp = u[:pw][1]
        if bh[1] > hp + 0.01
          podp << { poziom: 'uwaga', tekst: format('Legar (%s mm) wyższy niż podwalina (%s mm) – spód legara %s mm poniżej spodu podwaliny.',
                                                   Parametry.fmt(bh[1]), Parametry.fmt(hp), Parametry.fmt(bh[1] - hp)) }
        end
        suma = n.inject(0) { |a, x| a + x }
        return if suma.zero?
        podp << { poziom: 'ok', tekst: format('Podpory legarów %s: %d szt. (w przęsłach: %s) – oprzyj je na stopach fundamentowych.',
                                              Parametry.tekst_przekroju(Parametry.przekroj(p, 'podpora_przekroj')), suma, n.join(', ')) }
      end

      # Legary: każda linia dzielona na licach podwalin poprzecznych (także działowych częściowych) i omija podwaliny wzdłuż.
      def legary(u, p, bh)
        b, h = bh
        bp = u[:pw][0]
        d0, d1 = u[:ext][u[:id]]
        wynik = []
        linie_legarow(u, p).each do |e|
          zakaz = []
          u[:dzialowe].each do |w|
            odcinki_dzialowej(u, w).each do |s0, s1|
              pa = G.add(w[:a], G.mul(w[:kier], s0))
              pb = G.add(w[:a], G.mul(w[:kier], s1))
              if wzdluz_legarow?(u, w)
                next if (w[:a][u[:ie]] - e).abs >= (b + bp) / 2.0
                zakaz << [[pa[u[:id]], pb[u[:id]]].min, [pa[u[:id]], pb[u[:id]]].max]
              else
                lo, hi = [pa[u[:ie]], pb[u[:ie]]].sort
                next unless e + b / 2.0 > lo && e - b / 2.0 < hi
                c = w[:a][u[:id]]
                zakaz << [c - bp / 2.0, c + bp / 2.0]
              end
            end
          end
          G.odejmij_przedzialy(d0 + bp, d1 - bp, zakaz, 0.5).each do |a, c|
            next if c - a < 50.0
            wynik << Elementy.pozioma('L', punkt(u, a, e), punkt(u, c, e), b, h, -h, :os)
          end
        end
        wynik
      end

      # Podpory legarów: w każdym przęśle n belek w poprzek, równo, pod legarami (między podwalinami bocznymi).
      def podpory_elementy(u, p, bh, n)
        bp, hp = Parametry.przekroj(p, 'podpora_przekroj')
        b = u[:pw][0]
        e0, e1 = u[:ext][u[:ie]]
        wynik = []
        przesla(u).each_with_index do |(a, c), i|
          k = n[i]
          (1..k).each do |j|
            d = a + j * (c - a) / (k + 1)
            wynik << Elementy.pozioma('Pd', punkt(u, d, e0 + b), punkt(u, d, e1 - b), bp, hp, -bh[1] - hp, :os)
          end
        end
        wynik
      end

      # Punkt rzutu z (d wzdłuż legarów, e w poprzek).
      def punkt(u, d, e)
        u[:id].zero? ? [d, e] : [e, d]
      end
    end
  end
end
