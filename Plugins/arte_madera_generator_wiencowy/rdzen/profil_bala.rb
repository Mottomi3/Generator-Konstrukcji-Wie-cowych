# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/profil_bala.rb
# Zadanie: pełny profil bala do wizualizacji – pióra na wierzchu i wpust od spodu (pierwszy wieniec bez wpustu); przekrój pasami wzdłuż grubości, objętość.
# Tematy: pełny profil bala, pióro, wpust, podwójne pióro, luz wpustu, pierwszy wieniec bez wpustu, pasy przekroju, objętość z profilem
# Zależy od: rdzen/parametry.rb, rdzen/bryla.rb (punkty podziału, przecięcia ograniczeń, wartości)
# Używają: rdzen/projekt.rb (siatka i objętość pozycji, oznaczenie bali bez wpustu), rdzen/pozycje.rb (opis profilu w pozycji), rdzen/siatka.rb (pasy)
#
# Profil pozycji (poz[:profil], gdy parametr profil_bala = 'pelny'): { pioro: wys. pióra, wpust: głęb. wpustu,
# piora: [[y0, y1]], wpusty: [[y0, y1]] } – y od lica prawego bala (0 … t). Bryła bala = bal prosty (krycie) + pióra
# nad wierzchem − wpusty od spodu; obróbki zamka, otworów i skosu tną wszystkie pasy (pióro w gnieździe zamka znika).
# Zamki, kolizje, pozycje i listy liczone dla bala prostego – pełny profil zmienia tylko bryłę komponentu.
# Wynik przedziały: [{ xa:, xb:, pasy: [{ y0:, y1:, zb_a:, zb_b:, zt_a:, zt_b: }] }] – pasy rosnąco po y.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'bryla') unless defined?(ArteMadera::GeneratorWiencowy::Bryla)

