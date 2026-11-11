# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_skrzydla.rb
# Zadanie: dom w kształcie L – dwa dachy dwuspadowe z koszem (runda 10): podział na skrzydła, oś kalenicy, szczyty (także na części ściany), ściany okapowe skrzydła bocznego, płatwie obu dachów, połacie dla aplikacji do dachów, węgły ścięte do dachu, wypust górnych wieńców tylko na zewnątrz.
# Tematy: dom L w testach, dwa dachy z koszem w testach, skrzydło boczne w testach, szczyt na części ściany w testach, płatwie skrzydła bocznego w testach, połacie domu L w testach, wypust w narożniku wklęsłym, węgły domu L pod dachem
# Zależy od: testy/pomoc.rb, testy/kolizje_belek.rb, testy/losowe_domy.rb (sprawdzenie całego domu), rdzen/skrzydla.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_skrzydla.rb

require File.expand_path('losowe_domy', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

L1 = [[0, 0], [8000, 0], [8000, 4000], [4000, 4000], [4000, 7000], [0, 7000]].freeze

# Cały dom bez problemów (zamki, bryły, kolizje belek, bale i płatwie pod połaciami, podpory dla aplikacji do dachów).
def bez_problemow(seg, par, opis)
  problemy, pl = LosoweDomy.sprawdz(segmenty: seg, parametry: par, otwory: [], sciany: {})
  Testy.rowne(problemy, [], opis)
  pl
end

Testy.grupa('Podział obrysu L i oś kalenicy dachu głównego')
pd = Skrzydla.podzial(L1, 'dluzszy')
Testy.rowne([pd[:os], pd[:r], pd[:n], pd[:opp]], [:x, [4000, 4000], [8000, 7000], [0, 0]], 'równe rozpiętości – oś z parametru (dłuższy bok), narożnik wklęsły i brakujący')
Testy.rowne(Skrzydla.podzial(L1, 'y')[:os], :y, 'równe rozpiętości – kalenica wzdłuż Y z parametru')
Testy.rowne(Skrzydla.podzial([[0, 0], [8000, 0], [8000, 3000], [5000, 3000], [5000, 7000], [0, 7000]], 'x')[:os], :y,
            'szersze skrzydło pionowe (5000 > 3000) – dach główny wzdłuż Y mimo parametru')
Testy.rowne(Skrzydla.podzial([[0, 0], [8000, 0], [8000, 5000], [3000, 5000], [3000, 7000], [0, 7000]], 'y')[:os], :x,
            'szersze skrzydło poziome (5000 > 3000) – dach główny wzdłuż X mimo parametru')
Testy.sprawdz(Skrzydla.podzial([[0, 0], [4000, 0], [4000, 3000], [0, 3000]], 'x').nil?, 'prostokąt – nie L')
Testy.sprawdz(Skrzydla.podzial([[0, 0], [9000, 0], [9000, 6000], [6000, 6000], [6000, 3000], [3000, 3000], [3000, 6000], [0, 6000]], 'x').nil?,
              'obrys U – nie L')

Testy.grupa('Dom L 8 × 4 + 4 × 3 m – szczyty i ściany okapowe')
pl = plan_pelny(wielokat(L1))
p = pl[:parametry]
Testy.rowne(pl[:bledy], [], 'brak błędów')
Testy.rowne(pl[:os_kalenicy], :x, 'dach główny wzdłuż X')
Testy.rowne(pl[:sciany].select { |w| w[:szczyt] }.map { |w| w[:id] }, %w[W-2 W-5 W-6], 'szczyty: W-2 i W-6 (dach główny), W-5 (skrzydło boczne)')
w6 = sciana(pl, 'W-6')
Testy.rowne(w6[:szczyt][:s_zakres].map { |s| s.round(1) }, [3022.0, 1_000_000_000.0], 'W-6: szczyt od lica wewnętrznego linii okapu dachu głównego do narożnika')
Testy.sprawdz(sciana(pl, 'W-4')[:szczyt].nil? && sciana(pl, 'W-4')[:okap_boczny], 'W-4: ściana okapowa skrzydła bocznego (bez szczytu)')
Testy.sprawdz(w6[:okap_boczny] && w6[:okap_boczny][:s_zakres][1].round(1) == 3022.0, 'W-6: część okapowa do granicy szczytu')
Testy.rowne(sciana(pl, 'W-5')[:szczyt][:iv], 0, 'szczyt skrzydła bocznego – przekrój dachu w poprzek osi X')
Testy.rowne(sciana(pl, 'W-5')[:szczyt][:z_max], sciana(pl, 'W-2')[:szczyt][:z_max], 'równe rozpiętości – kalenice na tej samej wysokości', 0.01)
Testy.sprawdz(pl[:ostrzezenia].none? { |u| u.include?('tylko dla obrysu prostokątnego') }, 'bez ostrzeżenia o braku dachu')
%w[W-2 W-5 W-6].each { |id| Testy.sprawdz(nad_linia(pl, id) <= 0.01, "#{id}: bale pod linią dachu") }
# Wieńce szczytu W-6 tylko pod szczytem: nad górą ściany żaden bal nie wchodzi w część okapową.
gora = Szczyty.gora_wlasna(w6, p)
Testy.sprawdz(w6[:bale].select { |b| b[:z0] >= gora - 0.01 }.all? { |b| b[:s0] >= 3022.0 - 0.5 }, 'W-6: wieńce szczytu tylko nad dachem głównym')
gorny = w6[:bale].select { |b| (b[:z0] + b[:h] - gora).abs < 0.01 }
Testy.sprawdz(gorny.any? { |b| b[:cechy].any? { |c| c[:typ] == 'sciecie_dachu' && c[:x0] < 1.0 } } &&
              gorny.any? { |b| b[:cechy].any? { |c| c[:typ] == 'skos_gora' } },
              'W-6: górny bal ścięty w poprzek pod dachem skrzydła bocznego i po skosie pod dachem głównym')

Testy.grupa('Dom L – płatwie obu dachów')
platwie = pl[:elementy].select { |e| e[:prefiks] == 'P' }
wzdluz_x = platwie.select { |e| e[:polozenie][:x][0].abs > 0.5 }
wzdluz_y = platwie.select { |e| e[:polozenie][:x][1].abs > 0.5 }
Testy.sprawdz(wzdluz_x.length >= 3 && wzdluz_x.length == wzdluz_y.length, "płatwie dachu głównego i skrzydła bocznego (#{wzdluz_x.length} + #{wzdluz_y.length})")
wys = p['dach_okap_szczyt'].to_f
Testy.sprawdz(wzdluz_x.all? { |e| (e[:dl] - 8000.0 - 2.0 * wys).abs < 0.01 }, 'płatwie dachu głównego na całą długość z wysunięciem za szczyty')
vk = 2000.0
konce = wzdluz_y.map { |e| e[:polozenie][:poczatek][1] }
Testy.sprawdz(konce.all? { |y| y >= vk - 0.01 && y < 4000.0 }, "płatwie skrzydła bocznego kończą się na tylnej połaci dachu głównego (#{konce.map(&:round).inspect})")
Testy.sprawdz(wzdluz_y.all? { |e| (e[:polozenie][:poczatek][1] + e[:dl] - 7000.0 - wys).abs < 0.01 }, 'płatwie skrzydła bocznego wysunięte za jego szczyt')
Testy.rowne(kolizje_belek(pl, 'P'), 0, 'płatwie bez kolizji z balami')
Testy.rowne(kolizje_elementow(pl, 'P', 'P'), 0, 'płatwie obu dachów nie wchodzą w siebie')
Testy.sprawdz(sciana(pl, 'W-5')[:otwory].count { |o| o[:gniazdo] } >= wzdluz_y.length, 'gniazda płatwi skrzydła bocznego w jego szczycie')

Testy.grupa('Dom L – wypust górnych wieńców tylko na zewnątrz (uwaga użytkownika: 100 zamiast 300 do środka)')
t = Parametry.grubosc(p)
o = p['ostatek'].to_f
zew = t / 2.0 + p['dach_okap_szczyt'].to_f
w3 = sciana(pl, 'W-3')
gorne3 = w3[:bale].select { |b| b[:z0] >= Wience.wysokosc(w3, p) - Parametry.krycie(p) - 0.01 }
Testy.rowne(gorne3.map { |b| b[:s1] }.max, w3[:dl_osi] + t / 2.0 + o, 'W-3: w narożniku wklęsłym górny bal kończy się zwykłym ostatkiem', 0.01)
Testy.rowne(gorne3.map { |b| b[:s0] }.min, -zew, 'W-3: przy szczycie W-2 górny bal wypuszczony jak płatwie', 0.01)
w4 = sciana(pl, 'W-4')
gorne4 = w4[:bale].select { |b| b[:z0] >= Wience.wysokosc(w4, p) - Parametry.krycie(p) - 0.01 }
Testy.rowne([gorne4.map { |b| b[:s0] }.min, gorne4.map { |b| b[:s1] }.max], [-(t / 2.0 + o), w4[:dl_osi] + zew],
            'W-4 (okap skrzydła bocznego): ostatek w narożniku wklęsłym, wypust za szczyt W-5')
# To samo bez dachu z generatora (obrys U – szczyty osobno): wypust nie wchodzi do środka w narożniku wklęsłym.
u = plan_pelny(wielokat([[0, 0], [9000, 0], [9000, 6000], [6000, 6000], [6000, 3000], [3000, 3000], [3000, 6000], [0, 6000]]))
Testy.sprawdz(u[:ostrzezenia].any? { |x| x.include?('tylko dla obrysu prostokątnego') } && u[:elementy].none? { |e| e[:prefiks] == 'P' },
              'obrys U – bez belek dachu, ostrzeżenie')
u[:sciany].select { |w| w[:rodzaj] == :zewnetrzna && w[:wklesle].any? }.each do |w|
  [[0, w[:s_od]], [1, w[:s_do]]].each do |i, koniec|
    next unless w[:wklesle][i]
    skraj = i.zero? ? w[:bale].map { |b| b[:s0] }.min : w[:bale].map { |b| b[:s1] }.max
    Testy.rowne(skraj, koniec, "obrys U #{w[:id]}: koniec w narożniku wklęsłym bez wypustu", 0.01)
  end
end

Testy.grupa('Dom L – połacie dla aplikacji do dachów')
pol = pl[:polacie]
Testy.rowne(pol[:punkty], [[-1.0, 0.0], [8000.0, 0.0], [8000.0, 4000.0], [4000.0, 4000.0], [4000.0, 7000.0], [0.0, 7000.0], [0.0, 4000.0], [-1.0, 4000.0]],
            'obrys z uskokiem 1 mm na W-6 (okap = wysunięcie za szczyt)')
Testy.rowne(pol[:szczyty], [2, 5, 8], 'krawędzie szczytowe: W-2, W-5 i część W-6 pod dachem głównym')
pl2 = plan_pelny(wielokat(L1), 'dach_okap' => 300, 'dach_okap_szczyt' => 500)
Testy.rowne(pl2[:polacie][:punkty].values_at(0, 1, 4, 7), [[-200.0, 0.0], [8200.0, 0.0], [4000.0, 7200.0], [-200.0, 4000.0]],
            'szczyty wysunięte o (wysunięcie za szczyt − okap)')
wz = wzgledem_polaci(pl)
Testy.sprawdz(wz[:bale] <= 0.01 && wz[:platwie] <= 0.01 && wz[:dotyk] >= -0.5, 'bale i płatwie pod połaciami, każda płatew podpiera połać')
Testy.rowne(LosoweDomy.podpory_poza(pl), [], 'płatwie obu dachów jako podpory w granicy aplikacji')
Testy.sprawdz(plan_pelny(wielokat(L1), 'dach_wiezba' => 'generator', 'dach_uklad' => 'platwie_krokwie')[:ostrzezenia].any? { |x| x.include?('krokwie z generatora tylko dla domu prostokątnego') },
              'krokwie z generatora – ostrzeżenie (krokwie domu L z aplikacji do dachów)')

Testy.grupa('Dom L – węgły ścięte do dachu (uwaga użytkownika: nie zamykało węgłów do szczytu)')
kat = Dach.kat(p)
pl[:sciany].select { |w| w[:rodzaj] == :kontrfor && !w[:pod_platwia] }.each do |kf|
  d = Skrzydla.dom_sciany(Skrzydla.dom(pl[:sciany], p, pl[:os_kalenicy]), kf, p)
  gorny = kf[:bale].max_by { |b| b[:z0] }
  geo = Dach.geo(d)
  # Linia dachu nad osią gospodarza w miejscu węgła: górny bal węgła dochodzi do niej bliżej niż wysokość bala.
  z_dachu = [kf[:a][d[:iv]] - t / 2.0, kf[:a][d[:iv]] + t / 2.0].map { |v| Dach.linia_podparcia(geo, v, p) }.max
  Testy.sprawdz(z_dachu - (gorny[:z0] + gorny[:h]) < Parametry.krycie(p) + 0.01 && gorny[:z0] < z_dachu,
                "#{kf[:id]} na #{kf[:gospodarz][:id]}: węgieł dochodzi do dachu (do linii dachu #{(z_dachu - gorny[:z0] - gorny[:h]).round} mm, kąt #{(kat * 180 / Math::PI).round}°)")
  sciety = kf[:bale].any? { |b| b[:cechy].any? { |c| %w[skos_gora sciecie_dachu].include?(c[:typ]) } }
  Testy.sprawdz(sciety || z_dachu - (gorny[:z0] + gorny[:h]) > -0.01, "#{kf[:id]}: górny bal ścięty linią dachu albo cały pod nią")
end

Testy.grupa('Dom L – wszystkie ułożenia i warianty bez problemów')
uklady = {
  'wycięcie w prawym górnym rogu' => L1,
  'wycięcie w lewym górnym rogu' => [[0, 0], [8000, 0], [8000, 7000], [4000, 7000], [4000, 4000], [0, 4000]],
  'wycięcie w prawym dolnym rogu' => [[0, 0], [4000, 0], [4000, 3000], [8000, 3000], [8000, 7000], [0, 7000]],
  'wycięcie w lewym dolnym rogu' => [[4000, 0], [8000, 0], [8000, 7000], [0, 7000], [0, 3000], [4000, 3000]],
  'dach główny wzdłuż Y, skrzydło boczne węższe' => [[0, 0], [9000, 0], [9000, 3000], [5000, 3000], [5000, 8000], [0, 8000]]
}
uklady.each do |nazwa, pts|
  x = bez_problemow(wielokat(pts), { 'podloga' => 'nie' }, "#{nazwa}: dom bez problemów")
  Testy.sprawdz(x && x[:sciany].count { |w| w[:szczyt] } == 3 && x[:polacie] && x[:polacie][:szczyty].length == 3, "#{nazwa}: 3 szczyty, połacie")
end
bez_problemow(obroc_odcinki(wielokat(L1), 30), { 'podloga' => 'nie' }, 'dom L obrócony o 30°')
bez_problemow(wielokat(L1) + [[[4000, 0], [4000, 4000]]], { 'szczyty_na_dzialowych' => 'tak', 'podloga' => 'nie' }, 'działowa ze szczytem w dachu głównym')
bez_problemow(wielokat(L1) + [[[0, 5500], [4000, 5500]]], { 'szczyty_na_dzialowych' => 'tak', 'podloga' => 'nie' }, 'działowa ze szczytem w skrzydle bocznym')
x = plan_pelny(wielokat(L1) + [[[0, 5500], [4000, 5500]]], 'szczyty_na_dzialowych' => 'tak')
Testy.sprawdz(x[:sciany].find { |w| w[:rodzaj] == :dzialowa }[:szczyt], 'działowa w skrzydle bocznym ma szczyt jego dachu')
bez_problemow(wielokat(L1), { 'platwa_na_scianie' => 'tak', 'platwa_scienna_polozenie' => 'na_scianie', 'dach_kat' => 15, 'podloga' => 'nie' },
              'płatew ścienna na ścianie, 15°')
bez_problemow(wielokat(L1), { 'platwa_na_scianie' => 'tak', 'platwa_scienna_polozenie' => 'przy_licu', 'dach_kat' => 40, 'dach_uklad' => 'platwie_krokwie',
                              'podloga' => 'nie' }, 'płatew ścienna przy licu, 40°, krokwie z aplikacji')
bez_problemow(wielokat(L1), { 'profil_bala' => 'pelny', 'wegly_wypust_okap' => 'tak', 'okap_wience_wypust' => 2, 'wegiel_wypust_zewn' => 200,
                              'platwie_rozstaw_max' => 900, 'podloga' => 'nie' }, 'pełny profil, węgły wypuszczone pod okap (ustawienia użytkownika)')
x = plan_pelny(wielokat(L1), 'dach_rodzaj' => 'jednospadowy')
Testy.sprawdz(x[:ostrzezenia].any? { |s| s.include?('Dach jednospadowy: tylko dla domu prostokątnego') }, 'dach jednospadowy – nadal tylko dom prostokątny')

Testy.koniec
