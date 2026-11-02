# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/wegly_tabela.rb
# Zadanie: węgły (kontrfory) wstawiane jak okna i drzwi – z tabeli w oknie (ściana, od narożnika albo na środku) i automatycznie na środku ścian (parametr).
# Tematy: tabela węgłów, lista węgłów do okna, przesuwanie węgłów, węgieł z tabeli, kontrfor z tabeli, węgieł na środku ściany, węgły na środku automatycznie, położenie węgła od narożnika
# Zależy od: rdzen/parametry.rb, rdzen/sciany.rb (dodaj_kontrfor), rdzen/usztywnienie.rb (miejsce_ok?, wolne_miejsce)
# Używają: rdzen/projekt.rb (po otworach, przed stykami i węgłami usztywniającymi), sketchup/sterowanie.rb (lista węgłów do okna)
#
# Wejście domu 'wegly' => [{ 'sciana' => 'W-1', 'polozenie' => 'od' | 'srodek', 'od' => mm, 'wewn' => mm, 'zewn' => mm
# (wypusty – puste: z parametrów) }]: od – oś węgła od narożnika
# lica zewnętrznego (jak „od” okna; działowa – od początku osi), srodek – na środku osi ściany. Parametr wegly_srodek
# (zewnętrzne / wszystkie) dostawia węgieł na środku każdej ściany o osi nie krótszej niż wegly_srodek_min. Miejsce
# zajęte (skrzyżowanie, otwór) – najbliższe wolne w odległości do pół metra, z ostrzeżeniem; dalej – pominięty.
# Węgły z tabeli są jak narysowane (zrodlo :rysunek): styki i węgły usztywniające biorą je pod uwagę.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'sciany') unless defined?(ArteMadera::GeneratorWiencowy::Sciany)
require File.join(File.dirname(__FILE__), 'usztywnienie') unless defined?(ArteMadera::GeneratorWiencowy::Usztywnienie)

module ArteMadera
  module GeneratorWiencowy
    module WeglyTabela
      # Najdalej tyle [mm] od żądanego miejsca szuka się wolnego miejsca na węgieł.
      PRZESUNIECIE = 500.0 unless const_defined?(:PRZESUNIECIE)

      module_function

      # Węgły z tabeli i na środku ścian; zwraca ostrzeżenia.
      def dodaj(sciany, lista, p, os_kalenicy)
        uwagi = []
        glowne = sciany.reject { |w| w[:rodzaj] == :kontrfor }
        na_srodku(glowne, p).each do |w|
          kf = wstaw(sciany, w, srodek(w), p, os_kalenicy, uwagi, 'na środku')
          kf[:srodek] = true if kf
        end
        (lista.is_a?(Array) ? lista : []).each_with_index do |x, i|
          next unless x.is_a?(Hash)
          w = glowne.find { |s| s[:id] == x['sciana'].to_s }
          if w.nil?
            uwagi << "Węgieł z tabeli: nie ma ściany #{x['sciana']} – pominięty."
            next
          end
          s = polozenie(w, x, p)
          if s.nil?
            uwagi << "Węgieł z tabeli (#{w[:id]}): niepoprawne położenie „#{x['od']}” – pominięty."
            next
          end
          kf = wstaw(sciany, w, s, p, os_kalenicy, uwagi, 'z tabeli', 'wewn' => x['wewn'], 'zewn' => x['zewn'])
          kf[:tabela] = i if kf
        end
        uwagi
      end

      # Skąd jest węgieł (do listy w oknie): tabela, srodek, rysunek, reczny, styk, usztywnienie, platwa, koniec.
      def skad(kf)
        return 'tabela' if kf[:tabela]
        return 'srodek' if kf[:srodek]
        kf[:zrodlo].to_s
      end

      # Wszystkie węgły domu do listy w oknie (przesuwanie w karcie okien i drzwi): [{ 'id', 'sciana', 's' (oś na osi
      # gospodarza), 'od' (jak w tabeli: ściana zewnętrzna – od narożnika lica zewnętrznego), 'skad', 'tabela' (wiersz albo
      # nil) }], po ścianach i położeniu.
      def lista(sciany, p)
        t2 = Parametry.grubosc(p) / 2.0
        sciany.select { |w| w[:rodzaj] == :kontrfor }.map do |kf|
          g = kf[:gospodarz]
          k = g[:skrzyzowania].find { |x| x[:inna].equal?(kf) }
          next nil if k.nil?
          { 'id' => kf[:id].to_s, 'sciana' => g[:id].to_s, 's' => k[:s].round(1),
            'od' => (g[:rodzaj] == :zewnetrzna ? k[:s] + t2 : k[:s]).round(1), 'skad' => skad(kf), 'tabela' => kf[:tabela] }
        end.compact.sort_by { |x| [x['sciana'][2..-1].to_i, x['s']] }
      end

      # Ściany, które dostają węgieł na środku (parametr wegly_srodek, oś nie krótsza niż wegly_srodek_min).
      def na_srodku(glowne, p)
        tryb = p['wegly_srodek'].to_s
        return [] if tryb == 'nie'
        glowne.select { |w| (tryb == 'wszystkie' || w[:rodzaj] == :zewnetrzna) && w[:dl_osi] >= p['wegly_srodek_min'].to_f - 0.01 }
      end

      # Środek osi ściany (s).
      def srodek(w)
        w[:dl_osi] / 2.0
      end

      # Położenie s węgła z wiersza tabeli; nil – niepoprawne.
      def polozenie(w, x, p)
        return srodek(w) if x['polozenie'].to_s == 'srodek'
        od = Parametry.liczba(x['od'])
        return nil if od.nil?
        w[:rodzaj] == :zewnetrzna ? od - Parametry.grubosc(p) / 2.0 : od
      end

      # Wstawia węgieł w s albo w najbliższym wolnym miejscu (do PRZESUNIECIE); ostrzeżenie o przesunięciu lub pominięciu.
      def wstaw(sciany, w, s, p, os_kalenicy, uwagi, skad, ostatki = nil)
        ok = lambda { |x| Usztywnienie.miejsce_ok?(w.merge(wegly_reczne: nil), p, x, []) }
        x = ok.call(s) ? s : Usztywnienie.wolne_miejsce(w, s, s - PRZESUNIECIE, s + PRZESUNIECIE) { |y| ok.call(y) }
        if x.nil?
          uwagi << format('Węgieł %s (%s, %.0f mm): brak miejsca (skrzyżowanie, otwór albo koniec ściany) – pominięty.', skad, w[:id], s)
          return
        end
        if (x - s).abs > 0.5
          uwagi << format('Węgieł %s (%s): przesunięty o %.0f mm – w miejscu %.0f mm jest skrzyżowanie albo otwór.', skad, w[:id], x - s, s)
        end
        Sciany.dodaj_kontrfor(sciany, w, x, p, :rysunek, os_kalenicy, ostatki)
      end
    end
  end
end
