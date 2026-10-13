# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_sketchup.rb
# Zadanie: warstwa SketchUpa na atrapie API – ładowanie wtyczki, okno, generowanie, atrybuty, położenie bali, przebudowa, ręczne zmiany.
# Tematy: testy SketchUp, atrapa, okno – wywołania, budowa modelu, atrybuty Dokumentacji 2D, bal obrócony, przebudowa, kontrola z menu
# Zależy od: testy/atrapa/sketchup.rb, testy/pomoc.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_sketchup.rb

require 'json'
require File.expand_path('atrapa/sketchup', File.dirname(__FILE__))
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

def instancje(grupa)
  grupa.entities.to_a.select { |g| g.is_a?(Sketchup::Group) }.flat_map { |g| g.entities.to_a.select { |i| i.is_a?(Sketchup::ComponentInstance) } }
end

Testy.grupa('Ładowanie wtyczki')
Testy.rowne(PLUGIN_BUILD, '1', 'numer kompilacji')
Testy.sprawdz(defined?(ArteMadera::GeneratorWiencowy::Menu) ? true : false, 'moduły załadowane')
Testy.rowne(MODULE_FILES.length, 21, 'liczba modułów')

Testy.grupa('Start z zaznaczonych linii i okno')
seg = prostokat(0, 0, 6000, 4000) + [[[3000, 0], [3000, 4000]]]
m = model_z_liniami(seg, 300.0)
Sterowanie.start
dlg = Okno.dialog
Testy.sprawdz(!dlg.nil? && dlg.visible?, 'okno otwarte')
Testy.sprawdz(dlg.plik.end_with?('okno.html') && File.exist?(dlg.plik), 'plik okna istnieje')
dlg.wywolaj('gotowe')
init = dlg.skrypty.find { |s| s.start_with?('AMGW.init(') }
d = JSON.parse(init.sub(/\AAMGW\.init\(/, '').sub(/\)\z/, ''))
Testy.rowne(d['tryb'], 'nowy', 'tryb nowy')
Testy.rowne(d['opisy'].length, Parametry::OPISY.length, 'opisy wszystkich pól')
Testy.sprawdz(d['podsumowanie']['sciany'].length >= 5, 'podsumowanie ścian w danych startowych')
Testy.sprawdz(d['info'].include?('300 mm'), 'informacja o wysokości linii')

Testy.grupa('Podgląd z okna')
dlg.wywolaj('podglad', JSON.generate('parametry' => { 'liczba_wiencow' => '12', 'max_dlugosc' => '7000' }, 'otwory' => []))
w = ostatni_wynik(dlg)
Testy.rowne(w['bledy'], [], 'podgląd bez błędów')
Testy.rowne(w['wysokosci']['okapowa'], 12 * 139 + 69.5, 'wysokość po zmianie liczby wieńców')
Testy.rowne(m.entities.grep(Sketchup::Group).length, 0, 'podgląd nie zmienia modelu')

Testy.grupa('Generowanie')
otw = [{ 'sciana' => 'W-1', 'od' => '1500', 'szerokosc' => '1020', 'wysokosc' => '1010', 'parapet' => '900' }]
dane = { 'parametry' => { 'liczba_wiencow' => '12', 'max_dlugosc' => '5000' }, 'otwory' => otw }
dlg.wywolaj('generuj', JSON.generate(dane))
w = ostatni_wynik(dlg)
Testy.sprawdz(w['zbudowano'], 'zbudowano')
dom = m.entities.grep(Sketchup::Group).find { |g| g.name == 'Dom wieńcowy' }
Testy.sprawdz(!dom.nil?, 'grupa domu')
pl = Projekt.oblicz(Atrybuty.czytaj_wejscie(dom))
Testy.rowne(dom.entities.grep(Sketchup::Group).length, pl[:sciany].count { |s| !s[:bale].empty? }, 'grupa na każdą ścianę')
Testy.rowne(dom.entities.grep(Sketchup::Group).map(&:name), pl[:sciany].select { |s| !s[:bale].empty? }.map { |s| s[:id] }, 'nazwy grup W-n')
Testy.rowne(instancje(dom).length, pl[:bale].length, 'instancja na każdy bal')
defs = m.definitions.to_a.select { |x| x.get_attribute('ArteMadera_GW', 'dom') == Atrybuty.dom_id(dom) }
Testy.rowne(defs.length, pl[:pozycje].length, 'definicja na każdą pozycję')
Testy.sprawdz(defs.all? { |x| x.get_attribute('ArteMadera', 'rola') == 'timber' }, 'rola timber dla Dokumentacji 2D')
Testy.rowne(defs.map { |x| x.get_attribute('ArteMadera', 'prefiks') }.uniq.sort, %w[Bs Kf], 'prefiksy Bs i Kf')
Testy.sprawdz(dom.get_attribute('ArteMadera', 'rola').nil?, 'grupa domu bez roli (nie wyłącza bali w Dokumentacji 2D)')
Testy.rowne(m.layers['Ściany zewnętrzne'].nil?, false, 'tag Ściany zewnętrzne')
Testy.rowne(m.operacje.map(&:first), [:start, :commit], 'jedna operacja (jedno Cofnij)')
Testy.rowne(dom.transformation.origin.z * CAL, 300.0, 'dom na wysokości linii')
i0 = instancje(dom).first
Testy.rowne(i0.get_attribute('ArteMadera_GW', 'sciana'), 'W-1', 'instancja: ściana')

