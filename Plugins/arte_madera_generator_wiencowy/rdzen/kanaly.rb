# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: rdzen/kanaly.rb
# Zadanie: kanały na przewody elektryczne (N3) – pionowy otwór przez wszystkie wieńce ściany w zadanym miejscu (obróbka „kanal” bali, bryła z otworem) i opcjonalnie otwór puszki na zadanej wysokości (obróbka „puszka” – na liście obróbek); sprawdzenie miejsca (ściana, zamki skrzyżowań).
# Tematy: kanał na przewody, kanały elektryczne, otwór pionowy w balach, puszka elektryczna, obróbka kanal, obróbka puszka, wiercenie bali, strona puszki, kanał pod oknem
# Zależy od: rdzen/parametry.rb, rdzen/bryla.rb (SCAL; profil z obróbką kanal – kanal_pasow)
# Używają: rdzen/projekt.rb (przypisanie po otworach, obróbka po zamkach), rdzen/widok.rb (kanały w widoku ściany), html/klik_sciana.js (okienko kanału)
#
# Propozycja N3 z rundy 15 (przyjęta w poleceniu rundy 18): „w ścianie z bali przewodu nie da się poprowadzić później”.
# Wejście domu 'kanaly' => [{ 'sciana' => 'W-1', 'od' => mm (oś kanału od punktu odniesienia ściany, jak „od” otworu),
# 'srednica' => mm (puste – kanal_srednica), 'puszka' => mm (środek puszki od spodu pierwszego bala; puste – bez puszki),
# 'strona' => 'lewa' (puste – lico lewe ściany, +nor: wnętrze ściany zewnętrznej) albo 'prawa' (lico prawe, −nor) }].
# Ściana: w[:kanaly] = [{ s:, r:, puszka:, strona: (1 – lewa, 0 – prawa), do: (z spodu otworu albo nil), nazwa: 'K1', nr: }].
# Bal tej ściany, który zachodzi na kanał, dostaje obróbkę { typ: 'kanal', x0:, x1:, y0:, y1: } – otwór kwadratowy o boku
# średnicy w osi grubości bala na całą wysokość (rdzen/bryla.rb dzieli pasy przekroju); bal z puszką – { typ: 'puszka',
# x0:, x1:, z0:, z1:, strona: } (tylko na liście obróbek, bryła bez zmian). Kanał bliżej lica ściany poprzecznej
# (skrzyżowanie, węgieł) niż kanal_odstep_zamka – pominięty z ostrzeżeniem (trafiłby w zamek). Kanał w miejscu okna albo
# drzwi (runda 19, zadanie_r18 §2) – otwór tylko w balach pod otworem (od spodu ściany do parapetu), puszka nad parapetem
# pominięta; uwaga w wynikach.
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

require File.join(File.dirname(__FILE__), 'parametry') unless defined?(ArteMadera::GeneratorWiencowy::Parametry)
require File.join(File.dirname(__FILE__), 'bryla') unless defined?(ArteMadera::GeneratorWiencowy::Bryla)

