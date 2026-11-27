/*
  ArteMadera – Generator Wieńcowy
  Plik: html/zmiany.js
  Zadanie: pola zmienione względem ustawień fabrycznych – wyróżnienie etykiety, wartość fabryczna w dymku, liczba zmian w nagłówku sekcji.
  Tematy: zmienione względem fabrycznych, wyróżnienie zmienionych pól, wartość fabryczna, liczba zmian w sekcji
  Zależy od: html/wspolne.js (AMGW_DOM)
  Używają: html/okno.js (po zbudowaniu formularza i po zmianie pola)

  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_ZMIANY = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var fmt = AMGW_DOM.fmt;

  // Czy wartość pola różni się od wzorca (liczby – po wartości, reszta – tekst bez spacji i wielkości liter).
  function rozne(opis, wartosc, wzorzec) {
    if (opis.rodzaj === 'tabela') { return AMGW_TABELA.rozne(opis, wartosc, wzorzec); }
    if (opis.rodzaj === 'wybor' || opis.rodzaj === 'przekroj' || opis.rodzaj === 'tekst') {
      var norm = function (v) { return String(v).replace(/\s+/g, '').replace(/[×*]/g, 'x').replace(',', '.').toLowerCase(); };
      return norm(wartosc) !== norm(wzorzec);
    }
    var a = AMGW_DOM.liczba(wartosc);
    return a === null || Math.abs(a - Number(wzorzec)) > 1e-9;
  }

  // Czy wartość pola różni się od fabrycznej.
  function inneNizFabryczne(opis, wartosc) {
    return rozne(opis, wartosc, opis.domyslna);
  }

  // Pola zmienione względem ustawień fabrycznych: wyróżniona etykieta (z wartością fabryczną w dymku) i liczba
  // zmienionych pól w nagłówku sekcji.
  function oznacz(opisy) {
    var ile = {};
    var i;
    for (i = 0; i < opisy.length; i++) {
      var o = opisy[i];
      var pole = $('p-' + o.klucz);
      var lab = $('l-' + o.klucz);
      if (!pole || !lab) { continue; }
      var inne = inneNizFabryczne(o, pole.value);
      lab.className = (lab.className.replace(/\s*zmieniony/g, '') + (inne ? ' zmieniony' : '')).replace(/^\s+/, '');
      lab.title = inne ? 'Zmienione – fabrycznie: ' + opisWartosci(o, o.domyslna) : '';
      if (inne) { ile[o.sekcja] = (ile[o.sekcja] || 0) + 1; }
    }
    var sum = document.querySelectorAll('#sekcje summary');
    for (i = 0; i < sum.length; i++) {
      var klucz = sum[i].parentNode.getAttribute('data-sekcja');
      sum[i].textContent = sum[i].getAttribute('data-tytul') + (ile[klucz] ? ' · zmienione: ' + ile[klucz] : '');
    }
  }

  // Wartość pola do opisu w dymku: wybór – jego tekst, tabela – liczba wierszy, liczba – bez zbędnych zer.
  function opisWartosci(opis, wartosc) {
    if (opis.rodzaj === 'wybor') { return opisWyboru(opis, wartosc); }
    if (opis.rodzaj === 'tabela') { return 'tabela, wierszy: ' + AMGW_TABELA.kanon(opis, wartosc).length; }
    return AMGW_DOM.fmtPola(wartosc);
  }

  // Tekst wyboru (np. „wzdłuż dłuższego boku”) dla wartości pola wyboru.
  function opisWyboru(opis, wartosc) {
    var lista = opis.wybory || [];
    var j;
    for (j = 0; j < lista.length; j++) {
      if (String(lista[j][0]) === String(wartosc)) { return lista[j][1]; }
    }
    return String(wartosc);
  }

  return { oznacz: oznacz, inneNizFabryczne: inneNizFabryczne, rozne: rozne, opisWyboru: opisWyboru, opisWartosci: opisWartosci };
}());
