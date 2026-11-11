# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/wypusty_okapu.rb
# Zadanie: wypusty pod dachem – górne wieńce ścian okapowych wypuszczone za szczyty o wysunięcie płatwi (oparcie dachu nad szczytem) i opcjonalnie górne bale węgłów na ścianach okapowych wysunięte na zewnątrz do nawisu okapu, ścięte linią dachu.
# Tematy: wypuszczone wieńce, górne wieńce pod okapem, wypust za szczyt, oparcie dachu nad szczytem, wypust węgła pod okapem, wspornik okapu, długość wypustu a maksymalny bal
# Zależy od: rdzen/parametry.rb, rdzen/wience.rb (wieńce własne), rdzen/styki.rb (styki w wieńcu), rdzen/szczyty.rb (zasięg pod linią), rdzen/pod_dachem.rb (linia dachu nad węgłem)
# Używają: rdzen/bale.rb (kawałki wieńca), rdzen/styki.rb (styki liczone z wypustami)
#
# Wymóg użytkownika (runda 8): „górne wieńce pod okapem muszą być wypuszczone o długość jak płatwie, by można było o nie
# oprzeć konstrukcję dachu”. Ściana okapowa (zewnętrzna wzdłuż kalenicy, bez szczytu) – okap_wience_wypust górnych
# wieńców własnych kończy się dach_okap_szczyt za licem zewnętrznym szczytu (jak płatwie), na końcach z narożnikiem ze
# ścianą ze szczytem; kawałek końcowy nie dłuższy niż maksymalny bal (wypust skracany z ostrzeżeniem). Węgły na ścianach
# okapowych (wegly_wypust_okap = tak) – wegly_okap_wience górnych bali wysuniętych na zewnątrz do dach_okap od lica
# ściany, ściętych linią dachu (pod_dachem) – wsporniki pod okap.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'wience') unless defined?(ArteMadera::GeneratorWiencowy::Wience)

