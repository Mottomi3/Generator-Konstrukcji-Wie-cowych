/*
  ArteMadera – Generator Wieńcowy
  Plik: html/wyniki.js
  Zadanie: wyniki w oknie – liczby, wysokości, błędy, ostrzeżenia, podpowiedzi, tabela ścian ze stykami, lista bali i belek, rzut.
  Tematy: wyniki w oknie, podpowiedzi podłogi, tabela ścian, lista bali, liczby wyniku, wysokości ścian
  Zależy od: html/wspolne.js (AMGW_DOM), html/rzut.js (AMGW_RZUT)
  Używają: html/okno.js (pokazWynik)

  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_WYNIKI = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;
  var fmt = AMGW_DOM.fmt;

  // Lista błędów lub ostrzeżeń.
  function lista(idBox, pozycje, klasa) {
    var box = $(idBox);
    var i;
    wyczysc(box);
    if (!pozycje || pozycje.length === 0) { return; }
    var ul = el('ul', { 'class': klasa });
    for (i = 0; i < pozycje.length; i++) { ul.appendChild(el('li', null, pozycje[i])); }
    box.appendChild(ul);
  }

  // Wiersz tabeli wyników.
  function wiersz(tbody, komorki, liczbowe) {
    var tr = el('tr');
    var i;
    for (i = 0; i < komorki.length; i++) {
      var td = el('td', null, komorki[i]);
      if (liczbowe && liczbowe[i]) { td.className = 'liczba'; }
      tr.appendChild(td);
    }
    tbody.appendChild(tr);
  }

  // Podpowiedzi (podłoga, dobór przekrojów) z poziomem ok / uwaga / blad.
  function podpowiedzi(pozycje) {
    var box = $('lista-podpowiedzi');
    var i;
    wyczysc(box);
    if (!pozycje || pozycje.length === 0) { return; }
    box.appendChild(el('h3', null, 'Podpowiedzi'));
    var ul = el('ul', { 'class': 'lista-podp' });
    for (i = 0; i < pozycje.length; i++) { ul.appendChild(el('li', { 'class': pozycje[i].poziom }, pozycje[i].tekst)); }
    box.appendChild(ul);
  }

  // Wyniki: liczby, wysokości, tabela ścian, lista bali, rzut, błędy, ostrzeżenia i podpowiedzi; naKlik(id) – kliknięta
  // ściana na rzucie.
  function pokaz(d, naKlik) {
    var i;
    lista('lista-bledow', d.bledy, 'lista-blad');
    lista('lista-ostrzezen', d.ostrzezenia, 'lista-uwaga');
    podpowiedzi(d.podpowiedzi);
    AMGW_RZUT.rysuj($('rzut'), d.rzut, naKlik);
    var liczby = $('liczby');
    wyczysc(liczby);
    var tbS = $('tab-sciany').getElementsByTagName('tbody')[0];
    var tbL = $('tab-lista').getElementsByTagName('tbody')[0];
    wyczysc(tbS);
    wyczysc(tbL);
    if ($('wysokosci')) { $('wysokosci').textContent = ''; }
    if (!d.sciany) { return; }
    var n = d.liczby;
    var wpisy = [['Bale', n.bale], ['Pozycje', n.pozycje], ['Objętość bali', Number(n.objetosc_m3).toFixed(2) + ' m³'],
                 ['Waga bali', n.waga_kg + ' kg'], ['Zamki (pary bali)', n.pary_zamkow], ['Węgły pod styki', n.kontrfory_nowe],
                 ['Węgły usztywniające', n.wegly_usztywniajace], ['Limit światła', n.limit_swiatla + ' mm'],
                 ['Szczyty', n.szczyty], ['Belki podłogi i dachu', n.belki],
                 ['Objętość belek', Number(n.objetosc_belek_m3 || 0).toFixed(2) + ' m³']];
    for (i = 0; i < wpisy.length; i++) {
      var sp = el('span', null, wpisy[i][0] + ': ');
      sp.appendChild(el('b', null, wpisy[i][1]));
      liczby.appendChild(sp);
    }
    if (d.wysokosci && $('wysokosci')) {
      $('wysokosci').textContent = 'Wysokość: ściany okapowe ' + fmt(d.wysokosci.okapowa) + ' mm, szczytowe ' +
        fmt(d.wysokosci.szczytowa) + ' mm (z pierwszym balem szczytu), działowe ' + fmt(d.wysokosci.dzialowa_szczytowa) +
        '–' + fmt(d.wysokosci.dzialowa_okapowa) + ' mm.';
    }
    for (i = 0; i < d.sciany.length; i++) {
      var w = d.sciany[i];
      var styki = w.styki && w.styki.length === 2 ? w.styki[0].join(', ') + ' / ' + w.styki[1].join(', ') : '';
      wiersz(tbS, [w.id, w.rodzaj, w.dlugosc, fmt(w.wysokosc), w.wience, w.bale, styki],
             [false, false, true, true, true, true, false]);
    }
    for (i = 0; i < d.lista.length; i++) {
      var l = d.lista[i];
      wiersz(tbL, [l.prefiks, l.nazwa, l.przekroj, l.dl, l.ilosc, Number(l.objetosc_m3).toFixed(3)], [false, false, false, true, true, true]);
    }
  }

  return { pokaz: pokaz };
}());
