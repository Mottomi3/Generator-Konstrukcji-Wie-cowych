# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/parametry_stolarka.rb
# Zadanie: parametry stolarki – lista typowej stolarki (pole-tabela), folder modeli, prosty model okna i drzwi z generatora (rama, szyba, skrzydło drzwi, maskownice), gdy nie ma pliku modelu.
# Tematy: lista stolarki – parametr, folder modeli stolarki, ścieżka modelu stolarki, prosty model stolarki – parametry, maskownice – parametry, rama okna – parametr
# Zależy od: –
# Używają: rdzen/parametry_lista.rb (LISTA – sklejona z list sekcji), rdzen/stolarka_modele.rb, rdzen/stolarka_prosta.rb
#
# Wpis jak w rdzen/parametry_lista.rb. Cecha sciezka: 'folder' | 'plik' – przy polu okno dodaje przycisk „Wybierz…”
# (sketchup/okno_sciezki.rb); kolumna tabeli rodzaju :plik – pole tekstowe z przyciskiem wyboru pliku .skp.
# Decyzja użytkownika (2026-11-27): „nie stworzyłem modeli okien i drzwi, możesz dać tam do wprowadzenia ścieżkę dostępu,
# to da mi możliwość podmiany modeli” – bez pliku generator wstawia prosty model (do podmiany ścieżką).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module ParametryStolarka
      LISTA = [
        { klucz: 'stolarka', poziom: :standard, rodzaj: :tabela, sekcja: 'otwory', etykieta: 'Typowa stolarka – okna i drzwi',
          kolumny: [['symbol', 'Symbol', :tekst], ['rodzaj', 'Rodzaj', :wybor, [%w[okno okno], %w[drzwi drzwi]]],
                    ['szerokosc', 'Szer. stolarki [mm]', :liczba], ['wysokosc', 'Wys. stolarki [mm]', :liczba],
                    ['spod', 'Spód od podwaliny [mm]', :liczba], ['model', 'Model – plik .skp (nazwa albo pełna ścieżka)', :plik]],
          domyslna: [{ 'symbol' => 'O1', 'rodzaj' => 'okno', 'szerokosc' => 1020.0, 'wysokosc' => 1010.0, 'spod' => 900.0, 'model' => '' },
                     { 'symbol' => 'D1', 'rodzaj' => 'drzwi', 'szerokosc' => 930.0, 'wysokosc' => 2100.0, 'spod' => 0.0, 'model' => '' }],
          podpowiedz: 'Okna i drzwi do wstawiania kliknięciem w widok ściany i z listy przy tabeli otworów. Model – pełna ścieżka ' \
                      'pliku .skp („…” – wybór pliku) albo sama nazwa pliku w folderze modeli; puste – plik o nazwie symbolu ' \
                      '(np. O1.skp). Bez pliku – prosty model z generatora albo sam otwór (pole niżej).' },
        { klucz: 'stolarka_folder', poziom: :standard, domyslna: '', etykieta: 'Folder modeli stolarki (.skp)', rodzaj: :tekst, sekcja: 'otwory',
          sciezka: 'folder',
          podpowiedz: 'Pełna ścieżka folderu z modelami okien i drzwi, np. C:\\Users\\…\\Stolarka („Wybierz…” – okno wyboru). Model: ' \
                      'punkt 0 w dolnym lewym narożniku stolarki od zewnątrz, oś czerwona wzdłuż szerokości, zielona w głąb ' \
                      'ściany, niebieska w górę.' },
        { klucz: 'stolarka_prosta', poziom: :standard, podstawowy: true, domyslna: 'tak', etykieta: 'Bez pliku modelu – prosty model okna i drzwi',
          rodzaj: :wybor, sekcja: 'otwory',
          wybory: [['tak', 'prosty model z generatora (rama, szyba / skrzydło, maskownice)'], ['nie', 'sam otwór']],
          podpowiedz: 'Prosty model stoi w otworze do czasu podmiany na Twój plik (kolumna „Model” listy stolarki albo folder ' \
                      'modeli). Nie wchodzi do list bali ani wyceny.' },
        { klucz: 'stolarka_rama', poziom: :standard, domyslna: 68.0, etykieta: 'Prosty model – szerokość ramy', jednostka: 'mm', min: 20.0,
          max: 200.0, rodzaj: :liczba, sekcja: 'otwory', gdy: { 'stolarka_prosta' => ['tak'] },
          podpowiedz: 'Rama (ościeżnica) na całą grubość ściany; w oknie szyba w środku ramy, w drzwiach pełne skrzydło.' },
        { klucz: 'maskownica_szerokosc', poziom: :standard, domyslna: 95.0, etykieta: 'Prosty model – maskownica, szerokość', jednostka: 'mm',
          min: 0.0, max: 300.0, rodzaj: :liczba, sekcja: 'otwory', gdy: { 'stolarka_prosta' => ['tak'] },
          podpowiedz: 'Deski maskujące luz wokół stolarki od zewnątrz, przykręcone do ramy; 0 – bez maskownic.' },
        { klucz: 'maskownica_grubosc', poziom: :standard, domyslna: 20.0, etykieta: 'Prosty model – maskownica, grubość', jednostka: 'mm',
          min: 5.0, max: 60.0, rodzaj: :liczba, sekcja: 'otwory', gdy: { 'stolarka_prosta' => ['tak'] } },
        { klucz: 'maskownica_zakladka', poziom: :standard, domyslna: 15.0, etykieta: 'Prosty model – maskownica zachodzi na ramę', jednostka: 'mm',
          min: 0.0, max: 100.0, rodzaj: :liczba, sekcja: 'otwory', gdy: { 'stolarka_prosta' => ['tak'] } }
      ].freeze unless const_defined?(:LISTA)
    end
  end
end
