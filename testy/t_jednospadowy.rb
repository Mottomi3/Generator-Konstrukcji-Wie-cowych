# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_jednospadowy.rb
# Zadanie: dach jednospadowy – ściana niska i wysoka, szczyty skośne do linii dachu, ściana wysoka do połaci (górny bal przycięty, cienki pasek pominięty), płatwie bez kalenicowej, krokwie w jednym kawałku, połać dla aplikacji (trzy krawędzie szczytowe), widok ściany, obrys L.
# Tematy: testy dachu jednospadowego, ściana wysoka w testach, szczyt skośny w testach, spadek dachu w testach, okap za ścianą wysoką w testach
# Zależy od: testy/pomoc.rb, testy/kolizje_belek.rb, Plugins/.../rdzen/dach_jednospadowy.rb
# Używają: testy/uruchom.sh

require File.expand_path('pomoc', File.dirname(__FILE__))
require File.expand_path('kolizje_belek', File.dirname(__FILE__))
require File.join(KATALOG_WTYCZKI, 'rdzen', 'widok')
include ArteMadera::GeneratorWiencowy

JEDNO = { 'dach_rodzaj' => 'jednospadowy' }.freeze

def czysto(pl, opis)
  k = Kontrola.wszystko(pl)
  Testy.rowne([k[:kolizje].length, k[:mijanka].length, k[:za_dlugie].length], [0, 0, 0], "#{opis}: zamki, mijanka, długości")
end

# Najwyższy wierzch bali ściany po przycięciu [mm].
def gora_bali(w)
  w[:bale].map { |b| b[:z0] + b[:h] - Projekt.wysokosc_ciecia(b) }.max
end

Testy.grupa('Dom 5000 × 4000, spadek w stronę mniejszych y – W-1 niska, W-3 wysoka')
pl = plan_pelny(prostokat(0, 0, 5000, 4000), JEDNO)
p = pl[:parametry]
t = Parametry.grubosc(p)
Testy.rowne([pl[:bledy], pl[:ostrzezenia]], [[], []], 'bez błędów i ostrzeżeń')
Testy.rowne(pl[:sciany].select { |w| w[:szczyt] }.map { |w| w[:id] }, %w[W-2 W-3 W-4], 'szczyty skośne W-2, W-4 i płaski W-3')
w1 = sciana(pl, 'W-1')
w3 = sciana(pl, 'W-3')
Testy.rowne(Wience.wysokosc(w1, p), Wience.wysokosci(p)[:okapowa], 'ściana niska – wysokość ścian okapowych')
Testy.sprawdz(w3[:szczyt][:plaski] && w3[:szczyt][:kv].zero?, 'ściana wysoka – szczyt płaski')
z_w3 = Dach.z_ref(p) + Dach.tg(p) * (3978.0 - 22.0 - t / 2.0 - t / 2.0)
Testy.rowne(w3[:szczyt][:z_max], z_w3, 'linia przy licu wewnętrznym ściany wysokiej: z_ref + tg × (oś − oś − grubość)', 0.001)
Testy.rowne(gora_bali(w3), z_w3, 'ściana wysoka sięga połaci (górny bal przycięty wzdłuż)', 0.01)
Testy.rowne(pl[:podsumowanie][:wysokosci][:wysoka], z_w3.round(1), 'wysokość ściany wysokiej w podsumowaniu', 0.05)
Testy.sprawdz(w3[:bale].none? { |b| b[:pozycja][:prefiks] == 'Sz' }, 'bale ściany wysokiej – Bs (nie bale szczytu)')
Testy.sprawdz(sciana(pl, 'W-2')[:bale].any? { |b| b[:pozycja][:prefiks] == 'Sz' }, 'bale szczytu skośnego – Sz')
nad = %w[W-2 W-3 W-4].map { |id| nad_linia(pl, id) }.max
Testy.sprawdz(nad <= 0.01, format('bale pod linią dachu (najwyżej %.3f mm)', nad))
w2 = sciana(pl, 'W-2')
Testy.rowne([Szczyty.linia(w2, w2[:s_od], p) < Szczyty.linia(w2, w2[:s_do], p), Szczyty.zalom(w2, p)], [true, nil],
            'szczyt skośny rośnie od ściany niskiej, bez załomu')
pp = pl[:elementy].select { |e| e[:prefiks] == 'P' }
Testy.rowne(pp.map { |e| e[:b] }, [60.0, 80.0, 80.0, 80.0], 'płatwie: ścienna przy ścianie niskiej + 3 pośrednie, bez kalenicowej')
osie = pp.map { |e| e[:polozenie][:poczatek][1] + e[:b] / 2.0 }
Testy.sprawdz(osie.each_cons(2).all? { |a, b| b - a <= 1000.01 } && 3956.0 - osie.last <= 1000.01, "rozstaw płatwi ≤ 1000 do lica ściany wysokiej (#{osie.map(&:round).inspect})")
Testy.rowne(kolizje_belek(pl, 'P'), 0, 'płatwie bez kolizji z balami')
Testy.rowne(sciana(pl, 'W-2')[:otwory].count { |o| o[:gniazdo] }, 4, 'cztery gniazda w szczycie skośnym')
czysto(pl, 'dom')
v = Widok.sciana(pl, 'W-2')
Testy.rowne(v['linia_dachu'].length, 2, 'widok szczytu skośnego: linia dachu prosta')
v3 = Widok.sciana(pl, 'W-3')
Testy.rowne(v3['linia_dachu'].map { |_s, z| z }.uniq, [z_w3.round(1)], 'widok ściany wysokiej: linia dachu pozioma')

