# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_sketchup.rb
# Zadanie: warstwa SketchUpa na atrapie API – ładowanie wtyczki, okno, generowanie, atrybuty, położenie bali, przebudowa, ręczne zmiany.
# Tematy: testy SketchUp, atrapa, okno – wywołania, budowa modelu, atrybuty Dokumentacji 2D, bal obrócony, przebudowa, kontrola z menu, belki w modelu, zapamiętane ustawienia, szablony
# Zależy od: testy/atrapa/sketchup.rb, testy/pomoc.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_sketchup.rb

require 'json'
require 'tmpdir'
require 'fileutils'
ENV['AM_GW_USTAWIENIA'] = File.join(Dir.tmpdir, "am_gw_test_#{Process.pid}")
FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
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

# Ostatni skrypt okna o danym początku jako Hash (np. 'AMGW.ustaw(').
def ostatni_skrypt(dlg, poczatek)
  js = dlg.skrypty.reverse.find { |x| x.start_with?(poczatek) }
  js ? JSON.parse(js[poczatek.length..-2]) : nil
end

Testy.grupa('Ładowanie wtyczki')
Testy.rowne(PLUGIN_BUILD, '15', 'numer kompilacji')
Testy.sprawdz(defined?(ArteMadera::GeneratorWiencowy::Menu) ? true : false, 'moduły załadowane')
Testy.rowne(MODULE_FILES.length, Dir.glob(File.join(KATALOG_WTYCZKI, '{rdzen,sketchup}', '*.rb')).length, 'liczba modułów = pliki rdzen/ i sketchup/')
Testy.rowne(Ustawienia.ostatnie, {}, 'bez zapisanych ustawień na starcie testu')

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
Testy.rowne(d['opisy'].length, ParametryLista::LISTA.length, 'opisy wszystkich pól')
Testy.rowne(d['sekcje'].map { |x| x['klucz'] }, ParametryLista::SEKCJE.map { |x| x[0] }, 'sekcje okna')
Testy.sprawdz(d['opisy'].all? { |x| d['sekcje'].any? { |sk| sk['klucz'] == x['sekcja'] } }, 'każde pole w istniejącej sekcji')
Testy.sprawdz(d['opisy'].select { |x| x['rodzaj'] == 'wybor' }.all? { |x| !x['wybory'].empty? }, 'pola wyboru z listą wyborów')
Testy.sprawdz(d['szablony'].any? { |x| x.include?('wbudowany') }, 'szablony wbudowane w oknie')
Testy.sprawdz(d['podsumowanie']['sciany'].length >= 5, 'podsumowanie ścian w danych startowych')
Testy.sprawdz(d['info'].include?('300 mm'), 'informacja o wysokości linii')

Testy.grupa('Podgląd z okna')
dlg.wywolaj('podglad', JSON.generate('parametry' => { 'liczba_wiencow' => '12', 'max_dlugosc' => '7000' }, 'otwory' => []))
w = ostatni_wynik(dlg)
Testy.rowne(w['bledy'], [], 'podgląd bez błędów')
Testy.rowne(w['wysokosci']['okapowa'], 12 * 139 + 69.5, 'wysokość po zmianie liczby wieńców')
Testy.rowne(m.entities.grep(Sketchup::Group).length, 0, 'podgląd nie zmienia modelu')
Testy.rowne(Ustawienia.ostatnie['liczba_wiencow'], '12', 'parametry podglądu zapamiętane na komputerze')
Testy.sprawdz(File.exist?(Ustawienia.sciezka), 'plik ustawień zapisany')
Testy.sprawdz(w['podpowiedzi'].is_a?(Array) && !w['podpowiedzi'].empty?, 'podpowiedzi podłogi w wyniku')

Testy.grupa('Generowanie')
otw = [{ 'sciana' => 'W-1', 'od' => '1500', 'szerokosc' => '1020', 'wysokosc' => '1010', 'parapet' => '900' }]
dane = { 'parametry' => { 'liczba_wiencow' => '12', 'max_dlugosc' => '5000' }, 'otwory' => otw,
         'wegly' => [{ 'sciana' => 'W-2', 'polozenie' => 'srodek', 'od' => '' }] }
