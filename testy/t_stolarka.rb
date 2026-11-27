# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_stolarka.rb
# Zadanie: lista typowej stolarki (pole-tabela standardu), dawne pola nowego okna i drzwi, modele okien i drzwi wstawiane w otwory (rdzeń i atrapa SketchUpa), działowe w domu z wymiarów (runda 17).
# Tematy: test listy stolarki, test pola tabeli, test dawnych pól okna i drzwi, test modeli stolarki, test położenia modelu w otworze, test brakującego modelu, test działowych domu z wymiarów
# Zależy od: testy/atrapa/sketchup.rb, testy/pomoc.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_stolarka.rb

require 'json'
require 'tmpdir'
require 'fileutils'
ENV['AM_GW_USTAWIENIA'] = File.join(Dir.tmpdir, "am_gw_stolarka_#{Process.pid}")
FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
require File.expand_path('atrapa/sketchup', File.dirname(__FILE__))
require File.expand_path('pomoc', File.dirname(__FILE__))
require File.join(File.dirname(KATALOG_WTYCZKI), 'arte_madera_generator_wiencowy.rb')
require File.join(KATALOG_WTYCZKI, 'main.rb')
include ArteMadera::GeneratorWiencowy

Testy.grupa('Lista typowej stolarki – pole-tabela standardu')
p0 = Parametry.normalizuj({})[0]
Testy.rowne(p0['stolarka'].map { |r| [r['symbol'], r['rodzaj'], r['szerokosc'], r['wysokosc'], r['spod']] },
            [['O1', 'okno', 1020.0, 1010.0, 900.0], ['D1', 'drzwi', 930.0, 2100.0, 0.0]], 'lista fabryczna: O1 1020 × 1010, D1 930 × 2100')
Testy.sprawdz(ParametryLista.wpis('okno_szerokosc').nil? && ParametryLista.wpis('drzwi_wysokosc').nil?, 'sześć pól „Nowe okno / nowe drzwi” zastąpione listą')
Testy.rowne(Poziomy.poziom('stolarka'), 'standard', 'lista stolarki w standardzie warsztatu')
z_okna = JSON.generate([{ 'symbol' => 'O5', 'rodzaj' => 'okno', 'szerokosc' => '600', 'wysokosc' => '600,5', 'spod' => '1300', 'model' => 'okno 600.skp' },
                        { 'symbol' => '', 'rodzaj' => 'okno', 'szerokosc' => '', 'wysokosc' => '', 'spod' => '', 'model' => '' },
                        { 'symbol' => 'X', 'rodzaj' => 'balkon', 'szerokosc' => '800' }])
p1, u1 = Parametry.normalizuj('stolarka' => z_okna)
Testy.rowne(p1['stolarka'].length, 2, 'tabela z okna (tekst JSON): pusty wiersz pominięty')
Testy.rowne([p1['stolarka'][0]['wysokosc'], p1['stolarka'][0]['model'], p1['stolarka'][1]['rodzaj']], [600.5, 'okno 600.skp', 'okno'],
            'liczby z przecinkiem, nieznany rodzaj – pierwszy z listy')
Testy.sprawdz(u1.empty?, 'bez uwag dla poprawnej tabeli')
p2, u2 = Parametry.normalizuj('stolarka' => 'nie tabela')
Testy.sprawdz(p2['stolarka'] == p0['stolarka'] && u2.any? { |x| x.include?('niepoprawna tabela') }, 'niepoprawny tekst – lista fabryczna z uwagą')
Testy.rowne(Poziomy.rozne({ 'stolarka' => JSON.generate(p0['stolarka']) }, {}), [], 'ta sama lista jako tekst i jako tablica – bez różnicy')
Testy.rowne(Poziomy.rozne({ 'stolarka' => z_okna }, {}), ['stolarka'], 'inna lista – pole zmienione')

Testy.grupa('Dawne pola nowego okna i drzwi (do kompilacji 16) → lista stolarki')
p3 = Parametry.normalizuj('okno_szerokosc' => 1200.0, 'okno_parapet' => '850', 'drzwi_wysokosc' => 2050.0)[0]
Testy.rowne(p3['stolarka'].map { |r| [r['symbol'], r['szerokosc'], r['wysokosc'], r['spod']] },
            [['O1', 1200.0, 1010.0, 850.0], ['D1', 930.0, 2050.0, 0.0]], 'wartości dawnych pól w pozycjach O1 i D1')
p4 = Parametry.normalizuj('okno_szerokosc' => 1200.0, 'stolarka' => z_okna)[0]
Testy.rowne(p4['stolarka'][0]['symbol'], 'O5', 'lista już zapisana – dawne pola pominięte')

