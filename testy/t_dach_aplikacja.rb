# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_dach_aplikacja.rb
# Zadanie: dach z aplikacji do dachów w modelu (atrapa SketchUpa i API aplikacji) – połacie po budowie domu, podpory z płatwi, ustawienia KROKU 2, okno KROKU 2 z licznika, więźba po OK powiązana z domem, przebudowa (poprzednie połacie i więźba), same płatwie, brak i stara aplikacja, odmowa aplikacji, inny kontekst, dom obrócony.
# Tematy: testy aplikacji do dachów, testy API dachów, połacie w modelu, KROK 2 z generatora, podpory w modelu, więźba powiązana z domem, przebudowa połaci, więźba przy przebudowie, brak aplikacji do dachów, stara aplikacja do dachów, jedno Cofnij dla domu i połaci
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

Testy.grupa('Nowy dom z krokwiami – połacie z API, podpory z płatwi i okno KROKU 2')
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
_, pts, z, kat, okap, sz, opc = AtrapaDachow.ostatnie(:polacie)
oczek = pl[:polacie][:punkty].map { |x, y| [x / CAL, y / CAL] }
Testy.sprawdz(pts.all? { |q| q.is_a?(Geom::Point3d) } && pts.zip(oczek).all? { |a, b| (a.x - b[0]).abs < 1e-9 && (a.y - b[1]).abs < 1e-9 },
              'punkty obrysu: Geom::Point3d w układzie modelu, kolejność planu')
Testy.sprawdz(pts.all? { |q| (q.z * CAL - (pl[:polacie][:z] + 300.0)).abs < 1e-6 }, 'wysokość punktów: linia podparcia nad poziomem linii 300')
Testy.rowne([z, kat, okap, sz, opc[:operacja]], [nil, 20.0, 500.0, pl[:polacie][:szczyty], false],
            'API.polacie: z – średnia punktów, kąt, okap, szczyty w kolejności punktów, operacja generatora')
_, gp, lista = AtrapaDachow.ostatnie(:podpory)
Testy.sprawdz(gp == pg[0], 'podpory zapisane w grupie połaci')
pp = Krok2.podpory(pl)
Testy.rowne(lista.length, 3, 'podpory: 2 płatwie ścienne + kalenicowa')
Testy.sprawdz(lista.zip(pp).all? { |a, b| (0..2).all? { |k| (a[:od][k] - b[:od][k] - [0.0, 0.0, 300.0][k]).abs < 1e-6 } && a[:nazwa] == b[:nazwa] },
              'podpory w mm układu modelu (dom na poziomie 300)')
Testy.sprawdz(m.selection.to_a == pg, 'zaznaczone połacie')
Testy.sprawdz(AtrapaDachow.ostatnie(:wiezba).nil?, 'KROK 2 dopiero po zakończeniu wywołania z okna')
Testy.rowne(m.operacje.map(&:first), [:start, :commit, :start, :commit], 'dom i połacie – dwie operacje')
Testy.rowne(m.operacje[2], [:start, 'ArteMadera – połacie dachu', :dolaczona], 'połacie dołączone do budowy domu (jedno Cofnij)')
Testy.rowne(UI.uruchom_liczniki, 1, 'jeden licznik')
_, gw, fr, ow = AtrapaDachow.ostatnie(:wiezba)
Testy.sprawdz(gw == pg[0], 'KROK 2 na połaciach domu')
Testy.rowne([fr[:build_dir], fr[:ridge_on], fr[:seat_on], fr[:rafter_on], fr[:rafter_mode], fr[:purlin_supports_on]],
            ['up', false, false, true, 'max', true], 'KROK 2: w górę od połaci, bez płatwi kalenicowej i zamków dolnych, płatwie jako podpory')
Testy.rowne([fr[:rafter_w_mm], fr[:rafter_h_mm], fr[:rafter_spacing_mm], fr[:timber_class], fr[:check_on]], [50.0, 150.0, 900.0, 'C24', true],
            'KROK 2: krokiew, rozstaw i klasa drewna z generatora, kontrola nośności')
Testy.rowne([fr[:sheath_ceiling_on], fr[:sheath_plank_on], fr[:sheath_osb_on]], [false, true, false], 'poszycie: deskowanie (domyślnie)')
Testy.sprawdz(ow.fetch(:okno, true) && ow[:po_generowaniu].respond_to?(:call), 'okno KROKU 2 z procedurą po OK')
Testy.sprawdz(UI.zatrzymane.include?(1), 'licznik zatrzymany na starcie (bez powtórzeń)')
Testy.sprawdz(dom.entities.to_a.none? { |g| g.respond_to?(:name) && g.name == 'Dach - polacie' }, 'połacie poza grupą domu (podpis domu bez zmian)')
Testy.sprawdz(!Atrybuty.zmieniony_recznie?(dom), 'dom nie wygląda na zmieniony ręcznie')

Testy.grupa('Więźba po OK w KROKU 2 powiązana z domem')
op = m.operacje.length
wz = wiezba(m, 30_000, 0, 35_000, 4000, 3200)
AtrapaDachow.po_ok.call(wz)
Testy.rowne(wz.get_attribute('ArteMadera_GW', 'wiezba_domu'), Atrybuty.dom_id(dom), 'więźba oznaczona id domu')
Testy.rowne(m.operacje[op..-1], [[:start, 'ArteMadera – więźba domu', :dolaczona], [:commit]], 'oznaczenie dołączone do operacji KROKU 2')
AtrapaDachow.po_ok.call(nil)
Testy.rowne(m.operacje.length, op + 2, 'Anuluj w KROKU 2 – bez zmian')

