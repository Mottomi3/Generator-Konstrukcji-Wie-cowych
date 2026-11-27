# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/statyka_krokwi.rb
# Zadanie: sprawdzenie i dobór przekroju krokwi całego dachu – połacie domu i bocznego zadaszenia (przęsła między płatwiami, okap jako wspornik, rozstaw krokwi); automatycznie najmniejszy wystarczający z listy albo przekrój z wyboru ze sprawdzeniem.
# Tematy: statyka krokwi, dobór przekroju krokwi, automatyczny dobór krokwi, nośność krokwi, przęsło krokwi, krokwie zadaszenia – nośność
# Zależy od: rdzen/parametry.rb, rdzen/statyka.rb (belka), rdzen/statyka_dachu.rb (współczynnik μ, opis ugięcia), rdzen/dach.rb (płatwie, krokwie), rdzen/dach_jednospadowy.rb, rdzen/zadaszenie.rb (płatwie zadaszenia), rdzen/skrzydla.rb
# Używają: rdzen/projekt.rb (podpowiedzi sekcji „Szczyty i dach” i „Zadaszenie – przekroje”, przekrój dobrany do następnego przebiegu)
#
# Wymóg użytkownika (2026-11-25): „płatwie, słupy, krokwie niech są dobierane z minimalnego przekroju jako automatyczne,
# lub z wyboru przekroju użytkownika”. Jeden przekrój krokwi dla całego dachu (krokwie zadaszenia jak krokwie dachu –
# tak samo KROK 2 aplikacji do dachów). Model (uproszczony – podpowiedź, nie projekt; KROK 2 aplikacji ma pełną kontrolę):
# - krokiew – belka swobodnie podparta na płatwiach (ściana nośna – lico wewnętrzne ściany), kalenica i załamanie to
#   końce krokwi; przęsło w rzucie – największa odległość między podporami, okap za skrajną podporą jako wspornik (2a);
# - obciążenia na krokiew przy rozstawie krokwi (krokwie_rozstaw): ciężar pokrycia [kN/m² połaci] i śnieg gruntu × μ
#   (kąt połaci) w rzucie, składowe prostopadłe do krokwi, długość po skosie; granica ugięcia jak płatwie (dach_ugiecie).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'statyka') unless defined?(ArteMadera::GeneratorWiencowy::Statyka)
require File.join(File.dirname(__FILE__), 'statyka_dachu') unless defined?(ArteMadera::GeneratorWiencowy::StatykaDachu)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'dach_jednospadowy') unless defined?(ArteMadera::GeneratorWiencowy::DachJednospadowy)
require File.join(File.dirname(__FILE__), 'zadaszenie') unless defined?(ArteMadera::GeneratorWiencowy::Zadaszenie)
require File.join(File.dirname(__FILE__), 'skrzydla') unless defined?(ArteMadera::GeneratorWiencowy::Skrzydla)
require File.join(File.dirname(__FILE__), 'dlugosci_handlowe') unless defined?(ArteMadera::GeneratorWiencowy::DlugosciHandlowe)

