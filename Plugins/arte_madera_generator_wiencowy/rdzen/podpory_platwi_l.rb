# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/podpory_platwi_l.rb
# Zadanie: podparcie końców płatwi skrzydła bocznego domu L w dachu głównym – koniec przy płatwi dachu głównego (styk z łącznikiem ciesielskim) albo w koszu: słupek na niższej płatwi dachu głównego, nad którą płatew skrzydła przechodzi najbliżej swojego końca.
# Tematy: podparcie płatwi domu L, koniec płatwi w koszu, słupek pod płatwią, płatew skrzydła na płatwi głównej, łącznik płatwi z płatwią, kosz dachu – podpora
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (płatwie, xy), rdzen/skrzydla.rb (domy skrzydeł, zasięg i koniec płatwi skrzydła), rdzen/elementy.rb (element pionowy)
# Używają: rdzen/projekt.rb (belki – słupki), rdzen/materialy.rb (łączniki płatwi), rdzen/statyka_dachu.rb (przęsło płatwi skrzydła do słupka)
#
# Propozycja P2 z rundy 15 (przyjęta w poleceniu rundy 18). Płatew skrzydła bocznego biegnie od szczytu skrzydła do dachu
# głównego (Skrzydla.koniec_w_dachu_glownym): kończy się przy licu płatwi dachu głównego na tej samej wysokości (styk –
# łącznik ciesielski, np. wieszak belki, w zestawieniu) albo w koszu, gdzie jej wierzch dochodzi do połaci dachu głównego –
# tam nic jej nie podpiera. Wtedy w jej osi staje słupek (prefiks S, tag Dach) na wierzchu płatwi dachu głównego, nad
# którą płatew skrzydła przechodzi najbliżej swojego końca (niższa płatew – bliżej okapu dachu głównego), do spodu płatwi
# skrzydła; przekrój słupka – szerokość płatwi skrzydła × szerokość płatwi głównej (mieści się na obu). Odstęp mniejszy niż
# MIN_SLUPEK – płatew leży na płatwi głównej (podkładka, bez słupka). Brak płatwi pod spodem – koniec zostaje bez podpory
# z ostrzeżeniem.
# Wynik: { elementy: [słupki], laczniki: n (styki płatwi z płatwią), oparcia: n (płatew na płatwi bez słupka),
# podpory: [{ v:, u: }] (płatew skrzydła o osi v ma podporę w u – do statyki), bez_podpory: n }.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'skrzydla') unless defined?(ArteMadera::GeneratorWiencowy::Skrzydla)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)

module ArteMadera
  module GeneratorWiencowy
    module PodporyPlatwiL
      # Najniższy słupek [mm]; mniejszy odstęp – płatew skrzydła leży na płatwi głównej (podkładka).
      MIN_SLUPEK = 20.0 unless const_defined?(:MIN_SLUPEK)
      EPS = 0.01 unless const_defined?(:EPS)

      module_function

      # Podpory końców płatwi skrzydła bocznego (opis wyniku w nagłówku); dom prostokątny, bez płatwi albo
      # platwie_kosz = nie – pusty wynik.
      def oblicz(dom, p)
        wynik = { elementy: [], laczniki: 0, oparcia: 0, podpory: [], bez_podpory: 0 }
        return wynik unless dom && dom[:boczne] && Parametry.tak?(p, 'dach_elementy')
        d = Skrzydla.domy(dom).find { |x| x[:rola] == :boczne }
        return wynik if d.nil?
        glowne = Dach.platwie(d[:geo_glowne], p)
        Dach.platwie(Dach.geo(d), p).each do |pl|
          u0, u3 = Skrzydla.zasieg_platwi(d, pl, p)
          next if u3 - u0 < 1.0
          k = Skrzydla.koniec_w_dachu_glownym(d, pl, p)
          if przy_licu?(glowne, pl, k, d[:kier_u])
            wynik[:laczniki] += 1
            next
          end
          podeprzyj(wynik, d, pl, glowne, k, p)
        end
        wynik
      end

      # Czy koniec k płatwi skrzydła pl leży przy licu płatwi dachu głównego, z którą zachodzi na siebie wysokością (styk).
      def przy_licu?(glowne, pl, k, kier)
        glowne.any? do |m|
          m[:z_spod] < pl[:z_spod] + pl[:h] - 0.5 && m[:z_spod] + m[:h] > pl[:z_spod] + 0.5 && (m[:v] + kier * m[:b] / 2.0 - k).abs < EPS
        end
      end

      # Podpora końca w koszu: najbliższa końcowi płatew dachu główna pod płatwią skrzydła – słupek albo oparcie; brak –
      # bez_podpory.
      def podeprzyj(wynik, d, pl, glowne, k, p)
        if p['platwie_kosz'] == 'nie'
          wynik[:bez_podpory] += 1
          return
        end
        kier = d[:kier_u]
        pod = glowne.select do |m|
          m[:z_spod] + m[:h] <= pl[:z_spod] + EPS && (m[:v] - k) * kier >= m[:b] / 2.0 - EPS
        end.min_by { |m| (m[:v] - k) * kier }
        if pod.nil?
          wynik[:bez_podpory] += 1
          return
        end
        wynik[:podpory] << { v: pl[:v], u: pod[:v] }
        z0 = pod[:z_spod] + pod[:h]
        wys = pl[:z_spod] - z0
        if wys < MIN_SLUPEK
          wynik[:oparcia] += 1
          return
        end
        wynik[:elementy] << slupek(d, pl, pod, z0, wys)
      end

      # Słupek w osi płatwi skrzydła (v = pl[:v]) nad osią płatwi głównej (u = pod[:v]), od z0 w górę o wys.
      def slupek(d, pl, pod, z0, wys)
        bx = pl[:b]
        by = pod[:b]
        c = Dach.xy(d, pod[:v], pl[:v])
        # Wymiar wzdłuż osi X świata: przy kalenicy skrzydła wzdłuż X płatew skrzydła ma szerokość w Y, a płatew główna w X.
        sx, sy = d[:os] == :x ? [by, bx] : [bx, by]
        e = Elementy.nowy('S', wys, sx, sy, [c[0] - sx / 2.0, c[1] - sy / 2.0, z0], [0.0, 0.0, 1.0], [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [])
        e.merge!(rodzaj: 'Słupek pod płatwią', tag: :dach)
      end

      # Ostrzeżenia i podpowiedzi o końcach płatwi skrzydła: bez podpory (gdy są).
      def uwagi(wynik)
        return [] if wynik[:bez_podpory].zero?
        [format('Dom L: %d końców płatwi skrzydła bocznego w koszu bez podpory – pod nimi nie ma płatwi dachu głównego ' \
                '(albo „Płatwie skrzydła w koszu – podparcie” = nie). Podeprzyj je na budowie.', wynik[:bez_podpory])]
      end
    end
  end
end
