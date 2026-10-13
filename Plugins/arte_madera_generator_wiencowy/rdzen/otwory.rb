# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/otwory.rb
# Zadanie: otwory okienne i drzwiowe – położenie na ścianie, sprawdzenie, cięcia bali w każdym wieńcu.
# Tematy: otwór, okno, drzwi, parapet, nadproże, luz osiadania, cięcie proste przy otworze, wycięcie bala przy otworze, poziom ±0
# Zależy od: rdzen/geometria.rb, rdzen/parametry.rb
# Używają: rdzen/projekt.rb, rdzen/bale.rb, rdzen/styki.rb (omijanie otworów)
#
# Otwór (wejście, klucze tekstowe): sciana ('W-1'), od (od punktu odniesienia ściany: zewnętrzna – narożnik lica
# zewnętrznego na początku ściany, działowa – początek narysowanej osi), szerokosc, wysokosc, parapet (od ±0 = spód
# pierwszego bala), nazwa (opcjonalnie). W ścianie: w[:otwory] = [{ s0:, s1:, z0:, z1:, nazwa: }].
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'geometria') unless defined?(ArteMadera::GeneratorWiencowy::Geometria)
require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module Otwory
      # Bal przecięty otworem na wysokości mniejszej niż tyle [mm] traktujemy jak cały w otworze.
      TOL_Z = 1.0 unless const_defined?(:TOL_Z)

      module_function

      # Przypisanie otworów do ścian (w[:otwory]); zwraca listę ostrzeżeń.
      def przypisz(wejscie, sciany, p, wysokosc_sciany)
        uwagi = []
        sciany.each { |w| w[:otwory] = [] }
        t = Parametry.grubosc(p)
        luz = p['luz_nad_otworem'].to_f
        min_kaw = p['min_kawalek_przy_otworze'].to_f
        (wejscie || []).each_with_index do |o, i|
          nazwa = o['nazwa'].to_s.strip
          nazwa = "O#{i + 1}" if nazwa.empty?
          w = sciany.find { |s| s[:id] == o['sciana'].to_s.strip }
          if w.nil? || w[:rodzaj] == :kontrfor
            uwagi << "Otwór #{nazwa}: nie ma ściany „#{o['sciana']}” – pominięty."
            next
          end
          od = Parametry.liczba(o['od'])
          szer = Parametry.liczba(o['szerokosc'])
          wys = Parametry.liczba(o['wysokosc'])
          par = Parametry.liczba(o['parapet']) || 0.0
          if od.nil? || szer.nil? || wys.nil? || szer <= 0 || wys <= 0
            uwagi << "Otwór #{nazwa} (#{w[:id]}): brak wymiarów – pominięty."
            next
          end
          s0 = w[:ref] + od
          s1 = s0 + szer
          z0 = par
          z1 = par + wys + luz
          gora = wysokosc_sciany.call(w)
          if s0 < w[:s_od] || s1 > w[:s_do] || z0 < -0.01 || z1 > gora + 0.01
            uwagi << "Otwór #{nazwa} (#{w[:id]}) wychodzi poza ścianę – pominięty."
            next
          end
          w[:skrzyzowania].each do |k|
            strefa0 = k[:s] - t / 2.0 - min_kaw
            strefa1 = k[:s] + t / 2.0 + min_kaw
            next if s1 <= strefa0 + 0.01 || s0 >= strefa1 - 0.01
            uwagi << format('Otwór %s (%s) jest bliżej niż %.0f mm od lica ściany %s – kawałek bala przy otworze będzie za krótki.',
                            nazwa, w[:id], min_kaw, k[:inna][:id] || 'poprzecznej')
          end
          w[:otwory] << { s0: s0, s1: s1, z0: z0, z1: z1, nazwa: nazwa }
        end
        uwagi
      end

      # Cięcia w wieńcu [z0, z0 + h]: { pelne: [[s0, s1]] – bal przerwany, gniazda: [[s0, s1]] – te z pelnych, które są
      # gniazdami płatwi, wyciecia: [{ s0:, s1:, strona:, gleb: }], uwagi: [] }.
      def dla_wienca(w, z0, h)
        z1 = z0 + h
        wynik = { pelne: [], gniazda: [], wyciecia: [], uwagi: [] }
        (w[:otwory] || []).each do |o|
          dol = [z0, o[:z0]].max
          gora = [z1, o[:z1]].min
          next if gora - dol <= TOL_Z
          od_dolu = o[:z0] <= z0 + TOL_Z
          do_gory = o[:z1] >= z1 - TOL_Z
          if od_dolu && do_gory
            wynik[:pelne] << [o[:s0], o[:s1]]
            wynik[:gniazda] << [o[:s0], o[:s1]] if o[:gniazdo]
          elsif od_dolu
            wynik[:wyciecia] << { s0: o[:s0], s1: o[:s1], strona: :dol, gleb: o[:z1] - z0 }
          elsif do_gory
            wynik[:wyciecia] << { s0: o[:s0], s1: o[:s1], strona: :gora, gleb: z1 - o[:z0] }
          else
            wynik[:uwagi] << format('Otwór %s (%s) mieści się w wysokości jednego bala – bal przecięty w całości.', o[:nazwa], w[:id])
            wynik[:pelne] << [o[:s0], o[:s1]]
          end
        end
        wynik
      end

      # Czy w miejscu s ściany jest otwór na wysokości [z0, z1] (do kontrforów i styków).
      def w_otworze?(w, s, z0, z1)
        (w[:otwory] || []).any? do |o|
          s > o[:s0] + 0.01 && s < o[:s1] - 0.01 && [z1, o[:z1]].min - [z0, o[:z0]].max > TOL_Z
        end
      end

      # Przedziały s zajęte przez otwory poszerzone o zapas (do wyboru miejsc styków i kontrforów; bez gniazd płatwi).
      def strefy_zakazane(w, zapas)
        (w[:otwory] || []).reject { |o| o[:gniazdo] }.map { |o| [o[:s0] - zapas, o[:s1] + zapas] }
      end
    end
  end
end
