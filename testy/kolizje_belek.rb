# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/kolizje_belek.rb
# Zadanie: wspólne sprawdzenia przestrzenne testów – kolizje belek dachu z balami (punkty próbne), bale ponad linią szczytu, bale i płatwie względem połaci dla aplikacji do dachów.
# Tematy: kolizje belek, kolizje belek między sobą, punkt w przekroju belki, punkty próbne, prostopadłościan otaczający, układ lokalny belki, bale nad linią dachu, płaszczyzna połaci w testach, płatwie pod połacią
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

# Liczba punktów wspólnych belek (prefiks; belka z obróbkami – bryła z jej profilu, np. słup z zamkami) i bali (z marginesem
# 0,5 mm) – 0 = bez kolizji.
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
    prof_e = (e[:cechy] || []).empty? ? nil : ArteMadera::GeneratorWiencowy::Bryla.profil(e[:dl], e[:b], e[:h], e[:cechy])
    bale.each do |b, pol, ob, prof|
      probki(oe, ob, n).each do |q|
        le = lokalnie(pe, q)
        next unless le[0] > 0.5 && le[0] < e[:dl] - 0.5 && le[1] > 0.5 && le[1] < e[:b] - 0.5 && le[2] > 0.5 && le[2] < e[:h] - 0.5
        next if w_wrebie?(e, le)
        next if prof_e && !ArteMadera::GeneratorWiencowy::Bryla.zawiera?(prof_e, le[0], le[1], le[2], 0.5)
        next if e[:przekroj] && !w_belce?(e, q)
        lb = lokalnie(pol, q)
        ile += 1 if ArteMadera::GeneratorWiencowy::Bryla.zawiera?(prof, lb[0], lb[1], lb[2], 0.5)
      end
    end
  end
  ile
end

# Czy punkt lokalny belki le leży poza przekrojem jej wrębu (zamek płatwi) – w wrębie belka jest węższa i wyżej od spodu.
def w_wrebie?(e, le)
  w = e[:wrab]
  (e[:wreby] || []).any? do |x0, x1|
    le[0] > x0 - 0.5 && le[0] < x1 + 0.5 && (le[1] < w[:bok] + 0.5 || le[1] > e[:b] - w[:bok] - 0.5 || le[2] < w[:dol] + 0.5)
  end
end

# Czy punkt [y, z] leży wewnątrz wielokąta (z marginesem m od krawędzi).
def w_wielokacie?(pts, y, z, m)
  wewn = false
  pts.each_with_index do |a, i|
    b = pts[(i + 1) % pts.length]
    if (a[1] > z) != (b[1] > z)
      x = a[0] + (z - a[1]) * (b[0] - a[0]) / (b[1] - a[1])
      wewn = !wewn if y < x
    end
  end
  return false unless wewn
  pts.each_with_index.all? do |a, i|
    b = pts[(i + 1) % pts.length]
    dl = Math.hypot(b[0] - a[0], b[1] - a[1])
    next true if dl < 1e-9
    t = [[((y - a[0]) * (b[0] - a[0]) + (z - a[1]) * (b[1] - a[1])) / (dl * dl), 0.0].max, 1.0].min
    Math.hypot(y - a[0] - t * (b[0] - a[0]), z - a[1] - t * (b[1] - a[1])) > m
  end
end

# Czy punkt q (układ domu) leży w belce e (przekrój, wręby zamka płatwi, obróbki) z marginesem m.
def w_belce?(e, q, m = 0.5)
  g = ArteMadera::GeneratorWiencowy
  le = lokalnie(e[:polozenie], q)
  return false unless le[0] > m && le[0] < e[:dl] - m
  if e[:przekroj]
    przekroj = e[:przekroj]
    if (e[:wreby] || []).any? { |x0, x1| le[0] > x0 - m && le[0] < x1 + m }
      przekroj = g::ZamekPlatwi.przekroj_wrebu(przekroj, e[:b], e[:wrab])
    end
    return w_wielokacie?(przekroj, le[1], le[2], m)
  end
  return false unless le[1] > m && le[1] < e[:b] - m && le[2] > m && le[2] < e[:h] - m
  return true if (e[:cechy] || []).empty?
  g::Bryla.zawiera?(g::Bryla.profil(e[:dl], e[:b], e[:h], e[:cechy]), le[0], le[1], le[2], m)
end

