# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/skrzydla.rb
# Zadanie: dach domu w kształcie L – podział obrysu na skrzydło główne i boczne, opisy obu dachów (dwa dachy dwuspadowe z koszem), szczyty i ściany okapowe skrzydeł, zasięg płatwi skrzydła bocznego.
# Tematy: dom w kształcie L, obrys L, skrzydło główne, skrzydło boczne, dwa dachy z koszem, kosz dachu, kalenica w poprzek, oś kalenicy domu L, szczyt na części ściany, ściana okapowa skrzydła bocznego, płatwie skrzydła bocznego, koniec płatwi na dachu głównym, strefa skrzydła
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia, płatwie), rdzen/platwie_wience.rb (obniżenie dachu), rdzen/wience.rb
# Używają: rdzen/sciany.rb (oś kalenicy), rdzen/szczyty.rb (szczyty, gniazda), rdzen/dach.rb (belki), rdzen/pod_dachem.rb, rdzen/sciecie_dachu.rb, rdzen/wegly_konstrukcyjne.rb, rdzen/polacie.rb
#
# Decyzja użytkownika (runda 10): dom L dostaje dwa dachy dwuspadowe. Skrzydło główne (o większej rozpiętości; przy równych
# – wg parametru „kalenica”) ma dach na całej długości z dwoma szczytami, skrzydło boczne – kalenicę w poprzek, szczyt na
# wolnym końcu i wchodzi w dach główny dwoma koszami. Oba dachy mają tę samą wysokość okapu (linia podparcia na licu
# wewnętrznym ściany okapowej) i to samo obniżenie; dach domu = wyższa z dwóch płaszczyzn.
# Opis dachu skrzydła („dom”, jak dla domu prostokątnego): { os:, iv: (indeks współrzędnej w poprzek kalenicy), v_a:, v_b:
# (osie ścian okapowych), u1:, u2: (osie szczytów; skrzydło boczne – oś szczytu i oś linii okapu dachu głównego), wewn:,
# rola: :glowne | :boczne, obnizenie: }. Główne ma [:boczne] (opis skrzydła bocznego), [:r] (narożnik wklęsły obrysu)
# i [:zewn] (ściany zewnętrzne w kolejności obrysu – do połaci), boczne – [:u_wolny] (oś szczytu),
# [:u_styk] (oś linii okapu dachu głównego od strony skrzydła), [:kier_u] (±1 od styku do szczytu), [:geo_glowne].
# Ściana szczytowa dachu głównego dłuższa niż jego rozpiętość (biegnie dalej jako ściana okapowa skrzydła bocznego):
# szczyt z [:s_zakres] – poza nim linia szczytu = góra ściany, a w[:okap_boczny] = { geo:, s_zakres: } ścina górny bal
# w poprzek do płaszczyzny dachu skrzydła bocznego.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module Skrzydla
      # Zakres „do końca ściany” [mm].
      DALEKO = 1.0e9 unless const_defined?(:DALEKO)

      module_function

      # Podział obrysu L (6 punktów, jeden narożnik wklęsły, boki równoległe do osi): { os: (kalenica dachu głównego),
      # r: (narożnik wklęsły), n: (brakujący narożnik prostokąta), opp: (narożnik naprzeciw) }; inny obrys – nil.
      def podzial(pts, wybor)
        return nil unless pts.is_a?(Array) && pts.length == 6
        n = pts.length
        return nil unless (0...n).all? { |i| a = pts[i]; b = pts[(i + 1) % n]; (a[0] - b[0]).abs < 0.5 || (a[1] - b[1]).abs < 0.5 }
        wkl = (0...n).select do |i|
          a = pts[i - 1]
          b = pts[i]
          c = pts[(i + 1) % n]
          (b[0] - a[0]) * (c[1] - b[1]) - (b[1] - a[1]) * (c[0] - b[0]) < 0.0
        end
        return nil unless wkl.length == 1
        r = pts[wkl[0]]
        xs = pts.map { |q| q[0] }.minmax
        ys = pts.map { |q| q[1] }.minmax
        brak = xs.product(ys).reject { |x, y| pts.any? { |q| (q[0] - x).abs < 0.5 && (q[1] - y).abs < 0.5 } }
        return nil unless brak.length == 1
        nx, ny = brak[0]
        opp = [(xs - [nx]).first || nx, (ys - [ny]).first || ny]
        sx = (r[0] - opp[0]).abs
        sy = (r[1] - opp[1]).abs
        os = if (sx - sy).abs < 1.0
               wybrana_os(xs[1] - xs[0], ys[1] - ys[0], wybor)
             else
               sx < sy ? :x : :y
             end
        { os: os, r: r, n: [nx, ny], opp: opp }
      end

      # Oś kalenicy z parametru „kalenica” dla obrysu szer × wys (jak Sciany.os_kalenicy).
      def wybrana_os(szer, wys, wybor)
        case wybor.to_s
        when 'x' then :x
        when 'y' then :y
        when 'krotszy' then szer >= wys ? :y : :x
        else szer >= wys ? :x : :y
        end
      end

      # Oś kalenicy dachu głównego domu L (nil – obrys nie jest L).
      def os(pts, wybor)
        pd = podzial(pts, wybor)
        pd ? pd[:os] : nil
      end

      # Opis dachu domu L ze ścian zewnętrznych: dach główny z [:boczne]; nil – obrys nie jest L albo oś kalenicy inna niż
      # wynika z podziału (np. wymuszona przez taras).
      def dom(sciany, p, os_kalenicy)
        zewn = sciany.select { |w| w[:rodzaj] == :zewnetrzna }.sort_by { |w| w[:k] }
        return nil unless zewn.length == 6 && zewn.all? { |w| w[:bok] }
        pd = podzial(zewn.map { |w| w[:bok][0] }, p['kalenica'])
        return nil if pd.nil? || pd[:os] != os_kalenicy
        t2 = Parametry.grubosc(p) / 2.0
        iv = pd[:os] == :x ? 1 : 0
        iu = 1 - iv
        do_srodka = lambda { |q, i| q[i] + (pd[:opp][i] < pd[:n][i] ? 1.0 : -1.0) * t2 }
        # Dach główny: w poprzek od narożnika naprzeciw do narożnika wklęsłego, wzdłuż cały obrys.
        v_g = [do_srodka.call(pd[:opp], iv), pd[:r][iv] + (pd[:opp][iv] < pd[:n][iv] ? -t2 : t2)].sort
        u_g = [do_srodka.call(pd[:opp], iu), pd[:n][iu] + (pd[:opp][iu] < pd[:n][iu] ? -t2 : t2)].sort
        glowne = { os: pd[:os], iv: iv, v_a: v_g[0], v_b: v_g[1], u1: u_g[0], u2: u_g[1], wewn: [], rola: :glowne,
                   r: pd[:r], zewn: zewn }
        glowne[:obnizenie] = PlatwieWience.obnizenie({ v_a: v_g[0], v_b: v_g[1] }, p)
        # Skrzydło boczne: w poprzek od narożnika naprzeciw do narożnika wklęsłego, wzdłuż od linii okapu dachu głównego
        # do szczytu na wolnym końcu.
        v_b = [do_srodka.call(pd[:opp], iu), pd[:r][iu] + (pd[:opp][iu] < pd[:n][iu] ? -t2 : t2)].sort
        kier = pd[:n][iv] > pd[:opp][iv] ? 1.0 : -1.0
        u_styk = pd[:r][iv] - kier * t2
        u_wolny = pd[:n][iv] - kier * t2
        u_b = [u_styk, u_wolny].sort
        glowne[:boczne] = { os: pd[:os] == :x ? :y : :x, iv: iu, v_a: v_b[0], v_b: v_b[1], u1: u_b[0], u2: u_b[1], wewn: [],
                            rola: :boczne, obnizenie: glowne[:obnizenie], u_styk: u_styk, u_wolny: u_wolny, kier_u: kier,
                            geo_glowne: Dach.geo(glowne) }
        glowne
      end

      # Dachy domu: [główny, boczny] albo [dom] dla domu prostokątnego; nil – [].
      def domy(dom)
        return [] if dom.nil?
        dom[:boczne] ? [dom, dom[:boczne]] : [dom]
      end

      # Czy punkt rzutu q leży w strefie dachu dom (dom prostokątny – zawsze): główny – w jego rozpiętości (z grubością
      # ściany), boczny – za linią okapu dachu głównego.
      def w_strefie?(dom, q, p)
        return true if dom[:rola].nil?
        t = Parametry.grubosc(p)
        v = q[dom[:iv]]
        return false if v < dom[:v_a] - t || v > dom[:v_b] + t
        return true if dom[:rola] == :glowne
        (q[1 - dom[:iv]] - dom[:u_styk]) * dom[:kier_u] > t
      end

      # Dach, w którego strefie leży ściana (węgieł – jego oś, inna ściana – środek); nil – żaden.
      def dom_sciany(dom, w, p)
        q = w[:rodzaj] == :kontrfor ? w[:a] : [(w[:a][0] + w[:b][0]) / 2.0, (w[:a][1] + w[:b][1]) / 2.0]
        domy(dom).find { |d| w_strefie?(d, q, p) }
      end

      # Szczyty i ściany okapowe domu L (w[:szczyt], w[:okap_boczny]); zwraca ściany ze szczytem. dzialowe – czy działowe
      # w poprzek kalenicy od okapu do okapu dostają szczyt.
      def oznacz!(sciany, dom, p, z_okap, dzialowe)
        szczytowe = []
        domy(dom).each do |d|
          iv = d[:iv]
          iu = 1 - iv
          sciany.each do |w|
            next if w[:rodzaj] == :kontrfor || w[:os] == d[:os]
            lo, hi = [w[:a][iv], w[:b][iv]].minmax
            u = w[:a][iu]
            pelna = (lo - d[:v_a]).abs < 1.0 && (hi - d[:v_b]).abs < 1.0
            if w[:rodzaj] == :zewnetrzna
              na_szczycie = d[:rola] == :glowne ? [d[:u1], d[:u2]].any? { |x| (u - x).abs < 1.0 } : (u - d[:u_wolny]).abs < 1.0
              next unless na_szczycie && lo < d[:v_a] + 1.0 && hi > d[:v_b] - 1.0
              w[:szczyt] = szczyt(w, d, z_okap)
              w[:szczyt][:s_zakres] = zakres_szczytu(w, d, lo, p) unless pelna
            elsif w[:rodzaj] == :dzialowa && w[:nizsza].nil? && dzialowe && pelna && u > d[:u1] + 1.0 && u < d[:u2] - 1.0
              next unless konce_na_okapach?(w, d)
              w[:szczyt] = szczyt(w, d, z_okap)
              d[:wewn] << u
            else
              next
            end
            szczytowe << w
          end
          d[:wewn].sort!
        end
        okapy_boczne!(sciany, dom[:boczne], p)
        szczytowe
      end

      # Szczyt ściany w pod dachem d: geometria przekroju dachu z kierunkiem v wzdłuż ściany.
      def szczyt(w, d, z_okap)
        iv = d[:iv]
        Dach.geo(d).merge(iv: iv, v0: w[:a][iv], kv: w[:b][iv] >= w[:a][iv] ? 1.0 : -1.0, z_okap: z_okap)
      end

      # Zasięg [s0, s1] szczytu na ścianie dłuższej niż rozpiętość dachu d: od końca przy narożniku do lica wewnętrznego
      # linii okapu po stronie, po której ściana biegnie dalej.
      def zakres_szczytu(w, d, lo, p)
        t2 = Parametry.grubosc(p) / 2.0
        iv = d[:iv]
        dalej_za_b = (lo - d[:v_a]).abs < 1.0
        v_g = dalej_za_b ? d[:v_b] - t2 : d[:v_a] + t2
        s_g = (v_g - w[:a][iv]) * w[:kier][iv]
        # Szczyt po tej stronie granicy, po której leży oś dachu.
        srodek = ((d[:v_a] + d[:v_b]) / 2.0 - w[:a][iv]) * w[:kier][iv]
        srodek < s_g ? [-DALEKO, s_g] : [s_g, DALEKO]
      end

      # Czy oba końce działowej leżą na ścianach zewnętrznych wzdłuż kalenicy dachu d.
      def konce_na_okapach?(w, d)
        [0.0, w[:dl_osi]].all? do |s|
          k = w[:skrzyzowania].find { |x| (x[:s] - s).abs < 1.0 }
          k && k[:inna][:rodzaj] == :zewnetrzna && k[:inna][:os] == d[:os]
        end
      end

      # Ściany okapowe skrzydła bocznego (zewnętrzne wzdłuż jego kalenicy, w osiach v_a i v_b): w[:okap_boczny] = { geo:,
      # s_zakres: } – cała ściana albo jej część za linią okapu dachu głównego (ściana ze szczytem dachu głównego).
      def okapy_boczne!(sciany, boczne, p)
        sciany.each { |w| w.delete(:okap_boczny) }
        return if boczne.nil?
        iv = boczne[:iv]
        iu = 1 - iv
        geo = Dach.geo(boczne).merge(iv: iv)
        sciany.each do |w|
          next unless w[:rodzaj] == :zewnetrzna && w[:os] == boczne[:os]
          next unless [boczne[:v_a], boczne[:v_b]].any? { |v| (w[:a][iv] - v).abs < 1.0 }
          us = [w[:a][iu], w[:b][iu]]
          next unless us.any? { |u| (u - boczne[:u_styk]) * boczne[:kier_u] > 1.0 }
          zakres = [-DALEKO, DALEKO]
          zakres = [w[:szczyt][:s_zakres][1], DALEKO] if w[:szczyt] && w[:szczyt][:s_zakres] && w[:szczyt][:s_zakres][0] < -DALEKO / 2.0
          zakres = [-DALEKO, w[:szczyt][:s_zakres][0]] if w[:szczyt] && w[:szczyt][:s_zakres] && w[:szczyt][:s_zakres][1] > DALEKO / 2.0
          w[:okap_boczny] = { geo: geo, s_zakres: zakres }
        end
      end

      # Zasięg płatwi pl dachu dom wzdłuż kalenicy [u0, u3]: za szczyty o wysunięcie dachu; płatew skrzydła bocznego – od
      # szczytu do dachu głównego (koniec_w_dachu_glownym).
      def zasieg_platwi(dom, pl, p)
        wys = p['dach_okap_szczyt'].to_f + Parametry.grubosc(p) / 2.0
        return [dom[:u1] - wys, dom[:u2] + wys] unless dom[:rola] == :boczne
        [dom[:u_wolny] + dom[:kier_u] * wys, koniec_w_dachu_glownym(dom, pl, p)].sort
      end

      # Koniec płatwi skrzydła bocznego w dachu głównym (współrzędna u skrzydła = v dachu głównego): tam, gdzie wierzch
      # płatwi w jej osi dochodzi do płaszczyzny dachu głównego (w koszu); wcześniej – przy licu płatwi dachu głównego, w którą by
      # weszła (płatew skrzydła dochodzi do niej na styk).
      def koniec_w_dachu_glownym(dom, pl, p)
        gg = dom[:geo_glowne]
        vk = (gg[:v_a] + gg[:v_b]) / 2.0
        kier = dom[:kier_u]
        z_gora = pl[:z_spod] + pl[:h]
        # Kosz w osi płatwi: płaszczyzna dachu głównego na wysokości płaszczyzny skrzydła bocznego nad osią płatwi.
        z_os = [Dach.linia_podparcia(Dach.geo(dom), pl[:v], p), z_gora].min
        d = (Dach.linia_podparcia(gg, vk, p) - z_os) / Dach.tg(p)
        v_t = vk + kier * [d, 0.0].max
        lica = Dach.platwie(gg, p).select do |m|
          m[:z_spod] < z_gora - 0.5 && m[:z_spod] + m[:h] > pl[:z_spod] + 0.5
        end.map { |m| m[:v] + kier * m[:b] / 2.0 }.select { |f| (f - v_t) * kier > -0.01 }
        lica.empty? ? v_t : lica.max_by { |f| f * kier }
      end
    end
  end
end
