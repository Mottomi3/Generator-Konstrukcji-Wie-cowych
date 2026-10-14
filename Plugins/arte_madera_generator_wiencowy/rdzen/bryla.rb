# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/bryla.rb
# Zadanie: bryła bala z obróbek – profil wzdłuż bala (przedziały z zakresem grubości i wysokości), przynależność punktu, objętość, podpis.
# Tematy: bryła bala, profil bala, przedziały, obróbki bala, objętość, podpis bala, obrót o 180°, identyczne bale, skos (szczyty)
# Zależy od: –
# Używają: rdzen/siatka.rb, rdzen/pozycje.rb, rdzen/kontrola.rb
#
# Układ bala: x od czoła (0 … dl), y od lica prawego (0 … t), z od spodu (0 … h).
# Obróbki (cechy): gniazdo_gora / wyciecie_gora (wierzch obniżony do h − gleb na x0…x1), gniazdo_dol / wyciecie_dol
# (spód podniesiony do gleb), podciecie (strona 0: y ≥ gleb, strona 1: y ≤ t − gleb), skos_gora (wierzch ≤ prosta
# z0 → z1 na x0…x1, do szczytów). W każdym przedziale profilu: stały zakres y, wierzch i spód liniowe.
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

      module_function

      # Profil: lista przedziałów { xa:, xb:, y0:, y1:, zb_a:, zb_b:, zt_a:, zt_b: } (puste przedziały pominięte).
      def profil(dl, t, h, cechy)
        gora = [[0.0, dl, h, h]]
        dol = [[0.0, dl, 0.0, 0.0]]
        boki = []
        cechy.each do |c|
          case c[:typ]
          when 'gniazdo_gora', 'wyciecie_gora' then gora << [c[:x0], c[:x1], h - c[:gleb], h - c[:gleb]]
          when 'gniazdo_dol', 'wyciecie_dol' then dol << [c[:x0], c[:x1], c[:gleb], c[:gleb]]
          when 'skos_gora' then gora << [c[:x0], c[:x1], c[:z0], c[:z1]]
          when 'podciecie' then boki << c
          end
        end
        xs = [0.0, dl]
        (gora + dol).each { |g| xs << g[0] << g[1] }
        boki.each { |c| xs << c[:x0] << c[:x1] }
        xs.concat(przeciecia(gora)).concat(przeciecia(dol))
        xs = punkty_podzialu(xs, dl)
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
          next if y1 - y0 <= EPS || zt_a - zb_a <= EPS || zt_b - zb_b <= EPS
          wynik << { xa: xa, xb: xb, y0: y0, y1: y1, zb_a: zb_a, zb_b: zb_b, zt_a: zt_a, zt_b: zt_b }
        end
        wynik
      end

      # Punkty podziału profilu: 0, dl i punkty wewnętrzne odległe od poprzedniego (i od końców) o więcej niż SCAL.
      # Przedział między scalonymi punktami znika – sąsiednie przedziały biorą ograniczenia ze swojego środka.
      def punkty_podzialu(xs, dl)
        wynik = [0.0]
        xs.select { |x| x > SCAL && x < dl - SCAL }.sort.each { |x| wynik << x if x - wynik.last > SCAL }
        wynik << dl.to_f
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
        prof.each do |p|
          next unless x > p[:xa] + eps && x < p[:xb] - eps
          return false unless y > p[:y0] + eps && y < p[:y1] - eps
          u = (x - p[:xa]) / (p[:xb] - p[:xa])
          zb = p[:zb_a] + (p[:zb_b] - p[:zb_a]) * u
          zt = p[:zt_a] + (p[:zt_b] - p[:zt_a]) * u
          return z > zb + eps && z < zt - eps
        end
        false
      end

      # Objętość bryły z profilu [mm³].
      def objetosc(prof)
        prof.inject(0.0) do |suma, p|
          suma + (p[:xb] - p[:xa]) * (p[:y1] - p[:y0]) * ((p[:zt_a] - p[:zb_a]) + (p[:zt_b] - p[:zb_b])) / 2.0
        end
      end

      # Cechy po obrocie bala o 180° wokół osi pionowej (x → dl − x, lica zamienione).
      def obrocone(dl, cechy)
        cechy.map do |c|
          n = c.merge(x0: dl - c[:x1], x1: dl - c[:x0])
          n[:strona] = 1 - c[:strona] if c[:typ] == 'podciecie'
          n = n.merge(z0: c[:z1], z1: c[:z0]) if c[:typ] == 'skos_gora'
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
