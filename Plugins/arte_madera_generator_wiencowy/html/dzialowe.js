/*
  ArteMadera – Generator Wieńcowy
  Plik: html/dzialowe.js
  Zadanie: ściany działowe w domu z wymiarów (bez rysowania) – tabela w oknie: kierunek, odległość osi od lica, początek i długość; dane do Ruby.
  Tematy: działowe z tabeli okna, tabela działowych, działowa w domu z wymiarów, dodaj działową, usuń działową
  Zależy od: html/wspolne.js (AMGW_DOM), html/okno.html (karta #karta-dzialowe, tabela #tab-dzialowe)
  Używają: html/okno.js (init, zbierz – klucz 'dzialowe' w danych do Ruby)

  Wiersz jak w rdzen/dom_z_wymiarow.rb: kierunek 'poprzek' (równoległa do szerokości domu) albo 'wzdluz' (do długości), od – oś
  działowej od lica zewnętrznego ściany W-1 (poprzek – od lewego narożnika, wzdłuż – od dolnej ściany), poczatek i dlugosc
  (puste – od lica do lica). Karta widoczna tylko w domu z wymiarów.
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_DZIALOWE = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var KIERUNKI = [['poprzek', 'w poprzek (równoległa do szerokości)'], ['wzdluz', 'wzdłuż (równoległa do długości)']];
  var KLUCZE = ['od', 'poczatek', 'dlugosc'];
  var stan = { zmiana: function () {}, wlaczone: false };

  // Ciało tabeli działowych.
  function tbody() { return $('tab-dzialowe').getElementsByTagName('tbody')[0]; }

  // Nowy wiersz tabeli z danymi d ({ kierunek, od, poczatek, dlugosc }).
  function dodaj(d) {
    var tr = el('tr');
    var td = el('td');
    var sel = el('select', { 'data-d': 'kierunek' });
    var i;
    for (i = 0; i < KIERUNKI.length; i++) {
      var o = el('option', { value: KIERUNKI[i][0] }, KIERUNKI[i][1]);
      if (KIERUNKI[i][0] === (d.kierunek || 'poprzek')) { o.selected = true; }
      sel.appendChild(o);
    }
    sel.addEventListener('change', function () { stan.zmiana(); });
    td.appendChild(sel);
    tr.appendChild(td);
    for (i = 0; i < KLUCZE.length; i++) {
      td = el('td');
      var inp = el('input', { type: 'text', 'data-d': KLUCZE[i], inputmode: 'decimal' });
      inp.value = d[KLUCZE[i]] === undefined || d[KLUCZE[i]] === null ? '' : String(d[KLUCZE[i]]);
      inp.addEventListener('change', function () { stan.zmiana(); });
      td.appendChild(inp);
      tr.appendChild(td);
    }
    td = el('td');
    var usun = el('button', { type: 'button', title: 'Usuń działową' }, '×');
    usun.addEventListener('click', function () { tr.parentNode.removeChild(tr); stan.zmiana(); });
    td.appendChild(usun);
    tr.appendChild(td);
    tbody().appendChild(tr);
  }

  // Start: działowe zapisane w domu, czy to dom z wymiarów (karta widoczna) i podgląd po zmianie.
  function init(lista, zWymiarow, zmiana) {
    stan.zmiana = zmiana;
    stan.wlaczone = !!zWymiarow;
    AMGW_DOM.wyczysc(tbody());
    var karta = $('karta-dzialowe');
    karta.setAttribute('data-krok', stan.wlaczone ? 'sciany' : 'brak');
    karta.style.display = stan.wlaczone ? '' : 'none';
    var i;
    for (i = 0; i < (lista || []).length; i++) { dodaj(lista[i]); }
  }

  // Działowe z tabeli do wysłania do Ruby; poza domem z wymiarów – null (Ruby zostawia działowe domu bez zmian).
  function zbierz() {
    if (!stan.wlaczone) { return null; }
    var tr = tbody().getElementsByTagName('tr');
    var wynik = [];
    var i;
    var j;
    for (i = 0; i < tr.length; i++) {
      var d = {};
      var pola = tr[i].querySelectorAll('[data-d]');
      for (j = 0; j < pola.length; j++) { d[pola[j].getAttribute('data-d')] = pola[j].value; }
      wynik.push(d);
    }
    return wynik;
  }

  // Nowa działowa w poprzek na środku długości domu (od – z pola długości).
  function nowa(dlugoscDomu) {
    var dl = AMGW_DOM.liczba(dlugoscDomu);
    dodaj({ kierunek: 'poprzek', od: dl ? String(Math.round(dl / 2)) : '3000', poczatek: '', dlugosc: '' });
    stan.zmiana();
  }

  return { init: init, zbierz: zbierz, dodaj: dodaj, nowa: nowa };
}());
