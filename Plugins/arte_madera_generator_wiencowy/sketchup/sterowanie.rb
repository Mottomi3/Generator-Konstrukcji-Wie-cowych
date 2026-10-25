# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/sterowanie.rb
# Zadanie: przebieg pracy z menu – start (linie albo dom do edycji), podgląd, generowanie, kontrola; dane wyniku dla okna.
# Tematy: sterowanie, start z menu, tryb nowy / edycja, przebudowa z parametrów, ostrzeżenie o ręcznych poprawkach, kontrola zamków z menu, dane dla okna, rzut w oknie, ostatnie parametry, podpowiedzi w oknie, widok ściany dla okna, ostatni plan, dach z aplikacji po budowie
# Zależy od: rdzen/projekt.rb, rdzen/kontrola.rb, rdzen/widok.rb, sketchup/wejscie.rb, sketchup/budowa.rb, sketchup/dach_aplikacja.rb, sketchup/atrybuty.rb, sketchup/okno.rb, sketchup/ustawienia.rb, log.rb
# Używają: sketchup/menu.rb, sketchup/okno.rb (wywołania z okna)
#
# Wejście domu (Hash zapisywany w modelu): segmenty, z0, parametry, otwory, sciany (ustawienia ścian z widoku ściany).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module Sterowanie
      class << self
        attr_reader :wejscie, :dom, :plan

        # Menu „Generuj / edytuj”: zaznaczone linie → nowy dom, zaznaczony dom → edycja parametrów.
        def start
          model = Sketchup.active_model
          return UI.messagebox('Brak aktywnego modelu SketchUpa.') if model.nil?
          z = Wejscie.z_zaznaczenia(model)
          return UI.messagebox(z[:blad]) if z[:blad]
          if z[:dom]
            wej = Atrybuty.czytaj_wejscie(z[:dom])
            return UI.messagebox('Zaznaczony dom nie ma zapisanych parametrów – wygeneruj go ponownie z linii.') if wej.nil?
            @dom = z[:dom]
            @wejscie = wej
            info = 'Edycja zaznaczonego domu – „Generuj w modelu” zastąpi go nową wersją.'
            tryb = 'edycja'
          else
            @dom = nil
            ostatnie = Ustawienia.ostatnie
            @wejscie = { 'segmenty' => z[:segmenty], 'z0' => z[:z0], 'parametry' => ostatnie, 'otwory' => [], 'sciany' => {} }
            info = format('Zaznaczono %d linii na wysokości %.0f mm.', z[:segmenty].length, z[:z0])
            info += ' Parametry z ostatniego użycia.' unless ostatnie.empty?
            tryb = 'nowy'
          end
          plan = Log.time('obliczenia') { Projekt.oblicz(@wejscie) }
          @plan = plan
          Okno.pokaz('tryb' => tryb, 'parametry' => @wejscie['parametry'], 'otwory' => @wejscie['otwory'],
                     'sciany' => @wejscie['sciany'] || {}, 'info' => info, 'podsumowanie' => dla_okna(plan))
        rescue => e
          Log.error('Sterowanie.start', e)
          UI.messagebox("Wystąpił błąd:\n#{e.class}: #{e.message}\n\nSzczegóły w Konsoli Ruby.")
        end

        # Podgląd z okna: obliczenia bez zmian w modelu; parametry zapamiętane na komputerze.
        def podglad(dane)
          wej = scal(dane)
          Ustawienia.zapamietaj(wej['parametry'])
          @plan = Log.time('podgląd') { Projekt.oblicz(wej) }
          dla_okna(@plan)
        end

        # Widok ściany z ostatniego planu (podgląd lub generowanie) dla okna; { 'blad' => tekst }, gdy nie ma ściany.
        def widok(id)
          w = Widok.sciana(@plan, id)
          w || { 'blad' => "Brak ściany #{id} w ostatnim podglądzie.", 'id' => id.to_s }
        end

        # Generowanie z okna: obliczenia i budowa (zastępuje edytowany dom), potem dach z aplikacji do dachów (połacie
        # i KROK 2 – 'dach' w wyniku: tekst do okna); parametry zapamiętane na komputerze.
        def generuj(dane)
          model = Sketchup.active_model
          wej = scal(dane)
          Ustawienia.zapamietaj(wej['parametry'])
          plan = Log.time('obliczenia') { Projekt.oblicz(wej) }
          @plan = plan
          wynik = dla_okna(plan)
          return wynik unless plan[:bledy].empty?
          stary = @dom && @dom.valid? ? @dom : nil
          if stary && Atrybuty.zmieniony_recznie?(stary)
            odp = UI.messagebox("Dom zmieniono ręcznie po wygenerowaniu (przesunięte, usunięte lub dodane elementy).\n" \
                                'Nowa wersja zastąpi te zmiany. Kontynuować?', MB_YESNO)
            return wynik.merge('anulowano' => true) if odp != IDYES
          end
          stary_id = stary ? Atrybuty.dom_id(stary) : nil
          zb = Log.time('budowa modelu') { Budowa.zbuduj(model, plan, wej, stary) }
          @dom = zb[:grupa]
          @wejscie = wej
          model.selection.clear
          model.selection.add(@dom)
          Log.info(format('Dom wygenerowany: %d ścian, %d bali, %d pozycji.', plan[:sciany].length, plan[:bale].length,
                          plan[:pozycje].length))
          dach = DachAplikacja.po_budowie(model, @dom, plan, stary_id)
          wynik.merge('zbudowano' => true, 'definicje' => zb[:definicje], 'bledne_sciany' => zb[:bledne_sciany], 'dach' => dach)
        end

        # Menu „Kontrola”: kolizje w zamkach, mijanka, długości dla zaznaczonego domu.
        def kontrola
          model = Sketchup.active_model
          dom = model ? model.selection.to_a.find { |e| Atrybuty.dom?(e) } : nil
          return UI.messagebox('Zaznacz dom wygenerowany generatorem wieńcowym.') if dom.nil?
          wej = Atrybuty.czytaj_wejscie(dom)
          return UI.messagebox('Zaznaczony dom nie ma zapisanych parametrów – wygeneruj go ponownie z linii.') if wej.nil?
          plan = Projekt.oblicz(wej)
          k = Log.time('kontrola') { Kontrola.wszystko(plan) }
          tekst = []
          tekst << (k[:kolizje].empty? ? 'Zamki: bez kolizji.' : "Zamki: #{k[:kolizje].length} miejsc kolizji (szczegóły w Konsoli Ruby).")
          tekst << (k[:mijanka].empty? ? 'Mijanka styków: w porządku (min. 300 mm).' : "Mijanka: #{k[:mijanka].length} naruszeń.")
          tekst << (k[:za_dlugie].empty? ? 'Długości bali: w porządku.' : "Za długie bale: #{k[:za_dlugie].length}.")
          tekst << (k[:styki_bez_zamka].empty? ? 'Styki w zamkach: w porządku.' : "Styki bez zamka: #{k[:styki_bez_zamka].length}.")
          k[:kolizje].first(20).each { |c| Log.warn("Kolizja #{c[:sciany].join('/')} przy #{c[:punkt].inspect}, z #{c[:z].inspect}") }
          k[:mijanka].each { |m| Log.warn("Mijanka #{m[:sciana]} wieniec #{m[:wieniec]}: #{m[:odstep]} mm") }
          UI.messagebox(tekst.join("\n"))
        rescue => e
          Log.error('Sterowanie.kontrola', e)
          UI.messagebox("Wystąpił błąd:\n#{e.class}: #{e.message}")
        end

        # Wejście domu: zapamiętane linie i poziom + parametry, otwory i ustawienia ścian (widok ściany) z okna.
        def scal(dane)
          baza = @wejscie || {}
          { 'segmenty' => baza['segmenty'] || [], 'z0' => baza['z0'].to_f,
            'parametry' => dane['parametry'] || {}, 'otwory' => dane['otwory'] || [],
            'sciany' => dane['sciany'].is_a?(Hash) ? dane['sciany'] : (baza['sciany'] || {}) }
        end

        # Wynik dla okna (tylko typy JSON): błędy, ostrzeżenia, podpowiedzi, ściany, lista bali i belek, rzut.
        def dla_okna(plan)
          wynik = { 'bledy' => plan[:bledy], 'ostrzezenia' => plan[:ostrzezenia], 'rzut' => rzut(plan),
                    'podpowiedzi' => (plan[:podpowiedzi] || []).map { |h| klucze_tekstowe(h) }, 'widoki' => Widok.lista(plan) }
          s = plan[:podsumowanie]
          return wynik if s.nil?
          wynik.merge(
            'sciany' => s[:sciany].map { |w| klucze_tekstowe(w) },
            'lista' => s[:lista].map { |l| klucze_tekstowe(l) },
            'liczby' => { 'bale' => s[:liczba_bali], 'pozycje' => s[:liczba_pozycji], 'objetosc_m3' => s[:objetosc_m3],
                          'waga_kg' => s[:waga_kg], 'pary_zamkow' => s[:pary_zamkow], 'kontrfory_nowe' => s[:kontrfory_nowe],
                          'wegly_usztywniajace' => s[:wegly_usztywniajace], 'wegly_narysowane' => s[:wegly_narysowane],
                          'limit_swiatla' => s[:limit_swiatla], 'szczyty' => s[:szczyty], 'bale_szczytu' => s[:bale_szczytu],
                          'belki' => s[:liczba_belek], 'objetosc_belek_m3' => s[:objetosc_belek_m3] },
            'wysokosci' => klucze_tekstowe(s[:wysokosci]), 'przekroj' => s[:przekroj]
          )
        end

        # Rzut do okna: obrys i ściany (bale od końca do końca) w mm układu lokalnego.
        def rzut(plan)
          { 'obrys' => plan[:obrys],
            'sciany' => plan[:sciany].map do |w|
              { 'id' => w[:id], 'rodzaj' => w[:rodzaj].to_s, 'od' => Sciany.punkt(w, w[:s_od]), 'do' => Sciany.punkt(w, w[:s_do]),
                'ref' => Sciany.punkt(w, w[:ref] || 0.0),
                'otwory' => (w[:otwory] || []).reject { |o| o[:gniazdo] }.map { |o| [Sciany.punkt(w, o[:s0]), Sciany.punkt(w, o[:s1])] } }
            end }
        end

        # Hash z kluczami symbolami → kluczami tekstowymi (do JSON).
        def klucze_tekstowe(h)
          wynik = {}
          h.each { |k, v| wynik[k.to_s] = v.is_a?(Symbol) ? v.to_s : v }
          wynik
        end
      end
    end
  end
end
