# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/zlozone_domy.rb
# Zadanie: losowe domy o obrysach złożonych (L, T, U, Z, krzyż, H) z działowymi w liniach uskoków – obrys i działowe z ziarna, sprawdzenie jak w losowych domach.
# Tematy: domy złożone, obrys T, obrys U, obrys Z, obrys krzyż, obrys H, działowa w linii uskoku w testach, obrys z siatki pól, ziarno domu złożonego
# Zależy od: testy/losowe_domy.rb (parametry, dodatki rund, sprawdzenie), testy/pomoc.rb
# Używają: testy/t_zlozone.rb, ręcznie (ruby -I testy/atrapa testy/zlozone_domy.rb [liczba] [ziarno])
#
# Obrys powstaje z siatki 3 × 3 pól o losowych wymiarach: wzór mówi, które pola należą do domu. Działowe biegną po
# liniach siatki na całą szerokość domu – tam, gdzie linia jest bokiem obrysu (uskok), działowa leży w linii ściany
# zewnętrznej (rdzen/sciana_w_linii.rb). Błąd z rundy 14: taka działowa kończyła obliczenia wyjątkiem.

require File.expand_path('losowe_domy', File.dirname(__FILE__))

module ZlozoneDomy
  # Wzory pól (wiersze od dołu, kolumny od lewej): 1 – pole należy do domu.
  WZORY = {
    'L' => [[1, 1, 1], [1, 1, 0], [1, 1, 0]],
    'T' => [[0, 1, 0], [0, 1, 0], [1, 1, 1]],
    'U' => [[1, 1, 1], [1, 0, 1], [1, 0, 1]],
    'Z' => [[1, 1, 0], [1, 1, 1], [0, 1, 1]],
    'krzyż' => [[0, 1, 0], [1, 1, 1], [0, 1, 0]],
    'H' => [[1, 0, 1], [1, 1, 1], [1, 0, 1]],
    'L z dwoma uskokami' => [[1, 1, 1], [1, 1, 0], [1, 0, 0]]
  }.freeze unless const_defined?(:WZORY)
  # Ziarna domów złożonych zaczynają się od tego numeru (niżej – domy z testy/losowe_domy.rb).
  ZIARNA_OD = 10_000 unless const_defined?(:ZIARNA_OD)

  module_function

  # Wzór obrócony o ćwierć obrotu n razy i odbity (odbicie = true) – wszystkie ułożenia kształtu.
  def ulozony(wzor, n, odbicie)
    w = wzor.map(&:dup)
    n.times { w = w.transpose.map(&:reverse) }
    odbicie ? w.map(&:reverse) : w
  end

  # Wierzchołki obrysu (przeciwnie do wskazówek zegara) sumy pól wzoru na siatce xs × ys.
  def obrys(wzor, xs, ys)
    w = lambda { |i, j| i >= 0 && j >= 0 && i < 3 && j < 3 && wzor[j][i] == 1 }
    odcinki = []
    3.times do |j|
      3.times do |i|
        next unless w.call(i, j)
        odcinki << [[xs[i], ys[j]], [xs[i + 1], ys[j]]] unless w.call(i, j - 1)
        odcinki << [[xs[i + 1], ys[j]], [xs[i + 1], ys[j + 1]]] unless w.call(i + 1, j)
        odcinki << [[xs[i + 1], ys[j + 1]], [xs[i], ys[j + 1]]] unless w.call(i, j + 1)
        odcinki << [[xs[i], ys[j + 1]], [xs[i], ys[j]]] unless w.call(i - 1, j)
      end
    end
    nast = {}
    odcinki.each { |a, b| nast[a] = b }
    start = odcinki.map { |a, _b| a }.min
    pts = [start]
    pts << nast[pts.last] until nast[pts.last] == start
    pts.each_with_index.reject do |q, k|
      a = pts[k - 1]
      b = pts[(k + 1) % pts.length]
      (q[0] - a[0]) * (b[1] - q[1]) - (q[1] - a[1]) * (b[0] - q[0]) == 0
    end.map(&:first)
  end

  # Dom z ziarna: { ziarno:, opis:, segmenty:, parametry:, otwory:, sciany: }.
  def dom(ziarno)
    r = Random.new(ziarno)
    nazwa = WZORY.keys[r.rand(WZORY.length)]
    wzor = ulozony(WZORY[nazwa], r.rand(4), r.rand < 0.5)
    xs = [0]
    ys = [0]
    3.times { xs << xs.last + 1800 + r.rand(23) * 100 }
    3.times { ys << ys.last + 1800 + r.rand(23) * 100 }
    pts = obrys(wzor, xs, ys)
    seg = wielokat(pts)
    opis = ["#{nazwa} #{xs.last}×#{ys.last}"]
    [[:x, xs[1]], [:x, xs[2]], [:y, ys[1]], [:y, ys[2]]].each do |os, v|
      next unless r.rand < 0.45
      seg << (os == :x ? [[v, 0], [v, ys.last]] : [[0, v], [xs.last, v]])
      opis << "działowa #{os}=#{v} przez cały dom"
    end
    p = LosoweDomy.parametry(r)
    LosoweDomy.dodatki_r5(Random.new(ziarno * 104_729 + 31), p, opis)
    LosoweDomy.dodatki_r7(Random.new(ziarno * 2_750_159 + 3), p, opis)
    LosoweDomy.dodatki_r8(Random.new(ziarno * 3_331_333 + 11), p, opis)
    LosoweDomy.dodatki_r9(Random.new(ziarno * 4_256_249 + 17), p, opis)
    { ziarno: ziarno, opis: opis.join(', '), segmenty: seg, parametry: p, otwory: [], sciany: {} }
  end
end

if __FILE__ == $PROGRAM_NAME
  ile = (ARGV[0] || 50).to_i
  start = (ARGV[1] || ZlozoneDomy::ZIARNA_OD + 1).to_i
  zle = 0
  t0 = Time.now
  ile.times do |i|
    d = ZlozoneDomy.dom(start + i)
    problemy, _pl = LosoweDomy.sprawdz(d)
    next if problemy.empty?
    zle += 1
    puts "ZIARNO #{d[:ziarno]}: #{d[:opis]}"
    puts "  parametry: #{d[:parametry].inspect}"
    problemy.each { |pr| puts "  - #{pr}" }
  end
  puts "Domów złożonych: #{ile}, z problemami: #{zle}, czas #{(Time.now - t0).round(1)} s"
end
