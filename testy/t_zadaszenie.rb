# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_zadaszenie.rb
# Zadanie: boczne zadaszenie (runda 12) – linia dachu z załamaniem, płatwie zadaszenia, słupy z belkami poprzecznymi i słupkami, przybudówka z bali (obrys, role ścian, niska ściana, szczyty z załamaniem), krokwie zadaszenia z generatora, połacie z załamaniem dla aplikacji do dachów, przeszkody (kąt, taras, jednospadowy), przekazanie załamania w modelu (atrapa).
# Tematy: testy bocznego zadaszenia, testy załamania dachu, testy wiaty bocznej, testy przybudówki z bali
# Zależy od: testy/pomoc.rb, testy/losowe_domy.rb (sprawdzenie domu), testy/atrapa/sketchup.rb, testy/atrapa/aplikacja_dachow.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_zadaszenie.rb

require 'tmpdir'
require 'fileutils'
ENV['AM_GW_USTAWIENIA'] = File.join(Dir.tmpdir, "am_gw_test_zad_#{Process.pid}")
FileUtils.rm_rf(ENV['AM_GW_USTAWIENIA'])
require File.expand_path('atrapa/sketchup', File.dirname(__FILE__))
require File.expand_path('atrapa/aplikacja_dachow', File.dirname(__FILE__))
require File.expand_path('losowe_domy', File.dirname(__FILE__))
require File.join(KATALOG_WTYCZKI, 'sketchup', 'konwersja')
require File.join(KATALOG_WTYCZKI, 'sketchup', 'atrybuty')
require File.join(KATALOG_WTYCZKI, 'sketchup', 'dach_aplikacja')
include ArteMadera::GeneratorWiencowy

TG30 = Math.tan(30.0 * Math::PI / 180.0)
TG12 = Math.tan(12.0 * Math::PI / 180.0)

def el(pl, rodzaj)
  pl[:elementy].select { |e| e[:rodzaj] == rodzaj }
end

# Zakres elementu w osi k układu domu (wszystkie naroża prostopadłościanu) [min, max].
def zakres(e, k)
  pe = e[:polozenie]
  rogi = [0.0, e[:dl]].product([0.0, e[:b]], [0.0, e[:h]]).map do |x, y, z|
    pe[:poczatek][k] + pe[:x][k] * x + pe[:y][k] * y + pe[:z][k] * z
  end
  rogi.minmax
end

# --- wiata na słupach -------------------------------------------------------------------------------------------------
Testy.grupa('Wiata na słupach – linia dachu z załamaniem')
par = { 'zadaszenie' => 'slupy', 'dach_kat' => 30, 'liczba_wiencow' => 14 }
pl = plan_pelny(prostokat(0, 0, 6000, 4000), par)
p = pl[:parametry]
Testy.sprawdz(pl[:bledy].empty?, 'plan bez błędów')
geo = Dach.geo(Szczyty.przygotuj(pl[:sciany], p, pl[:os_kalenicy])[:dom])
Testy.rowne((geo[:zad] || []).length, 1, 'jedno zadaszenie (strona dolna)')
c = geo[:zad].first
t = Parametry.grubosc(p)
Testy.rowne(c[:kier], -1.0, 'po stronie mniejszych y')
Testy.rowne(c[:v_k], 0.0, 'linia załamania nad licem zewnętrznym ściany (płatew ścienna przy licu)')
Testy.rowne(c[:v_s], -2000.0, 'lico podpory – szerokość zadaszenia od lica ściany')
zk = Dach.linia_podparcia(geo, 0.0, p)
Testy.rowne(Dach.linia_podparcia(geo, -1000.0, p), zk - 1000.0 * TG12, 'za załamaniem – kąt zadaszenia', 0.001)
Testy.rowne(Dach.linia_podparcia(geo, 500.0, p), zk + 500.0 * TG30, 'przed załamaniem – kąt dachu', 0.001)
Testy.rowne(Dach.linia_podparcia(geo, 4100.0, p), Dach.linia_glowna(geo, 4100.0, p), 'druga strona bez zmian (okap dachu)')
Testy.rowne(Dach.zalomy_v(geo, p), [0.0, (geo[:v_a] + geo[:v_b]) / 2.0], 'załomy: załamanie i kalenica')

