# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/sprawdz_dach_aplikacja.rb
# Zadanie: dom z bali z prawdziwą aplikacją do dachów (na jej atrapie SketchUpa) – połacie z RoofBuilder na płaszczyźnie spodu krokwi, KROK 2 w górę od połaci: krokwie leżą na płatwiach i nad szczytami, kontrola nośności w raporcie.
# Tematy: aplikacja do dachów – sprawdzenie z prawdziwą wtyczką, połacie z RoofBuilder, KROK 2 w górę, krokwie z aplikacji nad płatwiami, kontrola krokwi z aplikacji, dach jednospadowy z aplikacją
# Zależy od: aplikacja do dachów (katalog obok repozytorium albo AM_GW_APLIKACJA_DACHOW, jej tests/support), testy/pomoc.rb, testy/kolizje_belek.rb, sketchup/dach_aplikacja.rb, sketchup/konwersja.rb, sketchup/atrybuty.rb
# Używają: testy/uruchom.sh (gdy aplikacja do dachów jest obok), ręcznie
#
# Uruchomienie: ruby testy/sprawdz_dach_aplikacja.rb – bez aplikacji do dachów: „POMINIĘTO” i FAILURES 0.
# Wysokości porównywane w układzie domu (mm) z płaszczyzną policzoną niezależnie od rdzenia (z_polaci).

KATALOG_DACHOW = ENV['AM_GW_APLIKACJA_DACHOW'] || File.expand_path('../../aplikacja-do-konstrukcji-dach-w', File.dirname(__FILE__))
unless File.exist?(File.join(KATALOG_DACHOW, 'artemadera_roof.rb')) &&
       File.exist?(File.join(KATALOG_DACHOW, 'tests', 'support', 'sketchup_mock.rb'))
  puts "POMINIĘTO: brak aplikacji do dachów w #{KATALOG_DACHOW} (ustaw AM_GW_APLIKACJA_DACHOW)"
  puts 'FAILURES: 0'
  exit 0
end

$LOAD_PATH.unshift(File.join(KATALOG_DACHOW, 'tests', 'support', 'stubs'))
require File.join(KATALOG_DACHOW, 'tests', 'support', 'sketchup_mock')
load File.join(KATALOG_DACHOW, 'artemadera_roof.rb')
require File.expand_path('pomoc', File.dirname(__FILE__))
require File.expand_path('kolizje_belek', File.dirname(__FILE__))
%w[konwersja atrybuty dach_aplikacja].each { |f| require File.join(KATALOG_WTYCZKI, 'sketchup', f) }
include ArteMadera::GeneratorWiencowy
ROOF = ArteMadera::Roof

# Grupa domu w modelu atrapy (bez bali – tylko położenie i id, jak po Budowa.zbuduj).
def dom_w_modelu(model, pl, z0)
  g = model.entities.add_group
  g.name = 'Dom wieńcowy'
  g.transformation = Konwersja.transformacja_domu(pl[:kat], z0)
  g.set_attribute(Atrybuty::DICT_GW, 'dom', "GW-test-#{pl[:obrys].length}-#{z0.round}")
  g
end

# Punkty ścian grupy (z jej elementami) w mm układu domu.
def punkty_lokalnie(grupa, dom)
  odwr = dom.transformation.inverse
  tr = grupa.transformation
  grupa.entities.grep(Sketchup::Face).flat_map(&:vertices).uniq.map do |v|
    Konwersja.z_punktu(v.position.transform(tr).transform(odwr))
  end
end

# Odchyłki punktów od połaci [mm]: [najniżej pod, najwyżej nad].
def odchylki(punkty, pol)
  d = punkty.map { |x, y, z| z - z_polaci(pol, x, y) }
  [d.min, d.max]
end

# [nazwa, linie, parametry, poziom linii z0, liczba połaci]
PRZYPADKI = [
  ['Dom 5 × 4 m, krokwie na płatwi ściennej i kalenicowej', prostokat(0, 0, 5000, 4000), { 'dach_uklad' => 'krokwie' }, 0.0, 2],
  ['Dom 4 × 6,5 m obrócony o 30°, płatwie i krokwie, 35°, okap 600, za szczytem 300',
   obroc_odcinki(prostokat(0, 0, 4000, 6500), 30),
   { 'dach_uklad' => 'platwie_krokwie', 'dach_kat' => 35, 'dach_okap' => 600, 'dach_okap_szczyt' => 300 }, 450.0, 2],
  ['Dom 7 × 4,5 m z działową ze szczytem, płatew ścienna na ścianie, krokiew 60 × 180',
   prostokat(0, 0, 7000, 4500) + [[[3500, 0], [3500, 4500]]],
   { 'dach_uklad' => 'platwie_krokwie', 'szczyty_na_dzialowych' => 'tak', 'platwa_scienna_polozenie' => 'na_scianie',
     'krokiew_przekroj' => '60x180', 'drewno_klasa' => 'C30' }, 0.0, 2],
  ['Dom 6 × 4,5 m, dach jednospadowy 15°, płatwie i krokwie, okap za ścianą wysoką 300',
   prostokat(0, 0, 6000, 4500), { 'dach_rodzaj' => 'jednospadowy', 'dach_uklad' => 'platwie_krokwie', 'dach_kat' => 15,
                                  'dach_okap_wysoki' => 300 }, 0.0, 1],
  ['Dom 5 × 4 m obrócony o 120°, jednospadowy ze spadkiem w stronę większych współrzędnych',
   obroc_odcinki(prostokat(0, 0, 5000, 4000), 120), { 'dach_rodzaj' => 'jednospadowy', 'dach_spadek' => 'max', 'dach_uklad' => 'krokwie' },
   300.0, 1]
].freeze

