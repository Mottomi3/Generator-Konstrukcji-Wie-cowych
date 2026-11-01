# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/bryla.rb
# Zadanie: bryła bala z obróbek – profil wzdłuż bala (przedziały z zakresem grubości i wysokości), przynależność punktu, objętość, podpis.
# Tematy: bryła bala, profil bala, przedziały, obróbki bala, objętość, podpis bala, obrót o 180°, identyczne bale, skos (szczyty), wyrównanie bliskich poziomów obróbek, punkty podziału profilu (granice obróbek przed przecięciami), ścięcie dachu w poprzek bala, pasy ze skośnym wierzchem
# Zależy od: –
# Używają: rdzen/siatka.rb, rdzen/pozycje.rb, rdzen/kontrola.rb
#
# Układ bala: x od czoła (0 … dl), y od lica prawego (0 … t), z od spodu (0 … h).
# Obróbki (cechy): gniazdo_gora / wyciecie_gora (wierzch obniżony do h − gleb na x0…x1), gniazdo_dol / wyciecie_dol
# (spód podniesiony do gleb), podciecie (strona 0: y ≥ gleb, strona 1: y ≤ t − gleb), skos_gora (wierzch ≤ prosta
# z0 → z1 na x0…x1, do szczytów), sciecie_dachu (wierzch ≤ płaszczyzna dachu w poprzek bala: z0 na licu y = 0, z1 na
# licu y = t, na x0…x1 – górny bal ściany pod połacią, rdzen/sciecie_dachu.rb). W każdym przedziale profilu: stały
# zakres y, wierzch i spód liniowe; przedział ze ścięciem dachu ma pasy (q[:pasy]) – wierzch pasa może opadać w poprzek
# (kt – dz/dy), q[:zt_a], q[:zt_b] to wtedy najwyższy wierzch przedziału (obrys w widoku ściany).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module Bryla
      EPS = 1e-6 unless const_defined?(:EPS)
      # Dokładność podpisu bala [mm] – bale różniące się mniej są tą samą pozycją.
      DOKLADNOSC = 0.1 unless const_defined?(:DOKLADNOSC)
      # Punkty podziału profilu bliższe niż tyle [mm] są scalane – krawędź krótsza niż tolerancja SketchUpa (0,0254 mm)
      # psuje ścianę bryły, a różnica 0,2 mm jest poniżej dokładności obróbki.
      SCAL = 0.2 unless const_defined?(:SCAL)
      # Ujemna wysokość przedziału na jednym końcu [mm], którą klin_ok? jeszcze przyjmuje (ostrze klina przesunięte
      # najwyżej o SCAL do punktu podziału: SCAL × tg kąta dachu do 60°).
      OSTRZE = 0.5 unless const_defined?(:OSTRZE)

      module_function

      # Profil: lista przedziałów { xa:, xb:, y0:, y1:, zb_a:, zb_b:, zt_a:, zt_b: } (puste przedziały pominięte).
      def profil(dl, t, h, cechy)
        gora = [[0.0, dl, h, h]]
        dol = [[0.0, dl, 0.0, 0.0]]
        boki = []
        sciecia = []
        cechy.each do |c|
          case c[:typ]
          when 'sciecie_dachu' then sciecia << c
          when 'gniazdo_gora', 'wyciecie_gora' then gora << [c[:x0], c[:x1], h - c[:gleb], h - c[:gleb]]
          when 'gniazdo_dol', 'wyciecie_dol' then dol << [c[:x0], c[:x1], c[:gleb], c[:gleb]]
          when 'skos_gora' then gora << [c[:x0], c[:x1], c[:z0], c[:z1]]
          when 'podciecie' then boki << c
          end
        end
        gora = wyrownaj_poziomy(gora, h, true)
        dol = wyrownaj_poziomy(dol, 0.0, false)
        xs = [0.0, dl]
        (gora + dol).each { |g| xs << g[0] << g[1] }
        (boki + sciecia).each { |c| xs << c[:x0] << c[:x1] }
        xs = punkty_podzialu(xs, dl, przeciecia(gora + dol))
        wynik = []
        xs.each_cons(2) do |xa, xb|
          xm = (xa + xb) / 2.0
          y0 = 0.0
          y1 = t
          boki.each do |c|
            next unless c[:x0] < xm && c[:x1] > xm
            c[:strona] == 0 ? y0 = [y0, c[:gleb]].max : y1 = [y1, t - c[:gleb]].min
          end
          zt_a, zt_b = wartosci(gora, xa, xb, xm, :min)
          zb_a, zb_b = wartosci(dol, xa, xb, xm, :max)
          next unless klin_ok?(zb_a, zb_b, zt_a, zt_b) && y1 - y0 > EPS
          zt_a = zb_a if zt_a - zb_a < EPS
          zt_b = zb_b if zt_b - zb_b < EPS
          q = { xa: xa, xb: xb, y0: y0, y1: y1, zb_a: zb_a, zb_b: zb_b, zt_a: zt_a, zt_b: zt_b }
          sc = sciecia.find { |c| c[:x0] < xm && c[:x1] > xm }
          q = z_pasami(q, sciecie_pasow([q], sc, t)) if sc
          wynik << q if q
        end
        wynik
      end

      # Część pasa, w której płaszczyzna ścięcia c jest nad spodem pasa (spód – wyższy z końców); nil – nigdzie.
      def nad_spodem(q, c, kt)
        zb = [q[:zb_a], q[:zb_b]].max
        return q if c[:z0] + kt * q[:y0] > zb + EPS && c[:z0] + kt * q[:y1] > zb + EPS
        return nil if kt.abs < EPS
        yk = (zb - c[:z0]) / kt
        y0, y1 = kt > 0 ? [[q[:y0], yk].max, q[:y1]] : [q[:y0], [q[:y1], yk].min]
        y1 - y0 > 0.2 ? q.merge(y0: y0, y1: y1) : nil
      end

      # Przedział z pasami: q[:pasy], obrys (zt_a, zt_b) – najwyższy wierzch pasów; bez pasów – nil (pusty przedział).
      def z_pasami(q, pasy)
        return nil if pasy.empty?
        return q if pasy.length == 1 && (pasy[0][:kt] || 0.0).abs < EPS && (pasy[0][:y1] - q[:y1]).abs < EPS &&
                    (pasy[0][:y0] - q[:y0]).abs < EPS
        gora = pasy.map { |c| [c[:zt_a], c[:zt_a] + (c[:kt] || 0.0) * (c[:y1] - c[:y0])].max }.max
        gora_b = pasy.map { |c| [c[:zt_b], c[:zt_b] + (c[:kt] || 0.0) * (c[:y1] - c[:y0])].max }.max
        q.merge(pasy: pasy, zt_a: gora, zt_b: gora_b)
      end

      # Pasy (wierzch płaski w poprzek) ścięte płaszczyzną dachu c (z0 na y = 0, z1 na y = t): pas pod płaszczyzną zostaje,
      # nad nią – wierzch po płaszczyźnie (kt), przecięty – dwa pasy na granicy. Wierzch zmienny wzdłuż (skos szczytu)
      # przecięty płaszczyzną – wyrównany do niższego końca (drewna ubywa); część pasa, w której płaszczyzna schodzi pod
      # spód, znika (klin – górny bal ściany wysokiej przecięty dachem przez całą wysokość).
      def sciecie_pasow(pasy, c, t)
        kt = (c[:z1] - c[:z0]) / t
        g = lambda { |y| c[:z0] + kt * y }
        pasy.map { |q| nad_spodem(q, c, kt) }.compact.map do |q|
          ga = g.call(q[:y0])
          gb = g.call(q[:y1])
          gmin, gmax = [ga, gb].minmax
          if [q[:zt_a], q[:zt_b]].max <= gmin + EPS
            [q]
          elsif [q[:zt_a], q[:zt_b]].min >= gmax - EPS
            [q.merge(zt_a: ga, zt_b: ga, kt: kt)]
          else
            zt = [q[:zt_a], q[:zt_b]].min
            plaski = q.merge(zt_a: zt, zt_b: zt)
            next [plaski] if zt <= gmin + EPS
            yk = (zt - c[:z0]) / kt
            lewy = plaski.merge(y1: yk)
            prawy = plaski.merge(y0: yk)
            kt > 0 ? [lewy.merge(zt_a: ga, zt_b: ga, kt: kt), prawy] : [lewy, prawy.merge(zt_a: zt, zt_b: zt, kt: kt)]
          end
        end.flatten(1)
      end

      # Czy przedział ma materiał: wysokość dodatnia na co najmniej jednym końcu i nigdzie ujemna – także klin (skos
      # szczytu doprowadzony do spodu bala: wysokość zero na jednym końcu, bal kończy się ostrzem, nie pionowym czołem).
      # Ujemna do OSTRZE na jednym końcu – ostrze tuż obok punktu podziału, którego nie dodano (bliżej niż SCAL od granicy
      # obróbki); wysokość na tym końcu = 0.
      def klin_ok?(zb_a, zb_b, zt_a, zt_b)
        ha = zt_a - zb_a
        hb = zt_b - zb_b
        [ha, hb].max > EPS && [ha, hb].min > -OSTRZE
      end

      # Poziome ograniczenia [x0, x1, z, z] (gniazda, wycięcia) różne o mniej niż SCAL – jeden poziom (wierzch: najniższy,
      # spód: najwyższy – drewna ubywa, nie przybywa); różne od wierzchu / spodu bala (skraj) o mniej niż SCAL – na skraju
      # (obróbka cieńsza niż 0,2 mm pominięta). Inaczej uskok krótszy niż tolerancja SketchUpa psuje ścianę bryły (np. dno
      # gniazda płatwi 0,095 mm nad dnem gniazda zamka).
      def wyrownaj_poziomy(lista, skraj, wierzch)
        plaskie = lista.select { |g| (g[2] - g[3]).abs < EPS }.map { |g| g[2] }
        lista.map do |g|
          next g if (g[2] - g[3]).abs >= EPS
          v = g[2]
          if (v - skraj).abs < SCAL
            v = skraj
          else
            bliskie = plaskie.select { |u| (u - v).abs < SCAL && (u - skraj).abs >= SCAL }
            v = wierzch ? bliskie.min : bliskie.max
          end
          [g[0], g[1], v, v]
        end
      end

      # Punkty podziału profilu: 0, dl i granice obróbek odległe od poprzedniej (i od końców) o więcej niż SCAL; potem
      # punkty dodatkowe (przecięcia ograniczeń) odległe od wszystkich o więcej niż SCAL. Granica obróbki nie przesuwa się
      # do bliskiego przecięcia (koniec podcięcia zamka 0,13 mm za przecięciem skosu z wierzchem – bal za szeroki
      # w zamku, kolizja); pominięte przecięcie daje cięciwę – drewna ubywa, nie przybywa. Przedział między scalonymi
      # punktami znika – sąsiednie przedziały biorą ograniczenia ze swojego środka.
      def punkty_podzialu(xs, dl, dodatkowe = [])
        wynik = [0.0]
        xs.select { |x| x > SCAL && x < dl - SCAL }.sort.each { |x| wynik << x if x - wynik.last > SCAL }
        wynik << dl.to_f
        dodatkowe.select { |x| x > SCAL && x < dl - SCAL }.sort.each do |x|
          wynik << x if wynik.all? { |u| (u - x).abs > SCAL }
        end
        wynik.sort
      end

      # Punkty x, w których dwie proste ograniczenia przecinają się wewnątrz wspólnego zakresu.
      def przeciecia(lista)
        wynik = []
        lista.combination(2).each do |a, b|
          x0 = [a[0], b[0]].max
          x1 = [a[1], b[1]].min
          next if x1 - x0 <= EPS
          da = (a[3] - a[2]) / (a[1] - a[0])
          db = (b[3] - b[2]) / (b[1] - b[0])
          next if (da - db).abs < 1e-12
          # a(x) = a2 + da (x − a0); b(x) = b2 + db (x − b0)
          x = (b[2] - db * b[0] - a[2] + da * a[0]) / (da - db)
          wynik << x if x > x0 + EPS && x < x1 - EPS
        end
        wynik
      end

      # Wartości ograniczenia (min dla wierzchu, max dla spodu) na końcach przedziału xa…xb; aktywne te, które obejmują xm.
      def wartosci(lista, xa, xb, xm, rodzaj)
        aktywne = lista.select { |g| g[0] < xm && g[1] > xm }
        va = aktywne.map { |g| liniowa(g, xa) }
        vb = aktywne.map { |g| liniowa(g, xb) }
        rodzaj == :min ? [va.min, vb.min] : [va.max, vb.max]
      end

      # Wartość ograniczenia liniowego [x0, x1, z0, z1] w punkcie x.
      def liniowa(g, x)
        return g[2] if (g[1] - g[0]).abs < EPS
        g[2] + (g[3] - g[2]) * (x - g[0]) / (g[1] - g[0])
      end

      # Czy punkt (x, y, z) w układzie bala jest wewnątrz bryły (ściśle, z marginesem eps).
      def zawiera?(prof, x, y, z, eps = 1e-6)
        prof.each do |q|
          next unless x > q[:xa] + eps && x < q[:xb] - eps
          u = (x - q[:xa]) / (q[:xb] - q[:xa])
          (q[:pasy] || [q]).each do |p|
            next unless y > p[:y0] + eps && y < p[:y1] - eps
            zb = p[:zb_a] + (p[:zb_b] - p[:zb_a]) * u
            zt = p[:zt_a] + (p[:zt_b] - p[:zt_a]) * u + (p[:kt] || 0.0) * (y - p[:y0])
            return z > zb + eps && z < zt - eps
          end
          return false
        end
        false
      end

      # Pole przekroju pasa na końcu a albo b (wierzch skośny w poprzek – średnia).
      def pole_pasa(c, koniec)
        w = c[:y1] - c[:y0]
        zt = koniec == :a ? c[:zt_a] : c[:zt_b]
        zb = koniec == :a ? c[:zb_a] : c[:zb_b]
        w * (zt + (c[:kt] || 0.0) * w / 2.0 - zb)
      end

      # Objętość bryły z profilu [mm³].
      def objetosc(prof)
        prof.inject(0.0) do |suma, q|
          (q[:pasy] || [q]).inject(suma) { |s, c| s + (q[:xb] - q[:xa]) * (pole_pasa(c, :a) + pole_pasa(c, :b)) / 2.0 }
        end
      end

      # Cechy po obrocie bala o 180° wokół osi pionowej (x → dl − x, lica zamienione).
      def obrocone(dl, cechy)
        cechy.map do |c|
          n = c.merge(x0: dl - c[:x1], x1: dl - c[:x0])
          n[:strona] = 1 - c[:strona] if c[:typ] == 'podciecie'
          n = n.merge(z0: c[:z1], z1: c[:z0]) if %w[skos_gora sciecie_dachu].include?(c[:typ])
          n
        end
      end

      # Podpis bala (tekst) – równe podpisy = identyczna bryła (te same wymiary i obróbki).
      def podpis(dl, t, h, cechy)
        r = lambda { |v| format('%.1f', (v.to_f / DOKLADNOSC).round * DOKLADNOSC) }
        opis = cechy.map do |c|
          [c[:typ], c[:strona].to_s, r.call(c[:x0]), r.call(c[:x1]), r.call(c[:gleb] || 0), r.call(c[:z0] || 0), r.call(c[:z1] || 0)].join(':')
        end
        ([r.call(dl), r.call(t), r.call(h)] + opis.uniq.sort).join('|')
      end

      # Podpis kanoniczny: [podpis, obrócony?] – mniejszy z podpisów bala i bala obróconego o 180°.
      def podpis_kanoniczny(dl, t, h, cechy)
        a = podpis(dl, t, h, cechy)
        b = podpis(dl, t, h, obrocone(dl, cechy))
        a <= b ? [a, false] : [b, true]
      end
    end
  end
end
