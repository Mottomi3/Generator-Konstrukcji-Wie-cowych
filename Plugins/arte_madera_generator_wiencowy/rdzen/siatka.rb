# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/siatka.rb
# Zadanie: siatka ścian (płaskich wielokątów z otworami) zamkniętej bryły bala z profilu – do budowy komponentu w SketchUpie.
# Tematy: siatka, ściany bryły, wielokąt z otworem, scalanie ścian współpłaszczyznowych, punkty T, bryła zamknięta, objętość siatki, pasy przekroju, siatka pełnego profilu
# Zależy od: rdzen/bryla.rb (profil prosty), rdzen/profil_bala.rb (pasy pełnego profilu)
# Używają: sketchup/budowa.rb, testy/t_siatka.rb
#
# Przedział profilu ma pasy wzdłuż grubości (bal prosty – jeden pas y0…y1, pełny profil – pasy z piórem i wpustem).
# Kroki: ściany pasów (wierzch, spód), boki na granicach pasów (część pasa, której nie zakrywa sąsiedni pas – trapezy),
# czoła na granicach przedziałów (różnica przekrojów z sąsiednich przedziałów, komórki siatki y × z) → wstawienie
# wierzchołków leżących na krawędziach (punkty T) → scalenie ścian w tej samej płaszczyźnie (znoszenie krawędzi
# przeciwnych) → pętle zewnętrzne i otwory.
# Wynik: [{ normalna: [x, y, z], petle: [zewnętrzna, otwór…] }] – punkty [x, y, z] w mm układu bala.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'bryla') unless defined?(ArteMadera::GeneratorWiencowy::Bryla)

