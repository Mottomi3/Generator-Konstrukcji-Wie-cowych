# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/podbitka.rb
# Zadanie: podbitka – boazeria widoczna od spodu pod albo na płatwiach (deski wzdłuż spadku), pod albo na krokwiach (deski równolegle do okapu); wybór zależny od układu dachu; co robi aplikacja do dachów (nadbitka KROKU 2); obniżenie linii, pod którą kończą się ściany pod połacią.
# Tematy: podbitka, podbitka pod płatwiami, podbitka na płatwiach, podbitka pod krokwiami, podbitka na krokwiach, boazeria od spodu, deska podbitki, obniżenie ścian pod podbitką, wybór podbitki a układ dachu, podbitka z aplikacji do dachów
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia, płatwie, kąt, jednospadowy), rdzen/elementy.rb
# Używają: rdzen/projekt.rb (belki – elementy Pb), rdzen/pod_dachem.rb i rdzen/szczyty.rb (obniżenie linii pod podbitką), rdzen/krok2.rb (podbitka jako nadbitka KROKU 2)
#
# Dom prostokątny (dom = Szczyty.dom_prostokatny: os, v_a, v_b, u1, u2, wewn). Pola wzdłuż kalenicy (u) – między licami
# wewnętrznymi szczytów (także na działowych); w poprzek (v) – od lica wewnętrznego ściany okapowej do kalenicy
# (jednospadowy – do lica wewnętrznego ściany wysokiej), z przerwą na działowe wzdłuż kalenicy.
# Pod płatwiami: płaszczyzna spodu płatwi = linia podparcia − wysokość płatwi pośredniej (krawędzie spodu płatwi od strony
# kalenicy leżą na jednej prostej), deski wzdłuż spadku, szerokość krycia, ostatnia węższa; dłuższe niż długość handlowa
# – dzielone na osiach płatwi. Pod krokwiami: płaszczyzna = linia podparcia (spód krokwi), deski wzdłuż okapu w pasach
# między płatwiami (płatwie wystają pod krokwie). Na płatwiach: deski wzdłuż spadku spodem na linii podparcia (krokwie
# leżą na nich – Dach.uniesienie_krokwi). Na krokwiach: deski wzdłuż okapu spodem na wierzchu krokwi. Na krokwiach
# i na samych płatwiach z aplikacją do dachów – nadbitka KROKU 2 (przez_aplikacje?), generator jej nie rysuje.
# Ściany pod połacią (działowe w poprzek kalenicy, węgły) kończą się pod podbitką „pod”: linia o obnizenie niżej.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)

