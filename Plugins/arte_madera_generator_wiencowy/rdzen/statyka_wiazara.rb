# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/statyka_wiazara.rb
# Zadanie: sprawdzenie trójkąta (wiązara) nad tarasem pod obciążeniem od płatwi i automatyczny dobór jego najmniejszego wystarczającego przekroju, który mieści się pod dachem.
# Tematy: statyka wiązara, dobór przekroju trójkąta nad tarasem, automatyczny dobór wiązara, krokiew wiązara – nośność, belka wiązara na słupach – nośność, trójkąt w wąskim domu – przekrój
# Zależy od: rdzen/parametry.rb, rdzen/statyka.rb (belka, klasy drewna), rdzen/statyka_dachu.rb (pas dachu, obciążenia, lista przekrojów), rdzen/dach.rb, rdzen/skrzydla.rb (zasięg płatwi), rdzen/taras.rb (słupy frontu), rdzen/taras_wiazar.rb (front, układ, postać)
# Używają: rdzen/projekt.rb (podpowiedzi sekcji „Taras”, przekrój dobrany do następnego przebiegu obliczeń)
#
# Wymóg użytkownika (2026-11-16): w bardzo wąskich domach trójkąt z przekroju płatwi (np. 60 × 200) nie mieści się pod
# dachem, choć niesie niewiele – „do opcji dodać automatyczne dobieranie przekroju, do minimalnej nośności konstrukcji
# dachu”. Trójkąt ma rozpiętość szerokości domu (płatwie – jego długości), więc dobiera się go osobno (taras_wieniec = auto).
# Model (uproszczony – podpowiedź, nie projekt konstruktora):
# - każda płatew oddaje trójkątowi obciążenie z połowy przęsła do najbliższej ściany domu i z całego końca za trójkątem
#   (obciążenia na metr płatwi jak w rdzen/statyka_dachu.rb + ciężar własny płatwi);
# - krokiew trójkąta: belka o rozpiętości w poziomie od ściany bocznej do kalenicy, obciążona siłami od płatwi pośrednich
#   w miejscach ich gniazd; moment zamieniony na równoważne obciążenie równomierne (Statyka.belka); wysokość do obliczeń
#   pomniejszona o głębokość gniazda płatwi; zastrzały pominięte (zapas); płatew kalenicowa stoi na słupku;
# - trójkąt na słupach (bez bali frontu): belka dolna między słupami sąsiadującymi z osią, obciążona słupkiem trójkąta;
#   słup w osi kalenicy – bez zginania.
# Dobór: najlżejszy przekrój z listy płatwi, który wystarcza i przy którym mieści się cały trójkąt (belka dolna, krokwie,
# słupek); gdy żaden wystarczający się nie mieści – najlżejszy wystarczający (trójkąt w postaci uproszczonej).
# Wynik idzie do następnego przebiegu obliczeń jak przekrój płatwi (p['taras_wieniec_dobrany'], rdzen/projekt.rb).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'statyka_dachu') unless defined?(ArteMadera::GeneratorWiencowy::StatykaDachu)
require File.join(File.dirname(__FILE__), 'taras_wiazar') unless defined?(ArteMadera::GeneratorWiencowy::TarasWiazar)