module ArteMadera
  module GeneratorWiencowy
    module WypustyOkapu
      module_function

      # Zasięg [s0, s1] wieńca wn (indeks i) ściany w po wypustach; zas – zasięg bez nich; uwagi – ostrzeżenia.
      def zasieg(w, wn, i, zas, p, uwagi)
        return zas if zas.nil? || wn[:nadstawka] || !Parametry.tak?(p, 'szczyty')
        return okapowa(w, wn, i, zas, p, uwagi) if okapowa?(w)
        return wegiel(w, wn, zas, p) if w[:rodzaj] == :kontrfor && w[:pod_dachem] && okapowa?(w[:gospodarz])
        zas
      end

      # Czy ściana jest okapową: zewnętrzna wzdłuż kalenicy, bez szczytu.
      def okapowa?(w)
        return false unless w[:rodzaj] == :zewnetrzna && w[:taras].nil?
        # Ściana okapowa skrzydła bocznego domu L (rdzen/skrzydla.rb) – także ze szczytem dachu głównego na części długości.
        return true if w[:okap_boczny]
        w[:kierunek] == :A && w[:szczyt].nil?
      end

      # Czy wieniec wn jest jednym z n górnych wieńców własnych ściany.
      def gorny?(w, wn, n, p)
        return false if n <= 0
        wlasne = Wience.wlasne(w, p)
        # Ściana ze szczytem na części długości – górne wieńce ściany, nie szczytu.
        wlasne = Wience.pelna_lista(w[:kierunek], true, p) if w[:szczyt]
        idx = wlasne.index { |k| (k[:z0] - wn[:z0]).abs < 0.01 }
        !idx.nil? && idx >= wlasne.length - n
      end

      # Ściana okapowa: górne wieńce dłuższe na końcach przy szczycie (do dach_okap_szczyt za licem szczytu).
      def okapowa(w, wn, i, zas, p, uwagi)
        return zas unless gorny?(w, wn, p['okap_wience_wypust'].to_i, p)
        t = Parametry.grubosc(p)
        lmax = p['max_dlugosc'].to_f
        styki = Styki.pozycje_w_wiencu(w, i).sort
        s0, s1 = zas
        if przy_szczycie?(w, 0.0) && (s0 - w[:s_od]).abs < 0.01
          cel = -(t / 2.0 + p['dach_okap_szczyt'].to_f)
          koniec = styki.first || s1
          s0 = [cel, [koniec - lmax, w[:s_od]].min].max
          skrocony(w, cel, s0, uwagi)
        end
        if przy_szczycie?(w, w[:dl_osi]) && (s1 - w[:s_do]).abs < 0.01
          cel = w[:dl_osi] + t / 2.0 + p['dach_okap_szczyt'].to_f
          poczatek = styki.last || s0
          s1 = [cel, [poczatek + lmax, w[:s_do]].max].min
          skrocony(w, cel, s1, uwagi)
        end
        [s0, s1]
      end

      # Ściana do planowania styków: okapowa z wypuszczonymi górnymi wieńcami – zasięg wydłużony o wypusty (kawałki górnych
      # wieńców przy końcach mieszczą się w maksymalnym balu); inna – bez zmian.
      def do_stykow(w, p)
        return w unless okapowa?(w) && Parametry.tak?(p, 'szczyty') && p['okap_wience_wypust'].to_i > 0
        t = Parametry.grubosc(p)
        zew = t / 2.0 + p['dach_okap_szczyt'].to_f
        s_od = przy_szczycie?(w, 0.0) ? [w[:s_od], -zew].min : w[:s_od]
        s_do = przy_szczycie?(w, w[:dl_osi]) ? [w[:s_do], w[:dl_osi] + zew].max : w[:s_do]
        w.merge(s_od: s_od, s_do: s_do)
      end

      # Ostrzeżenie, gdy wypust skrócony przez maksymalną długość bala.
      def skrocony(w, cel, jest, uwagi)
        return if (cel - jest).abs < 0.5
        u = format('Ściana %s: wypuszczone górne wieńce skrócone o %.0f mm – kawałek przy końcu byłby dłuższy niż maksymalny ' \
                   'bal (zwiększ maksymalną długość bala albo dodaj węgieł bliżej szczytu).', w[:id], (cel - jest).abs)
        uwagi << u unless uwagi.include?(u)
      end

      # Czy na końcu s ściany jest narożnik ze ścianą ze szczytem (nie płaskim) – wypukły: w narożniku wklęsłym wypust
      # wchodziłby do środka domu (uwaga użytkownika, runda 10), zostaje zwykły ostatek.
      def przy_szczycie?(w, s)
        return false if w[:wklesle] && w[:wklesle][s.abs < 1.0 ? 0 : 1]
        w[:skrzyzowania].any? do |k|
          k[:typ] == :naroznik && (k[:s] - s).abs < 1.0 && k[:inna][:szczyt] && !k[:inna][:szczyt][:plaski] &&
            Szczyty.w_zakresie?(k[:inna][:szczyt], k_s(k, w))
        end
      end

      # Miejsce s narożnika k na drugiej ścianie (k[:inna]) – do sprawdzenia, czy jej szczyt sięga narożnika.
      def k_s(k, w)
        inna = k[:inna]
        x = (inna[:skrzyzowania] || []).find { |q| q[:inna].equal?(w) }
        x ? x[:s] : 0.0
      end

      # Węgieł na ścianie okapowej: górne wegly_okap_wience bali wysunięte na zewnątrz do dach_okap od lica ściany, ścięte
      # linią dachu (zasięg pod linią jak w szczycie).
      def wegiel(w, wn, zas, p)
        return zas unless Parametry.tak?(p, 'wegly_wypust_okap')
        lista = Wience.dla_sciany(w, p)
        idx = lista.index { |k| (k[:z0] - wn[:z0]).abs < 0.01 }
        return zas if idx.nil? || idx < lista.length - p['wegly_okap_wience'].to_i
        t = Parametry.grubosc(p)
        zew = t / 2.0 + p['dach_okap'].to_f
        # Na zewnątrz – tam, gdzie linia dachu niżej.
        na_od = PodDachem.linia(w, w[:s_od], p) < PodDachem.linia(w, w[:s_do], p)
        s0, s1 = na_od ? [[-zew, w[:s_od]].min, w[:s_do]] : [w[:s_od], [zew, w[:s_do]].max]
        nowy = Szczyty.zasieg_linii(s0, s1, PodDachem.zalom(w, p), wn[:z0] + p['szczyt_min_wysokosc'].to_f) { |s| PodDachem.linia(w, s, p) }
        return zas if nowy.nil?
        na_od ? [[nowy[0], zas[0]].min, zas[1]] : [zas[0], [nowy[1], zas[1]].max]
      end
    end
  end
end
