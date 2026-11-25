# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_materialy.rb
# Zadanie: testy zestawienia materiałów (propozycja W2, runda 15) – powierzchnia dachu, deski nadbitki / deskowania / OSB w m² i sztukach, podbitka, taśma między wieńcami, okucia (śruby i podstawy słupów, kotwy podwalin, łączniki krokwi), impregnacja, blok w pliku CSV.
# Tematy: testy zestawienia materiałów, test powierzchni dachu, test taśmy między wieńcami, test okuć, test impregnacji, test bloku materiałów w CSV
# Zależy od: testy/pomoc.rb, Plugins/.../rdzen/materialy.rb, rdzen/zestawienie.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_materialy.rb – ostatnia linia „FAILURES: n”.

require File.expand_path('pomoc', File.dirname(__FILE__))
require File.expand_path('../Plugins/arte_madera_generator_wiencowy/rdzen/zestawienie', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

DOM = prostokat(0, 0, 8000, 6400)

# Wiersz materiałów o nazwie zaczynającej się od tekstu i jednostce.
def mat(pl, nazwa, jednostka = nil)
  pl[:materialy].find { |m| m[:nazwa].start_with?(nazwa) && (jednostka.nil? || m[:jednostka] == jednostka) }
end

Testy.grupa('Dom 8000 × 6400, wartości fabryczne: nadbitka 14 × 115 × 4000')
pl = plan_pelny(DOM)
p = pl[:parametry]
dach = Materialy.powierzchnia_dachu(pl)
dl = 8000.0 + 2.0 * p['dach_okap_szczyt']
rzut = 6400.0 + 2.0 * p['dach_okap']
m2 = dl * rzut / Math.cos(20.0 * Math::PI / 180.0) / 1.0e6
Testy.rowne(dach[:dach], m2, 'powierzchnia połaci: (długość + 2 × wysunięcie za szczyt) × (rozpiętość + 2 × okap) / cos kąta', 0.001)
Testy.rowne([dach[:zadaszenie], dach[:przyblizona]], [0.0, false], 'bez zadaszenia, dokładnie')
Testy.rowne(pl[:materialy].map { |m| m[:grupa] }.uniq, ['Poszycie dachu', 'Uszczelnienie', 'Okucia', 'Impregnacja'], 'grupy w kolejności')
nb = mat(pl, 'Nadbitka', 'm²')
Testy.rowne([nb[:wymiar], nb[:ilosc]], ['14 × 115 × 4000', m2.round(1)], 'nadbitka: wymiar i m²')
Testy.rowne(mat(pl, 'Nadbitka', 'szt.')[:ilosc], (m2 * 1.1 / (0.115 * 4.0) - 1e-9).ceil, 'nadbitka: sztuki z zapasem 10 %')
Testy.sprawdz(mat(pl, 'Deskowanie').nil? && mat(pl, 'Płyty OSB').nil?, 'bez deskowania pełnego i OSB (wyłączone fabrycznie)')
wyzej = pl[:bale].select { |b| b[:i] > 0 }.inject(0.0) { |s, b| s + b[:dl] }
pierwszy = pl[:bale].select { |b| b[:i].zero? }.inject(0.0) { |s, b| s + b[:dl] }
Testy.rowne(mat(pl, 'Taśma')[:ilosc], (wyzej / 1000.0 - 1e-9).ceil, 'taśma: metry bali poza najniższym wieńcem')
Testy.rowne(mat(pl, 'Izolacja pod pierwszy wieniec')[:ilosc], (pierwszy / 1000.0 - 1e-9).ceil, 'izolacja: metry najniższego wieńca')
pw = pl[:elementy].select { |e| e[:prefiks] == 'Pw' }
Testy.rowne(mat(pl, 'Kotwa podwaliny')[:ilosc], pw.inject(0) { |s, e| s + [(e[:dl] / 1000.0 - 1e-9).ceil + 1, 2].max }, 'kotwy podwalin co 1000, nie mniej niż 2')
Testy.sprawdz(mat(pl, 'Śruba regulacyjna').nil? && mat(pl, 'Podstawa słupa').nil? && mat(pl, 'Łącznik krokwi').nil?,
              'bez słupów i krokwi z generatora – bez ich okuć')
zewn = pl[:bale].select { |b| b[:sciana][:rodzaj] == :zewnetrzna }.inject(0.0) { |s, b| s + b[:dl] * b[:h] } / 1.0e6
Testy.sprawdz(mat(pl, 'Ściany – lica zewnętrzne')[:ilosc] >= zewn.round(1) && mat(pl, 'Ściany – lica zewnętrzne')[:ilosc] < zewn * 1.2,
              "lica zewnętrzne: ściany zewnętrzne (#{zewn.round(1)} m²) i połowy węgłów")
im = pl[:materialy].select { |m| m[:grupa] == 'Impregnacja' && m[:jednostka] == 'm²' }.inject(0.0) { |s, m| s + m[:ilosc] }
litry = mat(pl, 'Impregnat')[:ilosc]
Testy.sprawdz((litry - im * 2 / 10.0).abs <= 1.0, "impregnat: #{litry} l = m² × 2 warstwy / 10 m² z litra")
Testy.sprawdz(mat(pl, 'Deski poszycia i podbitki')[:ilosc] == m2.round(1), 'spód nadbitki do impregnacji = powierzchnia połaci')

Testy.grupa('Parametry zestawienia: zapas, pasy taśmy, rozstaw kotew, impregnat')
pl2 = plan_pelny(DOM, 'material_zapas' => 0, 'tasma_pasy' => '2', 'kotwy_podwalin_rozstaw' => 500, 'impregnat_wydajnosc' => 8, 'impregnat_warstwy' => '3')
Testy.rowne(mat(pl2, 'Nadbitka', 'szt.')[:ilosc], (m2 / (0.115 * 4.0) - 1e-9).ceil, 'zapas 0 %')
Testy.rowne(mat(pl2, 'Taśma')[:ilosc], (wyzej * 2 / 1000.0 - 1e-9).ceil, 'dwa pasy taśmy')
Testy.sprawdz(mat(pl2, 'Kotwa podwaliny')[:ilosc] > mat(pl, 'Kotwa podwaliny')[:ilosc], 'kotwy co 500 – więcej')
Testy.sprawdz(mat(pl2, 'Impregnat')[:ilosc] > litry && mat(pl2, 'Impregnat')[:uwagi].include?('3 warstwy'), 'trzy warstwy, 8 m² z litra')
Testy.sprawdz(mat(plan_pelny(DOM, 'tasma_pasy' => '0'), 'Taśma').nil?, 'bez taśmy – bez wiersza')

Testy.grupa('Warstwy poszycia z wyboru, podbitka z generatora, dom bez szczytów')
pl3 = plan_pelny(DOM, 'poszycie_nadbitka' => 'nie', 'poszycie_deski' => 'tak', 'poszycie_osb' => 'tak')
d3 = mat(pl3, 'Deskowanie', 'szt.')
Testy.rowne([mat(pl3, 'Deskowanie', 'm²')[:wymiar], d3[:ilosc]], ['25 × 100 × 4000', (m2 * 1.1 / (0.103 * 4.0) - 1e-9).ceil],
            'deskowanie 25 × 100: sztuki z odstępem 3 mm')
Testy.rowne(mat(pl3, 'Płyty OSB', 'szt.')[:ilosc], (m2 * 1.1 / (pl3[:parametry]['osb_szerokosc'] * pl3[:parametry]['osb_dlugosc'] / 1.0e6) - 1e-9).ceil, 'płyty OSB')
Testy.sprawdz(mat(pl3, 'Nadbitka').nil?, 'bez nadbitki')
pl4 = plan_pelny(DOM, 'podbitka' => 'pod_platwiami')
pb = pl4[:elementy].select { |e| e[:prefiks] == 'Pb' }
Testy.rowne(mat(pl4, 'Podbitka', 'm²')[:ilosc], (pb.inject(0.0) { |s, e| s + e[:dl] * 115.0 } / 1.0e6).round(1), 'podbitka z generatora: m² desek z modelu')
Testy.sprawdz(mat(pl4, 'Podbitka', 'szt.')[:ilosc] > 0 && mat(pl4, 'Nadbitka', 'm²'), 'podbitka w sztukach handlowych, nadbitka nadal jako poszycie')
pl5 = plan_pelny(DOM, 'szczyty' => 'nie')
Testy.sprawdz(pl5[:materialy].none? { |m| m[:grupa] == 'Poszycie dachu' } && mat(pl5, 'Taśma') && mat(pl5, 'Impregnat'),
              'bez szczytów: bez poszycia, taśma i impregnacja są')

Testy.grupa('Dach jednospadowy, boczne zadaszenie, obrys L')
plj = plan_pelny(DOM, 'dach_rodzaj' => 'jednospadowy')
pj = plj[:parametry]
mj = (8000.0 + 2.0 * pj['dach_okap_szczyt']) * (6400.0 + pj['dach_okap'] + pj['dach_okap_wysoki']) / Math.cos(20.0 * Math::PI / 180.0) / 1.0e6
Testy.rowne(Materialy.powierzchnia_dachu(plj)[:dach], mj, 'jednospadowy: rozpiętość + okap + okap za ścianą wysoką', 0.001)
plz = plan_pelny(DOM, 'zadaszenie' => 'slupy')
dz = Materialy.powierzchnia_dachu(plz)
pz = plz[:parametry]
Testy.rowne(dz[:dach], dl * (6400.0 + pz['dach_okap']) / Math.cos(20.0 * Math::PI / 180.0) / 1.0e6, 'z zadaszeniem: połać domu po tej stronie do linii załamania', 0.001)
Testy.sprawdz(dz[:zadaszenie] > 10.0, "połać zadaszenia osobno (#{dz[:zadaszenie].round(1)} m²)")
Testy.rowne(mat(plz, 'Nadbitka', 'm²')[:ilosc], (dz[:dach] + dz[:zadaszenie]).round(1), 'nadbitka: dom + zadaszenie')
Testy.rowne(mat(plz, 'Podstawa słupa')[:ilosc], plz[:elementy].count { |e| e[:prefiks] == 'S' && e[:rodzaj] == 'Słup zadaszenia' }, 'podstawy pod słupy zadaszenia (bez słupków)')
pll = plan_pelny(wielokat([[0, 0], [9000, 0], [9000, 5000], [5000, 5000], [5000, 8000], [0, 8000]]))
dl_l = Materialy.powierzchnia_dachu(pll)
Testy.sprawdz(dl_l && dl_l[:przyblizona] && dl_l[:dach] > 60.0, "obrys L: powierzchnia w przybliżeniu (#{dl_l ? dl_l[:dach].round(1) : '-'} m²)")
Testy.sprawdz(mat(pll, 'Nadbitka', 'm²')[:uwagi].include?('w przybliżeniu'), 'dopisek „w przybliżeniu” w uwagach')

Testy.grupa('Taras na słupach i krokwie z generatora: okucia')
plt = plan_pelny(DOM, 'taras' => 'podciag', 'dach_uklad' => 'platwie_krokwie', 'dach_wiezba' => 'generator')
slupy = plt[:elementy].select { |e| e[:prefiks] == 'S' }
Testy.rowne([mat(plt, 'Śruba regulacyjna')[:ilosc], mat(plt, 'Podstawa słupa')[:ilosc]], [slupy.length, slupy.length], 'śruba regulacyjna i podstawa na każdy słup tarasu')
Testy.sprawdz(mat(plt, 'Śruba regulacyjna')[:uwagi].include?('40 mm'), 'uwagi: wysokość śruby po skręceniu')
krokwie = plt[:elementy].count { |e| e[:prefiks] == 'K' }
laczniki = mat(plt, 'Łącznik krokwi')[:ilosc]
Testy.sprawdz(laczniki >= 2 * krokwie && (laczniki % krokwie).zero?, "łączniki krokwi: #{laczniki} = #{krokwie} krokwi × #{laczniki / krokwie} płatwi")
Testy.sprawdz(mat(plt, 'Belki dachu i słupy')[:ilosc] > 20.0, 'belki dachu i słupy do impregnacji')
plp = plan_pelny(DOM, 'taras' => 'podciag', 'slup_regulacja' => 'podkladki')
Testy.sprawdz(mat(plp, 'Podkładki')[:ilosc] == plp[:elementy].count { |e| e[:prefiks] == 'S' } && mat(plp, 'Śruba regulacyjna').nil?, 'podkładki zamiast śrub')
pln = plan_pelny(DOM, 'taras' => 'podciag', 'slup_osiadanie' => 'nie')
Testy.sprawdz(mat(pln, 'Śruba regulacyjna').nil? && mat(pln, 'Podkładki').nil? && mat(pln, 'Podstawa słupa'), 'słupy bez skracania – bez okuć regulacyjnych')

Testy.grupa('Plik CSV: blok materiałów pod sumami bali i belek')
csv = Zestawienie.csv(plt)
wiersze = csv.split("\r\n")
i0 = wiersze.index('Materiały;Pozycja;Wymiar [mm];Ilość;Jednostka;Uwagi')
Testy.sprawdz(!i0.nil? && wiersze[i0 - 1] == '' && wiersze[i0 - 2].start_with?(';Razem wszystko'), 'nagłówek materiałów po pustym wierszu pod „Razem wszystko”')
Testy.rowne(wiersze.length - i0 - 1, plt[:materialy].length, 'każdy materiał w osobnym wierszu')
Testy.sprawdz(wiersze.any? { |w| w =~ /\APoszycie dachu;Nadbitka – deski pióro-wpust;14x115x4000;\d+,\d;m²;/ }, 'nadbitka: wymiar bez spacji, przecinek dziesiętny')
Testy.sprawdz(wiersze.any? { |w| w.start_with?('Okucia;Śruba regulacyjna słupa;;') }, 'okucia w pliku')
Testy.rowne(Materialy.wiersze_csv([]), [], 'bez materiałów – bez bloku')
Testy.rowne(Materialy.lista(bale: []), [], 'plan bez bali – pusta lista')

Testy.koniec
