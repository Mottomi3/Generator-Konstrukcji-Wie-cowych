# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_taras.rb
# Zadanie: parametry sekcji „Taras” – wariant, głębokość, podciąg, słupy z zamkami, szczyt nad tarasem z wiązarem, wejście, balustrada.
# Tematy: taras – parametry, słupy tarasu – parametry, balustrada – parametry, szczyt nad tarasem – parametry, wiązar – parametry
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
          wybory: [['nie', 'bez tarasu'], ['podciag', 'typ 200 – podciąg na słupach, balustrada'],
                   ['sciany', 'typ 300 – ściany pełne, front otwarty']],
          podpowiedz: 'Narysuj sam dom – taras dokłada generator: obrys dłuższy o głębokość tarasu, ściana domu zostaje ' \
                      '(działowa ze szczytem), dach i płatwie idą nad taras. Typ 200: nad tarasem górne wieńce ścian na ' \
                      'słupach, szczyt frontu, balustrada z bali; typ 300: ściany boczne na całą wysokość. Tylko obrys prostokątny.' },
        { klucz: 'taras_strona', podstawowy: true, domyslna: 'max', etykieta: 'Taras – po stronie', rodzaj: :wybor, sekcja: 'taras', gdy: { 'taras' => %w[podciag sciany] },
          wybory: [['max', 'prawej albo górnej (rysunek z góry)'], ['min', 'lewej albo dolnej (rysunek z góry)']],
          podpowiedz: 'Na końcu wzdłuż kalenicy: kalenica wzdłuż X – prawa / lewa strona rysunku, wzdłuż Y – górna / dolna.' },
        { klucz: 'taras_glebokosc', podstawowy: true, domyslna: 2000.0, etykieta: 'Taras – głębokość', jednostka: 'mm', min: 500.0,
          max: 6000.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => %w[podciag sciany] }, podpowiedz: 'Od lica ściany domu do lica frontu tarasu (typ 300: 2000).' },
        { klucz: 'taras_wience_gorne', domyslna: 2, etykieta: 'Podciąg – górne wieńce ścian nad tarasem', min: 1, max: 6,
          rodzaj: :calkowita, sekcja: 'taras', gdy: { 'taras' => ['podciag'] }, podpowiedz: 'Typ 200: dwa górne bale ścian bocznych ' \
                                                          'i front od wieńca, który zamyka się z nimi w narożniku.' },
        { klucz: 'taras_ostatek', domyslna: 100.0, etykieta: 'Ostatek dolnych bali ścian bocznych przy tarasie', jednostka: 'mm',
          min: 0.0, max: 600.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'] }, podpowiedz: 'Za licem ściany domu, pod podciągiem.' },
        { klucz: 'taras_slup_przekroj', domyslna: '120x120', etykieta: 'Słup tarasu (wzdłuż ściany × w poprzek)', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'taras', gdy: { 'taras' => ['podciag'] }, podpowiedz: 'Projekty: 80 × 180, 120 × 120, 140 × 140.' },
        { klucz: 'taras_slupy_rozstaw_max', domyslna: 2000.0, etykieta: 'Słupy – największy rozstaw (osiowo)', jednostka: 'mm',
          min: 800.0, max: 5000.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'] },
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
          wybory: [['pelny', 'pełny (typ 200)'], ['azurowy', 'ażurowy – bale na przemian z przekładkami, jak balustrada'],
                   ['pusty', 'pusty – bale spinające i trójkątny wieniec pod płatwiami']],
          pomoc: 'Pełny – szczyt z bali do linii dachu. Ażurowy – co drugi wieniec szczytu to przekładki (pod płatwiami, przy ' \
                 'końcach i co najwyżej co „największy prześwit”). Pusty – nad podciągiem tylko podana liczba bali spinających ' \
                 'front, a na nich wiązar (trójkąt): krokwie wiązara z gniazdami pod płatwie, belka dolna i słupek pod kalenicą ' \
                 '(opcjonalnie zastrzały) – spina konstrukcję i szczyt. Wiązar może też stać na słupach bez bali pod nim.' },
        { klucz: 'taras_szczyt_bale', domyslna: 1, etykieta: 'Szczyt pusty – bale spinające', min: 0, max: 6, rodzaj: :calkowita,
          sekcja: 'taras', gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'] },
          podpowiedz: 'Pełne bale szczytu nad podciągiem (nad balem, który zamyka się ze ścianami bocznymi) – dolny pas trójkąta.' },
        { klucz: 'taras_wieniec', domyslna: 'platwa', etykieta: 'Szczyt pusty – wiązar (trójkąt) z przekroju', rodzaj: :wybor,
          sekcja: 'taras', gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'] },
          wybory: [['platwa', 'płatwi (jak płatwie)'], ['wlasny', 'podanego niżej'], ['brak', 'bez wiązara – słupki z przekładek pod płatwiami']] },
        { klucz: 'taras_wieniec_przekroj', domyslna: '80x160', etykieta: 'Wiązar – przekrój (grub. × wys.)', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'taras', gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'], 'taras_wieniec' => ['wlasny'] },
          podpowiedz: 'Grubość wiązara (wzdłuż kalenicy) × wysokość krokwi wiązara (prostopadle do połaci) i belki dolnej.' },
        { klucz: 'taras_wiazar', domyslna: 'slupek', etykieta: 'Wiązar – rodzaj', rodzaj: :wybor, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'], 'taras_wieniec' => %w[platwa wlasny] },
          wybory: [['slupek', 'krokwie, belka dolna i słupek pod kalenicą'], ['zastrzaly', 'jak obok + dwa zastrzały ze stopy słupka do krokwi']],
          pomoc: 'Wiązar licuje się z licem zewnętrznym frontu. Krokwie wiązara mają wierzch na linii dachu i gniazda pod płatwie ' \
                 '(płatew przechodzi przez wiązar z zamkiem – wrąb z boków i od spodu, jak w ścianie). Krokwie leżą na belce dolnej, ' \
                 'słupek pod kalenicą podpiera obie krokwie; zastrzały (wizualnie) od stopy słupka ukośnie do połowy krokwi.' },
        { klucz: 'taras_wiazar_podparcie', domyslna: 'bale', etykieta: 'Wiązar – na czym stoi', rodzaj: :wybor, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'], 'taras_wieniec' => %w[platwa wlasny] },
          wybory: [['bale', 'na balach frontu (podciąg i bale spinające)'], ['slupy', 'na słupach – szczyt bez bali, z przodu sam trójkąt']],
          podpowiedz: 'Na słupach: belka dolna wiązara zamiast bali frontu – leży na słupach frontu od spodu podciągu, między ' \
                      'ścianami bocznymi.' },
        { klucz: 'taras_wiazar_slupek', domyslna: 120.0, etykieta: 'Wiązar – szerokość słupka', jednostka: 'mm', min: 40.0,
          max: 400.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'], 'taras_wieniec' => %w[platwa wlasny] },
          podpowiedz: 'W płaszczyźnie frontu; grubość jak wiązar.' },
        { klucz: 'taras_wiazar_zastrzal', domyslna: 100.0, etykieta: 'Wiązar – szerokość zastrzału', jednostka: 'mm', min: 40.0,
          max: 400.0, rodzaj: :liczba, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'], 'taras_szczyt' => ['pusty'], 'taras_wieniec' => %w[platwa wlasny], 'taras_wiazar' => ['zastrzaly'] } },
        { klucz: 'taras_wejscie', domyslna: 'srodek', etykieta: 'Wejście na taras od frontu', rodzaj: :wybor, sekcja: 'taras', gdy: { 'taras' => ['podciag'] },
          wybory: [['srodek', 'pośrodku'], ['lewa', 'z lewej (patrząc na front z zewnątrz)'],
                   ['prawa', 'z prawej (patrząc na front z zewnątrz)'], ['brak', 'bez wejścia – balustrada na całym froncie']] },
        { klucz: 'taras_wejscie_szerokosc', domyslna: 1200.0, etykieta: 'Wejście – szerokość w świetle słupów', jednostka: 'mm',
          min: 600.0, max: 4000.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'], 'taras_wejscie' => %w[srodek lewa prawa] } },
        { klucz: 'taras_balustrada_rodzaj', domyslna: 'przesla', etykieta: 'Balustrada – z czego', rodzaj: :wybor, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'] },
          wybory: [['przesla', 'dołożona – bale i przekładki między słupami'],
                   ['sciany', 'z wieńców ścian – ściany boczne ciągle przez taras, zamki w narożnikach frontu']],
          pomoc: 'Dołożona: w przęsłach między słupami bale na przemian z przekładkami, ściany boczne kończą się za ścianą domu. ' \
                 'Z wieńców ścian: dolne wieńce ścian bocznych biegną ciągle przez cały taras (bez krótkich kawałków), front w ' \
                 'tych samych wieńcach między ścianami bocznymi (przerwa na wejście), w narożnikach frontu zamki – z zakładką ' \
                 '(co druga belka wysunięta, np. o 100 mm) albo równo z licem; do wysokości balustrady.' },
        { klucz: 'taras_balustrada_wysokosc', domyslna: 1000.0, etykieta: 'Balustrada z wieńców – wysokość (najwyżej)', jednostka: 'mm',
          min: 200.0, max: 2000.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'], 'taras_balustrada_rodzaj' => ['sciany'] },
          podpowiedz: 'Wieńce, których wierzch nie przekracza tej wysokości; poręcz frontu i boków na wspólnej wysokości.' },
        { klucz: 'taras_zakladka', domyslna: 'tak', etykieta: 'Balustrada z wieńców – zakładka w narożnikach frontu', rodzaj: :wybor,
          sekcja: 'taras', wybory: TAK_NIE, gdy: { 'taras' => ['podciag'], 'taras_balustrada_rodzaj' => ['sciany'] },
          podpowiedz: 'Tak – co druga belka wysunięta za lico (zakładka pod barierkę). Nie – końce równo z licem.' },
        { klucz: 'taras_zakladka_wypust', domyslna: 100.0, etykieta: 'Zakładka – wysunięcie belki', jednostka: 'mm', min: 20.0,
          max: 400.0, rodzaj: :liczba, sekcja: 'taras',
          gdy: { 'taras' => ['podciag'], 'taras_balustrada_rodzaj' => ['sciany'], 'taras_zakladka' => ['tak'] } },
        { klucz: 'taras_balustrada_bale', domyslna: 4, etykieta: 'Balustrada – liczba bali', min: 0, max: 8, rodzaj: :calkowita,
          sekcja: 'taras', gdy: { 'taras' => ['podciag'] }, podpowiedz: 'Bale na przemian z rzędami przekładek (typ 200: 4 bale i 3 rzędy, ok. 1 m). 0 – bez balustrady.' },
        { klucz: 'taras_przekladka', domyslna: 300.0, etykieta: 'Balustrada – długość przekładki', jednostka: 'mm', min: 50.0,
          max: 1000.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'] }, podpowiedz: 'Odcinek bala między balami balustrady (typ 200: 300).' },
        { klucz: 'taras_przekladka_odstep', domyslna: 600.0, etykieta: 'Balustrada – największy prześwit między przekładkami',
          jednostka: 'mm', min: 50.0, max: 2000.0, rodzaj: :liczba, sekcja: 'taras', gdy: { 'taras' => ['podciag'] },
          podpowiedz: 'Przekładki przy obu końcach przęsła i równo między nimi.' }
      ].freeze unless const_defined?(:LISTA)
    end
  end
end
