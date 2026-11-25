# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/losowe_domy.rb
# Zadanie: losowe domy do testów – obrys (prostokąt, L), działowe, węgły, otwory i parametry z ziarna; sprawdzenie jednego domu.
# Tematy: losowe domy, test losowy, ziarno, sprawdzenie domu, kolizje, bryły zamknięte, krótkie krawędzie brył, mijanka, długości bali, styki bez zamka, losowe ustawienia ścian, losowy pełny profil, losowe krokwie z aplikacji, połacie w teście losowym, losowe luzy stolarki, losowy dach jednospadowy, bal w narożniku bez zamka, losowy taras, podpory dla aplikacji do dachów w teście losowym, losowe boczne zadaszenie, losowy dobór przekrojów zadaszenia i krokwi, losowa podłoga w przybudówce, losowe łączenie wieńców szczytu
# Zależy od: testy/pomoc.rb, testy/kolizje_belek.rb
# Używają: testy/t_losowe.rb, ręcznie (ruby -I testy/atrapa testy/losowe_domy.rb [liczba] [ziarno])
#
# Dom z ziarna jest zawsze ten sam (Random.new(ziarno)) – błąd z raportu odtwarza się podając ziarno. Dodatki z rundy 4
# (pełny profil, strop, ustawienia ścian) i rundy 5 (krokwie z aplikacji, luzy stolarki) z osobnych losowań – domy
# z ziaren wcześniejszych rund bez zmian.

require File.expand_path('pomoc', File.dirname(__FILE__))
require File.expand_path('kolizje_belek', File.dirname(__FILE__))

