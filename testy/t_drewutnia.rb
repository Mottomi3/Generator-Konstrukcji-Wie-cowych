# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_drewutnia.rb
# Zadanie: drewutnia / zadaszenie przy ścianie szczytowej (runda 19, dodatek „typ + dodatki”) – elementy i położenie, strona naprzeciw tarasu, wysokość pod dachem domu z osiadaniem, omijanie węgłów i działowych, podwalin i fundamentów, statyka, podpory aplikacji do dachów bez drewutni, dom bez problemów w wielu ustawieniach.
# Tematy: test drewutni, test zadaszenia przy ścianie szczytowej, test dodatków domu
# Zależy od: testy/losowe_domy.rb (sprawdzenie całego domu)
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_drewutnia.rb

require File.expand_path('losowe_domy', File.dirname(__FILE__))
require File.join(KATALOG_WTYCZKI, 'rdzen', 'poziomy')
include ArteMadera::GeneratorWiencowy

D = prostokat(0, 0, 7000, 5000).freeze
DREW = { 'drewutnia' => 'slupy', 'dach_kat' => 30, 'liczba_wiencow' => 16 }.freeze

# Cały dom bez problemów (zamki, bryły, kolizje belek drewutni z balami, dachem, podwalinami i fundamentami).
def bez_problemow(seg, par, opis, sciany = {})
  problemy, pl = LosoweDomy.sprawdz(segmenty: seg, parametry: par, otwory: [], sciany: sciany)
  Testy.rowne(problemy, [], opis)
  pl
end

# Elementy drewutni planu.
def drew(pl, prefiks = nil)
  pl[:elementy].select { |e| e[:tag] == :drewutnia && (prefiks.nil? || e[:prefiks] == prefiks) }
end

# Najmniejsze i największe x elementów (narożniki otoczki).
def zakres_x(lista)
  xs = lista.flat_map do |e|
    pe = e[:polozenie]
    [0.0, e[:dl]].product([0.0, e[:b]], [0.0, e[:h]]).map { |x, y, z| pe[:poczatek][0] + pe[:x][0] * x + pe[:y][0] * y + pe[:z][0] * z }
  end
  [xs.min, xs.max]
end

Testy.grupa('Drewutnia przy ścianie szczytowej – elementy (runda 19)')
pl = bez_problemow(D, DREW, 'dom 7 × 5 m z drewutnią – bez problemów')
p = pl[:parametry]
Testy.rowne(drew(pl, 'P').map { |e| e[:rodzaj] }.sort, ['Oczep drewutni', 'Płatew drewutni przy ścianie'], 'płatew przy ścianie i oczep')
Testy.rowne(drew(pl, 'S').length, 6, 'dwa rzędy po trzy słupy (ściana 4,85 m, rozstaw do 2,5 m)')
Testy.rowne(drew(pl, 'F').length, Fundamenty.wlaczone?(p) ? 6 : 0, 'fundament pod każdym słupem (przy fundamentach domu)')
Testy.rowne(drew(pl, 'K').length, 7, 'krokwie co najwyżej co rozstaw krokwi dachu')
x0, x1 = zakres_x(drew(pl))
Testy.sprawdz(x1 < -29.0 && x0 > -1500.0 - 300.0 - 30.0, format('drewutnia z tyłu (x < 0): od %.0f do %.0f mm – głębokość 1500, okap 300', x0, x1))
Testy.sprawdz(drew(pl).reject { |e| e[:prefiks] == 'F' }.all? { |e| e[:polozenie][:poczatek][1] > 44.0 && e[:polozenie][:poczatek][1] < 5000 - 44.0 },
              'w poprzek – między ostatkami ścian okapowych (fundamenty pod ziemią mogą wystawać)')
pd = pl[:podpowiedzi].select { |h| h[:sekcja] == 'drewutnia' }
Testy.sprawdz(pd.length == 4 && pd.all? { |h| h[:poziom] == 'ok' }, 'cztery podpowiedzi: wymiary, krokwie, płatew i oczep, słupy')
Testy.sprawdz(pd[0][:tekst].include?('prześwit pod oczepem'), "podpowiedź z wymiarami: #{pd[0][:tekst]}")
Testy.sprawdz(Krok2.podpory(pl).none? { |q| q[:nazwa].to_s.include?('drewutni') } &&
              Krok2.podpory(pl).length == Krok2.podpory(plan_pelny(D, DREW.merge('drewutnia' => 'nie'))).length,
              'płatew i oczep drewutni nie są podporami połaci dla aplikacji do dachów')

Testy.grupa('Drewutnia – wysokość pod dachem domu z osiadaniem')
c = Drewutnia.geo(pl[:dach], pl[:sciany], pl[:elementy].reject { |e| e[:tag] == :drewutnia }, p)
z_dach = [Dach.linia_podparcia(Dach.geo(pl[:dach]), c[:v_lo], p), Dach.linia_podparcia(Dach.geo(pl[:dach]), c[:v_hi], p)].min
Testy.sprawdz(c[:h_k] <= z_dach - Osiadanie.luz(z_dach, p) - 50.0 + 0.01,
              format('wierzch krokwi %.0f mm ≤ dach %.0f − osiadanie %.0f − odstęp 50', c[:h_k], z_dach, Osiadanie.luz(z_dach, p)))
