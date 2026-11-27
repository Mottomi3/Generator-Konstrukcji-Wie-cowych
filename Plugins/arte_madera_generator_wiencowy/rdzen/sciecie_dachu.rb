# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/sciecie_dachu.rb
# Zadanie: bale ścian wzdłuż kalenicy wystające nad płaszczyznę dachu ścięte w poprzek do tej płaszczyzny – górny bal ściany okapowej przy ścianie nośnej, ściana wysoka dachu jednospadowego, działowa wzdłużna pod dachem.
# Tematy: ścięcie dachu, wyrównanie ścięcia do granic pasów, wyrównanie skosu do naroży gniazd, cienka resztka bala między wycięciami od góry i od dołu, węgieł przy szczycie ścięty do dachu, górny bal ścięty do płaszczyzny dachu, ściana nośna, ściana okapowa pod dachem, ściana wysoka – ścięcie skośne, działowa wzdłużna pod połacią, bal skośny w poprzek
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (linia podparcia), rdzen/bale.rb (położenie bala), rdzen/podbitka.rb (obniżenie)
# Używają: rdzen/projekt.rb (po balach, przed zamkami i pozycjami)
#
# Ściany wzdłuż kalenicy (kierunek A) mają płaszczyznę dachu stałą wzdłuż bala, zmienną w poprzek: na licu y = 0
# i y = t bala inna wysokość linii podparcia. Bal, którego wierzch jest wyżej niż płaszczyzna na którymkolwiek licu,
# dostaje obróbkę sciecie_dachu { z0: (y = 0), z1: (y = t) } na całej długości (rdzen/bryla.rb – pasy ze skośnym
# wierzchem). Tylko dom prostokątny z dachem z generatora (dom ze szczytów). Węgły przy szczycie (biegną wzdłuż kalenicy)
# – górny bal słupka węgła ścięty tak samo, pod podbitką „pod” niżej o jej obniżenie.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'skrzydla') unless defined?(ArteMadera::GeneratorWiencowy::Skrzydla)
require File.join(File.dirname(__FILE__), 'bale') unless defined?(ArteMadera::GeneratorWiencowy::Bale)
require File.join(File.dirname(__FILE__), 'podbitka') unless defined?(ArteMadera::GeneratorWiencowy::Podbitka)
require File.join(File.dirname(__FILE__), 'bryla') unless defined?(ArteMadera::GeneratorWiencowy::Bryla)
require File.join(File.dirname(__FILE__), 'profil_bala') unless defined?(ArteMadera::GeneratorWiencowy::ProfilBala)

