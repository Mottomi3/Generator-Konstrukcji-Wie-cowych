# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/buduj_rbz.rb
# Zadanie: paczka instalacyjna .rbz (zip rejestratora i folderu wtyczki) – do instalacji w Menedżerze rozszerzeń SketchUpa.
# Tematy: paczka rbz, instalacja, wydanie
# Zależy od: polecenie zip
# Używają: zamknięcie rundy (.claude/skills/gw-runda/SKILL.md)
#
# Użycie: ruby testy/buduj_rbz.rb – zapisuje arte_madera_generator_wiencowy_<wersja>.rbz w katalogu głównym repozytorium.

Encoding.default_external = Encoding::UTF_8
require 'fileutils'
require 'tmpdir'

KAT = File.expand_path('..', File.dirname(__FILE__))
PLUG = File.join(KAT, 'Plugins')
wersja = File.read(File.join(PLUG, 'arte_madera_generator_wiencowy', 'main.rb'))[/PLUGIN_VERSION\s*=\s*'([\d.]+)'/, 1]
kompilacja = File.read(File.join(PLUG, 'arte_madera_generator_wiencowy', 'main.rb'))[/PLUGIN_BUILD\s*=\s*'(\d+)'/, 1]
cel = File.join(KAT, "arte_madera_generator_wiencowy_#{wersja}.rbz")
FileUtils.rm_f(cel)
pliki = ['arte_madera_generator_wiencowy.rb'] +
        Dir.chdir(PLUG) { Dir.glob('arte_madera_generator_wiencowy/**/*').select { |f| File.file?(f) }.sort }
Dir.chdir(PLUG) do
  ok = system('zip', '-q', '-X', cel, *pliki)
  abort('BŁĄD: zip nie zadziałał') unless ok
end
puts "Zapisano #{File.basename(cel)}: #{pliki.length} plików, kompilacja #{kompilacja}, #{File.size(cel)} B."
