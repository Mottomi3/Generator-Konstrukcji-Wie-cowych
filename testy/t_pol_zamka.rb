# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_pol_zamka.rb
# Zadanie: testy pół zamka w ostatnim połączeniu pod dachem (runda 15) – bal szczytu przechodzi przez narożnik bez gniazda od spodu, bal pod nim ma gniazdo do połowy wysokości; wyłączone – bal ucięty przy ścianie poprzecznej; inna głębokość gniazda; brak kolizji.
# Tematy: testy pół zamka, test ostatniego połączenia pod dachem, test gniazda do połowy bala
# Zależy od: testy/pomoc.rb, testy/losowe_domy.rb, Plugins/.../rdzen/pol_zamka.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_pol_zamka.rb – ostatnia linia „FAILURES: n”.

require File.expand_path('losowe_domy', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

# Plan domu z ziarna z dodatkowymi parametrami.
def plan_ziarna(z, dodatki)
  d = LosoweDomy.dom(z)
  d = d.merge(parametry: d[:parametry].merge(dodatki))
  problemy, pl = LosoweDomy.sprawdz(d)
  [problemy, pl, d]
end

# Gniazda bala w osi c: { 'gniazdo_gora' => głębokość, 'gniazdo_dol' => głębokość }.
def gniazda(b, c)
  Hash[b[:cechy].select { |x| x[:typ].start_with?('gniazdo') && x[:os] && (x[:os] - c).abs < 0.01 }.map { |x| [x[:typ], x[:gleb]] }]
end

Testy.grupa('Głębokości gniazd półzamka')
p0 = Parametry.normalizuj('polzamek' => 'tak')[0]
Testy.rowne([PolZamka.gniazdo_nizszego(p0), PolZamka.gniazdo_wyzszego(p0)], [72.0, 0.0], 'fabrycznie: 72 w balu niższym (2 × 36), bal wyższy bez gniazda')
p1 = p0.merge('polzamek_gleb' => 50.0)
Testy.rowne([PolZamka.gniazdo_nizszego(p1), PolZamka.gniazdo_wyzszego(p1)], [50.0, 22.0], 'gniazdo 50 w niższym – reszta 22 od spodu wyższego')
Testy.rowne([PolZamka.gniazdo_nizszego(p0.merge('polzamek_gleb' => 10.0)), PolZamka.gniazdo_nizszego(p0.merge('polzamek_gleb' => 120.0))], [36.0, 72.0],
            'głębokość ograniczona: od zwykłego gniazda do połowy bala')
Testy.rowne([PolZamka.miesci_sie?(45.0, p0), PolZamka.miesci_sie?(19.0, p0), PolZamka.miesci_sie?(45.0, p0.merge('polzamek' => 'nie')), PolZamka.miesci_sie?(nil, p0)],
            [true, false, false, false], 'mieści się od 20 mm drewna pod skosem; wyłączone albo bal poza gniazdem – nie')
Testy.rowne(Parametry.normalizuj({})[0]['polzamek'], PolZamka.wlaczony?(Parametry.normalizuj({})[0]) ? 'tak' : 'nie', 'przełącznik zgodny z parametrem')

# Ziarna, w których bal szczytu przy narożniku ma pod skosem 24–56 mm (zwykłe gniazdo zostawiłoby mniej niż 20 mm).
[6002, 6005, 6014, 6020].each do |z|
  Testy.grupa("Ziarno #{z} – ostatnie połączenie pod dachem w narożniku")
  pr0, pl0, d = plan_ziarna(z, 'polzamek' => 'nie')
  pr1, pl1, = plan_ziarna(z, 'polzamek' => 'tak')
  Testy.rowne([pr0, pr1], [[], []], "pełne sprawdzenie bez i z pół zamkiem: #{d[:opis][0, 60]}…")
  Testy.sprawdz(pl0[:bale].none? { |b| b[:polzamek] }, 'wyłączone – bez półzamków')
  gorne = pl1[:bale].select { |b| b[:polzamek] }
  Testy.sprawdz(gorne.length >= 2, "bale z pół zamkiem: #{gorne.length}")
  t = Parametry.grubosc(pl1[:parametry])
  dobre = gorne.all? do |b|
    w = b[:sciana]
    b[:polzamek].all? do |c|
      k = w[:skrzyzowania].find { |x| (x[:s] - c).abs < 0.01 }
      k2 = k[:inna][:skrzyzowania].find { |x| x[:inna].equal?(w) }
      nizszy = Zamek.bale_w_zamku(k[:inna], k2[:s], t).find { |x| x[:lvl] == b[:lvl] - 1 }
      przez = b[:s0] < c - t / 2.0 + 0.01 && b[:s1] > c + t / 2.0 - 0.01
      przez && gniazda(b, c)['gniazdo_dol'].nil? && nizszy && gniazda(nizszy, k2[:s])['gniazdo_gora'] == 72.0
    end
  end
  Testy.sprawdz(dobre, 'bal wyższy przechodzi przez zamek bez gniazda od spodu, bal niższy ma gniazdo 72 od wierzchu')
  wolne0 = pl0[:bale].count { |b| b[:sciana][:szczyt] && b[:konce].include?(:wolny) }
  wolne1 = pl1[:bale].count { |b| b[:sciana][:szczyt] && b[:konce].include?(:wolny) }
  Testy.sprawdz(wolne1 < wolne0 || pl1[:bale].length > pl0[:bale].length,
                "mniej bali uciętych przy ścianie poprzecznej (#{wolne0} → #{wolne1}) albo bal, który wcześniej znikał (#{pl0[:bale].length} → #{pl1[:bale].length} bali)")
  Testy.sprawdz(pl1[:pary_zamkow] > pl0[:pary_zamkow], "więcej par bali w zamkach (#{pl0[:pary_zamkow]} → #{pl1[:pary_zamkow]})")
end

Testy.grupa('Inna głębokość gniazda: 50 w balu niższym, 22 od spodu wyższego')
pr, pl, = plan_ziarna(6005, 'polzamek' => 'tak', 'polzamek_gleb' => '50')
Testy.rowne(pr, [], 'pełne sprawdzenie')
b = pl[:bale].find { |x| x[:polzamek] }
Testy.sprawdz(b && gniazda(b, b[:polzamek].first)['gniazdo_dol'] == 22.0, 'bal wyższy: gniazdo 22 od spodu')

Testy.koniec
