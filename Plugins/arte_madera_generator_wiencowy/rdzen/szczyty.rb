# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/szczyty.rb
# Zadanie: szczyty z bali – które ściany mają szczyt, wieńce szczytu do kalenicy, skos bali wg linii dachu, gniazda pod płatwie.
# Tematy: szczyt, ściana szczytowa, bal szczytowy, skos bala, gniazdo płatwi, płatew przez szczyt, szczyt na działowej, wysokość szczytu, prefiks Sz, szczyt skośny (jednospadowy), szczyt płaski ściany wysokiej, zasięg pod linią dachu, załom linii szczytu
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb, rdzen/dach.rb (linia szczytu, płatwie), rdzen/dach_jednospadowy.rb (ściana wysoka), rdzen/taras.rb (szczyt ściany domu przy tarasie)
# Używają: rdzen/projekt.rb, rdzen/wience.rb (liczba wieńców szczytu), rdzen/bale.rb (zasięg i skos bali), rdzen/pozycje.rb (prefiks Sz)
#
# Szczyt ściany (w[:szczyt]): { v_a:, v_b: (osie ścian okapowych w kierunku v), v0: (v punktu a ściany), kv: (±1 – znak
# v wzdłuż s), z_okap:, z_max: (najwyższy punkt linii szczytu), plaski: (ściana wysoka dachu jednospadowego – v stałe,
# kv = 0, linia pozioma) }. Gniazda płatwi to otwory ściany z gniazdo: true –
# od spodu płatwi w górę (bal przy spodzie dostaje wycięcie od góry, bale wyżej są przecięte), jak w projekcie 900.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'taras') unless defined?(ArteMadera::GeneratorWiencowy::Taras)

