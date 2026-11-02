# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_szczyty.rb
# Zadanie: testy szczytów i dachu – wieńce do kalenicy, skos bali pod linią dachu, gniazda płatwi, krokwie przy szczycie, belki dachu bez kolizji.
# Tematy: testy szczytów, linia dachu, gniazdo płatwi, płatew ścienna, krokwie obie strony, krokwie od wewnątrz, krokiew na szczycie, kolizje belek
# Zależy od: testy/pomoc.rb
# Używają: testy/uruchom.sh

require File.expand_path('pomoc', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

require File.expand_path('kolizje_belek', File.dirname(__FILE__))

def czysto(pl, opis)
  k = Kontrola.wszystko(pl)
  Testy.rowne([k[:kolizje].length, k[:mijanka].length, k[:za_dlugie].length], [0, 0, 0], "#{opis}: zamki, mijanka, długości")
end

Testy.grupa('Dom 4000 × 3000 (jak 900) – szczyty na ścianach 3 m')
pl = plan_pelny(prostokat(0, 0, 4000, 3000))
p = pl[:parametry]
Testy.rowne(pl[:bledy], [], 'brak błędów')
Testy.rowne(pl[:sciany].select { |w| w[:szczyt] }.map { |w| w[:id] }, %w[W-2 W-4], 'szczyty na W-2 i W-4')
w2 = sciana(pl, 'W-2')
zmax = 2293.5 + 69.5 + Math.tan(20 * Math::PI / 180) * (1478.0 - 22.0)
Testy.rowne(w2[:szczyt][:z_max], zmax, 'wierzch szczytu: 2363 + tg 20° × 1456', 0.01)
Testy.rowne(w2[:wience].length, (zmax / 139.0).ceil, 'wieńce szczytowej do kalenicy')
Testy.sprawdz(nad_linia(pl, 'W-2') <= 0.01, "bale pod linią dachu (wystaje #{nad_linia(pl, 'W-2').round(3)})")
Testy.rowne(w2[:otwory].count { |o| o[:gniazdo] }, 5, 'gniazda: 2 płatwie ścienne, 2 pośrednie, kalenicowa')
Testy.sprawdz(pl[:pozycje].any? { |x| x[:prefiks] == 'Sz' }, 'pozycje bali szczytu (Sz)')
Testy.sprawdz(pl[:bale].select { |b| b[:z0] >= 2293.5 }.all? { |b| b[:pozycja][:prefiks] == 'Sz' }, 'bale nad okapem – Sz')
Testy.sprawdz(pl[:ostrzezenia].none? { |u| u.include?('krótsze niż') }, 'bez ostrzeżeń o kawałkach przy gniazdach')
pls = pl[:elementy].select { |e| e[:prefiks] == 'P' }
Testy.rowne(pls.length, 5, '5 płatwi')
Testy.rowne(pls.map { |e| e[:dl] }.uniq, [5000.0], 'płatwie 4000 + 2 × 500')
Testy.rowne(kolizje_belek(pl, 'P'), 0, 'płatwie bez kolizji z balami')
Testy.rowne(pl[:elementy].count { |e| e[:prefiks] == 'K' }, 0, 'same płatwie – bez krokwi')
czysto(pl, 'szczyty 900')

Testy.grupa('Płatew ścienna stojąca na ścianie')
pl = plan_pelny(prostokat(0, 0, 4000, 3000), 'platwa_scienna_polozenie' => 'na_scianie')
sc = Dach.platwie(sciana(pl, 'W-2')[:szczyt], pl[:parametry]).select { |x| x[:rodzaj] == 'scienna' }
Testy.rowne(sc.map { |x| x[:z_spod].round(2) }.uniq, [2293.5], 'spód płatwi na wierzchu ściany okapowej')
Testy.rowne(sc.map { |x| x[:v].round(2) }, [22.0, 2978.0], 'płatwie w osiach ścian okapowych')
Testy.rowne(kolizje_belek(pl, 'P'), 0, 'bez kolizji')
Testy.sprawdz(nad_linia(pl, 'W-4') <= 0.01, 'bale pod linią dachu')

Testy.grupa('Krokwie z generatora przy szczycie – obie strony, od wewnątrz, na szczycie')
seg = prostokat(0, 0, 5000, 4000)
wyn = {}
%w[obie_strony wewnatrz zewnatrz na_szczycie].each do |k|
  pl = plan_pelny(seg, 'dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator', 'krokwie_przy_szczycie' => k)
  wyn[k] = pl
  Testy.rowne(pl[:bledy], [], "#{k}: brak błędów")
  Testy.sprawdz(nad_linia(pl, 'W-2') <= 0.01, "#{k}: bale pod linią szczytu")
  Testy.rowne(kolizje_belek(pl, 'K'), 0, "#{k}: krokwie bez kolizji z balami")
  Testy.rowne(kolizje_belek(pl, 'P'), 0, "#{k}: płatwie bez kolizji z balami")
end
dk = 150.0 / Math.cos(20 * Math::PI / 180)
Testy.rowne(sciana(wyn['obie_strony'], 'W-2')[:szczyt][:z_max] - sciana(wyn['na_szczycie'], 'W-2')[:szczyt][:z_max], dk,
            'szczyt do wierzchu krokwi: wyżej o 150 / cos 20°', 0.01)
u_kr = lambda { |pl| pl[:elementy].select { |e| e[:prefiks] == 'K' && e[:polozenie][:x][1] > 0 }.map { |e| (e[:polozenie][:poczatek][0] - 25.0).round(1) }.sort }
Testy.rowne(u_kr.call(wyn['obie_strony']).first(2), [22.0 - 47.0, 22.0 + 47.0], 'obie strony: krokiew przy licu zewnętrznym i wewnętrznym')
Testy.rowne(u_kr.call(wyn['wewnatrz']).first, 22.0 + 47.0, 'od wewnątrz: pierwsza krokiew przy licu wewnętrznym')
Testy.rowne(u_kr.call(wyn['zewnatrz']).first, 22.0 - 47.0, 'od zewnątrz: pierwsza krokiew przy licu zewnętrznym')
Testy.rowne(u_kr.call(wyn['na_szczycie']).first, 22.0, 'na szczycie: krokiew w osi szczytu')
Testy.sprawdz(u_kr.call(wyn['wewnatrz']).each_cons(2).all? { |a, b| b - a <= 900.01 }, 'rozstaw krokwi ≤ 900')
czysto(wyn['obie_strony'], 'krokwie')

Testy.grupa('Dwa bliskie szczyty na działowych – krokwie bez kolizji (ziarno 1251)')
[120, 75].each do |odl|
  seg = prostokat(0, 0, 6000, 4000) + [[[3000, 0], [3000, 4000]], [[3000 + odl, 0], [3000 + odl, 4000]]]
  %w[obie_strony zewnatrz na_szczycie].each do |k|
    pl = plan_pelny(seg, 'dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator', 'krokwie_przy_szczycie' => k,
                    'szczyty_na_dzialowych' => 'tak')
    us = u_kr.call(pl)
    Testy.rowne(kolizje_belek(pl, 'K'), 0, "#{odl} mm, #{k}: krokwie bez kolizji z balami")
    Testy.sprawdz(us.each_cons(2).all? { |a, b| b - a >= 50.0 - 0.01 }, "#{odl} mm, #{k}: krokwie nie nachodzą na siebie")
    next unless k == 'obie_strony'
    Testy.rowne(us.select { |u| u > 3000 && u < 3000 + odl }, odl == 120 ? [3060.0] : [],
                "#{odl} mm: między szczytami #{odl == 120 ? 'jedna krokiew pośrodku' : 'bez krokwi (nie mieści się)'}")
  end
end

Testy.grupa('Same krokwie – bez płatwi pośrednich')
pl = plan_pelny(prostokat(0, 0, 5000, 4000), 'dach_uklad' => 'krokwie')
Testy.rowne(pl[:elementy].select { |e| e[:prefiks] == 'P' }.map { |e| e[:b] }.sort, [80.0, 80.0, 80.0], 'płatwie: 2 ścienne + kalenicowa (jeden przekrój)')
Testy.rowne(sciana(pl, 'W-2')[:otwory].count { |o| o[:gniazdo] }, 3, 'trzy gniazda w szczycie')

Testy.grupa('Węgły i działowe pod płatwią ścienną – gniazda')
seg = prostokat(0, 0, 6000, 4000) + [[[3000, 0], [3000, 4000]]]
pl = plan_pelny(seg, 'styk_na_dzialowej' => 'mijanka')
dz = pl[:sciany].find { |w| w[:rodzaj] == :dzialowa }
Testy.rowne(dz[:otwory].count { |o| o[:gniazdo] }, 2, 'działowa (do okapu): gniazda pod obie płatwie ścienne')
kf = pl[:sciany].select { |w| w[:rodzaj] == :kontrfor && w[:gospodarz][:kierunek] == :A }
Testy.sprawdz(!kf.empty? && kf.all? { |w| w[:otwory].count { |o| o[:gniazdo] } == 1 }, 'węgły na ścianach okapowych: gniazdo płatwi ściennej')
Testy.rowne(kolizje_belek(pl, 'P'), 0, 'płatwie bez kolizji z działową i węgłami')
czysto(pl, 'działowa i węgły')

Testy.grupa('Szczyt na działowej szczytowej (jak 1800 W-2)')
pl = plan_pelny(seg, 'szczyty_na_dzialowych' => 'tak')
dz = pl[:sciany].find { |w| w[:rodzaj] == :dzialowa }
Testy.sprawdz(!dz[:szczyt].nil?, 'działowa ma szczyt')
Testy.rowne(dz[:szczyt][:z_max], sciana(pl, 'W-2')[:szczyt][:z_max], 'ta sama wysokość co szczyt zewnętrzny')
Testy.sprawdz(nad_linia(pl, dz[:id]) <= 0.01, 'bale działowej pod linią dachu')
Testy.rowne(kolizje_belek(pl, 'P'), 0, 'płatwie przez działową bez kolizji')
czysto(pl, 'szczyt na działowej')

Testy.grupa('Bez szczytów i bez belek dachu')
pl = plan_pelny(prostokat(0, 0, 4000, 3000), 'szczyty' => 'nie')
Testy.rowne(pl[:sciany].count { |w| w[:szczyt] }, 0, 'bez szczytów')
Testy.rowne(sciana(pl, 'W-2')[:wience].length, 17, 'szczytowa: n + 1 wieńców')
Testy.rowne(pl[:elementy].count { |e| %w[P K].include?(e[:prefiks]) }, 0, 'bez belek dachu')
pl = plan_pelny(prostokat(0, 0, 4000, 3000), 'dach_elementy' => 'nie')
Testy.rowne(pl[:elementy].count { |e| %w[P K].include?(e[:prefiks]) }, 0, 'dach_elementy nie – bez belek')
Testy.rowne(sciana(pl, 'W-2')[:otwory].count { |o| o[:gniazdo] }, 5, 'gniazda płatwi zostają')

Testy.grupa('Kąt dachu i okno w szczycie')
otw = [{ 'sciana' => 'W-2', 'od' => 1100, 'szerokosc' => 800, 'wysokosc' => 500, 'parapet' => 2450 }]
pl = plan_pelny(prostokat(0, 0, 4000, 3000), { 'dach_kat' => 35 }, otw)
Testy.rowne(sciana(pl, 'W-2')[:otwory].count { |o| !o[:gniazdo] }, 1, 'okno w szczycie przyjęte')
Testy.sprawdz(pl[:ostrzezenia].none? { |u| u.include?('poza ścianę') }, 'bez ostrzeżenia „poza ścianę”')
Testy.sprawdz(sciana(pl, 'W-2')[:szczyt][:z_max] > zmax + 300, 'kąt 35° – wyższy szczyt')
Testy.sprawdz(nad_linia(pl, 'W-2') <= 0.01, 'bale pod linią dachu')
czysto(pl, 'kąt 35° z oknem')

Testy.grupa('Obrys L – szczyty osobno, bez belek dachu')
pl = plan_pelny(wielokat([[0, 0], [8000, 0], [8000, 4000], [4000, 4000], [4000, 7000], [0, 7000]]))
Testy.rowne(pl[:bledy], [], 'brak błędów')
Testy.sprawdz(pl[:sciany].count { |w| w[:szczyt] } >= 2, 'szczyty na ścianach szczytowych')
Testy.sprawdz(pl[:ostrzezenia].any? { |u| u.include?('tylko dla obrysu prostokątnego') }, 'ostrzeżenie o dachu')
Testy.rowne(pl[:elementy].count { |e| %w[P K].include?(e[:prefiks]) }, 0, 'bez belek dachu')
czysto(pl, 'obrys L')

Testy.grupa('Płatwie oparte na pełnym balu – bez przerwy pod gniazdem (runda 7)')
# Drewno tuż pod spodem płatwi w środku każdego gniazda ściany.
def pod_platwia_drewno?(pl, w)
  t = ArteMadera::GeneratorWiencowy::Parametry.grubosc(pl[:parametry])
  (w[:otwory] || []).select { |o| o[:gniazdo] && o[:s0] > w[:s_od] && o[:s1] < w[:s_do] }.all? do |o|
    s = (o[:s0] + o[:s1]) / 2.0 + 1.3
    z = o[:z0] - 0.5
    w[:bale].any? do |b|
      next false unless s > b[:s0] && s < b[:s1] && z > b[:z0] && z < b[:z0] + b[:h]
      prof = ArteMadera::GeneratorWiencowy::Bryla.profil(b[:dl], t, b[:h], b[:cechy])
      ArteMadera::GeneratorWiencowy::Bryla.zawiera?(prof, s - b[:s0], t / 2.0, z - b[:z0], 0.01)
    end
  end
end
[[7000, 5000, 20, {}], [7000, 5000, 14, {}], [6000, 4400, 35, {}], [7000, 5000, 20, { 'platwie_jeden_przekroj' => 'nie', 'platwa_przekroj' => '80x180', 'platwa_kalenicowa_przekroj' => '80x180', 'platwa_scienna_przekroj' => '60x200' }],
 [6000, 4500, 12, { 'dach_rodzaj' => 'jednospadowy' }]].each do |dx, dy, kat, ex|
  pl = plan_pelny(prostokat(0, 0, dx, dy), { 'dach_kat' => kat }.merge(ex))
  zle = pl[:elementy].select { |e| e[:prefiks] == 'P' }.length
  Testy.sprawdz(zle > 0, "#{dx} × #{dy}, #{kat}°: płatwie są")
  gable = pl[:sciany].select { |w| w[:kierunek] == :B && w[:rodzaj] == :zewnetrzna }
  Testy.sprawdz(gable.all? { |w| pod_platwia_drewno?(pl, w) }, "#{dx} × #{dy}, #{kat}° #{ex.keys.first}: pod każdą płatwią drewno")
end
p0, = ArteMadera::GeneratorWiencowy::Parametry.normalizuj('platwie_zamki' => 'nie', 'platwie_jeden_przekroj' => 'nie', 'platwa_przekroj' => '80x180', 'platwa_kalenicowa_przekroj' => '80x180', 'platwa_scienna_przekroj' => '60x200')
geo = { v_a: 22.0, v_b: 4978.0 }
ArteMadera::GeneratorWiencowy::Dach.platwie(geo, p0).each do |pl0|
  Testy.sprawdz(ArteMadera::GeneratorWiencowy::PlatwieWience.pasek_ok?(pl0[:z_spod], p0),
                "dom 7 × 5 z rundy 6 (80 × 180): płatew #{pl0[:rodzaj]} – pasek #{ArteMadera::GeneratorWiencowy::PlatwieWience.pasek(pl0[:z_spod], p0).round(1)} mm")
end
Testy.sprawdz(ArteMadera::GeneratorWiencowy::PlatwieWience.obnizenie(geo, p0) > 15.0, 'kalenicowa 18,9 mm nad wieńcem – dach obniżony')
p1, = ArteMadera::GeneratorWiencowy::Parametry.normalizuj({})
Testy.rowne(ArteMadera::GeneratorWiencowy::Dach.platwie(geo, p1).map { |x| x[:h] }.uniq, [200.0], 'jeden przekrój – wszystkie płatwie 200')
Testy.sprawdz(ArteMadera::GeneratorWiencowy::Dach.platwie(geo, p1).all? { |x| x[:gora].map { |q| q[1] }.max == 200.0 },
              'pełna wysokość płatwi po wyższej stronie')

Testy.grupa('Ściana nośna – bez płatwi ściennej, górny bal ścięty do płaszczyzny dachu (runda 7)')
[{}, { 'dach_rodzaj' => 'jednospadowy' }, { 'dach_kat' => 35 }].each do |ex|
  pl = plan_pelny(prostokat(0, 0, 7000, 5000), { 'platwa_na_scianie' => 'nie' }.merge(ex))
  Testy.rowne(pl[:bledy], [], "#{ex.inspect}: bez błędów")
  Testy.sprawdz(pl[:ostrzezenia].none? { |u| u.include?('poniżej wierzchu ściany') }, "#{ex.inspect}: bez ostrzeżenia o stromym dachu")
  okapowe = pl[:sciany].select { |w| w[:rodzaj] == :zewnetrzna && w[:kierunek] == :A }
  sciete = okapowe.map { |w| w[:bale].count { |b| b[:cechy].any? { |c| c[:typ] == 'sciecie_dachu' } } }
  Testy.sprawdz(sciete.all? { |n| n > 0 }, "#{ex.inspect}: górne bale obu ścian okapowych ścięte (#{sciete.inspect})")
  Testy.rowne(pl[:elementy].count { |e| e[:prefiks] == 'P' && e[:b] && e[:polozenie][:poczatek][2] < Wience.wysokosci(pl[:parametry])[:okapowa] }, 0,
              "#{ex.inspect}: bez płatwi ściennej przy ścianie")
  wz = wzgledem_polaci(pl)
  Testy.sprawdz(wz[:bale] <= 0.01, format('%s: bale pod połacią (%.3f)', ex.inspect, wz[:bale]))
  podp = Krok2.podpory(pl)
  Testy.sprawdz(podp.count { |x| x[:nazwa].start_with?('Ściana') } >= (ex.empty? || ex.key?('dach_kat') ? 2 : 1), "#{ex.inspect}: ściany okapowe jako podpory krokwi")
  czysto(pl, "ściana nośna #{ex.inspect}")
end

Testy.grupa('Zamki w płatwiach – wręby w ścianach (runda 7)')
pl = plan_pelny(prostokat(0, 0, 7000, 5000) + [[[3500, 0], [3500, 5000]]], 'szczyty_na_dzialowych' => 'tak')
pp = pl[:elementy].select { |e| e[:prefiks] == 'P' }
Testy.sprawdz(pp.all? { |e| e[:wreby] && e[:wreby].length >= 3 }, "każda płatew ma wręby w obu szczytach i działowej (#{pp.map { |e| (e[:wreby] || []).length }.inspect})")
e = pp.find { |x| x[:wreby] }
Testy.rowne(e[:wreby].map { |a, b| (b - a).round(1) }.uniq, [46.0], 'wrąb = grubość ściany + 2 × luz 1')
Testy.rowne(e[:wrab], { bok: 5.0, dol: 8.0 }, 'wrąb 5 z boku, 8 od spodu')
w2 = sciana(pl, 'W-2')
g = w2[:otwory].select { |o| o[:gniazdo] }
Testy.rowne(g.map { |o| (o[:s1] - o[:s0]).round(1) }.uniq, [70.0], 'gniazdo w szczycie = wrąb 80 − 2 × 5, bez luzu – bal dochodzi do dna wrębu (runda 8)')
zs = pl[:elementy].select { |x| x[:prefiks] == 'P' }.map { |x| x[:polozenie][:poczatek][2] }
Testy.sprawdz(g.all? { |o| zs.any? { |z| (o[:z0] - z - 8.0).abs < 0.01 } }, 'dno gniazda na spodzie wrębu (spód płatwi + 8)')
Testy.rowne(kolizje_belek(pl, 'P'), 0, 'płatwie z wrębami bez kolizji z balami')
poz = pl[:pozycje_elementow].find { |x| x[:wreby] }
k = Siatka.sprawdz(Projekt.siatka_pozycji(poz)[:sciany])
Testy.sprawdz(k[:zamknieta], 'bryła płatwi z wrębami zamknięta')
Testy.rowne(k[:objetosc].round(1), Projekt.objetosc_pozycji(poz).round(1), 'objętość płatwi z wrębami')
pl2 = plan_pelny(prostokat(0, 0, 7000, 5000), 'platwie_zamki' => 'nie')
Testy.sprawdz(pl2[:elementy].none? { |x| x[:wreby] }, 'bez zamków – płatwie bez wrębów')

Testy.grupa('Działowa wzdłuż kalenicy do dachu (runda 7)')
seg = prostokat(0, 0, 7000, 5000) + [[[0, 2500], [7000, 2500]], [[0, 1600], [3500, 1600]]]
pl = plan_pelny(seg)
dz = pl[:sciany].select { |w| w[:rodzaj] == :dzialowa && w[:kierunek] == :A }
Testy.rowne(dz.length, 2, 'dwie działowe wzdłuż kalenicy')
pod = dz.find { |w| (w[:a][1] - 2500).abs < 1 }
boczna = dz.find { |w| (w[:a][1] - 1600).abs < 1 }
okap = Wience.wysokosci(pl[:parametry])[:okapowa]
Testy.sprawdz(Wience.wysokosc(pod, pl[:parametry]) > okap + 700, 'działowa pod kalenicą wyżej niż ściany okapowe')
Testy.sprawdz(pod[:otwory].any? { |o| o[:gniazdo] && o[:s0] < pod[:s_od] + 1 }, 'płatew kalenicowa w gnieździe na całej długości działowej')
Testy.sprawdz(boczna[:bale].any? { |b| b[:cechy].any? { |c| c[:typ] == 'sciecie_dachu' } }, 'działowa boczna – górny bal ścięty pod dach')
wz = wzgledem_polaci(pl)
Testy.sprawdz(wz[:bale] <= 0.01, format('działowe pod połacią (%.3f)', wz[:bale]))
w2 = sciana(pl, 'W-2')
Testy.sprawdz((w2[:styki][:wspolne] || []).any? { |c| (c - 2478.0).abs < 1.0 }, 'szczyt łączony w zamku działowej pod kalenicą')
Testy.rowne(Kontrola.styki_bez_zamka(pl), [], 'styki w zamkach')
czysto(pl, 'działowe do dachu')
pl = plan_pelny(seg, 'dzialowa_wzdluz_do_dachu' => 'nie')
Testy.rowne(Wience.wysokosc(pl[:sciany].find { |w| w[:rodzaj] == :dzialowa && (w[:a][1] - 2500).abs < 1 }, pl[:parametry]), okap,
            'nie – działowa do wysokości ścian okapowych')

Testy.grupa('Węgły pod dachem: słupek przy szczycie do płaszczyzny dachu, przy okapie – wieniec nad ścianą (runda 8)')
pl = plan_pelny(prostokat(0, 0, 8000, 6400), 'dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator')
p = pl[:parametry]
geo = { v_a: 22.0, v_b: 6378.0 }
przy_szczycie = pl[:sciany].select { |w| w[:rodzaj] == :kontrfor && w[:gospodarz][:szczyt] }
Testy.sprawdz(przy_szczycie.length >= 2, "węgły przy szczytach (#{przy_szczycie.length})")
luki = przy_szczycie.map do |w|
  b = w[:bale].max_by { |x| x[:z0] }
  gora = Bryla.profil(b[:dl], 44.0, b[:h], b[:cechy]).map { |q| [q[:zt_a], q[:zt_b]].max }.max + b[:z0]
  lin = [Dach.linia_podparcia(geo, w[:a][1] - 22.0, p), Dach.linia_podparcia(geo, w[:a][1] + 22.0, p)]
  [gora - lin.min, lin.max - gora]
end
Testy.sprawdz(luki.all? { |a, b| a > -0.5 && b > -0.01 }, "górny bal słupka sięga płaszczyzny dachu, nie wyżej (#{luki.map { |x| x.map { |y| y.round(1) } }.inspect})")
Testy.sprawdz(przy_szczycie.all? { |w| w[:bale].any? { |b| b[:cechy].any? { |c| c[:typ] == 'sciecie_dachu' } } }, 'ścięcie w poprzek')
przy_okapie = pl[:sciany].select { |w| w[:rodzaj] == :kontrfor && w[:gospodarz][:szczyt].nil? }
okap = Wience.wysokosci(p)[:okapowa]
Testy.sprawdz(!przy_okapie.empty? && przy_okapie.all? { |w| w[:bale].any? { |b| b[:z0] < okap && b[:z0] + b[:h] > okap } },
              'węgły na ścianach okapowych – wieniec nad górą ściany (do dachu)')
Testy.rowne([kolizje_belek(pl, 'P', 5), kolizje_belek(pl, 'K', 5)], [0, 0], 'płatwie i krokwie bez kolizji z węgłami')
k = Kontrola.wszystko(pl)
Testy.rowne([k[:kolizje].length, k[:mijanka].length], [0, 0], 'zamki i mijanka')
wz = nad_linia(pl, 'W-2')
Testy.sprawdz(wz <= 0.01, format('szczyt pod linią (%.3f)', wz))

Testy.grupa('Górne wieńce okapowe wypuszczone jak płatwie, węgły pod okapem do nawisu (runda 8)')
pl = plan_pelny(prostokat(0, 0, 8000, 6400), 'dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator', 'wegly_wypust_okap' => 'tak')
p = pl[:parametry]
w1 = sciana(pl, 'W-1')
gorne = w1[:wience].last(2).map { |wn| w1[:bale].select { |b| (b[:z0] - wn[:z0]).abs < 0.01 } }
Testy.sprawdz(gorne.all? { |l| l.map { |b| b[:s0] }.min < -521.99 && l.map { |b| b[:s1] }.max > 8477.99 },
              'dwa górne wieńce W-1 od −522 do 8478 (500 za licem szczytów, jak płatwie)')
nizej = w1[:bale].select { |b| (b[:z0] - w1[:wience][-3][:z0]).abs < 0.01 }
Testy.rowne([nizej.map { |b| b[:s0] }.min, nizej.map { |b| b[:s1] }.max], [-122.0, 8078.0], 'trzeci od góry – zwykły ostatek')
Testy.sprawdz(pl[:ostrzezenia].none? { |u| u.include?('skrócone') }, 'styki liczone z wypustami – bez skracania')
Testy.sprawdz(w1[:bale].all? { |b| b[:dl] <= 5100.01 }, 'bale ≤ 5100')
kf = pl[:sciany].select { |w| w[:rodzaj] == :kontrfor && w[:gospodarz][:id] == 'W-1' }
Testy.sprawdz(kf.all? { |w| w[:bale].map { |b| b[:s0] }.min < -300.0 }, 'węgły pod okapem: górne bale wysunięte na zewnątrz (wspornik)')
Testy.rowne([kolizje_belek(pl, 'P', 5), kolizje_belek(pl, 'K', 5)], [0, 0], 'płatwie i krokwie bez kolizji z wypustami')
k = Kontrola.wszystko(pl)
Testy.rowne([k[:kolizje].length, k[:mijanka].length, k[:za_dlugie].length], [0, 0, 0], 'zamki, mijanka, długości')
pl0 = plan_pelny(prostokat(0, 0, 8000, 6400), 'okap_wience_wypust' => 0)
Testy.rowne(sciana(pl0, 'W-1')[:bale].map { |b| b[:s0] }.min, -122.0, 'okap_wience_wypust = 0 – bez wypustów')

Testy.koniec
