# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/wience.rb
# Zadanie: poziomy wieńców każdej ściany – półbal na dole ścian wzdłuż kalenicy, liczba wieńców, wysokości ścian.
# Tematy: wieniec, poziom wieńca, półbal, pierwszy wieniec, wysokość ściany, przesunięcie o pół wieńca, góra ścian, kontrfor – wysokość, wieńce szczytu
# Zależy od: rdzen/parametry.rb
# Używają: rdzen/bale.rb, rdzen/projekt.rb (wysokości do okna)
#
# Poziom lvl = spód bala pełnego w jednostkach pół krycia: ściany szczytowe (B) 0, 2, 4…, wzdłuż kalenicy (A) −1, 1, 3…
# Półbal to bal pełny z poziomu −1 obcięty na wysokości 0. Dwa bale ścian prostopadłych tworzą zamek, gdy ich lvl różnią się o 1.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module Wience
      module_function

      # Wieńce ściany od dołu: [{ nr:, z0:, h:, lvl:, polbal: }]; kontrfor dopasowany do wysokości gospodarza (przy
      # szczycie – także w szczyt, dalej ogranicza go linia dachu w rdzen/bale.rb).
      def dla_sciany(w, p)
        z_szczytu = w[:szczyt] ? w[:szczyt][:z_max] : nil
        z_szczytu = w[:gospodarz][:szczyt][:z_max] if w[:rodzaj] == :kontrfor && w[:gospodarz][:szczyt]
        lista = pelna_lista(w[:kierunek], w[:rodzaj] == :zewnetrzna, p, z_szczytu)
        return lista unless w[:rodzaj] == :kontrfor
        gosp = dla_sciany(w[:gospodarz], p)
        gora = gosp.last[:z0] + gosp.last[:h]
        wybrane = lista.select { |k| k[:z0] + k[:h] <= gora + 0.01 }
        wybrane.each_with_index { |k, i| k[:nr] = i + 1 }
        wybrane
      end

      # Wieńce według kierunku: A – półbal + n pełnych; B zewnętrzna – n + 1 (początek szczytu); B działowa i kontrfor – n;
      # ściana ze szczytem – wieńce aż do wierzchu szczytu z_szczytu.
      def pelna_lista(kierunek, zewnetrzna, p, z_szczytu = nil)
        h = Parametry.krycie(p)
        n = p['liczba_wiencow'].to_i
        lista = []
        if kierunek == :A
          n = [n, ((z_szczytu - h / 2.0) / h - 1e-9).ceil].max if z_szczytu
          lista << { nr: 1, z0: 0.0, h: h / 2.0, lvl: -1, polbal: true }
          (1..n).each { |j| lista << { nr: j + 1, z0: j * h - h / 2.0, h: h, lvl: 2 * j - 1, polbal: false } }
        else
          ile = zewnetrzna ? n + 1 : n
          ile = [ile, (z_szczytu / h - 1e-9).ceil].max if z_szczytu
          (0...ile).each { |k| lista << { nr: k + 1, z0: k * h, h: h, lvl: 2 * k, polbal: false } }
        end
        lista
      end

      # Wysokość ściany = góra najwyższego wieńca [mm].
      def wysokosc(w, p)
        l = dla_sciany(w, p)
        l.empty? ? 0.0 : l.last[:z0] + l.last[:h]
      end

      # Wysokości do okna: { okapowa:, szczytowa:, dzialowa_okapowa:, dzialowa_szczytowa: } [mm].
      def wysokosci(p)
        h = Parametry.krycie(p)
        n = p['liczba_wiencow'].to_i
        { okapowa: n * h + h / 2.0, szczytowa: (n + 1) * h, dzialowa_okapowa: n * h + h / 2.0, dzialowa_szczytowa: n * h }
      end
    end
  end
end
