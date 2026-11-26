# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_pol_zamka.rb
# Zadanie: testy pół zamka w ostatnim połączeniu pod dachem (rundy 15–16: narożnik, góra węgła, ściana nad węgłem i nad działową, węgieł ze stykami do połaci) – bal szczytu przechodzi przez narożnik bez gniazda od spodu, bal pod nim ma gniazdo do połowy wysokości; wyłączone – bal ucięty przy ścianie poprzecznej; inna głębokość gniazda; brak kolizji.
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

# Liczba gniazd od spodu, nad którymi pod skosem albo ścięciem dachu zostaje mniej niż zamek_min_drewno.
def cienkie(pl)
  min = pl[:parametry]['zamek_min_drewno'].to_f
  pl[:bale].inject(0) do |n, b|
    n + b[:cechy].count do |c|
      c[:typ] == 'gniazdo_dol' && c[:os] && [PolZamka.wierzch(b, c[:x0]), PolZamka.wierzch(b, c[:x1])].min - c[:gleb] < min - 0.01
    end
  end
end

# Miejsca półzamków w planie: pz_naroznik, pz_t, pz_x, pz_gora_wegla (bal węgła), pz_sciana_nad_weglem.
def miejsca(pl)
  pl[:bale].flat_map do |b|
    w = b[:sciana]
    (b[:polzamek] || []).map do |c|
      k = w[:skrzyzowania].find { |x| (x[:s] - c).abs < 0.5 }
      if w[:rodzaj] == :kontrfor then 'pz_gora_wegla'
      elsif k && k[:inna][:rodzaj] == :kontrfor then 'pz_sciana_nad_weglem'
      else "pz_#{k ? k[:typ] : 'inne'}"
      end
    end
  end.uniq.sort
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
  Testy.sprawdz(dobre, 'bal wyższy przechodzi przez zamek bez gniazda od spodu, bal pod nim ma gniazdo 72')
  Testy.sprawdz(cienkie(pl1).zero?, "z pół zamkiem żadnego gniazda od spodu z mniej niż 20 mm drewna pod dachem (bez: #{cienkie(pl0)})")
end

Testy.grupa('Fabrycznie włączone (akceptacja użytkownika 2026-11-25); bal górny z podfrezowanymi bokami')
Testy.rowne(Parametry.normalizuj({})[0]['polzamek'], 'tak', 'polzamek = tak')
_pr, plf, = plan_ziarna(6005, {})
bf = plf[:bale].find { |x| x[:polzamek] }
cf = bf[:polzamek].first
boki = bf[:cechy].select { |x| x[:typ] == 'podciecie' && (x[:os] - cf).abs < 0.01 }
Testy.rowne([boki.length, boki.map { |x| x[:strona] }.sort, boki.map { |x| x[:gleb] }.uniq], [2, [0, 1], [2.5]],
            'bal bez gniazda od spodu ma podcięcia boczne na obu licach (2,5 mm) – wchodzi w węższe gniazdo bala pod nim')
Testy.sprawdz(boki.all? { |x| (x[:x1] - x[:x0] - (44.0 + 40.0) / 2.0).abs < 0.01 }, 'podcięcia jak w zwykłym zamku: od krawędzi gniazda do lica ściany poprzecznej')

