# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/uwagi_pola.rb
# Zadanie: jedna lista uwag do okna – błędy, ostrzeżenia i podpowiedzi z planu z poziomem, krokiem okna i polem albo sekcją, do której uwaga prowadzi (kliknięcie uwagi przenosi do pola).
# Tematy: lista uwag, uwaga a pole, uwaga a krok, do poprawy, sprawdzone, przejście z uwagi do pola, rozpoznanie pola z tekstu uwagi
# Zależy od: rdzen/poziomy.rb (kroki), rdzen/parametry_lista.rb (pola)
# Używają: sketchup/sterowanie.rb (wynik do okna – 'uwagi'), html/uwagi.js (lista), html/kroki.js (znaczniki kroków)
#
# Uwagi powstają w wielu modułach jako teksty; tabela WZORCE przypisuje im pole albo sekcję po charakterystycznych słowach
# (pierwszy pasujący wzorzec). Podpowiedzi mają własną sekcję – wzorzec tylko doprecyzowuje pole. Uwaga bez wzorca i bez
# sekcji trafia do pierwszego kroku i nie jest klikalna.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'poziomy') unless defined?(ArteMadera::GeneratorWiencowy::Poziomy)

module ArteMadera
  module GeneratorWiencowy
    module UwagiPola
      # [wzorzec tekstu, klucz pola albo nil, sekcja (gdy bez pola)] – kolejność ma znaczenie.
      WZORCE = [
        [/Powierzchnia zabudowy/, 'limit_zabudowy', nil],
        [/Wysokość nad terenem/, 'limit_wysokosci', nil],
        [/Otwór|otwor/i, nil, 'otwory'],
        [/styk bez zamka|nie udało się dobrać miejsc styków|dłuższe niż .* mm \(najdłuższy/, 'max_dlugosc', nil],
        [/krótsze niż .* mm \(najkrótszy/, 'min_odcinek', nil],
        [/pod płatwią .* nie ma miejsca na węgie/, 'wegly_pod_platwiami', nil],
        [/góra działowej/, 'dzialowa_nizsza_wysokosc', nil],
        [/światło .* dłuższe niż/, 'wegly_max_swiatlo', nil],
        [/Węgieł na środku/, 'wegly_srodek', nil],
        [/wypuszczone górne wieńce/, 'taras_wience_gorne', nil],
        [/Wejście na taras/, 'taras_wejscie', nil],
        [/Trójkąt nad tarasem|Wiązar/, 'taras_wiazar', nil],
        [/Słupy? .*zadaszeni|zadaszeni/i, 'zadaszenie', nil],
        [/Słup/, 'taras_slup_przekroj', nil],
        [/Taras/, 'taras', nil],
        [/podbitk|nadbitk|bez poszycia/i, 'podbitka', nil],
        [/Dach jednospadowy/, 'dach_rodzaj', nil],
        [/krokwie z generatora|krokwie z aplikacji|poszycie z aplikacji|połacie dla aplikacji/, 'dach_wiezba', nil],
        [/Krokwie|krokiew/, 'krokiew_przekroj', nil],
        [/Płatwie|płatew|Płatew/, 'platwa_przekroj', nil],
        [/Izolacja|izolacj/, 'izolacja_podlogi', nil],
        [/Podciąg|podciąg/, 'podpora_przekroj', nil],
        [/Fundament/, 'fundamenty', nil],
        [/Legar|legar/, 'legar_przekroj', nil],
        [/Podwalina|podwalin/, 'podwalina_przekroj', nil],
        [/Podłoga/, 'podloga', nil],
        [/Kontrfor|węgieł|Węgieł|węgły/, nil, 'wegly'],
        [/zajmują to samo miejsce|Ustawienia ściany/, nil, 'sciany'],
        [/Dach/, nil, 'szczyty']
      ].freeze unless const_defined?(:WZORCE)

      module_function

      # Pole i sekcja uwagi o podanym tekście: [klucz albo nil, sekcja albo nil]; sekcja – z pola, z wzorca albo podana.
      def miejsce(tekst, sekcja = nil)
        w = WZORCE.find { |wzor, _k, _s| tekst.to_s =~ wzor }
        klucz = w ? w[1] : nil
        wpis = klucz ? ParametryLista.wpis(klucz) : nil
        return [klucz, wpis[:sekcja]] if wpis
        [nil, (w && w[2]) || (sekcja ? sekcja.to_s : nil)]
      end

      # Jedna uwaga do okna.
      def uwaga(tekst, poziom, sekcja = nil)
        klucz, sek = miejsce(tekst, sekcja)
        krok = Poziomy.krok_sekcji(sek)
        tytul = Poziomy::KROKI.find { |k, _t, _s| k == krok }
        { 'tekst' => tekst.to_s, 'poziom' => poziom, 'klucz' => klucz, 'sekcja' => sek, 'krok' => krok, 'krok_tytul' => tytul ? tytul[1] : '' }
      end

      # Lista uwag z planu: błędy ('blad'), ostrzeżenia ('ostrzezenie') i podpowiedzi ('blad' | 'uwaga' | 'ok').
      def lista(plan)
        wynik = (plan[:bledy] || []).map { |t| uwaga(t, 'blad') }
        wynik.concat((plan[:ostrzezenia] || []).map { |t| uwaga(t, 'ostrzezenie') })
        (plan[:podpowiedzi] || []).each do |h|
          poziom = %w[blad uwaga ok].include?(h[:poziom].to_s) ? h[:poziom].to_s : 'uwaga'
          wynik << uwaga(h[:tekst], poziom, h[:sekcja])
        end
        wynik
      end
    end
  end
end
