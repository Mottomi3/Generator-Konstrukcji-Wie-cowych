# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/konwersja.rb
# Zadanie: przeliczenia między rdzeniem (mm, tablice) a SketchUpem (cale, Geom::Point3d, Geom::Transformation).
# Tematy: jednostki mm/cale, punkt SketchUpa, transformacja domu (obrót układu lokalnego), transformacja bala, bal obrócony
# Zależy od: rdzen/bale.rb (polozenie), rdzen/parametry.rb
# Używają: sketchup/budowa.rb, sketchup/wejscie.rb
#
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~); wektory tworzone jawnie (Geom::Vector3d.new).

module ArteMadera
  module GeneratorWiencowy
    module Konwersja
      CAL = 25.4 unless const_defined?(:CAL)

      module_function

      # Milimetry → cale (jednostka wewnętrzna SketchUpa).
      def cal(mm)
        mm.to_f / CAL
      end

      # Cale → milimetry.
      def mm(cale)
        cale.to_f * CAL
      end

      # Punkt SketchUpa z [x, y, z] w mm.
      def punkt(xyz)
        Geom::Point3d.new(cal(xyz[0]), cal(xyz[1]), cal(xyz[2] || 0.0))
      end

      # Punkt [x, y, z] w mm z punktu SketchUpa.
      def z_punktu(pt)
        [mm(pt.x), mm(pt.y), mm(pt.z)]
      end

      # Transformacja grupy domu: obrót o kąt układu lokalnego wokół początku modelu i podniesienie na poziom z0 [mm].
      def transformacja_domu(kat, z0)
        c = Math.cos(kat)
        s = Math.sin(kat)
        Geom::Transformation.axes(Geom::Point3d.new(0, 0, cal(z0)), Geom::Vector3d.new(c, s, 0),
                                  Geom::Vector3d.new(-s, c, 0), Geom::Vector3d.new(0, 0, 1))
      end

      # Transformacja instancji bala w grupie domu; bal obrócony – początek na drugim końcu, osie x i y odwrócone.
      def transformacja_bala(b, p)
        pol = Bale.polozenie(b, p)
        o = pol[:poczatek]
        x = pol[:x]
        y = pol[:y]
        if b[:obrocony]
          t = Parametry.grubosc(p)
          o = [o[0] + x[0] * b[:dl] + y[0] * t, o[1] + x[1] * b[:dl] + y[1] * t, o[2]]
          x = [-x[0], -x[1], 0.0]
          y = [-y[0], -y[1], 0.0]
        end
        Geom::Transformation.axes(punkt(o), Geom::Vector3d.new(x[0], x[1], 0), Geom::Vector3d.new(y[0], y[1], 0),
                                  Geom::Vector3d.new(0, 0, 1))
      end
    end
  end
end
