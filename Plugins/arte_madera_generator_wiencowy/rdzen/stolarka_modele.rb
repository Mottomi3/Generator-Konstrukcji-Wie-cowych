# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/stolarka_modele.rb
# Zadanie: modele okien i drzwi użytkownika wstawiane w otwory – wiersz listy typowej stolarki dla otworu, plik modelu w folderze modeli, położenie modelu w otworze (punkt, osie) w układzie domu.
# Tematy: modele stolarki, model okna, model drzwi, plik modelu stolarki, folder modeli stolarki, wstawienie modelu w otwór, lista typowej stolarki – wiersz
# Zależy od: rdzen/parametry.rb (grubość ściany, lista stolarki p['stolarka'], folder p['stolarka_folder'])
# Używają: sketchup/stolarka_modele.rb (wstawienie komponentów przy generowaniu), html/otwory.js i html/klik_sciana.js (ta sama lista w oknie)
#
# Decyzja użytkownika z 2026-11-25: „w wolnym czasie zrobię modele typowych okien i drzwi, wtedy damy funkcję, by je od razu
# wstawiać do modeli”. Model = plik .skp w folderze stolarka_folder: nazwa z kolumny „Model” wiersza listy, a gdy pusta –
# symbol wiersza (np. O1.skp). Punkt 0 modelu w dolnym lewym narożniku stolarki widzianej od zewnątrz, oś X wzdłuż
# szerokości, Y w głąb ściany (do środka domu), Z w górę. Ściana zewnętrzna ma lico zewnętrzne po prawej stronie kier
# (rdzen/sciany.rb), więc „od zewnątrz” = −nor, a lewy narożnik widziany z zewnątrz leży przy s0 stolarki. Działowa – ta
# sama zasada (strona −nor jako „zewnętrzna”).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

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

      # Ścieżka pliku modelu dla wiersza listy (folder z parametru + nazwa z kolumny „Model” albo symbol); nil – brak folderu.
      def plik(p, r)
        folder = p['stolarka_folder'].to_s.strip
        return nil if folder.empty? || r.nil?
        nazwa = r['model'].to_s.strip
        nazwa = r['symbol'].to_s.strip if nazwa.empty?
        return nil if nazwa.empty?
        nazwa += ROZSZERZENIE unless nazwa.downcase.end_with?(ROZSZERZENIE)
        nazwa =~ %r{\A([A-Za-z]:)?[\\/]} ? nazwa : File.join(folder, nazwa)
      end

      # Modele do wstawienia w planie: [{ plik:, nazwa:, sciana:, typ:, polozenie: { poczatek:, x:, y:, z: },
      # szerokosc:, wysokosc: }] – otwory z typem z listy, gdy jest folder modeli.
      def do_wstawienia(plan)
        p = plan[:parametry]
        t = Parametry.grubosc(p)
        wynik = []
        (plan[:sciany] || []).each do |w|
          (w[:otwory] || []).each do |o|
            next if o[:gniazdo] || o[:stolarka].nil?
            r = wiersz(p, o[:typ])
            f = plik(p, r)
            next if f.nil?
            st = o[:stolarka]
            wynik << { plik: f, nazwa: "#{o[:nazwa]} #{r['symbol']}".strip, sciana: w[:id], typ: r['symbol'].to_s,
                       polozenie: polozenie(w, st, t), szerokosc: st[:s1] - st[:s0], wysokosc: st[:z1] - st[:z0] }
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
