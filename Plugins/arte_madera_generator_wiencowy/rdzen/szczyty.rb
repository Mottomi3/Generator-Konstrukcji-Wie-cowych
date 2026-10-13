# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/szczyty.rb
# Zadanie: szczyty z bali – które ściany mają szczyt, wieńce szczytu do kalenicy, skos bali wg linii dachu, gniazda pod płatwie.
# Tematy: szczyt, ściana szczytowa, bal szczytowy, skos bala, gniazdo płatwi, płatew przez szczyt, szczyt na działowej, wysokość szczytu, prefiks Sz
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb, rdzen/dach.rb (linia szczytu, płatwie)
# Używają: rdzen/projekt.rb, rdzen/wience.rb (liczba wieńców szczytu), rdzen/bale.rb (zasięg i skos bali), rdzen/pozycje.rb (prefiks Sz)
#
# Szczyt ściany (w[:szczyt]): { v_a:, v_b: (osie ścian okapowych w kierunku v), v0: (v punktu a ściany), kv: (±1 – znak
# v wzdłuż s), z_okap:, z_max: (wierzch linii szczytu w kalenicy) }. Gniazda płatwi to otwory ściany z gniazdo: true –
# od spodu płatwi w górę (bal przy spodzie dostaje wycięcie od góry, bale wyżej są przecięte), jak w projekcie 900.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)

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
          w[:szczyt] = geo.merge(v0: va, kv: vb >= va ? 1.0 : -1.0, z_okap: z_okap, z_max: Dach.z_szczytu(geo, p))
        end
        wynik[:dom] = dom_prostokatny(sciany, szczytowe, os_kalenicy)
        if wynik[:dom].nil? && Parametry.tak?(p, 'dach_elementy')
          wynik[:uwagi] << 'Dach: belki dachu (płatwie, krokwie) tylko dla obrysu prostokątnego – szczyty liczone dla każdej ściany osobno.'
        end
        wynik
      end

      # Czy ściana dostaje szczyt: zewnętrzna szczytowa od narożnika do narożnika albo działowa szczytowa od ściany do ściany.
      def szczytowa?(w, p)
        return false unless w[:kierunek] == :B
        konce = [0.0, w[:dl_osi]].map { |s| w[:skrzyzowania].find { |k| (k[:s] - s).abs < 1.0 } }
        return konce.all? { |k| k && k[:typ] == :naroznik } if w[:rodzaj] == :zewnetrzna
        return false unless w[:rodzaj] == :dzialowa && Parametry.tak?(p, 'szczyty_na_dzialowych')
        konce.all? { |k| k && k[:inna][:rodzaj] == :zewnetrzna && k[:inna][:kierunek] == :A }
      end

      # Opis dachu domu prostokątnego (4 ściany zewnętrzne, 2 szczyty): { os:, v_a:, v_b:, u1:, u2: }; nil w innym przypadku.
      def dom_prostokatny(sciany, szczytowe, os)
        zewn = sciany.select { |w| w[:rodzaj] == :zewnetrzna }
        szcz = szczytowe.select { |w| w[:rodzaj] == :zewnetrzna }
        return nil unless zewn.length == 4 && szcz.length == 2
        iu = os == :x ? 0 : 1
        u = szcz.map { |w| w[:a][iu] }.sort
        g = szcz[0][:szczyt]
        { os: os, v_a: g[:v_a], v_b: g[:v_b], u1: u[0], u2: u[1] }
      end

      # Współrzędna v punktu s ściany ze szczytem.
      def v_z_s(w, s)
        w[:szczyt][:v0] + w[:szczyt][:kv] * s
      end

      # Współrzędna s ściany dla v.
      def s_z_v(w, v)
        (v - w[:szczyt][:v0]) * w[:szczyt][:kv]
      end

      # Linia szczytu (wierzch bali) w miejscu s ściany [mm]; bez szczytu – nil.
      def linia(w, s, p)
        return nil if w[:szczyt].nil?
        Dach.linia_szczytu(w[:szczyt], v_z_s(w, s), p)
      end

      # Czy wysokość z w miejscu s ściany jest pod linią szczytu (ściana bez szczytu – zawsze).
      def pod_linia?(w, s, z, p)
        l = linia(w, s, p)
        l.nil? || z <= l + 0.01
      end

      # Zasięg [s0, s1] wieńca o spodzie z0, w którym linia szczytu jest wyżej niż z0 + najniższy kawałek; nil – brak bala.
      def zasieg(w, z0, p)
        g = w[:szczyt]
        return [w[:s_od], w[:s_do]] if g.nil?
        m = p['szczyt_min_wysokosc'].to_f
        vk = (g[:v_a] + g[:v_b]) / 2.0
        szczyt = Dach.linia_szczytu(g, vk, p)
        return nil if szczyt <= z0 + m
        r = (szczyt - z0 - m) / Dach.tg(p)
        s = [s_z_v(w, vk - r), s_z_v(w, vk + r)].sort
        lo = [s[0], w[:s_od]].max
        hi = [s[1], w[:s_do]].min
        hi - lo > 1.0 ? [lo, hi] : nil
      end

      # Obróbki skosu dla kawałka bala s0…s1 o spodzie z0 i wysokości h: [cechy skos_gora w układzie bala].
      def skosy(w, s0, s1, z0, h, p)
        return [] if w[:szczyt].nil?
        sk = s_z_v(w, (w[:szczyt][:v_a] + w[:szczyt][:v_b]) / 2.0)
        punkty = [s0, s1]
        punkty.insert(1, sk) if sk > s0 + 0.5 && sk < s1 - 0.5
        wynik = []
        punkty.each_cons(2) do |a, b|
          za = linia(w, a, p) - z0
          zb = linia(w, b, p) - z0
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
        gora = Wience.wysokosc(w, p)
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

      # Czy bal należy do szczytu (prefiks Sz): ma skos albo leży nad ścianami okapowymi.
      def bal_szczytu?(b)
        w = b[:sciana]
        return false if w[:szczyt].nil?
        b[:cechy].any? { |c| c[:typ] == 'skos_gora' } || b[:z0] >= w[:szczyt][:z_okap] - 0.01
      end
    end
  end
end
