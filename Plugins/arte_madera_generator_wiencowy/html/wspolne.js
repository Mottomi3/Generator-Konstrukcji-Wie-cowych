/*
  ArteMadera – Generator Wieńcowy
  Plik: html/wspolne.js
  Zadanie: wspólne funkcje okna – element po identyfikatorze, nowy element, czyszczenie, liczby do wyświetlenia.
  Tematy: funkcje pomocnicze okna, tworzenie elementów, formatowanie liczb
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

  return { $: $, el: el, wyczysc: wyczysc, liczba: liczba, fmt: fmt };
}());
