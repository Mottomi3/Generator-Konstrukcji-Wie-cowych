/*
  ArteMadera – Generator Wieńcowy
  Plik: html/typy.js
  Zadanie: typ domu w oknie – lista typów z opisem, „Zapisz zmiany w typie”, „Zapisz jako typ”, powielenie, usunięcie, „Przywróć typ”; baza porównania (standard warsztatu i typ) i pola zmienione tylko w tym domu z przyciskiem powrotu.
  Tematy: pasek typu domu, wybór typu, zapisz jako typ, zapisz zmiany w typie, powiel typ, usuń typ, przywróć typ, baza porównania, pole zmienione tylko w tym domu, powrót pola do typu albo standardu, poziom pola w oknie
  Zależy od: html/wspolne.js (AMGW_DOM), html/zmiany.js (porównanie wartości)
  Używają: html/okno.js (start, odpowiedź Ruby, zmiana pola), html/kroki.js (widoczność pól), html/standard.js (wartości standardu)

  Dane z Ruby (sketchup/okno_typy.rb): { lista: [{ nazwa, opis, wbudowany }], typ, baza: { klucz: wartość, zamek: {…} },
  komunikat, blad, wczytaj (wpisać pola typu i domu), standard (odświeżyć pola standardu) }.
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_TYPY = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;
  var NAZWY = { dom: 'ten dom', typ: 'typ', standard: 'standard' };
  var stan = { lista: [], typ: '', baza: {}, opisy: [], wywolaj: null, poZmianie: null, ustawZamek: null, tryb: '', usun: 0 };

  // Typ z listy po nazwie (null – nie ma).
  function znajdz(nazwa) {
    var i;
    for (i = 0; i < stan.lista.length; i++) { if (stan.lista[i].nazwa === nazwa) { return stan.lista[i]; } }
    return null;
  }

  // Lista typów w polu wyboru, opis wybranego i dostępność przycisków (typ wbudowany – bez zapisu zmian i usuwania).
  function pokazListe() {
    var sel = $('typ');
    var i;
    wyczysc(sel);
    for (i = 0; i < stan.lista.length; i++) {
      var t = stan.lista[i];
      var o = el('option', { value: t.nazwa }, t.nazwa + (t.wbudowany ? ' (wbudowany)' : ''));
      if (t.nazwa === stan.typ) { o.selected = true; }
      sel.appendChild(o);
    }
    var b = znajdz(stan.typ);
    $('typ-opis').textContent = b ? b.opis : '';
    $('btn-typ-zapisz').disabled = !b || b.wbudowany;
    $('btn-typ-usun').disabled = !b || b.wbudowany;
    $('btn-typ-zapisz').title = b && b.wbudowany ? 'Typ wbudowany – użyj „Zapisz jako typ…” albo „Powiel…”' :
      'Pola typu i domu z okna zapisane w wybranym typie';
  }

  // Komunikat pod paskiem typu (blad – na czerwono).
  function komunikat(tekst, blad) {
    var k = $('typ-komunikat');
    k.textContent = tekst || '';
    k.className = 'drobny ' + (blad ? 'blad' : 'ok');
    var s = $('standard-komunikat');
    if (s) { s.textContent = tekst || ''; s.className = 'drobny ' + (blad ? 'blad' : 'ok'); }
  }

  // Wartość bazowa pola (standard i typ); brak w bazie – fabryczna.
  function bazowa(o) {
    var v = stan.baza[o.klucz];
    return v === undefined || v === null ? o.domyslna : v;
  }

  // Czy pole ma inną wartość niż w typie i standardzie (zmienione tylko w tym domu).
  function zmienione(o) {
    var p = $('p-' + o.klucz);
    return !!p && AMGW_ZMIANY.rozne(o, p.value, bazowa(o));
  }

  // Wpisanie wartości w pole parametru (liczby bez zbędnego ,0).
  function wpisz(o, v) {
    var p = $('p-' + o.klucz);
    if (!p) { return; }
    p.value = o.rodzaj === 'wybor' || o.rodzaj === 'przekroj' || o.rodzaj === 'tekst' ? String(v) : AMGW_DOM.fmtPola(v);
  }

  // Czy wymiary zamka w oknie są inne niż w bazie.
  function zamekZmieniony() {
    var pola = document.querySelectorAll('[data-zamek]');
    var z = stan.baza.zamek || {};
    var i;
    for (i = 0; i < pola.length; i++) {
      var k = pola[i].getAttribute('data-zamek');
      var a = AMGW_DOM.liczba(pola[i].value);
      if (z[k] !== undefined && typeof z[k] === 'number' && (a === null || Math.abs(a - z[k]) > 1e-9)) { return true; }
    }
    return false;
  }

  // Znacznik poziomu przy etykiecie (typ / standard; „tylko w tym domu”, gdy pole zmienione) i przycisk powrotu pola.
  function oznacz(opisy) {
    var ile = { dom: 0, typ: 0, standard: 0 };
    var i;
    stan.opisy = opisy || stan.opisy;
    for (i = 0; i < stan.opisy.length; i++) {
      var o = stan.opisy[i];
      var lab = $('l-' + o.klucz);
      if (!lab) { continue; }
      var zm = zmienione(o);
      if (zm) { ile[o.poziom] = (ile[o.poziom] || 0) + 1; }
      lab.className = (lab.className.replace(/\s*wdomu/g, '') + (zm ? ' wdomu' : '')).replace(/^\s+/, '');
      var znak = $('z-poziom-' + o.klucz);
      if (!znak && o.poziom !== 'dom') {
        znak = el('span', { 'class': 'poziom', id: 'z-poziom-' + o.klucz });
        lab.appendChild(znak);
      }
      if (znak) {
        znak.textContent = NAZWY[o.poziom] + (zm ? ' – tylko w tym domu' : '');
        znak.title = zm ? 'W ' + (o.poziom === 'typ' ? 'typie' : 'standardzie') + ': ' +
          (o.rodzaj === 'wybor' ? AMGW_ZMIANY.opisWyboru(o, bazowa(o)) : AMGW_DOM.fmtPola(bazowa(o))) : 'Pole poziomu „' + NAZWY[o.poziom] + '”';
      }
      przyciskPowrotu(o, lab, zm && o.poziom !== 'dom');
    }
    var k = $('typ-zmiany');
    if (k) {
      k.textContent = ile.typ + ile.standard > 0 ? 'Zmienione tylko w tym domu: pola typu ' + ile.typ + ', pola standardu ' + ile.standard + '.' : '';
    }
    return ile;
  }

  // Przycisk „↺” przy etykiecie pola zmienionego w tym domu: wartość z typu albo standardu.
  function przyciskPowrotu(o, lab, pokaz) {
    var b = $('r-' + o.klucz);
    if (!pokaz) {
      if (b) { b.parentNode.removeChild(b); }
      return;
    }
    if (b) { return; }
    b = el('span', { 'class': 'cofnij', id: 'r-' + o.klucz, role: 'button', title: 'Wartość z ' + (o.poziom === 'typ' ? 'typu domu' : 'standardu warsztatu') }, '↺');
    b.addEventListener('click', function (ev) {
      ev.preventDefault();
      ev.stopPropagation();
      wpisz(o, bazowa(o));
      if (stan.poZmianie) { stan.poZmianie(); }
    });
    lab.appendChild(b);
  }

  // Wszystkie pola (albo tylko podanych poziomów) z powrotem według bazy; z wymiarami zamka przy poziomie standard.
  function przywroc(poziomy) {
    var i;
    for (i = 0; i < stan.opisy.length; i++) {
      var o = stan.opisy[i];
      if (!poziomy || poziomy.indexOf(o.poziom) >= 0) { wpisz(o, bazowa(o)); }
    }
    if ((!poziomy || poziomy.indexOf('standard') >= 0) && stan.ustawZamek) { stan.ustawZamek(stan.baza); }
  }

  // Odpowiedź Ruby (AMGW.typy): nowa lista i baza; wczytaj – pola typu i domu według typu; standard – pola standardu,
  // których w tym domu nie zmieniono, według nowego standardu.
  function odpowiedz(d) {
    var i;
    var bezZmian = {};
    var zamekBezZmian = !zamekZmieniony();
    if (d.standard) {
      for (i = 0; i < stan.opisy.length; i++) {
        if (stan.opisy[i].poziom === 'standard' && !zmienione(stan.opisy[i])) { bezZmian[stan.opisy[i].klucz] = true; }
      }
    }
    stan.lista = d.lista || stan.lista;
    stan.typ = d.typ || stan.typ;
    stan.baza = d.baza || stan.baza;
    pokazListe();
    komunikat(d.blad || d.komunikat || '', !!d.blad);
    if (d.blad) { return; }
    zamknijNowy();
    if (d.wczytaj) { przywroc(['dom', 'typ']); }
    if (d.standard) {
      for (i = 0; i < stan.opisy.length; i++) {
        if (bezZmian[stan.opisy[i].klucz]) { wpisz(stan.opisy[i], bazowa(stan.opisy[i])); }
      }
      if (zamekBezZmian && stan.ustawZamek) { stan.ustawZamek(stan.baza); }
    }
    if (stan.poZmianie) { stan.poZmianie(!!d.standard); }
  }

  // Wiersz nazwy i opisu nowego typu: tryb 'zapisz' (Zapisz jako typ) albo 'powiel'.
  function otworzNowy(tryb) {
    stan.tryb = tryb;
    $('typ-nowy').className = 'wiersz';
    $('typ-opis-nowy').style.display = tryb === 'powiel' ? 'none' : '';
    $('typ-nazwa').value = tryb === 'powiel' ? stan.typ.replace(/ \(kopia\)$/, '') + ' (kopia)' : '';
    $('typ-opis-nowy').value = '';
    $('typ-nazwa').focus();
  }

  // Schowanie wiersza nowego typu.
  function zamknijNowy() {
    stan.tryb = '';
    $('typ-nowy').className = 'wiersz ukryty';
  }

  // Zatwierdzenie nazwy: zapis nowego typu z pól okna albo powielenie wybranego.
  function zatwierdzNowy(parametry) {
    if (stan.tryb === 'powiel') {
      stan.wywolaj('typ_powiel', JSON.stringify({ nazwa: stan.typ, nowa: $('typ-nazwa').value }));
    } else {
      stan.wywolaj('typ_zapisz', JSON.stringify({ typ: stan.typ, nazwa: $('typ-nazwa').value, opis: $('typ-opis-nowy').value, parametry: parametry() }));
    }
  }

  // Start: dane typów z Ruby, wywołanie Ruby, zbieranie parametrów z okna, odświeżenie po zmianie i wpisanie wymiarów zamka.
  function init(d, opisy, wywolaj, parametry, poZmianie, ustawZamek) {
    stan.lista = (d && d.lista) || [];
    stan.typ = (d && d.typ) || '';
    stan.baza = (d && d.baza) || {};
    stan.opisy = opisy || [];
    stan.wywolaj = wywolaj;
    stan.poZmianie = poZmianie;
    stan.ustawZamek = ustawZamek;
    pokazListe();
    if (!$('typ-zmiany')) { $('typ-opis').parentNode.insertBefore(el('p', { id: 'typ-zmiany', 'class': 'drobny' }), $('typ-komunikat')); }
    $('typ').onchange = function () { wywolaj('typ_wybierz', this.value); };
    $('btn-typ-przywroc').onclick = function () {
      przywroc(null);
      komunikat('Pola wróciły do typu i standardu warsztatu.', false);
      poZmianie();
    };
    $('btn-typ-zapisz').onclick = function () {
      wywolaj('typ_zapisz', JSON.stringify({ typ: stan.typ, nazwa: stan.typ, opis: null, parametry: parametry() }));
    };
    $('btn-typ-zapisz-jako').onclick = function () { otworzNowy('zapisz'); };
    $('btn-typ-powiel').onclick = function () { otworzNowy('powiel'); };
    $('btn-typ-ok').onclick = function () { zatwierdzNowy(parametry); };
    $('btn-typ-anuluj').onclick = zamknijNowy;
    $('btn-typ-usun').onclick = function () {
      // Usunięcie dopiero po drugim kliknięciu w ciągu 5 s (bez okienka pytania).
      var teraz = new Date().getTime();
      if (teraz - stan.usun < 5000) {
        stan.usun = 0;
        this.textContent = 'Usuń';
        wywolaj('typ_usun', stan.typ);
      } else {
        stan.usun = teraz;
        this.textContent = 'Usunąć? Kliknij jeszcze raz';
        var b = this;
        setTimeout(function () { b.textContent = 'Usuń'; }, 5000);
      }
    };
  }

  // Nazwa wybranego typu.
  function typ() { return stan.typ; }

  // Baza porównania (wartości pól według standardu i typu).
  function baza() { return stan.baza; }

  return { init: init, odpowiedz: odpowiedz, oznacz: oznacz, zmienione: zmienione, zamekZmieniony: zamekZmieniony, bazowa: bazowa,
           wpisz: wpisz, typ: typ, baza: baza };
}());
