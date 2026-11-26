# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/ustawienia.rb
# Zadanie: plik ustawień na komputerze – standard warsztatu (pola poziomu „Standard warsztatu” i wymiary zamka), ustawienia okna (układ, tryb pól), odczyt i zapis pliku, przeniesienie plików starszych kompilacji (ostatnie parametry → standard, szablony → typy domów).
# Tematy: zapis ustawień, plik ustawień, wersja pliku ustawień, standard warsztatu, zapis standardu, przywrócenie fabrycznych, katalog AppData, ustawienia okna, układ okna, tryb pól okna, plik ustawień ze starszej kompilacji, kopia pliku ustawień
# Zależy od: rdzen/poziomy.rb (pola poziomu standard), rdzen/parametry_lista.rb, log.rb
# Używają: sketchup/typy_domow.rb (typy w tym samym pliku), sketchup/sterowanie.rb (start nowego domu), sketchup/okno.rb, sketchup/okno_typy.rb, sketchup/dziennik_pracy.rb (katalog), sketchup/raport.rb
#
# Plik JSON: Windows %APPDATA%\ArteMadera\GeneratorWiencowy\ustawienia.json, macOS ~/Library/Application Support/…,
# inne ~/.artemadera_gw/ (testy: zmienna AM_GW_USTAWIENIA = katalog). Zawartość (wersja 5, runda 16):
#   { 'wersja' => 5, 'standard' => { klucz => wartość, 'zamek' => {…} } – tylko pola inne niż fabryczne,
#     'typy' => { nazwa => { 'opis' => tekst, 'parametry' => {…} } } – własne typy domów (sketchup/typy_domow.rb),
#     'typ' => nazwa ostatnio wybranego typu, 'okno' => { 'uklad' => 'kroki' | 'zakladki', 'tryb_pol' => … } }
# – wartości tak, jak w oknie (teksty); sprawdza je Parametry.normalizuj. Nowy dom zaczyna od standardu i wybranego typu,
# nie od ostatniego podglądu (decyzja użytkownika z 2026-11-25) – podgląd niczego już nie zapisuje.
# Plik starszej wersji: „ostatnie” parametry stają się standardem (pola standardu) i typem „Ostatnie ustawienia”
# (pola typu i domu), własne szablony – typami; stary plik zostaje obok jako ustawienia_przed_r16.json.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require 'json'
require 'fileutils'

