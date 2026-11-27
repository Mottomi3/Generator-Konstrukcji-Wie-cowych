/*
  ArteMadera – Generator Wieńcowy – testy
  Plik: testy/t_okno_kroki.js
  Zadanie: okno w Chromium (Playwright), układ nowy – kroki w kolejności budowy, prawa kolumna z rzutem i listą „Do poprawy / Sprawdzone”, pola według poziomów (ten dom, typ, standard), zmiana tylko w tym domu, panel standardu warsztatu, podpowiedź po wejściu w pole, opcje wyszarzone dla obrysu, przełącznik układu, dom z wymiarów.
  Tematy: test układu kroków, test listy uwag, test poziomów pól w oknie, test panelu standardu, test przełącznika układu, test opcji niedostępnych dla obrysu, test domu z wymiarów w oknie, zrzut okna – kroki, test okna samego standardu
  Zależy od: testy/okno_dane.rb, Plugins/.../html/okno.html
  Używają: testy/uruchom.sh

  Uruchomienie: node testy/t_okno_kroki.js – ostatnia linia „FAILURES: n”; zrzuty: testy/wyniki/okno_kroki.png, okno_standard.png.
*/
var path = require('path');
var fs = require('fs');
var cp = require('child_process');
var pw;
try { pw = require('playwright'); } catch (e) {
  try { pw = require('/opt/node-tools/node_modules/playwright'); } catch (e2) { pw = require(path.join(cp.execSync('npm root -g').toString().trim(), 'playwright')); }
}

var KAT = path.resolve(__dirname, '..');
var HTML = path.join(KAT, 'Plugins', 'arte_madera_generator_wiencowy', 'html', 'okno.html');
var bledy = 0;
var ok = 0;
function sprawdz(w, opis) { if (w) { ok++; } else { bledy++; console.log('BŁĄD ' + opis); } }

var dane = JSON.parse(cp.execSync('ruby -I ' + path.join(KAT, 'testy', 'atrapa') + ' ' + path.join(KAT, 'testy', 'okno_dane.rb')).toString());