Testy.grupa('Ściany brył w definicjach')
ok_liczba = 0
ok_zwrot = 0
defs.each do |x|
  poz = pl[:pozycje].find { |p| p[:nazwa] == x.get_attribute('ArteMadera_GW', 'nazwa') }
  s = Projekt.siatka_pozycji(poz)
  sciany = x.entities.grep(Sketchup::Face)
  ok_liczba += 1 if sciany.length == s[:sciany].length
  zgodne = s[:sciany].each_with_index.all? do |f, i|
    n = sciany[i].normal
    n.x * f[:normalna][0] + n.y * f[:normalna][1] + n.z * f[:normalna][2] > 0.99
  end
  ok_zwrot += 1 if zgodne
end
Testy.rowne(ok_liczba, defs.length, 'liczba ścian w definicjach = siatka')
Testy.rowne(ok_zwrot, defs.length, 'ściany zwrócone na zewnątrz')

Testy.grupa('Położenie bali (także obróconych) w grupie domu')
bledne = 0
obrocone = 0
instancje(dom).each do |inst|
  b = pl[:bale].find do |x|
    x[:sciana][:id] == inst.get_attribute('ArteMadera_GW', 'sciana') && x[:pozycja][:nazwa] == inst.get_attribute('ArteMadera_GW', 'pozycja') &&
      (Konwersja.transformacja_bala(x, pl[:parametry]).origin - inst.transformation.origin).length < 1e-6
  end
  if b.nil?
    bledne += 1
    next
  end
  obrocone += 1 if b[:obrocony]
  poz = b[:pozycja]
  kan = Bryla.profil(poz[:dl], poz[:t], poz[:h], poz[:cechy])
  rzecz = Bryla.profil(b[:dl], poz[:t], b[:h], b[:cechy])
  pol = Bale.polozenie(b, pl[:parametry])
  [[poz[:dl] * 0.5, 22.0, b[:h] / 2], [5.0, 1.0, 5.0], [poz[:dl] - 5, 43.0, b[:h] - 5]].concat(
    poz[:cechy].map { |c| [(c[:x0] + c[:x1]) / 2.0, c[:typ] == 'podciecie' ? (c[:strona] == 0 ? 1.0 : 43.0) : 22.0, c[:typ].include?('gora') ? b[:h] - 1.0 : 1.0] }
  ).each do |lx, ly, lz|
    g = inst.transformation * Geom::Point3d.new(lx / CAL, ly / CAL, lz / CAL)
    gm = [g.x * CAL, g.y * CAL, g.z * CAL]
    d = [gm[0] - pol[:poczatek][0], gm[1] - pol[:poczatek][1]]
    rx = d[0] * pol[:x][0] + d[1] * pol[:x][1]
    ry = d[0] * pol[:y][0] + d[1] * pol[:y][1]
    bledne += 1 if Bryla.zawiera?(kan, lx, ly, lz) != Bryla.zawiera?(rzecz, rx, ry, gm[2] - pol[:poczatek][2])
  end
end
Testy.rowne(bledne, 0, 'bryła instancji pokrywa się z balem w punktach kontrolnych')
Testy.sprawdz(obrocone > 0, "są bale obrócone o 180° (#{obrocone})")

