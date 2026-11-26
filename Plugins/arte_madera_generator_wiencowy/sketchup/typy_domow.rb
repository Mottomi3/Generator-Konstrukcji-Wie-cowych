# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/typy_domow.rb
# Zadanie: typy domów – wbudowane (Typ 100–400) i własne zapisywane przez użytkownika: lista z opisami, zapis („Zapisz jako typ”, „Zapisz zmiany w typie”), powielenie, usunięcie, ostatnio wybrany typ, parametry nowego domu i baza porównania dla okna.
# Tematy: typy domów, typ domu, typy wbudowane, zapisz jako typ, zapisz zmiany w typie, powiel typ, usuń typ, wybrany typ, opis typu, parametry typu, baza typu, własne szablony jako typy
# Zależy od: sketchup/ustawienia.rb (plik ustawień), rdzen/poziomy.rb (pola typu i domu), rdzen/parametry_lista.rb (SZABLONY – typy wbudowane)
# Używają: sketchup/sterowanie.rb (start nowego domu), sketchup/okno.rb (dane startowe), sketchup/okno_typy.rb (wywołania okna)
#
# Decyzja użytkownika (2026-11-25): typy domów ustawia i predefiniuje sam, w wolnych chwilach – zapis ma być wygodny.
# Typ pamięta tylko pola poziomów „Typ domu” i „Ten dom” (wartości startowe, np. Typ 200: 20 wieńców, taras 2000);
# standard warsztatu jest wspólny. Typy wbudowane są punktem wyjścia: nie do usunięcia ani zmiany, do powielenia.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module TypyDomow
      # Opisy typów wbudowanych (jedno zdanie pod nazwą na liście).
      OPISY = {
        'Typ 100' => '16 wieńców, dach dwuspadowy 20° na samych płatwiach, bez tarasu.',
        'Typ 200' => '20 wieńców, taras 2 m z przodu na słupach z podciągiem.',
        'Typ 300' => '25 wieńców ze stropem, taras 2 m między ścianami, płatwie i krokwie.',
        'Typ 400' => 'Dach jednospadowy 15°, płatwie i krokwie.'
      }.freeze unless const_defined?(:OPISY)
      NAJDLUZSZA_NAZWA = 80 unless const_defined?(:NAJDLUZSZA_NAZWA)

      module_function

      # Typy wbudowane: { nazwa => { 'opis' =>, 'parametry' => } } – z szablonów „Typ …” listy parametrów.
      def wbudowane
        wynik = {}
        ParametryLista::SZABLONY.each do |nazwa, par|
          next unless nazwa.start_with?('Typ ')
          tekst = {}
          par.each { |k, v| tekst[k] = v.is_a?(Float) && v == v.round ? v.round.to_s : v.to_s }
          wynik[nazwa] = { 'opis' => OPISY[nazwa[0, 7]].to_s, 'parametry' => Poziomy.wybierz(tekst, :typ, :dom) }
        end
        wynik
      end

      # Własne typy z pliku ustawień: { nazwa => { 'opis' =>, 'parametry' => } }.
      def wlasne
        wynik = {}
        Ustawienia.wczytaj['typy'].each do |nazwa, t|
          next unless t.is_a?(Hash)
          wynik[nazwa.to_s] = { 'opis' => t['opis'].to_s, 'parametry' => Poziomy.wybierz(Ustawienia.hash(t['parametry']), :typ, :dom) }
        end
        wynik
      end

      # Lista typów do okna: wbudowane, potem własne alfabetycznie – [{ 'nazwa' =>, 'opis' =>, 'wbudowany' => }].
      def lista
        wbudowane.map { |n, t| { 'nazwa' => n, 'opis' => t['opis'], 'wbudowany' => true } } +
          wlasne.sort_by { |n, _t| n.downcase }.map { |n, t| { 'nazwa' => n, 'opis' => t['opis'], 'wbudowany' => false } }
      end

      # Typ o podanej nazwie ({ 'opis' =>, 'parametry' => }); nil – nie ma takiego.
      def typ(nazwa)
        wlasne[nazwa.to_s] || wbudowane[nazwa.to_s]
      end

      # Pola typu (poziomy „Typ domu” i „Ten dom”); nieznany typ – {}.
      def parametry(nazwa)
        t = typ(nazwa)
        t ? t['parametry'] : {}
      end

      # Czy typ jest wbudowany.
      def wbudowany?(nazwa)
        wbudowane.key?(nazwa.to_s)
      end

      # Ostatnio wybrany typ (gdy już go nie ma – pierwszy wbudowany).
      def wybrany
        n = Ustawienia.wczytaj['typ'].to_s
        typ(n) ? n : wbudowane.keys.first.to_s
      end

      # Zapamiętanie wybranego typu; zwraca tekst błędu albo nil.
      def wybierz(nazwa)
        return "Nie ma typu „#{nazwa}”." if typ(nazwa).nil?
        d = Ustawienia.wczytaj
        d['typ'] = nazwa.to_s
        Ustawienia.zapisz(d) ? nil : "Nie można zapisać pliku #{Ustawienia.sciezka}."
      end

      # Parametry nowego domu tego typu do okna: standard warsztatu uzupełniony polami typu (Poziomy.zloz).
      def nowy_dom(nazwa)
        Poziomy.zloz(Ustawienia.standard, parametry(nazwa))
      end

      # Baza porównania dla okna – wartości wszystkich pól według standardu i typu (sprawdzone, z wymiarami zamka):
      # pole o innej wartości jest „zmienione tylko w tym domu”.
      def baza(nazwa)
        Parametry.normalizuj(nowy_dom(nazwa))[0]
      end

      # Zapis własnego typu z parametrów okna („Zapisz jako typ” – nowa nazwa, „Zapisz zmiany w typie” – ta sama):
      # zostają pola poziomów „Typ domu” i „Ten dom”; zwraca tekst błędu albo nil.
      def zapisz(nazwa, opis, parametry)
        n = nazwa.to_s.strip
        return 'Podaj nazwę typu.' if n.empty?
        return "Nazwa typu może mieć najwyżej #{NAJDLUZSZA_NAZWA} znaków." if n.length > NAJDLUZSZA_NAZWA
        return 'Typ wbudowany – zapisz pod inną nazwą („Zapisz jako typ”) albo go powiel.' if wbudowany?(n)
        return 'Brak parametrów do zapisania.' unless parametry.is_a?(Hash)
        d = Ustawienia.wczytaj
        stary = Ustawienia.hash(d['typy'][n])
        d['typy'][n] = { 'opis' => opis.nil? ? stary['opis'].to_s : opis.to_s.strip,
                         'parametry' => Poziomy.wybierz(ParametryDach.przenies_nadbitke(parametry), :typ, :dom) }
        d['typ'] = n
        Ustawienia.zapisz(d) ? nil : "Nie można zapisać pliku #{Ustawienia.sciezka}."
      end

      # Powielenie typu (także wbudowanego) pod nową nazwą; zwraca tekst błędu albo nil.
      def powiel(nazwa, nowa)
        t = typ(nazwa)
        return "Nie ma typu „#{nazwa}”." if t.nil?
        return "Typ „#{nowa.to_s.strip}” już jest – podaj inną nazwę." if typ(nowa.to_s.strip)
        zapisz(nowa, t['opis'], t['parametry'])
      end

      # Usunięcie własnego typu; zwraca tekst błędu albo nil.
      def usun(nazwa)
        return 'Typów wbudowanych nie można usunąć – można je powielić.' if wbudowany?(nazwa)
        d = Ustawienia.wczytaj
        return "Nie ma typu „#{nazwa}”." unless d['typy'].key?(nazwa.to_s)
        d['typy'].delete(nazwa.to_s)
        d['typ'] = '' if d['typ'] == nazwa.to_s
        Ustawienia.zapisz(d) ? nil : "Nie można zapisać pliku #{Ustawienia.sciezka}."
      end
    end
  end
end
