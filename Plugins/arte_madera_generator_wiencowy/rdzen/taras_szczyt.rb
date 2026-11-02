# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/taras_szczyt.rb
# Zadanie: szczyt nad tarasem z podciągiem – pełny (jak 1100), ażurowy (bale na przemian z rzędami przekładek, jak balustrada) albo pusty (kilka bali spinających nad podciągiem i wiązar z rdzen/taras_wiazar.rb albo słupki z przekładek pod płatwiami; wiązar na słupach – front bez bali).
# Tematy: szczyt nad tarasem, szczyt ażurowy, szczyt pusty, przekładki w szczycie, bale spinające szczyt, słupek pod płatwią, front bez bali pod wiązarem
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wysokość ścian okapowych), rdzen/szczyty.rb (zasięg pod linią szczytu, s ↔ v), rdzen/dach.rb (płatwie)
# Używają: rdzen/bale.rb (kawałki wieńca frontu tarasu), rdzen/taras_wiazar.rb (czy wiązar, front bez bali)
#
# Wieńce szczytu frontu = wieńce nad pierwszym balem szczytu (ten zamyka się z górnymi balami ścian bocznych i zostaje
# pełny razem z podciągiem). Numer j wieńca szczytu od 0. Ażurowy: j parzyste – pełne bale, j nieparzyste – przekładki.
# Pusty: j < taras_szczyt_bale – pełne bale (spinają front), wyżej – przekładki tylko pod płatwiami (płatwie nad tarasem
# zostają podparte od frontu). Przekładki (długość taras_przekladka): pod każdą płatwią, przy końcach zasięgu wieńca
# wyżej (bal nad nimi ma na czym leżeć) i równo między nimi, prześwit nie większy niż taras_przekladka_odstep.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)
require File.join(File.dirname(__FILE__), 'szczyty') unless defined?(ArteMadera::GeneratorWiencowy::Szczyty)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)

module ArteMadera
  module GeneratorWiencowy
    module TarasSzczyt
      module_function

      # Czy ściana to front tarasu z podciągiem ze szczytem innym niż pełny.
      def dotyczy?(w, p)
        tr = w[:taras]
        tr && tr[:rola] == :front && tr[:wariant] == 'podciag' && w[:szczyt] && %w[azurowy pusty].include?(p['taras_szczyt'])
      end

      # Numer wieńca szczytu (0 – pierwszy nad balem zamykającym się ze ścianami bocznymi) albo nil (podciąg, balustrada).
      def numer(w, z0, p)
        h = Parametry.krycie(p)
        z_start = Wience.wysokosci(p)[:okapowa] + h / 2.0
        return nil if z0 < z_start - 0.01
        ((z0 - z_start) / h + 0.5).floor
      end

      # Przedziały bali wieńca o spodzie z0 na froncie tarasu (zas – zasięg pod linią szczytu): pełny wieniec – [zas],
      # wieniec przekładek – kawałki przekładek, bez kawałków – [].
      def przedzialy(w, wn, zas, p)
        return [zas] unless dotyczy?(w, p)
        return [] if bez_bali?(w, p) && wn[:z0] >= w[:taras][:z_front] - 0.01
        j = numer(w, wn[:z0], p)
        return [zas] if j.nil?
        pelny = p['taras_szczyt'] == 'azurowy' ? j.even? : j < p['taras_szczyt_bale'].to_i
        return [zas] if pelny
        return [] if wieniec?(p)
        przekladki(w, wn, zas, p, p['taras_szczyt'] == 'azurowy')
      end

      # Kawałki przekładek w wieńcu (zas – zasięg wieńca); wypelnij – także przy końcach i między (ażurowy), inaczej tylko
      # pod płatwiami (pusty).
      def przekladki(w, wn, zas, p, wypelnij)
        l = p['taras_przekladka'].to_f
        lo, hi = zas
        srodki = osie_platwi(w, p).select { |s| s - l / 2.0 > lo - 0.01 && s + l / 2.0 < hi + 0.01 }
        if wypelnij
          wyzej = Szczyty.zasieg(w, wn[:z0] + wn[:h], p) || zas
          a = [lo, wyzej[0]].max + l / 2.0
          b = [hi, wyzej[1]].min - l / 2.0
          srodki = (srodki + (b - a > l ? [a, b] : [(lo + hi) / 2.0])).sort
          srodki = uzupelnij(srodki, l, p['taras_przekladka_odstep'].to_f)
        end
        kawalki = srodki.uniq.map { |s| [[s - l / 2.0, lo].max, [s + l / 2.0, hi].min] }.select { |x0, x1| x1 - x0 > 1.0 }
        scal(kawalki)
      end

      # Czy szczyt pusty ma trójkątny wieniec – wiązar (rdzen/taras_wiazar.rb, zamiast słupków z przekładek); dach dwuspadowy.
      def wieniec?(p)
        p['taras_szczyt'] == 'pusty' && p['taras_wieniec'] != 'brak' && !Dach.jednospadowy?(p)
      end

      # Czy front tarasu jest bez bali od podciągu w górę (wiązar na słupach – z przodu sam trójkąt, runda 9).
      def bez_bali?(w, p)
        dotyczy?(w, p) && wieniec?(p) && p['taras_wiazar_podparcie'] == 'slupy'
      end

      # Osie płatwi na froncie (s ściany).
      def osie_platwi(w, p)
        Dach.platwie(w[:szczyt], p).map { |pl| Szczyty.s_z_v(w, pl[:v]) }.sort
      end

      # Dodatkowe środki przekładek tam, gdzie prześwit między sąsiednimi przekracza odstęp (równo w luce).
      def uzupelnij(srodki, l, odstep)
        wynik = []
        srodki.each_cons(2) do |a, b|
          wynik << a
          luka = b - a - l
          next if luka <= odstep + 0.01
          n = ((luka + l) / (odstep + l) - 1e-9).ceil
          (1...n).each { |i| wynik << a + (b - a) * i / n }
        end
        wynik << srodki.last unless srodki.empty?
        wynik
      end

      # Nachodzące na siebie kawałki scalone w jeden.
      def scal(kawalki)
        kawalki.sort.each_with_object([]) do |(a, b), wynik|
          if !wynik.empty? && a <= wynik.last[1] + 0.01
            wynik.last[1] = [wynik.last[1], b].max
          else
            wynik << [a, b]
          end
        end
      end
    end
  end
end
