# ArteMadera – Generator Wieńcowy – testy
# Plik: testy/podglad.py
# Zadanie: rysunek 3D domu z pliku OBJ (testy/podglad.rb) – cały dom i zbliżenie narożnika, do sprawdzenia wzrokowego.
# Tematy: podgląd 3D, rysunek domu, zbliżenie zamka
# Zależy od: testy/podglad.rb, matplotlib
# Używają: ręcznie (python3 testy/podglad.py dom.obj wynik.png)
import sys

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

KOLORY = {"zewnetrzna": "#c79a64", "dzialowa": "#a8794a", "kontrfor": "#e0b77a", "szczyt": "#d9b48a",
          "dach": "#7a8fa6", "podloga": "#8a9a5b"}


def wczytaj(plik):
    v, grupy, g = [], [], None
    for linia in open(plik, encoding="utf-8"):
        cz = linia.split()
        if not cz:
            continue
        if cz[0] == "v":
            v.append(tuple(float(x) for x in cz[1:4]))
        elif cz[0] == "g":
            g = [cz[1], []]
            grupy.append(g)
        elif cz[0] == "f":
            g[1].append([v[int(i) - 1] for i in cz[1:]])
    return grupy


def rysuj(ax, grupy, filtr=None):
    for nazwa, sciany in grupy:
        rodzaj = nazwa.split("_")[-1]
        polys = [s for s in sciany if filtr is None or all(filtr(p) for p in s)]
        if not polys:
            continue
        pc = Poly3DCollection(polys, facecolor=KOLORY.get(rodzaj, "#c79a64"), edgecolor="#3b2a18", linewidths=0.15)
        ax.add_collection3d(pc)


def main():
    plik, wynik = sys.argv[1], sys.argv[2]
    zblizenie = sys.argv[3] if len(sys.argv) > 3 else "naroznik"
    grupy = wczytaj(plik)
    xs = [p[0] for _, s in grupy for f in s for p in f]
    ys = [p[1] for _, s in grupy for f in s for p in f]
    zs = [p[2] for _, s in grupy for f in s for p in f]
    fig = plt.figure(figsize=(14, 7))
    ax = fig.add_subplot(1, 2, 1, projection="3d")
    rysuj(ax, grupy)
    ax.set_xlim(min(xs), max(xs)); ax.set_ylim(min(ys), max(ys)); ax.set_zlim(min(zs), max(zs))
    ax.set_box_aspect((max(xs) - min(xs), max(ys) - min(ys), max(zs) - min(zs)))
    ax.view_init(elev=24, azim=-58)
    ax.set_axis_off()
    ax.set_title("Dom testowy")
    ax2 = fig.add_subplot(1, 2, 2, projection="3d")
    x0, y0 = min(xs), min(ys)
    if zblizenie == "szczyt":
        x0 = min(x for _, s in grupy for f in s for x, y, z in f if z > -1)
        y0 = min(y for _, s in grupy for f in s for x, y, z in f if z > -1)
        r, z0, z1 = 1300.0, 1700.0, 3000.0
        rysuj(ax2, grupy, lambda p: x0 - 50 < p[0] < x0 + r and y0 - 50 < p[1] < y0 + r and z0 < p[2] < z1)
        ax2.set_xlim(x0, x0 + r); ax2.set_ylim(y0, y0 + r); ax2.set_zlim(z0, z1)
        ax2.set_box_aspect((1, 1, (z1 - z0) / r))
        ax2.view_init(elev=18, azim=-60)
        ax2.set_title("Narożnik szczytu – płatew ścienna i gniazda")
    else:
        r = 420.0
        rysuj(ax2, grupy, lambda p: p[0] < x0 + r and p[1] < y0 + r and p[2] < 650)
        ax2.set_xlim(x0, x0 + r); ax2.set_ylim(y0, y0 + r); ax2.set_zlim(0, 650)
        ax2.set_box_aspect((1, 1, 650 / r))
        ax2.view_init(elev=20, azim=-125)
        ax2.set_title("Narożnik – zamek z ostatkami 100")
    ax2.set_axis_off()
    plt.tight_layout()
    plt.savefig(wynik, dpi=110)


if __name__ == "__main__":
    main()