dlg.wywolaj('generuj', JSON.generate(dane))
w = ostatni_wynik(dlg)
Testy.sprawdz(w['zbudowano'], 'zbudowano')
dom = m.entities.grep(Sketchup::Group).find { |g| g.name == 'Dom wieńcowy' }
Testy.sprawdz(!dom.nil?, 'grupa domu')
pl = Projekt.oblicz(Atrybuty.czytaj_wejscie(dom))
wszystkie_poz = pl[:pozycje] + pl[:pozycje_elementow]
grupy_scian = pl[:sciany].select { |s| !s[:bale].empty? }.map { |s| s[:id] }
Testy.rowne(dom.entities.grep(Sketchup::Group).map(&:name), grupy_scian + %w[Podłoga Dach], 'grupy W-n, Podłoga, Dach')
Testy.rowne(instancje(dom).length, pl[:bale].length + pl[:elementy].length, 'instancja na każdy bal i belkę')
defs = m.definitions.to_a.select { |x| x.get_attribute('ArteMadera_GW', 'dom') == Atrybuty.dom_id(dom) }
Testy.rowne(defs.length, wszystkie_poz.length, 'definicja na każdą pozycję')
Testy.sprawdz(defs.all? { |x| x.get_attribute('ArteMadera', 'rola') == 'timber' }, 'rola timber dla Dokumentacji 2D')
Testy.rowne(defs.map { |x| x.get_attribute('ArteMadera', 'prefiks') }.uniq.sort, wszystkie_poz.map { |x| x[:prefiks] }.uniq.sort,
            'prefiksy definicji = prefiksy pozycji')
Testy.sprawdz((%w[Bs Kf Sz Pw L P] - defs.map { |x| x.get_attribute('ArteMadera', 'prefiks') }).empty?, 'są bale Bs, Kf, Sz i belki Pw, L, P')
Testy.sprawdz(%w[Szczyty Podłoga Dach].all? { |t| !m.layers[t].nil? }, 'tagi Szczyty, Podłoga, Dach')
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
  poz = wszystkie_poz.find { |p| p[:nazwa] == x.get_attribute('ArteMadera_GW', 'nazwa') }
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
  next if inst.get_attribute('ArteMadera_GW', 'sciana').nil?
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

Testy.grupa('Położenie belek podłogi i dachu (także krokwi ukośnych)')
bledne = 0
pl_kr = Projekt.oblicz(Atrybuty.czytaj_wejscie(dom).merge('parametry' => { 'dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator', 'liczba_wiencow' => '12' }))
pl_kr[:elementy].each do |e|
  tr = Konwersja.transformacja_elementu(e)
  poz = e[:pozycja]
  [[poz[:dl] / 2.0, poz[:t] / 2.0, poz[:h] / 2.0], [1.0, 1.0, 1.0], [poz[:dl] - 1.0, poz[:t] - 1.0, poz[:h] - 1.0]].each do |lx, ly, lz|
    g = tr * Geom::Point3d.new(lx / CAL, ly / CAL, lz / CAL)
    gm = [g.x * CAL, g.y * CAL, g.z * CAL]
    pol = e[:polozenie]
    d = (0..2).map { |k| gm[k] - pol[:poczatek][k] }
    rx, ry, rz = [:x, :y, :z].map { |o| (0..2).inject(0.0) { |sm, k| sm + d[k] * pol[o][k] } }
    bledne += 1 unless rx > -0.01 && rx < e[:dl] + 0.01 && ry > -0.01 && ry < e[:b] + 0.01 && rz > -0.01 && rz < e[:h] + 0.01
  end
end
Testy.rowne(bledne, 0, 'punkty komponentu belki leżą w belce z planu')
Testy.sprawdz(pl_kr[:elementy].any? { |e| e[:polozenie][:x][2].abs > 0.1 }, 'są krokwie ukośne')

