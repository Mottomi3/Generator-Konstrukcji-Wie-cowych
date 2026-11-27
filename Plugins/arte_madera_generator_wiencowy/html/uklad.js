/*
  ArteMadera – Generator Wieńcowy
  Plik: html/uklad.js
  Zadanie: przełącznik układu okna – nowy (kroki w kolejności budowy, rzut i uwagi zawsze na widoku) albo dotychczasowy (zakładki i sekcje, tryb Podstawowe / Wszystkie); rozmieszczenie kart i odświeżenie widoczności pól we właściwym układzie.
  Tematy: układ okna, przełącznik układu, układ nowy i dotychczasowy, rozmieszczenie kart, porównanie układów
  Zależy od: html/wspolne.js (AMGW_DOM), html/kroki.js (układ nowy), html/tryb.js (układ dotychczasowy), html/zakladki.js
  Używają: html/okno.js (start, zmiana pola, odpowiedź typów)

  Użytkownik chce móc porównać oba układy i zostać przy jednym (odpowiedź z 2026-11-25) – wybór zapamiętany na komputerze
  (wywołanie Ruby uklad). Karty mają stałe identyfikatory; w układzie nowym rzut i wynik zostają po prawej, a karty
  z atrybutem data-krok przechodzą pod pola kroku.
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_UKLAD = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  // Karty w kolejności układu dotychczasowego (prawa kolumna) i karty zawsze po prawej w układzie nowym.
  var KARTY = ['karta-rzut', 'karta-widok', 'karta-otwory', 'karta-dzialowe', 'karta-wegly-przesun', 'karta-wegly', 'karta-wynik',
               'karta-zestawienie'];
  var PRAWE = ['karta-rzut', 'karta-wynik'];
  var stan = { uklad: 'kroki', opisy: [], otwarte: null };

  // Karty we właściwych kolumnach: układ nowy – rzut i wynik po prawej, reszta pod polami kroku; dotychczasowy –
  // wszystkie po prawej w dawnej kolejności i widoczne.
  function rozmiesc() {
    var prawa = $('prawa');
    var lewa = $('krok-karty');
    var i;
    for (i = 0; i < KARTY.length; i++) {
      var k = $(KARTY[i]);
      if (!k) { continue; }
      if (stan.uklad === 'kroki' && PRAWE.indexOf(KARTY[i]) < 0) {
        lewa.appendChild(k);
      } else {
        prawa.appendChild(k);
        k.style.display = k.getAttribute('data-krok') === 'brak' ? 'none' : '';
      }
    }
  }

  // Rozwinięcie sekcji: przy przejściu do układu nowego zapamiętane (kroki rozwijają wszystkie), przy powrocie odtworzone.
  function sekcje() {
    var lista = document.querySelectorAll('#sekcje details');
    var i;
    if (stan.uklad === 'kroki') {
      if (!stan.otwarte) {
        stan.otwarte = {};
        for (i = 0; i < lista.length; i++) { stan.otwarte[lista[i].getAttribute('data-sekcja')] = lista[i].open; }
      }
    } else if (stan.otwarte) {
      for (i = 0; i < lista.length; i++) {
        var o = stan.otwarte[lista[i].getAttribute('data-sekcja')];
        if (o !== undefined) { lista[i].open = o; }
      }
      stan.otwarte = null;
    }
  }

  // Widoczność pól, sekcji i kart w bieżącym układzie.
  function odswiez(opisy) {
    stan.opisy = opisy || stan.opisy;
    if (stan.uklad === 'kroki') {
      AMGW_KROKI.zastosuj(stan.opisy);
    } else {
      AMGW_TRYB.zastosuj(stan.opisy);
      AMGW_ZAKLADKI.wybierz(AMGW_ZAKLADKI.biezaca());
    }
  }

  // Ustawienie układu ('kroki' | 'zakladki'): klasa na <body>, karty, przyciski, widoczność pól.
  function ustaw(nazwa, opisy) {
    stan.uklad = nazwa === 'zakladki' ? 'zakladki' : 'kroki';
    document.body.className = (document.body.className.replace(/\s*uklad-\w+/g, '') + ' uklad-' + stan.uklad).replace(/^\s+/, '');
    $('btn-uklad-kroki').className = stan.uklad === 'kroki' ? 'wybrany' : '';
    $('btn-uklad-zakladki').className = stan.uklad === 'zakladki' ? 'wybrany' : '';
    sekcje();
    rozmiesc();
    odswiez(opisy);
    return stan.uklad;
  }

  // Bieżący układ.
  function uklad() { return stan.uklad; }

  return { ustaw: ustaw, odswiez: odswiez, uklad: uklad };
}());
