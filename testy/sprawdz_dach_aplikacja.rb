# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/sprawdz_dach_aplikacja.rb
# Zadanie: dom z bali z prawdziwą aplikacją do dachów (na jej atrapie SketchUpa) przez jej API – połacie na płaszczyźnie wierzchu płatwi, płatwie domu jako podpory, KROK 2 w górę od połaci: krokwie na płatwiach i nad szczytami, przęsła między płatwiami w kontroli nośności; same płatwie – deski na płatwiach wzdłuż spadku, styki na płatwiach; dom odbity.
# Tematy: aplikacja do dachów – sprawdzenie z prawdziwą wtyczką, API aplikacji do dachów, połacie z API, KROK 2 w górę, krokwie z aplikacji nad płatwiami, kontrola krokwi z aplikacji, przęsła między płatwiami, deski na płatwiach z aplikacji, dach jednospadowy z aplikacją, dom odbity
# Zależy od: aplikacja do dachów 3.7.0+ (katalog obok repozytorium albo AM_GW_APLIKACJA_DACHOW, jej tests/support), testy/pomoc.rb, testy/kolizje_belek.rb, sketchup/dach_aplikacja.rb, sketchup/konwersja.rb, sketchup/atrybuty.rb
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

# Grupa domu w modelu atrapy (bez bali – tylko położenie i id, jak po Budowa.zbuduj); odbity – lustro (oś y odwrócona).
def dom_w_modelu(model, pl, z0, odbity = false)
  g = model.entities.add_group
  g.name = 'Dom wieńcowy'
  tr = Konwersja.transformacja_domu(pl[:kat], z0)
  if odbity
    tr = Geom::Transformation.axes(tr.origin, tr.xaxis, Geom::Vector3d.new(-tr.yaxis.x, -tr.yaxis.y, -tr.yaxis.z), tr.zaxis)
  end
  g.transformation = tr
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

# Elementy więźby danego rodzaju (ArteMaderaTimber.kind).
def czesci(wiezba, rodzaj)
  wiezba.entities.grep(Sketchup::Group).select { |g| g.get_attribute('ArteMaderaTimber', 'kind') == rodzaj }
end

# Oś kalenicy połaci w układzie domu: 0 – x, 1 – y (krawędź szczytowa ma stałe drugie z nich).
def os_kalenicy(pol)
  a = pol[:punkty][pol[:szczyty][0] - 1]
  b = pol[:punkty][pol[:szczyty][0] % pol[:punkty].length]
  (a[0] - b[0]).abs < 0.01 ? 0 : 1
end

# Zakresy płatwi w poprzek kalenicy (mm układu domu): [[od, do]].
def platwie_w_poprzek(pl, iv)
  pl[:elementy].select { |e| e[:prefiks] == 'P' }.map do |e|
    pe = e[:polozenie]
    [pe[:poczatek][iv], pe[:poczatek][iv] + pe[:y][iv] * e[:b]].minmax
  end
end

# [nazwa, linie, parametry, poziom linii z0, liczba połaci, dom odbity]
PRZYPADKI = [
  ['Dom 5 × 4 m, krokwie na płatwi ściennej i kalenicowej', prostokat(0, 0, 5000, 4000), { 'dach_uklad' => 'krokwie' }, 0.0, 2, false],
  ['Dom 4 × 6,5 m obrócony o 30°, płatwie i krokwie, 35°, okap 600, za szczytem 300',
   obroc_odcinki(prostokat(0, 0, 4000, 6500), 30),
   { 'dach_uklad' => 'platwie_krokwie', 'dach_kat' => 35, 'dach_okap' => 600, 'dach_okap_szczyt' => 300 }, 450.0, 2, false],
  ['Dom 7 × 4,5 m z działową ze szczytem, płatew ścienna na ścianie, krokiew 60 × 180',
   prostokat(0, 0, 7000, 4500) + [[[3500, 0], [3500, 4500]]],
   { 'dach_uklad' => 'platwie_krokwie', 'szczyty_na_dzialowych' => 'tak', 'platwa_scienna_polozenie' => 'na_scianie',
     'krokiew_przekroj' => '60x180', 'drewno_klasa' => 'C30' }, 0.0, 2, false],
  ['Dom 6 × 4,5 m, dach jednospadowy 15°, płatwie i krokwie, okap za ścianą wysoką 300',
   prostokat(0, 0, 6000, 4500), { 'dach_rodzaj' => 'jednospadowy', 'dach_uklad' => 'platwie_krokwie', 'dach_kat' => 15,
                                  'dach_okap_wysoki' => 300 }, 0.0, 1, false],
  ['Dom 5 × 4 m obrócony o 120°, jednospadowy ze spadkiem w stronę większych współrzędnych',
   obroc_odcinki(prostokat(0, 0, 5000, 4000), 120), { 'dach_rodzaj' => 'jednospadowy', 'dach_spadek' => 'max', 'dach_uklad' => 'krokwie' },
   300.0, 1, false],
  ['Dom 6 × 4,5 m, same płatwie (jak 900) – deski 2 m na płatwiach', prostokat(0, 0, 6000, 4500), { 'deski_dlugosc' => 2000 }, 0.0, 2,
   false],
  ['Dom 7 × 5 m, same płatwie, nadbitka i OSB 22', prostokat(0, 0, 7000, 5000),
   { 'poszycie_nadbitka' => 'tak', 'nadbitka_dlugosc' => 2500, 'poszycie_deski' => 'nie', 'poszycie_osb' => 'tak', 'osb_grubosc' => 22 },
   0.0, 2, false],
  ['Dom 5 × 4 m odbity (lustro), płatwie i krokwie', prostokat(0, 0, 5000, 4000), { 'dach_uklad' => 'platwie_krokwie' }, 0.0, 2, true]
].freeze

