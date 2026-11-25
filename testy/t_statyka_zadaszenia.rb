# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_statyka_zadaszenia.rb
# Zadanie: runda 13 – dobór przekrojów bocznego zadaszenia (płatwie z oczepem, belki poprzeczne, słupy – automatycznie albo z wyboru), słup z wyboczeniem, dobór krokwi całego dachu, podłoga w przybudówce do wyboru, parametry zadaszenia w osobnej zakładce okna.
# Tematy: testy statyki zadaszenia, testy doboru krokwi, testy słupa, testy podłogi w przybudówce, testy zakładki zadaszenia
# Zależy od: testy/pomoc.rb, testy/losowe_domy.rb (sprawdzenie domu), testy/atrapa/sketchup.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_statyka_zadaszenia.rb

require File.expand_path('atrapa/sketchup', File.dirname(__FILE__))
require File.expand_path('losowe_domy', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

# Plan domu z parametrami (pełny przebieg z doborem).
def plan(seg, par)
  Projekt.oblicz('segmenty' => seg, 'parametry' => par, 'otwory' => [])
end

# Podpowiedzi sekcji okna.
def podp(pl, sekcja)
  # Bez podpowiedzi o długościach handlowych (runda 14 – testy/t_dlugosci.rb): tu sprawdzane są wyniki statyki.
  pl[:podpowiedzi].select { |h| h[:sekcja] == sekcja && !h[:tekst].include?('najdłuższa belka tego przekroju') }
end

# Liczba po słowie (np. „przęsło 2.0 m”) z tekstu podpowiedzi.
def liczba_po(tekst, slowo)
  m = tekst.match(/#{slowo} (-?\d+(?:\.\d+)?)/)
  m ? m[1].to_f : nil
end

# Zakres elementu w osi k (wszystkie naroża prostopadłościanu) [min, max].
def zakres(e, k)
  pe = e[:polozenie]
  [0.0, e[:dl]].product([0.0, e[:b]], [0.0, e[:h]]).map do |x, y, z|
    pe[:poczatek][k] + pe[:x][k] * x + pe[:y][k] * y + pe[:z][k] * z
  end.minmax
end

DOM = prostokat(0, 0, 8000, 5000)
WIATA = { 'zadaszenie' => 'slupy', 'dach_kat' => 30 }.freeze

Testy.grupa('Słup – ściskanie z wyboczeniem')
r = StatykaSlupa.sprawdz(2500.0, 100.0, 100.0, 5.0, 5.0, 'C24')
Testy.rowne(r[:smuklosc], 2500.0 / (100.0 / Math.sqrt(12.0)), 'smukłość z mniejszego wymiaru', 0.01)
Testy.rowne(r[:kc], 0.3934, 'k_c (C24, smukłość 86,6)', 0.001)
Testy.rowne(r[:wyk], 0.283, 'wytężenie 100 × 100 / 2,5 m / 5 + 5 kN', 0.003)
Testy.sprawdz(r[:ok], 'słup wystarcza')
Testy.rowne(StatykaSlupa.wspolczynnik_kc(0.2, 0.2), 1.0, 'krótki słup – bez wyboczenia')
Testy.sprawdz(!StatykaSlupa.sprawdz(8000.0, 40.0, 40.0, 0.1, 0.1, 'C24')[:ok], 'smukłość ponad 150 – za słaby')
Testy.sprawdz(StatykaSlupa.sprawdz(2500.0, 100.0, 100.0, 5.0, 5.0, 'GL24h')[:wyk] < r[:wyk], 'klejone – mniejsze wytężenie')

Testy.grupa('Zadaszenie na słupach – dobór automatyczny')
pl = plan(DOM, WIATA)
p = pl[:parametry]
Testy.sprawdz(pl[:bledy].empty?, 'plan bez błędów')
pz = podp(pl, 'zadaszenie_przekroje')
Testy.rowne(pz.length, 3, 'trzy grupy: płatwie, belki, słupy')
Testy.sprawdz(pz.all? { |h| h[:poziom] == 'ok' && h[:tekst].include?('dobrane automatycznie') }, 'wszystkie dobrane automatycznie')
%w[zadaszenie_platwa_przekroj zadaszenie_belka_przekroj].each do |k|
  Testy.sprawdz(Parametry.katalog(p, 'zadaszenie_katalog').include?(Parametry.przekroj(p, k)), "#{k} z listy belek (#{p[k]})")
end
Testy.sprawdz(Parametry.katalog(p, 'zadaszenie_slupy_katalog').include?(Parametry.przekroj(p, 'zadaszenie_slup_przekroj')),
              "słup z listy słupów (#{p['zadaszenie_slup_przekroj']})")
pt = pz.find { |h| h[:tekst].start_with?('Płatwie') }[:tekst]
Testy.rowne(liczba_po(pt, 'przęsło'), 2.0, 'przęsło płatwi = rozstaw słupów (8 m / 4)', 0.05)
Testy.rowne(liczba_po(pt, 'pas'), 1.0, 'pas połaci płatwi zadaszenia', 0.15)
bt = pz.find { |h| h[:tekst].start_with?('Belki') }[:tekst]
Testy.rowne(liczba_po(bt, 'pas'), 2.0, 'belka niesie pas między słupami', 0.05)
st = pz.find { |h| h[:tekst].start_with?('Słupy') }[:tekst]
Testy.sprawdz(liczba_po(st, 'siła').to_f > 1.0 && liczba_po(st, 'wysokość').to_f > 1.0, "słup: wysokość i siła (#{st})")
slupy = pl[:elementy].select { |e| e[:rodzaj] == 'Słup zadaszenia' }
Testy.rowne(slupy.map { |e| [e[:b], e[:h]].sort }.uniq, [Parametry.przekroj(p, 'zadaszenie_slup_przekroj').sort], 'słupy w modelu z dobranego przekroju')
# Najlżejszy: przekrój o jeden lżejszy z listy podany ręcznie – za słaby.
lista = Parametry.katalog(p, 'zadaszenie_katalog').sort_by { |b, h| [b * h, -h] }
i = lista.index(Parametry.przekroj(p, 'zadaszenie_belka_przekroj'))
if i && i > 0
  pr = plan(DOM, WIATA.merge('zadaszenie_dobor' => 'reczny', 'zadaszenie_belka_przekroj' => Parametry.tekst_przekroju(lista[i - 1])))
  h = podp(pr, 'zadaszenie_przekroje').find { |x| x[:tekst].start_with?('Belki') }
  Testy.sprawdz(h && h[:poziom] == 'uwaga', "lżejsza belka z listy (#{Parametry.tekst_przekroju(lista[i - 1])}) – za słaba")
else
  Testy.sprawdz(i == 0, 'dobrana belka – najlżejsza z listy')
end
problemy, = LosoweDomy.sprawdz({ segmenty: DOM, parametry: WIATA, otwory: [] })
Testy.sprawdz(problemy.empty?, "bez kolizji (#{problemy.first(3).join('; ')})")

Testy.grupa('Zadaszenie – przekroje z wyboru (sprawdzenie)')
pr = plan(DOM, WIATA.merge('zadaszenie_dobor' => 'reczny', 'zadaszenie_platwa_przekroj' => '40x60', 'zadaszenie_slup_przekroj' => '60x60'))
Testy.rowne(pr[:parametry]['zadaszenie_platwa_przekroj'], '40x60', 'przekrój użytkownika bez zmian')
h = podp(pr, 'zadaszenie_przekroje').find { |x| x[:tekst].start_with?('Płatwie') }
Testy.sprawdz(h[:poziom] == 'uwaga' && h[:tekst] =~ /z listy wystarczy \d+ × \d+ \(albo dobór automatyczny\)/, "za słaba płatew – rada (#{h[:tekst]})")
pr = plan(DOM, WIATA.merge('zadaszenie_dobor' => 'reczny'))
Testy.sprawdz(podp(pr, 'zadaszenie_przekroje').all? { |x| x[:poziom] == 'ok' && x[:tekst].include?('wystarczy') },
              'przekroje fabryczne 80 × 160, 120 × 120 – wystarczą')
Testy.rowne(Parametry.przekroj(pr[:parametry], 'zadaszenie_platwa_przekroj'), [80.0, 160.0], 'fabryczny przekrój płatwi zadaszenia')

Testy.grupa('Przybudówka – płatwie między ścianami szczytowymi')
pb = plan(DOM, { 'zadaszenie' => 'bale', 'dach_kat' => 30, 'zadaszenie_strona' => 'obie' })
hb = podp(pb, 'zadaszenie_przekroje')
Testy.rowne(hb.length, 1, 'tylko płatwie (bez słupów i belek)')
Testy.rowne(liczba_po(hb[0][:tekst], 'przęsło'), 8.0, 'przęsło – długość domu między ścianami szczytowymi', 0.06)
Testy.sprawdz(hb[0][:poziom] == 'ok', 'dobrany przekrój wystarcza')

Testy.grupa('Krokwie – przęsło i dobór')
Testy.rowne(StatykaKrokwi.przeslo(0.0, 3000.0, [500.0, 1500.0, 3000.0]), 1500.0, 'największe przęsło między podporami')
Testy.rowne(StatykaKrokwi.przeslo(0.0, 3000.0, [1000.0, 3000.0]), 2000.0, 'wspornik okapu jako 2a')
Testy.rowne(StatykaKrokwi.przeslo(0.0, 3000.0, []), 3000.0, 'bez podpór – cała długość')
pk = plan(DOM, WIATA.merge('dach_uklad' => 'krokwie', 'krokwie_dobor' => 'auto', 'zadaszenie_szerokosc' => 3000))
k = pk[:parametry]['krokiew_przekroj']
Testy.sprawdz(Parametry.katalog(pk[:parametry], 'krokwie_katalog').include?(Parametry.przekroj(pk[:parametry], 'krokiew_przekroj')),
              "krokiew dobrana z listy (#{k})")
hk = podp(pk, 'szczyty').find { |x| x[:tekst].start_with?('Krokwie ') }
hz = podp(pk, 'zadaszenie_przekroje').find { |x| x[:tekst].start_with?('Krokwie zadaszenia') }
Testy.sprawdz(hk && hk[:tekst].include?('dobrane automatycznie'), 'podpowiedź krokwi dachu w „Szczyty i dach”')
Testy.sprawdz(hz && hz[:poziom] == 'ok', 'podpowiedź krokwi zadaszenia w zakładce zadaszenia')
Testy.rowne(liczba_po(hk[:tekst], 'przęsło'), 2.4, 'krokiew dachu: od płatwi ściennej do kalenicowej', 0.15)
Testy.rowne(liczba_po(hz[:tekst], 'przęsło'), 2.9, 'krokiew zadaszenia: od płatwi przy ścianie do oczepu', 0.15)
krok = pk[:elementy].select { |e| e[:prefiks] == 'K' }
Testy.sprawdz(krok.empty?, 'krokwie z aplikacji do dachów – w modelu generatora ich nie ma')
pg = plan(DOM, WIATA.merge('dach_uklad' => 'krokwie', 'krokwie_dobor' => 'auto', 'dach_wiezba' => 'generator'))
bh = Parametry.przekroj(pg[:parametry], 'krokiew_przekroj')
krok = pg[:elementy].select { |e| e[:prefiks] == 'K' }
Testy.sprawdz(!krok.empty? && krok.all? { |e| [e[:b], e[:h]] == bh }, "krokwie generatora (dach i zadaszenie) z dobranego przekroju #{bh.inspect}")
problemy, = LosoweDomy.sprawdz({ segmenty: DOM, parametry: WIATA.merge('dach_uklad' => 'krokwie', 'krokwie_dobor' => 'auto', 'dach_wiezba' => 'generator'), otwory: [] })
Testy.sprawdz(problemy.empty?, "krokwie dobrane – bez kolizji (#{problemy.first(3).join('; ')})")
pr = plan(DOM, { 'dach_uklad' => 'krokwie', 'krokiew_przekroj' => '40x80' })
h = podp(pr, 'szczyty').find { |x| x[:tekst].start_with?('Krokwie ') }
Testy.sprawdz(h && h[:poziom] == 'uwaga' && h[:tekst].include?('za słaba'), 'krokiew 40 × 80 z wyboru – za słaba')
Testy.sprawdz(podp(pr, 'zadaszenie_przekroje').empty?, 'bez zadaszenia – nic w zakładce zadaszenia')
Testy.sprawdz(podp(plan(DOM, {}), 'szczyty').none? { |x| x[:tekst].start_with?('Krokwie') }, 'same płatwie – bez krokwi')

Testy.grupa('Przybudówka – podłoga do wyboru')
%w[krotszy dluzszy].each do |kier|
  par = { 'zadaszenie' => 'bale', 'dach_kat' => 30, 'zadaszenie_strona' => 'obie', 'legary_kierunek' => kier, 'podciagi' => 'tak' }
  bez = plan(DOM, par.merge('zadaszenie_podloga' => 'nie'))
  z = plan(DOM, par)
  w_domu = lambda { |e| zakres(e, 1)[0] > -1.0 && zakres(e, 1)[1] < 5001.0 }
  Testy.sprawdz(bez[:elementy].select { |e| %w[L Pd].include?(e[:prefiks]) }.all?(&w_domu), "#{kier}: bez podłogi – legary i podciągi tylko w domu")
  Testy.sprawdz(z[:elementy].any? { |e| e[:prefiks] == 'L' && zakres(e, 1)[0] < -1000.0 }, "#{kier}: z podłogą – legary w przybudówce")
  pw = bez[:elementy].select { |e| e[:prefiks] == 'Pw' }
  Testy.sprawdz(pw.any? { |e| zakres(e, 1)[0] < -1999.0 && zakres(e, 1)[1] < -1800.0 }, "#{kier}: podwalina pod ścianą przybudówki")
  Testy.sprawdz(pw.any? { |e| zakres(e, 1)[0] < 1.0 && zakres(e, 1)[1] > 40.0 && zakres(e, 1)[1] < 80.0 }, "#{kier}: podwalina pod dawną ścianą okapową")
  f = bez[:elementy].select { |e| e[:prefiks] == 'F' }
  Testy.sprawdz(f.any? { |e| zakres(e, 1)[0] < -1999.0 }, "#{kier}: fundamenty pod ścianą przybudówki")
  Testy.sprawdz(f.none? { |e| zakres(e, 1)[0] > -1700.0 && zakres(e, 1)[1] < -300.0 && zakres(e, 0)[0] > 500.0 && zakres(e, 0)[1] < 7500.0 },
                "#{kier}: bez fundamentów w środku przybudówki")
  problemy, = LosoweDomy.sprawdz({ segmenty: DOM, parametry: par.merge('zadaszenie_podloga' => 'nie'), otwory: [] })
  Testy.sprawdz(problemy.empty?, "#{kier}: bez podłogi – bez kolizji (#{problemy.first(3).join('; ')})")
end
h = podp(plan(DOM, { 'zadaszenie' => 'bale', 'dach_kat' => 30, 'zadaszenie_podloga' => 'nie' }), 'zadaszenie')
Testy.sprawdz(h.any? { |x| x[:tekst].start_with?('Przybudówka bez podłogi') }, 'podpowiedź w zakładce zadaszenia')
pn = plan(DOM, { 'zadaszenie' => 'bale', 'dach_kat' => 30, 'podwaliny_pod_dzialowymi' => 'nie' })
Testy.sprawdz(pn[:elementy].any? { |e| e[:prefiks] == 'Pw' && zakres(e, 1)[0] < 1.0 && zakres(e, 1)[1] > 40.0 && zakres(e, 1)[1] < 80.0 },
              'dawna ściana okapowa na podwalinie także bez podwalin pod działowymi')

Testy.grupa('Zakładka zadaszenia w oknie')
sekcje = ParametryLista::SEKCJE
Testy.rowne(ParametryLista::ZAKLADKI.map(&:first), %w[dom zadaszenie], 'zakładki: dom i zadaszenie')
zad = sekcje.select { |s| s[3] == 'zadaszenie' }.map(&:first)
Testy.rowne(zad, %w[zadaszenie zadaszenie_przekroje], 'sekcje zakładki zadaszenia')
klucze = ParametryLista::LISTA.select { |w| w[:klucz].start_with?('zadaszenie') }
Testy.sprawdz(klucze.all? { |w| zad.include?(w[:sekcja]) }, 'wszystkie parametry zadaszenia w jego zakładce')
Testy.sprawdz(ParametryLista::LISTA.none? { |w| zad.include?(w[:sekcja]) && !w[:klucz].start_with?('zadaszenie') },
              'w zakładce zadaszenia tylko parametry zadaszenia')
Testy.rowne(ParametryLista::LISTA.find { |w| w[:klucz] == 'zadaszenie_dobor' }[:domyslna], 'auto', 'dobór zadaszenia – domyślnie automatyczny')

Testy.koniec
