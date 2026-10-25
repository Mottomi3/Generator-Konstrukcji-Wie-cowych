/*
  ArteMadera – Generator Wieńcowy
  Plik: html/okno.js
  Zadanie: logika okna parametrów – sekcje i pola z listy parametrów, podpowiedzi, szablony, wywołania Ruby.
  Tematy: formularz parametrów, sekcje pól, podpowiedzi pól, szablony w oknie, przywróć fabryczne, wymiary zamka w oknie, komunikaty w oknie, podgląd automatyczny, wybór ściany do widoku, przełącznik pól podstawowe / wszystkie
  Zależy od: html/okno.html, html/okno.css, html/wspolne.js (AMGW_DOM), html/wyniki.js (AMGW_WYNIKI.pokaz), html/sciana.js (AMGW_SCIANA), html/zmiany.js (AMGW_ZMIANY), html/tryb.js (AMGW_TRYB), html/edycja.js (AMGW_EDYCJA), html/otwory.js (AMGW_OTWORY – tabela okien i drzwi)
  Używają: sketchup/okno.rb (AMGW.init, AMGW.wynik, AMGW.ustaw, AMGW.szablony, AMGW.widok, AMGW.komunikat)

  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
  Pole nowego parametru pojawia się samo w swojej sekcji (ParametryLista w Ruby: sekcja, wybory, podpowiedź).
*/
var AMGW = (function () {
  'use strict';

  var stan = { opisy: [], sekcje: [], presety: {}, opisyZamka: [], sciany: [], timer: null, otwarte: {}, widok: '' };

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;
  var fmt = AMGW_DOM.fmt;

  // Wywołanie Ruby (window.sketchup.nazwa) – poza SketchUpem nic nie robi.
  function wywolaj(nazwa, dane) {
    if (window.sketchup && typeof window.sketchup[nazwa] === 'function') {
      window.sketchup[nazwa](dane === undefined ? '' : dane);
    }
  }

  // ---- formularz ----

  // Sekcje formularza (rozwijane) z listy sekcji; zachowuje rozwinięcie przy przebudowie.
  function zbudujSekcje() {
    var box = $('sekcje');
    var i;
    var stare = box.querySelectorAll('details');
    for (i = 0; i < stare.length; i++) { stan.otwarte[stare[i].getAttribute('data-sekcja')] = stare[i].open; }
    wyczysc(box);
    for (i = 0; i < stan.sekcje.length; i++) {
      var s = stan.sekcje[i];
      var det = el('details', { id: 'sekcja-' + s.klucz, 'data-sekcja': s.klucz });
      det.open = stan.otwarte[s.klucz] !== undefined ? stan.otwarte[s.klucz] : !!s.otwarta;
      det.appendChild(el('summary', { 'data-tytul': s.tytul }, s.tytul));
      det.appendChild(el('div', { id: 'pola-' + s.klucz, 'class': 'pola' }));
      if (s.klucz === 'przekroj') { det.appendChild(el('div', { id: 'pola-zamek', 'class': 'pola' })); }
      if (s.klucz === 'sciany') { det.appendChild(el('div', { id: 'wysokosci', 'class': 'wysokosci' })); }
      box.appendChild(det);
    }
  }

  // Formularz: sekcje, pole na każdy parametr (z podpowiedzią) i wymiary zamka.
  function zbudujFormularz(parametry) {
    var i;
    zbudujSekcje();
    for (i = 0; i < stan.opisy.length; i++) {
      dodajPole(stan.opisy[i], parametry);
    }
    zbudujZamek(parametry);
    AMGW_ZMIANY.oznacz(stan.opisy);
    AMGW_TRYB.zastosuj(stan.opisy);
  }

  // Jedno pole parametru w swojej sekcji (lista wyboru, liczba, przekrój albo tekst) i podpowiedź pod nim.
  function dodajPole(opis, parametry) {
    var sekcja = $('pola-' + opis.sekcja) || $('pola-rysunek');
    var wartosc = parametry[opis.klucz] !== undefined && parametry[opis.klucz] !== null ? parametry[opis.klucz] : opis.domyslna;
    var etykieta = el('label', { 'for': 'p-' + opis.klucz, id: 'l-' + opis.klucz }, opis.etykieta);
    var pole;
    var lista;
    var j;
    if (opis.rodzaj === 'wybor') {
      etykieta.className = 'pelny';
      sekcja.appendChild(etykieta);
      pole = el('select', { id: 'p-' + opis.klucz, 'data-klucz': opis.klucz });
      lista = opis.wybory || [];
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
      if (opis.rodzaj === 'tekst') { etykieta.className = 'pelny'; }
      sekcja.appendChild(etykieta);
      pole = el('input', { id: 'p-' + opis.klucz, 'data-klucz': opis.klucz, type: 'text' });
      if (opis.rodzaj === 'tekst') {
        pole.className = 'pelny';
        pole.value = String(wartosc);
      } else if (opis.rodzaj === 'przekroj') {
        pole.value = String(wartosc);
        pole.title = 'szerokość × wysokość, np. 50x150';
      } else {
        pole.setAttribute('inputmode', 'decimal');
        pole.value = fmt(wartosc);
        if (opis.min !== null && opis.max !== null) { pole.title = 'od ' + fmt(opis.min) + ' do ' + fmt(opis.max); }
      }
    }
    pole.addEventListener('change', function () { AMGW_ZMIANY.oznacz(stan.opisy); zaplanujPodglad(); });
    sekcja.appendChild(pole);
    if (opis.podpowiedz) { sekcja.appendChild(el('div', { 'class': 'podp', id: 'h-' + opis.klucz }, opis.podpowiedz)); }
  }

  // Wartość pola parametru z formularza (gdy brak pola – domyślna).
  function wartoscPola(klucz, domyslna) {
    var e = $('p-' + klucz);
    return e ? e.value : domyslna;
  }

  // ---- szablony ----

  // Lista szablonów w polu wyboru.
  function wypelnijSzablony(lista) {
    var sel = $('szablon');
    var i;
    wyczysc(sel);
    for (i = 0; i < (lista || []).length; i++) { sel.appendChild(el('option', { value: lista[i] }, lista[i])); }
  }

  // Komunikat przy szablonach.
  function komunikatSzablonu(tekst) { $('szablon-komunikat').textContent = tekst || ''; }

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

  // ---- wyniki ----

  // Komunikat nad formularzem (ok / blad).
  function pokazKomunikat(tekst, rodzaj) {
    var k = $('komunikat');
    k.className = 'komunikat ' + rodzaj;
    k.textContent = tekst;
  }

  // Ukrycie komunikatu.
  function ukryjKomunikat() { $('komunikat').className = 'komunikat ukryty'; }

  // Wyniki do okna (html/wyniki.js), lista ścian dla tabeli otworów (html/otwory.js) i odświeżenie widoku ściany.
  function pokazWynik(d) {
    AMGW_WYNIKI.pokaz(d, wybierzSciane);
    if (!d.sciany) {
      AMGW_SCIANA.lista($('widok-sciana'), [], '');
      AMGW_SCIANA.rysuj($('widok'), null, $('widok-opis'));
      AMGW_EDYCJA.panel($('widok-panel'), null);
      return;
    }
    stan.sciany = d.sciany;
    AMGW_OTWORY.sciany(d.sciany);
    if (d.widoki) {
      stan.widok = AMGW_SCIANA.lista($('widok-sciana'), d.widoki, stan.widok);
      if (stan.widok) { wywolaj('widok', stan.widok); }
    }
  }

  // Wybór ściany do widoku (lista albo kliknięcie na rzucie).
  function wybierzSciane(id) {
    var sel = $('widok-sciana');
    var i;
    for (i = 0; i < sel.options.length; i++) {
      if (sel.options[i].value === id) {
        sel.selectedIndex = i;
        stan.widok = id;
        wywolaj('widok', id);
        return;
      }
    }
  }

  // Widok ściany z Ruby (AMGW.widok) – rysunek, gdy to nadal wybrana ściana; kliknięcie w rysunek dodaje albo usuwa
  // węgieł; pod rysunkiem panel ustawień ściany.
  function widok(d) {
    if (d && d.id && stan.widok && d.id !== stan.widok) { return; }
    AMGW_SCIANA.rysuj($('widok'), d, $('widok-opis'), function (s, zasieg) {
      AMGW_EDYCJA.klik(d, s, AMGW_EDYCJA.wegielPrzy(d, s, zasieg));
    });
    AMGW_EDYCJA.panel($('widok-panel'), d);
  }

  // ---- wywołania ----

  // Dane formularza jako JSON (parametry, otwory i ustawienia ścian z widoku).
  function dane() { return JSON.stringify({ parametry: zbierzParametry(), otwory: AMGW_OTWORY.zbierz(), sciany: AMGW_EDYCJA.dane() }); }

  // Podgląd po zmianie pola (z opóźnieniem 350 ms – kilka zmian = jedno wywołanie); przeliczenie otworów w tabeli.
  function zaplanujPodglad() {
    AMGW_OTWORY.przelicz();
    if (stan.timer) { clearTimeout(stan.timer); }
    stan.timer = setTimeout(function () { stan.timer = null; wywolaj('podglad', dane()); }, 350);
  }

  // Start okna danymi z Ruby (AMGW.init).
  function init(d) {
    stan.opisy = d.opisy || [];
    stan.sekcje = d.sekcje || [];
    stan.presety = d.presety || {};
    stan.opisyZamka = d.opisy_zamka || [];
    $('info').textContent = d.info || '';
    wypelnijSzablony(d.szablony);
    $('plik-ustawien').textContent = d.plik_ustawien ? 'Ostatnie ustawienia zapisują się w: ' + d.plik_ustawien : '';
    AMGW_EDYCJA.init(d.sciany, zaplanujPodglad);
    AMGW_OTWORY.init(wartoscPola, zaplanujPodglad);
    zbudujFormularz(d.parametry || {});
    AMGW_TRYB.ustaw(d.tryb_pol, stan.opisy);
    var i;
    if (d.podsumowanie) { pokazWynik(d.podsumowanie); }
    for (i = 0; i < (d.otwory || []).length; i++) { AMGW_OTWORY.dodaj(d.otwory[i]); }
    $('btn-generuj').textContent = d.tryb === 'edycja' ? 'Zastąp dom w modelu' : 'Generuj w modelu';
  }

  // Parametry z szablonu albo fabryczne (AMGW.ustaw): nowy formularz i podgląd.
  function ustaw(d) {
    zbudujFormularz(d.parametry || {});
    komunikatSzablonu(d.komunikat);
    zaplanujPodglad();
  }

  // Lista szablonów po zapisie / usunięciu (AMGW.szablony).
  function szablony(d) {
    wypelnijSzablony(d.lista);
    komunikatSzablonu(d.komunikat);
  }

  // Wynik z Ruby (AMGW.wynik) – po podglądzie albo generowaniu.
  function wynik(d) {
    pokazWynik(d);
    $('btn-generuj').disabled = false;
    if (d.bledy && d.bledy.length) {
      pokazKomunikat('Nie można wygenerować domu – popraw błędy na liście.', 'blad');
    } else if (d.zbudowano) {
      pokazKomunikat('Dom wygenerowany w modelu: ' + d.liczby.bale + ' bali, ' + d.liczby.pozycje + ' pozycji.' +
                     (d.bledne_sciany ? ' Uwaga: ' + d.bledne_sciany + ' ścian brył nie narysowano.' : '') +
                     (d.dach ? ' ' + d.dach.tekst : ''), d.dach && !d.dach.ok ? 'blad' : 'ok');
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
      AMGW_OTWORY.dodaj({ sciana: AMGW_OTWORY.pierwszaSciana(), od: wartoscPola('nowy_otwor_od', '1000'),
                          szerokosc: wartoscPola('okno_szerokosc', '1020'), wysokosc: wartoscPola('okno_wysokosc', '1010'),
                          parapet: wartoscPola('okno_parapet', '900'), luz_gorny: '', nazwa: '' });
      zaplanujPodglad();
    });
    $('btn-drzwi').addEventListener('click', function () {
      AMGW_OTWORY.dodaj({ sciana: AMGW_OTWORY.pierwszaSciana(), od: wartoscPola('nowy_otwor_od', '1000'),
                          szerokosc: wartoscPola('drzwi_szerokosc', '930'), wysokosc: wartoscPola('drzwi_wysokosc', '2100'),
                          parapet: '0', luz_gorny: '', nazwa: '' });
      zaplanujPodglad();
    });
    $('btn-szablon-wczytaj').addEventListener('click', function () {
      if ($('szablon').value) { wywolaj('szablon_wczytaj', $('szablon').value); }
    });
    $('btn-szablon-usun').addEventListener('click', function () {
      if ($('szablon').value) { wywolaj('szablon_usun', $('szablon').value); }
    });
    $('btn-szablon-zapisz').addEventListener('click', function () {
      wywolaj('szablon_zapisz', JSON.stringify({ nazwa: $('szablon-nazwa').value, parametry: zbierzParametry() }));
    });
    $('btn-domyslne').addEventListener('click', function () { wywolaj('domyslne'); });
    $('widok-sciana').addEventListener('change', function () { wybierzSciane(this.value); });
    $('btn-zestawienie').addEventListener('click', function () { wywolaj('zapisz_liste'); });
    $('btn-tryb-podstawowe').addEventListener('click', function () { wywolaj('tryb_pol', AMGW_TRYB.ustaw('podstawowe', stan.opisy)); });
    $('btn-tryb-wszystkie').addEventListener('click', function () { wywolaj('tryb_pol', AMGW_TRYB.ustaw('wszystkie', stan.opisy)); });
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

  // Komunikat z Ruby (AMGW.komunikat) – np. po zapisie zestawienia.
  function komunikat(d) { pokazKomunikat(d.tekst || '', d.rodzaj === 'ok' ? 'ok' : 'blad'); }

  return { init: init, wynik: wynik, ustaw: ustaw, szablony: szablony, widok: widok, komunikat: komunikat, _zbierz: dane };
}());
