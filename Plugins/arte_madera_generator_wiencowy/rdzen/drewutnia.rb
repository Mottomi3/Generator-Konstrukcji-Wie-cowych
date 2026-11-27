# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/drewutnia.rb
# Zadanie: drewutnia / zadaszenie przy ścianie szczytowej domu prostokątnego – wiata z dachem jednospadowym od ściany: dwa rzędy słupów (przy ścianie i zewnętrzny) z fundamentami, płatew przy ścianie i oczep, krokwie; położenie pod okapem dachu domu z zapasem na osiadanie, z dala od węgłów, działowych i podwaliny.
# Tematy: drewutnia, zadaszenie przy ścianie szczytowej, wiata przy szczycie, dach jednospadowy drewutni, słupy drewutni, płatew drewutni, oczep drewutni, krokwie drewutni, drewutnia pod okapem dachu, drewutnia a osiadanie ścian, dodatki domu
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (opis dachu, linia podparcia, punkt rzutu), rdzen/elementy.rb, rdzen/fundamenty.rb, rdzen/osiadanie.rb (osiadanie dachu domu), rdzen/zadaszenie.rb (słup)
# Używają: rdzen/projekt.rb (elementy, podpowiedzi), rdzen/statyka_drewutni.rb (wymiary do sprawdzenia)
#
# Odpowiedź użytkownika z rundy 19 („typ + dodatki” – „tak, zacznij od drewutni / zadaszenia przy ścianie szczytowej
# z tyłu”). Wzór jak boczne zadaszenie na słupach (rdzen/zadaszenie.rb), ale dach osobny – jednospadowy, ze spadkiem od
# ściany szczytowej, pod okapem dachu domu. Wiata stoi obok ściany i jej nie dotyka: ściana z bali osiada (osiadanie_scian),
# a słupy nie – dlatego rząd słupów stoi przy ścianie, a wierzch krokwi jest niżej niż dach domu o odstęp i osiadanie.
# Przekrój wzdłuż kalenicy domu (s – odległość od lica ściany szczytowej na zewnątrz):
#   s_k – początek krokwi (za węgłami i działowymi wychodzącymi przed ścianę + odstęp), s_a – oś rzędu przy ścianie (słup
#   i jego fundament za podwaliną i fundamentami domu + odstęp), s_b – oś rzędu zewnętrznego (lico zewnętrzne słupów na głębokości), s_e –
#   koniec krokwi (okap za słupami). Wierzch krokwi: z(s) = h_k − tg α · (s − s_k); spód: z(s) − h / cos α; płatew i oczep
#   pod krokwiami (wierzch = spód krokwi przy krawędzi zewnętrznej belki).
# Wzdłuż ściany (v): między ostatkami ścian okapowych z odstępem albo węższa, na środku ściany.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)
require File.join(File.dirname(__FILE__), 'fundamenty') unless defined?(ArteMadera::GeneratorWiencowy::Fundamenty)
require File.join(File.dirname(__FILE__), 'osiadanie') unless defined?(ArteMadera::GeneratorWiencowy::Osiadanie)
require File.join(File.dirname(__FILE__), 'zadaszenie') unless defined?(ArteMadera::GeneratorWiencowy::Zadaszenie)

