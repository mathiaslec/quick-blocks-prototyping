/* [PCB selection - NOT WORKING YET] */
your_pcb="foo"; // [arduino_uno, arduino_mega, rp4]

////////////////////////////////////////////////////////////////////////////////
/* [Main parameters] */
grid_spacing = 10;

pcb_width=39.6;
pcb_depth = 31.5;
pcb_height = 1.65;

////////////////////////////////////////////////////////////////////////////////
/* [Secondary parameters] */
hole_diam = 3; // for screw
nut_min_diam = 5.4; // for nuts
tolerance = 0.2; //used fo 3D printing
min_border = 1.5; //minimal dist. from nut to the outter border of the board
pcb_offset = 1; //protruding border below the pcb

////////////////////////////////////////////////////////////////////////////////
/* [Change at your own risks] */
fillet_radius = 5;
nut_max_diam = nut_min_diam*2/sqrt(3);
board_height = 3;
board_width_min = ceil(pcb_width+(nut_max_diam+tolerance*2+min_border)*2+min_border*2);
board_width = ceil(board_width_min/grid_spacing)*grid_spacing-tolerance;
holes_dist_width_min = ceil(pcb_width+(nut_max_diam+tolerance*2)+min_border*2);
holes_dist_width = ceil(holes_dist_width_min/grid_spacing)*grid_spacing;
board_depth_min = ceil(pcb_depth+min_border*2);
board_depth = ceil(board_depth_min/grid_spacing)*grid_spacing-tolerance;
holes_dist_depth_min = floor(pcb_depth-(nut_max_diam+tolerance*2)/2-min_border*2);
holes_dist_depth = ceil(holes_dist_depth_min/grid_spacing)*grid_spacing;
tab_length = board_width/3;
L_tab_length = board_depth/3;
L_hook = 1;

////////////////////////////////////////////////////////////////////////////////
/*Code*/

// Module for symmetry
module mirror_copy(v = [1, 0, 0]) {
    children();
    mirror(v) children();}

// Board with holes
difference(){
    // Create the board
    linear_extrude(height = board_height) {
        difference() {
            offset($fn=50, r = fillet_radius) {
                square([board_width-fillet_radius*2,board_depth-fillet_radius*2],center=true);}
                square([pcb_width-pcb_offset*2,pcb_depth-pcb_offset*2],center=true);}}
                // holes
                mirror_copy([0, 1, 0])
                mirror_copy()
                translate([holes_dist_width/2,holes_dist_depth/2,0]){
                    cylinder($fn=50, h=board_height*2, r=hole_diam/2+tolerance);}
                    // nut holes
                    mirror_copy([0, 1, 0])
                    mirror_copy()
                    translate([holes_dist_width/2,holes_dist_depth/2,board_height/2]){
                        cylinder($fn=6, h=board_height*2, r=(nut_max_diam/2+tolerance));}}

//simple tabs
mirror_copy([0, 1, 0])
translate([-tab_length/2,pcb_depth/2+tolerance,board_height]){
cube([tab_length, min_border, pcb_height], center=false);}

//L tabs
mirror_copy([1, 0, 0])
translate([-pcb_width/2-tolerance-min_border,-L_tab_length/2,board_height]){
    cube([min_border, L_tab_length, pcb_height+tolerance*2]);
    translate([0,0,pcb_height+tolerance*2]){
        cube([min_border+L_hook, L_tab_length, 2]);}}
// THE END
 