(async function () {
  var browser = await pw.chromium.launch();
  var page = await browser.newPage({ viewport: { width: 1060, height: 860 } });
  var konsola = [];
  page.on('pageerror', function (e) { konsola.push(String(e)); });
  page.on('console', function (m) { if (m.type() === 'error') { konsola.push(m.text()); } });
  await page.addInitScript(function () {
    window.__wywolania = [];
    window.sketchup = {};
    ['gotowe', 'podglad', 'generuj', 'zamknij', 'blad_js', 'typ_wybierz', 'typ_zapisz', 'typ_powiel', 'typ_usun', 'standard_zapisz',
     'standard_fabryczne', 'uklad', 'widok', 'zapisz_liste', 'tryb_pol', 'sciany'].forEach(function (n) {
      window.sketchup[n] = function (arg) { window.__wywolania.push([n, arg]); };
    });
  });
  await page.goto('file://' + HTML);
  var widac = function (id) { var e = document.getElementById(id); return !!e && e.offsetParent !== null; };
  var opis = function (klucz) { return dane.init.opisy.filter(function (o) { return o.klucz === klucz; })[0]; };

  // ---- start w układzie nowym ----
  sprawdz(dane.init.uklad === 'kroki', 'układ nowy fabrycznie (' + dane.init.uklad + ')');
  await page.evaluate(function (d) { AMGW.init(d); }, dane.init);
  var st = await page.evaluate(function (widacTekst) {
    var widac = eval('(' + widacTekst + ')');
    return { klasa: document.body.className, kroki: document.querySelectorAll('#kroki button').length,
             wybrany: document.querySelector('#kroki button.wybrany').getAttribute('data-krok'),
             prawa: Array.prototype.map.call(document.querySelectorAll('#prawa > .karta'), function (k) { return k.id; }).join(','),
             lewa: Array.prototype.map.call(document.querySelectorAll('#krok-karty > .karta'), function (k) { return k.id; }).join(','),
             przyklejona: getComputedStyle(document.getElementById('prawa')).position,
             stare: [widac('zakladki'), widac('btn-tryb-podstawowe'), widac('lista-ostrzezen')].join(','),
             wynikGora: document.getElementById('karta-wynik').getBoundingClientRect().top,
             rzutGora: document.getElementById('karta-rzut').getBoundingClientRect().top,
             wysokosc: document.documentElement.scrollHeight };
  }, widac.toString());
  sprawdz(/uklad-kroki/.test(st.klasa) && st.kroki === 6 && st.wybrany === 'sciany', 'sześć kroków, pierwszy wybrany (' + st.kroki + ', ' + st.wybrany + ')');
  sprawdz(st.prawa === 'karta-rzut,karta-wynik' && st.przyklejona === 'sticky', 'po prawej stale rzut i wynik, kolumna przyklejona (' + st.prawa + ', ' + st.przyklejona + ')');
  sprawdz(st.lewa === 'karta-widok,karta-otwory,karta-dzialowe,karta-wegly-przesun,karta-wegly,karta-zestawienie', 'pozostałe karty pod polami kroku (' + st.lewa + ')');
  sprawdz(st.stare === 'false,false,false', 'zakładki, tryb Podstawowe / Wszystkie i dawne listy uwag schowane (' + st.stare + ')');
  sprawdz(st.rzutGora < 200 && st.wynikGora < 860, 'rzut i wynik widoczne bez przewijania (rzut ' + Math.round(st.rzutGora) + ' px, wynik ' + Math.round(st.wynikGora) + ' px)');
  sprawdz(st.wysokosc < 3000, 'krok „Ściany” krótszy niż dawne 5239 px przewijania (' + st.wysokosc + ' px)');

  // ---- poziomy pól w kroku ----
  var pz = await page.evaluate(function (widacTekst) {
    var widac = eval('(' + widacTekst + ')');
    return { dom: widac('p-liczba_wiencow'), typ: widac('p-ostatek'), standard: widac('p-max_dlugosc'), inny: widac('p-dach_kat'),
             zamek: widac('pola-zamek'), przyciskTypu: document.getElementById('btn-pola-typu').textContent,
             doWyboru: document.querySelectorAll('#pole-standardu option').length,
             widoczne: Array.prototype.filter.call(document.querySelectorAll('#sekcje [data-klucz]'), function (p) { return p.offsetParent !== null; }).length };
  }, widac.toString());
  sprawdz(pz.dom && !pz.typ && !pz.standard && !pz.inny && !pz.zamek, 'krok „Ściany”: pola domu widoczne; pola typu, standardu i innych kroków schowane');
  sprawdz(/Pola typu domu w tym kroku \(\d+\)/.test(pz.przyciskTypu) && pz.doWyboru > 20, 'przycisk pól typu i lista pól standardu do zmiany w tym domu (' + pz.przyciskTypu + ', ' + pz.doWyboru + ')');
  sprawdz(pz.widoczne >= 2 && pz.widoczne <= 8, 'w kroku widać tylko kilka pól domu (' + pz.widoczne + ')');
  await page.click('#btn-pola-typu');
  var pt = await page.evaluate(function (widacTekst) {
    var widac = eval('(' + widacTekst + ')');
    return [widac('p-ostatek'), widac('p-max_dlugosc'), document.getElementById('z-poziom-ostatek').textContent, document.getElementById('btn-pola-typu').textContent];
  }, widac.toString());
  sprawdz(pt[0] && !pt[1] && pt[2] === 'typ' && /Ukryj pola typu/.test(pt[3]), 'po rozwinięciu – pola typu ze znacznikiem „typ”, standard dalej schowany (' + pt.join(' | ') + ')');
  await page.click('#btn-pola-typu');

  // ---- pole standardu tylko w tym domu ----
  await page.selectOption('#pole-standardu', 'mijanka');
  var ps = await page.evaluate(function (widacTekst) {
    var widac = eval('(' + widacTekst + ')');
    return [widac('p-mijanka'), document.activeElement.id, document.getElementById('z-poziom-mijanka').textContent];
  }, widac.toString());
  sprawdz(ps[0] && ps[1] === 'p-mijanka' && ps[2] === 'standard', 'wybrane pole standardu pojawia się w kroku i dostaje kursor (' + ps.join(' | ') + ')');
  var bazowa = String(dane.init.typy.baza.mijanka);
  await page.fill('#p-mijanka', '450');
  await page.dispatchEvent('#p-mijanka', 'change');
  var pd = await page.evaluate(function () {
    return [document.getElementById('l-mijanka').className, document.getElementById('z-poziom-mijanka').textContent, !!document.getElementById('r-mijanka'),
            document.getElementById('typ-zmiany').textContent];
  });
  sprawdz(/wdomu/.test(pd[0]) && /tylko w tym domu/.test(pd[1]) && pd[2] && /pola standardu 1/.test(pd[3]), 'zmienione pole standardu oznaczone „tylko w tym domu” z przyciskiem powrotu (' + pd.join(' | ') + ')');
  await page.click('#r-mijanka');
  pd = await page.evaluate(function () {
    return [document.getElementById('p-mijanka').value, document.getElementById('l-mijanka').className, !!document.getElementById('r-mijanka')];
  });
  sprawdz(Number(pd[0]) === Number(bazowa) && !/wdomu/.test(pd[1]) && !pd[2], 'przycisk powrotu – wartość ze standardu (' + pd.join(' | ') + ')');

  // ---- wynik: lista uwag, znaczniki kroków, kliknięcie uwagi ----
  await page.evaluate(function (d) { AMGW.wynik(d); }, dane.wynik);
  var zle = dane.wynik.uwagi.filter(function (u) { return u.poziom !== 'ok'; });
  var dobre = dane.wynik.uwagi.filter(function (u) { return u.poziom === 'ok'; });
  var uw = await page.evaluate(function () {
    return { zle: document.querySelectorAll('#uwagi-zle li').length, dobre: document.querySelectorAll('#uwagi-dobre li').length,
             tytul: (document.getElementById('uwagi-zle-tytul') || {}).textContent,
             znaczniki: Array.prototype.map.call(document.querySelectorAll('#kroki .stan'), function (z) { return z.textContent; }),
             powierzchnie: document.querySelectorAll('#tab-powierzchnie tbody tr').length, liczby: document.getElementById('liczby').textContent };
  });
  sprawdz(uw.zle === zle.length && uw.dobre === dobre.length && zle.length > 0 && dobre.length > 0, 'lista „Do poprawy” (' + uw.zle + ') i „Sprawdzone” (' + uw.dobre + ')');
  var sumaZnacznikow = uw.znaczniki.reduce(function (s, z) { return s + (z === '✓' ? 0 : Number(z)); }, 0);
  sprawdz(uw.znaczniki.length === 6 && sumaZnacznikow === zle.length && uw.znaczniki.indexOf('✓') >= 0, 'znaczniki stanu kroków: liczba uwag albo ✓ (' + uw.znaczniki.join(' ') + ')');
  sprawdz(uw.powierzchnie === dane.wynik.powierzchnie.length && /Powierzchnia zabudowy: 31,5 m²/.test(uw.liczby) && /Wysokość nad terenem/.test(uw.liczby),
          'powierzchnie i wysokość w wyniku i w zestawieniu (' + uw.powierzchnie + ' wierszy)');
  var zPolem = zle.filter(function (u) { return u.klucz && u.krok !== 'sciany'; })[0] || dobre.filter(function (u) { return u.klucz && u.krok !== 'sciany'; })[0];
  sprawdz(!!zPolem, 'jest uwaga prowadząca do pola w innym kroku');
  if (zPolem) {
    if (zPolem.poziom === 'ok') { await page.evaluate(function () { document.getElementById('uwagi-dobre-box').open = true; }); }
    var nr = (zPolem.poziom === 'ok' ? dobre : zle.slice().sort(function (a, b) { var k = { blad: 0, ostrzezenie: 1, uwaga: 2 }; return k[a.poziom] - k[b.poziom]; })).indexOf(zPolem);
    await page.click((zPolem.poziom === 'ok' ? '#uwagi-dobre' : '#uwagi-zle') + ' li:nth-child(' + (nr + 1) + ')');
    var po = await page.evaluate(function () {
      return [document.querySelector('#kroki button.wybrany').getAttribute('data-krok'), document.activeElement.id];
    });
    sprawdz(po[0] === zPolem.krok && po[1] === 'p-' + zPolem.klucz, 'kliknięcie uwagi przenosi do pola: krok ' + po[0] + ', pole ' + po[1] + ' (oczekiwane ' + zPolem.krok + ', p-' + zPolem.klucz + ')');
  }

  // ---- kroki i ich karty ----
  var kartyKrokow = {};
  var kroki = ['sciany', 'otwory', 'dach', 'taras', 'podloga', 'zestawienie'];
  for (var i = 0; i < kroki.length; i++) {
    await page.click('#krok-' + kroki[i]);
    kartyKrokow[kroki[i]] = await page.evaluate(function () {
      return Array.prototype.filter.call(document.querySelectorAll('#krok-karty > .karta'), function (k) { return k.offsetParent !== null; }).map(function (k) { return k.id; }).join(',');
    });
  }
  sprawdz(kartyKrokow.sciany === 'karta-widok,karta-wegly-przesun,karta-wegly' && kartyKrokow.otwory === 'karta-widok,karta-otwory' &&
          kartyKrokow.dach === '' && kartyKrokow.zestawienie === 'karta-zestawienie', 'karty w swoich krokach: ' + JSON.stringify(kartyKrokow));
  var zest = await page.evaluate(function () {
    return [document.querySelectorAll('#tab-lista tbody tr').length, document.querySelectorAll('#tab-materialy tbody tr').length,
            document.querySelectorAll('#tab-sciany tbody tr').length];
  });
  sprawdz(zest[0] === dane.wynik.lista.length && zest[1] === dane.wynik.materialy.length && zest[2] === dane.wynik.sciany.length,
          'krok „Zestawienie”: lista bali, materiały i tabela ścian (' + zest.join(', ') + ')');
  await page.click('#krok-dach');
  var dk = await page.evaluate(function (widacTekst) {
    var widac = eval('(' + widacTekst + ')');
    return [widac('p-dach_kat'), widac('p-liczba_wiencow'), widac('p-dach_rodzaj')];
  }, widac.toString());
  sprawdz(dk[0] && !dk[1] && !dk[2], 'krok „Dach”: kąt dachu (ten dom) widoczny, rodzaj dachu (typ) schowany do rozwinięcia');

  // ---- podpowiedź po wejściu w pole ----
  var zPodp = 'dach_kat';
  sprawdz(!!opis(zPodp).podpowiedz, 'pole z podpowiedzią do testu');
  var przed = await page.evaluate(function (id) { return document.getElementById(id).offsetParent !== null; }, 'h-' + zPodp);
  await page.focus('#p-' + zPodp);
  var w = await page.evaluate(function (id) { var h = document.getElementById(id); return [h.offsetParent !== null, h.className]; }, 'h-' + zPodp);
  await page.focus('#p-dach_okap');
  var potem = await page.evaluate(function (id) { return document.getElementById(id).offsetParent !== null; }, 'h-' + zPodp);
  sprawdz(!przed && w[0] && /aktywna/.test(w[1]) && !potem, 'podpowiedź widać tylko po wejściu w pole (' + [przed, w[0], potem].join(', ') + ')');
  await page.screenshot({ path: path.join(KAT, 'testy', 'wyniki', 'okno_kroki.png') });

  // ---- panel „Standard warsztatu” ----
  // W tym domu „Maksymalna długość bala” zmieniona na 5000 – po zapisie standardu ma zostać.
  await page.click('#krok-sciany');
  await page.selectOption('#pole-standardu', 'max_dlugosc');
  await page.fill('#p-max_dlugosc', '5000');
  await page.dispatchEvent('#p-max_dlugosc', 'change');
  await page.click('#btn-standard');
  var liczbaStandardu = dane.init.opisy.filter(function (o) { return o.poziom === 'standard'; }).length;
  var sp = await page.evaluate(function () {
    return [document.getElementById('standard').className, document.querySelectorAll('[data-standard]').length,
            document.querySelectorAll('[data-standard-zamek]').length, document.getElementById('s-max_dlugosc').value];
  });
  sprawdz(sp[0] === 'panel-standard' && sp[1] === liczbaStandardu && sp[2] === dane.init.opisy_zamka.length,
          'panel standardu: pole na każde pole poziomu standard (' + sp[1] + ') i wymiary zamka (' + sp[2] + ')');
  sprawdz(Number(sp[3]) === Number(dane.init.typy.baza.max_dlugosc), 'panel pokazuje bieżący standard, nie wartość tego domu (' + sp[3] + ')');
  await page.fill('#standard-szukaj', 'mijanka');
  var sz = await page.evaluate(function () {
    return Array.prototype.filter.call(document.querySelectorAll('[data-standard]'), function (p) { return p.offsetParent !== null; }).map(function (p) { return p.id; }).join(',');
  });
  sprawdz(sz === 's-mijanka', 'szukanie zostawia pasujące pole (' + sz + ')');
  await page.screenshot({ path: path.join(KAT, 'testy', 'wyniki', 'okno_standard.png') });
  await page.fill('#s-mijanka', '500');
  await page.dispatchEvent('#s-mijanka', 'change');
  // Lista typowej stolarki – pole-tabela w panelu (runda 17): wiersze z listy, nowy wiersz, wartość w ukrytym polu.
  await page.fill('#standard-szukaj', '');
  var tw = await page.evaluate(function () {
    var t = document.getElementById('t-stolarka');
    return t ? t.querySelectorAll('tbody tr').length : -1;
  });
  sprawdz(tw === 2, 'lista typowej stolarki w panelu standardu – tabela z dwoma wierszami (' + tw + ')');
  await page.click('#tw-stolarka');
  await page.evaluate(function () {
    var r = document.querySelectorAll('#t-stolarka tbody tr')[2];
    var ustaw = function (k, v) { var p = r.querySelector('[data-kol="' + k + '"]'); p.value = v; p.dispatchEvent(new Event('change')); };
    ustaw('symbol', 'O2'); ustaw('szerokosc', '600'); ustaw('wysokosc', '600'); ustaw('spod', '1300');
  });
  var tl = await page.evaluate(function () {
    return [JSON.parse(document.getElementById('s-stolarka').value).length, document.getElementById('sl-stolarka').className];
  });
  sprawdz(tl[0] === 3 && /zmieniony/.test(tl[1]), 'nowy wiersz listy w ukrytym polu, pole oznaczone jako zmienione (' + tl.join(' | ') + ')');
  await page.evaluate(function () { window.__wywolania = []; });
  await page.click('#btn-standard-zapisz');
  var ws = await page.evaluate(function () { return window.__wywolania; });
  var zap = ws.length === 1 && ws[0][0] === 'standard_zapisz' ? JSON.parse(ws[0][1]) : {};
  sprawdz(zap.parametry && zap.parametry.mijanka === '500' && zap.parametry.zamek && zap.typ === dane.init.typy.typ && zap.parametry.liczba_wiencow === undefined,
          'zapis standardu: pola standardu z wymiarami zamka i nazwą typu, bez pól domu');
  sprawdz(zap.parametry && JSON.parse(zap.parametry.stolarka).length === 3 && JSON.parse(zap.parametry.stolarka)[2].symbol === 'O2',
          'zapis standardu z listą stolarki (tekst JSON)');
  // Odpowiedź Ruby: nowy standard (mijanka 500, najdłuższy bal 6500).
  var nowaBaza = JSON.parse(JSON.stringify(dane.init.typy.baza));
  nowaBaza.mijanka = 500;
  nowaBaza.max_dlugosc = 6500;
  await page.evaluate(function (d) { AMGW.typy(d); }, { lista: dane.init.typy.lista, typ: dane.init.typy.typ, baza: nowaBaza, standard: true, komunikat: 'Zapisano standard warsztatu.' });
  var pn = await page.evaluate(function () {
    return [document.getElementById('standard').className, document.getElementById('p-mijanka').value, document.getElementById('p-max_dlugosc').value,
            document.getElementById('l-max_dlugosc').className, document.getElementById('typ-komunikat').textContent];
  });
  sprawdz(/ukryty/.test(pn[0]) && pn[1] === '500' && pn[2] === '5000' && /wdomu/.test(pn[3]) && /Zapisano standard/.test(pn[4]),
          'po zapisie standardu: panel zamknięty, pole bez zmian w domu dostaje nową wartość, pole zmienione w tym domu zostaje (' + pn.join(' | ') + ')');

  // ---- typ: wczytanie pól typu i domu, przywrócenie ----
  var bazaTypu = JSON.parse(JSON.stringify(nowaBaza));
  bazaTypu.liczba_wiencow = 20;
  bazaTypu.taras = 'podciag';
  await page.evaluate(function (d) { AMGW.typy(d); }, { lista: dane.init.typy.lista, typ: dane.init.typy.lista[1].nazwa, baza: bazaTypu, wczytaj: true, komunikat: 'Typ 200' });
  var tp = await page.evaluate(function () {
    return [document.getElementById('p-liczba_wiencow').value, document.getElementById('p-taras').value, document.getElementById('p-max_dlugosc').value,
            document.getElementById('typ').value, document.getElementById('btn-typ-zapisz').disabled];
  });
  sprawdz(tp[0] === '20' && tp[1] === 'podciag' && tp[2] === '5000' && tp[3] === dane.init.typy.lista[1].nazwa && tp[4] === true,
          'wybór typu: pola typu i domu z typu, pole standardu zmienione w domu zostaje, typ wbudowany bez „Zapisz zmiany” (' + tp.join(' | ') + ')');
  await page.click('#btn-typ-przywroc');
  var tprz = await page.evaluate(function () { return [document.getElementById('p-max_dlugosc').value, document.querySelectorAll('label.wdomu').length]; });
  sprawdz(Number(tprz[0]) === 6500 && tprz[1] === 0, '„Przywróć typ” – wszystkie pola według typu i standardu (' + tprz.join(' | ') + ')');

  // ---- opcje niedostępne dla obrysu ----
  await page.evaluate(function () { window.__wywolania = []; });
  var wynikL = JSON.parse(JSON.stringify(dane.wynik));
  wynikL.obrys_rodzaj = 'l';
  await page.evaluate(function (d) { AMGW.wynik(d); }, wynikL);
  await page.waitForTimeout(500);
  var ob = await page.evaluate(function () {
    var sel = document.getElementById('p-taras');
    return [sel.value, Array.prototype.filter.call(sel.options, function (o) { return o.disabled; }).length, sel.options.length,
            (document.getElementById('n-taras') || {}).textContent, sel.options[1].textContent,
            window.__wywolania.filter(function (x) { return x[0] === 'podglad'; }).length];
  });
  sprawdz(ob[0] === 'nie' && ob[1] === ob[2] - 1 && /prostokątnym/.test(ob[3]) && /niedostępne/.test(ob[4]) && ob[5] === 1,
          'obrys L: taras przestawiony na „bez”, pozostałe wybory wyszarzone z powodem, nowy podgląd (' + ob.join(' | ') + ')');
  await page.evaluate(function (d) { AMGW.wynik(d); }, dane.wynik);
  ob = await page.evaluate(function () {
    var sel = document.getElementById('p-taras');
    return [Array.prototype.filter.call(sel.options, function (o) { return o.disabled; }).length, !!document.getElementById('n-taras'), sel.options[1].textContent];
  });
  sprawdz(ob[0] === 0 && !ob[1] && !/niedostępne/.test(ob[2]), 'obrys prostokątny: wszystkie wybory tarasu dostępne');

  // ---- przełącznik układu ----
  await page.evaluate(function () { window.__wywolania = []; });
  await page.click('#btn-uklad-zakladki');
  var uk = await page.evaluate(function (widacTekst) {
    var widac = eval('(' + widacTekst + ')');
    return [document.body.className, document.querySelectorAll('#prawa > .karta').length, widac('btn-tryb-podstawowe'), widac('kroki'), widac('uwagi'),
            widac('lista-ostrzezen') || widac('lista-podpowiedzi'), widac('karta-typy'), window.__wywolania.map(function (x) { return x.join(':'); }).join(',')];
  }, widac.toString());
  sprawdz(/uklad-zakladki/.test(uk[0]) && uk[1] === 8 && uk[2] && !uk[3] && !uk[4] && uk[5] && uk[6] && uk[7] === 'uklad:zakladki',
          'układ dotychczasowy: wszystkie karty po prawej, tryb pól, dawne listy; typ domu zostaje; wybór zapamiętany (' + uk.join(' | ') + ')');
  await page.click('#btn-uklad-kroki');
  uk = await page.evaluate(function () { return [document.body.className, document.querySelectorAll('#prawa > .karta').length, document.querySelectorAll('#krok-karty > .karta').length]; });
  sprawdz(/uklad-kroki/.test(uk[0]) && uk[1] === 2 && uk[2] === 6, 'powrót do układu nowego (' + uk.join(' | ') + ')');

  // ---- dom z wymiarów ----
  var initWym = JSON.parse(JSON.stringify(dane.init));
  initWym.z_wymiarow = true;
  initWym.otwory = [];
  await page.evaluate(function (d) { AMGW.init(d); }, initWym);
  var wym = await page.evaluate(function (widacTekst) {
    var widac = eval('(' + widacTekst + ')');
    return [widac('p-dom_dlugosc'), widac('p-dom_szerokosc'), document.getElementById('p-dom_dlugosc').value, JSON.parse(AMGW._zbierz()).parametry.dom_szerokosc];
  }, widac.toString());
  sprawdz(wym[0] && wym[1] && wym[2] === '6000' && wym[3] === '4000', 'dom z wymiarów: pola długości i szerokości w kroku „Ściany” (' + wym.join(' | ') + ')');
  await page.click('#krok-sciany');
  await page.click('#btn-dzialowa');
  await page.waitForTimeout(500);
  var dzw = await page.evaluate(function (widacTekst) {
    var widac = eval('(' + widacTekst + ')');
    var pg = window.__wywolania.filter(function (x) { return x[0] === 'podglad'; });
    return [widac('karta-dzialowe'), pg.length ? JSON.stringify(JSON.parse(pg[pg.length - 1][1]).dzialowe) : ''];
  }, widac.toString());
  sprawdz(dzw[0] && dzw[1] === '[{"kierunek":"poprzek","od":"3000","poczatek":"","dlugosc":""}]',
          'dom z wymiarów: tabela działowych w kroku „Ściany”, nowa działowa na środku w danych podglądu (' + dzw.join(' | ') + ')');

  // Kliknięcie w przycisk tuż po wpisaniu wartości: przebudowa okna czeka na puszczenie przycisku myszy – kliknięcie trafia.
  await page.evaluate(function () { window.__wywolania = []; });
  await page.fill('#p-dom_dlugosc', '8000');
  await page.click('#krok-dach');
  await page.waitForTimeout(700);
  var pok = await page.evaluate(function () {
    var pg = window.__wywolania.filter(function (x) { return x[0] === 'podglad'; });
    return [document.getElementById('krok-dach').className, pg.length ? JSON.parse(pg[pg.length - 1][1]).parametry.dom_dlugosc : ''];
  });
  sprawdz(/wybrany/.test(pok[0]) && pok[1] === '8000', 'kliknięcie kroku zaraz po wpisaniu wartości działa za pierwszym razem (' + pok.join(' | ') + ')');

  // ---- okno samego standardu (menu „Standard warsztatu…”, runda 17) ----
  var ps = await browser.newPage({ viewport: { width: 1060, height: 860 } });
  ps.on('pageerror', function (e) { konsola.push(String(e)); });
  await ps.addInitScript(function () {
    window.__wywolania = [];
    window.sketchup = new Proxy({}, { get: function (_t, n) { return function (arg) { window.__wywolania.push([n, arg]); }; } });
  });
  await ps.goto('file://' + HTML);
  var initStd = JSON.parse(JSON.stringify(dane.init));
  initStd.tryb = 'standard';
  initStd.parametry = {};
  initStd.otwory = [];
  initStd.podsumowanie = null;
  await ps.evaluate(function (d) { window.__wywolania = []; AMGW.init(d); }, initStd);
  await ps.waitForTimeout(500);
  var so = await ps.evaluate(function (widacTekst) {
    var widac = eval('(' + widacTekst + ')');
    return [/tylko-standard/.test(document.body.className), widac('standard-pola'), widac('btn-generuj'), widac('karta-rzut'),
            document.querySelectorAll('#standard-pola [data-standard]').length,
            window.__wywolania.filter(function (x) { return x[0] === 'podglad'; }).length];
  }, widac.toString());
  sprawdz(so[0] && so[1] && !so[2] && !so[3] && so[4] > 50 && so[5] === 0,
          'okno z menu: sam panel standardu, bez domu, przycisków generowania i podglądu (' + so.join(' | ') + ')');
  await ps.fill('#s-max_dlugosc', '5400');
  await ps.click('#btn-standard-zapisz');
  var zap = await ps.evaluate(function () { return window.__wywolania.filter(function (x) { return x[0] === 'standard_zapisz'; }).map(function (x) { return JSON.parse(x[1]).parametry.max_dlugosc; }); });
  var bazaStd = JSON.parse(JSON.stringify(initStd.typy.baza));
  bazaStd.max_dlugosc = 5400;
  await ps.evaluate(function (x) { AMGW.typy({ lista: x.lista, typ: AMGW_TYPY.typ(), baza: x.baza, standard: true, komunikat: 'Zapisano standard warsztatu.' }); },
                    { lista: initStd.typy.lista, baza: bazaStd });
  var po = await ps.evaluate(function () {
    return [document.getElementById('standard').className, document.getElementById('standard-komunikat').textContent, document.getElementById('s-max_dlugosc').value,
            window.__wywolania.filter(function (x) { return x[0] === 'podglad'; }).length];
  });
  sprawdz(zap.join() === '5400' && !/ukryty/.test(po[0]) && /Zapisano/.test(po[1]) && po[2] === '5400' && po[3] === 0,
          'zapis standardu w oknie z menu: panel zostaje otwarty z komunikatem i nową wartością (' + zap.join() + ' | ' + po.join(' | ') + ')');
  await ps.click('#btn-standard-zamknij');
  var zam = await ps.evaluate(function () { return window.__wywolania.filter(function (x) { return x[0] === 'zamknij'; }).length; });
  sprawdz(zam === 1, '„Zamknij” w oknie z menu zamyka całe okno');
  await ps.close();

  sprawdz(konsola.length === 0, 'brak błędów JavaScriptu: ' + konsola.join(' ; '));
  await browser.close();
  console.log('OK: ' + ok);
  console.log('FAILURES: ' + bledy);
  process.exit(bledy ? 1 : 0);
}());
