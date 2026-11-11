# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/krok2.rb
# Zadanie: co generator przekazuje KROKOWI 2 aplikacji do dachów – ustawienia początkowe (kierunek, krokwie albo poszycie na samych płatwiach, warstwy poszycia, klasa drewna) i płatwie generatora jako podpory krokwi i poszycia.
# Tematy: ustawienia KROKU 2, KROK 2 z generatora, poszycie dachu, nadbitka, deskowanie pełne, płyty OSB, deski na płatwiach, dach na samych płatwiach, podpory krokwi, płatwie jako podpory, przęsła krokwi, podpowiedź KROKU 2
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (układ z krokwiami, uniesienie krokwi), rdzen/podbitka.rb (podbitka jako nadbitka)
# Używają: rdzen/polacie.rb (podpowiedzi), sketchup/dach_aplikacja.rb
#
# Ustawienia – klucze KROKU 2 aplikacji (jej 01_config.rb, DEFAULTS_FRAMING, mm). Połać leży na wierzchu płatwi
# generatora: kierunek „w górę” (build_dir up – połać to spód krokwi), bez płatwi kalenicowej aplikacji (płatew
# kalenicowa leży w szczytach z bali) i bez zamków dolnych. Układ „same płatwie” – bez krokwi (rafter_on false):
# poszycie leży wprost na płatwiach, wzdłuż spadku, styki na płatwiach. Warstwy poszycia (sheath_*) – sekcja
# „Poszycie dachu”; każda leży na poprzedniej włączonej (nadbitka → deskowanie → OSB). Podbitka na krokwiach (albo na
# samych płatwiach) to nadbitka KROKU 2 – włączona z wymiarami podbitki (Podbitka.przez_aplikacje?).
# Podpory: płatwie (elementy z prefiksem P) – wierzch w osi płatwi na obu końcach (płatew ścięta – na połaci,
# kalenicowa – grzbiet, bez ścięcia – poziomy wierzch), szerokość i wysokość przekroju, nazwa pozycji; dach
# jednospadowy – także ściana wysoka (górny bal płasko pod połacią, wierzch w osi ściany); mm układu
# domu (sketchup/dach_aplikacja.rb przelicza je do układu kontekstu). Aplikacja liczy krokiew jako belkę ciągłą
# z przęsłami między płatwiami (płatew przy kalenicy – krokwie na płatwi, bez rozporu), a bez krokwi kładzie na
# płatwiach poszycie. Płatew z grzbietem (kalenicowa ścięta z dwóch stron): wierzch podany GRZBIET_NIZEJ pod grzbietem –
# punkt na samej kalenicy leży na granicy obu połaci i aplikacja (3.7.0) przypisuje go zależnie od zaokrągleń do
# jednej albo żadnej; 1 mm niżej rzut na każdą połać wypada wewnątrz niej.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'podbitka') unless defined?(ArteMadera::GeneratorWiencowy::Podbitka)

