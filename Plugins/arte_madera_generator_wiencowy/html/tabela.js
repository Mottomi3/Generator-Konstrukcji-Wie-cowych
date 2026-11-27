/*
  ArteMadera – Generator Wieńcowy
  Plik: html/tabela.js
  Zadanie: pola-tabele w oknie (lista typowej stolarki, magazyn drewna) – edytor tabeli z dodawaniem i usuwaniem wierszy, wartość jako tekst JSON w ukrytym polu, porównanie tabel bez względu na zapis liczb.
  Tematy: edytor tabeli, pole tabela w oknie, wiersze tabeli w oknie, dodaj wiersz, usuń wiersz, porównanie tabel, tabela jako JSON
  Zależy od: html/wspolne.js (AMGW_DOM), html/sciezka.js (AMGW_SCIEZKA – kolumna 'plik')
  Używają: html/standard.js (tabele w panelu standardu), html/okno.js (ukryte pole tabeli w formularzu domu), html/zmiany.js i html/typy.js (porównanie, wpisanie), html/otwory.js (lista stolarki)

  Opis pola z Ruby (sketchup/okno.rb): rodzaj 'tabela', kolumny [{ klucz, etykieta, rodzaj: 'tekst' | 'liczba' | 'wybor' |
  'znacznik' | 'plik' (tekst z przyciskiem wyboru pliku), wybory }], domyslna – tablica wierszy. W polach formularza wartość tabeli to tekst JSON (Ruby sprawdza ją
  w rdzen/parametry_tabela.rb).
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_TABELA = (function () {
  'use strict';

  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;

  // Tablica wierszy z wartości pola (tablica albo tekst JSON); niepoprawna – pusta tablica.
  function wiersze(v) {
    if (v && typeof v === 'object' && typeof v.length === 'number') { return v; }
    try {
      var x = JSON.parse(String(v || '[]'));
      return x && typeof x.length === 'number' ? x : [];
    } catch (e) {
      return [];
    }
  }

  // Wartość komórki w postaci porównywalnej (liczba – bez zbędnych zer, znacznik – true / false, tekst – bez spacji na końcach).
  function komorka(k, v) {
    if (k.rodzaj === 'liczba') {
      var n = AMGW_DOM.liczba(v);
      return n === null ? null : n;
    }
    if (k.rodzaj === 'znacznik') { return v === true || v === 'tak' || v === 'true' || v === 1 || v === '1'; }
    return String(v === undefined || v === null ? '' : v).replace(/^\s+|\s+$/g, '');
  }

  // Czy wiersz nie ma żadnej wartości (jak w Ruby: wiersz pusty pomijany).
  function pusty(opis, r) {
    var i;
    for (i = 0; i < opis.kolumny.length; i++) {
      var k = opis.kolumny[i];
      var v = r[k.klucz];
      if (k.rodzaj === 'wybor') { continue; }
      if (k.rodzaj === 'liczba' && v !== null) { return false; }
      if (k.rodzaj === 'znacznik' && v) { return false; }
      if ((k.rodzaj === 'tekst' || k.rodzaj === 'plik' || !k.rodzaj) && v !== '') { return false; }
    }
    return true;
  }

  // Tabela w postaci kanonicznej (wiersze z kolumnami opisu, bez pustych) – do porównań i zapisu.
  function kanon(opis, v) {
    var lista = wiersze(v);
    var wynik = [];
    var i;
    var j;
    for (i = 0; i < lista.length; i++) {
      var r = {};
      for (j = 0; j < opis.kolumny.length; j++) {
        var k = opis.kolumny[j];
        r[k.klucz] = komorka(k, lista[i] ? lista[i][k.klucz] : undefined);
      }
      if (!pusty(opis, r)) { wynik.push(r); }
    }
    return wynik;
  }

  // Czy dwie wartości tabeli są różne.
  function rozne(opis, a, b) {
    return JSON.stringify(kanon(opis, a)) !== JSON.stringify(kanon(opis, b));
  }

  // Tekst JSON tabeli do ukrytego pola.
  function tekst(opis, v) { return JSON.stringify(kanon(opis, v)); }

  // Komórka edytora: pole tekstowe (kolumna 'plik' – z przyciskiem wyboru pliku), lista wyboru albo znacznik; zmiana – naZmiane.
  function poleKomorki(k, v, naZmiane) {
    var p;
    var j;
    if (k.rodzaj === 'wybor') {
      p = el('select', { 'data-kol': k.klucz });
      for (j = 0; j < (k.wybory || []).length; j++) {
        var o = el('option', { value: k.wybory[j][0] }, k.wybory[j][1]);
        if (String(k.wybory[j][0]) === String(v)) { o.selected = true; }
        p.appendChild(o);
      }
    } else if (k.rodzaj === 'znacznik') {
      p = el('input', { type: 'checkbox', 'data-kol': k.klucz });
      p.checked = komorka(k, v);
    } else {
      p = el('input', { type: 'text', 'data-kol': k.klucz });
      if (k.rodzaj === 'liczba') { p.setAttribute('inputmode', 'decimal'); }
      p.value = v === undefined || v === null ? '' : (k.rodzaj === 'liczba' ? AMGW_DOM.fmtPola(v) : String(v));
    }
    p.addEventListener('change', naZmiane);
    return k.rodzaj === 'plik' ? AMGW_SCIEZKA.opakuj(p, 'plik') : p;
  }

  // Wiersze z edytora (tabela HTML) w postaci kanonicznej.
  function zEdytora(opis, tab) {
    var tr = tab.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
    var lista = [];
    var i;
    var j;
    for (i = 0; i < tr.length; i++) {
      var r = {};
      var pola = tr[i].querySelectorAll('[data-kol]');
      for (j = 0; j < pola.length; j++) {
        r[pola[j].getAttribute('data-kol')] = pola[j].type === 'checkbox' ? pola[j].checked : pola[j].value;
      }
      lista.push(r);
    }
    return kanon(opis, lista);
  }

  // Edytor tabeli w kontenerze box: tabela z wierszami wartości, przycisk „+ wiersz”, × przy wierszu; ukryte pole
  // (zwracane) trzyma tekst JSON i jest aktualizowane po każdej zmianie (potem naZmiane, gdy podane).
  function edytor(box, opis, wartosc, naZmiane) {
    var ukryte = el('input', { type: 'hidden' });
    var tab = el('table', { 'class': 'tabela tabela-pola', id: 't-' + opis.klucz });
    var thead = el('thead');
    var tr = el('tr');
    var i;
    for (i = 0; i < opis.kolumny.length; i++) { tr.appendChild(el('th', null, opis.kolumny[i].etykieta)); }
    tr.appendChild(el('th'));
    thead.appendChild(tr);
    tab.appendChild(thead);
    var tbody = el('tbody');
    tab.appendChild(tbody);
    var zmiana = function () {
      ukryte.value = JSON.stringify(zEdytora(opis, tab));
      if (naZmiane) { naZmiane(); }
    };
    var dodajWiersz = function (r) {
      var w = el('tr');
      var j;
      for (j = 0; j < opis.kolumny.length; j++) {
        var td = el('td');
        td.appendChild(poleKomorki(opis.kolumny[j], r[opis.kolumny[j].klucz], zmiana));
        w.appendChild(td);
      }
      var tdu = el('td');
      var usun = el('button', { type: 'button', title: 'Usuń wiersz' }, '×');
      usun.addEventListener('click', function () { tbody.removeChild(w); zmiana(); });
      tdu.appendChild(usun);
      w.appendChild(tdu);
      tbody.appendChild(w);
    };
    var lista = kanon(opis, wartosc);
    for (i = 0; i < lista.length; i++) { dodajWiersz(lista[i]); }
    ukryte.value = JSON.stringify(lista);
    var plus = el('button', { type: 'button', 'class': 'dodaj-wiersz', id: 'tw-' + opis.klucz }, '+ wiersz');
    plus.addEventListener('click', function () { dodajWiersz({}); });
    var opak = el('div', { 'class': 'tabela-przewijana' });
    opak.appendChild(tab);
    wyczysc(box);
    box.appendChild(opak);
    box.appendChild(plus);
    box.appendChild(ukryte);
    return ukryte;
  }

  return { wiersze: wiersze, kanon: kanon, rozne: rozne, tekst: tekst, edytor: edytor };
}());
