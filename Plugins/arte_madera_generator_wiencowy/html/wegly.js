/*
  ArteMadera – Generator Wieńcowy
  Plik: html/wegly.js
  Zadanie: tabela węgłów (kontrforów) w oknie – jak okna i drzwi: ściana, położenie (od narożnika albo na środku ściany), od [mm], wypust wewnątrz i na zewnątrz [mm].
  Tematy: tabela węgłów, węgieł z tabeli, kontrfor w oknie, węgieł na środku ściany, nowy węgieł
  Zależy od: html/wspolne.js (AMGW_DOM), html/okno.html (tabela #tab-wegly)
  Używają: html/okno.js (init, dodaj, zbierz, sciany), html/wegly_przesun.js (ustawOd – przesunięcie węgła z tabeli)

  Wiersz = { sciana, polozenie: 'od' | 'srodek', od, wewn, zewn (puste – z parametrów) } – te same klucze co wejście 'wegly' w Ruby (rdzen/wegly_tabela.rb).
  Pole „od” przy położeniu „na środku” jest nieaktywne.
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_WEGLY = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;
  var stan = { sciany: [], zmiana: function () {} };

  // Start: reakcja na zmianę wiersza (podgląd).
  function init(zmiana) {
    stan.zmiana = zmiana;
  }

  // Treść tabeli.
  function tbody() { return $('tab-wegly').getElementsByTagName('tbody')[0]; }

  // Lista ścian (bez węgłów); brakująca ściana zostaje z dopiskiem.
  function wypelnijSciany(sel, wybrana) {
    var i;
    var jest = false;
    wyczysc(sel);
    for (i = 0; i < stan.sciany.length; i++) {
      var w = stan.sciany[i];
      if (w.rodzaj === 'kontrfor') { continue; }
      var o = el('option', { value: w.id, title: w.rodzaj }, w.id);
      if (w.id === wybrana) { o.selected = true; jest = true; }
      sel.appendChild(o);
    }
    if (wybrana && !jest) {
      var brak = el('option', { value: wybrana }, wybrana + ' (brak)');
      brak.selected = true;
      sel.appendChild(brak);
    }
  }

  // Pole „od” aktywne tylko przy położeniu od narożnika.
  function odswiezWiersz(tr) {
    var pol = tr.querySelector('[data-w="polozenie"]').value;
    var od = tr.querySelector('[data-w="od"]');
    od.disabled = pol === 'srodek';
    od.title = pol === 'srodek' ? 'Węgieł w osi ściany – odległość liczy się sama' : 'Oś węgła od narożnika lica zewnętrznego';
  }

  // Pole wypustu węgła (wewn / zewn) w wierszu tr; puste – z parametrów.
  function poleWypustu(tr, klucz, wartosc, opis) {
    var td = el('td');
    var pole = el('input', { type: 'text', 'data-w': klucz, title: opis, placeholder: 'param.' });
    pole.value = wartosc === undefined || wartosc === null ? '' : String(wartosc);
    pole.addEventListener('change', function () { stan.zmiana(); });
    td.appendChild(pole);
    tr.appendChild(td);
  }

  // Nowy wiersz tabeli z danymi węgła x (sciana, polozenie, od, wewn, zewn).
  function dodaj(x) {
    var tr = el('tr');
    var td = el('td');
    var sel = el('select', { 'data-w': 'sciana' });
    wypelnijSciany(sel, x.sciana);
    sel.addEventListener('change', function () { stan.zmiana(); });
    td.appendChild(sel);
    tr.appendChild(td);
    td = el('td');
    var pol = el('select', { 'data-w': 'polozenie' });
    pol.appendChild(el('option', { value: 'od' }, 'od narożnika'));
    pol.appendChild(el('option', { value: 'srodek' }, 'na środku ściany'));
    pol.value = x.polozenie === 'srodek' ? 'srodek' : 'od';
    pol.addEventListener('change', function () { odswiezWiersz(tr); stan.zmiana(); });
    td.appendChild(pol);
    tr.appendChild(td);
    td = el('td');
    var od = el('input', { type: 'text', 'data-w': 'od' });
    od.value = x.od === undefined || x.od === null ? '' : String(x.od);
    od.addEventListener('change', function () { stan.zmiana(); });
    td.appendChild(od);
    tr.appendChild(td);
    poleWypustu(tr, 'wewn', x.wewn, 'Wypust wewnątrz domu [mm]; puste – z parametru „Węgieł – wypust wewnątrz domu”');
    poleWypustu(tr, 'zewn', x.zewn, 'Wypust na zewnątrz [mm]; puste – z parametru „Węgieł – wypust na zewnątrz”');
    td = el('td');
    var usun = el('button', { type: 'button', title: 'Usuń węgieł' }, '×');
    usun.addEventListener('click', function () { tr.parentNode.removeChild(tr); stan.zmiana(); });
    td.appendChild(usun);
    tr.appendChild(td);
    tbody().appendChild(tr);
    odswiezWiersz(tr);
  }

  // Węgły z tabeli do wysłania do Ruby.
  function zbierz() {
    var wiersze = tbody().getElementsByTagName('tr');
    var wynik = [];
    var i;
    for (i = 0; i < wiersze.length; i++) {
      var pola = wiersze[i].querySelectorAll('[data-w]');
      var x = {};
      var j;
      for (j = 0; j < pola.length; j++) { x[pola[j].getAttribute('data-w')] = pola[j].value; }
      wynik.push(x);
    }
    return wynik;
  }

  // Nowa lista ścian (po podglądzie) – odświeżenie list w wierszach.
  function sciany(lista) {
    stan.sciany = lista || [];
    var sel = $('tab-wegly').querySelectorAll('select[data-w="sciana"]');
    var i;
    for (i = 0; i < sel.length; i++) { wypelnijSciany(sel[i], sel[i].value); }
  }

  // Nowe położenie węgła z wiersza nr i (przesunięcie z listy węgłów – html/wegly_przesun.js): od narożnika, od [mm].
  function ustawOd(i, od) {
    var tr = tbody().getElementsByTagName('tr')[i];
    if (!tr) { return; }
    tr.querySelector('[data-w="polozenie"]').value = 'od';
    tr.querySelector('[data-w="od"]').value = String(Math.round(od));
    odswiezWiersz(tr);
    stan.zmiana();
  }

  return { init: init, dodaj: dodaj, zbierz: zbierz, sciany: sciany, ustawOd: ustawOd };
}());
