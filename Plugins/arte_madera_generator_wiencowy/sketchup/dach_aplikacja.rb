# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/dach_aplikacja.rb
# Zadanie: dach z aplikacji do dachów (ArteMadera Roof) po budowie domu – przez jej stałe API: połacie z planu (KROK 1), płatwie domu jako podpory, okno KROKU 2 z ustawieniami domu z bali, więźba powiązana z domem, zastąpienie poprzednich połaci i więźby.
# Tematy: aplikacja do dachów w modelu, API aplikacji do dachów, połacie w modelu, KROK 2 z generatora, więźba z aplikacji, więźba powiązana z domem, podpory w modelu, poprzednie połacie przy przebudowie, brak aplikacji do dachów, stara aplikacja do dachów, dom w innym kontekście, krawędzie szczytowe w modelu
# Zależy od: rdzen/polacie.rb (plan[:polacie]), rdzen/krok2.rb (ustawienia KROKU 2, podpory), sketchup/konwersja.rb, sketchup/atrybuty.rb, log.rb; ArteMadera::Roof::API (wersja 1, aplikacja 3.7.0+)
# Używają: sketchup/sterowanie.rb (po budowie domu)
#
# Tylko stałe wejście aplikacji (jej API.md): API.polacie(model, punkty, z, kąt, okap, szczyty, :operacja => false) –
# punkty Geom::Point3d w układzie kontekstu domu, z = nil (średnia z punktów), numery krawędzi szczytowych w kolejności
# punktów (odwrócenie obiegu przelicza API); API.podpory(grupa, płatwie i ściana wysoka w mm) – lista w grupie połaci (KROK 2
# z menu też ją widzi); API.wiezba(grupa, ustawienia, :po_generowaniu => …) – okno KROKU 2, po OK grupa „Wiezba
# dachowa” dostaje ArteMadera_GW.wiezba_domu = id domu. Połacie: grupa „Dach - polacie” obok grupy domu, ArteMadera_GW:
# polacie_domu = id domu. Przy przebudowie poprzednie połacie domu znikają, więźba poprzedniej wersji (po id, a bez
# id – nad obrysem poprzednich połaci) – po potwierdzeniu. Zmiany w modelu w jednej operacji dołączonej do budowy
# domu (jedno „Cofnij”); oznaczenie więźby dołączone do operacji KROKU 2.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module DachAplikacja
      NAZWA_WIEZBY = 'Wiezba dachowa'.freeze unless const_defined?(:NAZWA_WIEZBY)
      # Najniższa wersja API aplikacji do dachów (aplikacja 3.7.0).
      API_WERSJA = 1 unless const_defined?(:API_WERSJA)
      # Zapas wokół obrysu poprzednich połaci przy szukaniu więźby bez id domu [mm].
      ZAPAS_WIEZBY = 1000.0 unless const_defined?(:ZAPAS_WIEZBY)

      module_function

      # API aplikacji do dachów (ArteMadera::Roof::API, wersja ≥ 1) albo nil – brak aplikacji albo starsza niż 3.7.0.
      def api
        return nil unless defined?(ArteMadera::Roof::API) && ArteMadera::Roof::API.respond_to?(:wersja)
        ArteMadera::Roof::API.wersja.to_i >= API_WERSJA ? ArteMadera::Roof::API : nil
      end

      # Komunikat, gdy API brak (nil – jest): aplikacji nie ma albo jest starsza niż 3.7.0.
      def brak_api
        return nil if api
        zmiana = 'w parametrach wybierz „Krokwie i poszycie – kto je buduje” = generator'
        unless defined?(ArteMadera::Roof)
          return 'Dach z aplikacji nie powstał: aplikacja do dachów (ArteMadera Roof) nie jest wczytana – zainstaluj ją ' \
                 "(3.7.0 lub nowszą) albo #{zmiana}."
        end
        wersja = defined?(ArteMadera::Roof::PLUGIN_VERSION) ? " #{ArteMadera::Roof::PLUGIN_VERSION}" : ''
        "Dach z aplikacji nie powstał: aplikacja do dachów#{wersja} jest za stara – potrzebna 3.7.0 lub nowsza (stałe " \
          "wejście dla generatora); zaktualizuj ją albo #{zmiana}."
      end

      # Po budowie domu: bez poprzednich połaci domu stary_id (jego więźba – po potwierdzeniu), nowe połacie z planu
      # z płatwiami jako podporami, okno KROKU 2. Zwraca nil (bez połaci i więźby teraz i wcześniej) albo
      # { 'tekst' =>, 'ok' => }.
      def po_budowie(model, dom, plan, stary_id = nil)
        pol = plan[:polacie]
        ents = dom.parent.entities
        stare = stary_id.to_s.empty? ? [] : poprzednie_polacie(ents, stary_id)
        wiezba = wiezba_domu(ents, stary_id, stare)
        return nil if pol.nil? && stare.empty? && wiezba.empty?
        blad = pol ? przeszkoda(model, dom) : nil
        if blad && stare.empty? && wiezba.empty?
          Log.warn("Dach: #{blad}")
          return { 'tekst' => blad, 'ok' => false }
        end
        usun_wiezbe = !wiezba.empty? && usunac_wiezbe?(wiezba.length)
        wynik = w_operacji(model) do
          (stare + (usun_wiezbe ? wiezba : [])).each { |g| g.erase! if g.valid? }
          pol ? nowe_polacie(model, dom, pol, Krok2.podpory(plan)) : [nil, { 'tekst' => 'Poprzednie połacie dachu usunięte.', 'ok' => true }]
        end
        grupa, info = wynik
        return info if grupa.nil?
        p = plan[:parametry]
        otworz_krok2(grupa, Krok2.ustawienia(p), Atrybuty.dom_id(dom))
        Log.info('Dach: połacie z aplikacji do dachów gotowe – okno KROKU 2.')
        { 'tekst' => tekst_krok2(p), 'ok' => true }
      rescue => e
        Log.error('DachAplikacja.po_budowie', e)
        { 'tekst' => 'Połacie dachu nie powstały – błąd (szczegóły w Konsoli Ruby).', 'ok' => false }
      end

      # Pytanie o więźbę poprzedniej wersji domu (liczba grup) – true: usunąć.
      def usunac_wiezbe?(ile)
        UI.messagebox("Przy poprzedniej wersji domu jest więźba z aplikacji do dachów (#{ile}).\n" \
                      'Usunąć ją? Nową utworzysz w KROKU 2.', MB_YESNO) == IDYES
      end

      # Tekst do okna generatora: co zatwierdzić w KROKU 2 (krokwie albo poszycie na płatwiach).
      def tekst_krok2(p)
        if Krok2.bez_krokwi?(p)
          return 'Połacie dachu gotowe – zatwierdź poszycie w oknie KROKU 2 aplikacji do dachów (na płatwiach, wzdłuż spadku, ' \
                 'styki na płatwiach).'
        end
        'Połacie dachu gotowe – zatwierdź krokwie w oknie KROKU 2 aplikacji do dachów (płatwie domu jako podpory, raport ' \
          'z kontrolą nośności).'
      end

      # Zmiany w modelu w operacji dołączonej do poprzedniej (budowa domu) – jedno „Cofnij”; błąd cofa tylko tę część.
      def w_operacji(model, nazwa = 'ArteMadera – połacie dachu')
        model.start_operation(nazwa, true, false, true)
        begin
          wynik = yield
          model.commit_operation
          wynik
        rescue => e
          model.abort_operation
          raise e
        end
      end

      # Nowe połacie domu z podporami (Krok2.podpory – mm układu domu): [grupa, nil] albo [nil, { 'tekst' =>, 'ok' => false }]
      # (brak lub stara aplikacja, inny kontekst, odmowa aplikacji).
      def nowe_polacie(model, dom, pol, podpory = [])
        blad = przeszkoda(model, dom)
        if blad
          Log.warn("Dach: #{blad}")
          return [nil, { 'tekst' => blad, 'ok' => false }]
        end
        grupa, tekst = api.polacie(model, punkty(dom, pol), nil, pol[:kat], pol[:okap], pol[:szczyty], :operacja => false)
        if grupa.nil?
          Log.warn("Dach: aplikacja do dachów nie utworzyła połaci: #{tekst}")
          return [nil, { 'tekst' => "Połacie dachu nie powstały: #{tekst}", 'ok' => false }]
        end
        grupa.set_attribute(Atrybuty::DICT_GW, 'polacie_domu', Atrybuty.dom_id(dom))
        ok, info = api.podpory(grupa, w_kontekscie(dom, podpory))
        ok ? Log.info("Dach: #{info}") : Log.warn("Dach: podpory nie zapisane – #{info}")
        [grupa, nil]
      end

      # Co nie pozwala zrobić połaci (komunikat) – brak lub stara aplikacja, dom poza aktywnym kontekstem; nil – można.
      def przeszkoda(model, dom)
        blad = brak_api
        return blad if blad
        return nil if w_aktywnym?(model, dom)
        'Połacie dachu nie powstały: dom leży w innej grupie niż otwarta do edycji – zamknij edycję grupy i zastąp dom ponownie.'
      end

      # Czy dom leży w aktywnym kontekście modelu (tam aplikacja do dachów dodaje połacie).
      def w_aktywnym?(model, dom)
        model.active_entities.parent == dom.parent
      end

      # Punkty obrysu połaci (mm układu domu, wysokość obrysu) jako Geom::Point3d w układzie kontekstu domu.
      def punkty(dom, pol)
        pol[:punkty].map { |x, y| Konwersja.punkt([x, y, pol[:z]]).transform(dom.transformation) }
      end

      # Podpory dla API: punkty z mm układu domu do mm układu kontekstu domu.
      def w_kontekscie(dom, podpory)
        tr = dom.transformation
        punkt = lambda { |xyz| Konwersja.z_punktu(Konwersja.punkt(xyz).transform(tr)) }
        podpory.map do |q|
          { od: punkt.call(q[:od]), do: punkt.call(q[:do]), szerokosc: q[:szerokosc], wysokosc: q[:wysokosc], nazwa: q[:nazwa] }
        end
      end

      # Okno KROKU 2 aplikacji na połaciach grupy – po zakończeniu bieżącego wywołania z okna generatora (licznik
      # zatrzymany na starcie: okno modalne w liczniku SketchUpa potrafi go powtarzać); po OK więźba dostaje id domu.
      def otworz_krok2(grupa, ustawienia, dom_id)
        id = nil
        id = UI.start_timer(0.2, false) do
          UI.stop_timer(id) if id
          begin
            krok2(grupa, ustawienia, dom_id)
          rescue => e
            Log.error('DachAplikacja.otworz_krok2', e)
          end
        end
        id
      end

      # Wywołanie KROKU 2 (okno); odmowa aplikacji – komunikat. Połacie usunięte w międzyczasie (Cofnij) – nic.
      def krok2(grupa, ustawienia, dom_id)
        return nil unless grupa.valid? && api
        ok, tekst = api.wiezba(grupa, ustawienia, :po_generowaniu => lambda { |w| oznacz_wiezbe(w, dom_id) })
        return ok if ok
        Log.warn("Dach: KROK 2 aplikacji do dachów się nie otworzył: #{tekst}")
        UI.messagebox("KROK 2 aplikacji do dachów się nie otworzył:\n#{tekst}")
        nil
      end

      # Więźba z KROKU 2 (po OK) powiązana z domem: ArteMadera_GW.wiezba_domu = id domu – w operacji KROKU 2.
      def oznacz_wiezbe(wiezba, dom_id)
        return nil if wiezba.nil? || !wiezba.valid?
        w_operacji(Sketchup.active_model, 'ArteMadera – więźba domu') { wiezba.set_attribute(Atrybuty::DICT_GW, 'wiezba_domu', dom_id) }
      rescue => e
        Log.error('DachAplikacja.oznacz_wiezbe', e)
        nil
      end

      # Grupy połaci poprzedniej wersji domu (słownik ArteMadera_GW, polacie_domu).
      def poprzednie_polacie(ents, dom_id)
        ents.grep(Sketchup::Group).select { |g| g.valid? && g.get_attribute(Atrybuty::DICT_GW, 'polacie_domu').to_s == dom_id }
      end

      # Więźba poprzedniej wersji domu: grupy z wiezba_domu = jej id, a bez id (kompilacja 5, KROK 2 z menu) – grupy
      # „Wiezba dachowa” ze środkiem nad obrysem jej połaci (z zapasem).
      def wiezba_domu(ents, dom_id, polacie)
        return [] if dom_id.to_s.empty?
        zapas = Konwersja.cal(ZAPAS_WIEZBY)
        ramy = polacie.map { |g| g.bounds }
        ents.grep(Sketchup::Group).select do |g|
          next false unless g.valid?
          id = g.get_attribute(Atrybuty::DICT_GW, 'wiezba_domu')
          next id.to_s == dom_id unless id.nil?
          next false unless g.name == NAZWA_WIEZBY
          c = g.bounds.center
          ramy.any? { |r| c.x >= r.min.x - zapas && c.x <= r.max.x + zapas && c.y >= r.min.y - zapas && c.y <= r.max.y + zapas }
        end
      end
    end
  end
end
