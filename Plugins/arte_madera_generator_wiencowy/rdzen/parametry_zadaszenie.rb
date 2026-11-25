# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_zadaszenie.rb
# Zadanie: parametry sekcji „Boczne zadaszenie” – wariant (słupy z oczepem albo przybudówka z bali), strona, szerokość, kąt mniejszy niż kąt dachu, okap, przekroje płatwi, słupów i belek poprzecznych.
# Tematy: boczne zadaszenie – parametry, wiata boczna – parametry, przybudówka – parametry, załamanie dachu – parametry
# Zależy od: –
# Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji)
#
# Wpis jak w rdzen/parametry_lista.rb (klucz, domyślna, etykieta, jednostka, zakres, rodzaj, sekcja, wybory, podpowiedź;
# gdy – pole widoczne tylko przy wybranych wartościach innych pól, pomoc – dłuższe objaśnienie pod znakiem zapytania).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module ParametryZadaszenie
      # Warianty z zadaszeniem (pola zależne).
      Z = %w[slupy bale].freeze unless const_defined?(:Z)

      # Parametry sekcji (kolejność = kolejność w oknie).
      LISTA = [
        { klucz: 'zadaszenie', podstawowy: true, domyslna: 'nie', etykieta: 'Boczne zadaszenie przy ścianie okapowej',
          rodzaj: :wybor, sekcja: 'zadaszenie',
          wybory: [['nie', 'bez zadaszenia'], ['slupy', 'na słupach z oczepem (wiata, drewutnia)'],
                   ['bale', 'ściany z bali (przybudówka)']],
          podpowiedz: 'Połać dachu za ścianą okapową schodzi dalej pod mniejszym kątem – załamanie nad licem zewnętrznym ' \
                      'ściany. Narysuj sam dom: słupy, belki i płatwie zadaszenia albo ściany przybudówki dokłada generator. ' \
                      'Aplikacja do dachów dostaje połacie z załamaniem (łaty przy załamaniu, pełne moduły pod nim). ' \
                      'Dom prostokątny, dach dwuspadowy, bez tarasu.',
          pomoc: 'Boczne zadaszenie biegnie wzdłuż całej ściany okapowej, za szczyty wychodzi jak dach (wysunięcie płatwi). ' \
                 'Linia załamania leży nad licem zewnętrznym ściany okapowej (przy płatwi ściennej stojącej na ścianie – nad ' \
                 'jej krawędzią): dach domu nad nią bez zmian, dalej połać zadaszenia pod kątem zadaszenia do podpory ' \
                 '(słupy z oczepem albo niska ściana przybudówki) i okap. Płatwie zadaszenia co najwyżej „Największy rozstaw ' \
                 'płatwi”: pierwsza tuż przy ścianie (w gniazdach ostatków ścian szczytowych), ostatnia nad słupami (oczep). ' \
                 'Na słupach: belka poprzeczna na każdym słupie aż do ściany domu, płatwie na słupkach. Przybudówka: ściany ' \
                 'szczytowe przedłużone, dawna ściana okapowa zostaje jako działowa, ściana zewnętrzna przybudówki niska – ' \
                 'górny bal ścięty do połaci zadaszenia.' },
        { klucz: 'zadaszenie_strona', podstawowy: true, domyslna: 'min', etykieta: 'Zadaszenie – przy ścianie okapowej',
          rodzaj: :wybor, sekcja: 'zadaszenie', gdy: { 'zadaszenie' => Z },
          wybory: [['min', 'dolnej albo lewej (rysunek z góry)'], ['max', 'górnej albo prawej (rysunek z góry)'],
                   ['obie', 'po obu stronach']],
          podpowiedz: 'Kalenica wzdłuż X – ściana dolna / górna rysunku, wzdłuż Y – lewa / prawa.' },
        { klucz: 'zadaszenie_szerokosc', podstawowy: true, domyslna: 2000.0, etykieta: 'Zadaszenie – szerokość', jednostka: 'mm',
          min: 600.0, max: 6000.0, rodzaj: :liczba, sekcja: 'zadaszenie', gdy: { 'zadaszenie' => Z },
          podpowiedz: 'Od lica zewnętrznego ściany domu do lica zewnętrznego podpory (słupów albo ściany przybudówki), w poziomie.' },
        { klucz: 'zadaszenie_kat', podstawowy: true, domyslna: 12.0, etykieta: 'Zadaszenie – kąt (mniejszy niż kąt dachu)',
          jednostka: '°', min: 3.0, max: 50.0, rodzaj: :liczba, sekcja: 'zadaszenie', gdy: { 'zadaszenie' => Z },
          podpowiedz: 'Musi być mniejszy niż kąt dachu (załamanie). Blachodachówka zwykle od 9–12°, blacha na rąbek od 3–5° – ' \
                      'sprawdź kartę pokrycia.' },
        { klucz: 'zadaszenie_okap', domyslna: 300.0, etykieta: 'Zadaszenie – okap za podporą (najmniej)', jednostka: 'mm',
          min: 0.0, max: 1500.0, rodzaj: :liczba, sekcja: 'zadaszenie', gdy: { 'zadaszenie' => Z },
          podpowiedz: 'W poziomie, od lica podpory. Aplikacja do dachów wydłuża go do pełnych modułów łat (0 … 1 moduł).' },
        { klucz: 'zadaszenie_platwa_przekroj', domyslna: '80x160', etykieta: 'Płatew zadaszenia (szer. × wys.)', jednostka: 'mm',
          rodzaj: :przekroj, sekcja: 'zadaszenie', gdy: { 'zadaszenie' => Z },
          podpowiedz: 'Wszystkie płatwie zadaszenia (przy ścianie, pośrednie, oczep nad słupami); wierzch ścięty do połaci jak ' \
                      'płatwie dachu. Bez sprawdzenia nośności.' },
        { klucz: 'zadaszenie_slup_przekroj', domyslna: '120x120', etykieta: 'Słup zadaszenia (wzdłuż ściany × w poprzek)',
          jednostka: 'mm', rodzaj: :przekroj, sekcja: 'zadaszenie', gdy: { 'zadaszenie' => ['slupy'] },
          podpowiedz: 'Słupy na fundamentach punktowych (wymiary fundamentu jak pod podłogą), lico zewnętrzne w linii podpory.' },
        { klucz: 'zadaszenie_slupy_rozstaw', domyslna: 2500.0, etykieta: 'Słupy zadaszenia – największy rozstaw (osiowo)',
          jednostka: 'mm', min: 800.0, max: 6000.0, rodzaj: :liczba, sekcja: 'zadaszenie', gdy: { 'zadaszenie' => ['slupy'] },
          podpowiedz: 'Skrajne słupy w osiach ścian szczytowych, pośrednie równo; słup w miejscu węgła albo działowej ' \
                      'przesunięty obok.' },
        { klucz: 'zadaszenie_belka_przekroj', domyslna: '80x160', etykieta: 'Belka poprzeczna na słupie (szer. × wys.)',
          jednostka: 'mm', rodzaj: :przekroj, sekcja: 'zadaszenie', gdy: { 'zadaszenie' => ['slupy'] },
          podpowiedz: 'Na każdym słupie od lica podpory do ściany domu (przy szczycie – do końca ostatków); na niej oczep, ' \
                      'na słupkach płatwie zadaszenia. Ściana domu osiada (bale) – belka tylko oparta o ścianę.' }
      ].freeze unless const_defined?(:LISTA)
    end
  end
end
