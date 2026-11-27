# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/stolarka_prosta.rb
# Zadanie: prosty model okna i drzwi z generatora (rama na grubość ściany, szyba albo pełne skrzydło drzwi, maskownice od zewnątrz) wstawiany w otwór, gdy nie ma pliku modelu użytkownika – części jako prostopadłościany i ich siatki.
# Tematy: prosty model stolarki, model zastępczy okna, model zastępczy drzwi, rama okna, szyba, skrzydło drzwi, maskownice, podmiana modelu stolarki
# Zależy od: rdzen/parametry.rb (grubość ściany, parametry stolarka_rama, maskownica_*), rdzen/pryzmat.rb (siatka prostopadłościanu)
# Używają: rdzen/stolarka_modele.rb (lista do wstawienia), sketchup/stolarka_modele.rb (definicja komponentu z części)
#
# Układ jak model użytkownika (rdzen/stolarka_modele.rb): punkt 0 w dolnym lewym narożniku stolarki od zewnątrz, x wzdłuż
# szerokości (0…szer), y w głąb ściany (lico zewnętrzne y = 0, wewnętrzne y = grubość ściany), z w górę (0…wys). Rama
# wypełnia grubość ściany; maskownice leżą na licu zewnętrznym (y od −grubość deski do 0) i zachodzą na ramę o zakładkę –
# zakrywają luz między stolarką a balami (przykręcone do ramy, przesuwają się po ścianie przy osiadaniu).
# Część: { nazwa:, min: [x, y, z], max: [x, y, z], szyba: true | false }.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'pryzmat') unless defined?(ArteMadera::GeneratorWiencowy::Pryzmat)

module ArteMadera
  module GeneratorWiencowy
    module StolarkaProsta
      # Grubość szyby i luz skrzydła drzwi w ramie [mm].
      SZYBA = 4.0 unless const_defined?(:SZYBA)
      LUZ_SKRZYDLA = 3.0 unless const_defined?(:LUZ_SKRZYDLA)
      SKRZYDLO = 40.0 unless const_defined?(:SKRZYDLO)

      module_function

      # Części prostego modelu stolarki rodzaju ('okno' | 'drzwi') o wymiarach szer × wys [mm] w ścianie grubości t.
      def czesci(rodzaj, szer, wys, t, p)
        w = szer.to_f
        h = wys.to_f
        r = [p['stolarka_rama'].to_f, w / 3.0, h / 3.0].min
        drzwi = rodzaj.to_s == 'drzwi'
        lista = rama(w, h, t, r, drzwi)
        lista << (drzwi ? skrzydlo(w, h, t, r) : szyba(w, h, t, r))
        lista + maskownice(w, h, r, drzwi, p)
      end

      # Rama (ościeżnica) na grubość ściany: góra i boki, w oknie także dół.
      def rama(w, h, t, r, drzwi)
        dol = drzwi ? 0.0 : r
        lista = [czesc('Rama – góra', [0.0, 0.0, h - r], [w, t, h]),
                 czesc('Rama – lewa', [0.0, 0.0, dol], [r, t, h - r]),
                 czesc('Rama – prawa', [w - r, 0.0, dol], [w, t, h - r])]
        lista.unshift(czesc('Rama – dół', [0.0, 0.0, 0.0], [w, t, r])) unless drzwi
        lista
      end

      # Szyba okna w środku grubości ramy.
      def szyba(w, h, t, r)
        g = [SZYBA, t / 4.0].min
        czesc('Szyba', [r, t / 2.0 - g / 2.0, r], [w - r, t / 2.0 + g / 2.0, h - r], true)
      end

      # Pełne skrzydło drzwi w ramie (z luzem), od podłogi.
      def skrzydlo(w, h, t, r)
        g = [SKRZYDLO, t - 2.0].min
        l = LUZ_SKRZYDLA
        czesc('Skrzydło', [r + l, t / 2.0 - g / 2.0, l], [w - r - l, t / 2.0 + g / 2.0, h - r - l])
      end

      # Maskownice od zewnątrz: góra i boki, w oknie także dół; szerokość 0 – bez maskownic.
      def maskownice(w, h, r, drzwi, p)
        m = p['maskownica_szerokosc'].to_f
        return [] if m <= 0.0
        g = p['maskownica_grubosc'].to_f
        z = [p['maskownica_zakladka'].to_f, r].min
        x0 = z - m
        x1 = w - z + m
        dol = drzwi ? 0.0 : z
        lista = [czesc('Maskownica – góra', [x0, -g, h - z], [x1, 0.0, h - z + m]),
                 czesc('Maskownica – lewa', [x0, -g, dol], [z, 0.0, h - z]),
                 czesc('Maskownica – prawa', [w - z, -g, dol], [x1, 0.0, h - z])]
        lista << czesc('Maskownica – dół', [x0, -g, z - m], [x1, 0.0, z]) unless drzwi
        lista
      end

      # Część (prostopadłościan) od min do max.
      def czesc(nazwa, min, max, szyba = false)
        { nazwa: nazwa, min: min, max: max, szyba: szyba }
      end

      # Siatka części (ściany jak w rdzen/siatka.rb) w układzie modelu stolarki.
      def siatka(c)
        x0, y0, z0 = c[:min]
        x1, y1, z1 = c[:max]
        dy = y1 - y0
        dz = z1 - z0
        Pryzmat.siatka(x1 - x0, [[0.0, 0.0], [dy, 0.0], [dy, dz], [0.0, dz]]).map do |s|
          { normalna: s[:normalna], petle: s[:petle].map { |pt| pt.map { |x, y, zz| [x + x0, y + y0, zz + z0] } } }
        end
      end

      # Nazwa definicji prostego modelu: rodzaj i wymiary (jedna definicja na rodzaj i wymiar w budowie).
      def nazwa(rodzaj, szer, wys)
        format('%s %s × %s (prosty model)', rodzaj.to_s == 'drzwi' ? 'Drzwi' : 'Okno', Parametry.fmt(szer), Parametry.fmt(wys))
      end
    end
  end
end
