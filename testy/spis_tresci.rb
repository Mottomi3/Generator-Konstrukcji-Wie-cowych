# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/spis_tresci.rb
# Zadanie: generator spisu treści kodu docs/SPIS_TRESCI.md – tematy → pliki, lista plików, metody i stałe z numerami wierszy.
# Tematy: spis treści, mapa kodu, gdzie co zmieniać, nagłówki plików, numery wierszy
# Zależy od: nagłówki plików (Plik:, Zadanie:, Tematy:, Zależy od:, Używają:) i komentarze nad metodami
# Używają: testy/uruchom.sh (sprawdzenie aktualności), Claude przy każdej zmianie kodu
#
# Użycie: ruby testy/spis_tresci.rb            – zapisuje docs/SPIS_TRESCI.md
#         ruby testy/spis_tresci.rb --sprawdz  – tylko sprawdza, czy plik jest aktualny (SPIS FAILURES: 0/1)

Encoding.default_external = Encoding::UTF_8
KAT = File.expand_path('..', File.dirname(__FILE__))
WYNIK = File.join(KAT, 'docs', 'SPIS_TRESCI.md')
PLUG = File.join(KAT, 'Plugins')
GLOWNY = File.join(PLUG, 'arte_madera_generator_wiencowy')

# Pliki w kolejności: rejestrator, main, log, rdzeń, SketchUp, okno, testy.
def pliki
  lista = [File.join(PLUG, 'arte_madera_generator_wiencowy.rb'), File.join(GLOWNY, 'main.rb'), File.join(GLOWNY, 'log.rb')]
  lista += Dir.glob(File.join(GLOWNY, 'rdzen', '*.rb')).sort
  lista += Dir.glob(File.join(GLOWNY, 'sketchup', '*.rb')).sort
  lista += Dir.glob(File.join(GLOWNY, 'html', '*.{html,js,css}')).sort
  lista += Dir.glob(File.join(KAT, 'testy', '**', '*.{rb,js,py,sh}')).reject { |f| f.include?('/wyniki/') }.sort
  lista
end

# Ścieżka względna do opisu (bez Plugins/arte_madera_generator_wiencowy/).
def wzgledna(sciezka)
  s = sciezka.sub(KAT + '/', '')
  s.sub('Plugins/arte_madera_generator_wiencowy/', '')
end

# Pole nagłówka (Plik:, Zadanie:, Tematy:…) z pierwszych 25 wierszy.
def pole(linie, nazwa)
  linie.first(25).each do |l|
    m = l.match(/\A\s*(?:#|\/\/|\*|<!--)?\s*#{Regexp.escape(nazwa)}:\s*(.+?)\s*(?:-->)?\s*\z/)
    return m[1].strip if m
  end
  nil
end

# Elementy pliku: [wiersz, nazwa, opis] – metody (def / function), klasy, moduły, stałe.
def elementy(sciezka, linie)
  wynik = []
  rozsz = File.extname(sciezka)
  linie.each_with_index do |l, i|
    opis = komentarz_nad(linie, i, rozsz)
    case rozsz
    when '.rb'
      if (m = l.match(/\A\s*def\s+(self\.)?([\w?!=]+)(\(.*\))?/))
        wynik << [i + 1, "#{m[2]}#{m[3]}", opis]
      elsif (m = l.match(/\A\s*(module|class)\s+([A-Z][\w:]*)/))
        wynik << [i + 1, "#{m[1]} #{m[2]}", opis] unless %w[ArteMadera GeneratorWiencowy].include?(m[2])
      elsif (m = l.match(/\A\s*([A-Z][A-Z0-9_]+)\s*=(?!=)/))
        wynik << [i + 1, m[1], opis]
      end
    when '.js'
      if (m = l.match(/\A\s*function\s+(\w+)\s*\(([^)]*)\)/))
        wynik << [i + 1, "#{m[1]}(#{m[2]})", opis]
      elsif (m = l.match(/\A\s*var\s+([A-Z][A-Z0-9_]+)\s*=/))
        wynik << [i + 1, m[1], opis]
      end
    when '.py'
      if (m = l.match(/\Adef\s+(\w+)\(([^)]*)\)/))
        wynik << [i + 1, "#{m[1]}(#{m[2]})", opis]
      end
    end
  end
  wynik
