# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/atrapa/aplikacja_dachow.rb
# Zadanie: atrapa aplikacji do dachów (ArteMadera::Roof) – jej stałe API wersji 1 (polacie, podpory, wiezba) – zapisuje wywołania generatora.
# Tematy: atrapa aplikacji do dachów, atrapa API dachów, połacie w atrapie, KROK 2 w atrapie, podpory w atrapie, więźba po OK w atrapie
# Zależy od: testy/atrapa/sketchup.rb
# Używają: testy/t_dach_aplikacja.rb
#
# Tylko to, czego używa sketchup/dach_aplikacja.rb (te same nazwy i kształt danych co API.md aplikacji 3.7.0): połacie
# to grupa „Dach - polacie” z jedną poziomą ścianą obrysu (do ramy – bounds) i atrybutami ArteMaderaRoof (type, api),
# podpory – JSON w grupie połaci (ArteMaderaRoof.supports), więźba – okno: [true, nil], procedura po OK zapamiętana
# w AtrapaDachow.po_ok (test woła ją z grupą „Wiezba dachowa” albo nil). AtrapaDachow.wywolania – lista [nazwa, dane…];
# AtrapaDachow.blad – komunikat, którym API.polacie odmówi; AtrapaDachow.blad_wiezby – odmowa API.wiezba.

require 'json'

module ArteMadera
  module Roof
    PLUGIN_VERSION = '3.7.0'.freeze unless const_defined?(:PLUGIN_VERSION)

    module API
      def self.wersja
        1
      end

      def self.wersja_wtyczki
        PLUGIN_VERSION
      end

      def self.polacie(model, punkty, z, kat, okap, krawedzie_szczytowe = [], opcje = {})
        AtrapaDachow.wywolania << [:polacie, punkty, z, kat, okap, krawedzie_szczytowe, opcje]
        return [nil, AtrapaDachow.blad] if AtrapaDachow.blad
        pts = punkty.map { |q| q.is_a?(Geom::Point3d) ? q : Geom::Point3d.new(q[0] / 25.4, q[1] / 25.4, (q[2] || 0.0) / 25.4) }
        zc = z ? z / 25.4 : pts.inject(0.0) { |s, q| s + q.z } / pts.length
        g = model.active_entities.add_group
        g.name = 'Dach - polacie'
        g.entities.add_face(pts.map { |q| Geom::Point3d.new(q.x, q.y, zc) })
        g.set_attribute('ArteMaderaRoof', 'type', 'roof_planes')
        g.set_attribute('ArteMaderaRoof', 'api', 1)
        if opcje.fetch(:zaznacz, true)
          model.selection.clear
          model.selection.add(g)
        end
        [g, 'Utworzono połacie dachu.']
      end

      def self.podpory(grupa, lista, _model = nil)
        AtrapaDachow.wywolania << [:podpory, grupa, lista]
        grupa.set_attribute('ArteMaderaRoof', 'supports', lista.nil? ? '' : JSON.generate('podpory' => lista))
        [true, "Podpory zapisane w grupie połaci: #{(lista || []).length}."]
      end

      def self.wiezba(grupa, ustawienia = {}, opcje = {})
        AtrapaDachow.wywolania << [:wiezba, grupa, ustawienia, opcje]
        return [nil, AtrapaDachow.blad_wiezby] if AtrapaDachow.blad_wiezby
        AtrapaDachow.po_ok = opcje[:po_generowaniu]
        [true, nil]
      end
    end
  end
end

module AtrapaDachow
  class << self
    attr_accessor :blad, :blad_wiezby, :po_ok

    def wywolania
      @wywolania ||= []
    end

    # Ostatnie wywołanie o nazwie (nil – nie było).
    def ostatnie(nazwa)
      wywolania.reverse.find { |w| w[0] == nazwa }
    end

    def wyczysc
      wywolania.clear
      @blad = nil
      @blad_wiezby = nil
      @po_ok = nil
    end
  end
end
