# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_zlozone.rb
# Zadanie: testy domów o obrysach złożonych – działowa w linii ściany obrysu (dom L, T, U), linia przez wcięcie obrysu, ściany równoległe w tym samym miejscu, komunikat zamiast wyjątku, ziarna domów złożonych.
# Tematy: testy domów złożonych, działowa w linii uskoku – test, test ścian równoległych, test komunikatu po awarii, regresja rundy 14
# Zależy od: testy/zlozone_domy.rb, testy/losowe_domy.rb, testy/pomoc.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_zlozone.rb – ostatnia linia „FAILURES: n”.

require File.expand_path('zlozone_domy', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

# Plan domu z odcinków i parametrów.
def plan_z(odcinki, parametry = {})
  Projekt.oblicz('segmenty' => odcinki, 'parametry' => parametry, 'otwory' => [])
end

# Odcinki obrócone o n ćwierćobrotów i odbite (odbicie = true) – to samo w ośmiu ułożeniach.
def ulozone(odcinki, n, odbicie)
  odcinki.map do |s|
    s.map do |x, y|
      n.times { x, y = -y, x }
      odbicie ? [-x, y] : [x, y]
    end
  end
end

L = [[0, 0], [7900, 0], [7900, 4900], [5200, 4900], [5200, 8300], [0, 8300]].freeze
W_LINII = [[[0, 4900], [7900, 4900]]].freeze

Testy.grupa('Dom L – działowa w linii uskoku (błąd z 2026-11-14: wyjątek NoMethodError)')
pl = plan_z(wielokat(L) + W_LINII)
Testy.rowne(pl[:bledy], [], 'brak błędów')
Testy.sprawdz(pl[:wyjatek].nil?, 'bez wyjątku')
dz = pl[:sciany].select { |w| w[:rodzaj] == :dzialowa }
Testy.rowne(dz.length, 1, 'jedna działowa (część linii na boku obrysu pominięta)')
w3 = pl[:sciany].find { |w| w[:rodzaj] == :zewnetrzna && w[:bok] == [[7900, 4900], [5200, 4900]] }
w7 = dz[0]
Testy.rowne(w7[:a][1], w3[:a][1], 'działowa na osi ściany obrysu (linia narysowana po licu – 22 mm obok)', 0.01)
Testy.rowne(w3[:s_do], w3[:dl_osi], 'ściana obrysu kończy się w osi ściany poprzecznej – bez ostatka', 0.01)
Testy.rowne(w7[:s_do], w7[:dl_osi], 'działowa kończy się w tej samej osi', 0.01)
Testy.rowne([w3[:w_linii], w7[:w_linii]], [[false, true], [false, true]], 'oba końce oznaczone (w_linii)')
Testy.sprawdz(pl[:ostrzezenia].none? { |u| u.include?('poza obrysem') }, 'bez ostrzeżenia „linia poza obrysem” dla części na boku obrysu')
k = Kontrola.wszystko(pl)
Testy.rowne([k[:kolizje].length, k[:nakladanie].length, k[:mijanka].length], [0, 0, 0], 'bez kolizji, nakładania i naruszeń mijanki')
poprz = pl[:sciany].find { |w| w[:rodzaj] == :zewnetrzna && w[:bok] == [[5200, 4900], [5200, 8300]] }
Testy.sprawdz(poprz[:s_od] < -100.0, 'ściana poprzeczna przechodzi przez węzeł z ostatkiem – trzyma oba końce')
t = Parametry.grubosc(pl[:parametry])
konce3 = w3[:bale].map { |b| b[:s1] }.max
konce7 = w7[:bale].map { |b| b[:s1] }.max
Testy.rowne([konce3, konce7], [w3[:dl_osi], w7[:dl_osi]], 'bale obu ścian stykają się w osi zamka', 0.01)
Testy.sprawdz(w3[:bale].select { |b| (b[:s1] - w3[:dl_osi]).abs < 0.01 }.all? { |b| b[:cechy].any? { |c| c[:typ] =~ /gniazdo/ && c[:x1] > b[:dl] - 0.01 } },
              'każdy bal ściany obrysu ma na końcu połowę gniazda zamka')

Testy.grupa('Dom L z działową w linii uskoku – osiem ułożeń, pełne sprawdzenie')
4.times do |n|
  [false, true].each do |odb|
    seg = ulozone(wielokat(L) + W_LINII, n, odb)
    problemy, plx = LosoweDomy.sprawdz(segmenty: seg, parametry: {}, otwory: [], sciany: {})
    Testy.rowne(problemy, [], "obrót #{n * 90}°#{odb ? ', odbicie' : ''}")
    Testy.rowne(plx[:sciany].count { |w| w[:rodzaj] == :dzialowa }, 1, 'jedna działowa') if plx
  end
end

Testy.grupa('Obrys T – działowa między dwoma uskokami (w linii dwóch ścian obrysu)')
t_pts = ZlozoneDomy.obrys(ZlozoneDomy::WZORY['T'], [0, 2500, 5500, 8000], [0, 2600, 4400, 7000])
pl = plan_z(wielokat(t_pts) + [[[0, 4400], [8000, 4400]]])
Testy.rowne(pl[:bledy], [], 'brak błędów')
dz = pl[:sciany].select { |w| w[:rodzaj] == :dzialowa }
Testy.rowne(dz.length, 1, 'jedna działowa między uskokami')
Testy.rowne(dz[0][:w_linii], [true, true], 'oba końce w linii ścian obrysu')
Testy.rowne([dz[0][:s_od], dz[0][:s_do]], [0.0, dz[0][:dl_osi]], 'bez wypustów na obu końcach', 0.01)
k = Kontrola.wszystko(pl)
Testy.rowne([k[:kolizje].length, k[:nakladanie].length], [0, 0], 'bez kolizji i nakładania')

Testy.grupa('Obrys U – linia przez wcięcie daje dwie działowe')
u_pts = ZlozoneDomy.obrys(ZlozoneDomy::WZORY['U'], [0, 3000, 6000, 9000], [0, 3000, 5500, 8000])
pl = plan_z(wielokat(u_pts) + [[[0, 3000], [9000, 3000]]])
Testy.rowne(pl[:bledy], [], 'brak błędów')
Testy.rowne(pl[:sciany].count { |w| w[:rodzaj] == :dzialowa }, 2, 'dwie działowe – po każdej stronie wcięcia')
k = Kontrola.wszystko(pl)
Testy.rowne([k[:kolizje].length, k[:nakladanie].length], [0, 0], 'bez kolizji i nakładania')
# Linia przez środek wcięcia zamyka je (obrys to zewnętrzna granica narysowanych linii) – dom bez błędów i bez nakładania.
problemy, _plx = LosoweDomy.sprawdz(segmenty: wielokat(u_pts) + [[[0, 4500], [9000, 4500]]], parametry: {}, otwory: [], sciany: {})
Testy.rowne(problemy, [], 'linia przez środek wcięcia – dom bez problemów')

Testy.grupa('Ściany równoległe w tym samym miejscu – kontrola i ostrzeżenie')
pl = plan_z(prostokat(0, 0, 7000, 5000) + [[[3000, 0], [3000, 5000]], [[3075, 0], [3075, 5000]]])
k = Kontrola.wszystko(pl)
Testy.sprawdz(!k[:nakladanie].empty?, 'dwie działowe 75 mm od siebie – węgły w tym samym miejscu wykryte')
Testy.sprawdz(pl[:ostrzezenia].any? { |u| u.include?('zajmują to samo miejsce') }, 'ostrzeżenie dla użytkownika')
pl = plan_z(prostokat(0, 0, 7000, 5000) + [[[3000, 0], [3000, 5000]]])
Testy.rowne(Kontrola.wszystko(pl)[:nakladanie], [], 'zwykły dom – bez nakładania')

Testy.grupa('Komunikat zamiast wyjątku')
pl = Projekt.oblicz('segmenty' => [[[0, 0], nil]], 'parametry' => {})
Testy.rowne(pl[:bledy].length, 1, 'jeden błąd w planie')
Testy.sprawdz(pl[:bledy][0].start_with?('Nie udało się policzyć domu'), 'zdanie po polsku')
Testy.sprawdz(pl[:wyjatek].to_s.include?('NoMethodError') && pl[:wyjatek] =~ /\.rb:\d+/, "opis techniczny z plikiem i wierszem (#{pl[:wyjatek]})")
Testy.rowne([pl[:sciany], pl[:bale], pl[:podsumowanie]], [[], [], nil], 'plan bez ścian i bali')
Testy.sprawdz(Log.wpisy.any? { |w| w.to_s.include?('Projekt.oblicz') }, 'pełny ślad w dzienniku')

Testy.grupa('Domy złożone z ziaren (L, T, U, Z, krzyż, H z działowymi w liniach uskoków)')
[10_001, 10_003, 10_008, 10_010, 10_013, 10_014, 10_019, 10_041, 10_061, 10_072, 10_078, 10_106, 10_113].each do |z|
  d = ZlozoneDomy.dom(z)
  problemy, plx = LosoweDomy.sprawdz(d)
  Testy.rowne(problemy, [], "ziarno #{z}: #{d[:opis][0, 90]}")
  Testy.sprawdz(plx && !plx[:bale].empty?, "ziarno #{z}: są bale")
end

# Ziarno 10019 (runda 16): w węźle czterech ścian w jednej linii bal półzamka i bal ze zwykłym gniazdem stykają się
# czołami nad tym samym balem – gniazdo bala niższego zostawało płytkie (36) i bal półzamka w nie wchodził.
Testy.grupa('Pół zamka w węźle ścian w jednej linii (ziarno 10019)')
d = ZlozoneDomy.dom(10_019)
pl = Projekt.oblicz('segmenty' => d[:segmenty], 'parametry' => d[:parametry], 'otwory' => d[:otwory], 'sciany' => d[:sciany])
gorne = pl[:bale].select { |b| b[:lvl] == 26 && %w[W-4 W-12].include?(b[:sciana][:id]) }
Testy.rowne(gorne.length, 2, 'dwa bale wieńca nad węzłem – ściany zewnętrznej i działowej w jej linii')
w4 = gorne.find { |b| b[:sciana][:id] == 'W-4' }
w12 = gorne.find { |b| b[:sciana][:id] == 'W-12' }
Testy.sprawdz(PolZamka.w_osi?(w4, w4[:s1]) && PolZamka.w_osi?(w12, w12[:s1]), 'oba bale stykające się w węźle są balami półzamka')
Testy.sprawdz(gorne.all? { |b| b[:cechy].none? { |c| c[:typ] == 'gniazdo_dol' && (c[:os] - b[:s1]).abs < 0.01 } }, 'oba bez gniazda od spodu w węźle')
dolne = pl[:bale].select { |b| b[:lvl] == 25 && %w[W-5 W-10].include?(b[:sciana][:id]) && b[:s0].abs < 0.01 }
Testy.rowne(dolne.map { |b| b[:cechy].find { |c| c[:typ] == 'gniazdo_gora' && c[:os].abs < 0.01 }[:gleb] }, [72.0, 72.0],
            'bale niższe (obie ściany w linii) z gniazdem do połowy wysokości')
Testy.rowne(Kontrola.kolizje(pl), [], 'bez kolizji w zamkach')

Testy.koniec