module ArteMadera
  module GeneratorWiencowy
    module ProfilBala
      EPS = 1e-6 unless const_defined?(:EPS)
      # Wierzchy / spody pasów bliższe niż tyle [mm] na końcu przedziału są wyrównywane do niższego – inaczej skos
      # zaczynający się tuż nad wierzchem bala (0,06 mm) dałby krawędź krótszą niż tolerancja SketchUpa.
      WYROWNAJ = 0.2 unless const_defined?(:WYROWNAJ)

      module_function

      # Czy model ma pełny profil bala.
      def pelny?(p)
        p['profil_bala'] == 'pelny'
      end

      # Opis profilu z parametrów (pióra i wpusty w poprzek bala); nil – bal prosty.
      def opis(p)
        return nil unless pelny?(p)
        t = Parametry.grubosc(p)
        hp = p['zamek']['pioro'].to_f
        luz = p['wpust_luz'].to_f
        sz = p['pioro_szerokosc'].to_f
        osie = p['pioro_liczba'].to_s == '1' ? [t / 2.0] : [t / 2.0 - p['pioro_rozstaw'].to_f / 2.0, t / 2.0 + p['pioro_rozstaw'].to_f / 2.0]
        przedzial = lambda { |c, s| [[c - s / 2.0, 0.0].max, [c + s / 2.0, t].min] }
        { pioro: hp, wpust: hp + luz, piora: osie.map { |c| przedzial.call(c, sz) }, wpusty: osie.map { |c| przedzial.call(c, sz + luz) } }
      end

      # Bale na spodzie domu (pierwszy wieniec, półbal) bez wpustu – cecha 'bez_wpustu' (inna pozycja niż bal z wpustem).
      def oznacz(bale, p)
        return unless pelny?(p)
        bale.each do |b|
          next unless b[:z0].abs < 0.01
          b[:cechy] << { typ: 'bez_wpustu', x0: 0.0, x1: b[:dl] }
        end
      end

      # Pasy przekroju: [[y0, y1, nadwyżka wierzchu (pióro), podniesienie spodu (wpust)]] od lica prawego.
      def pasy_przekroju(t, opis, bez_wpustu)
        ys = [0.0, t]
        (opis[:piora] + opis[:wpusty]).each { |a, b| ys << a << b }
        ys = ys.map { |y| y.round(6) }.uniq.sort
        ys.each_cons(2).map do |y0, y1|
          ym = (y0 + y1) / 2.0
          gora = opis[:piora].any? { |a, b| ym > a && ym < b } ? opis[:pioro] : 0.0
          dol = !bez_wpustu && opis[:wpusty].any? { |a, b| ym > a && ym < b } ? opis[:wpust] : 0.0
          [y0, y1, gora, dol]
        end
      end

      # Przedziały pełnego profilu bala dl × t × h z obróbkami (cechy jak Bryla.profil) – patrz opis pliku.
      def przedzialy(dl, t, h, cechy, opis)
        ciecia_gora = []
        ciecia_dol = []
        boki = []
        bez_wpustu = false
        cechy.each do |c|
          case c[:typ]
          when 'gniazdo_gora', 'wyciecie_gora' then ciecia_gora << [c[:x0], c[:x1], h - c[:gleb], h - c[:gleb]]
          when 'gniazdo_dol', 'wyciecie_dol' then ciecia_dol << [c[:x0], c[:x1], c[:gleb], c[:gleb]]
          when 'skos_gora' then ciecia_gora << [c[:x0], c[:x1], c[:z0], c[:z1]]
          when 'podciecie' then boki << c
          when 'bez_wpustu' then bez_wpustu = true
          end
        end
        ciecia_gora = Bryla.wyrownaj_poziomy(ciecia_gora, h, true)
        ciecia_dol = Bryla.wyrownaj_poziomy(ciecia_dol, 0.0, false)
        pasy = pasy_przekroju(t, opis, bez_wpustu).map do |y0, y1, g, d|
          [y0, y1, [[0.0, dl, h + g, h + g]] + ciecia_gora, [[0.0, dl, d, d]] + ciecia_dol]
        end
        xs = [0.0, dl]
        (ciecia_gora + ciecia_dol).each { |c| xs << c[0] << c[1] }
        boki.each { |c| xs << c[:x0] << c[:x1] }
        linie = pasy.map { |pas| pas[2] + pas[3] }.flatten(1).uniq
        Bryla.punkty_podzialu(xs, dl, Bryla.przeciecia(linie)).each_cons(2).map { |xa, xb| przedzial(xa, xb, t, pasy, boki) }.compact
      end

      # Jeden przedział xa…xb: pasy z wierzchem i spodem (ograniczenia pasa w środku przedziału), zwężone podcięciami.
      def przedzial(xa, xb, t, pasy, boki)
        xm = (xa + xb) / 2.0
        lo = 0.0
        hi = t
        boki.each do |c|
          next unless c[:x0] < xm && c[:x1] > xm
          c[:strona] == 0 ? lo = [lo, c[:gleb]].max : hi = [hi, t - c[:gleb]].min
        end
        wynik = []
        pasy.each do |y0, y1, gora, dol|
          ya = [y0, lo].max
          yb = [y1, hi].min
          next if yb - ya <= EPS
          zt_a, zt_b = Bryla.wartosci(gora, xa, xb, xm, :min)
          zb_a, zb_b = Bryla.wartosci(dol, xa, xb, xm, :max)
          next unless Bryla.klin_ok?(zb_a, zb_b, zt_a, zt_b)
          wynik << { y0: ya, y1: yb, zb_a: zb_a, zb_b: zb_b, zt_a: [zt_a, zb_a].max, zt_b: [zt_b, zb_b].max }
        end
        %i[zt_a zt_b zb_a zb_b].each { |k| wyrownaj!(wynik, k) }
        wynik.empty? ? nil : { xa: xa, xb: xb, pasy: wynik }
      end

      # Wyrównanie wartości (wierzchów albo spodów na jednym końcu) różnych o mniej niż WYROWNAJ – do najniższej z grupy.
      def wyrownaj!(pasy, klucz)
        wartosci = pasy.map { |c| c[klucz] }
        pasy.each do |c|
          niz = wartosci.select { |v| v < c[klucz] - EPS && c[klucz] - v < WYROWNAJ }.min
          c[klucz] = niz if niz
        end
      end

      # Objętość przedziałów (pełny profil albo prosty – Bryla.profil) [mm³].
      def objetosc(prof)
        prof.inject(0.0) do |suma, q|
          (q[:pasy] || [q]).inject(suma) do |s, c|
            s + (q[:xb] - q[:xa]) * (c[:y1] - c[:y0]) * ((c[:zt_a] - c[:zb_a]) + (c[:zt_b] - c[:zb_b])) / 2.0
          end
        end
      end
    end
  end
end
