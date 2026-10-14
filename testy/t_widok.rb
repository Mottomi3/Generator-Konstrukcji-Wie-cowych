# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_widok.rb
# Zadanie: widok ściany do okna – obrysy bali zgodne z profilem, gniazda zamków na skrzyżowaniach, styki, linia dachu, lista ścian.
# Tematy: testy widoku ściany, obrys bala w widoku, pole obrysu, gniazdo zamka w widoku, linia dachu w widoku, styki w widoku
# Zależy od: testy/pomoc.rb, Plugins/.../rdzen/widok.rb
# Używają: testy/uruchom.sh

require File.expand_path('pomoc', File.dirname(__FILE__))
require File.join(KATALOG_WTYCZKI, 'rdzen', 'widok')
include ArteMadera::GeneratorWiencowy

# Pole wielokąta [[s, z]] (wzór Gaussa).
def pole(pts)
  s = 0.0
  pts.each_with_index { |a, i| b = pts[(i + 1) % pts.length]; s += a[0] * b[1] - b[0] * a[1] }
  (s / 2.0).abs
end

# Pole boku bala z profilu (rzut na płaszczyznę ściany).
def pole_profilu(b, t)
  Bryla.profil(b[:dl], t, b[:h], b[:cechy]).inject(0.0) do |s, q|
    s + (q[:xb] - q[:xa]) * ((q[:zt_a] - q[:zb_a]) + (q[:zt_b] - q[:zb_b])) / 2.0
  end
end

Testy.grupa('Dom 7000 × 4500 z działową i węgłem, bale do 5000 – widok W-1')
seg = prostokat(0, 0, 7000, 4500) + [[[3500, 0], [3500, 4500]], [[1500, -150], [1500, 150]]]
pl = plan(seg, { 'max_dlugosc' => 5000 }, [{ 'sciana' => 'W-1', 'od' => 4300, 'szerokosc' => 1020, 'wysokosc' => 1010, 'parapet' => 900, 'nazwa' => 'O1' }])
Testy.rowne(pl[:bledy], [], 'bez błędów')
w1 = pl[:sciany].find { |w| w[:id] == 'W-1' }
v = Widok.sciana(pl, 'W-1')
Testy.rowne(v['bale'].length, w1[:bale].length, 'obrys na każdy bal ściany')
t = Parametry.grubosc(pl[:parametry])
zle_pole = w1[:bale].each_with_index.reject { |b, i| (pole(v['bale'][i]['obrys']) - pole_profilu(b, t)).abs <= pole_profilu(b, t) * 0.002 + 1.0 }
Testy.rowne(zle_pole.length, 0, 'pole obrysu = pole boku bala z profilu')
poza = v['bale'].reject { |b| b['obrys'].all? { |s, z| s >= b['s0'] - 0.05 && s <= b['s1'] + 0.05 && z >= b['z0'] - 0.05 && z <= b['z0'] + b['h'] + 0.05 } }
Testy.rowne(poza.length, 0, 'obrys w prostokącie bala')
Testy.sprawdz(v['styki'] > 0 && v['bale'].any? { |b| b['konce'].include?('styk') }, "styki w widoku (#{v['styki']})")
Testy.rowne(v['otwory'].map { |o| o[4] }, ['O1'], 'okno w widoku')
Testy.sprawdz(v['skrzyzowania'].map { |k| k[1] }.include?('W-5'), 'skrzyżowanie z działową W-5')
s5 = v['skrzyzowania'].find { |k| k[1] == 'W-5' }[0]
# Bal, który przechodzi przez skrzyżowanie z W-5: w obrysie wierzch obniżony (gniazdo zamka) w pobliżu osi W-5.
przez = v['bale'].select { |b| b['s0'] < s5 - 100 && b['s1'] > s5 + 100 && b['h'] > 100 }
z_gniazda = przez.map { |b| b['obrys'].select { |s, _z| (s - s5).abs <= 25 }.map { |_s, z| z }.min - b['z0'] }
Testy.sprawdz(!przez.empty? && z_gniazda.all? { |z| z < 139.0 - 30 }, "gniazda zamka na skrzyżowaniu z W-5 (#{z_gniazda.first(3).inspect})")
Testy.rowne(v['linia_dachu'], [], 'ściana okapowa bez szczytu – bez linii dachu')

Testy.grupa('Ściana szczytowa (dom 4000 × 3000 z dachem) – linia dachu nad balami')
pl = plan_pelny(prostokat(0, 0, 4000, 3000))
sz = pl[:sciany].find { |w| w[:szczyt] }
v = Widok.sciana(pl, sz[:id])
Testy.sprawdz(v['szczyt'], 'widok ściany ze szczytem')
Testy.rowne(v['linia_dachu'].length, 3, 'linia dachu: początek, kalenica, koniec')
Testy.sprawdz(v['linia_dachu'][1][1] > v['linia_dachu'][0][1] && v['linia_dachu'][1][1] > v['linia_dachu'][2][1], 'kalenica najwyżej')
linia = lambda do |s|
  a, b = v['linia_dachu'][1][0] >= s ? [v['linia_dachu'][0], v['linia_dachu'][1]] : [v['linia_dachu'][1], v['linia_dachu'][2]]
  a[1] + (b[1] - a[1]) * (s - a[0]) / (b[0] - a[0])
end
nad = v['bale'].map { |b| b['obrys'].map { |s, z| z - linia.call(s) }.max }.max
Testy.sprawdz(nad <= 0.2, format('bale szczytu pod linią dachu (najwyżej %.2f mm)', nad))
Testy.sprawdz(v['bale'].any? { |b| b['prefiks'] == 'Sz' }, 'bale szczytu (Sz) w widoku')

Testy.grupa('Lista ścian do widoku i ściana nieznana')
ids = Widok.lista(pl).map { |x| x[0] }
Testy.sprawdz(!ids.empty? && pl[:sciany].select { |w| w[:rodzaj] == :kontrfor }.none? { |w| ids.include?(w[:id]) }, "lista bez węgłów (#{ids.join(', ')})")
Testy.rowne(Widok.sciana(pl, 'W-99'), nil, 'nieznana ściana – nil')
Testy.rowne(Widok.sciana(nil, 'W-1'), nil, 'brak planu – nil')

Testy.koniec
