/*
  ArteMadera – Generator Wieńcowy
  Plik: html/zalezne.js
  Zadanie: pola zależne w oknie – pole pokazuje się tylko przy wybranych wartościach pól nadrzędnych (np. kierunek spadku tylko przy dachu jednospadowym), wybory listy – tylko te, które pasują do innych pól (np. położenie desek a układ dachu), a opcje niedostępne dla obrysu domu są wyszarzone z powodem.
  Tematy: pola zależne, opcje zależne, ukrywanie pól zależnych, wybory zależne od innego pola, pole nadrzędne, opcje niedostępne dla obrysu, opcja wyszarzona z powodem, zamiennik wyboru
  Zależy od: html/wspolne.js (AMGW_DOM)
  Używają: html/tryb.js (widoczność pól), html/okno.js (po zmianie pola)

  Opis pola z Ruby (ParametryLista): gdy – { klucz: [dozwolone wartości] } (wszystkie warunki naraz; pole nadrzędne też
  musi być widoczne), wybory_gdy – { wartość: { klucz: [dozwolone] } } (wybór ukryty, gdy warunek niespełniony; wybrany
  ukryty – przestawiony na swój zamiennik z opisu pola (zamienniki – { wartość: wartość }, np. deski na krokwiach →
  na płatwiach przy samych płatwiach) albo na pierwszy dostępny).
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_ZALEZNE = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var stan = { obrys: '' };

  // Bieżąca wartość pola parametru (brak pola – null).
  function wartosc(klucz) {
    var e = $('p-' + klucz);
    return e ? String(e.value) : null;
  }

  // Czy warunek { klucz: [wartości] } jest spełniony przez bieżące wartości pól.
  function warunek(gdy) {
    var k;
    for (k in gdy) {
      if (Object.prototype.hasOwnProperty.call(gdy, k)) {
        var v = wartosc(k);
        if (v === null || gdy[k].map(String).indexOf(v) < 0) { return false; }
      }
    }
    return true;
  }

  // Czy pole o opisie o ma spełnione warunki (także pola nadrzędne – rekurencyjnie po opisach).
  function spelnione(o, opisy, glebokosc) {
    if (!o || !o.gdy) { return true; }
    if (!warunek(o.gdy)) { return false; }
    if ((glebokosc || 0) > 5) { return true; }
    var k;
    for (k in o.gdy) {
      if (Object.prototype.hasOwnProperty.call(o.gdy, k) && !spelnione(znajdz(opisy, k), opisy, (glebokosc || 0) + 1)) { return false; }
    }
    return true;
  }

  // Opis pola o kluczu k.
  function znajdz(opisy, k) {
    var i;
    for (i = 0; i < opisy.length; i++) { if (opisy[i].klucz === k) { return opisy[i]; } }
    return null;
  }

  // Rodzaj obrysu domu z ostatniego wyniku ('prostokat' | 'l' | 'inny'; '' – jeszcze nieznany): opcje niedostępne dla
  // obrysu są wyszarzone z powodem pod polem.
  function obrys(rodzaj) {
    stan.obrys = rodzaj || '';
  }

  // Powód niedostępnych opcji pod polem (pusty tekst – bez wiersza).
  function powod(sel, o, tekst) {
    var n = $('n-' + o.klucz);
    if (!tekst) {
      if (n) { n.parentNode.removeChild(n); }
      return;
    }
    if (!n) {
      n = document.createElement('div');
      n.id = 'n-' + o.klucz;
      n.className = 'powod';
      sel.parentNode.insertBefore(n, sel.nextSibling);
    }
    n.textContent = tekst;
  }

  // Wybory listy zgodne z innymi polami i z obrysem domu: ukrywa opcje niepasujące do innych pól, wyszarza niedostępne
  // dla obrysu (opis.obrys – { tylko: [rodzaje obrysu], zostaje: [wartości zawsze dostępne], powod: tekst });
  // zwraca true, gdy wybór trzeba było zmienić.
  function wybory(o) {
    var sel = $('p-' + o.klucz);
    if (!sel || (!o.wybory_gdy && !o.obrys) || sel.tagName !== 'SELECT') { return false; }
    var i;
    var zmiana = false;
    var poza = !!o.obrys && !!stan.obrys && o.obrys.tylko.indexOf(stan.obrys) < 0;
    for (i = 0; i < sel.options.length; i++) {
      var op = sel.options[i];
      var g = o.wybory_gdy ? o.wybory_gdy[op.value] : null;
      var ok = !g || warunek(g);
      var niedostepna = poza && o.obrys.zostaje.indexOf(op.value) < 0;
      if (!op.getAttribute('data-tekst')) { op.setAttribute('data-tekst', op.textContent); }
      op.textContent = op.getAttribute('data-tekst') + (niedostepna ? ' – niedostępne dla tego obrysu' : '');
      op.hidden = !ok;
      op.disabled = !ok || niedostepna;
    }
    powod(sel, o, poza ? o.obrys.powod : '');
    if (sel.selectedIndex >= 0 && sel.options[sel.selectedIndex].disabled) {
      var zam = o.zamienniki ? o.zamienniki[sel.options[sel.selectedIndex].value] : null;
      for (i = 0; i < sel.options.length; i++) {
        if (zam && sel.options[i].value === zam && !sel.options[i].disabled) { sel.selectedIndex = i; return true; }
      }
      for (i = 0; i < sel.options.length; i++) {
        if (!sel.options[i].disabled) { sel.selectedIndex = i; zmiana = true; break; }
      }
    }
    return zmiana;
  }

  // Wybory zależne wszystkich pól; true – któryś wybór zmieniony (trzeba przeliczyć podgląd).
  function wszystkieWybory(opisy) {
    var i;
    var zmiana = false;
    for (i = 0; i < opisy.length; i++) { if (wybory(opisy[i])) { zmiana = true; } }
    return zmiana;
  }

  return { spelnione: spelnione, wszystkieWybory: wszystkieWybory, warunek: warunek, obrys: obrys };
})();
