/*
  ArteMadera – Generator Wieńcowy
  Plik: html/klik_sciana.js
  Zadanie: okna, drzwi i węgły kliknięciem w widok ściany – przełącznik „klik wstawia: węgieł / okno / drzwi”, okienko z parametrami przy miejscu kliknięcia (typ stolarki z listy, wymiary, spód, luz górny, nazwa, od), poprawa i usunięcie istniejącego otworu albo węgła.
  Tematy: kliknięcie w widok ściany, okienko parametrów przy kliknięciu, okno kliknięciem, drzwi kliknięciem, węgieł kliknięciem, poprawa otworu kliknięciem, usuń otwór kliknięciem, przesuń węgieł w okienku, usuń węgieł w okienku, przełącznik klik wstawia
  Zależy od: html/wspolne.js (AMGW_DOM), html/otwory.js (lista stolarki, wiersze tabeli otworów), html/edycja.js (węgły ręczne ściany), html/okno.html (#klik-tryb, #karta-widok)
  Używają: html/okno.js (klik w widok ściany, start przełącznika)

  Decyzja użytkownika z 2026-11-25: „dodajmy + ewentualnie przy kliknięciu by się wyświetlało okienko z parametrami”.
  Miejsce na osi ściany s → „od” otworu: s0 otworu w balach = s − połowa (stolarka + 2 × luz boczny), od = s0 − ref
  (ref – punkt odniesienia ściany z widoku, rdzen/widok.rb); węgieł: oś w s (zaokrąglona do 10 mm), od = s − ref.
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_KLIK = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var fmt = AMGW_DOM.fmt;
  var liczba = AMGW_DOM.liczba;
  var stan = { tryb: 'wegiel', parametr: function (k, d) { return d; }, zmiana: function () {} };
  var TRYBY = [['wegiel', 'węgieł'], ['okno', 'okno'], ['drzwi', 'drzwi']];

  // Start: odczyt parametru z formularza i podgląd po zmianie; przyciski przełącznika nad widokiem ściany.
  function init(parametr, zmiana) {
    stan.parametr = parametr;
    stan.zmiana = zmiana;
    var box = $('klik-tryb');
    AMGW_DOM.wyczysc(box);
    box.appendChild(el('span', null, 'Klik w widok wstawia:'));
    var i;
    for (i = 0; i < TRYBY.length; i++) {
      var b = el('button', { type: 'button', id: 'klik-' + TRYBY[i][0], 'data-tryb': TRYBY[i][0] }, TRYBY[i][1]);
      b.addEventListener('click', function () { ustawTryb(this.getAttribute('data-tryb')); });
      box.appendChild(b);
    }
    ustawTryb(stan.tryb);
  }

  // Wybór, co wstawia kliknięcie w widok ściany ('wegiel' | 'okno' | 'drzwi').
  function ustawTryb(t) {
    stan.tryb = t;
    var i;
    for (i = 0; i < TRYBY.length; i++) {
      var b = $('klik-' + TRYBY[i][0]);
      if (b) { b.className = TRYBY[i][0] === t ? 'wybrany' : ''; }
    }
    zamknij();
    return t;
  }

  // Luz boczny stolarki z formularza [mm].
  function luzBoczny() { return liczba(stan.parametr('luz_boczny', '10')) || 0; }

  // Otwór widoku trafiony kliknięciem (s, h); null – brak.
  function otworPrzy(d, s, h) {
    var i;
    for (i = 0; i < (d.otwory || []).length; i++) {
      var o = d.otwory[i];
      if (s >= o[0] && s <= o[1] && h >= o[2] - 20 && h <= o[3] + 20) { return o; }
    }
    return null;
  }

  // Kliknięcie w widok ściany d w miejscu s (wysokość h, zasięg trafienia w węgieł, zdarzenie ev): przy węgle – okienko
  // węgła (węgieł to wąski cel, więc ma pierwszeństwo), w otworze – okienko poprawy otworu, wolne miejsce – okienko nowego
  // elementu według przełącznika.
  function klik(d, s, zasieg, h, ev) {
    if (!d || !d.id) { return; }
    var w = AMGW_EDYCJA.wegielPrzy(d, s, zasieg);
    if (w !== null) { okienkoWegla(d, ev, w); return; }
    var o = otworPrzy(d, s, h);
    if (o && o[6] !== null && o[6] !== undefined) { okienkoOtworu(d, ev, o[6], null); return; }
    if (stan.tryb === 'wegiel') { okienkoWegla(d, ev, null, s); return; }
    okienkoOtworu(d, ev, null, s);
  }

  // Okienko przy miejscu kliknięcia (pozycja względem karty widoku): tytuł, pola, przyciski.
  function okienko(ev, tytul) {
    zamknij();
    var karta = $('karta-widok');
    var box = el('div', { id: 'klik-okienko', 'class': 'klik-okienko', role: 'dialog' });
    box.appendChild(el('h3', null, tytul));
    karta.appendChild(box);
    var r = karta.getBoundingClientRect();
    var x = ev && ev.clientX !== undefined ? ev.clientX - r.left + 8 : 20;
    var y = ev && ev.clientY !== undefined ? ev.clientY - r.top + 8 : 60;
    box.style.left = Math.max(4, Math.min(x, r.width - 300)) + 'px';
    box.style.top = Math.max(4, y) + 'px';
    return box;
  }

  // Wiersz okienka: etykieta i pole (tekst albo lista wyboru) z identyfikatorem k-<klucz>.
  function pole(box, klucz, etykieta, wartosc, wybory) {
    var w = el('div', { 'class': 'klik-pole' });
    w.appendChild(el('label', { 'for': 'k-' + klucz }, etykieta));
    var p;
    if (wybory) {
      p = el('select', { id: 'k-' + klucz });
      var i;
      for (i = 0; i < wybory.length; i++) {
        var o = el('option', { value: wybory[i][0] }, wybory[i][1]);
        if (String(wybory[i][0]) === String(wartosc)) { o.selected = true; }
        p.appendChild(o);
      }
    } else {
      p = el('input', { id: 'k-' + klucz, type: 'text' });
      p.value = wartosc === undefined || wartosc === null ? '' : String(wartosc);
    }
    w.appendChild(p);
    box.appendChild(w);
    return p;
  }

  // Przyciski okienka: [[id, tekst, funkcja, główny]].
  function przyciski(box, lista) {
    var w = el('div', { 'class': 'wiersz klik-przyciski' });
    var i;
    for (i = 0; i < lista.length; i++) {
      var b = el('button', { type: 'button', id: lista[i][0], 'class': lista[i][3] ? 'glowny' : '' }, lista[i][1]);
      b.addEventListener('click', lista[i][2]);
      w.appendChild(b);
    }
    box.appendChild(w);
  }

  // Okienko okna / drzwi: nowy otwór w miejscu s (nr null) albo poprawa wiersza nr tabeli otworów.
  function okienkoOtworu(d, ev, nr, s) {
    var stary = nr === null ? null : AMGW_OTWORY.wiersz(nr);
    var rodzaj = stan.tryb === 'drzwi' ? 'drzwi' : 'okno';
    var lista = AMGW_OTWORY.lista();
    var wybory = [['', 'inny wymiar']];
    var pierwszy = null;
    var i;
    for (i = 0; i < lista.length; i++) {
      wybory.push([lista[i].symbol, AMGW_OTWORY.opisTypu(lista[i])]);
      if (!pierwszy && lista[i].rodzaj === rodzaj) { pierwszy = lista[i]; }
    }
    var t = stary ? AMGW_OTWORY.typ(stary.typ) : pierwszy;
    var szer = stary ? stary.szerokosc : (t ? fmt(t.szerokosc) : '');
    var wys = stary ? stary.wysokosc : (t ? fmt(t.wysokosc) : '');
    var od = stary ? stary.od : (liczba(szer) === null ? '' : fmt(Math.round(s - (liczba(szer) + 2 * luzBoczny()) / 2 - (d.ref || 0))));
    var box = okienko(ev, stary ? 'Otwór ' + (stary.nazwa || 'O' + (nr + 1)) + ' – ściana ' + stary.sciana : 'Nowe ' + rodzaj + ' – ściana ' + d.id);
    var pTyp = pole(box, 'typ', 'Typ z listy', stary ? stary.typ : (t ? t.symbol : ''), wybory);
    var pSzer = pole(box, 'szerokosc', 'Szerokość stolarki [mm]', szer);
    var pWys = pole(box, 'wysokosc', 'Wysokość stolarki [mm]', wys);
    var pSpod = pole(box, 'parapet', 'Spód od podwaliny [mm]', stary ? stary.parapet : (t ? fmt(t.spod) : (rodzaj === 'drzwi' ? '0' : '')));
    var pOd = pole(box, 'od', 'Od narożnika [mm]', od);
    var pLuz = pole(box, 'luz_gorny', 'Luz górny [mm] (puste – podpowiedź)', stary ? stary.luz_gorny : '');
    var pNazwa = pole(box, 'nazwa', 'Nazwa', stary ? stary.nazwa : '');
    pTyp.addEventListener('change', function () {
      var x = AMGW_OTWORY.typ(this.value);
      if (!x) { return; }
      var sr = liczba(pOd.value) === null ? null : liczba(pOd.value) + ((liczba(pSzer.value) || 0) + 2 * luzBoczny()) / 2;
      pSzer.value = fmt(x.szerokosc);
      pWys.value = fmt(x.wysokosc);
      pSpod.value = fmt(x.spod);
      if (sr !== null) { pOd.value = fmt(Math.round(sr - (x.szerokosc + 2 * luzBoczny()) / 2)); }
    });
    var dane = function () {
      return { typ: pTyp.value, szerokosc: pSzer.value, wysokosc: pWys.value, parapet: pSpod.value, od: pOd.value,
               luz_gorny: pLuz.value, nazwa: pNazwa.value };
    };
    if (stary) {
      przyciski(box, [['k-zapisz', 'Zapisz', function () { AMGW_OTWORY.ustaw(nr, dane()); zamknij(); }, true],
                      ['k-usun', 'Usuń', function () { AMGW_OTWORY.usun(nr); zamknij(); }],
                      ['k-anuluj', 'Anuluj', zamknij]]);
    } else {
      przyciski(box, [['k-wstaw', 'Wstaw', function () {
        var o = dane();
        o.sciana = d.id;
        AMGW_OTWORY.dodaj(o);
        stan.zmiana();
        zamknij();
      }, true], ['k-anuluj', 'Anuluj', zamknij]]);
    }
    pSzer.focus();
  }

  // Okienko węgła: nowy w miejscu s (sWegla null) albo istniejący w osi sWegla – przesunięcie („od”) i usunięcie.
  function okienkoWegla(d, ev, sWegla, s) {
    var nowy = sWegla === null;
    var os = nowy ? Math.round(s / 10) * 10 : sWegla;
    var box = okienko(ev, (nowy ? 'Nowy węgieł' : 'Węgieł') + ' – ściana ' + d.id);
    var pOd = pole(box, 'od', 'Oś węgła od narożnika [mm]', fmt(Math.round((os - (d.ref || 0)) * 10) / 10));
    box.appendChild(el('p', { 'class': 'drobny' }, 'Pierwsza zmiana przepisuje węgły tej ściany na ręczne (automat ściany wyłączony).'));
    var nowaOs = function () {
      var v = liczba(pOd.value);
      return v === null ? null : v + (d.ref || 0);
    };
    if (nowy) {
      przyciski(box, [['k-wstaw', 'Wstaw', function () {
        var x = nowaOs();
        if (x !== null) { AMGW_EDYCJA.klik(d, x, null); }
        zamknij();
      }, true], ['k-anuluj', 'Anuluj', zamknij]]);
    } else {
      przyciski(box, [['k-zapisz', 'Zapisz', function () {
        var x = nowaOs();
        if (x !== null && Math.abs(x - sWegla) > 0.05) { AMGW_EDYCJA.przesun(d.id, wegly(d), sWegla, x); }
        zamknij();
      }, true], ['k-usun', 'Usuń', function () { AMGW_EDYCJA.klik(d, sWegla, sWegla); zamknij(); }],
                      ['k-anuluj', 'Anuluj', zamknij]]);
    }
    pOd.focus();
  }

  // Osie węgłów na ścianie z widoku.
  function wegly(d) {
    var wynik = [];
    var i;
    for (i = 0; i < (d.skrzyzowania || []).length; i++) {
      if (d.skrzyzowania[i][2] === 'kontrfor') { wynik.push(d.skrzyzowania[i][0]); }
    }
    return wynik;
  }

  // Zamknięcie okienka (gdy otwarte).
  function zamknij() {
    var b = $('klik-okienko');
    if (b && b.parentNode) { b.parentNode.removeChild(b); }
  }

  return { init: init, klik: klik, ustawTryb: ustawTryb, zamknij: zamknij, tryb: function () { return stan.tryb; } };
}());
