# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/statyka_slupa.rb
# Zadanie: sprawdzenie słupa drewnianego ściskanego osiowo z wyboczeniem (przegubowo na obu końcach) – nośność, smukłość.
# Tematy: statyka słupa, nośność słupa, wyboczenie słupa, smukłość słupa, ściskanie wzdłuż włókien
# Zależy od: rdzen/statyka.rb (klasy drewna, k_mod)
# Używają: rdzen/statyka_zadaszenia.rb (słupy zadaszenia)
#
# Uproszczenie wg PN-EN 1995-1-1 §6.3.2 (klasa użytkowania 2 jak 1 – k_mod 0,8, obciążenie średniotrwałe): długość
# wyboczeniowa = wysokość słupa (przegub u dołu i u góry), smukłość z mniejszego wymiaru przekroju, współczynnik k_c
# (β_c 0,2 – lite, 0,1 – klejone), kombinacja 1,35 G + 1,5 Q, ciężar własny słupa doliczony. Bez zginania od wiatru
# i mimośrodu – słup wolnostojący wymaga stężenia. Wynik to podpowiedź – nie zastępuje projektu konstruktora.
# Jednostki: mm, N, MPa; siły w kN.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'statyka') unless defined?(ArteMadera::GeneratorWiencowy::Statyka)

module ArteMadera
  module GeneratorWiencowy
    module StatykaSlupa
      # Największa dopuszczalna smukłość słupa.
      SMUKLOSC_MAX = 150.0 unless const_defined?(:SMUKLOSC_MAX)

      module_function

      # Sprawdzenie słupa: l – długość wyboczeniowa [mm], b × h [mm], siły od obciążeń stałych ng i zmiennych nq [kN] bez
      # ciężaru własnego słupa. Wynik: { wyk: (wytężenie 0…), smuklosc:, kc:, n_d: [kN], ok: }.
      def sprawdz(l, b, h, ng, nq, klasa)
        k = Statyka::KLASY[klasa] || Statyka::KLASY['C24']
        a = b * h
        ciezar = k[:rho] * 9.81e-9 * a * l / 1000.0
        n_d = 1.35 * (ng + ciezar) + 1.5 * nq
        i = [b, h].min / Math.sqrt(12.0)
        smukl = l / i
        lrel = smukl / Math::PI * Math.sqrt(k[:fc0] / k[:e05])
        kc = wspolczynnik_kc(lrel, k[:lite] ? 0.2 : 0.1)
        fc0d = Statyka::KMOD * k[:fc0] / k[:gm]
        wyk = n_d * 1000.0 / a / (kc * fc0d)
        { wyk: wyk, smuklosc: smukl, kc: kc, n_d: n_d, ok: wyk <= 1.0 && smukl <= SMUKLOSC_MAX }
      end

      # Współczynnik wyboczeniowy k_c ze smukłości względnej (do 0,3 – bez wyboczenia).
      def wspolczynnik_kc(lrel, beta)
        return 1.0 if lrel <= 0.3
        kk = 0.5 * (1.0 + beta * (lrel - 0.3) + lrel * lrel)
        [1.0 / (kk + Math.sqrt(kk * kk - lrel * lrel)), 1.0].min
      end
    end
  end
end
