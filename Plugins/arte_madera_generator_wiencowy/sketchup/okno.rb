# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/okno.rb
# Zadanie: okno parametrów (UI::HtmlDialog) – dane startowe dla okna, wywołania z JavaScriptu, wyniki do okna.
# Tematy: okno, HtmlDialog, formularz parametrów, sekcje okna, podpowiedzi pól, szablony w oknie, przywróć domyślne, callback, podgląd, przycisk generuj, tabela otworów, komunikaty w oknie, widok ściany w oknie, zapis zestawienia z okna, tryb pól okna
# Zależy od: rdzen/parametry_lista.rb, sketchup/ustawienia.rb, sketchup/sterowanie.rb, sketchup/eksport.rb, log.rb
# Używają: sketchup/sterowanie.rb (pokaz)
#
# Okno buduje formularz z ParametryLista (SEKCJE, LISTA – jedno źródło pól). Wywołania JS → Ruby: gotowe, podglad,
# generuj, zamknij, blad_js, szablon_wczytaj, szablon_zapisz, szablon_usun, domyslne, widok (id ściany), zapisz_liste,
# tryb_pol ('podstawowe' | 'wszystkie').
# Ruby → JS: AMGW.init(dane), AMGW.wynik(dane), AMGW.ustaw({ parametry:, komunikat: }), AMGW.szablony({ lista:,
# komunikat: }), AMGW.widok(dane widoku ściany – rdzen/widok.rb), AMGW.komunikat({ tekst:, rodzaj: }).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require 'json'

module ArteMadera
  module GeneratorWiencowy
    module Okno
      SZEROKOSC = 1060 unless const_defined?(:SZEROKOSC)
      WYSOKOSC = 860 unless const_defined?(:WYSOKOSC)

      @dialog = nil unless instance_variable_defined?(:@dialog)

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

        # Dane startowe okna: sekcje i pola formularza, wartości, presety, szablony, informacja o liniach / domu.
        def dane_startowe
          d = @dane || {}
          { 'tryb' => d['tryb'] || 'nowy', 'kompilacja' => PLUGIN_BUILD, 'opisy' => opisy_pol,
            'sekcje' => ParametryLista::SEKCJE.map { |k, tytul, otwarta| { 'klucz' => k, 'tytul' => tytul, 'otwarta' => otwarta } },
            'presety' => ParametryLista::PRESETY, 'opisy_zamka' => ParametryLista::OPISY_ZAMKA,
            'parametry' => d['parametry'] || {}, 'szablony' => Ustawienia.nazwy_szablonow, 'plik_ustawien' => Ustawienia.sciezka,
            'otwory' => d['otwory'] || [], 'sciany' => d['sciany'] || {}, 'info' => d['info'].to_s,
            'podsumowanie' => d['podsumowanie'], 'tryb_pol' => Ustawienia.tryb_pol }
        end

        # Opisy pól z ParametryLista::LISTA w postaci dla JavaScriptu (sekcja, wybory, podpowiedź).
        def opisy_pol
          ParametryLista::LISTA.map do |w|
            { 'klucz' => w[:klucz], 'etykieta' => w[:etykieta], 'jednostka' => w[:jednostka].to_s, 'min' => w[:min],
              'max' => w[:max], 'rodzaj' => w[:rodzaj].to_s, 'domyslna' => w[:domyslna], 'sekcja' => w[:sekcja],
              'wybory' => ParametryLista.wybory(w), 'podpowiedz' => w[:podpowiedz].to_s, 'podstawowy' => w[:podstawowy] ? true : false }
          end
        end

        # Szablon do okna (wczytanie albo domyślne): AMGW.ustaw.
        def wyslij_parametry(parametry, komunikat)
          return if @dialog.nil?
          @dialog.execute_script("AMGW.ustaw(#{JSON.generate('parametry' => parametry, 'komunikat' => komunikat)})")
        rescue => e
          Log.error('Okno.wyslij_parametry', e)
        end

        # Lista szablonów do okna po zapisie / usunięciu: AMGW.szablony.
        def wyslij_szablony(komunikat)
          return if @dialog.nil?
          @dialog.execute_script("AMGW.szablony(#{JSON.generate('lista' => Ustawienia.nazwy_szablonow, 'komunikat' => komunikat)})")
        rescue => e
          Log.error('Okno.wyslij_szablony', e)
        end

        # Komunikat w oknie (ok / blad): AMGW.komunikat.
        def wyslij_komunikat(tekst, rodzaj)
          return if @dialog.nil?
          @dialog.execute_script("AMGW.komunikat(#{JSON.generate('tekst' => tekst, 'rodzaj' => rodzaj)})")
        rescue => e
          Log.error('Okno.wyslij_komunikat', e)
        end

        # Widok ściany do okna: AMGW.widok.
        def wyslij_widok(dane)
          return if @dialog.nil?
          @dialog.execute_script("AMGW.widok(#{JSON.generate(dane)})")
        rescue => e
          Log.error('Okno.wyslij_widok', e)
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
          dlg.add_action_callback('widok') do |_ctx, arg|
            begin
              wyslij_widok(Sterowanie.widok(arg.to_s))
            rescue => e
              Log.error('Okno.widok', e)
              wyslij_widok('blad' => "#{e.class}: #{e.message}", 'id' => arg.to_s)
            end
          end
          dlg.add_action_callback('zapisz_liste') do |_ctx, _arg|
            begin
              tekst, rodzaj = Eksport.zapisz_liste(Sterowanie.plan)
              wyslij_komunikat(tekst, rodzaj)
            rescue => e
              Log.error('Okno.zapisz_liste', e)
            end
          end
          dlg.add_action_callback('tryb_pol') do |_ctx, arg|
            begin
              Ustawienia.zapamietaj_tryb_pol(arg.to_s)
            rescue => e
              Log.error('Okno.tryb_pol', e)
            end
          end
          dlg.add_action_callback('blad_js') do |_ctx, arg|
            Log.error_text("Okno (JavaScript): #{arg}")
          end
          podlacz_szablony(dlg)
        end

        # Wywołania szablonów: wczytaj (nazwa), zapisz ({ nazwa, parametry }), usuń (nazwa), domyślne.
        def podlacz_szablony(dlg)
          dlg.add_action_callback('szablon_wczytaj') do |_ctx, arg|
            begin
              par = Ustawienia.szablon(arg.to_s)
              par.nil? ? wyslij_szablony("Nie ma szablonu „#{arg}”.") : wyslij_parametry(par, "Wczytano szablon „#{arg}”.")
            rescue => e
              Log.error('Okno.szablon_wczytaj', e)
            end
          end
          dlg.add_action_callback('szablon_zapisz') do |_ctx, arg|
            begin
              d = JSON.parse(arg.to_s)
              blad = Ustawienia.zapisz_szablon(d['nazwa'], d['parametry'])
              wyslij_szablony(blad || "Zapisano szablon „#{d['nazwa'].to_s.strip}”.")
            rescue => e
              Log.error('Okno.szablon_zapisz', e)
            end
          end
          dlg.add_action_callback('szablon_usun') do |_ctx, arg|
            begin
              blad = Ustawienia.usun_szablon(arg.to_s)
              wyslij_szablony(blad || "Usunięto szablon „#{arg}”.")
            rescue => e
              Log.error('Okno.szablon_usun', e)
            end
          end
          dlg.add_action_callback('domyslne') do |_ctx, _arg|
            begin
              wyslij_parametry(ParametryLista.domyslne, 'Przywrócono ustawienia fabryczne (zapiszą się przy podglądzie).')
            rescue => e
              Log.error('Okno.domyslne', e)
            end
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
