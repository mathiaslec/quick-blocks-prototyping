////////////////////////////////////////////////////////////////////////////////
/* [Main parameters] */
laser_cut = true;
xside=50;
yside=50;
thickness=5;
grid_spacing=10;
hole_diam=3;

////////////////////////////////////////////////////////////////////////////////
/* [Change at your own risks] */
fillet_radius = 2.5;//grid_spacing/4;
xside_recalc = ceil(xside/grid_spacing)*grid_spacing;
yside_recalc = ceil(yside/grid_spacing)*grid_spacing;

col = floor(xside_recalc/grid_spacing);// Number of rows
row = floor(yside_recalc/grid_spacing);// Number of columms
 
module array(){ 
    for(i =[0:col-1])
        translate([i*grid_spacing,0,0])
        for(j=[0:row-1])
            translate([0,j*grid_spacing,0])
            cylinder(thickness+1,d=hole_diam,$fn=15); } 

module wasteboard(){
    difference(){
linear_extrude(height = thickness) {
        offset($fn=50, r = fillet_radius) {
            translate([0,0,0])
                square([xside_recalc-grid_spacing-fillet_radius*2,yside_recalc-grid_spacing-fillet_radius*2],center=false);}
           }
           translate([grid_spacing/2-fillet_radius,grid_spacing/2-fillet_radius,0])
                array();}
    }

//wasteboard();
if (laser_cut==true){projection(cut = true) wasteboard();} else {wasteboard();}