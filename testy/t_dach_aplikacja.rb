# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_dach_aplikacja.rb
# Zadanie: dach z aplikacji do dachów w modelu (atrapa SketchUpa i aplikacji) – połacie po budowie domu, ustawienia KROKU 1 i 2, okno KROKU 2 z licznika, przebudowa (poprzednie połacie i więźba), brak aplikacji, odmowa aplikacji, inny kontekst, dom obrócony i odbity.
# Tematy: testy aplikacji do dachów, połacie w modelu, KROK 2 z generatora, przebudowa połaci, więźba przy przebudowie, brak aplikacji do dachów, jedno Cofnij dla domu i połaci
# Zależy od: testy/atrapa/sketchup.rb, testy/atrapa/aplikacja_dachow.rb, testy/pomoc.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_dach_aplikacja.rb

require 'json'
require 'tmpdir'
require 'fileutils'
ENV['AM_GW_USTAWIENIA'] = File.join(Dir.tmpdir, "am_gw_test_dach_#{Process.pid}")
FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
require File.expand_path('atrapa/sketchup', File.dirname(__FILE__))
require File.expand_path('atrapa/aplikacja_dachow', File.dirname(__FILE__))
require File.expand_path('pomoc', File.dirname(__FILE__))
require File.join(File.dirname(KATALOG_WTYCZKI), 'arte_madera_generator_wiencowy.rb')
require File.join(KATALOG_WTYCZKI, 'main.rb')
include ArteMadera::GeneratorWiencowy

CAL = 25.4

def model_z_liniami(odcinki, z0 = 0.0)
  Sketchup.model = Sketchup::Model.new
  m = Sketchup.active_model
  odcinki.each do |a, b|
    e = m.entities.add_line(Geom::Point3d.new(a[0] / CAL, a[1] / CAL, z0 / CAL), Geom::Point3d.new(b[0] / CAL, b[1] / CAL, z0 / CAL))
    m.selection.add(e)
  end
  m
end

def ostatni_wynik(dlg)
  js = dlg.skrypty.reverse.find { |s| s.start_with?('AMGW.wynik(') }
  js ? JSON.parse(js.sub(/\AAMGW\.wynik\(/, '').sub(/\)\z/, '')) : nil
end

# Nowy dom z linii (albo edycja zaznaczonego domu) i generowanie z parametrami; wynik okna.
def generuj(parametry)
  Sterowanie.start
  dlg = Okno.dialog
  dlg.wywolaj('gotowe')
  dlg.wywolaj('generuj', JSON.generate('parametry' => parametry, 'otwory' => []))
  ostatni_wynik(dlg)
end

def polacie(m)
  m.entities.grep(Sketchup::Group).select { |g| g.name == 'Dach - polacie' }
end

# Grupa „Wiezba dachowa” (jak z KROKU 2) z jedną ścianą nad prostokątem x0…x1 × y0…y1 [mm] na wysokości z [mm].
def wiezba(m, x0, y0, x1, y1, z)
  g = m.entities.add_group
  g.name = 'Wiezba dachowa'
  g.entities.add_face([[x0, y0], [x1, y0], [x1, y1], [x0, y1]].map { |x, y| Geom::Point3d.new(x / CAL, y / CAL, z / CAL) })
  g
end

def pole_ze_znakiem(pts)
  s = 0.0
  pts.each_with_index { |a, i| b = pts[(i + 1) % pts.length]; s += a[0] * b[1] - b[0] * a[1] }
  s / 2.0
end

Testy.grupa('Nowy dom z krokwiami – połacie z aplikacji i okno KROKU 2')
AtrapaDachow.wyczysc
m = model_z_liniami(prostokat(0, 0, 5000, 4000), 300.0)
w = generuj('dach_uklad' => 'krokwie')
dom = Sterowanie.dom
pl = Sterowanie.plan
Testy.sprawdz(w['zbudowano'], 'dom zbudowany')
Testy.sprawdz(w['dach'] && w['dach']['ok'] && w['dach']['tekst'].include?('KROKU 2'), "komunikat o dachu (#{w['dach'].inspect})")
pg = polacie(m)
Testy.rowne(pg.length, 1, 'jedna grupa połaci obok domu')
Testy.rowne(pg[0].get_attribute('ArteMadera_GW', 'polacie_domu'), Atrybuty.dom_id(dom), 'połacie oznaczone id domu')
_, fp, ust = AtrapaDachow.ostatnie(:generate)
oczek = pl[:polacie][:punkty].map { |x, y| [x / CAL, y / CAL] }
Testy.sprawdz(fp.points_2d.zip(oczek).all? { |a, b| (a[0] - b[0]).abs < 1e-9 && (a[1] - b[1]).abs < 1e-9 }, 'obrys w calach układu modelu')
Testy.rowne(fp.base_z * CAL, pl[:polacie][:z] + 300.0, 'wysokość obrysu: linia podparcia nad poziomem linii 300', 1e-6)
Testy.rowne(fp.source, nil, 'bez ściany bazowej (obrys z planu)')
Testy.rowne([ust[:angle_deg], ust[:overhang_mm], ust[:gable_edges], ust[:edge_angles], ust[:keep_base_face], ust[:make_group]],
            [20.0, 500.0, '2,4', '', true, true], 'ustawienia KROKU 1: kąt, okap, krawędzie szczytowe')