Testy.grupa('Przebudowa – poprzednie połacie znikają, więźba domu po potwierdzeniu')
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
Testy.sprawdz(UI.komunikaty.any? { |k| k.include?('więźba z aplikacji do dachów (2)') }, 'pytanie o więźbę domu (po id i nad połaciami)')
Testy.sprawdz(!wz.valid? && !nad.valid? && obok.valid?, 'więźba domu usunięta – także daleko od połaci (po id); cudza zostaje')
Testy.rowne(AtrapaDachow.ostatnie(:polacie)[3], 30.0, 'nowy kąt w KROKU 1')
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

Testy.grupa('Same płatwie (domyślnie) – połacie na wierzchu płatwi, KROK 2 bez krokwi: deski na płatwiach')
AtrapaDachow.wyczysc
m = model_z_liniami(prostokat(0, 0, 6000, 4500))
w = generuj({})
pl = Sterowanie.plan
Testy.sprawdz(w['dach'] && w['dach']['ok'] && w['dach']['tekst'].include?('poszycie'), "komunikat o poszyciu (#{w['dach'].inspect})")
Testy.rowne(polacie(m).length, 1, 'połacie')
_, _g, lista = AtrapaDachow.ostatnie(:podpory)
Testy.rowne(lista.length, pl[:elementy].count { |e| e[:prefiks] == 'P' }, "podpory: wszystkie płatwie (#{lista.length})")
UI.uruchom_liczniki
fr = AtrapaDachow.ostatnie(:wiezba)[2]
Testy.rowne([fr[:rafter_on], fr[:build_dir], fr[:sheath_plank_on], fr[:sheath_plank_t_mm], fr[:sheath_plank_len_mm]], [false, 'up', true, 25.0, 4000.0],
            'KROK 2 bez krokwi, deskowanie z parametrów')

Testy.grupa('KROK 2 – odmowa aplikacji, połacie cofnięte przed oknem')
AtrapaDachow.wyczysc
m = model_z_liniami(prostokat(0, 0, 5000, 4000))
generuj('dach_uklad' => 'krokwie')
AtrapaDachow.blad_wiezby = 'Brak połaci w zaznaczeniu.'
UI.komunikaty.clear
UI.uruchom_liczniki
AtrapaDachow.blad_wiezby = nil
Testy.sprawdz(UI.komunikaty.any? { |t| t.include?('KROK 2') && t.include?('Brak połaci w zaznaczeniu.') }, 'odmowa KROKU 2 – komunikat')
m.selection.clear
m.selection.add(Sterowanie.dom)
generuj('dach_uklad' => 'krokwie')
polacie(m).each(&:erase!)
n = AtrapaDachow.wywolania.count { |x| x[0] == :wiezba }
UI.uruchom_liczniki
Testy.rowne(AtrapaDachow.wywolania.count { |x| x[0] == :wiezba }, n, 'połacie cofnięte przed oknem – bez KROKU 2')

Testy.grupa('Bez aplikacji do dachów, aplikacja bez API (starsza niż 3.7.0), odmowa aplikacji')
roof = ArteMadera::Roof
ArteMadera.send(:remove_const, :Roof)
m = model_z_liniami(prostokat(0, 0, 5000, 4000))
w = generuj('dach_uklad' => 'krokwie')
ArteMadera.const_set(:Roof, roof)
Testy.sprawdz(w['zbudowano'] && !w['dach']['ok'] && w['dach']['tekst'].include?('nie jest wczytana'), "brak aplikacji – komunikat (#{w['dach'].inspect})")
Testy.rowne(polacie(m).length, 0, 'bez połaci')
api = ArteMadera::Roof::API
ArteMadera::Roof.send(:remove_const, :API)
m = model_z_liniami(prostokat(0, 0, 5000, 4000))
w = generuj('dach_uklad' => 'krokwie')
ArteMadera::Roof.const_set(:API, api)
Testy.sprawdz(!w['dach']['ok'] && w['dach']['tekst'].include?('jest za stara') && w['dach']['tekst'].include?('3.7.0 lub nowsza'),
              "aplikacja bez API – komunikat (#{w['dach'].inspect})")
Testy.rowne([polacie(m).length, UI.liczniki.length], [0, 0], 'bez połaci i bez KROKU 2')
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

Testy.grupa('Dom obrócony o 30° – punkty, szczyty i podpory z domem')
AtrapaDachow.wyczysc
m = model_z_liniami(obroc_odcinki(prostokat(0, 0, 6000, 4000), 30))
w = generuj('dach_uklad' => 'platwie_krokwie')
pl = Sterowanie.plan
_, pts, _z, _k, _o, sz = AtrapaDachow.ostatnie(:polacie)
tr = Sterowanie.dom.transformation
oczek = pl[:polacie][:punkty].map { |x, y| Geom::Point3d.new(x / CAL, y / CAL, 0).transform(tr) }
Testy.sprawdz(w['dach']['ok'] && pts.zip(oczek).all? { |a, b| (a.x - b.x).abs < 1e-6 && (a.y - b.y).abs < 1e-6 }, 'obrys obrócony z domem')
Testy.rowne(sz, pl[:polacie][:szczyty], 'krawędzie szczytowe w kolejności punktów (odwrócenie obiegu – w API)')
_, _g, lista = AtrapaDachow.ostatnie(:podpory)
ok = lista.zip(Krok2.podpory(pl)).all? do |a, b|
  q = Geom::Point3d.new(b[:do][0] / CAL, b[:do][1] / CAL, b[:do][2] / CAL).transform(tr)
  [q.x, q.y, q.z].zip(a[:do]).all? { |u, v| (u * CAL - v).abs < 1e-6 }
end
Testy.sprawdz(ok && lista.length > 3, "podpory obrócone z domem (#{lista.length})")
UI.uruchom_liczniki

Testy.koniec
