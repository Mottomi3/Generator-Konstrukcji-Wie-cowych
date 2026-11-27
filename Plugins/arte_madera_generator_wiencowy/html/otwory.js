/*
  ArteMadera – Generator Wieńcowy
  Plik: html/otwory.js
  Zadanie: tabela okien i drzwi w oknie – typ z listy typowej stolarki, stolarka (ściana, od, szerokość i wysokość stolarki, parapet, luz górny, nazwa), otwór w balach i podpowiedź luzu górnego; wiersz do poprawy z okienka przy widoku ściany.
  Tematy: tabela otworów, stolarka w oknie, luz górny w tabeli, podpowiedź luzu, otwór w balach w oknie, lista ścian otworu, nowe okno, nowe drzwi, typ stolarki w tabeli, lista typowej stolarki w oknie, otwór z listy stolarki, poprawa otworu z widoku ściany
  Zależy od: html/wspolne.js (AMGW_DOM), html/tabela.js (lista stolarki z pola „stolarka”), html/okno.html (tabela #tab-otwory, #nowy-typ)
  Używają: html/okno.js (init, dodaj, zbierz, sciany, pierwszaSciana, przelicz, dodajTyp), html/klik_sciana.js (lista, wiersz, ustaw, usun)

  Te same zasady co rdzen/stolarka.rb: otwór = stolarka + 2 × luz boczny, wysokość + luz górny; pusty luz górny =
  podpowiedź (wysokość × osiadanie %, w górę do 5 mm, nie mniej niż minimum) – widać ją w polu jako podpowiedź.
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_OTWORY = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;
  var KLUCZE = ['od', 'szerokosc', 'wysokosc', 'parapet', 'luz_gorny', 'nazwa'];
  var stan = { sciany: [], parametr: function (k, d) { return d; }, zmiana: function () {}, lista: [], listaTekst: '', nowyTekst: null };

  // Lista typowej stolarki z pola „stolarka” (standard warsztatu): [{ symbol, rodzaj, szerokosc, wysokosc, spod, model }].
  function lista() {
    var t = stan.parametr('stolarka', '[]');
    if (t !== stan.listaTekst) {
      stan.listaTekst = t;
      stan.lista = AMGW_TABELA.wiersze(t);
    }
    return stan.lista;
  }

  // Pozycja listy stolarki po symbolu (null – brak).
  function typ(symbol) {
    var l = lista();
    var i;
    for (i = 0; i < l.length; i++) { if (String(l[i].symbol) === String(symbol)) { return l[i]; } }
    return null;
  }

  // Opis pozycji listy: „O1 – okno 1020 × 1010”.
  function opisTypu(t) {
    return t.symbol + ' – ' + t.rodzaj + ' ' + AMGW_DOM.fmt(t.szerokosc) + ' × ' + AMGW_DOM.fmt(t.wysokosc);
  }

  // Opcje listy typów w polu wyboru (pierwsza: inny wymiar – bez typu); zachowuje wybrany.
  function wypelnijTypy(sel, wybrany) {
    var l = lista();
    var i;
    wyczysc(sel);
    sel.appendChild(el('option', { value: '' }, '–'));
    for (i = 0; i < l.length; i++) {
      var o = el('option', { value: l[i].symbol }, opisTypu(l[i]));
      if (String(l[i].symbol) === String(wybrany)) { o.selected = true; }
      sel.appendChild(o);
    }
    if (wybrany && !typ(wybrany)) {
      var brak = el('option', { value: wybrany }, wybrany + ' (brak na liście)');
      brak.selected = true;
      sel.appendChild(brak);
    }
  }

  // Start: odczyt parametru z formularza (klucz, wartość domyślna) i reakcja na zmianę wiersza (podgląd).
  function init(parametr, zmiana) {
    stan.parametr = parametr;
    stan.zmiana = zmiana;
  }

  // Liczba z pola tekstowego (przecinek albo kropka, spacje pomijane) albo null.
  function liczba(t) {
    var s = String(t === undefined || t === null ? '' : t).replace(/\s/g, '').replace(',', '.');
    if (s === '') { return null; }
    var v = parseFloat(s);
    return isNaN(v) ? null : v;
  }

  // Podpowiedź luzu górnego dla wysokości stolarki h [mm] (jak Stolarka.luz_podpowiedz w Ruby).
  function podpowiedz(h) {
    var proc = liczba(stan.parametr('osiadanie_scian', '1.5')) || 0;
    var min = liczba(stan.parametr('luz_gorny_min', '10')) || 0;
    var z = Math.ceil((h * proc / 100) / 5 - 1e-9) * 5;
    return Math.max(z, min);
  }

  // Wiersz: podpowiedź luzu w pustym polu i wymiary otworu w balach (szer. × wys.).
  function przeliczWiersz(tr) {
    var pole = function (k) { return tr.querySelector('[data-o="' + k + '"]'); };
    var szer = liczba(pole('szerokosc').value);
    var wys = liczba(pole('wysokosc').value);
    var luzPole = pole('luz_gorny');
    var opis = tr.querySelector('.otwor-w-balach');
    if (szer === null || wys === null) {
      luzPole.placeholder = '';
      opis.textContent = '';
      return;
    }
    var podp = podpowiedz(wys);
    luzPole.placeholder = String(podp);
    luzPole.title = 'Puste pole – podpowiedź ' + podp + ' mm (osiadanie ' + stan.parametr('osiadanie_scian', '1.5') + ' %).';
    var lg = liczba(luzPole.value);
    if (lg === null || lg < 0) { lg = podp; }
    var lb = liczba(stan.parametr('luz_boczny', '10')) || 0;
    opis.textContent = Math.round(szer + 2 * lb) + ' × ' + Math.round(wys + lg);
  }

  // Przeliczenie wszystkich wierszy (po zmianie luzu bocznego albo osiadania w parametrach) i odświeżenie list typów,
  // gdy zmieniła się lista stolarki.
  function przelicz() {
    var wiersze = $('tab-otwory').getElementsByTagName('tbody')[0].getElementsByTagName('tr');
    var stara = stan.listaTekst;
    var i;
    lista();
    for (i = 0; i < wiersze.length; i++) {
      if (stara !== stan.listaTekst) {
        var sel = wiersze[i].querySelector('[data-o="typ"]');
        wypelnijTypy(sel, sel.value);
      }
      przeliczWiersz(wiersze[i]);
    }
    if (stan.nowyTekst !== stan.listaTekst) { wypelnijNowy(); }
  }

  // Lista typów przy przycisku „+ dodaj” (bez pozycji pustej).
  function wypelnijNowy() {
    var sel = $('nowy-typ');
    var stary = sel.value;
    var l = lista();
    var i;
    stan.nowyTekst = stan.listaTekst;
    wyczysc(sel);
    for (i = 0; i < l.length; i++) {
      var o = el('option', { value: l[i].symbol }, opisTypu(l[i]));
      if (String(l[i].symbol) === stary) { o.selected = true; }
      sel.appendChild(o);
    }
  }

  // Lista ścian dla otworu (bez kontrforów); brakująca ściana zostaje z dopiskiem.
  function wypelnijSciany(sel, wybrana) {
    var i;
    var jest = false;
    wyczysc(sel);
    for (i = 0; i < stan.sciany.length; i++) {
      var w = stan.sciany[i];
      if (w.rodzaj === 'kontrfor') { continue; }
      var o = el('option', { value: w.id, title: w.rodzaj }, w.id);
      if (w.id === wybrana) { o.selected = true; jest = true; }
      sel.appendChild(o);
    }
    if (wybrana && !jest) {
      var brak = el('option', { value: wybrana }, wybrana + ' (brak)');
      brak.selected = true;
      sel.appendChild(brak);
    }
  }

  // Nowy wiersz tabeli z danymi otworu o (klucze jak w Ruby: sciana, od, szerokosc, wysokosc, parapet, luz_gorny, nazwa).
  function dodaj(o) {
    var tr = el('tr');
    var td = el('td');
    var sel = el('select', { 'data-o': 'sciana' });
    wypelnijSciany(sel, o.sciana);
    td.appendChild(sel);
    tr.appendChild(td);
    td = el('td');
    var selTyp = el('select', { 'data-o': 'typ', title: 'Typ z listy typowej stolarki (Standard warsztatu); „–” – inny wymiar' });
    wypelnijTypy(selTyp, o.typ || '');
    selTyp.addEventListener('change', function () {
      var t = typ(this.value);
      if (t) {
        tr.querySelector('[data-o="szerokosc"]').value = AMGW_DOM.fmt(t.szerokosc);
        tr.querySelector('[data-o="wysokosc"]').value = AMGW_DOM.fmt(t.wysokosc);
        tr.querySelector('[data-o="parapet"]').value = AMGW_DOM.fmt(t.spod);
      }
      przeliczWiersz(tr);
      stan.zmiana();
    });
    td.appendChild(selTyp);
    tr.appendChild(td);
    var i;
    for (i = 0; i < KLUCZE.length; i++) {
      td = el('td');
      var inp = el('input', { type: 'text', 'data-o': KLUCZE[i] });
      inp.value = o[KLUCZE[i]] === undefined || o[KLUCZE[i]] === null ? '' : String(o[KLUCZE[i]]);
      inp.addEventListener('change', function () { przeliczWiersz(tr); stan.zmiana(); });
      td.appendChild(inp);
      tr.appendChild(td);
    }
    td = el('td', { 'class': 'otwor-w-balach', title: 'Otwór w balach: stolarka + luzy' });
    tr.appendChild(td);
    td = el('td');
    var usun = el('button', { type: 'button', title: 'Usuń otwór' }, '×');
    usun.addEventListener('click', function () { tr.parentNode.removeChild(tr); stan.zmiana(); });
    td.appendChild(usun);
    tr.appendChild(td);
    sel.addEventListener('change', stan.zmiana);
    $('tab-otwory').getElementsByTagName('tbody')[0].appendChild(tr);
    przeliczWiersz(tr);
  }

  // Otwory z tabeli do wysłania do Ruby.
  function zbierz() {
    var wiersze = $('tab-otwory').getElementsByTagName('tbody')[0].getElementsByTagName('tr');
    var wynik = [];
    var i;
    for (i = 0; i < wiersze.length; i++) {
      var pola = wiersze[i].querySelectorAll('[data-o]');
      var o = {};
      var j;
      for (j = 0; j < pola.length; j++) { o[pola[j].getAttribute('data-o')] = pola[j].value; }
      wynik.push(o);
    }
    return wynik;
  }

  // Nowa lista ścian (po podglądzie) – odświeżenie list w wierszach.
  function sciany(lista) {
    stan.sciany = lista || [];
    var sel = $('tab-otwory').querySelectorAll('select[data-o="sciana"]');
    var i;
    for (i = 0; i < sel.length; i++) { wypelnijSciany(sel[i], sel[i].value); }
  }

  // Nowy wiersz z pozycji listy stolarki o symbolu (ściana, od – podane albo domyślne); false – brak takiej pozycji.
  function dodajZListy(symbol, sciana, od) {
    var t = typ(symbol);
    if (!t) { return false; }
    dodaj({ sciana: sciana || pierwszaSciana(), typ: t.symbol, od: od === undefined ? stan.parametr('nowy_otwor_od', '1000') : od,
            szerokosc: AMGW_DOM.fmt(t.szerokosc), wysokosc: AMGW_DOM.fmt(t.wysokosc), parapet: AMGW_DOM.fmt(t.spod), luz_gorny: '', nazwa: '' });
    return true;
  }

  // Nowy wiersz z pierwszej pozycji listy danego rodzaju ('okno' | 'drzwi'); false – lista nie ma takiej pozycji.
  function dodajTyp(rodzaj) {
    var l = lista();
    var i;
    for (i = 0; i < l.length; i++) { if (l[i].rodzaj === rodzaj) { return dodajZListy(l[i].symbol); } }
    return false;
  }

  // Wiersze tabeli (elementy tr).
  function wiersze() { return $('tab-otwory').getElementsByTagName('tbody')[0].getElementsByTagName('tr'); }

  // Dane wiersza nr (kolejność w tabeli – jak nr otworu z Ruby); null – brak.
  function wiersz(nr) {
    var tr = wiersze()[nr];
    if (!tr) { return null; }
    var o = {};
    var pola = tr.querySelectorAll('[data-o]');
    var j;
    for (j = 0; j < pola.length; j++) { o[pola[j].getAttribute('data-o')] = pola[j].value; }
    return o;
  }

  // Nowe wartości wiersza nr (klucze jak w dodaj; brakujące zostają) i podgląd.
  function ustaw(nr, o) {
    var tr = wiersze()[nr];
    if (!tr) { return; }
    var k;
    for (k in o) {
      if (!Object.prototype.hasOwnProperty.call(o, k)) { continue; }
      var p = tr.querySelector('[data-o="' + k + '"]');
      if (!p) { continue; }
      if (k === 'typ') { wypelnijTypy(p, o[k]); } else if (k === 'sciana') { wypelnijSciany(p, o[k]); } else { p.value = o[k]; }
    }
    przeliczWiersz(tr);
    stan.zmiana();
  }

  // Usunięcie wiersza nr i podgląd.
  function usun(nr) {
    var tr = wiersze()[nr];
    if (!tr) { return; }
    tr.parentNode.removeChild(tr);
    stan.zmiana();
  }

  // Pierwsza ściana (nie kontrfor) – domyślna dla nowego otworu.
  function pierwszaSciana() {
    var i;
    for (i = 0; i < stan.sciany.length; i++) {
      if (stan.sciany[i].rodzaj !== 'kontrfor') { return stan.sciany[i].id; }
    }
    return 'W-1';
  }

  return { init: init, dodaj: dodaj, zbierz: zbierz, sciany: sciany, pierwszaSciana: pierwszaSciana, przelicz: przelicz,
           podpowiedz: podpowiedz, lista: lista, typ: typ, opisTypu: opisTypu, dodajZListy: dodajZListy, dodajTyp: dodajTyp,
           wiersz: wiersz, ustaw: ustaw, usun: usun };
}());
