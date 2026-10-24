/*
  ArteMadera – Generator Wieńcowy
  Plik: html/tryb.js
  Zadanie: tryb pól okna – „Podstawowe” (tylko najczęściej zmieniane parametry i te zmienione względem fabrycznych) albo „Wszystkie”.
  Tematy: tryb podstawowe / zaawansowane, pola podstawowe, ukrywanie pól, przełącznik pól, zapamiętany tryb okna
  Zależy od: html/wspolne.js (AMGW_DOM), html/zmiany.js (klasa „zmieniony” na etykiecie)
  Używają: html/okno.js (po zbudowaniu formularza, po zmianie pola, przełącznik w nagłówku formularza)

  Pole podstawowe: opis.podstawowy (ParametryLista w Ruby, podstawowy: true). Pole zmienione względem fabrycznych jest
  widoczne także w trybie podstawowym – nic, co wpływa na dom, nie znika z oczu.
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_TRYB = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var stan = { tryb: 'podstawowe' };

  // Pokazanie albo ukrycie elementu (pusty display – wartość z arkusza stylów).
  function pokaz(e, widoczny) {
    if (e) { e.style.display = widoczny ? '' : 'none'; }
  }

  // Widoczność pól według trybu: w trybie podstawowym pola podstawowe i zmienione, sekcje bez widocznych pól ukryte,
  // wymiary zamka tylko w trybie „Wszystkie”.
  function zastosuj(opisy) {
    var wszystkie = stan.tryb === 'wszystkie';
    var widoczneWSekcji = {};
    var i;
    for (i = 0; i < opisy.length; i++) {
      var o = opisy[i];
      var lab = $('l-' + o.klucz);
      var zmienione = lab && /(^|\s)zmieniony(\s|$)/.test(lab.className);
      var widoczne = wszystkie || o.podstawowy || zmienione;
      pokaz(lab, widoczne);
      pokaz($('p-' + o.klucz), widoczne);
      pokaz($('h-' + o.klucz), widoczne);
      if (widoczne) { widoczneWSekcji[o.sekcja] = true; }
    }
    pokaz($('pola-zamek'), wszystkie);
    var sekcje = document.querySelectorAll('#sekcje details');
    for (i = 0; i < sekcje.length; i++) {
      pokaz(sekcje[i], wszystkie || !!widoczneWSekcji[sekcje[i].getAttribute('data-sekcja')]);
    }
    przyciski();
  }

  // Wyróżnienie przycisku bieżącego trybu.
  function przyciski() {
    var p = $('btn-tryb-podstawowe');
    var w = $('btn-tryb-wszystkie');
    if (p) { p.className = stan.tryb === 'wszystkie' ? '' : 'wybrany'; }
    if (w) { w.className = stan.tryb === 'wszystkie' ? 'wybrany' : ''; }
  }

  // Ustawienie trybu ('podstawowe' | 'wszystkie') i odświeżenie widoczności pól.
  function ustaw(tryb, opisy) {
    stan.tryb = tryb === 'wszystkie' ? 'wszystkie' : 'podstawowe';
    zastosuj(opisy || []);
    return stan.tryb;
  }

  // Bieżący tryb.
  function tryb() { return stan.tryb; }

  return { ustaw: ustaw, zastosuj: zastosuj, tryb: tryb };
}());
