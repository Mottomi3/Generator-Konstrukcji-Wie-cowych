# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/zamek_platwi.rb
# Zadanie: zamki w płatwiach – wręby płatwi w ścianach, przez które przechodzi (z boków i od spodu), żeby płatwie trzymały szczyty na miejscu; bryła belki z wrębami, objętość, podpis.
# Tematy: zamek płatwi, wrąb płatwi, płatew trzyma szczyt, gniazdo płatwi węższe, przekrój w wrębie, przycięcie wielokąta, siatka belki z wrębami
# Zależy od: rdzen/parametry.rb, rdzen/pryzmat.rb (pole przekroju, podpis), rdzen/siatka.rb (punkty T, scalanie ścian)
# Używają: rdzen/szczyty.rb (gniazdo dopasowane do wrębu, przejścia płatwi przez ściany), rdzen/dach.rb (wręby płatwi), rdzen/elementy.rb (pozycje), rdzen/projekt.rb (siatka i objętość)
#
# Płatew przechodzi przez ścianę w poprzek (szczyt, działowa, węgieł): na grubości ściany + luz (platwa_zamek_luz z każdej
# strony) jest zwężona o platwa_zamek_bok z każdego boku i podcięta od spodu o platwa_zamek_dol. Gniazdo w ścianie ma
# szerokość wrębu (bez luzu gniazda – bal dochodzi do dna wrębu, wymóg użytkownika z rundy 8) i dno na spodzie wrębu – barki płatwi po obu stronach ściany nie dają szczytowi
# odjechać wzdłuż płatwi. Wręby belki: e[:wreby] = [[x0, x1]] wzdłuż belki, e[:wrab] = { bok:, dol: }.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'pryzmat') unless defined?(ArteMadera::GeneratorWiencowy::Pryzmat)

