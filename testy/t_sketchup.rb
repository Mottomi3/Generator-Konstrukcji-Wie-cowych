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
Testy.rowne(PLUGIN_BUILD, '16', 'numer kompilacji')
Testy.sprawdz(defined?(ArteMadera::GeneratorWiencowy::Menu) ? true : false, 'moduły załadowane')
Testy.rowne(MODULE_FILES.length, Dir.glob(File.join(KATALOG_WTYCZKI, '{rdzen,sketchup}', '*.rb')).length, 'liczba modułów = pliki rdzen/ i sketchup/')
Testy.rowne([Ustawienia.standard, TypyDomow.wlasne], [{}, {}], 'bez zapisanego standardu i własnych typów na starcie testu')

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
Testy.sprawdz(d['typy']['lista'].count { |x| x['wbudowany'] } == 4 && d['typy']['typ'].start_with?('Typ 100'), 'typy wbudowane w oknie, wybrany Typ 100')
Testy.sprawdz(d['podsumowanie']['sciany'].length >= 5, 'podsumowanie ścian w danych startowych')
Testy.sprawdz(d['info'].include?('300 mm'), 'informacja o wysokości linii')

Testy.grupa('Podgląd z okna')
dlg.wywolaj('podglad', JSON.generate('parametry' => { 'liczba_wiencow' => '12', 'max_dlugosc' => '7000' }, 'otwory' => []))
w = ostatni_wynik(dlg)
Testy.rowne(w['bledy'], [], 'podgląd bez błędów')
Testy.rowne(w['wysokosci']['okapowa'], 12 * 139 + 69.5, 'wysokość po zmianie liczby wieńców')
Testy.rowne(m.entities.grep(Sketchup::Group).length, 0, 'podgląd nie zmienia modelu')
Testy.sprawdz(!File.exist?(Ustawienia.sciezka), 'podgląd niczego nie zapisuje na komputerze (nowy dom zaczyna od typu i standardu – runda 16)')
Testy.sprawdz(w['uwagi'].is_a?(Array) && w['uwagi'].all? { |u| %w[blad ostrzezenie uwaga ok].include?(u['poziom']) && !u['krok'].to_s.empty? } &&
              w['obrys_rodzaj'] == 'prostokat' && w['powierzchnie'].first[0] == 'Powierzchnia zabudowy', 'wynik z listą uwag, rodzajem obrysu i powierzchniami')
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

Testy.grupa('Typy domów i standard warsztatu w oknie (runda 16) – szczegóły w testy/t_typy.rb')
model_z_liniami(prostokat(0, 0, 5000, 4000))
Sterowanie.start
dlg = Okno.dialog
dlg.wywolaj('gotowe')
d = ostatni_skrypt(dlg, 'AMGW.init(')
Testy.rowne([d['parametry']['liczba_wiencow'], d['parametry']['max_dlugosc']], ['16', nil], 'nowy dom: pola Typu 100 i standard fabryczny – bez wartości z poprzedniego podglądu (było 12 wieńców i bal 7000)')
Testy.rowne([d['uklad'], d['kroki'].map { |k| k['klucz'] }, d['z_wymiarow']], ['kroki', %w[sciany otwory dach taras podloga zestawienie], false], 'układ nowy, sześć kroków')
Testy.sprawdz(d['opisy'].all? { |o| %w[dom typ standard].include?(o['poziom']) && d['kroki'].any? { |k| k['klucz'] == o['krok'] } }, 'każde pole ma poziom i krok')
dlg.wywolaj('typ_zapisz', JSON.generate('typ' => d['typy']['typ'], 'nazwa' => 'Mój domek', 'opis' => 'letni', 'parametry' => { 'liczba_wiencow' => '18', 'dach_kat' => '30', 'max_dlugosc' => '4800' }))
t = ostatni_skrypt(dlg, 'AMGW.typy(')
Testy.sprawdz(t['lista'].any? { |x| x['nazwa'] == 'Mój domek' && x['opis'] == 'letni' && !x['wbudowany'] } && t['typ'] == 'Mój domek' && t['komunikat'].include?('Zapisano'),
              'typ zapisany z opisem i wybrany')
