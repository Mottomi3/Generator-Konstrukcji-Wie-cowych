# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/elementy.rb
# Zadanie: elementy z belek (podłoga, dach) – belka prostopadłościenna w dowolnym położeniu, pozycje identycznych belek, lista zamówienia.
# Tematy: element, belka, podwalina, legar, podpora, płatew, krokiew, pozycja elementu, prefiks elementu, lista belek, położenie belki
# Zależy od: rdzen/geometria.rb, rdzen/bryla.rb (podpis), rdzen/parametry.rb
# Używają: rdzen/dach.rb, rdzen/podloga.rb, rdzen/projekt.rb, sketchup/budowa.rb
#
# Element (Hash): prefiks (grupa w Dokumentacji 2D: Pw podwaliny, L legary, Pd podciągi, P płatwie, K krokwie), rodzaj
# (tekst do nazwy komponentu), tag (:podloga | :dach), dl, b (szerokość = oś y belki), h (wysokość = oś z belki),
# cechy (obróbki jak u bali), polozenie { poczatek: [x, y, z], x:, y:, z: } – osie belki w układzie domu (mm).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'geometria') unless defined?(ArteMadera::GeneratorWiencowy::Geometria)
require File.join(File.dirname(__FILE__), 'bryla') unless defined?(ArteMadera::GeneratorWiencowy::Bryla)
require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module Elementy
      G = Geometria unless const_defined?(:G)

      # Nazwy rodzajów do komponentów i list: prefiks => [nazwa, tag]. Prefiksy = grupy Dokumentacji 2D (element_roles.rb,
      # PREFIX_GROUPS), nazwy zawierają słowa, po których Dokumentacja 2D rozpoznaje grupę także bez atrybutu.
      RODZAJE = {
        'Pw' => ['Podwalina', :podloga], 'L' => ['Legar', :podloga], 'Pd' => ['Podciąg pod legary', :podloga],
        'P' => ['Płatew', :dach], 'K' => ['Krokiew', :dach]
      }.freeze unless const_defined?(:RODZAJE)

      module_function

      # Belka pozioma od p0 do p1 (rzut, mm): szerokość b w poprzek – po lewej stronie kierunku przy :lewo, symetrycznie
      # przy :os, po prawej przy :prawo; spód na wysokości z_spod.
      def pozioma(prefiks, p0, p1, b, h, z_spod, wyrownanie = :os, cechy = [])
        d = G.norm(G.sub(p1, p0))
        l = G.lewa(d)
        przes = case wyrownanie
                when :lewo then 0.0
                when :prawo then -b
                else -b / 2.0
                end
        o = G.add(p0, G.mul(l, przes))
        nowy(prefiks, G.odl(p0, p1), b, h, [o[0], o[1], z_spod], [d[0], d[1], 0.0], [l[0], l[1], 0.0], [0.0, 0.0, 1.0], cechy)
      end

      # Belka ukośna (krokiew): oś w płaszczyźnie pionowej wzdłuż kierunku d (rzut), nachylenie kat, początek spodu p.
      def ukosna(prefiks, p, d, kat, dl, b, h)
        dn = G.norm(d)
        l = G.lewa(dn)
        x = [dn[0] * Math.cos(kat), dn[1] * Math.cos(kat), Math.sin(kat)]
        z = [-dn[0] * Math.sin(kat), -dn[1] * Math.sin(kat), Math.cos(kat)]
        o = [p[0] - l[0] * b / 2.0, p[1] - l[1] * b / 2.0, p[2]]
        nowy(prefiks, dl, b, h, o, x, [l[0], l[1], 0.0], z, [])
      end

      # Nowy element z osiami (x wzdłuż, y szerokość, z wysokość).
      def nowy(prefiks, dl, b, h, poczatek, x, y, z, cechy)
        nazwa, tag = RODZAJE[prefiks] || ['Element', :dach]
        { prefiks: prefiks, rodzaj: nazwa, tag: tag, dl: dl.to_f, b: b.to_f, h: h.to_f, cechy: cechy,
          polozenie: { poczatek: poczatek, x: x, y: y, z: z } }
      end

      # Pozycje elementów (identyczne belki = jedna pozycja), numery od nr_start; nazwa „nr-długość”.
      def numeruj(elementy, nr_start)
        wg = {}
        lista = []
        posortowane(elementy).each do |e|
          podpis, obrot = Bryla.podpis_kanoniczny(e[:dl], e[:b], e[:h], e[:cechy])
          klucz = "#{e[:prefiks]}##{podpis}"
          poz = wg[klucz]
          if poz.nil?
            nr = nr_start + lista.length
            cechy = obrot ? Bryla.obrocone(e[:dl], e[:cechy]) : e[:cechy]
            poz = { nr: nr, prefiks: e[:prefiks], rodzaj: e[:rodzaj], tag: e[:tag], dl: e[:dl], t: e[:b], h: e[:h],
                    cechy: cechy, podpis: podpis, ilosc: 0, bale: [], polbal: false, element: true,
                    nazwa: "#{nr}-#{e[:dl].round}" }
            wg[klucz] = poz
            lista << poz
          end
          poz[:ilosc] += 1
          poz[:bale] << e
          e[:pozycja] = poz
          e[:obrocony] = obrot
        end
        lista
      end

      # Kolejność numeracji: grupa (podłoga, potem dach), prefiks, długość malejąco.
      def posortowane(elementy)
        kolej = %w[Pw Pd L P K]
        elementy.sort_by { |e| [kolej.index(e[:prefiks]) || 9, -e[:dl].round, e[:b].round, e[:h].round] }
      end

      # Wiersze listy zamówienia elementów: jak Pozycje.lista_zamowienia (przekrój szer. × wys.).
      def lista_zamowienia(pozycje)
        pozycje.map do |poz|
          { nazwa: poz[:nazwa], prefiks: poz[:prefiks], przekroj: format('%s × %s', Parametry.fmt(poz[:t]), Parametry.fmt(poz[:h])),
            dl: poz[:dl].round, ilosc: poz[:ilosc], objetosc_m3: (poz[:t] * poz[:h] * poz[:dl] * poz[:ilosc] / 1.0e9).round(4),
            rodzaj: poz[:rodzaj] }
        end
      end

      # Położenie instancji pozycji (obrócona o 180° – początek na drugim końcu, osie x i y odwrócone).
      def polozenie_instancji(e)
        pol = e[:polozenie]
        return pol unless e[:obrocony]
        o = pol[:poczatek]
        x = pol[:x]
        y = pol[:y]
        p = (0..2).map { |i| o[i] + x[i] * e[:dl] + y[i] * e[:b] }
        { poczatek: p, x: x.map { |v| -v }, y: y.map { |v| -v }, z: pol[:z] }
      end
    end
  end
end
