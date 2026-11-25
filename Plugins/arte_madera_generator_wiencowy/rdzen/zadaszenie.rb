# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/zadaszenie.rb
# Zadanie: boczne zadaszenie przy ścianie okapowej domu prostokątnego – połać dachu za linią załamania schodzi dalej pod mniejszym kątem; wariant na słupach (słupy z fundamentami, belki poprzeczne, oczep, płatwie na słupkach) albo przybudówka z bali (obrys poszerzony, dawna ściana okapowa jako działowa, niska ściana zewnętrzna); płatwie zadaszenia.
# Tematy: boczne zadaszenie, załamanie dachu, linia załamania, połać zadaszenia, kąt zadaszenia, płatwie zadaszenia, płatew przy ścianie, oczep, słupy zadaszenia, belka poprzeczna zadaszenia, słupek pod płatwią zadaszenia, fundament słupa zadaszenia, przeszkody przy ścianie okapowej, przybudówka z bali, obrys z przybudówką, ściana domu przy przybudówce, ściana przybudówki, prześwit pod zadaszeniem
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia z załamaniem, płatew, wręby płatwi), rdzen/platwie_wience.rb (przekrój płatwi ściennej), rdzen/elementy.rb, rdzen/fundamenty.rb, rdzen/sciany.rb (oś kalenicy), rdzen/skrzydla.rb (zasięg płatwi)
# Używają: rdzen/projekt.rb (obrys z przybudówką, role ścian, elementy, podpowiedzi), rdzen/szczyty.rb (przekrój dachu z zadaszeniem, gniazda płatwi zadaszenia, ściana przybudówki pod połacią), rdzen/polacie.rb (załamania dla aplikacji do dachów), rdzen/krok2.rb (ściana domu przy przybudówce jako podpora)
#
# Wymóg użytkownika (2026-11-25): „boczne zadaszenie … musi być pod mniejszym kątem niż połać dachu, do której została
# doklejona; generator dachów powinien dostać informację, że w tym miejscu jest załamanie dachu”. Wybory: podparcie do
# wyboru (słupy z oczepem albo ściany z bali), na całej długości ściany okapowej (strona – parametr), łaty przy załamaniu
# z obu stron i pełne moduły pod załamaniem (aplikacja do dachów 3.12).
# Opis zadaszenia na przekroju dachu (geo[:zad], rdzen/dach.rb): [{ kier: (−1 – zadaszenie po stronie v_a, +1 – v_b),
# v_k: (linia załamania – lico zewnętrzne ściany okapowej, przy płatwi ściennej stojącej na ścianie – jej krawędź),
# v_lico:, v_s: (lico zewnętrzne podpory – słupów albo ściany przybudówki), tg:, kat: }]; v_a, v_b – osie ścian
# okapowych DOMU (przy przybudówce – dawnych, teraz działowych). Płatwie zadaszenia: pierwsza tuż za linią załamania (przy
# słupach – w gniazdach ostatków ścian szczytowych, w przybudówce – w ścianach szczytowych), pośrednie co najwyżej
# platwie_rozstaw_max (układy z płatwiami pośrednimi), ostatnia: oczep nad słupami albo płatew ścienna przybudówki (bez
# niej – ściana nośna, górny bal ścięty do połaci). Na słupach: słup → belka poprzeczna (od lica podpory do ściany domu,
# przy szczycie – do końca ostatków) → oczep na belce, pozostałe płatwie na słupkach; linie słupów omijają węgły
# i działowe wychodzące ze ściany. Przybudówka: obrys poszerzony o szerokość zadaszenia (jak taras – rdzen/taras.rb),
# dawna ściana okapowa – działowa (w[:zadaszenie][:rola] = :dom), ściana zewnętrzna przybudówki (:przybudowka) – szczyt
# płaski do połaci zadaszenia.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'platwie_wience') unless defined?(ArteMadera::GeneratorWiencowy::PlatwieWience)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)
require File.join(File.dirname(__FILE__), 'fundamenty') unless defined?(ArteMadera::GeneratorWiencowy::Fundamenty)
require File.join(File.dirname(__FILE__), 'sciany') unless defined?(ArteMadera::GeneratorWiencowy::Sciany)
require File.join(File.dirname(__FILE__), 'skrzydla') unless defined?(ArteMadera::GeneratorWiencowy::Skrzydla)

