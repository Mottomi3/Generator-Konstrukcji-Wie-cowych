/*
  ArteMadera – Generator Wieńcowy
  Plik: html/przeliczenia.js
  Zadanie: przeliczenia przy parametrach – podpowiedzi z obliczeń (legar, podciąg, fundamenty, dach) pokazane w sekcji parametrów, której dotyczą, i krótka informacja, co zmieniło się w domu po ostatniej zmianie pola.
  Tematy: przeliczenia przy parametrach, podpowiedzi w sekcji, co się zmieniło, zmiana po podglądzie, ocena przekroju przy polu
  Zależy od: html/wspolne.js (AMGW_DOM)
  Używają: html/okno.js (pokazWynik – po każdym podglądzie)

  Podpowiedź z Ruby: { poziom: 'ok' | 'uwaga' | 'blad', tekst:, sekcja: klucz sekcji okna (rdzen/projekt.rb#belki) }.
  Zmiana: liczby bieżącego wyniku porównane z poprzednim (bale, pozycje, objętości, belki).
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_PRZELICZENIA = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;
  var poprzednie = null;
  // Liczby porównywane po podglądzie: [klucz, nazwa, miejsca po przecinku, jednostka].
  var LICZBY = [['bale', 'bale', 0, ''], ['pozycje', 'pozycje', 0, ''], ['objetosc_m3', 'bale', 2, ' m³'],
                ['belki', 'belki', 0, ''], ['objetosc_belek_m3', 'belki', 2, ' m³']];

  // Podpowiedzi w sekcjach: ramka „przeliczenia” na końcu pól każdej sekcji, do której są podpowiedzi.
  function wSekcjach(podp) {
    var stare = document.querySelectorAll('.przeliczenia');
    var i;
    for (i = 0; i < stare.length; i++) { stare[i].parentNode.removeChild(stare[i]); }
    var wg = {};
    for (i = 0; i < (podp || []).length; i++) {
      if (podp[i].sekcja) { (wg[podp[i].sekcja] = wg[podp[i].sekcja] || []).push(podp[i]); }
    }
    var k;
    for (k in wg) {
      if (Object.prototype.hasOwnProperty.call(wg, k) && $('pola-' + k)) {
        var box = el('div', { 'class': 'przeliczenia', id: 'przel-' + k });
        for (i = 0; i < wg[k].length; i++) { box.appendChild(el('div', { 'class': wg[k][i].poziom }, wg[k][i].tekst)); }
        $('pola-' + k).appendChild(box);
      }
    }
  }

  // Liczba z zaokrągleniem i przecinkiem.
  function liczba(v, m) {
    return Number(v || 0).toFixed(m).replace('.', ',');
  }

  // Co się zmieniło względem poprzedniego podglądu (tekst; pusty – bez zmian albo pierwszy podgląd).
  function zmiana(n) {
    if (!n) { return ''; }
    var wynik = [];
    var i;
    if (poprzednie) {
      for (i = 0; i < LICZBY.length; i++) {
        var k = LICZBY[i][0];
        var d = Number(n[k] || 0) - Number(poprzednie[k] || 0);
        if (Math.abs(d) < Math.pow(10, -LICZBY[i][2]) / 2) { continue; }
        wynik.push(LICZBY[i][1] + ' ' + liczba(n[k], LICZBY[i][2]) + LICZBY[i][3] + ' (' + (d > 0 ? '+' : '−') +
                   liczba(Math.abs(d), LICZBY[i][2]) + ')');
      }
    }
    poprzednie = n;
    return wynik.length ? 'Po ostatniej zmianie: ' + wynik.join(', ') + '.' : '';
  }

  // Po podglądzie: podpowiedzi w sekcjach i informacja o zmianie (element #zmiana-podgladu).
  function pokaz(d) {
    wSekcjach(d.podpowiedzi);
    var box = $('zmiana-podgladu');
    if (box) {
      var t = zmiana(d.liczby);
      wyczysc(box);
      if (t) { box.appendChild(document.createTextNode(t)); }
    }
  }

  return { pokaz: pokaz, zmiana: zmiana };
})();
