# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/platwie_wience.rb
# Zadanie: płatwie oparte na pełnym balu – obniżenie dachu i przesunięcie płatwi pośrednich tak, żeby pod gniazdem płatwi nie zostawał pasek bala cieńszy niż najcieńszy dopuszczalny (bez przerw pod płatwią).
# Tematy: płatew na balu, płatew w powietrzu, przerwa pod płatwią, pasek pod gniazdem, obniżenie dachu, przesunięcie płatwi, dopasowanie płatwi do wieńców, jeden przekrój płatwi, płatew na balu węgła, luka między węgłem a płatwią
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (płatew, linia podparcia – wywołuje ten plik)
# Używają: rdzen/dach.rb (linia podparcia – obniżenie, płatwie pośrednie – położenia), rdzen/dach_jednospadowy.rb
#
# Gniazdo płatwi to otwór od spodu płatwi w górę w ścianach w poprzek płatwi (szczyty, działowe, węgły – wieńce co
# krycie, spód na k · krycie). Bal przy spodzie gniazda zostaje z paskiem r = spód płatwi mod krycie. Pasek cieńszy niż
# min_pasek_przy_otworze był wycinany – płatew wisiała nad przerwą (17 mm w domu 7 × 5). Teraz (platwie_na_wiencach):
# 1. dach obniżony o d (0 … dach_obnizenie_max) tak, żeby płatwie o stałym położeniu (ścienna przy licu, kalenicowa)
#    leżały na pełnym balu (r = 0) albo nad paskiem nie cieńszym niż najcieńszy dopuszczalny – najmniejsze d;
# 2. płatwie pośrednie przesunięte (najwyżej platwie_przesuniecie_max) w stronę okapu albo kalenicy tak samo, bez
#    przekroczenia rozstawu płatwi;
# 3. czego się nie da – pasek zostaje (rdzen/otwory.rb nie wycina paska pod gniazdem), bez przerwy.
# Węgły pod płatwiami (rdzen/wegly_konstrukcyjne.rb, runda 11): wieńce węgła są przesunięte o pół bala względem szczytu,
# a jego górny bal cieńszy niż najcieńszy pasek nie powstaje – płatew wisiała wtedy nad węgłem (do 20 mm, np. kalenicowa
# w domu 3,25 m). Obniżenie dachu i przesunięcie płatwi pośrednich pilnują więc także bala węgła: pełny albo nie cieńszy
# niż najcieńszy pasek (pasek_wegla) – płatew zawsze leży na węgle.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module PlatwieWience
      # Parametry, od których zależy obniżenie dachu (klucz pamięci podręcznej).
      KLUCZE = %w[dach_kat dach_rodzaj dach_spadek dach_podniesienie liczba_wiencow dach_uklad platwa_przekroj
                  platwa_kalenicowa_przekroj platwa_scienna_przekroj platwie_jeden_przekroj platwie_rozstaw_max
                  platwa_na_scianie platwa_scienna_polozenie platwie_sciecie min_pasek_przy_otworze platwie_na_wiencach
                  dach_obnizenie_max platwie_przesuniecie_max zamek preset platwie_zamki platwa_zamek_dol szczyty
                  wegly_pod_platwiami wegly_pod_platwiami_ktore podbitka].freeze unless const_defined?(:KLUCZE)
      # Pamięć obniżeń: klucz (osie ścian okapowych i parametry) → d [mm].
      PAMIEC = {} unless const_defined?(:PAMIEC)
      # Tolerancja „pasek zerowy” [mm].
      TOL = 0.05 unless const_defined?(:TOL)

      module_function

      # Przekrój płatwi danego rodzaju: jeden przekrój dla wszystkich (platwie_jeden_przekroj) albo osobne pola.
      def przekroj(p, rodzaj)
        return Parametry.przekroj(p, 'platwa_przekroj') if Parametry.tak?(p, 'platwie_jeden_przekroj')
        case rodzaj
        when 'scienna' then Parametry.przekroj(p, 'platwa_scienna_przekroj')
        when 'kalenicowa' then Parametry.przekroj(p, 'platwa_kalenicowa_przekroj')
        else Parametry.przekroj(p, 'platwa_przekroj')
        end
      end

      # Pasek bala pod gniazdem płatwi o spodzie z [mm] (0 … krycie); dno gniazda – spód wrębu płatwi (zamek płatwi).
      def pasek(z, p)
        k = Parametry.krycie(p)
        r = (z + (Parametry.tak?(p, 'platwie_zamki') ? p['platwa_zamek_dol'].to_f : 0.0)) % k
        r > k - TOL ? 0.0 : r
      end

      # Czy płatew o spodzie z leży na pełnym balu albo nad dość grubym paskiem.
      def pasek_ok?(z, p)
        r = pasek(z, p)
        r < TOL || r >= p['min_pasek_przy_otworze'].to_f - TOL
      end

      # Czy pod płatwią danego rodzaju staje węgieł, którego górny bal ma ją podpierać (parametry węgłów pod płatwiami;
      # płatew ścienna leży przy ścianie okapowej, podbitka pod płatwiami – węgieł kończy się pod deskami).
      def wegiel_pod?(p, rodzaj)
        return false unless Parametry.tak?(p, 'szczyty') && rodzaj != 'scienna'
        return false if p['wegly_pod_platwiami'].to_s == 'nie' || p['podbitka'].to_s == 'pod_platwiami'
        p['wegly_pod_platwiami_ktore'].to_s != 'kalenicowa' || rodzaj == 'kalenicowa'
      end

      # Pasek górnego bala węgła pod płatwią o spodzie z [mm] (0 … krycie): wieńce węgła zaczynają się półbalem – są
      # przesunięte o pół krycia względem wieńców szczytu.
      def pasek_wegla(z, p)
        k = Parametry.krycie(p)
        r = (z - k / 2.0) % k
        r > k - TOL ? 0.0 : r
      end

      # Czy płatew danego rodzaju o spodzie z leży dobrze: w ścianie (pasek_ok?) i – gdy stoi pod nią węgieł – na pełnym
      # balu węgła albo nad paskiem nie cieńszym niż najcieńszy.
      def oparcie_ok?(z, p, rodzaj)
        return false unless pasek_ok?(z, p)
        return true unless wegiel_pod?(p, rodzaj)
        r = pasek_wegla(z, p)
        r < TOL || r >= p['min_pasek_przy_otworze'].to_f - TOL
      end

      # Obniżenie dachu d [mm] dla przekroju geo (osie ścian okapowych) – w pamięci; podczas liczenia samo zwraca 0.
      def obnizenie(geo, p)
        # Skrzydło boczne domu L – obniżenie dachu głównego (ten sam poziom okapu obu dachów, rdzen/skrzydla.rb).
        return geo[:obnizenie].to_f if geo[:obnizenie]
        return 0.0 unless Parametry.tak?(p, 'platwie_na_wiencach')
        klucz = [geo[:v_a].to_f.round(2), geo[:v_b].to_f.round(2), p.values_at(*KLUCZE)]
        return PAMIEC[klucz] if PAMIEC.key?(klucz)
        PAMIEC.clear if PAMIEC.size > 500
        PAMIEC[klucz] = 0.0
        PAMIEC[klucz] = szukaj_obnizenia(Dach.platwie(geo, p), p)
      end

      # Najmniejsze d (0 … dach_obnizenie_max), przy którym płatwie o stałym położeniu mają oparcie_ok? (ściana i węgieł
      # pod płatwią); płatew stojąca na ścianie wyznacza dach – bez obniżenia. Kandydaci: 0, d dające pasek 0 i pasek
      # równy najcieńszemu – w ścianie i w węgle.
      def szukaj_obnizenia(platwie, p)
        return 0.0 if Parametry.tak?(p, 'platwa_na_scianie') && p['platwa_scienna_polozenie'] == 'na_scianie'
        stale = platwie.reject { |pl| pl[:rodzaj] == 'posrednia' }
        return 0.0 if stale.empty? || stale.all? { |pl| oparcie_ok?(pl[:z_spod], p, pl[:rodzaj]) }
        k = Parametry.krycie(p)
        mp = p['min_pasek_przy_otworze'].to_f
        dmax = p['dach_obnizenie_max'].to_f
        kandydaci = [0.0]
        stale.each do |pl|
          r = pasek(pl[:z_spod], p)
          kandydaci << r << r + k << (r - mp) % k
          next unless wegiel_pod?(p, pl[:rodzaj])
          r2 = pasek_wegla(pl[:z_spod], p)
          kandydaci << r2 << r2 + k << (r2 - mp) % k
        end
        kandydaci.select { |d| d >= 0.0 && d <= dmax + TOL }.sort.each do |d|
          return d if stale.all? { |pl| oparcie_ok?(pl[:z_spod] - d, p, pl[:rodzaj]) }
        end
        0.0
      end

      # Położenia płatwi pośrednich (v) między oparciami v0 i v1 (kier – w stronę v1, w górę połaci): równo, potem każda
      # z za cienkim paskiem (w ścianie albo w węgle pod nią) przesunięta na pełny bal albo na najcieńszy pasek
      # (najmniejsze przesunięcie, rozstaw dotrzymany). Blok: v → spód płatwi (Dach.platwa).
      def polozenia(v0, v1, n, p, kier)
        dl = (v1 - v0).abs
        rowne = (1..n).map { |j| v0 + kier * j * dl / (n + 1) }
        return rowne unless Parametry.tak?(p, 'platwie_na_wiencach') && block_given?
        tg = Math.tan(p['dach_kat'].to_f * Math::PI / 180.0)
        lmax = p['platwie_rozstaw_max'].to_f + 0.5
        przes = p['platwie_przesuniecie_max'].to_f
        k = Parametry.krycie(p)
        mp = p['min_pasek_przy_otworze'].to_f
        wynik = []
        poprz = v0
        rowne.each_with_index do |v, j|
          z = yield(v)
          if oparcie_ok?(z, p, 'posrednia')
            wynik << v
            poprz = v
            next
          end
          r = pasek(z, p)
          zostalo = n - j
          dz = [-r, k - r, mp - r]
          if wegiel_pod?(p, 'posrednia')
            r2 = pasek_wegla(z, p)
            dz.concat([-r2, k - r2, mp - r2])
          end
          kandydaci = dz.map { |d| v + kier * d / tg }.sort_by { |c| (c - v).abs }
          wybor = kandydaci.find do |c|
            (c - v).abs <= przes + 0.01 && (c - poprz) * kier > 0.0 && (c - poprz).abs <= lmax &&
              (v1 - c).abs / zostalo <= lmax && oparcie_ok?(yield(c), p, 'posrednia')
          end
          wybor ||= v
          wynik << wybor
          poprz = wybor
        end
        wynik
      end
    end
  end
end
