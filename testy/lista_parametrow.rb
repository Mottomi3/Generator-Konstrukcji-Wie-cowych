# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/lista_parametrow.rb
# Zadanie: generator docs/parametry.md – wszystkie parametry okna (sekcja, etykieta, wartość domyślna, zakres, wybory, podpowiedź) i szablony wbudowane.
# Tematy: lista parametrów – dokument, wartości domyślne – dokument, szablony wbudowane – dokument
# Zależy od: Plugins/arte_madera_generator_wiencowy/rdzen/parametry_lista.rb
# Używają: testy/uruchom.sh (sprawdzenie aktualności)
#
# Użycie: ruby testy/lista_parametrow.rb            – zapisuje docs/parametry.md
#         ruby testy/lista_parametrow.rb --sprawdz  – tylko sprawdza aktualność (FAILURES: 0/1)

Encoding.default_external = Encoding::UTF_8
KAT = File.expand_path('..', File.dirname(__FILE__))
require File.join(KAT, 'Plugins', 'arte_madera_generator_wiencowy', 'rdzen', 'parametry_lista')
L = ArteMadera::GeneratorWiencowy::ParametryLista
WYNIK = File.join(KAT, 'docs', 'parametry.md')

# Liczba bez zbędnego ,0 (przecinek dziesiętny).
def fmt(v)
  return v.to_s unless v.is_a?(Numeric)
  f = v.to_f
  (f - f.round).abs < 1e-9 ? f.round.to_s : format('%.1f', f).tr('.', ',')
end

# Komórka tabeli bez znaków psujących Markdown.
def kom(t)
  t.to_s.gsub('|', '/').gsub("\n", ' ')
end

# Treść dokumentu.
def tresc
  w = []
  w << '# Parametry generatora (wszystkie ustawiane w oknie)'
  w << ''
  w << 'Plik generowany z `rdzen/parametry_lista.rb` (`ruby testy/lista_parametrow.rb`) – nie edytować ręcznie.'
  w << 'Ostatnio użyte wartości i własne szablony zapisują się na komputerze (`sketchup/ustawienia.rb`).'
  w << ''
  L::SEKCJE.each do |klucz, tytul, _otwarta|
    w << "## #{tytul}"
    w << ''
    w << '| Klucz | Parametr | Domyślnie | Zakres / wybory | Podpowiedź |'
    w << '|---|---|---|---|---|'
    L::LISTA.select { |p| p[:sekcja] == klucz }.each do |p|
      zakres = if p[:rodzaj] == :wybor
                 L.wybory(p).map { |k, opis| "`#{k}` – #{opis}" }.join('; ')
               elsif p[:min] || p[:max]
                 "#{fmt(p[:min])} … #{fmt(p[:max])}"
               else
                 p[:rodzaj] == :przekroj ? 'szer. × wys.' : ''
               end
      dom = "#{fmt(p[:domyslna])}#{p[:jednostka] && !p[:jednostka].empty? ? ' ' + p[:jednostka] : ''}"
      w << "| `#{p[:klucz]}` | #{kom(p[:etykieta])} | #{kom(dom)} | #{kom(zakres)} | #{kom(p[:podpowiedz])} |"
    end
    w << ''
  end
  w << '## Szablony wbudowane'
  w << ''
  w << '| Szablon | Zmienione wartości |'
  w << '|---|---|'
  L::SZABLONY.each { |n, v| w << "| #{n} | #{v.map { |k, x| "`#{k}` = #{fmt(x)}" }.join(', ')} |" }
  w << ''
  w.join("\n")
end

if ARGV.include?('--sprawdz')
  ok = File.exist?(WYNIK) && File.read(WYNIK) == tresc
  puts 'BŁĄD   docs/parametry.md jest nieaktualny – uruchom: ruby testy/lista_parametrow.rb' unless ok
  puts "FAILURES: #{ok ? 0 : 1}"
  exit(ok ? 0 : 1)
end
File.write(WYNIK, tresc)
puts "Zapisano #{WYNIK}"
