# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/statyka_zadaszenia.rb
# Zadanie: sprawdzenie i dobór przekrojów bocznego zadaszenia – płatwie i oczep (przęsło między słupami albo ścianami, pas połaci zadaszenia), belki poprzeczne (od słupa do ściany domu) i słupy (ściskanie z wyboczeniem); automatycznie najmniejszy wystarczający z list albo przekroje z wyboru użytkownika ze sprawdzeniem.
# Tematy: statyka zadaszenia, dobór przekroju zadaszenia, automatyczny dobór zadaszenia, płatew zadaszenia – nośność, oczep – nośność, belka poprzeczna – nośność, słup zadaszenia – nośność, pas połaci zadaszenia, obciążenie zadaszenia
# Zależy od: rdzen/parametry.rb, rdzen/statyka.rb (belka), rdzen/statyka_slupa.rb (słup), rdzen/statyka_dachu.rb (obciążenia, przęsło płatwi, opis ugięcia), rdzen/dach.rb, rdzen/zadaszenie.rb (płatwie, linie słupów), rdzen/skrzydla.rb (zasięg płatwi)
# Używają: rdzen/projekt.rb (podpowiedzi sekcji „Zadaszenie – przekroje”, przekroje dobrane do następnego przebiegu)
#
# Wymóg użytkownika (2026-11-25): „płatwie, słupy, krokwie niech są dobierane z minimalnego przekroju jako automatyczne,
# lub z wyboru przekroju użytkownika”. Model (uproszczony jak rdzen/statyka_dachu.rb – podpowiedź, nie projekt):
# - obciążenia jak dach (ciężar pokrycia, śnieg gruntu × μ), ale przy kącie zadaszenia;
# - płatew i oczep: przęsło między podporami – linie słupów (belka poprzeczna pod płatwią, słupek) i ściany, przez które
#   płatew przechodzi (ostatki i ściany szczytowe, ściany przybudówki); koniec za szczytem jak wspornik; pas połaci –
#   połowa odległości do sąsiednich płatwi zadaszenia (pierwsza – od załamania, ostatnia – do okapu zadaszenia);
# - belka poprzeczna: swobodnie podparta na słupie i ścianie domu, obciążenie równomierne z pasa zadaszenia między
#   sąsiednimi liniami słupów (skrajne – z wysunięciem za szczyt);
# - słup: ściskanie osiowe z wyboczeniem na całej wysokości (fundament – belka), obciążenie z połowy szerokości
#   zadaszenia i okapu na tym samym pasie wzdłuż ściany; ciężar belki poprzecznej doliczony.
# Grupy o wspólnym przekroju: płatwie z oczepem, belki poprzeczne, słupy. Dobór (zadaszenie_dobor = auto) – najlżejszy
# przekrój z listy spełniający warunki dla całej grupy; wynik idzie do następnego przebiegu obliczeń (rdzen/projekt.rb).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'statyka') unless defined?(ArteMadera::GeneratorWiencowy::Statyka)
require File.join(File.dirname(__FILE__), 'statyka_slupa') unless defined?(ArteMadera::GeneratorWiencowy::StatykaSlupa)
require File.join(File.dirname(__FILE__), 'statyka_dachu') unless defined?(ArteMadera::GeneratorWiencowy::StatykaDachu)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'zadaszenie') unless defined?(ArteMadera::GeneratorWiencowy::Zadaszenie)
require File.join(File.dirname(__FILE__), 'skrzydla') unless defined?(ArteMadera::GeneratorWiencowy::Skrzydla)
require File.join(File.dirname(__FILE__), 'dlugosci_handlowe') unless defined?(ArteMadera::GeneratorWiencowy::DlugosciHandlowe)

