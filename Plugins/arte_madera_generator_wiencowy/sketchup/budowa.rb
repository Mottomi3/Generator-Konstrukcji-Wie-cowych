# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/budowa.rb
# Zadanie: budowa domu w modelu – grupa domu > grupy ścian W-n > instancje komponentów bali, tagi, usuwanie poprzedniej wersji.
# Tematy: budowa modelu, grupa domu, grupa ściany, komponent bala, definicja z siatki, ściana z otworem, tagi, przebudowa, usuwanie starych definicji, operacja cofnij
# Zależy od: rdzen/projekt.rb (siatka pozycji), rdzen/siatka.rb, sketchup/konwersja.rb, sketchup/atrybuty.rb, log.rb
# Używają: sketchup/sterowanie.rb
#
# Jedna definicja komponentu na pozycję (identyczne bale = jeden komponent). Bryła definicji w ułożeniu kanonicznym,
# ściany z siatki uproszczonej (Siatka.uprosc – krawędzie sąsiednich ścian pokrywają się, SketchUp nie musi ich dzielić),
# bal obrócony dostaje transformację z obrotem o 180° (Konwersja.transformacja_bala).
# Całość w jednej operacji (jedno „Cofnij”).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module Budowa
      # Tagi (dawniej warstwy) według rodzaju ściany.
      TAGI = {
        zewnetrzna: 'Ściany zewnętrzne',
        dzialowa: 'Ściany działowe',
        kontrfor: 'Kontrfory'
      }.freeze unless const_defined?(:TAGI)

      module_function

      # Budowa domu z planu; istniejąca – grupa poprzedniej wersji do zastąpienia. Zwraca { grupa:, definicje:, sciany_bez_scian: }.
      def zbuduj(model, plan, wejscie, istniejaca = nil)
        wynik = nil
        model.start_operation('ArteMadera – dom wieńcowy', true)
        begin
          rodzic = istniejaca ? istniejaca.parent.entities : model.active_entities
          usun_dom(model, istniejaca) if istniejaca
          dom_id = "GW-#{Time.now.strftime('%Y%m%d%H%M%S')}-#{rand(100_000)}"
          grupa = rodzic.add_group
          grupa.name = 'Dom wieńcowy'
          grupa.transformation = Konwersja.transformacja_domu(plan[:kat], wejscie['z0'].to_f)
          tagi = przygotuj_tagi(model)
          defs = {}
          bledy_scian = 0
          plan[:pozycje].each do |poz|
            d, bledne = definicja(model, poz, plan[:parametry], dom_id)
            defs[poz[:nr]] = d
            bledy_scian += bledne
          end
          plan[:sciany].each do |w|
            next if w[:bale].empty?
            g = grupa.entities.add_group
            g.name = w[:id]
            g.layer = tagi[w[:rodzaj]]
            w[:bale].each do |b|
              inst = g.entities.add_instance(defs[b[:pozycja][:nr]], Konwersja.transformacja_bala(b, plan[:parametry]))
              inst.layer = tagi[w[:rodzaj]]
              Atrybuty.oznacz_instancje(inst, b)
            end
          end
          Atrybuty.zapisz_dom(grupa, wejscie, dom_id, PLUGIN_BUILD)
          Atrybuty.zapisz_podpis(grupa)
          model.commit_operation
          wynik = { grupa: grupa, definicje: defs.length, bledne_sciany: bledy_scian }
        rescue => e
          model.abort_operation
          Log.error('Budowa.zbuduj', e)
          raise
        end
        wynik
      end

      # Definicja komponentu pozycji z siatki bryły; zwraca [definicja, liczba ścian, których nie udało się narysować].
      def definicja(model, poz, p, dom_id)
        nazwa = (poz[:prefiks] == 'Kf' ? 'Kontrfor ' : 'Bal ') + poz[:nazwa]
        d = model.definitions.add(nazwa)
        siatka = Projekt.siatka_pozycji(poz)
        bledne = 0
        Siatka.uprosc(siatka[:sciany]).each do |s|
          bledne += 1 unless rysuj_sciane(d.entities, s)
        end
        z = p['zamek']
        Atrybuty.oznacz_definicje(d, poz, dom_id, format('%s × %s', Parametry.fmt(z['grubosc']), Parametry.fmt(poz[:h])))
        Log.warn("Pozycja #{poz[:nazwa]}: #{bledne} ścian bryły nie narysowano – sprawdź bryłę w modelu.") if bledne > 0
        [d, bledne]
      end

      # Ściana bryły: pętla zewnętrzna, otwory (dorysowane i usunięte), zwrot zgodny z normalną siatki.
      def rysuj_sciane(ents, s)
        zewn = s[:petle][0].map { |pt| Konwersja.punkt(pt) }
        face = ents.add_face(zewn)
        return false if face.nil?
        s[:petle][1..-1].each do |otw|
          pts = otw.map { |pt| Konwersja.punkt(pt) }
          dziura = ents.add_face(pts)
          dziura.erase! if dziura && dziura.valid?
        end
        n = s[:normalna]
        face = ents.to_a.find { |f| f.is_a?(Sketchup::Face) && f.valid? && f.vertices.length >= 3 && f.classify_point(zewn[0]) != 0 && rownolegla?(f, n) } unless face.valid?
        return false if face.nil?
        fn = face.normal
        face.reverse! if fn.x * n[0] + fn.y * n[1] + fn.z * n[2] < 0
        true
      rescue => e
        Log.error('Budowa.rysuj_sciane', e)
        false
      end

      # Czy ściana SketchUpa leży równolegle do normalnej siatki (po podziale ściany przy otworze).
      def rownolegla?(f, n)
        fn = f.normal
        (fn.x * n[0] + fn.y * n[1] + fn.z * n[2]).abs > 0.999
      end

      # Tagi według rodzaju ściany (zakładane, gdy ich nie ma).
      def przygotuj_tagi(model)
        wynik = {}
        TAGI.each do |rodzaj, nazwa|
          wynik[rodzaj] = model.layers[nazwa] || model.layers.add(nazwa)
        end
        wynik
      end

      # Usunięcie poprzedniej wersji domu i jej nieużywanych definicji bali.
      def usun_dom(model, grupa)
        id = Atrybuty.dom_id(grupa)
        grupa.erase! if grupa.valid?
        return if id.empty?
        model.definitions.to_a.each do |d|
          next unless d.get_attribute(Atrybuty::DICT_GW, 'dom').to_s == id
          next if d.count_instances > 0
          model.definitions.remove(d) if model.definitions.respond_to?(:remove)
        end
      rescue => e
        Log.error('Budowa.usun_dom', e)
      end
    end
  end
end
