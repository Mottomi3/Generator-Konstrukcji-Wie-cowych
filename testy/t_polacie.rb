# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_polacie.rb
# Zadanie: połacie dla aplikacji do dachów – obrys, wysokość, krawędzie szczytowe, okap i wysunięcie za szczyt; płatwie pod połacią, szczyt pod krokwiami, bez krokwi generatora; kiedy połaci nie ma.
# Tematy: testy połaci, aplikacja do dachów w testach, płaszczyzna spodu krokwi, krawędzie szczytowe, okap połaci, krokwie z generatora albo z aplikacji, podpowiedź dachu
# Zależy od: testy/pomoc.rb, testy/kolizje_belek.rb, Plugins/.../rdzen/polacie.rb
# Używają: testy/uruchom.sh

require File.expand_path('pomoc', File.dirname(__FILE__))
require File.expand_path('kolizje_belek', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

# Pole wielokąta ze znakiem.
def pole_ze_znakiem(pts)
  s = 0.0
  pts.each_with_index { |a, i| b = pts[(i + 1) % pts.length]; s += a[0] * b[1] - b[0] * a[1] }
  s / 2.0
end

# Obrys połaci po odsunięciu okapu (jak aplikacja: każda krawędź o okap na zewnątrz) – [x_min, x_max, y_min, y_max].
def obrys_dachu(pol)
  xs = pol[:punkty].map { |x, _y| x }
  ys = pol[:punkty].map { |_x, y| y }
  [xs.min - pol[:okap], xs.max + pol[:okap], ys.min - pol[:okap], ys.max + pol[:okap]]
end

# Zakres płatwi wzdłuż osi (0 – x, 1 – y): [min, max] końców wszystkich płatwi.
def zakres_platwi(pl, os)
  konce = pl[:elementy].select { |e| e[:prefiks] == 'P' }.flat_map do |e|
    pe = e[:polozenie]
    [pe[:poczatek][os], pe[:poczatek][os] + pe[:x][os] * e[:dl]]
  end
  [konce.min, konce.max]
end

Testy.grupa('Dom 5000 × 4000, krokwie z aplikacji (domyślnie) – połacie na spodzie krokwi')
seg = prostokat(0, 0, 5000, 4000)
pl = plan_pelny(seg, 'dach_uklad' => 'krokwie')
p = pl[:parametry]
pol = pl[:polacie]
Testy.rowne(pl[:bledy], [], 'brak błędów')
Testy.rowne(p['dach_wiezba'], 'aplikacja', 'domyślnie krokwie z aplikacji do dachów')
Testy.sprawdz(!pol.nil?, 'są połacie')
Testy.rowne(pol[:punkty].length, 4, 'obrys z czterech punktów')
Testy.sprawdz(pole_ze_znakiem(pol[:punkty]) > 0, 'obrys przeciwnie do wskazówek zegara')
Testy.rowne(pol[:punkty].map { |x, _y| x }.minmax + pol[:punkty].map { |_x, y| y }.minmax, [0.0, 5000.0, 0.0, 4000.0],
            'obrys = lica zewnętrzne ścian (okap = wysunięcie za szczyt)')
gable = pol[:szczyty].map { |k| [pol[:punkty][k - 1], pol[:punkty][k % 4]] }
Testy.sprawdz(pol[:szczyty].length == 2 && gable.all? { |a, b| (a[0] - b[0]).abs < 0.01 }, "krawędzie szczytowe x = const (#{pol[:szczyty].inspect})")
t = Parametry.grubosc(p)
Testy.rowne(pol[:z], Dach.z_ref(p) - Dach.tg(p) * t, 'wysokość obrysu = linia podparcia przy licu zewnętrznym', 0.001)
Testy.rowne([pol[:kat], pol[:okap]], [20.0, 500.0], 'kąt i okap z parametrów')
wz = wzgledem_polaci(pl)
Testy.sprawdz(wz[:bale] <= 0.01, format('bale pod połacią (najwyżej %.3f mm)', wz[:bale]))
Testy.sprawdz(wz[:platwie] <= 0.01, format('płatwie pod połacią (najwyżej %.3f mm)', wz[:platwie]))
Testy.sprawdz(wz[:dotyk] >= -0.5, format('każda płatew podpiera krokwie – sięga połaci (najniżej %.3f mm)', wz[:dotyk]))
Testy.rowne(wz[:krokwie], 0, 'bez krokwi generatora – krokwie robi aplikacja')
Testy.rowne(pl[:elementy].count { |e| e[:prefiks] == 'P' }, 3, 'płatwie: 2 ścienne + kalenicowa')
Testy.sprawdz(pl[:podpowiedzi].any? { |h| h[:poziom] == 'ok' && h[:tekst].include?('KROK 2') }, 'podpowiedź o KROKU 2')
dachowy = obrys_dachu(pol)
Testy.rowne(zakres_platwi(pl, 0), [dachowy[0], dachowy[1]], 'płatwie kończą się z połacią przy szczytach')
Testy.rowne([dachowy[2], dachowy[3]], [-500.0, 4500.0], 'okap 500 od lica ścian okapowych')

Testy.grupa('Szczyt pod krokwiami: z aplikacji niżej niż krokwie z generatora obok szczytu')
pl_g = plan_pelny(seg, 'dach_uklad' => 'krokwie', 'dach_wiezba' => 'generator', 'krokwie_przy_szczycie' => 'obie_strony')
pl_n = plan_pelny(seg, 'dach_uklad' => 'krokwie', 'dach_wiezba' => 'generator', 'krokwie_przy_szczycie' => 'na_szczycie')
id = pl[:sciany].find { |w| w[:szczyt] }[:id]
dk = 150.0 / Math.cos(20 * Math::PI / 180)
Testy.rowne(sciana(pl_g, id)[:szczyt][:z_max] - sciana(pl, id)[:szczyt][:z_max], dk, 'niżej o grubość krokwi (150 / cos 20°)', 0.01)
Testy.rowne(sciana(pl_n, id)[:szczyt][:z_max], sciana(pl, id)[:szczyt][:z_max], 'jak krokiew na szczycie', 0.001)
Testy.sprawdz(pl_g[:polacie].nil? && pl_g[:elementy].any? { |e| e[:prefiks] == 'K' }, 'generator: krokwie w planie, bez połaci')
Testy.sprawdz(pl_g[:podpowiedzi].none? { |h| h[:tekst].include?('KROK 2') }, 'generator: bez podpowiedzi o KROKU 2')
Testy.rowne(kolizje_belek(pl, 'P'), 0, 'płatwie bez kolizji z balami')

Testy.grupa('Kalenica wzdłuż y, okap 600, wysunięcie za szczyt 300')
pl = plan_pelny(prostokat(0, 0, 4000, 6500), 'dach_uklad' => 'platwie_krokwie', 'dach_okap' => 600, 'dach_okap_szczyt' => 300,
                'dach_kat' => 35)
pol = pl[:polacie]
Testy.rowne(pl[:bledy], [], 'brak błędów')
gable = pol[:szczyty].map { |k| [pol[:punkty][k - 1], pol[:punkty][k % 4]] }
Testy.sprawdz(gable.all? { |a, b| (a[1] - b[1]).abs < 0.01 }, "krawędzie szczytowe y = const (#{pol[:szczyty].inspect})")
Testy.sprawdz(pole_ze_znakiem(pol[:punkty]) > 0, 'obrys przeciwnie do wskazówek zegara')
Testy.rowne(pol[:punkty].map { |_x, y| y }.minmax, [300.0, 6200.0], 'szczyty w obrysie cofnięte o okap − wysunięcie (300)')
dachowy = obrys_dachu(pol)
Testy.rowne(dachowy, [-600.0, 4600.0, -300.0, 6800.0], 'po odsunięciu: okap 600, za szczytem 300')
Testy.rowne(zakres_platwi(pl, 1), [dachowy[2], dachowy[3]], 'płatwie kończą się z połacią')
wz = wzgledem_polaci(pl)
Testy.sprawdz(wz[:bale] <= 0.01 && wz[:platwie] <= 0.01, format('bale i płatwie pod połacią (%.3f / %.3f mm)', wz[:bale], wz[:platwie]))
Testy.sprawdz(wz[:dotyk] >= -0.5, format('płatwie pośrednie i kalenicowa sięgają połaci (%.3f mm)', wz[:dotyk]))
Testy.sprawdz(pl[:elementy].count { |e| e[:prefiks] == 'P' } > 3, 'są płatwie pośrednie')

Testy.grupa('Płatew ścienna na ścianie, bez ścięcia płatwi, szczyty na działowej')
seg2 = prostokat(0, 0, 7000, 4500) + [[[3500, 0], [3500, 4500]]]
[{ 'platwa_scienna_polozenie' => 'na_scianie' }, { 'platwie_sciecie' => 'nie' },
 { 'szczyty_na_dzialowych' => 'tak', 'dach_uklad' => 'platwie_krokwie' }].each do |dod|
  pl = plan_pelny(seg2, { 'dach_uklad' => 'krokwie' }.merge(dod))
  wz = wzgledem_polaci(pl)
  opis = dod.map { |k, v| "#{k}=#{v}" }.join(', ')
  Testy.rowne(pl[:bledy], [], "#{opis}: brak błędów")
  Testy.sprawdz(wz[:bale] <= 0.01, format('%s: bale pod połacią (%.3f mm)', opis, wz[:bale]))
  Testy.sprawdz(wz[:platwie] <= 0.01 && wz[:dotyk] >= -0.5, format('%s: płatwie pod połacią i ją podpierają (%.3f / %.3f mm)', opis,
                                                                    wz[:platwie], wz[:dotyk]))
  czysto_dach = Kontrola.wszystko(pl)
  Testy.rowne(czysto_dach[:kolizje].length, 0, "#{opis}: zamki bez kolizji")
end

Testy.grupa('Kiedy połaci nie ma')
pl = plan_pelny(seg)
Testy.sprawdz(pl[:polacie].nil? && pl[:podpowiedzi].none? { |h| h[:tekst].start_with?('Dach:') }, 'same płatwie – bez połaci i podpowiedzi')
pl = plan_pelny(seg, 'dach_uklad' => 'krokwie', 'szczyty' => 'nie')
Testy.sprawdz(pl[:polacie].nil? && pl[:podpowiedzi].none? { |h| h[:tekst].start_with?('Dach:') }, 'bez szczytów – bez połaci i podpowiedzi')
pl = plan_pelny(seg, 'dach_uklad' => 'krokwie', 'dach_elementy' => 'nie')
Testy.sprawdz(pl[:polacie].nil?, 'bez belek dachu – bez połaci')
pl = plan_pelny(wielokat([[0, 0], [8000, 0], [8000, 4000], [4500, 4000], [4500, 7000], [0, 7000]]), 'dach_uklad' => 'krokwie')
Testy.sprawdz(pl[:polacie].nil? && pl[:podpowiedzi].any? { |h| h[:poziom] == 'uwaga' && h[:tekst].include?('prostokątnego') },
              'obrys L – bez połaci, podpowiedź o aplikacji')
pl = plan_pelny(prostokat(0, 0, 3000, 2500), 'dach_uklad' => 'krokwie', 'dach_okap' => 1500, 'dach_okap_szczyt' => 0)
Testy.sprawdz(pl[:polacie].nil? && pl[:podpowiedzi].any? { |h| h[:tekst].include?('za krótki') }, 'za krótki dom na połacie – podpowiedź')

Testy.koniec