p2 = plan_pelny(D, DREW.merge('drewutnia_wysokosc' => 1900))
c2 = Drewutnia.geo(p2[:dach], p2[:sciany], p2[:elementy].reject { |e| e[:tag] == :drewutnia }, p2[:parametry])
Testy.rowne(c2[:h_k].round, 1900, 'wysokość z parametru, gdy się mieści')
p3 = plan_pelny(D, DREW.merge('drewutnia_wysokosc' => 9000))
Testy.sprawdz(p3[:podpowiedzi].any? { |h| h[:sekcja] == 'drewutnia' && h[:poziom] == 'uwaga' && h[:tekst].include?('obniżona') },
              'za wysoka – obniżona z uwagą')
kr = drew(pl, 'K').map { |e| e[:polozenie][:poczatek][2] }
Testy.sprawdz(kr.uniq.length == 1, 'krokwie na jednej wysokości')

Testy.grupa('Drewutnia – strona (z tyłu, naprzeciw tarasu)')
pt = bez_problemow(D, DREW.merge('taras' => 'podciag', 'taras_strona' => 'min', 'podloga' => 'nie'), 'taras po lewej – drewutnia po prawej, bez problemów')
Testy.sprawdz(zakres_x(drew(pt))[0] > 7000.0 + 29.0, 'drewutnia za ścianą x = 7000')
pmax = plan_pelny(D, DREW.merge('drewutnia_strona' => 'max'))
Testy.sprawdz(zakres_x(drew(pmax))[0] > 7000.0, 'strona „prawej albo górnej”')
ps = plan_pelny(D, DREW.merge('taras' => 'sciany', 'taras_strona' => 'max', 'drewutnia_strona' => 'max'))
Testy.sprawdz(drew(ps).empty? && ps[:podpowiedzi].any? { |h| h[:sekcja] == 'drewutnia' && h[:tekst].include?('tej samej stronie co taras') },
              'po stronie tarasu – pominięta z uwagą')
py = bez_problemow(prostokat(0, 0, 5000, 7000), DREW, 'kalenica wzdłuż Y – drewutnia przy ścianie dolnej, bez problemów')
Testy.sprawdz(drew(py).all? { |e| e[:polozenie][:poczatek][1] < 0.0 }, 'kalenica wzdłuż Y – drewutnia przy y = 0')
pl_l = plan_pelny(wielokat([[0, 0], [8000, 0], [8000, 4000], [4000, 4000], [4000, 7000], [0, 7000]]), DREW)
Testy.sprawdz(drew(pl_l).empty?, 'dom L – bez drewutni')

Testy.grupa('Drewutnia – z dala od węgłów, działowych, podwalin i fundamentów')
dz = D + [[[0, 2500], [3500, 2500]]]
pw = bez_problemow(dz, DREW, 'działowa dochodząca do ściany szczytowej (wychodzi przed lico) – bez problemów')
cw = Drewutnia.geo(pw[:dach], pw[:sciany], pw[:elementy].reject { |e| e[:tag] == :drewutnia }, pw[:parametry])
wyp = pw[:parametry]['wegiel_wypust_zewn'].to_f
Testy.sprawdz(cw[:s_k] >= wyp + 30.0 - 0.01, format('krokwie od %.0f mm – za wypustem działowej %.0f + odstęp', cw[:s_k], wyp))
pf = bez_problemow(D, DREW.merge('podloga' => 'tak', 'fundamenty' => 'tak', 'fundament_przekroj' => '600x600'),
                   'duże fundamenty – słupy drewutni obok, bez kolizji')
fd = drew(pf, 'F')
Testy.sprawdz(!fd.empty? && zakres_x(fd)[1] <= -29.0, 'fundamenty drewutni przed licem ściany z odstępem')

Testy.grupa('Drewutnia – statyka i inne ustawienia')
pk = plan_pelny(D, DREW.merge('drewutnia_belka_przekroj' => '40x80', 'drewutnia_glebokosc' => 3000, 'drewutnia_slupy_rozstaw' => 4000))
u = pk[:podpowiedzi].find { |h| h[:sekcja] == 'drewutnia' && h[:tekst].include?('płatew i oczep') }
Testy.sprawdz(u && u[:poziom] == 'uwaga' && u[:tekst].include?('z magazynu'), "za słaba belka – uwaga z przekrojem z magazynu: #{u && u[:tekst]}")
bez_problemow(D, DREW.merge('dach_rodzaj' => 'jednospadowy'), 'dach jednospadowy domu – bez problemów')
bez_problemow(D, DREW.merge('zadaszenie' => 'slupy', 'zadaszenie_strona' => 'obie'), 'z bocznym zadaszeniem po obu stronach – bez kolizji')
bez_problemow(D, DREW.merge('dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator', 'podbitka' => 'tak'),
              'krokwie dachu z generatora i podbitka – bez kolizji')
bez_problemow(D, DREW.merge('drewutnia_szerokosc' => 2500, 'drewutnia_kat' => 20, 'drewutnia_okap' => 0), 'węższa, 20°, bez okapu')
pp = plan_pelny(D, DREW.merge('drewutnia_glebokosc' => 600))
Testy.sprawdz(drew(pp).empty? && pp[:podpowiedzi].any? { |h| h[:sekcja] == 'drewutnia' && h[:tekst].include?('za płytka') },
              'za płytka – pominięta z uwagą')
Testy.rowne(Poziomy.krok('drewutnia'), 'taras', 'pola drewutni w kroku „Dodatki”')

Testy.koniec
