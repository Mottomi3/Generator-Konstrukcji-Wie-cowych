# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/geometria.rb
# Zadanie: działania na punktach 2D/3D (tablice [x, y] / [x, y, z] w mm) bez API SketchUpa.
# Tematy: wektory, odległości, przecięcia odcinków, obrót układu, tolerancje, zaokrąglenia
# Zależy od: –
# Używają: wszystkie pliki rdzen/
#
# Punkty są zwykłymi tablicami liczb Float, żeby rdzeń dało się testować bez SketchUpa.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module Geometria
      # Tolerancja położenia [mm] – punkty bliżej siebie są tym samym punktem.
      TOL = 0.01 unless const_defined?(:TOL)
      # Tolerancja kąta [rad] przy sprawdzaniu równoległości (≈ 0,5°).
      TOL_KATA = 0.0087 unless const_defined?(:TOL_KATA)

      module_function

      # Różnica a − b (2D).
      def sub(a, b)
        [a[0] - b[0], a[1] - b[1]]
      end

      # Suma a + b (2D).
      def add(a, b)
        [a[0] + b[0], a[1] + b[1]]
      end

      # Wektor razy liczba (2D).
      def mul(a, k)
        [a[0] * k, a[1] * k]
      end

      # Iloczyn skalarny (2D).
      def dot(a, b)
        a[0] * b[0] + a[1] * b[1]
      end

      # Iloczyn wektorowy – składowa z (2D).
      def cross(a, b)
        a[0] * b[1] - a[1] * b[0]
      end

      # Długość wektora (2D).
      def dl(a)
        Math.sqrt(a[0] * a[0] + a[1] * a[1])
      end

      # Odległość punktów (2D).
      def odl(a, b)
        dl(sub(a, b))
      end

      # Wektor jednostkowy (2D); zerowy zostaje zerowy.
      def norm(a)
        d = dl(a)
        d < 1e-12 ? [0.0, 0.0] : [a[0] / d, a[1] / d]
      end

      # Wektor obrócony o +90° (w lewo).
      def lewa(a)
        [-a[1], a[0]]
      end

      # Punkt obrócony o kąt [rad] wokół początku układu.
      def obroc(p, kat)
        c = Math.cos(kat)
        s = Math.sin(kat)
        [p[0] * c - p[1] * s, p[0] * s + p[1] * c]
      end

      # Czy punkty są równe w tolerancji.
      def rowne?(a, b, tol = TOL)
        (a[0] - b[0]).abs <= tol && (a[1] - b[1]).abs <= tol
      end

      # Rzut punktu p na prostą a→b: [t (0..1 na odcinku), odległość od prostej, punkt rzutu].
      def rzut(p, a, b)
        ab = sub(b, a)
        d2 = dot(ab, ab)
        return [0.0, odl(p, a), a] if d2 < 1e-18
        t = dot(sub(p, a), ab) / d2
        q = add(a, mul(ab, t))
        [t, odl(p, q), q]
      end

      # Czy punkt leży na odcinku a–b (z końcami) w tolerancji tol.
      def na_odcinku?(p, a, b, tol = TOL)
        t, d, _q = rzut(p, a, b)
        len = odl(a, b)
        return d <= tol if len < 1e-12
        d <= tol && t * len >= -tol && t * len <= len + tol
      end

      # Przecięcie odcinków a–b i c–d: [punkt, ta, tc] albo nil (równoległe lub rozłączne).
      def przeciecie(a, b, c, d, tol = TOL)
        r = sub(b, a)
        s = sub(d, c)
        den = cross(r, s)
        return nil if den.abs < 1e-12
        qp = sub(c, a)
        ta = cross(qp, s) / den
        tc = cross(qp, r) / den
        la = dl(r)
        lc = dl(s)
        return nil if ta * la < -tol || ta * la > la + tol || tc * lc < -tol || tc * lc > lc + tol
        [add(a, mul(r, ta)), ta, tc]
      end

      # Przecięcie prostych (nie odcinków) a→b i c→d; nil dla równoległych.
      def przeciecie_prostych(a, b, c, d)
        r = sub(b, a)
        s = sub(d, c)
        den = cross(r, s)
        return nil if den.abs < 1e-12
        ta = cross(sub(c, a), s) / den
        add(a, mul(r, ta))
      end

      # Pole wielokąta ze znakiem (dodatnie = przeciwnie do ruchu wskazówek zegara).
      def pole(punkty)
        n = punkty.length
        s = 0.0
        n.times do |i|
          a = punkty[i]
          b = punkty[(i + 1) % n]
          s += a[0] * b[1] - b[0] * a[1]
        end
        s / 2.0
      end

      # Czy punkt jest wewnątrz wielokąta (promień w prawo; brzeg – nieokreślony).
      def wewnatrz?(p, punkty)
        wynik = false
        n = punkty.length
        j = n - 1
        n.times do |i|
          a = punkty[i]
          b = punkty[j]
          if (a[1] > p[1]) != (b[1] > p[1])
            x = (b[0] - a[0]) * (p[1] - a[1]) / (b[1] - a[1]) + a[0]
            wynik = !wynik if p[0] < x
          end
          j = i
        end
        wynik
      end

      # Zaokrąglenie do siatki tol (usuwa szum obliczeń przy porównaniach i kluczach).
      def zaokr(x, krok = 0.001)
        (x / krok).round * krok
      end

      # Klucz punktu do słowników (zaokrąglony).
      def klucz(p, krok = 0.001)
        p.map { |v| (v / krok).round }
      end

      # Punkt do komunikatu: „(x; y)” w mm.
      def txt(pt)
        format('(%.0f; %.0f)', pt[0], pt[1])
      end

      # Różnica a − b (3D).
      def sub3(a, b)
        [a[0] - b[0], a[1] - b[1], a[2] - b[2]]
      end

      # Iloczyn wektorowy (3D).
      def cross3(a, b)
        [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]]
      end

      # Iloczyn skalarny (3D).
      def dot3(a, b)
        a[0] * b[0] + a[1] * b[1] + a[2] * b[2]
      end

      # Długość wektora (3D).
      def dl3(a)
        Math.sqrt(dot3(a, a))
      end

      # Suma przedziałów [a, b] (scalanie zachodzących i stykających się w tolerancji).
      def scal_przedzialy(przedzialy, tol = TOL)
        lista = przedzialy.map { |p| [[p[0], p[1]].min, [p[0], p[1]].max] }.sort_by { |p| p[0] }
        wynik = []
        lista.each do |p|
          if wynik.empty? || p[0] > wynik.last[1] + tol
            wynik << [p[0], p[1]]
          elsif p[1] > wynik.last[1]
            wynik.last[1] = p[1]
          end
        end
        wynik
      end

      # Przedział [a, b] pomniejszony o listę przedziałów (wynik: lista kawałków o długości > tol).
      def odejmij_przedzialy(a, b, dziury, tol = TOL)
        kawalki = [[a, b]]
        scal_przedzialy(dziury, tol).each do |d|
          nowe = []
          kawalki.each do |k|
            if d[1] <= k[0] + tol || d[0] >= k[1] - tol
              nowe << k
            else
              nowe << [k[0], d[0]] if d[0] - k[0] > tol
              nowe << [d[1], k[1]] if k[1] - d[1] > tol
            end
          end
          kawalki = nowe
        end
        kawalki
      end
    end
  end
end