end

# Komentarz nad elementem: do 3 kolejnych wierszy komentarza bezpośrednio nad nim (bez wierszy pustych).
def komentarz_nad(linie, i, rozsz)
  znak = rozsz == '.js' ? '//' : '#'
  zebrane = []
  j = i - 1
  while j >= 0 && zebrane.length < 3
    l = linie[j].strip
    break unless l.start_with?(znak) && !l.start_with?('#!') && !l.start_with?('# encoding')
    zebrane.unshift(l.sub(/\A#{Regexp.escape(znak)}\s*/, ''))
    j -= 1
  end
  zebrane.join(' ')
end

# Treść spisu (Markdown).
def tresc
  opisy = []
  tematy = {}
  pliki.each do |f|
    linie = File.read(f, encoding: 'UTF-8').lines.map(&:chomp)
    rel = wzgledna(f)
    o = { rel: rel, linie: linie.length, zadanie: pole(linie, 'Zadanie') || '–', tematy: pole(linie, 'Tematy'),
          zalezy: pole(linie, 'Zależy od'), uzywaja: pole(linie, 'Używają'), elementy: elementy(f, linie) }
    opisy << o
    (o[:tematy] || '').split(/,(?!\d)/).map(&:strip).reject(&:empty?).each { |t| (tematy[t.downcase] ||= []) << rel }
  end
  out = []
  out << '# Spis treści kodu – ArteMadera Generator Wieńcowy'
  out << ''
  out << 'Plik generowany – nie edytuj ręcznie. Po każdej zmianie kodu: `ruby testy/spis_tresci.rb`'
  out << '(kontrola aktualności: `ruby testy/spis_tresci.rb --sprawdz`, wchodzi w `testy/uruchom.sh`).'
  out << 'Szukanie: najpierw tabela tematów (1), potem lista elementów pliku (3) – numer wiersza prowadzi prosto do miejsca.'
  out << 'Ścieżki plików wtyczki są względem `Plugins/arte_madera_generator_wiencowy/`.'
  out << ''
  out << '## 1. Gdzie co zmieniać – tematy → pliki'
  out << ''
  out << '| Temat | Plik |'
  out << '|---|---|'
  tematy.keys.sort.each { |t| out << "| #{t} | #{tematy[t].uniq.map { |r| "`#{r}`" }.join(', ')} |" }
  out << ''
  out << '## 2. Pliki'
  out << ''
  out << '| Plik | Wierszy | Zadanie |'
  out << '|---|---:|---|'
  opisy.each { |o| out << "| `#{o[:rel]}` | #{o[:linie]} | #{o[:zadanie]} |" }
  out << ''
  out << '## 3. Zawartość plików'
  opisy.each do |o|
    out << ''
    out << "### #{o[:rel]} (#{o[:linie]} wierszy)"
    out << ''
    out << "#{o[:zadanie]}"
    out << ''
    out << "Zależy od: #{o[:zalezy]}" if o[:zalezy]
    out << "Używają: #{o[:uzywaja]}" if o[:uzywaja]
    next if o[:elementy].empty?
    out << ''
    out << '| Wiersz | Element | Opis |'
    out << '|---:|---|---|'
    o[:elementy].each { |w, n, d| out << "| #{w} | `#{n.gsub('|', '\\|')}` | #{d.gsub('|', '\\|')} |" }
  end
  out.join("\n") + "\n"
end

nowa = tresc
if ARGV.include?('--sprawdz')
  stara = File.exist?(WYNIK) ? File.read(WYNIK, encoding: 'UTF-8') : ''
  if stara == nowa
    puts 'Spis treści aktualny.'
    puts 'SPIS FAILURES: 0'
    exit 0
  end
  puts 'BŁĄD   docs/SPIS_TRESCI.md jest nieaktualny – uruchom: ruby testy/spis_tresci.rb'
  puts 'SPIS FAILURES: 1'
  exit 1
end
File.write(WYNIK, nowa)
puts "Zapisano #{WYNIK.sub(KAT + '/', '')} (#{nowa.lines.length} wierszy)."
