# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry.rb
# Zadanie: wartości domyślne, presety przekroju bala z wymiarami zamka, opisy pól okna i sprawdzenie parametrów.
# Tematy: parametry, presety, przekrój bala, wymiary zamka, wartości domyślne, mijanka 300, długość bala, ostatek, kalenica
# Zależy od: log.rb
# Używają: rdzen/projekt.rb (normalizacja), wszystkie pliki rdzen/ (odczyt), sketchup/okno.rb (opisy pól)
#
# Nowy parametr: dopisz go w DOMYSLNE i OPISY (okno buduje formularz z OPISY), a odczytuj tylko przez p['klucz'].
# Nowy przekrój bala: dopisz preset w PRESETY (pełny komplet wymiarów zamka).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(File.dirname(__FILE__)), 'log') unless defined?(ArteMadera::GeneratorWiencowy::Log)

module ArteMadera
  module GeneratorWiencowy
    module Parametry
      # Wymóg użytkownika: styki w sąsiednich wieńcach przesunięte co najmniej o tyle [mm].
      MIJANKA_MIN = 300.0 unless const_defined?(:MIJANKA_MIN)

      # Presety przekroju: wymiary bala i zamka [mm]. Klucze zamka czyta rdzen/zamek.rb.
      PRESETY = {
        '44x146' => {
          'nazwa' => 'Bal 44 × 146 (krycie 139, pióro 7)',
          'grubosc' => 44.0,        # grubość ściany
          'wysokosc' => 146.0,      # wysokość bala z piórem (do list zamówień)
          'krycie' => 139.0,        # rozstaw wieńców = wysokość bryły bala prostego
          'pioro' => 7.0,           # wysokość pióra (pełny profil – późniejsza runda)
          'gniazdo_szer' => 40.0,   # szerokość gniazda górnego i dolnego w zamku
          'gniazdo_gleb' => 36.0,   # głębokość gniazda od wierzchu i od spodu bryły
          'podciecie_gleb' => 2.5,  # głębokość podcięcia bocznego (każde lico)
          'polbal_lista' => 70.0    # wysokość półbala w listach producenta
        }
      }.freeze unless const_defined?(:PRESETY)

      DOMYSLNE = {
        'preset' => '44x146',
        'liczba_wiencow' => 16,            # pełne wieńce ścian okapowych (szczytowe mają o jeden więcej)
        'ostatek' => 100.0,                # wypust bala za licem ściany poprzecznej
        'kalenica' => 'dluzszy',           # kierunek kalenicy: dluzszy | krotszy | x | y
        'max_dlugosc' => 5000.0,           # najdłuższy bal
        'min_odcinek' => 200.0,            # najkrótszy kawałek bala (ostrzeżenie)
        'styk_uklad' => 'dwa_skrzyzowania', # dwa_skrzyzowania (styk w osi zamka, jak 900 W-2) | jeden_kontrfor
        'mijanka' => 400.0,                # odstęp styków w sąsiednich wieńcach (≥ MIJANKA_MIN)
        'szczelina_styku' => 0.0,          # szczelina między czołami bali na styku
        'kontrfor_max_linia' => 600.0,     # krótsza linia przecinająca ścianę = kontrfor
        'min_odstep_skrzyzowan' => 300.0,  # najmniejszy odstęp osi skrzyżowań (nowe kontrfory)
        'odstep_od_otworu' => 150.0,       # najmniejszy odstęp osi nowego kontrforu od krawędzi otworu
        'min_kawalek_przy_otworze' => 70.0, # najkrótszy kawałek bala między licem ściany poprzecznej a otworem
        'luz_nad_otworem' => 0.0,          # luz osiadania nad otworem
        'tolerancja_rysunku' => 5.0,       # tolerancja dopasowania linii obrysu [mm]
        'gestosc' => 450.0                 # gęstość drewna do wagi [kg/m³] (świerk)
      }.freeze unless const_defined?(:DOMYSLNE)

      # Opisy pól okna: klucz => [etykieta, jednostka, min, max, rodzaj]; rodzaj: :liczba | :calkowita | :wybor.
      OPISY = [
        ['preset', 'Przekrój bala', '', nil, nil, :wybor],
        ['liczba_wiencow', 'Liczba wieńców (ściany okapowe)', 'szt.', 3, 60, :calkowita],
        ['ostatek', 'Ostatek za licem', 'mm', 40.0, 600.0, :liczba],
        ['kalenica', 'Kalenica (półbal na ścianach wzdłuż kalenicy)', '', nil, nil, :wybor],
        ['max_dlugosc', 'Maksymalna długość bala', 'mm', 1000.0, 13000.0, :liczba],
        ['min_odcinek', 'Najkrótszy kawałek bala', 'mm', 50.0, 2000.0, :liczba],
        ['styk_uklad', 'Układ styków na długości', '', nil, nil, :wybor],
        ['mijanka', 'Mijanka styków w sąsiednich wieńcach', 'mm', 300.0, 3000.0, :liczba],
        ['szczelina_styku', 'Szczelina na styku', 'mm', 0.0, 30.0, :liczba],
        ['kontrfor_max_linia', 'Linia kontrforu – najdłuższa', 'mm', 100.0, 3000.0, :liczba],
        ['min_odstep_skrzyzowan', 'Najmniejszy odstęp skrzyżowań', 'mm', 150.0, 3000.0, :liczba],
        ['odstep_od_otworu', 'Odstęp nowego kontrforu od otworu', 'mm', 0.0, 2000.0, :liczba],
        ['min_kawalek_przy_otworze', 'Kawałek bala przy otworze – najkrótszy', 'mm', 0.0, 1000.0, :liczba],
        ['luz_nad_otworem', 'Luz osiadania nad otworem', 'mm', 0.0, 200.0, :liczba],
        ['tolerancja_rysunku', 'Tolerancja rysunku obrysu', 'mm', 0.5, 50.0, :liczba],
        ['gestosc', 'Gęstość drewna (waga)', 'kg/m³', 300.0, 900.0, :liczba]
      ].freeze unless const_defined?(:OPISY)

      # Opisy wymiarów zamka w oknie: klucz presetu => [etykieta, jednostka].
      OPISY_ZAMKA = [
        ['grubosc', 'Grubość bala', 'mm'], ['krycie', 'Krycie (rozstaw wieńców)', 'mm'],
        ['wysokosc', 'Wysokość z piórem (listy)', 'mm'], ['pioro', 'Pióro', 'mm'],
        ['gniazdo_szer', 'Gniazdo – szerokość', 'mm'], ['gniazdo_gleb', 'Gniazdo – głębokość', 'mm'],
        ['podciecie_gleb', 'Podcięcie boczne – głębokość', 'mm'], ['polbal_lista', 'Półbal – wysokość w listach', 'mm']
      ].freeze unless const_defined?(:OPISY_ZAMKA)

      # Wartości pól wyboru: klucz => [[wartość, opis], ...].
      WYBORY = {
        'kalenica' => [['dluzszy', 'wzdłuż dłuższego boku'], ['krotszy', 'wzdłuż krótszego boku'],
                       ['x', 'wzdłuż osi X obrysu'], ['y', 'wzdłuż osi Y obrysu']],
        'styk_uklad' => [['dwa_skrzyzowania', 'styk w osi zamka, dwa skrzyżowania na przemian (jak 900 W-2)'],
                         ['jeden_kontrfor', 'styki obok jednego kontrforu, ± połowa mijanki']]
      }.freeze unless const_defined?(:WYBORY)

      module_function

      # Pełny zestaw parametrów z wartości użytkownika: [parametry, ostrzeżenia]. Zamek – z presetu lub własny.
      def normalizuj(wejscie)
        wej = wejscie.is_a?(Hash) ? wejscie : {}
        p = {}
        uwagi = []
        DOMYSLNE.each { |k, v| p[k] = wej.key?(k) ? wej[k] : v }
        p['preset'] = DOMYSLNE['preset'] unless PRESETY.key?(p['preset'].to_s)
        OPISY.each do |kl, etykieta, _jedn, min, max, rodzaj|
          next if rodzaj == :wybor
          v = liczba(p[kl])
          if v.nil?
            uwagi << "#{etykieta}: niepoprawna wartość „#{p[kl]}” – przyjęto #{DOMYSLNE[kl]}"
            v = DOMYSLNE[kl].to_f
          end
          if min && v < min
            uwagi << "#{etykieta}: #{fmt(v)} poniżej najmniejszej wartości #{fmt(min)} – przyjęto #{fmt(min)}"
            v = min.to_f
          end
          if max && v > max
            uwagi << "#{etykieta}: #{fmt(v)} powyżej największej wartości #{fmt(max)} – przyjęto #{fmt(max)}"
            v = max.to_f
          end
          p[kl] = rodzaj == :calkowita ? v.round : v.to_f
        end
        WYBORY.each do |kl, lista|
          next if lista.any? { |w| w[0] == p[kl].to_s }
          uwagi << "#{kl}: nieznana wartość „#{p[kl]}” – przyjęto #{DOMYSLNE[kl]}"
          p[kl] = DOMYSLNE[kl]
        end
        p['kalenica'] = p['kalenica'].to_s
        p['styk_uklad'] = p['styk_uklad'].to_s
        p['zamek'] = zamek_z(wej['zamek'], p['preset'], uwagi)
        [p, uwagi]
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
