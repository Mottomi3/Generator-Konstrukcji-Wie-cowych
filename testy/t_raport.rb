# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_raport.rb
# Zadanie: test działania z menu (atrapa SketchUpa) – przykładowe domy bez błędów, budowa cofnięta (model bez zmian), bryły zamknięte i objętości, zaznaczony dom, raport JSON.
# Tematy: testy raportu, test działania, przykładowe domy, cofnięcie operacji, bryła zamknięta, objętość bryły, raport JSON
# Zależy od: testy/atrapa/sketchup.rb, testy/pomoc.rb, Plugins/.../sketchup/raport.rb, rdzen/przyklady.rb
# Używają: testy/uruchom.sh

require 'json'
require 'tmpdir'
require 'fileutils'
ENV['AM_GW_USTAWIENIA'] = File.join(Dir.tmpdir, "am_gw_raport_#{Process.pid}")
require File.expand_path('atrapa/sketchup', File.dirname(__FILE__))
require File.expand_path('pomoc', File.dirname(__FILE__))
require File.join(KATALOG_WTYCZKI, 'main.rb')
include ArteMadera::GeneratorWiencowy

CAL = 25.4

Testy.grupa('Przykładowe domy liczą się bez błędów')
Przyklady.lista.each do |pr|
  pl = Projekt.oblicz(pr['wejscie'])
  Testy.rowne(pl[:bledy], [], pr['nazwa'])
end
Testy.rowne(Przyklady.lista.map { |x| x['nazwa'] }.uniq.length, Przyklady.lista.length, 'nazwy przykładów różne')

Testy.grupa('Test działania: zaznaczony dom i przykłady, model bez zmian')
m = Sketchup::Model.new
Sketchup.model = m
prostokat(0, 0, 5000, 4000).each do |a, b|
  m.selection.add(m.entities.add_line(Geom::Point3d.new(a[0] / CAL, a[1] / CAL, 0), Geom::Point3d.new(b[0] / CAL, b[1] / CAL, 0)))
end
Sterowanie.start
Sterowanie.generuj('parametry' => {}, 'otwory' => [])
dom = m.selection.to_a.first
Testy.sprawdz(Atrybuty.dom?(dom), 'dom zbudowany i zaznaczony')
przed = [m.entities.to_a.length, m.definitions.length]
m.operacje.clear
r = Raport.zbierz(m)
Testy.rowne([m.entities.to_a.length, m.definitions.length], przed, 'po teście model bez zmian (operacja cofnięta)')
Testy.rowne([m.operacje.first, m.operacje.last], [[:start, 'ArteMadera – test działania'], [:abort]], 'jedna operacja, cofnięta')
Testy.rowne(r['przyklady'].length, Przyklady.lista.length, 'wynik dla każdego przykładu')
r['przyklady'].each do |w|
  Testy.sprawdz(w['wyjatek'].nil? && w['zgodny'],
                "#{w['nazwa']}: zgodny (niezamknięte #{(w['niezamkniete'] || []).length}, inna objętość #{(w['inna_objetosc'] || []).first(2).inspect}, " \
                "instancje #{w['model'] && w['model']['instancje']} z #{w['plan']['bale'] + w['plan']['belki']}, wyjątek #{w['wyjatek']})")
end
z = r['zaznaczony_dom']
Testy.sprawdz(z && z['zmieniony_recznie'] == false && z['kompilacja_domu'] == PLUGIN_BUILD, 'zaznaczony dom: bez ręcznych zmian, ta kompilacja')
Testy.rowne(z['model']['instancje'], z['plan']['bale'] + z['plan']['belki'], 'zaznaczony dom: tyle instancji, co bali i belek')
Testy.rowne(r['srodowisko']['kompilacja'], PLUGIN_BUILD, 'środowisko: kompilacja')
Testy.rowne(r['srodowisko']['ruby'], RUBY_VERSION, 'środowisko: wersja Ruby')
tekst = JSON.generate(r)
Testy.sprawdz(tekst.length > 1000 && JSON.parse(tekst)['przyklady'].length == r['przyklady'].length, 'raport zapisuje się jako JSON')

Testy.grupa('Bryła z brakującą ścianą wykryta')
pl = Projekt.oblicz(Przyklady.lista[0]['wejscie'])
m2 = Sketchup::Model.new
zb = Budowa.zbuduj_w_operacji(m2, pl, Przyklady.lista[0]['wejscie'])
poz = pl[:pozycje].first
d = zb[:defs][poz[:nr]]
# Ściana znika bez dorysowania gdzie indziej (Face#erase! w atrapie zamienia ją w otwór sąsiedniej ściany).
d.entities.to_a.find { |e| e.is_a?(Sketchup::Face) }.instance_variable_set(:@valid, false)
b = Raport.bryly(pl, zb[:defs])
Testy.rowne(b['niezamkniete'], [poz[:nazwa]], 'niezamknięta bryła na liście')