Testy.grupa('Edycja i przebudowa')
stary_id = Atrybuty.dom_id(dom)
m.selection.clear
m.selection.add(dom)
Sterowanie.start
dlg = Okno.dialog
dlg.wywolaj('gotowe')
d = JSON.parse(dlg.skrypty.find { |s| s.start_with?('AMGW.init(') }.sub(/\AAMGW\.init\(/, '').sub(/\)\z/, ''))
Testy.rowne(d['tryb'], 'edycja', 'tryb edycja')
Testy.rowne(d['otwory'].length, 1, 'otwory wczytane z modelu')
Testy.rowne(d['parametry']['liczba_wiencow'], '12', 'parametry wczytane z modelu')
dlg.wywolaj('generuj', JSON.generate('parametry' => d['parametry'].merge('liczba_wiencow' => '10'), 'otwory' => d['otwory']))
nowe = m.entities.grep(Sketchup::Group).select { |g| g.name == 'Dom wieńcowy' }
Testy.rowne(nowe.length, 1, 'jeden dom po przebudowie')
Testy.sprawdz(!dom.valid?, 'stara grupa usunięta')
Testy.rowne(m.definitions.to_a.count { |x| x.get_attribute('ArteMadera_GW', 'dom') == stary_id }, 0, 'stare definicje usunięte')
dom = nowe[0]
Testy.rowne(Atrybuty.czytaj_wejscie(dom)['parametry']['liczba_wiencow'], '10', 'nowe parametry zapisane')

Testy.grupa('Ręczna zmiana – pytanie przed nadpisaniem')
inst = instancje(dom).first
inst.transformation = Geom::Transformation.axes(Geom::Point3d.new(1, 1, 1), Geom::Vector3d.new(1, 0, 0), Geom::Vector3d.new(0, 1, 0), Geom::Vector3d.new(0, 0, 1))
Testy.sprawdz(Atrybuty.zmieniony_recznie?(dom), 'podpis wykrywa przesunięcie')
UI.komunikaty.clear
UI.odpowiedz = IDNO
Okno.dialog.wywolaj('generuj', JSON.generate('parametry' => { 'liczba_wiencow' => '10' }, 'otwory' => []))
w = ostatni_wynik(Okno.dialog)
Testy.sprawdz(w['anulowano'], 'odpowiedź „nie” – bez zmian')
Testy.sprawdz(UI.komunikaty.any? { |t| t.include?('ręcznie') }, 'pytanie o ręczne zmiany')
Testy.sprawdz(dom.valid?, 'dom zostaje')
UI.odpowiedz = IDYES

Testy.grupa('Kontrola z menu')
m.selection.clear
m.selection.add(dom)
UI.komunikaty.clear
Sterowanie.kontrola
Testy.sprawdz(UI.komunikaty.last.to_s.include?('bez kolizji'), 'kontrola: bez kolizji')
Testy.sprawdz(UI.komunikaty.last.to_s.include?('Mijanka styków: w porządku'), 'kontrola: mijanka')

Testy.grupa('Błędy wejścia')
model_z_liniami([[[0, 0], [1000, 0]], [[0, 0], [0, 1000]]])
UI.komunikaty.clear
Sterowanie.start
Okno.dialog.wywolaj('generuj', JSON.generate('parametry' => {}, 'otwory' => []))
w = ostatni_wynik(Okno.dialog)
Testy.sprawdz(!w['bledy'].empty?, 'błąd – brak obrysu')
Sketchup.model = Sketchup::Model.new
UI.komunikaty.clear
Sterowanie.start
Testy.sprawdz(UI.komunikaty.last.to_s.include?('Zaznacz'), 'puste zaznaczenie – komunikat')
m = Sketchup::Model.new
Sketchup.model = m
m.selection.add(m.entities.add_line(Geom::Point3d.new(0, 0, 0), Geom::Point3d.new(100, 0, 0)))
m.selection.add(m.entities.add_line(Geom::Point3d.new(0, 0, 10), Geom::Point3d.new(0, 100, 10)))
UI.komunikaty.clear
Sterowanie.start
Testy.sprawdz(UI.komunikaty.last.to_s.include?('różnych wysokościach'), 'linie na różnych wysokościach – komunikat')

Testy.koniec
