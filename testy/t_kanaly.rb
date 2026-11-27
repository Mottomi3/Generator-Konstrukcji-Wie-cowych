# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_kanaly.rb
# Zadanie: kanały na przewody (N3, runda 18) – przypisanie do ścian, pominięcie przy zamku, otwór pionowy w każdym balu ściany (bryła zamknięta z otworem, objętość), puszka na liście obróbek, kanał w widoku ściany, w pełnym profilu i w szczycie, zapis w domu (SketchUp na atrapie).
# Tematy: test kanałów na przewody, test otworu pionowego w balu, test puszki, test kanału przy zamku, test kanału w widoku ściany
# Zależy od: testy/losowe_domy.rb (sprawdzenie całego domu), testy/atrapa/sketchup.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_kanaly.rb

require 'tmpdir'
require 'fileutils'
ENV['AM_GW_USTAWIENIA'] = File.join(Dir.tmpdir, "am_gw_kanaly_#{Process.pid}")
FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
require File.expand_path('losowe_domy', File.dirname(__FILE__))
require File.join(File.dirname(KATALOG_WTYCZKI), 'arte_madera_generator_wiencowy.rb')
require File.join(KATALOG_WTYCZKI, 'main.rb')
include ArteMadera::GeneratorWiencowy

SEG = (prostokat(0, 0, 6000, 4000) + [[[3000, 0], [3000, 4000]]]).freeze
KAN = [{ 'sciana' => 'W-1', 'od' => '1500', 'srednica' => '', 'puszka' => '300' },
       { 'sciana' => 'W-1', 'od' => '20', 'srednica' => '25' },
       { 'sciana' => 'W-2', 'od' => '1700', 'srednica' => '30', 'puszka' => '' },
       { 'sciana' => 'W-9', 'od' => '500' }].freeze

Testy.grupa('Kanały – przypisanie do ścian')
pl = Projekt.oblicz('segmenty' => SEG, 'parametry' => {}, 'otwory' => [], 'kanaly' => KAN)
Testy.rowne(pl[:bledy], [], 'dom z kanałami bez błędów')
w1 = pl[:sciany].find { |w| w[:id] == 'W-1' }
w2 = pl[:sciany].find { |w| w[:id] == 'W-2' }
Testy.rowne(w1[:kanaly].map { |k| [k[:nazwa], k[:s].round, (k[:r] * 2).round, k[:puszka]] }, [['K1', 1478, 25, 300.0]],
            'K1 na W-1: oś od narożnika lica, średnica z parametru (25), puszka 300')
Testy.sprawdz(pl[:ostrzezenia].any? { |u| u.start_with?('Kanał K2 (W-1)') && u.include?('zamek') }, 'K2 przy narożniku – pominięty (trafiłby w zamek)')
Testy.sprawdz(pl[:ostrzezenia].any? { |u| u.start_with?('Kanał K4') && u.include?('W-9') }, 'K4 na nieistniejącej ścianie – pominięty')
Testy.rowne(w2[:kanaly].map { |k| [k[:nazwa], (k[:r] * 2).round, k[:puszka]] }, [['K3', 30, nil]], 'K3 na ścianie szczytowej, bez puszki')

Testy.grupa('Kanały – otwór pionowy w balach')
t = Parametry.grubosc(pl[:parametry])
z_k1 = w1[:bale].select { |b| b[:cechy].any? { |c| c[:typ] == 'kanal' } }
Testy.rowne(z_k1.map { |b| b[:wieniec][:nr] }.uniq.length, w1[:bale].map { |b| b[:wieniec][:nr] }.uniq.length, 'kanał przez wszystkie wieńce ściany')
c = z_k1.first[:cechy].find { |x| x[:typ] == 'kanal' }
Testy.rowne([c[:y0], c[:y1]], [t / 2.0 - 12.5, t / 2.0 + 12.5], 'otwór w osi grubości bala')
b = z_k1.first
prof = Bryla.profil(b[:dl], t, b[:h], b[:cechy])
kz = Siatka.sprawdz(Siatka.z_profilu(prof)[:sciany])
bez = Bryla.profil(b[:dl], t, b[:h], b[:cechy].reject { |x| x[:typ] == 'kanal' })
Testy.sprawdz(kz[:zamknieta] && (Bryla.objetosc(bez) - Bryla.objetosc(prof) - 25.0 * 25.0 * b[:h]).abs < 1.0,
              'bryła bala zamknięta, objętość mniejsza o otwór 25 × 25 × wysokość')
xk = 1478.0 - b[:s0]
Testy.sprawdz(!Bryla.zawiera?(prof, xk, t / 2.0, b[:h] / 2.0) && Bryla.zawiera?(prof, xk, 3.0, b[:h] / 2.0), 'w osi kanału pusto, przy licu drewno')
pu = w1[:bale].select { |x| x[:cechy].any? { |cc| cc[:typ] == 'puszka' } }
Testy.rowne(pu.length, 1, 'otwór puszki w jednym balu (na wysokości 300)')
Testy.sprawdz(pu.first[:z0] <= 300.0 && pu.first[:z0] + pu.first[:h] > 300.0, 'puszka w balu, w którym leży jej środek')
Testy.sprawdz(pl[:podpowiedzi].any? { |h| h[:tekst].start_with?('Kanały na przewody: 2') }, 'w wynikach – zdanie o kanałach')
z_k3 = w2[:bale].select { |x| x[:cechy].any? { |cc| cc[:typ] == 'kanal' } }
Testy.sprawdz(z_k3.any? { |x| x[:pozycja][:prefiks] == 'Sz' }, 'kanał w ścianie szczytowej idzie także przez bale szczytu')
poz_z = z_k1.map { |x| x[:pozycja][:nr] }.uniq
poz_bez = w1[:bale].reject { |x| x[:cechy].any? { |cc| cc[:typ] == 'kanal' } }.map { |x| x[:pozycja][:nr] }.uniq
Testy.sprawdz((poz_z & poz_bez).empty?, 'bal z otworem to osobna pozycja (inna niż bez otworu)')

