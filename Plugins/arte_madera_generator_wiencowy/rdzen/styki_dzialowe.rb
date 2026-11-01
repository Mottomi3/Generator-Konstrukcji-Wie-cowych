# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/styki_dzialowe.rb
# Zadanie: styki w zamku działowej – wszystkie wieńce ściany łączone w osi skrzyżowania z działową (zamek trzyma oba końce), bez drugiego rzędu na mijankę i bez węgłów; reszta ściany – zwykłym układem.
# Tematy: styk na działowej, łączenie w zamku działowej, działowa zamiast węgła, styki wspólne, bez mijanki przy działowej, wysokość ściany poprzecznej przy styku
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wysokości ścian), rdzen/otwory.rb (strefy otworów – przez Styki.poza_otworami?)
# Używają: rdzen/styki.rb (planuj – najpierw działowe), rdzen/kontrola.rb (mijanka – styki wspólne wyłączone)
#
# Działowa (albo ściana zewnętrzna przy działowej) przechodzi przez ścianę w zamku – w każdym wieńcu bal ściany leży
# w gnieździe bala ściany poprzecznej. Styk w osi takiego skrzyżowania trzymają oba bale poprzeczne (nad i pod), więc
# wszystkie wieńce mogą łączyć się w tym samym miejscu (wymóg użytkownika: działowa zastępuje węgły i drugi rząd
# styków). Skrzyżowanie nadaje się, gdy ściana poprzeczna sięga co najmniej o wieniec niżej niż wierzch ściany
# (wyżej zamek trzyma tylko pas pod spodem). Wybór: od początku ściany najdalsze takie skrzyżowanie w zasięgu bala;
# odcinki bez takich skrzyżowań dłuższe niż bal – zwykłym układem (Styki.na_przemian / para), z mijanką ≥ 300 od
# styków wspólnych. Wynik w ścianie: w[:styki][:wspolne] – osie styków wspólnych.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)

module ArteMadera
  module GeneratorWiencowy
    module StykiDzialowe
      module_function

      # Czy styki wspólne w zamku działowej są włączone.
      def wlaczone?(p)
        p['styk_na_dzialowej'] == 'wspolny'
      end

      # Skrzyżowania ściany w, w których mogą łączyć się wszystkie wieńce: ściana poprzeczna działowa albo zewnętrzna
      # (nie węgieł), wnętrze ściany, z dala od otworów, wysoka prawie jak ściana w.
      def kotwice(w, p)
        t = Parametry.grubosc(p)
        h = Parametry.krycie(p)
        gora = Wience.wysokosc_calkowita(w, p)
        w[:skrzyzowania].select do |k|
          inna = k[:inna]
          next false if inna[:rodzaj] == :kontrfor || k[:typ] == :naroznik
          next false unless k[:s] > t && k[:s] < w[:dl_osi] - t && Styki.poza_otworami?(w, p, k[:s])
          Wience.wysokosc_calkowita(inna, p) >= gora - h - 0.5
        end.map { |k| k[:s] }.uniq.sort
      end

      # Plan styków ściany ze stykami wspólnymi: { parzyste:, nieparzyste:, kotwy:, nowe:, wspolne: } albo nil (brak
      # skrzyżowań z działową albo reszta ściany nie da się zaplanować – wtedy zwykły układ dla całej ściany).
      def planuj(w, p)
        return nil unless wlaczone?(p)
        kot = kotwice(w, p)
        return nil if kot.empty?
        lmax = p['max_dlugosc'].to_f
        wspolne = []
        odcinki = []
        cur = w[:s_od]
        while w[:s_do] - cur > lmax + 0.01
          zasieg = kot.select { |c| c > cur + 1.0 && c - cur <= lmax + 0.01 }
          if zasieg.empty?
            nast = kot.find { |c| c > cur + 1.0 }
            odcinki << [cur, nast || w[:s_do]]
            break if nast.nil?
            wspolne << nast
            cur = nast
          else
            wspolne << zasieg.max
            cur = zasieg.max
          end
        end
        return nil if wspolne.empty?
        odcinki << [cur, w[:s_do]] if w[:s_do] - cur > lmax + 0.01 && (odcinki.empty? || odcinki.last[1] < w[:s_do] - 0.01)
        zloz(w, p, wspolne, odcinki)
      end

      # Złożenie wyniku: styki wspólne w obu parzystościach + układ zwykły na odcinkach dłuższych niż bal (odcinek jako
      # ściana od styku do styku); nil, gdy odcinka nie da się zaplanować albo jego styki są bliżej niż mijanka od wspólnych.
      def zloz(w, p, wspolne, odcinki)
        parz = wspolne.dup
        nieparz = wspolne.dup
        nowe = []
        kotwy = wspolne.dup
        odcinki.each do |a, b|
          r = Styki.na_przemian(w.merge(s_od: a, s_do: b), p)
          return nil if r.nil?
          return nil if (r[:parzyste] + r[:nieparzyste]).any? { |s| wspolne.any? { |c| (s - c).abs < Parametry::MIJANKA_MIN - 0.01 } }
          parz.concat(r[:parzyste])
          nieparz.concat(r[:nieparzyste])
          nowe.concat(r[:nowe])
          kotwy.concat(r[:kotwy])
        end
        { parzyste: parz.sort, nieparzyste: nieparz.sort, kotwy: kotwy.sort, nowe: nowe, wspolne: wspolne }
      end

      # Czy styk w s (oś styku) jest stykiem wspólnym ściany (do kontroli mijanki).
      def wspolny?(w, s)
        st = w[:styki]
        !st.nil? && (st[:wspolne] || []).any? { |c| (c - s).abs < 1.0 }
      end
    end
  end
end
