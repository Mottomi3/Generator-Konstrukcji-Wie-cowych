# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_zestawienie.rb
# Zadanie: zestawienie CSV (rdzeń) i zapis pliku z okna (atrapa SketchUpa) – kolumny, przecinek dziesiętny, sumy, BOM, anulowanie.
# Tematy: testy zestawienia CSV, sumy grup, zapis pliku, BOM, okno zapisu anulowane
# Zależy od: testy/pomoc.rb, testy/atrapa/sketchup.rb, Plugins/.../rdzen/zestawienie.rb, sketchup/eksport.rb
# Używają: testy/uruchom.sh

require 'tmpdir'
require 'fileutils'
ENV['AM_GW_USTAWIENIA'] = File.join(Dir.tmpdir, "am_gw_zest_#{Process.pid}")
require File.expand_path('atrapa/sketchup', File.dirname(__FILE__))
require File.expand_path('pomoc', File.dirname(__FILE__))
require File.join(KATALOG_WTYCZKI, 'main.rb')
include ArteMadera::GeneratorWiencowy

Testy.grupa('CSV z planu domu 4000 × 3000 (bale, szczyty, belki)')
pl = plan_pelny(prostokat(0, 0, 4000, 3000))
csv = Zestawienie.csv(pl)
wiersze = csv.split("\r\n")
Testy.rowne(wiersze[0], 'Grupa;Pozycja;Rodzaj;Przekrój [mm];Długość [mm];Ilość [szt.];Objętość [m³]', 'nagłówek')
lista = pl[:podsumowanie][:lista]
Testy.rowne(wiersze[1..lista.length].length, lista.length, 'wiersz na każdą pozycję')
Testy.sprawdz(wiersze[1..lista.length].all? { |w| w.split(';').length == 7 }, 'siedem kolumn w każdym wierszu pozycji')
Testy.sprawdz(wiersze[1..lista.length].all? { |w| w.split(';')[6] =~ /\A\d+,\d{4}\z/ }, 'objętość z przecinkiem dziesiętnym')
razem = wiersze.find { |w| w.include?('Razem wszystko') }.split(';')
Testy.rowne(razem[5].to_i, lista.inject(0) { |s, l| s + l[:ilosc] }, 'suma sztuk')
Testy.rowne(razem[6].tr(',', '.').to_f, lista.inject(0.0) { |s, l| s + l[:objetosc_m3] }, 'suma objętości', 0.001)
Testy.sprawdz(wiersze.any? { |w| w.start_with?('P;Razem;Płatwie') } && wiersze.any? { |w| w.start_with?('Bs;Razem;Bale ścienne') },
              'sumy grup z nazwami')
Testy.rowne(Zestawienie.csv(nil), '', 'brak planu – pusty tekst')
Testy.rowne(Zestawienie.pole('a;b'), '"a;b"', 'pole ze średnikiem w cudzysłowie')

Testy.grupa('Zapis pliku z okna (atrapa)')
plik = File.join(Dir.tmpdir, "am_gw_zest_#{Process.pid}", 'lista')
FileUtils.mkdir_p(File.dirname(plik))
UI.plik_zapisu = plik
tekst, rodzaj = Eksport.zapisz_liste(pl)
Testy.rowne(rodzaj, 'ok', "zapisano (#{tekst})")
dane = File.binread(plik + '.csv')
Testy.sprawdz(dane.start_with?("\xEF\xBB\xBF".b), 'plik z BOM (Excel rozpozna polskie znaki)')
Testy.sprawdz(dane.force_encoding('UTF-8')[1..-1] == csv, 'treść pliku = zestawienie')
UI.plik_zapisu = nil
tekst, rodzaj = Eksport.zapisz_liste(pl)
Testy.rowne(rodzaj, 'blad', 'anulowany wybór pliku')
tekst, rodzaj = Eksport.zapisz_liste(nil)
Testy.sprawdz(rodzaj == 'blad' && tekst.include?('podgląd'), 'bez podglądu – komunikat')

FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
Testy.koniec
