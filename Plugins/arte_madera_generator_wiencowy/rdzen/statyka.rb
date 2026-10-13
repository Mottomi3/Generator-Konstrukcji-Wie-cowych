# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/statyka.rb
# Zadanie: sprawdzenie belki drewnianej swobodnie podpartej (zginanie, ścinanie, ugięcie końcowe), największa rozpiętość, dobór przekroju z katalogu.
# Tematy: statyka, legar – sprawdzenie, nośność belki, ugięcie, pełzanie, klasa drewna, C24, dobór przekroju, rozpiętość legara, izolacja a wysokość legara
# Zależy od: rdzen/parametry.rb
# Używają: rdzen/podloga.rb
#
# Uproszczenie wg PN-EN 1995-1-1 (klasa użytkowania 1, obciążenie średniotrwałe): k_mod 0,8, k_def 0,6, ψ2 0,3 (kat. A),
# γM 1,3 (lite) / 1,25 (klejone), kombinacja 1,35 G + 1,5 Q, k_cr 0,67, k_h dla niskich przekrojów.
# Jednostki: mm, N, MPa; obciążenia w kN/m = N/mm. Wynik to podpowiedź – nie zastępuje projektu konstruktora.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module Statyka
      # Klasy drewna: wytrzymałość na zginanie i ścinanie f_m,k, f_v,k [MPa], moduł E0,mean [MPa], gęstość [kg/m³], γM.
      KLASY = {
        'C18' => { fm: 18.0, fv: 3.4, e: 9000.0, rho: 380.0, gm: 1.3, lite: true },
        'C24' => { fm: 24.0, fv: 4.0, e: 11_000.0, rho: 420.0, gm: 1.3, lite: true },
        'C30' => { fm: 30.0, fv: 4.0, e: 12_000.0, rho: 460.0, gm: 1.3, lite: true },
        'GL24h' => { fm: 24.0, fv: 3.5, e: 11_500.0, rho: 420.0, gm: 1.25, lite: false }
      }.freeze unless const_defined?(:KLASY)
      KMOD = 0.8 unless const_defined?(:KMOD)
      KDEF = 0.6 unless const_defined?(:KDEF)
      PSI2 = 0.3 unless const_defined?(:PSI2)
      KCR = 0.67 unless const_defined?(:KCR)

      module_function

      # Sprawdzenie belki: l [mm], b × h [mm], obciążenia stałe g i użytkowe q [kN/m] bez ciężaru własnego, granica L/n.
      # Wynik: { wyk_m:, wyk_v:, u:, l_przez_u:, nosnosc_ok:, ugiecie_ok:, ok: }.
      def belka(l, b, h, g, q, klasa, granica)
        k = KLASY[klasa] || KLASY['C24']
        gc = g + k[:rho] * 9.81e-9 * b * h
        qd = 1.35 * gc + 1.5 * q
        m = qd * l * l / 8.0
        v = qd * l / 2.0
        kh = k[:lite] ? [[(150.0 / h)**0.2, 1.3].min, 1.0].max : [[(600.0 / h)**0.1, 1.1].min, 1.0].max
        fmd = KMOD * kh * k[:fm] / k[:gm]
        fvd = KMOD * k[:fv] / k[:gm]
        wyk_m = m / (b * h * h / 6.0) / fmd
        wyk_v = 1.5 * v / (KCR * b * h) / fvd
        ei = k[:e] * b * h**3 / 12.0
        u = 5.0 * l**4 / (384.0 * ei) * (gc * (1.0 + KDEF) + q * (1.0 + PSI2 * KDEF))
        lu = u > 0 ? l / u : 1.0e9
        nos = [wyk_m, wyk_v].max <= 1.0
        ug = lu >= granica - 1e-6
        { wyk_m: wyk_m, wyk_v: wyk_v, u: u, l_przez_u: lu, nosnosc_ok: nos, ugiecie_ok: ug, ok: nos && ug }
      end

      # Obciążenia legara [kN/m] z parametrów i rozstawu: [g, q].
      def obciazenia(p, rozstaw)
        [p['obciazenie_stale'].to_f * rozstaw / 1000.0, p['obciazenie_uzytkowe'].to_f * rozstaw / 1000.0]
      end

      # Największa rozpiętość [mm], przy której belka spełnia nośność i ugięcie L/granica (szukanie połówkowe).
      def max_rozpietosc(b, h, p, rozstaw, granica)
        g, q = obciazenia(p, rozstaw)
        lo = 100.0
        hi = 20_000.0
        return 0.0 unless belka(lo, b, h, g, q, p['drewno_klasa'], granica)[:ok]
        40.times do
          mid = (lo + hi) / 2.0
          belka(mid, b, h, g, q, p['drewno_klasa'], granica)[:ok] ? lo = mid : hi = mid
        end
        lo
      end

      # Przekroje z katalogu nie niższe niż izolacja, od najlżejszego (przy równym polu – wyższy pierwszy).
      def kandydaci(p)
        izol = p['izolacja_podlogi'].to_f
        Parametry.katalog(p).select { |b, h| h >= izol - 0.01 }.sort_by { |b, h| [b * h, -h] }
      end

      # Najlżejszy przekrój z katalogu (nie niższy niż izolacja), który przenosi rozpiętość l; nil gdy żaden.
      def dobierz(l, p, rozstaw, granica)
        g, q = obciazenia(p, rozstaw)
        kandydaci(p).find { |b, h| belka(l, b, h, g, q, p['drewno_klasa'], granica)[:ok] }
      end

      # Granica ugięcia L/n dla trybu doboru ('minimalny' – dopuszczalna, inne – zalecana).
      def granica(p, tryb = p['legary_dobor'])
        tryb == 'minimalny' ? p['ugiecie_minimalne'].to_f : p['ugiecie_zalecane'].to_f
      end
    end
  end
end
