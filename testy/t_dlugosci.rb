# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_dlugosci.rb
# Zadanie: testy wykazu drewna z hurtowni i długości handlowych – odczyt list „przekrój:długości”, listy fabryczne, podpowiedź o belce dłuższej niż w hurtowni, dobór przekroju dostępnego w całej długości.
# Tematy: testy wykazu drewna, test listy przekrojów z długościami, test długości handlowych, test doboru z długością
# Zależy od: testy/pomoc.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_dlugosci.rb – ostatnia linia „FAILURES: n”.

require File.expand_path('pomoc', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

# Plan domu prostokątnego w × d [mm] z parametrami.
def dom(w, d, parametry = {})
  Projekt.oblicz('segmenty' => prostokat(0, 0, w, d), 'parametry' => parametry, 'otwory' => [])
end

# Podpowiedzi o długościach handlowych z planu.
def dlugie(pl)
  pl[:podpowiedzi].select { |h| h[:tekst].include?('najdłuższa belka tego przekroju') }
end

Testy.grupa('Odczyt listy „przekrój:długości”')
w = WykazDrewna.wpisy("45x145:4.2/5.4/6, 45x170: 5,4 / 6; 50x100\n63×175 : 4200/5400")
Testy.rowne(w, [[45.0, 145.0, [4200.0, 5400.0, 6000.0]], [45.0, 170.0, [5400.0, 6000.0]], [50.0, 100.0, []], [63.0, 175.0, [4200.0, 5400.0]]],
            'przecinek, średnik i nowy wiersz między przekrojami; metry z kropką albo przecinkiem; milimetry')
Testy.rowne(WykazDrewna.wpisy('45x95:6,45x120:5/5.4'), [[45.0, 95.0, [6000.0]], [45.0, 120.0, [5000.0, 5400.0]]], 'bez spacji po przecinku')
Testy.rowne(WykazDrewna.wpisy('60x100, 60x120, tekst, 0x50'), [[60.0, 100.0, []], [60.0, 120.0, []]], 'lista ze starszej kompilacji – bez długości; śmieci pominięte')
p = Parametry.normalizuj('przekroje_katalog' => '45x145:6, 195x45:7, 45x145:4.2')[0]
Testy.rowne(Parametry.katalog(p), [[45.0, 145.0], [195.0, 45.0]], 'katalog – przekroje bez powtórzeń')
Testy.rowne(Parametry.dlugosci_katalogu(p), { [45.0, 145.0] => [4200.0, 6000.0], [45.0, 195.0] => [7000.0] },
            'długości – klucz mniejszy × większy, powtórzony przekrój scalony')

Testy.grupa('Listy fabryczne z wykazu hurtowni (2026-11-14)')
p0 = Parametry.normalizuj({})[0]
leg = Parametry.katalog(p0)
Testy.sprawdz(p0['przekroje_katalog'].include?('45x120:5.4/6') && !p0['przekroje_katalog'].include?('45x120:5/5.4'),
              '45 × 120 w długościach 5,4 / 6 m (decyzja z 2026-11-25)')
Testy.rowne(Parametry.dlugosci_katalogu(p0)[[45.0, 120.0]], [5400.0, 6000.0], 'długości 45 × 120 do doboru')
Testy.sprawdz(leg.include?([45.0, 245.0]) && leg.include?([200.0, 200.0]) && !leg.include?([38.0, 58.0]), 'legary: od 45 × 95 w górę, z drewnem widocznym')
%w[50x100 50x150 50x175 50x200 50x225 63x175 63x200 63x225 75x200 75x225 75x250 100x150].each do |t|
  Testy.sprawdz(!leg.include?(Parametry.przekroj_z(t)), "legary: #{t} nie ma w hurtowni – wypadł z listy")
end
Testy.rowne(Parametry.dlugosci_katalogu(p0)[[45.0, 195.0]], [4200.0, 5400.0, 6000.0, 7000.0], '45 × 195: konstrukcyjne 4,2 / 5,4 / 6 i Nsi 7 m razem')
pla = Parametry.dlugosci_katalogu(p0, 'platwie_katalog')
Testy.rowne(pla.values.flatten.max, 8000.0, 'płatwie: najdłuższa belka 8 m')
Testy.rowne(pla.select { |_k, d| d.last >= 8000.0 }.keys, [[80.0, 200.0]], '8 m tylko w 80 × 200')
Testy.sprawdz(Parametry.katalog(p0, 'platwie_katalog').all? { |b, h| h > b && b >= 60 }, 'płatwie: prostokątne od szerokości 60')
Testy.rowne(Parametry.katalog(p0, 'zadaszenie_slupy_katalog'), [[100.0, 100.0], [120.0, 120.0], [140.0, 140.0], [160.0, 160.0], [200.0, 200.0]],
            'słupy zadaszenia: kwadratowe z wykazu (bez 180 × 180)')
kr = Parametry.katalog(p0, 'krokwie_katalog')
Testy.sprawdz(kr.include?([45.0, 145.0]) && kr.include?([80.0, 200.0]) && !kr.include?([50.0, 150.0]) && !kr.include?([80.0, 240.0]),
              'krokwie: z wykazu, bez 50 × … i 80 × 240')

Testy.grupa('Belka dłuższa niż w hurtowni – podpowiedź')
pl = dom(10_000, 8000)
h = dlugie(pl)
Testy.rowne(h.length, 1, 'dom 10 × 8 m: jedna podpowiedź o płatwiach')
Testy.sprawdz(h[0][:poziom] == 'uwaga' && h[0][:sekcja] == 'szczyty', 'poziom uwaga, sekcja „Szczyty i dach”')
Testy.sprawdz(h[0][:tekst] =~ /Płatwie 80 × 200: \d+ szt\. o długości do 11 m, a najdłuższa belka tego przekroju z listy ma 8 m/,
              "ile, jak długie, jaka najdłuższa (#{h[0][:tekst]})")
Testy.sprawdz(h[0][:tekst].include?('połącz je nad podporą') && h[0][:tekst].include?('żadna belka z listy nie ma takiej długości'), 'rada: łączyć nad podporą')
Testy.rowne(dlugie(dom(6000, 4000)), [], 'dom 6 × 4 m: płatwie 7 m – 80 × 200 jest w 7 i 8 m, bez podpowiedzi')
pl = dom(10_000, 8000, 'platwie_katalog' => '60x200, 80x200, 140x240')
Testy.rowne(dlugie(pl), [], 'lista bez długości (starsza kompilacja) – bez podpowiedzi')
pl = dom(10_000, 8000, 'platwa_przekroj' => '90x210')
Testy.rowne(dlugie(pl), [], 'przekrój spoza listy – bez podpowiedzi')
pl = dom(6500, 4000, 'platwa_przekroj' => '60x160')
h = dlugie(pl)
Testy.sprawdz(h.length == 1 && h[0][:tekst] =~ /w całej długości są: \d+ × \d+/, "płatwie 60 × 160 (5 / 6 m) na 7,5 m – wskazane przekroje w całej długości (#{h.map { |x| x[:tekst] }.inspect})")

Testy.grupa('Dobór automatyczny – najpierw przekrój dostępny w całej długości')
lista = [[60.0, 120.0], [60.0, 140.0], [80.0, 200.0]]
pd = Parametry.normalizuj('platwie_katalog' => '60x120:5/6, 60x140:5/6/7, 80x200:5/7/8')[0]
Testy.rowne(DlugosciHandlowe.najlzejszy(lista, 6800.0, pd, 'platwie_katalog'), [60.0, 140.0], '6,8 m: 60 × 120 kończy się na 6 m – bierze 60 × 140')
Testy.rowne(DlugosciHandlowe.najlzejszy(lista, 5500.0, pd, 'platwie_katalog'), [60.0, 120.0], '5,5 m: najlżejszy')
Testy.rowne(DlugosciHandlowe.najlzejszy(lista, 9000.0, pd, 'platwie_katalog'), [60.0, 120.0], '9 m: żadnej belki – najlżejszy (z podpowiedzią o łączeniu)')
Testy.rowne(DlugosciHandlowe.najlzejszy([], 5000.0, pd, 'platwie_katalog'), nil, 'nic nie wystarcza – nil')
pb = Parametry.normalizuj('platwie_katalog' => '60x120, 60x140')[0]
Testy.rowne(DlugosciHandlowe.najlzejszy(lista, 9000.0, pb, 'platwie_katalog'), [60.0, 120.0], 'lista bez długości – bez ograniczenia')
# Wiata 2 m przy domu 6 × 4 m: płatwie zadaszenia 7 m – dobór nie bierze przekroju, który kończy się na 6 m.
pl = dom(6000, 4000, 'zadaszenie' => 'slupy', 'dach_kat' => 30, 'liczba_wiencow' => 14)
bz = Parametry.przekroj(pl[:parametry], 'zadaszenie_platwa_przekroj')
dz = Parametry.dlugosci_katalogu(pl[:parametry], 'zadaszenie_katalog')[bz.sort]
naj = pl[:elementy].select { |e| e[:prefiks] == 'P' && e[:tag] == :zadaszenie }.map { |e| e[:dl] }.max
Testy.sprawdz(dz && dz.last + 1.0 >= naj, "wiata: dobrana płatew #{bz.inspect} jest w hurtowni w całej długości #{naj.round} mm")
Testy.rowne(dlugie(pl).select { |x| x[:sekcja] == 'zadaszenie_przekroje' }, [], 'wiata: bez podpowiedzi o łączeniu')

Testy.koniec