module ArteMadera
  module GeneratorWiencowy
    module Drewutnia
      # Najniższy słup [mm] – niższy: drewutnia pominięta z uwagą.
      MIN_SLUP = 300.0 unless const_defined?(:MIN_SLUP)
      # Najmniejsza odległość osi rzędów słupów [mm].
      MIN_PRZESLO = 400.0 unless const_defined?(:MIN_PRZESLO)
      # Krok punktów na krawędziach belek dachu domu przy szukaniu wysokości [mm].
      KROK = 25.0 unless const_defined?(:KROK)

      module_function

      # Czy wybrano drewutnię.
      def wybrana?(p)
        p['drewutnia'].to_s == 'slupy'
      end

      # Strona ściany szczytowej: +1 – przy szczycie o większym u, −1 – o mniejszym; „z tyłu” – naprzeciw tarasu (bez tarasu
      # −1, bo taras stoi fabrycznie po stronie +1).
      def kier(p)
        case p['drewutnia_strona'].to_s
        when 'max' then 1.0
        when 'min' then -1.0
        else
          taras = %w[podciag sciany].include?(p['taras'].to_s)
          taras && p['taras_strona'].to_s == 'min' ? 1.0 : -1.0
        end
      end

      # Powód, dla którego drewutnia nie powstaje przy tych parametrach (nil – może powstać).
      def przeszkoda(p)
        return nil unless wybrana?(p)
        return 'Drewutnia: tylko przy szczytach z bali i dachu z generatora – pominięta.' unless Parametry.tak?(p, 'szczyty') && Parametry.tak?(p, 'dach_elementy')
        if %w[podciag sciany].include?(p['taras'].to_s) && kier(p) == (p['taras_strona'].to_s == 'min' ? -1.0 : 1.0)
          return 'Drewutnia po tej samej stronie co taras – pominięta (wybierz „z tyłu” albo drugą ścianę szczytową).'
        end
        nil
      end

      # Przekrój wzdłuż kalenicy i ściany: { kier:, u_lico:, v_lo:, v_hi:, s_k:, s_a:, s_b:, s_e:, h_k:, tg:, kat:,
      # z_dol:, belka: [b, h], slup: [wzdłuż ściany, w poprzek], krokiew: [b, h], obnizona: (wysokość z parametru
      # obniżona do dachu) } albo { uwaga: } – nie da się postawić; nil – bez drewutni.
      def geo(dom, sciany, elementy, p)
        return nil unless wybrana?(p) && przeszkoda(p).nil? && dom && dom[:boczne].nil? && dom[:rola].nil?
        t = Parametry.grubosc(p)
        k = kier(p)
        odst = p['drewutnia_odstep'].to_f
        u_lico = (k > 0 ? dom[:u2] : dom[:u1]) + k * t / 2.0
        w_max = dom[:v_b] - dom[:v_a] - t - 2.0 * odst
        w = p['drewutnia_szerokosc'].to_f
        w = w_max if w < 1.0 || w > w_max
        vc = (dom[:v_a] + dom[:v_b]) / 2.0
        c = { kier: k, u_lico: u_lico, v_lo: vc - w / 2.0, v_hi: vc + w / 2.0, kat: p['drewutnia_kat'].to_f * Math::PI / 180.0,
              belka: Parametry.przekroj(p, 'drewutnia_belka_przekroj'), slup: Parametry.przekroj(p, 'drewutnia_slup_przekroj'),
              krokiew: Parametry.przekroj(p, 'krokiew_przekroj'), z_dol: Zadaszenie.z_podstawy(p) }
        c[:tg] = Math.tan(c[:kat])
        c[:s_k] = wystep_scian(dom, sciany, c, t) + odst
        fund = Fundamenty.wlaczone?(p) ? Fundamenty.wymiar(p) : 0.0
        c[:s_a] = [c[:s_k] + [c[:slup][1], c[:belka][0]].max / 2.0, wystep_dolu(dom, elementy, c) + odst + [c[:slup][1], fund].max / 2.0].max
        c[:s_b] = p['drewutnia_glebokosc'].to_f - c[:slup][1] / 2.0
        c[:s_e] = p['drewutnia_glebokosc'].to_f + p['drewutnia_okap'].to_f
        return { uwaga: 'Drewutnia: za płytka – słupy przy ścianie i zewnętrzne nie mieszczą się (zwiększ głębokość).' } if c[:s_b] - c[:s_a] < MIN_PRZESLO
        return { uwaga: 'Drewutnia: ściana szczytowa za wąska.' } if w < 2.0 * c[:slup][0]
        wysokosc!(c, dom, elementy, p)
        return { uwaga: 'Drewutnia: pod okapem dachu domu za nisko na słupy (zmniejsz kąt albo głębokość).' } if z_belki(c, c[:s_b]) - c[:belka][1] - c[:z_dol] < MIN_SLUP
        c
      end

      # Wysokość wierzchu krokwi przy ścianie c[:h_k]: z parametru albo najwyżej – pod dachem domu (linia podparcia przy
      # ostatkach i punkty belek dachu nad drewutnią) z odstępem i osiadaniem ścian pod dachem; c[:obnizona] – parametr za
      # wysoki.
      def wysokosc!(c, dom, elementy, p)
        geo = Dach.geo(dom)
        zapas = lambda { |z| z - Osiadanie.luz(z, p) - p['drewutnia_odstep_dachu'].to_f }
        granice = [[c[:s_k], zapas.call([Dach.linia_podparcia(geo, c[:v_lo], p), Dach.linia_podparcia(geo, c[:v_hi], p)].min)]]
        elementy.each do |e|
          next if e[:tag] == :drewutnia || e[:tag] == :podloga
          s0, s1, v0, v1, z0 = obrys_elementu(dom, e, c)
          next if s1 < c[:s_k] || s0 > c[:s_e] || v1 < c[:v_lo] || v0 > c[:v_hi] || z0 < 1000.0
          punkty_nad(dom, e, c).each { |s, z| granice << [[s, c[:s_k]].max, zapas.call(z)] }
        end
        h_max = granice.map { |s, z| z + c[:tg] * (s - c[:s_k]) }.min
        h = p['drewutnia_wysokosc'].to_f
        c[:obnizona] = h > h_max + 0.5
        c[:h_k] = h < 1.0 || h > h_max ? h_max : h
      end

      # Punkty krawędzi elementu (co najwyżej co KROK wzdłuż osi, cztery krawędzie podłużne) nad drewutnią: [[s, z]] – belka
      # ukośna (krokiew dachu domu) liczy się tylko tam, gdzie wisi nad drewutnią, nie najniższym punktem okapu.
      def punkty_nad(dom, e, c)
        pe = e[:polozenie]
        iu = dom[:os] == :x ? 0 : 1
        n = [(e[:dl] / KROK).ceil, 1].max
        (0..n).flat_map do |i|
          x = e[:dl] * i / n
          [0.0, e[:b]].product([0.0, e[:h]]).map do |y, z|
            q = (0..2).map { |k| pe[:poczatek][k] + pe[:x][k] * x + pe[:y][k] * y + pe[:z][k] * z }
            s = (q[iu] - c[:u_lico]) * c[:kier]
            v = q[1 - iu]
            s >= c[:s_k] - KROK && s <= c[:s_e] + 1.0 && v >= c[:v_lo] - KROK && v <= c[:v_hi] + KROK ? [s, q[2]] : nil
          end.compact
        end
      end

      # Otoczka elementu w układzie drewutni: [s0, s1, v0, v1, z_spod].
      def obrys_elementu(dom, e, c)
        pe = e[:polozenie]
        naroza = [0.0, e[:dl]].product([0.0, e[:b]], [0.0, e[:h]]).map do |x, y, z|
          (0..2).map { |i| pe[:poczatek][i] + pe[:x][i] * x + pe[:y][i] * y + pe[:z][i] * z }
        end
        iu = dom[:os] == :x ? 0 : 1
        ss = naroza.map { |q| (q[iu] - c[:u_lico]) * c[:kier] }
        vs = naroza.map { |q| q[1 - iu] }
        [ss.min, ss.max, vs.min, vs.max, naroza.map { |q| q[2] }.min]
      end

      # Największe wystawanie przed lico ściany szczytowej ścian w poprzek (węgły, działowe) w pasie drewutni [mm].
      def wystep_scian(dom, sciany, c, t)
        iv = dom[:os] == :x ? 1 : 0
        iu = 1 - iv
        (sciany || []).map do |w|
          next 0.0 if w[:kier][iu].abs < 0.5 || w[:a][iv] + t / 2.0 < c[:v_lo] || w[:a][iv] - t / 2.0 > c[:v_hi]
          [w[:s_od], w[:s_do]].map { |s| (w[:a][iu] + w[:kier][iu] * s - c[:u_lico]) * c[:kier] }.max
        end.compact.push(0.0).max
      end

      # Największe wystawanie przed lico podwaliny i fundamentów domu w pasie drewutni [mm] (słupy stoją obok nich).
      def wystep_dolu(dom, elementy, c)
        (elementy || []).select { |e| %w[Pw F].include?(e[:prefiks]) && e[:tag] != :drewutnia }.map do |e|
          s0, s1, v0, v1, = obrys_elementu(dom, e, c)
          s0 < 1.0 && s1 > 0.0 && v1 > c[:v_lo] && v0 < c[:v_hi] ? s1 : 0.0
        end.push(0.0).max
      end

      # Wierzch krokwi w odległości s od lica ściany [mm].
      def z_krokwi(c, s)
        c[:h_k] - c[:tg] * (s - c[:s_k])
      end

      # Wierzch belki (płatew, oczep) o osi s: spód krokwi przy krawędzi zewnętrznej belki.
      def z_belki(c, s)
        z_krokwi(c, s + c[:belka][0] / 2.0) - c[:krokiew][1] / Math.cos(c[:kat])
      end

      # Punkt rzutu w układzie drewutni (s od lica, v wzdłuż ściany).
      def xy(dom, c, s, v)
        Dach.xy(dom, c[:u_lico] + c[:kier] * s, v)
      end

      # Położenia v słupów jednego rzędu: na końcach i równo, co najwyżej drewutnia_slupy_rozstaw.
      def slupy_v(c, p)
        a = c[:v_lo] + c[:slup][0] / 2.0
        b = c[:v_hi] - c[:slup][0] / 2.0
        n = [((b - a) / p['drewutnia_slupy_rozstaw'].to_f - 1e-9).ceil, 1].max
        (0..n).map { |i| a + (b - a) * i / n }
      end

      # Położenia v krokwi: na końcach i równo, co najwyżej krokwie_rozstaw.
      def krokwie_v(c, p)
        a = c[:v_lo] + c[:krokiew][0] / 2.0
        b = c[:v_hi] - c[:krokiew][0] / 2.0
        n = [((b - a) / p['krokwie_rozstaw'].to_f - 1e-9).ceil, 1].max
        (0..n).map { |i| a + (b - a) * i / n }
      end

      # Elementy drewutni (tag :drewutnia): słupy z fundamentami, płatew przy ścianie, oczep, krokwie; [] bez drewutni.
      # inne – elementy domu policzone wcześniej (dach nad drewutnią, podwaliny i fundamenty przy ścianie).
      def elementy(dom, sciany, inne, p)
        c = geo(dom, sciany, inne, p)
        return [] if c.nil? || c[:uwaga]
        bb, hb = c[:belka]
        wynik = []
        [[c[:s_a], 'Płatew drewutni przy ścianie'], [c[:s_b], 'Oczep drewutni']].each do |s, nazwa|
          z = z_belki(c, s)
          e = Elementy.pozioma('P', xy(dom, c, s, c[:v_lo]), xy(dom, c, s, c[:v_hi]), bb, hb, z - hb, :os)
          wynik << e.merge!(rodzaj: nazwa, tag: :drewutnia)
          slupy_v(c, p).each do |v|
            wynik << slup(dom, c, s, v, z - hb)
            next unless Fundamenty.wlaczone?(p)
            wynik.concat(Fundamenty.elementy([[xy(dom, c, s, v), c[:z_dol]]], p).map do |f|
              f.merge!(rodzaj: 'Fundament słupa drewutni', tag: :drewutnia)
            end)
          end
        end
        wynik.concat(krokwie(dom, c, p))
      end

      # Słup drewutni (S) w osi (s, v) od podstawy do z_gora; przekrój: wzdłuż ściany × w poprzek (wymiary w osiach X, Y).
      def slup(dom, c, s, v, z_gora)
        wzdluz, poprzek = c[:slup]
        sx, sy = dom[:os] == :x ? [poprzek, wzdluz] : [wzdluz, poprzek]
        q = xy(dom, c, s, v)
        Elementy.nowy('S', z_gora - c[:z_dol], sx, sy, [q[0] - sx / 2.0, q[1] - sy / 2.0, c[:z_dol]], [0.0, 0.0, 1.0],
                      [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], []).merge!(rodzaj: 'Słup drewutni', tag: :drewutnia)
      end

      # Krokwie (K) od okapu (s_e) w górę do ściany (s_k), spód na linii spodu krokwi.
      def krokwie(dom, c, p)
        bk, hk = c[:krokiew]
        d = dom[:os] == :x ? [-c[:kier], 0.0] : [0.0, -c[:kier]]
        z0 = z_krokwi(c, c[:s_e]) - hk / Math.cos(c[:kat])
        dl = (c[:s_e] - c[:s_k]) / Math.cos(c[:kat])
        krokwie_v(c, p).map do |v|
          q = xy(dom, c, c[:s_e], v)
          Elementy.ukosna('K', [q[0], q[1], z0], d, c[:kat], dl, bk, hk).merge!(rodzaj: 'Krokiew drewutni', tag: :drewutnia)
        end
      end

      # Podpowiedzi do sekcji „Drewutnia” ([{ poziom:, tekst: }]).
      def podpowiedzi(dom, sciany, inne, p)
        return [] unless wybrana?(p)
        u = przeszkoda(p)
        return [{ poziom: 'uwaga', tekst: u }] if u
        return [{ poziom: 'uwaga', tekst: 'Drewutnia: tylko dla domu prostokątnego – pominięta.' }] if dom.nil? || dom[:boczne] || dom[:rola]
        c = geo(dom, sciany, inne.reject { |e| e[:tag] == :drewutnia }, p)
        return [{ poziom: 'uwaga', tekst: c[:uwaga] }] if c[:uwaga]
        tekst = format('Drewutnia: %s × %s mm, dach %s°, wierzch krokwi przy ścianie %s mm, prześwit pod oczepem %s mm, słupy: %d',
                       Parametry.fmt((c[:v_hi] - c[:v_lo]).round), Parametry.fmt(p['drewutnia_glebokosc'].to_f),
                       Parametry.fmt(p['drewutnia_kat'].to_f), Parametry.fmt(c[:h_k].round),
                       Parametry.fmt((z_belki(c, c[:s_b]) - c[:belka][1]).round), 2 * slupy_v(c, p).length)
        wynik = [{ poziom: 'ok', tekst: tekst + '.' }]
        if c[:obnizona]
          wynik << { poziom: 'uwaga', tekst: format('Drewutnia: wysokość %s mm nie mieści się pod dachem domu (z odstępem i ' \
                                                    'osiadaniem) – obniżona do %s mm.', Parametry.fmt(p['drewutnia_wysokosc'].to_f),
                                                    Parametry.fmt(c[:h_k].round)) }
        end
        wynik
      end
    end
  end
end