Testy.grupa('Spadek w stronę większych y, kalenica wzdłuż krótszego boku')
pl = plan_pelny(prostokat(0, 0, 5000, 4000), JEDNO.merge('dach_spadek' => 'max'))
Testy.rowne(pl[:sciany].select { |w| w[:szczyt] && w[:szczyt][:plaski] }.map { |w| w[:id] }, ['W-1'], 'ściana wysoka W-1')
Testy.rowne(Wience.wysokosc(sciana(pl, 'W-3'), pl[:parametry]), Wience.wysokosci(pl[:parametry])[:okapowa], 'W-3 niska')
czysto(pl, 'spadek max')
pl = plan_pelny(prostokat(0, 0, 5000, 4000), JEDNO.merge('kalenica' => 'krotszy'))
wys = pl[:sciany].find { |w| w[:szczyt] && w[:szczyt][:plaski] }
Testy.sprawdz(wys && wys[:kierunek] == :A && wys[:a][0] > 4000.0, "kalenica wzdłuż krótszego boku: ściana wysoka po stronie x = 5000 (#{wys && wys[:id]})")
Testy.rowne(%w[W-1 W-3].map { |id| nad_linia(pl, id) <= 0.01 }, [true, true], 'szczyty skośne W-1 i W-3 pod linią dachu')
czysto(pl, 'kalenica wzdłuż krótszego')

Testy.grupa('Krokwie z generatora w jednym kawałku, okap za ścianą wysoką 300')
pl = plan_pelny(prostokat(0, 0, 5000, 4000), JEDNO.merge('dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator',
                                                        'dach_okap_wysoki' => 300))
kr = pl[:elementy].select { |e| e[:prefiks] == 'K' }
e = kr.first
pe = e[:polozenie]
koniec_y = pe[:poczatek][1] + pe[:x][1] * e[:dl]
Testy.rowne([pe[:poczatek][1], koniec_y.round(3)], [-500.0, 4300.0], 'od okapu 500 przed ścianą niską do 300 za wysoką')
Testy.sprawdz(kr.all? { |k| k[:polozenie][:x][1] > 0 }, 'wszystkie krokwie w górę połaci')
Testy.rowne([kolizje_belek(pl, 'K'), kolizje_belek(pl, 'P')], [0, 0], 'krokwie i płatwie bez kolizji z balami')
Testy.sprawdz(%w[W-2 W-4].all? { |id| nad_linia(pl, id) <= 0.01 }, 'szczyty do wierzchu krokwi, nie wyżej')
Testy.sprawdz(nad_linia(pl, 'W-3') <= 0.01 && gora_bali(sciana(pl, 'W-3')) <= sciana(pl, 'W-3')[:szczyt][:z_max] + 0.01,
              'ściana wysoka pod krokwiami')

Testy.grupa('Połać dla aplikacji do dachów – trzy krawędzie szczytowe')
pl = plan_pelny(prostokat(0, 0, 5000, 4000), JEDNO.merge('dach_uklad' => 'krokwie', 'dach_okap_wysoki' => 300))
pol = pl[:polacie]
Testy.sprawdz(!pol.nil?, 'połać jest')
Testy.rowne(pol[:szczyty].length, 3, 'trzy krawędzie szczytowe')
okap = ([1, 2, 3, 4] - pol[:szczyty]).first
a = pol[:punkty][okap - 1]
b = pol[:punkty][okap % 4]
Testy.rowne([a[1], b[1]], [0.0, 0.0], 'krawędź okapowa – lico zewnętrzne ściany niskiej')
Testy.rowne(pol[:punkty].map { |_x, y| y }.max, 4000.0 + 300.0 - 500.0, 'strona wysoka przesunięta o okap wysoki − okap')
wz = wzgledem_polaci(pl)
Testy.sprawdz(wz[:bale] <= 0.01 && wz[:platwie] <= 0.01 && wz[:dotyk] >= -0.5,
              format('bale i płatwie pod połacią, płatwie ją podpierają (%.3f / %.3f / %.3f)', wz[:bale], wz[:platwie], wz[:dotyk]))

Testy.grupa('Działowa ze szczytem skośnym, węgły na ścianie wysokiej, płatew na ścianie niskiej')
seg = prostokat(0, 0, 9000, 4500) + [[[4500, 0], [4500, 4500]]]
pl = plan_pelny(seg, JEDNO.merge('szczyty_na_dzialowych' => 'tak', 'platwa_scienna_polozenie' => 'na_scianie', 'dach_kat' => 30,
                                 'dach_uklad' => 'krokwie'))
