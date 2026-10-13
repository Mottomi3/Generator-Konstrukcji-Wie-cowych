# Parametry generatora (wszystkie ustawiane w oknie)

Plik generowany z `rdzen/parametry_lista.rb` (`ruby testy/lista_parametrow.rb`) – nie edytować ręcznie.
Ostatnio użyte wartości i własne szablony zapisują się na komputerze (`sketchup/ustawienia.rb`).

## Przekrój bala i zamek

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `preset` | Przekrój bala | 44x146 | `44x146` – Bal 44 × 146 (krycie 139, pióro 7) | Preset z kompletem wymiarów zamka; wymiary można zmienić poniżej. |
| `zamek_odbicie` | Kierunek podcięć zamka | rysunek | `rysunek` – jak na rysunku warsztatowym; `lustro` – lustrzane odbicie | Labirynt podcięć – oba warianty bez kolizji; zmiana odwraca bale poprzeczne licem. |

## Ściany

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `liczba_wiencow` | Liczba wieńców (ściany okapowe) | 16 szt. | 3 … 60 | Pełne wieńce ścian wzdłuż kalenicy; szczytowe mają o jeden więcej (pierwszy bal szczytu). |
| `ostatek` | Ostatek za licem | 100 mm | 40 … 600 | Wypust bala za licem ściany poprzecznej (projekty: 100, przy tarasie 200). |
| `kalenica` | Kalenica (półbal na ścianach wzdłuż kalenicy) | dluzszy | `dluzszy` – wzdłuż dłuższego boku; `krotszy` – wzdłuż krótszego boku; `x` – wzdłuż osi X obrysu; `y` – wzdłuż osi Y obrysu |  |

## Długości bali i łączenia

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `max_dlugosc` | Maksymalna długość bala | 5100 mm | 1000 … 13000 | Najdłuższy bal od producenta (listy 1800 i 1200: 5044 i 5090). |
| `min_odcinek` | Najkrótszy kawałek bala | 200 mm | 50 … 2000 | Krótszy kawałek – ostrzeżenie. |
| `styk_uklad` | Łączenie bali na długości | na_przemian | `na_przemian` – na przemian w kolejnych węgłach / działowych (jak 1200); `para` – para węgłów w odstępie mijanki, styk w osi zamka (jak 900 W-2); `jeden_wegiel` – jeden węgieł, styki ± połowa mijanki |  |
| `mijanka` | Mijanka styków w sąsiednich wieńcach | 400 mm | 300 … 3000 | Najmniejszy odstęp styków w sąsiednich wieńcach – nie mniej niż 300. |
| `szczelina_styku` | Szczelina na styku | 0 mm | 0 … 30 |  |
| `styk_odstep_od_otworu` | Styk od krawędzi otworu – najmniej | 400 mm | 0 … 2000 | Kawałek bala między stykiem a otworem nie krótszy niż tyle. |

## Węgły 244 – wzmocnienia ścian

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `wegly_max_swiatlo` | Najdłuższe światło ściany bez węgła | 4800 mm | 1500 … 10000 | Między licami ścian podpierających (narożnik, działowa, węgieł). 1800 W-2: 4756 bez węgła. |
| `wegly_max_swiatlo_wysokie` | To samo dla ścian wysokich | 3700 mm | 1500 … 10000 | Dom 1,5 kondygnacji (1200): węgieł już na ścianie 4 m. |
| `wegly_prog_wysokosci` | Ściana wysoka od wysokości | 3000 mm | 1500 … 8000 | Wysokość ściany okapowej bez szczytu (1100: 2966 – bez węgła, 1200: 3580 – z węgłem). |
| `wegly_rozmieszczenie` | Rozmieszczenie nowych węgłów | rowno | `rowno` – równo na długości ściany; `od_naroznikow` – od narożników o zadany odstęp (jak 1000); `tylko_narysowane` – tylko narysowane (generator tylko ostrzega) |  |
| `wegly_odstep_od_naroznika` | Odstęp węgła od narożnika | 800 mm | 300 … 3000 | Dla rozmieszczenia „od narożników”. |
| `wegly_na_dzialowych` | Węgły także na ścianach działowych | tak | `tak` – tak; `nie` – nie |  |
| `min_odstep_skrzyzowan` | Odstęp węgła od innego skrzyżowania | 300 mm | 150 … 3000 |  |
| `odstep_od_otworu` | Odstęp węgła od krawędzi otworu | 150 mm | 0 … 2000 |  |

