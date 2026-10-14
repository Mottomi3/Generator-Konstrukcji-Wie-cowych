# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/budowa.rb
# Zadanie: budowa domu w modelu – grupa domu > grupy ścian W-n > instancje komponentów bali, tagi, usuwanie poprzedniej wersji.
# Tematy: budowa modelu, grupa domu, grupa ściany, komponent bala, definicja z siatki, ściana z otworem, tagi, tag Szczyty, grupa Podłoga, grupa Dach, belki w modelu, przebudowa, usuwanie starych definicji, operacja cofnij
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
        kontrfor: 'Kontrfory',
        szczyt: 'Szczyty',
        podloga: 'Podłoga',
        dach: 'Dach'
      }.freeze unless const_defined?(:TAGI)
      # Grupy belek w domu: tag => nazwa grupy.
      GRUPY_BELEK = { podloga: 'Podłoga', dach: 'Dach' }.freeze unless const_defined?(:GRUPY_BELEK)

      module_function

      # Budowa domu z planu w jednej operacji (jedno „Cofnij”); istniejąca – grupa poprzedniej wersji do zastąpienia.
      # Zwraca { grupa:, definicje:, bledne_sciany:, defs: }.
      def zbuduj(model, plan, wejscie, istniejaca = nil)
        wynik = nil
        model.start_operation('ArteMadera – dom wieńcowy', true)
        begin
          wynik = zbuduj_w_operacji(model, plan, wejscie, istniejaca)
          model.commit_operation
        rescue => e
          model.abort_operation
          Log.error('Budowa.zbuduj', e)
          raise
        end
        wynik
      end

      # Budowa domu bez własnej operacji (wołający otwiera i zamyka operację – np. test działania, który ją cofa).
      def zbuduj_w_operacji(model, plan, wejscie, istniejaca = nil)
        rodzic = istniejaca ? istniejaca.parent.entities : model.active_entities
        usun_dom(model, istniejaca) if istniejaca
        dom_id = "GW-#{Time.now.strftime('%Y%m%d%H%M%S')}-#{rand(100_000)}"
        grupa = rodzic.add_group
        grupa.name = 'Dom wieńcowy'
        grupa.transformation = Konwersja.transformacja_domu(plan[:kat], wejscie['z0'].to_f)
        tagi = przygotuj_tagi(model)
        defs = {}
        bledy_scian = 0
        (plan[:pozycje] + (plan[:pozycje_elementow] || [])).each do |poz|
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
            inst.layer = b[:pozycja][:prefiks] == 'Sz' ? tagi[:szczyt] : tagi[w[:rodzaj]]
            Atrybuty.oznacz_instancje(inst, b)
          end
        end
        dodaj_belki(grupa, plan, defs, tagi)
        Atrybuty.zapisz_dom(grupa, wejscie, dom_id, PLUGIN_BUILD)
        Atrybuty.zapisz_podpis(grupa)
        { grupa: grupa, definicje: defs.length, bledne_sciany: bledy_scian, defs: defs }
      end

      # Grupy „Podłoga” i „Dach” z instancjami belek (pozycje elementów).
      def dodaj_belki(grupa, plan, defs, tagi)
        GRUPY_BELEK.each do |tag, nazwa|
          lista = (plan[:elementy] || []).select { |e| e[:tag] == tag }
          next if lista.empty?
          g = grupa.entities.add_group
          g.name = nazwa
          g.layer = tagi[tag]
          lista.each do |e|
            inst = g.entities.add_instance(defs[e[:pozycja][:nr]], Konwersja.transformacja_elementu(e))
            inst.layer = tagi[tag]
            Atrybuty.oznacz_element(inst, e)
          end
        end
      end

      # Nazwa komponentu pozycji: rodzaj i nazwa pozycji.
      def nazwa_definicji(poz)
        return "#{poz[:rodzaj]} #{poz[:nazwa]}" if poz[:element]
        { 'Kf' => 'Kontrfor ', 'Sz' => 'Bal szczytu ' }.fetch(poz[:prefiks], 'Bal ') + poz[:nazwa]
      end

      # Definicja komponentu pozycji z siatki bryły; zwraca [definicja, liczba ścian, których nie udało się narysować].
      def definicja(model, poz, p, dom_id)
        nazwa = nazwa_definicji(poz)
        d = model.definitions.add(nazwa)
        siatka = Projekt.siatka_pozycji(poz)
        bledne = 0
        Siatka.uprosc(siatka[:sciany]).each do |s|
          bledne += 1 unless rysuj_sciane(d.entities, s)
        end
        Atrybuty.oznacz_definicje(d, poz, dom_id, format('%s × %s', Parametry.fmt(poz[:t]), Parametry.fmt(poz[:h])))
        Log.warn("Pozycja #{poz[:nazwa]}: #{bledne} ścian bryły nie narysowano – sprawdź bryłę w modelu.") if bledne > 0
        [d, bledne]
      end

      # Ściana bryły: pętla zewnętrzna, otwory (dorysowane i usunięte), zwrot zgodny z normalną siatki; false – ściany
      # albo otworu w niej nie udało się narysować.
      def rysuj_sciane(ents, s)
        zewn = s[:petle][0].map { |pt| Konwersja.punkt(pt) }
        face = ents.add_face(zewn)
        return false if face.nil?
        cale = true
        s[:petle][1..-1].each do |otw|
          pts = otw.map { |pt| Konwersja.punkt(pt) }
          dziura = ents.add_face(pts)
          cale = false if dziura.nil?
          dziura.erase! if dziura && dziura.valid?
        end
        n = s[:normalna]
        face = ents.to_a.find { |f| f.is_a?(Sketchup::Face) && f.valid? && na_scianie?(f, zewn[0]) && rownolegla?(f, n) } unless face.valid?
        return false if face.nil?
        fn = face.normal
        face.reverse! if fn.x * n[0] + fn.y * n[1] + fn.z * n[2] < 0
        cale
      rescue => e
        Log.error('Budowa.rysuj_sciane', e)
        false
      end

      # Czy punkt leży na ścianie SketchUpa (w środku, na krawędzi albo w wierzchołku – nie obok i nie poza płaszczyzną).
      def na_scianie?(f, pt)
        k = f.classify_point(pt)
        [Sketchup::Face::PointInside, Sketchup::Face::PointOnEdge, Sketchup::Face::PointOnVertex].include?(k)
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
