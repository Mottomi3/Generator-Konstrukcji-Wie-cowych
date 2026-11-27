# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/taras.rb
# Zadanie: taras przed ścianą szczytową domu prostokątnego – obrys przedłużony o głębokość tarasu, ściana domu jako działowa ze szczytem, wariant 1100 (górne wieńce ścian nad tarasem jako podciąg na słupach) albo 1200 (ściany boczne pełne, front otwarty), słupy tarasu.
# Tematy: taras, węgieł w miejscu słupa tarasu, wariant 1100, wariant 1200, podciąg z bali, słupy tarasu, front tarasu, ściana domu przy tarasie, głębokość tarasu, wejście na taras, ostatek przy tarasie, przęsła balustrady
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb, rdzen/elementy.rb, rdzen/sciany.rb (oś kalenicy), rdzen/taras_sciany.rb (balustrada z wieńców ścian)
# Używają: rdzen/projekt.rb, rdzen/sciany.rb (opis ściany), rdzen/szczyty.rb (szczyt ściany domu), rdzen/bale.rb (zasięg wieńca), rdzen/usztywnienie.rb, rdzen/taras_balustrada.rb, rdzen/taras_slupy.rb, rdzen/taras_szczyt.rb, rdzen/wience.rb (półbal frontu – w[:taras][:z_polbal])
#
# Narysowany obrys = dom. Taras (parametr taras) dokłada generator przed ścianą szczytową po stronie taras_strona
# (wzdłuż kalenicy): bok obrysu przesunięty o taras_glebokosc, dawna ściana szczytowa zostaje jako działowa ze
# szczytem (ostatki na zewnątrz), oś kalenicy jak dla domu bez tarasu (ob[:os_kalenicy]). Role ścian:
# w[:taras] = { rola: :front | :dom | :bok, wariant:, … }.
# Wariant podciag (1100): front i ściany boczne nad tarasem tylko w górnych taras_wience_gorne wieńcach ścian bocznych
# i szczyt frontu (rdzen/taras_szczyt.rb); front zaczyna się półbalem (górna połowa bala, spód z_polbal = spód bali ścian
# bocznych) – bale ścian bocznych leżą na wyciętych połówkach bala frontu, naroże na jednym poziomie (wymóg
# użytkownika, runda 7); pod nimi słupy (rdzen/taras_slupy.rb – narożniki frontu, wejście,
# rozstaw najwyżej taras_slupy_rozstaw_max) i balustrada (rdzen/taras_balustrada.rb); dolne bale ścian bocznych kończą
# się ostatkiem taras_ostatek za licem ściany domu. Wariant sciany (1200): ściany boczne pełne do frontu; front – przy
# taras_sciany_front = szczyt (runda 18, P2) górne taras_wience_gorne wieńce nad otworem tarasu (półbalem jak w typie 200,
# w zamkach ścian bocznych) i szczyt (pełny, ażurowy, pusty z wiązarem na balach), przy otwarty – bez bali (zostaje
# w planie dla obrysu dachu, płatwi i połaci; płatwie nad tarasem bez podparcia od frontu).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)
require File.join(File.dirname(__FILE__), 'sciany') unless defined?(ArteMadera::GeneratorWiencowy::Sciany)
require File.join(File.dirname(__FILE__), 'taras_sciany') unless defined?(ArteMadera::GeneratorWiencowy::TarasSciany)

