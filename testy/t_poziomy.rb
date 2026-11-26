# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_poziomy.rb
# Zadanie: testy trzech poziomów ustawień i kroków okna (runda 16) – poziom przy każdym polu, podział jak w docs/podzial_pol_r16.md, kroki w kolejności budowy, złożenie parametrów ze standardu i typu, pola zmienione tylko w tym domu, lista uwag z miejscem w oknie, powierzchnie i limity, dom z wymiarów.
# Tematy: testy poziomów ustawień, test kroków okna, test listy uwag, test powierzchni i limitów, test domu z wymiarów, test rodzaju obrysu
# Zależy od: testy/pomoc.rb, Plugins/.../rdzen/poziomy.rb, rdzen/uwagi_pola.rb, rdzen/powierzchnie.rb, rdzen/dom_z_wymiarow.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_poziomy.rb – ostatnia linia „FAILURES: n”.

require File.expand_path('pomoc', File.dirname(__FILE__))
%w[poziomy uwagi_pola dom_z_wymiarow zestawienie].each { |m| require File.join(KATALOG_WTYCZKI, 'rdzen', m) }
include ArteMadera::GeneratorWiencowy

L = ParametryLista

Testy.grupa('Poziom przy każdym polu (docs/podzial_pol_r16.md)')
Testy.sprawdz(L::LISTA.all? { |w| %i[dom typ standard].include?(w[:poziom]) }, 'każde pole ma cechę poziom: dom, typ albo standard')
ile = Hash[%w[dom typ standard].map { |k| [k, Poziomy.klucze(k).length] }]
Testy.rowne([ile['dom'], ile['typ']], [18, 48], 'Ten dom: 16 pól z podziału + długość i szerokość domu z wymiarów; Typ domu: 48')
Testy.rowne(ile.values.inject(0) { |s, x| s + x }, L::LISTA.length, 'każde pole na dokładnie jednym poziomie')
Testy.rowne(%w[liczba_wiencow dach_kat taras_glebokosc preset dach_uklad podbitka max_dlugosc mijanka polzamek nie_ma_takiego].map { |k| Poziomy.poziom(k) },
            %w[dom dom dom typ typ typ standard standard standard standard], 'przykłady: wieńce i kąt – dom; bal, układ dachu, deski – typ; łączenia i zamek – standard')
Testy.sprawdz(L::LISTA.select { |w| w[:z_wymiarow] }.map { |w| w[:klucz] } == %w[dom_dlugosc dom_szerokosc], 'pola domu z wymiarów oznaczone')

Testy.grupa('Kroki okna w kolejności budowy')
Testy.rowne(Poziomy::KROKI.map { |k| k[1] }, ['Ściany', 'Okna i drzwi', 'Dach', 'Taras i zadaszenie', 'Podłoga', 'Zestawienie'], 'sześć kroków')
sekcje = L::SEKCJE.map { |s| s[0] }
Testy.rowne(Poziomy::KROKI.flat_map { |k| k[2] }.sort, sekcje.sort, 'każda sekcja parametrów w dokładnie jednym kroku')
Testy.rowne(%w[liczba_wiencow okno_szerokosc dach_kat taras zadaszenie legar_przekroj material_zapas limit_zabudowy].map { |k| Poziomy.krok(k) },
            %w[sciany otwory dach taras taras podloga zestawienie zestawienie], 'pola w swoich krokach')

Testy.grupa('Parametry nowego domu: fabryczne ← standard ← typ; zmiany tylko w tym domu')
standard = { 'mijanka' => '500', 'liczba_wiencow' => '9', 'dach_uklad' => 'krokwie', 'zamek' => { 'gniazdo_gleb' => '34' } }
typ = { 'liczba_wiencow' => '20', 'taras' => 'podciag', 'mijanka' => '350' }
zl = Poziomy.zloz(standard, typ)
Testy.rowne(zl, { 'mijanka' => '500', 'liczba_wiencow' => '20', 'taras' => 'podciag', 'zamek' => { 'gniazdo_gleb' => '34' } },
            'standard daje tylko pola standardu i zamek, typ – tylko pola typu i domu')
