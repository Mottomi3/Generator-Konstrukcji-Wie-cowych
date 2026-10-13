# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_rdzen.rb
# Zadanie: testy rdzenia – obrys, ściany, wieńce, styki z mijanką, kontrfory, otwory, pozycje, kolizje w zamkach.
# Tematy: testy rdzenia, dom 900, ściana działowa, skrzyżowanie X, obrys L, obrót, otwory, długie ściany, mijanka
# Zależy od: testy/pomoc.rb
# Używają: testy/uruchom.sh

require File.expand_path('pomoc', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

def bez_kolizji(pl, opis)
  k = Kontrola.wszystko(pl)
  Testy.rowne(k[:kolizje].length, 0, "#{opis}: kolizje w zamkach")
  Testy.rowne(k[:mijanka].length, 0, "#{opis}: naruszenia mijanki")
  Testy.rowne(k[:za_dlugie].length, 0, "#{opis}: bale za długie")
  k
end

Testy.grupa('Dom 4000 × 3000 (jak 900)')
pl = plan(prostokat(0, 0, 4000, 3000))
Testy.rowne(pl[:bledy], [], 'brak błędów')
Testy.rowne(pl[:sciany].map { |w| w[:id] }, %w[W-1 W-2 W-3 W-4], 'numeracja ścian')
Testy.rowne(sciana(pl, 'W-1')[:kierunek], :A, 'W-1 wzdłuż kalenicy (dłuższy bok)')
Testy.rowne(sciana(pl, 'W-2')[:kierunek], :B, 'W-2 szczytowa')
Testy.rowne(sciana(pl, 'W-1')[:s_do] - sciana(pl, 'W-1')[:s_od], 4200.0, 'bal W-1: 4000 + 2 × 100')
Testy.rowne(sciana(pl, 'W-2')[:s_do] - sciana(pl, 'W-2')[:s_od], 3200.0, 'bal W-2: 3000 + 2 × 100')
Testy.rowne(sciana(pl, 'W-1')[:wience].length, 17, 'W-1: półbal + 16 wieńców')
Testy.rowne(sciana(pl, 'W-1')[:wience][0][:h], 69.5, 'półbal 69,5')
Testy.rowne(sciana(pl, 'W-2')[:wience].length, 17, 'W-2: 17 wieńców (początek szczytu)')
Testy.rowne(Wience.wysokosc(sciana(pl, 'W-1'), pl[:parametry]), 16 * 139 + 69.5, 'wysokość okapowej')
Testy.rowne(Wience.wysokosc(sciana(pl, 'W-2'), pl[:parametry]), 17 * 139.0, 'wysokość szczytowej')
Testy.rowne(pl[:pozycje].length, 4, '4 pozycje (półbal, bal okapowy, bal szczytowy, górny szczytowy)')
Testy.rowne(pl[:pozycje].map { |p| p[:nazwa] }, %w[1-4200 2-4200 3-3200 4-3200], 'nazwy pozycji')
Testy.rowne(pl[:pary_zamkow], 4 * 33, 'pary bali w 4 narożnikach')
bez_kolizji(pl, 'dom 4000 × 3000')

Testy.grupa('Dom 4000 × 3000, maks. bal 4000 – styki jak 900 W-2')
pl = plan(prostokat(0, 0, 4000, 3000), 'max_dlugosc' => 4000)
w1 = sciana(pl, 'W-1')
Testy.rowne(w1[:styki][:regiony].length, 1, 'jedno miejsce łączenia')
Testy.rowne(w1[:styki][:regiony][0][:a] - w1[:s_od], 1900.0, 'styk w osi 1. kontrforu – 1900 od końca bala')
Testy.rowne(w1[:styki][:regiony][0][:b] - w1[:s_od], 2300.0, 'styk w osi 2. kontrforu – 2300 od końca bala')
dl = w1[:bale].map { |b| b[:dl].round }.uniq.sort
Testy.rowne(dl, [1900, 2300], 'bale 1900 i 2300')
Testy.rowne(pl[:sciany].count { |w| w[:rodzaj] == :kontrfor }, 4, '4 nowe kontrfory (po 2 na ścianę)')
Testy.rowne(pl[:sciany].select { |w| w[:rodzaj] == :kontrfor }.map { |w| w[:id] }, %w[W-5 W-6 W-7 W-8], 'kontrfory numerowane po ścianach')
kf = sciana(pl, 'W-5')
Testy.rowne(kf[:bale].length, 16, 'kontrfor: 16 bali (do wysokości ściany)')
Testy.rowne(kf[:bale].map { |b| b[:dl].round }.uniq, [244], 'kontrfor z odcinków 244')
Testy.rowne(pl[:pozycje].count { |p| p[:prefiks] == 'Kf' }, 1, 'jedna pozycja kontrforu')
w1[:bale].group_by { |b| b[:i] }.each do |i, lista|
  st = lista.select { |b| b[:konce][1] == :styk }.map { |b| b[:s1] }
  oczekiwany = i.even? ? w1[:styki][:regiony][0][:a] : w1[:styki][:regiony][0][:b]
  Testy.rowne(st, [oczekiwany], "wieniec #{i + 1}: styk na przemian")
end
bez_kolizji(pl, 'styki w zamkach kontrforów')

Testy.grupa('Wariant jeden kontrfor (styki ± 200)')
pl = plan(prostokat(0, 0, 4000, 3000), 'max_dlugosc' => 4000, 'styk_uklad' => 'jeden_kontrfor')
w1 = sciana(pl, 'W-1')
r = w1[:styki][:regiony][0]
Testy.rowne(r[:b] - r[:a], 400.0, 'odstęp styków 400')
Testy.rowne(pl[:sciany].count { |w| w[:rodzaj] == :kontrfor }, 2, 'po jednym kontrforze na ścianę')
bez_kolizji(pl, 'jeden kontrfor')

Testy.grupa('Mijanka poniżej 300 – poprawiona do 300')
pl = plan(prostokat(0, 0, 4000, 3000), 'max_dlugosc' => 4000, 'mijanka' => 200)
Testy.rowne(pl[:parametry]['mijanka'], 300.0, 'mijanka podniesiona do 300')
Testy.sprawdz(pl[:ostrzezenia].any? { |u| u.include?('Mijanka') }, 'ostrzeżenie o mijance')
r = sciana(pl, 'W-1')[:styki][:regiony][0]
Testy.rowne(r[:b] - r[:a], 300.0, 'odstęp kontrforów 300')
bez_kolizji(pl, 'mijanka 300')

Testy.grupa('Ściana działowa T–T i skrzyżowanie X')
seg = prostokat(0, 0, 6000, 4000) + [[[3000, 0], [3000, 4000]], [[0, 2000], [6000, 2000]]]
pl = plan(seg, 'max_dlugosc' => 7000)
Testy.rowne(pl[:bledy], [], 'brak błędów')
dz = pl[:sciany].select { |w| w[:rodzaj] == :dzialowa }
Testy.rowne(dz.length, 2, 'dwie działowe')
pozioma = dz.find { |w| w[:os] == :x }
Testy.rowne(pozioma[:s_do] - pozioma[:s_od], 6200.0, 'działowa przez ściany zewnętrzne z ostatkami: 6000 + 200')
Testy.rowne(pozioma[:skrzyzowania].map { |k| k[:typ] }, [:t, :x, :t], 'działowa: T, X, T')
Testy.rowne(sciana(pl, 'W-1')[:skrzyzowania].map { |k| k[:typ] }, [:naroznik, :t, :naroznik], 'W-1: narożnik, T, narożnik')
bez_kolizji(pl, 'działowe T i X')

Testy.grupa('Wolny koniec działowej')
seg = prostokat(0, 0, 6000, 4000) + [[[3000, 0], [3000, 2500]]]
pl = plan(seg)
dz = pl[:sciany].find { |w| w[:rodzaj] == :dzialowa }
Testy.rowne(dz[:s_od], -122.0, 'koniec przy ścianie zewnętrznej z ostatkiem')
Testy.rowne(dz[:s_do], dz[:dl_osi], 'wolny koniec bez ostatka')
Testy.rowne(dz[:bale].first[:konce], [:ostatek, :wolny], 'końce bala: ostatek, wolny')
bez_kolizji(pl, 'wolny koniec')

Testy.grupa('Kontrfor narysowany linią')
seg = prostokat(0, 0, 6000, 4000) + [[[2500, -150], [2500, 150]], [[-150, 1800], [150, 1800]]]
pl = plan(seg, 'max_dlugosc' => 7000)
kf = pl[:sciany].select { |w| w[:rodzaj] == :kontrfor }
Testy.rowne(kf.length, 2, 'dwa kontrfory z rysunku')
Testy.rowne(kf.map { |w| w[:gospodarz][:id] }.sort, %w[W-1 W-4], 'gospodarze W-1 i W-4')
Testy.rowne(kf[0][:a][0].round(1), 2500.0, 'kontrfor na W-1 w osi x = 2500')
bez_kolizji(pl, 'kontrfory z rysunku')

Testy.grupa('Linie podzielone jak w SketchUpie i małe szczeliny')
seg = []
prostokat(0, 0, 6000, 4000).each_with_index { |s, i| seg.concat(i.even? ? podziel(s, 0.3, 0.7) : [s]) }
seg[0] = [[3.0, 0.0], seg[0][1]]
seg << [[3000, 2], [3000, 3997]]
pl = plan(seg)
Testy.rowne(pl[:bledy], [], 'obrys rozpoznany mimo podziału i szczeliny 3 mm')
Testy.rowne(pl[:sciany].count { |w| w[:rodzaj] == :zewnetrzna }, 4, '4 ściany zewnętrzne')
Testy.rowne(pl[:sciany].count { |w| w[:rodzaj] == :dzialowa }, 1, 'działowa dociągnięta do obrysu')
Testy.rowne(pl[:sciany].find { |w| w[:rodzaj] == :dzialowa }[:skrzyzowania].map { |k| k[:typ] }, [:t, :t], 'działowa: T na obu końcach')

Testy.grupa('Obrys obrócony o 30°')
pl0 = plan(prostokat(0, 0, 6000, 4000) + [[[3000, 0], [3000, 4000]]])
pl30 = plan(obroc_odcinki(prostokat(0, 0, 6000, 4000) + [[[3000, 0], [3000, 4000]]], 30))
Testy.rowne(pl30[:bledy], [], 'brak błędów')
Testy.rowne(pl30[:kat] * 180 / Math::PI, 30.0, 'kąt układu 30°', 0.001)
Testy.rowne(pl30[:pozycje].map { |p| p[:nazwa] }, pl0[:pozycje].map { |p| p[:nazwa] }, 'te same pozycje co bez obrotu')
Testy.rowne(pl30[:bale].length, pl0[:bale].length, 'ta sama liczba bali')

Testy.grupa('Obrys w kształcie L')
pl = plan(wielokat([[0, 0], [8000, 0], [8000, 4000], [4000, 4000], [4000, 7000], [0, 7000]]))
Testy.rowne(pl[:bledy], [], 'brak błędów')
Testy.rowne(pl[:sciany].count { |w| w[:rodzaj] == :zewnetrzna }, 6, '6 ścian')
Testy.sprawdz(pl[:ostrzezenia].any? { |u| u.include?('wklęsły') }, 'ostrzeżenie o narożniku wklęsłym')
bez_kolizji(pl, 'obrys L')

Testy.grupa('Linia ukośna – błąd')
pl = plan(prostokat(0, 0, 6000, 4000) + [[[1000, 1000], [2000, 1700]]])
Testy.sprawdz(!pl[:bledy].empty? && pl[:bledy][0].include?('kątem prostym'), 'błąd o linii ukośnej')

Testy.grupa('Brak zamkniętego obrysu – błąd')
pl = plan(prostokat(0, 0, 6000, 4000)[0..2])
Testy.sprawdz(!pl[:bledy].empty? && pl[:bledy][0].include?('zamkniętego obrysu'), 'błąd o otwartym obrysie')

Testy.grupa('Długa ściana 12 m, maks. 5000')
pl = plan(prostokat(0, 0, 12_000, 4000))
w1 = sciana(pl, 'W-1')
Testy.rowne(w1[:styki][:regiony].length, 2, 'dwa miejsca łączenia (3 bale)')
Testy.sprawdz(w1[:bale].all? { |b| b[:dl] <= 5000.01 }, 'bale ≤ 5000')
Testy.rowne(pl[:sciany].count { |w| w[:rodzaj] == :kontrfor }, 8, '8 nowych kontrforów (2 ściany × 2 miejsca × 2)')
bez_kolizji(pl, 'ściana 12 m')

Testy.grupa('Długa ściana z działowymi – styki przy działowych')
seg = prostokat(0, 0, 9000, 4000) + [[[4400, 0], [4400, 4000]], [[4800, 0], [4800, 4000]]]
pl = plan(seg)
w1 = sciana(pl, 'W-1')
r = w1[:styki][:regiony][0]
Testy.rowne(r[:nowe], [], 'bez nowych kontrforów – styki w osiach działowych')
Testy.rowne([r[:a].round, r[:b].round], [4378, 4778], 'styki w osiach działowych')
bez_kolizji(pl, 'styki przy działowych')

Testy.grupa('Otwory')
otw = [{ 'sciana' => 'W-1', 'od' => 1500, 'szerokosc' => 1020, 'wysokosc' => 1010, 'parapet' => 900 },
       { 'sciana' => 'W-2', 'od' => 1200, 'szerokosc' => 930, 'wysokosc' => 2100, 'parapet' => 0, 'nazwa' => 'D1' }]
pl = plan(prostokat(0, 0, 6000, 4000), {}, otw)
Testy.rowne(pl[:bledy], [], 'brak błędów')
w1 = sciana(pl, 'W-1')
Testy.rowne(w1[:otwory].length, 1, 'okno przypisane do W-1')
Testy.rowne(w1[:otwory][0][:s0], 1500.0 - 22.0, 'okno od narożnika lica: s0 = od − t/2')
przeciete = w1[:bale].select { |b| b[:konce].include?(:otwor) }
Testy.sprawdz(!przeciete.empty?, 'bale przecięte przy oknie')
wyc = w1[:bale].select { |b| b[:cechy].any? { |c| c[:typ].start_with?('wyciecie') } }
Testy.sprawdz(!wyc.empty?, 'bale z wycięciem przy parapecie / nadprożu')
dolne = w1[:bale].select { |b| b[:cechy].any? { |c| c[:typ] == 'wyciecie_gora' } }
Testy.sprawdz(dolne.all? { |b| b[:z0] < 900 && b[:z0] + b[:h] > 900 }, 'wycięcie od góry w balu pod parapetem')
w2 = sciana(pl, 'W-2')
Testy.sprawdz(w2[:bale].select { |b| b[:i] == 0 }.length == 2, 'drzwi przecinają najniższy wieniec W-2')
bez_kolizji(pl, 'otwory')

Testy.grupa('Kontrfor przy otworze – przerwany')
seg = prostokat(0, 0, 6000, 4000) + [[[3000, -150], [3000, 150]]]
otw = [{ 'sciana' => 'W-1', 'od' => 2500, 'szerokosc' => 1000, 'wysokosc' => 1000, 'parapet' => 1000 }]
pl = plan(seg, { 'max_dlugosc' => 7000 }, otw)
kf = pl[:sciany].find { |w| w[:rodzaj] == :kontrfor && w[:zrodlo] == :rysunek }
Testy.sprawdz(kf[:bale].length < kf[:wience].length, 'kontrfor bez bali na wysokości okna')
Testy.sprawdz(kf[:bale].none? { |b| b[:z0] < 2000 && b[:z0] + b[:h] > 1000 }, 'żaden bal kontrforu nie wchodzi w okno')

Testy.grupa('Dom 6000 × 4000, maks. 5000 – styk przy działowej + nowy kontrfor')
seg = prostokat(0, 0, 6000, 4000) + [[[3000, 0], [3000, 4000]]]
pl = plan(seg)
r = sciana(pl, 'W-1')[:styki][:regiony][0]
Testy.rowne(r[:nowe].length, 1, 'jeden nowy kontrfor do pary z działową')
Testy.sprawdz([r[:a], r[:b]].any? { |x| (x - 2978.0).abs < 0.01 }, 'jedna kotwica w osi działowej')
bez_kolizji(pl, 'działowa + kontrfor')
bez_kolizji(pl, 'kontrfor przerwany')

Testy.grupa('Otwór za blisko skrzyżowania – ostrzeżenie')
otw = [{ 'sciana' => 'W-1', 'od' => 60, 'szerokosc' => 800, 'wysokosc' => 1000, 'parapet' => 900 }]
pl = plan(prostokat(0, 0, 6000, 4000), {}, otw)
Testy.sprawdz(pl[:ostrzezenia].any? { |u| u.include?('bliżej niż') }, 'ostrzeżenie o otworze przy narożniku')

Testy.grupa('Otwór na nieistniejącej ścianie')
pl = plan(prostokat(0, 0, 6000, 4000), {}, [{ 'sciana' => 'W-9', 'od' => 100, 'szerokosc' => 800, 'wysokosc' => 800 }])
Testy.sprawdz(pl[:ostrzezenia].any? { |u| u.include?('nie ma ściany') }, 'ostrzeżenie o braku ściany')

Testy.grupa('Kalenica wzdłuż krótszego boku')
pl = plan(prostokat(0, 0, 4000, 3000), 'kalenica' => 'krotszy')
Testy.rowne(sciana(pl, 'W-1')[:kierunek], :B, 'W-1 szczytowa')
Testy.rowne(sciana(pl, 'W-2')[:wience][0][:polbal], true, 'półbal na W-2')
bez_kolizji(pl, 'kalenica krótszy bok')

Testy.grupa('Inny ostatek i szczelina styku')
pl = plan(prostokat(0, 0, 4000, 3000), 'ostatek' => 200, 'max_dlugosc' => 4200, 'szczelina_styku' => 2)
Testy.rowne(sciana(pl, 'W-1')[:s_do] - sciana(pl, 'W-1')[:s_od], 4400.0, 'ostatek 200: 4000 + 400')
st = sciana(pl, 'W-1')[:bale].select { |b| b[:i] == 1 }
Testy.rowne(st.length, 2, 'dwa bale w wieńcu')
Testy.rowne((st[1][:s0] - st[0][:s1]).round(3), 2.0, 'szczelina 2 mm')
bez_kolizji(pl, 'ostatek 200')

Testy.koniec
