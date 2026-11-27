# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/dom_z_wymiarow.rb
# Zadanie: dom prostokątny z wymiarów bez rysowania – obrys (lico zewnętrzne) z pól „Długość domu” i „Szerokość domu”, gdy w modelu nic nie jest zaznaczone; ściany działowe z tabeli okna.
# Tematy: dom z wymiarów, dom prostokątny bez rysowania, obrys z wymiarów, długość domu, szerokość domu, nic nie zaznaczone, działowe z tabeli okna, działowa w domu z wymiarów
# Zależy od: rdzen/parametry.rb (pola dom_dlugosc, dom_szerokosc – rdzen/parametry_lista.rb)
# Używają: sketchup/sterowanie.rb (start bez zaznaczenia, podgląd i generowanie domu z wymiarów)
#
# Propozycja S1 (rundy 14–15, przyjęta do rundy 16): nic nie zaznaczone → okno otwiera się z prostokątem z wymiarów;
# zmiana wymiaru w oknie od razu przelicza dom. Prostokąt jak narysowany ręcznie: lico zewnętrzne ścian, początek w punkcie
# 0,0 modelu, długość wzdłuż osi X. Węgły ręczne – z tabeli okna. Działowe (runda 17) – z tabeli „Ściany działowe” w oknie:
# { kierunek: 'poprzek' (równoległa do szerokości, linia x = od) | 'wzdluz' (równoległa do długości, y = od), od – oś
# działowej od lica zewnętrznego ściany początkowej, poczatek (puste – od lica), dlugosc (puste – do lica naprzeciw) } –
# jak linia narysowana w środku obrysu (oś działowej od lica do lica albo do wolnego końca).
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

      # Odcinki obrysu domu z wymiarów podanych w parametrach i osie działowych z tabeli okna.
      def segmenty(parametry, dzialowe = [])
        dl, szer = wymiary(parametry)
        prostokat(dl, szer) + osie_dzialowych(dzialowe, dl, szer)
      end

      # Osie działowych z tabeli: [[x, y], [x, y]] w obrysie dl × szer; wiersz bez „od” albo poza obrysem – pominięty.
      def osie_dzialowych(dzialowe, dl, szer)
        (dzialowe || []).map do |d|
          next unless d.is_a?(Hash)
          wzdluz = d['kierunek'].to_s == 'wzdluz'
          od = Parametry.liczba(d['od'])
          poprzeczny = wzdluz ? szer : dl
          zasieg = wzdluz ? dl : szer
          next if od.nil? || od <= 0.0 || od >= poprzeczny
          a = [[Parametry.liczba(d['poczatek']) || 0.0, 0.0].max, zasieg].min
          dlug = Parametry.liczba(d['dlugosc'])
          b = dlug && dlug > 0.0 ? [a + dlug, zasieg].min : zasieg
          next if b - a < 1.0
          wzdluz ? [[a, od], [b, od]] : [[od, a], [od, b]]
        end.compact
      end
    end
  end
end
