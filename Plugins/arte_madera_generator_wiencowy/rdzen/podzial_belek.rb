# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/podzial_belek.rb
# Zadanie: belki dłuższe niż najdłuższa handlowa ich przekroju (magazyn drewna) dzielone w modelu nad podporą – płatwie dachu łączone na styk w osi ściany, przez którą przechodzą (szczyt, działowa, węgieł); kawałki z wrębami przeniesionymi, osobne pozycje w zestawieniu.
# Tematy: podział belek, belka dłuższa niż w hurtowni – podział, płatew dzielona nad ścianą, styk płatwi nad podporą, łączenie płatwi na długości, kawałki płatwi
# Zależy od: rdzen/parametry.rb (dlugosci_katalogu – magazyn drewna), rdzen/dlugosci_handlowe.rb (TOL)
# Używają: rdzen/projekt.rb (belki – przed podpowiedziami o długościach), rdzen/dach.rb (e[:podpory] – osie ścian wzdłuż płatwi)
#
# Propozycja P3 z rundy 15 (przyjęta w poleceniu rundy 18): „płatew 11 m przy najdłuższej belce z listy 8 m zostaje
# w modelu jednym kawałkiem; zestawienie zamawia belkę, której nie ma”. Płatew z podporami e[:podpory] (x wzdłuż belki –
# osie ścian, przez które przechodzi) dzielona zachłannie: każdy kawałek kończy się na najdalszej podporze, do której
# sięga najdłuższa handlowa; styk w osi ściany (w jej gnieździe). Bez podpory w zasięgu – belka zostaje w całości
# i podpowiedź z rdzen/dlugosci_handlowe.rb mówi, że trzeba ją łączyć. Statyka bez zmian – płatwie liczone jako belki
# jednoprzęsłowe między podporami. belki_podzial = nie – jak do kompilacji 17.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'dlugosci_handlowe') unless defined?(ArteMadera::GeneratorWiencowy::DlugosciHandlowe)

module ArteMadera
  module GeneratorWiencowy
    module PodzialBelek
      # Najkrótszy kawałek po podziale [mm] – podpora bliżej końca nie jest miejscem styku.
      MIN_KAWALEK = 300.0 unless const_defined?(:MIN_KAWALEK)

      module_function

      # Podział płatwi dachu w liście elementów (w miejscu); zwraca liczbę styków.
      def podziel!(elementy, p)
        return 0 if p['belki_podzial'].to_s == 'nie'
        dlugosci = Parametry.dlugosci_katalogu(p, 'platwie_katalog')
        styki = 0
        nowe = elementy.flat_map do |e|
          next [e] unless e[:prefiks] == 'P' && e[:tag] == :dach && e[:podpory] && (e[:cechy] || []).empty?
          handlowe = dlugosci[[e[:b], e[:h]].sort]
          next [e] if handlowe.nil? || e[:dl] <= handlowe.last + DlugosciHandlowe::TOL
          ciecia = miejsca(e[:dl], e[:podpory], handlowe.last)
          styki += ciecia.length
          kawalki(e, ciecia)
        end
        elementy.replace(nowe)
        styki
      end

      # Miejsca styków wzdłuż belki długości dl z podporami xs przy najdłuższej handlowej lmax: zachłannie najdalsza
      # podpora w zasięgu; [] – nie da się (belka zostaje w całości).
      def miejsca(dl, xs, lmax)
        pod = xs.select { |x| x > MIN_KAWALEK && x < dl - MIN_KAWALEK }.sort
        wynik = []
        s = 0.0
        while dl - s > lmax + DlugosciHandlowe::TOL
          x = pod.select { |q| q > s + MIN_KAWALEK && q - s <= lmax + DlugosciHandlowe::TOL }.max
          return [] if x.nil?
          wynik << x
          s = x
        end
        wynik
      end

      # Zdanie do wyników: ile styków płatwi nad ścianami (odmiana: 1 styk, 2–4 styki, 5 styków).
      def opis(n)
        slowo = if n == 1 then 'styk'
                elsif (2..4).cover?(n % 10) && !(12..14).cover?(n % 100) then 'styki'
                else 'styków'
                end
        format('Płatwie dłuższe niż w magazynie drewna podzielone nad ścianami: %d %s w osi ściany (kawałki – osobne pozycje ' \
               'w zestawieniu).', n, slowo)
      end

      # Kawałki belki e przecięte w miejscach ciecia (x wzdłuż belki): położenie przesunięte wzdłuż osi, wręby przycięte
      # i przesunięte do kawałka.
      def kawalki(e, ciecia)
        granice = [0.0] + ciecia + [e[:dl]]
        granice.each_cons(2).map do |a, b|
          po = e[:polozenie]
          k = e.merge(dl: b - a, polozenie: po.merge(poczatek: (0..2).map { |i| po[:poczatek][i] + po[:x][i] * a }),
                      podpory: e[:podpory].map { |x| x - a }.select { |x| x > 0.0 && x < b - a })
          if e[:wreby]
            k[:wreby] = e[:wreby].map { |w| [[w[0], a].max - a, [w[1], b].min - a] + w[2..-1] }.select { |w| w[1] - w[0] > 0.5 }
            k.delete(:wreby) if k[:wreby].empty?
          end
          k
        end
      end
    end
  end
end
