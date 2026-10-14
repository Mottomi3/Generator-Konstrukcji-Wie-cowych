# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/raport.rb
# Zadanie: test działania w prawdziwym SketchUpie i raport do wysłania – przykładowe domy budowane w operacji cofanej na końcu (model bez zmian), bryły zamknięte i objętości, zaznaczony dom, środowisko, dziennik.
# Tematy: test działania, raport do testów, raport JSON, bryła zamknięta w SketchUpie, objętość bryły, środowisko SketchUpa, porównanie modelu z planem, czas budowy
# Zależy od: rdzen/przyklady.rb, rdzen/projekt.rb, rdzen/kontrola.rb, rdzen/bryla.rb, sketchup/budowa.rb, sketchup/atrybuty.rb, sketchup/eksport.rb, sketchup/ustawienia.rb, log.rb
# Używają: sketchup/menu.rb („Test działania i raport…”)
#
# Raport (JSON) ma pozwolić sprawdzić wtyczkę bez dostępu do komputera użytkownika: wersje SketchUpa i Ruby, dla każdego
# przykładowego domu liczby z planu i z modelu, bryły niezamknięte i z inną objętością, czasy; dla zaznaczonego domu –
# zgodność modelu z parametrami. Przykładowe domy znikają z modelu (abort_operation).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require 'json'

