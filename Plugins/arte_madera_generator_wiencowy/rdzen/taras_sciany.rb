# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/taras_sciany.rb
# Zadanie: balustrada tarasu z wieńców ścian – dolne wieńce ścian bocznych biegną ciągle przez całą długość tarasu, front w tych wieńcach z balami między ścianami bocznymi (przerwa na wejście), w narożnikach frontu zamki z zakładką (co druga belka wysunięta) albo równo z licem; poręcz na jednej wysokości.
# Tematy: balustrada z wieńców ścian, wieńce ciągłe przez taras, zakładka pod barierkę, wypust w narożniku tarasu, wejście w balustradzie, wysokość balustrady, poręcz tarasu
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wieńce ściany), rdzen/taras.rb (role ścian, słupy frontu)
# Używają: rdzen/taras.rb (zasięg wieńca), rdzen/bale.rb (przedziały – wejście), rdzen/projekt.rb (poręcz), rdzen/taras_slupy.rb (pasy słupów)
#
# Wymóg użytkownika (runda 8): „belki ścian są kontynuowane na długość tarasu, tak by nie trzeba było dokładać krótkich
# kawałków; do wyboru co druga belka tarasu wysunięta o 100 mm – zakładka pod barierkę; zakładki do wysokości tarasu”.
# Taras z podciągiem, taras_balustrada_rodzaj = sciany: wieńce ścian bocznych i frontu, których wierzch nie przekracza
# taras_balustrada_wysokosc, są pełne (ściana boczna od narożnika domu do frontu jednym ciągiem, z łączeniami jak cała
# ściana); w narożnikach frontu bale krzyżują się w zamku jak w narożniku domu – z wypustem taras_zakladka_wypust (co
# druga belka w widoku z frontu) albo bez wypustu (koniec równo z licem, taras_zakladka = nie). Wyżej, do podciągu –
# otwarte (ściany boczne nad tarasem tylko w obrębie domu z ostatkiem). Front: przerwa na wejście między licami słupów.
# Poręcz – najwyższy wieniec balustrady frontu i ścian bocznych na wspólnej wysokości (wyższy ścięty z góry), bez piór.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)

module ArteMadera
  module GeneratorWiencowy
    module TarasSciany
      module_function

      # Czy balustrada z wieńców ścian (taras z podciągiem).
      def wlaczona?(p)
        p['taras'] == 'podciag' && p['taras_balustrada_rodzaj'] == 'sciany'
      end

      # Czy wieniec o spodzie z0 i wysokości h należy do balustrady (wierzch nie wyżej niż wysokość balustrady).
      def w_balustradzie?(z0, h, p)
        z0 + h <= p['taras_balustrada_wysokosc'].to_f + 0.01
      end

      # Wypust bala za licem w narożniku frontu [mm] (zakładka albo 0 – równo z licem).
      def wypust(p)
        Parametry.tak?(p, 'taras_zakladka') ? p['taras_zakladka_wypust'].to_f : 0.0
      end

      # Zasięg wieńca o spodzie z0 (h – wysokość) ściany tarasu w balustradzie z wieńców: front i ściana boczna – pełny,
      # koniec przy narożniku frontu z wypustem zakładki; nad balustradą – nil (dalej decyduje Taras.zasieg).
      def zasieg(w, z0, h, zas, p)
        tr = w[:taras]
        return nil unless w_balustradzie?(z0, h, p)
        t = Parametry.grubosc(p)
        o = wypust(p)
        lo, hi = zas
        if tr[:rola] == :front
          lo = [lo, -(t / 2.0 + o)].max if (lo - w[:s_od]).abs < 0.01
          hi = [hi, w[:dl_osi] + t / 2.0 + o].min if (hi - w[:s_do]).abs < 0.01
        elsif tr[:kier] > 0
          hi = tr[:s_front] + t / 2.0 + o if (hi - w[:s_do]).abs < 0.01
        elsif (lo - w[:s_od]).abs < 0.01
          lo = tr[:s_front] - t / 2.0 - o
        end
        hi - lo > 1.0 ? [lo, hi] : nil
      end

      # Przedziały wieńca frontu w balustradzie z przerwą na wejście (między licami słupów przy wejściu); bazy – przedziały
      # bez przerwy.
      def przedzialy(w, wn, bazy, p)
        return bazy unless wlaczona?(p) && w[:taras] && w[:taras][:rola] == :front && wn[:z0] < w[:taras][:z_front] - 0.01
        we = Taras.slupy_frontu(w, p)[:wejscie]
        return bazy if we.nil?
        b = Parametry.przekroj(p, 'taras_slup_przekroj')[0]
        dziura = [[we[0] + b / 2.0, we[1] - b / 2.0]]
        bazy.map { |a, c| Geometria.odejmij_przedzialy(a, c, dziura, 0.5) }.flatten(1)
      end

      # Wierzch balustrady (najwyższy wierzch wieńców balustrady ściany) [mm]; nil – brak wieńców.
      def gora_sciany(w, p)
        kursy = Wience.wlasne(w, p).select { |k| w_balustradzie?(k[:z0], k[:h], p) && k[:z0] < limit(w) - 0.01 }
        kursy.empty? ? nil : kursy.map { |k| k[:z0] + k[:h] }.max
      end

      # Spód podciągu ściany tarasu (front – z_front, bok – z_bok).
      def limit(w)
        w[:taras][:rola] == :front ? w[:taras][:z_front] : w[:taras][:z_bok]
      end

      # Wspólna wysokość poręczy – najniższy z wierzchów balustrad frontu i ścian bocznych [mm]; nil – brak.
      def wysokosc_poreczy(sciany, p)
        gory = sciany.select { |w| w[:taras] && %i[front bok].include?(w[:taras][:rola]) }.map { |w| gora_sciany(w, p) }.compact
        gory.min
      end

      # Poręcz: najwyższe bale balustrady frontu i ścian bocznych (część nad tarasem) ścięte do wspólnej wysokości i bez
      # piór (wierzch płaski). Ściana boczna – tylko odcinek od lica ściany domu do frontu.
      def porecz!(sciany, p)
        return unless wlaczona?(p)
        gora = wysokosc_poreczy(sciany, p)
        return if gora.nil?
        t = Parametry.grubosc(p)
        sciany.select { |w| w[:taras] && %i[front bok].include?(w[:taras][:rola]) }.each do |w|
          gs = gora_sciany(w, p)
          next if gs.nil?
          w[:bale].select { |b| (b[:z0] + b[:h] - gs).abs < 0.01 }.each do |b|
            x0, x1 = odcinek_tarasu(w, b, t)
            next if x1 - x0 < 1.0
            b[:cechy] << { typ: 'bez_piora', x0: x0, x1: x1 }
            zt = gora - b[:z0]
            b[:cechy] << { typ: 'skos_gora', x0: x0, x1: x1, z0: zt, z1: zt } if zt < b[:h] - 0.01
          end
        end
      end

      # Odcinek bala b nad tarasem [x0, x1] w układzie bala: front – cały, ściana boczna – od lica ściany domu do końca.
      def odcinek_tarasu(w, b, t)
        tr = w[:taras]
        return [0.0, b[:dl]] if tr[:rola] == :front
        lico = tr[:s_dom] + tr[:kier] * t / 2.0
        lo, hi = tr[:kier] > 0 ? [lico, b[:s1]] : [b[:s0], lico]
        [[lo - b[:s0], 0.0].max, [hi - b[:s0], b[:dl]].min]
      end
    end
  end
end
