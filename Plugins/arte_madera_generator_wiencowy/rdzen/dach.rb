# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/dach.rb
# Zadanie: geometria dachu dwuspadowego – linia podparcia (wierzch płatwi), linia szczytu, płatwie w przekroju, krokwie, belki dachu.
# Tematy: dach, kąt dachu, linia dachu, płatew, płatew kalenicowa, płatew ścienna, krokiew, krokwie przy szczycie, rozstaw krokwi, okap, wysunięcie dachu, układ dachu, krokwie z generatora albo z aplikacji do dachów
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wysokość ścian okapowych), rdzen/elementy.rb
# Używają: rdzen/szczyty.rb (linia szczytu, gniazda), rdzen/projekt.rb (belki dachu), rdzen/polacie.rb (linia podparcia)
#
# Przekrój poprzeczny dachu opisuje „geo” = { v_a:, v_b: } – osie ścian okapowych w kierunku v (prostopadle do kalenicy);
# kalenica w połowie. Linia podparcia: spód krokwi (płaszczyzna dachu nad płatwiami); na licu wewnętrznym ściany
# okapowej = z_ref, w stronę kalenicy rośnie o tg(kąt). Płatew ścięta (platwie_sciecie = tak, wymóg użytkownika):
# podniesiona tak, że wierzch ścięty po skosie leży w linii podparcia na całej szerokości (kalenicowa – z dwóch stron);
# bez ścięcia – wierzch poziomy na linii przy krawędzi od strony okapu (nic nie wystaje nad dach).
# Krokwie leżą na linii podparcia; szczyt kończy się na linii podparcia (bez krokwi, krokiew na szczycie albo krokwie
# z aplikacji do dachów – dach_wiezba = aplikacja, generator robi wtedy same płatwie, rdzen/polacie.rb) albo na
# wierzchu krokwi (krokwie z generatora obok szczytu).
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

      # Czy krokwie buduje generator (dach_wiezba = generator); przy aplikacji do dachów krokwie powstają w jej KROKU 2.
      def krokwie_generatora?(p)
        krokwie?(p) && p['dach_wiezba'] == 'generator'
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

      # Czy szczyt dochodzi do wierzchu krokwi (krokwie z generatora obok szczytu), a nie do linii podparcia.
      def szczyt_do_wierzchu_krokwi?(p)
        krokwie_generatora?(p) && p['krokwie_przy_szczycie'] != 'na_szczycie'
      end

      # Wysokość linii podparcia na licu wewnętrznym ściany okapowej [mm] (płatew ścienna na ścianie albo podniesienie).
      # Płatew stojąca na ścianie: bez ścięcia linia przechodzi przez jej wierzch przy krawędzi od okapu, ze ścięciem – przy
      # krawędzi od kalenicy (płatew stoi na ścianie, wierzch ścięty pod dach).
      def z_ref(p)
        z_okap = Wience.wysokosci(p)[:okapowa]
        if Parametry.tak?(p, 'platwa_na_scianie') && p['platwa_scienna_polozenie'] == 'na_scianie'
          b, h = Parametry.przekroj(p, 'platwa_scienna_przekroj')
          t2 = Parametry.grubosc(p) / 2.0
          return z_okap + h + tg(p) * (t2 - b / 2.0) if Parametry.tak?(p, 'platwie_sciecie')
          return z_okap + h + tg(p) * (b / 2.0 + t2)
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

      # Płatwie w przekroju: [{ rodzaj: 'scienna' | 'posrednia' | 'kalenicowa', v:, b:, h:, z_spod:, gora: }] (v – oś płatwi,
      # gora – wierzch ścięty: [[dv, dz]] od osi płatwi i od spodu, nil – wierzch poziomy).
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

      # Jedna płatew (kier – kierunek do kalenicy): ścięta – najwyższy punkt wierzchu w linii podparcia (krawędź od
      # kalenicy, kalenicowa – w osi), wierzch po skosie; bez ścięcia albo gdy ścięcie zostawiłoby mniej niż 1/3 wysokości
      # – wierzch poziomy na linii przy krawędzi od strony okapu.
      def platwa(geo, p, rodzaj, v, b, h, kier)
        vk = (geo[:v_a] + geo[:v_b]) / 2.0
        boki = rodzaj == 'kalenicowa' ? [vk - b / 2.0, vk + b / 2.0] : [v - kier * b / 2.0, v + kier * b / 2.0]
        z_boki = boki.map { |x| linia_podparcia(geo, x, p) }
        z_gora = rodzaj == 'kalenicowa' ? linia_podparcia(geo, vk, p) : z_boki[1]
        if Parametry.tak?(p, 'platwie_sciecie') && z_gora - z_boki.min < h * 2.0 / 3.0
          gora = rodzaj == 'kalenicowa' ? [[-b / 2.0, h - (z_gora - z_boki[0])], [0.0, h], [b / 2.0, h - (z_gora - z_boki[1])]] :
                                          [[-kier * b / 2.0, h - (z_gora - z_boki[0])], [kier * b / 2.0, h]].sort
          return { rodzaj: rodzaj, v: v, b: b, h: h, z_spod: z_gora - h, gora: gora }
        end
        { rodzaj: rodzaj, v: v, b: b, h: h, z_spod: z_boki.min - h, gora: nil }
      end

      # Położenia krokwi wzdłuż kalenicy (u) między szczytami w u1 < u2 (osie ścian szczytowych); wewn – osie szczytów
      # na działowych (krokwie z obu stron albo na szczycie). Pozostałe krokwie równo między krokwiami przy szczytach;
      # na koniec bez krokwi wchodzących w inny szczyt i bez nachodzących na siebie (bez_kolizji).
      def krokwie_u(u1, u2, p, wewn = [])
        return [] unless krokwie_generatora?(p)
        t = Parametry.grubosc(p)
        bk = Parametry.przekroj(p, 'krokiew_przekroj')[0]
        zew = t / 2.0 + bk / 2.0
        na_szczycie = p['krokwie_przy_szczycie'] == 'na_szczycie'
        wynik = []
        granice = []
        case p['krokwie_przy_szczycie']
        when 'obie_strony'
          wynik.concat([u1 - zew, u1 + zew, u2 - zew, u2 + zew])
          granice.concat([u1 + zew, u2 - zew])
        when 'wewnatrz'
          wynik.concat([u1 + zew, u2 - zew])
          granice.concat([u1 + zew, u2 - zew])
        when 'zewnatrz'
          wynik.concat([u1 - zew, u2 + zew])
          granice.concat([u1, u2])
        else
          wynik.concat([u1, u2])
          granice.concat([u1, u2])
        end
        wewn.each do |u|
          if na_szczycie
            wynik << u
            granice << u
          else
            wynik.concat([u - zew, u + zew])
            granice.concat([u - zew, u + zew])
          end
        end
        granice.sort.each_cons(2) do |lo, hi|
          next if hi - lo < bk + 1.0
          n = ((hi - lo) / p['krokwie_rozstaw'].to_f - 1e-9).ceil
          (1...n).each { |i| wynik << lo + i * (hi - lo) / n }
        end
        bez_kolizji(wynik, [u1, u2] + wewn, zew, bk, szczyt_do_wierzchu_krokwi?(p))
      end

      # Krokwie bez kolizji: gdy szczyty sięgają wierzchu krokwi – bez krokwi, której oś jest bliżej osi szczytu niż pół
      # grubości + pół krokwi (np. przy dwóch bliskich szczytach na działowych); nachodzące na siebie – jedna pośrodku.
      def bez_kolizji(lista, osie, zew, bk, obok_szczytu)
        wolne = obok_szczytu ? lista.reject { |u| osie.any? { |g| (u - g).abs < zew - 0.01 } } : lista
        wolne.sort.each_with_object([]) do |u, wynik|
          if !wynik.empty? && u - wynik.last < bk - 0.01
            wynik[-1] = (wynik.last + u) / 2.0
          else
            wynik << u
          end
        end
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
          Elementy.pozioma('P', xy(dom, u0, pl[:v]), xy(dom, u3, pl[:v]), pl[:b], pl[:h], pl[:z_spod], :os, [],
                           przekroj_platwi(dom, pl))
        end
        wynik.concat(krokwie(dom, geo, p))
        wynik
      end

      # Przekrój płatwi ściętej w układzie belki (y – szerokość: przy osi kalenicy x rośnie z v, przy osi y maleje), nil –
      # prostokąt.
      def przekroj_platwi(dom, pl)
        return nil if pl[:gora].nil?
        b = pl[:b]
        gora = pl[:gora].map { |dv, dz| [dom[:os] == :x ? b / 2.0 + dv : b / 2.0 - dv, dz] }.sort_by { |y, _z| -y }
        [[0.0, 0.0], [b, 0.0]] + gora
      end

      # Krokwie obu połaci: od okapu (lico ściany okapowej + dach_okap) do kalenicy, spód na linii podparcia.
      def krokwie(dom, geo, p)
        t = Parametry.grubosc(p)
        bk, hk = Parametry.przekroj(p, 'krokiew_przekroj')
        vk = (geo[:v_a] + geo[:v_b]) / 2.0
        a = kat(p)
        wynik = []
        krokwie_u(dom[:u1], dom[:u2], p, dom[:wewn] || []).each do |u|
          [[geo[:v_a] - t / 2.0 - p['dach_okap'].to_f, 1.0], [geo[:v_b] + t / 2.0 + p['dach_okap'].to_f, -1.0]].each do |v0, kier|
            dl = (vk - v0).abs / Math.cos(a)
            q = xy(dom, u, v0)
            d = dom[:os] == :x ? [0.0, kier] : [kier, 0.0]
            wynik << Elementy.ukosna('K', [q[0], q[1], linia_podparcia(geo, v0, p)], d, a, dl, bk, hk)
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
