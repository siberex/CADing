$fa = 1; $fs = 1;
$fn = $preview ? 32 : 64;

use <./fonts/FiraSansCondensed-SemiBold.ttf>
use <./fonts/RobotoCondensed-VariableFont_wght.ttf>

// Configurable >>>
$line1 = "Sib.Li";
$line2 = "+1 234 567-8900";
include <./.data.scad>;

scale_factor = 2.75;
base_width = scale_factor * 21; // approx. tag width
base_height = scale_factor * 5.45; // height of the bone middle part
base_thickness = 1.2; // set this to how thick you want the tag
//font_face = "Roboto Condensed:style=Bold";
font_face = "Fira Sans Condensed:style=SemiBold";

font_size = scale_factor * 1.7;
font_thickness = 0.6;
ear_thickness = 2.8;
// <<< End of configurable


ear_hole_corner_radius = 3;
ear_offset = 4; // should be more than ear_hole_corner_radius
ear_relaive_height = base_height + 1;


module ear(x = 0, y = 0) {
    rect = [ear_offset - ear_hole_corner_radius, ear_relaive_height - ear_hole_corner_radius];
    //#color("red") translate([x / 2, y, 0]) square(rect, center = true);
    
    translate([x / 2, y, 0])
        linear_extrude(base_thickness)
            difference() {
                offset(r = ear_hole_corner_radius + ear_thickness) {
                    square(rect, center = true);
                }
                offset(r = ear_hole_corner_radius) {
                    square(rect, center = true);
                }
            }
}

module base(width, height) {
    dx = width - ear_offset;
    ear_dx = ear_offset + ear_thickness;
    
    union() {
        translate([0, 0, base_thickness / 2])
            cube([width - ear_dx * 2, height, base_thickness], center = true);        
        ear(dx);
        ear(-dx);
    }
};

module textline(line, y_pos, length) {
    ear_dx = ear_offset + ear_thickness;
    text_padding = 0;
    fit_length = length - ear_dx * 2 - ear_hole_corner_radius - text_padding * 2;
    
    color("gray")
    translate([0, y_pos, base_thickness])
        linear_extrude(height = font_thickness)
            //// ↓ Uncomment to auto-size text lines ↓ ////
            //resize([fit_length, 0], auto = true)
                text(
                    line, 
                    size = font_size, font = str(font_face),
                    halign = "center", 
                    valign = "center",
                    spacing = 1
                );
}


module model() {
    union() {
        textline($line1, base_height / 4, base_width); 
        textline($line2, -base_height / 4, base_width);
        base(base_width, base_height);
    }
}
model();