Testy.grupa('Taras jak 1100 w modelu – grupa i tag Taras, słupy pionowe, balustrada')
model_glowny = Sketchup.model
Sketchup.model = Sketchup::Model.new
m_t = Sketchup.active_model
wej_t = { 'segmenty' => prostokat(0, 0, 4000, 4000), 'z0' => 0.0, 'otwory' => [], 'sciany' => {},
          'parametry' => { 'taras' => 'podciag', 'liczba_wiencow' => '12', 'podloga' => 'nie' } }
pl_t = Projekt.oblicz(wej_t)
zb_t = Budowa.zbuduj(m_t, pl_t, wej_t)
taras_g = zb_t[:grupa].entities.to_a.find { |g| g.is_a?(Sketchup::Group) && g.name == 'Taras' }
Testy.sprawdz(!taras_g.nil? && taras_g.layer.name == 'Taras', 'grupa Taras z tagiem Taras')
sl_t = taras_g ? taras_g.entities.to_a.select { |i| i.definition.get_attribute('ArteMadera', 'prefiks') == 'S' } : []
Testy.rowne(sl_t.length, pl_t[:elementy].count { |e| e[:prefiks] == 'S' }, 'słupy w grupie Taras (prefiks S dla Dokumentacji 2D)')
Testy.sprawdz(sl_t.all? { |i| i.transformation.xaxis.z.abs > 0.999 }, 'słupy pionowe')
bal_t = instancje(zb_t[:grupa]).select { |i| i.layer && i.layer.name == 'Taras' && i.definition.get_attribute('ArteMadera', 'prefiks') != 'S' }
Testy.rowne(bal_t.length, pl_t[:bale].count { |b| b[:taras] }, 'bale balustrady z tagiem Taras w grupach ścian')
Sketchup.model = model_glowny

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
# Dom przesunięty po generowaniu (np. na planie działki) – przebudowa zostawia go na nowym miejscu.
przes = Geom::Transformation.axes(Geom::Point3d.new(1000 / CAL, 500 / CAL, 0), Geom::Vector3d.new(1, 0, 0), Geom::Vector3d.new(0, 1, 0),
                                  Geom::Vector3d.new(0, 0, 1))
dom.transformation = przes * dom.transformation
cel = dom.transformation.to_a
Testy.rowne(d['sciany'], {}, 'dom bez ustawień ścian')
dlg.wywolaj('generuj', JSON.generate('parametry' => d['parametry'].merge('liczba_wiencow' => '10'), 'otwory' => d['otwory'],
                                     'sciany' => { 'W-1' => { 'ostatek_od' => 200 } }))
nowe = m.entities.grep(Sketchup::Group).select { |g| g.name == 'Dom wieńcowy' }
Testy.rowne(nowe.length, 1, 'jeden dom po przebudowie')
Testy.sprawdz(!dom.valid?, 'stara grupa usunięta')
Testy.rowne(m.definitions.to_a.count { |x| x.get_attribute('ArteMadera_GW', 'dom') == stary_id }, 0, 'stare definicje usunięte')
dom = nowe[0]
Testy.rowne(Atrybuty.czytaj_wejscie(dom)['parametry']['liczba_wiencow'], '10', 'nowe parametry zapisane')
Testy.rowne(Atrybuty.czytaj_wejscie(dom)['sciany'], { 'W-1' => { 'ostatek_od' => 200 } }, 'ustawienia ścian zapisane w domu')
Testy.rowne(Sterowanie.widok('W-1')['ustawienia']['ostatek_od'], 200.0, 'widok ściany: ostatek z ustawień ściany')
Testy.sprawdz(dom.transformation.to_a.zip(cel).all? { |a, b| (a - b).abs < 1e-6 }, 'przesunięty dom zostaje na miejscu po przebudowie')
Testy.sprawdz(!Atrybuty.zmieniony_recznie?(dom), 'przesunięcie całego domu to nie ręczna zmiana')

