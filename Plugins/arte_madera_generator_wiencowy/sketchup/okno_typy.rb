# encoding: UTF-8
#
# ArteMadera – Generator Wieńcowy
# Plik: sketchup/okno_typy.rb
# Zadanie: wywołania okna dla typów domów i standardu warsztatu – wybór typu, „Zapisz jako typ”, „Zapisz zmiany w typie”, powielenie, usunięcie, zapis i przywrócenie standardu, układ okna; odpowiedź do okna: lista typów i baza porównania.
# Tematy: okno – typy domów, okno – standard warsztatu, wywołania typów, wybór typu w oknie, zapis typu z okna, zapis standardu z okna, układ okna – zapamiętanie, baza porównania do okna
# Zależy od: sketchup/typy_domow.rb, sketchup/ustawienia.rb, rdzen/poziomy.rb, log.rb
# Używają: sketchup/okno.rb (podlacz, dane startowe)
#
# Okno woła: typ_wybierz (nazwa), typ_zapisz ({ nazwa, opis, parametry }), typ_powiel ({ nazwa, nowa }), typ_usun (nazwa),
# standard_zapisz ({ typ, parametry }), standard_fabryczne (typ), uklad (nazwa). Odpowiedź: AMGW.typy({ lista, typ, baza,
# komunikat, blad, wczytaj (pola typu i domu do wpisania w okno), standard (standard zmieniony – pola standardu do odświeżenia) }).
# Zgodność: Ruby 2.2+ (bez &., bez Array#sum, bez <<~).

module ArteMadera
  module GeneratorWiencowy
    module OknoTypy
      module_function

      # Typy i baza porównania dla okna: lista typów, bieżący typ (nieznany – ostatnio wybrany) i wartości wszystkich
      # pól według standardu i tego typu.
      def dane(typ)
        nazwa = TypyDomow.typ(typ) ? typ.to_s : TypyDomow.wybrany
        { 'lista' => TypyDomow.lista, 'typ' => nazwa, 'baza' => TypyDomow.baza(nazwa) }
      end

      # Podłączenie wywołań do okna dlg; wyslij – blok wysyłający odpowiedź (hash) do okna.
      def podlacz(dlg, &wyslij)
        akcja(dlg, 'typ_wybierz') do |arg|
          blad = TypyDomow.wybierz(arg.to_s)
          wyslij.call(dane(arg).merge(blad ? { 'blad' => blad } : { 'wczytaj' => true, 'komunikat' => "Typ „#{arg}” – wpisano pola typu i domu." }))
        end
        akcja(dlg, 'typ_zapisz') do |arg|
          d = JSON.parse(arg.to_s)
          blad = TypyDomow.zapisz(d['nazwa'], d['opis'], d['parametry'])
          wyslij.call(dane(blad ? d['typ'] : d['nazwa'].to_s.strip).merge(blad ? { 'blad' => blad } : { 'komunikat' => "Zapisano typ „#{d['nazwa'].to_s.strip}”." }))
        end
        akcja(dlg, 'typ_powiel') do |arg|
          d = JSON.parse(arg.to_s)
          blad = TypyDomow.powiel(d['nazwa'], d['nowa'])
          wyslij.call(dane(blad ? d['nazwa'] : d['nowa'].to_s.strip).merge(blad ? { 'blad' => blad } : { 'komunikat' => "Powielono typ jako „#{d['nowa'].to_s.strip}”." }))
        end
        akcja(dlg, 'typ_usun') do |arg|
          blad = TypyDomow.usun(arg.to_s)
          wyslij.call(dane(blad ? arg : nil).merge(blad ? { 'blad' => blad } : { 'komunikat' => "Usunięto typ „#{arg}”." }))
        end
        akcja(dlg, 'standard_zapisz') do |arg|
          d = JSON.parse(arg.to_s)
          blad = Ustawienia.zapisz_standard(d['parametry'])
          wyslij.call(dane(d['typ']).merge(blad ? { 'blad' => blad } : { 'standard' => true, 'komunikat' => 'Zapisano standard warsztatu.' }))
        end
        akcja(dlg, 'standard_fabryczne') do |arg|
          blad = Ustawienia.zapisz_standard({})
          wyslij.call(dane(arg).merge(blad ? { 'blad' => blad } : { 'standard' => true, 'komunikat' => 'Standard warsztatu wrócił do wartości fabrycznych.' }))
        end
        akcja(dlg, 'uklad') { |arg| Ustawienia.zapamietaj_uklad(arg.to_s) }
      end

      # Jedno wywołanie okna z obsługą błędu (komunikat w dzienniku, okno działa dalej).
      def akcja(dlg, nazwa)
        dlg.add_action_callback(nazwa) do |_ctx, arg|
          begin
            yield(arg)
          rescue => e
            Log.error("OknoTypy.#{nazwa}", e)
          end
        end
      end
    end
  end
end
