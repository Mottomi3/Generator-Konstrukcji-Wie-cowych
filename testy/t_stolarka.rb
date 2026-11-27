# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_stolarka.rb
# Zadanie: lista typowej stolarki (pole-tabela standardu), dawne pola nowego okna i drzwi, modele okien i drzwi wstawiane w otwory (rdzeń i atrapa SketchUpa), działowe w domu z wymiarów (runda 17).
# Tematy: test listy stolarki, test pola tabeli, test dawnych pól okna i drzwi, test modeli stolarki, test prostego modelu stolarki, test wyboru ścieżki, test przełącznika doboru w typie, test położenia modelu w otworze, test brakującego modelu, test działowych domu z wymiarów
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
par = { 'stolarka' => lista, 'stolarka_folder' => folder, 'liczba_wiencow' => 14, 'luz_boczny' => 10, 'stolarka_prosta' => 'nie' }
pn = Parametry.normalizuj(par)[0]
Testy.rowne(StolarkaModele.plik(pn, StolarkaModele.wiersz(pn, 'o1')), File.join(folder, 'O1.skp'), 'plik modelu: symbol + .skp (wielkość liter bez znaczenia)')
Testy.rowne(StolarkaModele.plik(pn, StolarkaModele.wiersz(pn, 'D1')), File.join(folder, 'drzwi 930.skp'), 'plik modelu z kolumny „Model”')
Testy.sprawdz(StolarkaModele.plik(Parametry.normalizuj({})[0], StolarkaModele.wiersz(pn, 'O1')).nil?, 'bez folderu modeli – bez modelu')
pelna = 'C:\\Modele\\okno 600.skp'
Testy.rowne(StolarkaModele.plik(Parametry.normalizuj({})[0], 'symbol' => 'O5', 'model' => pelna), pelna,
            'pełna ścieżka w kolumnie „Model” – bez folderu modeli')
Testy.rowne(StolarkaModele.plik(pn, 'symbol' => 'O5', 'model' => '/mnt/modele/o5'), '/mnt/modele/o5.skp', 'pełna ścieżka bez .skp – dopisane rozszerzenie')
seg = prostokat(0, 0, 6000, 4000)
otw = [{ 'sciana' => 'W-1', 'od' => '1000', 'szerokosc' => '1020', 'wysokosc' => '1010', 'parapet' => '900', 'typ' => 'O1' },
       { 'sciana' => 'W-2', 'od' => '800', 'szerokosc' => '930', 'wysokosc' => '2100', 'parapet' => '0', 'typ' => 'D1' },
       { 'sciana' => 'W-3', 'od' => '1500', 'szerokosc' => '600', 'wysokosc' => '600', 'parapet' => '1200', 'typ' => 'O9' },
       { 'sciana' => 'W-4', 'od' => '1000', 'szerokosc' => '700', 'wysokosc' => '700', 'parapet' => '1200' }]
plan = Projekt.oblicz('segmenty' => seg, 'parametry' => par, 'otwory' => otw)
Testy.sprawdz(plan[:bledy].empty?, 'dom z otworami z typami liczy się bez błędów')
mod = StolarkaModele.do_wstawienia(plan)
Testy.rowne(mod.map { |x| [x[:sciana], x[:typ]] }, [%w[W-1 O1], %w[W-2 D1], %w[W-3 O9]], 'bez prostego modelu: modele dla otworów z typem (bez typu – bez modelu)')
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
Testy.sprawdz(zb[:stolarka][:uwagi].any? { |u| u.include?('O9') && u.include?('brak pliku') && u.include?('sam otwór') }, 'brakujący plik O9 – uwaga, został sam otwór')
pt = inst.find { |i| i.definition.name == 'O1' }.transformation.origin
Testy.rowne([pt.x * 25.4, pt.y * 25.4, pt.z * 25.4].map { |v| v.round(1) }, o1[:polozenie][:poczatek].map { |v| v.round(1) },
            'model O1 w punkcie z rdzenia')
plan_bez = Projekt.oblicz('segmenty' => seg, 'parametry' => par.merge('stolarka_folder' => ''), 'otwory' => otw)
zb2 = Budowa.zbuduj(m, plan_bez, { 'segmenty' => seg, 'parametry' => par, 'otwory' => otw }, zb[:grupa])
Testy.sprawdz(zb2[:grupa].entities.to_a.none? { |e| e.is_a?(Sketchup::Group) && e.name == 'Stolarka' }, 'bez folderu modeli – bez grupy „Stolarka”')