m.selection.clear
m.selection.add(dom)
Sterowanie.start
Okno.dialog.wywolaj('gotowe')
d2 = ostatni_skrypt(Okno.dialog, 'AMGW.init(')
Testy.rowne(d2['sciany'], { 'W-1' => { 'ostatek_od' => 200 } }, 'edycja: ustawienia ścian wczytane do okna')
Okno.dialog.wywolaj('podglad', JSON.generate('parametry' => d2['parametry'], 'otwory' => d2['otwory']))
Testy.rowne(Sterowanie.widok('W-1')['ustawienia']['ostatek_od'], 200.0, 'podgląd bez ustawień ścian w danych – zostają z domu')

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

Testy.grupa('Zapamiętane ustawienia i szablony')
model_z_liniami(prostokat(0, 0, 5000, 4000))
Sterowanie.start
dlg = Okno.dialog
dlg.wywolaj('gotowe')
d = ostatni_skrypt(dlg, 'AMGW.init(')
Testy.rowne(d['parametry']['liczba_wiencow'], '10', 'nowy dom: parametry z ostatniego użycia')
Testy.sprawdz(d['info'].include?('ostatniego użycia'), 'informacja o ostatnich parametrach')
dlg.wywolaj('szablon_zapisz', JSON.generate('nazwa' => 'Mój domek', 'parametry' => { 'liczba_wiencow' => '18', 'dach_kat' => '30' }))
sz = ostatni_skrypt(dlg, 'AMGW.szablony(')
Testy.sprawdz(sz['lista'].include?('Mój domek') && sz['komunikat'].include?('Zapisano'), 'szablon zapisany')
dlg.wywolaj('szablon_wczytaj', 'Mój domek')
u = ostatni_skrypt(dlg, 'AMGW.ustaw(')
Testy.rowne([u['parametry']['liczba_wiencow'], u['parametry']['dach_kat']], %w[18 30], 'szablon wczytany')
nazwa = Ustawienia.nazwy_szablonow.find { |x| x.start_with?('Typ 300') }
dlg.wywolaj('szablon_wczytaj', nazwa)
u = ostatni_skrypt(dlg, 'AMGW.ustaw(')
Testy.rowne(u['parametry']['liczba_wiencow'], 25, 'szablon wbudowany: 25 wieńców')
Testy.rowne(u['parametry']['max_dlugosc'], 5100.0, 'szablon wbudowany: reszta domyślna')
dlg.wywolaj('szablon_zapisz', JSON.generate('nazwa' => nazwa, 'parametry' => {}))
Testy.sprawdz(ostatni_skrypt(dlg, 'AMGW.szablony(')['komunikat'].include?('wbudowany'), 'nie można nadpisać wbudowanego')
dlg.wywolaj('szablon_usun', 'Mój domek')
Testy.sprawdz(!Ustawienia.nazwy_szablonow.include?('Mój domek'), 'szablon usunięty')
dlg.wywolaj('domyslne')
u = ostatni_skrypt(dlg, 'AMGW.ustaw(')
Testy.rowne(u['parametry'], ParametryLista.domyslne, 'przywrócenie fabrycznych')
Testy.rowne(Okno.dane_startowe['tryb_pol'], 'podstawowe', 'tryb pól okna: domyślnie podstawowe')
dlg.wywolaj('tryb_pol', 'wszystkie')
Testy.rowne([Ustawienia.tryb_pol, Okno.dane_startowe['tryb_pol']], %w[wszystkie wszystkie], 'tryb pól okna zapamiętany na komputerze')
dlg.wywolaj('tryb_pol', 'cokolwiek')
Testy.rowne(Ustawienia.tryb_pol, 'podstawowe', 'nieznany tryb pól – podstawowe')
Testy.sprawdz(Okno.dane_startowe['opisy'].count { |o| o['podstawowy'] } >= 20, 'opisy pól z oznaczeniem podstawowych')
File.open(Ustawienia.sciezka, 'w') { |f| f.write('{uszkodzony') }
Testy.rowne(Ustawienia.ostatnie, {}, 'uszkodzony plik – puste ustawienia, bez błędu')
Ustawienia.zapamietaj('liczba_wiencow' => '10')