module ArteMadera
  module GeneratorWiencowy
    module StatykaKrokwi
      # Pole przekroju krokwi.
      POLE = 'krokiew_przekroj' unless const_defined?(:POLE)

      module_function

      # Czy przekrój krokwi dobiera generator.
      def auto?(p)
        Parametry.dobor(p, 'krokwie_dobor') == 'auto'
      end

      # Przęsło obliczeniowe krokwi w rzucie [mm] między jej końcami e0 i e1 (okap, kalenica, załamanie) przy podporach
      # (v): największa odległość między podporami albo wspornik końca (2a); bez podpór – cała długość.
      def przeslo(e0, e1, podpory)
        lo, hi = [e0, e1].sort
        pkt = podpory.select { |v| v >= lo - 0.5 && v <= hi + 0.5 }.map { |v| [[v, lo].max, hi].min }.sort
        pkt = pkt.each_with_object([]) { |v, acc| acc << v if acc.empty? || v - acc.last > 0.5 }
        return hi - lo if pkt.empty?
        (pkt.each_cons(2).map { |a, b| b - a } + [2.0 * (pkt.first - lo), 2.0 * (hi - pkt.last)]).max
      end

      # Krokwie domu do sprawdzenia: [{ gdzie: :dach | :zadaszenie, l: (przęsło w rzucie), kat: [°] }] – po jednej na połać.
      def krokwie(dom, p)
        t = Parametry.grubosc(p)
        Skrzydla.domy(dom).flat_map do |d|
          geo = Dach.geo(d)
          pod = Dach.platwie(geo, p).map { |x| x[:v] }
          next jednospadowa(geo, pod, p) if Dach.jednospadowy?(p)
          vk = (geo[:v_a] + geo[:v_b]) / 2.0
          [[geo[:v_a], 1.0], [geo[:v_b], -1.0]].flat_map do |vs, kier|
            c = (geo[:zad] || []).find { |x| x[:kier] == -kier }
            ve = c ? c[:v_k] : vs - kier * (t / 2.0 + p['dach_okap'].to_f)
            lin = pod + [vk]
            lin << vs + kier * t / 2.0 unless Parametry.tak?(p, 'platwa_na_scianie')
            lista = [{ gdzie: :dach, l: przeslo(ve, vk, lin), kat: p['dach_kat'].to_f,
                       dl: (vk - ve).abs / Math.cos(p['dach_kat'].to_f * Math::PI / 180.0) }]
            lista << zadaszenia(geo, c, p) if c
            lista
          end
        end
      end

      # Krokiew dachu jednospadowego (jeden kawałek od okapu za ścianą niską do okapu za ścianą wysoką; ściana wysoka podporą).
      def jednospadowa(geo, pod, p)
        t = Parametry.grubosc(p)
        vn, kier = DachJednospadowy.niska(geo, p)
        vw = DachJednospadowy.wysoka_v(geo, p)
        v0 = vn - kier * (t / 2.0 + p['dach_okap'].to_f)
        v1 = vw + kier * (t / 2.0 + p['dach_okap_wysoki'].to_f)
        lin = pod + [vw]
        lin << vn + kier * t / 2.0 unless Parametry.tak?(p, 'platwa_na_scianie')
        [{ gdzie: :dach, l: przeslo(v0, v1, lin), kat: p['dach_kat'].to_f }]
      end

      # Krokiew bocznego zadaszenia strony c: od załamania do okapu zadaszenia, na płatwiach zadaszenia (przybudówka ze ścianą
      # nośną – także na ścianie).
      def zadaszenia(geo, c, p)
        t = Parametry.grubosc(p)
        strona = Zadaszenie.platwie(geo, p).select { |pl| pl[:kier] == c[:kier] }
        pod = strona.map { |pl| pl[:v] }
        if p['zadaszenie'] == 'bale' && strona.none? { |pl| pl[:rodzaj] == 'zadaszenie_scienna' }
          pod << c[:v_s] - c[:kier] * t / 2.0
        end
        ve = c[:v_s] + c[:kier] * p['zadaszenie_okap'].to_f
        { gdzie: :zadaszenie, l: przeslo(c[:v_k], ve, pod), kat: p['zadaszenie_kat'].to_f }
      end

      # Ocena krokwi b × h: { ok:, wyk:, l_przez_u:, l: (przęsło w rzucie) } najbardziej wytężonej z listy (nil – pusta).
      def ocena(lista, b, h, p)
        granica = p['dach_ugiecie'].to_f
        s = p['krokwie_rozstaw'].to_f / 1000.0
        lista.map do |x|
          a = x[:kat] * Math::PI / 180.0
          g = p['dach_ciezar'].to_f * s * Math.cos(a)
          q = StatykaDachu.mi(x[:kat]) * p['dach_snieg'].to_f * s * Math.cos(a)**2
          r = Statyka.belka(x[:l] / Math.cos(a), b, h, g, q, p['drewno_klasa'], granica, StatykaDachu::PSI2_SNIEG)
          { ok: r[:ok], wyk: [r[:wyk_m], r[:wyk_v]].max, l_przez_u: r[:l_przez_u], l: x[:l] }
        end.max_by { |r| [r[:wyk], granica / [r[:l_przez_u], 1.0].max].max }
      end

      # Przekroje krokwi do doboru – od najlżejszego (przy równym polu wyższy pierwszy).
      def kandydaci(p)
        Parametry.katalog(p, 'krokwie_katalog').sort_by { |b, h| [b * h, -h] }
      end

      # Najlżejszy przekrój z magazynu wystarczający dla wszystkich krokwi, najpierw dostępny w całej długości krokwi
      # (od okapu do kalenicy); nil – żaden.
      def dobierz(lista, p)
        dl = lista.map { |x| x[:dl] }.compact.max
        DlugosciHandlowe.najpierw_w_calosci(kandydaci(p), dl, p, 'krokwie_katalog').find { |b, h| ocena(lista, b, h, p)[:ok] }
      end

      # Sprawdzenie i dobór krokwi domu: { podpowiedzi: [{ poziom:, tekst:, sekcja: }], nadpis: { POLE => 'b×h' } }; tryb jak
      # StatykaDachu.sprawdz. Podpowiedź krokwi dachu – sekcja „szczyty”, krokwi zadaszenia – „zadaszenie_przekroje”.
      def sprawdz(dom, p, tryb = :pierwszy)
        wynik = { podpowiedzi: [], nadpis: {} }
        return wynik if dom.nil? || !Dach.krokwie?(p) || !Parametry.tak?(p, 'szczyty') || !Parametry.tak?(p, 'dach_elementy')
        lista = krokwie(dom, p)
        return wynik if lista.empty?
        b, h = Parametry.przekroj(p, POLE)
        r = ocena(lista, b, h, p)
        min = dobierz(lista, p)
        if auto?(p) && tryb != :koniec && !(tryb == :potwierdz && r[:ok])
          wybrany = min || kandydaci(p).last
          if wybrany && wybrany != [b, h]
            wynik[:nadpis][POLE] = Parametry.tekst_przekroju(wybrany)
            return wynik
          end
        end
        [[:dach, 'szczyty', 'Krokwie'], [:zadaszenie, 'zadaszenie_przekroje', 'Krokwie zadaszenia']].each do |gdzie, sekcja, nazwa|
          czesc = lista.select { |x| x[:gdzie] == gdzie }
          next if czesc.empty?
          wynik[:podpowiedzi] << podpowiedz(nazwa, [b, h], ocena(czesc, b, h, p), min, p).merge(sekcja: sekcja)
        end
        wynik
      end

      # Podpowiedź do okna: krokwie (nazwa) o przekroju bh z oceną r (min – najlżejszy wystarczający dla całego dachu).
      def podpowiedz(nazwa, bh, r, min, p)
        tekst = format('%s %.0f × %.0f co %s m: przęsło %s m w rzucie – nośność %.0f %%, %s', nazwa, bh[0], bh[1],
                       Parametry.fmt((p['krokwie_rozstaw'].to_f / 1000.0).round(2)), Parametry.fmt((r[:l] / 1000.0).round(2)),
                       r[:wyk] * 100.0, StatykaDachu.ugiecie_opis(r[:l_przez_u]))
        if r[:ok]
          dopisek = if auto?(p) then ' – dobrane automatycznie (najmniejszy wystarczający z listy, jeden przekrój całego dachu).'
                    elsif min && min != bh then format(' – wystarczy; najmniejszy wystarczający z listy: %.0f × %.0f.', min[0], min[1])
                    else ' – wystarczy.'
                    end
          return { poziom: 'ok', tekst: tekst + dopisek }
        end
        rada = if min then format('za słaba – z listy wystarczy %.0f × %.0f%s.', min[0], min[1], auto?(p) ? '' : ' (albo dobór automatyczny)')
               else 'za słaba i żaden przekrój z listy nie wystarcza – dodaj płatew, zmniejsz rozstaw krokwi albo dopisz większy przekrój.'
               end
        { poziom: 'uwaga', tekst: format('%s (granica L/%.0f) – %s', tekst, p['dach_ugiecie'].to_f, rada) }
      end
    end
  end
end
