$fa = 1; $fs = 1;
$fn = $preview ? 32 : 64;

// https://github.com/adrianschlatter/threadlib?tab=readme-ov-file#installation
use <threadlib/threadlib.scad>

// Tripod screw, 1/4-20 UNC
profile = "UNC-1/4-ext";    
specs = thread_specs(profile);

P = specs[0];
Dsupport = specs[2]; // screw base cilinder diameter

cut_hook = true; // false = make ring

ring_thickness = Dsupport; // render as thick as the screw stem (=4.9052)
ring_inner_diameter = 14;

ring_inner_radius = ring_inner_diameter / 2;
extrusion_circle_radius = ring_thickness / 2;
ring_outer_radius = ring_inner_radius + extrusion_circle_radius;

module ring() {
    fn = 6;
    // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects
    fudge = 1/cos(180/fn);
    
    rotate([0, 0, cut_hook ? 9 : 0])
        rotate_extrude(angle = cut_hook ? 275 : 360)
            translate([ring_outer_radius, 0, 0])
                circle(r = extrusion_circle_radius * fudge, $fn = fn);
}

module screw_cilinder(turns = 5, extra_length = 2) {
    H = (turns + 1) * P + extra_length;

    translate([0, 0, extra_length])
        union() {
            rotate([0, 0, 180]) // to orient threads better
                thread(profile, turns=turns, higbee_arc=50);
            translate([0, 0, -P / 2 - extra_length])
                cylinder(h=H, d=Dsupport, $fn=120);
        };
}

module model()
    union() {
        translate([0, extrusion_circle_radius + ring_outer_radius, 0])
            ring();

        rotate ([90, 0, 0])
            translate([0, 0, -1])
                screw_cilinder();
    }


module cut_for_surface_table() {
    cut_height = 2; // just to be sure, thread groove size will suffice though

    difference()
    {
        translate([0, 0, ring_thickness / 2]) // correct z-axis to place model at 0
                model();

        if (cut_hook) {
            #translate([ring_outer_radius, ring_outer_radius / 2 + 2, ring_thickness / 2])
                cube([ring_inner_diameter, ring_inner_diameter, ring_thickness + 1], center = true);
        }

        #translate([0, 0, -cut_height])    
            linear_extrude(height = cut_height)
                offset(1) // extend shadow perimeter
                projection(cut=false)
                    model();
    }

}


cut_for_surface_table();