# Liczba punktów wspólnych belek o prefiksach a i b (punkty próbne n × n × n we wspólnej części otoczek) – 0 = bez kolizji.
def kolizje_elementow(pl, a, b, n = 6)
  lista_a = pl[:elementy].select { |e| e[:prefiks] == a }
  lista_b = pl[:elementy].select { |e| e[:prefiks] == b }
  ile = 0
  lista_a.each do |ea|
    oa = otoczka(ea[:polozenie], ea[:dl], ea[:b], ea[:h])
    lista_b.each do |eb|
      next if ea.equal?(eb)
      probki(oa, otoczka(eb[:polozenie], eb[:dl], eb[:b], eb[:h]), n).each { |q| ile += 1 if w_belce?(ea, q) && w_belce?(eb, q) }
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
# przeciwnie do wskazówek zegara – wnętrze po lewej stronie krawędzi). Obrys L (dwa dachy z koszem) – z_polaci_l.
def z_polaci(pol, x, y)
  n = pol[:punkty].length
  return z_polaci_l(pol, x, y) if n > 4
  d = (0...n).reject { |i| pol[:szczyty].include?(i + 1) }.map do |i|
    a = pol[:punkty][i]
    b = pol[:punkty][(i + 1) % n]
    l = Math.hypot(b[0] - a[0], b[1] - a[1])
    ((x - a[0]) * -(b[1] - a[1]) + (y - a[1]) * (b[0] - a[0])) / l
  end.min
  pol[:z] + Math.tan(pol[:kat] * Math::PI / 180.0) * d
end

# Połać domu L: krawędzie okapowe w dwóch kierunkach = dwa dachy dwuspadowe. Dach główny ma trzy krawędzie okapowe (z
# krótkim uskokiem na ścianie ze szczytem na części długości) i sięga wszędzie; dach skrzydła bocznego (dwie krawędzie)
# liczy się tylko po swojej stronie kalenicy dachu głównego – tam dach domu to wyższa z dwóch płaszczyzn.
def z_polaci_l(pol, x, y)
  n = pol[:punkty].length
  q = [x, y]
  tg = Math.tan(pol[:kat] * Math::PI / 180.0)
  okapy = (0...n).reject { |i| pol[:szczyty].include?(i + 1) }.map { |i| [pol[:punkty][i], pol[:punkty][(i + 1) % n]] }
  grupy = okapy.group_by { |a, b| (a[0] - b[0]).abs < 1e-6 ? 0 : 1 }
  dachy = grupy.map do |iv, kr|
    vs = kr.map { |a, _b| a[iv] }.minmax
    { iv: iv, v: vs, ile: kr.length, us: kr.flat_map { |a, b| [a[1 - iv], b[1 - iv]] }, z: pol[:z] + tg * [q[iv] - vs[0], vs[1] - q[iv]].min }
  end
  glowny, boczny = dachy.sort_by { |d| -d[:ile] }
  return glowny[:z] if boczny.nil?
  # Kalenica dachu głównego leży w poprzek skrzydła bocznego: współrzędna iv głównego = wzdłuż kalenicy bocznego.
  vk = (glowny[:v][0] + glowny[:v][1]) / 2.0
  strona = boczny[:us].inject(0.0) { |s, u| s + u } / boczny[:us].length - vk
  (q[glowny[:iv]] - vk) * strona >= 0.0 ? [glowny[:z], boczny[:z]].max : glowny[:z]
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
      (q[:pasy] || [q]).map do |c|
        d = (c[:kt] || 0.0) * (c[:y1] - c[:y0])
        [[q[:xa], c[:zt_a]], [q[:xb], c[:zt_b]]].product([[c[:y0], 0.0], [c[:y1], d]]).map do |(x, z), (y, dz)|
          nad.call(punkt.call(pol_b[:poczatek], osie, x, y, z + dz))
        end.max
      end.max
    end.max
  end.compact.max
  platwie = pl[:elementy].select { |e| e[:prefiks] == 'P' }.map do |e|
    pe = e[:polozenie]
    przekroj = e[:przekroj] || [[0.0, 0.0], [e[:b], 0.0], [e[:b], e[:h]], [0.0, e[:h]]]
    przekroj.product([0.0, e[:dl]]).map { |(y, z), x| nad.call(punkt.call(pe[:poczatek], [pe[:x], pe[:y], pe[:z]], x, y, z)) }.max
  end
  { bale: bale, platwie: platwie.max, dotyk: platwie.min, krokwie: pl[:elementy].count { |e| e[:prefiks] == 'K' } }
end
