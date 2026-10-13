# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_siatka.rb
# Zadanie: siatka brył wszystkich pozycji z kilku domów – zamknięta (każda krawędź raz w każdą stronę), objętość równa profilowi.
# Tematy: testy siatki, bryła zamknięta, objętość, otwory w ścianach siatki, skos
# Zależy od: testy/pomoc.rb
# Używają: testy/uruchom.sh

require File.expand_path('pomoc', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

def sprawdz_pozycje(pl, opis)
  bledne = 0
  zbedne = 0
  pl[:pozycje].each do |poz|
    prof = Bryla.profil(poz[:dl], poz[:t], poz[:h], poz[:cechy])
    s = Projekt.siatka_pozycji(poz)
    k = Siatka.sprawdz(s[:sciany])
    v = Bryla.objetosc(prof)
    ok = k[:zamknieta] && (k[:objetosc] - v).abs <= v * 1e-9 + 1e-3
    ok &&= s[:sciany].all? { |f| f[:petle].all? { |pt| pt.length >= 3 } }
    u = Siatka.uprosc(s[:sciany])
    ku = Siatka.sprawdz(u)
    ok &&= ku[:zamknieta] && (ku[:objetosc] - v).abs <= v * 1e-9 + 1e-3 && u.all? { |f| f[:petle].all? { |pt| pt.length >= 3 } }
    zbedne += u.inject(0) { |acc, f| acc + f[:petle].inject(0) { |a2, pts| a2 + pts.each_index.count { |i| Siatka.wspolliniowy?(pts[i - 1], pts[i], pts[(i + 1) % pts.length]) } } }
    unless ok
      bledne += 1
      puts "  #{poz[:nazwa]}: zamknięta=#{k[:zamknieta]} błędne krawędzie=#{k[:bledne_krawedzie]} V siatki=#{k[:objetosc].round(1)} V profilu=#{v.round(1)}"
    end
  end
  Testy.rowne(bledne, 0, "#{opis}: pozycje z błędną siatką (z #{pl[:pozycje].length}, także po uproszczeniu)")
  puts "  wierzchołki na prostej po uproszczeniu (punkty styku ścian): #{zbedne}"
end

Testy.grupa('Siatki – dom 4000 × 3000 ze stykami w zamkach')
sprawdz_pozycje(plan(prostokat(0, 0, 4000, 3000), 'max_dlugosc' => 4000), 'dom 900')

Testy.grupa('Siatki – działowe, kontrfory, otwory')
seg = prostokat(0, 0, 9000, 6000) + [[[4000, 0], [4000, 6000]], [[0, 3000], [9000, 3000]], [[6500, -150], [6500, 150]]]
otw = [{ 'sciana' => 'W-1', 'od' => 1200, 'szerokosc' => 1020, 'wysokosc' => 1010, 'parapet' => 950 },
       { 'sciana' => 'W-2', 'od' => 2000, 'szerokosc' => 930, 'wysokosc' => 2100, 'parapet' => 0 },
       { 'sciana' => 'W-5', 'od' => 600, 'szerokosc' => 800, 'wysokosc' => 2000, 'parapet' => 0 }]
pl = plan(seg, {}, otw)
Testy.rowne(pl[:bledy], [], 'brak błędów')
sprawdz_pozycje(pl, 'dom 9000 × 6000')

Testy.grupa('Siatki – jeden kontrfor, szczelina, ostatek 200')
sprawdz_pozycje(plan(prostokat(0, 0, 12_000, 5000), 'styk_uklad' => 'jeden_kontrfor', 'szczelina_styku' => 3, 'ostatek' => 200),
                'dom 12 m')

Testy.grupa('Siatka – bryła ze skosem i otworem w czole')
cechy = [{ typ: 'skos_gora', x0: 0.0, x1: 600.0, z0: 20.0, z1: 139.0 },
         { typ: 'gniazdo_gora', x0: 800.0, x1: 860.0, gleb: 36.0 },
         { typ: 'podciecie', strona: 0, x0: 300.0, x1: 342.0, gleb: 2.5 },
         { typ: 'podciecie', strona: 1, x0: 302.0, x1: 344.0, gleb: 2.5 },
         { typ: 'gniazdo_dol', x0: 302.0, x1: 342.0, gleb: 36.0 }]
prof = Bryla.profil(1200.0, 44.0, 139.0, cechy)
s = Siatka.z_profilu(prof)
k = Siatka.sprawdz(s[:sciany])
Testy.sprawdz(k[:zamknieta], 'bryła ze skosem zamknięta')
Testy.rowne(k[:objetosc].round(3), Bryla.objetosc(prof).round(3), 'objętość siatki = profilu')

Testy.grupa('Ściana z otworem (przekroje zagnieżdżone)')
prof = [{ xa: 0.0, xb: 100.0, y0: 0.0, y1: 44.0, zb_a: 0.0, zb_b: 0.0, zt_a: 139.0, zt_b: 139.0 },
        { xa: 100.0, xb: 200.0, y0: 10.0, y1: 30.0, zb_a: 40.0, zb_b: 40.0, zt_a: 90.0, zt_b: 90.0 },
        { xa: 200.0, xb: 300.0, y0: 0.0, y1: 44.0, zb_a: 0.0, zb_b: 0.0, zt_a: 139.0, zt_b: 139.0 }]
s = Siatka.z_profilu(prof)
z_otworem = s[:sciany].count { |f| f[:petle].length > 1 }
Testy.rowne(z_otworem, 2, 'dwie ściany czołowe z otworem')
k = Siatka.sprawdz(s[:sciany])
Testy.sprawdz(k[:zamknieta], 'bryła z przewężeniem zamknięta')
Testy.rowne(k[:objetosc].round(3), Bryla.objetosc(prof).round(3), 'objętość bryły z przewężeniem')

Testy.koniec
