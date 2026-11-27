/*
  ArteMadera – Generator Wieńcowy
  Plik: html/okno.js
  Zadanie: logika okna parametrów – sekcje i pola z listy parametrów, podpowiedzi, wymiary zamka, wynik podglądu, wywołania Ruby; typy, standard, kroki i układ w osobnych plikach.
  Tematy: formularz parametrów, sekcje pól, sekcje w zakładkach, podpowiedzi pól, wymiary zamka w oknie, komunikaty w oknie, podgląd automatyczny, wybór ściany do widoku, przełącznik pól podstawowe / wszystkie, odświeżenie pól po zmianie, start okna
  Zależy od: html/okno.html, html/okno.css, html/wspolne.js (AMGW_DOM), html/wyniki.js (AMGW_WYNIKI.pokaz), html/sciana.js (AMGW_SCIANA), html/zmiany.js (AMGW_ZMIANY), html/tryb.js (AMGW_TRYB), html/typy.js (AMGW_TYPY), html/standard.js (AMGW_STANDARD), html/kroki.js (AMGW_KROKI), html/uwagi.js (AMGW_UWAGI), html/uklad.js (AMGW_UKLAD), html/edycja.js (AMGW_EDYCJA), html/otwory.js (AMGW_OTWORY – tabela okien i drzwi), html/klik_sciana.js (AMGW_KLIK – okienko przy kliknięciu w widok ściany), html/dzialowe.js (AMGW_DZIALOWE – działowe domu z wymiarów), html/wegly.js (AMGW_WEGLY), html/wegly_przesun.js, html/przeliczenia.js, html/zalezne.js, html/pomoc.js, html/zakladki.js, html/tabela.js (pola-tabele)
  Używają: sketchup/okno.rb (AMGW.init, AMGW.wynik, AMGW.typy, AMGW.widok, AMGW.komunikat)

  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
  Pole nowego parametru pojawia się samo w swojej sekcji (ParametryLista w Ruby: sekcja, wybory, podpowiedź).
*/
var AMGW = (function () {
  'use strict';

  var stan = { opisy: [], sekcje: [], zakladki: [], presety: {}, opisyZamka: [], sciany: [], timer: null, otwarte: {}, widok: '' };

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

  // Sekcje formularza (rozwijane) z listy sekcji, każda w pojemniku swojej zakładki (AMGW_ZAKLADKI); zachowuje
  // rozwinięcie przy przebudowie.
  function zbudujSekcje() {
    var box = $('sekcje');
    var i;
    var stare = box.querySelectorAll('details');
    for (i = 0; i < stare.length; i++) { stan.otwarte[stare[i].getAttribute('data-sekcja')] = stare[i].open; }
    AMGW_ZAKLADKI.zbuduj(stan.zakladki);
    for (i = 0; i < stan.sekcje.length; i++) {
      var s = stan.sekcje[i];
      var det = el('details', { id: 'sekcja-' + s.klucz, 'data-sekcja': s.klucz });
      det.open = stan.otwarte[s.klucz] !== undefined ? stan.otwarte[s.klucz] : !!s.otwarta;
      det.appendChild(el('summary', { 'data-tytul': s.tytul }, s.tytul));
      det.appendChild(el('div', { id: 'pola-' + s.klucz, 'class': 'pola' }));
      if (s.klucz === 'przekroj') { det.appendChild(el('div', { id: 'pola-zamek', 'class': 'pola' })); }
      if (s.klucz === 'sciany') { det.appendChild(el('div', { id: 'wysokosci', 'class': 'wysokosci' })); }
      AMGW_ZAKLADKI.pojemnik(s.zakladka).appendChild(det);
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
    odswiezPola();
  }

  // Podpowiedzi przekrojów z magazynu drewna (datalist magazyn-<zastosowanie>) dla pól przekrojów z cechą „magazyn”.
  function listyMagazynu() {
    var box = $('listy-magazynu');
    var wiersze = AMGW_TABELA.wiersze(wartoscPola('magazyn_drewna', '[]'));
    var zast = ['legar', 'platew', 'krokiew', 'zadaszenie', 'slup', 'deska'];
    var i;
    var j;
    wyczysc(box);
    for (i = 0; i < zast.length; i++) {
      var dl = el('datalist', { id: 'magazyn-' + zast[i] });
      for (j = 0; j < wiersze.length; j++) {
        if (wiersze[j][zast[i]]) { dl.appendChild(el('option', { value: String(wiersze[j].przekroj) })); }
      }
      box.appendChild(dl);
    }
  }

  // Po zmianie wartości pól: podpowiedzi przekrojów z magazynu, wybory zależne, wyróżnienie zmienionych (względem fabrycznych
  // i względem typu ze standardem), nazwy zakładek i widoczność pól w bieżącym układzie.
  function odswiezPola() {
    listyMagazynu();
    var zmiana = AMGW_ZALEZNE.wszystkieWybory(stan.opisy);
    AMGW_ZMIANY.oznacz(stan.opisy);
    AMGW_TYPY.oznacz(stan.opisy);
    AMGW_ZAKLADKI.oznacz();
    AMGW_UKLAD.odswiez(stan.opisy);
    return zmiana;
  }

  // Jedno pole parametru w swojej sekcji (lista wyboru, liczba, przekrój albo tekst), podpowiedź pod nim i pytajnik
  // z objaśnieniem; zmiana pola – pola zależne, wyróżnienie zmienionych, widoczność i podgląd.
  function dodajPole(opis, parametry) {
    var sekcja = $('pola-' + opis.sekcja) || $('pola-rysunek');
    var wartosc = parametry[opis.klucz] !== undefined && parametry[opis.klucz] !== null ? parametry[opis.klucz] : opis.domyslna;
    if (opis.rodzaj === 'tabela') { poleTabeli(sekcja, opis, wartosc); return; }
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
      if (opis.wspolny) {
        pole.setAttribute('data-wspolny', opis.wspolny);
        if (opis.wspolny_mapa) { pole.setAttribute('data-wspolny-mapa', JSON.stringify(opis.wspolny_mapa)); }
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
        pole.title = 'szerokość × wysokość, np. 50x150' + (opis.magazyn ? ' – podpowiedzi z magazynu drewna' : '');
        if (opis.magazyn) { pole.setAttribute('list', 'magazyn-' + opis.magazyn); }
      } else {
        pole.setAttribute('inputmode', 'decimal');
        pole.value = AMGW_DOM.fmtPola(wartosc);
        if (opis.min !== null && opis.max !== null) { pole.title = 'od ' + fmt(opis.min) + ' do ' + fmt(opis.max); }
      }
    }
    pole.addEventListener('change', function () {
      // Przebudowa po puszczeniu przycisku myszy – kliknięcie w przycisk tuż po wpisaniu wartości trafia w przycisk.
      AMGW_DOM.poKliknieciu(function () {
        odswiezPola();
        zaplanujPodglad();
      });
    });
    AMGW_POMOC.poWejsciu(pole, opis.klucz);
    sekcja.appendChild(pole);
    if (opis.podpowiedz) { sekcja.appendChild(el('div', { 'class': 'podp', id: 'h-' + opis.klucz }, opis.podpowiedz)); }
    AMGW_POMOC.dodaj(sekcja, etykieta, opis);
  }

  // Pole-tabela w formularzu domu (lista stolarki, magazyn drewna): wartość w ukrytym polu (tekst JSON), etykieta z liczbą
  // wierszy – tabelę zmienia się w panelu „Standard warsztatu”.
  function poleTabeli(sekcja, opis, wartosc) {
    var etykieta = el('label', { 'for': 'p-' + opis.klucz, id: 'l-' + opis.klucz, 'class': 'pelny' },
                      opis.etykieta + ' – wierszy: ' + AMGW_TABELA.kanon(opis, wartosc).length + ' (zmiana: Standard warsztatu)');
    var pole = el('input', { id: 'p-' + opis.klucz, 'data-klucz': opis.klucz, type: 'hidden' });
    pole.value = AMGW_TABELA.tekst(opis, wartosc);
    sekcja.appendChild(etykieta);
    sekcja.appendChild(pole);
  }

  // Wartość pola parametru z formularza (gdy brak pola – domyślna).
  function wartoscPola(klucz, domyslna) {
    var e = $('p-' + klucz);
    return e ? e.value : domyslna;
  }

  // ---- zamek ----

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
      inp.value = AMGW_DOM.fmtPola(wlasny[o[0]] !== undefined ? wlasny[o[0]] : preset[o[0]]);
      inp.addEventListener('change', function () {
        AMGW_UKLAD.odswiez(stan.opisy);
        zaplanujPodglad();
      });
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
    AMGW_UWAGI.pokaz(d.uwagi);
    // Opcje niedostępne dla obrysu (wyszarzone z powodem); gdy wybór trzeba było przestawić – nowy podgląd.
    AMGW_ZALEZNE.obrys(d.obrys_rodzaj);
    if (odswiezPola()) { zaplanujPodglad(); }
    AMGW_PRZELICZENIA.pokaz(d);
    AMGW_PRZESUN.pokaz(d.wegly_lista || []);
    if (!d.sciany) {
      AMGW_SCIANA.lista($('widok-sciana'), [], '');
      AMGW_SCIANA.rysuj($('widok'), null, $('widok-opis'));
      AMGW_EDYCJA.panel($('widok-panel'), null);
      return;
    }
    stan.sciany = d.sciany;
    AMGW_OTWORY.sciany(d.sciany);
    AMGW_WEGLY.sciany(d.sciany);
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
    AMGW_KLIK.zamknij();
    AMGW_SCIANA.rysuj($('widok'), d, $('widok-opis'), function (s, zasieg, h, ev) { AMGW_KLIK.klik(d, s, zasieg, h, ev); });
    AMGW_EDYCJA.panel($('widok-panel'), d);
  }

  // ---- wywołania ----

  // Dane formularza jako JSON (parametry, otwory, węgły, ustawienia ścian z widoku, typ; dom z wymiarów – działowe).
  function dane() {
    var d = { parametry: zbierzParametry(), otwory: AMGW_OTWORY.zbierz(), wegly: AMGW_WEGLY.zbierz(),
              sciany: AMGW_EDYCJA.dane(), typ: AMGW_TYPY.typ() };
    var dz = AMGW_DZIALOWE.zbierz();
    if (dz) { d.dzialowe = dz; }
    return JSON.stringify(d);
  }

  // Podgląd po zmianie pola (z opóźnieniem 350 ms – kilka zmian = jedno wywołanie); przeliczenie otworów w tabeli; okno
  // samego standardu (z menu) – bez podglądu.
  function zaplanujPodglad() {
    if (AMGW_STANDARD.samodzielny()) { return; }
    AMGW_OTWORY.przelicz();
    if (stan.timer) { clearTimeout(stan.timer); }
    stan.timer = setTimeout(function () { stan.timer = null; wywolaj('podglad', dane()); }, 350);
  }

  // Start okna danymi z Ruby (AMGW.init): pola (pola domu z wymiarów tylko dla domu bez narysowanego obrysu), typy
  // i standard, kroki, układ okna, wynik pierwszego przeliczenia; tryb 'standard' (z menu) – sam panel standardu.
  function init(d) {
    var i;
    stan.opisy = [];
    for (i = 0; i < (d.opisy || []).length; i++) {
      if (!d.opisy[i].z_wymiarow || d.z_wymiarow) { stan.opisy.push(d.opisy[i]); }
    }
    stan.sekcje = d.sekcje || [];
    stan.zakladki = d.zakladki || [];
    stan.presety = d.presety || {};
    stan.opisyZamka = d.opisy_zamka || [];
    $('info').textContent = d.info || '';
    $('plik-ustawien').textContent = d.plik_ustawien ? 'Standard i typy zapisują się w: ' + d.plik_ustawien : '';
    AMGW_EDYCJA.init(d.sciany, zaplanujPodglad);
    AMGW_OTWORY.init(wartoscPola, zaplanujPodglad);
    AMGW_KLIK.init(wartoscPola, zaplanujPodglad);
    AMGW_DZIALOWE.init(d.dzialowe || [], d.z_wymiarow, zaplanujPodglad);
    AMGW_WEGLY.init(zaplanujPodglad);
    AMGW_KROKI.zbuduj(d.kroki || []);
    AMGW_TYPY.init(d.typy, stan.opisy, wywolaj, zbierzParametry, function () {
      if (AMGW_STANDARD.samodzielny()) { AMGW_STANDARD.poZapisie(); return; }
      if (AMGW_STANDARD.otwarty()) { AMGW_STANDARD.zamknij(); }
      odswiezPola();
      zaplanujPodglad();
    }, zbudujZamek);
    AMGW_STANDARD.init(stan.opisy, stan.sekcje, stan.opisyZamka, wywolaj);
    AMGW_TRYB.ustaw(d.tryb_pol, []);
    zbudujFormularz(d.parametry || {});
    AMGW_OTWORY.przelicz();
    AMGW_UKLAD.ustaw(d.uklad, stan.opisy);
    if (d.podsumowanie) { pokazWynik(d.podsumowanie); }
    for (i = 0; i < (d.otwory || []).length; i++) { AMGW_OTWORY.dodaj(d.otwory[i]); }
    for (i = 0; i < (d.wegly || []).length; i++) { AMGW_WEGLY.dodaj(d.wegly[i]); }
    $('btn-generuj').textContent = d.tryb === 'edycja' ? 'Zastąp dom w modelu' : 'Generuj w modelu';
    if (d.tryb === 'standard') { AMGW_STANDARD.samodzielnie(); }
  }

  // Nowy formularz z podanych parametrów (pola bez wartości – fabryczne) i podgląd; do testów okna (AMGW._ustaw).
  function ustaw(d) {
    zbudujFormularz(d.parametry || {});
    zaplanujPodglad();
  }

  // Typy domów i baza porównania z Ruby (AMGW.typy) – po wyborze, zapisie albo usunięciu typu i po zapisie standardu.
  function typy(d) { AMGW_TYPY.odpowiedz(d); }

  // Wynik z Ruby (AMGW.wynik) – po podglądzie albo generowaniu.
  function wynik(d) {
    pokazWynik(d);
    $('btn-generuj').disabled = false;
    if (d.bledy && d.bledy.length) {
      pokazKomunikat('Nie można wygenerować domu – popraw błędy na liście.', 'blad');
    } else if (d.zbudowano) {
      pokazKomunikat('Dom wygenerowany w modelu: ' + d.liczby.bale + ' bali, ' + d.liczby.pozycje + ' pozycji.' +
                     (d.bledne_sciany ? ' Uwaga: ' + d.bledne_sciany + ' ścian brył nie narysowano.' : '') +
                     (d.dach ? ' ' + d.dach.tekst : '') + opisStolarki(d.stolarka), d.dach && !d.dach.ok ? 'blad' : 'ok');
      $('btn-generuj').textContent = 'Zastąp dom w modelu';
    } else if (d.anulowano) {
      pokazKomunikat('Anulowano – dom w modelu bez zmian.', 'blad');
    } else {
      ukryjKomunikat();
    }
  }

  // Zdanie o modelach okien i drzwi wstawionych w otwory (sketchup/stolarka_modele.rb); bez modeli – pusty tekst.
  function opisStolarki(st) {
    if (!st || (!st.wstawione && !(st.uwagi || []).length)) { return ''; }
    return ' Modele stolarki: ' + st.wstawione + '.' + ((st.uwagi || []).length ? ' ' + st.uwagi.join(' ') : '');
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
    $('btn-okno').addEventListener('click', function () { if (AMGW_OTWORY.dodajTyp('okno')) { zaplanujPodglad(); } });
    $('btn-drzwi').addEventListener('click', function () { if (AMGW_OTWORY.dodajTyp('drzwi')) { zaplanujPodglad(); } });
    $('btn-dzialowa').addEventListener('click', function () { AMGW_DZIALOWE.nowa(wartoscPola('dom_dlugosc', '6000')); });
    $('btn-dodaj-otwor').addEventListener('click', function () { if (AMGW_OTWORY.dodajZListy($('nowy-typ').value)) { zaplanujPodglad(); } });
    $('btn-wegiel').addEventListener('click', function () {
      AMGW_WEGLY.dodaj({ sciana: AMGW_OTWORY.pierwszaSciana(), polozenie: 'od', od: '1500' });
      zaplanujPodglad();
    });
    $('btn-wegiel-srodek').addEventListener('click', function () {
      AMGW_WEGLY.dodaj({ sciana: AMGW_OTWORY.pierwszaSciana(), polozenie: 'srodek', od: '' });
      zaplanujPodglad();
    });
    $('widok-sciana').addEventListener('change', function () { wybierzSciane(this.value); });
    $('btn-zestawienie').addEventListener('click', function () { wywolaj('zapisz_liste'); });
    $('btn-tryb-podstawowe').addEventListener('click', function () { wywolaj('tryb_pol', AMGW_TRYB.ustaw('podstawowe', stan.opisy)); });
    $('btn-tryb-wszystkie').addEventListener('click', function () { wywolaj('tryb_pol', AMGW_TRYB.ustaw('wszystkie', stan.opisy)); });
    $('btn-uklad-kroki').addEventListener('click', function () { wywolaj('uklad', AMGW_UKLAD.ustaw('kroki', stan.opisy)); });
    $('btn-uklad-zakladki').addEventListener('click', function () { wywolaj('uklad', AMGW_UKLAD.ustaw('zakladki', stan.opisy)); });
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

  return { init: init, wynik: wynik, typy: typy, widok: widok, komunikat: komunikat, _zbierz: dane, _ustaw: ustaw };
}());
