# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_losowe.rb
# Zadanie: stały zestaw losowych domów (ziarna, które kiedyś ujawniły błąd, i kilka zwykłych) – każdy bez problemów.
# Tematy: test losowy, ziarna błędów, regresja, kolizje krokwi z działową, okruchy bali, styki bez zamka, krótkie krawędzie, krokwie z aplikacji i z generatora w teście losowym
# Zależy od: testy/losowe_domy.rb
# Używają: testy/uruchom.sh
#
# Pełne przeszukanie (setki domów): ruby -I testy/atrapa testy/losowe_domy.rb 400 1 – nowe ziarno z błędem dopisz tutaj.

require File.expand_path('losowe_domy', File.dirname(__FILE__))

# Ziarno => co ujawniło (runda 3, runda 4 – r4, runda 5 – r5).
ZIARNA = {
  106 => 'krokwie przy szczycie od zewnątrz na węgle', 147 => 'mijanka przy jednym węgle i balu 3 m',
  196 => 'krokiew na węgle przy szczycie', 216 => 'okruchy bali przy gnieździe płatwi, krótkie krawędzie',
  243 => 'krokwie na działowej ze szczytem', 260 => 'okruchy bali przy skosie', 336 => 'okruchy bali',
  9 => 'styki w szczycie poza zamkiem', 27 => 'styki w szczycie – ostrzeżenie', 62 => 'styki bez zamka – ostrzeżenie',
  91 => 'krótkie krawędzie brył (0,09 mm)', 116 => 'styk bez zamka w szczycie', 124 => 'styki przy działowej',
  4 => 'krótka krawędź skosu szczytu', 38 => 'krótka krawędź skosu szczytu', 1 => 'zwykły', 2 => 'zwykły', 3 => 'zwykły',
  338 => 'r4: strop – odcinki dopełnienia przy szczycie pod krokwiami', 375 => 'r4: działowa wzdłuż kalenicy pod stropem przy szczycie',
  740 => 'r4: pełny profil, antresola, krokwie od zewnątrz', 695 => 'r4: pełny profil – skos 0,06 mm nad wierzchem bala',
  791 => 'r4: pełny profil – pasek bala pod oknem płytszy niż wpust', 739 => 'r4: pełny profil, obrys L, strop',
  1251 => 'r4: dwa szczyty na działowych 75 mm od siebie – krokwie w szczycie',
  43 => 'r5: krokwie z aplikacji, szczyt na działowej, płatew na ścianie',
  377 => 'r5: krokwie z aplikacji, dwa szczyty na działowych, pełny profil',
  105 => 'r5: jednospadowy – bal szczytu nad ścianą wysoką, mostek 0,03 mm nad gniazdem zamka',
  250 => 'r5: jednospadowy – ostatek szczytu nad ścianą wysoką bez zamka'
}.freeze

ZIARNA.each do |z, opis|
  Testy.grupa("Ziarno #{z} – #{opis}")
  d = LosoweDomy.dom(z)
  problemy, pl = LosoweDomy.sprawdz(d)
  Testy.rowne(problemy, [], "#{d[:opis]}")
  Testy.sprawdz(pl && !pl[:bale].empty?, 'są bale')
  next unless d[:parametry]['dach_wiezba'] == 'aplikacja'
  # Ziarna z błędów krokwi generatora – także z krokwiami z generatora (dodatki rundy 5 przełączyły je na aplikację).
  problemy, _pl = LosoweDomy.sprawdz(d.merge(parametry: d[:parametry].merge('dach_wiezba' => 'generator')))
  Testy.rowne(problemy, [], 'to samo z krokwiami z generatora')
end

Testy.koniec
