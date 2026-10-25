# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/kolizje_belek.rb
# Zadanie: wspólne sprawdzenia przestrzenne testów – kolizje belek dachu z balami (punkty próbne), bale ponad linią szczytu, bale i płatwie względem połaci dla aplikacji do dachów.
# Tematy: kolizje belek, punkty próbne, prostopadłościan otaczający, układ lokalny belki, bale nad linią dachu, płaszczyzna połaci w testach, płatwie pod połacią
# Zależy od: testy/pomoc.rb (rdzeń wtyczki)
# Używają: testy/t_szczyty.rb, testy/t_losowe.rb, testy/t_polacie.rb

# Punkty próbne (n × n × n) w części wspólnej prostopadłościanów otaczających [min, max].
def probki(a, b, n)
  lo = (0..2).map { |k| [a[0][k], b[0][k]].max }
  hi = (0..2).map { |k| [a[1][k], b[1][k]].min }
  return [] if (0..2).any? { |k| hi[k] - lo[k] < 0.5 }
  wynik = []
  n.times { |i| n.times { |j| n.times { |m| wynik << [i, j, m].each_with_index.map { |u, k| lo[k] + (hi[k] - lo[k]) * (u + 0.5) / n } } } }
  wynik
end

# Prostopadłościan otaczający bryły o położeniu pol i wymiarach dl × b × h.
def otoczka(pol, dl, b, h)
  o = pol[:poczatek]
  rogi = [0, dl].product([0, b], [0, h]).map { |x, y, z| (0..2).map { |k| o[k] + pol[:x][k] * x + pol[:y][k] * y + pol[:z][k] * z } }
  [(0..2).map { |k| rogi.map { |r| r[k] }.min }, (0..2).map { |k| rogi.map { |r| r[k] }.max }]
end

# Punkt w układzie lokalnym (rzut na osie położenia).
def lokalnie(pol, q)
  d = (0..2).map { |k| q[k] - pol[:poczatek][k] }
  [:x, :y, :z].map { |o| (0..2).inject(0.0) { |s, k| s + d[k] * pol[o][k] } }
end

# Liczba punktów wspólnych belek dachu (prefiks) i bali (z marginesem 0,5 mm) – 0 = bez kolizji.
def kolizje_belek(pl, prefiks, n = 7)
  p = pl[:parametry]
  t = ArteMadera::GeneratorWiencowy::Parametry.grubosc(p)
  bale = pl[:bale].map do |b|
    pol = ArteMadera::GeneratorWiencowy::Bale.polozenie(b, p)
    pol = pol.merge(z: [0.0, 0.0, 1.0])
    [b, pol, otoczka(pol, b[:dl], t, b[:h]), ArteMadera::GeneratorWiencowy::Bryla.profil(b[:dl], t, b[:h], b[:cechy])]
  end
  ile = 0
  pl[:elementy].select { |e| e[:prefiks] == prefiks }.each do |e|
    pe = e[:polozenie]
    oe = otoczka(pe, e[:dl], e[:b], e[:h])
    bale.each do |b, pol, ob, prof|
      probki(oe, ob, n).each do |q|
        le = lokalnie(pe, q)
        next unless le[0] > 0.5 && le[0] < e[:dl] - 0.5 && le[1] > 0.5 && le[1] < e[:b] - 0.5 && le[2] > 0.5 && le[2] < e[:h] - 0.5
        lb = lokalnie(pol, q)
        ile += 1 if ArteMadera::GeneratorWiencowy::Bryla.zawiera?(prof, lb[0], lb[1], lb[2], 0.5)
      end
    end
  end
  ile
end

# Największe wystawanie bali ściany ponad linię szczytu [mm] (≤ 0 – wszystko pod linią).
def nad_linia(pl, id)
  w = sciana(pl, id)
  p = pl[:parametry]
  t = ArteMadera::GeneratorWiencowy::Parametry.grubosc(p)
  w[:bale].map do |b|
    ArteMadera::GeneratorWiencowy::Bryla.profil(b[:dl], t, b[:h], b[:cechy]).map do |q|
      [[q[:xa], q[:zt_a]], [q[:xb], q[:zt_b]]].map { |x, zt| b[:z0] + zt - ArteMadera::GeneratorWiencowy::Szczyty.linia(w, b[:s0] + x, p) }.max
    end.max
  end.compact.max
end


# Wysokość płaszczyzny połaci (plan[:polacie] – dla aplikacji do dachów) nad punktem [x, y] układu domu, liczona
# niezależnie od rdzenia: wysokość obrysu + tg kąta × odległość w głąb od najbliższej krawędzi okapowej (obrys
# przeciwnie do wskazówek zegara – wnętrze po lewej stronie krawędzi).
def z_polaci(pol, x, y)
  n = pol[:punkty].length
  d = (0...n).reject { |i| pol[:szczyty].include?(i + 1) }.map do |i|
    a = pol[:punkty][i]
    b = pol[:punkty][(i + 1) % n]
    l = Math.hypot(b[0] - a[0], b[1] - a[1])
    ((x - a[0]) * -(b[1] - a[1]) + (y - a[1]) * (b[0] - a[0])) / l
  end.min
  pol[:z] + Math.tan(pol[:kat] * Math::PI / 180.0) * d
end

# Bale i płatwie względem połaci: { bale: największe wystawanie wierzchu bali ponad połać, platwie: największe
# wystawanie płatwi, dotyk: najmniejsze z „najwyższy punkt płatwi − połać” (0 – każda płatew podpiera krokwie),
# krokwie: liczba krokwi generatora } [mm]; nil – plan bez połaci.
def wzgledem_polaci(pl)
  pol = pl[:polacie]
  return nil if pol.nil?
  g = ArteMadera::GeneratorWiencowy
  p = pl[:parametry]
  t = g::Parametry.grubosc(p)
  punkt = lambda { |o, osie, x, y, z| (0..2).map { |k| o[k] + osie[0][k] * x + osie[1][k] * y + osie[2][k] * z } }
  nad = lambda { |q| q[2] - z_polaci(pol, q[0], q[1]) }
  bale = pl[:bale].map do |b|
    pol_b = g::Bale.polozenie(b, p)
    osie = [pol_b[:x], pol_b[:y], [0.0, 0.0, 1.0]]
    g::Bryla.profil(b[:dl], t, b[:h], b[:cechy]).map do |q|
      [[q[:xa], q[:zt_a]], [q[:xb], q[:zt_b]]].product([0.0, t]).map { |(x, z), y| nad.call(punkt.call(pol_b[:poczatek], osie, x, y, z)) }.max
    end.max
  end.compact.max
  platwie = pl[:elementy].select { |e| e[:prefiks] == 'P' }.map do |e|
    pe = e[:polozenie]
    przekroj = e[:przekroj] || [[0.0, 0.0], [e[:b], 0.0], [e[:b], e[:h]], [0.0, e[:h]]]
    przekroj.product([0.0, e[:dl]]).map { |(y, z), x| nad.call(punkt.call(pe[:poczatek], [pe[:x], pe[:y], pe[:z]], x, y, z)) }.max
  end
  { bale: bale, platwie: platwie.max, dotyk: platwie.min, krokwie: pl[:elementy].count { |e| e[:prefiks] == 'K' } }
end
