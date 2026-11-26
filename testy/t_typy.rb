# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_typy.rb
# Zadanie: testy typów domów i standardu warsztatu w pliku ustawień (runda 16) – typy wbudowane i własne (zapis, zmiana, powielenie, usunięcie, wybrany typ), standard (tylko pola standardu inne niż fabryczne), nowy dom z typu i standardu, pliki ustawień starszych kompilacji (ostatnie parametry → standard i typ, szablony → typy, kopia starego pliku).
# Tematy: testy typów domów, testy standardu warsztatu, test pliku ustawień starszej wersji, test nowego domu z typu, test szablonów jako typów
# Zależy od: testy/pomoc.rb, testy/atrapa/sketchup.rb, Plugins/.../sketchup/ustawienia.rb, sketchup/typy_domow.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_typy.rb – ostatnia linia „FAILURES: n”.

require 'json'
require 'tmpdir'
require 'fileutils'
ENV['AM_GW_USTAWIENIA'] = File.join(Dir.tmpdir, "am_gw_typy_#{Process.pid}")
FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
require File.expand_path('atrapa/sketchup', File.dirname(__FILE__))
require File.expand_path('pomoc', File.dirname(__FILE__))
require File.join(File.dirname(KATALOG_WTYCZKI), 'arte_madera_generator_wiencowy.rb')
require File.join(KATALOG_WTYCZKI, 'main.rb')
include ArteMadera::GeneratorWiencowy

# Zapis pliku ustawień o podanej zawartości (jak z wcześniejszej kompilacji).
def plik_ustawien(dane)
  FileUtils.mkdir_p(Ustawienia.katalog)
  FileUtils.rm_f(File.join(Ustawienia.katalog, Ustawienia::KOPIA))
  File.open(Ustawienia.sciezka, 'w') { |f| f.write(dane.is_a?(String) ? dane : JSON.generate(dane)) }
end

Testy.grupa('Typy wbudowane')
wb = TypyDomow.lista
Testy.rowne(wb.map { |t| t['nazwa'][0, 7] }, ['Typ 100', 'Typ 200', 'Typ 300', 'Typ 400'], 'cztery typy wbudowane, bez własnych')
Testy.sprawdz(wb.all? { |t| t['wbudowany'] && t['opis'].length > 10 }, 'każdy z jednym zdaniem opisu')
t200 = wb[1]['nazwa']
Testy.rowne(TypyDomow.parametry(t200), { 'liczba_wiencow' => '20', 'taras' => 'podciag', 'taras_glebokosc' => '2000' }, 'Typ 200: pola typu i domu jako teksty okna')
Testy.rowne(TypyDomow.wybrany, wb[0]['nazwa'], 'bez pliku ustawień wybrany pierwszy wbudowany')
Testy.sprawdz(TypyDomow.wbudowane.values.all? { |t| t['parametry'].keys.all? { |k| %w[dom typ].include?(Poziomy.poziom(k)) } }, 'typy wbudowane mają tylko pola typu i domu')
Testy.rowne(Ustawienia.wczytaj, Ustawienia.pusty, 'pusty zestaw ustawień')
Testy.rowne([Ustawienia.uklad, Ustawienia.tryb_pol], %w[kroki podstawowe], 'fabrycznie: układ nowy, pola podstawowe')

Testy.grupa('Własne typy: zapisz jako, zapisz zmiany, powiel, usuń')
Testy.rowne(TypyDomow.zapisz('  ', 'x', {}), 'Podaj nazwę typu.', 'pusta nazwa')
Testy.sprawdz(TypyDomow.zapisz(t200, nil, {}).include?('wbudowany'), 'typ wbudowany nie do nadpisania')
Testy.sprawdz(TypyDomow.zapisz('x' * 81, nil, {}).include?('najwyżej'), 'za długa nazwa')
Testy.rowne(TypyDomow.zapisz(' Letni 35 ', ' do 35 m² ', 'liczba_wiencow' => '14', 'dach_kat' => '25', 'mijanka' => '600', 'taras' => 'podciag', 'zamek' => { 'gniazdo_gleb' => '30' }), nil, 'zapis nowego typu')
Testy.rowne(TypyDomow.typ('Letni 35'), { 'opis' => 'do 35 m²', 'parametry' => { 'liczba_wiencow' => '14', 'dach_kat' => '25', 'taras' => 'podciag' } },
            'typ pamięta pola typu i domu – pole standardu i zamek pominięte; nazwa i opis bez spacji na końcach')