module LosoweDomy
  G = ArteMadera::GeneratorWiencowy
  # Najkrótsza dopuszczalna krawędź bryły [mm] – zapas ponad tolerancję SketchUpa (0,0254 mm).
  MIN_KRAWEDZ = 0.1
  # Ziarna od tego numeru dostają losowy taras (runda 5).
  ZIARNA_Z_TARASEM = 2000
  # Ziarna od tego numeru dostają losowe nowości rundy 7 (podbitka, zamki płatwi, styki w zamku działowej, fundamenty…).
  ZIARNA_R7 = 3000
  # Ziarna od tego numeru dostają losowe nowości rundy 8 (wypusty pod okapem, węgły niesymetryczne, podłoga, taras…).
  ZIARNA_R8 = 4000
  # Ziarna od tego numeru dostają losowe nowości rundy 9 (węgły pod płatwiami i na wolnym końcu, wiązar nad tarasem).
  ZIARNA_R9 = 5000
  # Od tego ziarna – nowości rundy 10 (wiązar pod płatwiami, zastrzały pod kątem, poziom podciągu).
  ZIARNA_R10 = 6000 unless const_defined?(:ZIARNA_R10)
  # Od tego ziarna – nowości rundy 11 (słupki tylko pod kalenicową, węgieł w osi płatwi, przekroje wiązara, zamek płatwi
  # nad tarasem tylko od spodu, front tarasu łączony na styk, słup w osi kalenicy).
  ZIARNA_R11 = 7000 unless const_defined?(:ZIARNA_R11)
  # Od tego ziarna – nowości rundy 12 (boczne zadaszenie: wiata na słupach albo przybudówka z bali).
  ZIARNA_R12 = 8000 unless const_defined?(:ZIARNA_R12)
  # Od tego ziarna – nowości rundy 13 (dobór przekrojów zadaszenia i krokwi, podłoga w przybudówce do wyboru).
  ZIARNA_R13 = 8500 unless const_defined?(:ZIARNA_R13)
  # Od tego ziarna – nowości rundy 15 (wieńce szczytu łączone na styk albo w zamkach węgłów, słupy krótsze o osiadanie).
  ZIARNA_R15 = 9000 unless const_defined?(:ZIARNA_R15)

  module_function

  # Losowy wybór z listy.
  def wybierz(r, lista)
    lista[r.rand(lista.length)]
  end

  # Dom z ziarna: { ziarno:, opis:, segmenty:, parametry:, otwory: }.
  def dom(ziarno)
    r = Random.new(ziarno)
    prostokat_dom = r.rand < 0.75
    w = 3000 + r.rand(91) * 100
    d = 3000 + r.rand(71) * 100
    seg = []
    opis = []
    if prostokat_dom
      seg.concat(prostokat(0, 0, w, d))
      opis << "prostokąt #{w}×#{d}"
      r.rand(3).times do
        if r.rand < 0.5
          x = 1200 + r.rand([w - 2400, 1].max)
          y1 = r.rand < 0.7 ? d : 1500 + r.rand([d - 1500, 1].max)
          seg << [[x, 0], [x, y1]]
          opis << "działowa x=#{x}#{y1 < d ? " do #{y1}" : ''}"
        else
          y = 1200 + r.rand([d - 2400, 1].max)
          x1 = r.rand < 0.7 ? w : 1500 + r.rand([w - 1500, 1].max)
          seg << [[0, y], [x1, y]]
          opis << "działowa y=#{y}#{x1 < w ? " do #{x1}" : ''}"
        end
      end
      r.rand(3).times do
        if r.rand < 0.5
          x = 600 + r.rand([w - 1200, 1].max)
          seg << [[x, -150], [x, 150]]
          opis << "węgieł na dole x=#{x}"
        else
          y = 600 + r.rand([d - 1200, 1].max)
          seg << [[-150, y], [150, y]]
          opis << "węgieł z lewej y=#{y}"
        end
      end
    else
      cw = 1500 + r.rand([w - 3500, 1].max)
      cd = 1500 + r.rand([d - 3500, 1].max)
      seg.concat(wielokat([[0, 0], [w, 0], [w, d - cd], [w - cw, d - cd], [w - cw, d], [0, d]]))
      opis << "L #{w}×#{d} wycięcie #{cw}×#{cd}"
    end
    p = parametry(r)
    otw = otwory(r, prostokat_dom ? [w, d, w, d] : [w, d - cd, cw, cd])
    sciany = dodatki(Random.new(ziarno * 7919 + 13), p, prostokat_dom ? w : w - cw, opis)
    dodatki_r5(Random.new(ziarno * 104_729 + 31), p, opis)
    taras(Random.new(ziarno * 15_485_863 + 7), p, opis) if ziarno >= ZIARNA_Z_TARASEM
    dodatki_r7(Random.new(ziarno * 2_750_159 + 3), p, opis) if ziarno >= ZIARNA_R7
    dodatki_r8(Random.new(ziarno * 3_331_333 + 11), p, opis) if ziarno >= ZIARNA_R8
    dodatki_r9(Random.new(ziarno * 4_256_249 + 17), p, opis) if ziarno >= ZIARNA_R9
    dodatki_r10(Random.new(ziarno * 5_117_113 + 19), p, opis) if ziarno >= ZIARNA_R10
    dodatki_r11(Random.new(ziarno * 6_700_417 + 23), p, opis) if ziarno >= ZIARNA_R11
    dodatki_r12(Random.new(ziarno * 7_368_791 + 29), p, opis) if ziarno >= ZIARNA_R12
    dodatki_r13(Random.new(ziarno * 8_191_207 + 31), p, opis) if ziarno >= ZIARNA_R13
    dodatki_r15(Random.new(ziarno * 9_999_991 + 37), p, opis) if ziarno >= ZIARNA_R15
    { ziarno: ziarno, opis: opis.join(', '), segmenty: seg, parametry: p, otwory: otw, sciany: sciany }
  end

  # Dodatki rundy 4 (osobne losowanie): pełny profil, strop, ostatek 200 na końcu ściany, działowa pod antresolą,
  # węgły ręczne na W-1; zwraca ustawienia ścian (parametry uzupełnia w p, opis w opis).
  def dodatki(r, p, dl_w1, opis)
    if r.rand < 0.3
      p['profil_bala'] = 'pelny'
      p['pioro_liczba'] = wybierz(r, %w[1 2])
      opis << "pełny profil (#{p['pioro_liczba']} pióra)"
    end
    if r.rand < 0.2
      p['strop'] = 'tak'
      p['dzialowa_nizsza_wysokosc'] = (1800 + r.rand(13) * 100).to_s
      opis << "strop #{p['dzialowa_nizsza_wysokosc']}"
    end
    sciany = {}
    if r.rand < 0.3
      id = "W-#{1 + r.rand(4)}"
      (sciany[id] ||= {})[r.rand < 0.5 ? 'ostatek_od' : 'ostatek_do'] = wybierz(r, %w[200 150 300])
      opis << "ostatek #{id}"
    end
    if r.rand < 0.3
      sciany['W-5'] = { 'nad' => wybierz(r, %w[antresola polka strop]), 'wysokosc' => (1800 + r.rand(13) * 100).to_s }
      opis << "W-5 #{sciany['W-5']['nad']}"
    end
    if r.rand < 0.2
      (sciany['W-1'] ||= {})['wegly'] = (0...(1 + r.rand(2))).map { 400 + r.rand([dl_w1 - 800, 1].max) }
      opis << "węgły ręczne W-1 #{sciany['W-1']['wegly'].inspect}"
    end
    sciany
  end

  # Dodatki rundy 5 (osobne losowanie – domy z ziaren rund 1–4 bez zmian): krokwie z aplikacji do dachów (połacie),
  # luzy stolarki (boczny, osiadanie ścian – luz górny z podpowiedzi), dach jednospadowy.
  def dodatki_r5(r, p, opis)
    if r.rand < 0.4
      p['dach_wiezba'] = 'aplikacja'
      opis << 'krokwie z aplikacji' if %w[krokwie platwie_krokwie].include?(p['dach_uklad'])
    end
    if r.rand < 0.3
      p['luz_boczny'] = wybierz(r, %w[0 5 15])
      p['osiadanie_scian'] = wybierz(r, %w[0 3 4])
      opis << "luzy stolarki #{p['luz_boczny']} / #{p['osiadanie_scian']} %"
    end
    return unless r.rand < 0.3
    p['dach_rodzaj'] = 'jednospadowy'
    p['dach_spadek'] = wybierz(r, %w[min max])
    p['dach_okap_wysoki'] = wybierz(r, %w[0 300 500 800])
    opis << "dach jednospadowy (spadek #{p['dach_spadek']}, okap wysoki #{p['dach_okap_wysoki']})"
  end

  # Taras (osobne losowanie, tylko ziarna od ZIARNA_Z_TARASEM – domy z ziaren wcześniejszych rund bez zmian): wariant 1100
  # albo 1200, strona, głębokość, podciąg, wejście, balustrada, słupy.
  def taras(r, p, opis)
    return unless r.rand < 0.6
    p['taras'] = wybierz(r, %w[podciag podciag sciany])
    p['taras_strona'] = wybierz(r, %w[min max])
    p['taras_glebokosc'] = wybierz(r, %w[1200 2000 2400 3000])
    p['taras_wience_gorne'] = wybierz(r, %w[1 2 2 3])
    p['taras_wejscie'] = wybierz(r, %w[srodek lewa prawa brak])
    p['taras_balustrada_bale'] = wybierz(r, %w[0 3 4 4])
    p['taras_slup_przekroj'] = wybierz(r, %w[120x120 80x180 140x140])
    p['taras_slupy_rozstaw_max'] = wybierz(r, %w[1500 2000 2500])
    opis << "taras #{p['taras']} #{p['taras_strona']} #{p['taras_glebokosc']}"
  end

  # Dodatki rundy 7 (osobne losowanie, ziarna od ZIARNA_R7): podbitka w czterech położeniach, zamki płatwi, płatwie na
  # pełnym balu, styki w zamku działowej, węgieł na środku, działowa do dachu, podwalina 50 × 150 na śruby, fundamenty,
  # szczyt nad tarasem.
  def dodatki_r7(r, p, opis)
    p['podbitka'] = wybierz(r, %w[nie pod_platwiami na_platwiach pod_krokwiami na_krokwiach])
    p['platwie_zamki'] = wybierz(r, %w[tak tak nie])
    p['platwie_na_wiencach'] = wybierz(r, %w[tak tak nie])
    p['styk_na_dzialowej'] = wybierz(r, %w[wspolny mijanka])
    p['wegly_srodek'] = wybierz(r, %w[nie nie zewnetrzne wszystkie])
    p['dzialowa_wzdluz_do_dachu'] = wybierz(r, %w[tak nie])
    if r.rand < 0.4
      p['podwalina_przekroj'] = '50x150'
      p['podwalina_laczenie'] = 'sruby'
    end
    p['fundamenty'] = wybierz(r, %w[tak nie])
    p['taras_szczyt'] = wybierz(r, %w[pelny azurowy pusty])
    opis << "r7: podbitka #{p['podbitka']}, zamki płatwi #{p['platwie_zamki']}, styk #{p['styk_na_dzialowej']}, " \
            "węgieł środek #{p['wegly_srodek']}, podwalina #{p['podwalina_przekroj'] || '100x100'}, szczyt tarasu #{p['taras_szczyt']}"
  end

  # Dodatki rundy 8 (osobne losowanie, ziarna od ZIARNA_R8): wypuszczone górne wieńce okapowe, węgły pod okapem do
  # nawisu, węgły niesymetryczne, podciąg na równo, fundament okrągły, balustrada z wieńców ścian, trójkątny wieniec.
  def dodatki_r8(r, p, opis)
    p['okap_wience_wypust'] = wybierz(r, %w[0 1 2 2 3])
    p['wegly_wypust_okap'] = wybierz(r, %w[nie nie tak])
    p['wegly_okap_wience'] = wybierz(r, %w[2 3 4])
    p['wegiel_wypust_zewn'] = wybierz(r, %w[100 100 200])
    p['wegiel_wypust_wewn'] = wybierz(r, %w[100 100 150])
    p['podciag_poziom'] = wybierz(r, %w[pod rowno])
    p['podciagi'] = wybierz(r, %w[auto tak tak])
    p['fundament_ksztalt'] = wybierz(r, %w[kwadrat okragly])
    p['taras_balustrada_rodzaj'] = wybierz(r, %w[przesla sciany])
    p['taras_zakladka'] = wybierz(r, %w[tak nie])
    p['taras_wieniec'] = wybierz(r, %w[platwa wlasny brak])
    opis << "r8: wypust okapu #{p['okap_wience_wypust']}, węgły pod okapem #{p['wegly_wypust_okap']}, węgieł zewn. " \
            "#{p['wegiel_wypust_zewn']}, podciąg #{p['podciag_poziom']}, fundament #{p['fundament_ksztalt']}, balustrada " \
            "#{p['taras_balustrada_rodzaj']}, wieniec szczytu #{p['taras_wieniec']}"
  end

  # Dodatki rundy 9 (osobne losowanie, ziarna od ZIARNA_R9): węgły pod płatwiami, węgieł na wolnym końcu, wiązar nad
  # tarasem (rodzaj, na balach albo na słupach, słupek, zastrzał); szczyt pusty częściej.
  def dodatki_r9(r, p, opis)
    p['wegly_pod_platwiami'] = wybierz(r, %w[zewnetrzne zewnetrzne wszystkie nie])
    p['wegly_wolny_koniec'] = wybierz(r, %w[tak tak nie])
    p['wegly_wolny_koniec_min'] = wybierz(r, %w[0 600 1000 2000])
    p['taras_szczyt'] = wybierz(r, %w[pusty pusty pelny azurowy]) if p['taras'] == 'podciag'
    p['taras_wiazar'] = wybierz(r, %w[slupek zastrzaly])
    p['taras_wiazar_podparcie'] = wybierz(r, %w[bale slupy])
    p['taras_wiazar_slupek'] = wybierz(r, %w[80 120 160])
    p['taras_wiazar_zastrzal'] = wybierz(r, %w[60 100 140])
    opis << "r9: węgły pod płatwiami #{p['wegly_pod_platwiami']}, wolny koniec #{p['wegly_wolny_koniec']} od " \
            "#{p['wegly_wolny_koniec_min']}, wiązar #{p['taras_wiazar']} na #{p['taras_wiazar_podparcie']}"
  end

  # Dodatki rundy 10: wiązar pod płatwiami (głębokość gniazda, kąt zastrzałów), poziom podciągu; domy L mają dwa dachy
  # z koszem przy każdym ziarnie (rdzen/skrzydla.rb).
  def dodatki_r10(r, p, opis)
    p['taras_wiazar_gniazdo'] = wybierz(r, %w[0 20 20 40])
    p['taras_wiazar_zastrzal_kat'] = wybierz(r, %w[45 45 0 30 60])
    p['taras_wiazar'] = wybierz(r, %w[zastrzaly zastrzaly slupek])
    p['podciag_poziom'] = wybierz(r, %w[rowno rowno pod])
    opis << "r10: gniazdo wiązara #{p['taras_wiazar_gniazdo']}, zastrzały #{p['taras_wiazar_zastrzal_kat']}°, podciąg #{p['podciag_poziom']}"
  end

  # Dodatki rundy 11: słupki z kontrfor pod płatwiami tylko pod kalenicową, węgieł na środku ścian (staje w osi płatwi
  # kalenicowej), słupek i zastrzały wiązara z przekroju wiązara, zamek płatwi nad tarasem tylko od spodu, front tarasu
  # łączony na styk albo na węgłach, słup frontu w osi kalenicy, automatyczny dobór przekroju płatwi i trójkąta nad
  # tarasem (śnieg z kilku stref).
  def dodatki_r11(r, p, opis)
    p['wegly_pod_platwiami_ktore'] = wybierz(r, %w[wszystkie wszystkie kalenicowa])
    p['wegly_srodek'] = wybierz(r, %w[nie zewnetrzne zewnetrzne wszystkie])
    p['taras_wiazar_przekroje'] = wybierz(r, %w[wlasne jak_wiazar])
    p['taras_platwa_zamek'] = wybierz(r, %w[spod spod pelny])
    p['taras_styk'] = wybierz(r, %w[styk styk wegly])
    p['taras_slup_w_osi'] = wybierz(r, %w[tak tak nie])
    p['taras_slup_os_dociag'] = wybierz(r, %w[0 300 500 800])
    p['platwie_dobor'] = wybierz(r, %w[reczny reczny auto])
    p['platwie_jeden_przekroj'] = wybierz(r, %w[tak tak nie])
    p['dach_snieg'] = wybierz(r, %w[0.7 0.9 1.2 2.0])
    p['taras_wieniec'] = 'auto' if r.rand < 0.35
    opis << "r11: słupki pod #{p['wegly_pod_platwiami_ktore']}, węgieł na środku #{p['wegly_srodek']}, wiązar " \
            "#{p['taras_wiazar_przekroje']}, zamek płatwi nad tarasem #{p['taras_platwa_zamek']}, front #{p['taras_styk']}, " \
            "słup w osi #{p['taras_slup_w_osi']} (dociąganie #{p['taras_slup_os_dociag']}), dobór płatwi #{p['platwie_dobor']} " \
            "(jeden przekrój #{p['platwie_jeden_przekroj']}, śnieg #{p['dach_snieg']}), trójkąt z przekroju #{p['taras_wieniec']}"
  end

  # Dodatki rundy 12: boczne zadaszenie (słupy albo przybudówka, strona, szerokość, kąt mniejszy niż dachu – czasem nie,
  # okap, przekroje, rozstaw słupów); dom z tarasem, jednospadowy albo L – zadaszenie pominięte z ostrzeżeniem.
  def dodatki_r12(r, p, opis)
    return if r.rand < 0.4
    kat = p['dach_kat'].to_f
    p['zadaszenie'] = wybierz(r, %w[slupy slupy bale])
    p['zadaszenie_strona'] = wybierz(r, %w[min max obie])
    p['zadaszenie_szerokosc'] = wybierz(r, %w[900 1500 2000 2000 2600 3200])
    p['zadaszenie_kat'] = (r.rand < 0.1 ? kat + 1 : [3.0, kat - 1 - r.rand([kat - 4, 1].max).to_i].max).to_s
    p['zadaszenie_okap'] = wybierz(r, %w[0 200 300 500])
    p['zadaszenie_platwa_przekroj'] = wybierz(r, %w[80x160 60x120 100x200])
    p['zadaszenie_slup_przekroj'] = wybierz(r, %w[120x120 100x100 140x140])
    p['zadaszenie_belka_przekroj'] = wybierz(r, %w[80x160 60x140 100x200])
    p['zadaszenie_slupy_rozstaw'] = wybierz(r, %w[1500 2500 3500])
    opis << "r12: zadaszenie #{p['zadaszenie']} #{p['zadaszenie_strona']} #{p['zadaszenie_szerokosc']} mm, " \
            "#{p['zadaszenie_kat']}° (dach #{p['dach_kat']}°), okap #{p['zadaszenie_okap']}"
  end

  # Dodatki rundy 13: dobór przekrojów zadaszenia (automatycznie / z wyboru), dobór krokwi, podłoga w przybudówce.
  def dodatki_r13(r, p, opis)
    p['zadaszenie_dobor'] = wybierz(r, %w[auto auto reczny])
    p['krokwie_dobor'] = wybierz(r, %w[auto reczny])
    p['zadaszenie_podloga'] = wybierz(r, %w[tak nie])
    opis << "r13: dobór zadaszenia #{p['zadaszenie_dobor']}, krokwi #{p['krokwie_dobor']}, podłoga przybudówki #{p['zadaszenie_podloga']}"
  end

  # Dodatki rundy 15: łączenie wieńców szczytu (na styk – fabrycznie – albo w zamkach węgłów, jak do kompilacji 14),
  # słupy krótsze o osiadanie ścian (śruba / podkładki / wyłączone) przy różnym osiadaniu, pół zamka w ostatnim połączeniu.
  def dodatki_r15(r, p, opis)
    p['szczyt_styk'] = wybierz(r, %w[styk styk wegly])
    p['slup_osiadanie'] = wybierz(r, %w[tak tak nie])
    p['slup_regulacja'] = wybierz(r, %w[sruba podkladki])
    p['osiadanie_scian'] = wybierz(r, %w[1.5 1.5 3 5])
    p['polzamek'] = wybierz(r, %w[tak tak nie])
    opis << "r15: szczyt #{p['szczyt_styk']}, słupy osiadanie #{p['slup_osiadanie']} / #{p['slup_regulacja']} / #{p['osiadanie_scian']} %, pół zamka #{p['polzamek']}"
  end

  # Losowe parametry (wartości tekstowe jak z okna); krokwie z generatora (aplikacja – w dodatkach rundy 5).
  def parametry(r)
    {
      'liczba_wiencow' => (8 + r.rand(19)).to_s, 'max_dlugosc' => wybierz(r, %w[3000 4000 5100 5100 6000 7000]),
      'styk_uklad' => wybierz(r, %w[na_przemian na_przemian para jeden_wegiel]),
      'mijanka' => wybierz(r, %w[300 400 400 600]), 'kalenica' => wybierz(r, %w[dluzszy krotszy x y]),
      'ostatek' => wybierz(r, %w[100 100 200]), 'wegly_rozmieszczenie' => wybierz(r, %w[rowno rowno od_naroznikow tylko_narysowane]),
      'wegly_na_dzialowych' => wybierz(r, %w[tak nie]), 'zamek_odbicie' => wybierz(r, %w[rysunek lustro]),
      'szczyty' => wybierz(r, %w[tak tak tak nie]), 'szczyty_na_dzialowych' => wybierz(r, %w[tak nie]),
      'dach_kat' => (10 + r.rand(36)).to_s, 'dach_uklad' => wybierz(r, %w[platwie krokwie platwie_krokwie]),
      'krokwie_przy_szczycie' => wybierz(r, %w[obie_strony wewnatrz zewnatrz na_szczycie]),
      'platwa_na_scianie' => wybierz(r, %w[tak tak nie]), 'platwa_scienna_polozenie' => wybierz(r, %w[przy_licu na_scianie]),
      'podloga' => wybierz(r, %w[tak tak nie]), 'legary_kierunek' => wybierz(r, %w[krotszy dluzszy x y]),
      'legary_dobor' => wybierz(r, %w[zalecany minimalny reczny]), 'izolacja_podlogi' => wybierz(r, %w[0 100 150 200]),
      'szczelina_styku' => wybierz(r, %w[0 0 2]), 'dach_wiezba' => 'generator'
    }
  end

  # Losowe otwory na ścianach W-1…W-4 (długości lica ścian w kolejności numeracji).
  def otwory(r, dlugosci)
    (0...r.rand(5)).map do
      i = r.rand(4)
      dl = dlugosci[i]
      drzwi = r.rand < 0.3
      szer = drzwi ? 800 + r.rand(5) * 50 : 600 + r.rand(29) * 50
      next nil if dl - szer < 900
      od = 350 + r.rand(dl - szer - 700)
      { 'sciana' => "W-#{i + 1}", 'od' => od.to_s, 'szerokosc' => szer.to_s,
        'wysokosc' => (drzwi ? 2100 : 600 + r.rand(17) * 50).to_s, 'parapet' => (drzwi ? 0 : 500 + r.rand(13) * 50).to_s }
    end.compact
  end

  # Sprawdzenie domu: lista problemów (pusta – w porządku) i plan.
  def sprawdz(dom, belki = true)
    problemy = []
    pl = begin
      G::Projekt.oblicz('segmenty' => dom[:segmenty], 'parametry' => dom[:parametry], 'otwory' => dom[:otwory],
                        'sciany' => dom[:sciany] || {})
    rescue => e
      return [["wyjątek #{e.class}: #{e.message} @ #{e.backtrace.first(3).join(' | ')}"], nil]
    end
    return [["błędy: #{pl[:bledy].join('; ')}"], pl] unless pl[:bledy].empty?
    k = G::Kontrola.wszystko(pl)
    problemy << "kolizje w zamkach: #{k[:kolizje].length} (#{k[:kolizje].first.inspect})" unless k[:kolizje].empty?
    problemy << "mijanka: #{k[:mijanka].first(3).inspect}" unless k[:mijanka].empty?
    # Ściany równoległe (runda 14): bale ścian i działowych nigdy nie mogą zajmować tego samego miejsca; węgły dwóch ścian
    # narysowanych bliżej niż długość węgła – tylko z ostrzeżeniem dla użytkownika.
    wegly = pl[:sciany].select { |w| w[:rodzaj] == :kontrfor }.map { |w| w[:id] }
    nak = k[:nakladanie].reject { |n| (n[:sciany] - wegly).empty? && pl[:ostrzezenia].any? { |u| u.include?('zajmują to samo miejsce') } }
    problemy << "bale ścian równoległych w tym samym miejscu: #{nak.length} (#{nak.first.inspect})" unless nak.empty?
    if !k[:styki_bez_zamka].empty? && pl[:ostrzezenia].none? { |u| u.include?('styk bez zamka') }
      problemy << "styki bez zamka bez ostrzeżenia: #{k[:styki_bez_zamka].first(3).inspect}"
    end
    if !k[:za_dlugie].empty? && pl[:ostrzezenia].none? { |u| u.include?('dłuższe niż') }
      problemy << "za długie bale bez ostrzeżenia: #{k[:za_dlugie].first(3).inspect}"
    end
    siatki = (pl[:pozycje] + pl[:pozycje_elementow]).map { |poz| [poz, siatka(poz)] }
    zle = siatki.reject { |_poz, k| k[:ok] }.map { |poz, _k| "#{poz[:prefiks]} #{poz[:nazwa]}" }
    problemy << "bryły niezamknięte: #{zle.first(5).join(', ')}" unless zle.empty?
    krotkie_kr = siatki.select { |_poz, k| k[:min_krawedz] < MIN_KRAWEDZ }
    unless krotkie_kr.empty?
      problemy << format('krawędzie brył krótsze niż %.1f mm: %s', MIN_KRAWEDZ,
                         krotkie_kr.first(3).map { |poz, k| format('%s %s (%.3f)', poz[:prefiks], poz[:nazwa], k[:min_krawedz]) }.join(', '))
    end
    pl[:sciany].select { |w| w[:szczyt] }.each do |w|
      nad = nad_linia(pl, w[:id])
      problemy << format('%s: bale ponad linią dachu o %.2f mm', w[:id], nad) if nad && nad > 0.01
    end
    krotkie = pl[:bale].select { |b| b[:dl] < 1.0 || b[:h] < 1.0 }
    problemy << "bale o zerowym wymiarze: #{krotkie.length}" unless krotkie.empty?
    nazwy = (pl[:pozycje] + pl[:pozycje_elementow]).map { |x| x[:nazwa] }
    problemy << 'powtórzone nazwy pozycji' unless nazwy.uniq.length == nazwy.length
    if belki
      %w[P K S Pb Wt Bp].each do |pr|
        n = kolizje_belek(pl, pr, 4)
        problemy << "#{pr}: kolizje z balami (#{n} punktów)" if n > 0
      end
      # Boczne zadaszenie (runda 12): belki poprzeczne, słupy i słupki zadaszenia, płatwie i oczep (słupy tarasu z płatwiami –
      # osobno, §8 stanu prac).
      [%w[Wt P], %w[Wt S], %w[Wt Wt], %w[Bp P], %w[Bp S], ['S', 'P', :zadaszenie], %w[P P]].each do |a, b, tag|
        n = kolizje_elementow(pl, a, b, 4, tag)
        problemy << "#{a} z #{b}: kolizje (#{n} punktów)" if n > 0
      end
    end
    problemy.concat(problemy_polaci(pl))
    bez = bez_zamka_w_narozniku(pl)
    problemy << "bale ścięte dachem w narożniku bez zamka: #{bez.first(3).join(', ')}" unless bez.empty?
    [problemy, pl]
  end

  # Bale ścięte dachem, które zachodzą na słup zamka narożnika bez gniazda w jego osi (ostatek bez oparcia) – opisy;
  # bal wyższy półzamka (rdzen/pol_zamka.rb) nie ma gniazda z założenia – leży w gnieździe bala pod nim.
  def bez_zamka_w_narozniku(pl)
    t = G::Parametry.grubosc(pl[:parametry])
    pl[:sciany].select { |w| w[:szczyt] || w[:pod_dachem] }.flat_map do |w|
      w[:skrzyzowania].select { |k| k[:typ] == :naroznik }.flat_map do |k|
        w[:bale].select do |b|
          b[:s0] < k[:s] + t / 2.0 - 0.01 && b[:s1] > k[:s] - t / 2.0 + 0.01 && b[:cechy].any? { |c| c[:typ] == 'skos_gora' } &&
            b[:cechy].none? { |c| c[:typ].start_with?('gniazdo') && c[:os] && (c[:os] - k[:s]).abs < 0.01 } &&
            !G::PolZamka.w_osi?(b, k[:s])
        end.map { |b| "#{w[:id]} wieniec #{b[:wieniec][:nr]}" }
      end
    end
  end

  # Połacie dla aplikacji do dachów: bale i płatwie pod połacią, każda płatew ją podpiera, bez krokwi generatora;
  # podpory (płatwie, ściana wysoka) w granicy aplikacji (wierzch w osi pod połacią o ≤ b/2·sin α + 30 mm po normalnej).
  def problemy_polaci(pl)
    wz = wzgledem_polaci(pl)
    return [] if wz.nil?
    wynik = podpory_poza(pl)
    wynik << format('bale ponad połacią o %.2f mm', wz[:bale]) if wz[:bale] && wz[:bale] > 0.01
    wynik << format('płatwie ponad połacią o %.2f mm', wz[:platwie]) if wz[:platwie] && wz[:platwie] > 0.01
    # Podbitka na płatwiach – krokwie leżą na deskach: płatew pod połacią dokładnie o grubość deski w pionie.
    deska = G::Dach.uniesienie_krokwi(pl[:parametry])
    wynik << format('płatew %.2f mm pod połacią – nie podpiera krokwi', -wz[:dotyk]) if wz[:dotyk] && wz[:dotyk] + deska < -0.5
    wynik << format('płatew %.2f mm pod połacią, a deski podbitki mają %.2f', -wz[:dotyk], deska) if wz[:dotyk] && deska > 0 && (wz[:dotyk] + deska).abs > 0.5
    wynik << "krokwie generatora przy krokwiach z aplikacji: #{wz[:krokwie]}" if wz[:krokwie] > 0
    wynik
  end

  # Podpory, których aplikacja do dachów nie uzna (za wysoko, za nisko albo nie równolegle do okapu) – opisy.
  def podpory_poza(pl)
    pol = pl[:polacie]
    a = pol[:kat] * Math::PI / 180.0
    G::Krok2.ustawienia(pl[:parametry])
    G::Krok2.podpory(pl).map do |q|
      d = [q[:od], q[:do]].map { |x, y, z| (z_polaci(pol, x, y) - z) * Math.cos(a) }
      rownolegla = (z_polaci(pol, q[:od][0], q[:od][1]) - z_polaci(pol, q[:do][0], q[:do][1])).abs < 0.01
      next nil if rownolegla && d.all? { |v| v >= -0.01 && v <= q[:szerokosc] / 2.0 * Math.sin(a) + 30.0 }
      format('podpora %s poza aplikacją (%.2f / %.2f mm od połaci)', q[:nazwa], d[0], d[1])
    end.compact
  end

  # Siatka pozycji: { ok: zamknięta i z objętością profilu, min_krawedz: najkrótsza krawędź ścian [mm] }.
  def siatka(poz)
    sciany = G::Siatka.uprosc(G::Projekt.siatka_pozycji(poz)[:sciany])
    k = G::Siatka.sprawdz(sciany)
    v = G::Projekt.objetosc_pozycji(poz)
    { ok: k[:zamknieta] && (k[:objetosc] - v).abs <= v * 1e-9 + 1e-3, min_krawedz: min_krawedz(sciany) }
  end

  # Najkrótsza krawędź pętli ścian siatki [mm] (SketchUp scala punkty bliższe niż 0,0254 mm).
  def min_krawedz(sciany)
    m = Float::INFINITY
    sciany.each do |s|
      s[:petle].each do |pts|
        pts.each_with_index do |a, i|
          b = pts[(i + 1) % pts.length]
          d = Math.sqrt((0..2).inject(0.0) { |acc, k| acc + (a[k] - b[k])**2 })
          m = d if d < m
        end
      end
    end
    m
  end
end

if __FILE__ == $PROGRAM_NAME
  ile = (ARGV[0] || 50).to_i
  start = (ARGV[1] || 1).to_i
  zle = 0
  t0 = Time.now
  ile.times do |i|
    d = LosoweDomy.dom(start + i)
    t = Time.now
    problemy, _pl = LosoweDomy.sprawdz(d)
    next if problemy.empty?
    zle += 1
    puts "ZIARNO #{d[:ziarno]} (#{(Time.now - t).round(1)} s): #{d[:opis]}"
    puts "  parametry: #{d[:parametry].inspect}"
    puts "  otwory: #{d[:otwory].inspect}" unless d[:otwory].empty?
    problemy.each { |pr| puts "  - #{pr}" }
  end
  puts "Domów: #{ile}, z problemami: #{zle}, czas #{(Time.now - t0).round(1)} s"
end
