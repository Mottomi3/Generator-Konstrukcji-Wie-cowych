# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/sprawdz_zasady.rb
# Zadanie: kontrola zasad kodu – Ruby 2.2, ES5, rdzeń bez API SketchUpa, nagłówki plików, komentarze nad metodami, długość plików, kompilacja, MODULE_FILES.
# Tematy: zasady kodu, Ruby 2.2, ES5, nagłówki plików, jeden temat = jeden plik, długość pliku, numer kompilacji, MODULE_FILES
# Zależy od: ripper, node + acorn (ES5)
# Używają: testy/uruchom.sh, przed każdym commitem
#
# Użycie: ruby testy/sprawdz_zasady.rb – wiersze BŁĄD / UWAGA i ostatnia linia „ZASADY FAILURES: n”.

require 'ripper'
require 'open3'
Encoding.default_external = Encoding::UTF_8

KAT = File.expand_path('..', File.dirname(__FILE__))
PLUG = File.join(KAT, 'Plugins')
DIR = File.join(PLUG, 'arte_madera_generator_wiencowy')
# Plik dłuższy – ostrzeżenie (podziel temat); znacznie dłuższy – błąd.
UWAGA_WIERSZY = 450
BLAD_WIERSZY = 700
fails = []
warns = []

# Metody, których nie ma w Ruby 2.2 (NoMethodError w SketchUpie 2023 nie grozi, ale zasada jest wspólna z Dokumentacją 2D).
RUBY22_MISSING = %w[sum dig match? transform_values transform_keys clamp then yield_self filter_map tally delete_prefix
                    delete_suffix except fetch_values casecmp? unpack1 union difference intersection].freeze

def walk(node, &blk)
  return unless node.is_a?(Array)
  blk.call(node)
  node.each { |n| walk(n, &blk) }
end

def rel(sciezka)
  sciezka.sub(KAT + '/', '')
end

