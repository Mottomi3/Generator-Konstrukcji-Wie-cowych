# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/projekt.rb
# Zadanie: przebieg obliczeń domu od linii do listy bali i belek (kolejność kroków) i podsumowanie do okna – bez API SketchUpa.
# Tematy: przebieg generowania, kolejność kroków, plan domu, podsumowanie, lista ścian, ostrzeżenia, błędy, podpowiedzi, wejście (segmenty, parametry, otwory)
# Zależy od: wszystkie pliki rdzen/
# Używają: sketchup/sterowanie.rb, testy
#
# Wejście (Hash, klucze tekstowe – tak samo zapisane w modelu do przebudowy): 'segmenty' [[[x, y], [x, y]], …] w mm,
# 'parametry' {…}, 'otwory' [{…}], 'sciany' { 'W-n' => ustawienia ściany z widoku – rdzen/ustawienia_scian.rb }. Wynik – plan (Hash): parametry, kat, obrys, sciany, bale, pozycje, elementy (belki
# podłogi i dachu), pozycje_elementow, pary_zamkow, ostrzezenia, bledy, podpowiedzi, podsumowanie.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

unless defined?(ArteMadera::GeneratorWiencowy::Pozycje) && defined?(ArteMadera::GeneratorWiencowy::Siatka) &&
       defined?(ArteMadera::GeneratorWiencowy::Zamek) && defined?(ArteMadera::GeneratorWiencowy::Bale) &&
       defined?(ArteMadera::GeneratorWiencowy::Obrys) && defined?(ArteMadera::GeneratorWiencowy::Podloga)
  %w[geometria parametry obrys sciany ustawienia_scian wience otwory usztywnienie styki elementy dach szczyty dopelnienie
     pod_dachem bale zamek bryla profil_bala siatka pozycje statyka podloga kontrola].each do |plik|
    require File.join(File.dirname(__FILE__), plik)
  end
end