PRZYPADKI.each do |nazwa, seg, par, z0, ile, odbity|
  Testy.grupa(nazwa)
  Sketchup.reset_model!
  Sketchup.defaults.clear
  model = Sketchup.active_model
  pl = plan_pelny(seg, par)
  pol = pl[:polacie]
  p = pl[:parametry]
  Testy.sprawdz(pl[:bledy].empty? && !pol.nil?, 'plan z połaciami')
  next if pol.nil?
  dom = dom_w_modelu(model, pl, z0, odbity)
  grupa, info = DachAplikacja.nowe_polacie(model, dom, pol, Krok2.podpory(pl))
  Testy.sprawdz(!grupa.nil?, "połacie z API aplikacji (#{info.inspect})")
  next if grupa.nil?
  Testy.rowne(grupa.get_attribute('ArteMaderaRoof', 'api'), 1, 'połacie z API (wersja 1)')
  sciany = grupa.entities.grep(Sketchup::Face)
  Testy.rowne(sciany.length, ile, "połacie: #{ile}")
  pk = punkty_lokalnie(grupa, dom)
  lo, hi = odchylki(pk, pol)
  Testy.sprawdz(lo > -0.01 && hi < 0.01, format('połacie w płaszczyźnie wierzchu płatwi z generatora (%.4f…%.4f mm)', lo, hi))
  ob = [pk.map { |q| q[0] }.minmax, pk.map { |q| q[1] }.minmax].flatten.map { |v| v.round(2) }
  xs = pol[:punkty].map { |q| q[0] }.minmax
  ys = pol[:punkty].map { |q| q[1] }.minmax
  Testy.rowne(ob, [xs[0] - pol[:okap], xs[1] + pol[:okap], ys[0] - pol[:okap], ys[1] + pol[:okap]].map { |v| v.round(2) },
              'zasięg połaci = obrys + okap (szczyty: wysunięcie za szczyt, jednospadowy: okap za ścianą wysoką)')
  Testy.rowne(grupa.get_attribute(Atrybuty::DICT_GW, 'polacie_domu'), Atrybuty.dom_id(dom), 'połacie oznaczone id domu')
  ile_p = pl[:elementy].count { |e| e[:prefiks] == 'P' } + (Dach.jednospadowy?(p) ? 1 : 0)
  zapisane = ROOF::Supports.stored(grupa) || []
  Testy.rowne(zapisane.length, ile_p, "podpory zapisane w grupie połaci: #{ile_p} (płatwie#{Dach.jednospadowy?(p) ? ' i ściana wysoka' : ''})")

  polacie_ap, blad = ROOF::FaceCollector.from_selection([grupa])
  Testy.sprawdz(blad.nil? && polacie_ap.length == ile, "KROK 2 widzi połacie: #{ile} (#{blad.inspect})")
  wiezba, raport = ROOF::API.wiezba(grupa, Krok2.ustawienia(p).merge(components: false), :okno => false)
  Testy.sprawdz(!wiezba.nil?, "więźba z KROKU 2 przez API (#{raport.is_a?(String) ? raport : 'raport'})")
  next if wiezba.nil?
  tekst = raport.to_s
  Testy.sprawdz(tekst.include?('lista z wywołania innej wtyczki'), 'podpory z listy generatora w raporcie')
  Testy.sprawdz(tekst !~ /Żadna z belek nie leży pod połacią/, 'płatwie leżą pod połaciami')
  par = ROOF::FramingBuilder.prepare_parameters(ROOF::Config.load_settings(:framing).merge(Krok2.ustawienia(p)))
  ROOF::Supports.prepare!(model.active_entities, polacie_ap, par)
  pod = polacie_ap.inject(0) { |s, f| s + f.supports.length }
  Testy.rowne(pod, ile_p + (Dach.jednospadowy?(p) ? 0 : 1), 'każda podpora leży pod połacią (kalenicowa – pod obiema)')
  if Krok2.bez_krokwi?(p)
    Testy.rowne(czesci(wiezba, 'rafter').length, 0, 'bez krokwi')
    rodzaj = Parametry.tak?(p, 'poszycie_nadbitka') ? 'sheath_ceiling' : 'sheath_plank'
    deski = czesci(wiezba, rodzaj)
    Testy.sprawdz(deski.length > 4, "#{rodzaj}: #{deski.length} szt.")
    next if deski.empty?
    spod = deski.map { |k| odchylki(punkty_lokalnie(k, dom), pol)[0] }
    Testy.sprawdz(spod.min > -0.5 && spod.max < 0.5, format('pierwsza warstwa leży na płatwiach – spód na połaci (%.3f…%.3f mm)', spod.min, spod.max))
    iu = os_kalenicy(pol)
    iv = 1 - iu
    wymiary = deski.map { |k| q = punkty_lokalnie(k, dom); [q.map { |r| r[iu] }.minmax, q.map { |r| r[iv] }.minmax] }
    Testy.sprawdz(wymiary.all? { |(u0, u1), (v0, v1)| v1 - v0 > u1 - u0 }, 'wzdłuż spadku')
    pasy = platwie_w_poprzek(pl, iv)
    kraw = [ys, xs][iu].dup
    okapy = [kraw[0] - pol[:okap], kraw[1] + pol[:okap]]
    konce = wymiary.flat_map { |_u, v| v }.uniq { |v| v.round(1) }.reject { |v| okapy.any? { |o| (v - o).abs < 5 } }
    poza = konce.reject { |v| pasy.any? { |a, b| v >= a - 1.0 && v <= b + 1.0 } }
    Testy.sprawdz(konce.length >= 3 && poza.empty?, "styki i kalenica na płatwiach (#{konce.length} linii, poza: #{poza.map(&:round).first(6).inspect})")
    Testy.sprawdz(tekst.include?('Bez krokwi: poszycie leży na płatwiach'), 'raport: poszycie na płatwiach')
    if Parametry.tak?(p, 'poszycie_osb')
      osb = czesci(wiezba, 'sheath_osb')
      Testy.sprawdz(!osb.empty? && osb.all? { |k| (odchylki(punkty_lokalnie(k, dom), pol)[0] - p['nadbitka_grubosc'].to_f / Math.cos(pol[:kat] * Math::PI / 180.0)).abs < 1.0 },
                    "OSB na nadbitce (#{osb.length} szt.)")
    end
  else
    krokwie = czesci(wiezba, 'rafter')
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
    kontrola = tekst.lines.find { |l| l.include?('Kontrola krokwi') }
    Testy.sprawdz(!kontrola.nil?, "kontrola krokwi w raporcie: #{kontrola.to_s.strip}")
    if Dach.platwie_posrednie?(p)
      przesla = tekst.lines.find { |l| l.include?('Podpory pośrednie –') }
      Testy.sprawdz(!przesla.nil?, "przęsła między płatwiami: #{przesla.to_s.strip}")
    end
    if Parametry.tak?(p, 'poszycie_deski')
      Testy.sprawdz(!czesci(wiezba, 'sheath_plank').empty?, 'deskowanie na krokwiach')
    end
  end
  wzp = wzgledem_polaci(pl)
  Testy.sprawdz(wzp[:bale] <= 0.01 && wzp[:platwie] <= 0.01 && wzp[:dotyk] >= -0.5, 'bale i płatwie generatora pod połacią, płatwie ją podpierają')
end

Testy.koniec
