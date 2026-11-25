# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/sciany.rb
# Zadanie: ściany z rozpoznanego obrysu – osie, zasięgi bali z ostatkami, skrzyżowania, kontrfory, kierunek względem kalenicy, numeracja W-n.
# Tematy: ściana, oś ściany, ostatek, wypust węgła wewnątrz i na zewnątrz, narożnik L, połączenie T, skrzyżowanie X, kontrfor, wolny koniec, numeracja ścian, kierunek A/B, kalenica, narożnik wklęsły
# Zależy od: rdzen/geometria.rb, rdzen/parametry.rb, rdzen/skrzydla.rb, rdzen/sciana_w_linii.rb
# Używają: rdzen/projekt.rb, rdzen/styki.rb (dodaj_kontrfor), rdzen/wience.rb, rdzen/bale.rb, rdzen/zamek.rb
#
# Ściana (Hash): k (klucz), id ('W-n'), rodzaj (:zewnetrzna | :dzialowa | :kontrfor), kierunek (:A wzdłuż kalenicy –
# półbal na dole | :B szczytowa), a, b (oś), kier, nor (normalna w lewo), dl_osi, s_od, s_do (zasięg bali wzdłuż osi
# z ostatkami, s liczone od a), ref (s punktu odniesienia otworów), skrzyzowania [{s:, inna:, punkt:, typ:}], gospodarz,
# ostatki_param ([początek, koniec] – ostatek z parametrów przed ustawieniami ściany; nil – wolny koniec), w_linii ([początek,
# koniec] – koniec bez ostatka, w osi ściany poprzecznej: działowa w linii ściany obrysu – rdzen/sciana_w_linii.rb).
# Ściana zewnętrzna: lico zewnętrzne po prawej stronie kier (obrys przeciwnie do wskazówek zegara).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'geometria') unless defined?(ArteMadera::GeneratorWiencowy::Geometria)
require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'skrzydla') unless defined?(ArteMadera::GeneratorWiencowy::Skrzydla)
require File.join(File.dirname(__FILE__), 'sciana_w_linii') unless defined?(ArteMadera::GeneratorWiencowy::ScianaWLinii)