rb_files = [File.join(PLUG, 'arte_madera_generator_wiencowy.rb')] + Dir.glob(File.join(DIR, '**', '*.rb')).sort
rb_files.each do |path|
  r = rel(path)
  src = File.read(path, encoding: 'UTF-8')
  tree = Ripper.sexp(src)
  if tree.nil?
    fails << "#{r}: błąd składni Ruby"
    next
  end
  walk(tree) do |n|
    case n[0]
    when :call, :method_add_arg, :command_call
      op = n[2]
      meth = n[3]
      fails << "#{r}:#{op[2][0]}: operator &. (brak w Ruby 2.2)" if op.is_a?(Array) && op[0] == :@op && op[1] == '&.'
      if meth.is_a?(Array) && meth[0] == :@ident && RUBY22_MISSING.include?(meth[1])
        fails << "#{r}:#{meth[2][0]}: .#{meth[1]} (brak w Ruby 2.2#{meth[1] == 'sum' ? ' – użyj .inject(0.0) { |s, x| s + x }' : ''})"
      end
    when :do_block
      body = n[2]
      if body.is_a?(Array) && body[0] == :bodystmt && (body[2] || body[4])
        line = nil
        walk(n) { |m| line ||= m[2][0] if m.is_a?(Array) && m[0].to_s.start_with?('@') && m[2].is_a?(Array) }
        fails << "#{r}:#{line}: rescue/ensure w bloku do…end bez begin (Ruby 2.2 tego nie zna)"
      end
    when :var_ref, :top_const_ref
      c = n[1]
      fails << "#{r}:#{c[2][0]}: #{c[1]} bez Geom:: – użyj Geom::Vector3d.new(…)" if c.is_a?(Array) && c[0] == :@const && %w[X_AXIS Y_AXIS Z_AXIS ORIGIN].include?(c[1])
    end
  end
  Ripper.lex(src).each do |(pos, type, tok)|
    fails << "#{r}:#{pos[0]}: heredoc <<~ (brak w Ruby 2.2)" if type == :on_heredoc_beg && tok.start_with?('<<~')
    fails << "#{r}:#{pos[0]}: placeholder w komentarzu (#{$1})" if type == :on_comment && tok =~ /\b(TODO|FIXME|XXX)\b/
  end
  linie = src.lines
  linie.each_with_index do |l, i|
    fails << "#{r}:#{i + 1}: .floor/.ceil z argumentem (Ruby 2.4+)" if l =~ /\.(floor|ceil)\(\s*-?\d/
  end
  # Rdzeń bez API SketchUpa (testowalny bez atrapy).
  if r.include?('/rdzen/')
    linie.each_with_index do |l, i|
      next if l.strip.start_with?('#')
      fails << "#{r}:#{i + 1}: API SketchUpa w rdzeniu (#{$1}) – przenieś do sketchup/" if l =~ /\b(Sketchup::|Geom::|UI\.|Sketchup\.)/
    end
  end
  # puts / print tylko w dzienniku i w awaryjnych komunikatach ładowania.
  unless r.end_with?('/log.rb') || r.end_with?('arte_madera_generator_wiencowy.rb')
    walk(tree) do |n|
      next unless [:command, :fcall, :vcall].include?(n[0])
      id = n[1]
      next unless id.is_a?(Array) && id[0] == :@ident && %w[puts print].include?(id[1])
      i = id[2][0] - 1
      ctx = linie[[i - 3, 0].max..i].join
      next if ctx.include?('defined?(Log)') || ctx.include?('dziennika (log.rb)')
      fails << "#{r}:#{i + 1}: #{id[1]} w module – komunikaty przez Log.error / warn / info"
    end
  end
  # Nagłówek pliku i komentarze nad metodami (spis treści z nich powstaje).
  plik = linie.first(12).join[/Plik:\s*(\S+)/, 1]
  oczekiwany = r.sub('Plugins/arte_madera_generator_wiencowy/', '').sub('Plugins/', '')
  fails << "#{r}: nagłówek bez „Plik: #{oczekiwany}”" unless plik && oczekiwany.end_with?(plik)
  %w[Zadanie Tematy].each { |p| fails << "#{r}: nagłówek bez „#{p}:”" unless linie.first(25).any? { |l| l =~ /#\s*#{p}:/ } }
  linie.each_with_index do |l, i|
    next unless l =~ /\A\s*def\s+/
    fails << "#{r}:#{i + 1}: metoda bez komentarza w wierszu nad nią (opis do spisu treści)" unless i > 0 && linie[i - 1].strip.start_with?('#')
  end
  if linie.length > BLAD_WIERSZY
    fails << "#{r}: #{linie.length} wierszy (> #{BLAD_WIERSZY}) – podziel plik według tematów"
  elsif linie.length > UWAGA_WIERSZY
    warns << "#{r}: #{linie.length} wierszy (> #{UWAGA_WIERSZY}) – rozważ podział"
  end
end

# Numer kompilacji – ten sam w rejestratorze i main.rb.
reg = File.read(File.join(PLUG, 'arte_madera_generator_wiencowy.rb'))
main = File.read(File.join(DIR, 'main.rb'))
b1 = reg[/PLUGIN_BUILD\s*=\s*'(\d+)'/, 1]
b2 = main[/PLUGIN_BUILD\s*=\s*'(\d+)'/, 1]
d1 = reg[/PLUGIN_BUILD_DATE\s*=\s*'([\d-]+)'/, 1]
d2 = main[/PLUGIN_BUILD_DATE\s*=\s*'([\d-]+)'/, 1]
fails << "PLUGIN_BUILD różny: rejestrator #{b1.inspect}, main.rb #{b2.inspect}" if b1.nil? || b1 != b2
fails << "PLUGIN_BUILD_DATE różna: #{d1.inspect} / #{d2.inspect}" if d1.nil? || d1 != d2

# MODULE_FILES = wszystkie pliki .rb wtyczki (bez main i log).
mods = main[/MODULE_FILES\s*=\s*%w\[(.*?)\]/m, 1].to_s.split
have = Dir.glob(File.join(DIR, '**', '*.rb')).map { |f| f.sub(DIR + '/', '').sub(/\.rb\z/, '') } - %w[main log]
brak = have - mods
nadmiar = mods - have
fails << "MODULE_FILES w main.rb nie zawiera: #{brak.join(', ')}" unless brak.empty?
fails << "MODULE_FILES zawiera nieistniejące: #{nadmiar.join(', ')}" unless nadmiar.empty?

# JS okna = ES5; nagłówki plików okna.
acorn = %w[/opt/node-tools/node_modules/acorn /opt/npm-tools/node_modules/acorn].find { |d| File.directory?(d) }
js_files = Dir.glob(File.join(DIR, 'html', '*.js')).sort
if acorn
  js = "var a=require(#{acorn.inspect});var fs=require('fs');process.argv.slice(1).forEach(function(f){try{a.parse(fs.readFileSync(f,'utf8'),{ecmaVersion:5})}catch(e){console.log(f+':'+(e.loc?e.loc.line:'?')+': składnia spoza ES5 – '+e.message)}});"
  out, _st = Open3.capture2e('node', '-e', js, *js_files)
  out.each_line { |l| fails << rel(l.strip) unless l.strip.empty? }
else
  warns << 'brak parsera acorn – kontrola ES5 tylko wzorcami'
  js_files.each do |f|
    File.read(f, encoding: 'UTF-8').each_line.with_index(1) do |line, i|
      next if line =~ /^\s*(\/\/|\*)/
      fails << "#{rel(f)}:#{i}: możliwa składnia ES6+: #{line.strip[0, 90]}" if line =~ /\?\.[A-Za-z_$(\[]|\?\?|=>|\blet\s|\bconst\s|`|\bclass\s+[A-Z]|\basync\s+function|\bawait\s/
    end
  end
end
Dir.glob(File.join(DIR, 'html', '*')).sort.each do |f|
  tekst = File.read(f, encoding: 'UTF-8')
  fails << "#{rel(f)}: placeholder (TODO/FIXME)" if tekst =~ /\b(TODO|FIXME)\b/
  fails << "#{rel(f)}: nagłówek bez „Plik: html/#{File.basename(f)}”" unless tekst.lines.first(12).join.include?("Plik: html/#{File.basename(f)}")
end
js_files.each do |f|
  linie = File.read(f, encoding: 'UTF-8').lines
  if linie.length > BLAD_WIERSZY
    fails << "#{rel(f)}: #{linie.length} wierszy (> #{BLAD_WIERSZY}) – podziel plik według tematów"
  elsif linie.length > UWAGA_WIERSZY
    warns << "#{rel(f)}: #{linie.length} wierszy (> #{UWAGA_WIERSZY}) – rozważ podział"
  end
  linie.each_with_index do |l, i|
    next unless l =~ /\A\s*function\s+\w+\s*\(/
    next if i > 0 && linie[i - 1].strip.start_with?('//')
    fails << "#{rel(f)}:#{i + 1}: funkcja bez komentarza nad nią (opis do spisu treści)"
  end
end

warns.each { |w| puts "UWAGA  #{w}" }
fails.each { |f| puts "BŁĄD   #{f}" }
puts "ZASADY FAILURES: #{fails.size}"
exit(fails.empty? ? 0 : 1)
