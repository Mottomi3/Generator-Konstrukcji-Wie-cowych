# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_zamek.rb
# Zadanie: zamek 44 × 146 zgodny z rysunkiem IMG-20250930-WA0005 – wymiary obróbek, luzy, labirynt (tylko poprawne ułożenie bez kolizji).
# Tematy: testy zamka, odcinek 244, gniazdo 40 × 36, podcięcie 2,5 × 42, luz pionowy 2,5, luz 0,5, orientacja lic
# Zależy od: testy/pomoc.rb
# Używają: testy/uruchom.sh

require File.expand_path('pomoc', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

Testy.grupa('Odcinek 244 kontrforu = rysunek warsztatowy')
pl = plan(prostokat(0, 0, 6000, 4000) + [[[3000, -150], [3000, 150]]], 'max_dlugosc' => 7000)
kf = pl[:sciany].find { |w| w[:rodzaj] == :kontrfor }
poz = kf[:bale][3][:pozycja]
Testy.rowne(poz[:dl], 244.0, 'długość 244 = 100 + 44 + 100')
gg = poz[:cechy].select { |c| c[:typ] == 'gniazdo_gora' }
gd = poz[:cechy].select { |c| c[:typ] == 'gniazdo_dol' }
pc = poz[:cechy].select { |c| c[:typ] == 'podciecie' }.sort_by { |c| c[:strona] }
Testy.rowne(gg.map { |c| [c[:x0], c[:x1], c[:gleb]] }, [[102.0, 142.0, 36.0]], 'gniazdo górne 102…142, głęb. 36')
Testy.rowne(gd.map { |c| [c[:x0], c[:x1], c[:gleb]] }, [[102.0, 142.0, 36.0]], 'gniazdo dolne 102…142, głęb. 36')
Testy.rowne(pc.map { |c| [c[:x1] - c[:x0], c[:gleb]] }, [[42.0, 2.5], [42.0, 2.5]], 'podcięcia 42 × 2,5 na obu licach')
Testy.rowne(pc.map { |c| c[:x0] }.sort, [100.0, 102.0], 'podcięcia przesunięte o 2 mm (100…142 i 102…144)')
prof = Bryla.profil(poz[:dl], poz[:t], poz[:h], poz[:cechy])
Testy.sprawdz(Bryla.zawiera?(prof, 122.0, 22.0, 69.5), 'środek zamka (67) jest')
Testy.sprawdz(!Bryla.zawiera?(prof, 122.0, 22.0, 120.0), 'gniazdo górne puste')
Testy.sprawdz(!Bryla.zawiera?(prof, 122.0, 22.0, 20.0), 'gniazdo dolne puste')
Testy.sprawdz(!Bryla.zawiera?(prof, 122.0, 1.0, 69.5) && !Bryla.zawiera?(prof, 122.0, 43.0, 69.5), 'w zamku grubość 39')
Testy.sprawdz(Bryla.zawiera?(prof, 122.0, 3.0, 69.5) && Bryla.zawiera?(prof, 122.0, 41.0, 69.5), 'grubość 39 w środku')

Testy.grupa('Luzy w narożniku (słup zamka W-1 / W-2)')
pl = plan(prostokat(0, 0, 4000, 3000), 'liczba_wiencow' => 6)
p = pl[:parametry]
w1 = sciana(pl, 'W-1')
w2 = sciana(pl, 'W-2')
k = w1[:skrzyzowania].find { |x| x[:inna].equal?(w2) }
c = k[:punkt]
bale = Zamek.bale_w_zamku(w1, k[:s], 46.0) + Zamek.bale_w_zamku(w2, w2[:skrzyzowania].find { |x| x[:inna].equal?(w1) }[:s], 46.0)
uk = bale.map { |b| [b, Bale.polozenie(b, p), Bryla.profil(b[:dl], 44.0, b[:h], b[:cechy])] }
zajety = lambda do |x, y, z|
  uk.count { |_b, pol, prof| Kontrola.zawiera_globalnie?(pol, prof, [x, y, z]) }
end
# Pionowo w osi słupa: środki bali na przemian, przerwy 2,5 mm.
przerwy = []
z = 0.125
poprzedni = nil
start = nil
gora = Wience.wysokosc(w1, p) - 1.0
while z < gora
  stan = zajety.call(c[0], c[1], z) > 0
  if poprzedni == true && !stan
    start = z
  elsif poprzedni == false && stan && start
    przerwy << (z - start).round(2)
  end
  poprzedni = stan
  z += 0.25
end
Testy.sprawdz(!przerwy.empty?, 'są przerwy pionowe w osi zamka')
Testy.sprawdz(przerwy.all? { |g| (g - 2.5).abs <= 0.26 }, "przerwy pionowe 2,5 mm (#{przerwy.uniq.inspect})")
# W poziomie: luz 0,5 między środkiem bala a ścianką gniazda.
b_a = uk.find { |b, _p, _q| b[:sciana].equal?(w1) && b[:i] == 2 }
zm = b_a[0][:z0] + 79.5
Testy.rowne(zajety.call(c[0], c[1] + 19.25, zm), 1, 'środek bala W-1 sięga 19,5 od osi')
Testy.rowne(zajety.call(c[0], c[1] + 19.75, zm), 0, 'luz 0,5 przy ściance gniazda')
Testy.rowne(zajety.call(c[0], c[1] + 20.25, zm), 1, 'ścianka gniazda bala W-2')

Testy.grupa('Labirynt: tylko bal poprzeczny odwrócony licem składa się bez kolizji')
pl = plan(prostokat(0, 0, 4000, 3000) + [[[2000, -150], [2000, 150]]], 'liczba_wiencow' => 4)
wyniki = {}
[[-1, 1], [1, -1], [-1, -1], [1, 1]].each do |ox, oy|
  pl[:bale].each { |b| b[:cechy] = b[:cechy].reject { |c2| %w[gniazdo_gora gniazdo_dol podciecie].include?(c2[:typ]) } }
  Zamek.nanies(pl[:sciany], pl[:parametry], { x: ox, y: oy })
  wyniki[[ox, oy]] = Kontrola.kolizje(pl).length
end
Testy.rowne(wyniki[[-1, 1]], 0, 'ułożenie przyjęte (x −1, y +1) bez kolizji')
Testy.rowne(wyniki[[1, -1]], 0, 'ułożenie lustrzane bez kolizji')
Testy.sprawdz(wyniki[[-1, -1]] > 0 && wyniki[[1, 1]] > 0, 'oba lica w tę samą stronę – kolizje (kontrola działa)')

Testy.grupa('Półbal: tylko gniazdo górne')
pl = plan(prostokat(0, 0, 4000, 3000))
pb = sciana(pl, 'W-1')[:bale].find { |b| b[:polbal] }
Testy.rowne(pb[:h], 69.5, 'wysokość bryły półbala')
Testy.rowne(pb[:cechy].map { |c2| c2[:typ] }.uniq.sort, %w[gniazdo_gora podciecie], 'półbal: gniazda górne i podcięcia')
gorny = sciana(pl, 'W-2')[:bale].max_by { |b| b[:z0] }
Testy.rowne(gorny[:cechy].map { |c2| c2[:typ] }.uniq.sort, %w[gniazdo_dol podciecie], 'górny bal szczytowej: tylko gniazda dolne')

Testy.grupa('Styk w zamku: pół gniazda na końcu bala')
pl = plan(prostokat(0, 0, 4000, 3000), 'max_dlugosc' => 4000, 'liczba_wiencow' => 4)
b = sciana(pl, 'W-1')[:bale].find { |x| x[:i] == 1 && x[:konce][1] == :styk }
g = b[:cechy].select { |c2| c2[:typ].start_with?('gniazdo') && (c2[:x1] - b[:dl]).abs < 0.01 }
Testy.rowne(g.map { |c2| (c2[:x1] - c2[:x0]).round(3) }.uniq, [20.0], 'pół gniazda (20 mm) na końcu przy styku')

Testy.koniec
