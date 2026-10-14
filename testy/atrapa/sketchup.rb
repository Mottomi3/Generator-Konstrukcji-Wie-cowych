# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/atrapa/sketchup.rb
# Zadanie: atrapa API SketchUpa (Geom, Sketchup::Model/Entities/Group/ComponentDefinition/Face/Edge, UI) do testów bez SketchUpa.
# Tematy: atrapa API, testy offline, Geom::Point3d, Geom::Transformation, ściana z otworem w atrapie
# Zależy od: –
# Używają: testy/t_sketchup.rb, testy/pomoc.rb
#
# Atrapa zapisuje to, co wtyczka robi z modelem (grupy, definicje, instancje, ściany z punktami, atrybuty, okna),
# żeby testy mogły to sprawdzić. Nie odtwarza dzielenia ścian SketchUpa – otwór dorysowany i usunięty zostaje
# zapisany w polu otwory ściany zewnętrznej.

module Geom
  class Vector3d
    attr_reader :x, :y, :z

    def initialize(x = 0.0, y = 0.0, z = 0.0)
      @x = x.to_f
      @y = y.to_f
      @z = z.to_f
    end

    def to_a
      [@x, @y, @z]
    end

    def length
      Math.sqrt(@x * @x + @y * @y + @z * @z)
    end

    def normalize
      l = length
      l < 1e-12 ? Vector3d.new(0, 0, 0) : Vector3d.new(@x / l, @y / l, @z / l)
    end

    def dot(v)
      @x * v.x + @y * v.y + @z * v.z
    end

    def cross(v)
      Vector3d.new(@y * v.z - @z * v.y, @z * v.x - @x * v.z, @x * v.y - @y * v.x)
    end

    def *(k)
      k.is_a?(Vector3d) ? cross(k) : Vector3d.new(@x * k, @y * k, @z * k)
    end
  end

  class Point3d
    attr_reader :x, :y, :z

    def initialize(x = 0.0, y = 0.0, z = 0.0)
      if x.is_a?(Array)
        @x, @y, @z = x.map(&:to_f)
        @z ||= 0.0
      else
        @x = x.to_f
        @y = y.to_f
        @z = z.to_f
      end
    end

    def to_a
      [@x, @y, @z]
    end

    def transform(tr)
      tr.zastosuj(self)
    end

    def -(other)
      Vector3d.new(@x - other.x, @y - other.y, @z - other.z)
    end

    def +(v)
      Point3d.new(@x + v.x, @y + v.y, @z + v.z)
    end

    def ==(other)
      other.respond_to?(:x) && (@x - other.x).abs < 1e-9 && (@y - other.y).abs < 1e-9 && (@z - other.z).abs < 1e-9
    end
  end

  class Transformation
    attr_reader :m

    # Macierz 4 × 4 wierszami: [xaxis, yaxis, zaxis] w kolumnach, origin w ostatniej kolumnie.
    def initialize(m = nil)
      @m = m || [[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 0.0, 1.0]]
    end

    def self.axes(origin, xa, ya, za)
      new([[xa.x, ya.x, za.x, origin.x], [xa.y, ya.y, za.y, origin.y], [xa.z, ya.z, za.z, origin.z], [0.0, 0.0, 0.0, 1.0]])
    end

    def *(other)
      if other.is_a?(Transformation)
        w = Array.new(4) { Array.new(4, 0.0) }
        4.times { |i| 4.times { |j| w[i][j] = (0...4).inject(0.0) { |s, k| s + @m[i][k] * other.m[k][j] } } }
        Transformation.new(w)
      else
        zastosuj(other)
      end
    end

    def zastosuj(p)
      Point3d.new(@m[0][0] * p.x + @m[0][1] * p.y + @m[0][2] * p.z + @m[0][3],
                  @m[1][0] * p.x + @m[1][1] * p.y + @m[1][2] * p.z + @m[1][3],
                  @m[2][0] * p.x + @m[2][1] * p.y + @m[2][2] * p.z + @m[2][3])
    end

    def origin
      Point3d.new(@m[0][3], @m[1][3], @m[2][3])
    end

    def xaxis
      Vector3d.new(@m[0][0], @m[1][0], @m[2][0])
    end

    def yaxis
      Vector3d.new(@m[0][1], @m[1][1], @m[2][1])
    end

    def zaxis
      Vector3d.new(@m[0][2], @m[1][2], @m[2][2])
    end

    def to_a
      @m.transpose.flatten
    end
  end
