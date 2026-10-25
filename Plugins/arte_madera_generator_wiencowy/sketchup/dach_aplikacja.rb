# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/dach_aplikacja.rb
# Zadanie: dach z aplikacji do dachów (ArteMadera Roof) po budowie domu – połacie z planu (KROK 1 aplikacji), zastąpienie poprzednich połaci i więźby, okno KROKU 2 z ustawieniami zgodnymi z domem z bali.
# Tematy: aplikacja do dachów w modelu, połacie w modelu, KROK 2 z generatora, więźba z aplikacji, poprzednie połacie przy przebudowie, brak aplikacji do dachów, ustawienia KROKU 2, dom w innym kontekście, krawędzie szczytowe w modelu
# Zależy od: rdzen/polacie.rb (plan[:polacie]), rdzen/parametry.rb, sketchup/konwersja.rb, sketchup/atrybuty.rb, log.rb; ArteMadera::Roof (Footprint, RoofBuilder, Config, Commands)
# Używają: sketchup/sterowanie.rb (po budowie domu)
#
# Połacie: grupa „Dach - polacie” aplikacji obok grupy domu (ten sam kontekst), ze słownikiem ArteMadera_GW:
# polacie_domu = id domu. Przy przebudowie poprzednie połacie domu znikają, więźba z KROKU 2 nad nimi (grupa
# „Wiezba dachowa”, środek nad obrysem poprzednich połaci) – po potwierdzeniu. Przed otwarciem okna KROKU 2 generator
# zapisuje w aplikacji: kierunek w górę (połać = spód krokwi), bez płatwi kalenicowej i bez zamków dolnych (płatwie
# leżą w szczytach z bali), krokiew, rozstaw (największy) i klasę drewna z parametrów, kontrolę nośności włączoną.
# Zmiany w modelu – w jednej operacji dołączonej do budowy domu (jedno „Cofnij”).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module DachAplikacja
      NAZWA_WIEZBY = 'Wiezba dachowa'.freeze unless const_defined?(:NAZWA_WIEZBY)
      # Klasy drewna, które zna KROK 2 aplikacji (inne – zostaje wybór z aplikacji).
      KLASY_DREWNA = %w[C24 C30 GL24h GL28h].freeze unless const_defined?(:KLASY_DREWNA)
      # Zapas wokół obrysu poprzednich połaci przy szukaniu więźby nad nimi [mm].
      ZAPAS_WIEZBY = 1000.0 unless const_defined?(:ZAPAS_WIEZBY)

      module_function

      # Czy aplikacja do dachów jest wczytana (połacie i KROK 2).
      def dostepna?
        defined?(ArteMadera::Roof::Footprint) && defined?(ArteMadera::Roof::RoofBuilder) &&
          defined?(ArteMadera::Roof::Config) && defined?(ArteMadera::Roof::Commands) ? true : false
      end

      # Po budowie domu: bez poprzednich połaci domu stary_id (więźba nad nimi – po potwierdzeniu), nowe połacie
      # z planu, ustawienia i okno KROKU 2. Zwraca nil (bez połaci teraz i wcześniej) albo { 'tekst' =>, 'ok' => }.
      def po_budowie(model, dom, plan, stary_id = nil)
        pol = plan[:polacie]
        ents = dom.parent.entities
        stare = stary_id.to_s.empty? ? [] : poprzednie_polacie(ents, stary_id)
        return nil if pol.nil? && stare.empty?
        wiezba = wiezba_nad(ents, stare)
        usun_wiezbe = !wiezba.empty? && UI.messagebox("Nad poprzednią wersją domu jest więźba z aplikacji do dachów (#{wiezba.length}).\n" \
                                                      'Usunąć ją? Nową utworzysz w KROKU 2.', MB_YESNO) == IDYES
        wynik = w_operacji(model) do
          (stare + (usun_wiezbe ? wiezba : [])).each { |g| g.erase! if g.valid? }
          pol ? nowe_polacie(model, dom, pol) : [nil, { 'tekst' => 'Poprzednie połacie dachu usunięte.', 'ok' => true }]
        end
        grupa, info = wynik
        return info if grupa.nil?
        ArteMadera::Roof::Config.save_settings(:framing, ustawienia_krok2(plan[:parametry]))
        model.selection.clear
        model.selection.add(grupa)
        otworz_krok2
        Log.info('Dach: połacie z aplikacji do dachów gotowe – okno KROKU 2.')
        { 'tekst' => 'Połacie dachu gotowe – zatwierdź krokwie w oknie KROKU 2 aplikacji do dachów (raport z kontrolą nośności).',
          'ok' => true }
      rescue => e
        Log.error('DachAplikacja.po_budowie', e)
        { 'tekst' => 'Połacie dachu nie powstały – błąd (szczegóły w Konsoli Ruby).', 'ok' => false }
      end

      # Zmiany w modelu w operacji dołączonej do poprzedniej (budowa domu) – jedno „Cofnij”; błąd cofa tylko tę część.
      def w_operacji(model)
        model.start_operation('ArteMadera – połacie dachu', true, false, true)
        begin
          wynik = yield
          model.commit_operation
          wynik
        rescue => e
          model.abort_operation
          raise e
        end
      end

      # Nowe połacie domu: [grupa, nil] albo [nil, { 'tekst' =>, 'ok' => false }] (brak aplikacji, inny kontekst, błąd
      # aplikacji).
      def nowe_polacie(model, dom, pol)
        unless dostepna?
          Log.warn('Dach: aplikacja do dachów (ArteMadera Roof) nie jest wczytana – połacie pominięte.')
          return [nil, { 'tekst' => 'Krokwie nie powstały: aplikacja do dachów (ArteMadera Roof) nie jest wczytana – ' \
                                    'zainstaluj ją albo w parametrach wybierz krokwie z generatora.', 'ok' => false }]
        end
        unless w_aktywnym?(model, dom)
          return [nil, { 'tekst' => 'Połacie dachu nie powstały: dom leży w innej grupie niż otwarta do edycji – zamknij ' \
                                    'edycję grupy i zastąp dom ponownie.', 'ok' => false }]
        end
        obrys, szczyty = footprint(dom, pol)
        grupa, tekst = ArteMadera::Roof::RoofBuilder.generate(model, obrys, ustawienia_krok1(pol, szczyty))
        if grupa.nil?
          Log.warn("Dach: aplikacja do dachów nie utworzyła połaci: #{tekst}")
          return [nil, { 'tekst' => "Połacie dachu nie powstały: #{tekst}", 'ok' => false }]
        end
        grupa.set_attribute(Atrybuty::DICT_GW, 'polacie_domu', Atrybuty.dom_id(dom))
        [grupa, nil]
      end

      # Czy dom leży w aktywnym kontekście modelu (tam aplikacja do dachów dodaje połacie).
      def w_aktywnym?(model, dom)
        model.active_entities.parent == dom.parent
      end

      # Obrys aplikacji (Footprint, cale w układzie kontekstu domu) z punktów połaci w mm układu domu i numery krawędzi
      # szczytowych w tym obrysie (przenumerowane, gdy położenie domu odwraca kierunek obiegu – dom odbity):
      # [Footprint, [numery od 1]].
      def footprint(dom, pol)
        pts = pol[:punkty].map { |x, y| Konwersja.punkt([x, y, pol[:z]]).transform(dom.transformation) }
        obrys = pts.map { |pt| [pt.x.to_f, pt.y.to_f] }
        z = pts.inject(0.0) { |s, pt| s + pt.z.to_f } / pts.length
        obrys, szczyty = przeciwnie_do_zegara(obrys, pol[:szczyty])
        [ArteMadera::Roof::Footprint.new(obrys, z, nil, []), szczyty]
      end

      # Obrys przeciwnie do wskazówek zegara (jak FootprintReader aplikacji) i numery krawędzi szczytowych po zmianie
      # kolejności: krawędź k (od 1) odwróconego obrysu n punktów = krawędź n − k − 1 (mod n) przed odwróceniem.
      def przeciwnie_do_zegara(obrys, szczyty)
        pole = 0.0
        obrys.each_with_index { |a, i| b = obrys[(i + 1) % obrys.length]; pole += a[0] * b[1] - b[0] * a[1] }
        return [obrys, szczyty] if pole >= 0.0
        n = obrys.length
        [obrys.reverse, szczyty.map { |k| ((n - (k - 1) - 2) % n) + 1 }.sort]
      end

      # Ustawienia KROKU 1 aplikacji: zapisane w aplikacji + kąt, okap i krawędzie szczytowe domu (numery od 1).
      def ustawienia_krok1(pol, szczyty)
        ArteMadera::Roof::Config.load_settings(:roof).merge(
          angle_deg: pol[:kat], overhang_mm: pol[:okap], gable_edges: szczyty.join(','), edge_angles: '', make_group: true,
          keep_base_face: true
        )
      end

      # Ustawienia KROKU 2 zgodne z domem z bali (zapisywane w aplikacji przed otwarciem okna).
      def ustawienia_krok2(p)
        bk, hk = Parametry.przekroj(p, 'krokiew_przekroj')
        u = { build_dir: 'up', ridge_on: false, seat_on: false, rafter_on: true, rafter_mode: 'max', rafter_w_mm: bk,
              rafter_h_mm: hk, rafter_spacing_mm: p['krokwie_rozstaw'].to_f, check_on: true }
        u[:timber_class] = p['drewno_klasa'] if KLASY_DREWNA.include?(p['drewno_klasa'].to_s)
        u
      end

      # Okno KROKU 2 aplikacji na zaznaczonych połaciach – po zakończeniu bieżącego wywołania z okna generatora
      # (licznik zatrzymany na starcie: okno modalne w liczniku SketchUpa potrafi go powtarzać).
      def otworz_krok2
        id = nil
        id = UI.start_timer(0.2, false) do
          UI.stop_timer(id) if id
          begin
            ArteMadera::Roof::Commands.generate_framing
          rescue => e
            Log.error('DachAplikacja.otworz_krok2', e)
          end
        end
        id
      end

      # Grupy połaci poprzedniej wersji domu (słownik ArteMadera_GW, polacie_domu).
      def poprzednie_polacie(ents, dom_id)
        ents.grep(Sketchup::Group).select { |g| g.valid? && g.get_attribute(Atrybuty::DICT_GW, 'polacie_domu').to_s == dom_id }
      end

      # Więźba z KROKU 2 nad połaciami: grupy „Wiezba dachowa” ze środkiem nad obrysem połaci (z zapasem).
      def wiezba_nad(ents, polacie)
        return [] if polacie.empty?
        zapas = Konwersja.cal(ZAPAS_WIEZBY)
        ramy = polacie.map { |g| g.bounds }
        ents.grep(Sketchup::Group).select do |g|
          next false unless g.valid? && g.name == NAZWA_WIEZBY
          c = g.bounds.center
          ramy.any? { |r| c.x >= r.min.x - zapas && c.x <= r.max.x + zapas && c.y >= r.min.y - zapas && c.y <= r.max.y + zapas }
        end
      end
    end
  end
end
