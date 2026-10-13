# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/obrys.rb
# Zadanie: rozpoznanie narysowanych linii – zamknięty obrys (lico zewnętrzne), osie ścian działowych, znaczniki kontrforów.
# Tematy: obrys, lico zewnętrzne, linie wejściowe, osie działowych, znacznik kontrforu, układ lokalny (obrót), scalanie linii
# Zależy od: rdzen/geometria.rb, rdzen/parametry.rb
# Używają: rdzen/projekt.rb
#
# Wejście: odcinki [[x1, y1], [x2, y2]] w mm (rzut na płaszczyznę XY modelu).
# Wynik w układzie lokalnym obróconym o kąt najdłuższej linii: ściany są równoległe do osi X lub Y.
# SketchUp dzieli krawędzie w punktach styku – tu linie współliniowe są z powrotem scalane.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'geometria') unless defined?(ArteMadera::GeneratorWiencowy::Geometria)

module ArteMadera
  module GeneratorWiencowy
    module Obrys
      G = Geometria unless const_defined?(:G)

      module_function

      # Rozpoznanie linii: { kat:, obrys:, dzialowe:, kontrfory:, ostrzezenia:, bledy: } (układ lokalny).
      def rozpoznaj(segmenty, p)
        tol = p['tolerancja_rysunku'].to_f
        wynik = { kat: 0.0, obrys: [], dzialowe: [], kontrfory: [], ostrzezenia: [], bledy: [] }
        odc = segmenty.map { |s| [[s[0][0].to_f, s[0][1].to_f], [s[1][0].to_f, s[1][1].to_f]] }
        odc = odc.reject { |s| G.odl(s[0], s[1]) < tol }
        if odc.empty?
          wynik[:bledy] << 'Brak linii – zaznacz narysowany obrys domu (i osie ścian działowych).'
          return wynik
        end
        kat = kat_ukladu(odc)
        wynik[:kat] = kat
        lok = odc.map { |s| [G.obroc(s[0], -kat), G.obroc(s[1], -kat)] }
        poziome, pionowe, krzywe = rozdziel(lok, tol)
        krzywe.each do |s|
          wynik[:bledy] << format('Linia %s → %s nie jest równoległa ani prostopadła do pozostałych – ' \
                                  'generator obsługuje tylko ściany pod kątem prostym.', G.txt(G.obroc(s[0], kat)), G.txt(G.obroc(s[1], kat)))
        end
        poziome = scal(poziome, 1, tol)
        pionowe = scal(pionowe, 0, tol)
        przyciagnij_konce(poziome, pionowe, tol)
        obrys = obwiednia(poziome, pionowe, tol)
        if obrys.nil? || obrys.length < 4
          wynik[:bledy] << 'Nie znaleziono zamkniętego obrysu – linie lica zewnętrznego muszą tworzyć zamkniętą pętlę ' \
                           "(sprawdź, czy narożniki się stykają; tolerancja #{Parametry.fmt(tol)} mm)."
          return wynik
        end
        wynik[:obrys] = obrys
        klasyfikuj(poziome + pionowe, obrys, p, tol, wynik)
        wynik
      end

      # Kąt układu lokalnego = kierunek najdłuższej linii (0 ≤ kąt < 90°).
      def kat_ukladu(odc)
        naj = odc.max_by { |s| G.odl(s[0], s[1]) }
        d = G.sub(naj[1], naj[0])
        k = Math.atan2(d[1], d[0])
        k += Math::PI while k < 0
        k -= Math::PI / 2.0 while k >= Math::PI / 2.0 - 1e-12
        k
      end

      # Podział na poziome / pionowe (wyrównane) i pozostałe – linie w postaci {a:, b:, poz:} (a < b).
      def rozdziel(lok, tol)
        poziome = []
        pionowe = []
        krzywe = []
        lok.each do |s|
          dx = s[1][0] - s[0][0]
          dy = s[1][1] - s[0][1]
          if dy.abs <= tol || (dy.abs / [dx.abs, 1e-9].max) <= G::TOL_KATA
            y = (s[0][1] + s[1][1]) / 2.0
            poziome << { a: [s[0][0], s[1][0]].min, b: [s[0][0], s[1][0]].max, poz: y }
          elsif dx.abs <= tol || (dx.abs / [dy.abs, 1e-9].max) <= G::TOL_KATA
            x = (s[0][0] + s[1][0]) / 2.0
            pionowe << { a: [s[0][1], s[1][1]].min, b: [s[0][1], s[1][1]].max, poz: x }
          else
            krzywe << s
          end
        end
        [poziome, pionowe, krzywe]
      end

      # Scalanie linii leżących na jednej prostej (różnica położenia ≤ tol) i zachodzących / stykających się.
      # os: 1 – linie poziome (poz = y), 0 – pionowe (poz = x, znacznik pion: true).
      def scal(linie, os, tol)
        grupy = []
        linie.sort_by { |l| l[:poz] }.each do |l|
          if grupy.empty? || (l[:poz] - grupy.last[:poz]).abs > tol
            grupy << { poz: l[:poz], linie: [l], suma: l[:poz], n: 1 }
          else
            g = grupy.last
            g[:linie] << l
            g[:suma] += l[:poz]
            g[:n] += 1
          end
        end
        wynik = []
        grupy.each do |g|
          poz = g[:suma] / g[:n]
          G.scal_przedzialy(g[:linie].map { |l| [l[:a], l[:b]] }, tol).each do |p|
            linia = { a: p[0], b: p[1], poz: poz }
            linia[:pion] = true if os == 0
            wynik << linia
          end
        end
        wynik
      end

      # Końce linii bliskie linii prostopadłej (≤ tol) są do niej dociągane – narożniki i styki T się zamykają.
      def przyciagnij_konce(poziome, pionowe, tol)
        poziome.each do |h|
          pionowe.each do |v|
            next unless h[:poz] >= v[:a] - tol && h[:poz] <= v[:b] + tol
            h[:a] = v[:poz] if (h[:a] - v[:poz]).abs <= tol
            h[:b] = v[:poz] if (h[:b] - v[:poz]).abs <= tol
          end
        end
        pionowe.each do |v|
          poziome.each do |h|
            next unless v[:poz] >= h[:a] - tol && v[:poz] <= h[:b] + tol
            v[:a] = h[:poz] if (v[:a] - h[:poz]).abs <= tol
            v[:b] = h[:poz] if (v[:b] - h[:poz]).abs <= tol
          end
        end
      end

      # Zewnętrzna pętla grafu linii (po odcięciu wiszących końców): wierzchołki obrysu przeciwnie do wskazówek zegara.
      def obwiednia(poziome, pionowe, tol)
        wezly = {}
        krawedzie = {}
        dodaj_linie = lambda do |punkty|
          punkty = punkty.uniq { |pt| G.klucz(pt, tol / 10.0) }
          (0...(punkty.length - 1)).each do |i|
            a = punkty[i]
            b = punkty[i + 1]
            ka = G.klucz(a, tol / 10.0)
            kb = G.klucz(b, tol / 10.0)
            next if ka == kb
            wezly[ka] = a
            wezly[kb] = b
            (krawedzie[ka] ||= []) << kb unless (krawedzie[ka] || []).include?(kb)
            (krawedzie[kb] ||= []) << ka unless (krawedzie[kb] || []).include?(ka)
          end
        end
        poziome.each do |h|
          xs = [h[:a], h[:b]]
          pionowe.each { |v| xs << v[:poz] if v[:poz] > h[:a] + tol && v[:poz] < h[:b] - tol && h[:poz] >= v[:a] - tol && h[:poz] <= v[:b] + tol }
          dodaj_linie.call(xs.sort.map { |x| [x, h[:poz]] })
        end
        pionowe.each do |v|
          ys = [v[:a], v[:b]]
          poziome.each { |h| ys << h[:poz] if h[:poz] > v[:a] + tol && h[:poz] < v[:b] - tol && v[:poz] >= h[:a] - tol && v[:poz] <= h[:b] + tol }
          dodaj_linie.call(ys.sort.map { |y| [v[:poz], y] })
        end
        # Odcinanie wiszących końców (kontrfory, wolne końce działowych, linie poza obrysem).
        loop do
          wiszace = krawedzie.keys.select { |k| krawedzie[k].length < 2 }
          break if wiszace.empty?
          wiszace.each do |k|
            (krawedzie[k] || []).each { |s| krawedzie[s].delete(k) if krawedzie[s] }
            krawedzie.delete(k)
          end
        end
        return nil if krawedzie.empty?
        start = krawedzie.keys.min_by { |k| [wezly[k][1], wezly[k][0]] }
        kier = [1.0, 0.0]
        petla = [start]
        biezacy = start
        poprzedni = nil
        (krawedzie.length * 4 + 10).times do
          nastepny = najbardziej_w_prawo(biezacy, kier, poprzedni, krawedzie, wezly)
          return nil if nastepny.nil?
          kier = G.norm(G.sub(wezly[nastepny], wezly[biezacy]))
          poprzedni = biezacy
          biezacy = nastepny
          break if biezacy == start
          petla << biezacy
        end
        return nil unless biezacy == start
        uprosc(petla.map { |k| wezly[k] }, tol)
      end

      # Następny węzeł obwiedni: skręt w prawo, prosto, w lewo – w tej kolejności (zewnętrze zostaje po prawej).
      def najbardziej_w_prawo(biezacy, kier, poprzedni, krawedzie, wezly)
        kandydaci = krawedzie[biezacy].reject { |k| k == poprzedni && krawedzie[biezacy].length > 1 }
        prawo = [kier[1], -kier[0]]
        lewo = [-kier[1], kier[0]]
        [prawo, kier, lewo].each do |chciany|
          kandydaci.each do |k|
            d = G.norm(G.sub(wezly[k], wezly[biezacy]))
            return k if G.dot(d, chciany) > 0.999
          end
        end
        poprzedni
      end

      # Usuwa wierzchołki leżące na prostej między sąsiadami.
      def uprosc(punkty, tol)
        wynik = punkty.dup
        zmiana = true
        while zmiana && wynik.length > 3
          zmiana = false
          wynik.each_index do |i|
            a = wynik[i - 1]
            b = wynik[i]
            c = wynik[(i + 1) % wynik.length]
            next unless G.na_odcinku?(b, a, c, tol / 10.0)
            wynik.delete_at(i)
            zmiana = true
            break
          end
        end
        wynik
      end

      # Podział pozostałych linii na osie ścian działowych i znaczniki kontrforów.
      def klasyfikuj(linie, obrys, p, tol, wynik)
        boki = (0...obrys.length).map { |i| [obrys[i], obrys[(i + 1) % obrys.length]] }
        wewnetrzne = []
        linie.each do |l|
          a, b = konce(l)
          next if boki.any? { |s| G.na_odcinku?(a, s[0], s[1], tol) && G.na_odcinku?(b, s[0], s[1], tol) }
          wewnetrzne << [a, b]
        end
        max_k = p['kontrfor_max_linia'].to_f
        dlugie = wewnetrzne.select { |s| G.odl(s[0], s[1]) > max_k }
        krotkie = wewnetrzne - dlugie
        krotkie.each do |s|
          sciany = boki + dlugie
          trafienia = sciany.map { |w| przeciecie_wewnetrzne(s, w, tol) }.compact
          if trafienia.length == 1
            wynik[:kontrfory] << { punkt: trafienia[0], linia: s }
          elsif trafienia.length > 1
            wynik[:ostrzezenia] << "Krótka linia #{G.txt(s[0])} – #{G.txt(s[1])} przecina kilka ścian – pominięta (kontrfor przecina jedną ścianę)."
          else
            dlugie << s
          end
        end
        dlugie.each do |s|
          przyciete = przytnij_do_obrysu(s, obrys, boki, tol, wynik)
          wynik[:dzialowe] << przyciete if przyciete
        end
      end

      # Końce linii {a:, b:, poz:} jako punkty (poziome mają poz = y, pionowe poz = x).
      def konce(l)
        if l.key?(:pion)
          [[l[:poz], l[:a]], [l[:poz], l[:b]]]
        else
          [[l[:a], l[:poz]], [l[:b], l[:poz]]]
        end
      end

      # Punkt przecięcia leżący wewnątrz obu odcinków (nie na końcach odcinka s) albo nil.
      def przeciecie_wewnetrzne(s, w, tol)
        hit = G.przeciecie(s[0], s[1], w[0], w[1], tol)
        return nil if hit.nil?
        pt = hit[0]
        return nil if G.odl(pt, s[0]) <= tol || G.odl(pt, s[1]) <= tol
        pt
      end

      # Oś działowej przycięta do obrysu (część poza obrysem odrzucona z ostrzeżeniem); nil gdy całość na zewnątrz.
      def przytnij_do_obrysu(s, obrys, boki, tol, wynik)
        punkty = [s[0], s[1]]
        boki.each do |w|
          hit = G.przeciecie(s[0], s[1], w[0], w[1], tol)
          punkty << hit[0] if hit
        end
        d = G.sub(s[1], s[0])
        punkty = punkty.uniq { |pt| G.klucz(pt, tol / 10.0) }.sort_by { |pt| G.dot(G.sub(pt, s[0]), d) }
        wewnatrz = []
        (0...(punkty.length - 1)).each do |i|
          a = punkty[i]
          b = punkty[i + 1]
          srodek = G.mul(G.add(a, b), 0.5)
          if G.wewnatrz?(srodek, obrys) && G.odl(a, b) > tol
            wewnatrz << [a, b]
          elsif G.odl(a, b) > tol
            wynik[:ostrzezenia] << "Linia #{G.txt(a)} – #{G.txt(b)} leży poza obrysem – pominięta."
          end
        end
        return nil if wewnatrz.empty?
        [wewnatrz.first[0], wewnatrz.last[1]]
      end
    end
  end
end
