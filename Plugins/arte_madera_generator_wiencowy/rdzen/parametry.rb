# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry.rb
# Zadanie: sprawdzenie i uzupełnienie parametrów z okna / modelu / ustawień (zakresy, wybory, przekroje, zamek) i odczyt pomocniczy.
# Tematy: sprawdzanie parametrów, zakresy wartości, przekrój szer×wys, katalog przekrojów, wymiary zamka, mijanka 300, tak/nie
# Zależy od: rdzen/parametry_lista.rb, log.rb
# Używają: rdzen/projekt.rb (normalizacja), wszystkie pliki rdzen/ (odczyt), sketchup/okno.rb, sketchup/ustawienia.rb
#
# Definicje parametrów (domyślne, opisy, sekcje) są w rdzen/parametry_lista.rb – tu tylko sprawdzanie i odczyt.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(File.dirname(__FILE__)), 'log') unless defined?(ArteMadera::GeneratorWiencowy::Log)
require File.join(File.dirname(__FILE__), 'parametry_lista') unless defined?(ArteMadera::GeneratorWiencowy::ParametryLista)

module ArteMadera
  module GeneratorWiencowy
    module Parametry
      # Wymóg użytkownika: styki w sąsiednich wieńcach przesunięte co najmniej o tyle [mm].
      MIJANKA_MIN = 300.0 unless const_defined?(:MIJANKA_MIN)
      L = ParametryLista unless const_defined?(:L)
      PRESETY = ParametryLista::PRESETY unless const_defined?(:PRESETY)
      DOMYSLNE = ParametryLista.domyslne.freeze unless const_defined?(:DOMYSLNE)

      module_function

      # Pełny zestaw parametrów z wartości użytkownika: [parametry, ostrzeżenia]. Zamek – z presetu lub własny.
      def normalizuj(wejscie)
        wej = wejscie.is_a?(Hash) ? wejscie : {}
        p = {}
        uwagi = []
        L::LISTA.each do |w|
          k = w[:klucz]
          v = wej.key?(k) && !wej[k].nil? && wej[k].to_s.strip != '' ? wej[k] : w[:domyslna]
          p[k] = sprawdz(w, v, uwagi)
        end
        p['zamek'] = zamek_z(wej['zamek'], p['preset'], uwagi)
        [p, uwagi]
      end

      # Jedna wartość według rodzaju pola; wartość spoza zakresu – granica zakresu i ostrzeżenie.
      def sprawdz(w, v, uwagi)
        case w[:rodzaj]
        when :wybor then wybor(w, v, uwagi)
        when :przekroj
          return tekst_przekroju(przekroj_z(v)) if przekroj_z(v)
          uwagi << "#{w[:etykieta]}: niepoprawny przekrój „#{v}” (wpisz np. 50x150) – przyjęto #{w[:domyslna]}"
          w[:domyslna]
        when :tekst then v.to_s
        else liczba_w_zakresie(w, v, uwagi)
        end
      end

      # Wartość pola wyboru (stare wartości z wcześniejszych kompilacji zamieniane na obecne).
      def wybor(w, v, uwagi)
        t = v.to_s
        t = L::STARE_WARTOSCI[w[:klucz]][t] if L::STARE_WARTOSCI[w[:klucz]] && L::STARE_WARTOSCI[w[:klucz]][t]
        return t if L.wybory(w).any? { |x| x[0] == t }
        uwagi << "#{w[:etykieta]}: nieznana wartość „#{v}” – przyjęto #{w[:domyslna]}"
        w[:domyslna]
      end

      # Liczba w zakresie min…max (całkowita dla :calkowita).
      def liczba_w_zakresie(w, v, uwagi)
        n = liczba(v)
        if n.nil?
          uwagi << "#{w[:etykieta]}: niepoprawna wartość „#{v}” – przyjęto #{fmt(w[:domyslna])}"
          n = w[:domyslna].to_f
        end
        if w[:min] && n < w[:min]
          uwagi << "#{w[:etykieta]}: #{fmt(n)} poniżej najmniejszej wartości #{fmt(w[:min])} – przyjęto #{fmt(w[:min])}"
          n = w[:min].to_f
        end
        if w[:max] && n > w[:max]
          uwagi << "#{w[:etykieta]}: #{fmt(n)} powyżej największej wartości #{fmt(w[:max])} – przyjęto #{fmt(w[:max])}"
          n = w[:max].to_f
        end
        w[:rodzaj] == :calkowita ? n.round : n.to_f
      end

      # Wymiary zamka: preset uzupełniony wartościami użytkownika (sprawdzone, czy zamek się mieści).
      def zamek_z(wlasny, preset, uwagi)
        z = PRESETY[preset].dup
        if wlasny.is_a?(Hash)
          wlasny.each do |k, v|
            next unless z.key?(k) && k != 'nazwa'
            n = liczba(v)
            n.nil? ? uwagi << "Zamek – #{k}: niepoprawna wartość „#{v}”" : z[k] = n
          end
        end
        if z['gniazdo_gleb'] * 2.0 >= z['krycie']
          uwagi << 'Zamek: dwa gniazda są głębsze niż wysokość bala – przyjęto wymiary presetu'
          z = PRESETY[preset].dup
        end
        if z['gniazdo_szer'] > z['grubosc']
          uwagi << 'Zamek: gniazdo szersze niż grubość bala – przyjęto wymiary presetu'
          z = PRESETY[preset].dup
        end
        z
      end

      # Grubość ściany [mm].
      def grubosc(p)
        p['zamek']['grubosc'].to_f
      end

      # Rozstaw wieńców = wysokość bryły bala prostego [mm].
      def krycie(p)
        p['zamek']['krycie'].to_f
      end

      # Czy parametr tak/nie jest włączony.
      def tak?(p, klucz)
        p[klucz].to_s == 'tak'
      end

      # Przekrój parametru jako [szerokość, wysokość] w mm.
      def przekroj(p, klucz)
        przekroj_z(p[klucz]) || przekroj_z(DOMYSLNE[klucz])
      end

      # Przekrój z tekstu „50x150” / „50×150” / „50*150” → [50.0, 150.0]; nil gdy niepoprawny.
      def przekroj_z(v)
        m = v.to_s.strip.tr(',', '.').match(/\A(\d+(?:\.\d+)?)\s*[x×X*]\s*(\d+(?:\.\d+)?)\z/)
        return nil if m.nil?
        b = m[1].to_f
        h = m[2].to_f
        b > 0 && h > 0 ? [b, h] : nil
      end

      # Przekrój jako tekst „50x150”.
      def tekst_przekroju(bh)
        "#{fmt(bh[0])}x#{fmt(bh[1])}"
      end

      # Katalog przekrojów (lista „szer×wys” po przecinku) → [[b, h], …] bez niepoprawnych wpisów.
      def katalog(p, klucz = 'przekroje_katalog')
        p[klucz].to_s.split(/[;,\n]/).map { |t| przekroj_z(t) }.compact.uniq
      end

      # Liczba z tekstu lub liczby (przecinek dziesiętny dozwolony); nil gdy się nie da.
      def liczba(v)
        return v.to_f if v.is_a?(Numeric)
        t = v.to_s.strip.tr(',', '.')
        return nil unless t =~ /\A-?\d+(\.\d+)?\z/
        t.to_f
      end

      # Liczba do komunikatu (bez zbędnego ,0).
      def fmt(v)
        f = v.to_f
        (f - f.round).abs < 1e-9 ? f.round.to_s : format('%.1f', f)
      end
    end
  end
end
