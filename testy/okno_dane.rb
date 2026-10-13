# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/okno_dane.rb
# Zadanie: dane okna z prawdziwego przebiegu (atrapa SketchUpa) – wypisuje JSON { init:, wynik: } dla testu okna w przeglądarce.
# Tematy: dane testowe okna, init okna, wynik okna
# Zależy od: testy/atrapa/sketchup.rb, testy/pomoc.rb
# Używają: testy/t_okno.js
#
# Uruchomienie: ruby -I testy/atrapa testy/okno_dane.rb

require 'json'
require 'tmpdir'
require 'fileutils'
ENV['AM_GW_USTAWIENIA'] = File.join(Dir.tmpdir, "am_gw_okno_#{Process.pid}")
require File.expand_path('atrapa/sketchup', File.dirname(__FILE__))
require File.expand_path('pomoc', File.dirname(__FILE__))
require File.join(KATALOG_WTYCZKI, 'main.rb')
include ArteMadera::GeneratorWiencowy

m = Sketchup::Model.new
Sketchup.model = m
seg = prostokat(0, 0, 7000, 4500) + [[[3500, 0], [3500, 4500]], [[1500, -150], [1500, 150]]]
seg.each do |a, b|
  m.selection.add(m.entities.add_line(Geom::Point3d.new(a[0] / 25.4, a[1] / 25.4, 0), Geom::Point3d.new(b[0] / 25.4, b[1] / 25.4, 0)))
end
Sterowanie.start
init = Okno.dane_startowe
wynik = Sterowanie.podglad('parametry' => { 'max_dlugosc' => '5000' },
                           'otwory' => [{ 'sciana' => 'W-1', 'od' => '800', 'szerokosc' => '1020', 'wysokosc' => '1010', 'parapet' => '900' }])
FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
puts JSON.generate('init' => init, 'wynik' => wynik)