module ArteMadera
  module GeneratorWiencowy
    module StatykaWiazara
      module_function

      # Czy przekrój trójkąta dobiera generator.
      def auto?(p)
        p['taras_wieniec'].to_s == 'auto'
      end

      # Siły od płatwi na trójkąt: [{ v:, rodzaj:, g:, q: }] w kN (stałe z ciężarem płatwi, śnieg) – z połowy przęsła do
      # najbliższej ściany domu i z końca płatwi za trójkątem.
      def sily(dom, u, p)
        geo = u[:geo]
        lista = Dach.platwie(geo, p)
        rho = (Statyka::KLASY[p['drewno_klasa']] || Statyka::KLASY['C24'])[:rho]
        lista.map do |pl|
          u0, u3 = Skrzydla.zasieg_platwi(dom, pl, p)
          podpory = (dom[:przejscia] || []).select { |x| (x[:v] - pl[:v]).abs < 0.5 && (x[:u] - u[:u_c]).abs > u[:bw] }.map { |x| x[:u] }
          obok = podpory.min_by { |x| (x - u[:u_c]).abs }
          dl = if obok.nil? then u3 - u0
               elsif obok < u[:u_c] then (u[:u_c] - obok) / 2.0 + (u3 - u[:u_c])
               else (obok - u[:u_c]) / 2.0 + (u[:u_c] - u0)
               end
          g, q = StatykaDachu.obciazenia(StatykaDachu.pas(geo, lista, pl, p), p)
          { v: pl[:v], rodzaj: pl[:rodzaj], g: (g + rho * 9.81e-9 * pl[:b] * pl[:h]) * dl / 1000.0, q: q * dl / 1000.0 }
        end
      end

      # Krokiew jednej strony: rozpiętość a [mm] i obciążenia równoważne [kN/m] [g, q] (ten sam największy moment co
      # siły skupione od płatwi pośrednich w odległościach x od ściany), reakcja w kalenicy [g, q] w kN.
      def krokiew(sily, v_stopy, vk)
        a = (vk - v_stopy).abs
        pkt = sily.reject { |s| s[:rodzaj] == 'kalenicowa' }.map { |s| [(s[:v] - v_stopy).abs, s[:g], s[:q]] }.select { |x, _g, _q| x > 1.0 && x < a - 1.0 }
        moment = lambda do |x, k|
          ra = pkt.inject(0.0) { |s, pt| s + pt[k] * (a - pt[0]) / a }
          ra * x - pkt.inject(0.0) { |s, pt| pt[0] < x ? s + pt[k] * (x - pt[0]) : s }
        end
        xm = pkt.map { |x, _g, _q| x }.max_by { |x| 1.35 * moment.call(x, 1) + 1.5 * moment.call(x, 2) }
        rownowazne = xm.nil? ? [0.0, 0.0] : [1, 2].map { |k| 8.0 * moment.call(xm, k) * 1000.0 / (a * a) }
        { a: a, obc: rownowazne, szczyt: [1, 2].map { |k| pkt.inject(0.0) { |s, pt| s + pt[k] * pt[0] / a } } }
      end

      # Belka dolna trójkąta na słupach: [rozpiętość między słupami przy osi, obciążenia równoważne [g, q] w kN/m] od
      # siły słupka (płatew kalenicowa i reakcje krokwi w kalenicy); nil – słup w osi kalenicy albo trójkąt na balach.
      def belka_na_slupach(front, u, sily, krokwie, p)
        return nil unless u[:bez]
        os = Taras.os_frontu(front)
        slupy = Taras.slupy_frontu(front, p)[:slupy]
        return nil if slupy.any? { |s| (s - os).abs < 1.0 }
        lewy = slupy.select { |s| s < os }.max
        prawy = slupy.select { |s| s > os }.min
        return nil if lewy.nil? || prawy.nil?
        l = prawy - lewy
        kal = sily.find { |s| s[:rodzaj] == 'kalenicowa' }
        obc = [0, 1].map do |k|
          sila = (kal ? [kal[:g], kal[:q]][k] : 0.0) + krokwie.inject(0.0) { |s, kr| s + kr[:szczyt][k] }
          8.0 * sila * (os - lewy) * (prawy - os) / l * 1000.0 / (l * l)
        end
        [l, obc]
      end

      # Ocena przekroju b × h trójkąta: { ok:, wyk:, l_przez_u:, a: (rozpiętość krokwi) } – najgorszy z krokwi obu stron
      # i belki dolnej na słupach.
      def ocena(front, u, sily, b, h, p)
        granica = p['dach_ugiecie'].to_f
        klasa = p['drewno_klasa']
        krokwie = [u[:geo][:v_a], u[:geo][:v_b]].map { |v| krokiew(sily, v, u[:vk]) }
        hk = [h - p['taras_wiazar_gniazdo'].to_f, h / 3.0].max
        ps = StatykaDachu::PSI2_SNIEG
        wyniki = krokwie.map { |kr| Statyka.belka(kr[:a], b, hk, kr[:obc][0], kr[:obc][1], klasa, granica, ps).merge(a: kr[:a]) }
        dolna = belka_na_slupach(front, u, sily, krokwie, p)
        wyniki << Statyka.belka(dolna[0], b, h, dolna[1][0], dolna[1][1], klasa, granica, ps).merge(a: krokwie[0][:a]) if dolna
        r = wyniki.max_by { |x| [x[:wyk_m], x[:wyk_v], granica / [x[:l_przez_u], 1.0].max].max }
        { ok: wyniki.all? { |x| x[:ok] }, wyk: [r[:wyk_m], r[:wyk_v]].max, l_przez_u: r[:l_przez_u], a: r[:a] }
      end

      # Czy przy przekroju bh mieści się cały trójkąt (belka dolna, krokwie, słupek).
      def miesci_sie?(front, bh, p)
        u = TarasWiazar.uklad(front, p.merge('taras_wieniec_dobrany' => Parametry.tekst_przekroju(bh)))
        !u.nil? && TarasWiazar.postac(u) == :pelny
      end

      # Przekrój z listy: najlżejszy wystarczający, przy którym mieści się cały trójkąt; inaczej najlżejszy wystarczający;
      # nil – żaden nie wystarcza.
      def dobierz(front, u, sily, p)
        dobre = StatykaDachu.kandydaci(p).select { |b, h| ocena(front, u, sily, b, h, p)[:ok] }
        dobre.find { |bh| miesci_sie?(front, bh, p) } || dobre.first
      end

      # Sprawdzenie i dobór: { podpowiedzi: [{ poziom:, tekst: }], nadpis: { 'taras_wieniec_dobrany' => 'b×h' } }; tryb jak
      # w StatykaDachu.sprawdz (:pierwszy – dobór, :potwierdz – zmiana tylko, gdy obecny nie wystarcza, :koniec – ocena).
      def sprawdz(sciany, dom, p, tryb = :pierwszy)
        wynik = { podpowiedzi: [], nadpis: {} }
        front = dom.nil? ? nil : TarasWiazar.front(sciany, p)
        u = front.nil? ? nil : TarasWiazar.uklad(front, p)
        return wynik if u.nil?
        f = sily(dom, u, p)
        bh = TarasWiazar.przekroj(p)
        r = ocena(front, u, f, bh[0], bh[1], p)
        min = dobierz(front, u, f, p)
        if auto?(p) && tryb != :koniec && !(tryb == :potwierdz && r[:ok])
          wybrany = min || StatykaDachu.kandydaci(p).last
          if wybrany && wybrany != bh
            wynik[:nadpis]['taras_wieniec_dobrany'] = Parametry.tekst_przekroju(wybrany)
            return wynik
          end
        end
        wynik[:podpowiedzi] << podpowiedz(bh, r, min, p)
        wynik
      end

      # Podpowiedź do okna: przekrój trójkąta bh z oceną r (min – dobrany z listy albo nil).
      def podpowiedz(bh, r, min, p)
        opis = if r[:wyk] < 0.01
                 format('Trójkąt nad tarasem %.0f × %.0f: krokwie bez obciążenia od płatwi pośrednich (płatew kalenicowa stoi na słupku)',
                        bh[0], bh[1])
               else
                 format('Trójkąt nad tarasem %.0f × %.0f: krokiew o rozpiętości %s m pod płatwiami – nośność %.0f %%, %s',
                        bh[0], bh[1], Parametry.fmt((r[:a] / 1000.0).round(2)), r[:wyk] * 100.0, StatykaDachu.ugiecie_opis(r[:l_przez_u]))
               end
        if r[:ok]
          dopisek = if auto?(p) then ' – dobrany automatycznie (najmniejszy wystarczający z listy przekrojów płatwi).'
                    elsif min && min != bh then format(' – wystarczy; najmniejszy wystarczający z listy: %.0f × %.0f (dobór automatyczny).', min[0], min[1])
                    else ' – wystarczy.'
                    end
          return { poziom: 'ok', tekst: opis + dopisek }
        end
        rada = min ? format('za słaby – z listy wystarczy %.0f × %.0f.', min[0], min[1]) : 'za słaby i żaden przekrój z listy nie wystarcza.'
        { poziom: 'uwaga', tekst: format('%s (granica L/%.0f) – %s', opis, p['dach_ugiecie'].to_f, rada) }
      end
    end
  end
end
