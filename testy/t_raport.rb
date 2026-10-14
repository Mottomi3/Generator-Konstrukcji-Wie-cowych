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

Testy.grupa('Menu: zapis raportu i podsumowanie')
plik = File.join(ENV['AM_GW_USTAWIENIA'], 'raport')
FileUtils.mkdir_p(ENV['AM_GW_USTAWIENIA'])
UI.plik_zapisu = plik
UI.komunikaty.clear
Sketchup.model = m
Raport.uruchom
Testy.sprawdz(File.exist?(plik + '.json') && JSON.parse(File.read(plik + '.json', encoding: 'UTF-8'))['przyklady'].length == Przyklady.lista.length,
              'raport zapisany w wybranym pliku')
Testy.sprawdz(UI.komunikaty.last.to_s.include?('w porządku') && UI.komunikaty.last.to_s.include?('Raport zapisano'), 'okienko z podsumowaniem')
UI.plik_zapisu = nil

FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
Testy.koniec
