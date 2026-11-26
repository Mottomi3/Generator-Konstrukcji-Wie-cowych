# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/materialy.rb
# Zadanie: zestawienie materiałów poza balami i belkami, liczone z geometrii domu – deski poszycia dachu (m² i sztuki), taśma między wieńcami, izolacja pod pierwszy wieniec, okucia (śruby regulacyjne i podstawy słupów, kotwy podwalin, łączniki krokwi) i powierzchnia drewna do impregnacji z ilością impregnatu.
# Tematy: zestawienie materiałów, deski nadbitki w zestawieniu, powierzchnia dachu, taśma uszczelniająca między wieńcami, izolacja pod pierwszy wieniec, okucia, kotwy podwalin, podstawy słupów, łączniki krokwi z płatwiami, powierzchnia do impregnacji, ilość impregnatu, zapas na docinki
# Zależy od: rdzen/parametry.rb, rdzen/dach.rb (jednospadowy, geometria dachu), rdzen/krok2.rb (warstwy poszycia), rdzen/podbitka.rb (podbitka jako nadbitka z aplikacji)
# Używają: rdzen/projekt.rb (plan[:materialy]), rdzen/zestawienie.rb (drugi blok pliku CSV), sketchup/sterowanie.rb (tabela w oknie)
#
# Propozycja W2 (runda 15). Wiersz: { grupa:, nazwa:, wymiar:, ilosc:, jednostka:, uwagi: }. Zasady:
# - powierzchnia dachu: dom prostokątny – dokładnie (połacie z okapami i wysunięciem za szczyty, boczne zadaszenie osobno);
#   inny obrys – w przybliżeniu (rzut obrysu z okapem / cos kąta dachu), z dopiskiem;
# - deski i płyty: powierzchnia × (1 + material_zapas %) / (krycie × długość handlowa), w górę do sztuki; warstwy jak w KROKU 2
#   aplikacji do dachów (rdzen/krok2.rb) – także wtedy, gdy krokwie rysuje generator;
# - taśma: długość wszystkich bali poza najniższym wieńcem każdej ściany × tasma_pasy; pod pierwszy wieniec – osobno;
# - okucia: regulacja słupów z rdzen/osiadanie.rb (e[:osiadanie]), podstawa pod każdy słup, kotwy podwalin co
#   kotwy_podwalin_rozstaw (nie mniej niż 2 na podwalinę), łącznik na każde oparcie krokwi z generatora na płatwi;
# - impregnacja: lica bali (ściany zewnętrzne – jedno lico na zewnątrz, drugie wewnątrz; węgły na ścianach zewnętrznych
#   po połowie), obwód × długość belek, spód desek poszycia; litry = m² × impregnat_warstwy / impregnat_wydajnosc.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'dach') unless defined?(ArteMadera::GeneratorWiencowy::Dach)
require File.join(File.dirname(__FILE__), 'podbitka') unless defined?(ArteMadera::GeneratorWiencowy::Podbitka)
require File.join(File.dirname(__FILE__), 'krok2') unless defined?(ArteMadera::GeneratorWiencowy::Krok2)

