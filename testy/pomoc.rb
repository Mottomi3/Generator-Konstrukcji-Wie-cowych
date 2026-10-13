# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/pomoc.rb
# Zadanie: wspólne narzędzia testów – sprawdzenia, licznik błędów, przykładowe obrysy (domy testowe).
# Tematy: testy, asercje, domy testowe, obrys prostokątny, obrys w kształcie L, obrót obrysu
# Zależy od: Plugins/arte_madera_generator_wiencowy/rdzen/projekt.rb, rdzen/kontrola.rb
# Używają: testy/t_*.rb
#
# Uruchomienie testu: ruby -I testy/atrapa testy/t_rdzen.rb – ostatnia linia „FAILURES: n”.

ENV['AM_GW_CICHO'] = '1'
KATALOG_WTYCZKI = File.expand_path('../Plugins/arte_madera_generator_wiencowy', File.dirname(__FILE__)) unless defined?(KATALOG_WTYCZKI)
require File.join(KATALOG_WTYCZKI, 'log')
require File.join(KATALOG_WTYCZKI, 'rdzen', 'projekt')
require File.join(KATALOG_WTYCZKI, 'rdzen', 'kontrola')

module Testy
  @bledy = 0
  @ok = 0
  @grupa = ''

  class << self
    attr_reader :bledy, :ok

    def grupa(nazwa)
      @grupa = nazwa
      puts "-- #{nazwa}"
    end

    def sprawdz(warunek, opis)
      if warunek
        @ok += 1
      else
        @bledy += 1
        puts "BŁĄD [#{@grupa}] #{opis}"
      end
      warunek
    end

    def rowne(a, b, opis, tol = 0.01)
      ok = if a.is_a?(Numeric) && b.is_a?(Numeric)
             (a - b).abs <= tol
           else
             a == b
           end
      sprawdz(ok, "#{opis}: jest #{a.inspect}, ma być #{b.inspect}")
    end

    def koniec
      puts "OK: #{@ok}"
      puts "FAILURES: #{@bledy}"
      exit(@bledy.zero? ? 0 : 1)
    end
  end
end

# Odcinki prostokąta (lico zewnętrzne).
def prostokat(x0, y0, x1, y1)
  [[[x0, y0], [x1, y0]], [[x1, y0], [x1, y1]], [[x1, y1], [x0, y1]], [[x0, y1], [x0, y0]]]
end

# Odcinki wielokąta zamkniętego z listy wierzchołków.
def wielokat(punkty)
  (0...punkty.length).map { |i| [punkty[i], punkty[(i + 1) % punkty.length]] }
end

# Obrót odcinków o kąt [stopnie] wokół początku układu.
def obroc_odcinki(odcinki, stopnie)
  k = stopnie * Math::PI / 180.0
  odcinki.map { |s| s.map { |p| [p[0] * Math.cos(k) - p[1] * Math.sin(k), p[0] * Math.sin(k) + p[1] * Math.cos(k)] } }
end

# Podział odcinka na kawałki (jak SketchUp dzieli krawędź w punktach styku).
def podziel(odcinek, *t)
  a, b = odcinek
  punkty = [a] + t.map { |u| [a[0] + (b[0] - a[0]) * u, a[1] + (b[1] - a[1]) * u] } + [b]
  punkty.each_cons(2).to_a
end

# Plan samych ścian (bez szczytów i podłogi – testy ścian z kompilacji 1); parametry nadpisują.
def plan(segmenty, parametry = {}, otwory = [])
  plan_pelny(segmenty, { 'szczyty' => 'nie', 'podloga' => 'nie' }.merge(parametry), otwory)
end

# Plan domu z parametrami domyślnymi (ze szczytami, dachem i podłogą).
def plan_pelny(segmenty, parametry = {}, otwory = [])
  ArteMadera::GeneratorWiencowy::Projekt.oblicz('segmenty' => segmenty, 'parametry' => parametry, 'otwory' => otwory)
end

# Ściana planu po identyfikatorze.
def sciana(pl, id)
  pl[:sciany].find { |w| w[:id] == id }
end
