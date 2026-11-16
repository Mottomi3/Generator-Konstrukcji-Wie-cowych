# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_statyka_dachu.rb
# Zadanie: testy sprawdzenia płatwi i trójkąta nad tarasem (śnieg, pas dachu, przęsła), automatycznego doboru ich przekroju i trójkąta w wąskim domu.
# Tematy: testy statyki dachu, dobór przekroju płatwi w testach, dobór trójkąta nad tarasem w testach, trójkąt w wąskim domu w testach
# Zależy od: testy/pomoc.rb, testy/losowe_domy.rb (sprawdzenie domu)
# Używają: testy/uruchom.sh

require File.expand_path('pomoc', File.dirname(__FILE__))
require File.expand_path('losowe_domy', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

# Podpowiedzi planu zaczynające się od słowa (Płatwie / Płatew / Trójkąt): [[poziom, tekst]].
def podpowiedzi(pl, slowo)
  pl[:podpowiedzi].select { |h| h[:tekst].start_with?(slowo) }.map { |h| [h[:poziom], h[:tekst]] }
end

# Elementy planu o prefiksie.
def belki(pl, prefiks)
  pl[:elementy].select { |e| e[:prefiks] == prefiks }
end

BAZA = { 'dach_kat' => 30, 'platwa_przekroj' => '60x200', 'platwie_rozstaw_max' => 900, 'platwa_na_scianie' => 'nie',
         'liczba_wiencow' => 16 }.freeze

Testy.grupa('Obciążenia płatwi – śnieg, pas dachu, przęsło między ścianami')
Testy.rowne([20.0, 30.0, 45.0, 60.0].map { |k| StatykaDachu.mi(k).round(3) }, [0.8, 0.8, 0.4, 0.0], 'współczynnik kształtu dachu dla śniegu')
pl = plan_pelny(prostokat(0, 0, 6000, 4000), BAZA)
p = pl[:parametry]
st = pl[:platwie_statyka]
Testy.rowne([st.length, st.map { |x| x[:l].round }.uniq], [5, [5956]], 'dom 6 × 4 m: 5 płatwi o przęśle między szczytami (osie ścian)')
Testy.sprawdz(st.all? { |x| x[:pas] > 600.0 && x[:pas] < 700.0 }, "pas dachu na płatew – po połowie odległości do sąsiednich (#{st.map { |x| x[:pas].round }.inspect})")
Testy.sprawdz((st.inject(0.0) { |s, x| s + x[:pas] } - 3260.0).abs < 5.0,
              'pasy płatwi razem: 3912 między licami ścian okapowych bez połówek skrajnych pól (te niosą ściany)')
g, q = StatykaDachu.obciazenia(1000.0, p)
Testy.rowne([g.round(4), q.round(4)], [(0.35 / Math.cos(Math::PI / 6)).round(4), 0.72], 'na metr płatwi przy pasie 1 m: pokrycie 0,35 / cos 30°, śnieg 0,8 × 0,9')
Testy.rowne([StatykaDachu.wysokosc(60.0, 200.0, 'posrednia', p).round(1), StatykaDachu.wysokosc(60.0, 200.0, 'kalenicowa', p).round(1)],
            [(200.0 - 30.0 * Math.tan(Math::PI / 6)).round(1), (200.0 - 15.0 * Math.tan(Math::PI / 6)).round(1)],
            'wysokość do obliczeń – średnia płatwi ściętej do dachu')
h = podpowiedzi(pl, 'Płatwie')
Testy.sprawdz(h.length == 1 && h[0][0] == 'uwaga' && h[0][1].include?('60 × 200') && h[0][1].include?('z listy wystarczy 60 × 240'),
              "ręcznie: 60 × 200 na 6 m – za słaby, z podpowiedzią przekroju (#{h.inspect})")
pl = plan_pelny(prostokat(0, 0, 6000, 4000) + [[[3000, 0], [3000, 4000]]], BAZA.merge('szczyty_na_dzialowych' => 'tak'))
Testy.rowne(pl[:platwie_statyka].map { |x| x[:l].round }.uniq, [2978], 'działowa ze szczytem w połowie – przęsło o połowę krótsze')
h = podpowiedzi(pl, 'Płatwie')
Testy.sprawdz(h[0][0] == 'ok' && h[0][1].include?('najmniejszy wystarczający z listy: 60 × 140'), "ręcznie: wystarczy, z najmniejszym wystarczającym (#{h.inspect})")
pl = plan_pelny(prostokat(0, 0, 6000, 4000) + [[[0, 2000], [6000, 2000]]], BAZA)
kal = pl[:platwie_statyka].find { |x| x[:rodzaj] == 'kalenicowa' }
Testy.rowne(kal[:l].round, 1044, 'płatew kalenicowa na działowej wzdłuż kalenicy – liczą się tylko końce za szczytami (2 × 522)')

Testy.grupa('Automatyczny dobór przekroju płatwi')
d = { segmenty: prostokat(0, 0, 6000, 4000), otwory: [], parametry: BAZA.merge('platwie_dobor' => 'auto') }
problemy, pl = LosoweDomy.sprawdz(d)
p = pl[:parametry]
Testy.rowne([problemy, p['platwa_przekroj']], [[], '60x240'], 'dom 6 × 4 m: dobrane 60 × 240, dom bez problemów')
Testy.rowne(belki(pl, 'P').map { |e| [e[:b], e[:h]] }.uniq, [[60.0, 240.0]], 'płatwie w modelu mają dobrany przekrój')
gr = StatykaDachu.grupy(pl[:platwie_statyka], p)['platwa_przekroj']
lzejsze = StatykaDachu.kandydaci(p).take_while { |bh| bh != [60.0, 240.0] }
Testy.sprawdz(StatykaDachu.ocena(gr, 60.0, 240.0, p)[:ok] && lzejsze.none? { |b, h| StatykaDachu.ocena(gr, b, h, p)[:ok] },
              'dobrany wystarcza, żaden lżejszy z listy nie wystarcza')
h = podpowiedzi(pl, 'Płatwie')
Testy.sprawdz(h.length == 1 && h[0][0] == 'ok' && h[0][1].include?('dobrane automatycznie'), "podpowiedź o doborze (#{h.inspect})")
maly = plan_pelny(prostokat(0, 0, 3000, 2500), BAZA.merge('platwie_dobor' => 'auto'))
Testy.sprawdz(Parametry.przekroj(maly[:parametry], 'platwa_przekroj')[1] < 200.0, "domek 3 × 2,5 m – płatwie mniejsze niż 200 (#{maly[:parametry]['platwa_przekroj']})")
dlugi = plan_pelny(prostokat(0, 0, 12_000, 5000), BAZA.merge('platwie_dobor' => 'auto'))
h = podpowiedzi(dlugi, 'Płatwie')
Testy.sprawdz(dlugi[:parametry]['platwa_przekroj'] == '160x280' && h[0][0] == 'uwaga' && h[0][1].include?('żaden przekrój z listy nie wystarcza'),
              "12 m bez podpór: największy z listy i uwaga, żeby dodać podporę (#{h.inspect})")
osobne = plan_pelny(prostokat(0, 0, 6000, 4000), BAZA.merge('platwie_dobor' => 'auto', 'platwie_jeden_przekroj' => 'nie', 'platwa_na_scianie' => 'tak'))
po = osobne[:parametry]
Testy.rowne([po['platwa_przekroj'], po['platwa_kalenicowa_przekroj'], podpowiedzi(osobne, 'Płat').length], ['60x240', '60x240', 3],
            'osobne przekroje: pośrednie i kalenicowa dobrane osobno, trzy podpowiedzi')
Testy.sprawdz(Parametry.przekroj(po, 'platwa_scienna_przekroj')[1] < 240.0, "płatew ścienna przy ścianie – mniejsza (#{po['platwa_scienna_przekroj']})")
snieg = plan_pelny(prostokat(0, 0, 5000, 4000), BAZA.merge('platwie_dobor' => 'auto', 'dach_snieg' => 2.0))
lekki = plan_pelny(prostokat(0, 0, 5000, 4000), BAZA.merge('platwie_dobor' => 'auto', 'dach_snieg' => 0.7))
pole = lambda { |x| Parametry.przekroj(x[:parametry], 'platwa_przekroj').inject(:*) }
Testy.sprawdz(pole.call(snieg) > pole.call(lekki), "większy śnieg – większy przekrój (#{lekki[:parametry]['platwa_przekroj']} → #{snieg[:parametry]['platwa_przekroj']})")
reczny = plan_pelny(prostokat(0, 0, 6000, 4000), BAZA)
Testy.rowne(reczny[:parametry]['platwa_przekroj'], '60x200', 'dobór ręczny – przekrój z pola bez zmian')

Testy.grupa('Trójkąt nad tarasem – wąski dom i dobór automatyczny')
taras = BAZA.merge('taras' => 'podciag', 'taras_glebokosc' => 2000, 'taras_szczyt' => 'pusty', 'taras_wience_gorne' => 1, 'taras_szczyt_bale' => 0)
d = { segmenty: prostokat(0, 0, 5000, 2000), otwory: [], parametry: taras }
problemy, pl = LosoweDomy.sprawdz(d)
Testy.rowne([problemy, belki(pl, 'Wt').length], [[], 2], 'dom 2 m, trójkąt z płatwi 60 × 200: nie znika – dwie krokwie na balach frontu, bez problemów')
Testy.rowne(pl[:ostrzezenia].grep(/Trójkąt nad tarasem bez belki dolnej/).length, 1, 'ostrzeżenie: przekrój za wysoki, bez belki dolnej')
front = pl[:sciany].find { |w| Taras.front?(w) }
Testy.rowne(TarasWiazar.postac(TarasWiazar.uklad(front, pl[:parametry])), :krokwie, 'postać uproszczona – same krokwie')
h = podpowiedzi(pl, 'Trójkąt')
Testy.sprawdz(h.length == 1 && h[0][0] == 'ok' && h[0][1].include?('najmniejszy wystarczający z listy: 60 × 100'), "sprawdzenie trójkąta z podpowiedzią mniejszego (#{h.inspect})")
problemy, pl = LosoweDomy.sprawdz(d.merge(parametry: taras.merge('taras_wieniec' => 'auto')))
front = pl[:sciany].find { |w| Taras.front?(w) }
u = TarasWiazar.uklad(front, pl[:parametry])
Testy.rowne([problemy, TarasWiazar.przekroj(pl[:parametry]), TarasWiazar.postac(u), belki(pl, 'Wt').length], [[], [60.0, 100.0], :pelny, 4],
            'dobór automatyczny: 60 × 100 – cały trójkąt (belka dolna, krokwie, słupek), bez problemów')
Testy.rowne(pl[:ostrzezenia].grep(/Trójkąt/), [], 'bez ostrzeżeń o trójkącie')
h = podpowiedzi(pl, 'Trójkąt')
Testy.sprawdz(h[0][0] == 'ok' && h[0][1].include?('dobrany automatycznie'), "podpowiedź o doborze trójkąta (#{h.inspect})")
Testy.rowne(pl[:parametry]['platwa_przekroj'], '60x200', 'płatwie zostają z pola (dobór tylko trójkąta)')
problemy, pl = LosoweDomy.sprawdz(d.merge(segmenty: prostokat(0, 0, 5000, 5000), parametry: taras.merge('taras_wieniec' => 'auto', 'kalenica' => 'x')))
bh = TarasWiazar.przekroj(pl[:parametry])
front = pl[:sciany].find { |w| Taras.front?(w) }
Testy.sprawdz(problemy.empty? && bh[1] > 100.0 && bh[1] < 200.0, "dom 5 m: trójkąt większy niż w wąskim domu, mniejszy niż płatew (#{bh.inspect}, #{problemy.inspect})")
Testy.sprawdz(StatykaWiazara.miesci_sie?(front, bh, pl[:parametry]), 'dobrany przekrój mieści cały trójkąt')
oba = plan_pelny(prostokat(0, 0, 5000, 4000), taras.merge('taras_wieniec' => 'auto', 'platwie_dobor' => 'auto'))
Testy.sprawdz(podpowiedzi(oba, 'Płatwie')[0][1].include?('dobrane automatycznie') && podpowiedzi(oba, 'Trójkąt')[0][1].include?('dobrany automatycznie'),
              'dobór płatwi i trójkąta naraz')
kr = StatykaWiazara.krokiew([{ v: 1000.0, rodzaj: 'posrednia', g: 1.0, q: 2.0 }, { v: 2000.0, rodzaj: 'kalenicowa', g: 5.0, q: 5.0 }], 0.0, 2000.0)
Testy.rowne([kr[:a], kr[:obc].map { |x| x.round(4) }, kr[:szczyt]], [2000.0, [1.0, 2.0], [0.5, 1.0]],
            'krokiew z siłą w połowie: obciążenie równoważne 2P / a, połowa siły na słupek; kalenicowa nie zgina krokwi')
na_slupach = taras.merge('taras_wieniec' => 'auto', 'taras_wiazar_podparcie' => 'slupy', 'taras_wejscie' => 'srodek')
pl = plan_pelny(prostokat(0, 0, 5000, 4000), na_slupach)
front = pl[:sciany].find { |w| Taras.front?(w) }
u = TarasWiazar.uklad(front, pl[:parametry])
sily = [{ v: 2000.0, rodzaj: 'kalenicowa', g: 1.0, q: 2.0 }]
krokwie = [u[:geo][:v_a], u[:geo][:v_b]].map { |v| StatykaWiazara.krokiew(sily, v, u[:vk]) }
dolna = StatykaWiazara.belka_na_slupach(front, u, sily, krokwie, pl[:parametry])
Testy.sprawdz(dolna && (dolna[0] - 1320.0).abs < 0.01 && (dolna[1][0] - 2.0 * 1.0 / 1.32).abs < 0.001,
              "trójkąt na słupach, wejście pośrodku: belka dolna 1320 między słupami wejścia pod siłą słupka (#{dolna.inspect})")
pl = plan_pelny(prostokat(0, 0, 5000, 4000), na_slupach.merge('taras_wejscie' => 'brak'))
front = pl[:sciany].find { |w| Taras.front?(w) }
Testy.rowne(StatykaWiazara.belka_na_slupach(front, TarasWiazar.uklad(front, pl[:parametry]), sily, krokwie, pl[:parametry]), nil,
            'słup w osi kalenicy pod słupkiem trójkąta – belka dolna bez zginania')
Testy.rowne(Statyka.belka(4000.0, 60.0, 200.0, 0.3, 0.6, 'C24', 200.0, 0.0)[:u] < Statyka.belka(4000.0, 60.0, 200.0, 0.3, 0.6, 'C24', 200.0)[:u], true,
            'śnieg bez części długotrwałej – mniejsze ugięcie końcowe niż obciążenie użytkowe podłogi')

Testy.koniec
