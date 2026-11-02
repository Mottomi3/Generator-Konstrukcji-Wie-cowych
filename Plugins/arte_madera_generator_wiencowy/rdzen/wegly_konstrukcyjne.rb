# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/wegly_konstrukcyjne.rb
# Zadanie: węgły dostawiane automatycznie tam, gdzie wymaga ich konstrukcja – pod płatwiami przechodzącymi przez szczyt (słupek węgła do spodu płatwi, płatew na nim leży) i na wolnym końcu niepełnej ściany (bez węgła koniec jest wiotki).
# Tematy: węgieł pod płatwią, płatew na węgle, węgieł na wolnym końcu, niepełna ściana, wolny koniec działowej, węgły konstrukcyjne
# Zależy od: rdzen/parametry.rb, rdzen/sciany.rb (dodaj_kontrfor), rdzen/usztywnienie.rb (miejsce_ok?), rdzen/szczyty.rb (s ↔ v), rdzen/dach.rb (płatwie), rdzen/taras.rb (front i ściana domu przy tarasie), rdzen/podbitka.rb (deski pod płatwiami)
# Używają: rdzen/projekt.rb (po węgłach z tabeli, przed stykami i węgłami usztywniającymi), rdzen/bale.rb (górny bal węgła pod płatwią – kf[:pod_platwia])
#
# Pod płatwią (wegly_pod_platwiami = zewnetrzne | wszystkie, runda 9 – wymóg użytkownika): na ścianie ze szczytem (dom
# prostokątny) w osi każdej płatwi węgieł wzdłuż płatwi; wieńce węgła dochodzą do spodu płatwi (gniazdo płatwi w węgle
# z rdzen/szczyty.rb ścina górny bal; podbitka pod płatwiami – pod deskami: kf[:pod_platwia][:z_wegla]), węgieł nie
# powstaje przy narożniku i skrzyżowaniu (np. działowa pod kalenicą), przy otworze albo gdy ściana ma węgły ręczne. Zewnętrzne – szczyty zewnętrzne i ściana domu przy tarasie; wszystkie –
# także szczyty na działowych. Front tarasu – bez (ma trójkątny wieniec / wiązar).
# Wolny koniec (wegly_wolny_koniec): działowa, której koniec nie dochodzi do innej ściany, a wolny odcinek od ostatniego
# skrzyżowania jest dłuższy niż wegly_wolny_koniec_min – węgieł przy końcu, oś ostatek + pół grubości od końca (bale
# ściany kończą się ostatkiem za węgłem jak w narożniku).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'sciany') unless defined?(ArteMadera::GeneratorWiencowy::Sciany)
require File.join(File.dirname(__FILE__), 'usztywnienie') unless defined?(ArteMadera::GeneratorWiencowy::Usztywnienie)
require File.join(File.dirname(__FILE__), 'szczyty') unless defined?(ArteMadera::GeneratorWiencowy::Szczyty)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'taras') unless defined?(ArteMadera::GeneratorWiencowy::Taras)
require File.join(File.dirname(__FILE__), 'podbitka') unless defined?(ArteMadera::GeneratorWiencowy::Podbitka)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)
require File.join(File.dirname(__FILE__), 'otwory') unless defined?(ArteMadera::GeneratorWiencowy::Otwory)

