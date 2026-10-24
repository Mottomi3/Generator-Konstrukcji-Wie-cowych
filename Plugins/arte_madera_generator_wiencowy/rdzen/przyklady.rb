# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/przyklady.rb
# Zadanie: przykładowe domy do testu działania w SketchUpie (i w testach) – linie, parametry i otwory.
# Tematy: przykładowe domy, test działania, dom 4 × 4, dom jak 900, dom z działową, łączenie na przemian, obrys L, krokwie przy szczycie, pełny profil w teście, działowa pod antresolą w teście
# Zależy od: –
# Używają: sketchup/raport.rb (test działania), testy/t_raport.rb
#
# Linie jak narysowane w SketchUpie (mm): zamknięty obrys = lico zewnętrzne, linie w środku = osie działowych,
# krótka linia w poprzek ściany = węgieł. Domy obejmują wszystkie główne funkcje generatora.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module Przyklady
      module_function

      # Odcinki prostokąta (lico zewnętrzne).
      def prostokat(x0, y0, x1, y1)
        [[[x0, y0], [x1, y0]], [[x1, y0], [x1, y1]], [[x1, y1], [x0, y1]], [[x0, y1], [x0, y0]]]
      end

      # Odcinki wielokąta zamkniętego.
      def wielokat(punkty)
        (0...punkty.length).map { |i| [punkty[i], punkty[(i + 1) % punkty.length]] }
      end

      # Otwór w tabeli otworów (jak z okna).
      def otwor(sciana, od, szer, wys, parapet, nazwa)
        { 'sciana' => sciana, 'od' => od, 'szerokosc' => szer, 'wysokosc' => wys, 'parapet' => parapet, 'nazwa' => nazwa }
      end

      # Lista przykładów: [{ 'nazwa' =>, 'wejscie' => { 'segmenty', 'z0', 'parametry', 'otwory', 'sciany' } }].
      def lista
        [
          dom('Domek 4 × 4 – bez łączeń i węgłów', prostokat(0, 0, 4000, 4000), {}, []),
          dom('Jak 900 – 4 × 3, okno i drzwi', prostokat(0, 0, 4000, 3000), { 'liczba_wiencow' => 16 },
              [otwor('W-1', 1000, 1020, 1010, 900, 'O1'), otwor('W-3', 1500, 930, 2100, 0, 'D1')]),
          dom('Dom 7 × 4,5 – działowa, węgieł, bale do 5 m',
              prostokat(0, 0, 7000, 4500) + [[[3500, 0], [3500, 4500]], [[1500, -150], [1500, 150]]],
              { 'max_dlugosc' => 5000 }, [otwor('W-1', 4300, 1020, 1010, 900, 'O1')]),
          dom('Dom 10 × 8 – łączenie na przemian, węgły usztywniające', prostokat(0, 0, 10_000, 8000) + [[[0, 4000], [10_000, 4000]]],
              { 'liczba_wiencow' => 20 }, [otwor('W-2', 2000, 1020, 1010, 900, 'O1')]),
          dom('Obrys L – ściany bez dachu i podłogi',
              wielokat([[0, 0], [8000, 0], [8000, 4000], [4500, 4000], [4500, 7000], [0, 7000]]), {}, []),
          dom('Krokwie z obu stron szczytu, podłoga ocieplona 150', prostokat(0, 0, 6000, 5000),
              { 'dach_uklad' => 'krokwie', 'krokwie_przy_szczycie' => 'obie_strony', 'izolacja_podlogi' => 150 }, []),
          dom('Pełny profil, działowa pod antresolą, ostatek 200, węgieł ręczny', prostokat(0, 0, 6000, 4200) + [[[2000, 0], [2000, 4200]]],
              { 'liczba_wiencow' => 20, 'profil_bala' => 'pelny', 'dach_uklad' => 'platwie_krokwie' },
              [otwor('W-5', 1200, 900, 2000, 0, 'D1')],
              'W-5' => { 'nad' => 'antresola', 'wysokosc' => 2450 }, 'W-1' => { 'ostatek_od' => 200 }, 'W-3' => { 'wegly' => [3500] })
        ]
      end

      # Przykład: nazwa i wejście domu (sciany – ustawienia ścian z widoku ściany).
      def dom(nazwa, segmenty, parametry, otwory, sciany = {})
        { 'nazwa' => nazwa, 'wejscie' => { 'segmenty' => segmenty, 'z0' => 0.0, 'parametry' => parametry, 'otwory' => otwory,
                                           'sciany' => sciany } }
      end
    end
  end
end