Testy.grupa('Ustawienia z wcześniejszej kompilacji – podciąg wraca do wartości fabrycznej (runda 10)')
File.open(Ustawienia.sciezka, 'w') { |f| f.write(JSON.generate('wersja' => 1, 'ostatnie' => { 'podciag_poziom' => 'pod', 'liczba_wiencow' => '14' })) }
Testy.rowne(Ustawienia.ostatnie, { 'liczba_wiencow' => '14' }, 'plik wersji 1: zapamiętany poziom podciągu pominięty, reszta zostaje')
Testy.rowne(Parametry.normalizuj(Ustawienia.ostatnie)[0]['podciag_poziom'], 'rowno', 'podciąg na wysokości podwalin')
Ustawienia.zapamietaj('podciag_poziom' => 'pod', 'liczba_wiencow' => '10')
Testy.rowne([JSON.parse(File.read(Ustawienia.sciezka))['wersja'], Ustawienia.ostatnie['podciag_poziom']], [Ustawienia::WERSJA, 'pod'],
            'plik bieżącej wersji: wybór użytkownika (obniżony) zapamiętany')

Testy.grupa('Ustawienia z kompilacji 13 – listy przekrojów zastąpione wykazem z hurtowni (runda 14)')
stara = '45x95, 45x120, 50x100, 63x175'
File.open(Ustawienia.sciezka, 'w') do |f|
  f.write(JSON.generate('wersja' => 2, 'ostatnie' => { 'przekroje_katalog' => stara, 'platwie_katalog' => '60x100, 60x120', 'liczba_wiencow' => '14' },
                        'szablony' => { 'Mój dom' => { 'krokwie_katalog' => '50x150, 50x175', 'dach_kat' => '35' } }))
end
Testy.rowne(Ustawienia.ostatnie, { 'liczba_wiencow' => '14' }, 'plik wersji 2: stare listy przekrojów pominięte, reszta zostaje')
Testy.rowne(Ustawienia.szablon('Mój dom'), { 'dach_kat' => '35' }, 'własny szablon: stara lista krokwi pominięta, reszta zostaje')
pn = Parametry.normalizuj(Ustawienia.ostatnie)[0]
Testy.sprawdz(pn['przekroje_katalog'].include?('45x145:4.2/5.4/6') && pn['platwie_katalog'].include?('80x200:5/7/8'),
              'po wczytaniu – listy z długościami handlowymi')
Ustawienia.zapamietaj(pn.merge('przekroje_katalog' => '45x145:6, 45x195:7'))
Testy.rowne([JSON.parse(File.read(Ustawienia.sciezka))['wersja'], Ustawienia.ostatnie['przekroje_katalog']], [Ustawienia::WERSJA, '45x145:6, 45x195:7'],
            'plik bieżącej wersji: własna lista użytkownika zapamiętana')
Ustawienia.zapamietaj('liczba_wiencow' => '10')

Testy.grupa('Ustawienia z kompilacji 14 i 15 – deski 14 × 115, 45 × 120 w długościach 5,4 / 6, pół zamka i jedno pole desek (runda 16)')
p15 = Parametry.normalizuj({})[0]
Testy.rowne([p15['podbitka_grubosc'], p15['podbitka_krycie'], p15['podbitka_dlugosc']], [14.0, 115.0, 4000.0],
            'wartości fabryczne deski nadbitki / podbitki: 14 × 115 (krycie) × 4000')
Testy.rowne(Ustawienia::WERSJA, 5, 'plik ustawień w wersji 5')
stara_lista = '45x95:6, 45x120:5/5.4, 45x145:4.2/5.4/6'
File.open(Ustawienia.sciezka, 'w') do |f|
  f.write(JSON.generate('wersja' => 3,
                        'ostatnie' => { 'podbitka_grubosc' => '19', 'podbitka_krycie' => '121', 'nadbitka_grubosc' => '19', 'nadbitka_krycie' => '121',
                                        'przekroje_katalog' => stara_lista, 'poszycie_nadbitka' => 'nie', 'poszycie_deski' => 'tak',
                                        'platwie_katalog' => '60x100:6', 'liczba_wiencow' => '14', 'polzamek' => 'nie' },
                        'szablony' => { 'Mój dom' => { 'nadbitka_grubosc' => '19', 'nadbitka_krycie' => '121', 'przekroje_katalog' => stara_lista,
                                                       'poszycie_nadbitka' => 'nie', 'dach_kat' => '35', 'polzamek' => 'nie' } }))
