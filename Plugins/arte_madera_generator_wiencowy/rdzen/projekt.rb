# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/projekt.rb
# Zadanie: przebieg obliczeń domu od linii do listy bali (kolejność kroków) i podsumowanie do okna – bez API SketchUpa.
# Tematy: przebieg generowania, kolejność kroków, plan domu, podsumowanie, lista ścian, ostrzeżenia, błędy, wejście (segmenty, parametry, otwory)
# Zależy od: wszystkie pliki rdzen/
# Używają: sketchup/sterowanie.rb, testy
#
# Wejście (Hash, klucze tekstowe – tak samo zapisane w modelu do przebudowy): 'segmenty' [[[x, y], [x, y]], …] w mm,
# 'parametry' {…}, 'otwory' [{…}]. Wynik – plan (Hash): parametry, kat, obrys, sciany, bale, pozycje, pary_zamkow,
# ostrzezenia, bledy, podsumowanie.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

unless defined?(ArteMadera::GeneratorWiencowy::Pozycje) && defined?(ArteMadera::GeneratorWiencowy::Siatka) &&
       defined?(ArteMadera::GeneratorWiencowy::Zamek) && defined?(ArteMadera::GeneratorWiencowy::Bale) &&
       defined?(ArteMadera::GeneratorWiencowy::Obrys)
  %w[geometria parametry obrys sciany wience otwory styki bale zamek bryla siatka pozycje].each do |plik|
    require File.join(File.dirname(__FILE__), plik)
  end
end

module ArteMadera
  module GeneratorWiencowy
    module Projekt
      module_function

      # Cały przebieg: obrys → ściany → otwory → styki (kontrfory) → bale → zamki → pozycje.
      def oblicz(wejscie)
        wej = wejscie.is_a?(Hash) ? wejscie : {}
        p, uwagi = Parametry.normalizuj(wej['parametry'])
        plan = { parametry: p, kat: 0.0, obrys: [], sciany: [], bale: [], pozycje: [], pary_zamkow: 0,
                 ostrzezenia: uwagi.dup, bledy: [], podsumowanie: nil }
        ob = Obrys.rozpoznaj(wej['segmenty'] || [], p)
        plan[:kat] = ob[:kat]
        plan[:obrys] = ob[:obrys]
        plan[:ostrzezenia].concat(ob[:ostrzezenia])
        plan[:bledy].concat(ob[:bledy])
        return plan unless plan[:bledy].empty?
        sc = Sciany.zbuduj(ob, p)
        plan[:os_kalenicy] = sc[:os_kalenicy]
        plan[:ostrzezenia].concat(sc[:ostrzezenia])
        plan[:bledy].concat(sc[:bledy])
        return plan unless plan[:bledy].empty?
        sciany = sc[:sciany]
        Sciany.numeruj!(sciany)
        plan[:ostrzezenia].concat(Otwory.przypisz(wej['otwory'], sciany, p, lambda { |w| Wience.wysokosc(w, p) }))
        plan[:ostrzezenia].concat(Styki.planuj(sciany, p, sc[:os_kalenicy]))
        Sciany.numeruj!(sciany)
        bale = Bale.zbuduj(sciany, p)
        plan[:ostrzezenia].concat(bale[:ostrzezenia])
        plan[:pary_zamkow] = Zamek.nanies(sciany, p)
        plan[:sciany] = sciany
        plan[:bale] = bale[:bale]
        plan[:pozycje] = Pozycje.numeruj(bale[:bale], p)
        plan[:podsumowanie] = podsumowanie(plan)
        plan
      end

      # Podsumowanie do okna: ściany, liczby bali i pozycji, objętość i waga, wysokości.
      def podsumowanie(plan)
        p = plan[:parametry]
        z = p['zamek']
        sciany = plan[:sciany].map do |w|
          { id: w[:id], rodzaj: Sciany.opis_rodzaju(w), dlugosc: (w[:s_do] - w[:s_od]).round,
            wysokosc: Wience.wysokosc(w, p).round(1), wience: w[:wience].length, bale: w[:bale].length,
            otwory: (w[:otwory] || []).length,
            styki: w[:styki] && !w[:styki][:regiony].empty? ? w[:styki][:regiony].map { |r| [r[:a].round, r[:b].round] } : [] }
        end
        lista = Pozycje.lista_zamowienia(plan[:pozycje], p)
        m3 = lista.inject(0.0) { |s, x| s + x[:objetosc_m3] }
        { sciany: sciany, liczba_bali: plan[:bale].length, liczba_pozycji: plan[:pozycje].length,
          objetosc_m3: m3.round(3), waga_kg: (m3 * p['gestosc'].to_f).round, wysokosci: Wience.wysokosci(p),
          przekroj: z['nazwa'], lista: lista, pary_zamkow: plan[:pary_zamkow],
          kontrfory_nowe: plan[:sciany].count { |w| w[:rodzaj] == :kontrfor && w[:zrodlo] == :styk } }
      end

      # Siatka bryły pozycji (do budowy komponentu): Siatka.z_profilu dla profilu pozycji.
      def siatka_pozycji(poz)
        prof = Bryla.profil(poz[:dl], poz[:t], poz[:h], poz[:cechy])
        Siatka.z_profilu(prof)
      end
    end
  end
end
