# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/zrzut_dok2d.rb
# Zadanie: przykładowy dom zbudowany na atrapie SketchUpa zapisany jako zrzut geometrii Dokumentacji 2D (format „ArteMadera-geometria”) – sprawdzenie, jak Dokumentacja 2D widzi bale i belki generatora.
# Tematy: zrzut geometrii, Dokumentacja 2D, zgodność z Dokumentacją 2D, grupy pozycji, prefiksy Bs Kf Sz, pokaz grup
# Zależy od: testy/atrapa/sketchup.rb, sketchup/budowa.rb, rdzen/przyklady.rb
# Używają: ręcznie – ruby -I testy/atrapa testy/zrzut_dok2d.rb [numer przykładu] plik.json; potem w repozytorium
#          Dokumentacji 2D: ruby -I stublib model_dump_loader.rb plik.json katalog (karty, zestawienia, telefon.html)
#
# Zrzut jak Diagnostics::GeometryDump Dokumentacji 2D: definicje (z atrybutami słownika ArteMadera), wystąpienia
# z transformacjami (16 liczb kolumnami) i objętością bryły, ściany z pętlami (zewnętrzna + otwory) i ich krawędzie,
# tagi; współrzędne w calach.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require 'json'
require 'tmpdir'
ENV['AM_GW_USTAWIENIA'] ||= File.join(Dir.tmpdir, "am_gw_zrzut_#{Process.pid}")
require File.expand_path('atrapa/sketchup', File.dirname(__FILE__))
require File.expand_path('pomoc', File.dirname(__FILE__))
require File.join(File.dirname(KATALOG_WTYCZKI), 'arte_madera_generator_wiencowy.rb')
require File.join(KATALOG_WTYCZKI, 'main.rb')

module ZrzutDok2D
  G = ArteMadera::GeneratorWiencowy

  module_function

  # Zrzut całego modelu atrapy: Hash w formacie „ArteMadera-geometria”.
  def zrzut(model)
    @definicje = []
    @indeksy = {}
    @tagi = {}
    encje = lista(model.entities)
    { 'format' => 'ArteMadera-geometria', 'version' => 1, 'units' => 'inch',
      'note' => 'Zrzut z generatora wieńcowego (atrapa SketchUpa).',
      'model' => { 'title' => 'Generator wieńcowy – przykład', 'attributes' => atrybuty(model) },
      'default_layer' => 'Layer0', 'layers' => @tagi.keys.map { |n| { 'name' => n, 'visible' => true } },
      'definitions' => @definicje, 'entities' => encje, 'selection' => [], 'active_path' => [] }
  end

  # Lista encji: ściany, ich krawędzie (w SketchUpie powstają ze ścianą – atrapa ich nie ma) i wystąpienia.
  def lista(ents)
    wynik = ents.to_a.map do |e|
      if e.is_a?(Sketchup::Face)
        { 'type' => 'face', 'loops' => ([e.punkty] + e.otwory).map { |pts| pts.map { |p| [p.x, p.y, p.z] } } }
      elsif e.is_a?(Sketchup::Group) || e.is_a?(Sketchup::ComponentInstance)
        wystapienie(e)
      end
    end.compact
    wynik + krawedzie(wynik.select { |x| x['type'] == 'face' })
  end

  # Krawędzie pętli ścian – każda raz (klucz z końców zaokrąglonych do 1e-6 cala).
  def krawedzie(sciany)
    byly = {}
    out = []
    sciany.each do |f|
      f['loops'].each do |pts|
        pts.each_with_index do |a, i|
          b = pts[(i + 1) % pts.length]
          k = [a, b].map { |p| p.map { |v| (v * 1e6).round } }.sort
          next if byly[k]
          byly[k] = true
          out << { 'type' => 'edge', 'a' => a, 'b' => b }
        end
      end
    end
    out
  end

  # Grupa albo komponent: definicja (indeks), transformacja, nazwa, tag, atrybuty.
  def wystapienie(e)
    grupa = e.is_a?(Sketchup::Group)
    # W atrapie grupa ma własną listę encji (Group#entities), definicja grupy – pustą.
    w = { 'type' => grupa ? 'group' : 'component', 'definition' => definicja(e.definition, grupa, grupa ? e.entities : nil),
          'transformation' => e.transformation.to_a.map(&:to_f), 'name' => e.name.to_s }
    w['layer'] = tag(e.layer) if e.respond_to?(:layer) && e.layer
    v = e.respond_to?(:volume) ? e.volume.to_f : 0.0
    w['volume'] = v if v > 0.0
    a = atrybuty(e)
    w['attributes'] = a if a
    w
  end

  # Indeks definicji w zrzucie (każda definicja raz, z encjami i atrybutami); ents – encje grupy.
  def definicja(d, grupa, ents = nil)
    return @indeksy[d.object_id] if @indeksy.key?(d.object_id)
    i = @definicje.length
    @indeksy[d.object_id] = i
    wpis = { 'index' => i, 'name' => d.name.to_s, 'group' => grupa }
    @definicje << wpis
    a = atrybuty(d)
    wpis['attributes'] = a if a
    wpis['entities'] = lista(ents || d.entities)
    i
  end

  # Nazwa tagu (zapamiętana do listy tagów).
  def tag(t)
    n = t.respond_to?(:name) ? t.name.to_s : t.to_s
    @tagi[n] = true
    n
  end

  # Atrybuty jak w zrzucie: { słownik => { klucz => wartość } } albo nil.
  def atrybuty(obj)
    return nil unless obj.respond_to?(:atrybuty)
    a = obj.atrybuty
    a.empty? ? nil : JSON.parse(JSON.generate(a))
  end

  # Przykładowy dom nr n (rdzen/przyklady.rb) zbudowany na atrapie; zwraca model.
  def zbuduj(n)
    wej = G::Przyklady.lista[n]['wejscie']
    plan = G::Projekt.oblicz(wej)
    raise "błędy planu: #{plan[:bledy].join('; ')}" unless plan[:bledy].empty?
    model = Sketchup.active_model
    G::Budowa.zbuduj(model, plan, wej)
    model
  end
end

if __FILE__ == $PROGRAM_NAME
  n = (ARGV[0] || 2).to_i
  plik = ARGV[1] || 'zrzut_dok2d.json'
  model = ZrzutDok2D.zbuduj(n)
  File.write(plik, JSON.generate(ZrzutDok2D.zrzut(model)))
  puts "Zapisano #{plik}: przykład #{n} – #{ArteMadera::GeneratorWiencowy::Przyklady.lista[n]['nazwa']}"
end
