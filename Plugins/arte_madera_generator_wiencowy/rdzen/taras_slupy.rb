# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/taras_slupy.rb
# Zadanie: słupy tarasu z podciągiem – licem równo z licami ścian zewnętrznych, zamek górny (część słupa za balem idzie w górę obok bala) i zamek dolny (część słupa obok podwaliny schodzi w dół).
# Tematy: słupy tarasu, słup pod węgłem, słup licem z lica ściany, zamek górny słupa, zamek dolny słupa, słup na podwalinie, słup narożny tarasu
# Zależy od: rdzen/parametry.rb, rdzen/elementy.rb, rdzen/taras.rb (role ścian, słupy frontu, słupy pośrednie)
# Używają: rdzen/projekt.rb (belki – słupy S)
#
# Słup stoi pod podciągiem (spód bali frontu i ścian bocznych nad tarasem – ten sam poziom, Taras.z_podciagu). Zewnętrzne
# lico słupa = lico ściany (słup nie wychodzi przed ścianę – wymóg użytkownika, runda 7); słupy narożne licują się także
# z licem ściany bocznej. Zamek górny: nad spodem podciągu słup idzie dalej o taras_slup_zamek_gora, bez pasa pod balem
# (grubość ściany od lica) – bal leży w wycięciu, reszta słupa trzyma go od środka; narożny – bez pasów obu ścian; pod
# węgłem albo działową – bez zamka górnego (słup kończy się pod balem).
# Zamek dolny (gdy jest podłoga z podwalinami): poniżej poziomu 0 słup schodzi o taras_slup_zamek_dol (najwyżej wysokość
# podwaliny), bez pasa podwaliny (jej szerokość od lica) – słup obejmuje podwalinę od środka.
# Układ belki słupa: x w górę (od spodu zamka dolnego), y wzdłuż ściany, z = normalna ściany w lewo (układ prawoskrętny);
# obróbki – wyciecie_dol / wyciecie_gora (pas przy licu z = 0 albo z = g) i podciecie (pas ściany poprzecznej przy y = 0
# albo y = b).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'elementy') unless defined?(ArteMadera::GeneratorWiencowy::Elementy)
require File.join(File.dirname(__FILE__), 'taras') unless defined?(ArteMadera::GeneratorWiencowy::Taras)

module ArteMadera
  module GeneratorWiencowy
    module TarasSlupy
      module_function

      # Słupy tarasu z podciągiem (elementy S): pod frontem (narożne licem z licami obu ścian) i pośrednie pod ścianami
      # bocznymi; wierzch pełnego przekroju na spodzie podciągu.
      def slupy(sciany, p)
        front = sciany.find { |w| Taras.front?(w) }
        return [] if front.nil? || front[:taras][:wariant] != 'podciag'
        srodek = srodek_domu(sciany)
        lista = Taras.slupy_frontu(front, p)[:slupy]
        wynik = lista.each_with_index.map do |s, i|
          naroznik = i.zero? ? 0 : (i == lista.length - 1 ? 1 : nil)
          slup(front, s, front[:taras][:z_front], srodek, naroznik, p)
        end
        sciany.select { |w| Taras.rola(w) == :bok }.each do |w|
          tr = w[:taras]
          lo, hi = [tr[:s_dom], tr[:s_front]].sort
          Taras.posrednie(lo, hi, p).each { |s| wynik << slup(w, s, tr[:z_bok], srodek, nil, p) }
        end
        wynik
      end

      # Środek obrysu (średnia punktów ścian zewnętrznych) – do strony wewnętrznej ścian.
      def srodek_domu(sciany)
        pts = sciany.select { |w| w[:rodzaj] == :zewnetrzna }.flat_map { |w| [w[:a], w[:b]] }
        return [0.0, 0.0] if pts.empty?
        [pts.inject(0.0) { |s, q| s + q[0] } / pts.length, pts.inject(0.0) { |s, q| s + q[1] } / pts.length]
      end

      # Czy normalna ściany w lewo (w[:nor]) patrzy do środka domu.
      def nor_do_srodka?(w, srodek)
        (srodek[0] - w[:a][0]) * w[:nor][0] + (srodek[1] - w[:a][1]) * w[:nor][1] > 0.0
      end

      # Zamek dolny: [długość, szerokość pasa podwaliny] albo nil (bez podłogi, długość 0 albo podwalina szersza niż słup).
      def zamek_dolny(p, g)
        dl = p['taras_slup_zamek_dol'].to_f
        return nil if dl < 0.5 || !Parametry.tak?(p, 'podloga')
        pb, ph = Parametry.przekroj(p, 'podwalina_przekroj')
        return nil if g - pb < 10.0
        [[dl, ph].min, pb]
      end

      # Słup w ścianie w w miejscu s (oś słupu wzdłuż ściany), wierzch pełnego przekroju na z_gora; naroznik – 0 (koniec
      # przy s = 0 – pas ściany poprzecznej przy y = 0), 1 (przy końcu ściany – przy y = b) albo nil.
      def slup(w, s, z_gora, srodek, naroznik, p)
        b, g = Parametry.przekroj(p, 'taras_slup_przekroj')
        t = Parametry.grubosc(p)
        gora = p['taras_slup_zamek_gora'].to_f
        gora = 0.0 if skrzyzowanie_nad?(w, s, b, t)
        dol = zamek_dolny(p, g)
        ld = dol ? dol[0] : 0.0
        dl = ld + z_gora + gora
        do_srodka = nor_do_srodka?(w, srodek)
        cechy = []
        if gora > 0.5
          cechy << pas_lica(ld + z_gora, dl, t, do_srodka)
          cechy << pas_boku(ld + z_gora, dl, t, naroznik) if naroznik
        end
        if dol
          cechy << pas_lica(0.0, ld, dol[1], do_srodka)
          cechy << pas_boku(0.0, ld, dol[1], naroznik) if naroznik
        end
        Elementy.nowy('S', dl, b, g, poczatek(w, s, b, g, t, do_srodka, -ld), [0.0, 0.0, 1.0],
                      [w[:kier][0], w[:kier][1], 0.0], [w[:nor][0], w[:nor][1], 0.0], cechy)
      end

      # Czy nad słupem w miejscu s ściany w stoi węgieł albo działowa (nie narożnik) – zamek górny wszedłby w jej bale.
      def skrzyzowanie_nad?(w, s, b, t)
        (w[:skrzyzowania] || []).any? { |k| k[:typ] != :naroznik && (k[:s] - s).abs < (b + t) / 2.0 }
      end

      # Początek belki słupa (y = 0, z = 0, spód): lico zewnętrzne słupa w licu ściany.
      def poczatek(w, s, b, g, t, do_srodka, z0)
        n = w[:nor]
        k = w[:kier]
        dz = do_srodka ? -t / 2.0 : t / 2.0 - g
        [w[:a][0] + k[0] * (s - b / 2.0) + n[0] * dz, w[:a][1] + k[1] * (s - b / 2.0) + n[1] * dz, z0]
      end

      # Pas przy licu zewnętrznym słupa (szerokość gleb) na x0…x1 – wycięty.
      def pas_lica(x0, x1, gleb, do_srodka)
        { typ: do_srodka ? 'wyciecie_dol' : 'wyciecie_gora', x0: x0, x1: x1, gleb: gleb }
      end

      # Pas ściany poprzecznej przy słupie narożnym (szerokość gleb, przy y = 0 albo y = b) na x0…x1 – wycięty.
      def pas_boku(x0, x1, gleb, naroznik)
        { typ: 'podciecie', strona: naroznik, x0: x0, x1: x1, gleb: gleb }
      end
    end
  end
end
