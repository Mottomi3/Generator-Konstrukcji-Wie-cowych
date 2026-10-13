# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: arte_madera_generator_wiencowy.rb (rejestrator)
# Zadanie: rejestracja rozszerzenia w SketchUpie – jedyny plik ładowany automatycznie z folderu Plugins.
# Tematy: rejestracja rozszerzenia, opis w Menedżerze rozszerzeń, numer kompilacji
# Zależy od: arte_madera_generator_wiencowy/main.rb
# Używają: SketchUp
#
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require 'sketchup.rb'
require 'extensions.rb'

module ArteMadera
  module GeneratorWiencowy
    PLUGIN_ID      = 'arte_madera_generator_wiencowy'.freeze unless const_defined?(:PLUGIN_ID)
    PLUGIN_NAME    = 'ArteMadera – Generator Wieńcowy'.freeze unless const_defined?(:PLUGIN_NAME)
    PLUGIN_VERSION = '1.0.0'.freeze unless const_defined?(:PLUGIN_VERSION)
    PLUGIN_AUTHOR  = 'Arte Madera'.freeze unless const_defined?(:PLUGIN_AUTHOR)
    # Numer kompilacji – ten sam co w arte_madera_generator_wiencowy/main.rb.
    PLUGIN_BUILD      = '1'.freeze unless const_defined?(:PLUGIN_BUILD)
    PLUGIN_BUILD_DATE = '2026-10-13'.freeze unless const_defined?(:PLUGIN_BUILD_DATE)

    plik_rejestratora = __FILE__.dup
    plik_rejestratora.force_encoding('UTF-8') if plik_rejestratora.respond_to?(:force_encoding)

    unless file_loaded?(plik_rejestratora)
      begin
        rozszerzenie = SketchupExtension.new(PLUGIN_NAME, File.join(PLUGIN_ID, 'main'))
        rozszerzenie.description = 'Generator domów z bali (konstrukcja wieńcowa): z narysowanego obrysu i osi ścian ' \
                                   'działowych tworzy ściany z bali z zamkami narożnymi, kontrforami i stykami na mijankę; ' \
                                   'każdy bal to komponent z atrybutami dla Dokumentacji 2D. ' \
                                   'Menu: Rozszerzenia → ArteMadera Generator Wieńcowy. ' \
                                   "Kompilacja #{PLUGIN_BUILD} (#{PLUGIN_BUILD_DATE})."
        rozszerzenie.version = PLUGIN_VERSION
        rozszerzenie.creator = PLUGIN_AUTHOR
        rozszerzenie.copyright = "#{Time.now.year} #{PLUGIN_AUTHOR}"
        Sketchup.register_extension(rozszerzenie, true)
      rescue => e
        puts "[ArteMadera GW] Błąd rejestracji rozszerzenia: #{e.class}: #{e.message}"
        puts e.backtrace.join("\n") if e.backtrace
      end
      file_loaded(plik_rejestratora)
    end
  end
end
