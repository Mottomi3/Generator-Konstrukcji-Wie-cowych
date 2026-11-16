# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/taras_wiazar.rb
# Zadanie: wiązar (trójkąt) nad pustym szczytem frontu tarasu – dwie ciągłe krokwie wiązara pod płatwiami (płatwie leżą na nich w płytkich gniazdach – zamkach), belka dolna, słupek pod kalenicą i opcjonalnie dwa zastrzały od stopy słupka pod zadanym kątem (45°); licem z licem zewnętrznym frontu; na balach frontu albo na słupach bez bali; wręby płatwi na grubości wiązara.
# Tematy: wiązar szczytu tarasu, trójkąt nad tarasem, trójkąt w wąskim domu, wiązar bez belki dolnej, krokiew wiązara, belka dolna wiązara, słupek wiązara, zastrzał, kąt zastrzału, wiązar pod płatwiami, głębokość gniazda płatwi w wiązarze, gniazda płatwi w wiązarze, wiązar licem z frontem, szczyt bez bali, przekrój członu wiązara, przekrój słupka i zastrzałów wiązara
# Zależy od: rdzen/statyka_wiazara.rb (tylko wynik doboru w parametrach – p['taras_wieniec_dobrany']), rdzen/parametry.rb, rdzen/dach.rb (linia szczytu, płatwie), rdzen/elementy.rb (belka), rdzen/zamek_platwi.rb (gniazdo pod wrąb płatwi), rdzen/taras_szczyt.rb (czy szczyt pusty z wiązarem)
# Używają: rdzen/projekt.rb (przejścia płatwi przed belkami dachu, człony wiązara, ostrzeżenie o zastrzałach), rdzen/taras_slupy.rb (grubość lica frontu bez bali), rdzen/taras_szczyt.rb (bez bali frontu)
#
# Wiązar leży w płaszczyźnie frontu (v w poprzek kalenicy, z w górę), grubość (wzdłuż kalenicy) z przekroju płatwi albo
# podanego, lico zewnętrzne równo z licem zewnętrznym frontu (wymóg użytkownika, runda 9). Człon = obszar między linią
# spodu B(v) (maksimum prostych) i wierzchu T(v) (minimum prostych) na odcinku v. Wiązar podpiera płatwie od spodu
# (wymóg użytkownika, runda 10): wierzch krokwi wiązara jest równoległy do linii dachu i obniżony tak, że każda płatew
# leży w gnieździe (zamku) o głębokości co najmniej taras_wiazar_gniazdo przy niższej krawędzi – krokwie są ciągłe,
# gniazda (szerokość płatwi w wrębie, dno na spodzie wrębu) nie przecinają ich; płatew ma wrąb na grubości wiązara. Belka dolna: na balach frontu (wierzch najwyższego bala) albo – bez bali (szczyt bez bala,
# z przodu sam trójkąt) – na słupach frontu, od spodu podciągu, między licami wewnętrznymi ścian bocznych. Krokwie leżą
# na belce dolnej (pięta krokwi do wierzchu belki), słupek od belki do spodu krokwi, zastrzały od stopy słupka do spodu
# krokwi pod kątem taras_wiazar_zastrzal_kat od poziomu (45°; 0 – do połowy krokwi). Człony prefiks Wt (graniastosłupy wzdłuż kalenicy, przekrój w płaszczyźnie frontu).
# Słupek i zastrzały (wymóg użytkownika, runda 11 – do wyboru, taras_wiazar_przekroje): własne szerokości (smuklejsze,
# ładniejsze przy małych konstrukcjach) albo dokładnie jak reszta trójkąta – wysokość przekroju wiązara (np. płatwi).
# Zamek płatwi tylko od spodu (taras_platwa_zamek = spod): gniazdo w krokwi wiązara na pełną szerokość płatwi.
# Wąski dom albo wysoki przekrój (uwaga użytkownika z 2026-11-16: „przy bardzo wąskich konstrukcjach nie buduje trójkąta”):
# gdy belka dolna z krokwiami nie mieści się pod dachem, trójkąt powstaje w postaci uproszczonej (postac) – same krokwie
# stojące na balach frontu (ze słupkiem, jeśli jest na niego miejsce) albo, przy wiązarze na słupach, sama belka dolna
# ścięta dachem – z ostrzeżeniem; nigdy nie znika bez słowa.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)
require File.join(File.dirname(__FILE__), 'zamek_platwi') unless defined?(ArteMadera::GeneratorWiencowy::ZamekPlatwi)
require File.join(File.dirname(__FILE__), 'taras_szczyt') unless defined?(ArteMadera::GeneratorWiencowy::TarasSzczyt)

