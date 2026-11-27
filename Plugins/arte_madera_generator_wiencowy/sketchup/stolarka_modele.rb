# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/stolarka_modele.rb
# Zadanie: wstawienie modeli okien i drzwi użytkownika (pliki .skp z folderu modeli stolarki) w otwory domu przy generowaniu – grupa „Stolarka” w domu, tag Stolarka, brakujące pliki zgłaszane.
# Tematy: modele stolarki w modelu, wstawienie okna z pliku, wstawienie drzwi z pliku, grupa Stolarka, tag Stolarka, brak pliku modelu stolarki
# Zależy od: rdzen/stolarka_modele.rb (lista do wstawienia i położenie), sketchup/konwersja.rb (transformacja_elementu), log.rb
# Używają: sketchup/budowa.rb (po belkach)
#
# Definicja z pliku wczytywana raz na plik i budowę (model.definitions.load). Model większy albo mniejszy od stolarki
# o więcej niż TOL – wstawiony bez skalowania, z uwagą (wymiar z listy a wymiar modelu).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module StolarkaModeleSU
      # Różnica wymiaru modelu i stolarki z listy, od której jest uwaga [mm].
      TOL = 5.0 unless const_defined?(:TOL)

      module_function

      # Modele stolarki w grupie domu: { wstawione: n, uwagi: [tekst] }.
      def wstaw(grupa, plan, model, tag)
        lista = StolarkaModele.do_wstawienia(plan)
        wynik = { wstawione: 0, uwagi: [] }
        return wynik if lista.empty?
        g = grupa.entities.add_group
        g.name = 'Stolarka'
        g.layer = tag
        defs = {}
        lista.each do |s|
          unless File.exist?(s[:plik])
            wynik[:uwagi] << "Model stolarki #{s[:typ]} (#{s[:sciana]}): brak pliku #{s[:plik]} – został sam otwór."
            next
          end
          d = defs[s[:plik]] ||= model.definitions.load(s[:plik])
          inst = g.entities.add_instance(d, Konwersja.transformacja_elementu(polozenie: s[:polozenie]))
          inst.name = s[:nazwa]
          inst.layer = tag
          wynik[:wstawione] += 1
          u = uwaga_wymiaru(d, s)
          wynik[:uwagi] << u if u
        end
        g.erase! if wynik[:wstawione].zero? && g.valid?
        wynik
      rescue => e
        Log.error('StolarkaModeleSU.wstaw', e)
        wynik[:uwagi] << "Modele stolarki: #{e.class}: #{e.message}"
        wynik
      end

      # Uwaga, gdy model ma inną szerokość albo wysokość niż stolarka z listy (o więcej niż TOL); nil – zgodny.
      def uwaga_wymiaru(d, s)
        return nil unless d.respond_to?(:bounds)
        b = d.bounds
        szer = Konwersja.mm(b.width)
        wys = Konwersja.mm(b.depth)
        return nil if (szer - s[:szerokosc]).abs <= TOL && (wys - s[:wysokosc]).abs <= TOL
        format('Model stolarki %s: %.0f × %.0f mm, a stolarka z listy %.0f × %.0f mm – sprawdź model albo listę.',
               s[:typ], szer, wys, s[:szerokosc], s[:wysokosc])
      end
    end
  end
end
