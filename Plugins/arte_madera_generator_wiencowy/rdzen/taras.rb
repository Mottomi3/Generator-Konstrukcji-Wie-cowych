# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/taras.rb
# Zadanie: taras przed ścianą szczytową domu prostokątnego – obrys przedłużony o głębokość tarasu, ściana domu jako działowa ze szczytem, wariant 1100 (górne wieńce ścian nad tarasem jako podciąg na słupach) albo 1200 (ściany boczne pełne, front otwarty), słupy tarasu.
# Tematy: taras, wariant 1100, wariant 1200, podciąg z bali, słupy tarasu, front tarasu, ściana domu przy tarasie, głębokość tarasu, wejście na taras, ostatek przy tarasie, przęsła balustrady
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb, rdzen/elementy.rb, rdzen/sciany.rb (oś kalenicy)
# Używają: rdzen/projekt.rb, rdzen/sciany.rb (opis ściany), rdzen/szczyty.rb (szczyt ściany domu), rdzen/bale.rb (zasięg wieńca), rdzen/usztywnienie.rb, rdzen/taras_balustrada.rb
#
# Narysowany obrys = dom. Taras (parametr taras) dokłada generator przed ścianą szczytową po stronie taras_strona
# (wzdłuż kalenicy): bok obrysu przesunięty o taras_glebokosc, dawna ściana szczytowa zostaje jako działowa ze
# szczytem (ostatki na zewnątrz), oś kalenicy jak dla domu bez tarasu (ob[:os_kalenicy]). Role ścian:
# w[:taras] = { rola: :front | :dom | :bok, wariant:, … }.
# Wariant podciag (1100): front i ściany boczne nad tarasem tylko w górnych taras_wience_gorne wieńcach ścian bocznych
# (front od wieńca, który zamyka się z nimi w narożniku) i szczyt frontu; pod nimi słupy (narożniki frontu, wejście,
# rozstaw najwyżej taras_slupy_rozstaw_max) i balustrada (rdzen/taras_balustrada.rb); dolne bale ścian bocznych kończą
# się ostatkiem taras_ostatek za licem ściany domu. Wariant sciany (1200): ściany boczne pełne do frontu, front bez
# bali – zostaje w planie dla obrysu dachu, płatwi i połaci.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)
require File.join(File.dirname(__FILE__), 'sciany') unless defined?(ArteMadera::GeneratorWiencowy::Sciany)

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
          return ['Taras z podciągiem (jak 1100) tylko przy dachu dwuspadowym – pominięty (ściany pełne – jak 1200 – działają).']
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
        dane = info.merge(z_bok: z_bok, z_front: z_bok - Parametry.krycie(p) / 2.0)
        sciany.each do |w|
          next if w[:rodzaj] == :kontrfor || w[:os] == info[:os]
          w[:taras] = dane.merge(rola: :front) if w[:rodzaj] == :zewnetrzna && (w[:a][iu] - u_front).abs < 1.0
          w[:taras] = dane.merge(rola: :dom) if w[:rodzaj] == :dzialowa && (w[:a][iu] - u_dom).abs < 1.0
        end
        boki.each do |w|
          kier = (w[:b][iu] - w[:a][iu]) * info[:znak] > 0 ? 1.0 : -1.0
          s_dom = (u_dom - w[:a][iu]) * w[:kier][iu]
          w[:taras] = dane.merge(rola: :bok, kier: kier, s_dom: s_dom, s_front: (u_front - w[:a][iu]) * w[:kier][iu],
                                 s_dol: s_dom + kier * (t / 2.0 + p['taras_ostatek'].to_f))
        end
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
        when :front then w[:taras][:wariant] == 'sciany' ? 'front tarasu – otwarty' : 'front tarasu – podciąg i szczyt'
        when :dom then 'ściana domu przy tarasie (ze szczytem)'
        end
      end

      # Zasięg wieńca o spodzie z0 ściany tarasu (zas – zasięg bez tarasu); nil – brak bala w tym wieńcu.
      def zasieg(w, z0, zas, p)
        tr = w[:taras]
        return zas if tr.nil? || zas.nil?
        case tr[:rola]
        when :front
          return nil if tr[:wariant] == 'sciany'
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

      # Słupy pod frontem (s): narożniki, boki wejścia, pośrednie co najwyżej taras_slupy_rozstaw_max; { slupy:, wejscie:
      # [a, b] osi słupów przy wejściu albo nil }.
      def slupy_frontu(front, p)
        b = Parametry.przekroj(p, 'taras_slup_przekroj')[0]
        c1 = 0.0
        c2 = front[:dl_osi]
        szer = p['taras_wejscie_szerokosc'].to_f + b
        wejscie = case p['taras_wejscie']
                  when 'srodek' then [(c1 + c2 - szer) / 2.0, (c1 + c2 + szer) / 2.0]
                  when 'lewa', 'prawa' then wejscie_z_boku(front, c1, c2, szer, p['taras_wejscie'] == 'lewa')
                  end
        wejscie = nil if wejscie && (wejscie[0] < c1 - 0.01 || wejscie[1] > c2 + 0.01)
        stale = ([c1, c2] + (wejscie || [])).uniq.sort
        lista = []
        stale.each_cons(2) do |a, z|
          lista << a
          next if wejscie && (a - wejscie[0]).abs < 0.01 && (z - wejscie[1]).abs < 0.01
          lista.concat(posrednie(a, z, p))
        end
        lista << stale.last
        { slupy: lista, wejscie: wejscie }
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

      # Słupy pośrednie między osiami a…z (równo, rozstaw nie większy niż taras_slupy_rozstaw_max).
      def posrednie(a, z, p)
        n = ((z - a) / p['taras_slupy_rozstaw_max'].to_f - 1e-9).ceil
        (1...n).map { |i| a + (z - a) * i / n }
      end

      # Słupy tarasu z podciągiem (elementy S): pod frontem i pośrednie pod ścianami bocznymi; od poziomu 0 do spodu
      # podciągu (front – z_front, ściany boczne – z_bok); przekrój b wzdłuż ściany, nad którą stoi słup.
      def slupy(sciany, p)
        front = sciany.find { |w| front?(w) }
        return [] if front.nil? || front[:taras][:wariant] != 'podciag'
        b, g = Parametry.przekroj(p, 'taras_slup_przekroj')
        wynik = slupy_frontu(front, p)[:slupy].map { |s| slup(front, s, b, g, front[:taras][:z_front]) }
        sciany.select { |w| rola(w) == :bok }.each do |w|
          tr = w[:taras]
          lo, hi = [tr[:s_dom], tr[:s_front]].sort
          posrednie(lo, hi, p).each { |s| wynik << slup(w, s, b, g, tr[:z_bok]) }
        end
        wynik
      end

      # Słup w osi ściany w w miejscu s: przekrój b (wzdłuż ściany) × g, od poziomu 0 do wysokości h.
      def slup(w, s, b, g, h)
        c = [w[:a][0] + w[:kier][0] * s, w[:a][1] + w[:kier][1] * s]
        y = [w[:kier][0], w[:kier][1], 0.0]
        z = [-w[:kier][1], w[:kier][0], 0.0]
        o = [c[0] - y[0] * b / 2.0 - z[0] * g / 2.0, c[1] - y[1] * b / 2.0 - z[1] * g / 2.0, 0.0]
        Elementy.nowy('S', h, b, g, o, [0.0, 0.0, 1.0], y, z, [])
      end

      # Przęsła balustrady [[ściana, a, b]] (s między licami słupów, ściany domu i dolnych bali): ściany boczne – od końca
      # dolnych bali do słupa narożnego (podzielone słupami pośrednimi), front – między słupami poza wejściem.
      def przesla(sciany, p)
        front = sciany.find { |w| front?(w) }
        return [] if front.nil? || front[:taras][:wariant] != 'podciag'
        b, g = Parametry.przekroj(p, 'taras_slup_przekroj')
        wynik = []
        sf = slupy_frontu(front, p)
        sf[:slupy].each_cons(2) do |a, z|
          next if sf[:wejscie] && (a - sf[:wejscie][0]).abs < 0.01 && (z - sf[:wejscie][1]).abs < 0.01
          wynik << [front, a + b / 2.0, z - b / 2.0]
        end
        sciany.select { |w| rola(w) == :bok }.each do |w|
          tr = w[:taras]
          naroznik = tr[:s_front] - tr[:kier] * g / 2.0
          lo, hi = [tr[:s_dom], tr[:s_front]].sort
          granice = ([tr[:s_dol], naroznik] + posrednie(lo, hi, p).flat_map { |s| [s - b / 2.0, s + b / 2.0] }).sort
          granice.each_slice(2) { |a, z| wynik << [w, a, z] if z && z - a > 1.0 }
        end
        wynik
      end
    end
  end
end