Testy.rowne(TypyDomow.wybrany, 'Letni 35', 'zapisany typ staje się wybranym')
Testy.rowne(TypyDomow.zapisz('Letni 35', nil, 'liczba_wiencow' => '15'), nil, 'zapis zmian w typie')
Testy.rowne(TypyDomow.typ('Letni 35'), { 'opis' => 'do 35 m²', 'parametry' => { 'liczba_wiencow' => '15' } }, 'zmiany zapisane, opis zostaje')
Testy.rowne(TypyDomow.powiel('Letni 35', 'Letni 35 z tarasem'), nil, 'powielenie')
Testy.sprawdz(TypyDomow.powiel(t200, 'Letni 35').include?('już jest') && TypyDomow.powiel('brak', 'x').include?('Nie ma'), 'powielenie: zajęta nazwa, nieznany typ')
Testy.rowne(TypyDomow.lista.map { |t| t['nazwa'] }[4..-1], ['Letni 35', 'Letni 35 z tarasem'], 'własne po wbudowanych, alfabetycznie')
Testy.sprawdz(TypyDomow.usun(t200).include?('wbudowanych') && TypyDomow.usun('brak').include?('Nie ma'), 'usuwanie: wbudowany, nieznany')
Testy.rowne([TypyDomow.usun('Letni 35 z tarasem'), TypyDomow.wybrany], [nil, wb[0]['nazwa']], 'usunięcie wybranego typu – wybrany wraca do pierwszego wbudowanego')
Testy.rowne([TypyDomow.wybierz('Letni 35'), TypyDomow.wybrany, TypyDomow.wybierz('brak').to_s.include?('Nie ma')], [nil, 'Letni 35', true], 'wybór typu zapamiętany')

Testy.grupa('Standard warsztatu')
Testy.rowne(Ustawienia.zapisz_standard('mijanka' => '500', 'max_dlugosc' => '5100', 'liczba_wiencow' => '9', 'dach_kat' => '45', 'zamek' => { 'gniazdo_gleb' => '36' }), nil, 'zapis standardu')
Testy.rowne(Ustawienia.standard, { 'mijanka' => '500' }, 'zostają pola standardu inne niż fabryczne (bal 5100 i zamek z presetu – fabryczne; pola domu pominięte)')
Ustawienia.zapisz_standard('mijanka' => '500', 'zamek' => { 'gniazdo_gleb' => '34' })
Testy.rowne(Ustawienia.standard, { 'mijanka' => '500', 'zamek' => { 'gniazdo_gleb' => '34' } }, 'własne wymiary zamka w standardzie')
nowy = TypyDomow.nowy_dom('Letni 35')
Testy.rowne(nowy, { 'mijanka' => '500', 'liczba_wiencow' => '15', 'zamek' => { 'gniazdo_gleb' => '34' } }, 'parametry nowego domu: standard i pola typu')
b = TypyDomow.baza('Letni 35')
Testy.rowne([b['mijanka'], b['liczba_wiencow'], b['zamek']['gniazdo_gleb'], b['dach_kat']], [500.0, 15, 34.0, 20.0], 'baza porównania: standard, typ, reszta fabryczna')
Testy.rowne(JSON.parse(File.read(Ustawienia.sciezka)).keys.sort, %w[okno standard typ typy wersja], 'plik: standard, typy, wybrany typ, okno, wersja')
Testy.rowne([Ustawienia.zapisz_standard({}), Ustawienia.standard], [nil, {}], 'pusty zestaw – powrót do fabrycznych')
Testy.sprawdz(TypyDomow.typ('Letni 35'), 'zapis standardu nie rusza typów')

Testy.grupa('Nowy dom zaczyna od typu i standardu, nie od ostatniego podglądu')
Ustawienia.zapisz_standard('mijanka' => '450')
m = Sketchup::Model.new
Sketchup.model = m
prostokat(0, 0, 5000, 4000).each do |a, c|
  m.selection.add(m.entities.add_line(Geom::Point3d.new(a[0] / 25.4, a[1] / 25.4, 0), Geom::Point3d.new(c[0] / 25.4, c[1] / 25.4, 0)))
end
Sterowanie.start
d = Okno.dane_startowe
Testy.rowne([d['parametry']['liczba_wiencow'], d['parametry']['mijanka'], d['typy']['typ']], %w[15 450] + ['Letni 35'], 'okno: wieńce z typu, mijanka ze standardu')
przed = File.read(Ustawienia.sciezka)
Sterowanie.podglad('parametry' => d['parametry'].merge('liczba_wiencow' => '8', 'mijanka' => '700'), 'otwory' => [], 'typ' => 'Letni 35')
Testy.rowne(File.read(Ustawienia.sciezka), przed, 'podgląd z innymi wartościami nie zmienia pliku ustawień')
Sterowanie.start
Testy.rowne(Okno.dane_startowe['parametry']['liczba_wiencow'], '15', 'następne okno znów od typu (15 wieńców), nie od podglądu (8)')
Testy.rowne(Okno.dane_startowe['info'].include?('ostatniego'), false, 'bez informacji o parametrach z ostatniego użycia')

