# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/menu.rb
# Zadanie: menu Rozszerzenia → ArteMadera Generator Wieńcowy (generuj / edytuj, kontrola, test działania, o wtyczce).
# Tematy: menu, pozycje menu, o wtyczce, numer kompilacji, test działania z menu
# Zależy od: sketchup/sterowanie.rb, sketchup/raport.rb, log.rb
# Używają: main.rb (ładowanie)
#
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module Menu
      module_function

      # Dodanie menu (raz na sesję SketchUpa).
      def dodaj
        sub = UI.menu('Extensions').add_submenu('ArteMadera Generator Wieńcowy')
        sub.add_item('Generuj dom z zaznaczonych linii / edytuj zaznaczony dom…') { Sterowanie.start }
        sub.add_item('Kontrola zamków, styków i długości (zaznaczony dom)') { Sterowanie.kontrola }
        sub.add_separator
        sub.add_item('Test działania i raport do wysłania…') { Raport.uruchom }
        sub.add_item('O wtyczce') { o_wtyczce }
        sub
      rescue => e
        Log.error('Menu.dodaj', e)
        nil
      end

      # Okno z wersją i numerem kompilacji.
      def o_wtyczce
        UI.messagebox("#{PLUGIN_NAME}\nWersja #{PLUGIN_VERSION}, kompilacja #{PLUGIN_BUILD} (#{PLUGIN_BUILD_DATE})\n\n" \
                      "1. Narysuj linie (albo prostokąt): zamknięty obrys = lico zewnętrzne ścian, linie w środku = osie\n" \
                      "   ścian działowych, krótka linia w poprzek ściany = węgieł (kontrfor).\n" \
                      "2. Zaznacz linie i wybierz „Generuj dom…”.\n" \
                      "3. Żeby zmienić dom, zaznacz go i wybierz to samo polecenie.\n\n" \
                      '„Test działania i raport” buduje przykładowe domy (model zostaje bez zmian) i zapisuje raport do wysłania.')
      end
    end
  end
end