module ArteMadera
  module GeneratorWiencowy
    module Raport
      # Cale³ → mm³.
      CAL3 = 25.4**3 unless const_defined?(:CAL3)
      # Dopuszczalna różnica objętości bryły w SketchUpie i z profilu (część objętości).
      TOL_OBJ = 0.002 unless const_defined?(:TOL_OBJ)

      module_function

      # Menu: test działania, zapis raportu (okno zapisu) i podsumowanie w okienku.
      def uruchom
        model = Sketchup.active_model
        return UI.messagebox('Brak aktywnego modelu SketchUpa.') if model.nil?
        raport = Log.time('test działania') { zbierz(model) }
        sciezka = Eksport.wybierz_plik('Zapisz raport testu działania (do wysłania)',
                                       "ArteMadera_GW_raport_#{Time.now.strftime('%Y-%m-%d_%H%M')}.json", '.json')
        Eksport.zapisz(sciezka, JSON.pretty_generate(raport)) if sciezka
        UI.messagebox(podsumowanie(raport) + (sciezka ? "\n\nRaport zapisano:\n#{sciezka}" : "\n\nRaportu nie zapisano."))
        raport
      rescue => e
        Log.error('Raport.uruchom', e)
        UI.messagebox("Test działania przerwany błędem:\n#{e.class}: #{e.message}\n\nSzczegóły w Konsoli Ruby.")
        nil
      end

      # Cały raport: środowisko, zaznaczony dom, przykładowe domy, dziennik.
      def zbierz(model)
        dom = model.selection.to_a.find { |e| Atrybuty.dom?(e) }
        raport = { 'raport' => 'ArteMadera Generator Wieńcowy – test działania', 'czas' => Time.now.strftime('%Y-%m-%d %H:%M:%S'),
                   'srodowisko' => srodowisko(model), 'zaznaczony_dom' => dom ? sprawdz_dom(dom) : nil }
        raport['przyklady'] = przyklady(model)
        raport['dziennik'] = { 'wpisy' => Log.wpisy.last(60), 'czasy' => Log.czasy.last(40) }
        raport
      end

      # Wersje i ustawienia: SketchUp, Ruby, wtyczka, jednostki modelu, plik ustawień.
      def srodowisko(model)
        jednostki = begin
          model.options['UnitsOptions']['LengthUnit']
        rescue StandardError
          nil
        end
        { 'wtyczka' => PLUGIN_VERSION, 'kompilacja' => PLUGIN_BUILD, 'data_kompilacji' => PLUGIN_BUILD_DATE,
          'sketchup' => Sketchup.version.to_s, 'pro' => Sketchup.respond_to?(:is_pro?) ? Sketchup.is_pro? : nil,
          'jezyk' => Sketchup.respond_to?(:os_language) ? Sketchup.os_language : nil,
          'ruby' => RUBY_VERSION, 'platforma' => RUBY_PLATFORM, 'jednostki_modelu' => jednostki,
          'plik_ustawien' => Ustawienia.sciezka, 'ostatnie_parametry' => Ustawienia.ostatnie }
      end

      # Przykładowe domy zbudowane w jednej operacji, cofniętej na końcu (model zostaje bez zmian).
      def przyklady(model)
        wyniki = []
        model.start_operation('ArteMadera – test działania', true)
        begin
          Przyklady.lista.each do |pr|
            wyniki << begin
              test_domu(model, pr['nazwa'], pr['wejscie'])
            rescue => e
              Log.error("Raport.przyklady – #{pr['nazwa']}", e)
              { 'nazwa' => pr['nazwa'], 'wyjatek' => "#{e.class}: #{e.message}", 'slad' => (e.backtrace || []).first(6) }
            end
          end
        ensure
          model.abort_operation
        end
        wyniki
      end

      # Jeden dom: obliczenia, budowa w modelu, bryły i liczby elementów w modelu, kontrola, czasy.
      def test_domu(model, nazwa, wejscie)
        t0 = Time.now
        plan = Projekt.oblicz(wejscie)
        t1 = Time.now
        wynik = { 'nazwa' => nazwa, 'bledy' => plan[:bledy], 'ostrzezenia' => plan[:ostrzezenia], 'plan' => liczby_planu(plan),
                  'czas_obliczen_s' => (t1 - t0).round(2) }
        return wynik unless plan[:bledy].empty?
        zb = Budowa.zbuduj_w_operacji(model, plan, wejscie)
        wynik['czas_budowy_s'] = (Time.now - t1).round(2)
        wynik['model'] = liczby_modelu(zb[:grupa])
        wynik['bledne_sciany'] = zb[:bledne_sciany]
        wynik.merge!(bryly(plan, zb[:defs]))
        k = Kontrola.wszystko(plan)
        wynik['kontrola'] = { 'kolizje' => k[:kolizje].length, 'mijanka' => k[:mijanka].length, 'za_dlugie' => k[:za_dlugie].length,
                              'styki_bez_zamka' => k[:styki_bez_zamka].length }
        wynik['zgodny'] = zgodny?(wynik)
        wynik
      end

      # Liczby z planu: bale, pozycje, belki według prefiksu.
      def liczby_planu(plan)
        prefiksy = Hash.new(0)
        (plan[:bale] || []).each { |b| prefiksy[b[:pozycja][:prefiks]] += 1 }
        (plan[:elementy] || []).each { |e| prefiksy[e[:prefiks]] += 1 }
        { 'bale' => (plan[:bale] || []).length, 'pozycje' => (plan[:pozycje] || []).length,
          'belki' => (plan[:elementy] || []).length, 'pozycje_belek' => (plan[:pozycje_elementow] || []).length,
          'prefiksy' => prefiksy }
      end

      # Liczby z modelu (grupa domu): instancje według prefiksu definicji, grupy ścian.
      def liczby_modelu(grupa)
        prefiksy = Hash.new(0)
        grupy = 0
        grupa.entities.to_a.each do |g|
          next unless g.respond_to?(:entities) && !g.is_a?(Sketchup::ComponentInstance)
          grupy += 1
          g.entities.to_a.each do |i|
            next unless i.is_a?(Sketchup::ComponentInstance)
            prefiksy[i.definition.get_attribute(Atrybuty::DICT_AM, 'prefiks').to_s] += 1
          end
        end
        { 'grupy' => grupy, 'instancje' => prefiksy.values.inject(0, :+), 'prefiksy' => prefiksy }
      end

      # Bryły definicji: zamknięte (manifold) i z objętością jak z profilu; listy nazw z problemami.
      def bryly(plan, defs)
        niezamkniete = []
        objetosc = []
        (plan[:pozycje] + (plan[:pozycje_elementow] || [])).each do |poz|
          d = defs[poz[:nr]]
          inst = d && d.instances.first
          next if inst.nil?
          unless inst.respond_to?(:manifold?) && inst.manifold?
            niezamkniete << poz[:nazwa]
            next
          end
          oczek = Bryla.objetosc(Bryla.profil(poz[:dl], poz[:t], poz[:h], poz[:cechy]))
          jest = inst.volume.to_f * CAL3
          objetosc << [poz[:nazwa], oczek.round, jest.round] if (jest - oczek).abs > oczek * TOL_OBJ + 1.0
        end
        { 'definicje' => defs.length, 'niezamkniete' => niezamkniete, 'inna_objetosc' => objetosc }
      end

      # Czy dom w modelu zgadza się z planem: tyle instancji, co bali i belek, wszystkie bryły zamknięte, objętości zgodne.
      def zgodny?(w)
        w['model']['instancje'] == w['plan']['bale'] + w['plan']['belki'] && w['niezamkniete'].empty? &&
          w['inna_objetosc'].empty? && w['bledne_sciany'].to_i.zero?
      end

      # Zaznaczony dom: parametry, kompilacja, ręczne zmiany, liczby z planu i z modelu.
      def sprawdz_dom(dom)
        wej = Atrybuty.czytaj_wejscie(dom)
        return { 'blad' => 'Dom bez zapisanych parametrów.' } if wej.nil?
        plan = Projekt.oblicz(wej)
        { 'kompilacja_domu' => dom.get_attribute(Atrybuty::DICT_GW, 'kompilacja').to_s,
          'zmieniony_recznie' => Atrybuty.zmieniony_recznie?(dom), 'parametry' => wej['parametry'], 'otwory' => wej['otwory'],
          'liczba_linii' => (wej['segmenty'] || []).length, 'bledy' => plan[:bledy], 'ostrzezenia' => plan[:ostrzezenia],
          'plan' => liczby_planu(plan), 'model' => liczby_modelu(dom) }
      end

      # Tekst okienka po teście.
      def podsumowanie(r)
        linie = ["Test działania – SketchUp #{r['srodowisko']['sketchup']}, Ruby #{r['srodowisko']['ruby']}, " \
                 "kompilacja #{r['srodowisko']['kompilacja']}"]
        r['przyklady'].each do |w|
          stan = if w['wyjatek'] then "BŁĄD: #{w['wyjatek']}"
                 elsif !w['bledy'].empty? then "błędy: #{w['bledy'].first}"
                 elsif w['zgodny'] then format('w porządku (%d bali, %d belek, %.1f s)', w['plan']['bale'], w['plan']['belki'],
                                               w['czas_obliczen_s'].to_f + w['czas_budowy_s'].to_f)
                 else format('NIEZGODNY: niezamknięte %d, inna objętość %d, instancje %d z %d', w['niezamkniete'].length,
                             w['inna_objetosc'].length, w['model']['instancje'], w['plan']['bale'] + w['plan']['belki'])
                 end
          linie << "• #{w['nazwa']}: #{stan}"
        end
        z = r['zaznaczony_dom']
        linie << "Zaznaczony dom: #{z['zmieniony_recznie'] ? 'zmieniony ręcznie' : 'bez ręcznych zmian'}, kompilacja #{z['kompilacja_domu']}" if z && !z['blad']
        linie.join("\n")
      end
    end
  end
end