Testy.grupa('Modele stolarki – plik i położenie w otworze')
folder = File.join(ENV['AM_GW_USTAWIENIA'], 'modele')
FileUtils.mkdir_p(folder)
File.open(File.join(folder, 'O1.skp'), 'wb') { |f| f.write('atrapa') }
File.open(File.join(folder, 'drzwi 930.skp'), 'wb') { |f| f.write('atrapa') }
lista = [{ 'symbol' => 'O1', 'rodzaj' => 'okno', 'szerokosc' => 1020, 'wysokosc' => 1010, 'spod' => 900, 'model' => '' },
         { 'symbol' => 'D1', 'rodzaj' => 'drzwi', 'szerokosc' => 930, 'wysokosc' => 2100, 'spod' => 0, 'model' => 'drzwi 930' },
         { 'symbol' => 'O9', 'rodzaj' => 'okno', 'szerokosc' => 600, 'wysokosc' => 600, 'spod' => 1200, 'model' => '' }]
par = { 'stolarka' => lista, 'stolarka_folder' => folder, 'liczba_wiencow' => 14, 'luz_boczny' => 10 }
pn = Parametry.normalizuj(par)[0]
Testy.rowne(StolarkaModele.plik(pn, StolarkaModele.wiersz(pn, 'o1')), File.join(folder, 'O1.skp'), 'plik modelu: symbol + .skp (wielkość liter bez znaczenia)')
Testy.rowne(StolarkaModele.plik(pn, StolarkaModele.wiersz(pn, 'D1')), File.join(folder, 'drzwi 930.skp'), 'plik modelu z kolumny „Model”')
Testy.sprawdz(StolarkaModele.plik(Parametry.normalizuj({})[0], StolarkaModele.wiersz(pn, 'O1')).nil?, 'bez folderu modeli – bez modelu')
seg = prostokat(0, 0, 6000, 4000)
otw = [{ 'sciana' => 'W-1', 'od' => '1000', 'szerokosc' => '1020', 'wysokosc' => '1010', 'parapet' => '900', 'typ' => 'O1' },
       { 'sciana' => 'W-2', 'od' => '800', 'szerokosc' => '930', 'wysokosc' => '2100', 'parapet' => '0', 'typ' => 'D1' },
       { 'sciana' => 'W-3', 'od' => '1500', 'szerokosc' => '600', 'wysokosc' => '600', 'parapet' => '1200', 'typ' => 'O9' },
       { 'sciana' => 'W-4', 'od' => '1000', 'szerokosc' => '700', 'wysokosc' => '700', 'parapet' => '1200' }]
plan = Projekt.oblicz('segmenty' => seg, 'parametry' => par, 'otwory' => otw)
Testy.sprawdz(plan[:bledy].empty?, 'dom z otworami z typami liczy się bez błędów')
mod = StolarkaModele.do_wstawienia(plan)
Testy.rowne(mod.map { |x| [x[:sciana], x[:typ]] }, [%w[W-1 O1], %w[W-2 D1], %w[W-3 O9]], 'modele dla otworów z typem (bez typu – bez modelu)')
w1 = plan[:sciany].find { |w| w[:id] == 'W-1' }
o1 = mod[0]
st = w1[:otwory].find { |o| o[:typ] == 'O1' }[:stolarka]
t = Parametry.grubosc(plan[:parametry])
x_lico = w1[:a][0] + w1[:kier][0] * st[:s0] - w1[:nor][0] * t / 2.0
y_lico = w1[:a][1] + w1[:kier][1] * st[:s0] - w1[:nor][1] * t / 2.0
Testy.rowne(o1[:polozenie][:poczatek], [x_lico, y_lico, 900.0], 'punkt 0 modelu: lico zewnętrzne, lewy dolny narożnik stolarki')
Testy.rowne(o1[:polozenie][:y], [w1[:nor][0], w1[:nor][1], 0.0], 'oś Y modelu w głąb ściany (do środka domu)')
srodek = [3000.0, 2000.0]
wglab = [srodek[0] - o1[:polozenie][:poczatek][0], srodek[1] - o1[:polozenie][:poczatek][1]]
Testy.sprawdz(wglab[0] * o1[:polozenie][:y][0] + wglab[1] * o1[:polozenie][:y][1] > 0, 'oś Y modelu ściany zewnętrznej skierowana do środka domu')
Testy.rowne([o1[:szerokosc], o1[:wysokosc]], [1020.0, 1010.0], 'wymiary stolarki do porównania z modelem')

