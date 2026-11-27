# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_tabela.rb
# Zadanie: parametry w postaci tabeli (lista stolarki, magazyn drewna) – kolumny z opisu pola, sprawdzenie wierszy, tabela z tekstu JSON z okna, przeniesienie dawnych pól nowego okna i drzwi do listy stolarki.
# Tematy: parametr tabela, tabela w standardzie warsztatu, wiersze tabeli, kolumny tabeli, tabela z okna jako JSON, dawne pola nowego okna i drzwi
# Zależy od: – (Parametry.liczba przez wywołującego)
# Używają: rdzen/parametry.rb (sprawdz – rodzaj :tabela, normalizuj – przeniesienie dawnych pól), rdzen/parametry_lista.rb (stolarka), rdzen/magazyn_drewna.rb
#
# Pole tabeli w ParametryLista: rodzaj: :tabela, kolumny: [[klucz, etykieta, rodzaj (:tekst | :liczba | :wybor | :znacznik |
# :plik – tekst ze ścieżką, w oknie z przyciskiem wyboru pliku),
# wybory (dla :wybor)]], domyslna: [{ klucz kolumny => wartość }]. Wartość po sprawdzeniu: tablica wierszy (Hash z kluczami
# kolumn; liczby Float albo nil, znaczniki true / false, reszta – tekst bez spacji na końcach); wiersz bez żadnej wartości
# – pominięty. Okno przesyła tabelę jako tekst JSON (ukryte pole), plik ustawień i model – jako tablicę.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require 'json'

module ArteMadera
  module GeneratorWiencowy
    module ParametryTabela
      # Dawne pola „Nowe okno / nowe drzwi” (do kompilacji 16) → pierwsze wiersze listy stolarki.
      DAWNE_STOLARKI = [['O1', 'okno', 'okno_szerokosc', 'okno_wysokosc', 'okno_parapet'],
                        ['D1', 'drzwi', 'drzwi_szerokosc', 'drzwi_wysokosc', nil]].freeze unless const_defined?(:DAWNE_STOLARKI)

      module_function

      # Wiersze tabeli pola w z wartości v (tablica albo tekst JSON); niepoprawna wartość – tabela fabryczna z uwagą.
      def wiersze(w, v, uwagi)
        lista = v.is_a?(String) ? z_tekstu(v) : v
        unless lista.is_a?(Array)
          uwagi << "#{w[:etykieta]}: niepoprawna tabela – przyjęto fabryczną"
          lista = w[:domyslna]
        end
        lista.map { |r| wiersz(w, r) }.compact
      end

      # Tablica z tekstu JSON; nil – tekst nie jest tablicą JSON.
      def z_tekstu(t)
        x = JSON.parse(t)
        x.is_a?(Array) ? x : nil
      rescue JSON::ParserError
        nil
      end

      # Jeden wiersz z kolumnami pola w (klucze tekstowe albo symbole); nil – wiersz pusty albo nie-Hash.
      def wiersz(w, r)
        return nil unless r.is_a?(Hash)
        wynik = {}
        w[:kolumny].each do |k, _etykieta, rodzaj, wybory|
          v = r.key?(k) ? r[k] : r[k.to_sym]
          wynik[k] = wartosc(rodzaj, v, wybory)
        end
        pusty?(w, wynik) ? nil : wynik
      end

      # Wartość komórki według rodzaju kolumny.
      def wartosc(rodzaj, v, wybory)
        case rodzaj
        when :liczba then liczba(v)
        when :znacznik then v == true || %w[tak true 1 x].include?(v.to_s.strip.downcase)
        when :wybor
          t = v.to_s.strip
          wybory && !wybory.empty? && wybory.none? { |x| x[0] == t } ? wybory[0][0] : t
        else v.to_s.strip
        end
      end

      # Liczba z tekstu lub liczby (przecinek dziesiętny dozwolony); nil – puste albo niepoprawne.
      def liczba(v)
        return v.to_f if v.is_a?(Numeric)
        t = v.to_s.strip.tr(',', '.')
        t =~ /\A-?\d+(\.\d+)?\z/ ? t.to_f : nil
      end

      # Czy wiersz nie ma żadnej wartości (puste teksty, brak liczb, wszystkie znaczniki wyłączone).
      def pusty?(w, r)
        w[:kolumny].all? do |k, _e, rodzaj, _w|
          v = r[k]
          case rodzaj
          when :liczba then v.nil?
          when :znacznik then !v
          when :wybor then true
          else v.to_s.empty?
          end
        end
      end

      # Dawne pola nowego okna i drzwi z wejścia (model albo ustawienia sprzed kompilacji 17) → lista stolarki, gdy wejście
      # nie ma jeszcze listy; wejście bez dawnych pól – bez zmian.
      def przenies_stolarke(wej, domyslna)
        return wej if wej.key?('stolarka') || DAWNE_STOLARKI.none? { |_s, _r, a, b, _c| wej.key?(a) || wej.key?(b) }
        lista = domyslna.map(&:dup)
        DAWNE_STOLARKI.each do |symbol, rodzaj, ks, kw, kp|
          r = lista.find { |x| x['symbol'] == symbol } || (lista << { 'symbol' => symbol, 'rodzaj' => rodzaj }).last
          r['szerokosc'] = liczba(wej[ks]) || r['szerokosc']
          r['wysokosc'] = liczba(wej[kw]) || r['wysokosc']
          r['spod'] = liczba(wej[kp]) || r['spod'] if kp
        end
        wej.merge('stolarka' => lista)
      end
    end
  end
end
