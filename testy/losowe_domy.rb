# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/losowe_domy.rb
# Zadanie: losowe domy do testów – obrys (prostokąt, L), działowe, węgły, otwory i parametry z ziarna; sprawdzenie jednego domu.
# Tematy: losowe domy, test losowy, ziarno, sprawdzenie domu, kolizje, bryły zamknięte, mijanka, długości bali
# Zależy od: testy/pomoc.rb, testy/kolizje_belek.rb
# Używają: testy/t_losowe.rb, ręcznie (ruby -I testy/atrapa testy/losowe_domy.rb [liczba] [ziarno])
#
# Dom z ziarna jest zawsze ten sam (Random.new(ziarno)) – błąd z raportu odtwarza się podając ziarno.

require File.expand_path('pomoc', File.dirname(__FILE__))
require File.expand_path('kolizje_belek', File.dirname(__FILE__))

module LosoweDomy
  G = ArteMadera::GeneratorWiencowy

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
    { ziarno: ziarno, opis: opis.join(', '), segmenty: seg, parametry: p, otwory: otw }
  end

  # Losowe parametry (wartości tekstowe jak z okna).
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
      'szczelina_styku' => wybierz(r, %w[0 0 2])
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
      plan_pelny(dom[:segmenty], dom[:parametry], dom[:otwory])
    rescue => e
      return [["wyjątek #{e.class}: #{e.message} @ #{e.backtrace.first(3).join(' | ')}"], nil]
    end
    return [["błędy: #{pl[:bledy].join('; ')}"], pl] unless pl[:bledy].empty?
    k = G::Kontrola.wszystko(pl)
    problemy << "kolizje w zamkach: #{k[:kolizje].length} (#{k[:kolizje].first.inspect})" unless k[:kolizje].empty?
    problemy << "mijanka: #{k[:mijanka].first(3).inspect}" unless k[:mijanka].empty?
    if !k[:styki_bez_zamka].empty? && pl[:ostrzezenia].none? { |u| u.include?('styk bez zamka') }
      problemy << "styki bez zamka bez ostrzeżenia: #{k[:styki_bez_zamka].first(3).inspect}"
    end
    if !k[:za_dlugie].empty? && pl[:ostrzezenia].none? { |u| u.include?('dłuższe niż') }
      problemy << "za długie bale bez ostrzeżenia: #{k[:za_dlugie].first(3).inspect}"
    end
    zle = (pl[:pozycje] + pl[:pozycje_elementow]).reject { |poz| siatka_ok?(poz) }
    problemy << "bryły niezamknięte: #{zle.map { |x| "#{x[:prefiks]} #{x[:nazwa]}" }.first(5).join(', ')}" unless zle.empty?
    pl[:sciany].select { |w| w[:szczyt] }.each do |w|
      nad = nad_linia(pl, w[:id])
      problemy << format('%s: bale ponad linią dachu o %.2f mm', w[:id], nad) if nad && nad > 0.01
    end
    krotkie = pl[:bale].select { |b| b[:dl] < 1.0 || b[:h] < 1.0 }
    problemy << "bale o zerowym wymiarze: #{krotkie.length}" unless krotkie.empty?
    nazwy = (pl[:pozycje] + pl[:pozycje_elementow]).map { |x| x[:nazwa] }
    problemy << 'powtórzone nazwy pozycji' unless nazwy.uniq.length == nazwy.length
    if belki
      %w[P K].each do |pr|
        n = kolizje_belek(pl, pr, 4)
        problemy << "#{pr}: kolizje z balami (#{n} punktów)" if n > 0
      end
    end
    [problemy, pl]
  end

  # Czy siatka pozycji jest zamknięta i ma objętość profilu.
  def siatka_ok?(poz)
    prof = G::Bryla.profil(poz[:dl], poz[:t], poz[:h], poz[:cechy])
    k = G::Siatka.sprawdz(G::Siatka.uprosc(G::Projekt.siatka_pozycji(poz)[:sciany]))
    v = G::Bryla.objetosc(prof)
    k[:zamknieta] && (k[:objetosc] - v).abs <= v * 1e-9 + 1e-3
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
