# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_taras.rb
# Zadanie: taras – obrys przedłużony o głębokość, ściana domu ze szczytem, wariant 1100 (podciąg z górnych wieńców, słupy, wejście, balustrada z przekładkami) i 1200 (ściany boczne pełne, front bez bali), dach nad tarasem, strona tarasu, kiedy tarasu nie ma.
# Tematy: testy tarasu, szczyt nad tarasem w testach, zamki słupów w testach, taras 1100 w testach, taras 1200 w testach, słupy tarasu w testach, balustrada w testach, wejście na taras w testach
# Zależy od: testy/pomoc.rb, testy/kolizje_belek.rb, testy/losowe_domy.rb (sprawdzenie domu), Plugins/.../rdzen/taras.rb, rdzen/taras_balustrada.rb, rdzen/taras_slupy.rb, rdzen/taras_szczyt.rb
# Używają: testy/uruchom.sh

require File.expand_path('losowe_domy', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

# Sprawdzenie całego domu (bryły, zamki, mijanka, kolizje belek, połacie) jak w teście losowym.
def caly(seg, par, opis)
  problemy, pl = LosoweDomy.sprawdz(segmenty: seg, parametry: par, otwory: [], sciany: {})
  Testy.rowne(problemy, [], "#{opis}: dom bez problemów")
  Testy.rowne(kolizje_belek(pl, 'S'), 0, "#{opis}: słupy bez kolizji z balami")
  pl
end

def role(pl, rola)
  pl[:sciany].select { |w| w[:taras] && w[:taras][:rola] == rola }
end

def slupy(pl)
  pl[:elementy].select { |e| e[:prefiks] == 'S' }
end

# Środek słupa w rzucie [x, y].
def srodek(e)
  pe = e[:polozenie]
  [0, 1].map { |k| pe[:poczatek][k] + pe[:y][k] * e[:b] / 2.0 + pe[:z][k] * e[:h] / 2.0 }
end

Testy.grupa('Taras jak 1100 – dom 4000 × 4000, głębokość 2400, wejście z lewej')
seg = prostokat(0, 0, 4000, 4000)
par = { 'taras' => 'podciag', 'taras_glebokosc' => 2400, 'taras_wejscie' => 'lewa', 'liczba_wiencow' => 20 }
pl = caly(seg, par, '1100')
p = pl[:parametry]
t = Parametry.grubosc(p)
Testy.rowne(pl[:obrys].map { |x, _y| x }.max, 6400.0, 'obrys przedłużony o głębokość tarasu wzdłuż kalenicy')
front = role(pl, :front).first
dom = role(pl, :dom).first
boki = role(pl, :bok)
Testy.sprawdz(front && dom && boki.length == 2, 'front, ściana domu i dwie ściany boczne')
Testy.rowne([front[:rodzaj], dom[:rodzaj], dom[:a][0].round(1)], [:zewnetrzna, :dzialowa, 3978.0], 'ściana domu – działowa w osi dawnej ściany')
Testy.sprawdz(dom[:szczyt] && dom[:bale].any? { |b| b[:pozycja][:prefiks] == 'Sz' }, 'ściana domu ma szczyt z bali')
z_bok = Wience.wlasne(boki[0], p)[-2][:z0]
z_front = z_bok
Testy.rowne([front[:taras][:z_bok], front[:taras][:z_front]], [z_bok, z_front], 'podciąg: dwa górne wieńce ścian bocznych, front od tego samego poziomu')
naj = front[:bale].reject { |b| b[:taras] }.min_by { |b| b[:z0] }
Testy.rowne([naj[:z0], naj[:h], naj[:polbal]], [z_bok, Parametry.krycie(p) / 2.0, true],
            'front zaczyna się półbalem na poziomie bali ścian bocznych – naroże na jednym poziomie')
Testy.sprawdz(naj[:cechy].any? { |c| c[:typ] == 'gniazdo_gora' }, 'półbal frontu z gniazdem zamka od góry (bale ścian bocznych leżą na nim)')
Testy.sprawdz(front[:bale].reject { |b| b[:taras] }.all? { |b| b[:z0] >= z_front - 0.01 }, 'front: bale tylko od podciągu w górę (i balustrada)')
Testy.sprawdz(front[:szczyt] && front[:bale].any? { |b| b[:pozycja][:prefiks] == 'Sz' }, 'front ma szczyt')
boki.each do |w|
  tr = w[:taras]
  nad = w[:bale].reject { |b| b[:taras] || b[:z0] >= z_bok - 0.01 }
  dalej = nad.map { |b| tr[:kier] > 0 ? b[:s1] - tr[:s_dol] : tr[:s_dol] - b[:s0] }.max
  Testy.sprawdz(dalej <= 0.01, format('%s: dolne bale kończą się %.0f za licem ściany domu (najdalej %.2f)', w[:id], 100, dalej))
  gora = w[:bale].select { |b| b[:z0] >= z_bok - 0.01 }
  Testy.sprawdz(gora.any? { |b| (tr[:kier] > 0 ? b[:s1] : -b[:s0]) >= (tr[:kier] > 0 ? w[:s_do] : -w[:s_od]) - 0.01 },
                "#{w[:id]}: górne wieńce do frontu z ostatkiem")
end
sl = slupy(pl)
xs = sl.map { |e| srodek(e)[0].round(1) }.uniq
ys_front = sl.select { |e| (srodek(e)[0] - 6340.0).abs < 0.5 }.map { |e| srodek(e)[1].round(1) }.sort
Testy.rowne(ys_front, [60.0, 1380.0, 2660.0, 3940.0], 'słupy frontu licem z licami ścian: narożniki, wejście 1200 z lewej (od y = 0), pośredni ≤ 2000')
Testy.rowne(sl.length - ys_front.length, 2, 'po jednym słupie pośrednim pod ścianami bocznymi (2444 > 2000)')
Testy.sprawdz(xs.length == 2, "słupy tylko pod frontem i w połowie ścian bocznych (#{xs.inspect})")
Testy.rowne(sl.map { |e| [e[:b], e[:h]] }.uniq, [[120.0, 120.0]], 'przekrój słupa 120 × 120')
Testy.rowne(sl.map { |e| e[:dl] }.uniq, [100.0 + z_bok + 150.0], 'słupy: zamek dolny 100 + do spodu podciągu + zamek górny 150')
Testy.sprawdz(sl.all? { |e| e[:polozenie][:x] == [0.0, 0.0, 1.0] && e[:polozenie][:poczatek][2] == -100.0 }, 'słupy pionowe od −100 (zamek dolny)')
Testy.sprawdz(sl.all? { |e| e[:cechy].count { |c| c[:typ] =~ /wyciecie/ } == 2 }, 'słupy: pas pod balem i pas podwaliny wycięte')
Testy.rowne(sl.count { |e| e[:cechy].any? { |c| c[:typ] == 'podciecie' } }, 2, 'słupy narożne: także pasy ściany bocznej')
Testy.sprawdz(sl.all? { |e| [0, 1].all? { |k| c = srodek(e)[k]; c >= 59.99 && c <= 6340.01 } }, 'słupy nie wychodzą przed lica ścian')
gory = [front, boki[0]].map { |w| w[:bale].select { |b| b[:taras] }.map { |b| b[:z0] + Bryla.profil(b[:dl], t, b[:h], b[:cechy]).map { |q| q[:zt_a] }.max }.max }
Testy.rowne(gory[0].round(2), gory[1].round(2), 'poręcz frontu i ściany bocznej na tej samej wysokości')
Testy.sprawdz(pl[:bale].select { |b| b[:taras] }.group_by { |b| b[:sciana][:id] }.values.all? { |l| l.select { |b| b[:i] == l.map { |x| x[:i] }.max }.all? { |b| b[:cechy].any? { |c| c[:typ] == 'bez_piora' } } },
              'poręcz bez piór')
bal = pl[:bale].select { |b| b[:taras] }
bok_b = bal.select { |b| b[:sciana].equal?(boki[0]) }
Testy.rowne(bok_b.count { |b| b[:dl] > 400 }, 10, 'ściana boczna: 2 przęsła × (półbal + 4 bale)')
Testy.sprawdz(bok_b.select { |b| b[:dl] < 400 }.all? { |b| (b[:dl] - 300).abs < 0.01 }, 'przekładki 300')
fr_b = bal.select { |b| b[:sciana].equal?(front) }
Testy.rowne(fr_b.count { |b| b[:dl] > 400 }, 8, 'front: 2 przęsła × 4 bale (wejście bez balustrady)')
Testy.sprawdz(bal.all? { |b| b[:z0] + b[:h] <= (b[:sciana].equal?(front) ? z_front : z_bok) + 0.01 }, 'balustrada pod podciągiem')
Testy.rowne(fr_b.map { |b| b[:i] }.uniq.sort, [0, 1, 2, 3, 4, 5, 6], 'front: 7 wieńców balustrady (4 bale i 3 rzędy przekładek)')
Testy.sprawdz(fr_b.select { |b| b[:dl] > 400 }.map { |b| b[:i] }.uniq.sort == [0, 2, 4, 6], 'front: bale w wieńcach 0, 2, 4, 6')
Testy.sprawdz(bok_b.select { |b| b[:dl] > 400 }.map { |b| b[:i] }.uniq.sort == [0, 1, 3, 5, 7], 'ściana boczna: półbal i bale 1, 3, 5, 7')
pp = pl[:elementy].select { |e| e[:prefiks] == 'P' }
konce = pp.flat_map { |e| [e[:polozenie][:poczatek][0], e[:polozenie][:poczatek][0] + e[:polozenie][:x][0] * e[:dl]] }
Testy.rowne(konce.minmax.map { |v| v.round(1) }, [-500.0, 6900.0], 'płatwie nad domem i tarasem z wysunięciem 500')
Testy.sprawdz(pl[:podsumowanie][:lista].any? { |x| x[:prefiks] == 'S' && x[:rodzaj] == 'Słup tarasu' }, 'słupy na liście zamówienia')
Testy.rowne([Sciany.opis_rodzaju(front), Sciany.opis_rodzaju(dom)], ['front tarasu – podciąg i szczyt', 'ściana domu przy tarasie (ze szczytem)'],
            'opisy ścian tarasu')

Testy.grupa('Wejście pośrodku, z prawej, bez wejścia; bez balustrady')
y_front = lambda do |pl_|
  slupy(pl_).select { |e| (srodek(e)[0] - pl_[:obrys].map { |x, _y| x }.max + 60.0).abs < 0.5 }.map { |e| srodek(e)[1].round(1) }.sort
end
pl = plan_pelny(seg, par.merge('taras_wejscie' => 'srodek'))
Testy.rowne(y_front.call(pl), [60.0, 1340.0, 2660.0, 3940.0], 'pośrodku: słupy symetrycznie, światło 1200')
pl = plan_pelny(seg, par.merge('taras_wejscie' => 'prawa'))
Testy.rowne(y_front.call(pl), [60.0, 1340.0, 2620.0, 3940.0], 'z prawej: wejście przy y = 4000')
pl = plan_pelny(seg, par.merge('taras_wejscie' => 'brak'))
Testy.rowne(y_front.call(pl), [60.0, 2000.0, 3940.0], 'bez wejścia: słup pośredni co ≤ 2000')
Testy.rowne(pl[:bale].count { |b| b[:taras] && b[:sciana][:taras][:rola] == :front && b[:dl] > 400 }, 8, 'bez wejścia: balustrada na całym froncie')
pl = plan_pelny(seg, par.merge('taras_balustrada_bale' => 0))
Testy.rowne(pl[:bale].count { |b| b[:taras] }, 0, 'bez balustrady')
pl = plan_pelny(seg, par.merge('taras_wience_gorne' => 3))
Testy.rowne(role(pl, :bok)[0][:taras][:z_bok], Wience.wlasne(role(pl, :bok)[0], pl[:parametry])[-3][:z0], 'podciąg z trzech wieńców')

Testy.grupa('Szczyt nad tarasem – pełny, ażurowy, pusty')
seg = prostokat(0, 0, 4000, 5000)
par = { 'taras' => 'podciag', 'taras_glebokosc' => 2000, 'liczba_wiencow' => 16, 'dach_kat' => 30 }
szczyt = lambda do |pl_|
  f = role(pl_, :front).first
  f[:bale].reject { |b| b[:taras] }.select { |b| b[:z0] >= Wience.wysokosci(pl_[:parametry])[:okapowa] + 69.0 }
end
pelny = szczyt.call(plan_pelny(seg, par))
pl = caly(seg, par.merge('taras_szczyt' => 'azurowy'), 'szczyt ażurowy')
az = szczyt.call(pl)
Testy.sprawdz(az.length > 0 && az.inject(0.0) { |s_, b| s_ + b[:dl] } < pelny.inject(0.0) { |s_, b| s_ + b[:dl] } - 1000.0,
              'ażurowy: mniej drewna w szczycie niż pełny')
rzedy = az.group_by { |b| b[:i] }.sort.map { |_i, l| l.map { |b| b[:dl] }.max }
Testy.sprawdz(rzedy.each_with_index.all? { |d, j| j.odd? ? d <= 300.01 : true }, 'ażurowy: co drugi wieniec szczytu – przekładki 300')
osie = TarasSzczyt.osie_platwi(role(pl, :front).first, pl[:parametry])
Testy.sprawdz(az.select { |b| b[:dl] <= 300.01 }.length >= osie.length, 'ażurowy: przekładki co najmniej pod płatwiami')
pl = caly(seg, par.merge('taras_szczyt' => 'pusty', 'taras_szczyt_bale' => 1), 'szczyt pusty')
pu = szczyt.call(pl)
Testy.rowne(pu.select { |b| b[:dl] > 300.01 }.map { |b| b[:i] }.uniq.length, 1, 'pusty: jeden wieniec bali spinających')
f_pu = role(pl, :front).first
Testy.sprawdz(pu.select { |b| b[:dl] <= 300.01 }.all? { |b| TarasSzczyt.osie_platwi(f_pu, pl[:parametry]).any? { |s_| s_ > b[:s0] - 160.0 && s_ < b[:s1] + 160.0 } },
              'pusty: wyżej tylko przekładki pod płatwiami')

Testy.grupa('Taras jak 1200 – ściany boczne pełne, front otwarty, krokwie z aplikacji')
seg = prostokat(0, 0, 7000, 4000)
par = { 'taras' => 'sciany', 'dach_uklad' => 'krokwie', 'liczba_wiencow' => 20 }
pl = caly(seg, par, '1200')
front = role(pl, :front).first
Testy.rowne(front[:bale].length, 0, 'front bez bali')
Testy.rowne(slupy(pl).length + pl[:bale].count { |b| b[:taras] }, 0, 'bez słupów i balustrady')
boki = role(pl, :bok)
Testy.sprawdz(boki.all? { |w| w[:bale].map { |b| b[:i] }.uniq.length == Wience.wlasne(w, pl[:parametry]).length }, 'ściany boczne we wszystkich wieńcach')
Testy.sprawdz(boki.all? { |w| w[:bale].select { |b| b[:i] == 1 }.map { |b| b[:s1] }.max >= w[:s_do] - 0.01 }, 'ściany boczne do frontu')
Testy.rowne(pl[:polacie][:punkty].map { |x, _y| x }.max, 9000.0, 'połacie nad tarasem (obrys do frontu)')
Testy.sprawdz(role(pl, :dom).first[:szczyt], 'ściana domu ze szczytem')
Testy.rowne(Sciany.opis_rodzaju(front), 'front tarasu – otwarty', 'opis frontu')

Testy.grupa('Strona min, kalenica wzdłuż y, dach jednospadowy')
pl = caly(prostokat(0, 0, 4000, 6000), { 'taras' => 'podciag', 'taras_strona' => 'min', 'taras_glebokosc' => 1500 }, 'min, y')
Testy.rowne(pl[:obrys].map { |_x, y| y }.minmax, [-1500.0, 6000.0], 'taras od strony y = 0')
Testy.sprawdz(role(pl, :front).first[:a][1] < 0, 'front przy y = −1500')
pl = plan_pelny(prostokat(0, 0, 5000, 4000), 'taras' => 'podciag', 'dach_rodzaj' => 'jednospadowy')
Testy.sprawdz(pl[:obrys].map { |x, _y| x }.max == 5000.0 && pl[:ostrzezenia].any? { |u| u.include?('dwuspadowym') },
              'jednospadowy z podciągiem – taras pominięty z ostrzeżeniem')
caly(prostokat(0, 0, 5000, 4000), { 'taras' => 'sciany', 'dach_rodzaj' => 'jednospadowy' }, 'jednospadowy 1200')

Testy.grupa('Kiedy tarasu nie ma')
pl = plan_pelny(wielokat([[0, 0], [8000, 0], [8000, 4000], [4500, 4000], [4500, 7000], [0, 7000]]), 'taras' => 'podciag')
Testy.sprawdz(pl[:ostrzezenia].any? { |u| u.include?('Taras: tylko przy obrysie prostokątnym') } && pl[:sciany].none? { |w| w[:taras] },
              'obrys L – bez tarasu, ostrzeżenie')
pl = plan_pelny(prostokat(0, 0, 5000, 4000))
Testy.sprawdz(pl[:sciany].none? { |w| w[:taras] } && slupy(pl).empty? && pl[:obrys].map { |x, _y| x }.max == 5000.0, 'domyślnie bez tarasu')

Testy.grupa('Szczyt pusty – wiązar: krokwie z gniazdami, belka dolna, słupek, zastrzały, lico z frontem (runda 9)')
d = { segmenty: prostokat(0, 0, 4000, 4000), otwory: [],
      parametry: { 'taras' => 'podciag', 'taras_glebokosc' => 2000, 'liczba_wiencow' => 20, 'taras_szczyt' => 'pusty' } }
problemy, pl = LosoweDomy.sprawdz(d)
Testy.rowne(problemy, [], 'dom z wiązarem – kontrola losowych domów bez problemów')
wt = pl[:elementy].select { |e| e[:prefiks] == 'Wt' }
Testy.rowne(wt.length, 4, 'wiązar: dwie krokwie, belka dolna, słupek')
Testy.sprawdz(wt.all? { |e| e[:dl] == 80.0 && e[:przekroj] }, 'grubość jak płatew (80), przekrój w płaszczyźnie frontu')
front = pl[:sciany].find { |w| Taras.front?(w) }
iu = front[:taras][:iu]
u_lico = front[:a][iu] + front[:taras][:znak] * 22.0
zakres = wt.map { |e| [e[:polozenie][:poczatek][iu], e[:polozenie][:poczatek][iu] + e[:polozenie][:x][iu] * e[:dl]].sort }
Testy.sprawdz(zakres.all? { |lo, hi| front[:taras][:znak] < 0 ? (lo - u_lico).abs < 0.01 : (hi - u_lico).abs < 0.01 },
              "wiązar licem z licem zewnętrznym frontu (#{zakres.first.inspect}, lico #{u_lico})")
z_t = front[:bale].map { |b| b[:z0] + b[:h] }.max
Testy.rowne(wt.map { |e| e[:polozenie][:poczatek][2] }.min, z_t, 'belka dolna leży na balach frontu')
gora = wt.map { |e| e[:polozenie][:poczatek][2] + e[:h] }
zk = Dach.linia_szczytu(front[:szczyt], (front[:szczyt][:v_a] + front[:szczyt][:v_b]) / 2.0, pl[:parametry])
Testy.rowne([gora.count { |z| zk - z > -0.01 && zk - z < 30.0 }, wt.count { |e| e[:przekroj].length > 4 }], [2, 4],
            'krokwie wiązara do linii szczytu w kalenicy, człony z gniazdami i skosami')
Testy.rowne(kolizje_elementow(pl, 'Wt', 'P'), 0, 'płatwie w gniazdach wiązara – bez kolizji')
pw = pl[:elementy].select { |e| e[:prefiks] == 'P' }
Testy.sprawdz(pw.all? { |e| (e[:wreby] || []).any? { |x0, x1| x1 - x0 >= 81.99 } }, 'płatwie z wrębem na grubości wiązara (80 + 2 × luz)')
_pr, pl2 = LosoweDomy.sprawdz(d.merge(parametry: d[:parametry].merge('taras_wieniec' => 'wlasny', 'taras_wieniec_przekroj' => '100x120')))
Testy.sprawdz(pl2[:elementy].select { |e| e[:prefiks] == 'Wt' }.all? { |e| e[:dl] == 100.0 }, 'przekrój podany – 100 grubości')
pr3, pl3 = LosoweDomy.sprawdz(d.merge(parametry: d[:parametry].merge('taras_wiazar' => 'zastrzaly')))
Testy.rowne([pr3, pl3[:elementy].count { |e| e[:prefiks] == 'Wt' }], [[], 6], 'z zastrzałami – 6 członów, bez problemów')
pr4, pl4 = LosoweDomy.sprawdz(d.merge(parametry: d[:parametry].merge('taras_wiazar_podparcie' => 'slupy', 'taras_wiazar' => 'zastrzaly')))
Testy.rowne(pr4, [], 'wiązar na słupach – bez problemów')
f4 = pl4[:sciany].find { |w| Taras.front?(w) }
Testy.rowne(f4[:bale].count { |b| b[:z0] >= f4[:taras][:z_front] - 0.01 }, 0, 'front bez bali nad słupami – z przodu sam wiązar')
Testy.rowne(pl4[:elementy].select { |e| e[:prefiks] == 'Wt' }.map { |e| e[:polozenie][:poczatek][2] }.min, f4[:taras][:z_front],
            'belka dolna na słupach (od spodu podciągu)')
Testy.rowne([kolizje_elementow(pl4, 'Wt', 'S'), kolizje_belek(pl4, 'S', 5)], [0, 0], 'słupy z zamkiem górnym obok belki dolnej – bez kolizji')

Testy.grupa('Balustrada z wieńców ścian – ciągłe ściany boczne, zakładki w narożnikach frontu (runda 8)')
d = { segmenty: prostokat(0, 0, 4000, 4000), otwory: [],
      parametry: { 'taras' => 'podciag', 'taras_glebokosc' => 2000, 'liczba_wiencow' => 20, 'taras_balustrada_rodzaj' => 'sciany',
                   'taras_wejscie' => 'srodek' } }
problemy, pl = LosoweDomy.sprawdz(d)
Testy.rowne(problemy, [], 'kontrola losowych domów bez problemów')
w1 = sciana(pl, 'W-1')
dolne = w1[:bale].select { |b| b[:z0] + b[:h] <= 1000.01 }
Testy.rowne(dolne.map { |b| b[:s1] }.max, 6078.0, 'ściana boczna do frontu z zakładką 100 (5956 + 22 + 100)')
Testy.sprawdz(dolne.all? { |b| b[:dl] > 1000.0 }, "bez krótkich kawałków (#{dolne.map { |b| b[:dl].round }.min})")
Testy.rowne(pl[:bale].count { |b| b[:taras] }, 0, 'bez bali i przekładek dołożonych w przęsłach')
front = pl[:sciany].find { |w| Taras.front?(w) }
fb = front[:bale].select { |b| b[:z0] < 900.0 }
Testy.sprawdz(fb.map { |b| b[:s0] }.min < -121.99, 'front z zakładką w narożniku')
we = Taras.slupy_frontu(front, pl[:parametry])[:wejscie]
Testy.sprawdz(fb.none? { |b| b[:s0] < we[1] - 60.0 && b[:s1] > we[0] + 60.0 }, 'przerwa na wejście')
gory = [w1, front].map { |w| w[:bale].select { |b| b[:cechy].any? { |c| c[:typ] == 'bez_piora' } }.map { |b| b[:z0] + b[:cechy].find { |c| c[:typ] == 'skos_gora' }.to_h.fetch(:z0, b[:h]) }.max }
Testy.rowne(gory[0].round(2), gory[1].round(2), 'poręcz frontu i boku na jednej wysokości')
Testy.rowne(kolizje_belek(pl, 'S', 5), 0, 'słupy z wyciętym pasem – bez kolizji z balami')
_pr, pl = LosoweDomy.sprawdz(d.merge(parametry: d[:parametry].merge('taras_zakladka' => 'nie')))
Testy.rowne(sciana(pl, 'W-1')[:bale].select { |b| b[:z0] < 900.0 }.map { |b| b[:s1] }.max, 5978.0, 'bez zakładki – koniec równo z licem frontu')

Testy.koniec
