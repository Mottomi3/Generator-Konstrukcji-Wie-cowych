# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/symetria_wegly.rb
# Zadanie: węgły symetrycznie na ścianach równoległych – ściana bliźniacza (ta sama oś w świecie, ten sam zasięg) dostaje styki i węgły w tych samych miejscach co ściana policzona wcześniej; równy podział odcinków między ścianami przy rozmieszczeniu „równo”.
# Tematy: symetria węgłów, ściana bliźniacza, ściany równoległe, węgły w tych samych miejscach, styki symetryczne, równy podział odcinka, punkty podziału
# Zależy od: rdzen/parametry.rb, rdzen/styki.rb (kotwice, miejsce styku, kawałki), rdzen/usztywnienie.rb (miejsce na węgieł)
# Używają: rdzen/styki.rb (planuj, na_przemian), rdzen/usztywnienie.rb (planuj)
#
# Wymóg użytkownika (runda 8): węgły na długich ścianach nie na przemian na dwóch ścianach równoległych, tylko
# symetrycznie; przy „równo na długości ściany” odcinek między ścianami i działowymi dzielony równo. Ściana bliźniacza:
# ten sam rodzaj kierunku (A / B), oś równoległa, zasięg bali (s_od … s_do) w tym samym miejscu w świecie. Miejsca
# przenoszone przez współrzędną świata wzdłuż osi; gdy w ścianie bliźniaczej się nie da (otwór, za długi kawałek,
# brak skrzyżowania pod styk wspólny) – ściana liczona zwykle.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module SymetriaWegly
      # Tolerancja zgodności zasięgów i skrzyżowań [mm].
      TOL = 1.0 unless const_defined?(:TOL)
      # Największa liczba części odcinka przy równym podziale.
      PODZIAL_MAX = 8 unless const_defined?(:PODZIAL_MAX)

      module_function

      # Indeks współrzędnej świata wzdłuż osi ściany (0 – x, 1 – y).
      def os(w)
        w[:kier][0].abs > 0.5 ? 0 : 1
      end

      # Współrzędna świata punktu s ściany (wzdłuż jej osi).
      def swiat(w, s)
        w[:a][os(w)] + w[:kier][os(w)] * s
      end

      # Punkt s ściany dla współrzędnej świata x.
      def s_ze_swiata(w, x)
        (x - w[:a][os(w)]) * w[:kier][os(w)]
      end

      # Zasięg bali ściany w świecie [min, max].
      def zasieg(w)
        [swiat(w, w[:s_od]), swiat(w, w[:s_do])].sort
      end

      # Ściana bliźniacza z listy (już policzonych): ten sam kierunek, oś równoległa, ten sam zasięg; nil – brak.
      def blizniak(w, lista)
        z = zasieg(w)
        lista.find do |x|
          next false if x.equal?(w) || x[:kierunek] != w[:kierunek] || os(x) != os(w)
          zx = zasieg(x)
          (zx[0] - z[0]).abs < TOL && (zx[1] - z[1]).abs < TOL
        end
      end

      # Lista miejsc ściany x przeniesiona na ścianę w (posortowana).
      def przenies(w, x, lista)
        lista.map { |s| s_ze_swiata(w, swiat(x, s)) }.sort
      end

      # Styki ściany w w tych samych miejscach co u bliźniaka x (plan x[:styki]); nil – nie da się (nowe węgły w miejscach
      # zakazanych, kawałki dłuższe niż bal, styk wspólny bez skrzyżowania).
      def styki(w, x, p)
        st = x[:styki]
        return nil if st.nil? || st[:kotwy].nil? || st[:kotwy].empty?
        istn = Styki.kotwice(w, p)
        jest = lambda { |s| istn.any? { |k| (k - s).abs < TOL } }
        parz = przenies(w, x, st[:parzyste])
        nieparz = przenies(w, x, st[:nieparzyste])
        kotwy = przenies(w, x, st[:kotwy])
        wspolne = przenies(w, x, st[:wspolne] || [])
        return nil unless wspolne.all? { |s| jest.call(s) }
        return nil unless Styki.kawalki_ok?(w, [parz, nieparz], p['max_dlugosc'].to_f)
        nowe = []
        kotwy.each do |s|
          next if jest.call(s)
          return nil unless Styki.miejsce_styku_ok?(w, p, s, nowe)
          nowe << s
        end
        wynik = { parzyste: parz, nieparzyste: nieparz, kotwy: kotwy, nowe: nowe }
        wynik[:wspolne] = wspolne unless wspolne.empty?
        wynik
      end

      # Węgły usztywniające bliźniaka x w odcinku a…b ściany w (przeniesione); nil – bliźniak nie ma tu węgłów albo
      # któryś nie może stanąć (blok: s → czy miejsce dobre przy już wybranych).
      def usztywnienie(w, x, a, b)
        lista = x[:skrzyzowania].select { |k| k[:inna][:rodzaj] == :kontrfor && k[:inna][:zrodlo] == :usztywnienie }.map { |k| k[:s] }
        moje = przenies(w, x, lista).select { |s| s > a + TOL && s < b - TOL }
        return nil if moje.empty?
        wybrane = []
        moje.each do |s|
          return nil unless yield(s, wybrane)
          wybrane << s
        end
        wybrane
      end

      # Punkty równego podziału odcinków między skrzyżowaniami ściany (na 2 … PODZIAL_MAX części, najpierw najmniej części)
      # – kandydaci na nowe węgły pod styki przy rozmieszczeniu „równo”; tylko miejsca, w których węgieł może stanąć.
      def podzialy(w, p)
        osie = w[:skrzyzowania].map { |k| k[:s] }.sort
        wynik = []
        osie.each_cons(2) do |a, b|
          (2..PODZIAL_MAX).each do |n|
            (1...n).each do |i|
              x = a + (b - a) * i / n
              wynik << x if Styki.miejsce_styku_ok?(w, p, x, []) && wynik.none? { |y| (y - x).abs < 0.01 }
            end
          end
        end
        wynik.sort
      end
    end
  end
end