module ArteMadera
  module GeneratorWiencowy
    module Podbitka
      module_function

      # Rodzaj podbitki dopuszczalny przy układzie dachu: 'pod_platwiami', 'na_platwiach', 'pod_krokwiami', 'na_krokwiach'
      # albo 'nie'.
      def rodzaj(p)
        r = p['podbitka']
        return r if %w[pod_platwiami na_platwiach].include?(r) && Dach.platwie_posrednie?(p)
        return r if %w[pod_krokwiami na_krokwiach].include?(r) && Dach.krokwie?(p)
        'nie'
      end

      # Czy podbitkę robi aplikacja do dachów jako nadbitkę (pierwszą warstwę poszycia KROKU 2): krokwie i poszycie
      # z aplikacji, podbitka na krokwiach albo na samych płatwiach (bez krokwi).
      def przez_aplikacje?(p)
        return false if p['dach_wiezba'] == 'generator' || !Parametry.tak?(p, 'dach_elementy')
        r = rodzaj(p)
        r == 'na_krokwiach' || (r == 'na_platwiach' && !Dach.krokwie?(p))
      end

      # Uwaga, gdy wybrana podbitka nie pasuje do układu dachu (nil – pasuje).
      def uwaga(p)
        return nil if p['podbitka'].to_s == 'nie' || rodzaj(p) != 'nie'
        'Podbitka: wybrane położenie nie pasuje do układu dachu (pod / na płatwiach – układ z płatwiami pośrednimi, pod / na ' \
          'krokwiach – układ z krokwiami) – pominięta.'
      end

      # O ile niżej od linii podparcia kończą się ściany pod połacią [mm]: grubość podbitki w pionie (pod krokwiami) albo
      # wysokość płatwi + grubość w pionie (pod płatwiami); bez podbitki i podbitka „na” – 0.
      def obnizenie(p)
        g = p['podbitka_grubosc'].to_f / Math.cos(Dach.kat(p))
        case rodzaj(p)
        when 'pod_krokwiami' then g
        when 'pod_platwiami' then wysokosc_platwi(p) + g
        else 0.0
        end
      end

      # Wysokość płatwi pośredniej (spód płatwi wyznacza płaszczyznę podbitki).
      def wysokosc_platwi(p)
        Parametry.przekroj(p, 'platwa_przekroj')[1]
      end

      # Deski podbitki (elementy Pb) domu prostokątnego; sciany – do działowych wzdłuż kalenicy.
      def elementy(dom, p, sciany)
        r = rodzaj(p)
        return [] if dom.nil? || r == 'nie' || przez_aplikacje?(p)
        geo = { v_a: dom[:v_a], v_b: dom[:v_b] }
        przerwy = dzialowe_wzdluz(dom, sciany, p)
        wynik = []
        pola_u(dom, p).each do |u0, u1|
          spadki(geo, p).each do |v0, v1|
            wynik.concat(case r
                         when 'pod_platwiami' then pod_platwiami(dom, geo, p, u0, u1, v0, v1, przerwy)
                         when 'na_platwiach' then na_platwiach(dom, geo, p, u0, u1, v0, v1)
                         when 'pod_krokwiami' then pod_krokwiami(dom, geo, p, u0, u1, v0, v1, przerwy)
                         else na_krokwiach(dom, geo, p, u0, u1, v0, v1)
                         end)
          end
        end
        wynik
      end

      # Pola wzdłuż kalenicy: [[u0, u1]] między licami wewnętrznymi szczytów.
      def pola_u(dom, p)
        t2 = Parametry.grubosc(p) / 2.0
        osie = ([dom[:u1], dom[:u2]] + (dom[:wewn] || [])).sort
        osie.each_cons(2).map { |a, b| [a + t2, b - t2] }.select { |a, b| b - a > 50.0 }
      end

      # Spadki w poprzek: [[v0, v1]] od lica wewnętrznego ściany okapowej (v0) w górę do kalenicy albo do ściany wysokiej (v1).
      def spadki(geo, p)
        t2 = Parametry.grubosc(p) / 2.0
        if Dach.jednospadowy?(p)
          vn, kier = DachJednospadowy.niska(geo, p)
          return [[vn + kier * t2, DachJednospadowy.lico_wysokie_v(geo, p)]]
        end
        vk = (geo[:v_a] + geo[:v_b]) / 2.0
        [[geo[:v_a] + t2, vk], [geo[:v_b] - t2, vk]]
      end

      # Działowe wzdłuż kalenicy (kierunek A) – przedziały v zajęte przez ich grubość: [[lo, hi]].
      def dzialowe_wzdluz(dom, sciany, p)
        iv = dom[:os] == :x ? 1 : 0
        t2 = Parametry.grubosc(p) / 2.0
        sciany.select { |w| w[:rodzaj] == :dzialowa && w[:kierunek] == :A }.map { |w| [w[:a][iv] - t2, w[:a][iv] + t2] }
      end

      # Odcinki v0…v1 (w dowolnej kolejności) bez przedziałów zajętych: [[a, b]] w kierunku od v0 do v1.
      def odcinki(v0, v1, zajete)
        kier = v1 >= v0 ? 1.0 : -1.0
        lo, hi = [v0, v1].sort
        wolne = [[lo, hi]]
        zajete.each do |a, b|
          wolne = wolne.flat_map { |x, y| b <= x || a >= y ? [[x, y]] : [[x, a], [b, y]].select { |m, n| n - m > 1.0 } }
        end
        wolne = wolne.map { |x, y| kier > 0 ? [x, y] : [y, x] }
        kier > 0 ? wolne : wolne.reverse
      end

      # Pod płatwiami: deski wzdłuż spadku na odcinkach v (bez działowych), kolejne w u co krycie (ostatnia węższa),
      # podzielone na osiach płatwi, gdy dłuższe niż długość handlowa.
      def pod_platwiami(dom, geo, p, u0, u1, v0, v1, przerwy)
        g = p['podbitka_grubosc'].to_f
        kr = p['podbitka_krycie'].to_f
        hp = wysokosc_platwi(p)
        a = Dach.kat(p)
        osie = Dach.platwie(geo, p).map { |pl| pl[:v] }
        wynik = []
        odcinki(v0, v1, przerwy).each do |va, vb|
          kier = vb >= va ? 1.0 : -1.0
          # Czoło deski prostopadłe do spadku: górna krawędź początku cofa się o g·sin(kąt) – początek dalej od ściany.
          va += kier * g * Math.sin(a)
          kawalki(va, vb, osie, p['podbitka_dlugosc'].to_f * Math.cos(a)).each do |xa, xb|
            pasy(u0, u1, kr).each do |ua, ub|
              q = Dach.xy(dom, ua, xa)
              d = dom[:os] == :x ? [0.0, kier] : [kier, 0.0]
              z = Dach.linia_podparcia(geo, xa, p) - hp - g / Math.cos(a)
              wynik << deska_ukosna(dom, q, d, a, (xb - xa).abs / Math.cos(a), ub - ua, g, z)
            end
          end
        end
        wynik
      end

      # Na płatwiach: deski wzdłuż spadku spodem na linii podparcia (wierzch płatwi), od lica ściany okapowej do kalenicy
      # (ściany wysokiej), kolejne w u co krycie, podzielone na osiach płatwi, gdy dłuższe niż długość handlowa.
      def na_platwiach(dom, geo, p, u0, u1, v0, v1)
        g = p['podbitka_grubosc'].to_f
        kr = p['podbitka_krycie'].to_f
        a = Dach.kat(p)
        osie = Dach.platwie(geo, p).map { |pl| pl[:v] }
        kier = v1 >= v0 ? 1.0 : -1.0
        if Dach.krokwie?(p) && !Parametry.tak?(p, 'platwa_na_scianie')
          # Ściana nośna (górny bal ścięty do dachu) – deski aż do lica zewnętrznego, krokwie leżą na nich także nad ścianą.
          t = Parametry.grubosc(p)
          v0 -= kier * t
          v1 += kier * t if Dach.jednospadowy?(p)
        end
        d = dom[:os] == :x ? [0.0, kier] : [kier, 0.0]
        wynik = []
        kawalki(v0, v1, osie, p['podbitka_dlugosc'].to_f * Math.cos(a)).each do |xa, xb|
          pasy(u0, u1, kr).each do |ua, ub|
            q = Dach.xy(dom, ua, xa)
            wynik << deska_ukosna(dom, q, d, a, (xb - xa).abs / Math.cos(a), ub - ua, g, Dach.linia_podparcia(geo, xa, p))
          end
        end
        wynik
      end

      # Na krokwiach: deski wzdłuż okapu spodem na wierzchu krokwi, od lica ściany okapowej w górę spadku co krycie
      # (ostatnia węższa); dłuższe niż długość handlowa – dzielone równo.
      def na_krokwiach(dom, geo, p, u0, u1, v0, v1)
        g = p['podbitka_grubosc'].to_f
        kr = p['podbitka_krycie'].to_f
        a = Dach.kat(p)
        nad = Dach.dodatek_krokwi(p)
        n = [((u1 - u0) / p['podbitka_dlugosc'].to_f - 1e-9).ceil, 1].max
        kier = v1 >= v0 ? 1.0 : -1.0
        dl_spadku = (v1 - v0).abs / Math.cos(a)
        wynik = []
        s = 0.0
        while s < dl_spadku - 20.0
          szer = ([kr, dl_spadku - s].min * 10.0).floor / 10.0
          vs = v0 + kier * s * Math.cos(a)
          (0...n).each do |i|
            wynik << deska_wzdluz(dom, geo, p, u0 + (u1 - u0) * i / n, u0 + (u1 - u0) * (i + 1) / n, vs, kier, a, szer, g, nad)
          end
          s += kr
        end
        wynik
      end

      # Deska wzdłuż spadku: belka ukośna o szerokości b (wzdłuż u od punktu q), początek spodu na wysokości z.
      def deska_ukosna(dom, q, d, a, dl, b, g, z)
        e = Elementy.ukosna('Pb', [q[0], q[1], z], d, a, dl, b, g)
        uo = dom[:os] == :x ? [1.0, 0.0] : [0.0, 1.0]
        y = e[:polozenie][:y]
        przes = y[0] * uo[0] + y[1] * uo[1] > 0 ? b / 2.0 : -b / 2.0
        o = e[:polozenie][:poczatek]
        e[:polozenie][:poczatek] = [o[0] + y[0] * przes, o[1] + y[1] * przes, o[2]]
        e
      end

      # Podział odcinka va…vb (rzut) na kawałki nie dłuższe niż lmax (w rzucie), na osiach płatwi; bez płatwi – równo.
      def kawalki(va, vb, osie, lmax)
        lo, hi = [va, vb].sort
        return [[va, vb]] if hi - lo <= lmax + 0.01
        wew = osie.select { |v| v > lo + 1.0 && v < hi - 1.0 }.sort
        ciecia = []
        start = lo
        loop do
          break if hi - start <= lmax + 0.01
          nast = wew.select { |v| v > start + 1.0 && v - start <= lmax + 0.01 }.max
          nast ||= start + lmax
          ciecia << nast
          start = nast
        end
        pkt = [lo] + ciecia + [hi]
        lista = pkt.each_cons(2).to_a
        vb >= va ? lista : lista.reverse.map { |x, y| [y, x] }
      end

      # Pasy szerokości krycia od u0 do u1 (ostatni węższy; szerokość w dół do 0,1 mm – wymiar deski z piły).
      def pasy(u0, u1, kr)
        wynik = []
        u = u0
        while u < u1 - 1.0
          wynik << [u, u + ([kr, u1 - u].min * 10.0).floor / 10.0]
          u += kr
        end
        wynik
      end

      # Pod krokwiami: pasy między płatwiami (i działowymi) wzdłuż spadku, w nich deski wzdłuż okapu, kolejne w górę spadku
      # co krycie (ostatnia węższa); dłuższe niż długość handlowa – dzielone równo.
      def pod_krokwiami(dom, geo, p, u0, u1, v0, v1, przerwy)
        g = p['podbitka_grubosc'].to_f
        kr = p['podbitka_krycie'].to_f
        a = Dach.kat(p)
        zajete = przerwy + Dach.platwie(geo, p).map { |pl| [pl[:v] - pl[:b] / 2.0, pl[:v] + pl[:b] / 2.0] }
        lmax = p['podbitka_dlugosc'].to_f
        n = [((u1 - u0) / lmax - 1e-9).ceil, 1].max
        wynik = []
        odcinki(v0, v1, zajete).each do |va, vb|
          kier = vb >= va ? 1.0 : -1.0
          # Bok deski prostopadły do spadku: dolna krawędź końca wysunięta o g·sin(kąt) – pas krótszy o tyle.
          dl_spadku = ((vb - va).abs - g * Math.sin(a)) / Math.cos(a)
          s = 0.0
          while s < dl_spadku - 20.0
            szer = ([kr, dl_spadku - s].min * 10.0).floor / 10.0
            vs = va + kier * s * Math.cos(a)
            (0...n).each do |i|
              ua = u0 + (u1 - u0) * i / n
              ub = u0 + (u1 - u0) * (i + 1) / n
              wynik << deska_wzdluz(dom, geo, p, ua, ub, vs, kier, a, szer, g)
            end
            s += kr
          end
        end
        wynik
      end

      # Deska wzdłuż okapu u0…u1, dolna krawędź w vs (rzut), szerokość szer w górę spadku; wierzch na spodzie krokwi albo
      # (nad – wysokość płaszczyzny nad linią podparcia) spód na wierzchu krokwi.
      def deska_wzdluz(dom, geo, p, u0, u1, vs, kier, a, szer, g, nad = nil)
        dv = dom[:os] == :x ? [0.0, kier] : [kier, 0.0]
        uo = dom[:os] == :x ? [1.0, 0.0] : [0.0, 1.0]
        y = [dv[0] * Math.cos(a), dv[1] * Math.cos(a), Math.sin(a)]
        z = [-dv[0] * Math.sin(a), -dv[1] * Math.sin(a), Math.cos(a)]
        x = [uo[0], uo[1], 0.0]
        q0 = Dach.xy(dom, u0, vs)
        zs = Dach.linia_podparcia(geo, vs, p)
        gp = g
        if nad
          zs += nad
          gp = 0.0
        end
        o = [q0[0] - z[0] * gp, q0[1] - z[1] * gp, zs - z[2] * gp]
        cross = [x[1] * y[2] - x[2] * y[1], x[2] * y[0] - x[0] * y[2], x[0] * y[1] - x[1] * y[0]]
        if cross[0] * z[0] + cross[1] * z[1] + cross[2] * z[2] < 0
          q1 = Dach.xy(dom, u1, vs)
          o = [q1[0] - z[0] * gp, q1[1] - z[1] * gp, zs - z[2] * gp]
          x = x.map { |c| -c }
        end
        Elementy.nowy('Pb', u1 - u0, szer, g, o, x, y, z, [])
      end
    end
  end
end