PRZYPADKI.each do |nazwa, seg, par, z0, ile|
  Testy.grupa(nazwa)
  Sketchup.reset_model!
  Sketchup.defaults.clear
  model = Sketchup.active_model
  pl = plan_pelny(seg, par)
  pol = pl[:polacie]
  p = pl[:parametry]
  Testy.sprawdz(pl[:bledy].empty? && !pol.nil?, 'plan z połaciami')
  next if pol.nil?
  dom = dom_w_modelu(model, pl, z0)
  grupa, info = DachAplikacja.nowe_polacie(model, dom, pol)
  Testy.sprawdz(!grupa.nil?, "połacie z aplikacji (#{info.inspect})")
  next if grupa.nil?
  sciany = grupa.entities.grep(Sketchup::Face)
  Testy.rowne(sciany.length, ile, "połacie: #{ile}")
  pk = punkty_lokalnie(grupa, dom)
  lo, hi = odchylki(pk, pol)
  Testy.sprawdz(lo > -0.01 && hi < 0.01, format('połacie w płaszczyźnie spodu krokwi z generatora (%.4f…%.4f mm)', lo, hi))
  ob = [pk.map { |q| q[0] }.minmax, pk.map { |q| q[1] }.minmax].flatten.map { |v| v.round(2) }
  xs = pol[:punkty].map { |q| q[0] }.minmax
  ys = pol[:punkty].map { |q| q[1] }.minmax
  Testy.rowne(ob, [xs[0] - pol[:okap], xs[1] + pol[:okap], ys[0] - pol[:okap], ys[1] + pol[:okap]].map { |v| v.round(2) },
              'zasięg połaci = obrys + okap (szczyty: wysunięcie za szczyt, jednospadowy: okap za ścianą wysoką)')
  Testy.rowne(grupa.get_attribute(Atrybuty::DICT_GW, 'polacie_domu'), Atrybuty.dom_id(dom), 'połacie oznaczone id domu')

  model.selection.clear
  model.selection.add(grupa)
  polacie_ap, blad = ROOF::FaceCollector.from_selection(model.selection)
  Testy.sprawdz(blad.nil? && polacie_ap.length == ile, "KROK 2 widzi połacie: #{ile} (#{blad.inspect})")
  ust = ROOF::Config.load_settings(:framing).merge(DachAplikacja.ustawienia_krok2(p)).merge(components: false, group_all: true)
  wiezba, raport = ROOF::FramingBuilder.generate(model, polacie_ap, ust)
  Testy.sprawdz(!wiezba.nil?, "więźba z KROKU 2 (#{raport.is_a?(String) ? raport : 'raport'})")
  next if wiezba.nil?
  krokwie = wiezba.entities.grep(Sketchup::Group).select { |g| g.get_attribute('ArteMaderaTimber', 'kind') == 'rafter' }
  Testy.sprawdz(krokwie.length >= 4, "krokwie z aplikacji (#{krokwie.length})")
  dol = krokwie.map { |k| odchylki(punkty_lokalnie(k, dom), pol)[0] }
  Testy.sprawdz(dol.min > -0.5, format('krokwie nad połacią – nie wchodzą w płatwie ani szczyty (najniżej %.3f mm)', dol.min))
  Testy.sprawdz(dol.max < 0.5, format('każda krokiew leży na połaci (najwyżej spód %.3f mm)', dol.max))
  bk, hk = Parametry.przekroj(p, 'krokiew_przekroj')
  wym = krokwie.map do |k|
    q = punkty_lokalnie(k, dom)
    (q.map { |x, y, z| z - z_polaci(pol, x, y) }.max * Math.cos(pol[:kat] * Math::PI / 180.0)).round
  end.uniq
  Testy.rowne(wym, [hk.round], "wysokość krokwi #{bk.round} × #{hk.round} z generatora")
  tekst = raport.to_s
  kontrola = tekst.lines.find { |l| l.include?('Kontrola krokwi') }
  Testy.sprawdz(!kontrola.nil?, "kontrola krokwi w raporcie: #{kontrola.to_s.strip}")
  wzp = wzgledem_polaci(pl)
  Testy.sprawdz(wzp[:bale] <= 0.01 && wzp[:platwie] <= 0.01 && wzp[:dotyk] >= -0.5, 'bale i płatwie generatora pod połacią, płatwie ją podpierają')
end

Testy.koniec
