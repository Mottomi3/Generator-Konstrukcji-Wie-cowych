# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/ustawienia_scian.rb
# Zadanie: ustawienia pojedynczych ścian z widoku ściany – ostatek na każdym końcu, węgły ustawione ręcznie (dodane / usunięte kliknięciem), co jest nad działową (strop, antresola, półka) i jej góra.
# Tematy: ustawienia ściany, ostatek na narożniku, ostatek 200 pod taras, węgły ręczne, dodaj węgieł, usuń węgieł, działowa niższa, strop, antresola, półka, nad działową
# Zależy od: rdzen/parametry.rb, rdzen/sciany.rb (dodaj_kontrfor, sprawdz_miejsce_kontrforu)
# Używają: rdzen/projekt.rb (zaraz po numeracji ścian), rdzen/widok.rb (stan dla panelu ściany)
#
# Wejście domu 'sciany' => { 'W-1' => { 'ostatek_od' =>, 'ostatek_do' =>, 'wegly' => [s, …], 'nad' =>, 'wysokosc' => } }:
# ostatek_od / ostatek_do – mm od lica ściany poprzecznej (tylko końce z ostatkiem; początek = lewa strona widoku od lica);
# wegly – osie wszystkich węgłów ściany w mm od początku osi: lista = węgły ręczne (narysowane i dostawiane
# automatycznie na tej ścianie – wyłączone); nad – 'nic' | 'strop' | 'antresola' | 'polka' (działowe; brak – według
# parametru strop); wysokosc – góra działowej [mm] (brak – dzialowa_nizsza_wysokosc). Niższa działowa tylko pod
# stropem, antresolą lub półką (wymóg użytkownika) – inaczej pełna wysokość.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'sciany') unless defined?(ArteMadera::GeneratorWiencowy::Sciany)

