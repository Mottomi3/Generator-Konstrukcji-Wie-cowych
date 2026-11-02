# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_wegly.rb
# Zadanie: testy węgłów usztywniających i łączenia na przemian – limity światła, rozmieszczenie, ściany wysokie, otwory.
# Tematy: testy węgłów, węgieł pod płatwią w testach, wolny koniec w testach, światło ściany, ściana wysoka, węgieł od narożnika, tylko narysowane, łączenie na przemian, styk przy otworze, dom 4 × 4
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
pl = plan(seg, 'styk_na_dzialowej' => 'mijanka')
w2 = sciana(pl, 'W-2')
Testy.sprawdz(w2[:styki][:kotwy].map { |x| x.round }.include?(2978), 'W-2: styk jednej parzystości w osi działowej')
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

Testy.grupa('Węgły z tabeli jak okna i węgieł na środku ściany (runda 7)')
seg = prostokat(0, 0, 7000, 5000)
pl = ArteMadera::GeneratorWiencowy::Projekt.oblicz('segmenty' => seg, 'parametry' => { 'szczyty' => 'nie', 'podloga' => 'nie', 'max_dlugosc' => 7500 },
                                                 'otwory' => [], 'wegly' => [{ 'sciana' => 'W-1', 'polozenie' => 'od', 'od' => '2000' },
                                                                             { 'sciana' => 'W-3', 'polozenie' => 'srodek', 'od' => '' }])
kf = pl[:sciany].select { |w| w[:rodzaj] == :kontrfor && w[:zrodlo] == :rysunek }
Testy.rowne(kf.length, 2, 'dwa węgły z tabeli')
w1 = sciana(pl, 'W-1')
Testy.sprawdz(w1[:skrzyzowania].any? { |k| k[:inna][:rodzaj] == :kontrfor && (k[:s] - 1978.0).abs < 0.01 }, 'W-1: węgieł 2000 od narożnika lica (oś s = 1978)')
w3 = sciana(pl, 'W-3')
Testy.sprawdz(w3[:skrzyzowania].any? { |k| k[:inna][:rodzaj] == :kontrfor && (k[:s] - w3[:dl_osi] / 2.0).abs < 0.01 }, 'W-3: węgieł na środku osi')
czysto(pl, 'węgły z tabeli')
pl = plan(seg, 'wegly_srodek' => 'zewnetrzne', 'wegly_srodek_min' => 4500, 'max_dlugosc' => 7500)
srodkowe = pl[:sciany].select { |w| w[:rodzaj] == :kontrfor && w[:zrodlo] == :rysunek }
Testy.rowne(srodkowe.map { |w| w[:gospodarz][:id] }.sort, %w[W-1 W-2 W-3 W-4], 'węgieł na środku każdej ściany ≥ 4500')
pl = plan(seg, 'wegly_srodek' => 'zewnetrzne', 'wegly_srodek_min' => 6000, 'max_dlugosc' => 7500)
Testy.rowne(pl[:sciany].select { |w| w[:rodzaj] == :kontrfor && w[:zrodlo] == :rysunek }.map { |w| w[:gospodarz][:id] }.sort, %w[W-1 W-3],
            'tylko dłuższe ściany (7 m)')
otw = [{ 'sciana' => 'W-1', 'od' => 3000, 'szerokosc' => 1000, 'wysokosc' => 1000, 'parapet' => 900 }]
pl = ArteMadera::GeneratorWiencowy::Projekt.oblicz('segmenty' => seg, 'parametry' => { 'szczyty' => 'nie', 'podloga' => 'nie', 'max_dlugosc' => 7500 },
                                                 'otwory' => otw, 'wegly' => [{ 'sciana' => 'W-1', 'polozenie' => 'srodek' }])
Testy.sprawdz(pl[:ostrzezenia].any? { |u| u.include?('przesunięty') || u.include?('brak miejsca') }, 'okno na środku – węgieł przesunięty albo pominięty z ostrzeżeniem')
czysto(pl, 'węgieł przy oknie')

Testy.grupa('Węgły symetrycznie na ścianach równoległych, równy podział (runda 8)')
# Współrzędne węgłów w świecie wzdłuż osi gospodarza, ściana → posortowana lista.
x_wegli = lambda do |pl, id|
  pl[:sciany].select { |w| w[:rodzaj] == :kontrfor && w[:gospodarz][:id] == id }.map { |w| w[:a][0].round }.sort
end
pl = plan(prostokat(0, 0, 12_000, 6000))
Testy.rowne(x_wegli.call(pl, 'W-1'), x_wegli.call(pl, 'W-3'), 'W-1 i W-3 – węgły w tych samych miejscach')
Testy.rowne(x_wegli.call(pl, 'W-1'), [2413, 4804, 7196, 9587], '12 m – odcinek między narożnikami dzielony równo na 5')
pl = plan(prostokat(0, 0, 12_000, 6000), 'max_dlugosc' => 7000)
Testy.rowne(x_wegli.call(pl, 'W-1'), [3011, 6000, 8989], 'bal 7 m – 3 węgły równo zamiast 2 pod styki + 2 usztywniające')
Testy.rowne(x_wegli.call(pl, 'W-1'), x_wegli.call(pl, 'W-3'), 'bal 7 m – symetrycznie')
pl = plan(prostokat(0, 0, 10_000, 8000) + [[[0, 4000], [10_000, 4000]]], 'liczba_wiencow' => 20)
Testy.rowne([x_wegli.call(pl, 'W-3'), x_wegli.call(pl, 'W-5')], [x_wegli.call(pl, 'W-1')] * 2, 'działowa równoległa – te same miejsca')
czysto(pl, 'symetria z działową')