module ArteMadera
  module GeneratorWiencowy
    module Krok2
      # Klasy drewna, które zna KROK 2 aplikacji (inne – zostaje wybór z aplikacji).
      KLASY_DREWNA = %w[C24 C30 GL24h GL28h].freeze unless const_defined?(:KLASY_DREWNA)
      # Warstwy poszycia od spodu: [parametr włączenia, nazwa w podpowiedziach].
      unless const_defined?(:WARSTWY)
        WARSTWY = [['poszycie_nadbitka', 'nadbitka'], ['poszycie_deski', 'deskowanie'], ['poszycie_osb', 'OSB']].freeze
      end
      # O tyle pod grzbietem płatwi kalenicowej podawany jest jej wierzch (podpora wewnątrz obu połaci) [mm].
      GRZBIET_NIZEJ = 1.0 unless const_defined?(:GRZBIET_NIZEJ)
      # Krok w poprzek przy rozpoznaniu grzbietu (wierzch niżej po obu stronach osi) [mm].
      KROK_GRZBIETU = 1.0 unless const_defined?(:KROK_GRZBIETU)

      module_function

      # Czy dach bez krokwi – układ „same płatwie”: poszycie wprost na płatwiach.
      def bez_krokwi?(p)
        !Dach.krokwie?(p)
      end

      # Ustawienia początkowe KROKU 2 (symbole – klucze aplikacji, mm).
      def ustawienia(p)
        bk, hk = Parametry.przekroj(p, 'krokiew_przekroj')
        u = { build_dir: 'up', ridge_on: false, seat_on: false, rafter_on: !bez_krokwi?(p), rafter_mode: 'max', rafter_w_mm: bk,
              rafter_h_mm: hk, rafter_spacing_mm: p['krokwie_rozstaw'].to_f, check_on: true, purlin_supports_on: true }
        u[:timber_class] = p['drewno_klasa'] if KLASY_DREWNA.include?(p['drewno_klasa'].to_s)
        u.merge(poszycie(p))
      end

      # Warstwy poszycia KROKU 2 (sheath_*) z sekcji „Poszycie dachu”; podbitka na krokwiach (na samych płatwiach) –
      # nadbitka z wymiarami podbitki.
      def poszycie(p)
        nb = Podbitka.przez_aplikacje?(p) ? 'podbitka' : 'nadbitka'
        { sheath_ceiling_on: nadbitka?(p), sheath_ceiling_t_mm: p["#{nb}_grubosc"].to_f,
          sheath_ceiling_w_mm: p["#{nb}_krycie"].to_f, sheath_ceiling_len_mm: p["#{nb}_dlugosc"].to_f,
          sheath_plank_on: Parametry.tak?(p, 'poszycie_deski'), sheath_plank_t_mm: p['deski_grubosc'].to_f,
          sheath_plank_w_mm: p['deski_szerokosc'].to_f, sheath_plank_gap_mm: p['deski_szczelina'].to_f,
          sheath_plank_len_mm: p['deski_dlugosc'].to_f,
          sheath_osb_on: Parametry.tak?(p, 'poszycie_osb'), sheath_osb_t_mm: p['osb_grubosc'].to_f,
          sheath_osb_len_mm: p['osb_dlugosc'].to_f, sheath_osb_w_mm: p['osb_szerokosc'].to_f,
          sheath_osb_gap_mm: p['osb_szczelina'].to_f }
      end

      # Czy KROK 2 kładzie nadbitkę: parametr nadbitki albo podbitka na krokwiach (na samych płatwiach).
      def nadbitka?(p)
        Parametry.tak?(p, 'poszycie_nadbitka') || Podbitka.przez_aplikacje?(p)
      end

      # Nazwy włączonych warstw poszycia (od spodu).
      def warstwy(p)
        WARSTWY.select { |k, _n| k == 'poszycie_nadbitka' ? nadbitka?(p) : Parametry.tak?(p, k) }.map { |_k, n| n }
      end

      # Podpory krokwi i poszycia z planu: płatwie i ściana wysoka dachu jednospadowego – [{ od:, do: (wierzch w osi na
      # końcach, mm układu domu), szerokosc:, wysokosc:, nazwa: }].
      def podpory(plan)
        dz = Dach.uniesienie_krokwi(plan[:parametry])
        platwie = (plan[:elementy] || []).select { |e| e[:prefiks] == 'P' }.map { |e| podpora(e) }
        (platwie + sciany_wysokie(plan[:sciany] || [], plan[:parametry])).map do |q|
          # Podbitka na płatwiach – krokwie leżą na deskach: podpora na wierzchu desek.
          dz.zero? ? q : q.merge(od: [q[:od][0], q[:od][1], q[:od][2] + dz], do: [q[:do][0], q[:do][1], q[:do][2] + dz])
        end
      end

      # Ściany pod połacią jako podpory: ściana wysoka dachu jednospadowego (szczyt płaski) i ściany okapowe przy ścianie
      # nośnej (bez płatwi ściennej) – górny bal ścięty do połaci, wierzch w osi ściany, grubość bala.
      def sciany_wysokie(sciany, p)
        szczyt = sciany.map { |w| w[:szczyt] }.compact.first
        return [] if szczyt.nil?
        glowne = sciany.select { |w| w[:rodzaj] == :zewnetrzna && w[:kierunek] == :A && w[:szczyt].nil? }
        nosne = Parametry.tak?(p, 'platwa_na_scianie') ? [] : glowne + sciany.select { |w| w[:okap_boczny] && w[:szczyt].nil? }
        pod_platwia = lambda { |w| (w[:otwory] || []).any? { |o| o[:gniazdo] && o[:s0] < w[:s_od] + 0.5 } }
        (sciany.select { |w| w[:szczyt] && w[:szczyt][:plaski] && !pod_platwia.call(w) } + nosne).map do |w|
          iv = (w[:a][0] - w[:b][0]).abs < 0.5 ? 0 : 1
          # Przekrój dachu ściany: skrzydła bocznego domu L, własnego szczytu płaskiego albo pierwszego szczytu domu.
          geo = if w[:okap_boczny] then w[:okap_boczny][:geo]
                elsif w[:szczyt] then w[:szczyt]
                else sciany.map { |x| x[:szczyt] }.compact.find { |g| g[:iv].nil? || g[:iv] == iv } || szczyt
                end
          z = Dach.linia_podparcia(geo, w[:a][iv], p)
          nazwa = if w[:rodzaj] == :dzialowa then 'Działowa'
                  elsif w[:szczyt] then 'Ściana wysoka'
                  else 'Ściana okapowa'
                  end
          { od: [w[:a][0], w[:a][1], z], do: [w[:b][0], w[:b][1], z], szerokosc: Parametry.grubosc(p),
            wysokosc: Parametry.krycie(p), nazwa: "#{nazwa} #{w[:id]}" }
        end
      end

      # Podpora z belki poziomej: wierzch przekroju w osi (środek szerokości; grzbiet – GRZBIET_NIZEJ niżej), na obu
      # końcach belki.
      def podpora(e)
        pe = e[:polozenie]
        przekroj = e[:przekroj] || [[0.0, 0.0], [e[:b], 0.0], [e[:b], e[:h]], [0.0, e[:h]]]
        swiat = lambda { |x, y, z| (0..2).map { |k| pe[:poczatek][k] + pe[:x][k] * x + pe[:y][k] * y + pe[:z][k] * z } }
        ys = przekroj.map { |q| q[0] }
        zs = przekroj.map { |q| q[1] }
        y = (ys.min + ys.max) / 2.0
        z = wierzch_w(przekroj, y)
        z -= GRZBIET_NIZEJ if grzbiet?(przekroj, y, z)
        { od: swiat.call(0.0, y, z), do: swiat.call(e[:dl], y, z), szerokosc: ys.max - ys.min, wysokosc: zs.max - zs.min,
          nazwa: [e[:rodzaj], e[:pozycja] ? e[:pozycja][:nazwa] : nil].compact.join(' ') }
      end

      # Wierzch przekroju (wielokąt [[y, z]]) w miejscu y – najwyższe przecięcie jego krawędzi z pionem.
      def wierzch_w(przekroj, y)
        n = przekroj.length
        gora = nil
        n.times do |i|
          a = przekroj[i]
          b = przekroj[(i + 1) % n]
          next if y < [a[0], b[0]].min - 1e-9 || y > [a[0], b[0]].max + 1e-9
          z = (b[0] - a[0]).abs < 1e-9 ? [a[1], b[1]].max : a[1] + (b[1] - a[1]) * (y - a[0]) / (b[0] - a[0])
          gora = z if gora.nil? || z > gora
        end
        gora
      end

      # Czy wierzch przekroju w y to grzbiet – po obu stronach niżej.
      def grzbiet?(przekroj, y, z)
        [y - KROK_GRZBIETU, y + KROK_GRZBIETU].all? do |yy|
          zz = wierzch_w(przekroj, yy)
          !zz.nil? && zz < z - 1e-6
        end
      end

      # Podpowiedź do okna o tym, co zrobi KROK 2 ([{ poziom:, tekst: }]); same płatwie bez warstwy poszycia – uwaga.
      def podpowiedzi(p)
        w = warstwy(p)
        if bez_krokwi?(p)
          if w.empty?
            return [{ poziom: 'uwaga', tekst: 'Dach: same płatwie bez poszycia – KROK 2 aplikacji do dachów nie ma czego ' \
                                              'zbudować. Włącz deskowanie, nadbitkę albo OSB (Poszycie dachu).' }]
          end
          return [{ poziom: 'ok', tekst: "Dach: poszycie z aplikacji do dachów – po wygenerowaniu powstaną połacie na wierzchu " \
                                         "płatwi i otworzy się KROK 2: #{w.join(' + ')} na płatwiach (wzdłuż spadku, styki " \
                                         'na płatwiach).' }]
        end
        dalej = (w.empty? ? [] : [w.join(' + ')]) + ['łaty i kontrola nośności']
        [{ poziom: 'ok', tekst: 'Dach: krokwie z aplikacji do dachów – po wygenerowaniu powstaną połacie (spód krokwi na ' \
                                "płatwiach) i otworzy się KROK 2: krokwie (przęsła między płatwiami), #{dalej.join(', ')}." }]
      end
    end
  end
end
