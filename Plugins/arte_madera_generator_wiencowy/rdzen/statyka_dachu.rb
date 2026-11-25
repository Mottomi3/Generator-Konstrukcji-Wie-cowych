# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/statyka_dachu.rb
# Zadanie: sprawdzenie płatwi dachu (śnieg i ciężar pokrycia, przęsła między ścianami, pas dachu na płatew) i automatyczny dobór najmniejszego wystarczającego przekroju płatwi z listy.
# Tematy: statyka dachu, dobór przekroju płatwi, automatyczny dobór płatwi, nośność płatwi, obciążenie śniegiem, ciężar pokrycia, przęsło płatwi, pas dachu na płatew, ugięcie płatwi, lista przekrojów płatwi
# Zależy od: rdzen/parametry.rb, rdzen/statyka.rb (belka), rdzen/dach.rb (płatwie, kąt), rdzen/skrzydla.rb (dachy domu, zasięg płatwi)
# Używają: rdzen/projekt.rb (podpowiedzi sekcji „Szczyty i dach”, przekroje dobrane do drugiego przebiegu obliczeń), rdzen/statyka_zadaszenia.rb (obciążenia, przęsło płatwi, opis ugięcia), rdzen/statyka_krokwi.rb (współczynnik μ, opis ugięcia)
#
# Wymóg użytkownika (2026-11-16): „do opcji dodać automatyczne dobieranie przekroju, do minimalnej nośności konstrukcji
# dachu” – w wąskich domkach płatew 60 × 200 jest za duża (trójkąt nad tarasem z jej przekroju się nie mieści).
# Model (uproszczony, jak rdzen/statyka.rb – podpowiedź, nie projekt konstruktora):
# - płatew stoi pionowo i niesie pas dachu: połowa odległości do sąsiednich linii podparcia połaci po obu stronach
#   (płatwie, ściana okapowa bez płatwi ściennej); skrajna płatew ścienna – także okap;
# - obciążenie na metr płatwi: stałe = ciężar pokrycia z poszyciem [kN/m² połaci] × pas / cos kąta, zmienne = śnieg
#   gruntu × współczynnik kształtu dachu μ (0,8 do 30°, liniowo do 0 przy 60°) × pas; ciężar własny dolicza Statyka.belka;
# - przęsło: największa odległość między ścianami, przez które płatew przechodzi (szczyty, działowe ze szczytem, ściana
#   domu przy tarasie, trójkąt nad tarasem); odcinek leżący na ścianie wzdłuż płatwi nie jest przęsłem; koniec za szczytem
#   (wspornik a) liczony jak przęsło 2a (ten sam moment);
# - wysokość do obliczeń: płatew ścięta do płaszczyzny dachu – średnia wysokość przekroju.
# Dobór (platwie_dobor = auto): najlżejszy przekrój z „Dostępne przekroje płatwi”, który spełnia nośność i ugięcie
# L / dach_ugiecie dla wszystkich płatwi grupy (jeden przekrój – wszystkie płatwie; osobne – pośrednie, kalenicowa,
# ścienne). Wynik idzie do drugiego przebiegu obliczeń (rdzen/projekt.rb) – dom liczony jest od nowa z dobranym
# przekrojem, a ten przebieg tylko go potwierdza (większy przekrój, gdyby po zmianie geometrii nie wystarczał).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'statyka') unless defined?(ArteMadera::GeneratorWiencowy::Statyka)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'skrzydla') unless defined?(ArteMadera::GeneratorWiencowy::Skrzydla)

