// https://github.com/adrianschlatter/threadlib?tab=readme-ov-file#installation
use <threadlib/threadlib.scad>

ring_thickness = 6;
ring_inner_diameter = 14;

ring_inner_radius = ring_inner_diameter / 2;
extrusion_circle_radius = ring_thickness / 2;
ring_outer_radius = ring_inner_radius + extrusion_circle_radius;

module ring() {
    rotate_extrude($fn = 100)
    translate([ring_outer_radius, 0, 0])
    circle(r = extrusion_circle_radius, $fn = 120);
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
};

union() {
    translate([0, extrusion_circle_radius + ring_outer_radius, 0])
 	ring();
    
 	rotate ([90, 0, 0])
    translate([0, 0, -1])
    screw_cilinder();
}

// References:
// Test screw excessive length = 5.4 - 4.1 = 1.3mm
// Test screw total stem length = 9.2mm
// screw_target_depth = 9.2 - 1.3 = 7.9mm
