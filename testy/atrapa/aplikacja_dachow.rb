# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/atrapa/aplikacja_dachow.rb
# Zadanie: atrapa aplikacji do dachów (ArteMadera::Roof) – Footprint, RoofBuilder.generate, Config, Commands.generate_framing – zapisuje wywołania generatora.
# Tematy: atrapa aplikacji do dachów, połacie w atrapie, KROK 2 w atrapie, ustawienia aplikacji w atrapie
# Zależy od: testy/atrapa/sketchup.rb
# Używają: testy/t_dach_aplikacja.rb
#
# Tylko to, czego używa sketchup/dach_aplikacja.rb (te same nazwy i kształt danych co w aplikacji 3.3): połacie to
# grupa „Dach - polacie” z jedną poziomą ścianą obrysu (do ramy – bounds) i atrybutem ArteMaderaRoof.type.
# AtrapaDachow.wywolania – lista [nazwa, dane]; AtrapaDachow.blad – komunikat, którym RoofBuilder odmówi.

module ArteMadera
  module Roof
    class Footprint
      attr_reader :points_2d, :holes_2d, :base_z, :source

      def initialize(points_2d, base_z, source, holes_2d = [])
        @points_2d = points_2d
        @holes_2d = holes_2d
        @base_z = base_z
        @source = source
      end

      def edge_count
        @points_2d.length
      end
    end

    module Config
      DEFAULTS_ROOF = { angle_deg: 35.0, overhang_mm: 500.0, gable_edges: '', edge_angles: '', make_group: true,
                        keep_base_face: false }.freeze

      def self.load_settings(kind)
        AtrapaDachow.wywolania << [:load_settings, kind]
        kind == :roof ? DEFAULTS_ROOF.dup : (AtrapaDachow.framing || {}).dup
      end

      def self.save_settings(kind, settings)
        AtrapaDachow.wywolania << [:save_settings, kind, settings]
        AtrapaDachow.framing = (AtrapaDachow.framing || {}).merge(settings) if kind == :framing
        true
      end
    end

    module RoofBuilder
      def self.generate(model, footprint, settings)
        AtrapaDachow.wywolania << [:generate, footprint, settings]
        return [nil, AtrapaDachow.blad] if AtrapaDachow.blad
        g = model.active_entities.add_group
        g.name = 'Dach - polacie'
        g.entities.add_face(footprint.points_2d.map { |x, y| Geom::Point3d.new(x, y, footprint.base_z) })
        g.set_attribute('ArteMaderaRoof', 'type', 'roof_planes')
        [g, 'Utworzono polacie dachu.']
      end
    end

    module Commands
      def self.generate_framing
        AtrapaDachow.wywolania << [:generate_framing, Sketchup.active_model.selection.to_a]
        nil
      end
    end
  end
end

module AtrapaDachow
  class << self
    attr_accessor :blad, :framing

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
      @framing = nil
    end
  end
end
