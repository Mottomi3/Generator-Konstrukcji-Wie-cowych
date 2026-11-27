# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/magazyn_drewna.rb
# Zadanie: magazyn drewna – jedna tabela w standardzie warsztatu (przekrój, długości handlowe, rodzaj drewna, do czego: legar / podciąg, płatew, krokiew, belka zadaszenia, słup, deska; cena za m³) zamiast pięciu list tekstowych; listy przekrojów dla doboru, przeniesienie dawnych list, jeden przełącznik doboru przekrojów z wyjątkami.
# Tematy: magazyn drewna, tabela drewna, przekroje z magazynu, długości handlowe z magazynu, cena drewna, rodzaj drewna C24 Nsi DUO BSH, deska 14 × 115, jeden przełącznik doboru, dobór automatyczny albo podaję sam, wyjątek doboru dla elementu, dawne listy przekrojów
# Zależy od: rdzen/wykaz_drewna.rb (wykaz fabryczny z hurtowni), rdzen/parametry_tabela.rb (wiersze tabeli)
# Używają: rdzen/parametry.rb (katalog, dlugosci_katalogu, dobor, normalizuj – przeniesienie), rdzen/parametry_materialy.rb (pole magazyn_drewna), rdzen/wycena.rb (ceny)
#
# Decyzja użytkownika z 2026-11-25: „jeden magazyn drewna i jeden przełącznik doboru – tak, odpowiada mi to”. Wiersz
# magazynu: { przekroj: '45x145', dlugosci: '4.2/5.4/6' (metry, puste – bez ograniczenia), rodzaj, legar, platew, krokiew,
# zadaszenie, slup, deska (znaczniki – do czego), cena (zł/m³, puste – bez ceny) }. Dawne klucze list (do kompilacji 16)
# odpowiadają kolumnom: przekroje_katalog → legar (legary i podciągi), platwie_katalog → platew, krokwie_katalog →
# krokiew, zadaszenie_katalog → zadaszenie, zadaszenie_slupy_katalog → slup. Przełącznik przekroje_dobor (auto | reczny)
# obowiązuje każdy element, którego pole doboru ma wartość „wspolny”; inna wartość pola – wyjątek tego elementu.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'wykaz_drewna') unless defined?(ArteMadera::GeneratorWiencowy::WykazDrewna)
require File.join(File.dirname(__FILE__), 'parametry_tabela') unless defined?(ArteMadera::GeneratorWiencowy::ParametryTabela)