fr = AtrapaDachow.framing
Testy.rowne([fr[:build_dir], fr[:ridge_on], fr[:seat_on], fr[:rafter_on], fr[:rafter_mode]], ['up', false, false, true, 'max'],
            'KROK 2: w górę od połaci, bez płatwi kalenicowej i zamków dolnych')
Testy.rowne([fr[:rafter_w_mm], fr[:rafter_h_mm], fr[:rafter_spacing_mm], fr[:timber_class], fr[:check_on]], [50.0, 150.0, 900.0, 'C24', true],
            'KROK 2: krokiew, rozstaw i klasa drewna z generatora, kontrola nośności')
Testy.sprawdz(m.selection.to_a == pg, 'zaznaczone połacie (dla KROKU 2)')
Testy.sprawdz(AtrapaDachow.ostatnie(:generate_framing).nil?, 'KROK 2 dopiero po zakończeniu wywołania z okna')
Testy.rowne(m.operacje.map(&:first), [:start, :commit, :start, :commit], 'dom i połacie – dwie operacje')
Testy.rowne(m.operacje[2], [:start, 'ArteMadera – połacie dachu', :dolaczona], 'połacie dołączone do budowy domu (jedno Cofnij)')
Testy.rowne(UI.uruchom_liczniki, 1, 'jeden licznik')
kr = AtrapaDachow.ostatnie(:generate_framing)
Testy.sprawdz(kr && kr[1] == pg, 'KROK 2 otwarty na zaznaczonych połaciach')
Testy.sprawdz(UI.zatrzymane.include?(1), 'licznik zatrzymany na starcie (bez powtórzeń)')
Testy.sprawdz(dom.entities.to_a.none? { |g| g.respond_to?(:name) && g.name == 'Dach - polacie' }, 'połacie poza grupą domu (podpis domu bez zmian)')
Testy.sprawdz(!Atrybuty.zmieniony_recznie?(dom), 'dom nie wygląda na zmieniony ręcznie')

Testy.grupa('Przebudowa – poprzednie połacie znikają, więźba nad nimi po potwierdzeniu')
stary_id = Atrybuty.dom_id(dom)
nad = wiezba(m, -500, -500, 5500, 4500, 3200)
obok = wiezba(m, 20_000, 0, 25_000, 4000, 3200)
UI.komunikaty.clear
UI.odpowiedz = IDYES
m.selection.clear
m.selection.add(dom)
w = generuj('dach_uklad' => 'krokwie', 'dach_kat' => '30')
Testy.sprawdz(w['dach'] && w['dach']['ok'], 'połacie nowej wersji')
Testy.sprawdz(!pg[0].valid?, 'poprzednie połacie usunięte')
pg2 = polacie(m)
Testy.rowne(pg2.length, 1, 'jedna grupa połaci')
Testy.sprawdz(pg2[0].get_attribute('ArteMadera_GW', 'polacie_domu') == Atrybuty.dom_id(Sterowanie.dom) &&
              Atrybuty.dom_id(Sterowanie.dom) != stary_id, 'połacie z id nowej wersji domu')
Testy.sprawdz(UI.komunikaty.any? { |k| k.include?('więźba z aplikacji do dachów (1)') }, 'pytanie o więźbę nad domem')
Testy.sprawdz(!nad.valid? && obok.valid?, 'więźba nad domem usunięta, więźba obok zostaje')
Testy.rowne(AtrapaDachow.ostatnie(:generate)[2][:angle_deg], 30.0, 'nowy kąt w KROKU 1')
UI.uruchom_liczniki

Testy.grupa('Przebudowa – odpowiedź „Nie”: więźba zostaje')
nad = wiezba(m, -500, -500, 5500, 4500, 3200)
UI.odpowiedz = IDNO
m.selection.clear
m.selection.add(Sterowanie.dom)
w = generuj('dach_uklad' => 'krokwie')
UI.odpowiedz = IDYES
Testy.sprawdz(w['dach']['ok'] && nad.valid?, 'więźba zostaje, połacie nowe')
Testy.rowne(polacie(m).length, 1, 'jedna grupa połaci')
UI.uruchom_liczniki

