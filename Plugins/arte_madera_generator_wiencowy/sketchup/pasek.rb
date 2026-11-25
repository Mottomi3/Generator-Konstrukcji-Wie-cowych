# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/pasek.rb
# Zadanie: szybki dostęp do poleceń wtyczki – pasek narzędzi z trzema przyciskami i polecenia pod prawym przyciskiem myszy na zaznaczonym domu albo liniach.
# Tematy: pasek narzędzi, przyciski paska, ikony paska, menu pod prawym przyciskiem, menu kontekstowe, edytuj dom wieńcowy z menu kontekstowego, dom z zaznaczonych linii z menu kontekstowego
# Zależy od: sketchup/sterowanie.rb, sketchup/raport.rb, sketchup/atrybuty.rb (dom?), log.rb
# Używają: main.rb (ładowanie)
#
# Wcześniej jedyną drogą było menu Rozszerzenia → ArteMadera Generator Wieńcowy → … (trzy poziomy). Ikony: ikony/*.svg
# (Windows – ostre przy każdym powiększeniu ekranu) i ikony/*_24.png, *_32.png (macOS i zapas). Pasek pokazuje się sam
# przy pierwszym uruchomieniu; schowany przez użytkownika – zostaje schowany (Widok → Paski narzędzi).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module Pasek
      NAZWA = 'ArteMadera Generator Wieńcowy'.freeze unless const_defined?(:NAZWA)
      # Przyciski paska: [plik ikony, nazwa, podpowiedź na pasku stanu, polecenie].
      PRZYCISKI = [
        ['dom', 'Dom wieńcowy – nowy z linii albo edycja',
         'Zaznaczone linie obrysu – nowy dom; zaznaczony dom z generatora – edycja jego ustawień.', :start],
        ['kontrola', 'Kontrola domu wieńcowego',
         'Zamki, styki, długości bali i ściany równoległe zaznaczonego domu.', :kontrola],
        ['test', 'Test działania i raport',
         'Buduje przykładowe domy (model zostaje bez zmian) i zapisuje raport do folderu raportów.', :test]
      ].freeze unless const_defined?(:PRZYCISKI)
      # Najmniej zaznaczonych linii, żeby pod prawym przyciskiem pojawiło się „Dom wieńcowy z zaznaczonych linii”.
      MIN_LINII = 4 unless const_defined?(:MIN_LINII)
      # Stany paska z API SketchUpa (get_last_state) – własne stałe, gdyby API ich nie podało.
      NIGDY = defined?(::TB_NEVER_SHOWN) ? ::TB_NEVER_SHOWN : -1 unless const_defined?(:NIGDY)
      WIDOCZNY = defined?(::TB_VISIBLE) ? ::TB_VISIBLE : 1 unless const_defined?(:WIDOCZNY)

      class << self
        attr_reader :pasek

        # Pasek narzędzi i menu pod prawym przyciskiem (raz na sesję SketchUpa).
        def dodaj
          @pasek = UI::Toolbar.new(NAZWA)
          PRZYCISKI.each { |ikona, nazwa, opis, co| @pasek.add_item(polecenie(ikona, nazwa, opis, co)) }
          pokaz(@pasek)
          UI.add_context_menu_handler { |menu| pod_prawym(menu) }
          @pasek
        rescue => e
          Log.error('Pasek.dodaj', e)
          nil
        end

        # Polecenie paska z ikoną i opisami.
        def polecenie(ikona, nazwa, opis, co)
          c = UI::Command.new(nazwa) { wykonaj(co) }
          c.tooltip = nazwa
          c.status_bar_text = opis
          c.small_icon = sciezka_ikony(ikona, 24)
          c.large_icon = sciezka_ikony(ikona, 32)
          c
        end

        # Plik ikony: Windows – SVG, inne systemy – PNG o podanym boku.
        def sciezka_ikony(ikona, bok)
          plik = Sketchup.respond_to?(:platform) && Sketchup.platform == :platform_win ? "#{ikona}.svg" : "#{ikona}_#{bok}.png"
          File.join(EXTENSION_DIR, 'ikony', plik)
        end

        # Wykonanie polecenia paska albo menu.
        def wykonaj(co)
          case co
          when :start then Sterowanie.start
          when :kontrola then Sterowanie.kontrola
          when :test then Raport.uruchom
          end
        rescue => e
          Log.error("Pasek.wykonaj(#{co})", e)
        end

        # Pokazanie paska: nigdy niepokazany – pokazany; pokazany poprzednio – przywrócony; schowany – zostaje schowany.
        def pokaz(pasek)
          stan = pasek.respond_to?(:get_last_state) ? pasek.get_last_state : NIGDY
          if stan == NIGDY
            pasek.show
          elsif stan == WIDOCZNY
            pasek.restore
          end
        end

        # Menu pod prawym przyciskiem: na zaznaczonym domu z generatora – edycja i kontrola; na zaznaczonych liniach
        # (co najmniej MIN_LINII, bez domu) – nowy dom.
        def pod_prawym(menu)
          model = Sketchup.active_model
          return if model.nil?
          zazn = model.selection
          if zazn.any? { |e| Atrybuty.dom?(e) }
            menu.add_separator
            menu.add_item('Edytuj dom wieńcowy…') { wykonaj(:start) }
            menu.add_item('Kontrola domu wieńcowego') { wykonaj(:kontrola) }
          elsif linii?(zazn)
            menu.add_separator
            menu.add_item('Dom wieńcowy z zaznaczonych linii…') { wykonaj(:start) }
          end
        rescue => e
          Log.error('Pasek.pod_prawym', e)
        end

        # Czy w zaznaczeniu jest co najmniej MIN_LINII krawędzi (liczenie przerywane po osiągnięciu progu).
        def linii?(zazn)
          n = 0
          zazn.each do |e|
            n += 1 if e.is_a?(Sketchup::Edge)
            return true if n >= MIN_LINII
          end
          false
        end
      end
    end
  end
end
