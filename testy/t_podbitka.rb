# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_podbitka.rb
# Zadanie: podbitka w czterech położeniach – pod / na płatwiach, pod / na krokwiach: deski przy właściwej płaszczyźnie, bez kolizji z balami, krokwie uniesione nad deskami na płatwiach, podbitka jako nadbitka KROKU 2 aplikacji do dachów, wybór niepasujący do układu dachu.
# Tematy: testy podbitki, podbitka pod płatwiami w testach, podbitka na płatwiach w testach, podbitka pod krokwiami w testach, podbitka na krokwiach w testach, uniesienie krokwi w testach, nadbitka KROKU 2 w testach
# Zależy od: testy/pomoc.rb, testy/kolizje_belek.rb, Plugins/.../rdzen/podbitka.rb, Plugins/.../rdzen/krok2.rb
# Używają: testy/uruchom.sh, testy/ruby27.sh

require File.expand_path('pomoc', File.dirname(__FILE__))
require File.expand_path('kolizje_belek', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

DOM = prostokat(0, 0, 6000, 4500)

# Narożniki ściany spodniej (lokalne z = 0) i wierzchniej (z = h) elementu – [spód, wierzch] w świecie.
def sciany_deski(e)
  pe = e[:polozenie]
  [0.0, e[:h]].map do |z|
    [0.0, e[:dl]].product([0.0, e[:b]]).map { |x, y| (0..2).map { |k| pe[:poczatek][k] + pe[:x][k] * x + pe[:y][k] * y + pe[:z][k] * z } }
  end.sort_by { |f| f.inject(0.0) { |s, q| s + q[2] } }
end

# Największa odchyłka ściany deski (:spod albo :wierzch) od linii podparcia przesuniętej o dz [mm].
def odchylka(pl, strona, dz)
  p = pl[:parametry]
  w = pl[:sciany].find { |x| x[:szczyt] && !x[:szczyt][:plaski] }
  geo = { v_a: w[:szczyt][:v_a], v_b: w[:szczyt][:v_b] }
  iv = pl[:os_kalenicy] == :x ? 1 : 0
  pl[:elementy].select { |e| e[:prefiks] == 'Pb' }.map do |e|
    f = sciany_deski(e)[strona == :spod ? 0 : 1]
    f.map { |q| (q[2] - Dach.linia_podparcia(geo, q[iv], p) - dz).abs }.max
  end.max || 0.0
end

# Deski podbitki planu.
def deski(pl)
  pl[:elementy].select { |e| e[:prefiks] == 'Pb' }
end

Testy.grupa('Pod płatwiami – same płatwie, deski wierzchem na spodzie płatwi')
pl = plan_pelny(DOM, 'podbitka' => 'pod_platwiami')
p = pl[:parametry]
hp = Parametry.przekroj(p, 'platwa_przekroj')[1]
Testy.sprawdz(deski(pl).length > 20, "deski podbitki (#{deski(pl).length})")
Testy.rowne(odchylka(pl, :wierzch, -hp), 0.0, 'wierzch desek na płaszczyźnie spodu płatwi pośrednich', 0.05)
Testy.rowne(kolizje_belek(pl, 'Pb', 5), 0, 'deski bez kolizji z balami')
Testy.sprawdz(!Krok2.ustawienia(p)[:sheath_ceiling_on], 'KROK 2 bez nadbitki')

Testy.grupa('Na płatwiach – same płatwie z aplikacją: nadbitka KROKU 2 z wymiarami podbitki')
pl = plan_pelny(DOM, 'podbitka' => 'na_platwiach', 'podbitka_grubosc' => 22, 'podbitka_krycie' => 140)
p = pl[:parametry]
u = Krok2.ustawienia(p)
Testy.rowne(deski(pl).length, 0, 'generator nie rysuje desek – robi je aplikacja')
Testy.rowne([u[:sheath_ceiling_on], u[:sheath_ceiling_t_mm], u[:sheath_ceiling_w_mm]], [true, 22.0, 140.0], 'nadbitka KROKU 2 = podbitka')
Testy.sprawdz(Krok2.warstwy(p).include?('nadbitka'), 'nadbitka w podpowiedzi KROKU 2')

Testy.grupa('Na płatwiach – płatwie i krokwie z generatora: deski spodem na płatwiach, krokwie na deskach')
par = { 'podbitka' => 'na_platwiach', 'dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator' }
pl = plan_pelny(DOM, par)
p = pl[:parametry]
g = p['podbitka_grubosc'].to_f / Math.cos(Dach.kat(p))
Testy.sprawdz(deski(pl).length > 20, "deski podbitki (#{deski(pl).length})")
Testy.rowne(odchylka(pl, :spod, 0.0), 0.0, 'spód desek na linii podparcia (wierzch płatwi)', 0.05)
Testy.rowne(Dach.uniesienie_krokwi(p), g, 'krokwie uniesione o grubość deski w pionie')
geo = { v_a: 22.0, v_b: 4478.0 }
k = pl[:elementy].find { |e| e[:prefiks] == 'K' }
v0 = k[:polozenie][:poczatek][1] + k[:polozenie][:y][1] * k[:b] / 2.0
Testy.rowne(k[:polozenie][:poczatek][2], Dach.linia_podparcia(geo, v0, p) + g, 'spód krokwi na wierzchu desek', 0.05)
Testy.rowne([kolizje_belek(pl, 'Pb', 5), kolizje_belek(pl, 'K', 5)], [0, 0], 'deski i krokwie bez kolizji z balami')
pl0 = plan_pelny(DOM, par.merge('podbitka' => 'nie'))
Testy.rowne(Szczyty.linia(sciana(pl, 'W-2'), 2000.0, p) - Szczyty.linia(sciana(pl0, 'W-2'), 2000.0, pl0[:parametry]), g,
            'szczyt obok krokwi wyżej o grubość desek (do wierzchu krokwi)', 0.01)

Testy.grupa('Na płatwiach – krokwie z aplikacji: połać i podpory wyżej o grubość desek')
par = { 'podbitka' => 'na_platwiach', 'dach_uklad' => 'platwie_krokwie' }
pl = plan_pelny(DOM, par)
pl0 = plan_pelny(DOM, par.merge('podbitka' => 'nie'))
Testy.sprawdz(deski(pl).length > 20, 'deski rysuje generator (aplikacja kładzie krokwie na nich)')
Testy.rowne(pl[:polacie][:z] - pl0[:polacie][:z], g, 'połać wyżej o grubość deski w pionie')
Testy.rowne(Krok2.podpory(pl).map { |q| q[:od][2] }.zip(Krok2.podpory(pl0).map { |q| q[:od][2] }).map { |a, b| (a - b).round(3) }.uniq,
            [g.round(3)], 'podpory (płatwie) wyżej o grubość deski')
Testy.sprawdz(!Krok2.ustawienia(pl[:parametry])[:sheath_ceiling_on], 'KROK 2 bez nadbitki (podbitka już jest)')

Testy.grupa('Pod krokwiami – krokwie z generatora: wierzch desek na spodzie krokwi, między płatwiami')
pl = plan_pelny(DOM, 'podbitka' => 'pod_krokwiami', 'dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator')
Testy.sprawdz(deski(pl).length > 20, "deski podbitki (#{deski(pl).length})")
Testy.rowne(odchylka(pl, :wierzch, 0.0), 0.0, 'wierzch desek na linii podparcia (spód krokwi)', 0.05)
Testy.rowne(kolizje_belek(pl, 'Pb', 5), 0, 'deski bez kolizji z balami')

Testy.grupa('Na krokwiach – krokwie z generatora: spód desek na wierzchu krokwi; z aplikacją – nadbitka KROKU 2')
pl = plan_pelny(DOM, 'podbitka' => 'na_krokwiach', 'dach_uklad' => 'krokwie', 'dach_wiezba' => 'generator')
p = pl[:parametry]
Testy.sprawdz(deski(pl).length > 20, "deski podbitki (#{deski(pl).length})")
Testy.rowne(odchylka(pl, :spod, Dach.dodatek_krokwi(p)), 0.0, 'spód desek na wierzchu krokwi', 0.05)
Testy.rowne(Dach.uniesienie_krokwi(p), 0.0, 'krokwie nieuniesione')
pl = plan_pelny(DOM, 'podbitka' => 'na_krokwiach', 'dach_uklad' => 'krokwie')
Testy.rowne([deski(pl).length, Krok2.ustawienia(pl[:parametry])[:sheath_ceiling_on]], [0, true], 'z aplikacją – nadbitka KROKU 2')

Testy.grupa('Na płatwiach przy ścianie nośnej (dach jednospadowy) – deski do lic zewnętrznych ścian')
pl = plan_pelny(DOM, 'podbitka' => 'na_platwiach', 'dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator',
                     'dach_rodzaj' => 'jednospadowy', 'platwa_na_scianie' => 'nie')
Testy.rowne(pl[:bledy], [], 'bez błędów')
ys = deski(pl).map { |e| sciany_deski(e)[0].map { |q| q[1] } }.flatten
Testy.rowne([ys.min, ys.max], [0.0, 4500.0], 'deski od lica zewnętrznego ściany niskiej do lica zewnętrznego wysokiej', 0.05)
Testy.rowne([kolizje_belek(pl, 'Pb', 5), kolizje_belek(pl, 'K', 5)], [0, 0], 'deski i krokwie bez kolizji z balami')

Testy.grupa('Wybór niepasujący do układu dachu – pominięty z uwagą')
pl = plan_pelny(DOM, 'podbitka' => 'na_krokwiach', 'dach_uklad' => 'platwie')
Testy.rowne(deski(pl).length, 0, 'bez desek')
Testy.sprawdz(pl[:ostrzezenia].any? { |x| x.include?('Podbitka') }, 'uwaga o podbitce')
Testy.sprawdz(!Krok2.ustawienia(pl[:parametry])[:sheath_ceiling_on], 'KROK 2 bez nadbitki')

Testy.koniec
