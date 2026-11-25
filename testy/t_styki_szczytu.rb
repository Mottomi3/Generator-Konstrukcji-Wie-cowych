# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_styki_szczytu.rb
# Zadanie: testy łączenia wieńców szczytu na styk (decyzja T8, runda 15) – styki bez węgła na przemian o mijankę, węgły pod styki do wysokości ściany, szeroki szczyt, okno w szczycie, wybór „w zamkach węgłów”, szczyt płaski bez zmian, ziarna regresji.
# Tematy: testy szczytu na styk, test styków w wieńcach szczytu, test węgła pod styk do wysokości ściany, regresja styków bez zamka w szczycie
# Zależy od: testy/pomoc.rb, testy/losowe_domy.rb, Plugins/.../rdzen/styki_szczytu.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_styki_szczytu.rb – ostatnia linia „FAILURES: n”.

require File.expand_path('losowe_domy', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

# Dach z krokwiami z generatora, bez węgłów pod płatwiami – szczyt bez gniazd co kilkadziesiąt centymetrów.
DACH = { 'dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator', 'wegly_pod_platwiami' => 'nie' }.freeze

# Styki (koniec s1 bala zakończonego stykiem) w wieńcu o indeksie i ściany w.
def styki_wienca(w, i)
  w[:bale].select { |b| b[:i] == i && b[:konce][1] == :styk }.map { |b| b[:s1].round(1) }.sort
end

# Indeksy wieńców szczytu ściany w (spód na górze ściany bez szczytu albo wyżej).
def wience_szczytu(w, p)
  (0...w[:wience].length).select { |i| StykiSzczytu.wieniec?(w, w[:wience][i], p) }
end

# Węgły pod styki na ścianie w.
def wegly_stykow(pl, w)
  pl[:sciany].select { |k| k[:rodzaj] == :kontrfor && k[:zrodlo] == :styk && k[:gospodarz].equal?(w) }
end

Testy.grupa('Szczyt na styk: dom 8000 × 6400, ściana szczytowa 6400 przy balu 5100')
pl = plan_pelny(prostokat(0, 0, 8000, 6400), DACH)
p = pl[:parametry]
w = sciana(pl, 'W-2')
Testy.rowne(p['szczyt_styk'], 'styk', 'wartość fabryczna – na styk')
Testy.sprawdz(StykiSzczytu.dotyczy?(w, p) && !StykiSzczytu.dotyczy?(sciana(pl, 'W-1'), p), 'dotyczy ściany ze szczytem, nie okapowej')
gora = Szczyty.gora_wlasna(w, p)
okap = Wience.wysokosci(p)[:okapowa]
Testy.rowne(gora, 2363.0, 'góra ściany pod szczytem (17 wieńców)')
sz = wience_szczytu(w, p)
Testy.rowne(sz.first, 17, 'pierwszy wieniec szczytu – indeks 17')
kf = wegly_stykow(pl, w)
Testy.rowne(kf.length, 2, 'dwa węgły pod styki ściany')
Testy.sprawdz(kf.all? { |k| k[:bale].map { |b| b[:z0] + b[:h] }.max <= okap + 0.01 }, 'węgły pod styki kończą się na wysokości ściany okapowej')
Testy.sprawdz(kf.all? { |k| k[:bale].length == 17 }, 'węgieł pod styk: półbal + 16 wieńców')
os = StykiSzczytu.os(w, p)
Testy.rowne(os, 3178.0, 'oś siatek styków = kalenica (środek osi ściany)')
Testy.rowne(styki_wienca(w, 17), [3378.0], 'wieniec 17 (nieparzysty): styk w kalenicy + pół mijanki')
Testy.sprawdz(sz[1..-1].all? { |i| styki_wienca(w, i).empty? }, 'wyższe wieńce szczytu mieszczą się w balu – bez styków')
Testy.rowne(styki_wienca(w, 16), [2118.7], 'najwyższy wieniec ściany łączy się w zamku węgła')
osie = w[:skrzyzowania].map { |k| k[:s] }
Testy.sprawdz(osie.none? { |s| (s - 3378.0).abs < 66.0 }, 'styk szczytu poza zamkami')
k = Kontrola.wszystko(pl)
Testy.rowne([k[:kolizje].length, k[:mijanka].length, k[:za_dlugie].length, k[:styki_bez_zamka].length], [0, 0, 0, 0],
            'kontrola: zamki, mijanka, długości, styki bez zamka')
Testy.sprawdz(pl[:ostrzezenia].none? { |u| u.include?('styk bez zamka') || u.include?('dłuższe niż') }, 'bez ostrzeżeń o stykach i długościach')
problemy, _x = LosoweDomy.sprawdz(segmenty: prostokat(0, 0, 8000, 6400), parametry: DACH, otwory: [])
Testy.rowne(problemy, [], 'pełne sprawdzenie domu (bryły, kolizje, linia dachu)')

Testy.grupa('Wybór „w zamkach węgłów” – jak do kompilacji 14')
plw = plan_pelny(prostokat(0, 0, 8000, 6400), DACH.merge('szczyt_styk' => 'wegly'))
ww = sciana(plw, 'W-2')
kfw = wegly_stykow(plw, ww)
Testy.sprawdz(!StykiSzczytu.dotyczy?(ww, plw[:parametry]), 'nie dotyczy')
Testy.sprawdz(kfw.all? { |x| x[:bale].map { |b| b[:z0] + b[:h] }.max > okap + 100.0 }, 'węgły pod styki wchodzą w szczyt')
Testy.sprawdz(styki_wienca(ww, 17).all? { |s| ww[:skrzyzowania].any? { |x| (x[:s] - s).abs < 1.0 } } && !styki_wienca(ww, 17).empty?,
              'styk wieńca szczytu w osi węgła')
bale_na_styk = kf.inject(0) { |s, x| s + x[:bale].length }
bale_w_zamkach = kfw.inject(0) { |s, x| s + x[:bale].length }
Testy.sprawdz(bale_na_styk < bale_w_zamkach, "na styk mniej bali węgłów (#{bale_na_styk} zamiast #{bale_w_zamkach})")

Testy.grupa('Szeroki szczyt 11 m: dwa styki w dolnych wieńcach, jeden wyżej, na przemian')
pl = plan_pelny(prostokat(0, 0, 12_000, 11_000), DACH.merge('dach_uklad' => 'krokwie'))
p = pl[:parametry]
w = sciana(pl, 'W-2')
os = StykiSzczytu.os(w, p)
Testy.rowne(os, 5478.0, 'kalenica w osi ściany')
Testy.rowne(styki_wienca(w, 17), [4078.0, 7278.0], 'wieniec 17: dwa styki z siatki nieparzystej')
Testy.rowne(styki_wienca(w, 18), [3678.0, 6878.0], 'wieniec 18: dwa styki z siatki parzystej')
Testy.rowne([styki_wienca(w, 20), styki_wienca(w, 21)], [[5278.0], [5678.0]], 'wyżej jeden styk: kalenica ∓ pół mijanki')
Testy.sprawdz(styki_wienca(w, 26).empty?, 'wieniec krótszy niż bal – bez styku')
sz = wience_szczytu(w, p)
pary = sz.each_cons(2).map { |i, j| styki_wienca(w, i).product(styki_wienca(w, j)).map { |a, b| (a - b).abs }.min }.compact
Testy.sprawdz(pary.all? { |d| d >= 400.0 - 0.01 }, "styki sąsiednich wieńców szczytu mijają się o ≥ 400 (najmniej #{pary.min})")
bale_szczytu = w[:bale].select { |b| sz.include?(b[:i]) }
Testy.sprawdz(bale_szczytu.all? { |b| b[:dl] <= 5100.01 }, 'bale szczytu ≤ 5100')
Testy.sprawdz(bale_szczytu.select { |b| b[:konce].include?(:styk) }.all? { |b| b[:dl] >= 200.0 }, 'kawałki przy stykach nie krótsze niż najkrótszy kawałek')
Testy.sprawdz(wegly_stykow(pl, w).length == 4 && wegly_stykow(pl, w).all? { |x| x[:do_gory_sciany] }, 'cztery węgły pod styki – do wysokości ściany')
k = Kontrola.wszystko(pl)
Testy.rowne([k[:kolizje].length, k[:mijanka].length, k[:za_dlugie].length, k[:styki_bez_zamka].length], [0, 0, 0, 0], 'kontrola')

Testy.grupa('Mijanka 300 i okno w szczycie')
pl = plan_pelny(prostokat(0, 0, 8000, 6400), DACH.merge('mijanka' => 300))
Testy.rowne(styki_wienca(sciana(pl, 'W-2'), 17), [3328.0], 'mijanka 300: kalenica + 150')
okno = [{ 'sciana' => 'W-2', 'od' => 3000, 'szerokosc' => 800, 'wysokosc' => 600, 'parapet' => 2450 }]
pl = plan_pelny(prostokat(0, 0, 8000, 6400), DACH, okno)
p = pl[:parametry]
w = sciana(pl, 'W-2')
o = w[:otwory].find { |x| !x[:gniazdo] }
wszystkie = wience_szczytu(w, p).map { |i| styki_wienca(w, i) }.flatten
Testy.sprawdz(wszystkie.all? { |s| s <= o[:s0] - 400.0 + 0.01 || s >= o[:s1] + 400.0 - 0.01 },
              "styki szczytu co najmniej 400 od okna (okno #{o[:s0].round}…#{o[:s1].round}, styki #{wszystkie.inspect})")
k = Kontrola.wszystko(pl)
Testy.rowne([k[:kolizje].length, k[:mijanka].length, k[:styki_bez_zamka].length], [0, 0, 0], 'kontrola z oknem w szczycie')

Testy.grupa('Ściana pod szczytem łączy się jak zwykła – także w zamku działowej')
seg = prostokat(0, 0, 8000, 6400) + [[[0, 3000], [8000, 3000]]]
pl = plan_pelny(seg, DACH.merge('styk_na_dzialowej' => 'mijanka'))
w = sciana(pl, 'W-2')
dz = w[:skrzyzowania].find { |x| x[:inna][:rodzaj] == :dzialowa }
Testy.sprawdz(dz && w[:styki][:kotwy].any? { |s| (s - dz[:s]).abs < 1.0 }, 'działowa wzdłuż kalenicy jest miejscem styku ściany szczytowej')
Testy.rowne(wegly_stykow(pl, w).length, 1, 'jeden nowy węgieł zamiast dwóch')
k = Kontrola.wszystko(pl)
Testy.rowne([k[:kolizje].length, k[:mijanka].length, k[:za_dlugie].length, k[:styki_bez_zamka].length], [0, 0, 0, 0], 'kontrola')

Testy.grupa('Szczyt płaski (ściana wysoka dachu jednospadowego) – bez zmian, w zamkach węgłów')
pl = plan_pelny(prostokat(0, 0, 8000, 6400), 'dach_rodzaj' => 'jednospadowy')
p = pl[:parametry]
plaskie = pl[:sciany].select { |x| x[:szczyt] && x[:szczyt][:plaski] && x[:rodzaj] != :kontrfor }
Testy.sprawdz(!plaskie.empty? && plaskie.none? { |x| StykiSzczytu.dotyczy?(x, p) }, 'ściana wysoka – nie dotyczy')
skosne = pl[:sciany].select { |x| x[:szczyt] && !x[:szczyt][:plaski] && x[:rodzaj] != :kontrfor }
Testy.sprawdz(!skosne.empty? && skosne.all? { |x| StykiSzczytu.dotyczy?(x, p) }, 'szczyty skośne dachu jednospadowego – na styk')
k = Kontrola.wszystko(pl)
Testy.rowne([k[:kolizje].length, k[:mijanka].length], [0, 0], 'kontrola dachu jednospadowego')

# Ziarna, w których do kompilacji 14 styk wieńca szczytu wypadał nad węgłem zakończonym pod połacią (bez zamka).
{ 6026 => 'styk nad węgłem pod połacią', 6042 => 'styk nad węgłem pod połacią', 6050 => 'styk nad węgłem pod połacią',
  16 => 'styk w szczycie bez zamka', 88 => 'styk w szczycie bez zamka' }.each do |z, opis|
  Testy.grupa("Ziarno #{z} – #{opis}")
  d = LosoweDomy.dom(z)
  problemy, pl = LosoweDomy.sprawdz(d)
  Testy.rowne(problemy, [], d[:opis])
  skosne = pl[:sciany].select { |x| x[:szczyt] && !x[:szczyt][:plaski] && x[:rodzaj] != :kontrfor }.map { |x| x[:id] }
  bez = Kontrola.styki_bez_zamka(pl).select { |x| skosne.include?(x[:sciana]) }
  Testy.rowne(bez, [], 'zero styków bez zamka w ścianach ze szczytem skośnym')
end

Testy.koniec
