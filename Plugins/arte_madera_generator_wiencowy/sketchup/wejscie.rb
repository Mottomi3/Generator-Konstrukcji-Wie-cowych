# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/wejscie.rb
# Zadanie: odczyt zaznaczenia – narysowane linie (obrys, osie działowych, kontrfory) albo istniejący dom z generatora.
# Tematy: zaznaczenie, krawędzie, zaznaczona ściana (prostokąt kliknięty raz), linie obrysu w grupie, poziom domu z0, płaszczyzna pozioma, wybór domu do edycji
# Zależy od: sketchup/konwersja.rb, sketchup/atrybuty.rb, log.rb
# Używają: sketchup/sterowanie.rb
#
# Linie mogą być luzem albo w grupie / komponencie (z jego przekształceniem). Wszystkie muszą leżeć na jednej
# wysokości – ta wysokość to spód pierwszego bala (z0).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module Wejscie
      # Linie różniące się wysokością o więcej niż tyle [mm] nie leżą w jednej płaszczyźnie.
      TOL_Z = 1.0 unless const_defined?(:TOL_Z)

      module_function

      # Wynik: { dom: grupa } | { segmenty: [...], z0: mm } | { blad: tekst }.
      def z_zaznaczenia(model)
        zazn = model.selection.to_a
        dom = zazn.find { |e| Atrybuty.dom?(e) }
        return { dom: dom } if dom
        krawedzie = []
        zbierz(zazn, Geom::Transformation.new, krawedzie, 0)
        krawedzie = krawedzie.uniq { |e, tr| [e.object_id, tr.object_id] }
        return { blad: 'Zaznacz narysowane linie obrysu domu (lico zewnętrzne), osie ścian działowych i linie kontrforów – ' \
                       'albo dom wygenerowany wcześniej, żeby go edytować.' } if krawedzie.empty?
        segmenty = []
        zs = []
        krawedzie.each do |e, tr|
          a = Konwersja.z_punktu(e.start.position.transform(tr))
          b = Konwersja.z_punktu(e.end.position.transform(tr))
          zs << a[2] << b[2]
          segmenty << [[a[0], a[1]], [b[0], b[1]]]
        end
        if zs.max - zs.min > TOL_Z
          return { blad: format('Zaznaczone linie leżą na różnych wysokościach (%.0f…%.0f mm) – narysuj obrys w jednej płaszczyźnie poziomej.',
                                zs.min, zs.max) }
        end
        { segmenty: segmenty, z0: zs.min }
      end

      # Krawędzie z zaznaczenia (także krawędzie zaznaczonej ściany – prostokąt kliknięty raz – i wnętrza grup
      # i komponentów, z ich przekształceniem).
      def zbierz(lista, tr, wynik, glebokosc)
        return if glebokosc > 4
        lista.each do |e|
          if e.is_a?(Sketchup::Edge)
            wynik << [e, tr]
          elsif e.is_a?(Sketchup::Face)
            e.edges.each { |ed| wynik << [ed, tr] }
          elsif e.is_a?(Sketchup::Group) || e.is_a?(Sketchup::ComponentInstance)
            next if Atrybuty.dom?(e)
            ents = e.is_a?(Sketchup::Group) ? e.entities : e.definition.entities
            zbierz(ents.to_a, tr * e.transformation, wynik, glebokosc + 1)
          end
        end
      end
    end
  end
end
