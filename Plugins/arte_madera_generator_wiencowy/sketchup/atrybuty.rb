# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/atrybuty.rb
# Zadanie: atrybuty w modelu – zgodność z Dokumentacją 2D (słownik ArteMadera) i zapis wejścia generatora do przebudowy.
# Tematy: atrybuty, słownik ArteMadera, rola timber, prefiks Bs/Kf/Sz/Pw/L/Pd/Pl/Kr, pozycja, zapis parametrów w modelu, przebudowa, podpis zawartości, ręczne poprawki
# Zależy od: log.rb
# Używają: sketchup/budowa.rb, sketchup/wejscie.rb, sketchup/sterowanie.rb
#
# Słownik 'ArteMadera' (czyta Dokumentacja 2D): rola = 'timber', prefiks = 'Bs' | 'Kf' | 'Sz' (bale) albo 'Pw' | 'L' |
# 'Pd' | 'P' | 'K' (belki podłogi i dachu – kody grup Dokumentacji 2D), pozycja, nazwa – tylko na definicjach. Grupy domu i ścian nie dostają
# roli: 'skip' na grupie nadrzędnej wyłączyłby w Dokumentacji 2D wszystkie bale (dziedziczenie w
# ProjectBuilder#walk_entity). Prefiksy trzeba dopisać w Dokumentacji 2D (element_roles.rb, PREFIX_GROUPS) – do tego
# czasu Dokumentacja 2D ich nie rozpozna.
# Słownik 'ArteMadera_GW' (generator): na grupie domu – wejscie (JSON), dom (identyfikator), podpis, kompilacja;
# na definicji – dom, nazwa; na instancji – sciana, wieniec, pozycja.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require 'json'

module ArteMadera
  module GeneratorWiencowy
    module Atrybuty
      DICT_AM = 'ArteMadera'.freeze unless const_defined?(:DICT_AM)
      DICT_GW = 'ArteMadera_GW'.freeze unless const_defined?(:DICT_GW)

      module_function

      # Czy encja to grupa domu z generatora.
      def dom?(ent)
        ent.respond_to?(:get_attribute) && !ent.get_attribute(DICT_GW, 'wejscie').nil?
      end

      # Zapis wejścia (segmenty, parametry, otwory, z0) i identyfikatora domu na grupie.
      def zapisz_dom(grupa, wejscie, dom_id, kompilacja)
        grupa.set_attribute(DICT_GW, 'wejscie', JSON.generate(wejscie))
        grupa.set_attribute(DICT_GW, 'dom', dom_id)
        grupa.set_attribute(DICT_GW, 'kompilacja', kompilacja.to_s)
        nil
      end

      # Wejście zapisane na grupie domu (Hash) albo nil.
      def czytaj_wejscie(grupa)
        tekst = grupa.get_attribute(DICT_GW, 'wejscie')
        return nil if tekst.nil? || tekst.to_s.empty?
        JSON.parse(tekst.to_s)
      rescue JSON::ParserError => e
        Log.error('Atrybuty.czytaj_wejscie', e)
        nil
      end

      # Identyfikator domu (wiąże grupę z jej definicjami bali).
      def dom_id(grupa)
        grupa.get_attribute(DICT_GW, 'dom').to_s
      end

      # Oznaczenie definicji bala dla Dokumentacji 2D i generatora.
      def oznacz_definicje(defn, poz, dom_id, przekroj)
        defn.set_attribute(DICT_AM, 'rola', 'timber')
        defn.set_attribute(DICT_AM, 'prefiks', poz[:prefiks])
        defn.set_attribute(DICT_AM, 'pozycja', poz[:nr].to_s)
        defn.set_attribute(DICT_AM, 'nazwa', poz[:nazwa])
        defn.set_attribute(DICT_GW, 'dom', dom_id)
        defn.set_attribute(DICT_GW, 'nazwa', poz[:nazwa])
        defn.set_attribute(DICT_GW, 'przekroj', przekroj)
        nil
      end

      # Oznaczenie instancji bala (ściana, wieniec, pozycja).
      def oznacz_instancje(inst, b)
        inst.set_attribute(DICT_GW, 'sciana', b[:sciana][:id])
        inst.set_attribute(DICT_GW, 'wieniec', b[:wieniec][:nr])
        inst.set_attribute(DICT_GW, 'pozycja', b[:pozycja][:nazwa])
        nil
      end

      # Oznaczenie instancji belki podłogi lub dachu (rodzaj, pozycja).
      def oznacz_element(inst, e)
        inst.set_attribute(DICT_GW, 'element', e[:rodzaj])
        inst.set_attribute(DICT_GW, 'pozycja', e[:pozycja][:nazwa])
        nil
      end

      # Podpis zawartości domu: definicje i położenia instancji (zmiana = ręczna poprawka po generowaniu).
      def podpis(grupa)
        wpisy = []
        grupa.entities.each do |e|
          next unless e.respond_to?(:entities) && e.respond_to?(:transformation)
          e.entities.each do |i|
            next unless i.respond_to?(:definition)
            o = i.transformation.origin
            wpisy << format('%s|%s|%.2f|%.2f|%.2f', e.name, i.definition.name, o.x.to_f, o.y.to_f, o.z.to_f)
          end
          wpisy << "#{e.name}|n=#{e.entities.to_a.length}"
        end
        wpisy << "n=#{grupa.entities.to_a.length}"
        suma = 0
        wpisy.sort.join(';').each_byte { |c| suma = (suma * 31 + c) % 4_294_967_291 }
        "#{wpisy.length}-#{suma}"
      end

      # Zapis podpisu po budowie.
      def zapisz_podpis(grupa)
        grupa.set_attribute(DICT_GW, 'podpis', podpis(grupa))
      end

      # Czy dom zmieniono ręcznie od ostatniego generowania.
      def zmieniony_recznie?(grupa)
        zapisany = grupa.get_attribute(DICT_GW, 'podpis')
        !zapisany.nil? && zapisany != podpis(grupa)
      end
    end
  end
end