module ArteMadera
  module GeneratorWiencowy
    module StatykaZadaszenia
      # Pola przekrojów grup i nazwy do komunikatów.
      PLATWIE = 'zadaszenie_platwa_przekroj' unless const_defined?(:PLATWIE)
      BELKI = 'zadaszenie_belka_przekroj' unless const_defined?(:BELKI)
      SLUPY = 'zadaszenie_slup_przekroj' unless const_defined?(:SLUPY)
      NAZWY = { PLATWIE => 'Płatwie zadaszenia (z oczepem)', BELKI => 'Belki poprzeczne zadaszenia',
                SLUPY => 'Słupy zadaszenia' }.freeze unless const_defined?(:NAZWY)
      # Lista przekrojów do doboru dla pola.
      KATALOGI = { PLATWIE => 'zadaszenie_katalog', BELKI => 'zadaszenie_katalog',
                   SLUPY => 'zadaszenie_slupy_katalog' }.freeze unless const_defined?(:KATALOGI)

      module_function

      # Czy przekroje zadaszenia dobiera generator.
      def auto?(p)
        p['zadaszenie_dobor'].to_s == 'auto'
      end

      # Kąt zadaszenia [°].
      def kat(p)
        p['zadaszenie_kat'].to_f
      end

      # Obciążenia na metr kwadratowy rzutu zadaszenia [kN/m²]: [stałe, śnieg].
      def na_metr(p)
        StatykaDachu.obciazenia(1000.0, p, kat(p))
      end

      # Szerokości pasów połaci zadaszenia [mm w poziomie] dla płatwi strona (w kolejności listy): połowa odległości do
      # sąsiednich linii podparcia (płatwie, ściana nośna przybudówki); pierwsza – od załamania, ostatnia – do okapu.
      def pasy(c, strona, p)
        t = Parametry.grubosc(p)
        d = lambda { |v| (v - c[:v_k]) * c[:kier] }
        linie = strona.map { |pl| d.call(pl[:v]) }
        if p['zadaszenie'] == 'bale' && strona.none? { |pl| pl[:rodzaj] == 'zadaszenie_scienna' }
          linie << d.call(c[:v_s] - c[:kier] * t / 2.0)
        end
        linie = linie.sort
        koniec = d.call(c[:v_s]) + p['zadaszenie_okap'].to_f
        strona.map do |pl|
          x = d.call(pl[:v])
          i = linie.index { |y| (y - x).abs < 0.01 } || 0
          (i > 0 ? (x - linie[i - 1]) / 2.0 : x) + (i < linie.length - 1 ? (linie[i + 1] - x) / 2.0 : koniec - x)
        end
      end

      # Pasy wzdłuż ściany na linie słupów [mm]: połowa odległości do sąsiednich linii, skrajne – z wysunięciem za szczyt.
      def pasy_u(linie, p)
        us = linie.map { |x| x[:u] }
        wysuniecie = p['dach_okap_szczyt'].to_f + Parametry.grubosc(p) / 2.0
        us.each_with_index.map do |u, i|
          (i > 0 ? (u - us[i - 1]) / 2.0 : wysuniecie) + (i < us.length - 1 ? (us[i + 1] - u) / 2.0 : wysuniecie)
        end
      end

      # Człony zadaszenia domu do sprawdzenia: { PLATWIE => [{ l:, pas:, rodzaj: }], BELKI => [{ l:, pas: }],
      # SLUPY => [{ l:, a: (pole rzutu [m²]), g_wl: (ciężar belki i oczepu [kN]) }] }; bez zadaszenia – {}.
      def czlony(dom, sciany, p)
        wynik = { PLATWIE => [], BELKI => [], SLUPY => [] }
        return {} if dom.nil? || !Parametry.tak?(p, 'dach_elementy')
        geo = Dach.geo(dom)
        return {} if geo[:zad].nil?
        lista = Zadaszenie.platwie(geo, p)
        bb, hb = Parametry.przekroj(p, BELKI)
        bo, ho = Parametry.przekroj(p, PLATWIE)
        rho = (Statyka::KLASY[p['drewno_klasa']] || Statyka::KLASY['C24'])[:rho]
        geo[:zad].each do |c|
          strona = lista.select { |pl| pl[:kier] == c[:kier] }
          linie = Zadaszenie.linie_slupow(dom, geo, c, sciany, p, lista)
          pasy(c, strona, p).each_with_index do |pas, i|
            pl = strona[i]
            u0, u3 = Skrzydla.zasieg_platwi(dom, pl, p)
            next if u3 - u0 < 1.0
            dod = linie.select { |x| pl[:rodzaj] == 'oczep' || Zadaszenie.nad_belka?(pl, c, x[:v_konca]) }.map { |x| { v: pl[:v], u: x[:u] } }
            d = { przejscia: (dom[:przejscia] || []) + dod, podparcia: dom[:podparcia] || [] }
            wynik[PLATWIE] << { l: StatykaDachu.przeslo(d, pl, u0, u3, p), pas: pas, rodzaj: pl[:rodzaj], dl: u3 - u0 }
          end
          koniec = (c[:v_s] - c[:v_k]) * c[:kier] + p['zadaszenie_okap'].to_f
          pasy_u(linie, p).each_with_index do |pas_u, i|
            x = linie[i]
            l_belki = (x[:v_slupa] - x[:v_konca]).abs
            wynik[BELKI] << { l: l_belki, pas: pas_u, dl: l_belki }
            szer = l_belki / 2.0 + koniec - (x[:v_slupa] - c[:v_k]) * c[:kier]
            # Ciężar własny na słup: połowa belki poprzecznej i oczep na pasie słupa [kN].
            g_wl = rho * 9.81e-12 * (bb * hb * l_belki / 2.0 + bo * ho * pas_u)
            wynik[SLUPY] << { l: x[:z_slupa] - x[:z_dol], a: pas_u * szer / 1.0e6, g_wl: g_wl, dl: x[:z_slupa] - x[:z_dol] }
          end
        end
        wynik.reject { |_k, v| v.empty? }
      end

      # Wysokość płatwi do obliczeń: ścięta do połaci zadaszenia – średnia wysokość przekroju (jak płatwie dachu).
      def wysokosc(b, h, p)
        return h unless Parametry.tak?(p, 'platwie_sciecie')
        [h - b * Zadaszenie.tg(p) * 0.5, h / 3.0].max
      end

      # Ocena przekroju b × h dla grupy pola – najbardziej wytężony człon: { ok:, wyk:, l_przez_u: (belki), l:, pas:,
      # smuklosc:, n_d: (słupy) }.
      def ocena(pole, grupa, b, h, p)
        granica = p['dach_ugiecie'].to_f
        if pole == SLUPY
          g, q = na_metr(p)
          return grupa.map do |x|
            r = StatykaSlupa.sprawdz(x[:l], b, h, g * x[:a] + x[:g_wl], q * x[:a], p['drewno_klasa'])
            r.merge(l: x[:l])
          end.max_by { |r| [r[:wyk], r[:smuklosc] / StatykaSlupa::SMUKLOSC_MAX].max }
        end
        grupa.map do |x|
          g, q = StatykaDachu.obciazenia(x[:pas], p, kat(p))
          hh = pole == PLATWIE ? wysokosc(b, h, p) : h
          r = Statyka.belka(x[:l], b, hh, g, q, p['drewno_klasa'], granica, StatykaDachu::PSI2_SNIEG)
          { ok: r[:ok], wyk: [r[:wyk_m], r[:wyk_v]].max, l_przez_u: r[:l_przez_u], l: x[:l], pas: x[:pas] }
        end.max_by { |r| [r[:wyk], granica / [r[:l_przez_u], 1.0].max].max }
      end

      # Przekroje do doboru dla pola – od najlżejszego (przy równym polu wyższy pierwszy).
      def kandydaci(pole, p)
        Parametry.katalog(p, KATALOGI[pole]).sort_by { |b, h| [b * h, -h] }
      end

      # Najlżejszy przekrój z listy wystarczający dla grupy – w pierwszej kolejności dostępny w hurtowni w całej długości
      # najdłuższego członu grupy (rdzen/dlugosci_handlowe.rb); nil – żaden nie wystarcza.
      def dobierz(pole, grupa, p)
        dobre = kandydaci(pole, p).select { |b, h| ocena(pole, grupa, b, h, p)[:ok] }
        DlugosciHandlowe.najlzejszy(dobre, grupa.map { |x| x[:dl] }.compact.max, p, KATALOGI[pole])
      end

      # Sprawdzenie i dobór zadaszenia domu: { podpowiedzi: [{ poziom:, tekst: }], nadpis: { pole => 'b×h' } }; tryb jak
      # StatykaDachu.sprawdz (:pierwszy, :potwierdz, :koniec).
      def sprawdz(dom, sciany, p, tryb = :pierwszy)
        wynik = { podpowiedzi: [], nadpis: {} }
        return wynik unless Zadaszenie.aktywne?(p)
        czlony(dom, sciany, p).each do |pole, grupa|
          b, h = Parametry.przekroj(p, pole)
          r = ocena(pole, grupa, b, h, p)
          min = dobierz(pole, grupa, p)
          if auto?(p) && tryb != :koniec && !(tryb == :potwierdz && r[:ok])
            wybrany = min || kandydaci(pole, p).last
            if wybrany && wybrany != [b, h]
              wynik[:nadpis][pole] = Parametry.tekst_przekroju(wybrany)
              next
            end
          end
          wynik[:podpowiedzi] << podpowiedz(pole, [b, h], r, min, p)
        end
        wynik
      end

      # Opis członu do podpowiedzi: przęsło i pas (belki) albo wysokość, siła i smukłość (słupy).
      def opis(pole, bh, r)
        if pole == SLUPY
          return format('%s %.0f × %.0f: wysokość %s m, siła %s kN – nośność %.0f %% (wyboczenie, smukłość %.0f)', NAZWY[pole],
                        bh[0], bh[1], Parametry.fmt((r[:l] / 1000.0).round(2)), Parametry.fmt(r[:n_d].round(1)), r[:wyk] * 100.0,
                        r[:smuklosc])
        end
        format('%s %.0f × %.0f: przęsło %s m, pas %s m – nośność %.0f %%, %s', NAZWY[pole], bh[0], bh[1],
               Parametry.fmt((r[:l] / 1000.0).round(2)), Parametry.fmt((r[:pas] / 1000.0).round(2)), r[:wyk] * 100.0,
               StatykaDachu.ugiecie_opis(r[:l_przez_u]))
      end

      # Podpowiedź do okna dla grupy pola o przekroju bh z oceną r (min – najlżejszy wystarczający z listy albo nil).
      def podpowiedz(pole, bh, r, min, p)
        tekst = opis(pole, bh, r)
        if r[:ok]
          dopisek = if auto?(p) then ' – dobrane automatycznie (najmniejszy wystarczający z listy).'
                    elsif min && min != bh then format(' – wystarczy; najmniejszy wystarczający z listy: %.0f × %.0f.', min[0], min[1])
                    else ' – wystarczy.'
                    end
          return { poziom: 'ok', tekst: tekst + dopisek }
        end
        rada = if min then format('za słaby – z listy wystarczy %.0f × %.0f%s.', min[0], min[1], auto?(p) ? '' : ' (albo dobór automatyczny)')
               elsif pole == SLUPY then 'za słaby i żaden przekrój z listy nie wystarcza – zmniejsz rozstaw słupów albo dopisz większy przekrój.'
               else 'za słaby i żaden przekrój z listy nie wystarcza – zmniejsz rozstaw słupów albo płatwi, albo dopisz większy przekrój.'
               end
        granica = pole == SLUPY ? '' : format(' (granica L/%.0f)', p['dach_ugiecie'].to_f)
        { poziom: 'uwaga', tekst: format('%s%s – %s', tekst, granica, rada) }
      end
    end
  end
end