module ArteMadera
  module GeneratorWiencowy
    module Ustawienia
      PLIK = 'ustawienia.json'.freeze unless const_defined?(:PLIK)
      KOPIA = 'ustawienia_przed_r16.json'.freeze unless const_defined?(:KOPIA)
      # Wersja pliku: 2 (runda 10) – podciąg domyślnie na równo z podwaliną; 3 (runda 14) – listy przekrojów z hurtowni
      # z długościami handlowymi; 4 (runda 15) – deski nadbitki i podbitki 14 × 115, przekrój 45 × 120 w długościach 5,4 / 6 m;
      # 5 (runda 16) – standard warsztatu i typy domów zamiast ostatnich parametrów i szablonów, pół zamka fabrycznie włączone.
      WERSJA = 5 unless const_defined?(:WERSJA)
      # Listy przekrojów (rdzen/wykaz_drewna.rb) – w pliku starszym niż wersja 3 zastępowane fabrycznymi także w szablonach.
      LISTY_PRZEKROJOW = %w[przekroje_katalog platwie_katalog krokwie_katalog zadaszenie_katalog zadaszenie_slupy_katalog].freeze unless
        const_defined?(:LISTY_PRZEKROJOW)
      # Wymiary desek nadbitki i podbitki (rdzen/parametry_dach.rb) – w pliku starszym niż wersja 4 wracają do fabrycznych
      # 14 × 115 (decyzja użytkownika z 2026-11-25), także w szablonach.
      DESKI = %w[podbitka_grubosc podbitka_krycie nadbitka_grubosc nadbitka_krycie].freeze unless const_defined?(:DESKI)
      # Ostatnie parametry z pliku starszej wersji, które wracają do wartości fabrycznych: wersja pliku => klucze
      # (wersja 4: deski, lista legarów z przekrojem 45 × 120 i wybór warstw poszycia; wersja 5: pół zamka).
      DO_FABRYCZNYCH = { 2 => %w[podciag_poziom], 3 => LISTY_PRZEKROJOW,
                         4 => DESKI + %w[przekroje_katalog poszycie_nadbitka poszycie_deski], 5 => %w[polzamek] }.freeze unless
        const_defined?(:DO_FABRYCZNYCH)
      # To samo we własnych szablonach: wersja pliku => klucze.
      DO_FABRYCZNYCH_W_SZABLONACH = { 3 => LISTY_PRZEKROJOW, 4 => DESKI + %w[przekroje_katalog], 5 => %w[polzamek] }.freeze unless
        const_defined?(:DO_FABRYCZNYCH_W_SZABLONACH)
      # Nazwa typu, którym stają się ostatnie parametry z pliku starszej wersji, i jego opis.
      TYP_OSTATNIE = 'Ostatnie ustawienia (do kompilacji 15)'.freeze unless const_defined?(:TYP_OSTATNIE)
      UKLADY = %w[kroki zakladki].freeze unless const_defined?(:UKLADY)

      module_function

      # Katalog ustawień na tym komputerze.
      def katalog
        return ENV['AM_GW_USTAWIENIA'] if ENV['AM_GW_USTAWIENIA'] && !ENV['AM_GW_USTAWIENIA'].empty?
        if ENV['APPDATA'] && !ENV['APPDATA'].empty?
          File.join(ENV['APPDATA'], 'ArteMadera', 'GeneratorWiencowy')
        elsif RUBY_PLATFORM =~ /darwin/
          File.join(File.expand_path('~'), 'Library', 'Application Support', 'ArteMadera', 'GeneratorWiencowy')
        else
          File.join(File.expand_path('~'), '.artemadera_gw')
        end
      end

      # Pełna ścieżka pliku ustawień.
      def sciezka
        File.join(katalog, PLIK)
      end

      # Pusty zestaw ustawień bieżącej wersji.
      def pusty
        { 'wersja' => WERSJA, 'standard' => {}, 'typy' => {}, 'typ' => '', 'okno' => {} }
      end

      # Zawartość pliku (pusty zestaw, gdy brak pliku albo plik uszkodzony – wtedy ostrzeżenie w Log); plik starszej
      # wersji przeniesiony do bieżącej (ze_starszej) i zapisany, stary zostaje obok jako kopia.
      def wczytaj
        return pusty unless File.exist?(sciezka)
        d = JSON.parse(File.read(sciezka, encoding: 'UTF-8'))
        return pusty unless d.is_a?(Hash)
        if d['wersja'].to_i < WERSJA
          nowe = ze_starszej(d)
          kopia = File.join(katalog, KOPIA)
          FileUtils.cp(sciezka, kopia) unless File.exist?(kopia)
          zapisz(nowe)
          return nowe
        end
        pusty.merge('standard' => hash(d['standard']), 'typy' => hash(d['typy']), 'typ' => d['typ'].to_s, 'okno' => hash(d['okno']))
      rescue => e
        Log.warn("Ustawienia: nie można odczytać #{sciezka} (#{e.class}: #{e.message}) – przyjęto domyślne.")
        pusty
      end

      # Hash albo pusty hash, gdy to coś innego.
      def hash(v)
        v.is_a?(Hash) ? v : {}
      end

      # Ustawienia z pliku starszej wersji: zmienione wartości fabryczne zastępują zapamiętane (DO_FABRYCZNYCH), ostatnie
      # parametry – pola standardu inne niż fabryczne stają się standardem warsztatu, pola typu i domu – typem
      # TYP_OSTATNIE; własne szablony – typami (pola typu i domu).
      def ze_starszej(d)
        wersja = d['wersja'].to_i
        ostatnie = hash(d['ostatnie']).dup
        DO_FABRYCZNYCH.each { |w, klucze| klucze.each { |k| ostatnie.delete(k) } if wersja < w }
        ostatnie = ParametryDach.przenies_nadbitke(ostatnie)
        typy = {}
        wlasne = Poziomy.wybierz(tylko_inne(ostatnie), :typ, :dom)
        typy[TYP_OSTATNIE] = { 'opis' => 'Pola domu i typu z ostatniego podglądu przed kompilacją 16.', 'parametry' => wlasne } unless wlasne.empty?
        hash(d['szablony']).each do |nazwa, sz|
          next unless sz.is_a?(Hash)
          par = sz.dup
          DO_FABRYCZNYCH_W_SZABLONACH.each { |w, klucze| klucze.each { |k| par.delete(k) } if wersja < w }
          typy[nazwa.to_s] = { 'opis' => 'Własny szablon sprzed kompilacji 16.',
                               'parametry' => Poziomy.wybierz(ParametryDach.przenies_nadbitke(par), :typ, :dom) }
        end
        standard = Poziomy.wybierz(tylko_inne(ostatnie), :standard)
        standard['zamek'] = ostatnie['zamek'] if inny_zamek?(ostatnie)
        pusty.merge('standard' => standard, 'typy' => typy, 'typ' => typy.key?(TYP_OSTATNIE) ? TYP_OSTATNIE : '',
                    'okno' => hash(d['okno']))
      end

      # Tylko te pola zestawu, których wartość jest inna niż fabryczna.
      def tylko_inne(parametry)
        inne = Poziomy.rozne(parametry, {})
        wynik = {}
        parametry.each { |k, v| wynik[k] = v if inne.include?(k) }
        wynik
      end

      # Czy wymiary zamka w zestawie są inne niż wymiary presetu.
      def inny_zamek?(parametry)
        parametry['zamek'].is_a?(Hash) && Poziomy.rozne(parametry, 'preset' => parametry['preset']).include?('zamek')
      end

      # Zapis całego pliku (najpierw plik tymczasowy, potem zamiana); true gdy się udało.
      def zapisz(dane)
        FileUtils.mkdir_p(katalog)
        tmp = sciezka + '.tmp'
        File.open(tmp, 'w:UTF-8') { |f| f.write(JSON.pretty_generate(dane.merge('wersja' => WERSJA))) }
        File.rename(tmp, sciezka)
        true
      rescue => e
        Log.error('Ustawienia.zapisz', e)
        false
      end

      # Standard warsztatu: zapisane pola poziomu „Standard warsztatu” (inne niż fabryczne) i wymiary zamka.
      def standard
        wczytaj['standard']
      end

      # Zapis standardu warsztatu z zestawu parametrów (pola innych poziomów pominięte, zostają tylko wartości inne niż
      # fabryczne; pusty zestaw – powrót do fabrycznych); zwraca tekst błędu albo nil.
      def zapisz_standard(parametry)
        return 'Brak parametrów do zapisania.' unless parametry.is_a?(Hash)
        d = wczytaj
        st = Poziomy.wybierz(tylko_inne(parametry), :standard)
        st['zamek'] = parametry['zamek'] if inny_zamek?(parametry)
        d['standard'] = st
        zapisz(d) ? nil : "Nie można zapisać pliku #{sciezka}."
      end

      # Układ okna: 'kroki' (nowy – kroki w kolejności budowy, wynik zawsze na widoku; domyślnie) albo 'zakladki' (dotychczasowy).
      def uklad
        u = wczytaj['okno']['uklad']
        UKLADY.include?(u) ? u : UKLADY[0]
      end

      # Zapamiętanie układu okna.
      def zapamietaj_uklad(nazwa)
        d = wczytaj
        d['okno']['uklad'] = UKLADY.include?(nazwa.to_s) ? nazwa.to_s : UKLADY[0]
        zapisz(d)
      end

      # Tryb pól okna w układzie dotychczasowym: 'podstawowe' (domyślnie) albo 'wszystkie'.
      def tryb_pol
        wczytaj['okno']['tryb_pol'] == 'wszystkie' ? 'wszystkie' : 'podstawowe'
      end

      # Zapamiętanie trybu pól okna.
      def zapamietaj_tryb_pol(tryb)
        d = wczytaj
        d['okno']['tryb_pol'] = tryb.to_s == 'wszystkie' ? 'wszystkie' : 'podstawowe'
        zapisz(d)
      end
    end
  end
end