Testy.grupa('Krokwie z generatora – poprzednie połacie usunięte, krokwie w grupie Dach')
nad.erase!
m.selection.clear
m.selection.add(Sterowanie.dom)
w = generuj('dach_uklad' => 'krokwie', 'dach_wiezba' => 'generator')
Testy.rowne(w['dach'], { 'tekst' => 'Poprzednie połacie dachu usunięte.', 'ok' => true }, 'komunikat o usunięciu połaci')
Testy.rowne(polacie(m).length, 0, 'bez połaci')
dach = Sterowanie.dom.entities.to_a.find { |g| g.is_a?(Sketchup::Group) && g.name == 'Dach' }
k = dach.entities.to_a.count { |i| i.definition.get_attribute('ArteMadera', 'prefiks') == 'K' }
Testy.sprawdz(k > 0, "krokwie generatora w grupie Dach (#{k})")
Testy.rowne(UI.liczniki.length, 0, 'bez okna KROKU 2')
m.selection.clear
m.selection.add(Sterowanie.dom)
w = generuj('dach_uklad' => 'krokwie', 'dach_wiezba' => 'generator')
Testy.rowne(w['dach'], nil, 'dom bez połaci przed i po – bez komunikatu o dachu')

Testy.grupa('Bez aplikacji do dachów i odmowa aplikacji')
roof = ArteMadera::Roof
ArteMadera.send(:remove_const, :Roof)
m = model_z_liniami(prostokat(0, 0, 5000, 4000))
w = generuj('dach_uklad' => 'krokwie')
ArteMadera.const_set(:Roof, roof)
Testy.sprawdz(w['zbudowano'] && !w['dach']['ok'] && w['dach']['tekst'].include?('nie jest wczytana'), "brak aplikacji – komunikat (#{w['dach'].inspect})")
Testy.rowne(polacie(m).length, 0, 'bez połaci')
AtrapaDachow.blad = 'Okap jest zbyt duzy - obrys po odsunieciu zanika.'
m = model_z_liniami(prostokat(0, 0, 5000, 4000))
w = generuj('dach_uklad' => 'krokwie')
AtrapaDachow.blad = nil
Testy.sprawdz(!w['dach']['ok'] && w['dach']['tekst'].include?('Okap jest zbyt duzy'), 'odmowa aplikacji – jej komunikat')
Testy.rowne([polacie(m).length, UI.liczniki.length], [0, 0], 'bez połaci i bez KROKU 2')

Testy.grupa('Dom w innej grupie niż otwarta do edycji')
m = model_z_liniami(prostokat(0, 0, 5000, 4000))
generuj('dach_uklad' => 'krokwie')
UI.uruchom_liczniki
inna = m.entities.add_group
m.define_singleton_method(:active_entities) { inna.entities }
m.selection.clear
m.selection.add(Sterowanie.dom)
w = generuj('dach_uklad' => 'krokwie')
m.singleton_class.send(:remove_method, :active_entities)
Testy.sprawdz(!w['dach']['ok'] && w['dach']['tekst'].include?('innej grupie'), 'komunikat o innym kontekście')
Testy.rowne([polacie(m).length, inna.entities.length], [0, 0], 'bez połaci w złym miejscu')

Testy.grupa('Dom obrócony o 30° i dom odbity')
AtrapaDachow.wyczysc
m = model_z_liniami(obroc_odcinki(prostokat(0, 0, 6000, 4000), 30))
w = generuj('dach_uklad' => 'platwie_krokwie')
pl = Sterowanie.plan
_, fp, ust = AtrapaDachow.ostatnie(:generate)
tr = Sterowanie.dom.transformation
oczek = pl[:polacie][:punkty].map { |x, y| q = Geom::Point3d.new(x / CAL, y / CAL, 0).transform(tr); [q.x, q.y] }
Testy.sprawdz(w['dach']['ok'] && fp.points_2d.zip(oczek).all? { |a, b| (a[0] - b[0]).abs < 1e-6 && (a[1] - b[1]).abs < 1e-6 },
              'obrys obrócony z domem')
Testy.sprawdz(pole_ze_znakiem(fp.points_2d) > 0, 'obrys przeciwnie do wskazówek zegara')
naroz = lambda { |pts, nr| [pts[nr - 1], pts[nr % pts.length]].map { |x, y| [x.round(6), y.round(6)] }.sort }
sz = ust[:gable_edges].split(',').map(&:to_i)
Testy.rowne(sz.map { |k| naroz.call(fp.points_2d, k) }.sort, pl[:polacie][:szczyty].map { |k| naroz.call(oczek, k) }.sort,
            'krawędzie szczytowe te same')
UI.uruchom_liczniki
obrys = [[0.0, 0.0], [0.0, 100.0], [50.0, 150.0], [200.0, 100.0], [200.0, 0.0]]
odw, sz2 = DachAplikacja.przeciwnie_do_zegara(obrys, [1, 3])
Testy.sprawdz(pole_ze_znakiem(odw) > 0, 'odbity: obrys odwrócony')
Testy.rowne(sz2.map { |k| naroz.call(odw, k) }.sort, [1, 3].map { |k| naroz.call(obrys, k) }.sort, 'odbity: te same krawędzie szczytowe')

Testy.koniec