Testy.grupa('Wiata na słupach – elementy')
pp = el(pl, 'Płatew zadaszenia') + el(pl, 'Oczep zadaszenia')
Testy.rowne(pp.length, 3, 'płatwie zadaszenia: przy ścianie, pośrednia, oczep (rozstaw 1000)')
Testy.sprawdz(pp.all? { |e| e[:tag] == :zadaszenie && e[:prefiks] == 'P' }, 'płatwie zadaszenia – P w grupie Zadaszenie')
przy = pp.max_by { |e| zakres(e, 1)[1] }
Testy.rowne(zakres(przy, 1)[1], 0.0, 'płatew przy ścianie dotyka lica ściany', 0.01)
Testy.sprawdz(!(przy[:wreby] || []).empty?, 'płatew przy ścianie z wrębami w ostatkach ścian szczytowych')
oczep = el(pl, 'Oczep zadaszenia').first
Testy.rowne(zakres(oczep, 1)[0], -2000.0, 'oczep licem w linii podpory', 0.01)
Testy.rowne(zakres(oczep, 0), [-500.0, 6500.0], 'oczep na długość płatwi dachu (wysunięcie za szczyt)', 0.01)
slupy = el(pl, 'Słup zadaszenia')
Testy.rowne(slupy.length, 4, 'słupy co ≤ 2500: cztery na 6 m')
Testy.sprawdz(slupy.all? { |e| (zakres(e, 1)[0] + 2000.0).abs < 0.01 }, 'słupy licem w linii podpory')
belki = el(pl, 'Belka poprzeczna zadaszenia')
Testy.rowne(belki.length, 4, 'belka poprzeczna na każdym słupie')
Testy.sprawdz(belki.all? { |e| (zakres(e, 2)[1] - zakres(oczep, 2)[0]).abs < 0.01 }, 'oczep leży na belkach poprzecznych')
Testy.sprawdz(belki.zip(slupy.sort_by { |e| zakres(e, 0)[0] }).all? { |b, s| (zakres(b, 2)[0] - zakres(s, 2)[1]).abs < 0.01 },
              'belka leży na słupie')
skrajne = belki.select { |e| zakres(e, 0).inject(:+) / 2.0 < 100.0 || zakres(e, 0).inject(:+) / 2.0 > 5900.0 }
Testy.sprawdz(skrajne.length == 2 && skrajne.all? { |e| (zakres(e, 1)[1] + p['ostatek'].to_f + t / 2.0 - t / 2.0).abs < 0.01 },
              'skrajne belki do końca ostatków ścian szczytowych')
srodkowe = belki - skrajne
Testy.sprawdz(srodkowe.all? { |e| zakres(e, 1)[1].abs < 0.01 }, 'pośrednie belki do lica ściany')
slupki = el(pl, 'Słupek zadaszenia')
Testy.rowne(slupki.length, 6, 'słupki: pod płatwią pośrednią na 4 belkach, pod płatwią przy ścianie na 2 pośrednich')
fund = el(pl, 'Fundament słupa zadaszenia')
Testy.rowne(fund.length, 4, 'fundament pod każdym słupem')
Testy.sprawdz(fund.all? { |e| (zakres(e, 2)[1] - zakres(slupy.first, 2)[0]).abs < 0.01 }, 'słup stoi na fundamencie')
Testy.rowne(Zadaszenie.z_podstawy(p), -Parametry.przekroj(p, 'podwalina_przekroj')[1], 'podstawa słupów – spód podwaliny')
problemy, = LosoweDomy.sprawdz({ segmenty: prostokat(0, 0, 6000, 4000), parametry: par, otwory: [] })
Testy.sprawdz(problemy.empty?, "dom z wiatą bez kolizji, bryły zamknięte (#{problemy.first(3).join('; ')})")

Testy.grupa('Wiata – węgieł na ścianie omijany przez belkę')
par_w = par.merge('wegly_srodek' => 'wszystkie', 'wegly_srodek_min' => 3000, 'zadaszenie_slupy_rozstaw' => 3100)
pl_w = plan_pelny(prostokat(0, 0, 6200, 4000), par_w)
srodek = el(pl_w, 'Belka poprzeczna zadaszenia').map { |e| zakres(e, 0).inject(:+) / 2.0 }.sort
Testy.rowne(srodek.length, 3, 'trzy linie słupów')
bb_w = Parametry.przekroj(pl_w[:parametry], 'zadaszenie_belka_przekroj')[0]
Testy.sprawdz((srodek[1] - 3100.0).abs > t / 2.0 + bb_w / 2.0 + 5.0, "linia środkowa przesunięta obok węgła (#{srodek[1].round}, belka #{bb_w.round})")
problemy, = LosoweDomy.sprawdz({ segmenty: prostokat(0, 0, 6200, 4000), parametry: par_w, otwory: [] })
Testy.sprawdz(problemy.empty?, "bez kolizji (#{problemy.first(3).join('; ')})")

