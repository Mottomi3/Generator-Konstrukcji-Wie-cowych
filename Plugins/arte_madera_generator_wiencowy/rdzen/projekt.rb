# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/projekt.rb
# Zadanie: przebieg obliczeń domu od linii do listy bali i belek (kolejność kroków) i podsumowanie do okna – bez API SketchUpa.
# Tematy: przebieg generowania, kolejność kroków, plan domu, podsumowanie, lista ścian, ostrzeżenia, błędy, podpowiedzi, wejście (segmenty, parametry, otwory), połacie w planie, taras w przebiegu, boczne zadaszenie w przebiegu
# Zależy od: wszystkie pliki rdzen/
# Używają: sketchup/sterowanie.rb, testy
#
# Wejście (Hash, klucze tekstowe – tak samo zapisane w modelu do przebudowy): 'segmenty' [[[x, y], [x, y]], …] w mm,
# 'parametry' {…}, 'otwory' [{…}], 'kanaly' [{…} – rdzen/kanaly.rb], 'wegly' [{…} – rdzen/wegly_tabela.rb], 'sciany' { 'W-n' => ustawienia ściany z widoku – rdzen/ustawienia_scian.rb }. Wynik – plan (Hash): parametry, kat, obrys, sciany, bale, pozycje, elementy (belki
# podłogi i dachu), pozycje_elementow, polacie (dla aplikacji do dachów albo nil), dach (opis dachu domu prostokątnego / L albo nil),
# materialy (rdzen/materialy.rb), powierzchnie (rdzen/powierzchnie.rb), wycena (rdzen/wycena.rb), pary_zamkow, ostrzezenia, bledy, podpowiedzi, podsumowanie.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

unless defined?(ArteMadera::GeneratorWiencowy::Pozycje) && defined?(ArteMadera::GeneratorWiencowy::Siatka) &&
       defined?(ArteMadera::GeneratorWiencowy::Zamek) && defined?(ArteMadera::GeneratorWiencowy::Bale) &&
       defined?(ArteMadera::GeneratorWiencowy::Obrys) && defined?(ArteMadera::GeneratorWiencowy::Podloga)
  %w[geometria parametry podzial_belek skrzydla obrys sciany ustawienia_scian wience taras_sciany taras taras_balustrada osiadanie taras_slupy taras_szczyt taras_wiazar otwory kanaly usztywnienie wegly_tabela wegly_konstrukcyjne symetria_wegly wypusty_okapu styki_dzialowe styki_tarasu styki elementy dach_jednospadowy dach podpory_platwi_l zadaszenie szczyty polacie
     dopelnienie pod_dachem bale skos_przy_narozniku sciecie_dachu zamek_platwi zamek bryla profil_bala siatka pozycje statyka statyka_dachu statyka_wiazara statyka_slupa statyka_zadaszenia statyka_krokwi podloga_przybudowki fundamenty podciagi podloga podbitka drewutnia statyka_drewutni dlugosci_handlowe kontrola_rownoleglych kontrola awaria].each do |plik|
    require File.join(File.dirname(__FILE__), plik)
  end
end
require File.join(File.dirname(__FILE__), 'materialy') unless defined?(ArteMadera::GeneratorWiencowy::Materialy)
require File.join(File.dirname(__FILE__), 'powierzchnie') unless defined?(ArteMadera::GeneratorWiencowy::Powierzchnie)
require File.join(File.dirname(__FILE__), 'wycena') unless defined?(ArteMadera::GeneratorWiencowy::Wycena)

