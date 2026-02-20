// ===== Paramètres utilisateur =====
x_init_input = 109;           // Largeur initiale initiale (zone intérieure)
y_init_input = 52;           // Hauteur initiale
x1_input = 98;                // Espacement trous intérieurs X
y1_input = 33;               // Espacement trous intérieurs Y
diametre_trou = 3.5;      // Diamètre trous intérieurs traversants
diametre_lamage = 5.9;   // Diamètre lamage
profondeur_lamage = 3.5;  // Profondeur lamage
r = 5;                  // Rayon coins plaque
epaisseur = 5;          // Épaisseur plaque
bord_min = 2;           // Bord minimum autour des trous lamage et extérieurs
grid_spacing = 10;      // Module pour arrondi (ici 10 mm)
r2 = 1.5;                 // Rayon trous extérieurs
nut_min_diam = 5.5; // for nuts
tol = 0.2; 
nut_max_diam = (nut_min_diam+tol*2) * 2 / sqrt(3);        //
ep_nut = 2.4;             // tolerance
change_dimensions = false;

// ===== Fonctions arrondi =====
function arrondi_haut(val, grid) = ceil(val / grid) * grid;
function arrondi_bas(val, grid) = floor(val / grid) * grid;

x_init = change_dimensions ? y_init_input : x_init_input ;
y_init = change_dimensions ? x_init_input : y_init_input ;
x1 = change_dimensions ? y1_input : x1_input ;
y1 = change_dimensions ? x1_input : y1_input ;

// ===== Calculs pour trous extérieurs =====
// Distance brute entre trous extérieurs sur X
x_trou_ext_brut = x_init + 2 * r2;
// Arrondi supérieur multiple de 10
x_trou_ext = arrondi_haut(x_trou_ext_brut, grid_spacing);
y_trou_ext = arrondi_bas(y_init, grid_spacing);

// Largeur plaque = distance trous extérieurs + 1/2 multiple (bord après trous)
x = x_trou_ext + grid_spacing - tol*2;
y = y_trou_ext + grid_spacing - tol*2;

// Diamètre trous extérieurs
diametre_trou_ext = (2 * r2);

// ===== Modules =====
module plaque_arrondie(x, y, r, h) {
    linear_extrude(height = h)
        offset(r = r)
            offset(delta = -r)
                square([x, y], center = false);
}

module trous_interieurs(x1, y1, d_trou, d_lamage, h_lamage, epaisseur) {
    translate([x/2, y/2, 0]) {
        for (dx = [-x1/2, x1/2])
            for (dy = [-y1/2, y1/2]) {
                translate([dx, dy, 0]) {
                    cylinder(h = h_lamage, d = d_lamage, $fn=50);
                    translate([0, 0, -1])
                        cylinder(h = epaisseur + 2, d = d_trou, $fn=50);
                }
            }
    }
}

module trous_exterieurs(x_trou_ext, y_trou_ext, d, epaisseur, fragments) {
    translate([x/2, y/2, 0]) {
        for (dx = [-x_trou_ext/2, x_trou_ext/2])
            for (dy = [-y_trou_ext/2, y_trou_ext/2])
                translate([dx, dy, -1])
                    cylinder(h = epaisseur + 2, d = d, $fn=fragments);
    }
}

// ===== Sortie console =====
echo("Distance trous extérieurs x_trou_ext =", x_trou_ext);
echo("Largeur finale plaque X =", x);
echo("Distance trous extérieurs y_trou_ext =", y_trou_ext);
echo("Hauteur finale plaque Y =", y);
echo("diametre_trou_ext =", diametre_trou_ext);

// ===== Génération =====

difference() {
    plaque_arrondie(x, y, r, epaisseur);
    trous_interieurs(x1, y1, diametre_trou, diametre_lamage, profondeur_lamage, epaisseur);
    trous_exterieurs(x_trou_ext, y_trou_ext, (diametre_trou_ext+tol*2), epaisseur, fragments=50);
    translate([0,0,epaisseur-ep_nut]){
        trous_exterieurs(x_trou_ext, y_trou_ext, d=(nut_max_diam), epaisseur=3, fragments=6);}
} 