module ArteMadera
  module GeneratorWiencowy
    module Siatka
      # Krok klucza wierzchołka [mm].
      KLUCZ = 0.0005 unless const_defined?(:KLUCZ)

      module_function

      # Siatka bryły z profilu (patrz Bryla.profil): { sciany: [...], wierzcholki: n }.
      def z_profilu(prof)
        surowe = sciany_surowe(prof)
        uzgodnione = punkty_t(surowe)
        sciany = scal(uzgodnione)
        { sciany: sciany, surowe: uzgodnione }
      end

      # Ściany przedziałów i czoła, każda: { n: normalna, p: [punkty] } (kolejność przeciwna do wskazówek patrząc z zewnątrz).
      def sciany_surowe(prof)
        f = []
        lista = prof.map { |q| [q[:xa], q[:xb], pasy(q)] }
        lista.each do |xa, xb, ps|
          ps.each do |q|
            f << { n: normalna([[xa, q[:y0], q[:zt_a]], [xb, q[:y0], q[:zt_b]], [xb, q[:y1], q[:zt_b]]]),
                   p: [[xa, q[:y0], q[:zt_a]], [xb, q[:y0], q[:zt_b]], [xb, q[:y1], q[:zt_b]], [xa, q[:y1], q[:zt_a]]] }
            f << { n: normalna([[xa, q[:y0], q[:zb_a]], [xa, q[:y1], q[:zb_a]], [xb, q[:y1], q[:zb_b]]]),
                   p: [[xa, q[:y0], q[:zb_a]], [xa, q[:y1], q[:zb_a]], [xb, q[:y1], q[:zb_b]], [xb, q[:y0], q[:zb_b]]] }
          end
          f.concat(boki_y(xa, xb, ps))
        end
        lista.each_with_index do |(xa, xb, ps), i|
          lewy = i > 0 && (lista[i - 1][1] - xa).abs < Bryla::EPS ? lista[i - 1][2] : nil
          f.concat(czolo(xa, lewy, ps))
          prawy = i < lista.length - 1 && (lista[i + 1][0] - xb).abs < Bryla::EPS
          f.concat(czolo(xb, ps, nil)) unless prawy
        end
        f
      end

      # Pasy przedziału: pełny profil – lista pasy, profil prosty – jeden pas y0…y1.
      def pasy(q)
        q[:pasy] || [{ y0: q[:y0], y1: q[:y1], zb_a: q[:zb_a], zb_b: q[:zb_b], zt_a: q[:zt_a], zt_b: q[:zt_b] }]
      end

      # Boki pasów przedziału xa…xb na granicach y: część pasa niezakryta przez pas sąsiedni (po drugiej stronie granicy).
      def boki_y(xa, xb, ps)
        wynik = []
        ys = ps.map { |q| [q[:y0], q[:y1]] }.flatten.map { |y| y.round(6) }.uniq.sort
        ys.each do |y|
          lewy = ps.find { |q| (q[:y1] - y).abs < Bryla::EPS }
          prawy = ps.find { |q| (q[:y0] - y).abs < Bryla::EPS }
          roznica(lewy, prawy).each { |dol, gora| wynik.concat(trapez(xa, xb, y, dol, gora, 1.0)) } if lewy
          roznica(prawy, lewy).each { |dol, gora| wynik.concat(trapez(xa, xb, y, dol, gora, -1.0)) } if prawy
        end
        wynik
      end

      # Część pasa a niezakryta przez pas b (nil – cały): [[spód [z_a, z_b], wierzch [z_a, z_b]]] – do dwóch trapezów.
      def roznica(a, b)
        return [[[a[:zb_a], a[:zb_b]], [a[:zt_a], a[:zt_b]]]] if b.nil?
        wynik = []
        dol = [[a[:zt_a], b[:zb_a]].min, [a[:zt_b], b[:zb_b]].min]
        wynik << [[a[:zb_a], a[:zb_b]], [[dol[0], a[:zb_a]].max, [dol[1], a[:zb_b]].max]]
        gora = [[a[:zb_a], b[:zt_a]].max, [a[:zb_b], b[:zt_b]].max]
        wynik << [[[gora[0], a[:zt_a]].min, [gora[1], a[:zt_b]].min], [a[:zt_a], a[:zt_b]]]
        wynik
      end

      # Trapez boku w płaszczyźnie y od spodu dol do wierzchu gora (normalna ±y); [] gdy zerowej wysokości.
      def trapez(xa, xb, y, dol, gora, kier)
        return [] if gora[0] - dol[0] <= Bryla::EPS && gora[1] - dol[1] <= Bryla::EPS
        pkt = if kier > 0
                [[xa, y, gora[0]], [xb, y, gora[1]], [xb, y, dol[1]], [xa, y, dol[0]]]
              else
                [[xa, y, dol[0]], [xb, y, dol[1]], [xb, y, gora[1]], [xa, y, gora[0]]]
              end
        pkt = bez_powtorzen(pkt)
        pkt.length >= 3 ? [{ n: [0.0, kier, 0.0], p: pkt }] : []
      end

      # Czoło w płaszczyźnie x: komórki przekroju lewego bez prawego (normalna +x) i prawego bez lewego (−x); przekroje
      # z pasów (lewy – wartości na końcu b, prawy – na początku a).
      def czolo(x, lewe, prawe)
        pl = (lewe || []).map { |q| [q[:y0], q[:y1], q[:zb_b], q[:zt_b]] }
        pp = (prawe || []).map { |q| [q[:y0], q[:y1], q[:zb_a], q[:zt_a]] }
        ys = []
        zs = []
        (pl + pp).each do |r|
          ys << r[0] << r[1]
          zs << r[2] << r[3]
        end
        ys = ys.sort.uniq
        zs = zs.sort.uniq
        wynik = []
        w = lambda { |lista, ym, zm| lista.any? { |r| ym > r[0] && ym < r[1] && zm > r[2] && zm < r[3] } }
        ys.each_cons(2) do |y0, y1|
          zs.each_cons(2) do |z0, z1|
            ym = (y0 + y1) / 2.0
            zm = (z0 + z1) / 2.0
            w_l = w.call(pl, ym, zm)
            w_p = w.call(pp, ym, zm)
            if w_l && !w_p
              wynik << { n: [1.0, 0.0, 0.0], p: [[x, y0, z0], [x, y1, z0], [x, y1, z1], [x, y0, z1]] }
            elsif w_p && !w_l
              wynik << { n: [-1.0, 0.0, 0.0], p: [[x, y0, z0], [x, y0, z1], [x, y1, z1], [x, y1, z0]] }
            end
          end
        end
        wynik
      end

      # Normalna jednostkowa trójkąta a, b, c.
      def normalna(pts)
        a, b, c = pts
        u = [b[0] - a[0], b[1] - a[1], b[2] - a[2]]
        v = [c[0] - a[0], c[1] - a[1], c[2] - a[2]]
        n = [u[1] * v[2] - u[2] * v[1], u[2] * v[0] - u[0] * v[2], u[0] * v[1] - u[1] * v[0]]
        d = Math.sqrt(n[0] * n[0] + n[1] * n[1] + n[2] * n[2])
        d < 1e-12 ? [0.0, 0.0, 1.0] : n.map { |c2| c2 / d }
      end

      # Klucz wierzchołka (zaokrąglone współrzędne).
      def klucz(pt)
        [(pt[0] / KLUCZ).round, (pt[1] / KLUCZ).round, (pt[2] / KLUCZ).round]
      end

      # Wstawia do krawędzi ścian wierzchołki innych ścian, które na nich leżą (siatka bez punktów T).
      def punkty_t(sciany)
        wszystkie = {}
        sciany.each { |s| s[:p].each { |pt| wszystkie[klucz(pt)] = pt } }
        indeks = indeks_osi(wszystkie)
        sciany.map do |s|
          nowe = []
          n = s[:p].length
          n.times do |i|
            a = s[:p][i]
            b = s[:p][(i + 1) % n]
            nowe << a
            nowe.concat(na_krawedzi(a, b, kandydaci(a, b, indeks)))
          end
          { n: s[:n], p: bez_powtorzen(nowe) }
        end
      end

      # Indeks wierzchołków dla krawędzi równoległych do osi: klucz pozostałych dwóch współrzędnych → punkty.
      def indeks_osi(wszystkie)
        idx = { 0 => {}, 1 => {}, 2 => {}, :wszystkie => wszystkie.values }
        wszystkie.each do |k, pt|
          (idx[0][[k[1], k[2]]] ||= []) << pt
          (idx[1][[k[0], k[2]]] ||= []) << pt
          (idx[2][[k[0], k[1]]] ||= []) << pt
        end
        idx
      end

      # Wierzchołki, które mogą leżeć na krawędzi a–b (dla krawędzi wzdłuż osi – tylko z tej samej prostej).
      def kandydaci(a, b, idx)
        ka = klucz(a)
        kb = klucz(b)
        return idx[0][[ka[1], ka[2]]] || [] if ka[1] == kb[1] && ka[2] == kb[2]
        return idx[1][[ka[0], ka[2]]] || [] if ka[0] == kb[0] && ka[2] == kb[2]
        return idx[2][[ka[0], ka[1]]] || [] if ka[0] == kb[0] && ka[1] == kb[1]
        idx[:wszystkie]
      end

      # Wierzchołki leżące wewnątrz odcinka a–b, uporządkowane od a.
      def na_krawedzi(a, b, lista)
        d = [b[0] - a[0], b[1] - a[1], b[2] - a[2]]
        dl2 = d[0] * d[0] + d[1] * d[1] + d[2] * d[2]
        return [] if dl2 < 1e-12
        min = a.zip(b).map { |u, v| [u, v].min - 1e-6 }
        max = a.zip(b).map { |u, v| [u, v].max + 1e-6 }
        wynik = []
        lista.each do |pt|
          next unless pt[0] >= min[0] && pt[0] <= max[0] && pt[1] >= min[1] && pt[1] <= max[1] && pt[2] >= min[2] && pt[2] <= max[2]
          w = [pt[0] - a[0], pt[1] - a[1], pt[2] - a[2]]
          t = (w[0] * d[0] + w[1] * d[1] + w[2] * d[2]) / dl2
          next if t <= 1e-7 || t >= 1.0 - 1e-7
          r = [w[0] - d[0] * t, w[1] - d[1] * t, w[2] - d[2] * t]
          next if r[0] * r[0] + r[1] * r[1] + r[2] * r[2] > 1e-8
          wynik << [t, pt]
        end
        wynik.sort_by { |x| x[0] }.map { |x| x[1] }
      end

      # Usuwa kolejne powtórzone punkty pętli.
      def bez_powtorzen(pts)
        wynik = []
        pts.each { |pt| wynik << pt if wynik.empty? || klucz(wynik.last) != klucz(pt) }
        wynik.pop while wynik.length > 1 && klucz(wynik.last) == klucz(wynik.first)
        wynik
      end

      # Scalanie ścian tej samej płaszczyzny: krawędzie przeciwne się znoszą, z reszty powstają pętle (zewnętrzne i otwory).
      def scal(sciany)
        grupy = {}
        sciany.each do |s|
          d = s[:n][0] * s[:p][0][0] + s[:n][1] * s[:p][0][1] + s[:n][2] * s[:p][0][2]
          k = s[:n].map { |v| (v * 1e5).round } + [(d / 1e-3).round]
          (grupy[k] ||= []) << s
        end
        wynik = []
        grupy.each_value do |lista|
          n = lista[0][:n]
          krawedzie = {}
          punkty = {}
          lista.each do |s|
            m = s[:p].length
            m.times do |i|
              a = s[:p][i]
              b = s[:p][(i + 1) % m]
              ka = klucz(a)
              kb = klucz(b)
              punkty[ka] = a
              punkty[kb] = b
              if krawedzie[[kb, ka]] && krawedzie[[kb, ka]] > 0
                krawedzie[[kb, ka]] -= 1
              else
                krawedzie[[ka, kb]] = (krawedzie[[ka, kb]] || 0) + 1
              end
            end
          end
          petle = pety(krawedzie, punkty, n)
          wynik.concat(uloz(petle, n))
        end
        wynik
      end

      # Pętle z krawędzi skierowanych (na rozwidleniu – najostrzejszy skręt w lewo względem normalnej).
      def pety(krawedzie, punkty, n)
        wyj = {}
        krawedzie.each do |(ka, kb), ile|
          ile.times { (wyj[ka] ||= []) << kb }
        end
        petle = []
        loop do
          start = wyj.keys.find { |k| !wyj[k].empty? }
          break if start.nil?
          petla = [start]
          prev = nil
          cur = start
          (punkty.length * 2 + 4).times do
            kandydaci = wyj[cur]
            break if kandydaci.nil? || kandydaci.empty?
            nast = if kandydaci.length == 1 || prev.nil?
                     kandydaci[0]
                   else
                     kandydaci.max_by { |k| skret(punkty[prev], punkty[cur], punkty[k], n) }
                   end
            kandydaci.delete_at(kandydaci.index(nast))
            prev = cur
            cur = nast
            break if cur == start
            petla << cur
          end
          petle << petla.map { |k| punkty[k] } if petla.length >= 3
        end
        petle
      end

      # Kąt skrętu w lewo (−π…π) przy przejściu a → b → c, patrząc wzdłuż normalnej.
      def skret(a, b, c, n)
        u = [b[0] - a[0], b[1] - a[1], b[2] - a[2]]
        v = [c[0] - b[0], c[1] - b[1], c[2] - b[2]]
        cr = [u[1] * v[2] - u[2] * v[1], u[2] * v[0] - u[0] * v[2], u[0] * v[1] - u[1] * v[0]]
        sin = cr[0] * n[0] + cr[1] * n[1] + cr[2] * n[2]
        cos = u[0] * v[0] + u[1] * v[1] + u[2] * v[2]
        Math.atan2(sin, cos)
      end

      # Podział pętli na zewnętrzne (pole dodatnie względem normalnej) i otwory przypisane do zawierającej je pętli.
      def uloz(petle, n)
        zewn = []
        otwory = []
        petle.each { |pt| pole(pt, n) > 0 ? zewn << pt : otwory << pt }
        sciany = zewn.map { |pt| { normalna: n, petle: [pt] } }
        otwory.each do |o|
          cel = sciany.find { |s| wewnatrz?(o[0], s[:petle][0], n) }
          cel ? cel[:petle] << o : sciany << { normalna: n, petle: [o] }
        end
        sciany
      end

      # Pole pętli ze znakiem względem normalnej.
      def pole(pts, n)
        s = [0.0, 0.0, 0.0]
        m = pts.length
        m.times do |i|
          a = pts[i]
          b = pts[(i + 1) % m]
          s[0] += a[1] * b[2] - a[2] * b[1]
          s[1] += a[2] * b[0] - a[0] * b[2]
          s[2] += a[0] * b[1] - a[1] * b[0]
        end
        (s[0] * n[0] + s[1] * n[1] + s[2] * n[2]) / 2.0
      end

      # Punkt wewnątrz pętli (rzut na płaszczyznę bez największej składowej normalnej).
      def wewnatrz?(pt, petla, n)
        os = n.map(&:abs).each_with_index.max_by { |v, _i| v }[1]
        idx = [0, 1, 2] - [os]
        p2 = [pt[idx[0]], pt[idx[1]]]
        wielokat = petla.map { |q| [q[idx[0]], q[idx[1]]] }
        wynik = false
        j = wielokat.length - 1
        wielokat.each_with_index do |a, i|
          b = wielokat[j]
          if (a[1] > p2[1]) != (b[1] > p2[1])
            x = (b[0] - a[0]) * (p2[1] - a[1]) / (b[1] - a[1]) + a[0]
            wynik = !wynik if p2[0] < x
          end
          j = i
        end
        wynik
      end

      # Siatka do rysowania: usunięte wierzchołki leżące na prostej we wszystkich pętlach, w których występują
      # (zostają tylko narożniki i punkty styku z innymi ścianami – krawędzie sąsiednich ścian dalej się pokrywają).
      def uprosc(sciany)
        proste = Hash.new(true)
        sciany.each do |s|
          s[:petle].each do |pts|
            m = pts.length
            pts.each_with_index do |b, i|
              k = klucz(b)
              proste[k] = proste[k] && wspolliniowy?(pts[i - 1], b, pts[(i + 1) % m])
            end
          end
        end
        sciany.map do |s|
          petle = s[:petle].map { |pts| pts.reject { |b| proste[klucz(b)] } }
          { normalna: s[:normalna], petle: petle }
        end
      end

      # Czy b leży na prostej a–c między nimi (przejście na wprost).
      def wspolliniowy?(a, b, c)
        u = [b[0] - a[0], b[1] - a[1], b[2] - a[2]]
        v = [c[0] - b[0], c[1] - b[1], c[2] - b[2]]
        cr = [u[1] * v[2] - u[2] * v[1], u[2] * v[0] - u[0] * v[2], u[0] * v[1] - u[1] * v[0]]
        cr[0] * cr[0] + cr[1] * cr[1] + cr[2] * cr[2] < 1e-10 && (u[0] * v[0] + u[1] * v[1] + u[2] * v[2]) > 0
      end

      # Kontrola siatki: { zamknieta:, objetosc:, bledne_krawedzie: } – każda krawędź raz w każdą stronę.
      def sprawdz(sciany)
        licz = Hash.new(0)
        objetosc = 0.0
        sciany.each do |s|
          s[:petle].each do |pts|
            m = pts.length
            m.times do |i|
              licz[[klucz(pts[i]), klucz(pts[(i + 1) % m])]] += 1
            end
            (1...(m - 1)).each do |i|
              a = pts[0]
              b = pts[i]
              c = pts[i + 1]
              objetosc += (a[0] * (b[1] * c[2] - b[2] * c[1]) - a[1] * (b[0] * c[2] - b[2] * c[0]) + a[2] * (b[0] * c[1] - b[1] * c[0])) / 6.0
            end
          end
        end
        bledne = licz.select { |(ka, kb), ile| ile != 1 || licz[[kb, ka]] != 1 }.length
        { zamknieta: bledne == 0, objetosc: objetosc, bledne_krawedzie: bledne }
      end
    end
  end
end
