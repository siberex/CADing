$fa=1;
$fs=1;
$fn=64;

line1 = "+1 234 567-8900";
line2 = "+9 876 543-2156";

LengthFactor = 2.75; // increase this for longer names

base_height = 1.2; //set this to how thick you want the tag
//font_face = "Roboto Condensed:style=Bold";
font_face = "Fira Sans Condensed:style=SemiBold";
font_thickness = 0.6;


module roundedcube(xdim,ydim,zdim,rdim){

    translate([0,0,base_height/2]) cube([xdim-rdim*3,ydim,base_height],center=true);
    ydim2=ydim +1;
    zdim2=zdim+0.2;
    HoleRoundedDivisor = 1.1;
    
    difference() {
        hull() {
            translate([-xdim/2,ydim2/2,0])cylinder(r=rdim,h=zdim);
            translate([-xdim/2+rdim,ydim2/2,0])cylinder(r=rdim,h=zdim);
            translate([-xdim/2,-ydim2/2,0])cylinder(r=rdim,h=zdim);
            translate([-xdim/2+rdim,-ydim2/2,0])cylinder(r=rdim,h=zdim);
        }

        hull() {
            translate([-xdim/2+rdim/2,ydim2/2-rdim/2,0])cylinder(r=rdim/HoleRoundedDivisor,h=zdim2);
            translate([-xdim/2+rdim/2,-ydim2/2+rdim/2,0])cylinder(r=rdim/HoleRoundedDivisor,h=zdim2);
        }
    }

    difference() {
        hull() {
            translate([xdim/2,ydim2/2,0])cylinder(r=rdim,h=zdim);
            translate([xdim/2-rdim,ydim2/2,0])cylinder(r=rdim,h=zdim);
            translate([xdim/2,-ydim2/2,0])cylinder(r=rdim,h=zdim);
            translate([xdim/2-rdim,-ydim2/2,0])cylinder(r=rdim,h=zdim);
        }
        hull() {
            translate([xdim/2-rdim/2,-ydim2/2+rdim/2,0])cylinder(r=rdim/HoleRoundedDivisor,h=zdim2);
            translate([xdim/2-rdim/2,ydim2/2-rdim/2,0])cylinder(r=rdim/HoleRoundedDivisor,h=zdim2);
        }
    }
 
};

module textline(t,s,yp) {
    translate([0,yp,base_height])
        linear_extrude(height = font_thickness)
            text(t, s, font = str(font_face), $fn = 16, halign="center");
}


module model() {
    textline(line1, 4.7, 1.4); 
    textline(line2, 4.7, -5.6);
    roundedcube(LengthFactor*21,15,base_height,4);
}
model();