Testy.grupa('Wiata – połacie z załamaniem dla aplikacji do dachów')
pol = pl[:polacie]
Testy.rowne(pol[:zalamania].keys, [1], 'załamanie na krawędzi 1 (y = 0)')
z = pol[:zalamania][1]
Testy.rowne([z[:od].abs, z[:szerokosc], z[:okap], z[:kat]], [0.0, 2000.0, 300.0, 12.0], 'od, szerokość, okap, kąt')
Testy.rowne(z_polaci(pol, 3000.0, -1500.0), zk - 1500.0 * TG12 + Dach.uniesienie_krokwi(p), 'połać zadaszenia w płaszczyźnie z generatora', 0.001)
Testy.sprawdz(LosoweDomy.podpory_poza(pl).empty?, 'podpory w granicy aplikacji (także płatwie zadaszenia)')
Testy.rowne(Krok2.podpory(pl).length, pl[:elementy].count { |e| e[:prefiks] == 'P' }, 'płatwie zadaszenia jako podpory')

# --- przybudówka z bali ---------------------------------------------------------------------------------------------
Testy.grupa('Przybudówka z bali – obrys, role ścian, szczyty')
par_b = { 'zadaszenie' => 'bale', 'zadaszenie_strona' => 'obie', 'dach_kat' => 30, 'liczba_wiencow' => 14, 'podloga' => 'nie' }
pl_b = plan_pelny(prostokat(0, 0, 6000, 4000), par_b)
p_b = pl_b[:parametry]
Testy.sprawdz(pl_b[:bledy].empty?, 'plan bez błędów')
ys = pl_b[:obrys].map { |q| q[1] }.minmax
Testy.rowne(ys, [-2000.0, 6000.0], 'obrys poszerzony o przybudówki po obu stronach')
Testy.rowne(pl_b[:os_kalenicy], :x, 'kalenica jak w domu (wzdłuż dłuższego boku domu)')
dom_w = pl_b[:sciany].select { |w| Zadaszenie.rola(w) == :dom }
przy_w = pl_b[:sciany].select { |w| Zadaszenie.rola(w) == :przybudowka }
Testy.rowne([dom_w.length, przy_w.length], [2, 2], 'dawne ściany okapowe (działowe) i ściany przybudówek')
Testy.sprawdz(dom_w.all? { |w| w[:rodzaj] == :dzialowa && w[:szczyt].nil? }, 'dawna ściana okapowa – działowa bez szczytu')
Testy.rowne(dom_w.map { |w| Wience.wysokosc(w, p_b) }.uniq, [Wience.wysokosci(p_b)[:okapowa]], 'dawna ściana okapowa – wysokość ściany okapowej')
gabl = pl_b[:sciany].find { |w| w[:rodzaj] == :zewnetrzna && w[:kierunek] == :B }
Testy.rowne(Szczyty.zalom(gabl, p_b).length, 3, 'szczyt z dwoma załamaniami i kalenicą')
Testy.rowne([gabl[:szczyt][:v_a], gabl[:szczyt][:v_b]], [t / 2.0, 4000.0 - t / 2.0], 'dach liczony od osi ścian okapowych domu')
przy_w.each do |w|
  g = w[:szczyt]
  Testy.sprawdz(g && g[:plaski] && g[:przybudowka], "#{w[:id]}: szczyt płaski do połaci zadaszenia")
  gora = w[:bale].map { |b| b[:z0] + b[:h] }.max
  Testy.sprawdz(gora < Wience.wysokosci(p_b)[:okapowa] - 200.0, "#{w[:id]}: ściana przybudówki niższa (#{gora.round})")
  Testy.sprawdz(w[:bale].any? { |b| b[:cechy].any? { |x| x[:typ] == 'sciecie_dachu' } }, "#{w[:id]}: górny bal ścięty do połaci")
end
Testy.rowne(el(pl_b, 'Płatew zadaszenia').length, 6, 'płatwie zadaszenia: przy działowej, pośrednia, przy ścianie przybudówki (×2)')
Testy.rowne(el(pl_b, 'Słup zadaszenia').length, 0, 'bez słupów')
problemy, = LosoweDomy.sprawdz({ segmenty: prostokat(0, 0, 6000, 4000), parametry: par_b, otwory: [] })
Testy.sprawdz(problemy.empty?, "dom z przybudówkami bez kolizji (#{problemy.first(3).join('; ')})")
nosne = Krok2.sciany_wysokie(pl_b[:sciany], p_b.merge('platwa_na_scianie' => 'nie'))
Testy.sprawdz(nosne.empty? || nosne.all? { |q| q[:nazwa] =~ /Ściana (okapowa|przybudówki|wysoka)/ }, 'podpory ze ścian przybudówki nazwane')
pl_n = plan_pelny(prostokat(0, 0, 6000, 4000), par_b.merge('platwa_na_scianie' => 'nie'))
nazwy = Krok2.podpory(pl_n).map { |q| q[:nazwa] }
Testy.sprawdz(nazwy.count { |n| n.start_with?('Ściana okapowa') } == 2 && nazwy.count { |n| n.start_with?('Ściana przybudówki') } == 2,
              "ściana nośna: dawne ściany okapowe i ściany przybudówek podpierają połacie (#{nazwy.inspect})")