baza = Parametry.normalizuj(zl)[0]
Testy.rowne([baza['mijanka'], baza['liczba_wiencow'], baza['taras'], baza['zamek']['gniazdo_gleb'], baza['dach_uklad']], [500.0, 20, 'podciag', 34.0, 'platwie'], 'reszta – fabryczna')
dom = zl.merge('liczba_wiencow' => '20.0', 'dach_kat' => '25', 'taras' => 'sciany', 'mijanka' => '600')
Testy.rowne(Poziomy.zmienione_w_domu(dom, zl), { 'dom' => ['dach_kat'], 'typ' => ['taras'], 'standard' => ['mijanka'] },
            'zmienione tylko w tym domu – według poziomów („20.0” to dalej 20 wieńców)')
Testy.rowne(Poziomy.rozne(zl.merge('zamek' => { 'gniazdo_gleb' => '36' }), zl), ['zamek'], 'inne wymiary zamka')
Testy.rowne(Poziomy.wybierz({ 'mijanka' => 1, 'dach_kat' => 2, 'taras' => 3, 'obce' => 4 }, :dom, :typ), { 'dach_kat' => 2, 'taras' => 3 }, 'wybór pól poziomów')

Testy.grupa('Lista uwag z miejscem w oknie')
[['Ściana W-1: styk bez zamka w wieńcach 16 (węgieł kończy się niżej, pod połacią)', 'max_dlugosc', 'laczenia', 'sciany'],
 ['Otwór O1 (W-1) wychodzi poza ścianę – pominięty.', nil, 'otwory', 'otwory'],
 ['Taras: tylko przy obrysie prostokątnym – pominięty.', 'taras', 'taras', 'taras'],
 ['Płatwie 80 × 200: przęsło 7.0 m – za słaby', 'platwa_przekroj', 'szczyty', 'dach'],
 ['Powierzchnia zabudowy 48 m² – ponad Twój limit 35 m² (o 13 m²).', 'limit_zabudowy', 'powierzchnie', 'zestawienie'],
 ['Legar 45x145 nie przenosi rozpiętości', 'legar_przekroj', 'podloga', 'podloga'],
 ['Coś zupełnie innego', nil, nil, 'sciany']].each do |tekst, klucz, sekcja, krok|
  u = UwagiPola.uwaga(tekst, 'ostrzezenie')
  Testy.rowne([u['klucz'], u['sekcja'], u['krok']], [klucz, sekcja, krok], "„#{tekst[0, 40]}…” → #{klucz || sekcja || 'bez miejsca'}")
end
Testy.sprawdz(UwagiPola::WZORCE.all? { |_w, k, s| (k.nil? || L.wpis(k)) && (s.nil? || sekcje.include?(s)) }, 'wzorce wskazują istniejące pola i sekcje')
Testy.rowne(UwagiPola.uwaga('x', 'ok', 'podloga').values_at('sekcja', 'krok', 'krok_tytul'), %w[podloga podloga Podłoga], 'podpowiedź bez wzorca – jej własna sekcja')

Testy.grupa('Powierzchnie, wysokość i limity (W1)')
seg = prostokat(0, 0, 8000, 6000) + [[[3000, 0], [3000, 6000]], [[3000, 2500], [8000, 2500]]]
pl = plan_pelny(seg, 'taras' => 'podciag', 'taras_glebokosc' => '2000')
pw = pl[:powierzchnie]
Testy.rowne([pw[:zabudowa], pw[:rodzaj_obrysu]], [60.0, 'prostokat'], 'zabudowa po licach zewnętrznych z tarasem: 10 × 6 m')
Testy.rowne(pw[:pomieszczenia].map { |o| [o[:m2], o[:a], o[:b], o[:prostokat]] },
            [[17.35, 5912, 2934, true], [16.94, 4934, 3434, true], [12.01, 4934, 2434, true]], 'trzy pomieszczenia po licach wewnętrznych (bez ostatków i węgłów)')