# Ostatnie połączenia poza narożnikiem ze skosem: 8 – górny bal ściany okapowej ścięty płaszczyzną dachu, 17 – działowa
# pod połacią nad ścianą szczytową (T), 16 – ostatni bal węgła i bal ściany nad węgłem.
{ 8 => 'pz_naroznik', 17 => 'pz_t', 16 => 'pz_gora_wegla' }.each do |z, miejsce|
  Testy.grupa("Ziarno #{z} – ostatnie połączenie pod dachem poza narożnikiem szczytu (runda 16)")
  pr0, pl0, = plan_ziarna(z, 'polzamek' => 'nie')
  pr1, pl1, = plan_ziarna(z, 'polzamek' => 'tak')
  Testy.rowne([pr0, pr1], [[], []], 'pełne sprawdzenie bez i z pół zamkiem')
  Testy.sprawdz(miejsca(pl1).include?(miejsce), "pół zamka w miejscu #{miejsce}: #{miejsca(pl1).inspect}")
  Testy.sprawdz(cienkie(pl0) > 0 && cienkie(pl1).zero?, "gniazda od spodu z mniej niż 20 mm drewna pod dachem: #{cienkie(pl0)} → #{cienkie(pl1)}")
  Testy.sprawdz(pl1[:bale].count { |b| b[:sciana][:rodzaj] == :kontrfor } >= pl0[:bale].count { |b| b[:sciana][:rodzaj] == :kontrfor },
                'węgły nie krótsze niż bez pół zamka')
  t = Parametry.grubosc(pl1[:parametry])
  dobre = pl1[:bale].select { |b| b[:polzamek] }.all? do |b|
    w = b[:sciana]
    b[:polzamek].all? do |c|
      k = w[:skrzyzowania].find { |x| (x[:s] - c).abs < 0.01 }
      k2 = k[:inna][:skrzyzowania].find { |x| x[:inna].equal?(w) }
      nizszy = Zamek.bale_w_zamku(k[:inna], k2[:s], t).find { |x| x[:lvl] == b[:lvl] - 1 }
      gniazda(b, c)['gniazdo_dol'].nil? && nizszy && gniazda(nizszy, k2[:s])['gniazdo_gora'] == 72.0 &&
        b[:cechy].count { |x| x[:typ] == 'podciecie' && (x[:os] - c).abs < 0.01 } == 2
    end
  end
  Testy.sprawdz(dobre, 'każdy bal półzamka: bez gniazda od spodu, z podcięciami bocznymi, bal pod nim z gniazdem 72')
end

Testy.grupa('Styk w najwyższym wieńcu zostaje w zamku: węgieł ze stykami dochodzi do połaci (decyzja 2026-11-26)')
pr, pl, d = plan_ziarna(6502, {})
Testy.rowne(Podbitka.rodzaj(pl[:parametry]), 'pod_platwiami', "dom z podbitką pod płatwiami: #{d[:opis][0, 50]}…")
Testy.rowne(pr, [], 'pełne sprawdzenie (deski podbitki bez kolizji z węgłem)')
Testy.rowne(Kontrola.styki_bez_zamka(pl), [], 'żadnego styku bez zamka – także w najwyższym wieńcu ściany wysokiej')
ze_stykami, bez_stykow = pl[:sciany].select { |w| w[:rodzaj] == :kontrfor }.partition { |w| Podbitka.wegiel_do_polaci?(w) }
Testy.sprawdz(!ze_stykami.empty? && ze_stykami.all? { |w| Podbitka.obnizenie_wegla(w, pl[:parametry]).zero? }, "węgły ze stykami bez obniżenia pod podbitkę (#{ze_stykami.length})")
Testy.sprawdz(bez_stykow.all? { |w| Podbitka.obnizenie_wegla(w, pl[:parametry]) == Podbitka.obnizenie(pl[:parametry]) }, 'węgły bez styków dalej kończą się pod podbitką')
pl55 = plan_ziarna(6055, {})
Testy.rowne([pl55[0], Kontrola.styki_bez_zamka(pl55[1])], [[], []], 'ziarno 6055 – węgły ścian okapowych: pełne sprawdzenie, styki w zamkach')
Testy.sprawdz(pl[:ostrzezenia].none? { |u| u.include?('styk bez zamka') }, 'bez ostrzeżenia o styku bez zamka')

Testy.grupa('Inna głębokość gniazda: 50 w balu niższym, 22 od spodu wyższego')
pr, pl, = plan_ziarna(6005, 'polzamek' => 'tak', 'polzamek_gleb' => '50')
Testy.rowne(pr, [], 'pełne sprawdzenie')
b = pl[:bale].find { |x| x[:polzamek] }
Testy.sprawdz(b && gniazda(b, b[:polzamek].first)['gniazdo_dol'] == 22.0, 'bal wyższy: gniazdo 22 od spodu')

Testy.koniec