module ArteMadera
  module GeneratorWiencowy
    module Szczyty
      module_function

      # Ściany ze szczytem (w[:szczyt]) i opis dachu domu prostokątnego; zwraca { uwagi:, dom: (nil – bez belek dachu) }.
      def przygotuj(sciany, p, os_kalenicy)
        wynik = { uwagi: [], dom: nil }
        sciany.each { |w| w.delete(:szczyt) }
        return wynik unless Parametry.tak?(p, 'szczyty')
        idx = os_kalenicy == :x ? 1 : 0
        szczytowe = sciany.select { |w| szczytowa?(w, p) }
        if szczytowe.empty?
          wynik[:uwagi] << 'Szczyty: brak ścian szczytowych zakończonych narożnikami – szczytów nie dodano.'
          return wynik
        end
        z_okap = Wience.wysokosci(p)[:okapowa]
        szczytowe.each do |w|
          va = w[:a][idx]
          vb = w[:b][idx]
          geo = { v_a: [va, vb].min, v_b: [va, vb].max }
          w[:szczyt] = geo.merge(v0: va, kv: vb >= va ? 1.0 : -1.0, z_okap: z_okap)
          w[:szczyt][:z_max] = z_max(w, p)
        end
        wynik[:dom] = dom_prostokatny(sciany, szczytowe, os_kalenicy)
        return jednospadowy(sciany, wynik, p, z_okap) if Dach.jednospadowy?(p)
        if wynik[:dom].nil? && Parametry.tak?(p, 'dach_elementy')
          wynik[:uwagi] << 'Dach: belki dachu (płatwie, krokwie) tylko dla obrysu prostokątnego – szczyty liczone dla każdej ściany osobno.'
        end
        wynik
      end

      # Dach jednospadowy (dom prostokątny): ściana wysoka dostaje szczyt płaski (do połaci); inny obrys – bez szczytów
      # z ostrzeżeniem. Zwraca wynik przygotuj.
      def jednospadowy(sciany, wynik, p, z_okap)
        return wynik if wynik[:dom] && DachJednospadowy.sciana_wysoka!(sciany, wynik[:dom], p, z_okap)
        sciany.each { |w| w.delete(:szczyt) }
        wynik[:dom] = nil
        wynik[:uwagi] << 'Dach jednospadowy: tylko dla domu prostokątnego – szczytów nie dodano (inny dach zrób w aplikacji do dachów).'
        wynik
      end

      # Najwyższy punkt linii szczytu ściany [mm]: kalenica (dwuspadowy) albo wyższy koniec ściany (jednospadowy).
      def z_max(w, p)
        return Dach.z_szczytu(w[:szczyt], p) unless Dach.jednospadowy?(p)
        [w[:s_od], w[:s_do]].map { |s| linia(w, s, p) }.max
      end

      # Czy ściana dostaje szczyt: zewnętrzna szczytowa od narożnika do narożnika albo działowa szczytowa od ściany do ściany
      # (niższa działowa – pod stropem, antresolą, półką – szczytu nie ma).
      def szczytowa?(w, p)
        return false unless w[:kierunek] == :B
        konce = [0.0, w[:dl_osi]].map { |s| w[:skrzyzowania].find { |k| (k[:s] - s).abs < 1.0 } }
        return konce.all? { |k| k && k[:typ] == :naroznik } if w[:rodzaj] == :zewnetrzna
        return false unless w[:rodzaj] == :dzialowa && w[:nizsza].nil?
        return false unless Parametry.tak?(p, 'szczyty_na_dzialowych') || Taras.sciana_domu?(w)
        konce.all? { |k| k && k[:inna][:rodzaj] == :zewnetrzna && k[:inna][:kierunek] == :A }
      end

      # Opis dachu domu prostokątnego (4 ściany zewnętrzne, 2 szczyty): { os:, v_a:, v_b:, u1:, u2:, wewn: [u szczytów
      # na działowych] }; nil w innym przypadku.
      def dom_prostokatny(sciany, szczytowe, os)
        zewn = sciany.select { |w| w[:rodzaj] == :zewnetrzna }
        szcz = szczytowe.select { |w| w[:rodzaj] == :zewnetrzna }
        return nil unless zewn.length == 4 && szcz.length == 2
        iu = os == :x ? 0 : 1
        u = szcz.map { |w| w[:a][iu] }.sort
        g = szcz[0][:szczyt]
        wewn = szczytowe.select { |w| w[:rodzaj] == :dzialowa }.map { |w| w[:a][iu] }.sort
        { os: os, v_a: g[:v_a], v_b: g[:v_b], u1: u[0], u2: u[1], wewn: wewn }
      end

      # Współrzędna v punktu s ściany ze szczytem.
      def v_z_s(w, s)
        w[:szczyt][:v0] + w[:szczyt][:kv] * s
      end

      # Współrzędna s ściany dla v.
      def s_z_v(w, v)
        (v - w[:szczyt][:v0]) * w[:szczyt][:kv]
      end

      # Linia szczytu (wierzch bali) w miejscu s ściany [mm]; szczyt płaski (ściana wysoka dachu jednospadowego) – linia
      # podparcia przy jej licu wewnętrznym (krokwie i deski leżą na ścianie); bez szczytu – nil.
      def linia(w, s, p)
        g = w[:szczyt]
        return nil if g.nil?
        return Dach.linia_podparcia(g, g[:v0], p) if g[:plaski]
        Dach.linia_szczytu(g, v_z_s(w, s), p)
      end

      # Załom linii szczytu (kalenica) – s ściany; dach jednospadowy i szczyt płaski – nil (linia prosta).
      def zalom(w, p)
        g = w[:szczyt]
        return nil if g.nil? || g[:plaski]
        v = Dach.zalom_v(g, p)
        v.nil? ? nil : s_z_v(w, v)
      end

      # Czy wysokość z w miejscu s ściany jest pod linią szczytu (ściana bez szczytu – zawsze).
      def pod_linia?(w, s, z, p)
        l = linia(w, s, p)
        l.nil? || z <= l + 0.01
      end

      # Czy wysokość z w miejscu s ściany jest pod linią podparcia (spód krokwi / desek) – dla węgłów przy szczycie,
      # które wystają z obu stron szczytu pod połać; ściana bez szczytu – zawsze.
      def pod_podparciem?(w, s, z, p)
        return true if w[:szczyt].nil?
        z <= Dach.linia_podparcia(w[:szczyt], v_z_s(w, s), p) + 0.01
      end

      # Zasięg [s0, s1] wieńca o spodzie z0, w którym linia szczytu jest wyżej niż z0 + najniższy kawałek (szczyt płaski –
      # najcieńszy pasek górnego bala ściany wysokiej, jednospad_min_pasek); nil – brak bala.
      def zasieg(w, z0, p)
        g = w[:szczyt]
        return [w[:s_od], w[:s_do]] if g.nil?
        m = p['szczyt_min_wysokosc'].to_f
        m = [m, p['jednospad_min_pasek'].to_f].max if g[:plaski]
        zasieg_linii(w[:s_od], w[:s_do], zalom(w, p), z0 + m) { |s| linia(w, s, p) }
      end

      # Zasięg [s0, s1] odcinka s_od…s_do, na którym linia dachu (blok: s → wysokość; prosta albo łamana z załomem sk,
      # wypukła w górę) jest wyżej niż z_min; nil – nigdzie (krócej niż 1 mm).
      def zasieg_linii(s_od, s_do, sk, z_min)
        punkty = [s_od, s_do]
        punkty.insert(1, sk) if sk && sk > s_od && sk < s_do
        lo = nil
        hi = nil
        punkty.each_cons(2) do |a, b|
          za = yield(a) - z_min
          zb = yield(b) - z_min
          next if za <= 0.0 && zb <= 0.0
          x0 = za > 0.0 ? a : a + (b - a) * za / (za - zb)
          x1 = zb > 0.0 ? b : a + (b - a) * za / (za - zb)
          lo = x0 if lo.nil? || x0 < lo
          hi = x1 if hi.nil? || x1 > hi
        end
        lo && hi - lo > 1.0 ? [lo, hi] : nil
      end

      # Obróbki skosu dla kawałka bala s0…s1 o spodzie z0 i wysokości h: [cechy skos_gora w układzie bala].
      def skosy(w, s0, s1, z0, h, p)
        return [] if w[:szczyt].nil?
        skosy_linii(s0, s1, z0, h, zalom(w, p)) { |s| linia(w, s, p) }
      end

      # Skosy kawałka s0…s1 pod linią daszkową (blok: s → wysokość linii; załom w sk, nil – linia prosta): odcinki, na
      # których linia schodzi poniżej wierzchu bala.
      def skosy_linii(s0, s1, z0, h, sk)
        punkty = [s0, s1]
        punkty.insert(1, sk) if sk && sk > s0 + 0.5 && sk < s1 - 0.5
        wynik = []
        punkty.each_cons(2) do |a, b|
          za = yield(a) - z0
          zb = yield(b) - z0
          next if za >= h - 0.01 && zb >= h - 0.01
          wynik << { typ: 'skos_gora', x0: a - s0, x1: b - s0, z0: za, z1: zb }
        end
        wynik
      end

      # Gniazda płatwi (otwory z gniazdo: true); wywołać po stykach i węgłach. Dom prostokątny – każda ściana i węgieł,
      # przez które przechodzi płatew (także działowe i węgły pod płatwią ścienną); inny obrys – tylko szczyty.
      def gniazda(sciany, p, dom)
        return unless Parametry.tak?(p, 'szczyty')
        if dom
          platwie = Dach.platwie({ v_a: dom[:v_a], v_b: dom[:v_b] }, p)
          sciany.each { |w| gniazda_sciany(w, platwie, dom[:os] == :x ? 1 : 0, p) }
          return
        end
        luz = p['gniazdo_luz'].to_f
        sciany.each do |w|
          next if w[:szczyt].nil?
          Dach.platwie(w[:szczyt], p).each do |pl|
            s = [s_z_v(w, pl[:v] - pl[:b] / 2.0 - luz), s_z_v(w, pl[:v] + pl[:b] / 2.0 + luz)].sort
            dodaj_gniazdo(w, s, pl)
          end
        end
      end

      # Gniazda jednej ściany od płatwi domu prostokątnego (iv – indeks współrzędnej v): ściana w poprzek płatwi – gniazdo
      # na szerokości płatwi z luzem; ściana wzdłuż płatwi i pod nią – na całej długości.
      def gniazda_sciany(w, platwie, iv, p)
        luz = p['gniazdo_luz'].to_f
        t = Parametry.grubosc(p)
        gora = Wience.wysokosc_calkowita(w, p)
        w_poprzek = w[:kier][iv].abs > 0.5
        platwie.each do |pl|
          next if pl[:z_spod] >= gora - 0.01
          if w_poprzek
            v0 = w[:a][iv]
            s = [(pl[:v] - pl[:b] / 2.0 - luz - v0) * w[:kier][iv], (pl[:v] + pl[:b] / 2.0 + luz - v0) * w[:kier][iv]].sort
            next if s[1] <= w[:s_od] + 0.5 || s[0] >= w[:s_do] - 0.5
          else
            next unless (w[:a][iv] - pl[:v]).abs < t / 2.0 + pl[:b] / 2.0 - 0.5
            s = [w[:s_od] - 1.0, w[:s_do] + 1.0]
          end
          dodaj_gniazdo(w, s, pl)
        end
      end

      # Gniazdo płatwi w ścianie: otwór od spodu płatwi w górę na odcinku s.
      def dodaj_gniazdo(w, s, pl)
        w[:otwory] ||= []
        w[:otwory] << { s0: s[0], s1: s[1], z0: pl[:z_spod], z1: pl[:z_spod] + 100_000.0,
                        nazwa: "gniazdo płatwi #{pl[:rodzaj]}", gniazdo: true }
      end

      # Czy bal należy do szczytu (prefiks Sz): ma skos albo leży nad ścianami okapowymi (ściana wysoka dachu jednospadowego
      # – bale ścienne Bs).
      def bal_szczytu?(b)
        w = b[:sciana]
        return false if w[:szczyt].nil? || w[:szczyt][:plaski]
        b[:cechy].any? { |c| c[:typ] == 'skos_gora' } || b[:z0] >= w[:szczyt][:z_okap] - 0.01
      end
    end
  end
end
