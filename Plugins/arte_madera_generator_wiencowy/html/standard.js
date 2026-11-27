/*
  ArteMadera – Generator Wieńcowy
  Plik: html/standard.js
  Zadanie: panel „Standard warsztatu” – pola poziomu standard pogrupowane sekcjami z wymiarami zamka, wyszukiwanie pola, zapis standardu i powrót do wartości fabrycznych.
  Tematy: standard warsztatu w oknie, panel standardu, pola standardu, szukanie pola standardu, zapisz standard, przywróć fabryczne, wymiary zamka w standardzie, standard warsztatu z menu – okno bez domu
  Zależy od: html/wspolne.js (AMGW_DOM), html/zmiany.js (porównanie z fabrycznymi), html/typy.js (baza – bieżący standard)
  Używają: html/okno.js (przycisk „Standard warsztatu…”, odpowiedź Ruby, okno otwarte z menu „Standard warsztatu…” – tryb 'standard')

  Panel ma własne pola (identyfikatory s-<klucz>, wymiary zamka sz-<klucz>) – pola okna głównego to wartości tego domu.
  Zapis: wywołanie Ruby standard_zapisz ({ typ, parametry }) – sketchup/okno_typy.rb; po zapisie pola standardu, których
  w tym domu nie zmieniono, dostają nowe wartości (html/typy.js).
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_STANDARD = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;
  var fmt = AMGW_DOM.fmtPola;
  var stan = { opisy: [], sekcje: [], opisyZamka: [], wywolaj: null, samodzielny: false };

  // Pole panelu dla opisu o z wartością v (lista wyboru albo pole tekstowe) i etykieta wyróżniona, gdy inne niż fabryczne.
  function pole(box, o, v) {
    var lab = el('label', { 'for': 's-' + o.klucz, id: 'sl-' + o.klucz, title: o.podpowiedz || '' }, o.etykieta);
    if (o.jednostka) { lab.appendChild(el('span', { 'class': 'jedn' }, '[' + o.jednostka + ']')); }
    var p;
    var j;
    if (o.rodzaj === 'wybor') {
      p = el('select', { id: 's-' + o.klucz, 'data-standard': o.klucz });
      for (j = 0; j < (o.wybory || []).length; j++) {
        var op = el('option', { value: o.wybory[j][0] }, o.wybory[j][1]);
        if (String(o.wybory[j][0]) === String(v)) { op.selected = true; }
        p.appendChild(op);
      }
    } else {
      p = el('input', { id: 's-' + o.klucz, 'data-standard': o.klucz, type: 'text' });
      p.value = o.rodzaj === 'przekroj' || o.rodzaj === 'tekst' ? String(v) : fmt(v);
    }
    p.title = o.podpowiedz || '';
    p.addEventListener('change', function () { wyroznij(o); });
    box.appendChild(lab);
    box.appendChild(p);
    wyroznij(o);
  }

  // Etykieta pola panelu wyróżniona, gdy wartość inna niż fabryczna.
  function wyroznij(o) {
    var lab = $('sl-' + o.klucz);
    var p = $('s-' + o.klucz);
    if (!lab || !p) { return; }
    var inne = AMGW_ZMIANY.inneNizFabryczne(o, p.value);
    lab.className = inne ? 'zmieniony' : '';
  }

  // Zawartość panelu: sekcje z polami poziomu standard (wartości z bazy) i wymiary zamka.
  function zbuduj(baza) {
    var box = $('standard-pola');
    var i;
    var j;
    wyczysc(box);
    for (i = 0; i < stan.sekcje.length; i++) {
      var s = stan.sekcje[i];
      var pola = [];
      for (j = 0; j < stan.opisy.length; j++) {
        if (stan.opisy[j].sekcja === s.klucz && stan.opisy[j].poziom === 'standard') { pola.push(stan.opisy[j]); }
      }
      if (!pola.length && s.klucz !== 'przekroj') { continue; }
      var grupa = el('div', { 'class': 'standard-grupa', 'data-sekcja': s.klucz });
      grupa.appendChild(el('h3', null, s.tytul));
      var siatka = el('div', { 'class': 'pola' });
      for (j = 0; j < pola.length; j++) {
        pole(siatka, pola[j], baza[pola[j].klucz] !== undefined && baza[pola[j].klucz] !== null ? baza[pola[j].klucz] : pola[j].domyslna);
      }
      if (s.klucz === 'przekroj') { zamek(siatka, baza.zamek || {}); }
      grupa.appendChild(siatka);
      box.appendChild(grupa);
    }
  }

  // Pola wymiarów zamka w panelu.
  function zamek(box, wymiary) {
    var i;
    for (i = 0; i < stan.opisyZamka.length; i++) {
      var o = stan.opisyZamka[i];
      var lab = el('label', { 'for': 'sz-' + o[0] }, 'Zamek – ' + o[1]);
      lab.appendChild(el('span', { 'class': 'jedn' }, '[' + o[2] + ']'));
      var inp = el('input', { id: 'sz-' + o[0], 'data-standard-zamek': o[0], type: 'text', inputmode: 'decimal' });
      inp.value = wymiary[o[0]] !== undefined ? fmt(wymiary[o[0]]) : '';
      box.appendChild(lab);
      box.appendChild(inp);
    }
  }

  // Wartości z panelu: { klucz: wartość, zamek: { … } }.
  function zbierz() {
    var p = {};
    var z = {};
    var pola = document.querySelectorAll('[data-standard]');
    var i;
    for (i = 0; i < pola.length; i++) { p[pola[i].getAttribute('data-standard')] = pola[i].value; }
    pola = document.querySelectorAll('[data-standard-zamek]');
    for (i = 0; i < pola.length; i++) { if (pola[i].value !== '') { z[pola[i].getAttribute('data-standard-zamek')] = pola[i].value; } }
    p.zamek = z;
    return p;
  }

  // Filtr pól panelu po tekście etykiety (puste – wszystkie); grupy bez pasujących pól schowane.
  function szukaj(tekst) {
    var t = String(tekst || '').toLowerCase();
    var grupy = document.querySelectorAll('#standard-pola .standard-grupa');
    var i;
    var j;
    for (i = 0; i < grupy.length; i++) {
      var etykiety = grupy[i].getElementsByTagName('label');
      var widoczne = 0;
      for (j = 0; j < etykiety.length; j++) {
        var pasuje = !t || etykiety[j].textContent.toLowerCase().indexOf(t) >= 0;
        etykiety[j].style.display = pasuje ? '' : 'none';
        var p = $(etykiety[j].getAttribute('for'));
        if (p) { p.style.display = pasuje ? '' : 'none'; }
        if (pasuje) { widoczne++; }
      }
      grupy[i].style.display = widoczne ? '' : 'none';
    }
  }

  // Otwarcie panelu z bieżącym standardem (baza z html/typy.js).
  function otworz() {
    zbuduj(AMGW_TYPY.baza());
    $('standard-szukaj').value = '';
    $('standard-komunikat').textContent = '';
    $('standard').className = 'panel-standard';
  }

  // Zamknięcie panelu; okno otwarte z menu „Standard warsztatu” (bez domu) – zamknięcie całego okna.
  function zamknij() {
    if (stan.samodzielny) { stan.wywolaj('zamknij'); return; }
    $('standard').className = 'panel-standard ukryty';
  }

  // Okno otwarte z menu „Standard warsztatu…” – sam panel standardu na całe okno, bez domu i bez podglądu.
  function samodzielnie() {
    stan.samodzielny = true;
    document.body.className += ' tylko-standard';
    otworz();
  }

  // Czy okno pokazuje sam standard (otwarte z menu, bez domu).
  function samodzielny() { return stan.samodzielny; }

  // Po zapisie standardu albo powrocie do fabrycznych w oknie bez domu: pola panelu z nowego standardu.
  function poZapisie() { zbuduj(AMGW_TYPY.baza()); szukaj($('standard-szukaj').value); }

  // Czy panel jest otwarty.
  function otwarty() { return $('standard').className.indexOf('ukryty') < 0; }

  // Start: opisy pól, sekcje, opisy wymiarów zamka i wywołanie Ruby; podpięcie przycisków panelu.
  function init(opisy, sekcje, opisyZamka, wywolaj) {
    stan.opisy = opisy || [];
    stan.sekcje = sekcje || [];
    stan.opisyZamka = opisyZamka || [];
    stan.wywolaj = wywolaj;
    $('btn-standard').onclick = otworz;
    $('btn-standard-zamknij').onclick = zamknij;
    $('btn-standard-zapisz').onclick = function () {
      wywolaj('standard_zapisz', JSON.stringify({ typ: AMGW_TYPY.typ(), parametry: zbierz() }));
    };
    $('btn-standard-fabryczne').onclick = function () { wywolaj('standard_fabryczne', AMGW_TYPY.typ()); };
    $('standard-szukaj').oninput = function () { szukaj(this.value); };
  }

  return { init: init, otworz: otworz, zamknij: zamknij, otwarty: otwarty, zbierz: zbierz, szukaj: szukaj,
           samodzielnie: samodzielnie, samodzielny: samodzielny, poZapisie: poZapisie };
}());