module ArteMadera
  module GeneratorWiencowy
    module TarasWiazar
      # Najmniej drewna pod gniazdem płatwi w członie [mm]; mniej – człon przecięty gniazdem.
      MIN_DREWNO = 10.0 unless const_defined?(:MIN_DREWNO)
      # Najmniejsza wysokość trójkąta nad oparciem [mm] – niższy nie powstaje.
      MIN_TROJKAT = 60.0 unless const_defined?(:MIN_TROJKAT)
      # Najniższy słupek wiązara bez belki dolnej (przy jego licu) [mm].
      MIN_SLUPEK = 80.0 unless const_defined?(:MIN_SLUPEK)
      EPS = 1e-6 unless const_defined?(:EPS)

      module_function

      # Front tarasu z wiązarem (szczyt pusty z trójkątem) albo nil.
      def front(sciany, p)
        return nil unless TarasSzczyt.wieniec?(p)
        sciany.find { |w| TarasSzczyt.dotyczy?(w, p) }
      end

      # Przekrój członów wiązara [szerokość wzdłuż kalenicy, wysokość krokwi i belki]: płatwi, podany albo – taras_wieniec
      # = auto – dobrany do obciążenia (rdzen/statyka_wiazara.rb zapisuje go w p['taras_wieniec_dobrany']; w pierwszym
      # przebiegu obliczeń, zanim jest dobrany – przekrój płatwi).
      def przekroj(p)
        dobrany = p['taras_wieniec'] == 'auto' ? Parametry.przekroj_z(p['taras_wieniec_dobrany']) : nil
        dobrany || Parametry.przekroj(p, p['taras_wieniec'] == 'wlasny' ? 'taras_wieniec_przekroj' : 'platwa_przekroj')
      end

      # Szerokość słupka albo zastrzału w płaszczyźnie frontu [mm] (klucz – pole własnej szerokości): własna albo – przy
      # taras_wiazar_przekroje = jak_wiazar – wysokość przekroju wiązara (cały trójkąt z jednego przekroju, np. płatwi).
      def szerokosc_czlonu(p, klucz)
        return przekroj(p)[1] if p['taras_wiazar_przekroje'] == 'jak_wiazar'
        p[klucz].to_f
      end

      # Grubość lica frontu przy słupach tarasu [mm]: wiązar bez bali – grubość wiązara, inaczej grubość ściany.
      def grubosc_lica(w, p)
        return Parametry.grubosc(p) unless TarasSzczyt.bez_bali?(w, p)
        przekroj(p)[0]
      end

      # Układ wiązara: { os:, iu:, u_c: (oś grubości), bw:, hw:, hv: (wysokość krokwi w pionie), geo:, vk:, zk: (linia
      # szczytu w kalenicy), tg:, v_lo:, v_hi:, z_b0: (spód belki dolnej), z_b1: (wierzch), bok: (wrąb boczny płatwi
      # w wiązarze – 0 przy zamku tylko od spodu), bez: (wiązar na słupach – bez bali frontu) }; nil – brak miejsca.
      def uklad(w, p)
        t = Parametry.grubosc(p)
        tr = w[:taras]
        bw, hw = przekroj(p)
        iu = tr[:iu]
        geo = w[:szczyt]
        bez = TarasSzczyt.bez_bali?(w, p)
        if bez
          z_b0 = tr[:z_front]
          v_lo = geo[:v_a] + t / 2.0
          v_hi = geo[:v_b] - t / 2.0
        else
          return nil if w[:bale].empty?
          z_b0 = w[:bale].map { |b| b[:z0] + b[:h] }.max
          v_lo = geo[:v_a] - t / 2.0
          v_hi = geo[:v_b] + t / 2.0
        end
        vk = (geo[:v_a] + geo[:v_b]) / 2.0
        bok = ZamekPlatwi.bok_w_scianie(w, p)
        { os: iu.zero? ? :x : :y, iu: iu, u_c: w[:a][iu] + tr[:znak] * (t / 2.0 - bw / 2.0), bw: bw, hw: hw,
          hv: hw / Math.cos(Dach.kat(p)), geo: geo, vk: vk, zk: Dach.linia_szczytu(geo, vk, p) - pod_platwiami(geo, p, bok),
          tg: Dach.tg(p), v_lo: v_lo, v_hi: v_hi, z_b0: z_b0, z_b1: z_b0 + hw, bok: bok, bez: bez }
      end

      # Postać wiązara: :pelny – belka dolna, krokwie, słupek (zastrzały); :krokwie – belka dolna z krokwiami nie mieści
      # się pod dachem (wąski dom, wysoki przekrój): same krokwie na balach frontu; :belka – to samo przy wiązarze na
      # słupach: sama belka dolna ścięta dachem; nil – trójkąt niższy niż MIN_TROJKAT.
      def postac(u)
        return :pelny if u[:zk] - u[:hv] > u[:z_b1] + 1.0
        return nil if u[:zk] - u[:z_b0] < MIN_TROJKAT
        u[:bez] ? :belka : :krokwie
      end

      # O ile wierzch krokwi wiązara jest pod linią dachu [mm]: tak, żeby dno gniazda każdej płatwi (spód jej wrębu) było
      # przy niższej krawędzi gniazda co najmniej taras_wiazar_gniazdo pod wierzchem krokwi – płatwie leżą na wiązarze,
      # krokwie wiązara zostają ciągłe; bok – wrąb boczny płatwi w wiązarze (nil – z parametrów).
      def pod_platwiami(geo, p, bok = nil)
        vk = (geo[:v_a] + geo[:v_b]) / 2.0
        zapas = Dach.platwie(geo, p).map do |pl|
          b2 = ZamekPlatwi.szerokosc_w_scianie(pl[:b], p, bok) / 2.0
          v_niska = pl[:v] <= vk ? pl[:v] - b2 : pl[:v] + b2
          Dach.linia_szczytu(geo, v_niska, p) - ZamekPlatwi.spod_w_scianie(pl[:z_spod], p)
        end.min
        zapas.nil? ? 0.0 : [zapas - p['taras_wiazar_gniazdo'].to_f, 0.0].max
      end

      # Przejścia płatwi przez wiązar (dom[:przejscia] z grubością t – wręby płatwi na grubości wiązara, bok – wrąb
      # boczny: 0 przy zamku tylko od spodu); przed belkami dachu (Dach.elementy).
      def przejscia!(sciany, dom, p)
        w = front(sciany, p)
        return if w.nil? || dom.nil?
        u = uklad(w, p)
        return if u.nil?
        dom[:przejscia] ||= []
        Dach.platwie(Dach.geo(dom), p).each do |pl|
          przejscie = { v: pl[:v], u: u[:u_c], t: u[:bw] }
          przejscie[:bok] = u[:bok] if ZamekPlatwi.tylko_spod?(w, p)
          dom[:przejscia] << przejscie
        end
      end

      # Człony wiązara (elementy Wt); brak wiązara – [].
      def elementy(sciany, p)
        w = front(sciany, p)
        return [] if w.nil?
        u = uklad(w, p)
        return [] if u.nil? || postac(u).nil?
        gniazda = gniazda_platwi(u, p)
        min = p['min_odcinek'].to_f
        ksztalty = czlony(u, p).flat_map do |c|
          czesci = wielokaty(c, gniazda)
          # Człon przecięty gniazdem: okruchy krótsze niż najkrótszy kawałek pominięte (np. pięta krokwi za płatwią przy okapie).
          czesci.length > 1 ? czesci.select { |k| k.map { |v, _z| v }.minmax.reverse.inject(:-) >= min - 0.01 } : czesci
        end
        ksztalty.map { |ksztalt| belka(u, ksztalt) }
      end

      # Ostrzeżenia: trójkąt w postaci uproszczonej albo wcale (za niski – wąski dom, wysoki przekrój), wybrane zastrzały
      # się nie mieszczą (wiązar powstaje bez nich); [] – w porządku.
      def uwagi(sciany, p)
        w = front(sciany, p)
        u = w.nil? ? nil : uklad(w, p)
        return [] if u.nil?
        bw, hw = przekroj(p)
        opis = format('przekrój %.0f × %.0f jest za wysoki na ten trójkąt (wąski dom albo mały kąt dachu)', bw, hw)
        rada = 'Mniejszy przekrój zmieści cały trójkąt – wybierz w sekcji „Taras”: „Trójkąt z przekroju – dobranego automatycznie”.'
        case postac(u)
        when nil then ["Trójkąt nad tarasem nie powstał: #{opis}. #{rada}"]
        when :krokwie then ["Trójkąt nad tarasem bez belki dolnej – krokwie stoją na balach frontu: #{opis}. #{rada}"]
        when :belka then ["Trójkąt nad tarasem – sama belka na słupach, ścięta dachem: #{opis}. #{rada}"]
        else
          return [] unless p['taras_wiazar'] == 'zastrzaly' && czlony(u, p).length <= 4
          ['Trójkąt nad tarasem: zastrzały się nie mieszczą (za mały trójkąt albo za szeroki słupek i zastrzały) – pominięte.']
        end
      end

      # Gniazda płatwi w płaszczyźnie wiązara: [[v0, v1, z_dna]] (szerokość płatwi w wrębie – przy zamku tylko od spodu
      # pełna szerokość płatwi, dno na spodzie wrębu).
      def gniazda_platwi(u, p)
        Dach.platwie(u[:geo], p).map do |pl|
          b2 = ZamekPlatwi.szerokosc_w_scianie(pl[:b], p, u[:bok]) / 2.0
          [pl[:v] - b2, pl[:v] + b2, ZamekPlatwi.spod_w_scianie(pl[:z_spod], p)]
        end
      end

      # Człony w postaci { v0:, v1:, gora: [[a, b]], dol: [[a, b]] } (proste z = a + b·v): krokwie, belka dolna, słupek,
      # zastrzały (rodzaj taras_wiazar); postać uproszczona (postac) – same krokwie na balach frontu ze słupkiem, gdy się
      # mieści, albo sama belka dolna.
      def czlony(u, p)
        vk = u[:vk]
        zl = [u[:zk] - u[:tg] * vk, u[:tg]]
        zr = [u[:zk] + u[:tg] * vk, -u[:tg]]
        spod_l = [zl[0] - u[:hv], zl[1]]
        spod_r = [zr[0] - u[:hv], zr[1]]
        b1 = [u[:z_b1], 0.0]
        a = szerokosc_czlonu(p, 'taras_wiazar_slupek') / 2.0
        ksztalt = postac(u)
        return [{ v0: u[:v_lo], v1: u[:v_hi], gora: [b1, zl, zr], dol: [[u[:z_b0], 0.0]] }] if ksztalt == :belka
        return krokwie_na_balach(u, zl, zr, spod_l, spod_r, a) if ksztalt == :krokwie
        lista = [
          { v0: u[:v_lo], v1: vk, gora: [zl], dol: [spod_l, b1] },
          { v0: vk, v1: u[:v_hi], gora: [zr], dol: [spod_r, b1] },
          { v0: u[:v_lo], v1: u[:v_hi], gora: [b1, zl, zr], dol: [[u[:z_b0], 0.0]] },
          { v0: vk - a, v1: vk + a, gora: [spod_l, spod_r], dol: [b1] }
        ]
        lista.concat(zastrzaly(u, p, spod_l, spod_r, a)) if p['taras_wiazar'] == 'zastrzaly'
        lista
      end

      # Wiązar bez belki dolnej: dwie krokwie od wierzchu bali frontu do kalenicy (stopy ścięte poziomo na balach) i słupek
      # od bali do krokwi, gdy przy jego licu zostaje co najmniej MIN_SLUPEK wysokości.
      def krokwie_na_balach(u, zl, zr, spod_l, spod_r, a)
        vk = u[:vk]
        b0 = [u[:z_b0], 0.0]
        lista = [{ v0: u[:v_lo], v1: vk, gora: [zl], dol: [spod_l, b0] }, { v0: vk, v1: u[:v_hi], gora: [zr], dol: [spod_r, b0] }]
        if u[:zk] - u[:hv] - u[:tg] * a - u[:z_b0] >= MIN_SLUPEK
          lista << { v0: vk - a, v1: vk + a, gora: [spod_l, spod_r], dol: [b0] }
        end
        lista
      end

      # Dwa zastrzały: oś od stopy słupka (lico słupka na wierzchu belki dolnej) do spodu krokwi pod kątem
      # taras_wiazar_zastrzal_kat od poziomu (wymóg użytkownika, runda 10: 45° – podparcie krokwi i ozdoba); kąt 0 albo nie
      # większy niż kąt dachu – do połowy wolnego spodu krokwi; szerokość taras_wiazar_zastrzal albo jak wiązar
      # (szerokosc_czlonu); [] – za mało miejsca.
      def zastrzaly(u, p, spod_l, spod_r, a)
        ws = szerokosc_czlonu(p, 'taras_wiazar_zastrzal')
        vk = u[:vk]
        z1 = u[:z_b1]
        v2 = (z1 - spod_l[0]) / spod_l[1]
        c = vk - a
        return [] if c - v2 < 2.0 * ws
        vm = (v2 + c) / 2.0
        zm = spod_l[0] + spod_l[1] * vm
        k = (zm - z1) / (vm - c)
        kat = p['taras_wiazar_zastrzal_kat'].to_f
        k = -Math.tan(kat * Math::PI / 180.0) if kat > 0.0 && Math.tan(kat * Math::PI / 180.0) > u[:tg] + 0.05
        # Koniec osi zastrzału na spodzie krokwi; zastrzał krótszy niż dwie szerokości albo poza krokwią – bez zastrzałów.
        v_k = (z1 - k * c - spod_l[0]) / (spod_l[1] - k)
        return [] if v_k < v2 || (c - v_k) * Math.sqrt(1.0 + k * k) < 2.0 * ws
        dz = ws / 2.0 * Math.sqrt(1.0 + k * k)
        os_l = [z1 - k * c, k]
        lewy = { v0: v2, v1: c, gora: [[os_l[0] + dz, k], spod_l], dol: [[os_l[0] - dz, k], [z1, 0.0]] }
        cp = vk + a
        os_p = [z1 + k * cp, -k]
        prawy = { v0: cp, v1: 2.0 * vk - v2, gora: [[os_p[0] + dz, -k], spod_r], dol: [[os_p[0] - dz, -k], [z1, 0.0]] }
        [lewy, prawy]
      end

      # Wartość minimum (gora) albo maksimum (dol) prostych w v.
      def wartosc(proste, v, min)
        z = proste.map { |a, b| a + b * v }
        min ? z.min : z.max
      end

      # Wielokąty członu (lista punktów [v, z]) – obszar B ≤ z ≤ T na odcinku v0…v1 z gniazdami płatwi w wierzchu; gniazdo,
      # pod którym zostaje mniej niż MIN_DREWNO, przecina człon na części.
      def wielokaty(c, gniazda)
        przedzialy = [[c[:v0], c[:v1]]]
        gniazda.each do |g0, g1, zg|
          przedzialy = przedzialy.flat_map do |x0, x1|
            next [[x0, x1]] if g1 <= x0 + EPS || g0 >= x1 - EPS
            dol_max = [[g0, x0].max, [g1, x1].min].map { |v| wartosc(c[:dol], v, false) }.max
            next [[x0, x1]] if zg > dol_max + MIN_DREWNO
            [[x0, [g0, x0].max], [[g1, x1].min, x1]].select { |a, b| b - a > 1.0 }
          end
        end
        przedzialy.map { |x0, x1| obrys(c, x0, x1, gniazda) }.compact
      end

      # Punkty v podziału: końce, przecięcia prostych, krawędzie gniazd w x0…x1.
      def punkty(c, x0, x1, gniazda)
        proste = c[:gora] + c[:dol]
        vs = [x0, x1]
        proste.combination(2).each do |(a1, b1), (a2, b2)|
          next if (b1 - b2).abs < EPS
          v = (a2 - a1) / (b1 - b2)
          vs << v if v > x0 + EPS && v < x1 - EPS
        end
        gniazda.each { |g0, g1, _z| [g0, g1].each { |v| vs << v if v > x0 + EPS && v < x1 - EPS } }
        vs.sort.each_with_object([]) { |v, acc| acc << v if acc.empty? || v - acc.last > 1e-4 }
      end

      # Obrys części członu x0…x1: zakres, gdzie T > B, spód od lewej, wierzch (z gniazdami) od prawej; nil – pusty.
      def obrys(c, x0, x1, gniazda)
        vs = punkty(c, x0, x1, gniazda)
        roznica = lambda { |v| wartosc(c[:gora], v, true) - wartosc(c[:dol], v, false) }
        lo = zakres(vs, roznica, true)
        hi = zakres(vs, roznica, false)
        return nil if lo.nil? || hi.nil? || hi - lo < 1.0
        vs = ([lo, hi] + vs.select { |v| v > lo + EPS && v < hi - EPS }).sort
        dol = vs.map { |v| [v, wartosc(c[:dol], v, false)] }
        gora = []
        vs.reverse.each do |v|
          gora << [v, wierzch(c, v, gniazda, 1)]
          lewy = wierzch(c, v, gniazda, -1)
          gora << [v, lewy] if (lewy - gora.last[1]).abs > 1e-4
        end
        gora.each { |q| q[1] = [q[1], wartosc(c[:dol], q[0], false)].max }
        uprosc(dol + gora)
      end

      # Skrajny v (od lewej – lewy = true, od prawej – false), w którym człon ma grubość (T > B), z interpolacją.
      def zakres(vs, roznica, lewy)
        lista = lewy ? vs : vs.reverse
        poprz = nil
        lista.each do |v|
          d = roznica.call(v)
          if d > 1e-3
            return v if poprz.nil? || poprz[1] > 1e-3
            return poprz[0] + (v - poprz[0]) * (-poprz[1]) / (d - poprz[1])
          end
          poprz = [v, d]
        end
        nil
      end

      # Wierzch członu w v po stronie strona (+1 – z prawej, −1 – z lewej krawędzi gniazda): T albo dno gniazda.
      def wierzch(c, v, gniazda, strona)
        z = wartosc(c[:gora], v, true)
        x = v + strona * 1e-3
        gniazda.each { |g0, g1, zg| z = [z, zg].min if x > g0 && x < g1 }
        z
      end

      # Wielokąt bez powtórzonych i współliniowych punktów; nil – mniej niż 3 punkty.
      def uprosc(pts)
        q = []
        pts.each { |pt| q << pt if q.empty? || (pt[0] - q.last[0]).abs > 1e-4 || (pt[1] - q.last[1]).abs > 1e-4 }
        q.pop while q.length > 1 && (q.last[0] - q.first[0]).abs <= 1e-4 && (q.last[1] - q.first[1]).abs <= 1e-4
        zmiana = true
        while zmiana && q.length > 3
          zmiana = false
          q.each_index do |i|
            a = q[i - 1]
            b = q[i]
            d = q[(i + 1) % q.length]
            next unless ((b[0] - a[0]) * (d[1] - a[1]) - (b[1] - a[1]) * (d[0] - a[0])).abs < 1e-3
            q.delete_at(i)
            zmiana = true
            break
          end
        end
        q.length >= 3 ? q : nil
      end

      # Człon Wt: graniastosłup wzdłuż kalenicy (od u_c − bw/2 do u_c + bw/2) o przekroju ksztalt ([v, z] w płaszczyźnie
      # frontu) – przekrój w układzie belki (y wzdłuż v jak w Elementy.pozioma, z od spodu członu).
      def belka(u, ksztalt)
        v_lo, v_hi = ksztalt.map { |v, _z| v }.minmax
        z0, z1 = ksztalt.map { |_v, z| z }.minmax
        vc = (v_lo + v_hi) / 2.0
        p0 = u[:os] == :x ? [u[:u_c] - u[:bw] / 2.0, vc] : [vc, u[:u_c] - u[:bw] / 2.0]
        p1 = u[:os] == :x ? [u[:u_c] + u[:bw] / 2.0, vc] : [vc, u[:u_c] + u[:bw] / 2.0]
        znak = u[:os] == :x ? 1.0 : -1.0
        szer = v_hi - v_lo
        przekroj = ksztalt.map { |v, z| [szer / 2.0 + znak * (v - vc), z - z0] }
        przekroj.reverse! if pole(przekroj) < 0.0
        Elementy.pozioma('Wt', p0, p1, szer, z1 - z0, z0, :os, [], przekroj)
      end

      # Pole wielokąta [[y, z]] ze znakiem (dodatnie – przeciwnie do wskazówek).
      def pole(pts)
        pts.each_with_index.inject(0.0) do |s, (a, i)|
          b = pts[(i + 1) % pts.length]
          s + a[0] * b[1] - b[0] * a[1]
        end / 2.0
      end
    end
  end
end
