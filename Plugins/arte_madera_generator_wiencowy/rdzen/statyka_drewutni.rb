# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/statyka_drewutni.rb
# Zadanie: sprawdzenie drewutni przy ścianie szczytowej – krokwie, płatew przy ścianie i oczep (śnieg i ciężar pokrycia), słupy (ściskanie z wyboczeniem); podpowiedź z najmniejszym wystarczającym przekrojem z magazynu.
# Tematy: statyka drewutni, krokwie drewutni – sprawdzenie, płatew drewutni – sprawdzenie, oczep drewutni – sprawdzenie, słupy drewutni – sprawdzenie
# Zależy od: rdzen/parametry.rb, rdzen/statyka.rb (belka), rdzen/statyka_slupa.rb (słup), rdzen/statyka_dachu.rb (obciążenia, μ), rdzen/drewutnia.rb (przekrój drewutni)
# Używają: rdzen/projekt.rb (podpowiedzi sekcji „Drewutnia”)
#
# Model jak boczne zadaszenie (rdzen/statyka_zadaszenia.rb) – podpowiedź, nie projekt konstruktora:
# - krokiew: belka swobodnie podparta na płatwi i oczepie, przęsło w rzucie = odstęp rzędów słupów, wspornik okapu liczony
#   jak przęsło 2a; obciążenie jak krokwie dachu (rdzen/statyka_krokwi.rb) z rozstawu krokwi drewutni;
# - płatew i oczep: przęsło = rozstaw słupów, pas dachu – połowa odstępu rzędów i wspornik krokwi po swojej stronie;
# - słup: siła z pasa dachu na przęsło rzędu (z zapasem – jak słup pośredni), długość wyboczeniowa = wysokość słupa;
#   bez wiatru (słup wolnostojący wymaga stężenia).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'statyka') unless defined?(ArteMadera::GeneratorWiencowy::Statyka)
require File.join(File.dirname(__FILE__), 'statyka_slupa') unless defined?(ArteMadera::GeneratorWiencowy::StatykaSlupa)
require File.join(File.dirname(__FILE__), 'statyka_dachu') unless defined?(ArteMadera::GeneratorWiencowy::StatykaDachu)
require File.join(File.dirname(__FILE__), 'drewutnia') unless defined?(ArteMadera::GeneratorWiencowy::Drewutnia)