Testy.rowne([pw[:taras], pw[:uzytkowa]], [11.56, 46.3], 'taras osobno, pomieszczenia razem')
dach = Materialy.powierzchnia_dachu(pl)
Testy.rowne(pw[:dach], (dach[:dach] + dach[:zadaszenie]).round(2), 'powierzchnia dachu jak w zestawieniu materiałów')
geo = pl[:sciany].map { |w| w[:szczyt] }.compact.first
p = pl[:parametry]
kal = Dach.linia_podparcia(geo, (geo[:v_a] + geo[:v_b]) / 2.0, p) + p['podbitka_grubosc'] / Math.cos(Dach.kat(p))
Testy.rowne([pw[:kalenica], pw[:wysokosc]], [kal.round, (kal + 300.0).round], 'kalenica: linia podparcia w kalenicy + nadbitka; nad terenem + 300 mm', 1)
Testy.sprawdz(pl[:ostrzezenia].none? { |u| u.include?('limit') } && pl[:podpowiedzi].none? { |h| h[:sekcja] == 'powierzchnie' }, 'bez limitów – bez uwag')
pl2 = plan_pelny(seg, 'limit_zabudowy' => '35', 'limit_wysokosci' => '5000')
Testy.sprawdz(pl2[:ostrzezenia].any? { |u| u =~ /Powierzchnia zabudowy 48 m² – ponad Twój limit 35 m² \(o 13 m²\)/ }, 'limit zabudowy przekroczony – ostrzeżenie')
Testy.sprawdz(pl2[:podpowiedzi].any? { |h| h[:poziom] == 'ok' && h[:tekst] =~ /Wysokość nad terenem .* m – w limicie 5 m/ }, 'limit wysokości dotrzymany – pozycja „sprawdzone”')
Testy.sprawdz(Zestawienie.csv(pl).include?("Powierzchnie;Powierzchnia zabudowy;60;m²;") && Zestawienie.csv(pl).include?('Powierzchnie;Pomieszczenia razem;46,3;m²;'), 'blok powierzchni w pliku zestawienia')
segl = [[[0, 0], [9000, 0]], [[9000, 0], [9000, 4000]], [[9000, 4000], [5000, 4000]], [[5000, 4000], [5000, 8000]], [[5000, 8000], [0, 8000]], [[0, 8000], [0, 0]]]
pll = plan_pelny(segl)
Testy.rowne([pll[:powierzchnie][:rodzaj_obrysu], pll[:powierzchnie][:zabudowa], pll[:powierzchnie][:pomieszczenia].length, pll[:powierzchnie][:pomieszczenia][0][:prostokat]],
            ['l', 56.0, 1, false], 'dom L: jedno pomieszczenie w kształcie L, zabudowa 56 m²')
Testy.rowne(Powierzchnie.rodzaj_obrysu([[0, 0], [5, 0], [10, 0], [10, 5], [0, 5]]), 'prostokat', 'punkt na prostej nie jest narożem')
Testy.rowne(plan_pelny(seg, 'szczyty' => 'nie')[:powierzchnie].values_at(:kalenica, :dach), [nil, nil], 'dom bez dachu – bez kalenicy i połaci')

Testy.grupa('Dom prostokątny z wymiarów (S1)')
Testy.rowne(DomZWymiarow.segmenty({}), prostokat(0, 0, 6000, 4000).map { |a, b| [a.map(&:to_f), b.map(&:to_f)] }, 'fabrycznie 6000 × 4000 – jak cztery narysowane linie')
Testy.rowne(DomZWymiarow.wymiary('dom_dlugosc' => '7,5', 'dom_szerokosc' => 'abc'), [1500.0, 4000.0], 'wymiar poniżej zakresu – granica, niepoprawny – fabryczny')
plw = Projekt.oblicz('segmenty' => DomZWymiarow.segmenty('dom_dlugosc' => '7200', 'dom_szerokosc' => '4800'), 'parametry' => {}, 'otwory' => [], 'sciany' => {})
Testy.rowne([plw[:bledy], plw[:powierzchnie][:zabudowa], plw[:sciany].count { |w| w[:rodzaj] == :zewnetrzna }], [[], 34.56, 4], 'dom 7200 × 4800: cztery ściany, 34,56 m²')

Testy.koniec
