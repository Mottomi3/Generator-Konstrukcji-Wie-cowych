# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/osiadanie.rb
# Zadanie: osiadanie ścian z bali a słupy – o ile krótszy ma być słup stojący pod balami (luz osiadania i okucie regulacyjne w głowicy), podpowiedź do okna.
# Tematy: osiadanie słupów, słup krótszy o osiadanie, luz osiadania pod balem, śruba regulacyjna słupa, podkładki pod głowicę słupa, regulacja słupa
# Zależy od: rdzen/parametry.rb
# Używają: rdzen/taras_slupy.rb (długość słupa tarasu), rdzen/projekt.rb (podpowiedź w sekcji tarasu), rdzen/materialy.rb (okucia regulacyjne w zestawieniu)
#
# Ściana z bali osiada (osiadanie_scian [%] wysokości – ten sam parametr, z którego liczony jest luz nad stolarką), słup
# z jednego kawałka – nie. Bale leżące na słupie są wieńcami ścian domu: w domu opadają, na słupie zostałyby na miejscu.
# Dlatego słup jest krótszy o luz osiadania bali stojących obok niego (wysokość od spodu ścian do głowicy słupa ×
# osiadanie, w górę do pełnego milimetra), a w głowicy siedzi okucie regulacyjne: śruba (słup krótszy jeszcze o jej
# wysokość po skręceniu – slup_regulacja_wysokosc) albo podkładki wyjmowane w miarę osiadania (bez dodatku).
# slup_osiadanie = nie – słup do spodu bali, jak do kompilacji 14.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)

module ArteMadera
  module GeneratorWiencowy
    module Osiadanie
      module_function

      # Czy słupy pod balami są skracane o osiadanie ścian.
      def slupy?(p)
        Parametry.tak?(p, 'slup_osiadanie')
      end

      # Osiadanie bali o wysokości h [mm]: h × osiadanie_scian [%], w górę do pełnego milimetra.
      def luz(h, p)
        (h.to_f * p['osiadanie_scian'].to_f / 100.0 - 1e-9).ceil.to_f
      end

      # Rodzaj regulacji w głowicy słupa: 'sruba' albo 'podkladki'.
      def regulacja(p)
        p['slup_regulacja'].to_s == 'podkladki' ? 'podkladki' : 'sruba'
      end

      # Wysokość okucia w głowicy po osiadaniu [mm]: śruba skręcona – slup_regulacja_wysokosc, podkładki wyjęte – 0.
      def okucie(p)
        regulacja(p) == 'sruba' ? p['slup_regulacja_wysokosc'].to_f : 0.0
      end

      # Skrócenie słupa, na którym leżą bale o spodzie na wysokości z_gora: { luz:, okucie:, razem:, regulacja: } [mm];
      # nil – słupy bez skracania albo skrócenie zerowe.
      def slupa(z_gora, p)
        return nil unless slupy?(p)
        l = luz(z_gora, p)
        o = okucie(p)
        return nil if l + o < 0.5
        { luz: l, okucie: o, razem: l + o, regulacja: regulacja(p) }
      end

      # Podpowiedź do okna o skróceniu słupów ([{ poziom:, tekst: }]) – z elementów, które mają e[:osiadanie].
      def podpowiedzi(elementy, p)
        lista = (elementy || []).map { |e| e[:osiadanie] }.compact
        return [] if lista.empty?
        luzy = lista.map { |x| x[:luz] }
        zakres = luzy.min == luzy.max ? format('%.0f', luzy.max) : format('%.0f–%.0f', luzy.min, luzy.max)
        okucie = if lista.first[:regulacja] == 'sruba'
                   format('w głowicy śruba regulacyjna (%.0f mm po skręceniu) – dokręcaj ją, gdy ściany siadają', lista.first[:okucie])
                 else
                   'w głowicy podkładki – wyjmuj je, gdy ściany siadają'
                 end
        [{ poziom: 'ok', tekst: format('Słupy (%d szt.) krótsze o osiadanie ścian: %s mm luzu pod balami (%s %% wysokości), %s.',
                                       lista.length, zakres, p['osiadanie_scian'].to_s.sub(/\.0\z/, '').tr('.', ','), okucie) }]
      end
    end
  end
end
