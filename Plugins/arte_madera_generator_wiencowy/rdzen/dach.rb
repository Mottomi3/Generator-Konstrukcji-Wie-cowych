# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/dach.rb
# Zadanie: geometria dachu dwuspadowego – linia podparcia (wierzch płatwi), linia szczytu, płatwie w przekroju, krokwie, belki dachu.
# Tematy: dach, kąt dachu, linia dachu, płatew, płatew kalenicowa, płatew ścienna, krokiew, krokwie przy szczycie, rozstaw krokwi, okap, wysunięcie dachu, układ dachu
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wysokość ścian okapowych), rdzen/elementy.rb
# Używają: rdzen/szczyty.rb (linia szczytu, gniazda), rdzen/projekt.rb (belki dachu)
#
# Przekrój poprzeczny dachu opisuje „geo” = { v_a:, v_b: } – osie ścian okapowych w kierunku v (prostopadle do kalenicy);
# kalenica w połowie. Linia podparcia: wysokość wierzchu płatwi; na licu wewnętrznym ściany okapowej = z_ref, w stronę
# kalenicy rośnie o tg(kąt). Płatew stoi wierzchem na linii przy swojej krawędzi od strony okapu (nic nie wystaje nad dach).
# Krokwie leżą na linii podparcia; szczyt kończy się na linii podparcia (bez krokwi lub krokiew na szczycie) albo na
# wierzchu krokwi (krokwie obok szczytu).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)