module ArteMadera
  module GeneratorWiencowy
    module Sciany
      G = Geometria unless const_defined?(:G)

      module_function

      # Ściany i skrzyżowania z obrysu: { sciany:, os_kalenicy:, ostrzezenia:, podpowiedzi:, bledy: } (bez numeracji –
      # numeruj!). Podpowiedzi – narożniki wklęsłe (wklesle – ich punkty, zbierane w zewnetrzne).
      def zbuduj(obrys, p)
        wynik = { sciany: [], os_kalenicy: :x, ostrzezenia: [], podpowiedzi: [], wklesle: [], bledy: [] }
        t = Parametry.grubosc(p)
        tol = p['tolerancja_rysunku'].to_f
        wynik[:os_kalenicy] = obrys[:os_kalenicy] || Skrzydla.os(obrys[:obrys], p['kalenica']) || os_kalenicy(obrys[:obrys], p['kalenica'])
        licznik = [0]
        zewn = zewnetrzne(obrys[:obrys], t, p, licznik, wynik)
        wynik[:podpowiedzi] << podpowiedz_wklesle(wynik[:wklesle]) unless wynik[:wklesle].empty?
        dzial = dzialowe(obrys[:dzialowe], zewn, t, p, licznik, wynik, tol)
        wynik[:sciany] = zewn + dzial
        wynik[:sciany].each { |w| w[:kierunek] = (w[:os] == wynik[:os_kalenicy]) ? :A : :B }
        wyznacz_skrzyzowania(wynik[:sciany], tol)
        obrys[:kontrfory].each do |kf|
          gosp, s = gospodarz_kontrforu(kf[:punkt], wynik[:sciany], tol + t)
          if gosp.nil?
            wynik[:ostrzezenia] << "Kontrfor w punkcie #{G.txt(kf[:punkt])} nie leży na ścianie – pominięty."
            next
          end
          blad = sprawdz_miejsce_kontrforu(gosp, s, p)
          if blad
            wynik[:ostrzezenia] << "Kontrfor na ścianie przy #{G.txt(kf[:punkt])}: #{blad} – pominięty."
            next
          end
          dodaj_kontrfor(wynik[:sciany], gosp, s, p, :rysunek, wynik[:os_kalenicy])
        end
        wynik
      end

      # Oś kalenicy :x / :y w układzie lokalnym (kierunek ścian okapowych z półbalem).
      def os_kalenicy(obrys_pts, wybor)
        xs = obrys_pts.map { |q| q[0] }
        ys = obrys_pts.map { |q| q[1] }
        szer = xs.max - xs.min
        wys = ys.max - ys.min
        case wybor.to_s
        when 'x' then :x
        when 'y' then :y
        when 'krotszy' then szer >= wys ? :y : :x
        else szer >= wys ? :x : :y
        end
      end

      # Ściany zewnętrzne: oś = bok obrysu przesunięty do środka o pół grubości, narożniki = przecięcia osi.
      def zewnetrzne(pts, t, p, licznik, wynik)
        n = pts.length
        boki = (0...n).map { |i| [pts[i], pts[(i + 1) % n]] }
        osie = boki.map do |s|
          d = G.norm(G.sub(s[1], s[0]))
          l = G.lewa(d)
          [G.add(s[0], G.mul(l, t / 2.0)), G.add(s[1], G.mul(l, t / 2.0)), d]
        end
        narozniki = (0...n).map { |i| G.przeciecie_prostych(osie[i - 1][0], osie[i - 1][1], osie[i][0], osie[i][1]) }
        o = p['ostatek'].to_f
        (0...n).map do |i|
          a = narozniki[i]
          b = narozniki[(i + 1) % n]
          d = osie[i][2]
          wklesly_a = G.cross(osie[i - 1][2], d) < 0
          wklesly_b = G.cross(d, osie[(i + 1) % n][2]) < 0
          wynik[:wklesle] << boki[i][0] if wklesly_a
          wynik[:wklesle] << boki[i][1] if wklesly_b
          sciana(licznik, :zewnetrzna, a, b, d).merge(
            wklesle: [wklesly_a, wklesly_b], s_od: -(t / 2.0 + o), s_do: G.odl(a, b) + t / 2.0 + o,
            ref: G.dot(G.sub(boki[i][0], a), d), bok: boki[i], ostatki_param: [o, o]
          )
        end
      end

      # Podpowiedź o narożnikach wklęsłych (punkty bez powtórzeń): ostatki bali wchodzą tam do wnętrza budynku. Decyzja
      # użytkownika (2026-11-14): ostatki zostają – przy balu 44 mm nie ma lepszego rozwiązania – a informacja jest
      # podpowiedzią, nie ostrzeżeniem (przyda się przy grubszym balu).
      def podpowiedz_wklesle(punkty)
        opis = punkty.map { |q| G.txt(q) }.uniq
        { poziom: 'ok', tekst: format('%s %s – ostatki bali wchodzą tam do wnętrza budynku (przy balu 44 mm tak ma być).',
                                      opis.length == 1 ? 'Narożnik wklęsły przy' : "Narożniki wklęsłe (#{opis.length}) przy",
                                      opis.join(', ')) }
      end

      # Ściany działowe: końce na obrysie = przez ścianę zewnętrzną na zewnątrz o wypust węgła na zewnątrz (jak słupek węgła,
      # runda 9), na innej działowej = połączenie T (ostatek), pozostałe = wolny koniec.
      def dzialowe(linie, zewn, t, p, licznik, wynik, tol)
        o = p['ostatek'].to_f
        oz = p['wegiel_wypust_zewn'].to_f
        lista = linie.map do |s|
          a, b = s
          a, b = b, a if (b[0] - a[0]).abs >= (b[1] - a[1]).abs ? b[0] < a[0] : b[1] < a[1]
          { a: a, b: b }
        end
        lista.map do |l|
          d = G.norm(G.sub(l[:b], l[:a]))
          # Działowa w linii ściany obrysu (rdzen/sciana_w_linii.rb): oś tej ściany, koniec w osi ściany poprzecznej.
          w_linii = ScianaWLinii.konce(l, zewn, t + tol)
          l.merge!(ScianaWLinii.na_osi(l, w_linii[0][1])) unless w_linii.empty?
          a = l[:a]
          b = l[:b]
          wydl = [0.0, 0.0]
          konce_w_linii = [false, false]
          [0, 1].each do |koniec|
            pt = koniec == 0 ? a : b
            kont = w_linii.find { |k, w, _poprz| k == koniec && ScianaWLinii.na_linii?(a, b, w) }
            if kont
              c = G.przeciecie_prostych(a, b, kont[2][:a], kont[2][:b])
              koniec == 0 ? a = c : b = c
              ScianaWLinii.bez_ostatka!(kont[1], c)
              konce_w_linii[koniec] = true
              next
            end
            # Tylko ściany nierównoległe: ze ścianą równoległą linia działowej nie ma punktu przecięcia.
            zew = zewn.find { |w| przy_boku?(pt, w[:bok], t + tol) && !ScianaWLinii.rownolegle?(d, w) }
            if zew
              c = G.przeciecie_prostych(a, b, zew[:a], zew[:b])
              koniec == 0 ? a = c : b = c
              wydl[koniec] = t / 2.0 + oz
            elsif lista.any? { |m| !m.equal?(l) && G.na_odcinku?(pt, m[:a], m[:b], t / 2.0 + tol) }
              wydl[koniec] = t / 2.0 + o
            end
          end
          w = sciana(licznik, :dzialowa, a, b, d).merge(s_od: -wydl[0], s_do: G.odl(a, b) + wydl[1], ref: 0.0,
                                                        ostatki_param: wydl.map { |x| x > 0.0 ? x - t / 2.0 : nil })
          w[:w_linii] = konce_w_linii if konce_w_linii.any?
          w
        end
      end

      # Czy punkt leży na boku obrysu lub w jego pobliżu po stronie ściany (koniec działowej dosunięty do lica).
      def przy_boku?(pt, bok, zasieg)
        t, d, _q = G.rzut(pt, bok[0], bok[1])
        d <= zasieg && t >= -1e-6 && t <= 1.0 + 1e-6
      end

      # Nowa ściana (bez zasięgu): wspólne pola.
      def sciana(licznik, rodzaj, a, b, d)
        licznik[0] += 1
        os = d[0].abs >= d[1].abs ? :x : :y
        { k: licznik[0], id: nil, rodzaj: rodzaj, a: a, b: b, kier: d, nor: G.lewa(d), os: os,
          dl_osi: G.odl(a, b), skrzyzowania: [], gospodarz: nil }
      end

      # Skrzyżowania wszystkich par ścian prostopadłych, których osie się przecinają (narożniki, T, X).
      def wyznacz_skrzyzowania(sciany, tol)
        sciany.each { |w| w[:skrzyzowania] = [] }
        sciany.combination(2).each do |w1, w2|
          next if w1[:os] == w2[:os]
          pt = G.przeciecie_prostych(w1[:a], G.add(w1[:a], w1[:kier]), w2[:a], G.add(w2[:a], w2[:kier]))
          next if pt.nil?
          next unless G.na_odcinku?(pt, w1[:a], w1[:b], tol) && G.na_odcinku?(pt, w2[:a], w2[:b], tol)
          polacz(w1, w2, pt)
        end
        sciany.each { |w| w[:skrzyzowania].sort_by! { |k| k[:s] } }
      end

      # Zapis skrzyżowania w obu ścianach (typ: :naroznik, :t, :x, :kontrfor).
      def polacz(w1, w2, pt)
        s1 = G.dot(G.sub(pt, w1[:a]), w1[:kier])
        s2 = G.dot(G.sub(pt, w2[:a]), w2[:kier])
        typ = typ_skrzyzowania(w1, s1, w2, s2)
        w1[:skrzyzowania] << { s: s1, inna: w2, punkt: pt, typ: typ }
        w2[:skrzyzowania] << { s: s2, inna: w1, punkt: pt, typ: typ }
      end

      # Rodzaj skrzyżowania z położenia na osiach (koniec osi = 0 lub dl_osi).
      def typ_skrzyzowania(w1, s1, w2, s2)
        return :kontrfor if w1[:rodzaj] == :kontrfor || w2[:rodzaj] == :kontrfor
        k1 = s1.abs < 1.0 || (s1 - w1[:dl_osi]).abs < 1.0
        k2 = s2.abs < 1.0 || (s2 - w2[:dl_osi]).abs < 1.0
        return :naroznik if k1 && k2
        return :t if k1 || k2
        :x
      end

      # Ściana-gospodarz kontrforu: ściana, do której osi punkt jest najbliżej (≤ zasięg); [ściana, s] albo [nil, nil].
      def gospodarz_kontrforu(pt, sciany, zasieg)
        najl = nil
        sciany.each do |w|
          next if w[:rodzaj] == :kontrfor
          t, d, _q = G.rzut(pt, w[:a], w[:b])
          next if d > zasieg || t < 0.0 || t > 1.0
          najl = [w, t * w[:dl_osi], d] if najl.nil? || d < najl[2]
        end
        najl ? [najl[0], najl[1]] : [nil, nil]
      end

      # Czy kontrfor w miejscu s ściany w nie wchodzi w zamek innego skrzyżowania; tekst błędu albo nil.
      def sprawdz_miejsce_kontrforu(w, s, p)
        min = p['min_odstep_skrzyzowan'].to_f
        w[:skrzyzowania].each do |k|
          odl = (k[:s] - s).abs
          return format('za blisko skrzyżowania ze ścianą (%.0f mm, najmniej %.0f mm)', odl, min) if odl < min - 0.5
        end
        nil
      end

      # Nowy kontrfor (słupek: wypust wewnątrz + grubość + wypust na zewnątrz) w miejscu s ściany-gospodarza; ostatki –
      # { wewn:, zewn: } z wiersza tabeli węgłów (nil – z parametrów); zwraca ścianę kontrforu.
      def dodaj_kontrfor(sciany, gosp, s, p, zrodlo, os_kalenicy, ostatki = nil)
        t = Parametry.grubosc(p)
        c = G.add(gosp[:a], G.mul(gosp[:kier], s))
        d = gosp[:nor].dup
        d = G.mul(d, -1.0) if d[0] < -0.5 || d[1] < -0.5
        o_od, o_do = wypusty_kontrforu(sciany, gosp, c, d, p, ostatki || {})
        licznik = [sciany.map { |w| w[:k] }.max.to_i]
        kf = sciana(licznik, :kontrfor, c, c, d).merge(s_od: -(t / 2.0 + o_od), s_do: t / 2.0 + o_do, ref: -(t / 2.0 + o_od),
                                                       gospodarz: gosp, zrodlo: zrodlo)
        kf[:kierunek] = kf[:os] == os_kalenicy ? :A : :B
        sciany << kf
        polacz(gosp, kf, c)
        gosp[:skrzyzowania].sort_by! { |k| k[:s] }
        kf
      end

      # Wypusty kontrforu [na początku osi (−d), na końcu (+d)] [mm]: przy ścianie zewnętrznej strona wewnątrz domu dostaje
      # wypust wewnętrzny, druga – zewnętrzny (wegiel_wypust_wewn / _zewn albo z wiersza tabeli); przy działowej obie
      # strony są wewnątrz, przy ścianie domu przy tarasie strona tarasu jest na zewnątrz.
      def wypusty_kontrforu(sciany, gosp, c, d, p, ostatki)
        wewn = Parametry.liczba(ostatki['wewn']) || p['wegiel_wypust_wewn'].to_f
        zewn = Parametry.liczba(ostatki['zewn']) || p['wegiel_wypust_zewn'].to_f
        tr = gosp[:taras]
        # Ściana domu przy tarasie: strona tarasu jak na zewnątrz (runda 9).
        return d[tr[:iu]] * tr[:znak] > 0 ? [wewn, zewn] : [zewn, wewn] if tr && tr[:rola] == :dom
        return [wewn, wewn] unless gosp[:rodzaj] == :zewnetrzna
        obrys = sciany.select { |w| w[:rodzaj] == :zewnetrzna }.sort_by { |w| w[:k] }.map { |w| w[:a] }
        do_wewnatrz = obrys.length >= 3 && G.wewnatrz?(G.add(c, G.mul(d, Parametry.grubosc(p))), obrys)
        do_wewnatrz ? [zewn, wewn] : [wewn, zewn]
      end

      # Numeracja W-n: zewnętrzne od dolnego lewego narożnika przeciwnie do wskazówek zegara, potem działowe, potem kontrfory.
      def numeruj!(sciany)
        zewn = sciany.select { |w| w[:rodzaj] == :zewnetrzna }.sort_by { |w| w[:k] }
        dzial = sciany.select { |w| w[:rodzaj] == :dzialowa }.sort_by { |w| [w[:os] == :x ? 0 : 1, w[:a][1].round, w[:a][0].round] }
        kontr = sciany.select { |w| w[:rodzaj] == :kontrfor }
        nr = 0
        (zewn + dzial).each do |w|
          nr += 1
          w[:nr] = nr
          w[:id] = "W-#{nr}"
        end
        kontr.sort_by { |w| [w[:gospodarz][:nr], G.dot(G.sub(w[:a], w[:gospodarz][:a]), w[:gospodarz][:kier]).round] }.each do |w|
          nr += 1
          w[:nr] = nr
          w[:id] = "W-#{nr}"
        end
        sciany.sort_by! { |w| w[:nr] }
        sciany
      end

      # Punkt 2D na osi ściany w odległości s od początku a.
      def punkt(w, s)
        G.add(w[:a], G.mul(w[:kier], s))
      end

      # Opis rodzaju ściany do okna i list.
      def opis_rodzaju(w)
        return Taras.opis(w) if defined?(Taras) && Taras.opis(w)
        case w[:rodzaj]
        when :zewnetrzna then w[:kierunek] == :A ? 'zewnętrzna okapowa' : 'zewnętrzna szczytowa'
        when :dzialowa then 'działowa'
        else 'kontrfor'
        end
      end
    end
  end
end