Testy.grupa('Modele stolarki w modelu SketchUpa (atrapa)')
Sketchup.model = Sketchup::Model.new
m = Sketchup.active_model
zb = Budowa.zbuduj(m, plan, 'segmenty' => seg, 'parametry' => par, 'otwory' => otw)
g = zb[:grupa].entities.to_a.find { |e| e.is_a?(Sketchup::Group) && e.name == 'Stolarka' }
inst = g ? g.entities.to_a.select { |e| e.is_a?(Sketchup::ComponentInstance) } : []
Testy.sprawdz(!g.nil? && g.layer.name == 'Stolarka', 'grupa „Stolarka” z tagiem Stolarka w domu')
Testy.rowne(inst.map { |i| i.definition.name }.sort, ['O1', 'drzwi 930'], 'wstawione modele O1 i D1 (jedna definicja na plik)')
Testy.rowne(zb[:stolarka][:wstawione], 2, 'liczba wstawionych modeli w wyniku budowy')
Testy.sprawdz(zb[:stolarka][:uwagi].any? { |u| u.include?('O9') && u.include?('brak pliku') }, 'brakujący plik O9 – uwaga, został sam otwór')
pt = inst.find { |i| i.definition.name == 'O1' }.transformation.origin
Testy.rowne([pt.x * 25.4, pt.y * 25.4, pt.z * 25.4].map { |v| v.round(1) }, o1[:polozenie][:poczatek].map { |v| v.round(1) },
            'model O1 w punkcie z rdzenia')
plan_bez = Projekt.oblicz('segmenty' => seg, 'parametry' => par.merge('stolarka_folder' => ''), 'otwory' => otw)
zb2 = Budowa.zbuduj(m, plan_bez, { 'segmenty' => seg, 'parametry' => par, 'otwory' => otw }, zb[:grupa])
Testy.sprawdz(zb2[:grupa].entities.to_a.none? { |e| e.is_a?(Sketchup::Group) && e.name == 'Stolarka' }, 'bez folderu modeli – bez grupy „Stolarka”')

Testy.grupa('Działowe w domu z wymiarów (tabela okna)')
dz = [{ 'kierunek' => 'poprzek', 'od' => '3000', 'poczatek' => '', 'dlugosc' => '' },
      { 'kierunek' => 'wzdluz', 'od' => '1500', 'poczatek' => '', 'dlugosc' => '3000' },
      { 'kierunek' => 'poprzek', 'od' => '7000' }, { 'kierunek' => 'wzdluz', 'od' => '' }]
segz = DomZWymiarow.segmenty({ 'dom_dlugosc' => 6000, 'dom_szerokosc' => 4000 }, dz)
Testy.rowne(segz.length, 6, 'obrys i dwie działowe (od poza domem albo puste – pominięte)')
Testy.rowne(segz[4], [[3000.0, 0.0], [3000.0, 4000.0]], 'działowa w poprzek – od lica do lica')
Testy.rowne(segz[5], [[0.0, 1500.0], [3000.0, 1500.0]], 'działowa wzdłuż z długością – wolny koniec')
pz = Projekt.oblicz('segmenty' => segz, 'parametry' => { 'dom_dlugosc' => 6000, 'dom_szerokosc' => 4000 }, 'otwory' => [])
Testy.rowne(pz[:sciany].count { |w| w[:rodzaj] == :dzialowa }, 2, 'dwie ściany działowe w planie')
m2 = Sketchup::Model.new
Sketchup.model = m2
Sterowanie.start
d0 = Okno.dane_startowe
Testy.sprawdz(d0['z_wymiarow'] && d0['dzialowe'] == [], 'nic nie zaznaczone – dom z wymiarów, pusta tabela działowych w oknie')
wyn = Sterowanie.podglad('parametry' => { 'dom_dlugosc' => '6000', 'dom_szerokosc' => '4000' }, 'otwory' => [], 'dzialowe' => dz[0, 1])
Testy.sprawdz(Sterowanie.plan[:sciany].count { |w| w[:rodzaj] == :dzialowa } == 1 && wyn['bledy'].empty?, 'podgląd z działową z tabeli okna')
Sterowanie.generuj('parametry' => { 'dom_dlugosc' => '6000', 'dom_szerokosc' => '4000' }, 'otwory' => [], 'dzialowe' => dz[0, 1])
zap = Atrybuty.czytaj_wejscie(Sterowanie.dom)
Testy.sprawdz(zap['z_wymiarow'] && zap['dzialowe'].length == 1 && zap['segmenty'].length == 5, 'działowe zapisane w domu (edycja domu z wymiarów)')
Okno.dialog.close if Okno.dialog

FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
Testy.koniec
