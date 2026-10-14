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

Testy.grupa('Krokwie przy szczycie – obie strony, od wewnątrz, na szczycie')
seg = prostokat(0, 0, 5000, 4000)
wyn = {}
%w[obie_strony wewnatrz zewnatrz na_szczycie].each do |k|
  pl = plan_pelny(seg, 'dach_uklad' => 'platwie_krokwie', 'krokwie_przy_szczycie' => k)
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

Testy.grupa('Same krokwie – bez płatwi pośrednich')
pl = plan_pelny(prostokat(0, 0, 5000, 4000), 'dach_uklad' => 'krokwie')
Testy.rowne(pl[:elementy].select { |e| e[:prefiks] == 'P' }.map { |e| e[:b] }.sort, [60.0, 60.0, 80.0], 'płatwie: 2 ścienne + kalenicowa')
Testy.rowne(sciana(pl, 'W-2')[:otwory].count { |o| o[:gniazdo] }, 3, 'trzy gniazda w szczycie')

Testy.grupa('Węgły i działowe pod płatwią ścienną – gniazda')
seg = prostokat(0, 0, 6000, 4000) + [[[3000, 0], [3000, 4000]]]
pl = plan_pelny(seg)
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

Testy.koniec
