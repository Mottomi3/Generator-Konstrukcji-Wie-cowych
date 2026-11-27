/*
  ArteMadera – Generator Wieńcowy
  Plik: html/kanaly.js
  Zadanie: kanały na przewody (N3) w oknie – lista kanałów domu (ściana, od, średnica, puszka), okienko kanału przy kliknięciu w widok ściany (nowy, poprawa, usunięcie), lista pod tabelą okien i drzwi.
  Tematy: kanały na przewody w oknie, okienko kanału, kanał kliknięciem, lista kanałów, puszka w okienku, usuń kanał
  Zależy od: html/wspolne.js (AMGW_DOM), html/klik_sciana.js (AMGW_KLIK – okienko, pola, przyciski), html/okno.html (#lista-kanalow)
  Używają: html/okno.js (dane domu – kanaly, start), html/klik_sciana.js (kliknięcie przy kanale albo w trybie „kanał”), html/sciana.js (rysunek kanałów z widoku)

  Kanał w wejściu domu: { sciana, od (oś kanału od punktu odniesienia ściany, jak „od” otworu), srednica (puste –
  kanal_srednica), puszka (środek puszki od spodu pierwszego bala; puste – bez puszki), strona ('lewa' – puste, 'prawa') }
  – rdzen/kanaly.rb. Widok ściany podaje kanały jako [s, średnica, puszka, nazwa, nr wiersza, koniec pod oknem albo null].
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_KANALY = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var fmt = AMGW_DOM.fmt;
  var liczba = AMGW_DOM.liczba;
  var stan = { lista: [], parametr: function (k, d) { return d; }, zmiana: function () {} };

  // Start: kanały domu, odczyt parametru z formularza, podgląd po zmianie.
  function init(lista, parametr, zmiana) {
    stan.lista = [];
    var i;
    for (i = 0; i < (lista || []).length; i++) { stan.lista.push(kopia(lista[i])); }
    stan.parametr = parametr || stan.parametr;
    stan.zmiana = zmiana || stan.zmiana;
    pokaz();
  }

  // Strony puszki do okienka: lico lewe ściany (wnętrze ściany zewnętrznej) albo prawe.
  var STRONY = [['lewa', 'lewej – wnętrze ściany zewnętrznej'], ['prawa', 'prawej – od zewnątrz']];

  // Kopia kanału z polami tekstowymi.
  function kopia(k) {
    return { sciana: String(k.sciana || ''), od: tekst(k.od), srednica: tekst(k.srednica), puszka: tekst(k.puszka), strona: tekst(k.strona) };
  }

  // Wartość pola jako tekst (puste – '').
  function tekst(v) { return v === undefined || v === null ? '' : String(v); }

  // Lista kanałów do danych domu.
  function lista() {
    var wynik = [];
    var i;
    for (i = 0; i < stan.lista.length; i++) { wynik.push(kopia(stan.lista[i])); }
    return wynik;
  }

  // Kanał widoku ściany d trafiony w miejscu s (zasięg – tolerancja [mm]); numer wiersza albo null.
  function przy(d, s, zasieg) {
    var i;
    for (i = 0; i < (d.kanaly || []).length; i++) {
      var k = d.kanaly[i];
      if (Math.abs(s - k[0]) <= Math.max(k[1] / 2, zasieg || 0)) { return k[4]; }
    }
    return null;
  }

  // Okienko kanału: nowy w miejscu s ściany d (nr null) albo poprawa wiersza nr.
  function okienko(d, ev, nr, s) {
    var stary = nr === null ? null : stan.lista[nr];
    var od = stary ? stary.od : fmt(Math.round(s - (d.ref || 0)));
    var box = AMGW_KLIK.okienko(ev, (stary ? 'Kanał K' + (nr + 1) : 'Nowy kanał na przewody') + ' – ściana ' + (stary ? stary.sciana : d.id));
    var pOd = AMGW_KLIK.pole(box, 'od', 'Oś kanału od narożnika [mm]', od);
    var pSr = AMGW_KLIK.pole(box, 'srednica', 'Średnica [mm] (puste – ' + stan.parametr('kanal_srednica', '25') + ')', stary ? stary.srednica : '');
    var pPu = AMGW_KLIK.pole(box, 'puszka', 'Puszka – środek od spodu ściany [mm] (puste – bez puszki)',
                              stary ? stary.puszka : stan.parametr('kanal_puszka_wysokosc', '300'));
    var pSt = AMGW_KLIK.pole(box, 'strona', 'Puszka – od strony', stary ? (stary.strona || 'lewa') : 'lewa', STRONY);
    box.appendChild(el('p', { 'class': 'drobny' }, 'Pionowy otwór przez wszystkie wieńce w osi grubości bala; nie bliżej zamka niż ' +
                       stan.parametr('kanal_odstep_zamka', '60') + ' mm od lica ściany poprzecznej. W miejscu okna – tylko pod nim.'));
    var dane = function () {
      return { sciana: stary ? stary.sciana : d.id, od: pOd.value, srednica: pSr.value, puszka: pPu.value, strona: pSt.value };
    };
    if (stary) {
      AMGW_KLIK.przyciski(box, [['k-zapisz', 'Zapisz', function () { stan.lista[nr] = dane(); zmiana(); }, true],
                                ['k-usun', 'Usuń', function () { usun(nr); }], ['k-anuluj', 'Anuluj', AMGW_KLIK.zamknij]]);
    } else {
      AMGW_KLIK.przyciski(box, [['k-wstaw', 'Wstaw', function () { if (liczba(pOd.value) !== null) { stan.lista.push(dane()); zmiana(); } else { AMGW_KLIK.zamknij(); } }, true],
                                ['k-anuluj', 'Anuluj', AMGW_KLIK.zamknij]]);
    }
    pOd.focus();
  }

  // Usunięcie kanału nr.
  function usun(nr) {
    stan.lista.splice(nr, 1);
    zmiana();
  }

  // Po zmianie listy: okienko zamknięte, lista odświeżona, podgląd.
  function zmiana() {
    AMGW_KLIK.zamknij();
    pokaz();
    stan.zmiana();
  }

  // Lista kanałów pod tabelą okien i drzwi (z przyciskiem usunięcia).
  function pokaz() {
    var box = $('lista-kanalow');
    if (!box) { return; }
    AMGW_DOM.wyczysc(box);
    if (!stan.lista.length) {
      box.appendChild(el('p', { 'class': 'drobny' }, 'Kanały na przewody: brak – wstawisz je kliknięciem w widok ściany (przełącznik „kanał”).'));
      return;
    }
    var i;
    for (i = 0; i < stan.lista.length; i++) {
      var k = stan.lista[i];
      var w = el('div', { 'class': 'wiersz kanal-wiersz' });
      w.appendChild(el('span', null, 'K' + (i + 1) + ' · ' + k.sciana + ' · od ' + k.od + ' mm · Ø ' + (k.srednica || stan.parametr('kanal_srednica', '25')) +
                       (k.puszka !== '' ? ' · puszka ' + k.puszka + ' mm' + (k.strona === 'prawa' ? ' z prawej' : '') : '')));
      var b = el('button', { type: 'button', title: 'Usuń kanał', 'data-nr': String(i) }, '×');
      b.addEventListener('click', function () { usun(Number(this.getAttribute('data-nr'))); });
      w.appendChild(b);
      box.appendChild(w);
    }
  }

  return { init: init, lista: lista, przy: przy, okienko: okienko, usun: usun };
}());
