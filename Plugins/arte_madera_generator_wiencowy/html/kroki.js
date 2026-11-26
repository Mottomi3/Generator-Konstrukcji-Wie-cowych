/*
  ArteMadera – Generator Wieńcowy
  Plik: html/kroki.js
  Zadanie: nowy układ okna – kroki w kolejności budowy ze znacznikiem stanu, widoczność pól według poziomu (ten dom zawsze, pola typu po rozwinięciu, pola standardu tylko zmienione w tym domu albo wybrane do zmiany), karty kroku, przejście do pola z listy uwag.
  Tematy: kroki okna, pasek kroków, znacznik stanu kroku, widoczność pól według poziomu, pola typu w kroku, zmień pole standardu tylko w tym domu, karty kroku, przejście do pola, pole przypięte
  Zależy od: html/wspolne.js (AMGW_DOM), html/zalezne.js (pola zależne), html/typy.js (pola zmienione w domu)
  Używają: html/uklad.js (odświeżenie układu), html/uwagi.js (kliknięcie uwagi), html/okno.js (start, wynik)

  Kroki z Ruby (rdzen/poziomy.rb): [{ klucz, tytul, sekcje: [klucze sekcji] }]; pole ma opis.poziom ('dom' | 'typ' |
  'standard') i opis.krok. Karty okna z atrybutem data-krok (lista kroków po spacji) pokazują się pod polami swojego kroku.
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_KROKI = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;
  var stan = { kroki: [], krok: '', opisy: [], typOtwarty: {}, przypiete: {}, uwagi: [] };

  // Pokazanie albo ukrycie elementu (pusty display – wartość z arkusza stylów).
  function pokaz(e, widoczny) {
    if (e) { e.style.display = widoczny ? '' : 'none'; }
  }

  // Krok po kluczu (null – nie ma).
  function znajdz(klucz) {
    var i;
    for (i = 0; i < stan.kroki.length; i++) { if (stan.kroki[i].klucz === klucz) { return stan.kroki[i]; } }
    return null;
  }

  // Pasek kroków: przycisk na każdy krok z miejscem na znacznik stanu.
  function zbuduj(kroki) {
    var pasek = $('kroki');
    var i;
    stan.kroki = kroki || [];
    wyczysc(pasek);
    for (i = 0; i < stan.kroki.length; i++) {
      var k = stan.kroki[i];
      var b = el('button', { type: 'button', id: 'krok-' + k.klucz, 'data-krok': k.klucz }, (i + 1) + '. ' + k.tytul);
      b.appendChild(el('span', { 'class': 'stan', id: 'krok-stan-' + k.klucz }));
      b.addEventListener('click', (function (klucz) { return function () { wybierz(klucz); }; }(k.klucz)));
      pasek.appendChild(b);
    }
    if (!znajdz(stan.krok) && stan.kroki.length) { stan.krok = stan.kroki[0].klucz; }
  }

  // Czy pole jest widoczne w bieżącym kroku: warunki pól zależnych, krok, poziom (ten dom – zawsze; typ – po rozwinięciu,
  // zmienione albo przypięte; standard – zmienione w tym domu albo przypięte).
  function widoczne(o) {
    if (o.krok !== stan.krok || !AMGW_ZALEZNE.spelnione(o, stan.opisy)) { return false; }
    if (o.poziom === 'dom') { return true; }
    if (stan.przypiete[o.klucz] || AMGW_TYPY.zmienione(o)) { return true; }
    return o.poziom === 'typ' && !!stan.typOtwarty[stan.krok];
  }

  // Widoczność pól, sekcji i kart według kroku i poziomów; pasek z liczbą pól typu i wyborem pola standardu.
  function zastosuj(opisy) {
    var widoczneWSekcji = {};
    var typ = 0;
    var ukryteStandardu = [];
    var i;
    stan.opisy = opisy || stan.opisy;
    for (i = 0; i < stan.opisy.length; i++) {
      var o = stan.opisy[i];
      var w = widoczne(o);
      pokaz($('l-' + o.klucz), w);
      pokaz($('p-' + o.klucz), w);
      if (!w) { pokaz($('m-' + o.klucz), false); }
      pokaz($('n-' + o.klucz), w);
      var h = $('h-' + o.klucz);
      if (h) { h.style.display = w ? '' : 'none'; }
      if (w) { widoczneWSekcji[o.sekcja] = true; }
      if (o.krok === stan.krok && AMGW_ZALEZNE.spelnione(o, stan.opisy)) {
        if (o.poziom === 'typ') { typ++; }
        if (o.poziom === 'standard' && !w) { ukryteStandardu.push(o); }
      }
    }
    var zamek = stan.krok === (znajdzKrokSekcji('przekroj') || '') && (stan.przypiete.zamek || AMGW_TYPY.zamekZmieniony());
    pokaz($('pola-zamek'), zamek);
    if (zamek) { widoczneWSekcji.przekroj = true; }
    var sekcje = document.querySelectorAll('#sekcje details');
    for (i = 0; i < sekcje.length; i++) {
      var ws = !!widoczneWSekcji[sekcje[i].getAttribute('data-sekcja')];
      pokaz(sekcje[i], ws);
      if (ws) { sekcje[i].open = true; }
    }
    pasekPoziomow(typ, ukryteStandardu, zamek);
    karty();
    przyciski();
  }

  // Krok, do którego należy sekcja parametrów.
  function znajdzKrokSekcji(sekcja) {
    var i;
    for (i = 0; i < stan.kroki.length; i++) { if ((stan.kroki[i].sekcje || []).indexOf(sekcja) >= 0) { return stan.kroki[i].klucz; } }
    return null;
  }

  // Pasek nad polami kroku: przycisk „pola typu domu” (rozwiń / zwiń) i lista pól standardu do zmiany tylko w tym domu.
  function pasekPoziomow(typ, ukryte, zamekWidoczny) {
    var box = $('krok-poziomy');
    var i;
    wyczysc(box);
    if (typ > 0) {
      var otwarty = !!stan.typOtwarty[stan.krok];
      var b = el('button', { type: 'button', id: 'btn-pola-typu' }, (otwarty ? '▾ Ukryj pola typu domu' : '▸ Pola typu domu w tym kroku') + ' (' + typ + ')');
      b.addEventListener('click', function () {
        stan.typOtwarty[stan.krok] = !stan.typOtwarty[stan.krok];
        zastosuj();
      });
      box.appendChild(b);
    }
    var zamekDoWyboru = stan.krok === (znajdzKrokSekcji('przekroj') || '') && !zamekWidoczny;
    if (ukryte.length || zamekDoWyboru) {
      var sel = el('select', { id: 'pole-standardu', title: 'Pole standardu warsztatu zmieniane tylko w tym domu – pojawi się w tym kroku' });
      sel.appendChild(el('option', { value: '' }, 'Zmień pole standardu tylko w tym domu… (' + (ukryte.length + (zamekDoWyboru ? 1 : 0)) + ')'));
      for (i = 0; i < ukryte.length; i++) { sel.appendChild(el('option', { value: ukryte[i].klucz }, ukryte[i].etykieta)); }
      if (zamekDoWyboru) { sel.appendChild(el('option', { value: 'zamek' }, 'Wymiary zamka')); }
      sel.addEventListener('change', function () { if (this.value) { idzDo(this.value); } });
      box.appendChild(sel);
    }
  }

  // Karty okna z atrybutem data-krok: widoczne tylko w swoich krokach.
  function karty() {
    var lista = document.querySelectorAll('[data-krok].karta');
    var i;
    for (i = 0; i < lista.length; i++) {
      pokaz(lista[i], (' ' + lista[i].getAttribute('data-krok') + ' ').indexOf(' ' + stan.krok + ' ') >= 0);
    }
  }

  // Wyróżnienie przycisku bieżącego kroku.
  function przyciski() {
    var i;
    for (i = 0; i < stan.kroki.length; i++) {
      var b = $('krok-' + stan.kroki[i].klucz);
      if (b) { b.className = stan.kroki[i].klucz === stan.krok ? 'wybrany' : ''; }
    }
  }

  // Przejście do kroku.
  function wybierz(klucz) {
    if (znajdz(klucz)) { stan.krok = klucz; }
    zastosuj();
    return stan.krok;
  }

  // Znaczniki stanu kroków z listy uwag (html/uwagi.js): liczba uwag do poprawy albo ✓.
  function znaczniki(uwagi) {
    var ile = {};
    var bledy = {};
    var i;
    stan.uwagi = uwagi || [];
    for (i = 0; i < stan.uwagi.length; i++) {
      var u = stan.uwagi[i];
      if (u.poziom === 'ok') { continue; }
      ile[u.krok] = (ile[u.krok] || 0) + 1;
      if (u.poziom === 'blad') { bledy[u.krok] = true; }
    }
    for (i = 0; i < stan.kroki.length; i++) {
      var k = stan.kroki[i].klucz;
      var z = $('krok-stan-' + k);
      if (!z) { continue; }
      z.textContent = ile[k] ? String(ile[k]) : '✓';
      z.className = 'stan ' + (bledy[k] ? 'blad' : ile[k] ? 'uwaga' : 'ok');
      z.title = ile[k] ? 'Do poprawy: ' + ile[k] : 'Sprawdzone';
    }
  }

  // Opis pola po kluczu.
  function opis(klucz) {
    var i;
    for (i = 0; i < stan.opisy.length; i++) { if (stan.opisy[i].klucz === klucz) { return stan.opisy[i]; } }
    return null;
  }

  // Przejście do pola (klucz), sekcji albo kroku: właściwy krok, pole ukryte poziomem przypięte, przewinięcie,
  // wejście w pole i krótkie podświetlenie. Zwraca true, gdy było dokąd przejść.
  function idzDo(klucz, sekcja, krok) {
    var o = klucz && klucz !== 'zamek' ? opis(klucz) : null;
    var cel = null;
    if (klucz === 'zamek') {
      stan.przypiete.zamek = true;
      wybierz(znajdzKrokSekcji('przekroj') || stan.krok);
      cel = $('pola-zamek');
    } else if (o) {
      stan.krok = o.krok;
      stan.przypiete[o.klucz] = true;
      zastosuj();
      cel = $('p-' + o.klucz);
    } else if (sekcja && znajdzKrokSekcji(sekcja)) {
      wybierz(znajdzKrokSekcji(sekcja));
      cel = $('sekcja-' + sekcja);
      if (cel && cel.style.display === 'none') { cel = $('krok-poziomy'); }
    } else if (krok && znajdz(krok)) {
      wybierz(krok);
      cel = $('kroki');
    }
    if (!cel) { return false; }
    if (cel.scrollIntoView) { cel.scrollIntoView({ block: 'center' }); }
    if (o && cel.focus) { cel.focus(); }
    cel.className = (cel.className + ' blysk').replace(/^\s+/, '');
    setTimeout(function () { cel.className = cel.className.replace(/\s*blysk/g, ''); }, 1600);
    return true;
  }

  // Bieżący krok.
  function krok() { return stan.krok; }

  return { zbuduj: zbuduj, zastosuj: zastosuj, wybierz: wybierz, znaczniki: znaczniki, idzDo: idzDo, krok: krok, widoczne: widoczne };
}());
