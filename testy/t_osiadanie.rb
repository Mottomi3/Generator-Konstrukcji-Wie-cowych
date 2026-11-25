# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_osiadanie.rb
# Zadanie: testy słupów krótszych o osiadanie ścian (propozycja P1, runda 15) – luz osiadania, śruba regulacyjna albo podkładki, zamek górny po osiadaniu, wyłączenie, podpowiedź, brak kolizji.
# Tematy: testy osiadania słupów, test śruby regulacyjnej słupa, test luzu osiadania pod balem
# Zależy od: testy/pomoc.rb, testy/losowe_domy.rb, Plugins/.../rdzen/osiadanie.rb, rdzen/taras_slupy.rb
# Używają: testy/uruchom.sh
#
# Uruchomienie: ruby -I testy/atrapa testy/t_osiadanie.rb – ostatnia linia „FAILURES: n”.

require File.expand_path('losowe_domy', File.dirname(__FILE__))
include ArteMadera::GeneratorWiencowy

# Dom 6000 × 4000 z tarasem na słupach (typ 200).
TARAS = { 'taras' => 'podciag', 'taras_glebokosc' => 2000 }.freeze

# Słupy tarasu z planu.
def slupy_tarasu(pl)
  pl[:elementy].select { |e| e[:prefiks] == 'S' && e[:tag] == :taras }
end

# Wierzch pełnego przekroju słupa [mm nad poziomem 0]: początek wycięcia zamka górnego albo koniec słupa.
def wierzch_pelny(e)
  ld = -e[:polozenie][:poczatek][2]
  gorne = e[:cechy].select { |c| c[:x1] > e[:dl] - 0.01 && c[:x0] > ld + 500.0 }
  (gorne.empty? ? e[:dl] : gorne.map { |c| c[:x0] }.min) - ld
end

Testy.grupa('Luz osiadania: wysokość bali × osiadanie, w górę do milimetra')
p0 = Parametry.normalizuj({})[0]
Testy.rowne([p0['slup_osiadanie'], p0['slup_regulacja'], p0['slup_regulacja_wysokosc'], p0['osiadanie_scian']], ['tak', 'sruba', 40.0, 1.5],
            'wartości fabryczne: słupy krótsze, śruba 40 mm, osiadanie 1,5 %')
Testy.rowne([Osiadanie.luz(2224.0, p0), Osiadanie.luz(2000.0, p0), Osiadanie.luz(0.0, p0)], [34.0, 30.0, 0.0], 'luz: 2224 → 34, 2000 → 30, 0 → 0')
Testy.rowne(Osiadanie.slupa(2224.0, p0), { luz: 34.0, okucie: 40.0, razem: 74.0, regulacja: 'sruba' }, 'skrócenie ze śrubą: 34 + 40')
Testy.rowne(Osiadanie.slupa(2224.0, p0.merge('slup_regulacja' => 'podkladki')), { luz: 34.0, okucie: 0.0, razem: 34.0, regulacja: 'podkladki' },
            'skrócenie z podkładkami: sam luz')
Testy.rowne(Osiadanie.slupa(2224.0, p0.merge('slup_osiadanie' => 'nie')), nil, 'wyłączone – bez skrócenia')
Testy.rowne(Osiadanie.slupa(2224.0, p0.merge('osiadanie_scian' => 0, 'slup_regulacja' => 'podkladki')), nil, 'osiadanie 0 i podkładki – bez skrócenia')

