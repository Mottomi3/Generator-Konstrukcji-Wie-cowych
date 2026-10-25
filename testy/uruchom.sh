#!/bin/bash
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/uruchom.sh
# Zadanie: wszystkie testy i kontrole jednym poleceniem – ostatnia linia „WSZYSTKIE ZESTAWY: FAILURES n”.
# Tematy: uruchamianie testów, zestawy testów, kontrola przed commitem
# Zależy od: ruby, node (+ playwright i Chromium dla okna – bez nich test okna jest pomijany z ostrzeżeniem), aplikacja do dachów obok
# repozytorium albo AM_GW_APLIKACJA_DACHOW (bez niej sprawdzenie z prawdziwą aplikacją jest pomijane z ostrzeżeniem)
# Używają: start i zamknięcie rundy
#
# Użycie: bash testy/uruchom.sh

cd "$(dirname "$0")/.." || exit 1
export AM_GW_CICHO=1
SUMA=0
mkdir -p testy/wyniki

uruchom() {
  local nazwa="$1"; shift
  "$@" > "testy/wyniki/${nazwa}.txt" 2>&1
  local n
  n=$(grep -E "FAILURES:? [0-9]+" "testy/wyniki/${nazwa}.txt" | tail -1 | grep -oE "[0-9]+$")
  if [ -z "$n" ]; then n=1; echo "  ${nazwa}: brak wyniku (przerwany?) – testy/wyniki/${nazwa}.txt"; fi
  echo "  ${nazwa}: FAILURES ${n}"
  grep -E "^BŁĄD|^UWAGA" "testy/wyniki/${nazwa}.txt" | head -20 | sed 's/^/    /'
  SUMA=$((SUMA + n))
}

echo "Testy rdzenia i SketchUpa (atrapa):"
uruchom t_rdzen ruby -I testy/atrapa testy/t_rdzen.rb
uruchom t_wegly ruby -I testy/atrapa testy/t_wegly.rb
uruchom t_szczyty ruby -I testy/atrapa testy/t_szczyty.rb
uruchom t_polacie ruby -I testy/atrapa testy/t_polacie.rb
uruchom t_podloga ruby -I testy/atrapa testy/t_podloga.rb
uruchom t_zamek ruby -I testy/atrapa testy/t_zamek.rb
uruchom t_siatka ruby -I testy/atrapa testy/t_siatka.rb
uruchom t_widok ruby -I testy/atrapa testy/t_widok.rb
uruchom t_zestawienie ruby -I testy/atrapa testy/t_zestawienie.rb
uruchom t_raport ruby -I testy/atrapa testy/t_raport.rb
uruchom t_sciany_ust ruby -I testy/atrapa testy/t_sciany_ust.rb
uruchom t_losowe ruby -I testy/atrapa testy/t_losowe.rb
uruchom t_sketchup ruby -I testy/atrapa testy/t_sketchup.rb
uruchom t_dach_aplikacja ruby -I testy/atrapa testy/t_dach_aplikacja.rb

echo "Aplikacja do dachów (prawdziwa wtyczka na jej atrapie):"
KD="${AM_GW_APLIKACJA_DACHOW:-../aplikacja-do-konstrukcji-dach-w}"
if [ -f "$KD/artemadera_roof.rb" ]; then
  uruchom dach_aplikacja ruby testy/sprawdz_dach_aplikacja.rb
else
  echo "  dach_aplikacja: POMINIĘTY (brak $KD – sklonuj Mottomi3/Aplikacja-do-konstrukcji-dach-w obok) – UWAGA"
fi

if [ -x /opt/ruby27/bin/ruby ]; then
  echo "Ruby 2.7 (jak w SketchUpie 2023):"
  uruchom ruby27 bash testy/ruby27.sh
else
  echo "  Ruby 2.7: POMINIĘTY (brak /opt/ruby27 – bash testy/ruby27.sh zbuduje go i uruchomi testy) – UWAGA"
fi

echo "Okno (Chromium):"
export PLAYWRIGHT_BROWSERS_PATH="${PLAYWRIGHT_BROWSERS_PATH:-/opt/pw-browsers}"
export NODE_PATH="${NODE_PATH:-$(npm root -g 2>/dev/null)}"
if node -e "require('playwright')" >/dev/null 2>&1; then
  uruchom t_okno node testy/t_okno.js
else
  echo "  t_okno: POMINIĘTY (brak playwright) – UWAGA"
fi

echo "Kontrole:"
uruchom zasady ruby testy/sprawdz_zasady.rb
uruchom spis ruby testy/spis_tresci.rb --sprawdz
uruchom parametry ruby testy/lista_parametrow.rb --sprawdz

echo "WSZYSTKIE ZESTAWY: FAILURES ${SUMA}"
[ "$SUMA" -eq 0 ]
