# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/podglad.rb
# Zadanie: zapis domu testowego do pliku OBJ (siatki pozycji ułożone jak w modelu) – do obejrzenia bez SketchUpa (testy/podglad.py).
# Tematy: podgląd 3D, eksport OBJ, dom testowy, sprawdzenie wzrokowe
# Zależy od: testy/pomoc.rb, rdzen/przyklady.rb
# Używają: testy/podglad.py
#
# Uruchomienie: ruby -I testy/atrapa testy/podglad.rb plik.obj [nazwa_domu | przykladN – dom N z rdzen/przyklady.rb]

require File.expand_path('pomoc', File.dirname(__FILE__))
require File.join(KATALOG_WTYCZKI, 'rdzen', 'przyklady')
include ArteMadera::GeneratorWiencowy

DOMY = {
  'dom900' => [prostokat(0, 0, 4000, 3000) + [[[2000, 0], [2000, 3000]]], { 'max_dlugosc' => 4000, 'liczba_wiencow' => 8 },
               [{ 'sciana' => 'W-2', 'od' => 700, 'szerokosc' => 900, 'wysokosc' => 1000, 'parapet' => 300 }]],
  'domL' => [wielokat([[0, 0], [7000, 0], [7000, 4000], [4000, 4000], [4000, 6500], [0, 6500]]) + [[[0, 3000], [4000, 3000]]],
             { 'liczba_wiencow' => 10 },
             [{ 'sciana' => 'W-1', 'od' => 1200, 'szerokosc' => 1020, 'wysokosc' => 1010, 'parapet' => 600 },
              { 'sciana' => 'W-1', 'od' => 4300, 'szerokosc' => 930, 'wysokosc' => 1350, 'parapet' => 0 }]],
  'pelny900' => [prostokat(0, 0, 4000, 3000), {},
                 [{ 'sciana' => 'W-2', 'od' => 1000, 'szerokosc' => 900, 'wysokosc' => 2100, 'parapet' => 0 }], true],
  'krokwie' => [prostokat(0, 0, 6000, 4000) + [[[3000, 0], [3000, 4000]]],
                { 'dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator', 'krokwie_przy_szczycie' => 'wewnatrz' }, [], true],
  'antresola' => [prostokat(0, 0, 6000, 4200) + [[[2000, 0], [2000, 4200]], [[0, 1500], [2000, 1500]]],
                  { 'liczba_wiencow' => 20, 'dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator', 'podloga' => 'nie' }, [], true,
                  { 'W-5' => { 'nad' => 'antresola', 'wysokosc' => '2500' }, 'W-6' => { 'nad' => 'antresola', 'wysokosc' => '2500' },
                    'W-1' => { 'ostatek_od' => '200' } }],
  'profil' => [prostokat(0, 0, 4000, 3000), { 'profil_bala' => 'pelny', 'liczba_wiencow' => 6, 'szczyty' => 'nie', 'podloga' => 'nie' },
               [{ 'sciana' => 'W-1', 'od' => 1500, 'szerokosc' => 900, 'wysokosc' => 500, 'parapet' => 300 }], true],
  'jednospadowy' => [prostokat(0, 0, 6000, 4500) + [[[3000, 0], [3000, 4500]]],
                     { 'dach_rodzaj' => 'jednospadowy', 'dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator', 'dach_kat' => 15,
                       'szczyty_na_dzialowych' => 'tak', 'podloga' => 'nie' },
                     [{ 'sciana' => 'W-1', 'od' => 1200, 'szerokosc' => 1020, 'wysokosc' => 1010, 'parapet' => 900 }], true]
}.freeze

plik = ARGV[0] || 'dom.obj'
nazwa = ARGV[1] || 'dom900'
seg, par, otw, pelny, ust = DOMY[nazwa]
if nazwa =~ /\Aprzyklad(\d+)\z/
  # Przykładowy dom testu działania (rdzen/przyklady.rb) – pełny, z dachem i podłogą.
  wej = Przyklady.lista[Regexp.last_match(1).to_i]['wejscie']
  seg, par, otw, pelny, ust = wej['segmenty'], wej['parametry'], wej['otwory'], true, wej['sciany']
end
par = { 'szczyty' => 'nie', 'podloga' => 'nie' }.merge(par) unless pelny
pl = Projekt.oblicz('segmenty' => seg, 'parametry' => par, 'otwory' => otw, 'sciany' => ust || {})
raise pl[:bledy].join("\n") unless pl[:bledy].empty?
siatki = {}
wierzcholki = []
sciany = []
grupy = []
pl[:bale].each do |b|
  poz = b[:pozycja]
  siatki[poz[:nr]] ||= Siatka.uprosc(Projekt.siatka_pozycji(poz)[:sciany])
  pol = Bale.polozenie(b, pl[:parametry])
  o = pol[:poczatek]
  x = pol[:x]
  y = pol[:y]
  if b[:obrocony]
    o = [o[0] + x[0] * b[:dl] + y[0] * 44.0, o[1] + x[1] * b[:dl] + y[1] * 44.0, o[2]]
    x = [-x[0], -x[1], 0.0]
    y = [-y[0], -y[1], 0.0]
  end
  grupy << "g #{b[:sciana][:id]}_#{b[:nr]}_#{poz[:prefiks] == 'Sz' ? 'szczyt' : b[:sciana][:rodzaj]}"
  start = wierzcholki.length
  lista = []
  siatki[poz[:nr]].each do |f|
    pts = f[:petle][0]
    ind = pts.map do |pt|
      wierzcholki << [o[0] + x[0] * pt[0] + y[0] * pt[1], o[1] + x[1] * pt[0] + y[1] * pt[1], o[2] + pt[2]]
      wierzcholki.length
    end
    lista << ind
  end
  sciany << [grupy.last, lista, start]
end
pl[:elementy].each_with_index do |e, i|
  poz = e[:pozycja]
  siatki["e#{poz[:nr]}"] ||= Siatka.uprosc(Projekt.siatka_pozycji(poz)[:sciany])
  pol = Elementy.polozenie_instancji(e)
  o = pol[:poczatek]
  grupy << "g #{e[:prefiks]}#{i}_#{e[:nr]}_#{e[:tag]}"
  lista = siatki["e#{poz[:nr]}"].map do |f|
    f[:petle][0].map do |pt|
      wierzcholki << (0..2).map { |k| o[k] + pol[:x][k] * pt[0] + pol[:y][k] * pt[1] + pol[:z][k] * pt[2] }
      wierzcholki.length
    end
  end
  sciany << [grupy.last, lista, 0]
end
File.open(plik, 'w') do |f|
  f.puts "# ArteMadera Generator Wieńcowy – #{nazwa}: #{pl[:bale].length} bali, #{pl[:pozycje].length} pozycji"
  wierzcholki.each { |v| f.puts format('v %.3f %.3f %.3f', v[0], v[1], v[2]) }
  sciany.each do |g, lista, _s|
    f.puts g
    lista.each { |ind| f.puts "f #{ind.join(' ')}" }
  end
end
puts "#{plik}: #{pl[:bale].length} bali, #{pl[:pozycje].length} pozycji, #{wierzcholki.length} wierzchołków"
