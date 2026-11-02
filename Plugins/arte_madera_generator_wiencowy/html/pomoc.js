/*
  ArteMadera – Generator Wieńcowy
  Plik: html/pomoc.js
  Zadanie: objaśnienia pól w oknie – znak zapytania w kółku przy etykiecie, po kliknięciu ramka z dłuższym opisem i rysunkiem pokazującym różnicę (obciążenie, ugięcie, podbitka, położenie płatwi ściennej, układ dachu).
  Tematy: pytajnik przy polu, objaśnienie pola, rysunek objaśniający, obciążenie użytkowe – rysunek, ugięcie – rysunek, podbitka – rysunek, płatew ścienna – rysunek, układ dachu – rysunek
  Zależy od: html/wspolne.js (AMGW_DOM)
  Używają: html/okno.js (dodajPole)

  Opis pola z Ruby: pomoc – tekst objaśnienia, rysunek – klucz rysunku z RYSUNKI (SVG w tym pliku, kolory z arkusza).
  Zgodność: ES5 (var, function; bez let/const, =>, szablonów, class).
*/
var AMGW_POMOC = (function () {
  'use strict';

  var el = AMGW_DOM.el;
  var $ = AMGW_DOM.$;

  // Rysunki SVG (viewBox 0 0 320 120): podpisy po polsku, linie w kolorze tekstu, drewno – kolor akcentu.
  var RYSUNKI = {
    obciazenie:
      '<svg viewBox="0 0 320 120" class="rys"><rect x="20" y="78" width="280" height="10" class="drewno"/>' +
      '<rect x="20" y="88" width="16" height="22" class="drewno"/><rect x="284" y="88" width="16" height="22" class="drewno"/>' +
      '<circle cx="80" cy="40" r="7" class="kreska"/><line x1="80" y1="47" x2="80" y2="66" class="kreska"/>' +
      '<line x1="80" y1="66" x2="72" y2="78" class="kreska"/><line x1="80" y1="66" x2="88" y2="78" class="kreska"/>' +
      '<rect x="150" y="48" width="44" height="30" class="mebel"/><rect x="214" y="30" width="30" height="48" class="mebel"/>' +
      '<g class="strzalki"><line x1="40" y1="8" x2="40" y2="70"/><line x1="120" y1="8" x2="120" y2="70"/>' +
      '<line x1="270" y1="8" x2="270" y2="70"/></g><text x="160" y="16" class="podpis">2,0 kN/m² ≈ 200 kg na każdym m²</text>' +
      '<text x="160" y="104" class="podpis">ludzie i meble = obciążenie użytkowe</text></svg>',
    ugiecie:
      '<svg viewBox="0 0 320 120" class="rys"><rect x="20" y="20" width="280" height="10" class="drewno"/>' +
      '<path d="M20 70 Q160 96 300 70" class="kreska"/><path d="M20 70 Q160 82 300 70" class="kreska akcent"/>' +
      '<polygon points="20,75 12,88 28,88" class="podpora"/><polygon points="300,75 292,88 308,88" class="podpora"/>' +
      '<text x="160" y="14" class="podpis">legar bez obciążenia</text><text x="160" y="72" class="podpis akcent">L/400 – sztywno (4 m → 10 mm)</text>' +
      '<text x="160" y="110" class="podpis">L/250 – sprężyście (4 m → 16 mm)</text></svg>',
    podbitka:
      '<svg viewBox="0 0 320 120" class="rys">' +
      '<rect x="30" y="36" width="20" height="32" class="drewno"/>' +
      '<line x1="6" y1="72" x2="74" y2="72" class="kreska akcent gruba"/>' +
      '<text x="40" y="94" class="podpis">pod płatwiami</text>' +
      '<rect x="84" y="24" width="72" height="12" class="drewno"/>' +
      '<rect x="110" y="44" width="20" height="32" class="drewno"/>' +
      '<line x1="86" y1="40" x2="154" y2="40" class="kreska akcent gruba"/>' +
      '<text x="120" y="94" class="podpis">na płatwiach</text>' +
      '<rect x="164" y="30" width="72" height="12" class="drewno"/>' +
      '<rect x="190" y="42" width="20" height="32" class="drewno"/>' +
      '<line x1="166" y1="46" x2="188" y2="46" class="kreska akcent gruba"/>' +
      '<line x1="212" y1="46" x2="234" y2="46" class="kreska akcent gruba"/>' +
      '<text x="200" y="94" class="podpis">pod krokwiami</text>' +
      '<rect x="244" y="30" width="72" height="12" class="drewno"/>' +
      '<rect x="270" y="42" width="20" height="32" class="drewno"/>' +
      '<line x1="246" y1="26" x2="314" y2="26" class="kreska akcent gruba"/>' +
      '<text x="280" y="94" class="podpis">na krokwiach</text>' +
      '<text x="160" y="114" class="podpis akcent">gruba linia – deski podbitki; krokiew u góry, płatew niżej</text>' +
      '</svg>',
    platwa_scienna:
      '<svg viewBox="0 0 320 120" class="rys"><rect x="20" y="50" width="22" height="60" class="drewno"/>' +
      '<rect x="44" y="30" width="16" height="34" class="drewno akcent"/><line x1="0" y1="40" x2="140" y2="0" class="kreska"/>' +
      '<text x="70" y="70" class="podpis lewy">przy licu – obok ściany</text>' +
      '<rect x="190" y="50" width="22" height="60" class="drewno"/><rect x="190" y="16" width="22" height="34" class="drewno akcent"/>' +
      '<line x1="170" y1="22" x2="320" y2="-20" class="kreska"/><text x="220" y="70" class="podpis lewy">na ścianie – w osi</text>' +
      '<text x="160" y="116" class="podpis">ściana nośna – bez płatwi, górny bal ścięty pod dach</text></svg>',
    uklad_dachu:
      '<svg viewBox="0 0 320 120" class="rys"><polyline points="10,100 80,40 150,100" class="kreska"/>' +
      '<rect x="40" y="62" width="10" height="12" class="drewno"/><rect x="75" y="34" width="10" height="12" class="drewno"/>' +
      '<rect x="110" y="62" width="10" height="12" class="drewno"/><text x="80" y="116" class="podpis">same płatwie – deski na płatwiach</text>' +
      '<polyline points="170,100 240,40 310,100" class="kreska gruba akcent"/><rect x="235" y="40" width="10" height="12" class="drewno"/>' +
      '<rect x="176" y="88" width="10" height="12" class="drewno"/><rect x="294" y="88" width="10" height="12" class="drewno"/>' +
      '<text x="240" y="116" class="podpis">krokwie na płatwiach</text></svg>'
  };

  // Znak zapytania przy etykiecie pola i ukryta ramka objaśnienia (po polu); nic, gdy pole nie ma pomocy ani rysunku.
  function dodaj(sekcja, etykieta, opis) {
    if (!opis.pomoc && !opis.rysunek) { return; }
    var pyt = el('span', { 'class': 'pyt', id: 'q-' + opis.klucz, title: 'Objaśnienie', role: 'button' }, '?');
    pyt.addEventListener('click', function (ev) {
      ev.preventDefault();
      ev.stopPropagation();
      var m = $('m-' + opis.klucz);
      if (m) { m.style.display = m.style.display === 'none' ? '' : 'none'; }
    });
    etykieta.appendChild(pyt);
    var box = el('div', { 'class': 'pomoc', id: 'm-' + opis.klucz });
    box.style.display = 'none';
    if (opis.rysunek && RYSUNKI[opis.rysunek]) {
      var r = el('div', { 'class': 'rysunek' });
      r.innerHTML = RYSUNKI[opis.rysunek];
      box.appendChild(r);
    }
    if (opis.pomoc) { box.appendChild(el('p', {}, opis.pomoc)); }
    sekcja.appendChild(box);
  }

  return { dodaj: dodaj, RYSUNKI: RYSUNKI };
})();
