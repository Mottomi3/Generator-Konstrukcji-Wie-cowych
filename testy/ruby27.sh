#!/bin/bash
# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/ruby27.sh
# Zadanie: testy rdzenia i warstwy SketchUpa na Ruby 2.7.8 – tej samej linii co Ruby w SketchUpie 2023 (2.7.7); gdy brak, buduje Ruby ze źródeł z GitHuba.
# Tematy: zgodność z Ruby SketchUpa, Ruby 2.7, budowa Ruby ze źródeł, testy na starszym Ruby
# Zależy od: git, gcc, make, autoconf, bison, ruby (jako baseruby przy budowie)
# Używają: testy/uruchom.sh (sam wykrywa /opt/ruby27), zamknięcie rundy
#
# Użycie: bash testy/ruby27.sh – ostatnia linia „RUBY 2.7: FAILURES n”. Budowa ok. 10 min (jednorazowo w sesji).

cd "$(dirname "$0")/.." || exit 1
R27=/opt/ruby27/bin/ruby
if [ ! -x "$R27" ]; then
  ZR=/tmp/ruby27src
  [ -d "$ZR" ] || git clone -q --depth 1 --branch v2_7_8 https://github.com/ruby/ruby.git "$ZR" || exit 1
  for f in config.guess config.sub; do
    src=$(ls /usr/share/autoconf/build-aux/$f /usr/share/misc/$f 2>/dev/null | head -1)
    cp "$src" "$ZR/tool/$f" && cp "$src" "$ZR/$f"
  done
  ( cd "$ZR" && autoconf && ./configure --prefix=/opt/ruby27 --disable-install-doc --disable-install-rdoc \
      --with-baseruby="$(command -v ruby)" --with-out-ext=openssl,readline,gdbm,dbm,fiddle,psych,win32ole,pty,syslog,nkf \
      --enable-shared=no CFLAGS="-O1 -w" && make -j2 && make install ) > /tmp/ruby27_build.log 2>&1
  # make install kończy się błędem przy gemach wymagających openssl – sam Ruby jest już zainstalowany.
  [ -x "$R27" ] || { echo "Nie udało się zbudować Ruby 2.7 – /tmp/ruby27_build.log"; echo "RUBY 2.7: FAILURES 1"; exit 1; }
fi
export AM_GW_CICHO=1
SUMA=0
for t in t_rdzen t_wegly t_szczyty t_polacie t_jednospadowy t_podloga t_zamek t_siatka t_widok t_zestawienie t_raport t_sciany_ust t_sketchup \
         t_dach_aplikacja; do
  n=$("$R27" -W0 -I testy/atrapa "testy/$t.rb" 2>&1 | grep -E "FAILURES: [0-9]+" | tail -1 | grep -oE "[0-9]+$")
  [ -z "$n" ] && n=1
  echo "  $t (Ruby $("$R27" -e 'print RUBY_VERSION')): FAILURES $n"
  SUMA=$((SUMA + n))
done
echo "RUBY 2.7: FAILURES $SUMA"
[ "$SUMA" -eq 0 ]
