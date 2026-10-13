# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/kontrola.rb
# Zadanie: kontrola wyniku – kolizje bali w słupach zamków, mijanka styków w sąsiednich wieńcach, długości bali.
# Tematy: kontrola, kolizje, nachodzenie bali, sprawdzenie zamka, mijanka – sprawdzenie, długość – sprawdzenie, luz pionowy
# Zależy od: rdzen/bryla.rb, rdzen/bale.rb (polozenie), rdzen/zamek.rb (bale_w_zamku), rdzen/parametry.rb
# Używają: testy, sketchup/sterowanie.rb (menu „Kontrola”)
#
# Kolizje liczone dokładnie dla brył z obróbek prostokątnych: siatka komórek z granic przedziałów wszystkich bali
# w słupie zamka, w środku każdej komórki – ile bali ją zawiera.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'bryla') unless defined?(ArteMadera::GeneratorWiencowy::Bryla)
require File.join(File.dirname(__FILE__), 'bale') unless defined?(ArteMadera::GeneratorWiencowy::Bale)
require File.join(File.dirname(__FILE__), 'zamek') unless defined?(ArteMadera::GeneratorWiencowy::Zamek)

module ArteMadera
  module GeneratorWiencowy
    module Kontrola
      module_function

      # Wszystkie kontrole: { kolizje: [...], mijanka: [...], za_dlugie: [...] } (puste listy = w porządku).
      def wszystko(plan)
        { kolizje: kolizje(plan), mijanka: mijanka(plan), za_dlugie: za_dlugie(plan) }
      end

      # Kolizje w słupach zamków: [{ sciany: [id, id], punkt: [x, y], bale: [nr, nr], z: [z0, z1], objetosc: mm³ }].
      def kolizje(plan)
        p = plan[:parametry]
        t = Parametry.grubosc(p)
        profile = {}
        wynik = []
        plan[:sciany].each do |w1|
          w1[:skrzyzowania].each do |k|
            w2 = k[:inna]
            next unless w1[:k] < w2[:k]
            k2 = w2[:skrzyzowania].find { |x| x[:inna].equal?(w1) && Zamek.odl2(x[:punkt], k[:punkt]) < 0.01 }
            next if k2.nil?
            bale = Zamek.bale_w_zamku(w1, k[:s], t + 2.0) + Zamek.bale_w_zamku(w2, k2[:s], t + 2.0)
            wynik.concat(kolizje_slupa(bale, k[:punkt], t, p, profile, [w1[:id], w2[:id]]))
          end
        end
        wynik
      end

      # Kolizje w jednym słupie zamka (środek pt, bok t + 2 mm).
      def kolizje_slupa(bale, pt, t, p, profile, ids)
        r = t / 2.0 + 1.0
        uklady = bale.map do |b|
          profile[b[:nr]] ||= Bryla.profil(b[:dl], t, b[:h], b[:cechy])
          [b, Bale.polozenie(b, p), profile[b[:nr]]]
        end
        xs = [pt[0] - r, pt[0] + r]
        ys = [pt[1] - r, pt[1] + r]
        zs = []
        uklady.each do |_b, pol, prof|
          prof.each do |q|
            [[q[:xa], q[:y0], q[:zb_a]], [q[:xb], q[:y1], q[:zt_b]], [q[:xa], q[:y1], q[:zt_a]], [q[:xb], q[:y0], q[:zb_b]]].each do |lx, ly, lz|
              g = globalny(pol, lx, ly, lz)
              xs << g[0] if (g[0] - pt[0]).abs < r
              ys << g[1] if (g[1] - pt[1]).abs < r
              zs << g[2]
            end
          end
        end
        xs = xs.map { |v| v.round(4) }.uniq.sort
        ys = ys.map { |v| v.round(4) }.uniq.sort
        zs = zs.map { |v| v.round(4) }.uniq.sort
        wynik = []
        zs.each_cons(2) do |z0, z1|
          zm = (z0 + z1) / 2.0
          w_z = uklady.select { |b, _pol, _prof| zm > b[:z0] && zm < b[:z0] + b[:h] }
          next if w_z.length < 2
          xs.each_cons(2) do |x0, x1|
            ys.each_cons(2) do |y0, y1|
              c = [(x0 + x1) / 2.0, (y0 + y1) / 2.0, zm]
              trafione = w_z.select { |_b, pol, prof| zawiera_globalnie?(pol, prof, c) }
              next if trafione.length < 2
              wynik << { sciany: ids, punkt: [c[0].round(2), c[1].round(2)], bale: trafione.map { |b, _x, _y| b[:nr] },
                         z: [z0.round(2), z1.round(2)], objetosc: (x1 - x0) * (y1 - y0) * (z1 - z0) }
            end
          end
        end
        wynik
      end

      # Punkt bala (układ bala) w układzie domu.
      def globalny(pol, lx, ly, lz)
        o = pol[:poczatek]
        [o[0] + pol[:x][0] * lx + pol[:y][0] * ly, o[1] + pol[:x][1] * lx + pol[:y][1] * ly, o[2] + lz]
      end

      # Czy punkt domu leży w bryle bala.
      def zawiera_globalnie?(pol, prof, c)
        o = pol[:poczatek]
        d = [c[0] - o[0], c[1] - o[1]]
        lx = d[0] * pol[:x][0] + d[1] * pol[:x][1]
        ly = d[0] * pol[:y][0] + d[1] * pol[:y][1]
        Bryla.zawiera?(prof, lx, ly, c[2] - o[2])
      end

      # Naruszenia mijanki: [{ sciana:, wieniec:, odstep: }] – styki w sąsiednich wieńcach bliżej niż MIJANKA_MIN.
      def mijanka(plan)
        wynik = []
        plan[:sciany].each do |w|
          next if w[:rodzaj] == :kontrfor
          wg = {}
          w[:bale].each do |b|
            wg[b[:i]] ||= []
            wg[b[:i]] << b[:s1] if b[:konce][1] == :styk
          end
          wg.keys.sort.each do |i|
            nast = wg[i + 1]
            next if nast.nil?
            wg[i].each do |s|
              nast.each do |s2|
                odl = (s - s2).abs
                wynik << { sciana: w[:id], wieniec: i + 1, odstep: odl.round(1) } if odl < Parametry::MIJANKA_MIN - 0.01
              end
            end
          end
        end
        wynik
      end

      # Bale dłuższe od maksymalnej długości: [{ sciana:, nazwa:, dl: }].
      def za_dlugie(plan)
        lmax = plan[:parametry]['max_dlugosc'].to_f
        plan[:bale].select { |b| b[:dl] > lmax + 0.5 }.map do |b|
          { sciana: b[:sciana][:id], nazwa: b[:pozycja] ? b[:pozycja][:nazwa] : '', dl: b[:dl].round }
        end
      end
    end
  end
end