Testy.rowne([t['baza']['liczba_wiencow'], t['baza']['dach_kat'], t['baza']['max_dlugosc']], [18, 30.0, 5100.0], 'baza typu: pola typu i domu z typu, pole standardu ze standardu')
nazwa = TypyDomow.lista.find { |x| x['nazwa'].start_with?('Typ 300') }['nazwa']
dlg.wywolaj('typ_wybierz', nazwa)
t = ostatni_skrypt(dlg, 'AMGW.typy(')
Testy.rowne([t['typ'], t['wczytaj'], t['baza']['liczba_wiencow'], t['baza']['strop'], TypyDomow.wybrany], [nazwa, true, 25, 'tak', nazwa], 'wybór typu wbudowanego: 25 wieńców ze stropem, zapamiętany')
dlg.wywolaj('typ_zapisz', JSON.generate('typ' => nazwa, 'nazwa' => nazwa, 'opis' => nil, 'parametry' => {}))
Testy.sprawdz(ostatni_skrypt(dlg, 'AMGW.typy(')['blad'].to_s.include?('wbudowany'), 'typu wbudowanego nie można nadpisać')
dlg.wywolaj('typ_powiel', JSON.generate('nazwa' => nazwa, 'nowa' => 'Moje 300'))
t = ostatni_skrypt(dlg, 'AMGW.typy(')
Testy.sprawdz(t['typ'] == 'Moje 300' && TypyDomow.parametry('Moje 300') == TypyDomow.parametry(nazwa), 'powielenie typu wbudowanego')
dlg.wywolaj('typ_usun', 'Moje 300')
dlg.wywolaj('typ_usun', 'Mój domek')
Testy.sprawdz(TypyDomow.wlasne.empty? && ostatni_skrypt(dlg, 'AMGW.typy(')['typ'].start_with?('Typ 100'), 'typy usunięte – wybrany wraca do pierwszego wbudowanego')
dlg.wywolaj('standard_zapisz', JSON.generate('typ' => nazwa, 'parametry' => { 'mijanka' => '500', 'liczba_wiencow' => '9', 'max_dlugosc' => '5100' }))
t = ostatni_skrypt(dlg, 'AMGW.typy(')
Testy.rowne([t['standard'], t['baza']['mijanka'], t['baza']['liczba_wiencow'], Ustawienia.standard], [true, 500.0, 25, { 'mijanka' => '500' }],
            'zapis standardu: tylko pola standardu inne niż fabryczne; baza z nowym standardem')
