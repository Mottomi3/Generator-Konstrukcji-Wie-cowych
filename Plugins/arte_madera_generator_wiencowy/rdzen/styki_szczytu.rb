# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/styki_szczytu.rb
# Zadanie: łączenie wieńców szczytu ściany domu na styk – bez węgła i bez zamka, na przemian z przesunięciem o mijankę (nie mniej niż 300); miejsca styków w każdym wieńcu szczytu osobno.
# Tematy: szczyt na styk, styk na styk w szczycie, łączenie wieńców szczytu, wieniec szczytu, siatka styków szczytu, węgieł pod styk do wysokości ściany, szczyt bez węgłów pod styki
# Zależy od: rdzen/parametry.rb, rdzen/szczyty.rb (góra ściany bez szczytu, linia szczytu), rdzen/taras.rb (front tarasu ma własne zasady – rdzen/styki_tarasu.rb)
# Używają: rdzen/styki.rb (ściana pod szczytem łączona jak zwykła, węgły pod styki do wysokości ściany), rdzen/bale.rb (styki w kawałku wieńca szczytu), rdzen/kontrola.rb (styk na styk nie jest „stykiem bez zamka”)
#
# Decyzja użytkownika T8 (2026-11-25): „można na styk z przesunięciem o 300 mm” – wieńce w szczytach ścian domu jak front
# tarasu (runda 11). Parametr szczyt_styk = styk (domyślnie) | wegly (jak do kompilacji 14: styki całej ściany ze szczytem
# w zamkach węgłów, węgły pod styki do dachu).
# Wieniec szczytu = wieniec ściany o spodzie na górze ściany bez szczytu albo wyżej. Niżej ściana łączy się jak każda inna
# (rdzen/styki.rb – w zamkach węgłów i działowych), a węgły dostawione pod jej styki kończą się na wysokości ściany.
# Miejsca styków leżą na dwóch siatkach o kroku 2 × mijanka, przesuniętych względem siebie o mijankę – wieńce parzyste
# biorą jedną, nieparzyste drugą, więc styki sąsiednich wieńców zawsze mijają się co najmniej o mijankę. Siatki ustawione
# symetrycznie względem kalenicy (kalenica ± pół mijanki). W każdym kawałku wieńca dłuższym niż maksymalny bal: jak
# najmniej styków, przy punktach równego podziału. Styk nie wypada w zamku skrzyżowania, przy otworze (styk_odstep_od_otworu),
# w gnieździe płatwi ani bliżej niż mijanka od styku najwyższego wieńca ściany pod szczytem.
# Szczyt płaski (ściana wysoka dachu jednospadowego, działowa do dachu, ściana przybudówki) to pełne wieńce na całej
# długości – zostaje przy węgłach; front tarasu – rdzen/styki_tarasu.rb (taras_styk).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'taras') unless defined?(ArteMadera::GeneratorWiencowy::Taras)
require File.join(File.dirname(__FILE__), 'szczyty') unless defined?(ArteMadera::GeneratorWiencowy::Szczyty)