module ArteMadera
  module GeneratorWiencowy
    module Taras
      WARIANTY = %w[podciag sciany].freeze unless const_defined?(:WARIANTY)

      module_function

      # Czy taras jest włączony.
      def wlaczony?(p)
        WARIANTY.include?(p['taras'])
      end

      # Obrys przedłużony o taras (ob z Obrys.rozpoznaj – obrys, działowe, kontrfory w układzie lokalnym): bok obrysu po
      # stronie tarasu przesunięty o głębokość, oś dawnej ściany szczytowej dopisana jako działowa (końce działowych
      # narysowanych do jej lica przeniesione na oś), ob[:os_kalenicy] i ob[:taras]; zwraca ostrzeżenia.
      def przedluz!(ob, p)
        return [] unless wlaczony?(p)
        pts = ob[:obrys]
        return ['Taras: tylko przy obrysie prostokątnym – pominięty.'] unless prostokat?(pts)
        if p['taras'] == 'podciag' && p['dach_rodzaj'] == 'jednospadowy'
          return ['Taras na słupach (typ 200) tylko przy dachu dwuspadowym – pominięty (ściany pełne – typ 300 – działają).']
        end
        os = Sciany.os_kalenicy(pts, p['kalenica'])
        iu = os == :x ? 0 : 1
        iv = 1 - iu
        znak = p['taras_strona'] == 'min' ? -1.0 : 1.0
        us = pts.map { |q| q[iu] }
        u_dom = znak > 0 ? us.max : us.min
        u_front = u_dom + znak * p['taras_glebokosc'].to_f
        t = Parametry.grubosc(p)
        u_os = u_dom - znak * t / 2.0
        ob[:obrys] = pts.map { |q| (q[iu] - u_dom).abs < 0.5 ? punkt_uv(iu, u_front, q[iv]) : q }
        ob[:dzialowe] = ob[:dzialowe].map do |s|
          s.map { |q| (q[iu] - u_dom).abs < t / 2.0 + 0.5 ? punkt_uv(iu, u_os, q[iv]) : q }
        end
        vs = pts.map { |q| q[iv] }
        ob[:dzialowe] << [punkt_uv(iu, u_os, vs.min), punkt_uv(iu, u_os, vs.max)]
        ob[:os_kalenicy] = os
        ob[:taras] = { wariant: p['taras'], os: os, iu: iu, znak: znak, u_dom: u_dom, u_front: u_front }
        []
      end

      # Punkt układu lokalnego z współrzędnych wzdłuż kalenicy (u, indeks iu) i w poprzek (v).
      def punkt_uv(iu, u, v)
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

      # Role ścian tarasu (po ustawieniach ścian, przed szczytami): front, ściana domu, ściany boczne z końcem dolnych
      # bali (s_dol), osiami frontu i ściany domu (s_front, s_dom), kierunkiem do frontu (kier) i spodem podciągu (z_bok
      # – ściany boczne, z_front – front).
      def oznacz!(sciany, info, p)
        return if info.nil?
        t = Parametry.grubosc(p)
        iu = info[:iu]
        u_front = info[:u_front] - info[:znak] * t / 2.0
        u_dom = info[:u_dom] - info[:znak] * t / 2.0
        boki = sciany.select { |w| w[:rodzaj] == :zewnetrzna && w[:os] == info[:os] }
        z_bok = z_podciagu(boki.first, p)
        dane = info.merge(z_bok: z_bok, z_front: z_bok)
        sciany.each do |w|
          next if w[:rodzaj] == :kontrfor || w[:os] == info[:os]
          if w[:rodzaj] == :zewnetrzna && (w[:a][iu] - u_front).abs < 1.0
            w[:taras] = dane.merge(rola: :front)
            w[:taras][:z_polbal] = z_bok if front_z_balami?(w[:taras], p)
          end
          w[:taras] = dane.merge(rola: :dom) if w[:rodzaj] == :dzialowa && (w[:a][iu] - u_dom).abs < 1.0
        end
        boki.each do |w|
          kier = (w[:b][iu] - w[:a][iu]) * info[:znak] > 0 ? 1.0 : -1.0
          s_dom = (u_dom - w[:a][iu]) * w[:kier][iu]
          w[:taras] = dane.merge(rola: :bok, kier: kier, s_dom: s_dom, s_front: (u_front - w[:a][iu]) * w[:kier][iu],
                                 s_dol: s_dom + kier * (t / 2.0 + p['taras_ostatek'].to_f))
        end
      end

      # Czy front tarasu ma bale (podciąg z górnych wieńców i szczyt): typ 200 zawsze, typ 300 – przy taras_sciany_front =
      # szczyt (runda 18, P2: płatwie nad tarasem podparte od frontu); tr – w[:taras] albo opis tarasu z wariantem.
      def front_z_balami?(tr, p)
        return false if tr.nil?
        tr[:wariant] == 'podciag' || (tr[:wariant] == 'sciany' && p['taras_sciany_front'].to_s != 'otwarty')
      end

      # Spód podciągu ścian bocznych – najniższy z górnych taras_wience_gorne wieńców ściany bocznej [mm].
      def z_podciagu(w, p)
        return 0.0 if w.nil?
        kursy = Wience.wlasne(w, p)
        n = [[p['taras_wience_gorne'].to_i, 1].max, kursy.length].min
        kursy[-n][:z0]
      end

      # Rola ściany w tarasie (:front, :dom, :bok) albo nil.
      def rola(w)
        w[:taras] ? w[:taras][:rola] : nil
      end

      # Czy to ściana domu przy tarasie (działowa, która dostaje szczyt).
      def sciana_domu?(w)
        rola(w) == :dom
      end

      # Czy front tarasu (bez węgłów usztywniających – dołem otwarty albo bez bali).
      def front?(w)
        rola(w) == :front
      end

      # Czy odcinek a…b ściany bocznej leży nad tarasem z podciągiem (bez dolnych bali – bez węgłów usztywniających).
      def przeslona_tarasu?(w, a, b)
        tr = w[:taras]
        return false unless tr && tr[:rola] == :bok && tr[:wariant] == 'podciag'
        lo, hi = [tr[:s_dom], tr[:s_front]].sort
        a >= lo - 1.0 && b <= hi + 1.0
      end

      # Opis ściany tarasu do okna (nil – zwykła ściana).
      def opis(w)
        case rola(w)
        when :front then w[:taras][:z_polbal] ? 'front tarasu – podciąg i szczyt' : 'front tarasu – otwarty'
        when :dom then 'ściana domu przy tarasie (ze szczytem)'
        end
      end

      # Zasięg wieńca o spodzie z0 ściany tarasu (zas – zasięg bez tarasu); nil – brak bala w tym wieńcu.
      def zasieg(w, z0, zas, p)
        tr = w[:taras]
        return zas if tr.nil? || zas.nil?
        if TarasSciany.wlaczona?(p) && %i[front bok].include?(tr[:rola]) && z0 < TarasSciany.limit(w) - 0.01
          kurs = Wience.dla_sciany(w, p).find { |k| (k[:z0] - z0).abs < 0.01 }
          r = TarasSciany.zasieg(w, z0, kurs ? kurs[:h] : Parametry.krycie(p), zas, p)
          return r if r
        end
        case tr[:rola]
        when :front
          return nil unless tr[:z_polbal]
          z0 < tr[:z_front] - 0.01 ? nil : zas
        when :bok
          return zas if tr[:wariant] == 'sciany' || z0 >= tr[:z_bok] - 0.01
          lo, hi = zas
          if tr[:kier] > 0
            hi = [hi, tr[:s_dol]].min
          else
            lo = [lo, tr[:s_dol]].max
          end
          hi - lo > 1.0 ? [lo, hi] : nil
        else
          zas
        end
      end

      # Słupy pod frontem (s): narożniki (licem równo z licami ścian bocznych), boki wejścia, słup w osi kalenicy
      # (taras_slup_w_osi – w jednej linii ze słupkiem wiązara nad nim) i pośrednie co najwyżej taras_slupy_rozstaw_max;
      # { slupy:, wejscie: [a, b] osi słupów przy wejściu albo nil, os: s słupa w osi kalenicy albo nil }.
      def slupy_frontu(front, p)
        b = Parametry.przekroj(p, 'taras_slup_przekroj')[0]
        d = [(b - Parametry.grubosc(p)) / 2.0, 0.0].max
        c1 = d
        c2 = front[:dl_osi] - d
        szer = p['taras_wejscie_szerokosc'].to_f + b
        wejscie = case p['taras_wejscie']
                  when 'srodek' then [(c1 + c2 - szer) / 2.0, (c1 + c2 + szer) / 2.0]
                  when 'lewa', 'prawa' then wejscie_z_boku(front, c1, c2, szer, p['taras_wejscie'] == 'lewa')
                  end
        wejscie = nil if wejscie && (wejscie[0] < c1 - 0.01 || wejscie[1] > c2 + 0.01)
        os, wejscie = slup_w_osi(front, p, c1, c2, wejscie)
        stale = ([c1, c2] + (wejscie || []) + (os ? [os] : [])).uniq.sort
        lista = []
        stale.each_cons(2) do |a, z|
          lista << a
          next if wejscie && (a - wejscie[0]).abs < 0.01 && (z - wejscie[1]).abs < 0.01
          lista.concat(posrednie(a, z, p))
        end
        lista << stale.last
        { slupy: lista, wejscie: wejscie, os: os }
      end

      # Ostrzeżenie, gdy słup wejścia stanął w osi kalenicy i wejście ma inną szerokość w świetle niż podana; [] – bez zmian.
      def uwagi_wejscia(sciany, p)
        front = sciany.find { |w| front?(w) && w[:taras][:wariant] == 'podciag' }
        return [] if front.nil?
        sf = slupy_frontu(front, p)
        return [] if sf[:wejscie].nil? || sf[:os].nil? || !sf[:wejscie].include?(sf[:os])
        b = Parametry.przekroj(p, 'taras_slup_przekroj')[0]
        swiatlo = sf[:wejscie][1] - sf[:wejscie][0] - b
        return [] if (swiatlo - p['taras_wejscie_szerokosc'].to_f).abs < 0.5
        [format('Wejście na taras: słup wejścia stoi w osi kalenicy (pod słupkiem trójkąta) – szerokość w świetle %.0f mm ' \
                'zamiast %.0f. Żeby zostawić podaną szerokość, ustaw „Słup w osi – słup wejścia bliżej osi niż tyle staje ' \
                'w osi” na 0.', swiatlo, p['taras_wejscie_szerokosc'].to_f)]
      end

      # Oś kalenicy na froncie (s) – środek osi frontu (dach dwuspadowy nad domem prostokątnym).
      def os_frontu(front)
        front[:dl_osi] / 2.0
      end

      # Słup w osi kalenicy (wymóg użytkownika, runda 11: słup tarasu i słupek wiązara nad nim w jednej linii):
      # [s słupa albo nil, wejście]. Wejście z boku, którego słup stoi bliżej osi niż taras_slup_os_dociag – ten słup
      # staje w osi (wejście szersze albo węższe o tę odległość, zamiast dwóch słupów obok siebie); oś w świetle wejścia
      # (wejście pośrodku albo szerokie) – bez słupa w osi; pozostałe słupy pośrednie równo po obu stronach osi.
      def slup_w_osi(front, p, c1, c2, wejscie)
        return [nil, wejscie] unless Parametry.tak?(p, 'taras_slup_w_osi') && front[:taras][:wariant] == 'podciag'
        sk = os_frontu(front)
        prog = p['taras_slup_os_dociag'].to_f
        return [nil, wejscie] if sk - c1 < prog || c2 - sk < prog
        return [sk, nil] if wejscie.nil?
        if %w[lewa prawa].include?(p['taras_wejscie'])
          i = (wejscie[0] - c1).abs < 0.01 ? 1 : 0
          if (wejscie[i] - sk).abs < prog
            nowe = wejscie.dup
            nowe[i] = sk
            return [sk, nowe]
          end
        end
        return [nil, wejscie] if sk > wejscie[0] + 0.01 && sk < wejscie[1] - 0.01
        [sk, wejscie]
      end

      # Osie słupów przy wejściu z lewej / prawej strony frontu (patrząc na front z zewnątrz).
      def wejscie_z_boku(front, c1, c2, szer, lewa)
        n = [0.0, 0.0]
        n[front[:taras][:iu]] = front[:taras][:znak]
        lewo = [n[1], -n[0]]
        po_lewej_c1 = front[:kier][0] * lewo[0] + front[:kier][1] * lewo[1] < 0
        przy_c1 = lewa == po_lewej_c1
        przy_c1 ? [c1, c1 + szer] : [c2 - szer, c2]
      end

      # Strefy ściany tarasu (s), w których nie może stanąć węgieł – słupy (front i ściany boczne nad tarasem) z zapasem
      # pół grubości ściany i odstępu skrzyżowań: [[lo, hi]].
      def strefy_slupow(w, p)
        tr = w[:taras]
        return [] unless tr && tr[:wariant] == 'podciag' && %i[front bok].include?(tr[:rola])
        b = Parametry.przekroj(p, 'taras_slup_przekroj')[0]
        zapas = b / 2.0 + Parametry.grubosc(p) / 2.0 + p['min_odstep_skrzyzowan'].to_f
        osie = if tr[:rola] == :front
                 slupy_frontu(w, p)[:slupy]
               else
                 lo, hi = [tr[:s_dom], tr[:s_front]].sort
                 posrednie(lo, hi, p) + [tr[:s_front]]
               end
        osie.map { |s| [s - zapas, s + zapas] }
      end

      # Węgły (z rysunku, ręczne, z tabeli) w strefie słupa tarasu usunięte – słup stoi w ich miejscu; zwraca ostrzeżenia.
      def wegly_przy_slupach!(sciany, p)
        uwagi = []
        sciany.select { |w| w[:rodzaj] == :kontrfor }.each do |kf|
          g = kf[:gospodarz]
          k = g[:skrzyzowania].find { |x| x[:inna].equal?(kf) }
          next if k.nil? || strefy_slupow(g, p).none? { |z| k[:s] > z[0] && k[:s] < z[1] }
          sciany.delete(kf)
          g[:skrzyzowania].delete(k)
          uwagi << format('Ściana %s: węgieł w %.0f mm stoi w miejscu słupa tarasu – pominięty.', g[:id], k[:s])
        end
        uwagi
      end

      # Słupy pośrednie między osiami a…z (równo, rozstaw nie większy niż taras_slupy_rozstaw_max).
      def posrednie(a, z, p)
        n = ((z - a) / p['taras_slupy_rozstaw_max'].to_f - 1e-9).ceil
        (1...n).map { |i| a + (z - a) * i / n }
      end

      # Przęsła balustrady [[ściana, a, b]] (s między licami słupów, ściany domu i dolnych bali): ściany boczne – od końca
      # dolnych bali do słupa narożnego (podzielone słupami pośrednimi), front – między słupami poza wejściem.
      def przesla(sciany, p)
        front = sciany.find { |w| front?(w) }
        return [] if front.nil? || front[:taras][:wariant] != 'podciag' || TarasSciany.wlaczona?(p)
        b, g = Parametry.przekroj(p, 'taras_slup_przekroj')
        wynik = []
        sf = slupy_frontu(front, p)
        sf[:slupy].each_cons(2) do |a, z|
          next if sf[:wejscie] && (a - sf[:wejscie][0]).abs < 0.01 && (z - sf[:wejscie][1]).abs < 0.01
          wynik << [front, a + b / 2.0, z - b / 2.0]
        end
        sciany.select { |w| rola(w) == :bok }.each do |w|
          tr = w[:taras]
          naroznik = tr[:s_front] - tr[:kier] * (g - Parametry.grubosc(p) / 2.0)
          lo, hi = [tr[:s_dom], tr[:s_front]].sort
          granice = ([tr[:s_dol], naroznik] + posrednie(lo, hi, p).flat_map { |s| [s - b / 2.0, s + b / 2.0] }).sort
          granice.each_slice(2) { |a, z| wynik << [w, a, z] if z && z - a > 1.0 }
        end
        wynik
      end
    end
  end
end