end

module Sketchup
  class Atrybutowy
    def atrybuty
      @atrybuty ||= {}
    end

    # Numer encji (jak Entity#entityID – stały dla obiektu w sesji).
    def entityID
      object_id
    end

    def set_attribute(dict, key, value)
      (atrybuty[dict] ||= {})[key] = value
    end

    def get_attribute(dict, key, domyslna = nil)
      d = atrybuty[dict]
      d && d.key?(key) ? d[key] : domyslna
    end

    def delete_attribute(dict, key = nil)
      key ? (atrybuty[dict] || {}).delete(key) : atrybuty.delete(dict)
    end
  end

  class Vertex
    attr_reader :position

    def initialize(pt)
      @position = pt
    end
  end

  class Edge < Atrybutowy
    attr_reader :start, :end
    attr_accessor :parent

    def initialize(a, b)
      @start = Vertex.new(a)
      @end = Vertex.new(b)
    end

    def valid?
      true
    end
  end

  class Face < Atrybutowy
    # Wynik classify_point – jak w SketchUpie.
    PointUnknown = 0
    PointInside = 1
    PointOnVertex = 2
    PointOnEdge = 4
    PointOutside = 16
    PointNotOnPlane = 32

    attr_reader :punkty, :otwory
    attr_accessor :entities

    def initialize(punkty, entities)
      @punkty = punkty
      @entities = entities
      @valid = true
      @otwory = []
    end

    def vertices
      @punkty.map { |p| Vertex.new(p) }
    end

    # Krawędzie pętli zewnętrznej (jak Face#edges w SketchUpie – te same obiekty przy kolejnych wywołaniach).
    def edges
      @edges ||= @punkty.each_index.map { |i| Edge.new(@punkty[i], @punkty[(i + 1) % @punkty.length]) }
    end

    # Normalna z punktów (metoda Newella).
    def normal
      n = [0.0, 0.0, 0.0]
      m = @punkty.length
      m.times do |i|
        a = @punkty[i]
        b = @punkty[(i + 1) % m]
        n[0] += (a.y - b.y) * (a.z + b.z)
        n[1] += (a.z - b.z) * (a.x + b.x)
        n[2] += (a.x - b.x) * (a.y + b.y)
      end
      Geom::Vector3d.new(*n).normalize
    end

    def reverse!
      @punkty = @punkty.reverse
      self
    end

    def erase!
      @valid = false
      @entities.usun(self)
    end

    def valid?
      @valid
    end

    def classify_point(_pt)
      1
    end
  end

  class Entities
    attr_reader :parent

    def initialize(parent)
      @parent = parent
      @lista = []
    end

    def each(&blk)
      @lista.dup.each(&blk)
    end

    def to_a
      @lista.dup
    end

    def length
      @lista.length
    end

    def grep(klasa)
      @lista.select { |e| klasa === e }
    end

    def add_group(*_args)
      g = Group.new(self)
      @lista << g
      g
    end

    def add_instance(defn, tr)
      raise ArgumentError, 'brak definicji' if defn.nil?
      i = ComponentInstance.new(defn, tr, self)
      defn.instances_lista << i
      @lista << i
      i
    end

    # Ściana: jeśli w tej samej płaszczyźnie jest już ściana, która zawiera nową w całości – nowa jest „otworem”.
    def add_face(*pts)
      pts = pts.flatten
      return nil if pts.length < 3
      f = Face.new(pts, self)
      @lista << f
      @ostatnia = f
      f
    end

    def add_line(a, b)
      e = Edge.new(a, b)
      e.parent = self
      @lista << e
      e
    end

    def usun(e)
      if e.is_a?(Face)
        poprzednia = @lista.reverse.find { |x| x.is_a?(Face) && !x.equal?(e) && x.valid? }
        poprzednia.otwory << e.punkty if poprzednia
      end
      @lista.delete(e)
    end

    def erase_entities(lista)
      Array(lista).each { |e| e.respond_to?(:erase!) ? e.erase! : @lista.delete(e) }
    end

    # Atrapa: przywrócenie listy po abort_operation.
    def przywroc(lista)
      @lista = lista.dup
    end
  end

  class ComponentDefinition < Atrybutowy
    attr_accessor :name
    attr_reader :entities, :instances_lista

    def initialize(name)
      @name = name
      @entities = Entities.new(self)
      @instances_lista = []
    end

    def instances
      @instances_lista.select(&:valid?)
    end

    def count_instances
      instances.length
    end

    def group?
      false
    end
  end

  class Group < Atrybutowy
    attr_accessor :name, :transformation, :layer
    attr_reader :entities

    def initialize(rodzic)
      @rodzic = rodzic
      @name = ''
      @transformation = Geom::Transformation.new
      @definition = ComponentDefinition.new('Group')
      @entities = Entities.new(@definition)
      @valid = true
    end

    def parent
      @rodzic.parent
    end

    def definition
      @definition
    end

    def erase!
      @valid = false
      @entities.each { |e| e.erase! if e.respond_to?(:erase!) }
      @rodzic.usun(self)
    end

    def valid?
      @valid
    end
  end

  # Bryła z ścian (atrapa Group/ComponentInstance#manifold? i #volume): każda krawędź pętli ścian (z otworami) użyta
  # dokładnie dwa razy; objętość z twierdzenia o dywergencji (ściany skierowane na zewnątrz), cale³.
  module AtrapaBryly
    module_function

    def sciany(ents)
      ents.to_a.select { |e| e.is_a?(Face) && e.valid? }
    end

    def klucz(p)
      [p.x, p.y, p.z].map { |v| (v * 1e5).round }
    end

    def manifold?(ents)
      licz = Hash.new(0)
      sciany(ents).each do |f|
        ([f.punkty] + f.otwory).each do |pts|
          pts.each_with_index { |a, i| licz[[klucz(a), klucz(pts[(i + 1) % pts.length])].sort] += 1 }
        end
      end
      !licz.empty? && licz.values.all? { |n| n == 2 }
    end

    def wektor_pola(pts)
      w = [0.0, 0.0, 0.0]
      pts.each_with_index do |a, i|
        b = pts[(i + 1) % pts.length]
        w[0] += (a.y * b.z - a.z * b.y) / 2.0
        w[1] += (a.z * b.x - a.x * b.z) / 2.0
        w[2] += (a.x * b.y - a.y * b.x) / 2.0
      end
      w
    end

    def dlugosc(w)
      Math.sqrt(w[0] * w[0] + w[1] * w[1] + w[2] * w[2])
    end

    def volume(ents)
      return -1.0 unless manifold?(ents)
      v = 0.0
      sciany(ents).each do |f|
        a = wektor_pola(f.punkty)
        n = dlugosc(a)
        next if n < 1e-12
        skala = (n - f.otwory.inject(0.0) { |s, pts| s + dlugosc(wektor_pola(pts)) }) / n
        p0 = f.punkty[0]
        v += (p0.x * a[0] + p0.y * a[1] + p0.z * a[2]) * skala
      end
      v / 3.0
    end
  end

  class ComponentInstance < Atrybutowy
    attr_accessor :transformation, :layer, :name
    attr_reader :definition

    def manifold?
      AtrapaBryly.manifold?(@definition.entities)
    end

    def volume
      AtrapaBryly.volume(@definition.entities)
    end

    def initialize(defn, tr, rodzic)
      @definition = defn
      @transformation = tr
      @rodzic = rodzic
      @name = ''
      @valid = true
    end

    def erase!
      @valid = false
      @rodzic.usun(self)
    end

    def valid?
      @valid
    end
  end

  class DefinitionList
    def initialize
      @lista = []
    end

    def add(name)
      nazwa = name
      n = 1
      while @lista.any? { |d| d.name == nazwa }
        nazwa = "#{name}##{n}"
        n += 1
      end
      d = ComponentDefinition.new(nazwa)
      @lista << d
      d
    end

    def remove(d)
      @lista.delete(d)
      true
    end

    # Atrapa: przywrócenie listy po abort_operation.
    def przywroc(lista)
      @lista = lista.dup
    end

    def [](nazwa)
      @lista.find { |d| d.name == nazwa }
    end

    def to_a
      @lista.dup
    end

    def each(&blk)
      @lista.dup.each(&blk)
    end

    def length
      @lista.length
    end
  end

  class Layer
    attr_reader :name

    def initialize(name)
      @name = name
    end
  end

  class Layers
    def initialize
      @lista = [Layer.new('Untagged')]
    end

    def add(nazwa)
      self[nazwa] || (@lista << Layer.new(nazwa)).last
    end

    def [](nazwa)
      @lista.find { |l| l.name == nazwa }
    end

    def length
      @lista.length
    end
  end

  class Selection
    def initialize
      @lista = []
    end

    def to_a
      @lista.dup
    end

    def clear
      @lista.clear
    end

    def add(*e)
      @lista.concat(e.flatten)
    end
  end

  class Model < Atrybutowy
    attr_reader :entities, :definitions, :layers, :selection, :operacje

    def initialize
      @entities = Entities.new(self)
      @definitions = DefinitionList.new
      @layers = Layers.new
      @selection = Selection.new
      @operacje = []
    end

    def active_entities
      @entities
    end

    def start_operation(nazwa, *_reszta)
      @operacje << [:start, nazwa]
      @migawka = [@entities.to_a, @definitions.to_a]
      true
    end

    def commit_operation
      @operacje << [:commit]
      @migawka = nil
      true
    end

    # Jak w SketchUpie: cofnięcie wszystkiego od start_operation (encje najwyższego poziomu i definicje).
    def abort_operation
      @operacje << [:abort]
      if @migawka
        @entities.przywroc(@migawka[0])
        @definitions.przywroc(@migawka[1])
      end
      @migawka = nil
      true
    end

    def options
      { 'UnitsOptions' => { 'LengthUnit' => 2 } }
    end
  end

  @model = Model.new

  class << self
    attr_accessor :model

    def active_model
      @model
    end

    def require(sciezka)
      Kernel.require(sciezka)
    end

    def register_extension(_ext, _load)
      true
    end

    def version
      '23.0.0'
    end

    def is_pro?
      false
    end

    def os_language
      'pl'
    end
  end
