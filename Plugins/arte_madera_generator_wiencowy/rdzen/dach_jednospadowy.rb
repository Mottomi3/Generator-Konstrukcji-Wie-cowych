# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/dach_jednospadowy.rb
# Zadanie: dach jednospadowy – ściana niska i wysoka, linia podparcia od ściany niskiej w górę, płatwie bez kalenicowej, krokwie w jednym kawałku, ściana wysoka do połaci.
# Tematy: dach jednospadowy, spadek dachu, ściana niska, ściana wysoka, szczyt skośny, okap za ścianą wysoką, płatwie dachu jednospadowego, krokwie dachu jednospadowego, górny bal ściany wysokiej
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (z_ref, tg, płatew, krokwie przy szczycie), rdzen/elementy.rb
# Używają: rdzen/dach.rb (wybór dachu), rdzen/szczyty.rb (ściana wysoka), rdzen/polacie.rb, rdzen/pod_dachem.rb
#
# Ściany okapowe (wzdłuż „kalenicy” – parametr kalenica) to ściana niska (po stronie spadku, dach_spadek: min – mniejsze
# v, max – większe) i wysoka. Linia podparcia (spód krokwi / desek): na licu wewnętrznym ściany niskiej z_ref (jak przy
# dachu dwuspadowym), w stronę ściany wysokiej rośnie o tg(kąt), za nią dalej. Płatew ścienna przy ścianie niskiej,
# pośrednie równo do lica wewnętrznego ściany wysokiej (układ z płatwiami), bez kalenicowej. Ściana wysoka sięga połaci:
# wieńce do linii podparcia przy jej licu wewnętrznym, górny bal przycięty wzdłuż (rdzen/szczyty.rb – szczyt płaski);
# na niej leżą krokwie albo deski. Ściany w poprzek (szczytowe) dostają szczyt skośny – jeden spadek.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)

module ArteMadera
  module GeneratorWiencowy
    module DachJednospadowy
      module_function

      # Oś ściany niskiej i kierunek w górę połaci (+1 – w stronę większych v): [v, kier].
      def niska(geo, p)
        p['dach_spadek'] == 'max' ? [geo[:v_b], -1.0] : [geo[:v_a], 1.0]
      end

      # Oś ściany wysokiej (v).
      def wysoka_v(geo, p)
        p['dach_spadek'] == 'max' ? geo[:v_a] : geo[:v_b]
      end

      # Lico zewnętrzne ściany niskiej (v) – tam połać przechodzi nad wierzchem ściany (okap).
      def lico_niskie_v(geo, p)
        vn, kier = niska(geo, p)
        vn - kier * Parametry.grubosc(p) / 2.0
      end

      # Lico wewnętrzne ściany wysokiej (v) – do tej linii sięga jej górny bal.
      def lico_wysokie_v(geo, p)
        _vn, kier = niska(geo, p)
        wysoka_v(geo, p) - kier * Parametry.grubosc(p) / 2.0
      end

      # Linia podparcia w punkcie v [mm]: z_ref na licu wewnętrznym ściany niskiej, w górę o tg(kąt) w stronę wysokiej.
      def linia_podparcia(geo, v, p)
        vn, kier = niska(geo, p)
        Dach.z_ref(p) + Dach.tg(p) * ((v - vn) * kier - Parametry.grubosc(p) / 2.0)
      end

      # Płatwie: ścienna przy ścianie niskiej (płatwa_na_scianie), pośrednie równo do lica ściany wysokiej (układ
      # z płatwiami), bez kalenicowej – jak Dach.platwie.
      def platwie(geo, p)
        t = Parametry.grubosc(p)
        vn, kier = niska(geo, p)
        wynik = []
        oparcie = vn + kier * t / 2.0
        if Parametry.tak?(p, 'platwa_na_scianie')
          b, h = Parametry.przekroj(p, 'platwa_scienna_przekroj')
          oparcie = p['platwa_scienna_polozenie'] == 'na_scianie' ? vn : vn + kier * (t / 2.0 + b / 2.0)
          wynik << Dach.platwa(geo, p, 'scienna', oparcie, b, h, kier)
        end
        if Dach.platwie_posrednie?(p)
          b, h = Parametry.przekroj(p, 'platwa_przekroj')
          dl = (lico_wysokie_v(geo, p) - oparcie).abs
          n = (dl / p['platwie_rozstaw_max'].to_f - 1e-9).ceil - 1
          (1..n).each { |j| wynik << Dach.platwa(geo, p, 'posrednia', oparcie + kier * j * dl / (n + 1), b, h, kier) }
        end
        wynik.sort_by { |x| x[:v] }
      end

      # Krokwie w jednym kawałku: od okapu za ścianą niską (dach_okap) do okapu za ścianą wysoką (dach_okap_wysoki),
      # spód na linii podparcia; położenia wzdłuż ścian jak w dachu dwuspadowym (Dach.krokwie_u).
      def krokwie(dom, geo, p)
        t = Parametry.grubosc(p)
        bk, hk = Parametry.przekroj(p, 'krokiew_przekroj')
        vn, kier = niska(geo, p)
        a = Dach.kat(p)
        v0 = vn - kier * (t / 2.0 + p['dach_okap'].to_f)
        v1 = wysoka_v(geo, p) + kier * (t / 2.0 + p['dach_okap_wysoki'].to_f)
        dl = (v1 - v0).abs / Math.cos(a)
        d = dom[:os] == :x ? [0.0, kier] : [kier, 0.0]
        Dach.krokwie_u(dom[:u1], dom[:u2], p, dom[:wewn] || []).map do |u|
          q = Dach.xy(dom, u, v0)
          Elementy.ukosna('K', [q[0], q[1], linia_podparcia(geo, v0, p)], d, a, dl, bk, hk)
        end
      end

      # Szczyt płaski ściany wysokiej (wzdłuż okapu, v stałe – lico wewnętrzne): linia = linia podparcia przy licu
      # wewnętrznym; dom = { v_a:, v_b:, os: } (Szczyty.dom_prostokatny). Zwraca ścianę wysoką albo nil.
      def sciana_wysoka!(sciany, dom, p, z_okap)
        iv = dom[:os] == :x ? 1 : 0
        geo = { v_a: dom[:v_a], v_b: dom[:v_b] }
        vw = wysoka_v(geo, p)
        w = sciany.find { |x| x[:rodzaj] == :zewnetrzna && x[:kierunek] == :A && (x[:a][iv] - vw).abs < 1.0 }
        return nil if w.nil?
        v = lico_wysokie_v(geo, p)
        w[:szczyt] = geo.merge(v0: v, kv: 0.0, z_okap: z_okap, z_max: linia_podparcia(geo, v, p), plaski: true)
        w
      end
    end
  end
end