Testy.grupa('Kanały – cały dom bez problemów (kolizje, bryły, połacie), pełny profil, widok ściany')
prob, = LosoweDomy.sprawdz(segmenty: SEG, parametry: {}, otwory: [], sciany: {}, kanaly: KAN)
Testy.rowne(prob, [], 'profil prosty')
prob, = LosoweDomy.sprawdz(segmenty: SEG, parametry: { 'profil_bala' => 'pelny', 'dach_kat' => 35 }, otwory: [], sciany: {}, kanaly: KAN)
Testy.rowne(prob, [], 'pełny profil, dach 35°')
wv = Widok.sciana(pl, 'W-1')
Testy.rowne(wv['kanaly'], [[1478.0, 25.0, 300.0, 'K1', 0, nil]], 'widok ściany: kanał [s, średnica, puszka, nazwa, wiersz, koniec pod oknem]')
Testy.rowne(Widok.sciana(pl, 'W-3')['kanaly'], [], 'ściana bez kanałów – pusta lista')

Testy.grupa('Kanały – strona puszki i kanał w miejscu okna (runda 19, zadanie_r18 §2)')
Testy.rowne(pu.first[:cechy].find { |x| x[:typ] == 'puszka' }[:strona], 1, 'puszka fabrycznie od lica lewego (wnętrze ściany zewnętrznej)')
KP = [{ 'sciana' => 'W-5', 'od' => '1500', 'puszka' => '300', 'strona' => 'prawa' }].freeze
pp = Projekt.oblicz('segmenty' => SEG, 'parametry' => {}, 'otwory' => [], 'kanaly' => KP)
w5 = pp[:sciany].find { |w| w[:id] == 'W-5' }
pu5 = w5[:bale].map { |x| x[:cechy].find { |cc| cc[:typ] == 'puszka' } }.compact
Testy.rowne([w5[:rodzaj], pu5.map { |x| x[:strona] }], [:dzialowa, [0]], 'działowa – puszka z prawej strony (−nor)')
OKNO = [{ 'sciana' => 'W-1', 'od' => '1000', 'szerokosc' => '1000', 'wysokosc' => '1000', 'parapet' => '900' }].freeze
KO = [{ 'sciana' => 'W-1', 'od' => '1500', 'puszka' => '300' }, { 'sciana' => 'W-1', 'od' => '1600', 'puszka' => '1200' }].freeze
po = Projekt.oblicz('segmenty' => SEG, 'parametry' => {}, 'otwory' => OKNO, 'kanaly' => KO)
w1o = po[:sciany].find { |w| w[:id] == 'W-1' }
o1 = w1o[:otwory].reject { |x| x[:gniazdo] }.first
zk = w1o[:bale].select { |x| x[:cechy].any? { |cc| cc[:typ] == 'kanal' } }
Testy.sprawdz(!zk.empty? && zk.all? { |x| x[:z0] < o1[:z0] - 0.01 } && w1o[:bale].any? { |x| x[:z0] > o1[:z1] && x[:s0] < 1478 && x[:s0] + x[:dl] > 1478 },
              format('kanał w miejscu okna – otwór tylko w balach pod oknem (do %.0f mm), bale nad oknem bez otworu', o1[:z0]))
Testy.sprawdz(po[:ostrzezenia].any? { |u| u.start_with?('Kanał K1 (W-1) trafia w otwór') }, 'uwaga o kanale pod oknem')
Testy.sprawdz(po[:ostrzezenia].any? { |u| u.start_with?('Kanał K2 (W-1): puszka 1200') } &&
              w1o[:bale].none? { |x| x[:cechy].any? { |cc| cc[:typ] == 'puszka' && x[:z0] > 1000 } }, 'puszka w otworze okna – pominięta')
Testy.rowne(Widok.sciana(po, 'W-1')['kanaly'].map { |k| k[5] && k[5].round }, [o1[:z0].round, o1[:z0].round], 'widok: kanał kończy się pod oknem')
prob, = LosoweDomy.sprawdz(segmenty: SEG, parametry: {}, otwory: OKNO, sciany: {}, kanaly: KO)
Testy.rowne(prob, [], 'dom z kanałem pod oknem – bez problemów')

Testy.grupa('Kanały w domu w SketchUpie (atrapa)')
Sketchup.model = Sketchup::Model.new
Sterowanie.start
Testy.rowne(Okno.dane_startowe['kanaly'], [], 'nowy dom – bez kanałów w oknie')
wyn = Sterowanie.generuj('parametry' => { 'dom_dlugosc' => '6000', 'dom_szerokosc' => '4000' }, 'otwory' => [], 'kanaly' => KAN[0, 1])
Testy.sprawdz(wyn['bledy'].empty?, 'dom z kanałem wygenerowany')
zap = Atrybuty.czytaj_wejscie(Sterowanie.dom)
Testy.rowne(zap['kanaly'], KAN[0, 1], 'kanały zapisane w domu (edycja domu je zachowa)')
Okno.dialog.close if Okno.dialog

FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
Testy.koniec
