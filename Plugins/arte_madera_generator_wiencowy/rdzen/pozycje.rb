# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/pozycje.rb
# Zadanie: numeracja pozycji jak u producenta – identyczne bale (ta sama bryła, także po obrocie o 180°) dostają jedną pozycję „nr-długość”.
# Tematy: pozycja, numeracja bali, nazwa bala 10-4200, identyczne bale, komponent, prefiks Bs / Kf, ilość sztuk, lista bali
# Zależy od: rdzen/bryla.rb, rdzen/parametry.rb
# Używają: rdzen/projekt.rb, sketchup/budowa.rb (jedna definicja komponentu na pozycję)
#
# Pozycja (Hash): nr, nazwa ('10-4200'), prefiks ('Bs' bale ścienne, 'Kf' kontrfory), dl, t, h, cechy (w ułożeniu
# kanonicznym), podpis, ilosc, bale (lista). Bal dostaje b[:pozycja] i b[:obrocony] (ułożony odwrotnie niż kanoniczny).
# Kolejność numerów: ściany W-1, W-2…, w ścianie wieńce od dołu, w wieńcu wzdłuż ściany.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'bryla') unless defined?(ArteMadera::GeneratorWiencowy::Bryla)
require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'szczyty') unless defined?(ArteMadera::GeneratorWiencowy::Szczyty)

module ArteMadera
  module GeneratorWiencowy
    module Pozycje
      module_function

      # Pozycje wszystkich bali (lista w kolejności numerów).
      def numeruj(bale, p)
        t = Parametry.grubosc(p)
        wg_podpisu = {}
        lista = []
        posortowane(bale).each do |b|
          prefiks = prefiks_bala(b)
          podpis, obrot = Bryla.podpis_kanoniczny(b[:dl], t, b[:h], b[:cechy])
          klucz = prefiks + '#' + podpis
          poz = wg_podpisu[klucz]
          if poz.nil?
            cechy = obrot ? Bryla.obrocone(b[:dl], b[:cechy]) : b[:cechy]
            poz = { nr: lista.length + 1, prefiks: prefiks, dl: b[:dl], t: t, h: b[:h], cechy: cechy, podpis: podpis,
                    ilosc: 0, bale: [], polbal: b[:polbal] }
            poz[:nazwa] = "#{poz[:nr]}-#{b[:dl].round}"
            wg_podpisu[klucz] = poz
            lista << poz
          end
          poz[:ilosc] += 1
          poz[:bale] << b
          b[:pozycja] = poz
          b[:obrocony] = obrot
        end
        lista
      end

      # Bale w kolejności numeracji: numer ściany, wieniec, położenie wzdłuż ściany.
      def posortowane(bale)
        bale.sort_by { |b| [b[:sciana][:nr].to_i, b[:i], b[:s0].round(1)] }
      end

      # Prefiks grupy w Dokumentacji 2D: bale ścienne (Bs), kontrfory (Kf), bale szczytu (Sz).
      def prefiks_bala(b)
        return 'Kf' if b[:sciana][:rodzaj] == :kontrfor
        Szczyty.bal_szczytu?(b) ? 'Sz' : 'Bs'
      end

      # Lista do zamówienia: [{ nazwa:, prefiks:, przekroj:, dl:, ilosc:, objetosc_m3: }] (przekrój jak w listach producenta).
      def lista_zamowienia(pozycje, p)
        z = p['zamek']
        pozycje.map do |poz|
          wys = poz[:polbal] ? z['polbal_lista'].to_f : z['krycie'].to_f
          { nazwa: poz[:nazwa], prefiks: poz[:prefiks], przekroj: format('%s × %s', Parametry.fmt(poz[:t]), Parametry.fmt(wys)),
            dl: poz[:dl].round, ilosc: poz[:ilosc],
            objetosc_m3: (poz[:t] * wys * poz[:dl] * poz[:ilosc] / 1.0e9).round(4) }
        end
      end
    end
  end
end