module ArteMadera
  module GeneratorWiencowy
    module ZamekPlatwi
      EPS = 1e-6 unless const_defined?(:EPS)

      module_function

      # Czy płatwie mają zamki (wręby).
      def wlaczone?(p)
        Parametry.tak?(p, 'platwie_zamki')
      end

      # Wymiary wrębu { bok:, dol: } [mm]; bez zamków – zera.
      def wrab(p)
        return { bok: 0.0, dol: 0.0 } unless wlaczone?(p)
        { bok: p['platwa_zamek_bok'].to_f, dol: p['platwa_zamek_dol'].to_f }
      end

      # Szerokość płatwi w ścianie (w wrębie) [mm].
      def szerokosc_w_scianie(b, p)
        [b - 2.0 * wrab(p)[:bok], 1.0].max
      end

      # Spód płatwi w ścianie (dno gniazda) [mm].
      def spod_w_scianie(z_spod, p)
        z_spod + wrab(p)[:dol]
      end

      # Wręby belki o długości dl z osi ścian u_scian (współrzędna wzdłuż belki, od jej początku) i grubości t: [[x0, x1]]
      # posortowane, nachodzące scalone, przycięte do belki.
      def wreby(dl, u_scian, t, p)
        return [] unless wlaczone?(p)
        pol = t / 2.0 + p['platwa_zamek_luz'].to_f
        lista = u_scian.map { |u| [[u - pol, 0.0].max, [u + pol, dl].min] }.select { |a, b| b - a > 1.0 }.sort
        lista.each_with_object([]) do |(a, b), acc|
          if !acc.empty? && a <= acc.last[1] + EPS
            acc.last[1] = [acc.last[1], b].max
          else
            acc << [a, b]
          end
        end
      end

      # Przekrój w wrębie: przekrój belki przycięty do y ∈ [bok, b − bok] i z ≥ dol (wielokąt wypukły).
      def przekroj_wrebu(przekroj, b, w)
        q = przytnij(przekroj, 1, w[:bok], 1.0)
        q = przytnij(q, 1, b - w[:bok], -1.0)
        przytnij(q, 2, w[:dol], 1.0)
      end

      # Wielokąt [[y, z]] przycięty półpłaszczyzną: oś 1 (y) albo 2 (z), znak +1 – zostaje ≥ granica, −1 – ≤ granica.
      def przytnij(pts, os, granica, znak)
        i = os - 1
        wynik = []
        pts.each_with_index do |a, k|
          b = pts[(k + 1) % pts.length]
          da = (a[i] - granica) * znak
          db = (b[i] - granica) * znak
          wynik << a if da >= -EPS
          if (da > EPS && db < -EPS) || (da < -EPS && db > EPS)
            t = da / (da - db)
            wynik << [a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t]
          end
        end
        bez_powtorzen(wynik)
      end

      # Punkty bez kolejnych powtórzeń (także ostatni = pierwszy).
      def bez_powtorzen(pts)
        wynik = []
        pts.each { |pt| wynik << pt if wynik.empty? || (pt[0] - wynik.last[0]).abs > EPS || (pt[1] - wynik.last[1]).abs > EPS }
        wynik.pop while wynik.length > 1 && (wynik.last[0] - wynik.first[0]).abs <= EPS && (wynik.last[1] - wynik.first[1]).abs <= EPS
        wynik
      end

      # Odcinki belki: [[x0, x1, przekrój]] – przekrój pełny poza wrębami, przekrój wrębu w nich.
      def odcinki(dl, przekroj, b, wreby, w)
        wn = przekroj_wrebu(przekroj, b, w)
        wynik = []
        x = 0.0
        wreby.each do |a, c|
          wynik << [x, a, przekroj] if a - x > EPS
          wynik << [a, c, wn]
          x = c
        end
        wynik << [x, dl, przekroj] if dl - x > EPS
        wynik
      end

      # Objętość belki z wrębami [mm³].
      def objetosc(dl, przekroj, b, wreby, w)
        odcinki(dl, przekroj, b, wreby, w).inject(0.0) { |s, (x0, x1, q)| s + (x1 - x0) * Pryzmat.pole(q) }
      end

      # Podpis wrębów (do rozpoznania identycznych belek).
      def podpis(wreby, w)
        return '' if wreby.empty?
        format('W%.1f/%.1f:', w[:bok], w[:dol]) + wreby.map { |a, c| format('%.1f-%.1f', a, c) }.join(',')
      end

      # Wręby belki obróconej o 180° (x → dl − x).
      def obrocone(dl, wreby)
        wreby.map { |a, c| [dl - c, dl - a] }.reverse
      end

      # Siatka belki z wrębami: boki każdego odcinka, czoła na końcach i barki wrębów (przekrój pełny bez przekroju wrębu –
      # trzy pasy: z lewej, z prawej, od spodu), potem punkty T i scalenie ścian jednej płaszczyzny (rdzen/siatka.rb).
      def siatka(dl, przekroj, b, wreby, w)
        f = []
        lista = odcinki(dl, przekroj, b, wreby, w)
        lista.each do |x0, x1, q|
          n = q.length
          n.times do |i|
            ya, za = q[i]
            yb, zb = q[(i + 1) % n]
            d = Math.sqrt((yb - ya)**2 + (zb - za)**2)
            next if d < 1e-9
            f << { n: [0.0, (zb - za) / d, -(yb - ya) / d], p: [[x0, ya, za], [x0, yb, zb], [x1, yb, zb], [x1, ya, za]] }
          end
        end
        f << { n: [-1.0, 0.0, 0.0], p: lista.first[2].reverse.map { |y, z| [0.0, y, z] } }
        f << { n: [1.0, 0.0, 0.0], p: lista.last[2].map { |y, z| [dl, y, z] } }
        lista.each_cons(2) do |(_a0, a1, qa), (_b0, _b1, qb)|
          pelny, kier = Pryzmat.pole(qa) > Pryzmat.pole(qb) ? [qa, 1.0] : [qb, -1.0]
          barki(pelny, b, w).each do |pas|
            pts = kier > 0 ? pas.map { |y, z| [a1, y, z] } : pas.reverse.map { |y, z| [a1, y, z] }
            f << { n: [kier, 0.0, 0.0], p: pts } if pts.length >= 3 && Pryzmat.pole(pas) > EPS
          end
        end
        Siatka.scal(Siatka.punkty_t(f))
      end

      # Barki wrębu w przekroju pełnym: części poza przekrojem wrębu – pas z lewej (y ≤ bok), z prawej (y ≥ b − bok)
      # i od spodu (bok ≤ y ≤ b − bok, z ≤ dol); wielokąty przeciwnie do wskazówek patrząc od +x.
      def barki(pelny, b, w)
        lewy = przytnij(pelny, 1, w[:bok], -1.0)
        prawy = przytnij(pelny, 1, b - w[:bok], 1.0)
        srodek = przytnij(przytnij(pelny, 1, w[:bok], 1.0), 1, b - w[:bok], -1.0)
        dol = przytnij(srodek, 2, w[:dol], -1.0)
        [lewy, prawy, dol].select { |q| q.length >= 3 }
      end
    end
  end
end