module ArteMadera
  module GeneratorWiencowy
    module Projekt
      module_function

      # Cały przebieg: obrys → ściany → ustawienia ścian → szczyty → otwory → styki → węgły → dopełnienie nad niższymi
      # działowymi → gniazda płatwi → bale → zamki → pozycje → belki dachu i podłogi.
      def oblicz(wejscie)
        wej = wejscie.is_a?(Hash) ? wejscie : {}
        p, uwagi = Parametry.normalizuj(wej['parametry'])
        plan = { parametry: p, kat: 0.0, obrys: [], sciany: [], bale: [], pozycje: [], elementy: [], pozycje_elementow: [],
                 pary_zamkow: 0, ostrzezenia: uwagi.dup, bledy: [], podpowiedzi: [], podsumowanie: nil }
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
        plan[:ostrzezenia].concat(UstawieniaScian.zastosuj(sciany, wej['sciany'], p, sc[:os_kalenicy]))
        Sciany.numeruj!(sciany)
        sz = Szczyty.przygotuj(sciany, p, sc[:os_kalenicy])
        plan[:ostrzezenia].concat(sz[:uwagi])
        plan[:ostrzezenia].concat(Otwory.przypisz(wej['otwory'], sciany, p, lambda { |w| Wience.wysokosc(w, p) }))
        plan[:ostrzezenia].concat(Styki.planuj(sciany, p, sc[:os_kalenicy]))
        plan[:ostrzezenia].concat(Usztywnienie.planuj(sciany, p, sc[:os_kalenicy]))
        Sciany.numeruj!(sciany)
        plan[:ostrzezenia].concat(Dopelnienie.planuj(sciany, p))
        Szczyty.gniazda(sciany, p, sz[:dom])
        plan[:ostrzezenia].concat(PodDachem.przygotuj(sciany, p, sz[:dom]))
        bale = Bale.zbuduj(sciany, p)
        plan[:ostrzezenia].concat(bale[:ostrzezenia])
        plan[:pary_zamkow] = Zamek.nanies(sciany, p)
        ProfilBala.oznacz(bale[:bale], p)
        plan[:sciany] = sciany
        plan[:bale] = bale[:bale]
        plan[:ostrzezenia].concat(uwagi_o_stykach(plan))
        plan[:pozycje] = Pozycje.numeruj(bale[:bale], p)
        belki(plan, sz[:dom], p)
        plan[:podsumowanie] = podsumowanie(plan)
        plan[:ostrzezenia].uniq!
        plan
      end

      # Belki dachu (dom prostokątny) i podłogi: elementy, pozycje (numery po balach), podpowiedzi podłogi.
      def belki(plan, dom, p)
        plan[:elementy].concat(Dach.elementy(dom, p)) if dom
        pod = Podloga.zaplanuj(plan[:sciany], p)
        plan[:elementy].concat(pod[:elementy])
        plan[:podpowiedzi].concat(pod[:podpowiedzi])
        plan[:podloga] = { legar: pod[:legar], podpory: pod[:podpory] }
        plan[:pozycje_elementow] = Elementy.numeruj(plan[:elementy], plan[:pozycje].length + 1)
      end

      # Ostrzeżenia o stykach, których nie trzyma zamek (wieńce szczytu nad węgłem, który kończy się pod połacią).
      def uwagi_o_stykach(plan)
        Kontrola.styki_bez_zamka(plan).group_by { |x| x[:sciana] }.map do |id, lista|
          format('Ściana %s: styk bez zamka w wieńcach %s (węgieł kończy się niżej, pod połacią) – zwiększ maksymalną ' \
                 'długość bala albo dorysuj węgieł bliżej kalenicy.', id, lista.map { |x| x[:wieniec] }.uniq.sort.join(', '))
        end
      end

      # Podsumowanie do okna: ściany, liczby bali i pozycji, objętość i waga, wysokości.
      def podsumowanie(plan)
        p = plan[:parametry]
        z = p['zamek']
        sciany = plan[:sciany].map do |w|
          { id: w[:id], rodzaj: Sciany.opis_rodzaju(w), dlugosc: (w[:s_do] - w[:s_od]).round,
            wysokosc: Wience.wysokosc(w, p).round(1), wience: w[:wience].count { |k| !k[:nadstawka] }, bale: w[:bale].length,
            otwory: (w[:otwory] || []).count { |o| !o[:gniazdo] },
            styki: styki_opis(w) }
        end
        lista = Pozycje.lista_zamowienia(plan[:pozycje], p)
        m3 = lista.inject(0.0) { |s, x| s + x[:objetosc_m3] }
        belki = Elementy.lista_zamowienia(plan[:pozycje_elementow])
        m3_belek = belki.inject(0.0) { |s, x| s + x[:objetosc_m3] }
        { sciany: sciany, liczba_bali: plan[:bale].length, liczba_pozycji: plan[:pozycje].length,
          objetosc_m3: m3.round(3), waga_kg: (m3 * p['gestosc'].to_f).round, wysokosci: Wience.wysokosci(p),
          przekroj: z['nazwa'], lista: lista + belki, pary_zamkow: plan[:pary_zamkow],
          objetosc_belek_m3: m3_belek.round(3), liczba_belek: plan[:elementy].length,
          szczyty: plan[:sciany].count { |w| w[:szczyt] }, bale_szczytu: plan[:bale].count { |b| b[:pozycja][:prefiks] == 'Sz' },
          kontrfory_nowe: plan[:sciany].count { |w| w[:rodzaj] == :kontrfor && w[:zrodlo] == :styk },
          wegly_usztywniajace: plan[:sciany].count { |w| w[:rodzaj] == :kontrfor && w[:zrodlo] == :usztywnienie },
          wegly_narysowane: plan[:sciany].count { |w| w[:rodzaj] == :kontrfor && w[:zrodlo] == :rysunek },
          limit_swiatla: Usztywnienie.limit_swiatla(p).round }
      end

      # Styki ściany do okna: [styki wieńców parzystych, nieparzystych] w mm od początku osi (puste – bez styków).
      def styki_opis(w)
        st = w[:styki]
        return [] if st.nil? || (st[:parzyste].empty? && st[:nieparzyste].empty?)
        [st[:parzyste].map { |s| s.round }, st[:nieparzyste].map { |s| s.round }]
      end

      # Siatka bryły pozycji (do budowy komponentu): Siatka.z_profilu dla profilu pozycji (pełny profil bala – z piórem
      # i wpustem, gdy pozycja ma opis profilu).
      def siatka_pozycji(poz)
        return { sciany: Pryzmat.siatka(poz[:dl], poz[:przekroj]) } if poz[:przekroj]
        Siatka.z_profilu(profil_pozycji(poz))
      end

      # Profil bryły pozycji: pełny (rdzen/profil_bala.rb) albo prosty (rdzen/bryla.rb).
      def profil_pozycji(poz)
        return ProfilBala.przedzialy(poz[:dl], poz[:t], poz[:h], poz[:cechy], poz[:profil]) if poz[:profil]
        Bryla.profil(poz[:dl], poz[:t], poz[:h], poz[:cechy])
      end

      # Objętość bryły pozycji [mm³] (pełny albo prosty profil).
      def objetosc_pozycji(poz)
        return Pryzmat.objetosc(poz[:dl], poz[:przekroj]) if poz[:przekroj]
        ProfilBala.objetosc(profil_pozycji(poz))
      end
    end
  end
end
