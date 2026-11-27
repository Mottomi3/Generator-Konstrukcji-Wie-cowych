# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_wycena.rb
# Zadanie: magazyn drewna (tabela fabryczna, znaczniki zastosowań, deska 14 × 115), jeden przełącznik doboru przekrojów z wyjątkami, dobór w całej długości krokwi i legarów, wycena materiału (W3) i jej blok w CSV (runda 17).
# Tematy: test magazynu drewna, test przełącznika doboru, test wyjątku doboru, test doboru w całej długości, test wyceny, test cennika materiałów, test wyceny w CSV
# Zależy od: testy/pomoc.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_wycena.rb

require File.expand_path('pomoc', File.dirname(__FILE__))
require File.join(KATALOG_WTYCZKI, 'rdzen', 'zestawienie')
include ArteMadera::GeneratorWiencowy

Testy.grupa('Magazyn drewna – tabela fabryczna')
p0 = Parametry.normalizuj({})[0]
mag = p0['magazyn_drewna']
Testy.rowne(ParametryLista.wpis('magazyn_drewna')[:rodzaj], :tabela, 'magazyn drewna – pole-tabela')
Testy.sprawdz(%w[przekroje_katalog platwie_katalog krokwie_katalog zadaszenie_katalog zadaszenie_slupy_katalog].none? { |k| ParametryLista.wpis(k) },
              'pięć pól tekstowych list przekrojów zastąpionych magazynem')
deska = mag.find { |r| r['deska'] }
Testy.rowne([deska['przekroj'], deska['dlugosci'], deska['rodzaj']], ['14x115', '4', 'deska'], 'deska 14 × 115 × 4 m w magazynie')
Testy.rowne(mag.count { |r| r['rodzaj'] == 'C24' }, 10, 'drewno konstrukcyjne C24 z wykazu hurtowni')
Testy.sprawdz(Parametry.katalog(p0, 'zadaszenie_slupy_katalog').all? { |b, h| b == h }, 'słupy – przekroje kwadratowe')
Testy.sprawdz(!Parametry.katalog(p0, 'platwie_katalog').include?([14.0, 115.0]), 'deska nie trafia do doboru płatwi')

Testy.grupa('Jeden przełącznik doboru przekrojów z wyjątkami')
Testy.rowne(%w[platwie_dobor krokwie_dobor zadaszenie_dobor legary_dobor].map { |k| ParametryLista.wpis(k)[:domyslna] }, %w[wspolny] * 4,
            'pola doboru elementów fabrycznie „jak przełącznik”')
Testy.rowne(p0['przekroje_dobor'], 'reczny', 'przełącznik fabrycznie: podaję sam')
pa = Parametry.normalizuj('przekroje_dobor' => 'auto')[0]
Testy.rowne(%w[platwie_dobor krokwie_dobor zadaszenie_dobor legary_dobor].map { |k| Parametry.dobor(pa, k) }, %w[auto auto auto zalecany],
            'przełącznik „automatycznie” – wszystkie elementy (legary: zalecany)')
pw = Parametry.normalizuj('przekroje_dobor' => 'auto', 'platwie_dobor' => 'reczny', 'legary_dobor' => 'minimalny')[0]
Testy.rowne([Parametry.dobor(pw, 'platwie_dobor'), Parametry.dobor(pw, 'krokwie_dobor'), Parametry.dobor(pw, 'legary_dobor')], %w[reczny auto minimalny],
            'wyjątek elementu wygrywa z przełącznikiem')
seg = prostokat(0, 0, 8000, 6000)
pl_r = Projekt.oblicz('segmenty' => seg, 'parametry' => { 'platwa_przekroj' => '80x200' }, 'otwory' => [])
pl_a = Projekt.oblicz('segmenty' => seg, 'parametry' => { 'platwa_przekroj' => '80x200', 'przekroje_dobor' => 'auto' }, 'otwory' => [])
Testy.rowne(pl_r[:parametry]['platwa_przekroj'], '80x200', 'podaję sam – płatew z pola')
Testy.sprawdz(pl_a[:parametry]['platwa_przekroj'] != '80x200' && Parametry.katalog(pl_a[:parametry], 'platwie_katalog').include?(Parametry.przekroj(pl_a[:parametry], 'platwa_przekroj')),
              "automatycznie – płatew z magazynu (#{pl_a[:parametry]['platwa_przekroj']})")

Testy.grupa('Dobór w całej długości – krokwie i legary')
lista = [[45.0, 145.0], [45.0, 170.0], [60.0, 160.0]]
pd = Parametry.normalizuj('magazyn_drewna' => [{ 'przekroj' => '45x145', 'dlugosci' => '4.2', 'krokiew' => true },
                                                { 'przekroj' => '45x170', 'dlugosci' => '6', 'krokiew' => true },
                                                { 'przekroj' => '60x160', 'krokiew' => true }])[0]
