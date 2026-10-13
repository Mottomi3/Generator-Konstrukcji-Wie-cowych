/*
  ArteMadera – Generator Wieńcowy – testy
  Plik: testy/t_okno.js
  Zadanie: okno parametrów w Chromium (Playwright) – formularz z opisów, rzut, tabela otworów, wywołania sketchup.*, wyniki.
  Tematy: test okna, Playwright, formularz, wywołania Ruby, zrzut okna
  Zależy od: testy/okno_dane.rb, Plugins/.../html/okno.html
  Używają: testy/uruchom.sh

  Uruchomienie: node testy/t_okno.js – ostatnia linia „FAILURES: n”; zrzut: testy/wyniki/okno.png.
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
  var page = await browser.newPage({ viewport: { width: 1000, height: 900 } });
  var konsola = [];
  page.on('pageerror', function (e) { konsola.push(String(e)); });
  page.on('console', function (m) { if (m.type() === 'error') { konsola.push(m.text()); } });
  await page.addInitScript(function () {
    window.__wywolania = [];
    window.sketchup = {};
    ['gotowe', 'podglad', 'generuj', 'zamknij', 'blad_js'].forEach(function (n) {
      window.sketchup[n] = function (arg) { window.__wywolania.push([n, arg]); };
    });
  });
  await page.goto('file://' + HTML);
  var w = await page.evaluate(function () { return window.__wywolania; });
  sprawdz(w.length === 1 && w[0][0] === 'gotowe', 'okno woła gotowe po wczytaniu');

  await page.evaluate(function (d) { AMGW.init(d); }, dane.init);
  var liczbaPol = await page.evaluate(function () { return document.querySelectorAll('[data-klucz]').length; });
  sprawdz(liczbaPol === dane.init.opisy.length, 'pole na każdy parametr (' + liczbaPol + ')');
  var liczbaZamka = await page.evaluate(function () { return document.querySelectorAll('[data-zamek]').length; });
  sprawdz(liczbaZamka === dane.init.opisy_zamka.length, 'pola wymiarów zamka (' + liczbaZamka + ')');
  var etykiety = await page.evaluate(function () {
    return Array.prototype.map.call(document.querySelectorAll('#rzut text'), function (t) { return t.textContent; });
  });
  sprawdz(etykiety.indexOf('W-1') >= 0 && etykiety.indexOf('W-5') >= 0, 'rzut z opisami ścian');
  var wiersze = await page.evaluate(function () { return document.querySelectorAll('#tab-sciany tbody tr').length; });
  sprawdz(wiersze === dane.init.podsumowanie.sciany.length, 'tabela ścian');

  await page.evaluate(function () { window.__wywolania = []; });
  await page.click('#btn-okno');
  await page.waitForTimeout(500);
  w = await page.evaluate(function () { return window.__wywolania; });
  var pg = w.filter(function (x) { return x[0] === 'podglad'; });
  sprawdz(pg.length === 1, 'dodanie okna uruchamia podgląd');
  var d = JSON.parse(pg[0][1]);
  sprawdz(d.otwory.length === 1 && d.otwory[0].sciana === 'W-1' && d.otwory[0].szerokosc === '1020', 'otwór w danych podglądu');
  sprawdz(d.parametry.zamek && d.parametry.zamek.krycie === '139', 'wymiary zamka w danych');
  var opcje = await page.evaluate(function () {
    return Array.prototype.map.call(document.querySelectorAll('#tab-otwory select option'), function (o) { return o.value; });
  });
  sprawdz(opcje.indexOf('W-6') < 0 && opcje.indexOf('W-5') >= 0, 'lista ścian otworu bez kontrforów');

  await page.evaluate(function () { window.__wywolania = []; });
  await page.fill('#p-liczba_wiencow', '14');
  await page.dispatchEvent('#p-liczba_wiencow', 'change');
  await page.waitForTimeout(500);
  w = await page.evaluate(function () { return window.__wywolania; });
  pg = w.filter(function (x) { return x[0] === 'podglad'; });
  sprawdz(pg.length === 1 && JSON.parse(pg[0][1]).parametry.liczba_wiencow === '14', 'zmiana pola → podgląd z nową wartością');

  await page.evaluate(function (d) { AMGW.wynik(d); }, dane.wynik);
  var niebieskie = await page.evaluate(function () { return document.querySelectorAll('#rzut line[stroke="#4a90c2"]').length; });
  sprawdz(niebieskie === 1, 'otwór na rzucie');
  var lista = await page.evaluate(function () { return document.querySelectorAll('#tab-lista tbody tr').length; });
  sprawdz(lista === dane.wynik.lista.length, 'lista bali');

  await page.evaluate(function () { AMGW.wynik({ bledy: ['Nie znaleziono zamkniętego obrysu'], ostrzezenia: [], rzut: null }); });
  var kom = await page.evaluate(function () { return document.getElementById('komunikat').className; });
  sprawdz(kom.indexOf('blad') >= 0, 'komunikat o błędzie');

  await page.evaluate(function (d) { var x = JSON.parse(JSON.stringify(d)); x.zbudowano = true; AMGW.wynik(x); }, dane.wynik);
  kom = await page.evaluate(function () { return [document.getElementById('komunikat').className, document.getElementById('btn-generuj').textContent]; });
  sprawdz(kom[0].indexOf('ok') >= 0 && kom[1] === 'Zastąp dom w modelu', 'komunikat po generowaniu');

  await page.evaluate(function () { window.__wywolania = []; });
  await page.click('#btn-generuj');
  w = await page.evaluate(function () { return window.__wywolania; });
  sprawdz(w.length === 1 && w[0][0] === 'generuj', 'przycisk Generuj woła generuj');

  fs.mkdirSync(path.join(KAT, 'testy', 'wyniki'), { recursive: true });
  await page.evaluate(function (d) { AMGW.wynik(d); }, dane.wynik);
  await page.screenshot({ path: path.join(KAT, 'testy', 'wyniki', 'okno.png'), fullPage: true });
  sprawdz(konsola.length === 0, 'bez błędów JavaScript (' + konsola.join(' | ') + ')');
  await browser.close();
  console.log('OK: ' + ok);
  console.log('FAILURES: ' + bledy);
  process.exit(bledy ? 1 : 0);
}()).catch(function (e) { console.log('BŁĄD ' + e); console.log('FAILURES: 1'); process.exit(1); });
