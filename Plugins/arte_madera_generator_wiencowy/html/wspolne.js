/*
  ArteMadera – Generator Wieńcowy
  Plik: html/wspolne.js
  Zadanie: wspólne funkcje okna – element po identyfikatorze, nowy element, czyszczenie, liczby do wyświetlenia, przebudowa po kliknięciu.
  Tematy: funkcje pomocnicze okna, tworzenie elementów, formatowanie liczb, kliknięcie tuż po zmianie pola (przebudowa odłożona)
  Zależy od: html/okno.html (ładowany pierwszy)
  Używają: html/okno.js, html/rzut.js, html/wyniki.js

  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_DOM = (function () {
  'use strict';

  // Element po identyfikatorze.
  function $(id) { return document.getElementById(id); }

  // Nowy element z atrybutami i tekstem.
  function el(tag, atrybuty, tekst) {
    var e = document.createElement(tag);
    var k;
    if (atrybuty) {
      for (k in atrybuty) {
        if (Object.prototype.hasOwnProperty.call(atrybuty, k)) { e.setAttribute(k, atrybuty[k]); }
      }
    }
    if (tekst !== undefined && tekst !== null) { e.appendChild(document.createTextNode(String(tekst))); }
    return e;
  }

  // Usunięcie zawartości elementu.
  function wyczysc(e) { while (e.firstChild) { e.removeChild(e.firstChild); } }

  // Liczba z tekstu (przecinek dziesiętny dozwolony); null, gdy to nie liczba.
  function liczba(v) {
    var t = String(v === undefined || v === null ? '' : v).replace(',', '.').replace(/\s+/g, '');
    if (!/^-?\d+(\.\d+)?$/.test(t)) { return null; }
    return parseFloat(t);
  }

  // Liczba do wyświetlenia (bez zbędnego ,0).
  function fmt(v) {
    var n = Number(v);
    if (isNaN(n)) { return String(v); }
    return Math.abs(n - Math.round(n)) < 1e-9 ? String(Math.round(n)) : n.toFixed(1);
  }

  // Liczba do pola formularza: bez zaokrąglania do jednego miejsca (0,35 zostaje 0.35 – do trzech miejsc, bez zbędnych zer).
  function fmtPola(v) {
    var n = Number(v);
    if (isNaN(n)) { return String(v); }
    return Math.abs(n - Math.round(n)) < 1e-9 ? String(Math.round(n)) : String(Math.round(n * 1000) / 1000);
  }

  // Przebudowa okna po zmianie pola – dopiero po puszczeniu przycisku myszy. Zmiana pola przychodzi w chwili naciśnięcia
  // innego elementu (pole traci fokus); gdyby okno przesunęło się przed puszczeniem przycisku, kliknięcie nie trafiłoby
  // w przycisk i trzeba by klikać drugi raz.
  var mysz = { wcisnieta: false, odlozone: [] };

  // Wykonanie odłożonych przebudów (po kliknięciu albo gdy okno straciło fokus z wciśniętym przyciskiem).
  function wykonajOdlozone() {
    var lista = mysz.odlozone;
    var i;
    mysz.wcisnieta = false;
    mysz.odlozone = [];
    for (i = 0; i < lista.length; i++) { lista[i](); }
  }

  // Funkcja przebudowy: od razu, gdy przycisk myszy nie jest wciśnięty; inaczej tuż po kliknięciu.
  function poKliknieciu(fn) {
    if (mysz.wcisnieta) { mysz.odlozone.push(fn); } else { fn(); }
  }

  document.addEventListener('mousedown', function () { mysz.wcisnieta = true; }, true);
  document.addEventListener('mouseup', function () {
    mysz.wcisnieta = false;
    if (mysz.odlozone.length) { window.setTimeout(wykonajOdlozone, 30); }
  }, true);
  window.addEventListener('blur', function () { if (mysz.wcisnieta) { wykonajOdlozone(); } });

  return { $: $, el: el, wyczysc: wyczysc, liczba: liczba, fmt: fmt, fmtPola: fmtPola, poKliknieciu: poKliknieciu };
}());