end
Testy.rowne(Ustawienia.ostatnie, { 'platwie_katalog' => '60x100:6', 'liczba_wiencow' => '14' },
            'plik wersji 3: deski 19 × 121, lista legarów, wybór warstw poszycia i wyłączone pół zamka pominięte, reszta zostaje')
Testy.rowne(Ustawienia.szablon('Mój dom'), { 'poszycie_nadbitka' => 'nie', 'dach_kat' => '35' },
            'własny szablon: deski, lista legarów i pół zamka pominięte, wybór warstw poszycia zostaje')
Testy.rowne(Parametry.normalizuj(Ustawienia.szablon('Mój dom'))[0].values_at('podbitka', 'polzamek', 'dach_kat'), ['nie', 'tak', 35.0],
            'szablon po wczytaniu: nadbitka wyłączona = bez desek, pół zamka fabrycznie')
pn = Parametry.normalizuj(Ustawienia.ostatnie)[0]
Testy.rowne([pn['podbitka'], pn['podbitka_grubosc'], pn['podbitka_krycie'], pn['polzamek']], ['na_platwiach', 14.0, 115.0, 'tak'],
            'po wczytaniu – nadbitka (przy samych płatwiach na płatwiach), deski 14 × 115, pół zamka włączone')
Testy.sprawdz(pn['przekroje_katalog'].include?('45x120:5.4/6'), 'po wczytaniu – 45 × 120 w długościach 5,4 / 6')
File.open(Ustawienia.sciezka, 'w') { |f| f.write(JSON.generate('wersja' => 4, 'ostatnie' => { 'polzamek' => 'nie', 'podbitka' => 'nie', 'poszycie_nadbitka' => 'tak', 'nadbitka_grubosc' => '19', 'dach_uklad' => 'krokwie' })) }
p4 = Parametry.normalizuj(Ustawienia.ostatnie)[0]
Testy.rowne([p4['polzamek'], p4['podbitka'], p4['podbitka_grubosc']], ['tak', 'na_krokwiach', 19.0],
            'plik wersji 4 (kompilacja 15): pół zamka włączone, nadbitka → deski na krokwiach z własną grubością')
Ustawienia.zapamietaj(pn.merge('podbitka_grubosc' => '19', 'przekroje_katalog' => '45x145:6', 'polzamek' => 'nie'))
Testy.rowne([JSON.parse(File.read(Ustawienia.sciezka))['wersja'], Ustawienia.ostatnie['podbitka_grubosc'].to_f, Ustawienia.ostatnie['przekroje_katalog'],
             Ustawienia.ostatnie['polzamek']],
            [5, 19.0, '45x145:6', 'nie'], 'plik bieżącej wersji: własna deska, lista użytkownika i wyłączone pół zamka zapamiętane')
Ustawienia.zapamietaj('liczba_wiencow' => '10')

Testy.grupa('Pasek narzędzi i menu pod prawym przyciskiem (runda 14)')
pasek = Pasek.pasek
Testy.sprawdz(pasek && pasek.nazwa == 'ArteMadera Generator Wieńcowy' && pasek.polecenia.length == 3, 'pasek z trzema przyciskami założony przy ładowaniu')
Testy.sprawdz(pasek.pokazany, 'pierwsze uruchomienie – pasek pokazany')
pasek.polecenia.each do |c|
  Testy.sprawdz(File.exist?(c.small_icon) && File.exist?(c.large_icon) && File.size(c.small_icon) > 100, "ikony przycisku „#{c.nazwa}” są w paczce")
  Testy.sprawdz(!c.tooltip.to_s.empty? && !c.status_bar_text.to_s.empty?, "opisy przycisku „#{c.nazwa}”")
