# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: main.rb
# Zadanie: stałe wtyczki (wersja, numer kompilacji, katalogi) i ładowanie modułów w kolejności zależności.
# Tematy: ładowanie modułów, MODULE_FILES, numer kompilacji, wersja, katalog wtyczki
# Zależy od: log.rb i wszystkie moduły z MODULE_FILES
# Używają: arte_madera_generator_wiencowy.rb (rejestrator)
#
# Nowy plik .rb → dopisz go do MODULE_FILES (kolejność zależności). Numer kompilacji = numer rundy prac,
# ten sam w rejestratorze (pilnuje testy/sprawdz_zasady.rb).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require 'sketchup.rb'
require 'json'

module ArteMadera
  module GeneratorWiencowy
    PLUGIN_ID      = 'arte_madera_generator_wiencowy'.freeze unless const_defined?(:PLUGIN_ID)
    PLUGIN_NAME    = 'ArteMadera – Generator Wieńcowy'.freeze unless const_defined?(:PLUGIN_NAME)
    PLUGIN_VERSION = '1.0.0'.freeze unless const_defined?(:PLUGIN_VERSION)
    PLUGIN_AUTHOR  = 'Arte Madera'.freeze unless const_defined?(:PLUGIN_AUTHOR)
    # Numer kompilacji – rośnie z każdą rundą prac; ten sam w arte_madera_generator_wiencowy.rb.
    PLUGIN_BUILD      = '2'.freeze unless const_defined?(:PLUGIN_BUILD)
    PLUGIN_BUILD_DATE = '2026-10-13'.freeze unless const_defined?(:PLUGIN_BUILD_DATE)

    unless const_defined?(:EXTENSION_DIR)
      katalog = File.dirname(__FILE__).dup
      katalog.force_encoding('UTF-8') if katalog.respond_to?(:force_encoding)
      EXTENSION_DIR = katalog.freeze
    end

    # Dziennik najpierw – z niego korzystają wszystkie moduły.
    begin
      Sketchup.require(File.join(EXTENSION_DIR, 'log'))
    rescue LoadError, StandardError => e
      puts "[ArteMadera GW] Nie można załadować dziennika (log.rb): #{e.class}: #{e.message}"
    end

    # Moduły w kolejności zależności: rdzeń (czysty Ruby), potem warstwa SketchUpa.
    MODULE_FILES = %w[
      rdzen/geometria rdzen/parametry_lista rdzen/parametry rdzen/obrys rdzen/sciany rdzen/wience rdzen/otwory
      rdzen/usztywnienie rdzen/styki rdzen/bryla rdzen/elementy rdzen/dach rdzen/szczyty rdzen/pod_dachem rdzen/bale rdzen/zamek
      rdzen/siatka rdzen/pozycje rdzen/statyka rdzen/podloga rdzen/projekt rdzen/kontrola
      sketchup/konwersja sketchup/atrybuty sketchup/ustawienia sketchup/wejscie sketchup/budowa sketchup/okno
      sketchup/sterowanie sketchup/menu
    ].freeze unless const_defined?(:MODULE_FILES)

    MODULE_FILES.each do |plik|
      begin
        Sketchup.require(File.join(EXTENSION_DIR, plik))
      rescue LoadError, StandardError => e
        if defined?(Log)
          Log.error("Nie można załadować modułu #{plik}", e, 8)
        else
          puts "[ArteMadera GW] Nie można załadować modułu #{plik}: #{e.class}: #{e.message}"
        end
      end
    end

    unless file_loaded?(__FILE__)
      Menu.dodaj if defined?(Menu)
      file_loaded(__FILE__)
    end
  end
end
