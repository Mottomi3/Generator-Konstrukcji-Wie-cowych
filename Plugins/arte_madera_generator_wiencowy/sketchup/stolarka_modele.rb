# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/stolarka_modele.rb
# Zadanie: wstawienie modeli okien i drzwi w otwory domu przy generowaniu – plik .skp użytkownika albo prosty model z generatora (definicja z części), grupa „Stolarka” w domu, tag Stolarka, brakujące pliki zgłaszane.
# Tematy: modele stolarki w modelu, wstawienie okna z pliku, wstawienie drzwi z pliku, prosty model stolarki w modelu, materiał szyby, grupa Stolarka, tag Stolarka, brak pliku modelu stolarki
# Zależy od: rdzen/stolarka_modele.rb (lista do wstawienia i położenie), rdzen/stolarka_prosta.rb (części i siatki prostego modelu), sketchup/konwersja.rb (transformacja_elementu, punkt), sketchup/budowa.rb (rysuj_sciane), sketchup/atrybuty.rb (słowniki), log.rb
# Używają: sketchup/budowa.rb (po belkach)
#
# Definicja z pliku wczytywana raz na plik i budowę (model.definitions.load). Model większy albo mniejszy od stolarki
# o więcej niż TOL – wstawiony bez skalowania, z uwagą (wymiar z listy a wymiar modelu). Prosty model: jedna definicja na
# rodzaj i wymiar w budowie, każda część w osobnej grupie (ściany części się nie scalają), rola „skip” dla Dokumentacji 2D
# (to nie drewno do zamówienia), identyfikator domu na definicji – przebudowa usuwa nieużywane.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module StolarkaModeleSU
      # Różnica wymiaru modelu i stolarki z listy, od której jest uwaga [mm].
      TOL = 5.0 unless const_defined?(:TOL)

      module_function

      # Modele stolarki w grupie domu: { wstawione: n, proste: n, uwagi: [tekst] }.
      def wstaw(grupa, plan, model, tag, dom_id = '')
        lista = StolarkaModele.do_wstawienia(plan)
        wynik = { wstawione: 0, proste: 0, uwagi: [] }
        return wynik if lista.empty?
        g = grupa.entities.add_group
        g.name = 'Stolarka'
        g.layer = tag
        defs = {}
        lista.each do |s|
          d = definicja(model, s, defs, wynik, dom_id)
          next if d.nil?
          inst = g.entities.add_instance(d, Konwersja.transformacja_elementu(polozenie: s[:polozenie]))
          inst.name = s[:nazwa]
          inst.layer = tag
        end
        g.erase! if (wynik[:wstawione] + wynik[:proste]).zero? && g.valid?
        wynik
      rescue => e
        Log.error('StolarkaModeleSU.wstaw', e)
        wynik[:uwagi] << "Modele stolarki: #{e.class}: #{e.message}"
        wynik
      end

      # Definicja dla otworu: z pliku (gdy istnieje), inaczej prosty model (gdy włączony); nil – sam otwór. Liczy wstawione
      # i dopisuje uwagi (brak pliku, inny wymiar modelu).
      def definicja(model, s, defs, wynik, dom_id)
        if s[:plik] && File.exist?(s[:plik])
          d = defs[s[:plik]] ||= model.definitions.load(s[:plik])
          wynik[:wstawione] += 1
          u = uwaga_wymiaru(d, s)
          wynik[:uwagi] << u if u
          return d
        end
        if s[:plik]
          dalej = s[:prosty] ? 'wstawiony prosty model' : 'został sam otwór'
          wynik[:uwagi] << "Model stolarki #{s[:typ]} (#{s[:sciana]}): brak pliku #{s[:plik]} – #{dalej}."
        end
        return nil if s[:prosty].nil?
        nazwa = StolarkaProsta.nazwa(s[:rodzaj], s[:szerokosc], s[:wysokosc])
        wynik[:proste] += 1
        defs[nazwa] ||= prosta(model, nazwa, s[:prosty], dom_id)
      end

      # Definicja prostego modelu z części (każda w swojej grupie; szyba z materiałem przezroczystym).
      def prosta(model, nazwa, czesci, dom_id)
        d = model.definitions.add(nazwa)
        szklo = material_szyby(model)
        czesci.each do |c|
          g = d.entities.add_group
          g.name = c[:nazwa]
          StolarkaProsta.siatka(c).each { |sc| Budowa.rysuj_sciane(g.entities, sc) }
          g.material = szklo if c[:szyba] && szklo && g.respond_to?(:material=)
        end
        d.set_attribute(Atrybuty::DICT_AM, 'rola', 'skip')
        d.set_attribute(Atrybuty::DICT_GW, 'dom', dom_id.to_s)
        d.set_attribute(Atrybuty::DICT_GW, 'nazwa', nazwa)
        d
      end

      # Materiał szyby (niebieskawy, przezroczysty) – zakładany raz w modelu; nil – model bez materiałów.
      def material_szyby(model)
        return nil unless model.respond_to?(:materials)
        m = model.materials['ArteMadera – szyba']
        return m if m
        m = model.materials.add('ArteMadera – szyba')
        m.color = [170, 200, 230] if m.respond_to?(:color=)
        m.alpha = 0.35 if m.respond_to?(:alpha=)
        m
      rescue => e
        Log.error('StolarkaModeleSU.material_szyby', e)
        nil
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
