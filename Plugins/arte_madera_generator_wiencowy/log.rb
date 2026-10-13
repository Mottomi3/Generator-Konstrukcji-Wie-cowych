# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: log.rb
# Zadanie: dziennik wtyczki – jedno miejsce na błędy, ostrzeżenia, informacje i czasy etapów.
# Tematy: dziennik, błędy, ostrzeżenia, czasy etapów, Konsola Ruby
# Zależy od: –
# Używają: wszystkie pliki (rdzeń i warstwa SketchUp)
#
# Każdy wpis trafia do Konsoli Ruby (przedrostek „[ArteMadera GW]”) i do pamięci (ostatnie 300 wpisów);
# w testach wydruk wyłącza zmienna środowiska AM_GW_CICHO.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module Log
      PREFIX = '[ArteMadera GW]'.freeze unless const_defined?(:PREFIX)
      MAX_WPISOW = 300 unless const_defined?(:MAX_WPISOW)
      MAX_CZASOW = 200 unless const_defined?(:MAX_CZASOW)
      # Etap dłuższy niż tyle milisekund jest też wypisywany w Konsoli Ruby.
      WOLNY_MS = 2000.0 unless const_defined?(:WOLNY_MS)

      @wpisy ||= []
      @czasy ||= []
      @liczniki ||= { 'error' => 0, 'warning' => 0, 'info' => 0 }

      class << self
        # Błąd z wyjątkiem: gdzie – moduł i metoda (np. „Budowa.zbuduj”).
        def error(gdzie, wyjatek, linie = 6)
          tekst = "#{gdzie}: #{wyjatek.class}: #{wyjatek.message}"
          slad = wyjatek.respond_to?(:backtrace) && wyjatek.backtrace ? wyjatek.backtrace.first(linie.to_i) : []
          wypisz(tekst, slad)
          dodaj('error', tekst, slad)
          nil
        rescue StandardError
          nil
        end

        # Błąd opisany tekstem (np. zgłoszony przez okno – JavaScript).
        def error_text(tekst)
          wypisz(tekst.to_s)
          dodaj('error', tekst.to_s, [])
          nil
        rescue StandardError
          nil
        end

        # Ostrzeżenie (np. ostatek wchodzący do wnętrza, otwór przy skrzyżowaniu).
        def warn(tekst)
          wypisz(tekst.to_s)
          dodaj('warning', tekst.to_s, [])
          nil
        rescue StandardError
          nil
        end

        # Informacja (np. podsumowanie generowania).
        def info(tekst)
          wypisz(tekst.to_s)
          dodaj('info', tekst.to_s, [])
          nil
        rescue StandardError
          nil
        end

        # Czas etapu; blok dostaje słownik na szczegóły, zwracany jest wynik bloku.
        def time(etap)
          start = Time.now
          szczegoly = {}
          skonczony = false
          begin
            wynik = yield(szczegoly)
            skonczony = true
            wynik
          ensure
            zapisz_czas(etap, (Time.now - start) * 1000.0, szczegoly, skonczony)
          end
        end

        # Zapis czasu etapu (wywoływany przez time).
        def zapisz_czas(etap, ms, szczegoly, skonczony)
          wpis = { 'etap' => etap.to_s, 'ms' => ms.to_f.round(1), 'ok' => skonczony ? true : false }
          wpis['szczegoly'] = szczegoly if szczegoly.is_a?(Hash) && !szczegoly.empty?
          @czasy << wpis
          @czasy.shift while @czasy.length > MAX_CZASOW
          if ms.to_f >= WOLNY_MS || !skonczony
            wypisz(format('czas: %s – %.1f s%s', etap, ms.to_f / 1000.0, skonczony ? '' : ' (przerwane)'))
          end
          wpis
        rescue StandardError
          nil
        end

        # Kopia wpisów (do okna i raportu).
        def wpisy
          @wpisy.map(&:dup)
        end

        # Kopia zapisanych czasów etapów.
        def czasy
          @czasy.map(&:dup)
        end

        # Liczba wpisów według poziomu.
        def liczniki
          @liczniki.dup
        end

        # Czyszczenie dziennika (testy, nowa sesja generowania).
        def wyczysc
          @wpisy = []
          @czasy = []
          @liczniki = { 'error' => 0, 'warning' => 0, 'info' => 0 }
          nil
        end

        private

        # Zapis wpisu w pamięci (najwyżej MAX_WPISOW ostatnich).
        def dodaj(poziom, tekst, slad)
          @liczniki[poziom] = (@liczniki[poziom] || 0) + 1
          @wpisy << { 'poziom' => poziom, 'czas' => Time.now.strftime('%H:%M:%S'), 'tekst' => tekst, 'slad' => slad }
          @wpisy.shift while @wpisy.length > MAX_WPISOW
        end

        # Wydruk do Konsoli Ruby – jedyne miejsce z puts w module (dziennik).
        def wypisz(tekst, slad = [])
          return if ENV['AM_GW_CICHO']
          puts "#{PREFIX} #{tekst}"
          slad.each { |l| puts "    #{l}" } if slad && !slad.empty?
        end
      end
    end
  end
end