module ArteMadera
  module GeneratorWiencowy
    module SciecieDachu
      # Najpłytsze ścięcie [mm] na niższym licu – płytsze pogłębiane do tej wartości (krawędź nie krótsza niż tolerancja SketchUpa).
      MIN = 0.2 unless const_defined?(:MIN)

      module_function

      # Ścina bale ścian wzdłuż kalenicy do płaszczyzny dachu; dom – opis dachu (Szczyty.dom_prostokatny), nil – nic.
      def przytnij!(bale, p, dom)
        return if dom.nil? || !Parametry.tak?(p, 'szczyty')
        t = Parametry.grubosc(p)
        bale.each do |b|
          w = b[:sciana]
          ob = w[:okap_boczny]
          if ob
            # Ściana okapowa skrzydła bocznego domu L (rdzen/skrzydla.rb) – także część ściany ze szczytem dachu głównego.
            c = sciecie(b, p, ob[:geo], ob[:geo][:iv], t)
            c = w_zakresie(c, b, ob[:s_zakres]) if c
          else
            d = Skrzydla.dom_sciany(dom, w, p)
            next if d.nil? || w[:os] != d[:os]
            c = sciecie(b, p, Dach.geo(d), d[:iv], t)
          end
          b[:cechy] << c if c
        end
      end

      # Ścięcie c bala b ograniczone do zakresu s ściany (nil – bal poza zakresem).
      def w_zakresie(c, b, zakres)
        x0 = [zakres[0] - b[:s0], 0.0].max
        x1 = [zakres[1] - b[:s0], b[:dl]].min
        x1 - x0 > Bryla::SCAL ? c.merge(x0: x0, x1: x1) : nil
      end

      # Ścięcia bliskie granic przekroju: gdzie płaszczyzna ścięcia przecina poziom wierzchu (dno gniazda zamka, wierzch
      # pióra) bliżej niż 0,2 mm od granicy pasa (podcięcie, pióro), płaszczyzna przesunięta równolegle tak, by przecięcie
      # wypadło na granicy – krawędź krótsza niż tolerancja SketchUpa psuje bryłę. Po zamkach i oznaczeniu profilu.
      def wyrownaj!(bale, p)
        t = Parametry.grubosc(p)
        opis = ProfilBala.pelny?(p) ? ProfilBala.opis(p) : nil
        bale.each do |b|
          c = b[:cechy].find { |x| x[:typ] == 'sciecie_dachu' }
          next if c.nil?
          kt = (c[:z1] - c[:z0]) / t
          next if kt.abs < 1e-9
          reszta = b[:cechy].reject { |x| x.equal?(c) }
          prof = opis ? ProfilBala.przedzialy(b[:dl], t, b[:h], reszta, opis) : Bryla.profil(b[:dl], t, b[:h], reszta)
          granice = [0.0, t]
          poziomy = []
          prof.each do |q|
            granice << q[:y0] << q[:y1]
            (q[:pasy] || [q]).each do |x|
              granice << x[:y0] << x[:y1]
              poziomy << x[:zt_a] << x[:zt_b]
            end
          end
          przesun!(c, kt, t, poziomy.compact.uniq, granice.compact.uniq)
        end
      end

      # Skosy wzdłuż bala (skos_gora – szczyty, bale pod dachem) przechodzące bliżej niż Bryla::SCAL od naroża obróbki (granica
      # x gniazda albo wycięcia na poziomie jego dna): nad narożem – skos obniżony do naroża, pod nim – obniżony do odstępu
      # Bryla::SCAL (krawędź krótsza niż tolerancja SketchUpa psuje bryłę; runda 12 – węgły pod połacią zadaszenia, gdzie
      # łamana linia dachu trafia blisko dna gniazda zamka). Skos zawsze w dół – bal nie wychodzi ponad dach. Runda 19
      # (ziarno 6305): także dolne naroża gniazda od spodu (x gniazda na spodzie bala) – szpic klina szczytu przed gniazdem
      # niższy niż Bryla::SCAL znika (skos obniżony do naroża; pod narożem bal i tak jest pusty).
      def wyrownaj_skosy!(bale)
        bale.each do |b|
          skosy = b[:cechy].select { |c| c[:typ] == 'skos_gora' && c[:x1] - c[:x0] > 1e-6 }
          next if skosy.empty?
          naroza = b[:cechy].flat_map do |c|
            case c[:typ]
            when 'gniazdo_gora', 'wyciecie_gora' then [[c[:x0], b[:h] - c[:gleb], true], [c[:x1], b[:h] - c[:gleb], true]]
            when 'gniazdo_dol', 'wyciecie_dol'
              [[c[:x0], c[:gleb], true], [c[:x1], c[:gleb], true], [c[:x0], 0.0, false], [c[:x1], 0.0, false]]
            else []
            end
          end
          skosy.each do |c|
            naroza.each do |x, z, oba|
              next if x < c[:x0] - 1e-9 || x > c[:x1] + 1e-9
              d = c[:z0] + (c[:z1] - c[:z0]) * (x - c[:x0]) / (c[:x1] - c[:x0]) - z
              next unless d.abs > 1e-6 && d.abs < Bryla::SCAL && (oba || d > 0.0)
              dz = d > 0.0 ? -d : -(Bryla::SCAL + d)
              c[:z0] += dz
              c[:z1] += dz
            end
          end
        end
      end

      # Cienka resztka bala między wycięciem od góry (gniazdo płatwi, gniazdo zamka) a gniazdem od spodu w tym samym miejscu –
      # grubsza od zera, cieńsza niż Bryla::SCAL: wycięcie od góry płytsze, tak by zostało Bryla::SCAL (runda 19, ziarno
      # 6557 – płatew nad węgłem w balu szczytu zostawiała 0,008 mm; krawędź krótsza niż tolerancja SketchUpa psuje bryłę).
      def wyrownaj_przeciwne!(bale)
        bale.each do |b|
          gora = b[:cechy].select { |c| %w[gniazdo_gora wyciecie_gora].include?(c[:typ]) }
          dol = b[:cechy].select { |c| %w[gniazdo_dol wyciecie_dol].include?(c[:typ]) }
          gora.each do |c|
            dol.each do |d|
              next unless [c[:x1], d[:x1]].min - [c[:x0], d[:x0]].max > 1e-6
              r = b[:h] - c[:gleb] - d[:gleb]
              c[:gleb] -= Bryla::SCAL - r if r > 1e-6 && r < Bryla::SCAL
            end
          end
        end
      end

      # Przesunięcie płaszczyzny ścięcia c (nachylenie kt w poprzek) do najbliższej granicy pasa dla pierwszego poziomu,
      # którego przecięcie wypada bliżej niż Bryla::SCAL od granicy albo nad którym płaszczyzna na granicy jest niżej niż
      # Bryla::SCAL (stopień krótszy niż tolerancja – runda 9); płaszczyzna zawsze w dół.
      def przesun!(c, kt, t, poziomy, granice)
        poziomy.each do |z|
          yk = (z - c[:z0]) / kt
          next if yk <= 0.0 || yk >= t
          # Krawędź za krótka w poziomie (przecięcie przy granicy) albo w pionie (płaszczyzna tuż nad poziomem na granicy pasa).
          next unless granice.any? { |y| (y - yk).abs > 1e-6 && [(y - yk).abs, (kt * (y - yk)).abs].min < Bryla::SCAL }
          # Płaszczyzna tylko w dół (bal nie wychodzi ponad dach): przecięcie przesuwa się do granicy po stronie wyższej płaszczyzny.
          yb = granice.select { |y| (y - yk) * kt > 1e-6 }.min_by { |y| (y - yk).abs }
          next if yb.nil?
          dz = z - kt * yb - c[:z0]
          c[:z0] += dz
          c[:z1] += dz
          return
        end
      end

      # Obróbka ścięcia bala b (nil – bal pod dachem): wysokości płaszczyzny na licach y = 0 i y = t względem spodu bala.
      def sciecie(b, p, geo, iv, t)
        pol = Bale.polozenie(b, p)
        v0 = pol[:poczatek][iv]
        v1 = v0 + pol[:y][iv] * t
        # Węgieł pod połacią kończy się pod podbitką „pod” (jak działowe w poprzek i węgły na ścianach okapowych).
        dz = b[:sciana][:rodzaj] == :kontrfor ? Podbitka.obnizenie_wegla(b[:sciana], p) : 0.0
        z0 = Dach.linia_podparcia(geo, v0, p) - dz - b[:z0]
        z1 = Dach.linia_podparcia(geo, v1, p) - dz - b[:z0]
        lo = [z0, z1].min
        return nil if lo >= b[:h] - 1e-6
        # Bal wystaje ponad dach mniej niż MIN (runda 18, P5 – ziarna 6110, 6269: 0,04–0,15 mm): ścięcie obniżone tak, że na
        # niższym licu ma MIN – bal zawsze pod dachem, bez krawędzi krótszych niż tolerancja SketchUpa.
        if lo > b[:h] - MIN
          z0 -= lo - (b[:h] - MIN)
          z1 -= lo - (b[:h] - MIN)
        end
        { typ: 'sciecie_dachu', x0: 0.0, x1: b[:dl], z0: z0, z1: z1 }
      end
    end
  end
end
