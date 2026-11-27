/*
  ArteMadera – Generator Wieńcowy
  Plik: html/wycena.js
  Zadanie: wycena materiału w oknie (W3) – tabela pozycji z ilością, ceną i wartością, suma, lista pozycji bez ceny z odesłaniem do standardu warsztatu.
  Tematy: wycena w oknie, koszt materiału w oknie, pozycje bez ceny, suma wyceny
  Zależy od: html/wspolne.js (AMGW_DOM), dane wyniku z Ruby (rdzen/wycena.rb przez sketchup/sterowanie.rb – klucz wycena)
  Używają: html/wyniki.js (po każdym podglądzie)

  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_WYCENA = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;

  // Kwota w złotych z dwoma miejscami i spacjami tysięcy.
  function zl(v) {
    var t = Number(v || 0).toFixed(2).replace('.', ',');
    return t.replace(/\B(?=(\d{3})+(?!\d))/g, ' ') + ' zł';
  }

  // Suma wyceny do liczb wyniku (null – żadnej ceny).
  function suma(w) {
    if (!w || !w.wiersze) { return null; }
    var i;
    for (i = 0; i < w.wiersze.length; i++) { if (w.wiersze[i].cena) { return zl(w.suma) + (w.kompletna ? '' : ' (bez części cen)'); } }
    return null;
  }

  // Tabela wyceny w karcie zestawienia; bez żadnej ceny – jedno zdanie, gdzie je wpisać.
  function pokaz(w) {
    var box = $('wycena');
    if (!box) { return; }
    wyczysc(box);
    if (!w || !w.wiersze || !w.wiersze.length) { return; }
    if (suma(w) === null) {
      box.appendChild(el('p', { 'class': 'drobny' }, 'Ceny wpisuje się w Standardzie warsztatu: sekcja „Magazyn drewna, dobór przekrojów i ceny” ' +
        '(cena bala, ceny w magazynie drewna, cennik materiałów).'));
      return;
    }
    var tab = el('table', { 'class': 'tabela', id: 'tab-wycena' });
    var th = el('tr');
    var nagl = ['Grupa', 'Pozycja', 'Ilość', 'Jedn.', 'Cena', 'Wartość'];
    var i;
    for (i = 0; i < nagl.length; i++) { th.appendChild(el('th', null, nagl[i])); }
    var thead = el('thead');
    thead.appendChild(th);
    tab.appendChild(thead);
    var tb = el('tbody');
    for (i = 0; i < w.wiersze.length; i++) {
      var x = w.wiersze[i];
      var tr = el('tr', x.wartosc === null || x.wartosc === undefined ? { 'class': 'bez-ceny' } : null);
      tr.appendChild(el('td', null, x.grupa));
      tr.appendChild(el('td', null, x.nazwa));
      tr.appendChild(el('td', { 'class': 'liczba' }, String(x.ilosc).replace('.', ',')));
      tr.appendChild(el('td', null, x.jednostka));
      tr.appendChild(el('td', { 'class': 'liczba' }, x.cena ? zl(x.cena) : 'brak ceny'));
      tr.appendChild(el('td', { 'class': 'liczba' }, x.wartosc !== null && x.wartosc !== undefined ? zl(x.wartosc) : ''));
      tb.appendChild(tr);
    }
    var tr2 = el('tr', { 'class': 'suma' });
    tr2.appendChild(el('td', { colspan: '5' }, w.kompletna ? 'Razem' : 'Razem – bez ' + w.bez_ceny.length + ' pozycji bez ceny'));
    tr2.appendChild(el('td', { 'class': 'liczba' }, zl(w.suma)));
    tb.appendChild(tr2);
    tab.appendChild(tb);
    box.appendChild(tab);
    box.appendChild(el('p', { 'class': 'drobny' }, 'Materiał bez robocizny i transportu – podpowiedź do oferty. Ceny: Standard warsztatu → ' +
      '„Magazyn drewna, dobór przekrojów i ceny”.'));
  }

  return { pokaz: pokaz, suma: suma };
}());