end

class SketchupExtension
  attr_accessor :description, :version, :creator, :copyright

  def initialize(nazwa, sciezka)
    @nazwa = nazwa
    @sciezka = sciezka
  end
end

module UI
  @komunikaty = []
  @odpowiedz = 6

  class << self
    attr_accessor :komunikaty, :odpowiedz, :plik_zapisu

    def messagebox(tekst, _typ = nil)
      @komunikaty << tekst.to_s
      @odpowiedz
    end

    # Okno zapisu: test ustawia UI.plik_zapisu (nil – „Anuluj”).
    def savepanel(_tytul, _katalog = nil, _nazwa = nil)
      @plik_zapisu
    end

    def menu(_nazwa)
      Menu.new
    end
  end

  class Menu
    attr_reader :pozycje

    def initialize
      @pozycje = []
    end

    def add_submenu(_nazwa)
      Menu.new
    end

    def add_item(nazwa, &blk)
      @pozycje << [nazwa, blk]
      @pozycje.length
    end

    def add_separator
      nil
    end
  end

  class HtmlDialog
    STYLE_DIALOG = 0
    attr_reader :skrypty, :wywolania, :plik, :opcje

    def initialize(opcje = {})
      @opcje = opcje
      @skrypty = []
      @wywolania = {}
      @widoczne = false
    end

    def set_file(plik)
      @plik = plik
    end

    def add_action_callback(nazwa, &blk)
      @wywolania[nazwa] = blk
    end

    def execute_script(js)
      @skrypty << js
    end

    def show
      @widoczne = true
    end

    def close
      @widoczne = false
    end

    def visible?
      @widoczne
    end

    # Test: wywołanie jak z JavaScriptu.
    def wywolaj(nazwa, arg = '')
      @wywolania[nazwa].call(nil, arg)
    end
  end
end

MB_YESNO = 4 unless defined?(MB_YESNO)
IDYES = 6 unless defined?(IDYES)
IDNO = 7 unless defined?(IDNO)

$atrapa_zaladowane = []

def file_loaded?(nazwa)
  $atrapa_zaladowane.include?(nazwa)
end

def file_loaded(nazwa)
  $atrapa_zaladowane << nazwa
end
