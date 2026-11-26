/*
  ArteMadera – Generator Wieńcowy
  Plik: html/uwagi.js
  Zadanie: lista „Do poprawy / Sprawdzone” w prawej kolumnie okna – błędy, ostrzeżenia i podpowiedzi w jednym miejscu, z nazwą kroku; kliknięcie uwagi przenosi do pola, sekcji albo kroku.
  Tematy: lista uwag, do poprawy, sprawdzone, kliknięcie uwagi, przejście z uwagi do pola, uwagi w prawej kolumnie
  Zależy od: html/wspolne.js (AMGW_DOM), html/kroki.js (przejście do pola, znaczniki kroków)
  Używają: html/okno.js (wynik podglądu)

  Uwagi z Ruby (rdzen/uwagi_pola.rb): [{ tekst, poziom: 'blad' | 'ostrzezenie' | 'uwaga' | 'ok', klucz, sekcja, krok, krok_tytul }].
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_UWAGI = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;
  var KOLEJNOSC = { blad: 0, ostrzezenie: 1, uwaga: 2, ok: 3 };

  // Jedna pozycja listy: tekst, nazwa kroku i kliknięcie (gdy uwaga ma pole, sekcję albo krok).
  function pozycja(u) {
    var li = el('li', { 'class': u.poziom + (u.klucz || u.sekcja || u.krok ? ' klik' : '') });
    if (u.krok_tytul) { li.appendChild(el('span', { 'class': 'gdzie' }, u.krok_tytul)); }
    li.appendChild(document.createTextNode(u.tekst));
    if (u.klucz || u.sekcja || u.krok) {
      li.title = 'Kliknij, żeby przejść do ' + (u.klucz ? 'pola' : 'kroku „' + (u.krok_tytul || '') + '”');
      li.addEventListener('click', function () { AMGW_KROKI.idzDo(u.klucz, u.sekcja, u.krok); });
    }
    return li;
  }

  // Lista uwag: „Do poprawy” (błędy, ostrzeżenia, uwagi – w tej kolejności) i zwinięte „Sprawdzone”; znaczniki kroków.
  function pokaz(uwagi) {
    var box = $('uwagi');
    var lista = (uwagi || []).slice();
    var zle = [];
    var dobre = [];
    var i;
    wyczysc(box);
    lista.sort(function (a, b) { return (KOLEJNOSC[a.poziom] || 0) - (KOLEJNOSC[b.poziom] || 0); });
    for (i = 0; i < lista.length; i++) { (lista[i].poziom === 'ok' ? dobre : zle).push(lista[i]); }
    if (zle.length) {
      box.appendChild(el('div', { 'class': 'uwagi-naglowek', id: 'uwagi-zle-tytul' }, 'Do poprawy (' + zle.length + ')'));
      var ul = el('ul', { 'class': 'uwagi-lista', id: 'uwagi-zle' });
      for (i = 0; i < zle.length; i++) { ul.appendChild(pozycja(zle[i])); }
      box.appendChild(ul);
    } else if (uwagi) {
      box.appendChild(el('div', { 'class': 'uwagi-czysto', id: 'uwagi-czysto' }, 'Nic do poprawy.'));
    }
    if (dobre.length) {
      var det = el('details', { id: 'uwagi-dobre-box' });
      det.appendChild(el('summary', null, 'Sprawdzone (' + dobre.length + ')'));
      var ul2 = el('ul', { 'class': 'uwagi-lista', id: 'uwagi-dobre' });
      for (i = 0; i < dobre.length; i++) { ul2.appendChild(pozycja(dobre[i])); }
      det.appendChild(ul2);
      box.appendChild(det);
    }
    AMGW_KROKI.znaczniki(uwagi || []);
  }

  return { pokaz: pokaz };
}());
