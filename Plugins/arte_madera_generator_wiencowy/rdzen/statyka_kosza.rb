# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/statyka_kosza.rb
# Zadanie: statyka podparcia końca płatwi skrzydła domu L w koszu – siła ze słupka (albo oparcia) na płatew dachu głównego, doliczona do jej statyki, i docisk w poprzek włókien pod słupkiem i nad nim (PN-EN 1995-1-1, p. 6.1.5).
# Tematy: statyka kosza, słupek w koszu – siła, płatew główna – siła skupiona, docisk w poprzek włókien, reakcja płatwi skrzydła, wytyczne kosza domu L
# Zależy od: rdzen/parametry.rb, rdzen/statyka.rb (klasy drewna), rdzen/dach.rb (płatwie), rdzen/skrzydla.rb (koniec płatwi skrzydła), rdzen/statyka_dachu.rb (pas dachu, obciążenia, podpory płatwi – wczytuje ten plik)
# Używają: rdzen/statyka_dachu.rb (siła na płatwi głównej), rdzen/projekt.rb (podpowiedź o docisku)
#
# Odpowiedź użytkownika z rundy 19: „sprawdź w wytycznych dla konstruktorów / architektów / prawie budowlanym / normach”.
# Wynik sprawdzenia (docs/specyfikacja.md, „Dom L – kosz”): oparcie płatwi dobudówki (lukarny, skrzydła) na płatwi pośredniej
# dachu głównego przez krótkie słupki to zwykłe rozwiązanie ciesielskie; norma (PN-EN 1995-1-1) wymaga przy nim dwóch
# sprawdzeń, których do rundy 18 nie było: płatew dachu głównego niesie siłę skupioną od słupka (zginanie, ścinanie,
# ugięcie) i drewno pod słupkiem i nad nim jest ściskane w poprzek włókien (σc,90,d ≤ kc,90 · fc,90,d, p. 6.1.5).
# Model (uproszczony – podpowiedź, nie projekt konstruktora):
# - reakcja na słupku = belka płatwi skrzydła na dwóch podporach (słupek i najbliższa podpora po drugiej stronie) ze
#   wspornikiem do końca w koszu: R = q (L + a)² / (2 L); bez drugiej podpory – cały ciężar płatwi;
# - siła na płatwi głównej w środku jej największego przęsła (najgorzej) – zastępczo obciążenie równomierne 2 R / L
#   (ten sam moment P L / 4; ścinanie i ugięcie z zapasem);
# - docisk: pole stykowe słupka (szerokość płatwi skrzydła × szerokość płatwi głównej), długość docisku wydłużona
#   o 30 mm z obu stron (p. 6.1.5 (1)), kc,90 = 1,0 (bez podwyższenia), kmod i γM jak w rdzen/statyka.rb.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'statyka') unless defined?(ArteMadera::GeneratorWiencowy::Statyka)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'skrzydla') unless defined?(ArteMadera::GeneratorWiencowy::Skrzydla)

