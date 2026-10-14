/*
  ArteMadera – Generator Wieńcowy
  Plik: html/rzut.js
  Zadanie: rzut domu w oknie (SVG) – obrys, ściany i węgły, otwory, punkty odniesienia otworów, opisy W-n.
  Tematy: rzut w oknie, rysunek SVG, opisy ścian na rzucie, punkt odniesienia otworu, kliknięcie ściany na rzucie
  Zależy od: html/wspolne.js (AMGW_DOM)
  Używają: html/wyniki.js (AMGW_RZUT.rysuj)

  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_RZUT = (function () {
  'use strict';

  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;

  // Rzut SVG: obrys, ściany, kontrfory, otwory, punkty odniesienia i opisy W-n; naKlik(id) – kliknięcie ściany.
  function rysuj(box, rzut, naKlik) {
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
      if (naKlik && !kf) { svg.appendChild(polePrzycisku(ns, s, sx, sy, gr, naKlik)); }
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

  // Szeroka, niewidoczna linia nad ścianą – łatwiej ją kliknąć (wybór ściany do widoku).
  function polePrzycisku(ns, s, sx, sy, gr, naKlik) {
    var hit = document.createElementNS(ns, 'line');
    hit.setAttribute('x1', sx(s.od)); hit.setAttribute('y1', sy(s.od));
    hit.setAttribute('x2', sx(s['do'])); hit.setAttribute('y2', sy(s['do']));
    hit.setAttribute('stroke', 'transparent');
    hit.setAttribute('stroke-width', gr * 9);
    hit.setAttribute('class', 'klik-sciana');
    hit.setAttribute('data-sciana', s.id);
    hit.addEventListener('click', function () { naKlik(s.id); });
    return hit;
  }

  // Miejsce opisu na rzucie: [x, y, wyrównanie]; ściana – obok środka po stronie od środka obrysu, kontrfor – za końcem
  // bliższym środka obrysu (w środku domu – opis nie wchodzi na opis ściany zewnętrznej).
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
      var blizej = da > db ? b : a;
      var kier = [(blizej[0] - m[0]) / (d / 2), (blizej[1] - m[1]) / (d / 2)];
      m = [blizej[0] + kier[0] * gr * 4, blizej[1] + kier[1] * gr * 4];
      return [m[0], m[1], Math.abs(kier[0]) > 0.5 ? (kier[0] > 0 ? 'start' : 'end') : 'middle'];
    }
    if ((m[0] - srodek[0]) * n[0] + (m[1] - srodek[1]) * n[1] < 0) { n = [-n[0], -n[1]]; }
    odl = s.rodzaj === 'zewnetrzna' ? gr * 13 : gr * 4;
    if (Math.abs(n[0]) > 0.5) {
      return [m[0] + n[0] * odl, m[1], n[0] > 0 ? 'start' : 'end'];
    }
    return [m[0] + d * 0.12 * (dx >= 0 ? 1 : -1), m[1] + n[1] * odl, 'middle'];
  }

  return { rysuj: rysuj };
}());