end
%w[dom kontrola test].each do |n|
  Testy.sprawdz(%W[#{n}.svg #{n}_24.png #{n}_32.png].all? { |f| File.exist?(File.join(KATALOG_WTYCZKI, 'ikony', f)) }, "ikona #{n}: SVG i PNG 24 / 32")
end
UI::Toolbar.ostatni_stan = TB_HIDDEN
p2 = Pasek.dodaj
Testy.sprawdz(!p2.pokazany && !p2.przywrocony, 'pasek schowany przez użytkownika zostaje schowany')
UI::Toolbar.ostatni_stan = TB_VISIBLE
p3 = Pasek.dodaj
Testy.sprawdz(p3.przywrocony && !p3.pokazany, 'pasek widoczny poprzednio – przywrócony')
UI::Toolbar.ostatni_stan = nil
UI.menu_kontekstowe.replace([UI.menu_kontekstowe.last])
m = model_z_liniami(prostokat(0, 0, 4000, 3000))
Testy.rowne(UI.prawy_przycisk.pozycje.map(&:first), ['Dom wieńcowy z zaznaczonych linii…'], 'prawy przycisk na czterech liniach – nowy dom')
UI.prawy_przycisk.pozycje[0][1].call
Testy.sprawdz(Okno.dialog && Okno.dialog.visible?, 'polecenie spod prawego przycisku otwiera okno')
Sterowanie.generuj('parametry' => {}, 'otwory' => [])
Testy.rowne(UI.prawy_przycisk.pozycje.map(&:first), ['Edytuj dom wieńcowy…', 'Kontrola domu wieńcowego'], 'prawy przycisk na zaznaczonym domu – edycja i kontrola')
UI.komunikaty.clear
UI.prawy_przycisk.pozycje[1][1].call
Testy.sprawdz(UI.komunikaty.last.to_s.include?('Zamki: bez kolizji') && UI.komunikaty.last.to_s.include?('Ściany równoległe: bez nakładania'),
              'kontrola spod prawego przycisku – z wynikiem ścian równoległych')
m.selection.clear
m.selection.add(m.entities.add_line(Geom::Point3d.new(0, 0, 0), Geom::Point3d.new(10, 0, 0)))
Testy.rowne(UI.prawy_przycisk.pozycje, [], 'jedna zaznaczona linia – bez poleceń wtyczki w menu')
UI.komunikaty.clear
pasek.polecenia[0].wywolaj
Testy.sprawdz(UI.komunikaty.last.to_s.include?('Zaznacz narysowane linie') || (Okno.dialog && Okno.dialog.visible?), 'pierwszy przycisk paska uruchamia generator')

Testy.grupa('Awaria obliczeń – okienko po polsku i wpis w dzienniku pracy (runda 14)')
m = model_z_liniami(prostokat(0, 0, 4000, 3000))
Sterowanie.start
zepsute = Projekt.method(:przebieg)
Projekt.define_singleton_method(:przebieg) { |*_a| raise NoMethodError, 'próba awarii' }
UI.komunikaty.clear
wy = Sterowanie.generuj('parametry' => {}, 'otwory' => [])
Projekt.define_singleton_method(:przebieg, zepsute)
Testy.sprawdz(UI.komunikaty.last.to_s.start_with?('Nie udało się policzyć domu') && UI.komunikaty.last.to_s.include?("kompilacja #{PLUGIN_BUILD}"),
              "okienko z komunikatem po polsku i numerem kompilacji (#{UI.komunikaty.last.to_s[-70, 70]})")
Testy.sprawdz(wy['bledy'].length == 1 && wy['zbudowano'].nil?, 'wynik dla okna: jeden błąd, bez budowy')
aw = DziennikPracy.ostatnie(3).select { |w| w['zdarzenie'] == 'awaria' }.last
Testy.sprawdz(aw && aw['opis'].include?('NoMethodError') && aw['linie'].length == 4, 'awaria w dzienniku pracy z liniami rysunku')
Testy.rowne(Sterowanie.podglad('parametry' => {}, 'otwory' => [])['bledy'], [], 'po awarii – podgląd znów działa')

Testy.grupa('Otwarcie od nowa – zaznaczony dom razem z liniami (runda 10)')
m = model_z_liniami(prostokat(0, 0, 4000, 3000))
Sterowanie.start
Okno.dialog.wywolaj('generuj', JSON.generate('parametry' => { 'liczba_wiencow' => '10' }, 'otwory' => []))
dom = m.entities.grep(Sketchup::Group).find { |g| g.name == 'Dom wieńcowy' }
linie_domu = m.entities.grep(Sketchup::Edge)
m.selection.clear
m.selection.add(dom)
linie_domu.each { |e| m.selection.add(e) }
UI.komunikaty.clear
Sterowanie.start
Okno.dialog.wywolaj('gotowe')
Testy.rowne([ostatni_skrypt(Okno.dialog, 'AMGW.init(')['tryb'], UI.komunikaty.length], ['edycja', 0],
            'dom i linie, z których powstał – edycja bez pytania')
nowe_linie = [[[20_000, 0], [23_000, 0]], [[23_000, 0], [23_000, 3000]], [[23_000, 3000], [20_000, 3000]], [[20_000, 3000], [20_000, 0]]].map do |a, b|
  m.entities.add_line(Geom::Point3d.new(a[0] / CAL, a[1] / CAL, 0), Geom::Point3d.new(b[0] / CAL, b[1] / CAL, 0))
end
m.selection.clear
m.selection.add(dom)
nowe_linie.each { |e| m.selection.add(e) }
UI.odpowiedz = 6
Sterowanie.start
Okno.dialog.wywolaj('gotowe')
d3 = ostatni_skrypt(Okno.dialog, 'AMGW.init(')
Testy.sprawdz(UI.komunikaty.last.to_s.include?('Zaznaczono wygenerowany dom i 4 linii'), 'dom i inne linie – pytanie')
Testy.rowne([d3['tryb'], d3['otwory'], d3['sciany']], ['nowy', [], {}], 'Tak – nowy dom z linii: okno od nowa, bez otworów i ustawień ścian starego domu')
UI.odpowiedz = 7
Sterowanie.start
Okno.dialog.wywolaj('gotowe')
Testy.rowne(ostatni_skrypt(Okno.dialog, 'AMGW.init(')['tryb'], 'edycja', 'Nie – edycja zaznaczonego domu')
okno_przed = Okno.dialog
UI.odpowiedz = 2
Sterowanie.start
Testy.sprawdz(Okno.dialog.equal?(okno_przed), 'Anuluj – bez nowego okna')
UI.odpowiedz = 6
Okno.send(:po_zamknieciu, Okno.dialog)
Testy.sprawdz(Okno.dialog.nil? && Okno.dane_startowe['parametry'] == {} && Okno.dane_startowe['info'] == '', 'po zamknięciu okna nie zostają po nim dane')
Ustawienia.zapamietaj('liczba_wiencow' => '10')

Testy.grupa('Zaznaczona sama ściana prostokąta (kliknięta raz)')
Sketchup.model = Sketchup::Model.new
m = Sketchup.active_model
sciana_prost = m.entities.add_face([[0, 0], [5000, 0], [5000, 4000], [0, 4000]].map { |x, y| Geom::Point3d.new(x / CAL, y / CAL, 0) })
m.selection.add(sciana_prost)
z = Wejscie.z_zaznaczenia(m)
Testy.rowne(z[:segmenty] ? z[:segmenty].length : 0, 4, 'cztery boki z krawędzi ściany')
m.selection.add(sciana_prost.edges[0])
Testy.rowne(Wejscie.z_zaznaczenia(m)[:segmenty].length, 4, 'krawędź zaznaczona drugi raz nie dubluje boku')

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

FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
Testy.koniec