module ArteMadera
  module GeneratorWiencowy
    module MagazynDrewna
      # Dawny klucz listy przekrojów → kolumna magazynu.
      KOLUMNY_LIST = { 'przekroje_katalog' => 'legar', 'platwie_katalog' => 'platew', 'krokwie_katalog' => 'krokiew',
                       'zadaszenie_katalog' => 'zadaszenie', 'zadaszenie_slupy_katalog' => 'slup' }.freeze unless const_defined?(:KOLUMNY_LIST)
      # Zastosowania (kolumny znaczników) z etykietami w oknie.
      ZASTOSOWANIA = [['legar', 'Legar / podciąg'], ['platew', 'Płatew'], ['krokiew', 'Krokiew'], ['zadaszenie', 'Belka zadaszenia'],
                      ['slup', 'Słup'], ['deska', 'Deska']].freeze unless const_defined?(:ZASTOSOWANIA)
      RODZAJE = [%w[C24 C24], ['Nsi', 'Nsi / KVH'], ['DUO', 'DUO / TRIO'], %w[BSH BSH], %w[deska deska]].freeze unless const_defined?(:RODZAJE)
      # Kolumny tabeli magazynu (pole magazyn_drewna).
      KOLUMNY = ([['przekroj', 'Przekrój [mm]', :tekst], ['dlugosci', 'Długości [m]', :tekst], ['rodzaj', 'Rodzaj', :wybor, RODZAJE]] +
                 ZASTOSOWANIA.map { |k, e| [k, e, :znacznik] } + [['cena', 'Cena [zł/m³]', :liczba]]).freeze unless const_defined?(:KOLUMNY)
      # Deska nadbitki / podbitki i deskowania (decyzja z rundy 15): 14 × 115 (krycie) × 4000.
      DESKA = { 'przekroj' => '14x115', 'dlugosci' => '4', 'rodzaj' => 'deska' }.freeze unless const_defined?(:DESKA)
      # Wartość pola doboru elementu, która oznacza „jak przełącznik przekroje_dobor”.
      WSPOLNY = 'wspolny'.freeze unless const_defined?(:WSPOLNY)

      module_function

      # Magazyn fabryczny: wykaz z hurtowni (C24 – konstrukcyjne, Nsi / DUO / BSH – widoczne) ze znacznikami jak dawne listy
      # fabryczne i deska 14 × 115; bez cen.
      def fabryczny
        listy = {}
        { 'legar' => :legary, 'platew' => :platwie, 'krokiew' => :krokwie, 'zadaszenie' => :platwie, 'slup' => :slupy }.each do |k, z|
          listy[k] = WykazDrewna.wpisy(WykazDrewna.lista(z)).map { |b, h, _d| [b, h] }
        end
        wiersze = []
        [[WykazDrewna::KONSTRUKCYJNE, 'C24'], [WykazDrewna::WIDOCZNE, 'Nsi']].each do |wykaz, rodzaj|
          WykazDrewna.scalone(wykaz).each do |b, h, dl|
            r = { 'przekroj' => "#{b}x#{h}", 'dlugosci' => dl.map { |x| fmt(x) }.join('/'), 'rodzaj' => rodzaj }
            ZASTOSOWANIA.each { |k, _e| r[k] = listy[k] ? listy[k].include?([b.to_f, h.to_f]) : false }
            r['cena'] = nil
            wiersze << r
          end
        end
        d = DESKA.dup
        ZASTOSOWANIA.each { |k, _e| d[k] = k == 'deska' }
        d['cena'] = nil
        wiersze << d
      end

      # Liczba do tekstu długości (4.2, 6).
      def fmt(x)
        (x - x.round).abs < 1e-9 ? x.round.to_s : x.to_s
      end

      # Wpisy magazynu dla zastosowania (kolumna albo dawny klucz listy): [[b, h, [długości mm rosnąco]]] – przekrój jak
      # w wierszu (szerokość × wysokość), długości puste – bez ograniczenia.
      def wpisy(p, zastosowanie)
        kol = KOLUMNY_LIST[zastosowanie.to_s] || zastosowanie.to_s
        (p['magazyn_drewna'] || []).select { |r| r[kol] }.map do |r|
          bh = WykazDrewna.wpisy(r['przekroj'].to_s).first
          next nil if bh.nil?
          dl = r['dlugosci'].to_s.scan(/\d+(?:[.,]\d+)?/).map { |x| WykazDrewna.milimetry(x) }.select { |x| x > 0 }.uniq.sort
          [bh[0], bh[1], dl]
        end.compact
      end

      # Przekroje magazynu dla zastosowania: [[b, h]] bez powtórzeń.
      def przekroje(p, zastosowanie)
        wpisy(p, zastosowanie).map { |b, h, _d| [b, h] }.uniq
      end

      # Długości handlowe dla zastosowania: { [mniejszy, większy] => [mm rosnąco] } – tylko wpisy z długościami.
      def dlugosci(p, zastosowanie)
        wynik = {}
        wpisy(p, zastosowanie).each do |b, h, dl|
          next if dl.empty?
          k = [b, h].sort
          wynik[k] = ((wynik[k] || []) + dl).uniq.sort
        end
        wynik
      end

      # Wiersz magazynu o przekroju bh (kolejność wymiarów bez znaczenia; zastosowanie – tylko wiersze z tym znacznikiem,
      # nil – dowolny); nil – brak.
      def wiersz(p, bh, zastosowanie = nil)
        k = [bh[0].to_f, bh[1].to_f].sort
        kol = zastosowanie ? (KOLUMNY_LIST[zastosowanie.to_s] || zastosowanie.to_s) : nil
        (p['magazyn_drewna'] || []).find do |r|
          next false if kol && !r[kol]
          x = WykazDrewna.wpisy(r['przekroj'].to_s).first
          x && [x[0], x[1]].sort == k
        end
      end

      # Tryb doboru elementu: pole doboru (np. 'platwie_dobor') z wartością „wspolny” – według przełącznika przekroje_dobor
      # (legary: auto → 'zalecany'); inna wartość – wyjątek tego elementu.
      def dobor(p, klucz)
        v = p[klucz].to_s
        return v unless v == WSPOLNY
        s = p['przekroje_dobor'].to_s == 'auto' ? 'auto' : 'reczny'
        klucz == 'legary_dobor' ? (s == 'auto' ? 'zalecany' : 'reczny') : s
      end

      # Dawne listy przekrojów (pola tekstowe do kompilacji 16) w wejściu → magazyn: wpisy wszystkich list ze znacznikami
      # list, w których były (lista nieobecna – fabryczna), długości z list; bez dawnych list albo z magazynem – bez zmian.
      def przenies_listy(wej)
        return wej if wej.key?('magazyn_drewna') || KOLUMNY_LIST.keys.none? { |k| wej.key?(k) }
        fab = fabryczny
        wg = {}
        KOLUMNY_LIST.each do |klucz, kol|
          tekst = wej.key?(klucz) ? wej[klucz].to_s : WykazDrewna.tekst(fab.select { |r| r[kol] }.map { |r| przekroj_dl(r) })
          WykazDrewna.wpisy(tekst).each do |b, h, dl|
            r = (wg[[b, h]] ||= nowy_wiersz(fab, b, h))
            r[kol] = true
            r['dlugosci'] = (dlugosci_wiersza(r) + dl).uniq.sort.map { |x| fmt(x / 1000.0) }.join('/') unless dl.empty?
          end
        end
        deska = fab.last
        wej.merge('magazyn_drewna' => wg.keys.sort.map { |k| wg[k] } + [deska])
      end

      # Wpis [b, h, [mm]] wiersza fabrycznego (do tekstu listy).
      def przekroj_dl(r)
        bh = WykazDrewna.wpisy(r['przekroj']).first
        [bh[0].round, bh[1].round, dlugosci_wiersza(r).map { |x| x / 1000.0 }]
      end

      # Długości wiersza w mm.
      def dlugosci_wiersza(r)
        r['dlugosci'].to_s.scan(/\d+(?:[.,]\d+)?/).map { |x| WykazDrewna.milimetry(x) }
      end

      # Nowy wiersz magazynu b × h przy przenoszeniu list (rodzaj z wykazu fabrycznego albo C24, bez znaczników i długości).
      def nowy_wiersz(fab, b, h)
        f = fab.find { |r| r['przekroj'] == "#{b.round}x#{h.round}" }
        r = { 'przekroj' => "#{fmt(b)}x#{fmt(h)}", 'dlugosci' => '', 'rodzaj' => f ? f['rodzaj'] : 'C24', 'cena' => nil }
        ZASTOSOWANIA.each { |k, _e| r[k] = false }
        r
      end
    end
  end
end