module ArteMadera
  module GeneratorWiencowy
    module Materialy
      NAGLOWEK = ['Materiały', 'Pozycja', 'Wymiar [mm]', 'Ilość', 'Jednostka', 'Uwagi'].freeze unless const_defined?(:NAGLOWEK)
      # Belki liczone do impregnacji (prefiksy elementów): płatwie, krokwie, słupy, wiązar tarasu, belki zadaszenia.
      BELKI_WIDOCZNE = %w[P K S Wt Bp].freeze unless const_defined?(:BELKI_WIDOCZNE)

      module_function

      # Wszystkie wiersze materiałów z planu (pusta lista, gdy plan bez bali).
      def lista(plan)
        return [] if plan.nil? || (plan[:bale] || []).empty?
        p = plan[:parametry]
        dach = powierzchnia_dachu(plan)
        poszycie(plan, p, dach) + uszczelnienie(plan, p) + okucia(plan, p) + impregnacja(plan, p, dach)
      end

      # Zaokrąglenie do n miejsc (Ruby 2.2 – bez floor(n) / ceil(n)).
      def zaokr(v, n = 1)
        v.to_f.round(n)
      end

      # Liczba sztuk w górę: ilość z zapasem / wielkość sztuki.
      def sztuki(ilosc, sztuka, p)
        return 0 if sztuka <= 0.0
        (ilosc * (1.0 + p['material_zapas'].to_f / 100.0) / sztuka - 1e-9).ceil
      end

      # Wiersz zestawienia.
      def wiersz(grupa, nazwa, wymiar, ilosc, jednostka, uwagi = '')
        { grupa: grupa, nazwa: nazwa, wymiar: wymiar, ilosc: ilosc, jednostka: jednostka, uwagi: uwagi }
      end

      # ---------- dach ----------

      # Powierzchnia połaci [m²]: { dach:, zadaszenie:, przyblizona: } albo nil (dom bez szczytów / dachu).
      def powierzchnia_dachu(plan)
        p = plan[:parametry]
        return nil unless Parametry.tak?(p, 'szczyty')
        dom = plan[:dach]
        return przyblizona(plan, p) if dom.nil? || dom[:boczne]
        t = Parametry.grubosc(p)
        cos = Math.cos(Dach.kat(p))
        dl = (dom[:u2] - dom[:u1]) + t + 2.0 * p['dach_okap_szczyt'].to_f
        rozpietosc = dom[:v_b] - dom[:v_a] + t
        zad = dom[:zad] || []
        if Dach.jednospadowy?(p)
          rzut = rozpietosc + p['dach_okap'].to_f + p['dach_okap_wysoki'].to_f
        else
          # Po stronie bocznego zadaszenia połać domu kończy się na linii załamania (lico ściany) – bez okapu.
          rzut = rozpietosc + (2 - zad.length) * p['dach_okap'].to_f
        end
        boczne = zad.inject(0.0) do |s, c|
          s + dl * ((c[:v_s] - c[:v_k]).abs + p['zadaszenie_okap'].to_f) / Math.cos(c[:kat])
        end
        { dach: dl * rzut / cos / 1.0e6, zadaszenie: boczne / 1.0e6, przyblizona: false }
      end

      # Powierzchnia dachu w przybliżeniu dla obrysu innego niż prostokąt: (pole obrysu + obwód × okap) / cos kąta.
      def przyblizona(plan, p)
        pts = plan[:obrys] || []
        return nil if pts.length < 3
        pole = 0.0
        obwod = 0.0
        pts.each_with_index do |a, i|
          b = pts[(i + 1) % pts.length]
          pole += a[0] * b[1] - b[0] * a[1]
          obwod += Math.sqrt((b[0] - a[0])**2 + (b[1] - a[1])**2)
        end
        okap = (p['dach_okap'].to_f + p['dach_okap_szczyt'].to_f) / 2.0
        { dach: (pole.abs / 2.0 + obwod * okap) / Math.cos(Dach.kat(p)) / 1.0e6, zadaszenie: 0.0, przyblizona: true }
      end

      # Deski i płyty poszycia: warstwy z sekcji „Poszycie dachu” (jak KROK 2 aplikacji do dachów) i podbitka z generatora.
      def poszycie(plan, p, dach)
        wynik = []
        if dach
          m2 = dach[:dach] + dach[:zadaszenie]
          uw = format('połacie %s m²%s, zapas %s %%', liczba(m2), dach[:przyblizona] ? ' (w przybliżeniu – obrys inny niż prostokąt)' : '',
                      liczba(p['material_zapas'].to_f, 0))
          warstwy = Krok2.warstwy(p)
          if warstwy.include?('nadbitka')
            wynik.concat(deski('Nadbitka – deski pióro-wpust', p['podbitka_grubosc'].to_f, p['podbitka_krycie'].to_f, p['podbitka_dlugosc'].to_f, m2, p, uw))
          end
          if warstwy.include?('deskowanie')
            wynik.concat(deski('Deskowanie pełne', p['deski_grubosc'].to_f, p['deski_szerokosc'].to_f + p['deski_szczelina'].to_f,
                               p['deski_dlugosc'].to_f, m2, p, uw, p['deski_szerokosc'].to_f))
          end
          if warstwy.include?('OSB')
            wym = format('%s × %s × %s', liczba(p['osb_grubosc'].to_f, 0), liczba(p['osb_szerokosc'].to_f, 0), liczba(p['osb_dlugosc'].to_f, 0))
            wynik << wiersz('Poszycie dachu', 'Płyty OSB', wym, zaokr(m2), 'm²', uw)
            wynik << wiersz('Poszycie dachu', 'Płyty OSB', wym, sztuki(m2 * 1.0e6, p['osb_szerokosc'].to_f * p['osb_dlugosc'].to_f, p), 'szt.', '')
          end
        end
        wynik.concat(podbitka(plan, p))
        wynik
      end

      # Dwa wiersze desek: m² i sztuki o długości handlowej (krycie – szerokość z odstępem; szer – szerokość deski w opisie).
      def deski(nazwa, grubosc, krycie, dlugosc, m2, p, uwagi, szer = nil)
        wym = format('%s × %s × %s', liczba(grubosc, 0), liczba(szer || krycie, 0), liczba(dlugosc, 0))
        [wiersz('Poszycie dachu', nazwa, wym, zaokr(m2), 'm²', uwagi),
         wiersz('Poszycie dachu', nazwa, wym, sztuki(m2 * 1.0e6, krycie * dlugosc, p), 'szt.', szer ? '' : 'szerokość krycia')]
      end

      # Deski rysowane przez generator (elementy Pb): m² i sztuki o długości handlowej; na płatwiach albo na krokwiach –
      # nadbitka, pod nimi – podbitka.
      def podbitka(plan, p)
        pb = (plan[:elementy] || []).select { |e| e[:prefiks] == 'Pb' }
        return [] if pb.empty?
        krycie = p['podbitka_krycie'].to_f
        mm2 = pb.inject(0.0) { |s, e| s + e[:dl] * krycie }
        wym = format('%s × %s × %s', liczba(p['podbitka_grubosc'].to_f, 0), liczba(krycie, 0), liczba(p['podbitka_dlugosc'].to_f, 0))
        nazwa = "#{Podbitka.rodzaj(p).start_with?('na_') ? 'Nadbitka' : 'Podbitka'} – deski pióro-wpust"
        [wiersz('Poszycie dachu', nazwa, wym, zaokr(mm2 / 1.0e6), 'm²', "#{pb.length} desek w modelu, zapas #{liczba(p['material_zapas'].to_f, 0)} %"),
         wiersz('Poszycie dachu', nazwa, wym, sztuki(mm2, krycie * p['podbitka_dlugosc'].to_f, p), 'szt.', 'szerokość krycia')]
      end

      # ---------- uszczelnienie ----------

      # Taśma między wieńcami (bale poza najniższym wieńcem każdej ściany) i izolacja pod pierwszy wieniec [m].
      def uszczelnienie(plan, p)
        wynik = []
        pasy = p['tasma_pasy'].to_i
        wyzej = plan[:bale].select { |b| b[:i] > 0 }.inject(0.0) { |s, b| s + b[:dl] }
        pierwszy = plan[:bale].select { |b| b[:i].zero? }.inject(0.0) { |s, b| s + b[:dl] }
        if pasy > 0
          wynik << wiersz('Uszczelnienie', 'Taśma uszczelniająca między wieńcami', '', (wyzej * pasy / 1000.0 - 1e-9).ceil, 'm',
                          pasy == 1 ? 'jeden pas na każdy styk wieńców' : "#{pasy} pasy na każdy styk wieńców")
        end
        wynik << wiersz('Uszczelnienie', 'Izolacja pod pierwszy wieniec', liczba(Parametry.grubosc(p), 0), (pierwszy / 1000.0 - 1e-9).ceil, 'm',
                        'na podwalinie albo fundamencie, pod wszystkimi ścianami')
        wynik
      end

      # ---------- okucia ----------

      # Okucia: regulacja i podstawy słupów, kotwy podwalin, łączniki krokwi z płatwiami.
      def okucia(plan, p)
        el = plan[:elementy] || []
        wynik = []
        reg = el.map { |e| e[:osiadanie] }.compact
        sruby = reg.select { |x| x[:regulacja] == 'sruba' }
        podkl = reg.select { |x| x[:regulacja] == 'podkladki' }
        unless sruby.empty?
          wynik << wiersz('Okucia', 'Śruba regulacyjna słupa', '', sruby.length, 'szt.',
                          format('skok co najmniej %s mm (osiadanie ścian), wysokość po skręceniu %s mm', liczba(sruby.map { |x| x[:luz] }.max, 0),
                                 liczba(sruby.first[:okucie], 0)))
        end
        unless podkl.empty?
          wynik << wiersz('Okucia', 'Podkładki pod głowicę słupa (komplet)', '', podkl.length, 'kpl.',
                          format('razem %s mm na słup – wyjmowane, gdy ściany siadają', liczba(podkl.map { |x| x[:luz] }.max, 0)))
        end
        slupy = el.select { |e| e[:prefiks] == 'S' && e[:rodzaj].to_s.start_with?('Słup ') }
        wynik << wiersz('Okucia', 'Podstawa słupa (kotwa)', '', slupy.length, 'szt.', 'pod każdy słup tarasu i zadaszenia') unless slupy.empty?
        podwaliny = el.select { |e| e[:prefiks] == 'Pw' }
        unless podwaliny.empty?
          rozstaw = [p['kotwy_podwalin_rozstaw'].to_f, 100.0].max
          n = podwaliny.inject(0) { |s, e| s + [(e[:dl] / rozstaw - 1e-9).ceil + 1, 2].max }
          wynik << wiersz('Okucia', 'Kotwa podwaliny', '', n, 'szt.', format('co %s mm, nie mniej niż 2 na podwalinę', liczba(rozstaw, 0)))
        end
        n = oparcia_krokwi(el)
        wynik << wiersz('Okucia', 'Łącznik krokwi z płatwią', '', n, 'szt.', 'jeden na każde oparcie krokwi na płatwi') if n > 0
        wynik
      end

      # Liczba oparć krokwi z generatora na płatwiach: pary (krokiew, płatew), których osie w rzucie się przecinają.
      def oparcia_krokwi(el)
        krokwie = el.select { |e| e[:prefiks] == 'K' }.map { |e| odcinek_rzutu(e) }
        platwie = el.select { |e| e[:prefiks] == 'P' }.map { |e| odcinek_rzutu(e) }
        krokwie.inject(0) { |s, k| s + platwie.count { |q| przecinaja?(k, q) } }
      end

      # Odcinek osi belki w rzucie z góry: [[x0, y0], [x1, y1]] (początek belki i jej koniec wzdłuż osi x elementu).
      def odcinek_rzutu(e)
        o = e[:polozenie][:poczatek]
        x = e[:polozenie][:x]
        [[o[0], o[1]], [o[0] + x[0] * e[:dl], o[1] + x[1] * e[:dl]]]
      end

      # Czy dwa odcinki w rzucie przecinają się (z tolerancją 100 mm na końcach – belka ma szerokość).
      def przecinaja?(a, b)
        d1 = [a[1][0] - a[0][0], a[1][1] - a[0][1]]
        d2 = [b[1][0] - b[0][0], b[1][1] - b[0][1]]
        wyzn = d1[0] * d2[1] - d1[1] * d2[0]
        return false if wyzn.abs < 1e-6
        r = [b[0][0] - a[0][0], b[0][1] - a[0][1]]
        ta = (r[0] * d2[1] - r[1] * d2[0]) / wyzn
        tb = (r[0] * d1[1] - r[1] * d1[0]) / wyzn
        la = Math.sqrt(d1[0]**2 + d1[1]**2)
        lb = Math.sqrt(d2[0]**2 + d2[1]**2)
        ta * la > -100.0 && ta * la < la + 100.0 && tb * lb > -100.0 && tb * lb < lb + 100.0
      end

      # ---------- impregnacja ----------

      # Powierzchnie drewna do impregnatu albo farby [m²] i ilość impregnatu [l].
      def impregnacja(plan, p, dach)
        zewn = 0.0
        wewn = 0.0
        plan[:bale].each do |b|
          w = b[:sciana]
          lico = b[:dl] * b[:h]
          if w[:rodzaj] == :zewnetrzna || (w[:rodzaj] == :kontrfor && w[:gospodarz] && w[:gospodarz][:rodzaj] == :zewnetrzna)
            zewn += lico
            wewn += lico
          else
            wewn += 2.0 * lico
          end
        end
        belki = (plan[:elementy] || []).select { |e| BELKI_WIDOCZNE.include?(e[:prefiks]) }
                                       .inject(0.0) { |s, e| s + 2.0 * (e[:b].to_f + e[:h].to_f) * e[:dl] }
        deski = dach && (Krok2.warstwy(p) & %w[nadbitka deskowanie]).any? ? (dach[:dach] + dach[:zadaszenie]) * 1.0e6 : 0.0
        deski += (plan[:elementy] || []).select { |e| e[:prefiks] == 'Pb' }.inject(0.0) { |s, e| s + e[:dl] * p['podbitka_krycie'].to_f }
        wynik = [wiersz('Impregnacja', 'Ściany – lica zewnętrzne', '', zaokr(zewn / 1.0e6), 'm²', 'ściany zewnętrzne i zewnętrzne połowy węgłów'),
                 wiersz('Impregnacja', 'Ściany – lica wewnętrzne', '', zaokr(wewn / 1.0e6), 'm²', 'ściany zewnętrzne od środka, działowe z obu stron')]
        wynik << wiersz('Impregnacja', 'Belki dachu i słupy', '', zaokr(belki / 1.0e6), 'm²', 'płatwie, krokwie z generatora, słupy – cztery boki') if belki > 0.0
        wynik << wiersz('Impregnacja', 'Deski poszycia i podbitki – spód', '', zaokr(deski / 1.0e6), 'm²', 'strona widoczna od spodu') if deski > 0.0
        razem = (zewn + wewn + belki + deski) / 1.0e6
        wydajnosc = [p['impregnat_wydajnosc'].to_f, 0.1].max
        warstwy = [p['impregnat_warstwy'].to_i, 1].max
        wynik << wiersz('Impregnacja', 'Impregnat albo farba – razem', '', (razem * warstwy / wydajnosc - 1e-9).ceil, 'l',
                        format('%s m², %d %s, %s m² z litra', liczba(razem), warstwy, warstwy == 1 ? 'warstwa' : 'warstwy', liczba(wydajnosc)))
        wynik
      end

      # ---------- tekst ----------

      # Liczba z przecinkiem dziesiętnym (n miejsc, bez zbędnych zer po przecinku).
      def liczba(v, n = 1)
        t = format("%.#{n}f", v.to_f)
        t = t.sub(/\.?0+\z/, '') if t.include?('.')
        t.tr('.', ',')
      end

      # Wiersze bloku materiałów do pliku CSV (nagłówek + wiersze; pusta lista, gdy brak materiałów).
      def wiersze_csv(materialy)
        return [] if materialy.nil? || materialy.empty?
        [NAGLOWEK] + materialy.map do |m|
          [m[:grupa], m[:nazwa], m[:wymiar].to_s.tr('×', 'x').delete(' '), m[:ilosc].is_a?(Float) ? liczba(m[:ilosc]) : m[:ilosc].to_s, m[:jednostka], m[:uwagi]]
        end
      end
    end
  end
end
