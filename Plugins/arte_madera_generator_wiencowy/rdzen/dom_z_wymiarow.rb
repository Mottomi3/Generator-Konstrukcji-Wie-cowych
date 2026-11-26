# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/dom_z_wymiarow.rb
# Zadanie: dom prostokątny z wymiarów bez rysowania – obrys (lico zewnętrzne) z pól „Długość domu” i „Szerokość domu”, gdy w modelu nic nie jest zaznaczone.
# Tematy: dom z wymiarów, dom prostokątny bez rysowania, obrys z wymiarów, długość domu, szerokość domu, nic nie zaznaczone
# Zależy od: rdzen/parametry.rb (pola dom_dlugosc, dom_szerokosc – rdzen/parametry_lista.rb)
# Używają: sketchup/sterowanie.rb (start bez zaznaczenia, podgląd i generowanie domu z wymiarów)
#
# Propozycja S1 (rundy 14–15, przyjęta do rundy 16): nic nie zaznaczone → okno otwiera się z prostokątem z wymiarów;
# zmiana wymiaru w oknie od razu przelicza dom. Prostokąt jak narysowany ręcznie: lico zewnętrzne ścian, początek w punkcie
# 0,0 modelu, długość wzdłuż osi X. Działowe i węgły ręczne – z tabel okna albo po narysowaniu obrysu w modelu.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module DomZWymiarow
      module_function

      # Wymiary domu [długość, szerokość] w mm z parametrów okna (niepoprawne – wartości fabryczne, poza zakresem – granica).
      def wymiary(parametry)
        p = Parametry.normalizuj(parametry)[0]
        [p['dom_dlugosc'].to_f, p['dom_szerokosc'].to_f]
      end

      # Obrys prostokąta dl × szer [mm] od punktu 0,0: cztery odcinki [[x, y], [x, y]] – jak cztery narysowane linie.
      def prostokat(dl, szer)
        r = [[0.0, 0.0], [dl.to_f, 0.0], [dl.to_f, szer.to_f], [0.0, szer.to_f]]
        (0...4).map { |i| [r[i], r[(i + 1) % 4]] }
      end

      # Odcinki obrysu domu z wymiarów podanych w parametrach.
      def segmenty(parametry)
        prostokat(*wymiary(parametry))
      end
    end
  end
end
