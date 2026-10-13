/*
  ArteMadera – Generator Wieńcowy
  Plik: html/okno.js
  Zadanie: logika okna parametrów – formularz z opisów pól, tabela otworów, rzut SVG, wyniki, wywołania Ruby (sketchup.*).
  Tematy: formularz parametrów, sekcje pól, wymiary zamka w oknie, tabela otworów, rzut w oknie, wyniki w oknie, podgląd automatyczny
  Zależy od: html/okno.html, html/okno.css
  Używają: sketchup/okno.rb (AMGW.init, AMGW.wynik)

  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
  Pole nowego parametru pojawia się samo (Parametry::OPISY); SEKCJE decydują tylko, w której sekcji stoi.
*/
var AMGW = (function () {
  'use strict';

  // Sekcja okna dla klucza parametru (klucz spoza listy trafia do „Rozpoznanie rysunku i waga”).
  var SEKCJE = {
    preset: 'pola-przekroj',
    liczba_wiencow: 'pola-sciany', ostatek: 'pola-sciany', kalenica: 'pola-sciany',
    max_dlugosc: 'pola-styki', min_odcinek: 'pola-styki', styk_uklad: 'pola-styki', mijanka: 'pola-styki',
    szczelina_styku: 'pola-styki',
    luz_nad_otworem: 'pola-otwory', odstep_od_otworu: 'pola-otwory', min_kawalek_przy_otworze: 'pola-otwory'
  };
  var OKNO_DOMYSLNE = { szerokosc: 1020, wysokosc: 1010, parapet: 900 };
  var DRZWI_DOMYSLNE = { szerokosc: 930, wysokosc: 2100, parapet: 0 };

  var stan = { opisy: [], wybory: {}, presety: {}, opisyZamka: [], sciany: [], timer: null };

  // Element po identyfikatorze.
  function $(id) { return document.getElementById(id); }

  // Nowy element z atrybutami i tekstem.
  function el(tag, atrybuty, tekst) {
    var e = document.createElement(tag);
    var k;
    if (atrybuty) {
      for (k in atrybuty) {
        if (Object.prototype.hasOwnProperty.call(atrybuty, k)) { e.setAttribute(k, atrybuty[k]); }
      }
    }
    if (tekst !== undefined && tekst !== null) { e.appendChild(document.createTextNode(String(tekst))); }
    return e;
  }

  // Usunięcie zawartości elementu.
  function wyczysc(e) { while (e.firstChild) { e.removeChild(e.firstChild); } }

  // Liczba z tekstu (przecinek dziesiętny dozwolony); null, gdy to nie liczba.
  function liczba(v) {
    var t = String(v === undefined || v === null ? '' : v).replace(',', '.').replace(/\s+/g, '');
    if (!/^-?\d+(\.\d+)?$/.test(t)) { return null; }
    return parseFloat(t);
  }

  // Liczba do wyświetlenia (bez zbędnego ,0).
  function fmt(v) {
    var n = Number(v);
    if (isNaN(n)) { return String(v); }
    return Math.abs(n - Math.round(n)) < 1e-9 ? String(Math.round(n)) : n.toFixed(1);
  }

  // Wywołanie Ruby (window.sketchup.nazwa) – poza SketchUpem nic nie robi.
  function wywolaj(nazwa, dane) {
    if (window.sketchup && typeof window.sketchup[nazwa] === 'function') {
      window.sketchup[nazwa](dane === undefined ? '' : dane);
    }
  }

  // ---- formularz ----

  // Formularz z opisów pól (Parametry::OPISY) i wymiary zamka.
  function zbudujFormularz(parametry) {
    var i;
    var ids = ['pola-przekroj', 'pola-sciany', 'pola-styki', 'pola-otwory', 'pola-rysunek'];
    for (i = 0; i < ids.length; i++) { wyczysc($(ids[i])); }
    for (i = 0; i < stan.opisy.length; i++) {
      dodajPole(stan.opisy[i], parametry);
    }
    zbudujZamek(parametry);
  }

  // Jedno pole parametru w swojej sekcji (lista wyboru albo pole liczby).
  function dodajPole(opis, parametry) {
    var sekcja = $(SEKCJE[opis.klucz] || 'pola-rysunek');
    var wartosc = parametry[opis.klucz] !== undefined ? parametry[opis.klucz] : opis.domyslna;
    var etykieta = el('label', { 'for': 'p-' + opis.klucz }, opis.etykieta);
    var pole;
    var lista;
    var j;
    if (opis.rodzaj === 'wybor') {
      etykieta.className = 'pelny';
      sekcja.appendChild(etykieta);
      pole = el('select', { id: 'p-' + opis.klucz, 'data-klucz': opis.klucz });
      lista = opis.klucz === 'preset' ? listaPresetow() : (stan.wybory[opis.klucz] || []);
      for (j = 0; j < lista.length; j++) {
        var o = el('option', { value: lista[j][0] }, lista[j][1]);
        if (String(lista[j][0]) === String(wartosc)) { o.selected = true; }
        pole.appendChild(o);
      }
      if (opis.klucz === 'preset') {
        pole.addEventListener('change', function () { zbudujZamek({ preset: this.value }); zaplanujPodglad(); });
      }
    } else {
      if (opis.jednostka) { etykieta.appendChild(el('span', { 'class': 'jedn' }, '[' + opis.jednostka + ']')); }
      sekcja.appendChild(etykieta);
      pole = el('input', { id: 'p-' + opis.klucz, 'data-klucz': opis.klucz, type: 'text', inputmode: 'decimal' });
      pole.value = fmt(wartosc);
      if (opis.min !== null && opis.max !== null) { pole.title = 'od ' + fmt(opis.min) + ' do ' + fmt(opis.max); }
    }
    pole.addEventListener('change', zaplanujPodglad);
    sekcja.appendChild(pole);
  }

  // Presety przekroju do listy wyboru.
  function listaPresetow() {
    var wynik = [];
    var k;
    for (k in stan.presety) {
      if (Object.prototype.hasOwnProperty.call(stan.presety, k)) { wynik.push([k, stan.presety[k].nazwa]); }
    }
    return wynik;
  }

  // Pola wymiarów zamka: wartości własne albo z presetu.
  function zbudujZamek(parametry) {
    var box = $('pola-zamek');
    var preset = stan.presety[parametry.preset || ($('p-preset') ? $('p-preset').value : '')] || {};
    var wlasny = parametry.zamek || {};
    var i;
    wyczysc(box);
    for (i = 0; i < stan.opisyZamka.length; i++) {
      var o = stan.opisyZamka[i];
      var lab = el('label', { 'for': 'z-' + o[0] }, o[1]);
      lab.appendChild(el('span', { 'class': 'jedn' }, '[' + o[2] + ']'));
      var inp = el('input', { id: 'z-' + o[0], 'data-zamek': o[0], type: 'text', inputmode: 'decimal' });
      inp.value = fmt(wlasny[o[0]] !== undefined ? wlasny[o[0]] : preset[o[0]]);
      inp.addEventListener('change', zaplanujPodglad);
      box.appendChild(lab);
      box.appendChild(inp);
    }
  }

  // Parametry z formularza (z wymiarami zamka) do wysłania do Ruby.
  function zbierzParametry() {
    var p = {};
    var zamek = {};
    var pola = document.querySelectorAll('[data-klucz]');
    var i;
    for (i = 0; i < pola.length; i++) { p[pola[i].getAttribute('data-klucz')] = pola[i].value; }
    pola = document.querySelectorAll('[data-zamek]');
    for (i = 0; i < pola.length; i++) { zamek[pola[i].getAttribute('data-zamek')] = pola[i].value; }
    p.zamek = zamek;
    return p;
  }

  // ---- otwory ----

  // Wiersz otworu w tabeli (ściana, od, szerokość, wysokość, parapet, nazwa).
  function dodajOtwor(o) {
    var tr = el('tr');
    var td = el('td');
    var sel = el('select', { 'data-o': 'sciana' });
    wypelnijSciany(sel, o.sciana);
    td.appendChild(sel);
    tr.appendChild(td);
    var klucze = ['od', 'szerokosc', 'wysokosc', 'parapet', 'nazwa'];
    var i;
    for (i = 0; i < klucze.length; i++) {
      td = el('td');
      var inp = el('input', { type: 'text', 'data-o': klucze[i] });
      inp.value = o[klucze[i]] === undefined || o[klucze[i]] === null ? '' : String(o[klucze[i]]);
      inp.addEventListener('change', zaplanujPodglad);
      td.appendChild(inp);
      tr.appendChild(td);
    }
    td = el('td');
    var usun = el('button', { type: 'button', title: 'Usuń otwór' }, '×');
    usun.addEventListener('click', function () { tr.parentNode.removeChild(tr); zaplanujPodglad(); });
    td.appendChild(usun);
    tr.appendChild(td);
    sel.addEventListener('change', zaplanujPodglad);
    $('tab-otwory').getElementsByTagName('tbody')[0].appendChild(tr);
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

  // Otwory z tabeli do wysłania do Ruby.
  function zbierzOtwory() {
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

  // Odświeżenie list ścian w tabeli otworów po podglądzie.
  function odswiezScianyOtworow() {
    var sel = $('tab-otwory').querySelectorAll('select[data-o="sciana"]');
    var i;
    for (i = 0; i < sel.length; i++) { wypelnijSciany(sel[i], sel[i].value); }
  }

  // Pierwsza ściana (nie kontrfor) – domyślna dla nowego otworu.
  function pierwszaSciana() {
    var i;
    for (i = 0; i < stan.sciany.length; i++) {
      if (stan.sciany[i].rodzaj !== 'kontrfor') { return stan.sciany[i].id; }
    }
    return 'W-1';
  }

  // ---- rzut ----

  // Rzut SVG: obrys, ściany, kontrfory, otwory, punkty odniesienia i opisy W-n.
  function rysujRzut(rzut) {
    var box = $('rzut');
    wyczysc(box);
    if (!rzut || !rzut.obrys || rzut.obrys.length < 3) {
      box.appendChild(el('p', { 'class': 'drobny' }, 'Brak rozpoznanego obrysu.'));
      return;
    }
    var pts = [];
    var i;
    var j;
    for (i = 0; i < rzut.obrys.length; i++) { pts.push(rzut.obrys[i]); }
    for (i = 0; i < rzut.sciany.length; i++) { pts.push(rzut.sciany[i].od); pts.push(rzut.sciany[i]['do']); }
    var minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
    for (i = 0; i < pts.length; i++) {
      minX = Math.min(minX, pts[i][0]); maxX = Math.max(maxX, pts[i][0]);
      minY = Math.min(minY, pts[i][1]); maxY = Math.max(maxY, pts[i][1]);
    }
    var m = Math.max(maxX - minX, maxY - minY, 1000) * 0.2;
    var w = maxX - minX + 2 * m;
    var h = maxY - minY + 2 * m;
    var ns = 'http://www.w3.org/2000/svg';
    var svg = document.createElementNS(ns, 'svg');
    svg.setAttribute('viewBox', '0 0 ' + w.toFixed(0) + ' ' + h.toFixed(0));
    var sx = function (p) { return (p[0] - minX + m).toFixed(1); };
    var sy = function (p) { return (maxY - p[1] + m).toFixed(1); };
    var gr = Math.max(w, h) / 220;
    var srodekObrysu = [0, 0];
    for (i = 0; i < rzut.obrys.length; i++) {
      srodekObrysu[0] += rzut.obrys[i][0] / rzut.obrys.length;
      srodekObrysu[1] += rzut.obrys[i][1] / rzut.obrys.length;
    }
    var poly = document.createElementNS(ns, 'polygon');
    var lista = [];
    for (i = 0; i < rzut.obrys.length; i++) { lista.push(sx(rzut.obrys[i]) + ',' + sy(rzut.obrys[i])); }
    poly.setAttribute('points', lista.join(' '));
    poly.setAttribute('fill', '#f1e6d8');
    poly.setAttribute('stroke', '#c9b79f');
    poly.setAttribute('stroke-width', gr);
    svg.appendChild(poly);
    for (i = 0; i < rzut.sciany.length; i++) {
      var s = rzut.sciany[i];
      var kf = s.rodzaj === 'kontrfor';
      var ln = document.createElementNS(ns, 'line');
      ln.setAttribute('x1', sx(s.od)); ln.setAttribute('y1', sy(s.od));
      ln.setAttribute('x2', sx(s['do'])); ln.setAttribute('y2', sy(s['do']));
      ln.setAttribute('stroke', kf ? '#b07a3e' : '#5a3b1c');
      ln.setAttribute('stroke-width', gr * (kf ? 2.2 : 3.0));
      svg.appendChild(ln);
      for (j = 0; j < s.otwory.length; j++) {
        var ol = document.createElementNS(ns, 'line');
        ol.setAttribute('x1', sx(s.otwory[j][0])); ol.setAttribute('y1', sy(s.otwory[j][0]));
        ol.setAttribute('x2', sx(s.otwory[j][1])); ol.setAttribute('y2', sy(s.otwory[j][1]));
        ol.setAttribute('stroke', '#4a90c2');
        ol.setAttribute('stroke-width', gr * 4.0);
        svg.appendChild(ol);
      }
      if (!kf) {
        var c = document.createElementNS(ns, 'circle');
        c.setAttribute('cx', sx(s.ref)); c.setAttribute('cy', sy(s.ref)); c.setAttribute('r', gr * 2.6);
        c.setAttribute('fill', '#8a5a2b');
        svg.appendChild(c);
      }
      var t = document.createElementNS(ns, 'text');
      var poz = miejsceOpisu(s, kf, srodekObrysu, gr);
      t.setAttribute('x', sx(poz)); t.setAttribute('y', sy(poz));
      t.setAttribute('font-size', gr * (kf ? 7 : 10));
      t.setAttribute('text-anchor', poz[2]);
      t.setAttribute('dominant-baseline', 'middle');
      t.setAttribute('fill', kf ? '#8a5a2b' : '#2b2620');
      t.appendChild(document.createTextNode(s.id));
      svg.appendChild(t);
    }
    box.appendChild(svg);
  }

  // Miejsce opisu na rzucie: [x, y, wyrównanie]; ściana – obok środka po stronie od środka obrysu, kontrfor – za końcem.
  function miejsceOpisu(s, kf, srodek, gr) {
    var a = s.od;
    var b = s['do'];
    var dx = b[0] - a[0];
    var dy = b[1] - a[1];
    var d = Math.sqrt(dx * dx + dy * dy) || 1;
    var n = [-dy / d, dx / d];
    var m = [(a[0] + b[0]) / 2, (a[1] + b[1]) / 2];
    var odl;
    if (kf) {
      var da = Math.pow(a[0] - srodek[0], 2) + Math.pow(a[1] - srodek[1], 2);
      var db = Math.pow(b[0] - srodek[0], 2) + Math.pow(b[1] - srodek[1], 2);
      var dalej = da > db ? a : b;
      var kier = [(dalej[0] - m[0]) / (d / 2), (dalej[1] - m[1]) / (d / 2)];
      m = [dalej[0] + kier[0] * gr * 4, dalej[1] + kier[1] * gr * 4];
      return [m[0], m[1], Math.abs(kier[0]) > 0.5 ? (kier[0] > 0 ? 'start' : 'end') : 'middle'];
    }
    if ((m[0] - srodek[0]) * n[0] + (m[1] - srodek[1]) * n[1] < 0) { n = [-n[0], -n[1]]; }
    odl = s.rodzaj === 'zewnetrzna' ? gr * 13 : gr * 4;
    if (Math.abs(n[0]) > 0.5) {
      return [m[0] + n[0] * odl, m[1], n[0] > 0 ? 'start' : 'end'];
    }
    return [m[0] + d * 0.12 * (dx >= 0 ? 1 : -1), m[1] + n[1] * odl, 'middle'];
  }

  // ---- wyniki ----

  // Komunikat nad formularzem (ok / blad).
  function pokazKomunikat(tekst, rodzaj) {
    var k = $('komunikat');
    k.className = 'komunikat ' + rodzaj;
    k.textContent = tekst;
  }

  // Ukrycie komunikatu.
  function ukryjKomunikat() { $('komunikat').className = 'komunikat ukryty'; }

  // Lista błędów lub ostrzeżeń.
  function lista(idBox, pozycje, klasa) {
    var box = $(idBox);
    var i;
    wyczysc(box);
    if (!pozycje || pozycje.length === 0) { return; }
    var ul = el('ul', { 'class': klasa });
    for (i = 0; i < pozycje.length; i++) { ul.appendChild(el('li', null, pozycje[i])); }
    box.appendChild(ul);
  }

  // Wiersz tabeli wyników.
  function wiersz(tbody, komorki, liczbowe) {
    var tr = el('tr');
    var i;
    for (i = 0; i < komorki.length; i++) {
      var td = el('td', null, komorki[i]);
      if (liczbowe && liczbowe[i]) { td.className = 'liczba'; }
      tr.appendChild(td);
    }
    tbody.appendChild(tr);
  }

  // Wyniki: liczby, wysokości, tabela ścian, lista bali, rzut, błędy i ostrzeżenia.
  function pokazWynik(d) {
    var i;
    lista('lista-bledow', d.bledy, 'lista-blad');
    lista('lista-ostrzezen', d.ostrzezenia, 'lista-uwaga');
    rysujRzut(d.rzut);
    var liczby = $('liczby');
    wyczysc(liczby);
    var tbS = $('tab-sciany').getElementsByTagName('tbody')[0];
    var tbL = $('tab-lista').getElementsByTagName('tbody')[0];
    wyczysc(tbS);
    wyczysc(tbL);
    $('wysokosci').textContent = '';
    if (!d.sciany) { return; }
    stan.sciany = d.sciany;
    odswiezScianyOtworow();
    var n = d.liczby;
    var wpisy = [['Bale', n.bale], ['Pozycje', n.pozycje], ['Objętość', Number(n.objetosc_m3).toFixed(2) + ' m³'],
                 ['Waga', n.waga_kg + ' kg'], ['Zamki (pary bali)', n.pary_zamkow], ['Nowe kontrfory przy stykach', n.kontrfory_nowe]];
    for (i = 0; i < wpisy.length; i++) {
      var sp = el('span', null, wpisy[i][0] + ': ');
      sp.appendChild(el('b', null, wpisy[i][1]));
      liczby.appendChild(sp);
    }
    if (d.wysokosci) {
      $('wysokosci').textContent = 'Wysokość: ściany okapowe ' + fmt(d.wysokosci.okapowa) + ' mm, szczytowe ' +
        fmt(d.wysokosci.szczytowa) + ' mm (z pierwszym balem szczytu), działowe ' + fmt(d.wysokosci.dzialowa_szczytowa) +
        '–' + fmt(d.wysokosci.dzialowa_okapowa) + ' mm.';
    }
    for (i = 0; i < d.sciany.length; i++) {
      var w = d.sciany[i];
      var styki = [];
      var j;
      for (j = 0; j < w.styki.length; j++) { styki.push(w.styki[j][0] + '/' + w.styki[j][1]); }
      wiersz(tbS, [w.id, w.rodzaj, w.dlugosc, fmt(w.wysokosc), w.wience, w.bale, styki.join(', ')],
             [false, false, true, true, true, true, false]);
    }
    for (i = 0; i < d.lista.length; i++) {
      var l = d.lista[i];
      wiersz(tbL, [l.prefiks, l.nazwa, l.przekroj, l.dl, l.ilosc, Number(l.objetosc_m3).toFixed(3)], [false, false, false, true, true, true]);
    }
  }

  // ---- wywołania ----

  // Dane formularza jako JSON (parametry i otwory).
  function dane() { return JSON.stringify({ parametry: zbierzParametry(), otwory: zbierzOtwory() }); }

  // Podgląd po zmianie pola (z opóźnieniem 350 ms – kilka zmian = jedno wywołanie).
  function zaplanujPodglad() {
    if (stan.timer) { clearTimeout(stan.timer); }
    stan.timer = setTimeout(function () { stan.timer = null; wywolaj('podglad', dane()); }, 350);
  }

  // Start okna danymi z Ruby (AMGW.init).
  function init(d) {
    stan.opisy = d.opisy || [];
    stan.wybory = d.wybory || {};
    stan.presety = d.presety || {};
    stan.opisyZamka = d.opisy_zamka || [];
    $('info').textContent = d.info || '';
    zbudujFormularz(d.parametry || {});
    var i;
    if (d.podsumowanie) { pokazWynik(d.podsumowanie); }
    for (i = 0; i < (d.otwory || []).length; i++) { dodajOtwor(d.otwory[i]); }
    $('btn-generuj').textContent = d.tryb === 'edycja' ? 'Zastąp dom w modelu' : 'Generuj w modelu';
  }

  // Wynik z Ruby (AMGW.wynik) – po podglądzie albo generowaniu.
  function wynik(d) {
    pokazWynik(d);
    $('btn-generuj').disabled = false;
    if (d.bledy && d.bledy.length) {
      pokazKomunikat('Nie można wygenerować domu – popraw błędy na liście.', 'blad');
    } else if (d.zbudowano) {
      pokazKomunikat('Dom wygenerowany w modelu: ' + d.liczby.bale + ' bali, ' + d.liczby.pozycje + ' pozycji.' +
                     (d.bledne_sciany ? ' Uwaga: ' + d.bledne_sciany + ' ścian brył nie narysowano.' : ''), 'ok');
      $('btn-generuj').textContent = 'Zastąp dom w modelu';
    } else if (d.anulowano) {
      pokazKomunikat('Anulowano – dom w modelu bez zmian.', 'blad');
    } else {
      ukryjKomunikat();
    }
  }

  // Podpięcie przycisków i zgłoszenie gotowości okna do Ruby.
  function start() {
    $('btn-podglad').addEventListener('click', function () { wywolaj('podglad', dane()); });
    $('btn-generuj').addEventListener('click', function () {
      this.disabled = true;
      pokazKomunikat('Generowanie…', 'ok');
      wywolaj('generuj', dane());
    });
    $('btn-zamknij').addEventListener('click', function () { wywolaj('zamknij'); });
    $('btn-okno').addEventListener('click', function () {
      dodajOtwor({ sciana: pierwszaSciana(), od: 1000, szerokosc: OKNO_DOMYSLNE.szerokosc, wysokosc: OKNO_DOMYSLNE.wysokosc,
                   parapet: OKNO_DOMYSLNE.parapet, nazwa: '' });
      zaplanujPodglad();
    });
    $('btn-drzwi').addEventListener('click', function () {
      dodajOtwor({ sciana: pierwszaSciana(), od: 1000, szerokosc: DRZWI_DOMYSLNE.szerokosc, wysokosc: DRZWI_DOMYSLNE.wysokosc,
                   parapet: DRZWI_DOMYSLNE.parapet, nazwa: '' });
      zaplanujPodglad();
    });
    wywolaj('gotowe');
  }

  window.onerror = function (msg, src, linia) {
    wywolaj('blad_js', String(msg) + ' (wiersz ' + linia + ')');
    return false;
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', start);
  } else {
    start();
  }

  return { init: init, wynik: wynik, _zbierz: dane };
}());
