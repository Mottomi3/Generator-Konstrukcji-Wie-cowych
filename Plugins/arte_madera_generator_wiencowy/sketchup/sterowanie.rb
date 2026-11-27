# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/sterowanie.rb
# Zadanie: przebieg pracy z menu – start (linie albo dom do edycji), podgląd, generowanie, kontrola; dane wyniku dla okna.
# Tematy: sterowanie, standard warsztatu z menu, okienko po awarii obliczeń, wpis do dziennika pracy po generowaniu, start z menu, tryb nowy / edycja, przebudowa z parametrów, ostrzeżenie o ręcznych poprawkach, kontrola zamków z menu, dane dla okna, rzut w oknie, ostatnie parametry, podpowiedzi w oknie, widok ściany dla okna, ostatni plan, dach z aplikacji po budowie
# Zależy od: rdzen/projekt.rb, rdzen/awaria.rb (plan[:wyjatek]), rdzen/kontrola.rb, rdzen/widok.rb, sketchup/wejscie.rb, sketchup/budowa.rb, sketchup/dach_aplikacja.rb, sketchup/atrybuty.rb, sketchup/okno.rb, sketchup/ustawienia.rb, sketchup/dziennik_pracy.rb, log.rb
# Używają: sketchup/menu.rb, sketchup/pasek.rb, sketchup/okno.rb (wywołania z okna)
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
          z = dom_czy_linie(z)
          return if z.nil?
          # Każde otwarcie od nowa: bez planu i pamięci podręcznej z poprzedniego okna (uwaga użytkownika, runda 10).
          @plan = nil
          PlatwieWience::PAMIEC.clear
          if z[:dom]
            wej = Atrybuty.czytaj_wejscie(z[:dom])
            return UI.messagebox('Zaznaczony dom nie ma zapisanych parametrów – wygeneruj go ponownie z linii.') if wej.nil?
            @dom = z[:dom]
            # Dom z wcześniejszej kompilacji: dawne pola nadbitki → jedno pole położenia desek (okno pokazuje już nowe pole).
            wej['parametry'] = ParametryDach.przenies_nadbitke(wej['parametry']) if wej['parametry'].is_a?(Hash)
            @wejscie = wej
            info = 'Edycja zaznaczonego domu – „Generuj w modelu” zastąpi go nową wersją.'
            tryb = 'edycja'
          else
            # Nowy dom zaczyna od standardu warsztatu i ostatnio wybranego typu – nie od ostatniego podglądu
            # (decyzja użytkownika z 2026-11-25); nic nie zaznaczone – prostokąt z wymiarów (rdzen/dom_z_wymiarow.rb).
            @dom = nil
            typ = TypyDomow.wybrany
            par = TypyDomow.nowy_dom(typ)
            @wejscie = { 'segmenty' => z[:pusto] ? DomZWymiarow.segmenty(par, []) : z[:segmenty], 'z0' => z[:pusto] ? 0.0 : z[:z0],
                         'parametry' => par, 'otwory' => [], 'wegly' => [], 'sciany' => {}, 'typ' => typ }
            @wejscie['z_wymiarow'] = true if z[:pusto]
            info = if z[:pusto]
                     'Nic nie zaznaczono – dom prostokątny z wymiarów (długość i szerokość w kroku „Ściany”).'
                   else
                     format('Zaznaczono %d linii na wysokości %.0f mm.', z[:segmenty].length, z[:z0])
                   end
            tryb = 'nowy'
          end
          plan = Log.time('obliczenia') { Projekt.oblicz(@wejscie) }
          @plan = plan
          okienko_awarii(plan, @wejscie)
          Okno.pokaz('tryb' => tryb, 'parametry' => @wejscie['parametry'], 'otwory' => @wejscie['otwory'], 'wegly' => @wejscie['wegly'] || [],
                     'sciany' => @wejscie['sciany'] || {}, 'info' => info, 'podsumowanie' => dla_okna(plan),
                     'typ' => @wejscie['typ'], 'z_wymiarow' => @wejscie['z_wymiarow'], 'dzialowe' => @wejscie['dzialowe'] || [])
        rescue => e
          Log.error('Sterowanie.start', e)
          UI.messagebox("Wystąpił błąd:\n#{e.class}: #{e.message}\n\nSzczegóły w Konsoli Ruby.")
        end

        # Menu „Standard warsztatu…”: okno z samym panelem standardu (bez domu, bez podglądu) – zmiana tego, jak budujesz
        # zawsze, bez zaznaczania linii ani domu.
        def standard
          @plan = nil
          @dom = nil
          @wejscie = nil
          Okno.pokaz('tryb' => 'standard', 'parametry' => {}, 'otwory' => [], 'wegly' => [], 'sciany' => {},
                     'info' => 'Standard warsztatu – wspólny dla wszystkich typów domów i nowych domów.', 'typ' => TypyDomow.wybrany)
        rescue => e
          Log.error('Sterowanie.standard', e)
          UI.messagebox("Wystąpił błąd:\n#{e.class}: #{e.message}\n\nSzczegóły w Konsoli Ruby.")
        end

        # Zaznaczony dom i linie razem: te same linie, z których dom powstał – edycja domu; inne – pytanie, czy zrobić
        # nowy dom z linii (Tak) czy edytować zaznaczony dom (Nie); Anuluj – nil. Wcześniej dom w zaznaczeniu zawsze
        # wygrywał i okno otwierało się z jego parametrami zamiast od nowa (uwaga użytkownika, runda 10).
        def dom_czy_linie(z)
          return z unless z[:dom] && z[:segmenty]
          wej = Atrybuty.czytaj_wejscie(z[:dom])
          return { dom: z[:dom] } if wej && te_same_linie?(wej['segmenty'], z[:segmenty])
          odp = UI.messagebox(format("Zaznaczono wygenerowany dom i %d linii.\n\nTak – nowy dom z zaznaczonych linii.\n" \
                                     'Nie – edycja zaznaczonego domu.', z[:segmenty].length), MB_YESNOCANCEL)
          return nil if odp == IDCANCEL
          odp == IDYES ? { segmenty: z[:segmenty], z0: z[:z0] } : { dom: z[:dom] }
        end

        # Czy dwa zestawy linii są takie same (końce z dokładnością 1 mm, dowolna kolejność i zwrot).
        def te_same_linie?(a, b)
          klucz = lambda do |lista|
            (lista || []).map { |s| s.map { |q| [q[0].to_f.round, q[1].to_f.round] }.sort }.sort
          end
          klucz.call(a) == klucz.call(b)
        end

        # Podgląd z okna: obliczenia bez zmian w modelu (na komputerze nic się nie zapisuje – standard i typy mają
        # własne przyciski zapisu).
        def podglad(dane)
          wej = scal(dane)
          @plan = Log.time('podgląd') { Projekt.oblicz(wej) }
          dla_okna(@plan)
        end

        # Widok ściany z ostatniego planu (podgląd lub generowanie) dla okna; { 'blad' => tekst }, gdy nie ma ściany.
        def widok(id)
          w = Widok.sciana(@plan, id)
          w || { 'blad' => "Brak ściany #{id} w ostatnim podglądzie.", 'id' => id.to_s }
        end

        # Generowanie z okna: obliczenia i budowa (zastępuje edytowany dom), potem dach z aplikacji do dachów (połacie
        # i KROK 2 – 'dach' w wyniku: tekst do okna); parametry, typ i zmiany tylko w tym domu zostają w modelu (atrybuty domu).
        def generuj(dane)
          model = Sketchup.active_model
          wej = scal(dane)
          plan = Log.time('obliczenia') { Projekt.oblicz(wej) }
          ms_obliczen = ostatni_czas
          @plan = plan
          wynik = dla_okna(plan)
          okienko_awarii(plan, wej)
          return wynik unless plan[:bledy].empty?
          stary = @dom && @dom.valid? ? @dom : nil
          if stary && Atrybuty.zmieniony_recznie?(stary)
            odp = UI.messagebox("Dom zmieniono ręcznie po wygenerowaniu (przesunięte, usunięte lub dodane elementy).\n" \
                                'Nowa wersja zastąpi te zmiany. Kontynuować?', MB_YESNO)
            return wynik.merge('anulowano' => true) if odp != IDYES
          end
          stary_id = stary ? Atrybuty.dom_id(stary) : nil
          zb = Log.time('budowa modelu') { Budowa.zbuduj(model, plan, wej, stary) }
          ms_budowy = ostatni_czas
          @dom = zb[:grupa]
          @wejscie = wej
          model.selection.clear
          model.selection.add(@dom)
          Log.info(format('Dom wygenerowany: %d ścian, %d bali, %d pozycji.', plan[:sciany].length, plan[:bale].length,
                          plan[:pozycje].length))
          dach = DachAplikacja.po_budowie(model, @dom, plan, stary_id)
          DziennikPracy.generowanie(plan, wej, stary ? 'edycja' : 'nowy', ms_obliczen, ms_budowy, zb, dach, PLUGIN_BUILD)
          st = zb[:stolarka] || { wstawione: 0, uwagi: [] }
          wynik.merge('zbudowano' => true, 'definicje' => zb[:definicje], 'bledne_sciany' => zb[:bledne_sciany], 'dach' => dach,
                      'stolarka' => { 'wstawione' => st[:wstawione], 'uwagi' => st[:uwagi] })
        end

        # Menu „Kontrola”: kolizje w zamkach, mijanka, długości dla zaznaczonego domu.
        def kontrola
          model = Sketchup.active_model
          dom = model ? model.selection.to_a.find { |e| Atrybuty.dom?(e) } : nil
          return UI.messagebox('Zaznacz dom wygenerowany generatorem wieńcowym.') if dom.nil?
          wej = Atrybuty.czytaj_wejscie(dom)
          return UI.messagebox('Zaznaczony dom nie ma zapisanych parametrów – wygeneruj go ponownie z linii.') if wej.nil?
          plan = Projekt.oblicz(wej)
          return UI.messagebox(plan[:bledy].join("\n\n")) unless plan[:bledy].empty?
          k = Log.time('kontrola') { Kontrola.wszystko(plan) }
          tekst = []
          tekst << (k[:kolizje].empty? ? 'Zamki: bez kolizji.' : "Zamki: #{k[:kolizje].length} miejsc kolizji (szczegóły w Konsoli Ruby).")
          tekst << (k[:mijanka].empty? ? 'Mijanka styków: w porządku (min. 300 mm).' : "Mijanka: #{k[:mijanka].length} naruszeń.")
          tekst << (k[:za_dlugie].empty? ? 'Długości bali: w porządku.' : "Za długie bale: #{k[:za_dlugie].length}.")
          tekst << (k[:styki_bez_zamka].empty? ? 'Styki w zamkach: w porządku.' : "Styki bez zamka: #{k[:styki_bez_zamka].length}.")
          tekst << (k[:nakladanie].empty? ? 'Ściany równoległe: bez nakładania.' : "Ściany równoległe: bale w tym samym miejscu – #{k[:nakladanie].map { |n| n[:sciany].join(' i ') }.uniq.join(', ')}.")
          k[:kolizje].first(20).each { |c| Log.warn("Kolizja #{c[:sciany].join('/')} przy #{c[:punkt].inspect}, z #{c[:z].inspect}") }
          k[:mijanka].each { |m| Log.warn("Mijanka #{m[:sciana]} wieniec #{m[:wieniec]}: #{m[:odstep]} mm") }
          UI.messagebox(tekst.join("\n"))
        rescue => e
          Log.error('Sterowanie.kontrola', e)
          UI.messagebox("Wystąpił błąd:\n#{e.class}: #{e.message}")
        end

        # Okienko z komunikatem, gdy obliczenia przerwał nieprzewidziany błąd (plan[:wyjatek] – rdzen/awaria.rb): przy
        # starcie i przy „Generuj”; podgląd po zmianie pola pokazuje ten sam komunikat tylko na liście błędów w oknie.
        def okienko_awarii(plan, wejscie = nil)
          return unless plan && plan[:wyjatek]
          DziennikPracy.awaria(plan, wejscie, PLUGIN_BUILD)
          UI.messagebox(plan[:bledy].first.to_s)
        end

        # Czas ostatniego zmierzonego etapu (Log.time) w milisekundach.
        def ostatni_czas
          c = Log.czasy.last
          c ? c['ms'] : nil
        end

        # Wejście domu: zapamiętane linie i poziom (dom z wymiarów – prostokąt z pól długości i szerokości) + parametry,
        # otwory, ustawienia ścian (widok ściany) i typ domu z okna.
        def scal(dane)
          baza = @wejscie || {}
          par = dane['parametry'] || {}
          dz = dane['dzialowe'].is_a?(Array) ? dane['dzialowe'] : (baza['dzialowe'] || [])
          wej = { 'segmenty' => baza['z_wymiarow'] ? DomZWymiarow.segmenty(par, dz) : (baza['segmenty'] || []), 'z0' => baza['z0'].to_f,
                  'parametry' => par, 'otwory' => dane['otwory'] || [], 'wegly' => dane['wegly'] || [],
                  'sciany' => dane['sciany'].is_a?(Hash) ? dane['sciany'] : (baza['sciany'] || {}),
                  'typ' => (dane['typ'] || baza['typ']).to_s }
          if baza['z_wymiarow']
            wej['z_wymiarow'] = true
            wej['dzialowe'] = dz
          end
          wej
        end

        # Wynik dla okna (tylko typy JSON): błędy, ostrzeżenia, podpowiedzi, ściany, lista bali i belek, rzut.
        def dla_okna(plan)
          wynik = { 'bledy' => plan[:bledy], 'ostrzezenia' => plan[:ostrzezenia], 'rzut' => rzut(plan),
                    'wegly_lista' => plan[:sciany].empty? ? [] : WeglyTabela.lista(plan[:sciany], plan[:parametry]),
                    'podpowiedzi' => (plan[:podpowiedzi] || []).map { |h| klucze_tekstowe(h) }, 'widoki' => Widok.lista(plan),
                    'uwagi' => UwagiPola.lista(plan), 'obrys_rodzaj' => plan[:powierzchnie] ? plan[:powierzchnie][:rodzaj_obrysu] : '',
                    'powierzchnie' => Powierzchnie.wiersze(plan[:powierzchnie]) }
          s = plan[:podsumowanie]
          return wynik if s.nil?
          wynik.merge(
            'sciany' => s[:sciany].map { |w| klucze_tekstowe(w) },
            'lista' => s[:lista].map { |l| klucze_tekstowe(l) },
            'materialy' => (plan[:materialy] || []).map { |m| klucze_tekstowe(m) },
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