module ArteMadera
  module GeneratorWiencowy
    module Kanaly
      module_function

      # Przypisanie kanałów do ścian (w[:kanaly]); zwraca listę ostrzeżeń.
      def przypisz(wejscie, sciany, p)
        uwagi = []
        sciany.each { |w| w[:kanaly] = [] }
        t = Parametry.grubosc(p)
        (wejscie || []).each_with_index do |k, i|
          nazwa = "K#{i + 1}"
          w = sciany.find { |s| s[:id] == k['sciana'].to_s.strip }
          if w.nil? || w[:rodzaj] == :kontrfor
            uwagi << "Kanał #{nazwa}: nie ma ściany „#{k['sciana']}” – pominięty."
            next
          end
          od = Parametry.liczba(k['od'])
          d = Parametry.liczba(k['srednica']) || p['kanal_srednica'].to_f
          if od.nil? || d <= 0.0
            uwagi << "Kanał #{nazwa} (#{w[:id]}): brak położenia – pominięty."
            next
          end
          d = [d, t - 2.0 * Bryla::SCAL - 1.0].min
          s = w[:ref] + od
          r = d / 2.0
          if s - r < w[:s_od] || s + r > w[:s_do]
            uwagi << "Kanał #{nazwa} (#{w[:id]}) wychodzi poza ścianę – pominięty."
            next
          end
          kol = kolizja_zamka(w, s, r, t, p)
          if kol
            uwagi << format('Kanał %s (%s) jest bliżej niż %.0f mm od lica ściany %s – trafiłby w zamek; pominięty.', nazwa, w[:id],
                            p['kanal_odstep_zamka'].to_f, kol)
            next
          end
          kk = { s: s, r: r, puszka: Parametry.liczba(k['puszka']), strona: k['strona'].to_s == 'prawa' ? 0 : 1, nazwa: nazwa, nr: i }
          uwagi.concat(pod_otworem!(kk, w))
          w[:kanaly] << kk
        end
        uwagi
      end

      # Kanał kk w miejscu okna albo drzwi ściany w: otwór w balach tylko pod nim (kk[:do] = spód otworu), puszka nad spodem
      # otworu pominięta; zwraca uwagi.
      def pod_otworem!(kk, w)
        o = (w[:otwory] || []).reject { |x| x[:gniazdo] }.select { |x| x[:s0] < kk[:s] + kk[:r] && x[:s1] > kk[:s] - kk[:r] }.min_by { |x| x[:z0] }
        return [] if o.nil?
        kk[:do] = o[:z0]
        uwagi = [format('Kanał %s (%s) trafia w otwór %s – otwór w balach tylko pod nim (do %.0f mm od spodu ściany).', kk[:nazwa],
                        w[:id], o[:nazwa] || 'okna', o[:z0])]
        if kk[:puszka] && kk[:puszka] >= o[:z0] - 0.01
          uwagi << format('Kanał %s (%s): puszka %.0f mm jest w otworze %s – pominięta.', kk[:nazwa], w[:id], kk[:puszka], o[:nazwa] || 'okna')
          kk[:puszka] = nil
        end
        uwagi
      end

      # Ściana poprzeczna (id), w której zamek trafiłby kanał s ± r; nil – kanał z dala od skrzyżowań.
      def kolizja_zamka(w, s, r, t, p)
        odstep = p['kanal_odstep_zamka'].to_f
        k = (w[:skrzyzowania] || []).find { |x| (s - x[:s]).abs < t / 2.0 + odstep + r }
        k ? (k[:inna][:id] || 'poprzecznej') : nil
      end

      # Obróbki kanałów i puszek w balach (po zamkach): każdy bal ściany z kanałami, który zachodzi na kanał.
      def obrob!(bale, p)
        t = Parametry.grubosc(p)
        sr = p['kanal_puszka_srednica'].to_f / 2.0
        bale.each do |b|
          kanaly = b[:sciana][:kanaly]
          next if kanaly.nil? || kanaly.empty?
          kanaly.each do |k|
            next if k[:do] && b[:z0] >= k[:do] - 0.01
            x0 = [k[:s] - k[:r] - b[:s0], 0.0].max
            x1 = [k[:s] + k[:r] - b[:s0], b[:dl]].min
            next if x1 - x0 <= Bryla::SCAL
            b[:cechy] << { typ: 'kanal', x0: x0, x1: x1, y0: t / 2.0 - k[:r], y1: t / 2.0 + k[:r] }
            next if k[:puszka].nil? || k[:puszka] < b[:z0] - 0.01 || k[:puszka] >= b[:z0] + b[:h] - 0.01
            xs = k[:s] - b[:s0]
            zs = k[:puszka] - b[:z0]
            b[:cechy] << { typ: 'puszka', x0: xs - sr, x1: xs + sr, z0: zs, z1: zs, strona: k[:strona] || 1 }
          end
        end
      end

      # Zdanie do wyników: ile kanałów i bali z otworem kanału i puszki; nil – bez kanałów.
      def opis(bale)
        n_k = bale.count { |b| b[:cechy].any? { |c| c[:typ] == 'kanal' } }
        return nil if n_k.zero?
        n_p = bale.count { |b| b[:cechy].any? { |c| c[:typ] == 'puszka' } }
        kanaly = bale.map { |b| b[:sciana] }.uniq.inject(0) { |s, w| s + (w[:kanaly] || []).length }
        format('Kanały na przewody: %d – otwór pionowy w %d balach, otwór puszki w %d (wiercenie na liście obróbek bala).', kanaly, n_k, n_p)
      end

      # Kanały ściany w do widoku: [[s, d, puszka albo nil, nazwa, nr, koniec u góry (spód otworu) albo nil]].
      def do_widoku(w)
        (w[:kanaly] || []).map { |k| [k[:s], k[:r] * 2.0, k[:puszka], k[:nazwa], k[:nr], k[:do]] }
      end
    end
  end
end
