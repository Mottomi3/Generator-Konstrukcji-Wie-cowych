/*
  ArteMadera – Generator Wieńcowy
  Plik: html/wegly_przesun.js
  Zadanie: przesuwanie węgłów w karcie okien i drzwi – lista wszystkich węgłów domu (automatyczne, pod płatwiami, na wolnych końcach, z rysunku, ręczne, z tabeli) z położeniem „od” jak przy otworach; zmiana położenia przesuwa węgieł.
  Tematy: przesuwanie węgłów, przesuń węgieł, lista węgłów w oknie, węgły przy oknach i drzwiach, skąd węgieł
  Zależy od: html/wspolne.js (AMGW_DOM), html/okno.html (tabela #tab-wegly-przesun), html/wegly.js (AMGW_WEGLY.ustawOd – węgieł z tabeli), html/edycja.js (AMGW_EDYCJA.przesun – węgły ręczne ściany)
  Używają: html/okno.js (pokaz po podglądzie)

  Lista z Ruby (rdzen/wegly_tabela.rb#lista): [{ id, sciana, s, od, skad, tabela }]. Węgieł z tabeli – zmiana wiersza tabeli;
  inny – węgły tej ściany (bez tych z tabeli i na środku z parametru) zapisane jako ręczne z nowym położeniem (automat ściany
  wyłączony, przywraca go przycisk w panelu ściany). Węgieł na środku z parametru – tylko podgląd położenia.
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_PRZESUN = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;
  var fmt = AMGW_DOM.fmt;
  var liczba = AMGW_DOM.liczba;
  var KROK = 50;
  var OPISY = {
    tabela: 'z tabeli węgłów', srodek: 'na środku (parametr)', rysunek: 'z rysunku', reczny: 'ręczny',
    styk: 'pod łączenie bali', usztywnienie: 'usztywniający', platwa: 'pod płatwią', koniec: 'na wolnym końcu'
  };
  var stan = { lista: [] };

  // Treść tabeli.
  function tbody() { return $('tab-wegly-przesun').getElementsByTagName('tbody')[0]; }

  // Osie (s) węgłów ściany, które idą na listę ręczną (bez z tabeli i na środku z parametru).
  function osieRecznych(sciana) {
    var wynik = [];
    var i;
    for (i = 0; i < stan.lista.length; i++) {
      var x = stan.lista[i];
      if (x.sciana === sciana && (x.tabela === null || x.tabela === undefined) && x.skad !== 'srodek') { wynik.push(x.s); }
    }
    return wynik;
  }

  // Przesunięcie węgła x na nowe „od” [mm].
  function przesun(x, od) {
    if (od === null || Math.abs(od - x.od) < 0.5) { return; }
    if (x.tabela !== null && x.tabela !== undefined) {
      AMGW_WEGLY.ustawOd(x.tabela, od);
      return;
    }
    AMGW_EDYCJA.przesun(x.sciana, osieRecznych(x.sciana), x.s, x.s + (od - x.od));
  }

  // Przycisk przesunięcia o krok (znak −1 / +1).
  function przycisk(x, znak) {
    var b = el('button', { type: 'button', title: (znak < 0 ? 'W lewo' : 'W prawo') + ' o ' + KROK + ' mm' }, znak < 0 ? '◀' : '▶');
    b.addEventListener('click', function () { przesun(x, x.od + znak * KROK); });
    return b;
  }

  // Wiersz węgła x.
  function wiersz(x) {
    var tr = el('tr');
    tr.appendChild(el('td', null, x.sciana));
    tr.appendChild(el('td', null, x.id));
    tr.appendChild(el('td', null, OPISY[x.skad] || x.skad));
    var td = el('td');
    var pole = el('input', { type: 'text', 'data-wegiel': x.id, title: 'Oś węgła od narożnika lica zewnętrznego (działowa – od początku osi)' });
    pole.value = fmt(x.od);
    if (x.skad === 'srodek') {
      pole.disabled = true;
      pole.title = 'Węgieł z parametru „Węgieł na środku ściany” – przesuń go, dodając węgieł w tabeli węgłów';
    } else {
      pole.addEventListener('change', function () { przesun(x, liczba(this.value)); });
    }
    td.appendChild(pole);
    tr.appendChild(td);
    td = el('td', { 'class': 'przyciski-wiersza' });
    if (x.skad !== 'srodek') {
      td.appendChild(przycisk(x, -1));
      td.appendChild(przycisk(x, 1));
    }
    tr.appendChild(td);
    return tr;
  }

  // Lista węgłów z wyniku podglądu (d.wegly_lista); brak – tabela pusta.
  function pokaz(lista) {
    stan.lista = lista || [];
    var tb = tbody();
    wyczysc(tb);
    var i;
    for (i = 0; i < stan.lista.length; i++) { tb.appendChild(wiersz(stan.lista[i])); }
    $('wegly-przesun-pusto').style.display = stan.lista.length ? 'none' : '';
  }

  return { pokaz: pokaz, przesun: przesun };
}());