module ArteMadera
  module GeneratorWiencowy
    module Zadaszenie
      WARIANTY = %w[slupy bale].freeze unless const_defined?(:WARIANTY)
      # Słupek pod płatwią krótszy niż tyle [mm] – pominięty (płatew leży wprost na belce poprzecznej).
      MIN_SLUPEK = 20.0 unless const_defined?(:MIN_SLUPEK)
      # Odstęp belki poprzecznej od węgła albo działowej wychodzącej ze ściany okapowej [mm].
      ODSTEP = 10.0 unless const_defined?(:ODSTEP)
      # Najniższy słup zadaszenia [mm] – niższy: zadaszenie bez słupów (uwaga).
      MIN_SLUP = 300.0 unless const_defined?(:MIN_SLUP)

      module_function

      # Czy wybrano boczne zadaszenie (słupy albo przybudówka).
      def wybrane?(p)
        WARIANTY.include?(p['zadaszenie'].to_s)
      end

      # Kąt zadaszenia [rad].
      def kat(p)
        p['zadaszenie_kat'].to_f * Math::PI / 180.0
      end

      # Tangens kąta zadaszenia.
      def tg(p)
        Math.tan(kat(p))
      end

      # Strony zadaszenia: −1 – przy ścianie okapowej o mniejszym v, +1 – o większym.
      def strony(p)
        case p['zadaszenie_strona'].to_s
        when 'max' then [1.0]
        when 'obie' then [-1.0, 1.0]
        else [-1.0]
        end
      end

      # Powód, dla którego zadaszenie nie powstaje przy tych parametrach (nil – może powstać).
      def przeszkoda(p)
        return nil unless wybrane?(p)
        return 'Boczne zadaszenie: tylko przy szczytach z bali – pominięte.' unless Parametry.tak?(p, 'szczyty')
        return 'Boczne zadaszenie: tylko przy dachu dwuspadowym – pominięte.' if p['dach_rodzaj'] == 'jednospadowy'
        if %w[podciag sciany].include?(p['taras'].to_s)
          return 'Boczne zadaszenie razem z tarasem przed szczytem – jeszcze nie; zadaszenie pominięte (wyłącz taras albo zadaszenie).'
        end
        if p['zadaszenie_kat'].to_f > p['dach_kat'].to_f - 0.5
          return format('Boczne zadaszenie: kąt zadaszenia %s° musi być mniejszy niż kąt dachu %s° (co najmniej o 0,5°) – ' \
                        'zadaszenie pominięte.', Parametry.fmt(p['zadaszenie_kat'].to_f), Parametry.fmt(p['dach_kat'].to_f))
        end
        nil
      end

      # Czy zadaszenie powstaje (wybrane i bez przeszkody w parametrach).
      def aktywne?(p)
        wybrane?(p) && przeszkoda(p).nil?
      end

      # Obrys poszerzony o przybudówkę (zadaszenie = bale; ob z Obrys.rozpoznaj): bok obrysu przy ścianie okapowej po stronie
      # zadaszenia przesunięty o szerokość, oś dawnej ściany okapowej dopisana jako działowa (końce działowych narysowanych do
      # jej lica przeniesione na oś), ob[:os_kalenicy] z obrysu domu i ob[:zadaszenie]; zwraca ostrzeżenia.
      def przedluz!(ob, p)
        return [] unless p['zadaszenie'] == 'bale'
        u = przeszkoda(p)
        return [u] if u
        pts = ob[:obrys]
        return ['Boczne zadaszenie (przybudówka): tylko przy obrysie prostokątnym – pominięte.'] unless prostokat?(pts)
        os = ob[:os_kalenicy] || Sciany.os_kalenicy(pts, p['kalenica'])
        iu = os == :x ? 0 : 1
        iv = 1 - iu
        t = Parametry.grubosc(p)
        vs = pts.map { |q| q[iv] }
        us = pts.map { |q| q[iu] }
        lista = strony(p).map do |kier|
          v_dom = kier < 0 ? vs.min : vs.max
          { kier: kier, v_dom: v_dom, v_os: v_dom - kier * t / 2.0, v_zew: v_dom + kier * p['zadaszenie_szerokosc'].to_f }
        end
        ob[:obrys] = pts.map do |q|
          s = lista.find { |x| (q[iv] - x[:v_dom]).abs < 0.5 }
          s ? punkt(iu, q[iu], s[:v_zew]) : q
        end
        ob[:dzialowe] = ob[:dzialowe].map do |seg|
          seg.map do |q|
            s = lista.find { |x| (q[iv] - x[:v_dom]).abs < t / 2.0 + 0.5 }
            s ? punkt(iu, q[iu], s[:v_os]) : q
          end
        end
        lista.each { |s| ob[:dzialowe] << [punkt(iu, us.min, s[:v_os]), punkt(iu, us.max, s[:v_os])] }
        ob[:os_kalenicy] = os
        ob[:zadaszenie] = { os: os, iu: iu, iv: iv, strony: lista }
        []
      end

      # Punkt układu lokalnego ze współrzędnych wzdłuż kalenicy (u, indeks iu) i w poprzek (v).
      def punkt(iu, u, v)
        iu.zero? ? [u, v] : [v, u]
      end

      # Czy obrys to prostokąt o bokach wzdłuż osi.
      def prostokat?(pts)
        return false unless pts.length == 4
        (0...4).all? do |i|
          a = pts[i]
          b = pts[(i + 1) % 4]
          (a[0] - b[0]).abs < 0.5 || (a[1] - b[1]).abs < 0.5
        end
      end

      # Role ścian przybudówki (po zbudowaniu ścian): dawna ściana okapowa – w[:zadaszenie] = { rola: :dom, kier: },
      # ściana zewnętrzna przybudówki – { rola: :przybudowka, kier: }.
      def oznacz!(sciany, info, p)
        sciany.each { |w| w.delete(:zadaszenie) }
        return if info.nil?
        t = Parametry.grubosc(p)
        iv = info[:iv]
        sciany.each do |w|
          next if w[:rodzaj] == :kontrfor || (w[:a][iv] - w[:b][iv]).abs > 0.5
          info[:strony].each do |s|
            if w[:rodzaj] == :dzialowa && (w[:a][iv] - s[:v_os]).abs < 1.0
              w[:zadaszenie] = { rola: :dom, kier: s[:kier] }
            elsif w[:rodzaj] == :zewnetrzna && (w[:a][iv] - (s[:v_zew] - s[:kier] * t / 2.0)).abs < 1.0
              w[:zadaszenie] = { rola: :przybudowka, kier: s[:kier] }
            end
          end
        end
      end

      # Rola ściany w przybudówce (:dom, :przybudowka) albo nil.
      def rola(w)
        w[:zadaszenie] ? w[:zadaszenie][:rola] : nil
      end

      # Przekrój dachu ściany szczytowej z zadaszeniem: g = { v_a:, v_b: } z końców ściany (iv – indeks v); przy przybudówce
      # osie ścian okapowych domu (dawnych – działowych), opis zadaszenia g[:zad]. Bez zadaszenia albo obrys inny niż
      # prostokąt (cztery ściany zewnętrzne) – g bez zmian.
      def geo(g, sciany, p, iv)
        return g unless aktywne?(p) && sciany.count { |w| w[:rodzaj] == :zewnetrzna } == 4
        wynik = g.dup
        if p['zadaszenie'] == 'bale'
          domowe = sciany.select { |w| rola(w) == :dom }
          return g if domowe.empty?
          domowe.each { |w| wynik[w[:zadaszenie][:kier] < 0 ? :v_a : :v_b] = w[:a][iv] }
          kier = domowe.map { |w| w[:zadaszenie][:kier] }.uniq.sort
        else
          kier = strony(p)
        end
        wynik[:zad] = opis(wynik, p, kier)
        wynik
      end

      # Opis stron zadaszenia na przekroju (osie ścian okapowych domu g[:v_a], g[:v_b]): linia załamania nad licem
      # zewnętrznym ściany (płatew ścienna stojąca na ścianie, szersza niż ściana – nad jej krawędzią), lico podpory.
      def opis(g, p, kier)
        t = Parametry.grubosc(p)
        ext = t / 2.0
        if Parametry.tak?(p, 'platwa_na_scianie') && p['platwa_scienna_polozenie'] == 'na_scianie'
          ext = [ext, PlatwieWience.przekroj(p, 'scienna')[0] / 2.0].max
        end
        kier.map do |k|
          vs = k < 0 ? g[:v_a] : g[:v_b]
          lico = vs + k * t / 2.0
          { kier: k, v_k: vs + k * ext, v_lico: lico, v_s: lico + k * p['zadaszenie_szerokosc'].to_f, tg: tg(p), kat: kat(p) }
        end
      end

      # Płatwie zadaszenia w przekroju (jak Dach.platwie): przy ścianie, pośrednie, ostatnia (oczep albo płatew ścienna
      # przybudówki); rodzaj: zadaszenie_przy_scianie | zadaszenie | oczep | zadaszenie_scienna, strona – kier.
      def platwie(geo, p)
        return [] if geo.nil? || geo[:zad].nil?
        b, h = Parametry.przekroj(p, 'zadaszenie_platwa_przekroj')
        t = Parametry.grubosc(p)
        geo[:zad].flat_map do |c|
          v1 = c[:v_k] + c[:kier] * b / 2.0
          ost = ostatnia(c, b, t, p)
          koniec = ost ? ost[0] : c[:v_s] - c[:kier] * t / 2.0
          lista = [[v1, 'zadaszenie_przy_scianie']]
          if Dach.platwie_posrednie?(p)
            n = ((koniec - v1).abs / p['platwie_rozstaw_max'].to_f - 1e-9).ceil - 1
            (1..n).each { |i| lista << [v1 + (koniec - v1) * i / (n + 1), 'zadaszenie'] } if n > 0
          end
          lista << ost if ost && (ost[0] - v1) * c[:kier] > b - 0.5
          lista.map { |v, rodzaj| Dach.platwa(geo, p, rodzaj, v, b, h, -c[:kier]).merge(kier: c[:kier]) }
        end
      end

      # Ostatnia płatew zadaszenia [v, rodzaj]: oczep nad słupami (lico w linii podpory) albo płatew ścienna przybudówki
      # (przy licu wewnętrznym albo na ścianie); nil – przybudówka ze ścianą nośną.
      def ostatnia(c, b, t, p)
        return [c[:v_s] - c[:kier] * b / 2.0, 'oczep'] if p['zadaszenie'] == 'slupy'
        return nil unless Parametry.tak?(p, 'platwa_na_scianie')
        return [c[:v_s] - c[:kier] * t / 2.0, 'zadaszenie_scienna'] if p['platwa_scienna_polozenie'] == 'na_scianie'
        [c[:v_s] - c[:kier] * (t + b / 2.0), 'zadaszenie_scienna']
      end

      # Elementy zadaszenia domu prostokątnego: płatwie (P, z wrębami w ścianach, przez które przechodzą) i – na słupach –
      # słupy, fundamenty, belki poprzeczne i słupki; [] bez zadaszenia.
      def elementy(dom, sciany, p)
        return [] if dom.nil? || !Parametry.tak?(p, 'dach_elementy')
        geo = Dach.geo(dom)
        return [] if geo[:zad].nil?
        wynik = platwie_elementy(dom, geo, p)
        wynik.concat(slupy(dom, geo, sciany, p)) if p['zadaszenie'] == 'slupy'
        wynik
      end

      # Płatwie zadaszenia jako elementy P (grupa „Zadaszenie”) na zasięgu płatwi dachu (wysunięcie za szczyty).
      def platwie_elementy(dom, geo, p)
        platwie(geo, p).map do |pl|
          u0, u3 = Skrzydla.zasieg_platwi(dom, pl, p)
          e = Elementy.pozioma('P', Dach.xy(dom, u0, pl[:v]), Dach.xy(dom, u3, pl[:v]), pl[:b], pl[:h], pl[:z_spod], :os, [],
                               Dach.przekroj_platwi(dom, pl))
          Dach.wreby_platwi!(e, dom, pl, u0, p)
          e.merge!(rodzaj: pl[:rodzaj] == 'oczep' ? 'Oczep zadaszenia' : 'Płatew zadaszenia', tag: :zadaszenie)
        end
      end

      # Wysokość podstawy słupów [mm]: spód podwaliny (podłoga) albo 0 – na niej stoi fundament.
      def z_podstawy(p)
        return 0.0 unless Parametry.tak?(p, 'podloga')
        -Parametry.przekroj(p, 'podwalina_przekroj')[1]
      end

      # Słupy, fundamenty, belki poprzeczne i słupki zadaszenia na słupach (każda strona).
      def slupy(dom, geo, sciany, p)
        bs, ls = Parametry.przekroj(p, 'zadaszenie_slup_przekroj')
        bb, hb = Parametry.przekroj(p, 'zadaszenie_belka_przekroj')
        z0 = z_podstawy(p)
        lista_pl = platwie(geo, p)
        wynik = []
        geo[:zad].each do |c|
          pl_strony = lista_pl.select { |pl| pl[:kier] == c[:kier] }
          oczep = pl_strony.find { |pl| pl[:rodzaj] == 'oczep' }
          next if oczep.nil?
          z_belki = oczep[:z_spod]
          z_slupa = z_belki - hb
          next if z_slupa - z0 < MIN_SLUP
          v_slupa = c[:v_s] - c[:kier] * ls / 2.0
          linie(dom, c, przeszkody(sciany, c, dom, p), bb, p).each do |u, v_konca|
            wynik << slup(dom, u, v_slupa, bs, ls, z0, z_slupa, 'Słup zadaszenia')
            if Fundamenty.wlaczone?(p)
              wynik.concat(Fundamenty.elementy([[Dach.xy(dom, u, v_slupa), z0]], p).map do |f|
                f.merge!(rodzaj: 'Fundament słupa zadaszenia', tag: :zadaszenie)
              end)
            end
            b = Elementy.pozioma('Bp', Dach.xy(dom, u, c[:v_s]), Dach.xy(dom, u, v_konca), bb, hb, z_slupa, :os)
            wynik << b.merge!(rodzaj: 'Belka poprzeczna zadaszenia', tag: :zadaszenie)
            pl_strony.each do |pl|
              next if pl.equal?(oczep) || !nad_belka?(pl, c, v_konca)
              hs = pl[:z_spod] - z_belki
              next if hs < MIN_SLUPEK
              wynik << slup(dom, u, pl[:v], bb, pl[:b], z_belki, pl[:z_spod], 'Słupek zadaszenia')
            end
          end
        end
        wynik
      end

      # Czy płatew leży nad belką poprzeczną (rzut płatwi między licem podpory a końcem belki przy domu).
      def nad_belka?(pl, c, v_konca)
        lo, hi = [c[:v_s], v_konca].sort
        pl[:v] - pl[:b] / 2.0 >= lo - 0.5 && pl[:v] + pl[:b] / 2.0 <= hi + 0.5
      end

      # Przeszkody przy licu ściany okapowej po stronie zadaszenia: ściany w poprzek (szczytowe z ostatkami, działowe
      # z wypustem, węgły) wychodzące przed lico – [{ u:, pol: (pół grubości), v: (koniec przed licem) }].
      def przeszkody(sciany, c, dom, p)
        iv = dom[:iv]
        iu = 1 - iv
        t = Parametry.grubosc(p)
        sciany.map do |w|
          next nil if w[:kier][iv].abs < 0.5
          konce = [w[:s_od], w[:s_do]].map { |s| w[:a][iv] + w[:kier][iv] * s }
          v = c[:kier] < 0 ? konce.min : konce.max
          next nil unless (v - c[:v_lico]) * c[:kier] > 0.5 && (konce.min - c[:v_lico]) * (konce.max - c[:v_lico]) < 0.5
          { u: w[:a][iu], pol: t / 2.0, v: v }
        end.compact
      end

      # Linie słupów [[u, v końca belki poprzecznej]]: skrajne w osiach ścian szczytowych (belka do końca ostatków), pośrednie
      # równo co najwyżej zadaszenie_slupy_rozstaw; linia, w której belka trafiłaby w węgieł albo działową, przesunięta obok.
      def linie(dom, c, przeszkody, bb, p)
        u1 = dom[:u1]
        u2 = dom[:u2]
        n = ((u2 - u1) / p['zadaszenie_slupy_rozstaw'].to_f - 1e-9).ceil
        n = 1 if n < 1
        us = (0..n).map { |i| u1 + (u2 - u1) * i / n }
        us.each_with_index.map do |u, i|
          u = omin(u, przeszkody, bb, u1, u2) unless i.zero? || i == n
          konce = przeszkody.select { |x| (x[:u] - u).abs < x[:pol] + bb / 2.0 - 0.5 }.map { |x| x[:v] }
          v = konce.empty? ? c[:v_lico] : (c[:kier] < 0 ? konce.min : konce.max)
          [u, v]
        end
      end

      # Położenie u linii pośredniej z dala od przeszkód (najbliższe wolne, w zakresie u1…u2).
      def omin(u, przeszkody, bb, u1, u2)
        kolizja = lambda { |x| przeszkody.find { |q| (q[:u] - x).abs < q[:pol] + bb / 2.0 + ODSTEP - 0.5 } }
        q = kolizja.call(u)
        return u if q.nil?
        d = q[:pol] + bb / 2.0 + ODSTEP
        kandydaci = [q[:u] - d, q[:u] + d].select { |x| x > u1 + bb && x < u2 - bb && kolizja.call(x).nil? }
        kandydaci.empty? ? u : kandydaci.min_by { |x| (x - u).abs }
      end

      # Słup (S) od z_dol do z_gora: przekrój b (wzdłuż kalenicy) × l (w poprzek), oś w (u, v); x w górę.
      def slup(dom, u, v, b, l, z_dol, z_gora, rodzaj)
        y = dom[:os] == :x ? [1.0, 0.0, 0.0] : [0.0, 1.0, 0.0]
        z = [-y[1], y[0], 0.0]
        q = Dach.xy(dom, u, v)
        poczatek = [q[0] - y[0] * b / 2.0 - z[0] * l / 2.0, q[1] - y[1] * b / 2.0 - z[1] * l / 2.0, z_dol]
        Elementy.nowy('S', z_gora - z_dol, b, l, poczatek, [0.0, 0.0, 1.0], y, z, []).merge!(rodzaj: rodzaj, tag: :zadaszenie)
      end

      # Podpowiedzi do sekcji „Boczne zadaszenie” ([{ poziom:, tekst: }]).
      def podpowiedzi(dom, p, elementy)
        return [] unless wybrane?(p)
        u = przeszkoda(p)
        return [{ poziom: 'uwaga', tekst: u }] if u
        geo = dom ? Dach.geo(dom) : nil
        if geo.nil? || geo[:zad].nil?
          return [{ poziom: 'uwaga', tekst: 'Boczne zadaszenie: tylko dla domu prostokątnego z dachem z generatora – pominięte.' }]
        end
        pl = platwie(geo, p)
        slupy = elementy.count { |e| e[:rodzaj] == 'Słup zadaszenia' }
        tekst = format('Zadaszenie: załamanie nad licem ściany okapowej, połać %s° (dach %s°) na %s mm + okap %s mm; płatwie ' \
                       'zadaszenia: %d', Parametry.fmt(p['zadaszenie_kat'].to_f), Parametry.fmt(p['dach_kat'].to_f),
                       Parametry.fmt(p['zadaszenie_szerokosc'].to_f), Parametry.fmt(p['zadaszenie_okap'].to_f), pl.length)
        tekst += format(', słupy: %d', slupy) if p['zadaszenie'] == 'slupy'
        wynik = [{ poziom: 'ok', tekst: tekst + '.' }]
        belka = elementy.select { |e| e[:rodzaj] == 'Belka poprzeczna zadaszenia' }.map { |e| e[:polozenie][:poczatek][2] }.min
        if belka
          wynik << { poziom: 'ok', tekst: format('Zadaszenie: prześwit pod belkami poprzecznymi %s mm nad wierzchem podwalin.',
                                                 Parametry.fmt(belka.round)) }
        elsif p['zadaszenie'] == 'slupy'
          wynik << { poziom: 'uwaga', tekst: 'Zadaszenie: słupy niższe niż 300 mm – bez słupów (zmniejsz szerokość albo kąt).' }
        end
        wynik
      end
    end
  end
end
