# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/styki_tarasu.rb
# Zadanie: łączenie bali frontu tarasu z podciągiem (podciąg, bale spinające, szczyt nad tarasem, balustrada z wieńców) na styk – bez węgła i zamków, na przemian z mijanką; najniższy bal podciągu łączony nad słupem.
# Tematy: styk na styk, łączenie bali szczytu nad tarasem, styk frontu tarasu, styk nad słupem, szczyt bez kontrfory, front tarasu bez węgłów
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wieńce frontu), rdzen/taras.rb (front, słupy frontu)
# Używają: rdzen/styki.rb (front tarasu zamiast węgłów pod styki), rdzen/kontrola.rb (styk na styk nie jest „stykiem bez zamka”)
#
# Wymóg użytkownika (runda 11): w trójkącie nad tarasem kontrfora (słupek z półzamkami) pod łączenie bali jest zbędna –
# „wystarczy na styk łączyć z przesunięciem o 300 mm na przemian”. Front tarasu z podciągiem (taras_styk = styk) nie
# dostaje więc węgłów pod styki: w każdym miejscu łączenia wieńce jednej parzystości stykają się w osi słupa frontu
# (najniższy bal podciągu leży końcami na słupie), wieńce drugiej – o mijankę (≥ 300) dalej, na ciągłym balu niżej.
# Miejsca łączenia: jak najmniej, przy równym podziale długości frontu, w najbliższym słupie pośrednim; gdy żaden słup
# nie pasuje (kawałki dłuższe niż maksymalny bal) – w punktach równego podziału.
# Wynik jak w rdzen/styki.rb: { parzyste: [s], nieparzyste: [s], kotwy: [], nowe: [], na_styk: true }.
# taras_styk = wegly – front łączony jak zwykła ściana (węgły pod styki, rdzen/styki.rb).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)
require File.join(File.dirname(__FILE__), 'taras') unless defined?(ArteMadera::GeneratorWiencowy::Taras)

module ArteMadera
  module GeneratorWiencowy
    module StykiTarasu
      # Najwięcej dodatkowych miejsc łączenia ponad najmniejszą potrzebną liczbę.
      ZAPAS = 3 unless const_defined?(:ZAPAS)

      module_function

      # Czy bale ściany łączy się na styk bez węgła: front tarasu z podciągiem przy taras_styk = styk.
      def dotyczy?(w, p)
        tr = w[:taras]
        !tr.nil? && tr[:rola] == :front && tr[:wariant] == 'podciag' && p['taras_styk'].to_s != 'wegly'
      end

      # Czy ściana ma styki na styk (plan z tego pliku) – kontrola nie szuka w nich zamka.
      def na_styk?(w)
        st = w[:styki]
        !st.nil? && st[:na_styk] == true
      end

      # Plan styków frontu (zasięg bali w – z wypustami górnych wieńców): najmniej miejsc łączenia, najpierw nad słupami,
      # potem w punktach równego podziału; nil – nie da się (kawałki dłuższe niż maksymalny bal).
      def planuj(w, p)
        lmax = p['max_dlugosc'].to_f
        dl = w[:s_do] - w[:s_od]
        k0 = [(dl / lmax - 1e-9).ceil - 1, 1].max
        slupy = (Taras.slupy_frontu(w, p)[:slupy][1..-2] || [])
        (k0..(k0 + ZAPAS)).each do |k|
          [slupy, []].each do |podpory|
            plan = proba(w, p, k, podpory)
            return plan if plan
          end
        end
        nil
      end

      # Jedna próba: k miejsc łączenia przy punktach równego podziału, każde w najbliższej podporze z listy (pusta – w samym
      # punkcie podziału); wieńce parzystości najniższego bala podciągu łączone w podporze, pozostałe o mijankę w stronę
      # punktu podziału. nil – kawałki za długie, za krótkie albo styk w zamku skrzyżowania.
      def proba(w, p, k, podpory)
        d = [p['mijanka'].to_f, Parametry::MIJANKA_MIN].max
        dl = w[:s_do] - w[:s_od]
        bazy = []
        drugie = []
        (1..k).each do |j|
          cel = w[:s_od] + j * dl / (k + 1)
          baza = podpory.reject { |s| bazy.include?(s) }.min_by { |s| (s - cel).abs } || cel
          bazy << baza
          drugie << (baza <= cel ? baza + d : baza - d)
        end
        return nil unless dobre?(w, p, bazy.sort, drugie.sort)
        parzyste, nieparzyste = parzystosc_podciagu(w, p).even? ? [bazy, drugie] : [drugie, bazy]
        { parzyste: parzyste.sort, nieparzyste: nieparzyste.sort, kotwy: [], nowe: [], na_styk: true }
      end

      # Czy listy styków obu parzystości dają kawałki nie dłuższe niż maksymalny bal i nie krótsze niż najkrótszy
      # kawałek, styki sąsiednich wieńców mijają się o co najmniej 300, a żaden nie wypada w zamku skrzyżowania
      # (narożniki, węgły z tabeli).
      def dobre?(w, p, bazy, drugie)
        lmax = p['max_dlugosc'].to_f
        lmin = p['min_odcinek'].to_f
        t = Parametry.grubosc(p)
        return false unless bazy.all? { |a| drugie.all? { |b| (a - b).abs >= Parametry::MIJANKA_MIN - 0.01 } }
        [bazy, drugie].all? do |lista|
          punkty = [w[:s_od]] + lista + [w[:s_do]]
          punkty.each_cons(2).all? { |a, b| b - a <= lmax + 0.01 && b - a >= lmin - 0.01 } &&
            lista.all? { |s| w[:skrzyzowania].none? { |x| (x[:s] - s).abs < 1.5 * t } }
        end
      end

      # Indeks wieńca (od dołu ściany) najniższego bala podciągu frontu – jego styki wypadają nad słupami.
      def parzystosc_podciagu(w, p)
        z = w[:taras][:z_front]
        Wience.dla_sciany(w, p).index { |wn| wn[:z0] >= z - 0.01 } || 0
      end
    end
  end
end
