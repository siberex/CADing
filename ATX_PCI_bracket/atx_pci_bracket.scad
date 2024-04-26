$fn = 64;

include <omdl/omdl-base.scad>;
include <pci_bracket.scad>;


short_form = false;

holes_diameter = 2.8;

holes_dy = 7.3;
holes_dx1 = short_form ? 15 : 35;
holes_dx2 = holes_dx1 + 40;

    
difference() {
    pci_slot_bracket(
        form = short_form ? 1 : 0,
        fins=3,
        ribs=[3, 0],
        tabs=[
            [holes_dx1, holes_dy, holes_diameter], 
            [holes_dx2, holes_dy, holes_diameter]
        ]
    );
    
    translate([1, 14/2 + 1.7, short_form ? 44.2 : 65])
        rotate([90, 0, 90])
            rounded_cube(width = 14, height = 16.5, depth = 5, radius = 0.5);
}

module rounded_cube(width = 10, height = 10, depth = 10, radius = 2, center = true) {
    translate([0, 0, center ? -depth/2 : 0])
    linear_extrude(depth)
        offset(r = radius)
            square([width - 2*radius, height - 2*radius], center);
    
}
