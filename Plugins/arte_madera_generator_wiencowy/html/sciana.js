/*
  ArteMadera – Generator Wieńcowy
  Plik: html/sciana.js
  Zadanie: widok ściany w oknie (SVG) – bale z numerami pozycji, wieńce, otwory, styki, skrzyżowania z innymi ścianami i węgłami, linia dachu; wybór ściany.
  Tematy: widok ściany, rozkład ściany, elewacja ściany, wybór ściany w oknie, styki na widoku, numery pozycji na widoku, kliknięcie w widok ściany, węgieł ręczny na widoku
  Zależy od: html/wspolne.js (AMGW_DOM)
  Używają: html/okno.js (AMGW.widok, lista ścian po podglądzie)

  Dane z Ruby: rdzen/widok.rb (s – wzdłuż osi ściany, z – od spodu pierwszego bala, mm).
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_SCIANA = (function () {
  'use strict';

  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;
  var fmt = AMGW_DOM.fmt;
  var NS = 'http://www.w3.org/2000/svg';
  var KOLORY = { Bs: '#ead7bb', Kf: '#cf9f69', Sz: '#f5e7cf' };
  var RODZAJE = { zewnetrzna: 'zewnętrzna', dzialowa: 'działowa', kontrfor: 'węgieł' };
  // Wysokość rysunku w oknie [px]: najmniejsza i największa.
  var WYS_MIN = 240;
  var WYS_MAX = 520;
  // Najniższy rysunek (część WYS_MIN), przy którym cała ściana mieści się jeszcze w szerokości okna.
  var SPLASZCZENIE = 0.7;

  // Element SVG z atrybutami.
  function svgEl(tag, atr) {
    var e = document.createElementNS(NS, tag);
    var k;
    for (k in atr) {
      if (Object.prototype.hasOwnProperty.call(atr, k)) { e.setAttribute(k, atr[k]); }
    }
    return e;
  }

  // Lista ścian w polu wyboru (po podglądzie); zachowuje wybraną, gdy nadal istnieje. Zwraca wybraną ścianę albo ''.
  function lista(sel, widoki, wybrana) {
    var i;
    var jest = false;
    wyczysc(sel);
    for (i = 0; i < (widoki || []).length; i++) {
      var o = el('option', { value: widoki[i][0] }, widoki[i][0] + ' – ' + (RODZAJE[widoki[i][1]] || widoki[i][1]));
      if (widoki[i][0] === wybrana) { o.selected = true; jest = true; }
      sel.appendChild(o);
    }
    if (!jest && sel.options.length) { sel.options[0].selected = true; }
    return sel.value || '';
  }

  // Zakres rysunku: [smin, smax, zmin, zmax] z bali, otworów i linii dachu.
  function zakres(d) {
    var smin = d.s_od, smax = d.s_do, zmin = 0, zmax = 0;
    var i, j;
    for (i = 0; i < d.bale.length; i++) {
      var o = d.bale[i].obrys;
      for (j = 0; j < o.length; j++) {
        smin = Math.min(smin, o[j][0]); smax = Math.max(smax, o[j][0]);
        zmin = Math.min(zmin, o[j][1]); zmax = Math.max(zmax, o[j][1]);
      }
    }
    for (i = 0; i < (d.linia_dachu || []).length; i++) { zmax = Math.max(zmax, d.linia_dachu[i][1]); }
    return [smin, smax, zmin, zmax];
  }

  // Rysunek ściany w kontenerze; opis nad rysunkiem w elemencie opis (gdy podany); naKlik(s, zasieg) – kliknięcie
  // w rysunek: miejsce s na osi ściany i zasięg trafienia w węgieł [mm] (8 px rysunku).
  function rysuj(box, d, opis, naKlik) {
    wyczysc(box);
    if (opis) { opis.textContent = ''; }
    if (!d || d.blad || !d.bale || !d.bale.length) {
      box.appendChild(el('p', { 'class': 'drobny' }, d && d.blad ? d.blad : 'Wybierz ścianę po podglądzie.'));
      return;
    }
    var z = zakres(d);
    var sz = Math.max(z[1] - z[0], 500);
    var wz = Math.max(z[3] - z[2], 300);
    var m = Math.max(wz * 0.12, 180);
    var szer = Math.max(box.clientWidth || 600, 300);
    var kSzer = szer / (sz + 2 * m);
    var kWys = WYS_MIN / (wz + 2 * m);
    // Cała ściana w szerokości okna, dopóki rysunek nie jest za niski; długa niska ściana – przewijanie w poziomie.
    var k = kSzer >= kWys * SPLASZCZENIE ? kSzer : kWys;
    if ((wz + 2 * m) * k > WYS_MAX) { k = WYS_MAX / (wz + 2 * m); }
    var svg = svgEl('svg', { viewBox: '0 0 ' + (sz + 2 * m).toFixed(1) + ' ' + (wz + 2 * m).toFixed(1),
                            width: ((sz + 2 * m) * k).toFixed(0), height: ((wz + 2 * m) * k).toFixed(0) });
    var X = function (s) { return (s - z[0] + m).toFixed(1); };
    var Y = function (h) { return (z[3] - h + m).toFixed(1); };
    var px = function (n) { return (n / k).toFixed(1); };
    skrzyzowania(svg, d, z, X, Y, px);
    bale(svg, d, X, Y, px, k);
    otwory(svg, d, X, Y, px);
    styki(svg, d, X, Y);
    dach(svg, d, X, Y);
    wience(svg, d, z, m, X, Y, px, k);
    if (naKlik) { klikanie(svg, d, z, m, k, naKlik); }
    box.appendChild(svg);
    if (opis) {
      opis.textContent = d.id + ' · ' + (RODZAJE[d.rodzaj] || d.rodzaj) + (d.szczyt ? ' ze szczytem' : '') + ' · ' +
        fmt(d.dl_osi) + ' mm w osi · wieńce: ' + d.wience.length + ' · bale: ' + d.bale.length + ' · styki: ' + d.styki;
    }
  }

  // Kliknięcie w rysunek: miejsce na osi ściany (z odwróconego przekształcenia SVG) do funkcji naKlik.
  function klikanie(svg, d, z, m, k, naKlik) {
    svg.setAttribute('class', 'klikalny');
    svg.addEventListener('click', function (ev) {
      var ctm = svg.getScreenCTM();
      if (!ctm) { return; }
      var pt = svg.createSVGPoint();
      pt.x = ev.clientX;
      pt.y = ev.clientY;
      var s = pt.matrixTransform(ctm.inverse()).x + z[0] - m;
      if (s > d.s_od && s < d.s_do) { naKlik(s, 8 / k); }
    });
  }

  // Skrzyżowania z innymi ścianami i węgłami: linia przerywana i opis nad ścianą (węgieł ręczny – opis pogrubiony).
  function skrzyzowania(svg, d, z, X, Y, px) {
    var i;
    for (i = 0; i < (d.skrzyzowania || []).length; i++) {
      var k = d.skrzyzowania[i];
      var kf = k[2] === 'kontrfor';
      svg.appendChild(svgEl('line', { x1: X(k[0]), y1: Y(z[2]), x2: X(k[0]), y2: Y(z[3]), stroke: kf ? '#b07a3e' : '#7d6a55',
                                      'stroke-width': '1', 'stroke-dasharray': '4 3', 'vector-effect': 'non-scaling-stroke',
                                      'class': 'skrzyzowanie' }));
      var t = svgEl('text', { x: X(k[0]), y: Y(z[3]), dy: px(-6), 'font-size': px(10), 'text-anchor': 'middle',
                              fill: kf ? '#8a5a2b' : '#5c4a38', 'font-weight': k[3] === 'reczny' ? '700' : '400' });
      t.appendChild(document.createTextNode(k[1]));
      svg.appendChild(t);
    }
  }

  // Bale: obrys z gniazdami zamków i skosem, kolor wg grupy, numer pozycji (gdy się mieści) i opis po najechaniu.
  function bale(svg, d, X, Y, px, k) {
    var i, j;
    for (i = 0; i < d.bale.length; i++) {
      var b = d.bale[i];
      var pts = [];
      for (j = 0; j < b.obrys.length; j++) { pts.push(X(b.obrys[j][0]) + ',' + Y(b.obrys[j][1])); }
      var poly = svgEl('polygon', { points: pts.join(' '), fill: KOLORY[b.prefiks] || '#ead7bb', stroke: '#7a5530',
                                    'stroke-width': '0.8', 'vector-effect': 'non-scaling-stroke', 'class': 'bal' });
      var tytul = svgEl('title', {});
      tytul.appendChild(document.createTextNode('Poz. ' + b.nazwa + ' (' + b.prefiks + ') · wieniec ' + b.wieniec + ' · ' +
                                                fmt(b.s1 - b.s0) + ' mm'));
      poly.appendChild(tytul);
      svg.appendChild(poly);
      if ((b.s1 - b.s0) * k >= 26 && b.h * k >= 8) {
        var t = svgEl('text', { x: X((b.s0 + b.s1) / 2), y: Y(b.z0 + b.h / 2), 'font-size': px(Math.min(10, b.h * k * 0.75)),
                                'text-anchor': 'middle', 'dominant-baseline': 'central', fill: '#3b2a1a', 'class': 'nr-poz' });
        t.appendChild(document.createTextNode(String(b.nr)));
        svg.appendChild(t);
      }
    }
  }

  // Otwory: prostokąt otworu w balach, w nim stolarka (przerywana – widać luz boczny i górny) i nazwa.
  function otwory(svg, d, X, Y, px) {
    var i;
    for (i = 0; i < (d.otwory || []).length; i++) {
      var o = d.otwory[i];
      svg.appendChild(svgEl('rect', { x: X(o[0]), y: Y(o[3]), width: (o[1] - o[0]).toFixed(1), height: (o[3] - o[2]).toFixed(1),
                                      fill: '#ffffff', 'fill-opacity': '0.85', stroke: '#4a90c2', 'stroke-width': '1.5',
                                      'vector-effect': 'non-scaling-stroke', 'class': 'otwor' }));
      var st = o[5];
      if (st) {
        svg.appendChild(svgEl('rect', { x: X(st[0]), y: Y(st[3]), width: (st[1] - st[0]).toFixed(1), height: (st[3] - st[2]).toFixed(1),
                                        fill: 'none', stroke: '#2f6f9f', 'stroke-width': '1', 'stroke-dasharray': '4 3',
                                        'vector-effect': 'non-scaling-stroke', 'class': 'stolarka' }));
      }
      if (o[4]) {
        var t = svgEl('text', { x: X((o[0] + o[1]) / 2), y: Y((o[2] + o[3]) / 2), 'font-size': px(10), 'text-anchor': 'middle',
                                'dominant-baseline': 'central', fill: '#2f6f9f' });
        t.appendChild(document.createTextNode(o[4]));
        svg.appendChild(t);
      }
    }
  }

  // Styki bali: czerwona kreska na końcu bala oznaczonym jako styk.
  function styki(svg, d, X, Y) {
    var i;
    for (i = 0; i < d.bale.length; i++) {
      var b = d.bale[i];
      var konce = [[b.konce[0], b.s0], [b.konce[1], b.s1]];
      var j;
      for (j = 0; j < 2; j++) {
        if (konce[j][0] !== 'styk') { continue; }
        svg.appendChild(svgEl('line', { x1: X(konce[j][1]), y1: Y(b.z0), x2: X(konce[j][1]), y2: Y(b.z0 + b.h), stroke: '#d0342c',
                                        'stroke-width': '2.2', 'vector-effect': 'non-scaling-stroke', 'class': 'styk' }));
      }
    }
  }

  // Linia dachu (szczyt – wierzch bali szczytu, ściana pod połacią – spód krokwi).
  function dach(svg, d, X, Y) {
    var i;
    var pts = [];
    for (i = 0; i < (d.linia_dachu || []).length; i++) { pts.push(X(d.linia_dachu[i][0]) + ',' + Y(d.linia_dachu[i][1])); }
    if (pts.length < 2) { return; }
    svg.appendChild(svgEl('polyline', { points: pts.join(' '), fill: 'none', stroke: '#a0522d', 'stroke-width': '1.5',
                                        'stroke-dasharray': '6 4', 'vector-effect': 'non-scaling-stroke', 'class': 'linia-dachu' }));
  }

  // Numery wieńców z lewej (co który się mieści).
  function wience(svg, d, z, m, X, Y, px, k) {
    var i;
    var co = 1;
    var hmin = Infinity;
    for (i = 0; i < d.wience.length; i++) { hmin = Math.min(hmin, d.wience[i][2]); }
    while (hmin * k * co < 11 && co < 10) { co++; }
    for (i = 0; i < d.wience.length; i++) {
      var w = d.wience[i];
      if ((w[0] - 1) % co !== 0) { continue; }
      var t = svgEl('text', { x: X(z[0] - m * 0.35), y: Y(w[1] + w[2] / 2), 'font-size': px(9), 'text-anchor': 'middle',
                              'dominant-baseline': 'central', fill: '#8a7a68', 'class': 'nr-wienca' });
      t.appendChild(document.createTextNode(String(w[0])));
      svg.appendChild(t);
    }
  }

  return { rysuj: rysuj, lista: lista };
}());
