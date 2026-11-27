# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_drewutnia.rb
# Zadanie: parametry sekcji „Drewutnia / zadaszenie przy ścianie szczytowej” – wariant, strona (z tyłu – naprzeciw tarasu), głębokość, szerokość, kąt, wysokość, okap, rozstaw słupów, odstępy od ściany i dachu domu, przekroje belek i słupów.
# Tematy: drewutnia – parametry, zadaszenie przy ścianie szczytowej – parametry, wiata przy szczycie – parametry, dodatki domu – parametry
# Zależy od: rdzen/magazyn_drewna.rb (przekroje z magazynu – pole magazyn)
# Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji)
#
# Odpowiedź użytkownika z rundy 19 na „typ + dodatki” – „tak”: typ = bryła domu, dodatki osobnymi przełącznikami; pierwszy
# nowy dodatek – drewutnia / zadaszenie przy ścianie szczytowej z tyłu (rdzen/drewutnia.rb). Przełącznik dodatku to pole
# „Ten dom” (widoczne od razu w kroku „Dodatki”, nie w typie); przekroje – w typie. Wpis jak w
# rdzen/parametry_lista.rb (gdy – pole widoczne tylko przy wybranych wartościach innych pól).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module ParametryDrewutnia
      # Warunek pól zależnych: drewutnia wybrana.
      GDY = { 'drewutnia' => ['slupy'] }.freeze unless const_defined?(:GDY)

      # Parametry sekcji (kolejność = kolejność w oknie).
      LISTA = [
        { klucz: 'drewutnia', poziom: :dom, podstawowy: true, domyslna: 'nie',
          obrys: { tylko: %w[prostokat], zostaje: %w[nie], powod: 'Drewutnia tylko przy obrysie prostokątnym.' },
          etykieta: 'Drewutnia / zadaszenie przy ścianie szczytowej', rodzaj: :wybor, sekcja: 'drewutnia',
          wybory: [['nie', 'bez drewutni'], ['slupy', 'na słupach – dach jednospadowy od ściany szczytowej']],
          podpowiedz: 'Wiata z dachem jednospadowym przy ścianie szczytowej: słupy przy ścianie i na zewnątrz, na nich płatew ' \
                      'i oczep, krokwie ze spadkiem od ściany. Stoi obok ściany (ściana z bali osiada, drewutnia nie) i pod okapem ' \
                      'dachu domu z zapasem na osiadanie. Dom prostokątny.',
          pomoc: 'Szerokość: między ostatkami ścian okapowych (pełna) albo mniejsza, na środku ściany. Głębokość: od lica ściany ' \
                 'szczytowej do lica zewnętrznego słupów. Wysokość: wierzch krokwi przy ścianie – najwyżej pod dachem domu ' \
                 '(odstęp od dachu + osiadanie ścian pod nim). Węgły i działowe wychodzące przed ścianę oraz podwalina odsuwają ' \
                 'słupy i krokwie od ściany. Krokwie z przekroju i rozstawu krokwi dachu, pokrycie – na budowie.' },
        { klucz: 'drewutnia_strona', poziom: :dom, podstawowy: true, domyslna: 'tyl', etykieta: 'Drewutnia – przy ścianie',
          rodzaj: :wybor, sekcja: 'drewutnia', gdy: GDY,
          wybory: [['tyl', 'z tyłu – naprzeciw tarasu (bez tarasu: lewa albo dolna)'],
                   ['min', 'lewej albo dolnej (rysunek z góry)'], ['max', 'prawej albo górnej (rysunek z góry)']],
          podpowiedz: 'Ściana szczytowa: kalenica wzdłuż X – lewa / prawa strona rysunku, wzdłuż Y – dolna / górna.' },
        { klucz: 'drewutnia_glebokosc', poziom: :dom, podstawowy: true, domyslna: 1500.0, etykieta: 'Drewutnia – głębokość', jednostka: 'mm',
          min: 600.0, max: 4000.0, rodzaj: :liczba, sekcja: 'drewutnia', gdy: GDY,
          podpowiedz: 'Od lica ściany szczytowej do lica zewnętrznego słupów, w poziomie.' },
        { klucz: 'drewutnia_szerokosc', poziom: :dom, podstawowy: true, domyslna: 0.0, etykieta: 'Drewutnia – szerokość (0 – pełna)', jednostka: 'mm',
          min: 0.0, max: 30_000.0, rodzaj: :liczba, sekcja: 'drewutnia', gdy: GDY,
          podpowiedz: 'Wzdłuż ściany szczytowej, na jej środku; 0 albo więcej niż się mieści – między ostatkami ścian okapowych.' },
        { klucz: 'drewutnia_kat', poziom: :dom, podstawowy: true, domyslna: 10.0, etykieta: 'Drewutnia – kąt dachu', jednostka: '°',
          min: 3.0, max: 30.0, rodzaj: :liczba, sekcja: 'drewutnia', gdy: GDY,
          podpowiedz: 'Spadek od ściany na zewnątrz. Sprawdź najmniejszy kąt w karcie pokrycia (blacha na rąbek od 3–5°).' },
        { klucz: 'drewutnia_wysokosc', poziom: :dom, domyslna: 0.0, etykieta: 'Drewutnia – wysokość przy ścianie (0 – najwyżej)', jednostka: 'mm',
          min: 0.0, max: 10_000.0, rodzaj: :liczba, sekcja: 'drewutnia', gdy: GDY,
          podpowiedz: 'Wierzch krokwi przy ścianie od spodu ścian. 0 albo więcej niż się mieści – tuż pod dachem domu.' },
        { klucz: 'drewutnia_okap', poziom: :standard, domyslna: 300.0, etykieta: 'Drewutnia – okap za słupami', jednostka: 'mm',
          min: 0.0, max: 1000.0, rodzaj: :liczba, sekcja: 'drewutnia', gdy: GDY, podpowiedz: 'W poziomie, od lica zewnętrznego słupów.' },
        { klucz: 'drewutnia_slupy_rozstaw', poziom: :standard, domyslna: 2500.0, etykieta: 'Drewutnia – największy rozstaw słupów',
          jednostka: 'mm', min: 800.0, max: 6000.0, rodzaj: :liczba, sekcja: 'drewutnia', gdy: GDY,
          podpowiedz: 'Słupy na końcach i równo pomiędzy, w dwóch rzędach: przy ścianie i na zewnątrz. Rozstaw = przęsło płatwi i oczepu.' },
        { klucz: 'drewutnia_odstep', poziom: :standard, domyslna: 30.0, etykieta: 'Drewutnia – odstęp od ściany domu', jednostka: 'mm',
          min: 5.0, max: 300.0, rodzaj: :liczba, sekcja: 'drewutnia', gdy: GDY,
          podpowiedz: 'Słupy, płatew i krokwie nie dotykają ściany z bali (osiada); tyle samo od ostatków ścian okapowych, węgłów ' \
                      'i działowych wychodzących przed ścianę.' },
        { klucz: 'drewutnia_odstep_dachu', poziom: :standard, domyslna: 50.0, etykieta: 'Drewutnia – odstęp od dachu domu', jednostka: 'mm',
          min: 0.0, max: 500.0, rodzaj: :liczba, sekcja: 'drewutnia', gdy: GDY,
          podpowiedz: 'Pod płatwiami i krokwiami dachu domu wysuniętymi za szczyt – do tego osiadanie ścian pod nimi.' },
        { klucz: 'drewutnia_belka_przekroj', magazyn: 'zadaszenie', poziom: :typ, domyslna: '100x160',
          etykieta: 'Drewutnia – płatew i oczep (szer. × wys.)', jednostka: 'mm', rodzaj: :przekroj, sekcja: 'drewutnia', gdy: GDY,
          podpowiedz: 'Płatew przy ścianie i oczep na słupach zewnętrznych; sprawdzenie nośności pod sekcją.' },
        { klucz: 'drewutnia_slup_przekroj', magazyn: 'slup', poziom: :typ, domyslna: '120x120',
          etykieta: 'Drewutnia – słup (wzdłuż ściany × w poprzek)', jednostka: 'mm', rodzaj: :przekroj, sekcja: 'drewutnia', gdy: GDY,
          podpowiedz: 'Słupy na fundamentach punktowych (jak pod podłogą); słup wolnostojący wymaga stężenia (zastrzały).' }
      ].freeze unless const_defined?(:LISTA)
    end
  end
end
