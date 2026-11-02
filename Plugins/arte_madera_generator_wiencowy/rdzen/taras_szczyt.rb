# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/taras_szczyt.rb
# Zadanie: szczyt nad tarasem z podciągiem – pełny (jak 1100), ażurowy (bale na przemian z rzędami przekładek, jak balustrada) albo pusty (kilka bali spinających nad podciągiem, wyżej tylko słupki z przekładek pod płatwiami).
# Tematy: szczyt nad tarasem, szczyt ażurowy, szczyt pusty, trójkątny wieniec, belki szczytu pod płatwiami, przekładki w szczycie, bale spinające szczyt, słupek pod płatwią
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wysokość ścian okapowych), rdzen/szczyty.rb (zasięg pod linią szczytu, s ↔ v), rdzen/dach.rb (płatwie)
# Używają: rdzen/bale.rb (kawałki wieńca frontu tarasu), rdzen/projekt.rb (belki trójkątnego wieńca)
#
# Wieńce szczytu frontu = wieńce nad pierwszym balem szczytu (ten zamyka się z górnymi balami ścian bocznych i zostaje
# pełny razem z podciągiem). Numer j wieńca szczytu od 0. Ażurowy: j parzyste – pełne bale, j nieparzyste – przekładki.
# Pusty: j < taras_szczyt_bale – pełne bale (spinają front), wyżej – przekładki tylko pod płatwiami (płatwie nad tarasem
# zostają podparte od frontu). Przekładki (długość taras_przekladka): pod każdą płatwią, przy końcach zasięgu wieńca
# wyżej (bal nad nimi ma na czym leżeć) i równo między nimi, prześwit nie większy niż taras_przekladka_odstep.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)
require File.join(File.dirname(__FILE__), 'szczyty') unless defined?(ArteMadera::GeneratorWiencowy::Szczyty)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)

