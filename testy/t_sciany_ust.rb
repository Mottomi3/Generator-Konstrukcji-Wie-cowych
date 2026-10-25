# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_sciany_ust.rb
# Zadanie: testy ustawień pojedynczych ścian z widoku ściany – ostatek na końcu, węgły ręczne, niższa działowa pod stropem / antresolą / półką z dopełnieniem zamka.
# Tematy: testy ustawień ściany, ostatek 200 na narożniku, węgły ręczne, usunięty węgieł, działowa niższa, dopełnienie zamka, strop, antresola, odcinki 244 i 344
# Zależy od: testy/pomoc.rb
# Używają: testy/uruchom.sh

require File.expand_path('pomoc', File.dirname(__FILE__))
require File.expand_path('kolizje_belek', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

# Plan z ustawieniami ścian (bez szczytów i podłogi, gdy pelny = false).
def plan_s(segmenty, parametry, sciany, otwory = [], pelny = false)
  par = pelny ? parametry : { 'szczyty' => 'nie', 'podloga' => 'nie' }.merge(parametry)
  Projekt.oblicz('segmenty' => segmenty, 'parametry' => par, 'otwory' => otwory, 'sciany' => sciany)
end

# Węgły ściany: [[s, źródło]] (s zaokrąglone).
def wegly_sciany(pl, id)
  sciana(pl, id)[:skrzyzowania].select { |k| k[:typ] == :kontrfor }.map { |k| [k[:s].round, k[:inna][:zrodlo]] }
end

# Kontrola bez kolizji, mijanki i za długich bali.
def czysto(pl, opis)
  k = Kontrola.wszystko(pl)
  Testy.rowne([k[:kolizje].length, k[:mijanka].length, k[:za_dlugie].length, k[:styki_bez_zamka].length], [0, 0, 0, 0],
              "#{opis}: kolizje, mijanka, za długie, styki bez zamka")
end

# Bale nadstawki (wieńce ponad własną wysokością ściany).
def nadstawka(pl, id)
  sciana(pl, id)[:bale].select { |b| b[:wieniec][:nadstawka] }
end

# Największe wystawanie bali ściany pod połacią ponad linię dachu [mm] (≤ 0 – wszystko pod połacią).
def nad_dachem(pl, id)
  w = sciana(pl, id)
  p = pl[:parametry]
  t = Parametry.grubosc(p)
  w[:bale].map do |b|
    Bryla.profil(b[:dl], t, b[:h], b[:cechy]).map do |q|
      [[q[:xa], q[:zt_a]], [q[:xb], q[:zt_b]]].map { |x, zt| b[:z0] + zt - PodDachem.linia(w, b[:s0] + x, p) }.max
    end.max
  end.compact.max
end

Testy.grupa('Ostatek 200 na jednym końcu ściany')
dom = prostokat(0, 0, 4000, 3000)
p0 = plan_s(dom, {}, {})
p1 = plan_s(dom, {}, 'W-1' => { 'ostatek_od' => '200' })
Testy.rowne(sciana(p0, 'W-1')[:s_od], -122.0, 'bez ustawień: ostatek 100')
Testy.rowne([sciana(p1, 'W-1')[:s_od], sciana(p1, 'W-1')[:s_do]], [-222.0, sciana(p0, 'W-1')[:s_do]], 'W-1: początek 200, koniec bez zmian')
Testy.rowne(sciana(p1, 'W-1')[:bale].map { |b| b[:dl].round }.max, 4300, 'bale W-1 dłuższe o 100')
Testy.rowne(sciana(p1, 'W-4')[:bale].map { |b| b[:dl].round }.max, 3200, 'ściana poprzeczna bez zmian')
czysto(p1, 'ostatek 200')
Testy.rowne(UstawieniaScian.stan(sciana(p1, 'W-1'), p1[:parametry])['ostatek_od'], 200.0, 'stan dla okna: ostatek początku')
p2 = plan_s(dom, {}, 'W-2' => { 'ostatek_do' => '1000' })
Testy.rowne(sciana(p2, 'W-2')[:s_do] - sciana(p2, 'W-2')[:dl_osi], 622.0, 'ostatek ponad zakres – 600')
Testy.sprawdz(p2[:ostrzezenia].any? { |u| u.include?('W-2') && u.include?('600') }, 'ostrzeżenie o zakresie ostatka')
p3 = plan_s(dom, {}, 'W-9' => { 'ostatek_od' => '200' })
Testy.sprawdz(p3[:ostrzezenia].any? { |u| u.include?('W-9') && u.include?('pominięte') }, 'ustawienia nieistniejącej ściany – ostrzeżenie')
wolny = plan_s(prostokat(0, 0, 5000, 4000) + [[[2500, 0], [2500, 2000]]], {}, 'W-5' => { 'ostatek_do' => '200' })
Testy.rowne(sciana(wolny, 'W-5')[:s_do], sciana(wolny, 'W-5')[:dl_osi], 'wolny koniec działowej – bez ostatka mimo ustawienia')

Testy.grupa('Węgły ręczne: dodany, usunięty, zamiast automatu i rysunku')
dom = prostokat(0, 0, 7000, 4500)
auto = plan_s(dom, { 'max_dlugosc' => 7200 }, {})
Testy.rowne(wegly_sciany(auto, 'W-1').map { |s, z| z }, [:usztywnienie], 'automat: węgieł usztywniający na W-1')
puste = plan_s(dom, { 'max_dlugosc' => 7200 }, 'W-1' => { 'wegly' => [] })
Testy.rowne(wegly_sciany(puste, 'W-1'), [], 'lista pusta: bez węgłów na W-1')
Testy.sprawdz(puste[:ostrzezenia].any? { |u| u.include?('W-1') && u.include?('ręcznie') }, 'ostrzeżenie o świetle przy węgłach ręcznych')
Testy.rowne(wegly_sciany(puste, 'W-3').map { |s, z| z }, [:usztywnienie], 'inna ściana – automat bez zmian')
jeden = plan_s(dom, { 'max_dlugosc' => 7200 }, 'W-1' => { 'wegly' => ['2000'] })
Testy.rowne(wegly_sciany(jeden, 'W-1'), [[2000, :reczny]], 'węgieł ręczny w 2000')
Testy.sprawdz(jeden[:ostrzezenia].any? { |u| u.include?('W-1') && u.include?('światło') }, 'za długie światło po prawej – ostrzeżenie')
czysto(jeden, 'węgieł ręczny')
dwa = plan_s(dom, { 'max_dlugosc' => 7200 }, 'W-1' => { 'wegly' => [2300, 4600, 10] })
Testy.rowne(wegly_sciany(dwa, 'W-1'), [[2300, :reczny], [4600, :reczny]], 'dwa węgły ręczne, trzeci przy narożniku pominięty')
Testy.sprawdz(dwa[:ostrzezenia].any? { |u| u.include?('W-1') && u.include?('pominięty') }, 'ostrzeżenie o pominiętym węgle')
Testy.sprawdz(dwa[:ostrzezenia].none? { |u| u.include?('W-1') && u.include?('światło') }, 'światła w limicie – bez ostrzeżenia')
narys = dom + [[[1500, -150], [1500, 150]]]
pn = plan_s(narys, { 'max_dlugosc' => 7200 }, {})
Testy.rowne(wegly_sciany(pn, 'W-1').map { |s, z| [s, z] }.first, [1478, :rysunek], 'narysowany węgieł')
pr = plan_s(narys, { 'max_dlugosc' => 7200 }, 'W-1' => { 'wegly' => [3478] })
Testy.rowne(wegly_sciany(pr, 'W-1'), [[3478, :reczny]], 'lista ręczna zastępuje narysowany węgieł')
dlugi = prostokat(0, 0, 9000, 4000)
st1 = plan_s(dlugi, {}, 'W-1' => { 'wegly' => [4478] })
Testy.sprawdz(st1[:ostrzezenia].any? { |u| u.include?('W-1') && u.include?('styków') && u.include?('ręcznie') }, 'jeden węgieł ręczny – styków nie da się dobrać')
st2 = plan_s(dlugi, {}, 'W-1' => { 'wegly' => [4178, 4778] })
Testy.rowne(sciana(st2, 'W-1')[:styki][:kotwy].map(&:round), [4178, 4778], 'styki na przemian w dwóch węgłach ręcznych')
Testy.rowne(wegly_sciany(st2, 'W-1').length, 2, 'bez nowych węgłów pod styki')
czysto(st2, 'styki w węgłach ręcznych')

Testy.grupa('Działowa pod antresolą (szczytowa, B) – dopełnienie zamka 244 przy ścianach okapowych')
dom = prostokat(0, 0, 6000, 4200) + [[[2000, 0], [2000, 4200]]]
par = { 'liczba_wiencow' => 25 }
pelna = plan_s(dom, par, {})
Testy.rowne(Wience.wysokosc(sciana(pelna, 'W-5'), pelna[:parametry]), 25 * 139.0, 'pełna działowa: 25 wieńców')
an = plan_s(dom, par, 'W-5' => { 'nad' => 'antresola', 'wysokosc' => '2500' })
w5 = sciana(an, 'W-5')
Testy.rowne(Wience.wysokosc(w5, an[:parametry]), 17 * 139.0, 'działowa pod antresolą: 17 wieńców (2363)')
Testy.rowne(w5[:dopelnienie].length, 2, 'dwie kolumny dopełnienia (obie ściany okapowe)')
ns = nadstawka(an, 'W-5')
Testy.rowne(ns.length, 18, '9 wieńców nadstawki × 2 odcinki')
Testy.rowne(ns.map { |b| b[:dl].round }.uniq, [244], 'odcinki 244 (100 + 44 + 100)')
Testy.sprawdz(ns.all? { |b| b[:pozycja][:prefiks] == 'Bs' }, 'odcinki to bale ścienne działowej (jak W-7 w 1100)')
Testy.rowne(ns.map { |b| b[:z0] }.max, 25 * 139.0, 'ostatni odcinek zamyka zamek z górnym balem ściany okapowej')
czysto(an, 'antresola')
an2 = plan_s(dom, par.merge('ostatek' => 200), 'W-5' => { 'nad' => 'polka', 'wysokosc' => '2780' })
Testy.rowne(Wience.wysokosc(sciana(an2, 'W-5'), an2[:parametry]), 20 * 139.0, 'pod półką 2780: 20 wieńców (jak 1200)')
Testy.rowne(nadstawka(an2, 'W-5').map { |b| b[:dl].round }.uniq, [344], 'przy ostatku 200 odcinki 344 (jak 1200 W-7)')
czysto(an2, 'półka, ostatek 200')
st = plan_s(dom, par.merge('strop' => 'tak'), {})
Testy.rowne(Wience.wysokosc(sciana(st, 'W-5'), st[:parametry]), 17 * 139.0, 'strop nad parterem: działowa pod stropem')
st_nic = plan_s(dom, par.merge('strop' => 'tak'), 'W-5' => { 'nad' => 'nic' })
Testy.rowne(Wience.wysokosc(sciana(st_nic, 'W-5'), st_nic[:parametry]), 25 * 139.0, 'strop, ale działowa ustawiona na pełną')
nisko = plan_s(dom, {}, 'W-5' => { 'nad' => 'strop', 'wysokosc' => '5000' })
Testy.sprawdz(nisko[:ostrzezenia].any? { |u| u.include?('W-5') && u.include?('pełnej wysokości') }, 'góra ponad pełną wysokość – ostrzeżenie')
Testy.rowne(nadstawka(nisko, 'W-5').length, 0, 'wtedy bez nadstawki')
dach = plan_s(dom, par.merge('dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator'), { 'W-5' => { 'nad' => 'antresola', 'wysokosc' => '2500' } }, [], true)
Testy.sprawdz(!sciana(dach, 'W-5')[:pod_dachem].nil?, 'działowa w poprzek kalenicy pod połacią')
Testy.sprawdz(nad_dachem(dach, 'W-5') <= 0.01, "odcinki nadstawki pod połacią (wystaje #{nad_dachem(dach, 'W-5').round(2)})")
Testy.rowne([kolizje_belek(dach, 'P'), kolizje_belek(dach, 'K')], [0, 0], 'płatwie i krokwie bez kolizji z odcinkami nadstawki')
czysto(dach, 'antresola z dachem')
otw = plan_s(dom, par, { 'W-5' => { 'nad' => 'antresola', 'wysokosc' => '2500' } },
             [{ 'sciana' => 'W-5', 'od' => '1500', 'szerokosc' => '900', 'wysokosc' => '2600', 'parapet' => '0' }])
Testy.sprawdz(otw[:ostrzezenia].any? { |u| u.include?('W-5') && u.include?('poza ścianę') }, 'drzwi wyższe niż niższa działowa – ostrzeżenie')

Testy.grupa('Działowa wzdłuż kalenicy (A) pod antresolą – dopełnienie przy szczytach, pod linią szczytu')
dom = prostokat(0, 0, 6000, 4200) + [[[0, 1500], [6000, 1500]]]
aa = plan_s(dom, { 'liczba_wiencow' => 20 }, { 'W-5' => { 'nad' => 'antresola', 'wysokosc' => '2500' } }, [], true)
w5 = sciana(aa, 'W-5')
Testy.rowne(w5[:kierunek], :A, 'działowa wzdłuż kalenicy')
Testy.rowne(Wience.wysokosc(w5, aa[:parametry]), 17 * 139.0 + 69.5, 'półbal + 17 wieńców (2432,5 – jak 1100 W-6)')
kol = w5[:dopelnienie]
Testy.rowne(kol.length, 2, 'kolumny przy obu szczytach')
Testy.sprawdz(kol.all? { |k| k[:z_gora] }, 'kolumny pod linią szczytu')
ns = nadstawka(aa, 'W-5')
Testy.sprawdz(ns.length > 2, "odcinki nad działową (#{ns.length})")
Testy.sprawdz(ns.all? do |b|
  k = kol.find { |x| b[:s0] >= x[:s0] - 0.01 && b[:s1] <= x[:s1] + 0.01 }
  k && b[:z0] + b[:h] <= k[:z_gora] + 0.01
end, 'każdy odcinek w swojej kolumnie i pod linią szczytu')
czysto(aa, 'działowa A pod antresolą, szczyty')
Testy.rowne([kolizje_belek(aa, 'P'), kolizje_belek(aa, 'K')], [0, 0], 'belki dachu bez kolizji z odcinkami przy szczytach')
Testy.sprawdz(aa[:bledy].empty?, 'bez błędów planu')

Testy.grupa('Działowa ze szczytem ustawiona pod antresolą – bez szczytu')
dom = prostokat(0, 0, 8000, 6000) + [[[4000, 0], [4000, 6000]]]
sz = plan_s(dom, { 'szczyty_na_dzialowych' => 'tak', 'liczba_wiencow' => 20 }, {}, [], true)
Testy.sprawdz(!sciana(sz, 'W-5')[:szczyt].nil?, 'działowa ze szczytem')
sz2 = plan_s(dom, { 'szczyty_na_dzialowych' => 'tak', 'liczba_wiencow' => 20 }, { 'W-5' => { 'nad' => 'antresola' } }, [], true)
Testy.sprawdz(sciana(sz2, 'W-5')[:szczyt].nil?, 'pod antresolą szczytu nie ma')
Testy.sprawdz(nadstawka(sz2, 'W-5').length > 0, 'dopełnienie przy ścianach okapowych')
czysto(sz2, 'działowa pod antresolą zamiast szczytu')

Testy.koniec