## Szczyty i dach

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `szczyty` | Szczyty z bali | tak | `tak` – tak; `nie` – nie | Ściany szczytowe zewnętrzne dostają szczyt z bali ściętych pod kątem dachu. |
| `szczyty_na_dzialowych` | Szczyty także na działowych szczytowych | nie | `tak` – tak; `nie` – nie | Jak 1800 W-2 – ściana działowa do kalenicy. |
| `dach_kat` | Kąt dachu | 20 ° | 5 … 60 | Projekty 900 i 1000: 20°. |
| `dach_uklad` | Układ dachu | platwie | `platwie` – same płatwie (deski na płatwiach); `krokwie` – krokwie na płatwi ściennej i kalenicowej; `platwie_krokwie` – płatwie i krokwie |  |
| `dach_podniesienie` | Wierzch płatwi nad ścianą okapową (przy licu wewn.) | 69,5 mm | -300 … 1500 | Projekt 900: 69,5 = wierzch najwyższego bala ściany szczytowej. Nie dotyczy płatwi stojącej na ścianie. |
| `krokwie_przy_szczycie` | Krokwie przy ścianie szczytowej | obie_strony | `obie_strony` – z obu stron szczytu; `wewnatrz` – tylko od wewnątrz; `zewnatrz` – tylko od zewnątrz; `na_szczycie` – na szczycie (krokiew oparta na balach) | Krokwie obok szczytu – szczyt dochodzi do wierzchu krokwi; krokiew na szczycie – szczyt kończy się pod nią. |
| `krokiew_przekroj` | Krokiew (szer. × wys.) | 50x150 mm | szer. × wys. |  |
| `krokwie_rozstaw` | Rozstaw krokwi – największy | 900 mm | 300 … 2000 |  |
| `platwa_przekroj` | Płatew pośrednia | 80x180 mm | szer. × wys. | Projekt 900: 80 × 180. |
| `platwa_kalenicowa_przekroj` | Płatew kalenicowa | 80x180 mm | szer. × wys. |  |
| `platwie_rozstaw_max` | Największy rozstaw płatwi (w poziomie) | 1000 mm | 300 … 4000 | 900: ok. 990. |
| `platwa_na_scianie` | Płatew ścienna (przy ścianie okapowej) | tak | `tak` – tak; `nie` – nie |  |
| `platwa_scienna_polozenie` | Płatew ścienna – położenie | przy_licu | `przy_licu` – przy licu wewnętrznym, wierzchem na linii dachu (jak 900); `na_scianie` – stoi na ścianie okapowej, w osi |  |
| `platwa_scienna_przekroj` | Płatew na ścianie | 60x200 mm | szer. × wys. | Projekt 900: 60 × 200. |
| `gniazdo_luz` | Luz w gnieździe płatwi (każda strona) | 5 mm | 0 … 30 |  |
| `szczyt_min_wysokosc` | Najniższy kawałek bala przy skosie | 30 mm | 5 … 140 | Niższy klin bala przy skosie dachu jest pomijany. |
| `dach_elementy` | Belki dachu w modelu (płatwie, krokwie) | tak | `tak` – tak; `nie` – nie | Dla obrysu prostokątnego. |
| `dach_okap` | Okap – wysunięcie krokwi za ścianę | 500 mm | 0 … 1500 | W poziomie, od lica ściany okapowej. |
| `dach_okap_szczyt` | Wysunięcie płatwi za szczyt | 500 mm | 0 … 1500 | Od lica szczytu (900: płatwie 6082). |