Testy.grupa('Prosty model okna i drzwi z generatora (runda 18)')
pp = Parametry.normalizuj({})[0]
Testy.rowne(pp['stolarka_prosta'], 'tak', 'fabrycznie: bez pliku – prosty model')
Testy.rowne(Poziomy.poziom('stolarka_prosta'), 'standard', 'przełącznik prostego modelu w standardzie warsztatu')
ok_cz = StolarkaProsta.czesci('okno', 1020.0, 1010.0, 44.0, pp)
dr_cz = StolarkaProsta.czesci('drzwi', 930.0, 2100.0, 44.0, pp)
Testy.rowne(ok_cz.length, 9, 'okno: rama 4, szyba, maskownice 4')
Testy.rowne(dr_cz.length, 7, 'drzwi: rama 3 (bez progu), skrzydło, maskownice 3')
rama = ok_cz.select { |c| c[:nazwa].start_with?('Rama') }
Testy.sprawdz(rama.all? { |c| c[:min][1].abs < 1e-9 && (c[:max][1] - 44.0).abs < 1e-9 }, 'rama na całą grubość ściany (y od 0 do 44)')
Testy.sprawdz(rama.all? { |c| c[:min][0] >= -1e-9 && c[:max][0] <= 1020.0 + 1e-9 && c[:min][2] >= -1e-9 && c[:max][2] <= 1010.0 + 1e-9 },
              'rama w wymiarach stolarki')
mask = ok_cz.select { |c| c[:nazwa].start_with?('Maskownica') }
Testy.sprawdz(mask.all? { |c| (c[:max][1]).abs < 1e-9 && (c[:min][1] + 20.0).abs < 1e-9 }, 'maskownice na licu zewnętrznym (y od −20 do 0)')
gora = mask.find { |c| c[:nazwa].include?('góra') }
Testy.rowne([gora[:min][0], gora[:max][0], gora[:min][2], gora[:max][2]], [-80.0, 1100.0, 995.0, 1090.0],
            'maskownica górna zachodzi 15 mm na ramę i wystaje 80 mm poza stolarkę')
Testy.sprawdz(ok_cz.count { |c| c[:szyba] } == 1 && dr_cz.none? { |c| c[:szyba] }, 'szyba tylko w oknie')
skr = dr_cz.find { |c| c[:nazwa] == 'Skrzydło' }
Testy.sprawdz(skr[:min][2] > 0 && skr[:max][2] < 2100.0 - 68.0, 'skrzydło drzwi od podłogi do ramy górnej (z luzem)')
Testy.rowne(StolarkaProsta.czesci('okno', 1020.0, 1010.0, 44.0, pp.merge('maskownica_szerokosc' => 0.0)).length, 5, 'maskownica 0 – bez maskownic')
ok_s = (ok_cz + dr_cz).all? { |c| k = Siatka.sprawdz(StolarkaProsta.siatka(c)); k[:zamknieta] && k[:objetosc] > 0 }
Testy.sprawdz(ok_s, 'siatki części zamknięte, ściany na zewnątrz (Siatka.sprawdz)')
plan_p = Projekt.oblicz('segmenty' => seg, 'parametry' => par.merge('stolarka_prosta' => 'tak'), 'otwory' => otw)
mod_p = StolarkaModele.do_wstawienia(plan_p)
Testy.rowne(mod_p.map { |x| [x[:sciana], x[:typ], x[:rodzaj], x[:plik].nil?] },
            [['W-1', 'O1', 'okno', false], ['W-2', 'D1', 'drzwi', false], ['W-3', 'O9', 'okno', false], ['W-4', '', 'okno', true]],
            'każdy otwór dostaje model: z pliku albo prosty (otwór bez typu – okno, bo nie zaczyna się na spodzie)')
m3 = Sketchup::Model.new
Sketchup.model = m3
zb3 = Budowa.zbuduj(m3, plan_p, 'segmenty' => seg, 'parametry' => par, 'otwory' => otw)
g3 = zb3[:grupa].entities.to_a.find { |e| e.is_a?(Sketchup::Group) && e.name == 'Stolarka' }
n3 = g3.entities.to_a.select { |e| e.is_a?(Sketchup::ComponentInstance) }.map { |i| i.definition.name }.sort
Testy.rowne(n3, ['O1', 'Okno 600 × 600 (prosty model)', 'Okno 700 × 700 (prosty model)', 'drzwi 930'],
            'pliki O1 i D1, prosty model dla brakującego O9 i otworu bez typu')
