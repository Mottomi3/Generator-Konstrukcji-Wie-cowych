# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/stolarka_modele.rb
# Zadanie: modele okien i drzwi wstawiane w otwory – wiersz listy typowej stolarki dla otworu, plik modelu (pełna ścieżka z kolumny „Model” albo nazwa w folderze modeli), prosty model z generatora, gdy pliku nie ma, położenie modelu w otworze (punkt, osie) w układzie domu.
# Tematy: modele stolarki, model okna, model drzwi, plik modelu stolarki, ścieżka modelu stolarki, folder modeli stolarki, wstawienie modelu w otwór, lista typowej stolarki – wiersz, rodzaj otworu okno / drzwi
# Zależy od: rdzen/parametry.rb (grubość ściany, lista stolarki p['stolarka'], folder p['stolarka_folder'], p['stolarka_prosta']), rdzen/stolarka_prosta.rb (części prostego modelu)
# Używają: sketchup/stolarka_modele.rb (wstawienie komponentów przy generowaniu), html/otwory.js i html/klik_sciana.js (ta sama lista w oknie)
#
# Decyzje użytkownika: 2026-11-25 – „w wolnym czasie zrobię modele typowych okien i drzwi, wtedy damy funkcję, by je od razu
# wstawiać do modeli”; 2026-11-27 – modeli jeszcze nie ma, ścieżka do wpisania „da mi możliwość podmiany modeli”. Model =
# plik .skp: pełna ścieżka z kolumny „Model” wiersza listy albo nazwa (z kolumny „Model”, a gdy pusta – symbol wiersza,
# np. O1.skp) w folderze stolarka_folder. Otwór bez pliku (bez typu, bez folderu, plik nie istnieje) dostaje prosty model
# z generatora (rdzen/stolarka_prosta.rb), gdy stolarka_prosta = tak. Punkt 0 modelu w dolnym lewym narożniku stolarki
# widzianej od zewnątrz, oś X wzdłuż szerokości, Y w głąb ściany (do środka domu), Z w górę. Ściana zewnętrzna ma lico
# zewnętrzne po prawej stronie kier (rdzen/sciany.rb), więc „od zewnątrz” = −nor, a lewy narożnik widziany z zewnątrz leży
# przy s0 stolarki. Działowa – ta sama zasada (strona −nor jako „zewnętrzna”).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'stolarka_prosta') unless defined?(ArteMadera::GeneratorWiencowy::StolarkaProsta)

module ArteMadera
  module GeneratorWiencowy
    module StolarkaModele
      # Rozszerzenie pliku modelu dopisywane, gdy w kolumnie „Model” go nie ma.
      ROZSZERZENIE = '.skp'.freeze unless const_defined?(:ROZSZERZENIE)

      module_function

      # Wiersz listy typowej stolarki o symbolu (wielkość liter bez znaczenia); nil – brak.
      def wiersz(p, symbol)
        s = symbol.to_s.strip.downcase
        return nil if s.empty?
        (p['stolarka'] || []).find { |r| r['symbol'].to_s.strip.downcase == s }
      end

      # Ścieżka pliku modelu dla wiersza listy: pełna ścieżka z kolumny „Model” (bez folderu modeli) albo nazwa z kolumny
      # „Model” lub symbol w folderze modeli; nil – brak wiersza, nazwy albo folderu dla samej nazwy.
      def plik(p, r)
        return nil if r.nil?
        nazwa = r['model'].to_s.strip
        nazwa = r['symbol'].to_s.strip if nazwa.empty?
        return nil if nazwa.empty?
        nazwa += ROZSZERZENIE unless nazwa.downcase.end_with?(ROZSZERZENIE)
        return nazwa if pelna_sciezka?(nazwa)
        folder = p['stolarka_folder'].to_s.strip
        folder.empty? ? nil : File.join(folder, nazwa)
      end

      # Czy tekst jest pełną ścieżką (C:\…, C:/…, \\serwer\…, /…).
      def pelna_sciezka?(t)
        t =~ %r{\A([A-Za-z]:)?[\\/]} ? true : false
      end

      # Rodzaj otworu: z wiersza listy stolarki, a bez typu – drzwi, gdy stolarka zaczyna się na spodzie ściany (spód 0).
      def rodzaj(r, st)
        return r['rodzaj'].to_s if r && !r['rodzaj'].to_s.empty?
        st[:z0].abs < 0.5 ? 'drzwi' : 'okno'
      end

      # Modele do wstawienia w planie: [{ plik: (nil – brak pliku), prosty: (części prostego modelu albo nil), nazwa:,
      # sciana:, typ:, rodzaj:, polozenie: { poczatek:, x:, y:, z: }, szerokosc:, wysokosc: }] – każdy otwór ze stolarką,
      # który ma plik modelu albo dostaje prosty model (stolarka_prosta = tak).
      def do_wstawienia(plan)
        p = plan[:parametry]
        t = Parametry.grubosc(p)
        prosty = p['stolarka_prosta'].to_s != 'nie'
        wynik = []
        (plan[:sciany] || []).each do |w|
          (w[:otwory] || []).each do |o|
            next if o[:gniazdo] || o[:stolarka].nil?
            r = wiersz(p, o[:typ])
            f = plik(p, r)
            next if f.nil? && !prosty
            st = o[:stolarka]
            sz = st[:s1] - st[:s0]
            wy = st[:z1] - st[:z0]
            rd = rodzaj(r, st)
            wynik << { plik: f, prosty: prosty ? StolarkaProsta.czesci(rd, sz, wy, t, p) : nil, rodzaj: rd,
                       nazwa: "#{o[:nazwa]} #{r ? r['symbol'] : ''}".strip, sciana: w[:id], typ: r ? r['symbol'].to_s : '',
                       polozenie: polozenie(w, st, t), szerokosc: sz, wysokosc: wy }
          end
        end
        wynik
      end

      # Położenie modelu: punkt 0 – lico „zewnętrzne” ściany (−nor) przy s0 stolarki na wysokości jej spodu; osie X = kier,
      # Y = nor (w głąb ściany), Z = pion. Układ domu (mm, jak położenie belek – Konwersja.transformacja_elementu).
      def polozenie(w, st, t)
        a = w[:a]
        k = w[:kier]
        n = w[:nor]
        x = a[0] + k[0] * st[:s0] - n[0] * t / 2.0
        y = a[1] + k[1] * st[:s0] - n[1] * t / 2.0
        { poczatek: [x, y, st[:z0]], x: [k[0], k[1], 0.0], y: [n[0], n[1], 0.0], z: [0.0, 0.0, 1.0] }
      end
    end
  end
end