## Podłoga

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `podloga` | Podłoga (podwaliny, legary, podpory) | tak | `tak` – tak; `nie` – nie |  |
| `podwalina_przekroj` | Podwalina pod ścianami | 100x100 mm | szer. × wys. | Projekt 900: 100 × 100. Niższa niż legar – podniesiona do wysokości legara. |
| `podwaliny_pod_dzialowymi` | Podwaliny także pod działowymi | tak | `tak` – tak; `nie` – nie |  |
| `legary_kierunek` | Legary wzdłuż | krotszy | `krotszy` – krótszego boku; `dluzszy` – dłuższego boku; `x` – osi X obrysu; `y` – osi Y obrysu |  |
| `legary_rozstaw` | Rozstaw legarów (osiowo) | 600 mm | 250 … 1200 | Projekt 900: 550–610. |
| `izolacja_podlogi` | Izolacja między legarami | 100 mm | 0 … 400 | Legar nie niższy niż izolacja (0 – bez izolacji). |
| `legary_dobor` | Dobór przekroju legara | zalecany | `zalecany` – zalecany (ugięcie ≤ L/zalecane); `minimalny` – minimalny (ugięcie ≤ L/minimalne); `reczny` – ręczny – podany niżej (tylko sprawdzenie) |  |
| `legar_przekroj` | Legar – przekrój ręczny | 50x100 mm | szer. × wys. | Projekt 900: 50 × 100. |
| `podpory_rozstaw_max` | Rozstaw podpór legarów – największy | 0 mm | 0 … 8000 | 0 – automatycznie: podpory tak gęsto, jak wymaga przekrój legara. |
| `podpora_przekroj` | Podpora legarów (podwalina pośrednia) | 100x100 mm | szer. × wys. |  |
| `obciazenie_uzytkowe` | Obciążenie użytkowe | 2 kN/m² | 0,5 … 10 | Mieszkanie: 1,5–2,0 (PN-EN 1991-1-1, kat. A). |
| `obciazenie_stale` | Obciążenie stałe (deski, izolacja) | 0,5 kN/m² | 0 … 5 | Bez ciężaru legarów (liczony osobno). |
| `drewno_klasa` | Klasa drewna konstrukcyjnego | C24 | `C18` – C18; `C24` – C24; `C30` – C30; `GL24h` – GL24h (klejone) |  |
| `ugiecie_zalecane` | Ugięcie zalecane L / | 400 | 150 … 1000 | Sztywna podłoga bez drgań. |
| `ugiecie_minimalne` | Ugięcie dopuszczalne L / | 250 | 100 … 1000 | Granica – mniej sztywna podłoga już niedopuszczalna. |
| `przekroje_katalog` | Dostępne przekroje legarów | 45x95, 45x120, 45x145, 45x170, 45x195, 45x220, 50x100, 50x150, 50x175, 50x200, 50x225, 63x175, 63x200, 63x225, 75x200, 75x225, 75x250, 100x100, 100x150 |  | Lista „szer.×wys.” po przecinku – dobór bierze najlżejszy spełniający warunki. |

## Otwory – ustawienia

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `min_kawalek_przy_otworze` | Kawałek bala przy otworze – najkrótszy | 70 mm | 0 … 1000 |  |
| `luz_nad_otworem` | Luz osiadania nad otworem | 0 mm | 0 … 200 |  |
| `okno_szerokosc` | Nowe okno – szerokość | 1020 mm | 100 … 6000 | Wymiary wstawiane przyciskiem „+ okno” (900: 1020 × 1010). |
| `okno_wysokosc` | Nowe okno – wysokość | 1010 mm | 100 … 4000 |  |
| `okno_parapet` | Nowe okno – parapet | 900 mm | 0 … 4000 |  |
| `drzwi_szerokosc` | Nowe drzwi – szerokość | 930 mm | 300 … 6000 |  |
| `drzwi_wysokosc` | Nowe drzwi – wysokość | 2100 mm | 1000 … 4000 |  |
| `nowy_otwor_od` | Nowy otwór – odległość od narożnika | 1000 mm | 0 … 30000 |  |

## Rozpoznanie rysunku i waga

| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |
|---|---|---|---|---|
| `kontrfor_max_linia` | Linia węgła – najdłuższa | 600 mm | 100 … 3000 | Krótsza linia przecinająca jedną ścianę = węgieł. |
| `tolerancja_rysunku` | Tolerancja rysunku obrysu | 5 mm | 0,5 … 50 |  |
| `gestosc` | Gęstość drewna (waga) | 450 kg/m³ | 300 … 900 |  |

## Szablony wbudowane

| Szablon | Zmienione wartości |
|---|---|
| Domek parterowy 44 (jak 900) | `liczba_wiencow` = 16 |
| Dom parterowy wysoki (jak 1800) | `liczba_wiencow` = 20 |
| Dom 1,5 kondygnacji (jak 1200) | `liczba_wiencow` = 25 |
| Bez łączenia bali (bale do 7 m) | `max_dlugosc` = 7000 |
| Podłoga ocieplona 150 mm | `izolacja_podlogi` = 150 |
