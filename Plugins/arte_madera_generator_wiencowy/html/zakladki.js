/*
  ArteMadera – Generator Wieńcowy
  Plik: html/zakladki.js
  Zadanie: zakładki formularza parametrów – „Dom” i „Zadaszenie boczne / tylne” (sekcje parametrów w osobnych pojemnikach), przełączanie zakładek i liczba zmienionych pól w nazwie zakładki.
  Tematy: zakładki okna, zakładka zadaszenia, przełączanie zakładek, pojemnik sekcji zakładki, liczba zmian w zakładce
  Zależy od: html/wspolne.js (AMGW_DOM), html/okno.html (#zakladki, #sekcje)
  Używają: html/okno.js (budowa sekcji formularza, po zmianie pola), html/zmiany.js (klasa „zmieniony” na etykiecie)

  Zakładki z Ruby: [{ klucz:, tytul: }] (rdzen/parametry_lista.rb ZAKLADKI); sekcja: { zakladka: klucz }. Wymóg użytkownika
  (2026-11-25): „cała część bocznego zadaszenia – lub tylnego – w osobnej zakładce, by się nic nie myliło”.
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_ZAKLADKI = (function () {
  'use strict';

  var $ = AMGW_DOM.$;
  var el = AMGW_DOM.el;
  var wyczysc = AMGW_DOM.wyczysc;
  var stan = { lista: [], biezaca: '' };

  // Pasek zakładek (#zakladki) i pusty pojemnik sekcji każdej zakładki (#sekcje-<klucz> w #sekcje); wybrana zakładka
  // zostaje po przebudowie formularza (szablon, fabryczne).
  function zbuduj(lista) {
    stan.lista = lista && lista.length ? lista : [{ klucz: 'dom', tytul: 'Dom' }];
    var pasek = $('zakladki');
    var box = $('sekcje');
    var i;
    wyczysc(pasek);
    wyczysc(box);
    for (i = 0; i < stan.lista.length; i++) {
      var z = stan.lista[i];
      var b = el('button', { type: 'button', id: 'zakl-' + z.klucz, 'data-zakladka': z.klucz, 'data-tytul': z.tytul }, z.tytul);
      b.addEventListener('click', (function (k) { return function () { wybierz(k); }; }(z.klucz)));
      pasek.appendChild(b);
      box.appendChild(el('div', { id: 'sekcje-' + z.klucz, 'class': 'kolumna zakladka', 'data-zakladka': z.klucz }));
    }
    pasek.style.display = stan.lista.length > 1 ? '' : 'none';
    if (!$('sekcje-' + stan.biezaca)) { stan.biezaca = stan.lista[0].klucz; }
    wybierz(stan.biezaca);
  }

  // Pojemnik sekcji zakładki (nieznana zakładka – pierwsza).
  function pojemnik(klucz) {
    return $('sekcje-' + klucz) || $('sekcje-' + stan.lista[0].klucz);
  }

  // Pokazanie zakładki: jej pojemnik widoczny, pozostałe ukryte, przycisk wyróżniony.
  function wybierz(klucz) {
    var i;
    stan.biezaca = $('sekcje-' + klucz) ? klucz : stan.lista[0].klucz;
    for (i = 0; i < stan.lista.length; i++) {
      var k = stan.lista[i].klucz;
      var widoczna = k === stan.biezaca;
      var p = $('sekcje-' + k);
      var b = $('zakl-' + k);
      if (p) { p.style.display = widoczna ? '' : 'none'; }
      if (b) { b.className = widoczna ? 'wybrany' : ''; }
    }
    return stan.biezaca;
  }

  // Nazwy zakładek z liczbą pól zmienionych względem fabrycznych (etykiety z klasą „zmieniony” w pojemniku zakładki).
  function oznacz() {
    var i;
    for (i = 0; i < stan.lista.length; i++) {
      var z = stan.lista[i];
      var b = $('zakl-' + z.klucz);
      var p = $('sekcje-' + z.klucz);
      if (!b || !p) { continue; }
      var n = p.querySelectorAll('label.zmieniony').length;
      b.textContent = z.tytul + (n ? ' · zmienione: ' + n : '');
    }
  }

  // Klucz bieżącej zakładki.
  function biezaca() { return stan.biezaca; }

  return { zbuduj: zbuduj, pojemnik: pojemnik, wybierz: wybierz, oznacz: oznacz, biezaca: biezaca };
}());