Testy.rowne(pl[:bledy], [], 'bez błędów')
dz = pl[:sciany].find { |w| w[:rodzaj] == :dzialowa }
Testy.sprawdz(dz[:szczyt] && !dz[:szczyt][:plaski], 'działowa ma szczyt skośny')
kf = pl[:sciany].select { |w| w[:rodzaj] == :kontrfor && w[:gospodarz][:szczyt] && w[:gospodarz][:szczyt][:plaski] }
Testy.sprawdz(!kf.empty?, "węgły na ścianie wysokiej (#{kf.length})")
wz = wzgledem_polaci(pl)
Testy.sprawdz(wz[:bale] <= 0.01 && wz[:platwie] <= 0.01 && wz[:dotyk] >= -0.5,
              format('węgły, działowa i płatwie pod połacią (%.3f / %.3f / %.3f)', wz[:bale], wz[:platwie], wz[:dotyk]))
czysto(pl, 'działowa i węgły')

Testy.grupa('Cienki górny pasek ściany wysokiej pomijany')
pasek = lambda do |pl_|
  w = pl_[:sciany].find { |x| x[:szczyt] && x[:szczyt][:plaski] }
  w[:szczyt][:z_max] - w[:bale].map { |b| b[:z0] }.max
end
grubosci = (0..30).map { |i| 3000 + i * 10 }.map { |d| [d, pasek.call(plan_pelny(prostokat(0, 0, 4000, d), JEDNO))] }
Testy.sprawdz(grubosci.all? { |_d, g| g >= 30.0 - 0.01 && g < 139.0 + 30.0 },
              "górny bal ściany wysokiej nie cieńszy niż 30 (#{grubosci.map { |_d, g| g.round }.uniq.sort.first(3).inspect})")
Testy.sprawdz(grubosci.any? { |_d, g| g > 139.0 }, 'cienki pasek pominięty – górny bal pełny, pod połacią szczelina do 30')

Testy.grupa('Narożnik przy ścianie wysokiej – bal szczytu przez narożnik tylko w zamku')
pl = plan_pelny(prostokat(0, 0, 5000, 4000), JEDNO)
p = pl[:parametry]
w3 = sciana(pl, 'W-3')
gora = w3[:bale].map { |b| b[:lvl] }.max
w2 = sciana(pl, 'W-2')
nad = w2[:bale].select { |b| b[:lvl] > gora }
Testy.sprawdz(!nad.empty?, "bale szczytu W-2 ponad ścianą wysoką (#{nad.length})")
Testy.sprawdz(nad.all? { |b| b[:s1] <= 3956.0 - 22.0 + 0.01 }, 'kończą się przy licu wewnętrznym ściany wysokiej – bez ostatka')
Testy.sprawdz(nad.select { |b| (b[:s1] - 3934.0).abs < 0.01 }.all? { |b| b[:konce][1] == :wolny }, 'koniec przy licu – wolny (bez zamka)')
Testy.sprawdz(w3[:bale].select { |b| b[:lvl] == gora }.all? { |b| b[:cechy].none? { |c| c[:typ] == 'gniazdo_gora' } },
              'górny bal ściany wysokiej bez pustego gniazda z góry')
Testy.sprawdz(w2[:bale].none? { |b| b[:s1] > 3934.01 && b[:cechy].any? { |c| c[:typ] == 'skos_gora' } &&
                                 b[:cechy].none? { |c| c[:typ] == 'gniazdo_dol' && (c[:os] - 3956.0).abs < 0.01 } },
              'każdy bal ścięty dachem w narożniku ma gniazdo zamka')
mostki = w2[:bale].select { |b| b[:s1] > 3934.01 && b[:cechy].any? { |c| c[:typ] == 'skos_gora' } }.map do |b|
  SkosPrzyNarozniku.wierzch_w_gniezdzie(b, 3956.0, 40.0) - 36.0
end
Testy.sprawdz(mostki.all? { |m| m >= p['zamek_min_drewno'] - 0.01 }, "drewno nad gniazdem ≥ 20 (#{mostki.map { |m| m.round(1) }.inspect})")
pl0 = plan_pelny(prostokat(0, 0, 5000, 4000), JEDNO.merge('zamek_min_drewno' => 0))
Testy.sprawdz(pl0[:bale].length >= pl[:bale].length, 'zamek_min_drewno 0 – tyle samo albo więcej bali')
czysto(pl, 'narożnik')

Testy.grupa('Obrys L – dach jednospadowy tylko dla domu prostokątnego')
pl = plan_pelny(wielokat([[0, 0], [8000, 0], [8000, 4000], [4500, 4000], [4500, 7000], [0, 7000]]), JEDNO)
Testy.sprawdz(pl[:sciany].none? { |w| w[:szczyt] } && pl[:ostrzezenia].any? { |u| u.include?('Dach jednospadowy') },
              'bez szczytów, ostrzeżenie')

Testy.koniec