module ArteMadera
  module GeneratorWiencowy
    module Projekt
      module_function

      # Najwięcej dodatkowych przebiegów przy automatycznym doborze przekrojów.
      PRZEBIEGI_DOBORU = 3 unless const_defined?(:PRZEBIEGI_DOBORU)

      # Plan domu z wejścia. Automatyczny dobór przekroju płatwi (rdzen/statyka_dachu.rb), trójkąta nad tarasem
      # (rdzen/statyka_wiazara.rb), bocznego zadaszenia (rdzen/statyka_zadaszenia.rb) i krokwi (rdzen/statyka_krokwi.rb):
      # pierwszy przebieg liczy dom z przekrojami z pól i dobiera najmniejsze wystarczające,
      # następny liczy dom od nowa z dobranymi (płatwie, gniazda, trójkąt nad tarasem) i je potwierdza; gdyby po zmianie
      # geometrii nie wystarczały – jeszcze raz z większymi.
      # Nieprzewidziany wyjątek obliczeń nie wychodzi na zewnątrz: plan z jednym błędem po polsku (plan[:wyjatek] – opis
      # techniczny), pełny ślad w dzienniku (rdzen/awaria.rb; decyzja użytkownika z 2026-11-14).
      def oblicz(wejscie)
        plan = przebieg(wejscie, {}, :pierwszy)
        nadpis = {}
        PRZEBIEGI_DOBORU.times do |i|
          nowe = plan[:dobor_przekrojow]
          break if nowe.nil? || nowe.empty? || !plan[:bledy].empty?
          nadpis = nadpis.merge(nowe)
          plan = przebieg(wejscie, nadpis, i == PRZEBIEGI_DOBORU - 1 ? :koniec : :potwierdz)
        end
        plan
      rescue StandardError => e
        Awaria.plan(wejscie, e)
      end

      # Jeden przebieg: obrys (z tarasem) → ściany → ustawienia ścian → role ścian tarasu → szczyty → otwory → styki → węgły →
      # dopełnienie nad niższymi działowymi → gniazda płatwi → bale → balustrada tarasu → bale ścięte dachem przy
      # narożnikach → bale ścięte do płaszczyzny dachu w poprzek → zamki → pozycje → belki dachu, słupy tarasu i podłoga.
      # nadpis – przekroje płatwi dobrane w poprzednim przebiegu (zastępują pola), tryb – tryb doboru (StatykaDachu.sprawdz).
      def przebieg(wejscie, nadpis, tryb)
        wej = wejscie.is_a?(Hash) ? wejscie : {}
        p, uwagi = Parametry.normalizuj(wej['parametry'])
        p = p.merge(nadpis)
        plan = { parametry: p, kat: 0.0, obrys: [], sciany: [], bale: [], pozycje: [], elementy: [], pozycje_elementow: [],
                 pary_zamkow: 0, ostrzezenia: uwagi.dup, bledy: [], podpowiedzi: [], podsumowanie: nil }
        ob = Obrys.rozpoznaj(wej['segmenty'] || [], p)
        plan[:kat] = ob[:kat]
        plan[:ostrzezenia].concat(ob[:ostrzezenia])
        plan[:bledy].concat(ob[:bledy])
        return plan unless plan[:bledy].empty?
        plan[:ostrzezenia].concat(Taras.przedluz!(ob, p))
        plan[:ostrzezenia].concat(Zadaszenie.przedluz!(ob, p))
        plan[:obrys] = ob[:obrys]
        sc = Sciany.zbuduj(ob, p)
        plan[:os_kalenicy] = sc[:os_kalenicy]
        plan[:ostrzezenia].concat(sc[:ostrzezenia])
        plan[:podpowiedzi].concat((sc[:podpowiedzi] || []).map { |h| h.merge(sekcja: 'sciany') })
        plan[:bledy].concat(sc[:bledy])
        return plan unless plan[:bledy].empty?
        sciany = sc[:sciany]
        Sciany.numeruj!(sciany)
        plan[:ostrzezenia].concat(UstawieniaScian.zastosuj(sciany, wej['sciany'], p, sc[:os_kalenicy]))
        Sciany.numeruj!(sciany)
        Taras.oznacz!(sciany, ob[:taras], p)
        Zadaszenie.oznacz!(sciany, ob[:zadaszenie], p)
        sz = Szczyty.przygotuj(sciany, p, sc[:os_kalenicy])
        plan[:ostrzezenia].concat(sz[:uwagi])
        plan[:ostrzezenia].concat(Otwory.przypisz(wej['otwory'], sciany, p, lambda { |w| Wience.wysokosc(w, p) }))
        plan[:ostrzezenia].concat(Kanaly.przypisz(wej['kanaly'], sciany, p))
        plan[:ostrzezenia].concat(WeglyTabela.dodaj(sciany, wej['wegly'], p, sc[:os_kalenicy]))
        plan[:ostrzezenia].concat(WeglyKonstrukcyjne.dodaj(sciany, p, sc[:os_kalenicy], sz[:dom]))
        plan[:ostrzezenia].concat(Taras.wegly_przy_slupach!(sciany, p))
        plan[:ostrzezenia].concat(Taras.uwagi_wejscia(sciany, p))
        plan[:ostrzezenia].concat(Styki.planuj(sciany, p, sc[:os_kalenicy]))
        plan[:ostrzezenia].concat(Usztywnienie.planuj(sciany, p, sc[:os_kalenicy]))
        Sciany.numeruj!(sciany)
        plan[:ostrzezenia].concat(Dopelnienie.planuj(sciany, p))
        Szczyty.gniazda(sciany, p, sz[:dom])
        plan[:ostrzezenia].concat(PodDachem.przygotuj(sciany, p, sz[:dom]))
        bale = Bale.zbuduj(sciany, p)
        TarasBalustrada.dodaj!(Taras.przesla(sciany, p), bale, p)
        TarasSciany.porecz!(sciany, p)
        SkosPrzyNarozniku.przytnij!(sciany, bale, p)
        SciecieDachu.przytnij!(bale[:bale], p, sz[:dom])
        plan[:ostrzezenia].concat(bale[:ostrzezenia])
        plan[:pary_zamkow] = Zamek.nanies(sciany, p)
        ProfilBala.oznacz(bale[:bale], p)
        SciecieDachu.wyrownaj!(bale[:bale], p)
        SciecieDachu.wyrownaj_skosy!(bale[:bale])
        SciecieDachu.wyrownaj_przeciwne!(bale[:bale])
        Kanaly.obrob!(bale[:bale], p)
        k = Kanaly.opis(bale[:bale])
        plan[:podpowiedzi] << { poziom: 'ok', sekcja: 'otwory', tekst: k } if k
        plan[:sciany] = sciany
        plan[:bale] = bale[:bale]
        plan[:ostrzezenia].concat(uwagi_o_stykach(plan))
        plan[:ostrzezenia].concat(KontrolaRownoleglych.ostrzezenia(plan))
        plan[:pozycje] = Pozycje.numeruj(bale[:bale], p)
        plan[:dach] = sz[:dom]
        belki(plan, sz[:dom], p, tryb)
        plan[:materialy] = Materialy.lista(plan)
        # Powierzchnie, wysokość nad terenem i limity użytkownika (rdzen/powierzchnie.rb).
        plan[:powierzchnie] = Powierzchnie.licz(plan)
        limity = Powierzchnie.uwagi(plan[:powierzchnie], p)
        plan[:ostrzezenia].concat(limity[:ostrzezenia])
        plan[:podpowiedzi].concat(limity[:podpowiedzi])
        plan[:podsumowanie] = podsumowanie(plan)
        # Wycena materiału (W3, rdzen/wycena.rb): bale, belki i deski z magazynu drewna, reszta z cennika.
        plan[:wycena] = Wycena.licz(plan)
        plan[:ostrzezenia].uniq!
        plan
      end

      # Podpory końców płatwi skrzydła bocznego domu L (rdzen/podpory_platwi_l.rb): słupki w elementach, wynik w planie
      # (łączniki do zestawienia), podpory w skrzydle (przęsło w statyce płatwi), ostrzeżenie o końcach bez podpory.
      def podpory_l(plan, dom, p)
        r = PodporyPlatwiL.oblicz(dom, p)
        plan[:elementy].concat(r[:elementy])
        plan[:podpory_l] = r
        dom[:boczne][:podpory_kosz] = r[:podpory] if dom && dom[:boczne]
        plan[:ostrzezenia].concat(PodporyPlatwiL.uwagi(r))
      end

      # Belki dachu (dom prostokątny), podbitka i podłoga: elementy, pozycje (numery po balach), podpowiedzi z sekcją okna
      # (szczyty, podloga, taras – pokazywane przy parametrach); połacie dla aplikacji do dachów (plan[:polacie]);
      # sprawdzenie płatwi, krokwi, zadaszenia i trójkąta nad tarasem, przekroje dobrane do następnego przebiegu (plan[:dobor_przekrojow],
      # tryb – StatykaDachu.sprawdz).
      def belki(plan, dom, p, tryb = :pierwszy)
        TarasWiazar.przejscia!(plan[:sciany], dom, p)
        plan[:elementy].concat(Dach.elementy(dom, p)) if dom
        podpory_l(plan, dom, p)
        zad = Zadaszenie.elementy(dom, plan[:sciany], p)
        plan[:elementy].concat(zad)
        plan[:podpowiedzi].concat(Zadaszenie.podpowiedzi(dom, p, zad).map { |h| h.merge(sekcja: 'zadaszenie') })
        plan[:podpowiedzi].concat(PodlogaPrzybudowki.podpowiedzi(plan[:sciany], p).map { |h| h.merge(sekcja: 'zadaszenie') })
        u = Zadaszenie.przeszkoda(p)
        plan[:ostrzezenia] << u if u
        st = StatykaDachu.sprawdz(dom, p, tryb)
        sw = StatykaWiazara.sprawdz(plan[:sciany], dom, p, tryb)
        sz = StatykaZadaszenia.sprawdz(dom, plan[:sciany], p, tryb)
        sk = StatykaKrokwi.sprawdz(dom, p, tryb)
        plan[:dobor_przekrojow] = st[:nadpis].merge(sw[:nadpis]).merge(sz[:nadpis]).merge(sk[:nadpis])
        plan[:platwie_statyka] = st[:platwie]
        plan[:podpowiedzi].concat(st[:podpowiedzi].map { |h| h.merge(sekcja: 'szczyty') })
        plan[:podpowiedzi].concat(StatykaKosza.podpowiedzi(dom, p).map { |h| h.merge(sekcja: 'szczyty') })
        plan[:podpowiedzi].concat(sk[:podpowiedzi])
        plan[:podpowiedzi].concat(sw[:podpowiedzi].map { |h| h.merge(sekcja: 'taras') })
        plan[:podpowiedzi].concat(sz[:podpowiedzi].map { |h| h.merge(sekcja: 'zadaszenie_przekroje') })
        plan[:elementy].concat(Podbitka.elementy(dom, p, plan[:sciany]))
        u = Podbitka.uwaga(p)
        plan[:ostrzezenia] << u if u
        plan[:elementy].concat(TarasSlupy.slupy(plan[:sciany], p))
        plan[:podpowiedzi].concat(Osiadanie.podpowiedzi(plan[:elementy], p).map { |h| h.merge(sekcja: 'taras') })
        plan[:elementy].concat(TarasWiazar.elementy(plan[:sciany], p))
        plan[:ostrzezenia].concat(TarasWiazar.uwagi(plan[:sciany], p))
        plan[:polacie] = Polacie.dla_domu(dom, p)
        plan[:podpowiedzi].concat(Polacie.podpowiedzi(dom, p, plan[:polacie]).map { |h| h.merge(sekcja: 'szczyty') })
        pod = Podloga.zaplanuj(plan[:sciany], p)
        plan[:elementy].concat(pod[:elementy])
        plan[:podpowiedzi].concat(pod[:podpowiedzi].map { |h| h.merge(sekcja: 'podloga') })
        plan[:podloga] = { legar: pod[:legar], podpory: pod[:podpory] }
        drewutnia(plan, dom, p)
        n = PodzialBelek.podziel!(plan[:elementy], p)
        plan[:podpowiedzi] << { poziom: 'ok', sekcja: 'szczyty', tekst: PodzialBelek.opis(n) } if n > 0
        plan[:podpowiedzi].concat(DlugosciHandlowe.podpowiedzi(plan[:elementy], p))
        plan[:pozycje_elementow] = Elementy.numeruj(plan[:elementy], plan[:pozycje].length + 1)
      end

      # Drewutnia przy ścianie szczytowej (rdzen/drewutnia.rb, dodatek z rundy 19): elementy pod dachem domu (liczone po
      # dachu, podbitce i podłodze – podwaliny i fundamenty przy ścianie), podpowiedzi z wymiarami i statyką w sekcji „drewutnia”.
      def drewutnia(plan, dom, p)
        plan[:elementy].concat(Drewutnia.elementy(dom, plan[:sciany], plan[:elementy], p))
        lista = Drewutnia.podpowiedzi(dom, plan[:sciany], plan[:elementy], p) +
                StatykaDrewutni.podpowiedzi(dom, plan[:sciany], plan[:elementy], p)
        plan[:podpowiedzi].concat(lista.map { |h| h.merge(sekcja: 'drewutnia') })
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
          objetosc_m3: m3.round(3), waga_kg: (m3 * p['gestosc'].to_f).round, wysokosci: wysokosci(plan),
          przekroj: z['nazwa'], lista: lista + belki, pary_zamkow: plan[:pary_zamkow],
          objetosc_belek_m3: m3_belek.round(3), liczba_belek: plan[:elementy].length,
          szczyty: plan[:sciany].count { |w| w[:szczyt] }, bale_szczytu: plan[:bale].count { |b| b[:pozycja][:prefiks] == 'Sz' },
          kontrfory_nowe: plan[:sciany].count { |w| w[:rodzaj] == :kontrfor && w[:zrodlo] == :styk },
          wegly_usztywniajace: plan[:sciany].count { |w| w[:rodzaj] == :kontrfor && w[:zrodlo] == :usztywnienie },
          wegly_narysowane: plan[:sciany].count { |w| w[:rodzaj] == :kontrfor && w[:zrodlo] == :rysunek },
          wegly_konstrukcyjne: plan[:sciany].count { |w| w[:rodzaj] == :kontrfor && %i[platwa koniec].include?(w[:zrodlo]) },
          limit_swiatla: Usztywnienie.limit_swiatla(p).round }
      end

      # Wysokości ścian do okna (Wience.wysokosci) i ściana wysoka dachu jednospadowego (góra jej bali – do połaci).
      def wysokosci(plan)
        p = plan[:parametry]
        w = plan[:sciany].find { |x| x[:szczyt] && x[:szczyt][:plaski] && x[:rodzaj] == :zewnetrzna }
        return Wience.wysokosci(p) if w.nil?
        Wience.wysokosci(p).merge(wysoka: (w[:bale].map { |b| b[:z0] + b[:h] - wysokosc_ciecia(b) }.max || 0.0).round(1))
      end

      # O ile górny bal jest niższy po przycięciu wzdłuż (skos płaski na całej długości) [mm].
      def wysokosc_ciecia(b)
        c = b[:cechy].find { |x| x[:typ] == 'skos_gora' && (x[:z0] - x[:z1]).abs < 0.01 && x[:x0] < 0.5 && x[:x1] > b[:dl] - 0.5 }
        c ? b[:h] - c[:z0] : 0.0
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
        return { sciany: ZamekPlatwi.siatka(poz[:dl], poz[:przekroj], poz[:t], poz[:wreby], poz[:wrab]) } if poz[:wreby]
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
        return ZamekPlatwi.objetosc(poz[:dl], poz[:przekroj], poz[:t], poz[:wreby], poz[:wrab]) if poz[:wreby]
        return Pryzmat.objetosc(poz[:dl], poz[:przekroj]) if poz[:przekroj]
        ProfilBala.objetosc(profil_pozycji(poz))
      end
    end
  end
end
