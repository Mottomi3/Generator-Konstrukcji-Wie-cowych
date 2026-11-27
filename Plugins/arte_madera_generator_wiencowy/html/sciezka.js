/*
  ArteMadera – Generator Wieńcowy
  Plik: html/sciezka.js
  Zadanie: pola ze ścieżką pliku albo folderu (folder modeli stolarki, kolumna „Model” listy stolarki) – przycisk „…” obok pola otwiera okno wyboru w SketchUpie, wybrana ścieżka wraca do pola.
  Tematy: wybór ścieżki, wybór folderu, wybór pliku modelu, przycisk wybierz, ścieżka modelu stolarki w oknie
  Zależy od: html/wspolne.js (AMGW_DOM)
  Używają: html/tabela.js (kolumna rodzaju 'plik'), html/standard.js i html/okno.js (pole z cechą sciezka), sketchup/okno_sciezki.rb (AMGW_SCIEZKA.wybrana)

  Wywołanie Ruby: wybierz_sciezke(JSON { id, rodzaj: 'folder' | 'plik', poczatek }) – Ruby odpowiada
  AMGW_SCIEZKA.wybrana({ id, sciezka }) (sciezka pusta – anulowano). Poza SketchUpem przycisk nic nie robi; ścieżkę
  można zawsze wpisać ręcznie.
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_SCIEZKA = (function () {
  'use strict';

  var el = AMGW_DOM.el;
  var licznik = 0;

  // Pole p (input) w opakowaniu z przyciskiem „…” wyboru ścieżki rodzaju 'folder' albo 'plik'; zwraca opakowanie.
  function opakuj(p, rodzaj) {
    if (!p.id) { licznik += 1; p.id = 'sciezka-' + licznik; }
    var box = el('span', { 'class': 'sciezka' });
    var b = el('button', { type: 'button', 'class': 'sciezka-wybierz',
                           title: rodzaj === 'folder' ? 'Wybierz folder' : 'Wybierz plik .skp' }, '…');
    b.addEventListener('click', function () {
      if (window.sketchup && typeof window.sketchup.wybierz_sciezke === 'function') {
        window.sketchup.wybierz_sciezke(JSON.stringify({ id: p.id, rodzaj: rodzaj, poczatek: p.value }));
      }
    });
    box.appendChild(p);
    box.appendChild(b);
    return box;
  }

  // Odpowiedź Ruby: wpisanie wybranej ścieżki do pola i zdarzenie „change” (jak po wpisaniu ręcznym).
  function wybrana(d) {
    var p = d && d.id ? document.getElementById(d.id) : null;
    if (!p || !d.sciezka) { return; }
    p.value = d.sciezka;
    var e = document.createEvent('HTMLEvents');
    e.initEvent('change', true, false);
    p.dispatchEvent(e);
  }

  return { opakuj: opakuj, wybrana: wybrana };
}());