module ArteMadera
  module GeneratorWiencowy
    module TarasSzczyt
      module_function

      # Czy ściana to front tarasu z podciągiem ze szczytem innym niż pełny.
      def dotyczy?(w, p)
        tr = w[:taras]
        tr && tr[:rola] == :front && tr[:wariant] == 'podciag' && w[:szczyt] && %w[azurowy pusty].include?(p['taras_szczyt'])
      end

      # Numer wieńca szczytu (0 – pierwszy nad balem zamykającym się ze ścianami bocznymi) albo nil (podciąg, balustrada).
      def numer(w, z0, p)
        h = Parametry.krycie(p)
        z_start = Wience.wysokosci(p)[:okapowa] + h / 2.0
        return nil if z0 < z_start - 0.01
        ((z0 - z_start) / h + 0.5).floor
      end

      # Przedziały bali wieńca o spodzie z0 na froncie tarasu (zas – zasięg pod linią szczytu): pełny wieniec – [zas],
      # wieniec przekładek – kawałki przekładek, bez kawałków – [].
      def przedzialy(w, wn, zas, p)
        return [zas] unless dotyczy?(w, p)
        j = numer(w, wn[:z0], p)
        return [zas] if j.nil?
        pelny = p['taras_szczyt'] == 'azurowy' ? j.even? : j < p['taras_szczyt_bale'].to_i
        return [zas] if pelny
        return [] if wieniec?(p)
        przekladki(w, wn, zas, p, p['taras_szczyt'] == 'azurowy')
      end

      # Kawałki przekładek w wieńcu (zas – zasięg wieńca); wypelnij – także przy końcach i między (ażurowy), inaczej tylko
      # pod płatwiami (pusty).
      def przekladki(w, wn, zas, p, wypelnij)
        l = p['taras_przekladka'].to_f
        lo, hi = zas
        srodki = osie_platwi(w, p).select { |s| s - l / 2.0 > lo - 0.01 && s + l / 2.0 < hi + 0.01 }
        if wypelnij
          wyzej = Szczyty.zasieg(w, wn[:z0] + wn[:h], p) || zas
          a = [lo, wyzej[0]].max + l / 2.0
          b = [hi, wyzej[1]].min - l / 2.0
          srodki = (srodki + (b - a > l ? [a, b] : [(lo + hi) / 2.0])).sort
          srodki = uzupelnij(srodki, l, p['taras_przekladka_odstep'].to_f)
        end
        kawalki = srodki.uniq.map { |s| [[s - l / 2.0, lo].max, [s + l / 2.0, hi].min] }.select { |x0, x1| x1 - x0 > 1.0 }
        scal(kawalki)
      end

      # Czy szczyt pusty ma trójkątny wieniec (zamiast słupków z przekładek); dach dwuspadowy.
      def wieniec?(p)
        p['taras_szczyt'] == 'pusty' && p['taras_wieniec'] != 'brak' && !Dach.jednospadowy?(p)
      end

      # Trójkątny wieniec nad pustym szczytem frontu tarasu: dwie belki (prefiks Wt) w płaszczyźnie frontu, od wierzchu bali
      # spinających do kalenicy, wierzch na linii spodu płatwi (płatwie leżą na nich), przekrój z płatwi albo podany.
      # Belka – graniastosłup (rdzen/pryzmat.rb) wzdłuż kalenicy o szerokości wieńca, przekrój w płaszczyźnie frontu.
      def wience(sciany, p)
        return [] unless wieniec?(p)
        w = sciany.find { |x| dotyczy?(x, p) }
        return [] if w.nil? || w[:bale].empty?
        bw, hw = Parametry.przekroj(p, p['taras_wieniec'] == 'wlasny' ? 'taras_wieniec_przekroj' : 'platwa_przekroj')
        geo = w[:szczyt]
        platwie = Dach.platwie(geo, p)
        d = platwie.map { |pl| [pl[:v] - pl[:b] / 2.0, pl[:v] + pl[:b] / 2.0].map { |x| Dach.linia_podparcia(geo, x, p) }.max - pl[:z_spod] }.max || 0.0
        z_t = w[:bale].map { |b| b[:z0] + b[:h] }.max
        vk = (geo[:v_a] + geo[:v_b]) / 2.0
        t = Parametry.grubosc(p)
        iu = (w[:a][0] - w[:b][0]).abs < 0.5 ? 0 : 1
        u_f = w[:a][iu]
        os = iu.zero? ? :x : :y
        [[geo[:v_a] - t / 2.0, 1.0], [geo[:v_b] + t / 2.0, -1.0]].map do |v_lico, kier|
          ksztalt = polowa(geo, p, d, hw, z_t, vk, v_lico, kier)
          next nil if ksztalt.nil?
          belka(os, u_f, bw, z_t, ksztalt)
        end.compact
      end

      # Przekrój połowy wieńca w płaszczyźnie frontu: punkty [v, z] (od lica ściany bocznej v_lico w stronę kalenicy, kier ±1)
      # między wierzchem bali spinających z_t, linią T(v) = linia podparcia − d (spód płatwi) i T − grubość w pionie; nil –
      # brak miejsca (linia pod balami).
      def polowa(geo, p, d, hw, z_t, vk, v_lico, kier)
        tg = Dach.tg(p)
        hv = hw / Math.cos(Dach.kat(p))
        top = lambda { |v| Dach.linia_podparcia(geo, v, p) - d }
        return nil if top.call(vk) <= z_t + 1.0
        # T rośnie w stronę kalenicy o tg na mm: miejsce, gdzie T = z_t, i gdzie dolna krawędź (T − hv) = z_t.
        v1 = vk - kier * (top.call(vk) - z_t) / tg
        v1 = v_lico if (v1 - v_lico) * kier < 0.0
        v2 = vk - kier * (top.call(vk) - hv - z_t) / tg
        pts = [[v1, [top.call(v1), z_t].max]]
        pts << [v1, z_t] if top.call(v1) > z_t + 0.5
        if (vk - v2) * kier > 0.5
          pts << [v2, z_t] if (v2 - v1) * kier > 0.5
          pts << [vk, top.call(vk) - hv]
        else
          pts << [vk, z_t]
        end
        pts << [vk, top.call(vk)]
        pts
      end

      # Belka Wt: graniastosłup wzdłuż kalenicy (od u_f − bw/2 do u_f + bw/2) o przekroju ksztalt ([v, z] w płaszczyźnie
      # frontu) – przekrój w układzie belki (y wzdłuż v jak w Elementy.pozioma, z od spodu z_t).
      def belka(os, u_f, bw, z_t, ksztalt)
        vs = ksztalt.map { |v, _z| v }
        v_lo, v_hi = vs.minmax
        vc = (v_lo + v_hi) / 2.0
        szer = v_hi - v_lo
        wys = ksztalt.map { |_v, z| z }.max - z_t
        p0 = os == :x ? [u_f - bw / 2.0, vc] : [vc, u_f - bw / 2.0]
        p1 = os == :x ? [u_f + bw / 2.0, vc] : [vc, u_f + bw / 2.0]
        znak = os == :x ? 1.0 : -1.0
        przekroj = ksztalt.map { |v, z| [szer / 2.0 + znak * (v - vc), z - z_t] }
        przekroj.reverse! if pole(przekroj) < 0.0
        Elementy.pozioma('Wt', p0, p1, szer, wys, z_t, :os, [], przekroj)
      end

      # Pole wielokąta [[y, z]] ze znakiem (dodatnie – przeciwnie do wskazówek).
      def pole(pts)
        pts.each_with_index.inject(0.0) do |s, (a, i)|
          b = pts[(i + 1) % pts.length]
          s + a[0] * b[1] - b[0] * a[1]
        end / 2.0
      end

      # Osie płatwi na froncie (s ściany).
      def osie_platwi(w, p)
        Dach.platwie(w[:szczyt], p).map { |pl| Szczyty.s_z_v(w, pl[:v]) }.sort
      end

      # Dodatkowe środki przekładek tam, gdzie prześwit między sąsiednimi przekracza odstęp (równo w luce).
      def uzupelnij(srodki, l, odstep)
        wynik = []
        srodki.each_cons(2) do |a, b|
          wynik << a
          luka = b - a - l
          next if luka <= odstep + 0.01
          n = ((luka + l) / (odstep + l) - 1e-9).ceil
          (1...n).each { |i| wynik << a + (b - a) * i / n }
        end
        wynik << srodki.last unless srodki.empty?
        wynik
      end

      # Nachodzące na siebie kawałki scalone w jeden.
      def scal(kawalki)
        kawalki.sort.each_with_object([]) do |(a, b), wynik|
          if !wynik.empty? && a <= wynik.last[1] + 0.01
            wynik.last[1] = [wynik.last[1], b].max
          else
            wynik << [a, b]
          end
        end
      end
    end
  end
end
