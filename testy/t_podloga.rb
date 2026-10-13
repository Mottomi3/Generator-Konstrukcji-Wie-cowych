# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_podloga.rb
# Zadanie: testy podłogi i statyki – wzory belki, dobór przekroju (minimalny / zalecany / ręczny), izolacja, podpory, układ podwalin i legarów.
# Tematy: testy podłogi, statyka legara, ugięcie, dobór przekroju, izolacja, podpory legarów, podwaliny na zakład, legary między podwalinami
# Zależy od: testy/pomoc.rb
# Używają: testy/uruchom.sh

require File.expand_path('pomoc', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

# Elementy planu o prefiksie.
def el(pl, prefiks)
  pl[:elementy].select { |e| e[:prefiks] == prefiks }
end

# Czy jest podpowiedź danego poziomu zawierająca tekst.
def podp?(pl, poziom, tekst)
  pl[:podpowiedzi].any? { |h| h[:poziom] == poziom && h[:tekst].include?(tekst) }
end

P0 = Parametry.normalizuj({})[0]

Testy.grupa('Statyka – belka 50 × 100 C24, 2,4 m, co 600 (sprawdzenie ręczne)')
g, q = Statyka.obciazenia(P0, 600.0)
Testy.rowne([g, q], [0.3, 1.2], 'obciążenia legara 0,3 i 1,2 kN/m')
s = Statyka.belka(2400.0, 50.0, 100.0, g, q, 'C24', 400.0)
gc = 0.3 + 420 * 9.81e-9 * 5000
qd = 1.35 * gc + 1.5 * 1.2
sigma = qd * 2400**2 / 8.0 / (50 * 100**2 / 6.0)
fmd = 0.8 * 1.5**0.2 * 24 / 1.3
Testy.rowne(s[:wyk_m], sigma / fmd, 'wykorzystanie na zginanie', 1e-9)
u = 5.0 * 2400**4 / (384 * 11_000 * 50 * 100**3 / 12.0) * (gc * 1.6 + 1.2 * 1.18)
Testy.rowne(s[:u], u, 'ugięcie końcowe z pełzaniem', 1e-9)
Testy.sprawdz(!s[:ok] && !s[:nosnosc_ok], '50 × 100 na 2,4 m przy 2 kN/m² – za słaby')
Testy.sprawdz(Statyka.belka(1400.0, 50.0, 100.0, g, q, 'C24', 400.0)[:ok], 'na 1,4 m – wystarcza')
l1 = Statyka.max_rozpietosc(50.0, 100.0, P0, 600.0, 400.0)
Testy.sprawdz(Statyka.belka(l1 - 1, 50.0, 100.0, g, q, 'C24', 400.0)[:ok] && !Statyka.belka(l1 + 5, 50.0, 100.0, g, q, 'C24', 400.0)[:ok],
              "największa rozpiętość 50 × 100: #{l1.round} mm")
Testy.sprawdz(Statyka.max_rozpietosc(50.0, 100.0, P0, 600.0, 250.0) >= l1, 'granica L/250 – większa rozpiętość niż L/400')
Testy.sprawdz(Statyka.max_rozpietosc(50.0, 100.0, P0.merge('drewno_klasa' => 'C18'), 600.0, 400.0) < l1, 'C18 – mniejsza rozpiętość')

Testy.grupa('Dobór przekroju – katalog, izolacja, minimalny / zalecany')
zal = Statyka.dobierz(3850.0, P0, 600.0, 400.0)
min = Statyka.dobierz(3850.0, P0, 600.0, 250.0)
Testy.sprawdz(zal && min && min[0] * min[1] <= zal[0] * zal[1], "minimalny #{min.inspect} nie większy niż zalecany #{zal.inspect}")
iz = P0.merge('izolacja_podlogi' => 150.0)
Testy.sprawdz(Statyka.kandydaci(iz).all? { |b, h| h >= 150 }, 'izolacja 150 – tylko przekroje ≥ 150')
Testy.sprawdz(Statyka.dobierz(1000.0, iz, 600.0, 400.0)[1] >= 150, 'krótki legar i tak ≥ izolacji')

Testy.grupa('Podłoga domu 4000 × 3000 (jak 900)')
pl = plan_pelny(prostokat(0, 0, 4000, 3000))
pw = el(pl, 'Pw')
Testy.rowne(pw.map { |e| e[:dl] }.sort, [3000.0, 3000.0, 4000.0, 4000.0], 'podwaliny zewnętrzne: długości lica (na zakład)')
Testy.sprawdz(pw.all? { |e| e[:cechy].length == 2 && e[:cechy].all? { |c| (c[:gleb] - 50.0).abs < 0.01 } }, 'zakład na pół wysokości w narożnikach')
Testy.rowne(pw.map { |e| e[:polozenie][:poczatek][2] }.uniq, [-100.0], 'wierzch podwalin na poziomie 0 (spód bali)')
lg = el(pl, 'L')
Testy.sprawdz(!lg.empty? && lg.all? { |e| e[:polozenie][:x][1].abs > 0.99 }, 'legary wzdłuż krótszego boku (Y)')
Testy.rowne(lg.map { |e| e[:dl] }.uniq, [2800.0], 'legar między podwalinami: 3000 − 2 × 100')
Testy.rowne(lg.map { |e| e[:polozenie][:poczatek][2] + e[:h] }.uniq, [0.0], 'wierzch legarów równo z podwalinami')
xs = lg.map { |e| e[:polozenie][:poczatek][0] + e[:b] / 2.0 }.sort
Testy.sprawdz(([100.0] + xs + [3900.0]).each_cons(2).all? { |a, b| b - a <= 600.01 }, 'rozstaw legarów ≤ 600')
Testy.sprawdz(pl[:podpowiedzi].length >= 2, 'podpowiedzi do okna')
Testy.sprawdz(pl[:podpowiedzi].none? { |h| h[:poziom] == 'blad' }, 'dobrany przekrój bez błędów')
Testy.sprawdz(pl[:podpowiedzi].any? { |h| h[:tekst].include?('najmniejszy wystarczający') }, 'podpowiedź o przekroju najmniejszym i zalecanym')

Testy.grupa('Ręczny przekrój za słaby – podpory i podpowiedź')
pl = plan_pelny(prostokat(0, 0, 6000, 5000), 'legary_dobor' => 'reczny', 'legar_przekroj' => '50x100')
Testy.rowne(pl[:podloga][:legar], [50.0, 100.0], 'zostaje przekrój ręczny')
Testy.sprawdz(pl[:podloga][:podpory] >= 1 && el(pl, 'Pd').length == pl[:podloga][:podpory], "dodane podpory (#{pl[:podloga][:podpory]})")
pd = el(pl, 'Pd')
Testy.rowne(pd.map { |e| e[:polozenie][:poczatek][2] + e[:h] }.uniq, [-100.0], 'podpory pod legarami')
pl = plan_pelny(prostokat(0, 0, 6000, 5000), 'legary_dobor' => 'reczny', 'legar_przekroj' => '50x100', 'izolacja_podlogi' => 150)
Testy.sprawdz(podp?(pl, 'blad', 'niższy niż izolacja'), 'błąd: legar niższy niż izolacja')

Testy.grupa('Rozstaw podpór z parametru')
pl = plan_pelny(prostokat(0, 0, 6000, 5000), 'podpory_rozstaw_max' => 1500)
pr = Podloga.przesla(Podloga.uklad(pl[:sciany], pl[:parametry]))
oczek = pr.map { |a, c| ((c - a) / 1500.0 - 1e-9).ceil - 1 }.inject(0) { |s2, n| s2 + n }
Testy.rowne(pl[:podloga][:podpory], oczek, 'podpory co ≤ 1500')

Testy.grupa('Działowe – podwaliny i legary dzielone')
seg = prostokat(0, 0, 6000, 4000) + [[[3000, 0], [3000, 4000]], [[0, 2000], [3000, 2000]]]
pl = plan_pelny(seg, 'legary_kierunek' => 'x')
pw = el(pl, 'Pw')
Testy.rowne(pw.length, 4 + 2, 'podwaliny: 4 zewnętrzne + 2 działowe')
lg = el(pl, 'L')
Testy.sprawdz(lg.all? { |e| e[:polozenie][:x][0].abs > 0.99 }, 'legary wzdłuż X')
Testy.sprawdz(lg.all? { |e| e[:dl] <= 2850.0 + 0.01 }, 'legary przerwane na podwalinie działowej poprzecznej')
dz_y = 2000.0
Testy.sprawdz(lg.none? { |e| e[:polozenie][:poczatek][0] < 3000 && (e[:polozenie][:poczatek][1] + e[:b] / 2.0 - dz_y).abs < 75.0 },
              'brak legara na podwalinie działowej wzdłuż')
Testy.sprawdz(Podloga.przesla(Podloga.uklad(pl[:sciany], pl[:parametry])).length == 2, 'dwa przęsła (działowa na całą szerokość)')

Testy.grupa('Kierunek legarów i wyłączenie podłogi')
pl = plan_pelny(prostokat(0, 0, 4000, 3000), 'legary_kierunek' => 'dluzszy')
Testy.sprawdz(el(pl, 'L').all? { |e| e[:polozenie][:x][0].abs > 0.99 }, 'wzdłuż dłuższego boku (X)')
pl = plan_pelny(prostokat(0, 0, 4000, 3000), 'podloga' => 'nie')
Testy.rowne(pl[:elementy].count { |e| %w[Pw L Pd].include?(e[:prefiks]) }, 0, 'podłoga wyłączona')
pl = plan_pelny(wielokat([[0, 0], [8000, 0], [8000, 4000], [4000, 4000], [4000, 7000], [0, 7000]]))
Testy.sprawdz(podp?(pl, 'uwaga', 'tylko dla obrysu prostokątnego'), 'obrys L – podpowiedź, bez podłogi')

Testy.grupa('Pozycje belek i siatki')
pl = plan_pelny(prostokat(0, 0, 6000, 4000) + [[[3000, 0], [3000, 4000]]])
pe = pl[:pozycje_elementow]
Testy.rowne(pe.first[:nr], pl[:pozycje].length + 1, 'numery belek po balach')
Testy.rowne(pe.map { |x| x[:nazwa] }.uniq.length, pe.length, 'nazwy pozycji jednoznaczne')
Testy.rowne(pe.map { |x| x[:ilosc] }.inject(0) { |a, b| a + b }, pl[:elementy].length, 'każda belka w pozycji')
zle = pe.count do |poz|
  k = Siatka.sprawdz(Siatka.uprosc(Projekt.siatka_pozycji(poz)[:sciany]))
  v = Bryla.objetosc(Bryla.profil(poz[:dl], poz[:t], poz[:h], poz[:cechy]))
  !(k[:zamknieta] && (k[:objetosc] - v).abs <= v * 1e-9 + 1e-3)
end
Testy.rowne(zle, 0, 'siatki belek zamknięte (podwaliny z zakładem)')
Testy.sprawdz(pl[:podsumowanie][:lista].any? { |x| x[:prefiks] == 'L' }, 'legary na liście zamówienia')

Testy.koniec
