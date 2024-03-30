$fa = 1; $fs = 1;
$fn = $preview ? 32 : 64;

// https://github.com/adrianschlatter/threadlib?tab=readme-ov-file#installation
use <threadlib/threadlib.scad>

ring_thickness = 5;
ring_inner_diameter = 14;

ring_inner_radius = ring_inner_diameter / 2;
extrusion_circle_radius = ring_thickness / 2;
ring_outer_radius = ring_inner_radius + extrusion_circle_radius;

module ring() {
    fn = 6;
    // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects
    fudge = 1/cos(180/fn);
    
    rotate_extrude($fn = 100)
    translate([ring_outer_radius, 0, 0])
    circle(r = extrusion_circle_radius * fudge, $fn = fn);
}

module screw_cilinder(turns = 5, extra_length = 2) {
    // Tripod screw, 1/4-20 UNC
    profile = "UNC-1/4-ext";    
    specs = thread_specs(profile);
    
    translate([0, 0, extra_length])
    union() {
        P = specs[0];
        Dsupport = specs[2];
        H = (turns + 1) * P + extra_length;
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

translate([0, 0, -ring_thickness/2])
difference()
{
    model();
    translate([0, 0, ring_thickness / 2])
        linear_extrude(height=1)
            projection(cut=false)
                model();
}