Testy.grupa('Plik ustawień z kompilacji 15: ostatnie parametry → standard i typ, szablony → typy')
plik_ustawien('wersja' => 4,
              'ostatnie' => { 'liczba_wiencow' => '18', 'mijanka' => '500', 'max_dlugosc' => '5100', 'dach_kat' => '30', 'polzamek' => 'nie',
                              'poszycie_nadbitka' => 'tak', 'podbitka' => 'nie', 'nadbitka_grubosc' => '19', 'dach_uklad' => 'platwie_krokwie',
                              'zamek' => { 'gniazdo_gleb' => '36', 'gniazdo_szer' => '38' } },
              'szablony' => { 'Mój dom' => { 'liczba_wiencow' => '22', 'dach_kat' => '35', 'mijanka' => '300', 'poszycie_nadbitka' => 'nie', 'polzamek' => 'nie' } },
              'okno' => { 'tryb_pol' => 'wszystkie' })
u = Ustawienia.wczytaj
Testy.rowne(u['standard'], { 'mijanka' => '500', 'podbitka_grubosc' => '19', 'zamek' => { 'gniazdo_gleb' => '36', 'gniazdo_szer' => '38' } },
            'standard: pola standardu inne niż fabryczne z ostatnich parametrów (deska nadbitki 19 → wspólna deska) i własny zamek; wyłączone pół zamka pominięte')
Testy.rowne(u['typy'][Ustawienia::TYP_OSTATNIE]['parametry'], { 'liczba_wiencow' => '18', 'dach_kat' => '30', 'podbitka' => 'na_krokwiach', 'dach_uklad' => 'platwie_krokwie' },
            'typ „Ostatnie ustawienia”: pola typu i domu inne niż fabryczne (nadbitka włączona → deski na krokwiach)')
Testy.rowne(u['typy']['Mój dom']['parametry'], { 'liczba_wiencow' => '22', 'dach_kat' => '35', 'podbitka' => 'nie' }, 'szablon → typ: pola typu i domu, nadbitka wyłączona = bez desek')
Testy.rowne([u['typ'], u['okno']['tryb_pol'], TypyDomow.wybrany], [Ustawienia::TYP_OSTATNIE, 'wszystkie', Ustawienia::TYP_OSTATNIE], 'wybrany typ z ostatnich parametrów, ustawienia okna zostają')
Testy.rowne([JSON.parse(File.read(Ustawienia.sciezka))['wersja'], JSON.parse(File.read(File.join(Ustawienia.katalog, Ustawienia::KOPIA)))['wersja']], [5, 4],
            'plik zapisany w wersji 5, stary plik obok jako kopia')
Testy.rowne(TypyDomow.baza(TypyDomow.wybrany).values_at('liczba_wiencow', 'mijanka', 'polzamek', 'podbitka'), [18, 500.0, 'tak', 'na_krokwiach'], 'nowy dom po przeniesieniu: jak ostatnio, z pół zamkiem')

Testy.grupa('Starsze pliki: wartości fabryczne zmienione w kolejnych rundach')
plik_ustawien('wersja' => 1, 'ostatnie' => { 'podciag_poziom' => 'pod', 'liczba_wiencow' => '14' })
Testy.rowne([Ustawienia.standard, TypyDomow.parametry(Ustawienia::TYP_OSTATNIE)], [{}, { 'liczba_wiencow' => '14' }], 'plik wersji 1: poziom podciągu wraca do fabrycznego, wieńce zostają w typie')
stara_lista = '45x95:6, 45x120:5/5.4, 45x145:4.2/5.4/6'
plik_ustawien('wersja' => 3, 'ostatnie' => { 'podbitka_grubosc' => '19', 'przekroje_katalog' => stara_lista, 'platwie_katalog' => '60x100:6' },
              'szablony' => { 'A' => { 'przekroje_katalog' => stara_lista, 'dach_kat' => '35' } })
Testy.rowne([Ustawienia.standard, TypyDomow.parametry('A'), TypyDomow.typ(Ustawienia::TYP_OSTATNIE)], [{ 'platwie_katalog' => '60x100:6' }, { 'dach_kat' => '35' }, nil],
            'plik wersji 3: deski 19 i stara lista legarów pominięte, własna lista płatwi w standardzie; bez pól typu – bez typu „Ostatnie”')
plik_ustawien('{uszkodzony')
Testy.rowne([Ustawienia.wczytaj, TypyDomow.wybrany], [Ustawienia.pusty, wb[0]['nazwa']], 'uszkodzony plik – puste ustawienia, bez błędu')

FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
Testy.koniec
