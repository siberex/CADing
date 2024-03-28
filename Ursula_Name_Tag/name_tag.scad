$fa=1;
$fs=1;
$fn=64;

line1 = "+1 234 567-8900";
line2 = "+9 876 543-2156";

LengthFactor = 2.75; // increase this for longer names

base_height = 1.2; //set this to how thick you want the tag
//font_face = "Roboto Condensed:style=Bold";
font_face = "Fira Sans Condensed:style=SemiBold";
font_size = 4.7;
font_thickness = 0.6;


ear_hole_corner_radius = 3;
ear_width = 4;
ear_height = 16;
ear_thickness = 2.8;


module ear(x = 0, y = 0) {
    rect = [ear_width - ear_hole_corner_radius, ear_height - ear_hole_corner_radius];
    //#color("red") translate([x / 2, y, 0]) square(rect, center = true);
    
    translate([x / 2, y, 0])
        linear_extrude(base_height)
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
    dx = width - ear_width;
    ear_dx = ear_width + ear_thickness;

    union() {
        translate([0, 0, base_height / 2])
            cube([width - ear_dx * 2, height, base_height], center = true);        
        ear(dx);
        ear(-dx);
    }
};

module textline(line, size, y_pos) {
    translate([0, y_pos, base_height])
        linear_extrude(height = font_thickness)
            text(line, size, font = str(font_face), $fn = 16, halign="center", spacing = 1);
}


module model() {
    union() {
        textline(line1, font_size, 1.4); 
        textline(line2, font_size, -5.6);
        base(LengthFactor * 21, 15);
    }
}
model();