dlg.wywolaj('standard_fabryczne', nazwa)
Testy.rowne([Ustawienia.standard, ostatni_skrypt(dlg, 'AMGW.typy(')['baza']['mijanka']], [{}, Parametry::DOMYSLNE['mijanka']], 'powrót standardu do wartości fabrycznych')
dlg.wywolaj('uklad', 'zakladki')
Testy.rowne([Ustawienia.uklad, Okno.dane_startowe['uklad']], %w[zakladki zakladki], 'układ okna zapamiętany na komputerze')
dlg.wywolaj('uklad', 'cokolwiek')
Testy.rowne(Ustawienia.uklad, 'kroki', 'nieznany układ – nowy')
Testy.rowne(Okno.dane_startowe['tryb_pol'], 'podstawowe', 'tryb pól okna: domyślnie podstawowe')
dlg.wywolaj('tryb_pol', 'wszystkie')
Testy.rowne([Ustawienia.tryb_pol, Okno.dane_startowe['tryb_pol']], %w[wszystkie wszystkie], 'tryb pól okna zapamiętany na komputerze')
dlg.wywolaj('tryb_pol', 'cokolwiek')
Testy.rowne(Ustawienia.tryb_pol, 'podstawowe', 'nieznany tryb pól – podstawowe')
Testy.sprawdz(Okno.dane_startowe['opisy'].count { |o| o['podstawowy'] } >= 20, 'opisy pól z oznaczeniem podstawowych')
# Dalsze testy budują małe domy – własny typ z 10 wieńcami jako wybrany.
TypyDomow.zapisz('Test – 10 wieńców', 'do testów', 'liczba_wiencow' => '10')

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
TypyDomow.zapisz('Test – 10 wieńców', 'do testów', 'liczba_wiencow' => '10')

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
# Nic nie zaznaczone – dom prostokątny z wymiarów (S1, runda 16); wcześniej komunikat „Zaznacz…”.
dw = Okno.dialog
dw.wywolaj('gotowe')
iw = ostatni_skrypt(dw, 'AMGW.init(')
Testy.sprawdz(UI.komunikaty.empty? && iw['z_wymiarow'] == true && iw['info'].include?('z wymiarów') && iw['tryb'] == 'nowy', 'puste zaznaczenie – okno domu z wymiarów')
Testy.rowne(iw['podsumowanie']['powierzchnie'].first[1], '24', 'dom fabryczny 6000 × 4000: zabudowa 24 m²')
dw.wywolaj('podglad', JSON.generate('parametry' => { 'dom_dlugosc' => '8000', 'dom_szerokosc' => '5000', 'liczba_wiencow' => '10' }, 'otwory' => []))
ww = ostatni_wynik(dw)
Testy.rowne([ww['bledy'], ww['powierzchnie'].first[1], ww['obrys_rodzaj']], [[], '40', 'prostokat'], 'zmiana wymiarów w oknie – nowy obrys 8000 × 5000')
dw.wywolaj('generuj', JSON.generate('parametry' => { 'dom_dlugosc' => '5000', 'dom_szerokosc' => '3500', 'liczba_wiencow' => '6' }, 'otwory' => [], 'typ' => iw['typy']['typ']))
gw = ostatni_wynik(dw)
domw = Sketchup.active_model.entities.grep(Sketchup::Group).find { |g| Atrybuty.dom?(g) }
wejw = domw ? Atrybuty.czytaj_wejscie(domw) : {}
Testy.sprawdz(gw['zbudowano'] == true && wejw['z_wymiarow'] == true && wejw['typ'] == iw['typy']['typ'] && wejw['segmenty'].length == 4,
              'dom z wymiarów wygenerowany; w modelu zapisane: z wymiarów, typ, cztery odcinki obrysu')
Sketchup.active_model.selection.clear
Sketchup.active_model.selection.add(domw)
Sterowanie.start
Okno.dialog.wywolaj('gotowe')
ew = ostatni_skrypt(Okno.dialog, 'AMGW.init(')
Testy.rowne([ew['tryb'], ew['z_wymiarow'], ew['parametry']['dom_dlugosc']], ['edycja', true, '5000'], 'edycja domu z wymiarów – pola wymiarów wracają')
# Dom zapisany przed rundą 16 (osobne pola podbitki i nadbitki) – okno edycji dostaje jedno pole położenia desek.
stare = Atrybuty.czytaj_wejscie(domw)
stare['parametry'] = stare['parametry'].merge('podbitka' => 'nie', 'poszycie_nadbitka' => 'tak', 'nadbitka_grubosc' => '19', 'dach_uklad' => 'krokwie')
domw.set_attribute(Atrybuty::DICT_GW, 'wejscie', JSON.generate(stare))
Sterowanie.start
Okno.dialog.wywolaj('gotowe')
ps = ostatni_skrypt(Okno.dialog, 'AMGW.init(')['parametry']
Testy.rowne([ps['podbitka'], ps['podbitka_grubosc'], ps.key?('poszycie_nadbitka')], ['na_krokwiach', '19', false], 'edycja starego domu: nadbitka → deski na krokwiach z jej grubością')
m = Sketchup::Model.new
Sketchup.model = m
m.selection.add(m.entities.add_line(Geom::Point3d.new(0, 0, 0), Geom::Point3d.new(100, 0, 0)))
m.selection.add(m.entities.add_line(Geom::Point3d.new(0, 0, 10), Geom::Point3d.new(0, 100, 10)))
UI.komunikaty.clear
Sterowanie.start
Testy.sprawdz(UI.komunikaty.last.to_s.include?('różnych wysokościach'), 'linie na różnych wysokościach – komunikat')

FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
Testy.koniec