module ArteMadera
  module GeneratorWiencowy
    module StatykaDachu
      # Pola przekroju płatwi według rodzaju (osobne przekroje) i nazwy do komunikatów.
      POLA = { 'posrednia' => 'platwa_przekroj', 'kalenicowa' => 'platwa_kalenicowa_przekroj',
               'scienna' => 'platwa_scienna_przekroj' }.freeze unless const_defined?(:POLA)
      NAZWY = { 'platwa_przekroj' => 'Płatwie', 'platwa_kalenicowa_przekroj' => 'Płatew kalenicowa',
                'platwa_scienna_przekroj' => 'Płatwie ścienne' }.freeze unless const_defined?(:NAZWY)

      # Część śniegu działająca długotrwale (pełzanie) – 0 poniżej 1000 m n.p.m.
      PSI2_SNIEG = 0.0 unless const_defined?(:PSI2_SNIEG)

      module_function

      # Czy przekrój płatwi dobiera generator.
      def auto?(p)
        p['platwie_dobor'].to_s == 'auto'
      end

      # Współczynnik kształtu dachu dla śniegu μ (kąt w stopniach): 0,8 do 30°, liniowo do 0 przy 60°.
      def mi(kat)
        return 0.8 if kat <= 30.0
        return 0.0 if kat >= 60.0
        0.8 * (60.0 - kat) / 30.0
      end

      # Obciążenia płatwi [kN/m] dla pasa dachu pas [mm w poziomie] przy kącie połaci kat [°] (domyślnie kąt dachu; boczne
      # zadaszenie – jego kąt): [stałe, śnieg].
      def obciazenia(pas, p, kat = nil)
        k = kat.nil? ? p['dach_kat'].to_f : kat.to_f
        [p['dach_ciezar'].to_f * pas / 1000.0 / Math.cos(k * Math::PI / 180.0), mi(k) * p['dach_snieg'].to_f * pas / 1000.0]
      end

      # Wysokość przekroju do obliczeń [mm]: płatew ścięta do płaszczyzny dachu – średnia (kalenicowa ścięta z obu stron).
      def wysokosc(b, h, rodzaj, p)
        return h unless Parametry.tak?(p, 'platwie_sciecie')
        [h - b * Dach.tg(p) * (rodzaj == 'kalenicowa' ? 0.25 : 0.5), h / 3.0].max
      end

      # Pas dachu na płatew pl [mm w poziomie]: po połowie odległości do sąsiednich linii podparcia połaci (płatwie; ściana
      # okapowa, gdy nie ma przy niej płatwi ściennej); skrajna płatew – także okap.
      def pas(geo, lista, pl, p)
        t = Parametry.grubosc(p)
        linie = lista.map { |x| x[:v] }
        [[geo[:v_a], 1.0], [geo[:v_b], -1.0]].each do |vs, kier|
          linie << vs + kier * t / 2.0 unless lista.any? { |x| x[:rodzaj] == 'scienna' && (x[:v] - vs).abs < t + x[:b] }
        end
        linie = linie.sort.each_with_object([]) { |v, acc| acc << v if acc.empty? || v - acc.last > 0.01 }
        i = linie.index { |v| (v - pl[:v]).abs < 0.01 } || 0
        okap = p['dach_okap'].to_f + t
        (i > 0 ? (pl[:v] - linie[i - 1]) / 2.0 : okap) + (i < linie.length - 1 ? (linie[i + 1] - pl[:v]) / 2.0 : okap)
      end

      # Przęsło obliczeniowe płatwi pl dachu d na zasięgu u0…u3 [mm]: największa odległość między podporami (ściany
      # w poprzek – d[:przejscia]; końce ścian wzdłuż płatwi – d[:podparcia], odcinek na takiej ścianie nie jest przęsłem;
      # koniec płatwi skrzydła bocznego w dachu głównym) albo dwa wsporniki końca; bez podpór – cała długość.
      def przeslo(d, pl, u0, u3, p)
        na_osi = lambda { |x| (x[:v] - pl[:v]).abs < 0.5 }
        ciagle = (d[:podparcia] || []).select(&na_osi).map { |x| x[:u] }
        pkt = (d[:przejscia] || []).select(&na_osi).map { |x| x[:u] } + ciagle.flatten
        if d[:rola] == :boczne
          wolny = d[:u_wolny] + d[:kier_u] * (p['dach_okap_szczyt'].to_f + Parametry.grubosc(p) / 2.0)
          pkt << ((u0 - wolny).abs < 1.0 ? u3 : u0)
        end
        pkt = pkt.map { |u| [[u, u0].max, u3].min }.sort.each_with_object([]) { |u, acc| acc << u if acc.empty? || u - acc.last > 0.5 }
        return u3 - u0 if pkt.empty?
        przesla = pkt.each_cons(2).reject { |a, b| ciagle.any? { |c0, c1| a >= c0 - 0.5 && b <= c1 + 0.5 } }.map { |a, b| b - a }
        (przesla + [2.0 * (pkt.first - u0), 2.0 * (u3 - pkt.last)]).max
      end

      # Płatwie wszystkich dachów domu do sprawdzenia: [{ rodzaj:, b:, h:, l: (przęsło), pas: }].
      def platwie(dom, p)
        Skrzydla.domy(dom).flat_map do |d|
          geo = Dach.geo(d)
          lista = Dach.platwie(geo, p)
          lista.map do |pl|
            u0, u3 = Skrzydla.zasieg_platwi(d, pl, p)
            next nil if u3 - u0 < 1.0
            { rodzaj: pl[:rodzaj], b: pl[:b], h: pl[:h], l: przeslo(d, pl, u0, u3, p), pas: pas(geo, lista, pl, p) }
          end.compact
        end
      end

      # Grupy płatwi o wspólnym przekroju: { pole przekroju => [płatwie] } (jeden przekrój – wszystkie w platwa_przekroj);
      # dach bez płatwi – {}.
      def grupy(lista, p)
        return {} if lista.empty?
        return { 'platwa_przekroj' => lista } if Parametry.tak?(p, 'platwie_jeden_przekroj')
        lista.group_by { |x| POLA[x[:rodzaj]] || 'platwa_przekroj' }
      end

      # Ocena przekroju b × h dla płatwi grupy – wynik najbardziej wytężonej (nośność albo ugięcie względem granicy):
      # { ok:, wyk: (nośność 0…), l_przez_u:, l:, pas: }.
      def ocena(grupa, b, h, p)
        granica = p['dach_ugiecie'].to_f
        grupa.map do |x|
          g, q = obciazenia(x[:pas], p)
          r = Statyka.belka(x[:l], b, wysokosc(b, h, x[:rodzaj], p), g, q, p['drewno_klasa'], granica, PSI2_SNIEG)
          { ok: r[:ok], wyk: [r[:wyk_m], r[:wyk_v]].max, l_przez_u: r[:l_przez_u], l: x[:l], pas: x[:pas] }
        end.max_by { |r| [r[:wyk], granica / [r[:l_przez_u], 1.0].max].max }
      end

      # Przekroje do doboru – od najlżejszego (przy równym polu wyższy pierwszy).
      def kandydaci(p)
        Parametry.katalog(p, 'platwie_katalog').sort_by { |b, h| [b * h, -h] }
      end

      # Najlżejszy przekrój z listy wystarczający dla grupy; nil – żaden.
      def dobierz(grupa, p)
        kandydaci(p).find { |b, h| ocena(grupa, b, h, p)[:ok] }
      end

      # Sprawdzenie i dobór dla domu: { podpowiedzi: [{ poziom:, tekst: }], nadpis: { pole => 'b×h' do następnego przebiegu },
      # platwie: [sprawdzone płatwie – przęsło i pas dachu] }.
      # tryb: :pierwszy – dobór od zera; :potwierdz – przebieg z dobranym już przekrojem, zmiana tylko, gdy obecny nie
      # wystarcza; :koniec – ostatni przebieg, bez zmian (sama ocena).
      def sprawdz(dom, p, tryb = :pierwszy)
        wynik = { podpowiedzi: [], nadpis: {}, platwie: [] }
        return wynik if dom.nil? || !Parametry.tak?(p, 'szczyty') || !Parametry.tak?(p, 'dach_elementy')
        wynik[:platwie] = platwie(dom, p)
        grupy(wynik[:platwie], p).each do |pole, grupa|
          b, h = Parametry.przekroj(p, pole)
          r = ocena(grupa, b, h, p)
          min = dobierz(grupa, p)
          if auto?(p) && tryb != :koniec && !(tryb == :potwierdz && r[:ok])
            wybrany = min || kandydaci(p).last
            if wybrany && wybrany != [b, h]
              wynik[:nadpis][pole] = Parametry.tekst_przekroju(wybrany)
              next
            end
          end
          wynik[:podpowiedzi] << podpowiedz(pole, [b, h], r, min, p)
        end
        wynik
      end

      # Ugięcie do komunikatu: „ugięcie L/250”, a przy znikomym – „ugięcie poniżej L/1000”.
      def ugiecie_opis(l_przez_u)
        l_przez_u > 999.5 ? 'ugięcie poniżej L/1000' : format('ugięcie L/%.0f', l_przez_u)
      end

      # Podpowiedź do okna dla grupy płatwi o przekroju bh z oceną r (min – najlżejszy wystarczający z listy albo nil).
      def podpowiedz(pole, bh, r, min, p)
        opis = format('%s %.0f × %.0f: przęsło %s m, pas dachu %s m – nośność %.0f %%, %s', NAZWY[pole], bh[0], bh[1],
                      Parametry.fmt((r[:l] / 1000.0).round(2)), Parametry.fmt((r[:pas] / 1000.0).round(2)), r[:wyk] * 100.0,
                      ugiecie_opis(r[:l_przez_u]))
        if r[:ok]
          dopisek = if auto?(p) then ' – dobrane automatycznie (najmniejszy wystarczający z listy).'
                    elsif min && min != bh then format(' – wystarczy; najmniejszy wystarczający z listy: %.0f × %.0f.', min[0], min[1])
                    else ' – wystarczy.'
                    end
          return { poziom: 'ok', tekst: opis + dopisek }
        end
        rada = if min then format('za słaby – z listy wystarczy %.0f × %.0f%s.', min[0], min[1], auto?(p) ? '' : ' (albo dobór automatyczny)')
               else 'za słaby i żaden przekrój z listy nie wystarcza – dodaj podporę (działowa ze szczytem), zmniejsz rozstaw ' \
                    'płatwi albo dopisz większy przekrój.'
               end
        { poziom: 'uwaga', tekst: format('%s (granica L/%.0f) – %s', opis, p['dach_ugiecie'].to_f, rada) }
      end
    end
  end
end