problemy, = LosoweDomy.sprawdz({ segmenty: prostokat(0, 0, 6000, 4000), parametry: par_b.merge('platwa_na_scianie' => 'nie'), otwory: [] })
Testy.sprawdz(problemy.empty?, "przybudówka ze ścianą nośną bez kolizji (#{problemy.first(3).join('; ')})")

# --- krokwie z generatora ----------------------------------------------------------------------------------------------
Testy.grupa('Krokwie zadaszenia z generatora')
pl_k = plan_pelny(prostokat(0, 0, 6000, 4000), par.merge('dach_uklad' => 'krokwie', 'dach_wiezba' => 'generator'))
k = pl_k[:elementy].select { |e| e[:prefiks] == 'K' }
nach = k.map { |e| (Math.atan2(e[:polozenie][:x][2], Math.hypot(e[:polozenie][:x][0], e[:polozenie][:x][1])) * 180.0 / Math::PI).round(3) }
Testy.rowne(nach.uniq.sort, [12.0, 30.0], 'krokwie dachu 30° i zadaszenia 12°')
Testy.rowne(nach.count(12.0), nach.count(30.0) / 2, 'krokiew zadaszenia przy każdej krokwi strony z zadaszeniem')
Testy.sprawdz(pl_k[:polacie].nil?, 'krokwie z generatora – bez połaci dla aplikacji')

# --- przeszkody ------------------------------------------------------------------------------------------------------
Testy.grupa('Przeszkody – kąt, taras, dach jednospadowy')
[[{ 'zadaszenie_kat' => 30 }, /musi być mniejszy niż kąt dachu/],
 [{ 'taras' => 'sciany' }, /z tarasem/],
 [{ 'dach_rodzaj' => 'jednospadowy' }, /dwuspadowym/]].each do |zm, wzor|
  %w[slupy bale].each do |war|
    pl_x = plan_pelny(prostokat(0, 0, 6000, 4000), par.merge('zadaszenie' => war).merge(zm))
    Testy.sprawdz(pl_x[:bledy].empty? && pl_x[:ostrzezenia].any? { |u| u =~ wzor }, "#{war} #{zm.inspect}: ostrzeżenie")
    Testy.sprawdz(pl_x[:elementy].none? { |e| e[:tag] == :zadaszenie } && (pl_x[:polacie].nil? || pl_x[:polacie][:zalamania].nil?),
                  "#{war} #{zm.inspect}: bez zadaszenia")
    Testy.rowne(pl_x[:obrys].map { |q| q[1] }.minmax, [0.0, 4000.0], "#{war} #{zm.inspect}: obrys domu") if zm.key?('zadaszenie_kat')
  end
end
pod = plan_pelny(prostokat(0, 0, 6000, 4000), par.merge('zadaszenie_kat' => 30))[:podpowiedzi].select { |h| h[:sekcja] == 'zadaszenie' }
Testy.sprawdz(pod.any? { |h| h[:poziom] == 'uwaga' }, 'podpowiedź w sekcji zadaszenia')
pod = pl[:podpowiedzi].select { |h| h[:sekcja] == 'zadaszenie' }
Testy.sprawdz(pod.any? { |h| h[:tekst].include?('prześwit') }, 'podpowiedź: prześwit pod belkami')
Testy.sprawdz(StatykaDachu.platwie(Szczyty.przygotuj(pl[:sciany], p, pl[:os_kalenicy])[:dom], p).length == 5,
              'statyka płatwi dachu bez płatwi zadaszenia')

# --- model (atrapa) --------------------------------------------------------------------------------------------------
Testy.grupa('Model – załamanie przekazane aplikacji do dachów')
Sketchup.model = Sketchup::Model.new
model = Sketchup.active_model
dom = model.entities.add_group
dom.set_attribute(Atrybuty::DICT_GW, 'dom', 'GW-zad')
AtrapaDachow.wyczysc
grupa, info = DachAplikacja.nowe_polacie(model, dom, pol, Krok2.podpory(pl))
Testy.sprawdz(grupa.nil? && info['tekst'] =~ /3\.12\.0 lub nowszej/, 'aplikacja 3.7.0 – komunikat, bez połaci')
module ArteMadera
  module Roof
    module API
      def self.wersja_wtyczki
        '3.12.0'
      end
    end
  end
end
grupa, info = DachAplikacja.nowe_polacie(model, dom, pol, Krok2.podpory(pl))
Testy.sprawdz(!grupa.nil?, "aplikacja 3.12 – połacie (#{info.inspect})")
opc = AtrapaDachow.ostatnie(:polacie)[6]
Testy.rowne(opc[:zalamania], pol[:zalamania], 'opcja :zalamania w wywołaniu API.polacie')
Testy.rowne(opc[:operacja], false, 'w operacji budowy domu')

Testy.koniec
