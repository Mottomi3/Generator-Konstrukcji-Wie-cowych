# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/sciecie_dachu.rb
# Zadanie: bale ścian wzdłuż kalenicy wystające nad płaszczyznę dachu ścięte w poprzek do tej płaszczyzny – górny bal ściany okapowej przy ścianie nośnej, ściana wysoka dachu jednospadowego, działowa wzdłużna pod dachem.
# Tematy: ścięcie dachu, górny bal ścięty do płaszczyzny dachu, ściana nośna, ściana okapowa pod dachem, ściana wysoka – ścięcie skośne, działowa wzdłużna pod połacią, bal skośny w poprzek
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia), rdzen/bale.rb (położenie bala)
# Używają: rdzen/projekt.rb (po balach, przed zamkami i pozycjami)
#
# Ściany wzdłuż kalenicy (kierunek A) mają płaszczyznę dachu stałą wzdłuż bala, zmienną w poprzek: na licu y = 0
# i y = t bala inna wysokość linii podparcia. Bal, którego wierzch jest wyżej niż płaszczyzna na którymkolwiek licu,
# dostaje obróbkę sciecie_dachu { z0: (y = 0), z1: (y = t) } na całej długości (rdzen/bryla.rb – pasy ze skośnym
# wierzchem). Tylko dom prostokątny z dachem z generatora (dom ze szczytów).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'bale') unless defined?(ArteMadera::GeneratorWiencowy::Bale)

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

      # Obróbka ścięcia bala b (nil – bal pod dachem): wysokości płaszczyzny na licach y = 0 i y = t względem spodu bala.
      def sciecie(b, p, geo, iv, t)
        pol = Bale.polozenie(b, p)
        v0 = pol[:poczatek][iv]
        v1 = v0 + pol[:y][iv] * t
        z0 = Dach.linia_podparcia(geo, v0, p) - b[:z0]
        z1 = Dach.linia_podparcia(geo, v1, p) - b[:z0]
        return nil if [z0, z1].min >= b[:h] - MIN
        { typ: 'sciecie_dachu', x0: 0.0, x1: b[:dl], z0: z0, z1: z1 }
      end
    end
  end
end