module ArteMadera
  module GeneratorWiencowy
    module StatykaKosza
      # Wydłużenie długości docisku z każdej strony [mm] (PN-EN 1995-1-1, p. 6.1.5 (1)).
      DOCISK_WYDLUZENIE = 30.0 unless const_defined?(:DOCISK_WYDLUZENIE)
      # Współczynnik kc,90 (bez podwyższenia 1,25 / 1,5 – po bezpiecznej stronie).
      KC90 = 1.0 unless const_defined?(:KC90)

      module_function

      # Siły od słupków (i oparć) w koszu na płatwie dachu głównego: [{ v: (oś płatwi głównej), g:, s: [N], b_skrz: }];
      # dom prostokątny albo bez podpór w koszu – [].
      def sily_glownych(dom, p)
        return [] unless dom && dom[:boczne] && Parametry.tak?(p, 'dach_elementy')
        d = dom[:boczne]
        (d[:podpory_kosz] || []).map { |podp| reakcja(d, podp, p) }.compact
      end

      # Reakcja płatwi skrzydła na słupku podp ({ v: oś płatwi skrzydła, u: oś płatwi głównej }) – { v:, g:, s:, b_skrz: }
      # albo nil (płatwi nie ma).
      def reakcja(d, podp, p)
        geo = Dach.geo(d)
        lista = Dach.platwie(geo, p)
        pl = lista.find { |x| (x[:v] - podp[:v]).abs < 0.5 }
        return nil if pl.nil?
        u0, u3 = Skrzydla.zasieg_platwi(d, pl, p)
        k = Skrzydla.koniec_w_dachu_glownym(d, pl, p)
        us = [[podp[:u], u0].max, u3].min
        pkt = StatykaDachu.podpory(d, pl, u0, u3, p)[0]
        kier = k > us ? 1.0 : -1.0
        up = pkt.select { |u| (u - us) * kier < -0.5 }.min_by { |u| (u - us).abs }
        dl = dlugosc_obciazona(up ? (us - up).abs : nil, (k - us).abs, u3 - u0)
        g, s = StatykaDachu.obciazenia(StatykaDachu.pas(geo, lista, pl, p), p)
        k_drewna = Statyka::KLASY[p['drewno_klasa']] || Statyka::KLASY['C24']
        g += k_drewna[:rho] * 9.81e-9 * pl[:b] * pl[:h]
        { v: podp[:u], g: g * dl, s: s * dl, b_skrz: pl[:b] }
      end

      # Długość płatwi „zbierająca” obciążenie na słupek [mm]: (L + a)² / 2L dla przęsła L i wspornika a; bez drugiej
      # podpory – cała długość.
      def dlugosc_obciazona(l, a, cala)
        return cala if l.nil? || l < 1.0
        (l + a)**2 / (2.0 * l)
      end

      # Suma sił od słupków na płatwi pl dachu głównego: [stałe, śnieg] w N albo nil.
      def sila(sily, pl)
        tu = sily.select { |x| (x[:v] - pl[:v]).abs < 0.5 }
        return nil if tu.empty?
        [tu.inject(0.0) { |a, x| a + x[:g] }, tu.inject(0.0) { |a, x| a + x[:s] }]
      end

      # Obciążenia płatwi gq [kN/m] powiększone o zastępcze obciążenie równomierne od siły x[:sila] (2 P / L).
      def z_sila(gq, x)
        return gq unless x[:sila] && x[:l].to_f > 1.0
        [gq[0] + 2.0 * x[:sila][0] / x[:l], gq[1] + 2.0 * x[:sila][1] / x[:l]]
      end

      # Wytężenie docisku w poprzek włókien pod słupkiem siły f (z płatwią główną szerokości b_gl): 0… (1 – granica).
      def docisk(f, b_gl, p)
        k = Statyka::KLASY[p['drewno_klasa']] || Statyka::KLASY['C24']
        fd = 1.35 * f[:g] + 1.5 * f[:s]
        w = 2.0 * DOCISK_WYDLUZENIE
        pole = [b_gl * (f[:b_skrz] + w), f[:b_skrz] * (b_gl + w)].min
        fc90d = Statyka::KMOD * k[:fc90] / k[:gm]
        fd / pole / (KC90 * fc90d)
      end

      # Podpowiedź do sekcji „Szczyty i dach”: siła od słupków w koszu i docisk (uwaga, gdy docisk > 100 %); [] bez słupków.
      def podpowiedzi(dom, p)
        sily = sily_glownych(dom, p)
        return [] if sily.empty?
        glowne = Dach.platwie(dom[:boczne][:geo_glowne], p)
        oceny = sily.map do |f|
          m = glowne.find { |x| (x[:v] - f[:v]).abs < 0.5 }
          [(1.35 * f[:g] + 1.5 * f[:s]) / 1000.0, m ? docisk(f, m[:b], p) : 0.0]
        end
        sila = oceny.map(&:first).max
        wyk = oceny.map(&:last).max
        tekst = format('Dom L – kosz: płatew skrzydła oddaje na płatew dachu głównego do %.1f kN (obliczeniowo; doliczone do jej ' \
                       'statyki), docisk w poprzek włókien pod słupkiem %.0f %% (PN-EN 1995-1-1, p. 6.1.5)', sila, wyk * 100.0)
        return [{ poziom: 'ok', tekst: tekst + '.' }] if wyk <= 1.0
        [{ poziom: 'uwaga', tekst: tekst + ' – za duży: pod słupkiem i nad nim blacha rozkładająca albo szersza płatew.' }]
      end
    end
  end
end
