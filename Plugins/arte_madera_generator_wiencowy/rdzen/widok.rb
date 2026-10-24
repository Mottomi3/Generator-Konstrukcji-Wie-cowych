# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/widok.rb
# Zadanie: widok ściany do okna – bale jako obrysy w płaszczyźnie ściany (s, z), otwory, styki, skrzyżowania, linia dachu.
# Tematy: widok ściany, rozkład ściany, elewacja ściany, obrys bala w widoku, styki w widoku, skrzyżowania w widoku, linia dachu w widoku, ustawienia ściany w widoku, źródło węgła
# Zależy od: rdzen/parametry.rb, rdzen/bryla.rb (profil bala), rdzen/szczyty.rb, rdzen/pod_dachem.rb (linia dachu), rdzen/ustawienia_scian.rb (stan ustawień), rdzen/wience.rb
# Używają: sketchup/sterowanie.rb (widok dla okna), html/sciana.js (rysunek)
#
# Widok jak rozkład ściany w projektach producenta: patrzymy na ścianę od strony lica, s – wzdłuż osi ściany (od jej
# początku), z – od spodu pierwszego bala. Obrys bala z profilu (wierzch i spód z gniazdami zamków i skosem dachu).
# Skrzyżowania: [s, id, rodzaj, źródło węgła ('rysunek' | 'reczny' | 'styk' | 'usztywnienie' | '')]; ustawienia ściany
# do panelu w oknie (ostatki końców, węgły ręczne, co nad działową) i wartości domyślne z parametrów.
# Wynik tylko z typów JSON (tablice, liczby, teksty), wartości w mm zaokrąglone do 0,1.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'bryla') unless defined?(ArteMadera::GeneratorWiencowy::Bryla)
require File.join(File.dirname(__FILE__), 'szczyty') unless defined?(ArteMadera::GeneratorWiencowy::Szczyty)
require File.join(File.dirname(__FILE__), 'pod_dachem') unless defined?(ArteMadera::GeneratorWiencowy::PodDachem)
require File.join(File.dirname(__FILE__), 'ustawienia_scian') unless defined?(ArteMadera::GeneratorWiencowy::UstawieniaScian)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)

