/*
  ArteMadera – Generator Wieńcowy
  Plik: html/edycja.js
  Zadanie: ustawienia pojedynczej ściany pod jej widokiem – ostatek na każdym końcu, węgły dodawane i usuwane kliknięciem w widok, co jest nad działową (strop, antresola, półka) i jej góra.
  Tematy: panel ściany, edycja w widoku ściany, ostatek na końcu ściany, ostatek 200 pod taras, dodaj węgieł kliknięciem, usuń węgieł kliknięciem, przywróć węgły automatyczne, działowa niższa, nad działową, ustawienia ścian do Ruby
  Zależy od: html/wspolne.js (AMGW_DOM), dane widoku z Ruby (rdzen/widok.rb: ustawienia, domyslne, skrzyzowania)
  Używają: html/okno.js (init, panel po widoku, klik z html/sciana.js, dane do podglądu)

  Ustawienia ścian (jak 'sciany' w wejściu domu, rdzen/ustawienia_scian.rb): { 'W-1': { ostatek_od, ostatek_do, wegly: [s],
  nad, wysokosc } } – tylko wartości różne od wynikających z parametrów; lista wegly = węgły ustawione ręcznie.
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_EDYCJA = (function () {
  'use strict';

  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;
  var fmt = AMGW_DOM.fmt;
  var liczba = AMGW_DOM.liczba;
  var stan = { ust: {}, naZmiane: null };
  var NAD = [['', 'jak w ustawieniach'], ['nic', 'nic – pełna wysokość'], ['strop', 'strop'], ['antresola', 'antresola'],
             ['polka', 'półka']];
  // Odległość kliknięcia od węgła, przy której klik usuwa węgieł [mm].
  var BLISKO = 80;

  // Start: ustawienia ścian zapisane w domu i funkcja wołana po każdej zmianie (podgląd).
  function init(ustawienia, naZmiane) {
    stan.ust = JSON.parse(JSON.stringify(ustawienia || {}));
    stan.naZmiane = naZmiane;
  }

  // Ustawienia ścian do wysłania (bez pustych wpisów).
  function dane() {
    var wynik = {};
    var k;
    for (k in stan.ust) {
      if (Object.prototype.hasOwnProperty.call(stan.ust, k) && Object.keys(stan.ust[k]).length) { wynik[k] = stan.ust[k]; }
    }
    return wynik;
  }

  // Ustawienia ściany id (tworzone przy pierwszej zmianie).
  function ust(id) {
    if (!stan.ust[id]) { stan.ust[id] = {}; }
    return stan.ust[id];
  }

  // Zmiana ustawienia: wartość pusta albo równa domyślnej – usunięta z ustawień; potem podgląd.
  function ustaw(id, klucz, wartosc, domyslna) {
    var u = ust(id);
    if (wartosc === '' || wartosc === null || wartosc === undefined || (domyslna !== undefined && String(wartosc) === String(domyslna))) {
      delete u[klucz];
    } else {
      u[klucz] = wartosc;
    }
    if (stan.naZmiane) { stan.naZmiane(); }
  }

  // Osie węgłów na ścianie z danych widoku (skrzyżowania z węgłami).
  function weglyWidoku(d) {
    var wynik = [];
    var i;
    for (i = 0; i < (d.skrzyzowania || []).length; i++) {
      if (d.skrzyzowania[i][2] === 'kontrfor') { wynik.push(d.skrzyzowania[i][0]); }
    }
    return wynik;
  }

  // Klik w widoku ściany: przy węgle (sWegla) – usunięcie, w innym miejscu – nowy węgieł (oś zaokrąglona do 10 mm).
  // Pierwsza zmiana przepisuje węgły ściany na listę ręczną (automat tej ściany wyłączony).
  function klik(d, s, sWegla) {
    if (!d || !d.id) { return; }
    var u = ust(d.id);
    if (!u.wegly) { u.wegly = weglyWidoku(d); }
    if (sWegla !== null && sWegla !== undefined) {
      u.wegly = u.wegly.filter(function (x) { return Math.abs(x - sWegla) > 1; });
    } else {
      u.wegly.push(Math.round(s / 10) * 10);
      u.wegly.sort(function (a, b) { return a - b; });
    }
    if (stan.naZmiane) { stan.naZmiane(); }
  }

  // Najbliższy węgieł do miejsca s w zasięgu BLISKO (albo zasieg [mm]); null – brak.
  function wegielPrzy(d, s, zasieg) {
    var lista = weglyWidoku(d);
    var naj = null;
    var i;
    for (i = 0; i < lista.length; i++) {
      if (Math.abs(lista[i] - s) <= Math.max(BLISKO, zasieg || 0) && (naj === null || Math.abs(lista[i] - s) < Math.abs(naj - s))) {
        naj = lista[i];
      }
    }
    return naj;
  }

  // Pole liczby w panelu (etykieta, wartość, po zmianie – funkcja z nową wartością).
  function poleLiczby(box, id, etykieta, wartosc, naZmiane) {
    var lab = el('label', { 'for': id }, etykieta);
    var inp = el('input', { id: id, type: 'text', inputmode: 'decimal' });
    inp.value = wartosc === null || wartosc === undefined ? '' : fmt(wartosc);
    inp.addEventListener('change', function () {
      var v = liczba(this.value);
      naZmiane(v === null ? '' : v);
    });
    box.appendChild(lab);
    box.appendChild(inp);
  }

  // Panel ustawień ściany pod widokiem (d – dane widoku z Ruby; brak – panel pusty).
  function panel(box, d) {
    wyczysc(box);
    if (!d || d.blad || !d.ustawienia) { return; }
    var u = stan.ust[d.id] || {};
    var s = d.ustawienia;
    var dom = d.domyslne || {};
    box.appendChild(el('h3', null, 'Ustawienia ściany ' + d.id));
    var pola = el('div', { 'class': 'pola' });
    box.appendChild(pola);
    if (s.ostatek_od !== null && s.ostatek_od !== undefined) {
      poleLiczby(pola, 'e-ostatek-od', 'Ostatek – lewy koniec (początek)', s.ostatek_od, function (v) {
        ustaw(d.id, 'ostatek_od', v, dom.ostatek);
      });
    }
    if (s.ostatek_do !== null && s.ostatek_do !== undefined) {
      poleLiczby(pola, 'e-ostatek-do', 'Ostatek – prawy koniec', s.ostatek_do, function (v) {
        ustaw(d.id, 'ostatek_do', v, dom.ostatek);
      });
    }
    if (d.dzialowa) { panelDzialowej(pola, d, u, s, dom); }
    var wiersz = el('div', { 'class': 'wiersz wegly-stan' });
    if (u.wegly) {
      wiersz.appendChild(el('span', null, 'Węgły tej ściany ustawione ręcznie (' + u.wegly.length + ').'));
      var b = el('button', { type: 'button', id: 'e-wegly-auto' }, 'Przywróć automatyczne');
      b.addEventListener('click', function () { delete ust(d.id).wegly; if (stan.naZmiane) { stan.naZmiane(); } });
      wiersz.appendChild(b);
    } else {
      wiersz.appendChild(el('span', null, 'Węgły tej ściany: automatycznie i z rysunku.'));
    }
    box.appendChild(wiersz);
    box.appendChild(el('p', { 'class': 'drobny' }, 'Kliknij w widok ściany, żeby dodać węgieł; kliknij przy węgle (przerywana linia), ' +
      'żeby go usunąć. Ostatek 200 – np. pod taras.'));
  }

  // Pola działowej: co jest nad nią (strop, antresola, półka – tylko wtedy niższa) i góra działowej.
  function panelDzialowej(pola, d, u, s, dom) {
    var lab = el('label', { 'for': 'e-nad', 'class': 'pelny' }, 'Nad działową (niższa tylko pod stropem, antresolą, półką)');
    var sel = el('select', { id: 'e-nad' });
    var i;
    for (i = 0; i < NAD.length; i++) {
      var opis = NAD[i][0] === '' ? NAD[i][1] + ' (strop: ' + (dom.strop || 'nie') + ')' : NAD[i][1];
      var o = el('option', { value: NAD[i][0] }, opis);
      if ((u.nad || '') === NAD[i][0]) { o.selected = true; }
      sel.appendChild(o);
    }
    sel.addEventListener('change', function () { ustaw(d.id, 'nad', this.value); });
    pola.appendChild(lab);
    pola.appendChild(sel);
    if (s.nad && s.nad !== 'nic') {
      poleLiczby(pola, 'e-wysokosc', 'Góra działowej (spód stropu / antresoli)', u.wysokosc !== undefined ? u.wysokosc : dom.wysokosc,
                 function (v) { ustaw(d.id, 'wysokosc', v, dom.wysokosc); });
      pola.appendChild(el('div', { 'class': 'podp' }, 'Działowa kończy się na ' + fmt(d.wysokosc_wlasna) +
        ' mm (pełny wieniec); wyżej zamek dopełniają odcinki przy ścianach, które idą wyżej.'));
    }
  }

  return { init: init, dane: dane, klik: klik, wegielPrzy: wegielPrzy, panel: panel };
}());
