# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_wegly.rb
# Zadanie: testy węgłów usztywniających i łączenia na przemian – limity światła, rozmieszczenie, ściany wysokie, otwory.
# Tematy: testy węgłów, światło ściany, ściana wysoka, węgieł od narożnika, tylko narysowane, łączenie na przemian, styk przy otworze, dom 4 × 4
# Zależy od: testy/pomoc.rb
# Używają: testy/uruchom.sh

require File.expand_path('pomoc', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

# Węgły ściany według źródła: osie s (zaokrąglone) węgłów danego źródła na ścianie id.
def wegly(pl, id, zrodlo)
  sciana(pl, id)[:skrzyzowania].select { |k| k[:typ] == :kontrfor && k[:inna][:zrodlo] == zrodlo }.map { |k| k[:s].round }
end

# Kontrola bez kolizji, bez naruszeń mijanki i bez za długich bali.
def czysto(pl, opis)
  k = Kontrola.wszystko(pl)
  Testy.rowne([k[:kolizje].length, k[:mijanka].length, k[:za_dlugie].length], [0, 0, 0], "#{opis}: kolizje, mijanka, za długie")
end

# Największe światło ściany (między licami podparć) [mm].
def max_swiatlo(pl, id)
  t = Parametry.grubosc(pl[:parametry])
  Usztywnienie.przeslony(sciana(pl, id)).map { |a, b, _na, _nb| b - a - t }.max
end

Testy.grupa('Dom 4 × 4 (lico) – bez łączenia i bez węgłów')
pl = plan(prostokat(0, 0, 4000, 4000))
Testy.rowne(pl[:sciany].count { |w| w[:rodzaj] == :kontrfor }, 0, 'brak węgłów')
Testy.sprawdz(pl[:sciany].all? { |w| w[:styki][:kotwy].empty? }, 'brak styków')
Testy.rowne(pl[:pozycje].map { |p| p[:nazwa] }, %w[1-4200 2-4200 3-4200], 'trzy pozycje 4200')
Testy.rowne(pl[:podsumowanie][:limit_swiatla], 4800, 'limit światła 4800 w podsumowaniu')

Testy.grupa('Ściana 6 m bez łączenia (maks. 7000) – jeden węgieł w środku')
pl = plan(prostokat(0, 0, 6000, 4000), 'max_dlugosc' => 7000)
Testy.rowne(wegly(pl, 'W-1', :usztywnienie), [2978], 'W-1: węgieł w środku światła')
Testy.rowne(wegly(pl, 'W-3', :usztywnienie), [2978], 'W-3: węgieł w środku')
Testy.rowne(wegly(pl, 'W-2', :usztywnienie), [], 'W-2 (4 m): bez węgła')
Testy.sprawdz(max_swiatlo(pl, 'W-1') <= 4800.0, 'światło po dodaniu ≤ 4800')
Testy.rowne(pl[:podsumowanie][:wegly_usztywniajace], 2, 'podsumowanie: 2 węgły usztywniające')
czysto(pl, 'węgieł w środku')

Testy.grupa('Rozmieszczenie od narożników (800)')
pl = plan(prostokat(0, 0, 6000, 4000), 'max_dlugosc' => 7000, 'wegly_rozmieszczenie' => 'od_naroznikow')
Testy.rowne(wegly(pl, 'W-1', :usztywnienie), [800, 5156], 'węgły 800 od osi narożników')
pl = plan(prostokat(0, 0, 6000, 4000), 'max_dlugosc' => 7000, 'wegly_rozmieszczenie' => 'od_naroznikow',
          'wegly_odstep_od_naroznika' => 1200)
Testy.rowne(wegly(pl, 'W-1', :usztywnienie), [1200, 4756], 'odstęp 1200')
czysto(pl, 'od narożników')

Testy.grupa('Tylko narysowane – ostrzeżenie zamiast węgła')
pl = plan(prostokat(0, 0, 6000, 4000), 'max_dlugosc' => 7000, 'wegly_rozmieszczenie' => 'tylko_narysowane')
Testy.rowne(pl[:sciany].count { |w| w[:rodzaj] == :kontrfor }, 0, 'bez nowych węgłów')
Testy.rowne(pl[:ostrzezenia].count { |u| u.include?('narysuj węgieł') }, 2, 'dwa ostrzeżenia (W-1, W-3)')

Testy.grupa('Limit światła z parametru')
pl = plan(prostokat(0, 0, 6000, 4000), 'max_dlugosc' => 7000, 'wegly_max_swiatlo' => 6000)
Testy.rowne(pl[:sciany].count { |w| w[:rodzaj] == :kontrfor }, 0, 'limit 6000 – ściana 6 m bez węgła')
pl = plan(prostokat(0, 0, 6000, 4000), 'max_dlugosc' => 7000, 'wegly_max_swiatlo' => 2500)
Testy.rowne(wegly(pl, 'W-1', :usztywnienie).length, 2, 'limit 2500 – dwa węgły na 6 m')
Testy.rowne(wegly(pl, 'W-2', :usztywnienie).length, 1, 'limit 2500 – jeden węgieł na 4 m')
Testy.sprawdz(max_swiatlo(pl, 'W-1') <= 2500.0 && max_swiatlo(pl, 'W-2') <= 2500.0, 'światła ≤ 2500')
czysto(pl, 'limit 2500')

Testy.grupa('Ściana wysoka (22 wieńce) – mniejszy limit')
pl = plan(prostokat(0, 0, 4500, 4000), 'liczba_wiencow' => 22)
Testy.rowne(Usztywnienie.limit_swiatla(pl[:parametry]), 3700.0, 'limit dla ścian wysokich')
Testy.rowne(wegly(pl, 'W-1', :usztywnienie), [2228], 'W-1 (4,5 m): węgieł')
Testy.rowne(wegly(pl, 'W-2', :usztywnienie), [1978], 'W-2 (4 m): węgieł')
pl = plan(prostokat(0, 0, 4500, 4000))
Testy.rowne(pl[:sciany].count { |w| w[:rodzaj] == :kontrfor }, 0, '16 wieńców – bez węgłów')
pl = plan(prostokat(0, 0, 4500, 4000), 'liczba_wiencow' => 22, 'wegly_prog_wysokosci' => 3200)
Testy.rowne(pl[:sciany].count { |w| w[:rodzaj] == :kontrfor }, 0, 'próg 3200 – ściana 3127 nie jest wysoka')

Testy.grupa('Węgieł omija otwór')
otw = [{ 'sciana' => 'W-1', 'od' => 2500, 'szerokosc' => 1000, 'wysokosc' => 1000, 'parapet' => 900 }]
pl = plan(prostokat(0, 0, 6000, 4000), { 'max_dlugosc' => 7000 }, otw)
s = wegly(pl, 'W-1', :usztywnienie)
Testy.rowne(s.length, 1, 'jeden węgieł')
o = sciana(pl, 'W-1')[:otwory][0]
Testy.sprawdz(s[0] + 22 + 150 <= o[:s0] + 0.5 || s[0] - 22 - 150 >= o[:s1] - 0.5, 'węgieł ≥ 150 od krawędzi okna')
Testy.sprawdz(max_swiatlo(pl, 'W-1') <= 4800.0, 'światło ≤ 4800')
czysto(pl, 'węgieł przy oknie')

Testy.grupa('Węgły na działowych – przełącznik')
seg = prostokat(0, 0, 6000, 8000) + [[[0, 4000], [6000, 4000]]]
pl = plan(seg, 'max_dlugosc' => 7000)
dz = pl[:sciany].find { |w| w[:rodzaj] == :dzialowa }
Testy.rowne(wegly(pl, dz[:id], :usztywnienie).length, 1, 'działowa 6 m: węgieł')
pl = plan(seg, 'max_dlugosc' => 7000, 'wegly_na_dzialowych' => 'nie')
dz = pl[:sciany].find { |w| w[:rodzaj] == :dzialowa }
Testy.rowne(wegly(pl, dz[:id], :usztywnienie).length, 0, 'wyłączone – działowa bez węgła')
Testy.rowne(wegly(pl, 'W-1', :usztywnienie).length, 1, 'zewnętrzna 6 m nadal z węgłem')

Testy.grupa('Łączenie na przemian – działowe jako kotwice')
seg = prostokat(0, 0, 9000, 6000) + [[[0, 3000], [9000, 3000]]]
pl = plan(seg)
w2 = sciana(pl, 'W-2')
Testy.rowne(w2[:styki][:parzyste].map { |x| x.round }, [2978], 'W-2: styk wieńców parzystych w osi działowej')
Testy.rowne(w2[:styki][:nowe].length, 1, 'W-2: jeden nowy węgieł')
Testy.sprawdz((w2[:styki][:nieparzyste][0] - w2[:styki][:parzyste][0]).abs >= 400.0 - 0.01, 'mijanka ≥ 400')
w1 = sciana(pl, 'W-1')
Testy.sprawdz(w1[:bale].all? { |b| b[:dl] <= 5100.01 }, 'W-1: bale ≤ 5100')
czysto(pl, 'na przemian z działową')

Testy.grupa('Łączenie na przemian – ściana 20 m')
pl = plan(prostokat(0, 0, 20_000, 5000))
w1 = sciana(pl, 'W-1')
k = w1[:styki][:kotwy]
kmin = 2 * ((w1[:s_do] - w1[:s_od]) / 5100.0).ceil - 2
Testy.sprawdz(k.length >= kmin && k.length <= kmin + 2, "kotwice: #{k.length} (najmniej 2 × (bale w wieńcu − 1) = #{kmin})")
Testy.sprawdz(k.each_cons(2).all? { |a, b| b - a >= 400.0 - 0.01 }, 'kolejne kotwice co ≥ mijanka')
Testy.sprawdz(w1[:bale].all? { |b| b[:dl] <= 5100.01 }, 'bale ≤ 5100')
Testy.rowne(pl[:podsumowanie][:wegly_usztywniajace], 0, 'węgły styków usztywniają ścianę')
czysto(pl, 'ściana 20 m')

Testy.grupa('Styk z dala od otworów')
otw = [{ 'sciana' => 'W-1', 'od' => 1000, 'szerokosc' => 1500, 'wysokosc' => 1200, 'parapet' => 900 },
       { 'sciana' => 'W-1', 'od' => 5000, 'szerokosc' => 2000, 'wysokosc' => 2100, 'parapet' => 0 },
       { 'sciana' => 'W-1', 'od' => 8500, 'szerokosc' => 1500, 'wysokosc' => 1200, 'parapet' => 900 }]
pl = plan(prostokat(0, 0, 12_000, 4000), {}, otw)
w1 = sciana(pl, 'W-1')
odl = w1[:styki][:kotwy].map { |s| w1[:otwory].map { |o| [o[:s0] - s, s - o[:s1]].max }.min }
Testy.sprawdz(odl.all? { |x| x >= 400.0 - 0.01 }, "styki ≥ 400 od otworów (#{odl.map { |x| x.round }.inspect})")
Testy.sprawdz(pl[:ostrzezenia].none? { |u| u.include?('krótsze niż') }, 'bez za krótkich kawałków')
czysto(pl, 'styki przy otworach')

Testy.grupa('Układy para i jeden węgieł nadal dostępne')
%w[para jeden_wegiel].each do |uklad|
  pl = plan(prostokat(0, 0, 12_000, 4000), 'styk_uklad' => uklad)
  w1 = sciana(pl, 'W-1')
  Testy.rowne(w1[:styki][:uklad], uklad, "#{uklad}: zapisany układ")
  Testy.sprawdz(w1[:bale].all? { |b| b[:dl] <= 5100.01 }, "#{uklad}: bale ≤ 5100")
  czysto(pl, uklad)
end

Testy.koniec