module ArteMadera
  module GeneratorWiencowy
    module StykiSzczytu
      # Najwięcej dodatkowych styków w kawałku ponad najmniejszą potrzebną liczbę.
      ZAPAS = 3 unless const_defined?(:ZAPAS)

      module_function

      # Czy wieńce szczytu ściany łączy się na styk: ściana domu ze szczytem skośnym przy szczyt_styk = styk (nie węgieł,
      # nie szczyt płaski, nie front tarasu).
      def dotyczy?(w, p)
        g = w[:szczyt]
        return false if g.nil? || g[:plaski] || w[:rodzaj] == :kontrfor
        return false if p['szczyt_styk'].to_s == 'wegly'
        !Taras.front?(w)
      end

      # Czy wieniec wn ściany w jest wieńcem szczytu łączonym na styk (spód na górze ściany bez szczytu albo wyżej).
      def wieniec?(w, wn, p)
        dotyczy?(w, p) && !wn[:nadstawka] && wn[:z0] >= Szczyty.gora_wlasna(w, p) - 0.01
      end

      # Odstęp styków sąsiednich wieńców [mm]: mijanka, nie mniej niż 300.
      def odstep(p)
        [p['mijanka'].to_f, Parametry::MIJANKA_MIN].max
      end

      # Oś siatek styków na osi ściany [mm]: najwyższy punkt linii szczytu (kalenica); linia prosta – środek ściany.
      def os(w, p)
        zalomy = Szczyty.zalom(w, p)
        return (w[:s_od] + w[:s_do]) / 2.0 if zalomy.empty?
        zalomy.max_by { |s| Szczyty.linia(w, s, p) }
      end

      # Miejsca styków w kawałku a…b wieńca szczytu wn (indeks i od dołu ściany): [] – kawałek mieści się w maksymalnym
      # balu albo nie ma gdzie go połączyć (wtedy ostrzeżenie o za długim balu daje rdzen/bale.rb).
      def pozycje(w, wn, i, a, b, p)
        lmax = p['max_dlugosc'].to_f
        dl = b - a
        return [] if dl <= lmax + 0.01
        lmin = p['min_odcinek'].to_f
        strefy = strefy_zakazane(w, wn, i, p)
        k0 = [(dl / lmax - 1e-9).ceil - 1, 1].max
        (k0..(k0 + ZAPAS)).each do |k|
          wynik = proba(w, i, a, b, k, strefy, lmin, lmax, p)
          return wynik if wynik
        end
        []
      end

      # Jedna próba: k styków, każdy w wolnym miejscu siatki najbliżej punktu równego podziału, kawałki od najkrótszego do
      # maksymalnego bala; nil – nie da się.
      def proba(w, i, a, b, k, strefy, lmin, lmax, p)
        wynik = []
        (1..k).each do |j|
          cel = a + j * (b - a) / (k + 1)
          pop = wynik.last || a
          x = najblizszy(w, i, cel, pop + lmin, [b - lmin, pop + lmax].min, strefy, p)
          return nil if x.nil?
          wynik << x
        end
        b - wynik.last <= lmax + 0.01 ? wynik : nil
      end

      # Wolne miejsce siatki wieńca i najbliższe celu w zakresie lo…hi; nil – brak.
      def najblizszy(w, i, cel, lo, hi, strefy, p)
        siatka(w, i, lo, hi, p).reject { |x| strefy.any? { |s0, s1| x > s0 && x < s1 } }.min_by { |x| (x - cel).abs }
      end

      # Miejsca siatki wieńca i w zakresie lo…hi: oś − pół mijanki (wieńce parzyste) albo oś + pół mijanki (nieparzyste),
      # dalej co 2 × mijanka.
      def siatka(w, i, lo, hi, p)
        d = odstep(p)
        x0 = os(w, p) + (i.even? ? -d / 2.0 : d / 2.0)
        m = ((lo - x0) / (2.0 * d) - 1e-9).ceil
        wynik = []
        while x0 + m * 2.0 * d <= hi + 0.01
          wynik << x0 + m * 2.0 * d
          m += 1
        end
        wynik
      end

      # Przedziały osi ściany, w których styk wieńca szczytu wn (indeks i) nie może wypaść: zamki skrzyżowań (1,5 grubości
      # od osi), otwory sięgające szczytu z zapasem jak dla styków, gniazda płatwi przy tym wieńcu, a nad najwyższym
      # wieńcem ściany pod szczytem – mijanka od jego styków.
      def strefy_zakazane(w, wn, i, p)
        t = Parametry.grubosc(p)
        h = wn[:h]
        gora = Szczyty.gora_wlasna(w, p)
        zapas = [p['styk_odstep_od_otworu'].to_f, p['odstep_od_otworu'].to_f + t / 2.0].max
        wynik = w[:skrzyzowania].map { |k| [k[:s] - 1.5 * t, k[:s] + 1.5 * t] }
        (w[:otwory] || []).each do |o|
          if o[:gniazdo]
            next unless o[:z0] < wn[:z0] + 2.0 * h && o[:z1] > wn[:z0] - h
            wynik << [o[:s0] - p['min_odcinek'].to_f, o[:s1] + p['min_odcinek'].to_f]
          elsif o[:z1] > gora - h
            wynik << [o[:s0] - zapas, o[:s1] + zapas]
          end
        end
        d = odstep(p)
        styki_pod(w, wn, i, gora).each { |s| wynik << [s - d + 0.01, s + d - 0.01] }
        wynik
      end

      # Styki wieńca tuż pod wieńcem szczytu wn, gdy jest to jeszcze wieniec ściany (łączony w zamkach – rdzen/styki.rb).
      def styki_pod(w, wn, i, gora)
        st = w[:styki]
        return [] if st.nil? || i.zero? || wn[:z0] - wn[:h] >= gora - 0.01
        (i - 1).even? ? st[:parzyste] : st[:nieparzyste]
      end
    end
  end
end
