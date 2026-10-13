# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/bale.rb
# Zadanie: bale każdej ściany w każdym wieńcu – kawałki między otworami i stykami, wycięcia przy otworach, położenie w układzie domu.
# Tematy: bal, kawałek bala, podział wieńca, cięcie przy otworze, styk w wieńcu, kontrfor przerwany przy otworze, położenie bala, długość bala
# Zależy od: rdzen/geometria.rb, rdzen/parametry.rb, rdzen/wience.rb, rdzen/otwory.rb, rdzen/styki.rb
# Używają: rdzen/projekt.rb, rdzen/zamek.rb (obróbki), rdzen/pozycje.rb
#
# Bal (Hash): nr, sciana, wieniec ({ nr:, z0:, h:, lvl:, polbal: }), i (indeks wieńca od 0), s0, s1 (na osi ściany),
# dl, z0, h, lvl, cechy (obróbki w układzie bala: x od czoła s0 wzdłuż ściany, y od lica prawego (−nor) do lewego,
# z od spodu), konce ([:ostatek | :styk | :otwor | :wolny] na s0 i s1).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'geometria') unless defined?(ArteMadera::GeneratorWiencowy::Geometria)
require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)
require File.join(File.dirname(__FILE__), 'otwory') unless defined?(ArteMadera::GeneratorWiencowy::Otwory)
require File.join(File.dirname(__FILE__), 'styki') unless defined?(ArteMadera::GeneratorWiencowy::Styki)

module ArteMadera
  module GeneratorWiencowy
    module Bale
      G = Geometria unless const_defined?(:G)

      module_function

      # Wszystkie bale domu (bez obróbek zamka): { bale: [...], ostrzezenia: [...] }.
      def zbuduj(sciany, p)
        wynik = { bale: [], ostrzezenia: [] }
        nr = 0
        sciany.each do |w|
          w[:wience] = Wience.dla_sciany(w, p)
          w[:bale] = []
          w[:wience].each_with_index do |wn, i|
            if w[:rodzaj] == :kontrfor && !kontrfor_obecny?(w, wn, p)
              next
            end
            kawalki_wienca(w, wn, i, p, wynik[:ostrzezenia]).each do |b|
              nr += 1
              b[:nr] = nr
              w[:bale] << b
              wynik[:bale] << b
            end
          end
        end
        sprawdz_dlugosci(wynik, p)
        wynik
      end

      # Kawałki bala w wieńcu: zasięg ściany minus otwory przelotowe, podzielony w miejscach styków.
      def kawalki_wienca(w, wn, i, p, uwagi)
        ciecia = Otwory.dla_wienca(w, wn[:z0], wn[:h])
        ciecia[:uwagi].each { |u| uwagi << u unless uwagi.include?(u) }
        przedzialy = G.odejmij_przedzialy(w[:s_od], w[:s_do], ciecia[:pelne], 0.5)
        styki = w[:rodzaj] == :kontrfor ? [] : Styki.pozycje_w_wiencu(w, i)
        g = p['szczelina_styku'].to_f / 2.0
        wynik = []
        przedzialy.each do |a, b|
          punkty = [[a, koniec_typ(w, a, ciecia[:pelne])]]
          styki.sort.each do |st|
            next unless st - g > a + 1.0 && st + g < b - 1.0
            punkty << [st - g, :styk] << [st + g, :styk]
          end
          punkty << [b, koniec_typ(w, b, ciecia[:pelne])]
          punkty.each_slice(2) do |(s0, t0), (s1, t1)|
            wynik << nowy_bal(w, wn, i, s0, s1, [t0, t1], ciecia[:wyciecia])
          end
        end
        wynik
      end

      # Rodzaj końca bala w miejscu s: ostatek (koniec zasięgu z ostatkiem), otwór, wolny koniec ściany.
      def koniec_typ(w, s, pelne)
        return :otwor if pelne.any? { |o| (o[0] - s).abs < 0.6 || (o[1] - s).abs < 0.6 }
        return :ostatek if w[:rodzaj] == :kontrfor
        if (s - w[:s_od]).abs < 0.01
          return w[:s_od] < -0.01 ? :ostatek : :wolny
        end
        w[:s_do] > w[:dl_osi] + 0.01 ? :ostatek : :wolny
      end

      # Nowy bal z wycięciami od otworów (cechy w układzie bala).
      def nowy_bal(w, wn, i, s0, s1, konce, wyciecia)
        cechy = []
        wyciecia.each do |c|
          x0 = [c[:s0], s0].max - s0
          x1 = [c[:s1], s1].min - s0
          next if x1 - x0 <= 0.5
          cechy << { typ: c[:strona] == :dol ? 'wyciecie_dol' : 'wyciecie_gora', x0: x0, x1: x1, gleb: c[:gleb] }
        end
        { sciana: w, wieniec: wn, i: i, s0: s0, s1: s1, dl: s1 - s0, z0: wn[:z0], h: wn[:h], lvl: wn[:lvl],
          polbal: wn[:polbal], cechy: cechy, konce: konce }
      end

      # Czy bal kontrforu w wieńcu wn ma oparcie: bale gospodarza na poziomach lvl ± 1 obecne (bez otworu) w osi kontrforu.
      def kontrfor_obecny?(kf, wn, p)
        gosp = kf[:gospodarz]
        s = G.dot(G.sub(kf[:a], gosp[:a]), gosp[:kier])
        sasiedzi = Wience.dla_sciany(gosp, p).select { |g| (g[:lvl] - wn[:lvl]).abs == 1 }
        return false if sasiedzi.empty?
        sasiedzi.none? { |g| Otwory.w_otworze?(gosp, s, g[:z0], g[:z0] + g[:h]) }
      end

      # Ostrzeżenia o długościach: kawałek krótszy od najkrótszego, bal dłuższy od maksymalnego.
      def sprawdz_dlugosci(wynik, p)
        lmax = p['max_dlugosc'].to_f
        lmin = p['min_odcinek'].to_f
        za_dlugie = {}
        za_krotkie = {}
        wynik[:bale].each do |b|
          next if b[:sciana][:rodzaj] == :kontrfor
          id = b[:sciana][:id]
          (za_dlugie[id] ||= []) << b[:dl] if b[:dl] > lmax + 0.5
          (za_krotkie[id] ||= []) << b[:dl] if b[:dl] < lmin - 0.5
        end
        za_dlugie.each do |id, l|
          wynik[:ostrzezenia] << format('Ściana %s: %d bal(e) dłuższe niż %.0f mm (najdłuższy %.0f mm).', id, l.length, lmax, l.max)
        end
        za_krotkie.each do |id, l|
          wynik[:ostrzezenia] << format('Ściana %s: %d kawałek(ki) krótsze niż %.0f mm (najkrótszy %.0f mm).', id, l.length, lmin, l.min)
        end
      end

      # Położenie bala w układzie domu: początek (lico prawe, czoło s0, spód), osie x (wzdłuż), y (w lewo), z (w górę).
      def polozenie(b, p)
        w = b[:sciana]
        t = Parametry.grubosc(p)
        o2 = G.add(G.add(w[:a], G.mul(w[:kier], b[:s0])), G.mul(w[:nor], -t / 2.0))
        { poczatek: [o2[0], o2[1], b[:z0]], x: [w[:kier][0], w[:kier][1], 0.0], y: [w[:nor][0], w[:nor][1], 0.0], z: [0.0, 0.0, 1.0] }
      end
    end
  end
end
