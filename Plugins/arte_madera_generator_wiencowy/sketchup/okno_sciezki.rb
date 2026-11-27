# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/okno_sciezki.rb
# Zadanie: wybór ścieżki z okna generatora – folder modeli stolarki (UI.select_directory) i plik modelu okna albo drzwi (UI.openpanel), odpowiedź do pola w oknie.
# Tematy: wybór ścieżki, wybór folderu, wybór pliku modelu, okno wyboru pliku, ścieżka modelu stolarki
# Zależy od: log.rb
# Używają: sketchup/okno.rb (podlacz), html/sciezka.js (przycisk „…” przy polu)
#
# Wywołanie JS → Ruby: wybierz_sciezke(JSON { id, rodzaj: 'folder' | 'plik', poczatek }); Ruby → JS:
# AMGW_SCIEZKA.wybrana({ id, sciezka }) – pusta ścieżka, gdy użytkownik anulował. Okno wyboru zaczyna w folderze z pola
# (dla pliku – w jego folderze), gdy istnieje.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require 'json'

module ArteMadera
  module GeneratorWiencowy
    module OknoSciezki
      # Filtr okna wyboru pliku modelu.
      FILTR = 'Modele SketchUpa (*.skp)|*.skp||'.freeze unless const_defined?(:FILTR)

      module_function

      # Podłączenie wywołania wybierz_sciezke do okna dlg.
      def podlacz(dlg)
        dlg.add_action_callback('wybierz_sciezke') do |_ctx, arg|
          begin
            d = JSON.parse(arg.to_s)
            dlg.execute_script("AMGW_SCIEZKA.wybrana(#{JSON.generate('id' => d['id'].to_s, 'sciezka' => wybierz(d))})")
          rescue => e
            Log.error('OknoSciezki.wybierz_sciezke', e)
          end
        end
      end

      # Okno wyboru dla danych z pola ({ 'rodzaj' =>, 'poczatek' => }); zwraca wybraną ścieżkę albo '' (anulowano).
      def wybierz(d)
        start = katalog_startowy(d['poczatek'])
        s = if d['rodzaj'].to_s == 'folder'
              UI.select_directory(title: 'Folder modeli okien i drzwi', directory: start.to_s)
            else
              UI.openpanel('Model okna albo drzwi (.skp)', start.to_s, FILTR)
            end
        s.nil? ? '' : s.to_s
      end

      # Folder, w którym zaczyna okno wyboru: ścieżka z pola, gdy jest folderem, albo folder pliku z pola; nil – brak.
      def katalog_startowy(t)
        s = t.to_s.strip
        return nil if s.empty?
        return s if File.directory?(s)
        k = File.dirname(s)
        return nil if k == '.' || k == s
        File.directory?(k) ? k : nil
      end
    end
  end
end