Testy.rowne(DlugosciHandlowe.najpierw_w_calosci(lista, 5000.0, pd, 'krokwie_katalog'), [[45.0, 170.0], [60.0, 160.0], [45.0, 145.0]],
            'najpierw dostępne w całej długości (bez długości – bez ograniczenia), potem krótsze')
pk = Projekt.oblicz('segmenty' => prostokat(0, 0, 6000, 7000),
                    'parametry' => { 'dach_uklad' => 'krokwie', 'dach_wiezba' => 'generator', 'krokwie_dobor' => 'auto', 'dach_kat' => 35,
                                     'magazyn_drewna' => [{ 'przekroj' => '45x195', 'dlugosci' => '4.2', 'krokiew' => true },
                                                          { 'przekroj' => '45x220', 'dlugosci' => '6', 'krokiew' => true }] }, 'otwory' => [])
Testy.rowne(pk[:parametry]['krokiew_przekroj'], '45x220', 'krokiew 4,8 m: 45 × 195 jest tylko w 4,2 m – bierze 45 × 220 (6 m)')

Testy.grupa('Wycena materiału (W3)')
w0 = pl_r[:wycena]
Testy.sprawdz(w0 && !w0[:wiersze].empty? && w0[:suma].zero? && !w0[:kompletna], 'bez cen: pozycje bez ceny, suma 0')
ceny = p0['magazyn_drewna'].map { |r| r.merge('cena' => r['rodzaj'] == 'deska' ? 1500.0 : 2000.0) }
pc = Projekt.oblicz('segmenty' => seg, 'otwory' => [],
                    'parametry' => { 'cena_bala' => 2500, 'magazyn_drewna' => ceny, 'podbitka' => 'pod_platwiami', 'dach_uklad' => 'platwie_krokwie',
                                     'cennik_materialow' => [{ 'nazwa' => 'Taśma uszczelniająca', 'jednostka' => 'm', 'cena' => 3 },
                                                             { 'nazwa' => 'Kotwa podwaliny', 'jednostka' => 'szt.', 'cena' => 12.5 }] })
w = pc[:wycena]
bale = w[:wiersze].find { |x| x[:nazwa].start_with?('Bale') }
Testy.rowne(bale[:wartosc], (pc[:podsumowanie][:objetosc_m3] * 2500).round(2), 'bale: objętość × cena bala', 2.0)
tasma = pc[:materialy].find { |m| m[:nazwa].start_with?('Taśma') }
Testy.rowne(w[:wiersze].find { |x| x[:nazwa].start_with?('Taśma') }[:wartosc], tasma[:ilosc] * 3.0, 'taśma: metry × cena z cennika')
belki = w[:wiersze].select { |x| x[:nazwa].start_with?('Belki') }
Testy.sprawdz(belki.find { |x| x[:nazwa].include?('80 × 200') }[:cena] == 2000.0, 'belki: cena z magazynu według przekroju (płatew 80 × 200)')
Testy.sprawdz(belki.find { |x| x[:nazwa].include?('50 × 100') }[:cena].nil? && w[:bez_ceny].any? { |n| n.include?('50 × 100') },
              'przekrój spoza magazynu (legar 50 × 100) – bez ceny, na liście pozycji bez ceny')
Testy.sprawdz(w[:wiersze].none? { |x| x[:nazwa].include?('Fundament') }, 'fundamenty punktowe poza wyceną drewna')
deski = w[:wiersze].find { |x| x[:nazwa].include?('deski') }
Testy.sprawdz(deski && deski[:cena] == 1500.0 && deski[:jednostka] == 'm³', 'deski podbitki: m³ ze sztuk × cena deski z magazynu')
Testy.sprawdz(w[:wiersze].none? { |x| x[:nazwa].start_with?('Belki') && x[:nazwa].include?('14 × 115') }, 'deski Pb liczone raz (w deskach, nie w belkach)')
Testy.rowne(w[:suma], w[:wiersze].map { |x| x[:wartosc] || 0.0 }.inject(0.0) { |a, b| a + b }.round(2), 'suma = suma wartości')
csv = Zestawienie.csv(pc)
Testy.sprawdz(csv.include?('Wycena;Pozycja;Ilość;Jednostka;Cena [zł];Wartość [zł]') && csv =~ /Wycena;Razem/, 'blok wyceny w zestawieniu CSV')
Testy.sprawdz(!Zestawienie.csv(pl_r).include?('Wycena;'), 'bez żadnej ceny – bez bloku wyceny w CSV')

Testy.koniec