module ArteMadera
  module GeneratorWiencowy
    module WeglyKonstrukcyjne
      module_function

      # Węgły pod płatwiami i na wolnych końcach ścian (dom – opis dachu z Szczyty.przygotuj); zwraca ostrzeżenia.
      def dodaj(sciany, p, os_kalenicy, dom)
        uwagi = []
        pod_platwiami(sciany, p, os_kalenicy, dom, uwagi)
        wolne_konce(sciany, p, os_kalenicy, uwagi)
        uwagi
      end

      # Czy ściana dostaje węgły pod płatwiami (szczyt nie płaski, nie front tarasu, rodzaj wg parametru).
      def sciana_pod_platwiami?(w, p)
        tryb = p['wegly_pod_platwiami'].to_s
        return false if tryb == 'nie' || w[:szczyt].nil? || w[:szczyt][:plaski] || Taras.front?(w)
        return true if w[:rodzaj] == :zewnetrzna || Taras.sciana_domu?(w)
        tryb == 'wszystkie' && w[:rodzaj] == :dzialowa
      end

      # Węgły w osiach płatwi na ścianach ze szczytem (dom prostokątny).
      def pod_platwiami(sciany, p, os_kalenicy, dom, uwagi)
        return if dom.nil? || !Parametry.tak?(p, 'szczyty')
        platwie = Dach.platwie({ v_a: dom[:v_a], v_b: dom[:v_b] }, p)
        t = Parametry.grubosc(p)
        o = p['ostatek'].to_f
        min = p['min_odstep_skrzyzowan'].to_f
        sciany.select { |w| w[:rodzaj] != :kontrfor && sciana_pod_platwiami?(w, p) }.each do |w|
          next if w[:wegly_reczne]
          platwie.each do |pl|
            s = Szczyty.s_z_v(w, pl[:v])
            # Płatew przy narożniku albo przy skrzyżowaniu (działowa, węgieł) – podparta ścianą obok.
            next if s < w[:s_od] + t + o + min || s > w[:s_do] - t - o - min
            next if w[:skrzyzowania].any? { |k| (k[:s] - s).abs < min - 0.01 }
            unless Usztywnienie.miejsce_ok?(w, p, s, [])
              uwagi << format('Ściana %s: pod płatwią (%.0f mm od początku osi) nie ma miejsca na węgieł – otwór albo słup ' \
                              'tarasu zbyt blisko.', w[:id], s)
              next
            end
            kf = Sciany.dodaj_kontrfor(sciany, w, s, p, :platwa, os_kalenicy)
            kf[:pod_platwia] = pl.merge(z_wegla: z_wegla(kf, pl, p, dom))
          end
        end
      end

      # Wierzch węgła pod płatwią [mm]: spód płatwi (podbitka pod płatwiami – spód desek na niższym licu węgła, deski leżą
      # w spadku); gdy wierzch bala węgła wystaje nad niego o mniej niż tolerancję otworów (otwór by go nie ściął), wierzch
      # niżej – bal ścięty o tolerancję.
      def z_wegla(kf, pl, p, dom)
        z = pl[:z_spod]
        if Podbitka.pod_spodem_platwi(p) > 0.0
          geo = { v_a: dom[:v_a], v_b: dom[:v_b] }
          t2 = Parametry.grubosc(p) / 2.0
          z = [z, [pl[:v] - t2, pl[:v] + t2].map { |v| Dach.linia_podparcia(geo, v, p) }.min - Podbitka.obnizenie(p)].min
        end
        Wience.dla_sciany(kf, p).each do |k|
          g = k[:z0] + k[:h]
          return g - Otwory::TOL_Z - 0.01 if g > z + 0.001 && g <= z + Otwory::TOL_Z + 0.01
        end
        z
      end

      # Węgły na wolnych końcach działowych (wolny odcinek dłuższy niż wegly_wolny_koniec_min).
      def wolne_konce(sciany, p, os_kalenicy, uwagi)
        return unless Parametry.tak?(p, 'wegly_wolny_koniec')
        t = Parametry.grubosc(p)
        o = p['ostatek'].to_f
        min = p['wegly_wolny_koniec_min'].to_f
        odstep = p['min_odstep_skrzyzowan'].to_f
        sciany.select { |w| w[:rodzaj] == :dzialowa }.each do |w|
          next if w[:wegly_reczne]
          konce(w).each do |koniec, kier|
            krzyz = w[:skrzyzowania].map { |k| k[:s] }
            dalej = krzyz.map { |s| (s - koniec) * kier }.select { |d| d > 0.5 }.min
            wolny = dalej.nil? ? w[:dl_osi] : dalej
            next if wolny <= min + 0.01
            s = koniec + kier * (t / 2.0 + o)
            if dalej && dalej - (t / 2.0 + o) < odstep - 0.01
              uwagi << format('Ściana %s: wolny koniec %.0f mm – za blisko skrzyżowania na węgieł przy końcu.', w[:id], wolny)
              next
            end
            next if krzyz.any? { |x| (x - s).abs < odstep - 0.01 }
            kf = Sciany.dodaj_kontrfor(sciany, w, s, p, :koniec, os_kalenicy)
            kf[:wolny_koniec] = true
          end
        end
      end

      # Wolne końce działowej: [[s końca, kierunek w głąb ściany]] (koniec bez ostatka – nie dochodzi do innej ściany).
      def konce(w)
        lista = []
        lista << [0.0, 1.0] if w[:s_od] > -0.01
        lista << [w[:dl_osi], -1.0] if w[:s_do] < w[:dl_osi] + 0.01
        lista
      end
    end
  end
end