module ArteMadera
  module GeneratorWiencowy
    module StatykaDrewutni
      module_function

      # Wymiary do sprawdzenia: { krokiew: { l:, rozstaw: }, belki: [{ nazwa:, l:, pas: }], slup: { l:, pas:, rozstaw: } }
      # z przekroju drewutni c (Drewutnia.geo).
      def wymiary(c, p)
        kv = Drewutnia.krokwie_v(c, p)
        sv = Drewutnia.slupy_v(c, p)
        rozstaw_s = sv.each_cons(2).map { |a, b| b - a }.push(0.0).max
        rozstaw_k = kv.each_cons(2).map { |a, b| b - a }.push(c[:krokiew][0]).max
        l = c[:s_b] - c[:s_a]
        okap = c[:s_e] - c[:s_b]
        pas_a = l / 2.0 + (c[:s_a] - c[:s_k])
        pas_b = l / 2.0 + okap
        { krokiew: { l: [l, 2.0 * okap, 2.0 * (c[:s_a] - c[:s_k])].max, rozstaw: rozstaw_k },
          belki: [{ nazwa: 'płatew przy ścianie', l: rozstaw_s, pas: pas_a }, { nazwa: 'oczep', l: rozstaw_s, pas: pas_b }],
          slup: { l: Drewutnia.z_belki(c, c[:s_a]) - c[:belka][1] - c[:z_dol], pas: [pas_a, pas_b].max, rozstaw: rozstaw_s } }
      end

      # Ocena krokwi b × h: { ok:, wyk:, l_przez_u: }.
      def krokiew(w, b, h, kat, p)
        a = kat * Math::PI / 180.0
        s = w[:rozstaw] / 1000.0
        g = p['dach_ciezar'].to_f * s * Math.cos(a)
        q = StatykaDachu.mi(kat) * p['dach_snieg'].to_f * s * Math.cos(a)**2
        r = Statyka.belka(w[:l] / Math.cos(a), b, h, g, q, p['drewno_klasa'], p['dach_ugiecie'].to_f, StatykaDachu::PSI2_SNIEG)
        { ok: r[:ok], wyk: [r[:wyk_m], r[:wyk_v]].max, l_przez_u: r[:l_przez_u] }
      end

      # Ocena belek (płatew, oczep) b × h – najbardziej wytężona: { ok:, wyk:, l_przez_u: }.
      def belki(lista, b, h, kat, p)
        granica = p['dach_ugiecie'].to_f
        lista.map do |x|
          g, q = StatykaDachu.obciazenia(x[:pas], p, kat)
          r = Statyka.belka(x[:l], b, h, g, q, p['drewno_klasa'], granica, StatykaDachu::PSI2_SNIEG)
          { ok: r[:ok], wyk: [r[:wyk_m], r[:wyk_v]].max, l_przez_u: r[:l_przez_u] }
        end.max_by { |r| [r[:wyk], granica / [r[:l_przez_u], 1.0].max].max }
      end

      # Ocena słupa b × h: { ok:, wyk: }.
      def slup(w, b, h, kat, p)
        g, q = StatykaDachu.obciazenia(w[:pas], p, kat)
        r = StatykaSlupa.sprawdz(w[:l], b, h, g * w[:rozstaw] / 1000.0, q * w[:rozstaw] / 1000.0, p['drewno_klasa'])
        { ok: r[:ok], wyk: r[:wyk] }
      end

      # Najlżejszy przekrój z listy klucz (magazyn), dla którego blok zwraca ok; nil – żaden.
      def najmniejszy(p, klucz)
        Parametry.katalog(p, klucz).sort_by { |b, h| [b * h, -h] }.find { |b, h| yield(b, h)[:ok] }
      end

      # Podpowiedzi sekcji „Drewutnia”: krokwie, płatew i oczep, słupy ([{ poziom:, tekst: }]); [] bez drewutni.
      def podpowiedzi(dom, sciany, inne, p)
        return [] unless Drewutnia.wybrana?(p) && Drewutnia.przeszkoda(p).nil? && dom && dom[:boczne].nil? && dom[:rola].nil?
        c = Drewutnia.geo(dom, sciany, inne.reject { |e| e[:tag] == :drewutnia }, p)
        return [] if c.nil? || c[:uwaga]
        w = wymiary(c, p)
        kat = p['drewutnia_kat'].to_f
        [
          opis('Krokwie', c[:krokiew], krokiew(w[:krokiew], c[:krokiew][0], c[:krokiew][1], kat, p),
               najmniejszy(p, 'krokwie_katalog') { |b, h| krokiew(w[:krokiew], b, h, kat, p) }, w[:krokiew][:l]),
          opis('Płatew i oczep', c[:belka], belki(w[:belki], c[:belka][0], c[:belka][1], kat, p),
               najmniejszy(p, 'zadaszenie_katalog') { |b, h| belki(w[:belki], b, h, kat, p) }, w[:belki][0][:l]),
          opis('Słupy', c[:slup], slup(w[:slup], c[:slup][0], c[:slup][1], kat, p),
               najmniejszy(p, 'zadaszenie_slupy_katalog') { |b, h| slup(w[:slup], b, h, kat, p) }, w[:slup][:l])
        ]
      end

      # Podpowiedź dla jednego rodzaju: przekrój bh, ocena r, najmniejszy wystarczający min, długość obliczeniowa l [mm].
      def opis(nazwa, bh, r, min, l)
        tekst = format('Drewutnia – %s %.0f × %.0f: długość obliczeniowa %s m, nośność %.0f %%', nazwa.downcase, bh[0], bh[1],
                       Parametry.fmt((l / 1000.0).round(2)), r[:wyk] * 100.0)
        tekst += ', ' + StatykaDachu.ugiecie_opis(r[:l_przez_u]) if r[:l_przez_u]
        if r[:ok]
          dopisek = min && min != bh ? format(' – wystarczy; najmniejszy wystarczający z magazynu: %.0f × %.0f.', min[0], min[1]) : ' – wystarczy.'
          return { poziom: 'ok', tekst: tekst + dopisek }
        end
        rada = min ? format('za słaby – z magazynu wystarczy %.0f × %.0f.', min[0], min[1]) : 'za słaby i nic z magazynu nie wystarcza – zmniejsz rozstaw słupów albo głębokość.'
        { poziom: 'uwaga', tekst: tekst + ' – ' + rada }
      end
    end
  end
end