module ArteMadera
  module GeneratorWiencowy
    module Widok
      module_function

      # Ściany do wyboru w oknie: [[id, rodzaj]] – ściany z balami bez kontrforów (węgły widać na ścianach).
      def lista(plan)
        return [] if plan.nil? || plan[:sciany].nil?
        plan[:sciany].reject { |w| w[:rodzaj] == :kontrfor || w[:bale].nil? || w[:bale].empty? }.map { |w| [w[:id], w[:rodzaj].to_s] }
      end

      # Widok jednej ściany (Hash z kluczami tekstowymi) albo nil, gdy ściany nie ma.
      def sciana(plan, id)
        return nil if plan.nil? || plan[:sciany].nil?
        w = plan[:sciany].find { |x| x[:id] == id.to_s }
        return nil if w.nil? || w[:bale].nil? || w[:bale].empty?
        p = plan[:parametry]
        t = Parametry.grubosc(p)
        bale = w[:bale].map { |b| bal(b, t) }
        { 'id' => w[:id], 'rodzaj' => w[:rodzaj].to_s, 'szczyt' => !w[:szczyt].nil?,
          'dl_osi' => r(w[:dl_osi]), 's_od' => r(w[:s_od]), 's_do' => r(w[:s_do]),
          'wience' => wience(w), 'bale' => bale, 'otwory' => otwory(w),
          'skrzyzowania' => (w[:skrzyzowania] || []).map { |k| [r(k[:s]), k[:inna][:id].to_s, k[:inna][:rodzaj].to_s, k[:inna][:zrodlo].to_s] },
          'linia_dachu' => linia_dachu(w, p),
          'styki' => bale.select { |b| b['konce'].include?('styk') }.length,
          'dzialowa' => w[:rodzaj] == :dzialowa, 'wysokosc_wlasna' => r(Wience.wysokosc(w, p)),
          'ustawienia' => UstawieniaScian.stan(w, p),
          'domyslne' => { 'ostatek' => p['ostatek'], 'wysokosc' => p['dzialowa_nizsza_wysokosc'], 'strop' => p['strop'] } }
      end

      # Bal w widoku: obrys [[s, z]], pozycja, wieniec, końce.
      def bal(b, t)
        poz = b[:pozycja] || {}
        { 'obrys' => obrys(b, t), 'nr' => poz[:nr], 'nazwa' => poz[:nazwa].to_s, 'prefiks' => poz[:prefiks].to_s,
          'wieniec' => b[:wieniec][:nr], 's0' => r(b[:s0]), 's1' => r(b[:s1]), 'z0' => r(b[:z0]), 'h' => r(b[:h]),
          'konce' => (b[:konce] || []).map(&:to_s) }
      end

      # Obrys bala w płaszczyźnie ściany z profilu: wierzch od lewej do prawej, spód z powrotem; ciągłe odcinki profilu
      # (przerwa w profilu – bal pokazany do przerwy).
      def obrys(b, t)
        prof = Bryla.profil(b[:dl], t, b[:h], b[:cechy])
        return [] if prof.empty?
        gora = []
        dol = []
        prof.each do |q|
          break if !gora.empty? && (q[:xa] - gora.last[0]).abs > 0.01
          gora << [q[:xa], q[:zt_a]] << [q[:xb], q[:zt_b]]
          dol << [q[:xa], q[:zb_a]] << [q[:xb], q[:zb_b]]
        end
        punkty = (gora + dol.reverse).map { |x, z| [r(b[:s0] + x), r(b[:z0] + z)] }
        uprosc(punkty)
      end

      # Punkty bez powtórzeń i bez punktów leżących na prostej między sąsiadami.
      def uprosc(punkty)
        lista = punkty.each_with_object([]) { |pt, acc| acc << pt if acc.empty? || acc.last != pt }
        lista.pop if lista.length > 1 && lista.first == lista.last
        return lista if lista.length < 4
        wynik = []
        lista.each_with_index do |pt, i|
          a = lista[i - 1]
          c = lista[(i + 1) % lista.length]
          iloczyn = (pt[0] - a[0]) * (c[1] - a[1]) - (pt[1] - a[1]) * (c[0] - a[0])
          wynik << pt if iloczyn.abs > 0.05
        end
        wynik.length >= 3 ? wynik : lista
      end

      # Wieńce ściany: [[nr, z0, h]] od dołu (z bali).
      def wience(w)
        w[:bale].map { |b| [b[:wieniec][:nr], r(b[:z0]), r(b[:h])] }.uniq.sort_by { |x| [x[1], x[0]] }
      end

      # Otwory (bez gniazd płatwi): [[s0, s1, z0, z1, nazwa]].
      def otwory(w)
        (w[:otwory] || []).reject { |o| o[:gniazdo] }.map { |o| [r(o[:s0]), r(o[:s1]), r(o[:z0]), r(o[:z1]), o[:nazwa].to_s] }
      end

      # Linia dachu nad ścianą (szczyt – wierzch bali szczytu, ściana pod połacią – spód krokwi): [[s, z]]; [] – brak.
      def linia_dachu(w, p)
        if w[:szczyt]
          sk = Szczyty.s_z_v(w, (w[:szczyt][:v_a] + w[:szczyt][:v_b]) / 2.0)
          blok = lambda { |s| Szczyty.linia(w, s, p) }
        elsif w[:pod_dachem]
          g = w[:pod_dachem]
          sk = ((g[:v_a] + g[:v_b]) / 2.0 - w[:a][g[:iv]]) * w[:kier][g[:iv]]
          blok = lambda { |s| PodDachem.linia(w, s, p) }
        else
          return []
        end
        s = [w[:s_od], w[:s_do]]
        s.insert(1, sk) if sk > w[:s_od] && sk < w[:s_do]
        s.map { |x| [r(x), r(blok.call(x))] }
      end

      # Zaokrąglenie do 0,1 mm.
      def r(v)
        (v.to_f * 10.0).round / 10.0
      end
    end
  end
end