module ArteMadera
  module GeneratorWiencowy
    module UstawieniaScian
      # Co może być nad działową: nic (pełna wysokość) albo to, co pozwala ją obniżyć.
      NAD = %w[nic strop antresola polka].freeze unless const_defined?(:NAD)
      # Opisy dla okna i ostrzeżeń.
      OPISY_NAD = { 'nic' => 'nic – pełna wysokość', 'strop' => 'strop', 'antresola' => 'antresola',
                    'polka' => 'półka' }.freeze unless const_defined?(:OPISY_NAD)
      # Zakres ostatka ustawianego na końcu ściany [mm] (jak parametr ostatek).
      OSTATEK_MIN = 40.0 unless const_defined?(:OSTATEK_MIN)
      OSTATEK_MAX = 600.0 unless const_defined?(:OSTATEK_MAX)

      module_function

      # Ustawienia ścian do planu (po numeracji ścian, przed szczytami i stykami); zwraca ostrzeżenia.
      def zastosuj(sciany, ustawienia, p, os_kalenicy)
        uwagi = []
        ust = ustawienia.is_a?(Hash) ? ustawienia : {}
        ust.each do |id, u|
          next unless u.is_a?(Hash)
          w = sciany.find { |x| x[:id] == id.to_s && x[:rodzaj] != :kontrfor }
          if w.nil?
            uwagi << "Ustawienia ściany #{id} pominięte – nie ma takiej ściany."
            next
          end
          ostatki(w, u, p, uwagi)
          wegly(sciany, w, u['wegly'], p, os_kalenicy, uwagi) if u.key?('wegly')
        end
        sciany.each { |w| nad(w, ust[w[:id]].is_a?(Hash) ? ust[w[:id]] : {}, p) if w[:rodzaj] == :dzialowa }
        uwagi
      end

      # Ostatki na końcach ściany (tylko końce, które mają ostatek – nie wolne końce działowych).
      def ostatki(w, u, p, uwagi)
        t = Parametry.grubosc(p)
        { 'ostatek_od' => :s_od, 'ostatek_do' => :s_do }.each do |klucz, pole|
          next if u[klucz].nil? || u[klucz].to_s.strip.empty?
          v = Parametry.liczba(u[klucz])
          if v.nil?
            uwagi << "Ściana #{w[:id]}: ostatek „#{u[klucz]}” nie jest liczbą – bez zmian."
            next
          end
          if v < OSTATEK_MIN || v > OSTATEK_MAX
            v = [[v, OSTATEK_MIN].max, OSTATEK_MAX].min
            uwagi << format('Ściana %s: ostatek poza zakresem %.0f…%.0f mm – przyjęto %.0f mm.', w[:id], OSTATEK_MIN, OSTATEK_MAX, v)
          end
          if pole == :s_od
            w[:s_od] = -(t / 2.0 + v) if w[:s_od] < -0.01
          elsif w[:s_do] > w[:dl_osi] + 0.01
            w[:s_do] = w[:dl_osi] + t / 2.0 + v
          end
        end
      end

      # Węgły ręczne ściany: usunięte węgły narysowane na tej ścianie, dostawione z listy (miejsca sprawdzone), automat
      # (usztywnienie, styki) na tej ścianie wyłączony – w[:wegly_reczne].
      def wegly(sciany, w, lista, p, os_kalenicy, uwagi)
        sciany.select { |k| k[:rodzaj] == :kontrfor && k[:gospodarz].equal?(w) }.each { |k| usun_kontrfor(sciany, k) }
        pozycje = Array(lista).map { |x| Parametry.liczba(x) }.compact.sort
        dodane = []
        pozycje.each do |s|
          next if dodane.any? { |d| (d - s).abs < 1.0 }
          blad = s <= 0.0 || s >= w[:dl_osi] ? 'poza ścianą' : Sciany.sprawdz_miejsce_kontrforu(w, s, p)
          if blad
            uwagi << format('Ściana %s: węgieł w %.0f mm – %s – pominięty.', w[:id], s, blad)
            next
          end
          Sciany.dodaj_kontrfor(sciany, w, s, p, :reczny, os_kalenicy)
          dodane << s
        end
        w[:wegly_reczne] = true
      end

      # Usunięcie węgła (ściany kontrforu i jego skrzyżowania z gospodarzem).
      def usun_kontrfor(sciany, kf)
        sciany.delete(kf)
        kf[:gospodarz][:skrzyzowania].reject! { |k| k[:inna].equal?(kf) }
      end

      # Co jest nad działową i jej góra: w[:nizsza] = { nad:, z: } (brak – pełna wysokość).
      def nad(w, u, p)
        n = u['nad'].to_s
        n = Parametry.tak?(p, 'strop') ? 'strop' : 'nic' unless NAD.include?(n)
        if n == 'nic'
          w.delete(:nizsza)
          return
        end
        z = Parametry.liczba(u['wysokosc'])
        z = p['dzialowa_nizsza_wysokosc'].to_f if z.nil? || z <= 0.0
        w[:nizsza] = { nad: n, z: [z, Parametry::L.wpis('dzialowa_nizsza_wysokosc')[:min].to_f].max }
      end

      # Stan ustawień ściany dla okna: ostatki końców (nil – wolny koniec), węgły ręczne, co nad działową.
      def stan(w, p)
        t = Parametry.grubosc(p)
        od = w[:s_od] < -0.01 ? (-w[:s_od] - t / 2.0).round(1) : nil
        dok = w[:s_do] > w[:dl_osi] + 0.01 ? (w[:s_do] - w[:dl_osi] - t / 2.0).round(1) : nil
        { 'ostatek_od' => od, 'ostatek_do' => dok, 'wegly_reczne' => w[:wegly_reczne] ? true : false,
          'nad' => w[:nizsza] ? w[:nizsza][:nad] : (w[:rodzaj] == :dzialowa ? 'nic' : nil),
          'wysokosc' => w[:nizsza] ? w[:nizsza][:z] : nil }
      end
    end
  end
end