Testy.grupa('Słupy tarasu krótsze o luz osiadania i śrubę regulacyjną')
pl = plan_pelny(prostokat(0, 0, 6000, 4000), TARAS)
p = pl[:parametry]
plb = plan_pelny(prostokat(0, 0, 6000, 4000), TARAS.merge('slup_osiadanie' => 'nie'))
sl = slupy_tarasu(pl)
slb = slupy_tarasu(plb)
front = pl[:sciany].find { |w| Taras.front?(w) }
z = front[:taras][:z_front]
luz = Osiadanie.luz(z, p)
Testy.sprawdz(sl.length >= 4 && sl.length == slb.length, "te same słupy (#{sl.length})")
Testy.sprawdz(sl.all? { |e| e[:osiadanie] && e[:osiadanie][:luz] == luz && e[:osiadanie][:okucie] == 40.0 }, "opis skrócenia w elemencie (luz #{luz.round})")
Testy.sprawdz(slb.none? { |e| e[:osiadanie] }, 'bez skracania – bez opisu')
Testy.rowne(sl.map { |e| wierzch_pelny(e).round(2) }.uniq, [(z - luz - 40.0).round(2)], 'wierzch pełnego przekroju: spód podciągu − luz − śruba')
Testy.rowne(slb.map { |e| wierzch_pelny(e).round(2) }.uniq, [z.round(2)], 'bez skracania: wierzch na spodzie podciągu (jak do kompilacji 14)')
z_zamkiem = sl.zip(slb).select { |_a, b| b[:dl] > wierzch_pelny(b) - b[:polozenie][:poczatek][2] + 1.0 }
Testy.sprawdz(!z_zamkiem.empty? && z_zamkiem.all? { |a, b| (b[:dl] - a[:dl] - luz).abs < 0.01 },
              'słup z zamkiem górnym krótszy o sam luz – po osiadaniu obejmuje bal na pełne 150 mm')
bez_zamka = sl.zip(slb).reject { |pair| z_zamkiem.include?(pair) }
Testy.sprawdz(bez_zamka.all? { |a, b| (b[:dl] - a[:dl] - luz - 40.0).abs < 0.01 }, 'słup pod węgłem (bez zamka górnego) krótszy o luz i śrubę')
Testy.sprawdz(pl[:podpowiedzi].any? { |h| h[:sekcja] == 'taras' && h[:tekst].include?('krótsze o osiadanie ścian') && h[:tekst].include?('śruba regulacyjna') },
              'podpowiedź w sekcji tarasu')
Testy.sprawdz(plb[:podpowiedzi].none? { |h| h[:tekst].include?('krótsze o osiadanie') }, 'bez skracania – bez podpowiedzi')
problemy, _x = LosoweDomy.sprawdz(segmenty: prostokat(0, 0, 6000, 4000), parametry: TARAS, otwory: [])
Testy.rowne(problemy, [], 'pełne sprawdzenie domu z tarasem (bryły, kolizje)')

Testy.grupa('Podkładki zamiast śruby; większe osiadanie')
plp = plan_pelny(prostokat(0, 0, 6000, 4000), TARAS.merge('slup_regulacja' => 'podkladki'))
Testy.rowne(slupy_tarasu(plp).map { |e| wierzch_pelny(e).round(2) }.uniq, [(z - luz).round(2)], 'podkładki: wierzch niżej o sam luz')
Testy.sprawdz(plp[:podpowiedzi].any? { |h| h[:tekst].include?('podkładki') }, 'podpowiedź o podkładkach')
pl4 = plan_pelny(prostokat(0, 0, 6000, 4000), TARAS.merge('osiadanie_scian' => 4, 'slup_regulacja_wysokosc' => 60))
luz4 = Osiadanie.luz(z, pl4[:parametry])
Testy.rowne(slupy_tarasu(pl4).map { |e| wierzch_pelny(e).round(2) }.uniq, [(z - luz4 - 60.0).round(2)], "osiadanie 4 % (luz #{luz4.round}) i śruba 60")
problemy, _x = LosoweDomy.sprawdz(segmenty: prostokat(0, 0, 6000, 4000), parametry: TARAS.merge('osiadanie_scian' => '4', 'taras_wiazar' => 'zastrzaly'), otwory: [])
Testy.rowne(problemy, [], 'pełne sprawdzenie przy osiadaniu 4 %')

Testy.koniec
