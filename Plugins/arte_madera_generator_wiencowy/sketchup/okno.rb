# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/okno.rb
# Zadanie: okno parametrów (UI::HtmlDialog) – dane startowe dla okna, wywołania z JavaScriptu, wyniki do okna.
# Tematy: okno, HtmlDialog, formularz parametrów, callback, podgląd, przycisk generuj, tabela otworów, komunikaty w oknie
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb, sketchup/sterowanie.rb, log.rb
# Używają: sketchup/sterowanie.rb (pokaz)
#
# Okno buduje formularz z Parametry::OPISY i WYBORY (jedno źródło pól). Wywołania JS → Ruby: gotowe, podglad, generuj,
# zamknij, blad_js. Ruby → JS: AMGW.init(dane), AMGW.wynik(dane).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require 'json'

module ArteMadera
  module GeneratorWiencowy
    module Okno
      SZEROKOSC = 980 unless const_defined?(:SZEROKOSC)
      WYSOKOSC = 820 unless const_defined?(:WYSOKOSC)

      class << self
        attr_reader :dialog

        # Otwarcie okna z danymi startowymi (tryb: 'nowy' | 'edycja').
        def pokaz(dane)
          @dane = dane
          zamknij_stare
          @dialog = UI::HtmlDialog.new(dialog_title: "ArteMadera – Generator Wieńcowy (kompilacja #{PLUGIN_BUILD})",
                                       preferences_key: 'ArteMadera_GW_okno', scrollable: true, resizable: true,
                                       width: SZEROKOSC, height: WYSOKOSC, style: UI::HtmlDialog::STYLE_DIALOG)
          @dialog.set_file(File.join(EXTENSION_DIR, 'html', 'okno.html'))
          podlacz(@dialog)
          @dialog.show
          @dialog
        rescue => e
          Log.error('Okno.pokaz', e)
          UI.messagebox("Nie można otworzyć okna generatora:\n#{e.class}: #{e.message}")
          nil
        end

        # Dane startowe okna: pola formularza, wartości, presety, informacja o liniach / domu.
        def dane_startowe
          d = @dane || {}
          { 'tryb' => d['tryb'] || 'nowy', 'kompilacja' => PLUGIN_BUILD, 'opisy' => opisy_pol,
            'wybory' => Parametry::WYBORY, 'presety' => Parametry::PRESETY, 'opisy_zamka' => Parametry::OPISY_ZAMKA,
            'parametry' => d['parametry'] || {},
            'otwory' => d['otwory'] || [], 'info' => d['info'].to_s, 'podsumowanie' => d['podsumowanie'] }
        end

        # Opisy pól z Parametry::OPISY w postaci dla JavaScriptu.
        def opisy_pol
          Parametry::OPISY.map do |k, etykieta, jedn, min, max, rodzaj|
            { 'klucz' => k, 'etykieta' => etykieta, 'jednostka' => jedn, 'min' => min, 'max' => max,
              'rodzaj' => rodzaj.to_s, 'domyslna' => Parametry::DOMYSLNE[k] }
          end
        end

        # Wynik obliczeń lub budowy do okna.
        def wyslij_wynik(dane)
          return if @dialog.nil?
          @dialog.execute_script("AMGW.wynik(#{JSON.generate(dane)})")
        rescue => e
          Log.error('Okno.wyslij_wynik', e)
        end

        private

        # Wywołania z JavaScriptu.
        def podlacz(dlg)
          dlg.add_action_callback('gotowe') do |_ctx, _arg|
            begin
              dlg.execute_script("AMGW.init(#{JSON.generate(dane_startowe)})")
            rescue => e
              Log.error('Okno.gotowe', e)
            end
          end
          dlg.add_action_callback('podglad') do |_ctx, arg|
            begin
              wyslij_wynik(Sterowanie.podglad(JSON.parse(arg.to_s)))
            rescue => e
              Log.error('Okno.podglad', e)
              wyslij_wynik('bledy' => ["#{e.class}: #{e.message}"])
            end
          end
          dlg.add_action_callback('generuj') do |_ctx, arg|
            begin
              wyslij_wynik(Sterowanie.generuj(JSON.parse(arg.to_s)))
            rescue => e
              Log.error('Okno.generuj', e)
              wyslij_wynik('bledy' => ["#{e.class}: #{e.message}"])
            end
          end
          dlg.add_action_callback('zamknij') do |_ctx, _arg|
            begin
              dlg.close
            rescue => e
              Log.error('Okno.zamknij', e)
            end
          end
          dlg.add_action_callback('blad_js') do |_ctx, arg|
            Log.error_text("Okno (JavaScript): #{arg}")
          end
        end

        # Zamknięcie poprzedniego okna generatora.
        def zamknij_stare
          @dialog.close if @dialog && @dialog.visible?
        rescue => e
          Log.error('Okno.zamknij_stare', e)
        end
      end
    end
  end
end
