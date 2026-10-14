# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/pod_dachem.rb
# Zadanie: bale wystające pod połać – węgły na ścianach okapowych i działowe w poprzek kalenicy ścięte linią dachu (spód krokwi / desek); ostrzeżenie o zbyt stromym dachu.
# Tematy: pod dachem, prześwit pod połacią, węgieł pod okapem, ostatek pod dachem, linia podparcia, stromy dach, skos węgła
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb, rdzen/dach.rb (linia podparcia), rdzen/szczyty.rb (skosy_linii)
# Używają: rdzen/projekt.rb, rdzen/bale.rb (zasięg i skos bali pod dachem)
#
# Dotyczy domu prostokątnego z dachem (dom ze szczytów). Ściany biegnące w poprzek kalenicy bez własnego szczytu
# (działowe szczytowe niższe od dachu, węgły na ścianach okapowych) dostają w[:pod_dachem] = { v_a:, v_b:, iv: };
# ich bale (zwłaszcza ostatki pod okapem przy stromym dachu) są ścinane linią podparcia, jak bale szczytu.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'szczyty') unless defined?(ArteMadera::GeneratorWiencowy::Szczyty)

module ArteMadera
  module GeneratorWiencowy
    module PodDachem
      module_function

      # Oznacza ściany pod połacią (w[:pod_dachem]); zwraca ostrzeżenia (dach zbyt stromy dla ściany okapowej).
      def przygotuj(sciany, p, dom)
        uwagi = []
        sciany.each { |w| w.delete(:pod_dachem) }
        return uwagi if dom.nil?
        iv = dom[:os] == :x ? 1 : 0
        geo = { v_a: dom[:v_a], v_b: dom[:v_b], iv: iv }
        sciany.each do |w|
          next if w[:szczyt] || w[:kier][iv].abs < 0.5
          next if w[:rodzaj] == :zewnetrzna
          w[:pod_dachem] = geo
        end
        t = Parametry.grubosc(p)
        z_lico = Dach.linia_podparcia(geo, geo[:v_a] - t / 2.0, p)
        z_okap = Wience.wysokosci(p)[:okapowa]
        if z_lico < z_okap - 0.5
          uwagi << format('Dach: przy zewnętrznym licu ściany okapowej spód krokwi / desek jest %.0f mm poniżej wierzchu ściany ' \
                          '– zmniejsz kąt dachu albo podnieś płatwie (wierzch płatwi nad ścianą okapową).', z_okap - z_lico)
        end
        uwagi
      end

      # Współrzędna v punktu s ściany pod dachem.
      def v_z_s(w, s)
        g = w[:pod_dachem]
        w[:a][g[:iv]] + s * w[:kier][g[:iv]]
      end

      # Linia podparcia nad punktem s ściany [mm]; ściana nie pod dachem – nil.
      def linia(w, s, p)
        return nil if w[:pod_dachem].nil?
        Dach.linia_podparcia(w[:pod_dachem], v_z_s(w, s), p)
      end

      # Zasięg [s0, s1] wieńca o spodzie z0 pod linią dachu (najniższy kawałek jak w szczycie); nil – cały nad dachem.
      def zasieg(w, z0, p)
        g = w[:pod_dachem]
        return [w[:s_od], w[:s_do]] if g.nil?
        m = p['szczyt_min_wysokosc'].to_f
        vk = (g[:v_a] + g[:v_b]) / 2.0
        szczyt = Dach.linia_podparcia(g, vk, p)
        return nil if szczyt <= z0 + m
        r = (szczyt - z0 - m) / Dach.tg(p)
        s = [vk - r, vk + r].map { |v| (v - w[:a][g[:iv]]) * w[:kier][g[:iv]] }.sort
        lo = [s[0], w[:s_od]].max
        hi = [s[1], w[:s_do]].min
        hi - lo > 1.0 ? [lo, hi] : nil
      end

      # Skosy kawałka bala s0…s1 (spód z0, wysokość h) pod linią dachu; [] gdy mieści się pod połacią.
      def skosy(w, s0, s1, z0, h, p)
        g = w[:pod_dachem]
        return [] if g.nil?
        sk = ((g[:v_a] + g[:v_b]) / 2.0 - w[:a][g[:iv]]) * w[:kier][g[:iv]]
        Szczyty.skosy_linii(s0, s1, z0, h, sk) { |s| linia(w, s, p) }
      end
    end
  end
end
