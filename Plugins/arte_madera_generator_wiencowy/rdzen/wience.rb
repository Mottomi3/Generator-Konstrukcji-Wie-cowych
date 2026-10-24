# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/wience.rb
# Zadanie: poziomy wieńców każdej ściany – półbal na dole ścian wzdłuż kalenicy, liczba wieńców, wysokości ścian.
# Tematy: wieniec, poziom wieńca, półbal, pierwszy wieniec, wysokość ściany, przesunięcie o pół wieńca, góra ścian, kontrfor – wysokość, wieńce szczytu, wieńce niższej działowej, nadstawka
# Zależy od: rdzen/parametry.rb (kolumny dopełnienia w[:dopelnienie] liczy rdzen/dopelnienie.rb)
# Używają: rdzen/bale.rb, rdzen/projekt.rb (wysokości do okna), rdzen/dopelnienie.rb, rdzen/szczyty.rb (gniazda)
#
# Poziom lvl = spód bala pełnego w jednostkach pół krycia: ściany szczytowe (B) 0, 2, 4…, wzdłuż kalenicy (A) −1, 1, 3…
# Półbal to bal pełny z poziomu −1 obcięty na wysokości 0. Dwa bale ścian prostopadłych tworzą zamek, gdy ich lvl różnią się o 1.
# Niższa działowa (w[:nizsza]): wieńce własne do pełnego wieńca nie wyżej niż w[:nizsza][:z], wyżej wieńce nadstawki
# (nadstawka: true) – tylko odcinki dopełnienia zamka (rdzen/dopelnienie.rb). Wysokość ściany = góra wieńców własnych.
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
        return nizsza_lista(w, lista, p) if w[:nizsza] && w[:rodzaj] == :dzialowa
        return lista unless w[:rodzaj] == :kontrfor
        gosp = wlasne(w[:gospodarz], p)
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

      # Wieńce niższej działowej: własne (góra pełnego wieńca ≤ w[:nizsza][:z], nie wyżej niż pełna wysokość), potem
      # nadstawka – tyle wieńców, ile sięgają kolumny dopełnienia (bez kolumn – sama działowa).
      def nizsza_lista(w, pelna, p)
        h = Parametry.krycie(p)
        gora = [w[:nizsza][:z], pelna.last[:z0] + pelna.last[:h]].min
        zmax = (w[:dopelnienie] || []).map { |k| k[:z_do] }.max || 0.0
        lista = []
        (0...400).each do |j|
          k = if w[:kierunek] == :A
                j.zero? ? { nr: 1, z0: 0.0, h: h / 2.0, lvl: -1, polbal: true } : { nr: j + 1, z0: j * h - h / 2.0, h: h, lvl: 2 * j - 1, polbal: false }
              else
                { nr: j + 1, z0: j * h, h: h, lvl: 2 * j, polbal: false }
              end
          k[:nadstawka] = true if j > 0 && k[:z0] + k[:h] > gora + 0.01
          break if k[:nadstawka] && k[:z0] >= zmax - 0.01
          lista << k
        end
        lista
      end

      # Wieńce własne ściany (bez nadstawki niższej działowej).
      def wlasne(w, p)
        dla_sciany(w, p).reject { |k| k[:nadstawka] }
      end

      # Wysokość ściany = góra najwyższego wieńca własnego [mm] (niższa działowa – bez nadstawki).
      def wysokosc(w, p)
        l = wlasne(w, p)
        l.empty? ? 0.0 : l.last[:z0] + l.last[:h]
      end

      # Wysokość ściany z nadstawką niższej działowej [mm] (np. do gniazd płatwi).
      def wysokosc_calkowita(w, p)
        l = dla_sciany(w, p)
        l.empty? ? 0.0 : l.last[:z0] + l.last[:h]
      end

      # Pełna wysokość ściany (jakby nie była niższą działową) [mm].
      def wysokosc_pelna(w, p)
        l = pelna_lista(w[:kierunek], w[:rodzaj] == :zewnetrzna, p, w[:szczyt] ? w[:szczyt][:z_max] : nil)
        l.last[:z0] + l.last[:h]
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
