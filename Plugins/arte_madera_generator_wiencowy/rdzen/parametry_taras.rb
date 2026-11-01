# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_taras.rb
# Zadanie: parametry sekcji „Taras” – wariant, głębokość, podciąg, słupy z zamkami, szczyt nad tarasem, wejście, balustrada.
# Tematy: taras – parametry, słupy tarasu – parametry, balustrada – parametry, szczyt nad tarasem – parametry
# Zależy od: rdzen/parametry_lista.rb (TAK_NIE)
# Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji)
#
# Wpis jak w rdzen/parametry_lista.rb (klucz, domyślna, etykieta, jednostka, zakres, rodzaj, sekcja, wybory, podpowiedź;
# gdy – pole widoczne tylko przy wybranych wartościach innych pól, pomoc – dłuższe objaśnienie pod znakiem zapytania).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module ParametryTaras
      TAK_NIE = [['tak', 'tak'], ['nie', 'nie']].freeze unless const_defined?(:TAK_NIE)

      # Parametry sekcji (kolejność = kolejność w oknie).
      LISTA = [
        { klucz: 'taras', podstawowy: true, domyslna: 'nie', etykieta: 'Taras przed ścianą szczytową', rodzaj: :wybor, sekcja: 'taras',
          wybory: [['nie', 'bez tarasu'], ['podciag', 'jak 1100 – podciąg na słupach, balustrada'],
                   ['sciany', 'jak 1200 – ściany pełne, front otwarty']],
          podpowiedz: 'Narysuj sam dom – taras dokłada generator: obrys dłuższy o głębokość tarasu, ściana domu zostaje ' \
                      '(działowa ze szczytem), dach i płatwie idą nad taras. 1100: nad tarasem górne wieńce ścian na ' \
                      'słupach, szczyt frontu, balustrada z bali; 1200: ściany boczne na całą wysokość. Tylko obrys prostokątny.' },
        { klucz: 'taras_strona', podstawowy: true, domyslna: 'max', etykieta: 'Taras – po stronie', rodzaj: :wybor, sekcja: 'taras',
          wybory: [['max', 'prawej albo górnej (rysunek z góry)'], ['min', 'lewej albo dolnej (rysunek z góry)']],
          podpowiedz: 'Na końcu wzdłuż kalenicy: kalenica wzdłuż X – prawa / lewa strona rysunku, wzdłuż Y – górna / dolna.' },
        { klucz: 'taras_glebokosc', podstawowy: true, domyslna: 2000.0, etykieta: 'Taras – głębokość', jednostka: 'mm', min: 500.0,
          max: 6000.0, rodzaj: :liczba, sekcja: 'taras', podpowiedz: 'Od lica ściany domu do lica frontu tarasu (1200: 2000).' },
        { klucz: 'taras_wience_gorne', domyslna: 2, etykieta: 'Podciąg – górne wieńce ścian nad tarasem', min: 1, max: 6,
          rodzaj: :calkowita, sekcja: 'taras', podpowiedz: 'Wariant 1100: dwa górne bale ścian bocznych (95-2372, 96-2372) ' \
                                                          'i front od wieńca, który zamyka się z nimi w narożniku.' },
        { klucz: 'taras_ostatek', domyslna: 100.0, etykieta: 'Ostatek dolnych bali ścian bocznych przy tarasie', jednostka: 'mm',
          min: 0.0, max: 600.0, rodzaj: :liczba, sekcja: 'taras', podpowiedz: 'Za licem ściany domu, pod podciągiem.' },
        { klucz: 'taras_slup_przekroj', domyslna: '120x120', etykieta: 'Słup tarasu (wzdłuż ściany × w poprzek)', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'taras', podpowiedz: 'Projekty: 80 × 180, 120 × 120, 140 × 140.' },
        { klucz: 'taras_slupy_rozstaw_max', domyslna: 2000.0, etykieta: 'Słupy – największy rozstaw (osiowo)', jednostka: 'mm',
          min: 800.0, max: 5000.0, rodzaj: :liczba, sekcja: 'taras',
          podpowiedz: 'Pod frontem i pod ścianami bocznymi nad tarasem; słupy zawsze w narożnikach frontu i przy wejściu.' },
        { klucz: 'taras_slup_zamek_gora', domyslna: 150.0, etykieta: 'Słup – zamek górny (wysokość obok bala)', jednostka: 'mm',
          min: 0.0, max: 600.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'] },
          podpowiedz: 'Słup licem równo z licem ściany; nad spodem podciągu część słupa za balem idzie dalej w górę, bal leży ' \
                      'w wycięciu. 0 – słup kończy się pod balem.' },
        { klucz: 'taras_slup_zamek_dol', domyslna: 100.0, etykieta: 'Słup – zamek dolny (obok podwaliny)', jednostka: 'mm',
          min: 0.0, max: 300.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'] },
          podpowiedz: 'Część słupa obok podwaliny schodzi w dół (najwyżej na wysokość podwaliny). 0 – słup stoi na podwalinie. ' \
                      'Tylko z podłogą.' },
        { klucz: 'taras_szczyt', domyslna: 'pelny', etykieta: 'Szczyt nad tarasem', rodzaj: :wybor, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'] },
          wybory: [['pelny', 'pełny (jak 1100)'], ['azurowy', 'ażurowy – bale na przemian z przekładkami, jak balustrada'],
                   ['pusty', 'pusty – bale spinające nad podciągiem, wyżej słupki pod płatwiami']],
          pomoc: 'Pełny – szczyt z bali do linii dachu. Ażurowy – co drugi wieniec szczytu to przekładki (pod płatwiami, przy ' \
                 'końcach i co najwyżej co „największy prześwit”). Pusty – nad podciągiem tylko podana liczba bali spinających ' \
                 'front, wyżej słupki z przekładek pod każdą płatwią (płatwie zostają podparte).' },
        { klucz: 'taras_szczyt_bale', domyslna: 1, etykieta: 'Szczyt pusty – bale spinające', min: 0, max: 6, rodzaj: :calkowita,
          sekcja: 'taras', gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'] },
          podpowiedz: 'Pełne bale szczytu nad podciągiem (nad balem, który zamyka się ze ścianami bocznymi).' },
        { klucz: 'taras_wejscie', domyslna: 'srodek', etykieta: 'Wejście na taras od frontu', rodzaj: :wybor, sekcja: 'taras',
          wybory: [['srodek', 'pośrodku'], ['lewa', 'z lewej (patrząc na front z zewnątrz)'],
                   ['prawa', 'z prawej (patrząc na front z zewnątrz)'], ['brak', 'bez wejścia – balustrada na całym froncie']] },
        { klucz: 'taras_wejscie_szerokosc', domyslna: 1200.0, etykieta: 'Wejście – szerokość w świetle słupów', jednostka: 'mm',
          min: 600.0, max: 4000.0, rodzaj: :liczba, sekcja: 'taras' },
        { klucz: 'taras_balustrada_bale', domyslna: 4, etykieta: 'Balustrada – liczba bali', min: 0, max: 8, rodzaj: :calkowita,
          sekcja: 'taras', podpowiedz: 'Bale na przemian z rzędami przekładek (1100: 4 bale i 3 rzędy, ok. 1 m). 0 – bez balustrady.' },
        { klucz: 'taras_przekladka', domyslna: 300.0, etykieta: 'Balustrada – długość przekładki', jednostka: 'mm', min: 50.0,
          max: 1000.0, rodzaj: :liczba, sekcja: 'taras', podpowiedz: 'Odcinek bala między balami balustrady (1100: 300).' },
        { klucz: 'taras_przekladka_odstep', domyslna: 600.0, etykieta: 'Balustrada – największy prześwit między przekładkami',
          jednostka: 'mm', min: 50.0, max: 2000.0, rodzaj: :liczba, sekcja: 'taras',
          podpowiedz: 'Przekładki przy obu końcach przęsła i równo między nimi.' }
      ].freeze unless const_defined?(:LISTA)
    end
  end
end
