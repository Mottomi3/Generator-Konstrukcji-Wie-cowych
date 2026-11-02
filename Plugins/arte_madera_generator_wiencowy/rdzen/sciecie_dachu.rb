# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/sciecie_dachu.rb
# Zadanie: bale ścian wzdłuż kalenicy wystające nad płaszczyznę dachu ścięte w poprzek do tej płaszczyzny – górny bal ściany okapowej przy ścianie nośnej, ściana wysoka dachu jednospadowego, działowa wzdłużna pod dachem.
# Tematy: ścięcie dachu, wyrównanie ścięcia do granic pasów, węgieł przy szczycie ścięty do dachu, górny bal ścięty do płaszczyzny dachu, ściana nośna, ściana okapowa pod dachem, ściana wysoka – ścięcie skośne, działowa wzdłużna pod połacią, bal skośny w poprzek
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia), rdzen/bale.rb (położenie bala), rdzen/podbitka.rb (obniżenie)
# Używają: rdzen/projekt.rb (po balach, przed zamkami i pozycjami)
#
# Ściany wzdłuż kalenicy (kierunek A) mają płaszczyznę dachu stałą wzdłuż bala, zmienną w poprzek: na licu y = 0
# i y = t bala inna wysokość linii podparcia. Bal, którego wierzch jest wyżej niż płaszczyzna na którymkolwiek licu,
# dostaje obróbkę sciecie_dachu { z0: (y = 0), z1: (y = t) } na całej długości (rdzen/bryla.rb – pasy ze skośnym
# wierzchem). Tylko dom prostokątny z dachem z generatora (dom ze szczytów). Węgły przy szczycie (biegną wzdłuż kalenicy)
# – górny bal słupka węgła ścięty tak samo, pod podbitką „pod” niżej o jej obniżenie.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'bale') unless defined?(ArteMadera::GeneratorWiencowy::Bale)
require File.join(File.dirname(__FILE__), 'podbitka') unless defined?(ArteMadera::GeneratorWiencowy::Podbitka)
require File.join(File.dirname(__FILE__), 'bryla') unless defined?(ArteMadera::GeneratorWiencowy::Bryla)
require File.join(File.dirname(__FILE__), 'profil_bala') unless defined?(ArteMadera::GeneratorWiencowy::ProfilBala)

module ArteMadera
  module GeneratorWiencowy
    module SciecieDachu
      # Ścięcie płytsze niż tyle [mm] na wyższym licu pomijane (bal pod dachem z dokładnością obróbki).
      MIN = 0.2 unless const_defined?(:MIN)

      module_function

      # Ścina bale ścian wzdłuż kalenicy do płaszczyzny dachu; dom – opis dachu (Szczyty.dom_prostokatny), nil – nic.
      def przytnij!(bale, p, dom)
        return if dom.nil? || !Parametry.tak?(p, 'szczyty')
        iv = dom[:os] == :x ? 1 : 0
        geo = { v_a: dom[:v_a], v_b: dom[:v_b] }
        t = Parametry.grubosc(p)
        bale.each do |b|
          next unless b[:sciana][:kierunek] == :A
          c = sciecie(b, p, geo, iv, t)
          b[:cechy] << c if c
        end
      end

      # Ścięcia bliskie granic przekroju: gdzie płaszczyzna ścięcia przecina poziom wierzchu (dno gniazda zamka, wierzch
      # pióra) bliżej niż 0,2 mm od granicy pasa (podcięcie, pióro), płaszczyzna przesunięta równolegle tak, by przecięcie
      # wypadło na granicy – krawędź krótsza niż tolerancja SketchUpa psuje bryłę. Po zamkach i oznaczeniu profilu.
      def wyrownaj!(bale, p)
        t = Parametry.grubosc(p)
        opis = ProfilBala.pelny?(p) ? ProfilBala.opis(p) : nil
        bale.each do |b|
          c = b[:cechy].find { |x| x[:typ] == 'sciecie_dachu' }
          next if c.nil?
          kt = (c[:z1] - c[:z0]) / t
          next if kt.abs < 1e-9
          reszta = b[:cechy].reject { |x| x.equal?(c) }
          prof = opis ? ProfilBala.przedzialy(b[:dl], t, b[:h], reszta, opis) : Bryla.profil(b[:dl], t, b[:h], reszta)
          granice = [0.0, t]
          poziomy = []
          prof.each do |q|
            granice << q[:y0] << q[:y1]
            (q[:pasy] || [q]).each do |x|
              granice << x[:y0] << x[:y1]
              poziomy << x[:zt_a] << x[:zt_b]
            end
          end
          przesun!(c, kt, t, poziomy.compact.uniq, granice.compact.uniq)
        end
      end

      # Przesunięcie płaszczyzny ścięcia c (nachylenie kt w poprzek) do najbliższej granicy pasa dla pierwszego poziomu,
      # którego przecięcie wypada bliżej niż Bryla::SCAL od granicy albo nad którym płaszczyzna na granicy jest niżej niż
      # Bryla::SCAL (stopień krótszy niż tolerancja – runda 9); płaszczyzna zawsze w dół.
      def przesun!(c, kt, t, poziomy, granice)
        poziomy.each do |z|
          yk = (z - c[:z0]) / kt
          next if yk <= 0.0 || yk >= t
          # Krawędź za krótka w poziomie (przecięcie przy granicy) albo w pionie (płaszczyzna tuż nad poziomem na granicy pasa).
          next unless granice.any? { |y| (y - yk).abs > 1e-6 && [(y - yk).abs, (kt * (y - yk)).abs].min < Bryla::SCAL }
          # Płaszczyzna tylko w dół (bal nie wychodzi ponad dach): przecięcie przesuwa się do granicy po stronie wyższej płaszczyzny.
          yb = granice.select { |y| (y - yk) * kt > 1e-6 }.min_by { |y| (y - yk).abs }
          next if yb.nil?
          dz = z - kt * yb - c[:z0]
          c[:z0] += dz
          c[:z1] += dz
          return
        end
      end

      # Obróbka ścięcia bala b (nil – bal pod dachem): wysokości płaszczyzny na licach y = 0 i y = t względem spodu bala.
      def sciecie(b, p, geo, iv, t)
        pol = Bale.polozenie(b, p)
        v0 = pol[:poczatek][iv]
        v1 = v0 + pol[:y][iv] * t
        # Węgieł pod połacią kończy się pod podbitką „pod” (jak działowe w poprzek i węgły na ścianach okapowych).
        dz = b[:sciana][:rodzaj] == :kontrfor ? Podbitka.obnizenie(p) : 0.0
        z0 = Dach.linia_podparcia(geo, v0, p) - dz - b[:z0]
        z1 = Dach.linia_podparcia(geo, v1, p) - dz - b[:z0]
        return nil if [z0, z1].min >= b[:h] - MIN
        { typ: 'sciecie_dachu', x0: 0.0, x1: b[:dl], z0: z0, z1: z1 }
      end
    end
  end
end