Testy.rowne([zb3[:stolarka][:wstawione], zb3[:stolarka][:proste]], [2, 2], 'w wyniku: z plików 2, proste 2')
Testy.sprawdz(zb3[:stolarka][:uwagi].any? { |u| u.include?('O9') && u.include?('prosty model') }, 'brak pliku O9 – uwaga, wstawiony prosty model')
dp = m3.definitions.to_a.find { |d| d.name == 'Okno 700 × 700 (prosty model)' }
Testy.rowne(dp.get_attribute(Atrybuty::DICT_AM, 'rola'), 'skip', 'prosty model z rolą „skip” dla Dokumentacji 2D (nie drewno)')
Testy.rowne(dp.entities.to_a.count { |e| e.is_a?(Sketchup::Group) }, 9, 'prosty model: każda część w swojej grupie')
plan_x = Projekt.oblicz('segmenty' => seg, 'parametry' => par.merge('stolarka_prosta' => 'tak', 'stolarka_folder' => ''), 'otwory' => otw)
zb4 = Budowa.zbuduj(m3, plan_x, { 'segmenty' => seg, 'parametry' => par, 'otwory' => otw }, zb3[:grupa])
Testy.rowne([zb4[:stolarka][:wstawione], zb4[:stolarka][:proste], zb4[:stolarka][:uwagi]], [0, 4, []],
            'bez folderu modeli – same proste modele, bez uwag')
Testy.sprawdz(m3.definitions.to_a.none? { |d| d.name == 'Okno 700 × 700 (prosty model)' && d.count_instances.zero? },
              'przebudowa usuwa nieużywane definicje prostego modelu')

Testy.grupa('Wybór ścieżki z okna (folder i plik modelu)')
Testy.rowne(OknoSciezki.katalog_startowy(folder), folder, 'folder z pola – okno wyboru zaczyna w nim')
Testy.rowne(OknoSciezki.katalog_startowy(File.join(folder, 'O1.skp')), folder, 'plik z pola – okno wyboru w jego folderze')
Testy.sprawdz(OknoSciezki.katalog_startowy('').nil? && OknoSciezki.katalog_startowy('Q:\\nie ma\\x.skp').nil?, 'puste albo nieistniejące – bez folderu startowego')
module ::UI
  def self.select_directory(o = {})
    @ostatnie = [:folder, o]
    'C:\\Stolarka'
  end

  def self.openpanel(*a)
    @ostatnie = [:plik, a]
    nil
  end

  def self.ostatnie
    @ostatnie
  end
end
Testy.rowne(OknoSciezki.wybierz('rodzaj' => 'folder', 'poczatek' => folder), 'C:\\Stolarka', 'wybór folderu – UI.select_directory')
Testy.rowne(UI.ostatnie[1][:directory], folder, 'okno wyboru folderu zaczyna w folderze z pola')
Testy.rowne(OknoSciezki.wybierz('rodzaj' => 'plik', 'poczatek' => ''), '', 'wybór pliku anulowany – pusta ścieżka')
Testy.sprawdz(UI.ostatnie[0] == :plik && UI.ostatnie[1][2].include?('*.skp'), 'wybór pliku – UI.openpanel z filtrem .skp')
Testy.rowne(Okno.opisy_pol.find { |o| o['klucz'] == 'stolarka_folder' }['sciezka'], 'folder', 'pole folderu modeli z przyciskiem wyboru')
Testy.rowne(Okno.opisy_pol.find { |o| o['klucz'] == 'stolarka' }['kolumny'].last['rodzaj'], 'plik', 'kolumna „Model” – ścieżka pliku z przyciskiem')

Testy.grupa('Przełącznik doboru przekrojów według typu domu (odpowiedź 6 z rundy 17)')
Testy.rowne(Poziomy.poziom('przekroje_dobor'), 'typ', 'przełącznik doboru – pole typu domu')
Testy.rowne(Parametry.normalizuj({})[0]['przekroje_dobor'], 'reczny', 'fabrycznie (bez typu) – podaję sam')
typy_p = ParametryLista::SZABLONY.select { |n, _p| n.start_with?('Typ ') }.map { |n, pa| [n[0, 7], pa['przekroje_dobor'] || 'reczny'] }
Testy.rowne(typy_p, [['Typ 100', 'reczny'], ['Typ 200', 'reczny'], ['Typ 300', 'auto'], ['Typ 400', 'auto']],
            'Typ 100 i 200 – podaję sam, Typ 300 i 400 – automatycznie')

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