Testy.grupa('Test działania z menu i paska: raport zapisuje się sam, wynik jednym zdaniem (runda 14)')
FileUtils.mkdir_p(ENV['AM_GW_USTAWIENIA'])
UI.plik_zapisu = nil
UI.komunikaty.clear
Sketchup.model = m
r = Raport.uruchom
pliki = Dir.glob(File.join(DziennikPracy.katalog, "raport_*_k#{PLUGIN_BUILD}.json"))
Testy.rowne(pliki.length, 1, 'jeden plik raportu w folderze raportów – bez okna zapisu')
Testy.sprawdz(DziennikPracy.katalog.start_with?(ENV['AM_GW_USTAWIENIA']), 'testy: folder raportów pod katalogiem tymczasowym (nie w katalogu domowym)')
zap = JSON.parse(File.read(pliki[0], encoding: 'UTF-8'))
Testy.rowne(zap['przyklady'].length, Przyklady.lista.length, 'raport w pliku: wszystkie przykłady')
Testy.rowne([zap['wynik']['domy'], zap['wynik']['w_porzadku'], zap['wynik']['problemy']], [Przyklady.lista.length, Przyklady.lista.length, []],
            'raport w pliku: wynik – wszystkie domy w porządku')
Testy.sprawdz(zap['przyklady'].all? { |w| w['kontrola'].key?('nakladanie') && w['kontrola']['nakladanie'].zero? }, 'kontrola ścian równoległych w raporcie')
Testy.sprawdz(zap['dziennik_pracy'].is_a?(Array) && zap['dziennik_pracy'].any? { |w| w['zdarzenie'] == 'generowanie' },
              'raport zawiera dziennik pracy (wygenerowany wcześniej dom)')
ok = UI.komunikaty.last.to_s
Testy.sprawdz(ok.start_with?("WSZYSTKO W PORZĄDKU – #{Przyklady.lista.length} z #{Przyklady.lista.length}"), "okienko zaczyna się od wyniku (#{ok[0, 60]})")
Testy.sprawdz(ok.include?('Raport zapisał się sam') && ok.include?(pliki[0]), 'okienko: gdzie jest raport')
# Dom z problemem – wynik mówi o problemach.
zly = r.merge('przyklady' => r['przyklady'].map.with_index { |w, i| i == 1 ? w.merge('zgodny' => false, 'niezamkniete' => ['1-3600']) : w })
Testy.rowne(Raport.wynik(zly)['problemy'], [Przyklady.lista[1]['nazwa']], 'wynik: dom niezgodny na liście problemów')
Testy.sprawdz(Raport.podsumowanie(zly.merge('wynik' => Raport.wynik(zly))).start_with?("PROBLEMY w 1 z #{Przyklady.lista.length}"), 'okienko: problemy na początku')

Testy.grupa('Dziennik pracy: wiersz po każdym wygenerowaniu domu (runda 14)')
wp = DziennikPracy.ostatnie(10).select { |w| w['zdarzenie'] == 'generowanie' }.last
Testy.sprawdz(wp && wp['tryb'] == 'nowy' && wp['kompilacja'] == PLUGIN_BUILD, 'wpis: tryb i kompilacja')
Testy.sprawdz(wp['bale'] > 0 && wp['sciany'] >= 4 && wp['definicje'] > 0 && wp['ms_obliczen'].to_f > 0 && wp['ms_budowy'].to_f > 0, 'wpis: liczby i czasy obliczeń i budowy')
Testy.rowne([wp['obrys']['boki'], wp['obrys']['x'], wp['obrys']['y'], wp['zmienione']], [4, 5000, 4000, {}], 'wpis: obrys 5 × 4 m, ustawienia fabryczne')
m.selection.clear
m.selection.add(dom)
Sterowanie.start
Sterowanie.generuj('parametry' => { 'liczba_wiencow' => '12', 'dach_kat' => '30' }, 'otwory' => [])
wp = DziennikPracy.ostatnie(1).last
Testy.rowne([wp['tryb'], wp['zmienione']], ['edycja', { 'liczba_wiencow' => 12, 'dach_kat' => 30.0 }], 'edycja domu: tryb i zmienione ustawienia')
(DziennikPracy::MAX_WIERSZY + DziennikPracy::ZAPAS + 5).times { |i| DziennikPracy.dopisz('zdarzenie' => 'próba', 'nr' => i) }
Testy.sprawdz(File.readlines(File.join(DziennikPracy.katalog, DziennikPracy::PLIK)).length <= DziennikPracy::MAX_WIERSZY + DziennikPracy::ZAPAS,
              'dziennik nie rośnie bez końca')

FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
Testy.koniec
