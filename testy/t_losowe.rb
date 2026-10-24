# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/t_losowe.rb
# Zadanie: stały zestaw losowych domów (ziarna, które kiedyś ujawniły błąd, i kilka zwykłych) – każdy bez problemów.
# Tematy: test losowy, ziarna błędów, regresja, kolizje krokwi z działową, okruchy bali, styki bez zamka, krótkie krawędzie
# Zależy od: testy/losowe_domy.rb
# Używają: testy/uruchom.sh
#
# Pełne przeszukanie (setki domów): ruby -I testy/atrapa testy/losowe_domy.rb 400 1 – nowe ziarno z błędem dopisz tutaj.

require File.expand_path('losowe_domy', File.dirname(__FILE__))

# Ziarno => co ujawniło (runda 3, runda 4 – r4).
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
  1251 => 'r4: dwa szczyty na działowych 75 mm od siebie – krokwie w szczycie'
}.freeze

ZIARNA.each do |z, opis|
  Testy.grupa("Ziarno #{z} – #{opis}")
  d = LosoweDomy.dom(z)
  problemy, pl = LosoweDomy.sprawdz(d)
  Testy.rowne(problemy, [], "#{d[:opis]}")
  Testy.sprawdz(pl && !pl[:bale].empty?, 'są bale')
end

Testy.koniec