Testy.grupa('Węgieł niesymetryczny – wypust wewnątrz i na zewnątrz (runda 8)')
pl = Projekt.oblicz('segmenty' => prostokat(0, 0, 8000, 6400), 'parametry' => { 'wegiel_wypust_zewn' => 200, 'szczyty' => 'nie', 'podloga' => 'nie' },
                    'otwory' => [], 'wegly' => [{ 'sciana' => 'W-1', 'polozenie' => 'od', 'od' => '2000', 'wewn' => '300', 'zewn' => '' }])
kf = pl[:sciany].find { |w| w[:rodzaj] == :kontrfor && (w[:a][0] - 2000.0).abs < 1 }
Testy.rowne([kf[:s_od], kf[:s_do]], [-222.0, 322.0], 'z tabeli: na zewnątrz 200 (parametr), wewnątrz 300 (wiersz)')
w3 = pl[:sciany].find { |w| w[:rodzaj] == :kontrfor && w[:gospodarz][:id] == 'W-3' }
Testy.rowne([w3[:s_od], w3[:s_do]], [-122.0, 222.0], 'ściana naprzeciwko: na zewnątrz (+y) 200, wewnątrz 100')
czysto(pl, 'węgły niesymetryczne')

Testy.grupa('Węgły pod płatwiami, wypust końców działowych, wolny koniec ściany (runda 9)')
require File.expand_path('kolizje_belek', File.dirname(__FILE__))
pl = plan_pelny(prostokat(0, 0, 6000, 8000) + [[[3000, 0], [3000, 8000]]], 'wegiel_wypust_zewn' => 200, 'platwie_rozstaw_max' => 900)
p = pl[:parametry]
w6 = pl[:sciany].find { |w| w[:rodzaj] == :dzialowa }
Testy.rowne([w6[:s_od], w6[:s_do] - w6[:dl_osi]], [-222.0, 222.0], 'działowa przez ścianę zewnętrzną – na zewnątrz 200 (jak węgieł)')
szczyty = pl[:sciany].select { |w| w[:szczyt] && w[:rodzaj] == :zewnetrzna }
platwie = Dach.platwie({ v_a: 22.0, v_b: 5978.0 }, p)
szczyty.each do |w|
  pod = pl[:sciany].select { |k| k[:rodzaj] == :kontrfor && k[:gospodarz].equal?(w) && k[:pod_platwia] }
  Testy.rowne(pod.length, platwie.count { |x| x[:rodzaj] == 'posrednia' }, "#{w[:id]}: węgieł pod każdą płatwią pośrednią (kalenicowa nad działową, ścienne przy narożnikach)")
  Testy.sprawdz(pod.all? { |k| (k[:s_do] - k[:s_od] - 344.0).abs < 0.01 }, "#{w[:id]}: węgły 100 + 44 + 200")
  luki = pod.map do |k|
    b = k[:bale].max_by { |x| x[:z0] }
    c = b[:cechy].select { |x| x[:typ] == 'wyciecie_gora' }.map { |x| b[:z0] + b[:h] - x[:gleb] }
    k[:pod_platwia][:z_spod] - (c.empty? ? b[:z0] + b[:h] : c.min)
  end
  Testy.sprawdz(luki.all? { |x| x > -0.01 && x < 20.0 }, "#{w[:id]}: górny bal węgła pod spodem płatwi, luka < 20 (#{luki.map { |x| x.round(1) }.inspect})")
  Testy.sprawdz(luki.count { |x| x < 1.1 } >= 2, "#{w[:id]}: węgły dochodzą do spodu płatwi (bal ścięty albo cały)")
end
Testy.rowne([kolizje_belek(pl, 'P', 5)], [0], 'płatwie bez kolizji z węgłami pod nimi')
czysto(pl, 'węgły pod płatwiami')
bez = plan_pelny(prostokat(0, 0, 6000, 8000) + [[[3000, 0], [3000, 8000]]], 'wegly_pod_platwiami' => 'nie')
Testy.rowne(bez[:sciany].count { |k| k[:pod_platwia] }, 0, 'wegly_pod_platwiami = nie – bez węgłów pod płatwiami')
pb = plan_pelny(prostokat(0, 0, 6000, 8000), 'podbitka' => 'pod_platwiami')
Testy.rowne(kolizje_belek(pb, 'Pb', 5), 0, 'podbitka pod płatwiami – węgły kończą się pod deskami')
wolny = plan(prostokat(0, 0, 6000, 8000) + [[[0, 4000], [2500, 4000]]])
kf = wolny[:sciany].find { |k| k[:wolny_koniec] }
Testy.sprawdz(kf && (kf[:a][0] - (2500.0 - 122.0)).abs < 0.01, 'wolny koniec 2500 – węgieł 122 od końca (ostatek 100 za węgłem)')
czysto(wolny, 'węgieł na wolnym końcu')
krotki = plan(prostokat(0, 0, 6000, 8000) + [[[0, 4000], [900, 4000]]])
Testy.rowne(krotki[:sciany].count { |k| k[:wolny_koniec] }, 0, 'wolny odcinek krótszy niż 1000 – bez węgła')

Testy.koniec