module ArteMadera
  module GeneratorWiencowy
    module Dach
      module_function

      # Kąt dachu [rad].
      def kat(p)
        p['dach_kat'].to_f * Math::PI / 180.0
      end

      # Tangens kąta dachu.
      def tg(p)
        Math.tan(kat(p))
      end

      # Czy układ dachu ma krokwie.
      def krokwie?(p)
        %w[krokwie platwie_krokwie].include?(p['dach_uklad'])
      end

      # Czy układ dachu ma płatwie pośrednie (między ścienną a kalenicową).
      def platwie_posrednie?(p)
        %w[platwie platwie_krokwie].include?(p['dach_uklad'])
      end

      # Grubość krokwi w pionie (h / cos kąta) – o tyle wierzch krokwi jest nad linią podparcia [mm].
      def dodatek_krokwi(p)
        return 0.0 unless krokwie?(p)
        Parametry.przekroj(p, 'krokiew_przekroj')[1] / Math.cos(kat(p))
      end

      # Czy szczyt dochodzi do wierzchu krokwi (krokwie obok szczytu), a nie do linii podparcia.
      def szczyt_do_wierzchu_krokwi?(p)
        krokwie?(p) && p['krokwie_przy_szczycie'] != 'na_szczycie'
      end

      # Wysokość linii podparcia na licu wewnętrznym ściany okapowej [mm] (płatew ścienna na ścianie albo podniesienie).
      def z_ref(p)
        z_okap = Wience.wysokosci(p)[:okapowa]
        if Parametry.tak?(p, 'platwa_na_scianie') && p['platwa_scienna_polozenie'] == 'na_scianie'
          b, h = Parametry.przekroj(p, 'platwa_scienna_przekroj')
          return z_okap + h + tg(p) * (b / 2.0 + Parametry.grubosc(p) / 2.0)
        end
        z_okap + p['dach_podniesienie'].to_f
      end

      # Linia podparcia w punkcie v przekroju [mm].
      def linia_podparcia(geo, v, p)
        t = Parametry.grubosc(p)
        pol = (geo[:v_b] - geo[:v_a]) / 2.0
        vk = (geo[:v_a] + geo[:v_b]) / 2.0
        z_ref(p) + tg(p) * (pol - t / 2.0 - (v - vk).abs)
      end

      # Linia szczytu (wierzch bali szczytu) w punkcie v [mm].
      def linia_szczytu(geo, v, p)
        linia_podparcia(geo, v, p) + (szczyt_do_wierzchu_krokwi?(p) ? dodatek_krokwi(p) : 0.0)
      end

      # Najwyższy punkt linii szczytu (w kalenicy) [mm].
      def z_szczytu(geo, p)
        linia_szczytu(geo, (geo[:v_a] + geo[:v_b]) / 2.0, p)
      end

      # Płatwie w przekroju: [{ rodzaj: 'scienna' | 'posrednia' | 'kalenicowa', v:, b:, h:, z_spod: }] (v – oś płatwi).
      def platwie(geo, p)
        t = Parametry.grubosc(p)
        vk = (geo[:v_a] + geo[:v_b]) / 2.0
        wynik = []
        oparcia = [[geo[:v_a], 1.0], [geo[:v_b], -1.0]].map do |vs, kier|
          if Parametry.tak?(p, 'platwa_na_scianie')
            b, h = Parametry.przekroj(p, 'platwa_scienna_przekroj')
            v = p['platwa_scienna_polozenie'] == 'na_scianie' ? vs : vs + kier * (t / 2.0 + b / 2.0)
            wynik << platwa(geo, p, 'scienna', v, b, h, kier)
            v
          else
            vs + kier * t / 2.0
          end
        end
        b, h = Parametry.przekroj(p, 'platwa_przekroj')
        if platwie_posrednie?(p)
          oparcia.each_with_index do |ve, i|
            kier = i.zero? ? 1.0 : -1.0
            dl = (vk - ve).abs
            n = (dl / p['platwie_rozstaw_max'].to_f - 1e-9).ceil - 1
            (1..n).each { |j| wynik << platwa(geo, p, 'posrednia', ve + kier * j * dl / (n + 1), b, h, kier) }
          end
        end
        bk, hk = Parametry.przekroj(p, 'platwa_kalenicowa_przekroj')
        wynik << platwa(geo, p, 'kalenicowa', vk, bk, hk, 1.0)
        wynik.sort_by { |x| x[:v] }
      end

      # Jedna płatew: wierzch na linii podparcia przy krawędzi od strony okapu (kier – kierunek do kalenicy).
      def platwa(geo, p, rodzaj, v, b, h, kier)
        vk = (geo[:v_a] + geo[:v_b]) / 2.0
        krawedz = rodzaj == 'kalenicowa' ? [linia_podparcia(geo, vk - b / 2.0, p), linia_podparcia(geo, vk + b / 2.0, p)].min :
                                           linia_podparcia(geo, v - kier * b / 2.0, p)
        { rodzaj: rodzaj, v: v, b: b, h: h, z_spod: krawedz - h }
      end

      # Położenia krokwi wzdłuż kalenicy (u) między szczytami w u1 < u2 (osie ścian szczytowych).
      def krokwie_u(u1, u2, p)
        return [] unless krokwie?(p)
        t = Parametry.grubosc(p)
        bk = Parametry.przekroj(p, 'krokiew_przekroj')[0]
        zew = t / 2.0 + bk / 2.0
        wynik = []
        lo = u1
        hi = u2
        case p['krokwie_przy_szczycie']
        when 'obie_strony'
          wynik.concat([u1 - zew, u1 + zew, u2 - zew, u2 + zew])
          lo = u1 + zew
          hi = u2 - zew
        when 'wewnatrz'
          wynik.concat([u1 + zew, u2 - zew])
          lo = u1 + zew
          hi = u2 - zew
        when 'zewnatrz'
          wynik.concat([u1 - zew, u2 + zew])
        else
          wynik.concat([u1, u2])
        end
        n = ((hi - lo) / p['krokwie_rozstaw'].to_f - 1e-9).ceil
        (1...n).each { |i| wynik << lo + i * (hi - lo) / n }
        wynik.sort
      end

      # Belki dachu domu prostokątnego: płatwie wzdłuż kalenicy i krokwie (elementy). dom = { os:, v_a:, v_b:, u1:, u2: }.
      def elementy(dom, p)
        return [] unless Parametry.tak?(p, 'dach_elementy')
        t = Parametry.grubosc(p)
        geo = { v_a: dom[:v_a], v_b: dom[:v_b] }
        wys = p['dach_okap_szczyt'].to_f + t / 2.0
        u0 = dom[:u1] - wys
        u3 = dom[:u2] + wys
        wynik = platwie(geo, p).map do |pl|
          Elementy.pozioma('Pl', xy(dom, u0, pl[:v]), xy(dom, u3, pl[:v]), pl[:b], pl[:h], pl[:z_spod], :os)
        end
        wynik.concat(krokwie(dom, geo, p))
        wynik
      end

      # Krokwie obu połaci: od okapu (lico ściany okapowej + dach_okap) do kalenicy, spód na linii podparcia.
      def krokwie(dom, geo, p)
        t = Parametry.grubosc(p)
        bk, hk = Parametry.przekroj(p, 'krokiew_przekroj')
        vk = (geo[:v_a] + geo[:v_b]) / 2.0
        a = kat(p)
        wynik = []
        krokwie_u(dom[:u1], dom[:u2], p).each do |u|
          [[geo[:v_a] - t / 2.0 - p['dach_okap'].to_f, 1.0], [geo[:v_b] + t / 2.0 + p['dach_okap'].to_f, -1.0]].each do |v0, kier|
            dl = (vk - v0).abs / Math.cos(a)
            q = xy(dom, u, v0)
            d = dom[:os] == :x ? [0.0, kier] : [kier, 0.0]
            wynik << Elementy.ukosna('Kr', [q[0], q[1], linia_podparcia(geo, v0, p)], d, a, dl, bk, hk)
          end
        end
        wynik
      end

      # Punkt rzutu z (u wzdłuż kalenicy, v w poprzek).
      def xy(dom, u, v)
        dom[:os] == :x ? [u, v] : [v, u]
      end
    end
  end
end
