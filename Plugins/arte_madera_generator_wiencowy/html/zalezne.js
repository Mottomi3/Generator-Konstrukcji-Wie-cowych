/*
  ArteMadera – Generator Wieńcowy
  Plik: html/zalezne.js
  Zadanie: pola zależne w oknie – pole pokazuje się tylko przy wybranych wartościach pól nadrzędnych (np. kierunek spadku tylko przy dachu jednospadowym), a wybory listy – tylko te, które pasują do innych pól (np. podbitka a układ dachu).
  Tematy: pola zależne, opcje zależne, ukrywanie pól zależnych, wybory zależne od innego pola, pole nadrzędne
  Zależy od: html/wspolne.js (AMGW_DOM)
  Używają: html/tryb.js (widoczność pól), html/okno.js (po zmianie pola)

  Opis pola z Ruby (ParametryLista): gdy – { klucz: [dozwolone wartości] } (wszystkie warunki naraz; pole nadrzędne też
  musi być widoczne), wybory_gdy – { wartość: { klucz: [dozwolone] } } (wybór ukryty, gdy warunek niespełniony; wybrany
  ukryty – przestawiony na pierwszy dostępny).
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_ZALEZNE = (function () {
  'use strict';

  var $ = AMGW_DOM.$;

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

  // Wybory listy zgodne z innymi polami: ukrywa niepasujące opcje; zwraca true, gdy wybór trzeba było zmienić.
  function wybory(o) {
    var sel = $('p-' + o.klucz);
    if (!sel || !o.wybory_gdy || sel.tagName !== 'SELECT') { return false; }
    var i;
    var zmiana = false;
    for (i = 0; i < sel.options.length; i++) {
      var g = o.wybory_gdy[sel.options[i].value];
      var ok = !g || warunek(g);
      sel.options[i].hidden = !ok;
      sel.options[i].disabled = !ok;
    }
    if (sel.selectedIndex >= 0 && sel.options[sel.selectedIndex].disabled) {
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

  return { spelnione: spelnione, wszystkieWybory: wszystkieWybory, warunek: warunek };
})();
